# DevPlanner standalone — zaakceptowany stan refaktoryzacji

Status: **częściowo zrealizowane; poniższy dokument opisuje wyłącznie stan zaakceptowany**.

Dokument jest wspólny dla repozytoriów:

- `/Users/przemyslawnowak/Desktop/dev/DevNote/Backend`
- `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`

Obie kopie muszą być byte-for-byte identyczne. Nie zmieniaj kodu, migracji ani
testów w ramach samej synchronizacji dokumentacji.

## 1. Obowiązujące decyzje

- DevPlanner działa jako standalone i używa lokalnej tożsamości `UserId` typu
  UUID (`Guid` w backendzie). `ReadyUserId`, `CoreUserId` oraz aliasy tych pól
  nie są kontraktem docelowym.
- Backend, OpenAPI i Flutter używają lokalnego `UserId`; nie dodano aliasów,
  dual-read/write, fallbacku ani importu legacy.
- Zakres produktu obejmuje workspace, projekty, zadania, Kanban, Storage, Wiki,
  Whiteboard, Chat, Notifications, ustawienia i administrację użytkownikami.
- Ready/Core/DataBus i ich połączenia runtime pozostają poza standalone.

## 2. Pakiety zaakceptowane

### 2D — sesje urządzeń i refresh tokeny

Pakiet jest zaakceptowany po wspólnym targeted suite **119/119**. Zaakceptowany
zakres obejmuje lifecycle sesji urządzenia, rotację rodzin refresh tokenów,
revoke oraz persistence.

### 3D — frontend auth/admin/me

Pakiet jest zaakceptowany z `AuthComposition` oraz podłączonymi seamami
auth/admin/profile/session w uzgodnionym zakresie. Produkcyjne bramki transportu
i E2E pozostają otwarte i nie są dowodem ukończenia całego produktu.

### 4B — świeży schemat domeny, FK i indeksy

Pakiet jest zaakceptowany po poprawce przeglądu CSRF. Akceptacja dotyczy
zatwierdzonego schematu i kontraktów; pozostałe agregaty domenowe nadal wymagają
osobnych pakietów.

### 4C — OpenAPI oraz Chat/Notifications `UserId`

Pakiet jest zaakceptowany po korekcie indeksu migracji. Walidacja PostgreSQL dla
Notifications zakończyła się wynikiem **41/41**.

### 4D — Tasks/Kanban lokalny `UserId`

Pakiet jest zaakceptowany w zakresie lokalnego `UserId` dla Tasks/Kanban.
Zmiana obejmuje encje, kontrakty, query/handler/mapper, capacity i preferencje
Kanban, realtime/outbox/workery oraz konfigurację EF/indexes. Usunięto nazwy
`*CoreUserId` i legacy Ready z tego pionu; nie dodano aliasów, dual-read/write,
fallbacku ani backfillu.

Dowody zaakceptowane dla 4D:

- backend build: **0/0** (PASS, zero ostrzeżeń);
- targeted Tasks/Kanban unit/handler suite: **100/100** (PASS; 69 + 31);
- idempotentny skrypt migracji EF: PASS.

Walidacja integracyjna PostgreSQL dla 4D **nie została zweryfikowana**: filtr
był zablokowany przez nieprawidłowe credentials istniejącej instancji
`127.0.0.1:5440`. Nie wolno przedstawiać tego jako PASS ani jako dowodu
działania migracji na PostgreSQL.

### 4E — Projects/Workspace lokalny `UserId`

Pakiet jest zaakceptowany dla lokalnego UUID `UserId` w Projects/Workspace.

Dowody zaakceptowane dla 4E:

- backend build: **0/0** (PASS, zero błędów i ostrzeżeń);
- agent gate: **17/17** (PASS);
- dodatkowy root gate: **20** testów (PASS).

Dwa przypadki `WorkspaceRoleHttpIntegration` nie przeszły konfiguracji fixture,
ponieważ środowiskowa baza testowa nie zawiera tabeli
`veloryn_workspaces.workspaces`. Jest to problem provisioning/fixture bazy
testowej, a nie błąd logiki pakietu; nie zmienia akceptacji 4E. Tabelę należy
zapewnić przed ponownym uruchomieniem tych dwóch przypadków.

### 6F/6G — frontendowe typed adapters rename

Pakiety globalnego Chat (6F) i Notifications (6G) są zaakceptowane w zakresie
standalone runtime wiring oraz rename do typowanych adapterów opartych o lokalny
`UserId`.

Dowody zaakceptowane dla wspólnego zakresu 6F/6G:

- targeted frontend suite: **11/11** (PASS);
- `flutter analyze`: PASS.

Nie jest to akceptacja produkcyjnego transportu sesji ani pełnych testów E2E.

### 4F — frontend auth lokalny `UserId`

Pakiet jest zaakceptowany dla aktywnego rdzenia autoryzacji Fluttera. `AuthUser`
używa kanonicznych pól `String userId` i `login`; w zakresie 4F usunięto
aliasy `CoreUserId`/Ready oraz bezpośrednie odwołania do starych call site'ów
auth w shellu, routerze, pickerze i wątkach. Typed `/api/v1/me` pozostaje
kontraktem profilu. Nie dodano fallbacku Ready/Core/DataBus ani dual-read/write.

Dowody zaakceptowane dla 4F:

- `flutter test test/core/auth`: **48/48** (PASS);
- `flutter test test/auth`: **16/16** (PASS);
- `flutter test test/app/router`: **9/9** (PASS);
- suma targeted suite: **73/73** (PASS);
- `flutter analyze`: PASS, bez problemów;
- `git diff --check`: PASS.

Pozostałe domenowe DTO frontendu (m.in. Tasks, Projects i Storage) pozostają
poza zakresem 4F i nadal wymagają osobnych pakietów migracji do lokalnego
`UserId`.

### 4G — Storage/Office/avatar/share/AI lokalny `UserId`

Pakiet jest zaakceptowany dla Storage, upload/download, ACL, współdzielenia,
integracji Office/OnlyOffice, avatarów, wyszukiwania semantycznego i zadań AI.
Encje, kontrakty, serwisy oraz bezpośrednie testy używają lokalnego UUID
`UserId`; usunięto parametry i aliasy `CoreUserId`/Ready oraz fallbacki.

Nie dodano migracji EF. Odpowiedni schemat jest już lokalny, a
`StorageUserNotificationPreference` został poprawnie przemianowany w migracji
4C; tworzenie duplikatu migracji byłoby błędem.

Dowody zaakceptowane dla 4G:

- backend build: **0/0** (PASS, zero błędów i ostrzeżeń);
- wybrana suite Storage/Office/avatar/share/AI: **135/135** (PASS);
- formatowanie i `git diff --check`: PASS.

Szersza bramka HTTP/integration Storage pozostaje otwarta z powodu fixture
`42P01` oraz standalone guarda odrzucającego legacy środowisko; nie jest to
wynik PASS.

### 4H — Wiki/Whiteboard/OKR lokalny `UserId`

Pakiet jest zaakceptowany dla lokalnego `UserId` w grantach dostępu Wiki i
Whiteboard, `Objective.CreatedByUserId` oraz `StickyNote.AssigneeUserIds`.
Usunięto aliasy i fallbacki Ready/Core. Zastosowano wyłącznie rename-only
migrację `20260917074039_UseLocalUserIdForWikiWhiteboardAndOkr`.

Dowody zaakceptowane dla 4H:

- backend build: **0/0** (PASS);
- root selected suite: **74/74** (PASS; agent narrow suite 57/57);
- idempotentność migracji i `git diff --check`: PASS.

Wiki HTTP/OpenAPI integration była historycznie blokowana przez legacy JWKS
environment; 4O usuwa odziedziczoną konfigurację fixture’ów, ale szersza
bramka Wiki HTTP nadal wymaga własnych, ukierunkowanych dowodów.

### 4I — frontend Tasks/Kanban lokalny `UserId`

Pakiet jest zaakceptowany dla aktywnego frontendu Tasks/Kanban. Modele,
payloady, query, repozytoria, realtime oraz UI używają kanonicznych pól
`userId`, `assigneeUserId`/`assigneeUserIds` i `userIds`; obejmuje to także
profile członków projektu, board/list/details, templates, capacity i workload.
Odświeżono wygenerowane Freezed/JSON/Retrofit. Nie ma aliasów, fallbacku,
dual-read/write ani mapowania Ready/Core.

Dowody zaakceptowane dla 4I:

- targeted frontend suite: **116/116** (PASS);
- generator: PASS, 182 outputs zapisane (wyłącznie istniejące ostrzeżenie
  constraint `json_annotation`);
- scoped `flutter analyze`: PASS, bez problemów;
- pełny skan zakresu pakietu nie znalazł `CoreUserId`, `coreUserId`,
  `ReadyUserId`, `readyUserId` ani `ready_id`;
- `git diff --check`: PASS.

Pełny `flutter analyze` po 4J nie jest dowodem testów E2E Tasks/Kanban.

### 4J — frontend Workspace members, invitations i lokalny katalog

Pakiet jest zaakceptowany dla członkostw workspace, zaproszeń oraz lokalnego
katalogu użytkowników. `WorkspaceMemberResponse`, zaproszenia i payloady
używają `userId`, a `LocalDirectoryUserResponse` publikuje dokładny kontrakt
`userId`, `login`, `displayName`, `email`, `emailVerified`, `avatarFileId`.
Wyszukiwanie korzysta z `searchLocalUsers`; bez fallbacku i dual-read/write.
Zaktualizowano bezpośrednie call-site’y Project/Storage wymagane przez te
kontrakty, w tym użycie `avatarFileId`, oraz odświeżono artefakty generowane.

Dowody zaakceptowane dla 4J:

- focused members/workspace suite: **10/10** (PASS);
- dodatkowa suite kontraktów i konsumentów: **11/11** (PASS);
- generator: PASS, 5 artefaktów;
- `flutter analyze`: PASS, `No issues found!`;
- `git diff --check`: PASS.

Aktualny source scan nie wykazuje już tych legacy pól DTO ani feature actors;
starsza wzmianka nie jest już blokadą. Nie rozszerza to jednak dowodów na pełne
E2E ani platformy.

### 4K — frontend Projects/Workspace core lokalny `UserId`

Pakiet jest zaakceptowany dla frontendowych kontraktów Projects/Workspace core.
`ProjectResponse`, `ProjectMemberResponse`, `PortfolioResponse` i
`WorkspaceResponse` oraz listy i mappery używają kanonicznych pól
`createdByUserId` i `userId`. Zaktualizowano także bezpośrednie wywołania
Project oraz odświeżono artefakty generowane; nie dodano aliasów, fallbacku ani
dual-read/write.

Dowody zaakceptowane dla 4K:

- agent suite: **27/27** (PASS);
- dodatkowy kontraktowy test generatora: **1/1** (PASS);
- root cross-package selective suite: **18/18** (PASS);
- `flutter analyze`: PASS;
- `git diff --check`: PASS.

Zakres 4K nie obejmuje pozostałych workspace feature actors, niezależnych
DTO dostępu/automatyzacji/realtime ani produktu E2E.

### 4L — frontend Storage/Wiki/Whiteboard/ACL lokalny `UserId`

Pakiet jest zaakceptowany dla frontendowych kontraktów Storage, Office,
avatarów, share i AI oraz pozostałych Storage/Wiki/Whiteboard ACL. `Objective`
publikuje `createdByUserId`, a sticky notes używają kanonicznego
`assigneeUserIds`; artefakty generowane zostały odświeżone. W tym zakresie nie
ma aliasów `CoreUserId`/Ready, fallbacków ani dual-read/write.

Dowody zaakceptowane dla 4L:

- agent suite: **23/23** (PASS);
- root cross-package selective suite: **18/18** (PASS);
- `flutter analyze`: PASS;
- `git diff --check`: PASS.

Pełny build runner w trakcie 4L dodatkowo wygenerował workspace responses, ale
ich źródłem autorytatywnym pozostaje pakiet 4K. 4L nie obejmuje pozostałych
workspace feature actors, niezależnych DTO dostępu/automatyzacji/realtime ani
produktu E2E.

