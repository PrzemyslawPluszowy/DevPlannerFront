# DevPlanner Desktop — plan domknięcia logowania, sesji i Keychain

Status: **PLAN, NIE IMPLEMENTACJA**  
Data audytu: **2026-09-19**  
Repozytoria objęte planem:

- `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`
- `/Users/przemyslawnowak/Desktop/dev/DevNote/Backend`

Ten dokument jest instrukcją wykonawczą. Agent realizujący plan ma wykonywać
pakiety po kolei. Nie wolno łączyć pakietów, rozszerzać zakresu „przy okazji”
ani oznaczać pakietu jako ukończony bez wszystkich jego bramek.

## 1. Cel i wynik końcowy

Po wykonaniu planu aplikacja desktopowa ma:

1. logować przez systemową przeglądarkę i Authorization Code + PKCE `S256`;
2. trzymać access token wyłącznie w pamięci procesu;
3. trzymać refresh token wyłącznie w magazynie systemowym;
4. automatycznie odświeżać access token przed wygaśnięciem i po pojedynczym
   autoryzacyjnym `401`;
5. wykonywać najwyżej jeden refresh równocześnie, niezależnie od liczby żądań;
6. nigdy nie wysyłać refresh tokena jako Bearer do API lub SignalR;
7. rotować refresh token bez okna, w którym awaria `/me` niszczy sesję;
8. kończyć sesję lokalną po `invalid_grant`, reuse, revoke lub zmianie stanu
   konta, ale zachowywać credential przy zwykłej awarii sieci/TLS/5xx;
9. respektować revoke w REST i SignalR;
10. nie pokazywać powtarzalnych promptów Keychain po hot restart/rebuildzie;
11. mieć przenośny podpis developerski i osobny, jawny proces podpisu Release;
12. posiadać automatyczne testy protokołu oraz ręczny E2E na realnym macOS.

## 2. Stan wejściowy — nie wolno go błędnie interpretować

### 2.1. Elementy poprawne i chronione przed regresją

- Backend rejestruje publicznego klienta `devplanner-desktop` bez sekretu.
- Authorization Code i refresh grant są aktywne.
- PKCE jest wymagane globalnie, wyłącznie metodą `S256`.
- Callback desktopowy jest ograniczony do loopback i portów `49152..65535`.
- Front otwiera systemową przeglądarkę, generuje losowe `state` oraz verifier.
- Access token jest obecnie w pamięci transportu.
- Refresh token jest zapisany przez `flutter_secure_storage`.
- Backend rotuje refresh token i wykrywa reuse całej rodziny.
- Logout wywołuje endpoint revocation i zawsze czyści lokalny vault.
- Debug/Profile macOS mają obecnie stabilny podpis lokalnym certyfikatem i
  rzeczywisty smoke test nie wyświetlił ponownego promptu Keychain.

Agent nie może usuwać PKCE, włączać implicit/password grant, dodawać client
secretu do desktopu, zapisywać tokenów w Hive/preferences/pliku ani przenosić
logowania do WebView.

### 2.2. Potwierdzone luki

#### P0 — brak runtime refresh i retry po 401

`DevPlannerHttpTransport` dołącza bieżący access token, ale odpowiedź `401`
zwraca wyżej bez odświeżenia tokena. Refresh występuje tylko podczas bootstrapu.
Po wygaśnięciu access tokena działająca aplikacja traci API do restartu.

#### P0 — możliwość użycia refresh tokena jako Bearer

Gdy `DevPlannerHttpTransport` nie otrzyma `_tokenProvider`, fallback odczytuje
`PlatformSecureRefreshTokenVault`. Vault przechowuje refresh token, nie access
token. Aktualny bootstrap podaje provider i omija błąd, ale publiczny kontrakt
transportu pozwala przyszłemu callerowi wysłać refresh token do API.

#### P0 — utrata zrotowanego tokena po udanym grant i błędzie `/me`

Transport otrzymuje nowy refresh token, następnie pobiera `/api/v1/me/`, a
dopiero adapter zapisuje nowy token do vaulta. Jeśli `/me` lub sieć zawiedzie
po rotacji, vault pozostaje ze zużytym tokenem. Następny start może uruchomić
reuse detection i unieważnić rodzinę.

#### P1 — refresh nie jest single-flight

Brak jednego koordynatora dla REST, generated Dio i SignalR. Dodanie prostego
interceptora bez koordynatora spowoduje równoległe użycie jednego refresh
tokenu; backend prawidłowo uzna drugie użycie za reuse i unieważni sesję.

