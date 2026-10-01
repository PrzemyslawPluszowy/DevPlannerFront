# Publikacja DevPlanner — 2026-10-01

Zgoda użytkownika obejmuje commit, push oraz wdrożenie Frontu i Backendu.

## Zapisane źródła

- Backend: 5d84079745a95978fc2047a774ba8b3a27e1401c, wypchnięty do main.
- Front: 3849a0b, wypchnięty do main.
- Commit message zawiera [skip ci], ponieważ wdrożenie backendu jest wykonywane ręcznie przez SSH, bez równoległego GitHub Actions.
- Walidacja przed publikacją: Front 2212 PASS i analyzer bez uwag; Backend pełne 1469 PASS/4 SKIP oraz późniejszy batch fixture 40/40 PASS. Web/Wasm/macOS debug build PASS.
- Przy sprawdzeniu staged diff znaleziono końcowe spacje w nowym dokumencie backendu (poprawione przed push) oraz osiem pustych linii ze spacjami w wygenerowanych plikach Freezed Frontu. Plików wygenerowanych nie zmieniano ręcznie; nie raportować ścisłego committed diff --check jako PASS dla Frontu.

## Front — paczka gotowa na VPS

Build Web Wasm z DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl przesłano jako /home/codex-staging/devplanner-front-3849a0b-web.tar.gz.

SHA-256 lokalnie i na VPS:

dd4a17f4c0c09d83c5b3856b6611a28d333e35120c0a9f0a8471d77643de9003

Nginx ma już root /srv/devplanner/frontend/current i fallback SPA. Obecny użytkownik codex-staging nie ma zapisu do /srv/devplanner/frontend; sudo -l dopuszcza wyłącznie observe, deploy, deploy-local i seed-demo. Logowanie root dostępnym kluczem zostało odrzucone. Nie obchodzono ograniczeń.

Administrator może umożliwić publikację jedną komendą:

```bash
sudo chown codex-staging:codex-staging /srv/devplanner/frontend
```

Po jej wykonaniu agent może rozpakować paczkę do katalogu releases/3849a0b, atomowo utworzyć symlink current i sprawdzić index.html, bootstrap, Wasm oraz fallback trasy. Zmiana właściciela dotyczy tylko katalogu publikacji Frontu; nie jest potrzebny dostęp do sekretów, Dockera ani konfiguracji Nginx.

## Backend

Ręczny deploy uruchomiony poleceniem sudo -n /usr/local/sbin/devplanner-deploy-local. Log lokalny: /tmp/devplanner-staging-deploy-2026-10-01.log. Deploy zakończył się exit 0. Obraz API ma dokładnie SHA 5d84079745a95978fc2047a774ba8b3a27e1401c; kontener healthy, Nginx active, observer readiness ready oraz publiczny /health/ready zwraca Healthy. Migracje obu kontekstów wykonane przez skrypt. Front pozostaje nieopublikowany z powodu potwierdzonego braku prawa zapisu.


## Reguły agentów i skrypt Frontu

W obu AGENTS.md zapisano staging jako docelowe środowisko testów UI/E2E i odbioru wizualnego, obowiązkowy Wasm i publikację przez skrypty. Użytkownik zezwolił na czyszczenie i seedowanie danych tego stagingu w ramach testów. Nie wykonano resetu bazy ani seedowania w tej publikacji.

Dedykowany skrypt Front/scripts/deploy_staging_wasm.sh ma preflight uprawnień, budowę Wasm, kontrolę sumy SHA-256, wersjonowane katalogi, atomowy symlink i cofnięcie symlinka przy nieudanym sprawdzeniu HTTP. bash -n PASS; preflight na obecnym koncie odmawia publikacji przed buildem/uploadem. Skrypt nie był jeszcze sprawdzony w pełnym przebiegu publikacji.


## Końcowy wynik — Front i Backend opublikowane

Po wykonaniu przez administratora zmiany właściciela katalogu Frontu skrypt publikacji przeszedł pełny przebieg (exit 0). Aktywna wersja Frontu: b234a98438ed22e40049d4c38f2ff1c40d6b3f34.

Pierwszy render ujawnił brak MIME dla .mjs w Nginx. Publisher zachowuje treść modułu Wasm, nadaje mu rozszerzenie main.dart.wasm.js i aktualizuje jego ścieżkę w loaderze. Adres bootstrapu w index.html jest wersjonowany SHA wydania, aby uniknąć starej kopii przeglądarkowej. Nie wymaga to zmiany konfiguracji Nginx ani ponownej kompilacji aplikacji.