### 4N — backendowe aktywne identity names i transport

Pakiety 4N-A, 4N-B i 4N-C są zaakceptowane w zakresie aktywnych warstw
backendu. Warstwy te nie używają nazw identity `Core`/`Ready`; kanoniczne
nazwy transportowe to `userId`, `actorUserId` i `authorUserId`. Dotyczy to
infrastruktury Ops/Admin, globalnego wyszukiwania Chat oraz objętego zakresem
cleanupu Projects. Nie dodano aliasów, fallbacków ani dual-read/write.

Obowiązuje jedna rename-only migracja
`20260917082352_UseLocalUserIdForOpsInfrastructure` dla tych rename’ów; nie
tworzyć równoległej migracji wykonującej te same zmiany.

Dowody zaakceptowane dla 4N:

- 4N source scan: PASS;
- backend build: **0/0** (PASS);
- idempotentny skrypt migracji EF, formatowanie i `git diff --check`: PASS.

Test HTTP/OpenAPI pozostaje otwarty i nie jest wynikiem PASS: zatrzymuje go
legacy fixture `WORKSPACES_JWKS_*`. Obsługa tej blokady została zamknięta przez
pakiety 4O i 4Q dla objętego nimi zakresu.

### 4O — standalone test host i lokalny Identity/OpenIddict

Pakiet jest zaakceptowany dla testowego hosta, fixture’ów i helperów lokalnego
standalone Identity/OpenIddict. Fixture’y nie ustawiają już zabronionych
`WORKSPACES_JWKS_URL`, `WORKSPACES_JWT_ISSUER` ani
`WORKSPACES_JWT_AUDIENCE`; czyszczą odziedziczone klucze i używają lokalnego
issuera OpenIddict. Produkcyjna logika, aliasy i fallbacki nie zostały zmienione.

Dowody zaakceptowane dla 4O:

- backend build: **0/0** (PASS);
- Local Identity/OpenIddict tests: **19/19** (PASS);
- scoped format verify helpera i `git diff --check`: PASS.

Pełna weryfikacja formatu projektu pozostaje osobnym porządkiem technicznym z
istniejącymi whitespace diagnostics; nie jest to błąd produktu ani podstawą do
cofnięcia akceptacji. Historyczne uruchomienia `dotnet format` z root repo były
niejednoznaczne co do wyboru projektu; kolejne weryfikacje wykonywać z jawnym
plikiem projektu, np. `dotnet format veloryn-workspaces.csproj
--verify-no-changes`.

### 4P — konkretny kontrakt OpenAPI dla avatarów

Pakiet jest zaakceptowany dla `GET /api/v1/me/avatar` oraz
`GET /api/v1/users/{userId}/avatar`. Wildcard `image/*` zastąpiono trzema
konkretnymi typami odpowiedzi: `image/jpeg`, `image/png` i `image/webp`, zgodnie
z walidacją uploadu i magic bytes. Nie zmieniono uploadu, storage, cache/ETag ani
statusów błędów.

Dowody zaakceptowane dla 4P:

- backend build: **0/0** (PASS);
- OpenAPI publikuje dokładnie trzy obsługiwane typy bez wildcardu (PASS);
- avatar upload tests: **3/3** (PASS).

### 4Q — disposable fixture i kontrakt OpenAPI AdminOps

Pakiet jest zaakceptowany w zakresie standalone HTTP/OpenAPI. Fixture
`AdminOpsPostgresFixture` tworzy losową, disposable bazę PostgreSQL, stosuje
aktualne migracje `WorkspaceDbContext` i `LocalIdentityDbContext`, a następnie
sprząta bazę po testach. OpenAPI wymaga standalone BFF cookie
`BffSessionCookie` (`devplanner.bff`, `apiKey` w `cookie`) i nie publikuje
legacy `Bearer` ani wewnętrznego `IdentityCookie`.

Dowody zaakceptowane dla 4Q:

- niezależny build z root: **0/0** (PASS);
- wybrane testy HTTP/OpenAPI: **11/11** (PASS), obejmujące AdminOps i
  `ApiEndpointTests.ChatSearchRateLimit`;
- `git diff --check`: PASS.

Nie uruchamiano pełnej suite; fixture i kontrakt są wzorcem dla kolejnych
odblokowywanych standalone HTTP/integration testów. Nie wracać do legacy
connection stringów, Bearer/JWT ani schematu IdentityCookie.

### 4R-B — standalone runtime readiness

Pakiet jest zaakceptowany w zakresie lokalnej konfiguracji startowej, świeżego
schematu i bounded bootu backendu. Audyt README, `.env.example`, launch
settings, `Program.cs`, `start-local.sh` i Compose potwierdził topologię
standalone bez runtime endpointów Ready/Core/DataBus.

W świeżej bazie wykryto brak kolumny `project_automation_rules.ArchivedAtUtc`:
ręczna migracja `20260822160000_AddAutomationRuleArchive` nie była odkrywana
przez EF, bo nie miała atrybutów `DbContext`/`Migration`. Dodano addytywną,
idempotentną migrację `20260917100000_EnsureAutomationRuleArchiveColumn`; nie
zmieniano historycznych migracji.

Dowody zaakceptowane dla 4R-B:

- `docker compose config --quiet`: PASS;
- backend build: **0/0** PASS;
- migracje `WorkspaceDbContext` i `LocalIdentityDbContext` na disposable
  PostgreSQL: PASS;
- bounded boot: `/health/live` 200, `/health/ready` 200, Swagger 200;
- po poprawce brak błędu `ArchivedAtUtc` i nieobsłużonego wyjątku startowego;
- nie uruchamiano pełnej suite ani długotrwałego procesu.

Pełny `start-local.sh` nadal wymaga Docker Compose; MinIO, ClamAV, Redis,
OnlyOffice i Mailpit są prerequisite'ami odpowiednich funkcji, lecz nie były
uruchamiane w bounded probe. Nie przywracać konfiguracji ani endpointów
Ready/Core/DataBus.

### 4R Front — frontend runtime readiness

Pakiet jest zaakceptowany dla audytu standalone Flutter runtime. Kanoniczny
start prowadzi przez `lib/main.dart` i `DevPlannerApp`, a aktywna konfiguracja
używa wyłącznie `DEVPLANNER_API_BASE_URL`; nie ma aktywnych endpointów ani
kluczy Ready/Core/DataBus. Pakiet 4S domknął cleanup nieosiągalnych legacy
widgetów i tras; z `lib/core/auth` nie pozostaje żaden kod.

Dowody: `flutter analyze` po 4S — PASS (`No issues found!`). Niezależny
`flutter build web --debug --no-tree-shake-icons` po 4S zakończył się PASS w
**98.7 s**.

### 4S — frontend legacy auth corrective cleanup

Pakiet jest zaakceptowany: usunięto cały `lib/core/auth`, `AuthApi` i każdy
port kompatybilności, stare endpointy logowania/refresh, dedykowane testy oraz
nieosiągalne legacy dormant widgets/routes. Aktywny Chat otrzymuje jawny
`userId` z kompozycji użytkownika. `lib/auth` pozostaje jedynym aktywnym
standalone auth; nie dodano fallbacku ani aliasu.

Dowody: `flutter analyze` po 4S — PASS; `flutter gen-l10n` i `git diff
--check` — PASS; post-4S Web build PASS (**98.7 s**).

### 5A/5B — dormant legacy auth i DataBus cleanup

Pakiety są zaakceptowane: usunięto dormant DataBus/Core resource-scope,
zewnętrzny JWKS/JWT bearer oraz nieużywane legacy auth/configuration paths.
Aktywna kompozycja pozostaje lokalnym OpenIddict/BFF; skan źródeł nie wykazuje
już tych klas, rejestracji ani pakietu JwtBearer.

Dowody: root review backend build **0/0** (PASS) oraz wybrana suite **74/74**
(PASS). Nie oznacza to ukończenia pełnej macierzy E2E/platform.

### 5I/5K — hermetic PostgreSQL oraz Storage/AI HTTP

Disposable PostgreSQL i hermetyczne Storage/AI fixtures są zaakceptowane.
Walidacja ukierunkowanego zakresu zakończyła się wynikiem **17/17** (PASS).

### 5L/5M — lokalny test seam i sesja BFF

Pozytywny test seam używa wyłącznie `X-Test-User-Id` i emituje `sub`; pozytywne
oczekiwania OpenAPI używają lokalnych identyfikatorów. Kontrakt `/me` sprawdza
bezpośrednie `302` BFF przy wyłączonych redirectach. Root validation: **1/1**
(PASS). Nie przywrócono bearer/JWT.

### 5N/5O — HTTP/OpenAPI fixture i kontrakt

Pozostała ukierunkowana bramka HTTP/OpenAPI na disposable fixture zakończyła się
wynikiem **57/57** (PASS), obejmując aktualny BFF session scheme i kontrakty
OpenAPI.

### 5P — ACL, automatyzacja i realtime

Pakiet jest zaakceptowany po proof suite **33/33** (PASS) dla ACL,
automatyzacji i realtime. Wynik dotyczy wskazanego zakresu testów, nie pełnej
macierzy E2E ani wszystkich platform.

### 5R — odporność równoczesnej rotacji refresh tokena

Pakiet jest zaakceptowany dla równoczesnych żądań rotacji refresh tokena w
PostgreSQL. Retry jest ograniczony do maksymalnie jednej próby i uruchamia się
wyłącznie dla `PostgresException.SqlState == "40001"`. Ponowienie obejmuje
pełną operację w jednej transakcji razem z zapisem audytu; rollback nie duplikuje
wpisu audytowego. Drugi równoczesny request kończy się fail-closed po wykryciu
reuse i unieważnia rodzinę tokenów.

Dowody zaakceptowane dla 5R:

- `RefreshTokenPostgresConcurrencyTests`: **1/1** (PASS);
- `dotnet build veloryn-workspaces.csproj --no-restore`: **0/0** (PASS);
- `git diff --check`: PASS.

### 5S — workspace lifecycle, membership, invitations i preferences

Pakiet jest zaakceptowany dla lifecycle workspace, członkostw, zaproszeń i
preferencji na disposable PostgreSQL. Dowody obejmują wyłącznie ten zakres
HTTP/integration i nie rozszerzają akceptacji na pełne E2E produktu.

Dowody zaakceptowane dla 5S:

- targeted disposable PostgreSQL gate: **7/7** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

### 5T — Wiki PostgreSQL/HTTP standalone

Pakiet jest zaakceptowany dla standalone Wiki PostgreSQL/HTTP z użyciem
`WebApplicationFactory`. Wynik potwierdza wskazany kontrakt HTTP i persistence
Wiki; nie jest dowodem pełnej macierzy E2E ani wszystkich platform.

Dowody zaakceptowane dla 5T:

- standalone Wiki PostgreSQL/HTTP gate: **4/4** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

### 5U — frontend bounded auth/session/shell/router

Pakiet jest zaakceptowany dla bounded frontendowego zakresu auth, session,
shella i routera.

Dowody zaakceptowane dla 5U:

- targeted frontend suite: **53/53** (PASS);
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5V — frontend global Chat/Notifications/realtime contracts

Pakiet jest zaakceptowany dla frontendowych kontraktów globalnego Chat,
Notifications i realtime oraz ich fake/test suite. Wynik nie dowodzi live
backend SignalR E2E; ten zakres pozostaje częścią otwartej macierzy E2E.

Dowody zaakceptowane dla 5V:

- targeted frontend contract/fake suite: **67/67** (PASS);
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5W — standalone Task HTTP/OpenAPI matrix

Pakiet jest zaakceptowany dla standalone Task HTTP/OpenAPI matrix przez
`WebApplicationFactory` i disposable PostgreSQL. Zakres obejmuje smoke test 100
operacji Tasks, role/access, workflow oraz kontrakty błędów `400/401/403/404/409`.
Test używa wyłącznie GUID `UserId` przekazywanego przez `X-Test-User-Id`; z
testu usunięto wskaźniki i nazwy Ready/Core oraz legacy environment.