#### P1 — połowiczny kontrakt OIDC

Klient żąda `openid profile`, wysyła `nonce`, ale nie odczytuje i nie waliduje
ID tokena. Autorytatywną tożsamość i tak pobiera z `/api/v1/me/`. Nie wolno
pozostawić kontraktu w stanie „nonce wysłany, lecz niesprawdzony”.

#### P1 — revoke nie ma pełnego dowodu dla access tokena i SignalR

Refresh lifecycle jest mocny, ale trzeba udowodnić, że zrevokowana sesja nie
może używać już wydanego access tokena oraz nie pozostaje na aktywnym
połączeniu SignalR. Sam zakaz kolejnego refreshu nie wystarcza.

#### P1 — podpis macOS nie jest przenośny ani dystrybucyjny

`project.pbxproj` zawiera osobisty common name certyfikatu. Działa na obecnym
Macu, ale nie na innym komputerze ani CI. Release pozostaje ad-hoc i nie jest
procesem dystrybucyjnym.

#### P2 — odporność callbacku i sieci

- listener pobiera tylko `server.first`; przypadkowe żądanie może zakończyć
  oczekiwanie przed właściwym callbackiem;
- transport tokenowy nie ma jawnych timeoutów;
- każde HTTP 400/401 podczas refreshu jest traktowane jak credential do
  usunięcia, zamiast sprawdzenia `error=invalid_grant`;
- przeglądarka nie dostaje poprawnej odpowiedzi dla wszystkich ścieżek błędu.

## 3. Nienaruszalne reguły implementacji

1. Jedynym kanonicznym identyfikatorem użytkownika jest lokalny UUID `UserId`;
   OIDC `sub` ma tę samą wartość.
2. Presentation nie może zobaczyć access ani refresh tokena.
3. Foundation HTTP nie może importować konkretnego adaptera auth ani vaulta.
   Dostaje mały port/callback w composition root.
4. Vault przechowuje wyłącznie refresh token. Access token, czas wygaśnięcia
   i trwający `Future` refreshu są wyłącznie w pamięci.
5. Refresh token nigdy nie trafia do `Authorization`, logów, wyjątków,
   telemetry, `toString`, snapshotów testowych ani komunikatów UI.
6. Nie logować authorization code, verifiera, state, nonce, access tokena,
   refresh tokena, cookie ani pełnej odpowiedzi tokenowej.
7. Retry po 401 jest najwyżej jeden. Drugie 401 kończy request; nie uruchamia
   kolejnego refreshu.
8. Endpointy `/connect/token`, `/connect/revocation`, callback i login nie
   mogą korzystać z ogólnego interceptora retry API.
9. Równoległe żądania oczekują na ten sam `Future` refreshu. Nie wolno tworzyć
   kolejki, która kolejno użyje tego samego, już zużytego refresh tokena.
10. Logout wygrywa z każdym rozpoczętym wcześniej refreshem. Spóźniona
    odpowiedź nie może przywrócić tokena ani stanu signed-in.
11. Nie wolno ręcznie implementować kryptografii JWT/OIDC.
12. Nie edytować historycznych migracji EF. Nowa migracja tylko wtedy, gdy
    faktycznie zmienia się schemat.
13. Nie zmieniać Web BFF. Desktop Bearer i Web cookie pozostają osobnymi
    composition roots.
14. Nie commitować ani pushować bez polecenia użytkownika.

## 4. Docelowy przepływ

### 4.1. Logowanie interaktywne

1. Klient wiąże listener wyłącznie do loopback.
2. Generuje `state`, verifier oraz challenge `S256`.
3. Otwiera `/connect/authorize` w systemowej przeglądarce.
4. Listener ignoruje obce ścieżki i kontynuuje oczekiwanie na `/callback`.
5. Callback sprawdza loopback peer, ścieżkę, `state`, `error` i `code`.
6. Authorization code jest wymieniany dokładnie raz.
7. Po odpowiedzi tokenowej nowy refresh token jest najpierw trwale zapisany.
8. Dopiero potem access token służy do pobrania `/api/v1/me/`.
9. Jeśli `/me` ma przejściowy błąd, nowy refresh token zostaje zachowany;
   aplikacja nie publikuje signed-in, ale kolejny restore może odzyskać sesję.
10. Po poprawnym `/me` publikowany jest signed-in.

### 4.2. Start aplikacji