Potwierdzono HTTP 200 i sumy SHA-256 zgodne z lokalnym buildem dla main.dart.wasm oraz modułu wsparcia. MIME: application/wasm i application/javascript. /workspaces zwraca dokładnie opublikowany index.html (SPA fallback). Backend /health/ready: HTTP 200 Healthy, kontener obrazu 5d84079745a95978fc2047a774ba8b3a27e1401c healthy.

Rzeczywisty render w przeglądarce na stagingu zakończył się ekranem logowania DevPlanner pod /login?returnTo=/workspaces. Nie wykonano w tej publikacji uwierzytelnionych scenariuszy modalu, Chat i Storage; nie jest to ich pełny odbiór. Wcześniejsza blokada publikacji Frontu jest rozwiązana.


## 2026-10-01 — naprawa logowania i branding

Potwierdzona przyczyna auth.oidc_callback_invalid na stagingu: discovery wskazywało /.well-known/jwks.json, ale Nginx przekazywał do API tylko dokładne discovery i prefiksy api/auth/bff/connect/hubs/health. JWKS zwracało HTTP 200 text/html ze SPA zamiast JSON. Główny endpoint kluczy zmieniony na /connect/jwks; dotychczasowy endpoint pozostaje aliasem backendu. Nie osłabiono walidacji podpisu, issuer, audience ani nonce.

Backend LocalOpenIddictTests + BffSecurityTests + LocalLoginHttpTests: 41 PASS, 0 SKIP, 0 FAIL. Formularz serwera otrzymał logo BANKAI flow z istniejących assetów Frontu, Inter, responsywny dwukolumnowy układ, focus, etykiety i błędy oraz prefers-color-scheme light/dark. Anti-forgery i autocomplete zachowane. Kontrakty enumów niezmienione.

Front otrzymał AuthPageSurface oparty o istniejące shell tokens i assety. Motyw ekranu wejścia reaguje na systemową jasność, niezależnie od zapisanej preferencji aplikacji. Oba ThemeData są przygotowane w initState. Właściciele Cubitów i przebieg logowania bez zmian. UI UX Pro Max: Accessible Authentication, password managers/paste, nazwane kontrolki; Impeccable Operate i craft-floor.

W chwili tego wpisu: wdrożenie oraz uwierzytelniony odbiór UI pozostają do potwierdzenia. Logi testów /tmp/devplanner-login-fix-tests.log; build Wasm /tmp/devplanner-branded-login-wasm-build.log.


## 2026-10-01 — regresje ze stagingu po uruchomieniu aplikacji

- Wcześniejszy pakiet logowania wdrożony: Backend `6f1e38c`, Front `3737c5e`.
  Discovery wskazuje `/connect/jwks`, JWKS zwraca JSON/200; rzeczywiste logowanie
  przeszło callback i wyrenderowało workspace. Konta/secrets nie są dokumentowane.
- Naprawa w bieżącym pakiecie: seeder inicjalizuje sześć statusów, zachowuje
  istniejące nazwy/kolory/pozycje i status początkowy. Addytywna migracja
  `BackfillMissingProjectWorkflows` naprawia wyłącznie projekty bez workflow.
  Rollback aplikacji zachowuje naprawione dane, aby nie odtwarzać awarii odczytu.
- Front: `/me` korzysta z rozwiązanego adaptera HTTP zamiast pustego argumentu
  konstruktora routera. Suwak poziomy tabeli Listy jest stale widoczny i interaktywny.
- Walidacja kodu: Backend batch initializer/ProjectTaskHandler/enum wire: 58 PASS,
  0 FAIL/0 SKIP; Front router: 15 PASS; pełny analyzer Front: brak problemów.
  Wyniki nie zastępują manualnej akceptacji na stagingu. Wasm/deploy bieżącego
  pakietu jeszcze w toku.
- UI UX Pro Max: zastosowano zalecenie `Content Jumping` (stabilna geometria
  stanów asynchronicznych). Impeccable Operate/craft floor: zachowanie tokenów,
  interaktywnych suwaków i dotychczasowej stylistyki Listy/Kanbana.
- Do dokończenia na stagingu: Kanban drop i stabilność nagłówka, List scroll,
  profil, wszystkie projekty workflow, sesja konkretnego pliku OnlyOffice,
  obecność aplikacji i prawy panel osób. Audyt potwierdził, że dotychczas Tasks
  presence obejmuje wyłącznie otwarty projekt, a nie całą zalogowaną sesję.
- Nowa jawna dyspozycja użytkownika: manualne przejście aplikacji i poprawianie
  znalezionych błędów, następnie czat na trzech kontach w niezależnych sesjach
  (wysyłanie/odczyt/presence/pliki/reconnect). Trzy karty z tym samym cookie
  nie są dowodem testu trzech użytkowników.