Dowody zaakceptowane dla 5W:

- standalone Task HTTP/OpenAPI matrix: **6/6** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

Pakiet nie jest dowodem pełnego E2E produktu.

### 5X — standalone local login backend/BFF

Pakiet jest zaakceptowany dla lokalnego logowania backendowego przez `GET/POST
/auth/login`. Zakres obejmuje antiforgery, rate limit **10/5 min/IP**,
`returnUrl` ograniczony do adresów lokalnych, aktywne i potwierdzone konto
lokalne, neutralne błędy oraz przejście z cookie Identity do autoryzacji BFF.
Nieudane lub niejednoznaczne dopasowanie loginu/e-maila kończy się fail-closed.
Publiczna rejestracja nie istnieje; provisioning dotyczy wyłącznie
skonfigurowanych klientów OIDC.

Dowody zaakceptowane dla 5X:

- `LocalLogin` + `BffSecurity` + `LocalOpenIddict` +
  `LocalIdentityFoundation`: **36/36** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

Pakiet nie zamyka desktop PKCE ani real browser E2E.

### 5Y — frontend web BFF root

Pakiet jest zaakceptowany dla frontendowego web BFF root: browser launcher,
web composition i restore wykonywane przed `runApp`, CTA bez credentials,
neutralny redirect bez error flash oraz brak bearer transportu.

Dowody zaakceptowane dla 5Y:

- targeted gates po review: **39/39**, następnie korekta review **24/24**
  (PASS);
- scoped `flutter analyze`: PASS;
- web debug build: PASS.

Desktop PKCE pozostaje otwarte, podobnie jak real browser E2E; ten pakiet nie
jest dowodem pełnego E2E.

### 5Z — backend Desktop Authorization Code + PKCE contract

Pakiet backendowy jest zaakceptowany dla kontraktu Desktop Authorization Code +
PKCE. Publiczny klient ma `client_id=devplanner-desktop` i nie ma sekretu.
Wymagany jest code flow z PKCE `S256`; callback używa loopback URI
`http://127.0.0.1:<49152..65535>/callback`. Kontrakt obejmuje rotację,
wykrywanie reuse i revoke refresh-tokenów.

Dowody zaakceptowane dla 5Z:

- targeted `LocalOpenIddict` gate: **13/13** (PASS);
- backend build: PASS, bez ostrzeżeń;
- manual visual rendering: PASS.

Implementacja transportu platformowego po stronie Front pozostaje w toku.
Browser Playwright E2E jest celowo zdepriorytetyzowane; real browser E2E nadal
pozostaje otwarte.

### 6E — Desktop PKCE typed transport implementation

Pakiet jest zaakceptowany dla typed transportu Desktop PKCE. Klient używa
publicznego `devplanner-desktop`, Authorization Code + PKCE `S256`, losowego
portu loopback `49152..65535` i system browsera. `state`, `nonce` i
`code_verifier` należą do typed transportu; access token pozostaje wyłącznie w
pamięci, a refresh token wyłącznie w OS vault. Rotacja zastępuje wartość w
vault. Autorytatywnym odczytem użytkownika jest `GET /api/v1/me/`, a wylogowanie
używa `POST /connect/revocation`; lokalny vault jest czyszczony także wtedy,
gdy zdalne revoke zwróci błąd. Transport obejmuje ścieżki launcherów
Windows/macOS/Linux.

Dowody zaakceptowane dla 6E:

- backend `LocalOpenIddict` + revocation targeted gates: **17/17** (PASS);
- backend build: PASS, bez ostrzeżeń;
- frontend targeted suite: **13/13** (PASS);
- scoped `flutter analyze`: PASS.

Pozostaje ręczna weryfikacja native login/callback/refresh/logout na każdym z
systemów Windows/macOS/Linux; nie jest ona jeszcze dowodem sukcesu. Real browser
E2E pozostaje celowo odroczone.

### 6E — macOS manual smoke status

Najnowszy macOS smoke potwierdził zaufany development certificate, discovery
backendu, aktywny native CTA oraz pracę loopback listenera. Dostarczenie adresu
`/connect/authorize` do przeglądarki kończy się jednak niepowodzeniem zarówno
przez `Process.open`, jak i `url_launcher`, mimo że samo uruchomienie launchera
raportuje sukces. W efekcie nie zweryfikowano auth callbacku, sesji, `me`,
refresh ani revocation.

Po próbie disposable runtime i baza zostały wyczyszczone. Browser E2E pozostaje
odroczone zgodnie z decyzją użytkownika, a desktop end-to-end jest zablokowane
konkretną usterką dostarczenia URL przez launcher; nie wolno oznaczać go jako
ukończonego. Wcześniejsze uruchomienie po HTTP nadal prawidłowo kończy się
OpenIddict `ID2083`; nie wyłączano TLS ani nie zmieniano keychain.

### Front post-4S — Web build

Niezależny frontendowy `flutter build web --debug --no-tree-shake-icons` po 4S
zakończył się PASS w **98.7 s**; `flutter analyze` również pozostaje PASS.

## 3. Stan otwarty

- Szerokie, dotąd nieuruchomione bramki HTTP/integration poza zaakceptowanymi
  zakresami oraz pełne E2E nadal wymagają osobnych fixture’ów i dowodów.
- Pozostają pełne E2E token/session/revoke/realtime oraz walidacja platform
  Windows, macOS i Linux. Web debug build jest już PASS (**98.7 s**).
- Projekt jako całość pozostaje nieukończony; powyższe akceptacje są zakresowe.

## 4. Reguła aktualizacji

Każda kolejna zaakceptowana zmiana musi zostać opisana jednocześnie w tym planie
i w handoffie, a następnie skopiowana do obu repozytoriów i sprawdzona:

```bash
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-plan.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-plan.md
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-handoff.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-handoff.md
```

Nie commituj i nie pushuj bez wyraźnej dyspozycji użytkownika.

### R1/B0 — bezpieczne przywrócenie kompozycji rootu Frontu

Pakiet jest **częściowo zintegrowany**. Przywrócono wyłącznie dwa odzyskane,
produkcyjne porty kompozycji wymagane przez aktywny `DevPlannerApp` i router:
`lib/workspaces/presentation/chat/global_chat_composition.dart` oraz
`lib/workspaces/presentation/notifications/global_notifications_composition.dart`.
Nie włączono placeholderowej strony Workspaces, pliku runtime oznaczonego
`partial` ani pozornej obsługi Web SignalR/BFF. Scoped `flutter analyze` dla obu
plików i `dart format --output=none` zakończyły się PASS, a
`git diff --check` zakończył się PASS.

Pakiet nie zamyka odbudowy Workspaces: istniejące zależności domenowe i
realtime nadal importują `package:ready_next` i wymagają osobnych, małych
pakietów migracji do `package:devplanner`. Szczegóły, hash stagingu i dowody są
w `Front/docs/recovery/R1-B0-root-integration-report.md`.

### R1/B1a — foundation surface error/l10n

Pakiet zakończono częściowym PASS dla aktywnych standalone importerów poza
legacy grafem Workspaces. Bez fizycznego przenoszenia plików skierowano
potwierdzone importery do istniejących powierzchni
`package:devplanner/foundation/error/error.dart` oraz
`package:devplanner/foundation/l10n/l10n.dart`, które zachowują ten sam typ i
rozszerzenie lokalizacji. Zmieniono 7 deklaracji error i 5 deklaracji l10n w
admin, me oraz odpowiadających testach. Scoped analyzer tych źródeł i testy
`api_error` + admin zakończyły się PASS; `git diff --check` i formatowanie także
PASS.

Nie zmieniano auth, theme, transportu, root/router/runtime, Chat, Notifications
ani realtime. Importery Workspaces i legacy `core/data`/`features/settings`
pozostawiono do osobnego pionu, ponieważ ich kontrakty nadal używają
`package:ready_next` i zamiana samego typu błędu powoduje niezgodność `Either`.
Szczegóły oraz liczniki są w
`Front/docs/recovery/R1-B1a-error-l10n-report.md`.

### 2026-09-18 — I4a: odporność startu desktopowej sesji PKCE

Ręczne uruchomienie macOS wykryło realną awarię: odrzucony wpis refresh tokenu
z macOS Keychain zwracał odpowiedź OIDC HTTP 400 przed `runApp`, przez co
natywne okno pozostawało czarne. Transport desktopowy rozpoznaje teraz 400/401
wyłącznie w żądaniu `grant_type=refresh_token` jako nieodtwarzalną lokalną
sesję, a adapter usuwa wtedy wpis Keychain. Błędy połączenia, TLS i 5xx nie są
kasowaniem sesji. Bootstrap fail-closed publikuje ekran logowania nawet przy
niespodziewanym błędzie odtwarzania, jednocześnie raportując go diagnostycznie.

Dowody: scoped `flutter analyze` czterech plików PASS, targeted auth suite
**8/8** PASS, `git diff --check` PASS oraz ręczny `flutter run -d macos`:
po restarcie wystąpił log odrzucenia starej sesji bez wyjątku, a interfejs
macOS udostępnił przycisk „Logowanie”. Szczegóły są w
`Front/docs/recovery/I4a-desktop-startup-session-recovery-report.md`.

Pakiet nie stanowi dowodu kompletnego desktop E2E login/callback/`/me`/logout
ani innych platform; te pozostają otwarte.

### 2026-09-18 — I5e/I5g: katalog Workspaces i standalone importy menu

Pakiety zostały niezależnie zaakceptowane dla
`lib/workspaces/presentation/workspaces_home/**`,
`workspaces/shared/helpers/workspace_icon_helper.dart` oraz niezbędnych
importerów dialogów zasobów projektu. Katalog, wyszukiwanie, drzewo,
hover i dialogi używają prywatnych `ValueNotifier`ów z jawnym `dispose`, bez
`setState`/`StatefulBuilder`/`setDialogState`; produkcyjne pliki Workspaces
Home nie przekraczają 366 linii. Dotychczasowe top-level entrypointy dialogów
zastąpiono statycznym API klas dialogów. Stare importy `ready_next` zastąpiono
istniejącymi kontraktami `devplanner`, a usunięty router zastąpiono
`DevPlannerNavigation`, bez aliasu kompatybilności.

Regresja wykryta w niezależnym review została naprawiona: menu projektów
pokazuje `backendCode`, a gdy go nie ma — `statusCode` HTTP, więc komunikat
z kodem `503` nie znika. Dowody odbioru root: scoped analyzer PASS, pełne
widget tests Workspaces Home PASS **4/4**, Cubit tests PASS **8/8**, brak
starego stanu/importów oraz plików >400 i `git diff --check` PASS. Raporty:
`Front/docs/recovery/I5e-workspaces-home-local-state-report.md` oraz
`I5g-workspaces-home-import-unblock-report.md`. Nie jest to desktopowe E2E.