1. Vault jest odczytywany raz przez koordynator.
2. Brak credentialu oznacza signed-out bez requestu.
3. Credential jest używany do jednego refresh grant.
4. Nowy refresh token jest zapisany przed `/me`.
5. `invalid_grant` usuwa vault i kończy signed-out.
6. Timeout/TLS/offline/5xx nie usuwa vaulta; UI pokazuje błąd przywrócenia.

### 4.3. Zwykłe żądanie REST

1. Provider zwraca ważny access token.
2. Jeśli token wygasa w krótkim oknie bezpieczeństwa, koordynator wykonuje
   single-flight refresh przed wysłaniem requestu.
3. Gdy API zwróci autoryzacyjne 401, transport przekazuje koordynatorowi token,
   którego użył request.
4. Jeśli inny request zdążył już zmienić token, request ponawia się z nowym
   tokenem bez drugiego refreshu.
5. W przeciwnym razie wszystkie requesty oczekują na jeden refresh.
6. Request jest ponawiany dokładnie raz i oznaczony flagą w `RequestOptions`.
7. Drugie 401 przechodzi do warstwy błędu i może zakończyć sesję zgodnie z
   wynikiem koordynatora; nie ma pętli.

### 4.4. SignalR

`accessTokenFactory` pobiera token z tego samego koordynatora co REST. Nie
czyta vaulta. Przy reconnect może odświeżyć token single-flight. Revoke danej
sesji kończy dokładnie jej połączenia, bez wylogowania innych urządzeń tego
samego użytkownika.

### 4.5. Logout

1. Koordynator zwiększa numer generacji sesji i czyści access token w pamięci.
2. Odczytuje refresh token i próbuje standardowego revocation.
3. Niezależnie od wyniku zdalnego revoke czyści lokalny vault.
4. Każdy spóźniony login/refresh z poprzedniej generacji jest ignorowany;
   otrzymany refresh token jest best-effort revokowany i nie jest zapisywany.
5. Stan UI przechodzi do signed-out.

## 5. Pakiety wykonawcze

### A0 — zamrożenie baseline i charakterystyczne testy czerwone

Cel: udokumentować usterki przed zmianą kodu.

Dozwolone pliki:

- nowe testy pod `Front/test/auth/` i `Front/test/foundation/http/`;
- nowe/rozszerzone testy Backend Identity;
- dokumentacja pakietu.

Kroki:

- zapisać `git status --short` w obu repozytoriach i nie dotykać zmian obcych;
- uruchomić obecne `test/auth` jako baseline;
- dodać czerwony test: access token wygasa podczas działania aplikacji;
- dodać czerwony test: 20 równoległych requestów 401 powoduje jeden refresh;
- dodać czerwony test: po refresh 20 requestów ponawia się po jednym razie;
- dodać czerwony test: drugie 401 nie tworzy pętli;
- dodać czerwony test: fallback transportu nie może odczytać refresh vaulta;
- dodać czerwony test: udana rotacja + błąd `/me` zachowuje nowy token;
- dodać czerwony test: logout podczas refreshu nie wskrzesza sesji;
- dodać czerwony test: `invalid_grant` czyści vault, 5xx/offline go zachowuje;
- dodać czerwony test: SignalR i REST współdzielą jeden refresh;
- na Backend dodać test pokazujący aktualne zachowanie access tokena po revoke;
- testy czerwone mają failować z oczekiwanego powodu, nie przez compile error.

STOP:

- jeśli test wymaga zmiany publicznego API, najpierw opisać wymagany kontrakt;
- jeśli istniejące testy auth są czerwone przed zmianą, nie implementować A1.

Gate A0:

- dotychczasowe testy auth są zielone;
- nowe testy charakterystyczne są czerwone i mają opis przyczyny;
- brak zmian produkcyjnych.

### A1 — rozdzielenie odpowiedzi tokenowej od pobrania profilu

Status: **DONE (2026-09-19)** — odpowiedź tokenowa jest oddzielona od `/me`,
zrotowany refresh token jest zapisywany przed profilem, a awaria vaulta powoduje
best-effort revocation nowo wydanego credentialu.

Cel: usunąć okno utraty zrotowanego refresh tokena.

Pliki główne:

- `Front/lib/auth/data/adapters/desktop_pkce_session_transport*.dart`;
- `Front/lib/auth/data/adapters/desktop_pkce_auth_adapter.dart`;
- `Front/lib/auth/data/auth_composition.dart`;
- testy `Front/test/auth/`.

Wymagany kontrakt:

- transport token endpoint zwraca mały wynik zawierający access token, refresh
  token, `expires_in` i ewentualny token type;
- pobranie `/me` jest osobną metodą używającą access tokena;
- adapter/koordynator zapisuje zrotowany refresh token przed `/me`;
- `expires_in` jest walidowane: dodatnia liczba w rozsądnym zakresie;
- brak access/refresh tokena jest błędem protokołu;
- wynik ani wyjątek nie może wypisać wartości tokenów.

Testy obowiązkowe:

- zapis nowego refresh tokena występuje przed wywołaniem `/me`;
- błąd zapisu vaulta nie publikuje signed-in;
- po błędzie zapisu nowy credential jest best-effort revokowany;
- błąd `/me` po zapisie zachowuje nowy credential;
- błędna odpowiedź tokenowa nie nadpisuje poprzedniego vaulta;
- login i restore używają tego samego bezpiecznego porządku operacji.

Zakazy:

- nie dodawać jeszcze interceptora 401;
- nie przenosić access tokena do vaulta;
- nie wykonywać `/me` przy każdym przyszłym runtime refreshu.

Gate A1: targeted auth tests, scoped analyzer, `git diff --check`.

### A2 — jeden desktopowy koordynator tokenów i single-flight refresh

Cel: jedno źródło prawdy dla access tokena, expiry, rotacji i logout race.

Utworzyć mały, niewidoczny dla presentation port, np. kontrakt o możliwościach:

- `currentAccessToken()`;
- `validAccessToken()` — może odświeżyć przed expiry;
- `recoverAfterUnauthorized(failedAccessToken)`;
- `clearSession()`/logout lifecycle.

Nazwa może być dopasowana do konwencji projektu, ale odpowiedzialność nie może
zostać rozbita między HTTP, SignalR i bootstrap.

Wymagania implementacyjne:

- przechowywać `accessToken` oraz absolutny czas wygaśnięcia w pamięci;
- czas liczyć przez wstrzykiwany `Clock`/`TimeProvider` testowy, nie przez
  rozsiane `DateTime.now()`;
- użyć okna odświeżenia 60 sekund, ale dla tokenów krótszych od 120 sekund
  ograniczyć je tak, aby token nie był natychmiast zawsze „stary”;
- pole `_refreshInFlight` wskazuje jeden współdzielony `Future`;
- wyzerować `_refreshInFlight` w `finally`;
- cała rotacja obejmuje request, zapis nowego refresh tokena i publikację
  access tokena; czekający nie mogą ruszyć między tymi krokami;
- numer generacji sesji zabezpiecza login/refresh kontra logout;
- `invalid_grant` czyści access token i vault oraz zgłasza trwałe wygaśnięcie;
- offline/TLS/timeout/5xx czyści access token tylko wtedy, gdy jest nieważny,
  ale nie usuwa refresh credentialu;
- refresh runtime nie wywołuje `/me`;
- żadna publiczna metoda nie zwraca refresh tokena.

Testy obowiązkowe:

- 1, 2, 20 i 100 równoległych callerów = dokładnie jeden token request;
- wszyscy callerzy dostają ten sam nowy access token;
- refresh failure trafia do wszystkich callerów bez deadlocka;
- kolejna próba po przejściowym failure może uruchomić nowy refresh;
- logout w każdej fazie request/write/publish nie odtwarza sesji;
- dwa kolejne prawidłowe refresh cykle używają kolejnych tokenów rotacji;
- zegar na granicy expiry nie powoduje refresh storm;
- brak credentialu kończy się jednoznacznym wynikiem, nie wyjątkiem null.

Gate A2: testy koordynatora 100% scenariuszy powyżej, analyzer, diff check.

### A3 — bezpieczny REST retry

Cel: podłączyć koordynator do całego desktopowego HTTP.

Pliki główne:

- `Front/lib/foundation/http/devplanner_http_transport.dart`;
- `Front/lib/bootstrap/app_bootstrap.dart`;
- wygenerowane klienty tylko jeżeli wymaga tego ich wspólny Dio;
- testy transportu.

Zmiany:

- usunąć import i fallback do `PlatformSecureRefreshTokenVault` z transportu;
- bez `tokenProvider` desktopowy transport nie dodaje Authorization i failuje
  w composition/testach wymagających standalone API;
- bootstrap podaje provider access tokena i callback odzyskania po 401;
- zarówno `execute`, jak i `apiDio` używane przez typed/generowane klienty
  przechodzą przez ten sam mechanizm;