### 2026-09-18 — I5a: Kanban bez `setState` i god Cubitu

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/tasks/board/**`. Lokalny stan interakcji korzysta
z prywatnych `ValueNotifier`ów i obserwatorów, bez `setState`. `TasksBoardCubit`
ma teraz 166 linii i jest cienką fasadą; odpowiedzialności realnie rozdzielono
na zwykłe, nazwane klasy: runtime/realtime, komendy kart, preferencje oraz
operacje bulk. Nie użyto `part` ani mixinów do ukrycia jednego god objectu.
Wszystkie pliki Kanbanu mieszczą się w limicie 400 linii.

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/tasks/board --reporter compact`
PASS **85/85**, `flutter test .../tasks_board_cubit_test.dart` PASS **24/24**,
brak `setState`/`StatefulBuilder`/`setDialogState`, brak plików >400 i
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5a-task-board-local-state-report.md`. Pakiet nie jest
desktopowym E2E z backendem ani nie zastępuje aktywnego routingu.

### 2026-09-18 — I5b: lista zadań bez `setState` i plików ponad 400 linii

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/tasks/list/**`. Lokalny stan edycji, hover,
pickerów i arkuszy korzysta z prywatnych `ValueNotifier`ów oraz
`ValueListenableBuilder`/`AnimatedBuilder`, z jawnym `dispose`. Rozdzielono
tytuł/akcje komórki, picker czasu, arkusz kolumn i odpowiedzialności
`TaskListPreferencesCubit` (ładowanie, polityka projektu, sort), bez zmian
kontraktów API czy routingu. Wszystkie pliki w katalogu mieszczą się w limicie
400 linii.

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/tasks/list --reporter compact`
PASS **120/120**, brak `setState`/`StatefulBuilder`/`setDialogState`, brak
plików >400 oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5b-task-list-local-state-report.md`. Zakres nie jest
zastępstwem desktopowego E2E z backendem.

### 2026-09-18 — I5d: pliki i dokumenty bez `setState`

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/storage/**`. Lokalny stan interakcji Storage
używa prywatnych `ValueNotifier`ów i obserwatorów, a operacje OnlyOffice
przeniesiono do `StorageOfficeEditorActionsCubit` z niemutowalnym stanem.
Podzielono dialog Office i shell przeglądarki; żaden plik Storage nie
przekracza 400 linii. Zakres nie odtwarza placeholderów i nie zmienia
kontraktów backendu.

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/storage --reporter compact` PASS
**96/96**, brak `setState`/`StatefulBuilder`/`setDialogState`, brak
`package:ready_next` w produkcyjnych i bezpośrednich testach Storage, brak
plików >400 oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5d-storage-local-state-report.md`. Pakiet nie jest
desktopowym E2E z działającym backendem i OnlyOffice.

### 2026-09-18 — I5c: szczegóły zadania bez `setState`

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/tasks/detail/**`. Wszystkie lokalne formularze,
hover i drag-and-drop używają prywatnych `ValueNotifier`ów oraz
`ValueListenableBuilder`/`AnimatedBuilder`, z jawnym `dispose`. Operacje
odczytu i zapisu pozostają w wyspecjalizowanych Cubitach/repozytoriach.
Wydzielono `task_details_dependency_fields.dart`, aby żaden plik tego pionu
nie przekraczał 400 linii (największy ma 394).

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/tasks/detail --reporter compact`
PASS **24/24**, brak `setState`, brak plików >400 i `git diff --check` PASS.
Raport kontynuacyjny:
`Front/docs/recovery/I5c-task-detail-local-state-report.md`. Pakiet nie
dowodzi desktopowego E2E z backendem.

### 2026-09-18 — I4b–I4f: porządkowanie pionu powiadomień i lokalnego stanu shellu

To jest pakiet **częściowo zaakceptowany**, a nie zakończenie Chat ani
powiadomień. Przywrócono spójne nazewnictwo standalone w aktywnych kontraktach
powiadomień (`userId`, `recipientUserId`), zregenerowano typowane artefakty
Freezed/JSON/Retrofit oraz usunięto importy `ready_next` z warstw data/domain/
presentation powiadomień, gdy istnieje bezpośredni odpowiednik `devplanner`.
Scoped analyzer tych trzech warstw jest PASS, a test repozytoriów ustawień
powiadomień jest PASS **7/7**. Pełne drzewo testów data/domain/presentation
powiadomień jest PASS **46/46**; nie jest to jeszcze desktopowe E2E z backendem.

W prezentacji powiadomień użyto istniejącego
`DevPlannerModalHost` oraz standalone `DevPlannerNavigation`; nie odtworzono
starego `AppModalHost`, `AppRouter` ani Core deeplinków. Lokalny wybór trybu
odpowiedzi oraz zwijanie sidebara shellu używają prywatnych `ValueNotifier`
i `ValueListenableBuilder`, z jawnym `dispose`; w tym zakresie nie ma
`setState`. Żaden widget objęty pakietem nie przekracza 400 linii.

Chat pozostaje świadomie poza aktywnym routingiem: ma być później globalnym
overlayem po prawej stronie, a nie ekranem. W jego legacy UI nadal występują
trzy wcześniejsze użycia `setState`, których nie wolno kopiować do nowej
kompozycji. Pełny test pionu powiadomień i integracja globalnego overlayu są
otwarte do czasu domknięcia realtime oraz kompozycji shellu. Raporty zakresowe:
`I4b-chat-import-migration-report.md`,
`I4c-notifications-import-migration-report.md`,
`I4c-identity-terminology-repair-report.md`,
`I4d-shell-local-state-report.md` oraz
`I4e-notifications-test-imports-report.md`; realtime ma osobny raport
`I4f-notifications-realtime-import-migration-report.md` w
`Front/docs/recovery/`.

### 2026-09-18 — I4h: build i smoke test macOS

`flutter build macos --debug` jest PASS, a świeże `DevPlanner.app` renderuje
natywny ekran logowania zamiast wcześniejszego czarnego/pustego okna. Widoczny
w trakcie smoke testu komunikat nieudanego logowania nie jest maskowany ani
uznawany za E2E; wymaga osobnej weryfikacji z działającym backendem i ręcznie
wprowadzonymi przez użytkownika danymi. Szczegóły:
`Front/docs/recovery/I4h-macos-build-smoke-report.md`.

Pełne `flutter analyze --machine` po tym pakiecie zwróciło
`ERROR=0 WARNING=0 INFO=0`. Jest to bramka kompilacyjna, nie zwalnia jednak
z migracji **322 odziedziczonych** użyć `setState`; pierwsze trzy izolowane
pakiety obejmują kolejno Kanban, listę i szczegóły zadań.

### 2026-09-18 — I5h: dialogi tworzenia zasobów projektu

Pakiet `lib/workspaces/presentation/projects/dialogs/**` został niezależnie
zaakceptowany. Monolit dialogów tworzenia projektu, Whiteboardu, zadania,
strony Wiki, karty Corkboard i folderu zastąpiono klasową fasadą
`ProjectResourceCreationDialogs`, sześcioma niezależnymi formularzami oraz
małymi, nazwanymi Cubitami komend o niemutowalnym stanie. Wywołania repozytoriów
nie pozostają w UI; lokalne kontrolki używają prywatnych `ValueNotifier`ów i
mają `dispose`. Jedyny konieczny caller — menu projektów — korzysta z sześciu
metod statycznych fasady; nie zmieniono jego pozostałego UI ani routingu.

Odbiór rootu: scoped `flutter analyze` PASS; testy Cubitów komend **7/7** i
test menu **3/3** PASS; brak `setState`/`StatefulBuilder`/`setDialogState`,
brak importów `ready_next`, `core` i `http`, brak plików >400 linii (maks. 358)
oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5h-project-dialogs-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5f: ustawienia projektu bez lokalnego `setState`

Pakiet `lib/workspaces/presentation/projects/settings/**` został niezależnie
zaakceptowany. Modal ustawień podzielono na ramę, katalog zakładek, renderer
aktywnej zakładki oraz jawny registry composition/lifecycle dla lazy Cubitów.
Formularze pól własnych, szablony, członkowie, workflow, kamienie milowe,
etykiety, automatyzacje i centrum użytkownika zachowują funkcje, a operacje
asynchroniczne zostają w wyspecjalizowanych Cubitach. Globalne entrypointy
modalów zastąpiły klasowe fasady `ProjectSettingsDialogs` i
`ProjectUserHubDialogs`.

Odbiór rootu: scoped `flutter analyze` PASS; test modalów **4/4** PASS; brak
`setState`/`StatefulBuilder`/`setDialogState`, brak globalnych entrypointów
modalów, brak importów `ready_next` i zewnętrznego `http`, brak plików >400 linii
(maks. 388) oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5f-project-settings-local-state-report.md`. Pakiet nie
jest desktopowym E2E z działającym backendem.

### 2026-09-18 — I5j: ustawienia przestrzeni standalone

Pakiet `lib/workspaces/presentation/workspaces_settings/**` został niezależnie
zaakceptowany. Wszystkie importy `ready_next` zastąpiono bezpośrednimi
odpowiednikami `devplanner`; wyszukiwanie i zaproszenia używają lokalnego
katalogu użytkowników (`LocalUserDirectoryResponse`, `userId`), a nie Ready.
Zachowano ustawienia ogólne, członków, zaproszenia i preferencje powiadomień.
Lokalny stan formularzy ma lifecycle `ValueNotifier`, a spóźnione odpowiedzi
wyszukiwania zaproszeń są odrzucane.

Odbiór rootu: scoped `flutter analyze` PASS; test lokalnego katalogu
zaproszeń **1/1** PASS; brak `setState`/`StatefulBuilder`/`setDialogState`,
brak importów `ready_next` i zewnętrznego `http`, brak plików >400 linii
(maks. 389) oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5j-workspace-settings-local-state-report.md`. Brakuje
desktopowego E2E z działającym backendem.

### 2026-09-18 — I5i: recurrence z neutralnym stanem Cubita

Pakiet `lib/workspaces/presentation/tasks/recurrence/**` został niezależnie
zaakceptowany. Edytor, arkusz, historia i karty reguł zachowują tworzenie,
edycję, zapis, pauzę/wznowienie, usuwanie, natychmiastowe wykonanie i refresh.
UI-local state używa `ValueNotifier`ów, a pliki `part` zastąpiono zwykłymi
małymi widgetami. Launcher, formatter oraz mapper odpowiedzi są API klasowymi.
`TaskRecurrenceEditorCubit` i jego stan nie zależą od Flutter Material:
neutralny `TaskRecurrenceScheduledTime` chroni logikę UTC, a konwersja do
pickera pozostaje wyłącznie w UI.

Odbiór rootu: scoped `flutter analyze` PASS, testy recurrence **11/11** PASS
(w tym regresja czasu UTC), brak `setState`/`StatefulBuilder`/`setDialogState`,
`part`, globalnych helperów i Material UI w Cubicie/stanie, brak plików >400
linii (maks. 364) oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5i-task-recurrence-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5k: zapisane widoki zadań bez `setState`

Pakiet `lib/workspaces/presentation/tasks/views/**` został niezależnie
zaakceptowany. Zachowano tworzenie, konfigurację, wybór, zmianę nazwy,
nadpisanie i usuwanie zapisanych widoków oraz obsługę konfliktu wersji 409.
Dialogi lokalnego stanu używają prywatnych `ValueNotifier`ów z `dispose`, a
menu rozbito o mały listener informacji zwrotnej; nie dodano globalnych helperów
ani legacy transportu.

Odbiór rootu: scoped `flutter analyze` PASS, testy **12/12** PASS, brak
`setState`/`StatefulBuilder`/`setDialogState`, importów `ready_next` i
zewnętrznego `http`/`dio`, brak plików >400 linii (maks. 383) oraz
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5k-task-saved-views-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5l: prywatne zadania bez logiki repozytorium w UI

Pakiet `lib/workspaces/presentation/private/**` został niezależnie
zaakceptowany. Odczyt, mapowanie i stronicowanie prywatnych zadań należą do
`PersonalSectionCubit`, a filtry są niemutowalne. Dialog i strona używają
lokalnego `ValueNotifier`a z lifecycle, istniejącego hosta pickerów oraz portu
nawigacji; UI nie wykonuje już odczytu repozytorium.

Odbiór rootu: scoped `flutter analyze` PASS, testy **5/5** PASS (brak
kontraktu, sukces, błąd, cursor i filtry), brak
`setState`/`StatefulBuilder`/`setDialogState`, importów `ready_next` i
zewnętrznego `http`/`dio`, brak plików >400 linii (maks. 346) oraz
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5l-private-tasks-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5m: profil i bezpieczeństwo sesji bez `setState`

Pakiet `lib/me/presentation/**` został niezależnie zaakceptowany. Rozbito
profil na komponenty danych osobowych, hasła, sesji i uprawnień; zachowano
edycję nazwy, awatar, zmianę hasła, unieważnienie sesji i kontrolę uprawnień.
Operacje pozostają w Cubitach oraz `MeGateway`, a lokalny stan formularzy ma
prywatny lifecycle `ValueNotifier`; nie ma plików `part` ani globalnych helperów.

Odbiór rootu: scoped `flutter analyze` PASS i testy `test/me` **34/34** PASS,
w tym zmiana hasła, sesje oraz błędy adaptera API. Brak
`setState`/`StatefulBuilder`/`setDialogState`, importów `ready_next` i
zewnętrznego `http`/`dio`, brak plików >400 linii (maks. 397) oraz
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5m-profile-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — R2a/R2b: importy realtime czatu i shellu Workspaces

Niezależnie odebrano dwa pakiety migracji standalone. R2a usuwa `ready_next`
z realtime czatu i zachowuje SignalR, replay, deduplikację oraz typowane błędy;
kontrakt autora używa `authorUserId`. R2b usuwa legacy importy z shellu,
routingu i menu Workspaces, korzystając z `DevPlannerNavigation`,
`DevPlannerPanelsScope` i `AuthSessionPort`; zachowane są ścieżki zasobów,
Resource Chat oraz dostępność menu po zwinięciu.

Odbiór rootu: R2a scoped analyzer PASS i realtime **11/11** PASS; R2b scoped
analyzer PASS i testy menu **3/3** PASS. W obu zakresach brak `ready_next`,
zewnętrznego `http`/`dio` i plików >400 oraz `git diff --check` PASS. Raporty:
`R2a-chat-realtime-import-repair-report.md` i
`R2b-workspaces-shell-routing-import-repair-report.md` w `Front/docs/recovery/`.
Nie jest to zamknięcie globalnego Chat/Notifications ani desktopowe E2E.

### 2026-09-18 — T1/T2: odtworzenie kontraktów testowych standalone

Testy pozostałe po usunięciu `ready_next` zostały dopasowane do aktualnego
kontraktu DevPlanner, bez cofania produkcyjnej kompozycji. Obejmuje to bootstrap
i root aplikacji, router (powiadomienia nie są osobną trasą), User Hub projektu
oraz adapter uploadu załączników Chat. Zachowane są scenariusze sesji,
przekierowania fail-closed, preferencji projektu, opuszczenia projektu, ticketu,
uploadu, finalizacji i statusów skanowania pliku.

Odbiór rootu: `flutter analyze lib` PASS; shell **4/4**, User Hub **6/6**,
upload Chat **9/9**, router **3/3**, bootstrap/root **5/5** PASS oraz
`git diff --check` PASS. Raporty: `T1-bootstrap-app-tests-repair-report.md`,
`T2a-notifications-router-test-repair-report.md`,
`T2b-chat-attachment-upload-port-adapter-test-repair-report.md` i
`T2c-project-user-hub-test-import-repair-report.md` w `Front/docs/recovery/`.
Nie jest to pełne uruchomienie całej suite ani desktopowe E2E z backendem.

### 2026-09-18 — T3: kontrakty Chat i realtime po usunięciu legacy

Zaktualizowano pozostałe testy Chat/realtime po migracji namespace do
`devplanner`. Nie przywrócono modeli `ready_next`: kontrakty korzystają z
`authorUserId` i aktualnych adapterów. Zachowano serializację załączników,
repozytorium rozmów, reducer z deduplikacją/replayem, SignalR workspace oraz
Resource Chat pliku przez `DevPlannerPanelsScope`, bez osobnej trasy Chat.

Odbiór rootu: analyzer wszystkich zmienionych testów PASS; Chat/realtime data
**42/42** PASS, reducer **6/6** PASS, Resource Chat pliku **6/6** PASS,
`rg "package:ready_next/" test` nie zwraca wyników i `git diff --check` PASS.
Raporty: `T3a-chat-attachment-transport-contract-test-repair-report.md`,
`T3b-chat-repository-impl-test-repair-report.md` i
`T3c-workspace-realtime-tests-repair-report.md` w `Front/docs/recovery/`.
Nie jest to pełna suite, globalny panel Chat/Powiadomienia ani desktopowe E2E.

### 2026-09-18 — I6: Chat presentation bez `setState` i plików >400 linii

Rozbito ekran rozmowy, composer i panel rozmowy na małe komponenty o jasnej
odpowiedzialności: historię wiadomości, pola composera, elementy panelu oraz
lokalny wybór paneli. Stan odpowiedzi, wątku, dyskusji i drag-and-drop używa
prywatnych `ValueNotifier`ów z `dispose`; Cubity nadal wykonują wyłącznie
logikę rozmowy i załączników. Zachowano Resource Chat przez
`DevPlannerPanelsScope`, SignalR, deep link do wiadomości, Quill oraz blokadę
wysyłki podczas skanowania załączników.

Odbiór rootu: `flutter analyze lib/workspaces/presentation/chat` PASS, brak
`setState`/`StatefulBuilder`/`setDialogState`, brak plików >400 linii oraz
`git diff --check` PASS. Suite Chat **80/80** PASS; po ostatniej zmianie
kontrolek załączników testy wpływu **14/14** PASS. Nie jest to jeszcze
zamknięty globalny overlay Chat/Powiadomienia ani desktopowe E2E. `flutter
build macos --debug` PASS; pozostaje nieblokujące ostrzeżenie o przyszłym SPM
dla `media_kit_libs_macos_video` i `media_kit_video`.

### 2026-09-18 — I7: session-scoped globalny overlay Chat i Powiadomienia

Dodano jeden host `app/shell/overlays/devplanner_global_panels_host.dart`,
który renderuje panele po prawej stronie pod belką 64 px, nad aktywną trasą.
Nie powstaje osobna trasa Chat ani Notifications. Host zachowuje ekran,
scroll i formularze pod overlayem, obsługuje barrier, klawisz Escape oraz
przywrócenie poprzedniego focusu. Belka shellu wywołuje wyłącznie
`DevPlannerPanelsController` przez scope — nie zna HTTP, sesji ani Cubitów.

`DevPlannerApp` składa sesyjny `DevPlannerStandaloneRuntime` i przekazuje do
hosta jawne porty REST/realtime. `ChatRepositoryImpl` implementuje teraz
również kontrakt szczegółu rozmowy i Resource Chat pliku: zachowuje cursor,
Delta Quill, reply, załączniki oraz autoryzowany scope pliku. Brak kompozycji
sesji pokazuje jawny stan niedostępności, nigdy pusty panel. Wszystkie zależności
composera i SignalR są providerami composition rootu; UI nie tworzy klienta API.
Klucz prywatnych draftów został również przemianowany z historycznego prefiksu
`ready_next` na `devplanner`; zgodnie z decyzją projektu nie migrujemy lokalnych
danych po usuniętym produkcie.

Odbiór pakietu: analyzer zakresu PASS; adapter Chat **8/8**, host overlay
**2/2** (w tym provider Resource Chat dla aktywnej trasy), shell **4/4**, root
**3/3**, powiadomienia **1/1** — razem **18/18**
PASS. `git diff --check` PASS, `flutter build macos --debug` PASS. Pozostaje
nieblokujące ostrzeżenie Fluttera o przyszłym SPM dla `media_kit_libs_macos_video`
i `media_kit_video`. Nadal nie jest to manualne desktopowe E2E z lokalnym backendem.
Po końcowej korekcie scope Resource Chat pełny zakres presentation Chat przeszedł
**80/80**, a osobny zakres data Chat/realtime, reducer, Notifications i app/router
**117/117**. `flutter analyze lib`, synchronizacja obu dokumentów oraz skan braku
runtime `ready_next`/Ready/Core/DataBus w `lib` i `test` są PASS.
Kontrola uruchomienia ręcznego potwierdziła render ekranu logowania. README
opisuje kanoniczne uruchomienie desktopu z `https://localhost:5173`; test
logowania, `/me`, Chat/SignalR i logout nadal wymaga przejścia przez realną
sesję lokalnego użytkownika.

Podczas rzeczywistego kliknięcia panelu Chat wykryto i naprawiono błąd composera
DI: `AuthSessionPort` rozszerza `Listenable`, dlatego host używa
`ListenableProvider<AuthSessionPort>`, a nie `RepositoryProvider`. Zmiana
eliminuje czerwony ekran Provider przy otwieraniu globalnego Chatu.

Kolejna kontrola desktopowa ujawniła brak `Overlay` nad panelem zbudowanym w
`MaterialApp.router.builder`: tooltipy wewnątrz Chatu nie miały swojego
przodka `Overlay`. Host utrzymuje teraz jeden trwały `OverlayEntry` i w nim
renderuje zarówno trasę, jak i panele. Rzeczywisty klik Chat po tej korekcie
pokazał prawy panel „Brak rozmów” i jego zamknięcie bez czerwonego ekranu.
Test hosta i root aplikacji są PASS po korekcie.

Kontrola Powiadomień otwiera prawidłowy prawy panel, ale lokalny backend
zwraca błąd 500 podczas pobrania inboxa. Lokalna baza na porcie 5440 ma
zastosowaną ostatnią migrację `20260917100000_EnsureAutomationRuleArchiveColumn`,
a izolowane testy `NotificationServiceTests` są **41/41 PASS**. Nie wolno
maskować tego stanu w UI ani uznać E2E powiadomień za zakończone: pozostaje
odtworzenie autoryzowanego żądania do działającego procesu backendu i usunięcie
przyczyny 500.

### 2026-09-18 — I8: naprawa PostgreSQL inboxa powiadomień

Usunięto rzeczywistą przyczynę 500 w `GET /api/v1/notifications/groups`.
`NotificationService.ListGroupsAsync` budował prywatny rekord `GroupSummary`
przed sortowaniem; provider Npgsql nie tłumaczy `OrderBy` po takim
konstruktorze. Filtry i sortowanie odbywają się teraz na encji
`WorkspaceNotificationGroup`, a `GroupSummary` powstaje dopiero po
materializacji strony. Nie ma eval po stronie klienta przed `Take`, nie zmienia
to uprawnień Chat ani cursorowego kontraktu API.

Dodano test PostgreSQL `PostgresGroupListReturnsEmptyInboxWithoutServerError`.
Test razem z filtrowaniem kategorii jest **2/2 PASS**. Rzeczywiste,
autoryzowane żądanie desktopowego tokenu po restarcie lokalnego backendu
zwraca: `/notifications/unread-count`, `/notifications/` i
`/notifications/groups` — wszystkie **200**, a oba listujące endpointy mają
`items: []`. Backend uruchomiono ponownie przez
`start-desktop-auth-local.sh`; nie wykonano migracji ani nie zmieniono danych.
Końcowa kontrola po naprawie: backendowy zakres Notifications **44/44 PASS**;
frontend `flutter analyze lib` PASS, a testy root/overlay **5/5 PASS**.

### 2026-09-18 — L1: lokalny fixture do odbioru pionu Workspace/Tasks

Lokalna baza, wcześniej pusta z założenia projektu, otrzymała jawny fixture
odbiorowy: workspace `DevPlanner`, projekt `Planer` oraz zadanie `Pierwsze
zadanie` z jedną checklistą. Dane są własnością lokalnego konta administratora
i służą do wejścia w rzeczywiste drzewo menu, Tasks i Kanban; nie są atrapą
frontendową ani migracją starych danych. Rzeczywiste żądania lokalnym tokenem
potwierdziły: create workspace **201**, create project **201**, create task
**201**, lista zadań **200** z jedną pozycją oraz grupy Kanban **200** z
sześcioma workflow groups. Fixture zachować do desktopowego smoke testu, chyba
że użytkownik świadomie zdecyduje o jego usunięciu.

### 2026-09-18 — L2: trwałe klucze lokalnej sesji desktopowej

W `.env.local` ustawiono `DEVPLANNER_DATA_PROTECTION_KEYS_PATH` na lokalny
katalog poza repozytorium. Katalog ma uprawnienia właściciela `0700`; backend
po restarcie zapisał w nim pierwszy klucz. Eliminuje to efemeryczny key ring,
który po restarcie unieważniał możliwość odczytu refresh tokenów desktopowego
PKCE. Zmiana istniejącego key ringu wymusza jednorazowe ponowne logowanie i
odrzuca stare cookie formularza/CSRF — jest to oczekiwane i nie jest błędem
aplikacji. W środowisku wdrożeniowym klucze muszą nadal być szyfrowane przez
mechanizm hosta; lokalny katalog nie może być kopiowany do repozytorium.

### 2026-09-18 — R2a: kanoniczny deep link Tasks/Kanban

Aktywny router zachowuje teraz query w bezpiecznej lokalizacji startowej;
`?view=kanban` nie znika już przy restarcie desktopowej aplikacji. Dodano też
jawne przekierowanie historycznego adresu
`/workspaces/{workspaceId}/projects/{projectId}/kanban` do jedynej kanonicznej
trasy `.../tasks?view=kanban`, a historyczny adres samego projektu do jego
rzeczywistej listy `.../tasks`. Nie tworzono drugiego widoku Kanbanu ani
pustego dashboardu projektu; nie zmieniano kontraktów HTTP, Cubitów i
providerów — oba widoki nadal korzystają z jednego rzeczywistego composition
rootu Tasks.

Dodano także rzeczywistą trasę `/workspaces/{workspaceId}`. Karta workspace
prowadzi do istniejącego katalogu projektów zasilanego przez `ProjectsGateway`,
a kliknięcie projektu prowadzi do kanonicznej listy Tasks. UI przekazuje tylko
intencję nawigacji; pobranie projektów pozostaje w małym `WorkspaceProjectsCubit`.
Błędny UUID lub brak bramy pokazuje jawny komunikat i nie wykonuje żądania.

Dowód: `flutter test test/app/router/devplanner_root_router_compile_test.dart`
**13/13 PASS**, w tym test query po restarcie, przekierowania legacy oraz
przejście karta workspace → katalog projektów → Tasks;
`flutter analyze lib/app/router/devplanner_router.dart
test/app/router/devplanner_root_router_compile_test.dart` PASS oraz
`git diff --check` PASS. Jest to wyłącznie naprawa routingu R2, nie dowód
pełnego ręcznego desktopowego scenariusza Tasks/Kanban.

### 2026-09-18 — R2b: przywrócenie Plików projektu

`StorageScope.project` i jego URL istniały w domenie, lecz aktywne drzewo
projektu nie wystawiało pozycji Pliki, a router nie składał jej rzeczywistego
widoku. Przywrócono węzeł `Pliki` pod każdym projektem oraz trasę
`/workspaces/{workspaceId}/projects/{projectId}/files`. Trasa waliduje oba
UUID i przekazuje do istniejącego `StorageReadOnlyBrowserPage` dokładnie
`StorageScope.project(workspaceId, projectId)`. Współdzieli repository,
upload/download i egzekwowanie ACL z plikami workspace'u; nie zawiera mocka,
nowego klienta HTTP ani placeholdera. Błędny identyfikator pozostaje jawnym
stanem niedostępności.

Dowód: routerowy test Storage potwierdza odczyt z zakresem projektu, test
menu klika nowy węzeł i sprawdza jego kanoniczny URL; po zmianie zestaw
`router + navigation tree + scope codec` ma **22/22 PASS**. `flutter analyze
lib` oraz `git diff --check` są PASS. Nadal brakuje ręcznego desktopowego
scenariusza upload/download z MinIO; nie oznaczono go jako zakończonego.

### 2026-09-18 — R2c: przywrócenie „Moich plików”

Katalog tras zawierał `DevPlannerRouteCatalog.myFiles`, ale router i pozycja
`personalFiles` w sidebarze nie prowadziły do żadnego aktywnego widoku.
Dodano trasę `/me/files` z istniejącym `StorageReadOnlyBrowserPage` i
`StorageScope.personal`, a pozycja „Moje pliki” w drzewie nawigacji prowadzi
do tego URL. Nie ma dostępu HTTP w menu: menu przekazuje wyłącznie lokalizację,
a Storage zachowuje pojedynczą kompozycję repository oraz swoje stany błędów.

Dowód: test bezpośredniej trasy sprawdza `StorageScope.personal`, a test
sidebaru klika „Moje pliki” i sprawdza `/me/files`. Po zmianie zestaw
`router + navigation tree + scope codec` ma **23/23 PASS**; `flutter analyze
lib`, `git diff --check` i synchronizacja czterech dzienników są PASS.
Ręczny test desktopowy prywatnych uploadów nadal pozostaje do wykonania.

### 2026-09-18 — R2d: uczciwy dowód Storage i gotowość usług

Zweryfikowano lokalne usługi bez sesji użytkownika: MinIO
`/minio/health/live`, Backend `/health/live` i `/health/ready` zwracają
**200**, a Swagger lokalnego Backend jest dostępny. To jest dowód gotowości
infrastruktury, nie dowód uploadu wykonanego przez Flutter.

Skorygowano mylącą nazwę testu `StorageHttpTests`: wykorzystywał on
`IStorageService` w pamięci, a nie MinIO, choć nazywał się „RealMinIo”. Jest
teraz `StorageLifecycleFullPipelineWithHermeticStorageAndVerificationWorksCorrectly`,
a adapter testowy nosi nazwę `InMemoryStorageService` i ma polski komentarz
zakazujący traktowania go jako dowodu S3. Test po przebudowie **1/1 PASS**.
Prawdziwy upload/pobranie w UI nadal wymaga osobnego desktopowego smoke testu
z zalogowaną sesją — nie został ukryty przez test hermetyczny.

### 2026-09-18 — R2e: odzyskanie pełnego drzewa dawnego Workspace w nowym shellu

Po potwierdzeniu, że uproszczony shell nie spełniał wymogu zachowania menu
Workspace, `WorkspaceNavigationTree` otrzymało pełne poddrzewo projektu:
`Zadania → Lista/Kanban/Automatyzacje`, `Whiteboardy`, `Tablica korkowa`,
`Wiki` i `Pliki projektu`. Workspace zachowuje `Pliki workspace'u` i gałąź
`Projekty`, a katalog zachowuje Przegląd, zadania/pliki osobiste oraz realne
workspace'y. Chat i Powiadomienia pozostają globalnymi overlayami, bez trasy.

Shell nie renderuje już wszystkich dzieci stale. Właściciel shella trzyma
lokalny, niemutowalny `ValueNotifier<Set<String>>` tylko dla rozwiniętych
gałęzi; nie ma `setState`, globalnego Cubita ani logiki danych w UI. Węzły
rozwijają się chevronem, a przodkowie bieżącej trasy rozwijają się automatycznie.
Shell zachowuje pełny URI razem z query, więc `?view=kanban` zaznacza Kanban,
a nie ogólną Listę.
Rozbito wiersz drzewa do osobnego małego pliku; żaden widget nie przekracza
400 linii. Wszystkie widoczne tooltipy są w ARB.

Aktywne są wyłącznie realne piony i URL-e: Workspace/Projects, Lista Tasks,
Kanban jako `?view=kanban` oraz osobiste/workspace/project Files. Whiteboardy,
Wiki, Corkboard i Automatyzacje są widoczne jako odzyskana hierarchia, lecz
celowo nie mają fałszywej trasy ani placeholdera — ich pełny pion wymaga
oddzielnego typed gateway, Cubita, page, ACL i testów. Pełna mapa źródeł,
statusów i kolejności prac jest w repozytorium `Front`:
`docs/recovery/legacy-workspace-menu-map.md`.

Odbiór: `flutter test` dla routera, shella, drzewa i tokenów theme **29/29
PASS**; `flutter analyze lib` PASS; `git diff --check` PASS. Jest to odbiór
struktury i routingu, nie deklaracja ukończenia Whiteboard/Wiki/Corkboard/
Automatyzacji ani ręcznego desktopowego smoke testu Storage.

### 2026-09-18 — R2f: przywrócenie osobistych zadań

Dodano rzeczywistą trasę `/me/tasks` i pozycja „Zadania” w globalnym drzewie
prowadzi teraz do niej, a nie jest martwym wpisem. Router przyjmuje osobny,
typowany `TaskViewRepository`; produkcyjnie składa go z lokalnego transportu
do potwierdzonego endpointu `/api/v1/me/tasks`. Nie zależy od Kanbanu ani
SignalR. Wstrzyknięcie jawnego repozytorium pozwala testować router bez sieci.

Trasa wykorzystuje odzyskany `PersonalSectionCubit`: cursor, filtry,
stronicowanie, retry i link do szczegółu zadania pozostają w istniejących,
małych klasach. UI wykonuje tylko rendering i intencje, a jego bezpośrednie
importy `core` zostały zastąpione `foundation`. Adapter `TaskViewRepository`
nadal korzysta z historycznej osłony błędów `core`; jest to jawny dług migracji
warstwy data, nie zgoda na przywrócenie Core do routera/UI.

Odbiór: targeted analyzer PASS; test routera razem z trasami Workspace,
Tasks/Kanban i Files **21/21 PASS**. Nie uruchamiano aplikacji ani podglądu
GUI. Ręczny odbiór lokalnego desktopu pozostaje etapem stagingu.

### 2026-09-18 — R2g: zamknięcie zakresu odzyskania Workspace

Po doprecyzowaniu zakresu nie wolno budować nowych pionów, których dawny
Workspace nie dostarczał w gotowej postaci. Usunięto pięć niepodpiętych plików
rozpoczynających nowy pion Whiteboards (model domenowy, port, adapter i Cubit).
Nie zmieniły routingu, drzewa ani istniejącej funkcjonalności.

Do odbioru przywrócenia pozostają wyłącznie: rozwijane menu Workspace, pliki
(osobiste, workspace i projektowe), Tasks z listą i Kanbanem oraz istniejące
globalne panele Chat i Powiadomień. Whiteboardy, Wiki, Tablica korkowa i
Automatyzacje pozostają widocznymi, nieaktywnymi pozycjami odzyskanego menu;
nie wolno dla nich tworzyć ekranów, placeholderów ani klientów API bez nowej,
wyraźnej decyzji produktowej.

Odbiór po korekcie: **35/35 PASS** dla routera, shella, menu, zadań osobistych
i tokenów theme; `flutter analyze lib` PASS. Dodatkowy odbiór istniejących
pionów: **39/39 PASS** dla globalnych paneli, Powiadomień, listy/Kanbanu,
odczytu, uploadu i tworzenia folderu w Files. Nie uruchamiano aplikacji ani GUI.

### 2026-09-18 — R2h: aktualizacja macierzy parity do rzeczywistego grafu

`docs/recovery/feature-parity.md` otrzymał nadrzędny snapshot R2g. Historyczne
wpisy R0/R1 pozostają materiałem do odzyskania źródeł, ale nie mogą już
fałszywie opisywać aktywnego routera jako zbioru placeholderów. Snapshot
potwierdza aktualne trasy katalogu, projektów, listy/Kanbanu, szczegółu taska
oraz plików; potwierdza też Chat i Powiadomienia jako globalne overlaye bez
tras. Whiteboards, Wiki, Corkboard i OKR są jasno oznaczone jako nieaktywne
pozycje menu, bez dopisywania nowych pionów.

Do macierzy wpisano wyłącznie aktualne, automatyczne dowody: testy szczegółu
Taska, Chat i Powiadomień **27/27 PASS**, obok wcześniejszych pakietów 35/35
i 39/39 oraz `flutter analyze lib` PASS. Status `live` pozostaje `NIE` dla
każdego pionu — nie uruchomiono GUI ani desktopowego API, bo odbiór odbywa się
na stagingu. Pełny `flutter test` został przerwany po przekroczeniu limitu
obserwowanego procesu i nie jest raportowany jako wynik.

### 2026-09-18 — R2i: rozdzielenie logiki mutacji Powiadomień

`NotificationsCubit` został rozdzielony bez zmiany kontraktu UI lub API.
Nowa klasa `presentation/notifications/cubit/notifications_inbox_mutation_reducer.dart`
zawiera wyłącznie czyste, optymistyczne transformacje inboxa: odczyt,
archiwizację, pin oraz scalanie stron listy. Cubit pozostaje właścicielem I/O,
kolejki mutacji, rollbacku, błędów, cursorów i lifecycle realtime. Nie ma
`BuildContext`, routera ani I/O w reduktorze.

Po formacie Cubit ma 398 linii, reduktor 186 linii; oba mieszczą się w limicie
400. Odbiór: `notifications_cubit_test.dart`, `global_notifications_page_test.dart`
i `notification_reply_cubit_test.dart` **20/20 PASS**; analyzer katalogu
Powiadomień PASS. Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2j: podział modalu preferencji Powiadomień

`notification_preferences_modal.dart` nie jest już dużym widgetem mieszającym
composition i renderowanie trzech niezależnych stanów. Został hostem modalu
(119 linii): odczytuje porty, tworzy cztery istniejące Cubity i zachowuje ich
ten sam scope. Nowy `notification_preferences_sections.dart` (356 linii)
renderuje oddzielnie delivery, Storage i read-only digest; nie wykonuje HTTP
i komunikuje wyłącznie intencje do Cubitów. Nie zmieniono tras, API,
zachowania rollbacku ani zasięgu `DevPlannerModalHost`.

Odbiór: `notification_preferences_cubits_test.dart` **5/5 PASS** oraz
analyzer katalogu preferencji PASS. Oba widgety są poniżej 400 linii.
Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2k: weryfikacja kompilacji Backend przed stagingiem

W katalogu Backend są trzy projekty (`veloryn-workspaces.csproj` oraz dwa
projekty testowe), dlatego ogólne `dotnet build` wymaga jawnego wskazania
projektu i nie jest właściwą komendą odbioru. Zweryfikowano główny backend:
`dotnet build veloryn-workspaces.csproj --no-restore`.

Wynik: PASS, 0 ostrzeżeń, 0 błędów. Nie uruchamiano API, bazy, MinIO ani GUI;
wynik potwierdza wyłącznie aktualną kompilację przed wdrożeniem stagingowym.

### 2026-09-18 — R2l: foundation dla aktywnego panelu Powiadomień

Aktywne pliki globalnego panelu Powiadomień, jego widgetów, modalu preferencji,
sekcji preferencji i modalu odpowiedzi importują teraz lokalizację oraz theme
wyłącznie przez publiczne fasady `foundation/l10n` i `foundation/theme`.
Nie zmieniono danych, route, modal hosta ani API; jest to usunięcie sprzężenia
presentation z historyczną ścieżką `core`, nie mechaniczne kasowanie katalogu.

Odbiór po migracji: panel, inbox, preferencje i reply **28/28 PASS**;
analyzer całego katalogu Powiadomień PASS. Jeden import `core/l10n` pozostał
wyłącznie w nieaktywnym, historycznym `notifications/standalone/`; nie jest
częścią globalnego hosta i wymaga osobnego audytu, zamiast cichego usunięcia.
Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2m: test aktywnej listy globalnego Chatu

`devplanner_global_panels_host_test.dart` nie sprawdza już wyłącznie stanu
„Chat unavailable”. Dodano scenariusz z prawdziwym portem `ChatRepository`:
kliknięcie belki otwiera globalny panel, Cubit pobiera i renderuje rozmowę,
a ekran zadania pod panelem pozostaje w drzewie. Test korzysta z lokalizacji
takiej jak produkcyjny `MaterialApp`, więc wykrywa również brak delegatów.

Odbiór: test globalnego hosta **3/3 PASS**, analyzer testu PASS. Jest to
automatyczny dowód renderowania panelu i braku zmiany trasy, nie dowód
realtime, ACL ani wysyłki między dwoma użytkownikami; te scenariusze pozostają
do odbioru stagingowego. Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2n: foundation dla aktywnej ścieżki globalnego Chatu

Sześć komponentów renderowanych przez globalny panel Chat (`chat_drawer`,
lista wiadomości, composer i pola composera oraz oba fragmenty rozmowy)
korzysta teraz z publicznych fasad `foundation/l10n` i `foundation/theme`.
Nie zmieniono repository, Cubitów, SignalR, draftów, uploadu ani nawigacji;
to wyłącznie usunięcie sprzężenia presentation z historyczną ścieżką `core`.

Odbiór: host panelu, Cubit rozmowy i widget composera **19/19 PASS**; analyzer
katalogu Chat PASS. Sprawdzone pliki aktywnego panelu nie mają już importów
`core/l10n` ani `core/theme`. Nie uruchamiano GUI ani aplikacji.
### 2026-09-18 — R2o: Chat wyłącznie jako globalny panel

Globalny Chat nie może otwierać własnej trasy ani ekranu. Usunięto martwy
fallback, który po kliknięciu „pełny widok” zamykał panel i prowadził do
nieistniejącego `/chat/conversations/:id`. Akcja „otwórz pełny widok” jest
teraz opcjonalna i nie jest renderowana przez session-scoped host; rozmowa,
historia oraz composer pozostają w prawym overlayu nad aktualną trasą.

Usunięto również niepodłączone, historyczne wrappery pełnych stron Chat
(`chat_landing_page.dart` i `chat_route_pages.dart`). Nie usunięto domeny,
repository, Cubitów ani Resource Chat dla udostępnionych plików — są one
kontraktami panelu. Dodany test wybiera rozmowę w globalnym panelu, potwierdza
brak ikony przejścia do osobnego widoku oraz zachowanie ekranu pod overlayem.

Odbiór: `devplanner_global_panels_host_test.dart` **3/3 PASS**; pakiet
Chat (host, Cubit rozmowy, composer) **19/19 PASS**; analyzer aktywnego
katalogu Chat PASS. Nie uruchamiano GUI, backendu ani stagingu.
### 2026-09-18 — R2p: odbiór granicy overlayu i routera

Po usunięciu historycznych wrapperów sprawdzono cały produkcyjny katalog
`lib`: `flutter analyze lib` zakończył się PASS. Test katalogu root routera
potwierdził **16/16 PASS**, w tym realne trasy zadań, Kanban oraz plików.
Test hosta globalnych paneli potwierdził **3/3 PASS**. Nie ma już kodu
presentation prowadzącego do `/chat/conversations/:id`; pozostają wyłącznie
kontrakty HTTP API pod `/api/v1/chat/...`, potrzebne overlayowi.

Zgodność obu przekazywanych dokumentów została sprawdzona przez `cmp`,
a `git diff --check` dla Front i Backend nie wykazał błędów whitespace.
Nie uruchamiano GUI, desktopowego frontu, backendu, MinIO ani stagingu.
### 2026-09-18 — R2q: regresja priorytetowych pionów Workspace

Wykonano odbiór trzech zakresów wskazanych jako priorytet: Pliki, lista
zadań i Kanban. Testy potwierdzają, że domyślna trasa zadań używa bogatej
listy standalone, a trasa Kanban używa istniejącej implementacji board;
przepływ tworzenia zadania czeka na potwierdzenie i blokuje podwójne wysłanie.
Dla Files sprawdzono sidebar, toolbar, listę, breadcrumbs, menu desktopowe,
skrót Cmd/Ctrl+A, Escape i zachowanie po zwężeniu layoutu.

Odbiór: wskazane testy **20/20 PASS**. To automatyczna regresja komponentów
i tras, nie test stagingowy połączeń API/MinIO. Nie uruchamiano aplikacji,
backendu ani GUI.
### 2026-09-18 — R2r: rozdzielenie automatyzacji Tasks i zakaz setState

W aktywnym pionie Tasks usunięto ostatnie znalezione użycie `setState` z
przełącznika grupowania listy. Hover i focus są lokalnym, niemutowalnym stanem
`ValueNotifier` oraz `ValueListenableBuilder`; nie dotyczą danych domenowych.
Komponent korzysta też z publicznych fasad `foundation/l10n` i
`foundation/theme`.

`AutomationSettingsCubit` został podzielony bez zmiany endpointów lub UI:
stan jest w osobnym pliku, startowe odczyty są w
`AutomationSettingsLoader`, a odczyt tasków/dry-run w
`AutomationSettingsDryRunService`. Cubit nadal jest jedynym właścicielem
publikacji stanów, mutacji reguł, historii i lifecycle. Sama klasa ma teraz
392 linie, czyli mieści się w wymaganym limicie; nie użyto funkcji globalnych
ani `BuildContext` poza UI. Pełny raport: Front
`docs/recovery/R2r-task-settings-quality-report.md`.

Odbiór: przełącznik **1/1 PASS**, ustawienia automatyzacji **9/9 PASS**,
analyzer katalogu Cubitów PASS. Nie uruchamiano GUI, backendu ani stagingu.
### 2026-09-18 — R2s: foundation dla aktywnych Tasks i Files

Dwadzieścia cztery pliki renderowane przez Shell Plików, recurrence oraz Saved
Views Tasks przestały importować historyczne fasady `core/l10n` i
`core/theme`. Używają wyłącznie publicznych `foundation/l10n` i
`foundation/theme`. Nie zmieniono modeli, repository, endpointów, routera,
Cubiców ani zachowania UI; jest to usunięcie sprzężenia presentation, nie
mechaniczne kasowanie dawnego katalogu `core`.

Odbiór: analyzer trzech objętych gałęzi PASS; regresja Files, Saved Views i
recurrence **29/29 PASS**. Skan aktywnych Tasks/Files nie wykazuje już importów
`core/l10n` ani `core/theme`. Szczegóły i komendy:
`docs/recovery/R2s-active-tasks-storage-foundation-report.md`. Nie uruchamiano
GUI, backendu ani stagingu.
### 2026-09-18 — R2t: router bez jednej dużej klasy

Konfiguracja `GoRouter`, guard i lifecycle pozostały w
`devplanner_router.dart`; budowanie stron i redirectów przeniesiono do
`devplanner_router_pages.part.dart` z jawnym kontraktem getterów zależności.
Główna klasa routera mieści się w limicie, a komponent stron ma 209 linii.
Nie zmieniono konstruktora publicznego, URL-i, `?view=kanban`, walidacji UUID,
ACL ani composition Files/Tasks/Admin.

Odbiór: analyzer routera PASS; testy katalogu root routera, routera i
powiadomień **31/31 PASS**. Potwierdzono realne trasy katalogu, projektów,
Files, listy/Kanbanu/szczegółu taska, public share oraz fail-closed `/admin`.
Szczegóły: `docs/recovery/R2t-router-boundary-report.md`. Nie uruchamiano
GUI, backendu ani stagingu.
### 2026-09-18 — R2u: tylko dwa motywy DevPlanner

Z `MaterialTheme` usunięto cztery nieużywane warianty medium/high contrast,
ich publiczne fabryki oraz puste modele dodatkowych kolorów. Pozostają tylko
`light()` i `dark()` z tokenami Gmail-like shell, feedbacku i powierzchni.
Fabryka motywu ma 300 linii, nie przekracza limitu i nie wprowadza kolejnego
presetu sprzecznego ze specyfikacją.

Odbiór: analyzer theme/app/shell PASS; testy jasnego/ciemnego motywu,
`DevPlannerApp` i shell **9/9 PASS**. Raport:
`docs/recovery/R2u-two-theme-foundation-report.md`. Nie uruchamiano GUI,
backendu ani stagingu. Preferencja użytkownika w ustawieniach jest odrębnym
następnym krokiem, nie została pozorowana kontrolką bez persistence.
### 2026-09-18 — R2v: trwały wybór jasnego albo ciemnego motywu

Dodano drzewo `app/theme`: enum dwóch wariantów, port persistence, adapter
`shared_preferences` oraz mały `ThemePreferenceCubit`. Domyślnie aplikacja
startuje jasno; odczytuje zapis bez blokowania startu, a zmianę publikuje
dopiero po potwierdzonym zapisie. `DevPlannerApp` składa i zamyka Cubit, nie
tworząc nowego routera przy zmianie `themeMode`.

Belka ma jedną dostępną akcję przełączenia jasny/ciemny, sterowaną wyłącznie
przez Cubit. Nie dodano wariantu systemowego, presetów, `setState`, I/O w UI
ani nowego ekranu. Odbiór: analyzer PASS; Cubit, aplikacja i shell **11/11
PASS**. Szczegóły: `docs/recovery/R2v-theme-preference-report.md`. Nie
uruchamiano GUI, backendu ani stagingu.
### 2026-09-18 — R2w: audyt struktury aktywnego Frontu

Skan aktywnych `app/auth/foundation/workspaces` nie znajduje importów Ready,
DataBus ani dawnych połączeń zewnętrznych. W aktywnych App/Foundation/Tasks/
Files nie ma też `setState`. Skan plików >400 jest tylko wskazówką: router
ma osobne klasy i 209-linijkowy builder stron, automatyzacja ma Cubit 392 linii
oraz oddzielne state/loader/dry-run, a transport rozdziela request/response/
adaptery. Nie wykonywano mechanicznego dzielenia plików.

Dokładny zapis granic klas i ograniczeń odbioru:
`docs/recovery/R2w-structural-audit-report.md`. Wynik nie jest dowodem live;
backend, MinIO, SignalR, OnlyOffice i staging pozostają NOT RUN, ponieważ GUI
nie było uruchamiane.
### 2026-09-18 — R2x: chroniony zakres odzyskania Workspace

Zakres tej fazy jest zamknięty: przywracamy Files, Tasks i Kanban jako
działające piony oraz częściowy Chat i Powiadomienia wyłącznie jako globalne
prawe overlaye. Nie dodajemy osobnego ekranu/trasy Chat lub Powiadomień ani
nowych pionów Whiteboard, Wiki, Corkboard, OKR czy Automations.

Audyt Backend potwierdził brak aktywnego klienta/URL/konfiguracji Ready,
Core/DataBus; jedyny traf to fail-closed guard zakazujący `DATABUS`.
`dotnet build veloryn-workspaces.csproj --no-restore` kończy się 0 warnings,
0 errors. `flutter analyze` aktywnego Frontu i testów Files/Tasks/Shell/Router
kończy się `No issues found`. Raport i granice odbioru:
`docs/recovery/R2x-active-scope-and-standalone-audit-report.md`. Nie
uruchamiano GUI, Backend ani stagingu.
### 2026-09-18 — R2y: helpery Tasks bez funkcji globalnych

W aktywnych Tasks przeniesiono pomocniki grupowania listy, menu wiersza,
cykliczności, historii, załączników, awatarów współpracowników, pól własnych,
kolorów etykiet oraz launchery type/assignee/settings/archive do małych klas
jednej odpowiedzialności. Nie zmieniono tras, endpointów, modeli, danych ani
Cubitów. Analiza całego Tasks PASS, `task_list_grouping_test` **4/4 PASS**.
Pozostałe historyczne launchery UI są zapisane jako kolejny mały krok, bez
prawa do stworzenia wspólnego utility/God class. Raport:
`docs/recovery/R2y-tasks-helpers-boundary-report.md`.
### 2026-09-18 — R2z: dowód regresji pionu Files

Testy wertykalne potwierdzają istniejące zachowanie folderów, uploadu,
downloadu, sharingu, ACL/BFF read-only, wersjonowania i delete/restore. Pełny,
jednoznacznie zapisany końcowy wynik dla wersji oraz delete/restore to **13/13
PASS**; zakres i granica względem MinIO/staging są opisane w
`docs/recovery/R2z-storage-vertical-regression-report.md`. Nie uruchamiano
aplikacji, Backend, MinIO ani GUI.
### 2026-09-18 — R3a: rdzeń Kanban potwierdzony automatycznie

Trasa, ACL, loading/empty, DnD z rollbackiem, workflow, bulk operations,
quick create, filtry, preferencje i realtime boardu są pokryte wynikiem
**40/40 PASS**. Nie jest to odbiór live SignalR/Backend. Pełny zakres:
`docs/recovery/R3a-kanban-core-regression-report.md`.
### 2026-09-18 — R3b: globalne panele częściowo potwierdzone

Overlay Chat/Powiadomienia nie zmienia aktywnej trasy; testy obejmują czyszczenie
Chat po revoke, realtime, cursor/retry Inbox oraz odpowiedź do Chat. Wynik
**36/36 PASS** nie zastępuje desktopowego testu SignalR/Backend. Szczegóły:
`docs/recovery/R3b-global-panels-regression-report.md`.
### 2026-09-18 — R3c: kolejne launchery Tasks bez funkcji globalnych

`AnchoredTextEditor`, `TaskDatePicker`, `TaskComplexityPicker`,
`TaskSizePicker`, `TaskRiskPicker`, `TaskDurationEditor` i
`TaskBusinessValuePicker` zastępują funkcje plikowe w edycji
komórek, menu oraz template actions. Normalizacja daty UTC nie zmieniła
zachowania, a cały katalog Tasks po zmianie ma `flutter analyze` PASS. Kolejny
zakres i zasady: `docs/recovery/R2y-tasks-helpers-boundary-report.md`.
### 2026-09-18 — R3d: tabela i mapowania szczegółu Tasks

`TaskDetailsLabeler` i `TaskListGrid.visibleColumns` zastępują dwie funkcje
globalne bez zmiany danych. `project_tasks_list_rows_test` obejmujący tabelę,
daty, typy, metryki i menu kończy się **24/24 PASS**; cały Tasks analyzer PASS.
### 2026-09-18 — R3e: zależności, cykliczność i opis Tasks

Formularze szczegółu używają `TaskDependencyLabeler` i
`TaskRecurrenceModeLabeler`; odczyt Quill Delta/fallback tekstowy przejął
`TaskDetailsDescriptionControllerFactory`. Nie zmieniono requestów ani stanu
zadania. Analyzer katalogu szczegółów PASS.

### 2026-09-18 — R3f: czas pracy Tasks bez funkcji globalnych

`TaskTimeTrackingPresentation` przejął obliczanie minut aktywnego wpisu oraz
formatowanie czasu i statusu akceptacji. Zmiana jest czysto prezentacyjna:
nie zmienia requestów, stanu ani odpowiedzialności `TaskTimeTrackingCubit`.
`flutter analyze lib/workspaces/presentation/tasks/detail` kończy się PASS.

### 2026-09-18 — R3g: cykliczność Tasks bez funkcji globalnych

`TaskRecurrenceDialogLauncher` składa dialog z istniejącym repository i
`TaskRecurrenceCubit`, a `TaskRecurrenceFrequencyLabeler` lokalizuje etykiety.
Zapis cykliczności oraz kontrakty API nie zmieniły się. Analyzer szczegółów
Tasks PASS.

### 2026-09-18 — R3h: milestone Tasks bez funkcji globalnej

`TaskMilestonePickerLauncher` przejął wyłącznie otwarcie dolnego pickera z
istniejącym `TaskMilestoneCubit`; przypisanie i odpięcie nadal wykonuje Cubit.
Analyzer szczegółów Tasks PASS.

### 2026-09-18 — R3i: template Tasks bez funkcji globalnej

`TaskTemplateDialogLauncher` przejął kompozycję modalu z aktualnym zadaniem
i `TaskTemplateCubit`; sam zapis template pozostaje w Cubicie. Analyzer
szczegółów Tasks PASS.

### 2026-09-18 — R3j: akceptacja i checklista Tasks bez funkcji globalnych

`TaskDetailsTextEditor` obsługuje dialog krótkiego tekstu i deleguje mutacje
do `TaskDetailsCubit`; `TaskDependencyTypeLabeler` lokalizuje typ relacji.
Analyzer szczegółów oraz testy usług akceptacji/checklisty **5/5 PASS**.

### 2026-09-18 — R3k: pełna analiza Frontu bez ostrzeżeń

Naprawiono wyłącznie higienę testów: kolejność importów oraz trzy wywołania API
Flutter oznaczone jako przestarzałe. Nie zmieniono funkcjonalności produktu,
tras, kontraktów ani transportu. `flutter analyze` kończy się `No issues
found`; testy trasy logowania i tokenów motywu **5/5 PASS**.

### 2026-09-18 — R3l: artefakt desktopowego Frontu zbudowany

`flutter build macos --debug` zbudował `DevPlanner.app` bez uruchamiania GUI.
Flutter zgłasza wyłącznie nieblokujące ostrzeżenie przyszłej kompatybilności
Swift Package Manager dla `media_kit_libs_macos_video` i `media_kit_video`.
Przed stagingiem należy je śledzić przy aktualizacji Fluttera; nie jest to
obecny błąd kompilacji ani dowód odbioru live.

### 2026-09-18 — R3m: Backend kompiluje się bez ostrzeżeń

`dotnet build veloryn-workspaces.csproj --no-restore` kończy się powodzeniem:
**0 ostrzeżeń, 0 błędów**. Polecenie nie uruchamia Backend, bazy, MinIO ani
innych usług środowiskowych.

### 2026-09-18 — R3n: regresja aktywnych pionów Frontu

Testy routera/shella, Kanbanu oraz Files (wersje, delete/restore) kończą się
**57/57 PASS**. Testy globalnych overlayów Chat/Powiadomienia, realtime,
revoke, retry i odpowiedzi do Chat kończą się **36/36 PASS**. W szczególności
panel zachowuje aktywną trasę pod spodem. To dowód automatyczny, nie zastępuje
ręcznego scenariusza desktopowego z Backendem, MinIO i SignalR.

### 2026-09-18 — R3o: audyt granic aktywnego Frontu

W `app`, `auth`, `foundation` i `workspaces` nie ma wywołania `setState` ani
bezpośredniego klienta HTTP w warstwie prezentacji. Skan funkcji plikowych
aktywnych Tasks jest pusty. Najdłuższe klasy aktywnego UI/Cubit pozostają pod
limitem 400 linii: `TaskDurationEditor` ma 399, a
`AutomationSettingsCubit` 392; długie pliki generowane i modele/transport są
wyłączone z tego kryterium. Nie jest to test runtime.

### 2026-09-18 — R3p: aktywny Resource Chat pliku i cleanup placeholderów

Files ma aktywną trasę szczegółu `/storage/files/:fileId`; z listy prowadzi do
niej akcja „Szczegóły pliku”. `StorageFileDetailsCubit` pobiera świeże
uprawnienia, a „Czat pliku” jest widoczny tylko przy potwierdzonym
`canOpenResourceChat`. `ResourceChatCubit` ponownie autoryzuje zasób i otwiera
prawy globalny panel bez trasy Chat. Usunięto nieosiągalne źródła dawnych tras
z placeholderami oraz dawne widoki tras Whiteboard/Wiki/OKR. Analyzer PASS;
testy Resource Chat, routera i Files **31/31 PASS**, a katalog i przejście
Files → szczegóły **14/14 PASS**. Szczegóły:
`docs/recovery/R2x-active-scope-and-standalone-audit-report.md`.

### 2026-09-18 — R3q: ponowny build macOS po aktywacji Files Resource Chat

`flutter build macos --debug` po dodaniu szczegółu Files i cleanupie dawnych
tras zbudował `DevPlanner.app`. Nie uruchamiano GUI. Pozostaje wyłącznie znane,
nieblokujące ostrzeżenie przyszłej obsługi Swift Package Manager przez
`media_kit_libs_macos_video` i `media_kit_video`.

### 2026-09-19 — R3r: domyślne uruchomienie macOS ze stagingiem

Konfiguracja VS Code `DevPlanner macOS — staging` przekazuje teraz jedyny
standalone origin `https://devnote.flutter-dev.pl` jako
`DEVPLANNER_API_BASE_URL`. Ten sam adres obsługuje Flutter Web, BFF, API,
OpenIddict i SignalR, więc desktop korzysta z wdrożonego backendu bez lokalnego
API, PostgreSQL lub MinIO. Lokalna konfiguracja HTTPS pozostaje osobnym,
jawnym wyborem; bezpieczny domyślny adres kodu dla świeżego checkoutu nie został
zmieniony.

Odbiór konfiguracji: `https://devnote.flutter-dev.pl/health/ready` zwraca
`Healthy`; `jq empty .vscode/launch.json`, synchronizacja dokumentów
Front/Backend oraz `git diff --check` w obu repozytoriach są PASS. Nie
uruchomiono GUI ani nie wykonano loginu — to nie jest dowód desktopowego E2E.