- zapisać token użyty w request w `RequestOptions.extra`, bez jego wartości w
  logach;
- dodać flagę liczby prób auth; dopuszczalna wartość to 0 albo 1;
- po 401 porównać failed token z bieżącym tokenem koordynatora;
- ponawiać request z odtworzonym body. Dla `FormData`/uploadu nie używać
  zużytego streamu; utworzyć nowe dane z oryginalnych bajtów albo jawnie
  oznaczyć request jako niereplayowalny i nie ponawiać go automatycznie;
- nie retryować 400, 403, 404, 409, 422, 429 ani 5xx;
- nie retryować requestu po drugim 401.

Testy obowiązkowe:

- `execute` i bezpośredni typed `apiDio` mają identyczne zachowanie;
- GET, JSON POST, DELETE i upload mają jawnie potwierdzoną politykę retry;
- 401 po zmianie tokena nie robi zbędnego refreshu;
- 20 równoległych 401 = jeden refresh i 20 pojedynczych retry;
- refresh `invalid_grant` przełącza sesję signed-out;
- błąd sieci refreshu nie udaje błędu credentials;
- refresh token nigdy nie pojawia się w nagłówku API;
- Web BFF nigdy nie uruchamia desktopowego refreshu.

Gate A3: targeted HTTP/auth suite, `flutter analyze`, `git diff --check`.

### A4 — SignalR korzystający z tego samego lifecycle

Cel: usunąć osobny, pasywny provider starego access tokena.

Pliki główne:

- `Front/lib/workspaces/data/realtime/signalr/workspace_signalr_client.dart`;
- composition runtime SignalR;
- testy realtime/auth.

Zmiany:

- `accessTokenFactory` woła `validAccessToken()` koordynatora;
- reconnect używa aktualnego tokena i może dołączyć do single-flight refresh;
- błąd trwałego refreshu zatrzymuje reconnect loop i publikuje stan revoke;
- błąd przejściowy podlega ograniczonemu backoffowi istniejącego klienta;
- logout zatrzymuje połączenie przed wyczyszczeniem sesyjnego UI;
- nie tworzyć drugiego mutexa ani cache tokena w kliencie SignalR.

Testy obowiązkowe:

- REST i SignalR wywołane równocześnie powodują jeden refresh;
- reconnect po rotacji używa nowego tokena;
- logout podczas reconnectu nie tworzy nowego połączenia;
- `invalid_grant` kończy reconnect, a offline zachowuje możliwość retry;
- token nie jest logowany przez bibliotekę SignalR.

Gate A4: auth + realtime tests, analyzer, diff check.

### B1 — jawna polityka lifetime i walidacja sesji dla REST

Cel: access token ma jawny czas życia, a revoke sesji jest egzekwowany przez
Backend, nie tylko przez brak kolejnego refreshu.

Pliki główne:

- `Backend/Infrastructure/Identity/LocalOpenIddictServiceCollectionExtensions.cs`;
- nowy mały handler walidacji sesji w `Infrastructure/Identity`;
- `Application/Auth/Sessions/*` tylko przez istniejący port;
- testy OpenIddict/HTTP/revoke.

Decyzja planu:

- access token lifetime ustawić jawnie na **10 minut**;
- refresh token i device session pozostają **30 dni**, chyba że osobna decyzja
  produktowa zmieni oba kontrakty i testy jednocześnie.

Wymagania:

- każdy desktopowy access token zawiera `sub` i `devplanner_session_id`;
- walidacja API sprawdza istnienie sesji, właściciela, `RevokedAtUtc`, expiry,
  status i potwierdzenie konta oraz zgodność `SecurityVersion`;
- brak/malformed session claim w desktopowym bearerze kończy się 401;
- nie zwracać informacji, czy konto/sesja istnieje;
- najpierw poprawność. Nie dodawać cache, który opóźnia revoke. Optymalizacja
  wymaga osobnego pomiaru i jawnej maksymalnej zwłoki;
- BFF cookie pozostaje na swoim istniejącym walidatorze;
- handler nie może ufać samemu `sub` bez sprawdzenia powiązania sesji.

Testy obowiązkowe:

- aktywna sesja działa;
- revoke bieżącej sesji powoduje 401 dla starego access tokena;
- revoke innego urządzenia nie wylogowuje bieżącego;
- disabled/deleted/unconfirmed/security-version-changed = 401;
- sesja innego użytkownika podmieniona w claimie = 401;
- brak claimu i błędny UUID = 401;
- Web BFF nie dostaje regresji;
- lifetime access/refresh jest sprawdzony kontraktem.

Gate B1: backend build, targeted auth/revoke HTTP tests, format, diff check.

### B2 — revoke aktywnego SignalR

Cel: zrevokowana sesja urządzenia nie odbiera dalszych zdarzeń realtime.

Wymagania projektowe:

- połączenie rejestruje zweryfikowany `devplanner_session_id`, `userId` i
  `connectionId` po udanym auth;
- rejestr przechowuje możliwość przerwania dokładnego połączenia;
- revoke publikuje po commit zdarzenie z `sessionId`;
- każdy host odbiera zdarzenie i abortuje połączenia tej sesji;
- rozwiązanie musi działać przy co najmniej dwóch hostach i obecnym Redis;
- rozłączenie jednej sesji nie usuwa innych sesji użytkownika;
- OnDisconnected zawsze usuwa wpis, również po wyjątkach;
- dodatkowa walidacja na connect i przed operacją hubu pozostaje fail-closed.

Nie akceptować rozwiązania, które tylko wysyła klientowi komunikat „wyloguj
się”. Złośliwy klient nie może pozostać w grupach i odbierać zdarzeń.

Testy obowiązkowe:

- revoke rozłącza właściwe połączenie na jednym hoście;
- inne urządzenie tego użytkownika pozostaje połączone;
- połączenie innego użytkownika pozostaje połączone;
- test dwuhostowy z Redis rozłącza sesję na drugim hoście;
- reconnect starym access tokenem jest odrzucony;
- brak wycieku wpisów registry po normalnym i awaryjnym disconnect.

Gate B2: targeted SignalR one-host + two-host suite, build, format, diff check.

### C1 — zakończenie połowicznego OIDC

Decyzja planu: ponieważ aplikacja używa `/api/v1/me/` jako autorytatywnej
tożsamości i nie konsumuje ID tokena, obecny klient desktopowy ma zostać
uproszczony do OAuth Authorization Code + PKCE:

- scope: `offline_access devplanner.api`;
- usunąć `openid`, `profile` i `nonce` z requestu desktopowego;
- nie dodawać ręcznej walidacji JWT;
- backendowy klient nadal pozostaje publicznym native clientem;
- nazewnictwo dokumentacji ma mówić „OAuth Authorization Code + PKCE” dla
  klienta, a „OpenIddict authorization server” dla implementacji serwera.

Przed zmianą dodać integration test potwierdzający, że backend wydaje access i
refresh token bez scope `openid` oraz że `/api/v1/me/` działa. Jeżeli serwer
tego nie obsługuje, agent ma zatrzymać C1 i opisać blocker. Nie wolno wrócić do
połowicznego OIDC. Alternatywa pełnego OIDC wymaga osobnej decyzji i biblioteki
walidującej discovery, JWKS, `iss`, `aud`, podpis, expiry i nonce.

Gate C1: backend protocol tests, frontend request contract tests, auth suite.

### D1 — odporność callbacku i klasyfikacja błędów

Zmiany:

- listener iteruje requesty do prawidłowego callbacku albo timeoutu;
- obce ścieżki dostają 404 i nie kończą oczekiwania;
- prawidłowy callback z `error` dostaje czytelną odpowiedź HTML i kończy flow;
- state mismatch dostaje neutralny błąd bez ujawniania wartości;
- po sukcesie przeglądarka dostaje odpowiedź dopiero po bezpiecznym przejęciu
  kodu; wymiana tokenowa może działać po zamknięciu odpowiedzi;
- dodać connect/send/receive timeouty do Dio transportu auth;
- rozpoznać trwały credential wyłącznie po standardowym `invalid_grant`
  (ewentualne dodatkowe kody muszą mieć osobny test kontraktu Backend);
- HTTP 400 z innym błędem, 401 proxy, 429, 5xx, timeout, TLS i offline nie
  usuwają refresh tokena;
- limit rozmiaru i liczby parametrów callbacku pozostaje mały i testowany.

Testy: favicon/probe przed callbackiem, dwie obce ścieżki, state mismatch,
user denied, timeout, port collision, invalid_grant, 429, 500, TLS/offline.

Gate D1: protocol tests bez prawdziwej przeglądarki, analyzer, diff check.

### E1 — przenośny podpis developerski macOS

Cel: zachować stabilną tożsamość bez wpisywania osobistego certyfikatu do
wersjonowanego `project.pbxproj`.

Zmiany:

- usunąć osobisty common name z wersjonowanego pliku projektu;
- utworzyć wersjonowany przykład konfiguracji podpisu bez sekretów;
- lokalny plik override z identity/team dodać do `.gitignore`;
- Debug/Profile pobierają identity z override lub jawnej zmiennej CI;
- brak konfiguracji kończy się czytelnym błędem builda, nie cichym ad-hoc;
- zachować `PRODUCT_BUNDLE_IDENTIFIER=com.excellent.devplanner`;
- udokumentować komendę sprawdzającą Authority, TeamIdentifier, entitlements i
  designated requirement;
- test dwóch kolejnych buildów potwierdza zgodny designated requirement.

Nie usuwać istniejącego wpisu Keychain podczas tej migracji. Jeśli zmieni się
designated requirement, zaplanować jawny jednorazowy prompt/migrację, a nie
kasować cały login keychain użytkownika.

Gate E1: dwa clean buildy Debug, codesign verify, relaunch i hot restart bez
powtarzalnego promptu, auth tests, diff check.

### E2 — podpis Release i docelowy Keychain

Domyślna decyzja dla planu: bez Mac App Store użyć **Developer ID Application +
Hardened Runtime + notarization**. Jeśli produkt ma trafić do Mac App Store,
zatrzymać E2 i przygotować odrębny profil/sandbox; nie mieszać obu kanałów.

Kroki:

- skonfigurować Release bez ad-hoc;
- podpiąć właściwe entitlements i sprawdzić je na gotowej aplikacji, nie tylko
  w pliku plist;
- uzyskać provisioning/credentials przez bezpieczne CI, nigdy przez repo;
- zbudować, podpisać, znotaryzować i wykonać `stapler validate`;
- dopiero przy gotowych entitlements ocenić przejście z file-based Keychain do
  Data Protection Keychain;
- jeśli następuje przejście, wykonać migrację: odczyt legacy → zapis DPK →
  odczyt kontrolny → usunięcie legacy. Awaria w dowolnym kroku nie może usunąć
  jedynej działającej kopii;
- pusta tablica `keychain-access-groups` nie jest dowodem działającego access
  group; sprawdzić realne embedded entitlements przez `codesign`.

Gate E2: podpis/notarization, Gatekeeper na czystym koncie macOS, migracja
Keychain, relaunch po update aplikacji, brak prompt storm.

### F1 — pełny E2E i chaos matrix

Środowisko:

- rzeczywisty Backend, PostgreSQL i Redis;
- testowy użytkownik bez sekretów w repo;
- build macOS podpisany zgodnie z E1/E2;
- logowanie wyłącznie przez systemową przeglądarkę.

Scenariusze obowiązkowe:

1. pierwszy login → callback → `/me` → workspace;
2. restart procesu → silent restore → rotacja refresh tokena;
3. pozostawienie aplikacji ponad lifetime access tokena → dalsze REST działa;
4. 20 równoległych żądań w chwili expiry → jeden refresh;
5. SignalR reconnect w chwili expiry → bez utraty sesji;
6. logout online → revoke, vault pusty, API 401;
7. logout offline → vault pusty lokalnie, aplikacja signed-out;
8. revoke tej sesji z drugiego urządzenia → REST 401 i SignalR disconnect;
9. revoke innego urządzenia → bieżąca sesja działa;
10. wyłączenie konta/zmiana SecurityVersion → REST i SignalR odrzucone;
11. backend 500 podczas refreshu → credential zachowany, brak pętli;
12. brak sieci podczas refreshu → retry po odzyskaniu sieci;
13. reuse starego refresh tokena → rodzina revoked i wymagany login;
14. hot restart i dwa rebuildy → brak powtarzalnego promptu Keychain;
15. update podpisanej aplikacji → istniejąca sesja nadal dostępna;
16. nieprawidłowy callback/state → brak tokenów i neutralny błąd;
17. logi Front/Backend → brak tokenów, kodów, verifierów i sekretów.

Każdy scenariusz zapisuje: datę, platformę, build identity, komendę, wynik,
oczekiwanie i dowód. Brak hosta Windows/Linux zapisuje się jako `NOT RUN`, nie
PASS.

## 6. Bramki końcowe

Frontend minimum:

```bash
flutter test test/auth --reporter compact
flutter test test/foundation/http --reporter compact
flutter test test/workspaces/data/realtime --reporter compact
flutter analyze
flutter build macos --debug
git diff --check
```

Backend minimum:

```bash
dotnet restore
dotnet build veloryn-workspaces.csproj --no-restore
dotnet test Tests/Veloryn.Workspaces.Tests/Veloryn.Workspaces.Tests.csproj \
  --filter 'FullyQualifiedName~LocalOpenIddict|FullyQualifiedName~RefreshToken|FullyQualifiedName~BffSecurity|FullyQualifiedName~ChatSignalR'
dotnet ef migrations script --idempotent --project veloryn-workspaces.csproj
dotnet format veloryn-workspaces.csproj --verify-no-changes
git diff --check
```

macOS minimum:

```bash
codesign --verify --deep --strict --verbose=2 /path/to/DevPlanner.app
codesign -dv --verbose=4 /path/to/DevPlanner.app
codesign -d -r- /path/to/DevPlanner.app
codesign -d --entitlements :- /path/to/DevPlanner.app
```

Pełna suite może ujawnić cudze, istniejące błędy. Agent musi rozdzielić:

- `PASS` — komenda faktycznie zakończona kodem 0;
- `FAIL związany` — błąd w zakresie pakietu, pakiet nieukończony;
- `FAIL zastany` — udowodniony na baseline, zachowany w raporcie;
- `NOT RUN` — komenda nie została uruchomiona.

## 7. Warunki natychmiastowego zatrzymania

Agent zatrzymuje pakiet i nie improwizuje, gdy:

- miałby zapisać access token poza pamięcią albo refresh token poza vaultem;
- miałby dodać client secret do aplikacji desktopowej;
- proponuje wyłączyć PKCE, TLS, cert validation, sandbox lub Gatekeeper;
- nie potrafi odtworzyć body requestu przed retry;
- test pokazuje więcej niż jeden refresh dla jednej fali 401;
- refresh token pojawia się w Bearerze albo logu;
- logout race potrafi odtworzyć sesję;
- zmiana podpisu wymaga usunięcia całego Keychain użytkownika;
- revoke jednej sesji wylogowuje inne urządzenia bez żądania użytkownika;
- rozwiązanie SignalR działa tylko na jednym hoście;
- pełne OIDC wymagałoby ręcznej implementacji JWT;
- musi edytować historyczną migrację;
- występuje konflikt z cudzymi zmianami w tych samych liniach.

## 8. Definition of Done

Zakres jest ukończony wyłącznie wtedy, gdy:

- wszystkie pakiety A0–F1 mają osobne dowody;
- brak fallbacku refresh-vault → Bearer;
- REST, typed Dio i SignalR używają jednego koordynatora;
- jedna fala requestów powoduje jeden refresh i najwyżej jeden retry/request;
- rotacja zapisuje nowy credential przed zależnym `/me`;
- trwałe i przejściowe błędy refreshu mają różne zachowanie;
- revoke jest natychmiast egzekwowany dla REST i aktywnego SignalR;
- klient nie udaje OIDC bez walidacji ID tokena;
- Debug/Profile nie zawierają osobistego certyfikatu w repo;
- Release jest podpisany i znotaryzowany albo jawnie pozostaje osobnym,
  nieukończonym kanałem;
- dwa kolejne buildy i update zachowują dostęp do własnego wpisu Keychain;
- realny macOS E2E przeszedł pełną macierz;
- plan i handoff w obu repozytoriach są byte-for-byte zsynchronizowane;
- żaden wynik `NOT RUN` ani zastany FAIL nie został opisany jako PASS.

## 9. Szablon raportu każdego pakietu

Agent kończy pakiet raportem o dokładnej strukturze:

```text
Pakiet: A1
Status: PASS | FAIL | BLOCKED
Zakres zmieniony:
- plik: konkretna odpowiedzialność

Kontrakty zachowane:
- access token tylko w pamięci
- refresh token tylko w vault
- Web BFF bez zmian

Testy i komendy:
- dokładna komenda — PASS/FAIL/NOT RUN — liczba testów

Scenariusze bezpieczeństwa:
- single-flight: PASS/FAIL/NOT RUN
- logout race: PASS/FAIL/NOT RUN
- token leakage scan: PASS/FAIL/NOT RUN

Znane ograniczenia:
- tylko fakty, bez domniemanego sukcesu

Następny dozwolony pakiet:
- A2
```

Po zaakceptowaniu pakietu root aktualizuje wspólny plan oraz handoff w Backend
i Front. Agent wykonawczy nie może sam oznaczyć nadrzędnego planu jako DONE.
