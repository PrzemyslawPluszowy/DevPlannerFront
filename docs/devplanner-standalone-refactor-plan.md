# DevPlanner standalone — zaakceptowany stan refaktoryzacji

## 2026-09-19 — staging: desktop auth, commit 1c11573

- [x] Wdrożono Backend `1c11573fd37f1d0d42f989e11e26bb8ddcd62439`
  skryptem `devplanner-deploy-local` na VPS; automatyczny run Actions
  `35442774260` anulowano przed ręcznym wdrożeniem.
- [x] Build Release, oba migratory, kontener healthy, publiczne readiness
  `Healthy`, zapytanie kontrolne PostgreSQL i odrzucenie błędnego Bearera 401.
- [ ] Pełna suite Backend nie jest zielona: 1152 PASS, 7 FAIL, 1 SKIP;
  testowy kontener DI w `MeEndpointsTests` nie rejestruje
  `DeviceSessionRealtimeConnectionRegistry`. Produkcyjny kontener ją rejestruje.
- [ ] Desktopowy E2E Keychain/restart/update i dystrybucyjny instalator
  pozostają otwarte. To wdrożenie nie publikuje nowej aplikacji desktopowej.

Raport: `Backend/docs/recovery/desktop-auth-staging-deployment-2026-09-19.md`.
Nie wykonano dodatkowego commita; użyto commita dostarczonego przez użytkownika.


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

### 2026-09-19 — R3s: ciągła rama Gmail-inspired shella

Desktopowy shell renderuje nagłówek marki jako górną część lewej kolumny,
zamiast jako fragment pełnej belki nad sidebarem. Sidebar i jego nagłówek mają
więc wspólne, ciągłe tło gradientowe; prawa belka ma kompaktowe 40 px i zawiera
tylko kontekst modułu oraz akcje globalne. Nie zmieniono tras, composition,
portów, danych ani kontraktu Chat/Notifications. Typografia menu i kontekstu
belki używa lokalnego Intera 11 px, a marka 12 px. Globalny `ThemeData`
ustala spójne, mniejsze role tekstu i ikonę domyślną 18 px; nie dodano
skalowania tekstu, które omijałoby ustawienia dostępności systemu.

Odbiór: scoped analyzer PASS; shell oraz testy theme/typography **7/7 PASS**;
`flutter build macos --debug` PASS z istniejącym nieblokującym ostrzeżeniem
Swift Package Manager dla `media_kit_*`; `git diff --check` PASS. Manualny
odbiór z relaunchu desktopowego pozostaje następnym krokiem.

### 2026-09-19 — R3t: nowe drzewo lewego menu Workspace

Zatwierdzono nową implementację menu bez przywracania legacy UI: katalog
workspace'ów jest odczytywany przy starcie, a projekty są pobierane dopiero po
rozwinięciu konkretnej gałęzi. Błąd projektu pozostaje lokalny i nie usuwa
innych workspace'ów. Shell otrzymał wąski kontrakt tworzenia workspace'u,
odświeżenie katalogu i przejście na nową przestrzeń po sukcesie.

Kanoniczne trasy Lista/Kanban/Files, polityki Backend oraz globalne overlaye
Chat/Powiadomienia nie zmieniły się. Pionów Whiteboard/Wiki/Corkboard/
Automations nie dodano jako klikalnych placeholderów.

### 2026-09-19 — R3u: globalna gęstość i typografia nawigacji

Po ręcznym porównaniu z referencją Gmail-inspired ustalono jeden kontrakt
geometrii dla nawigacji: rozwinięty sidebar ma 224 px, zwinięty 56 px,
nagłówek 56 px, a wiersz menu 28 px. `DevPlannerNavigationTheme` jest
rozszerzeniem globalnego `ThemeData` i publikuje także rozmiar ikon 18 px,
tekst wiersza Inter 12 px, etykietę sekcji 11 px, wcięcie drzewa 16 px oraz
promień zaznaczenia 14 px.

Shell, katalog workspace'ów, ulubione workspace'y, drzewa rozwijane i gałęzie
zasobów korzystają z tych samych tokenów. Aktywny element zachowuje tylko
delikatne tło — usunięto dodatkowe obramowania i dekoracyjne kafelki ikon z
nawigacji. Prywatna sekcja katalogu nie otrzymuje już osobnej ramki, dzięki
czemu hierarchię tworzą wcięcia i nagłówki, a nie zagnieżdżone kapsuły. Nie
zmieniono tras, danych, portów ani kontraktów API.

### 2026-09-19 — UX-A1: audyt i plan domknięcia Listy/Kanbanu

Audyt kodu, historii `d1cc273..eda6e56` oraz kontraktów Backend potwierdził
regresję kompozycji w `TasksBoardRoutePage`: pełny `TasksBoardPage` jest
montowany wyłącznie dla literalnego `view=kanban`, a domyślna Lista oraz
`board/list/timeline/workload/recurrence` omijają wspólny nagłówek, przełącznik
widoków, saved views, akcje projektu i lifecycle realtime. Istniejący test route
page utrwala ten split. Pierwszy pakiet naprawczy musi zawsze montować jeden
pełny host Tasks i ustalić `/tasks` jako Listę oraz `?view=kanban` jako Kanban.

Audyt potwierdził również trzy konkurencyjne systemy menu, brak parytetu akcji
Lista/Kanban, zbyt małą globalną typografię interaktywną, hardkodowane
powierzchnie Tasks oraz martwe pozycje modułów bez aktywnej trasy. Nie wolno
przepisywać Backend: większość funkcji Tasks/Kanban ma już typed klienty,
repozytoria i UI; problemem jest kompozycja, discoverability i spójność.

Plan wykonawczy, kolejność pakietów, ownership agentów, bramki oraz Definition
of Done zapisano w
`Front/docs/recovery/tasks-list-kanban-ux-recovery-plan.md`. Decyzja produktowa:
bez pośredniego ekranu „Przegląd”; kliknięcie projektu prowadzi bezpośrednio do
Zadań. Ten pakiet nie zmienia runtime ani nie jest odbiorem GUI/E2E.

### 2026-09-19 — UX-T0: jeden host Tasks i kontrakt trasy

Pakiet T0 z planu domknięcia Listy/Kanbanu wykonany. `TasksBoardRoutePage`
montuje zawsze ten sam `TasksBoardPage`, a `?view=` nie może już wybrać innego
ekranu. Nowy kanoniczny kontrakt widoku
(`lib/workspaces/presentation/tasks/tasks_project_view_contract.dart`) ustala
`/tasks` jako Listę, `?view=kanban` jako Kanban i zachowuje `board` jako alias
wejściowy; `?view=` buduje wyłącznie
`DevPlannerRouteCatalog.projectTasksView`. Sidebar porównuje ścieżkę i widok z
adresu, wiersz projektu prowadzi bezpośrednio do Listy, a drzewo nie renderuje
już pośredniego „Przeglądu” (widok `/workspaces` pozostaje fallbackiem `/`).

Bramki: pełny `flutter test` **884/884 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Pełne pliki, decyzje i ograniczenia opisuje
wpis UX-T0 w `docs/devplanner-standalone-refactor-handoff.md`. Nie zmieniano API
ani UI tabeli i boardu; brak odbioru GUI/E2E. Kolejne pakiety: T1, T2.

### 2026-09-19 — UX-T1: tokeny Tasks i podłoga typografii

Powstał `DevPlannerTasksTheme` w `lib/foundation/theme/tasks_theme.dart` z jedną
skalą dla całego modułu Tasks (typografia 13/18, 12/16 w600, 11/16, 14/20 w600,
15/20 w600; geometria wierszy 36–46 px; odstępy 4/8/12/16/24; promienie 8/8/12;
powierzchnie canvas/command bar/karta/menu/bulk bar oraz role akcentu, cienia
i scrimu). Globalne `labelMedium` i `labelSmall` podniesiono z 10 px do 12 i 11
px, a w aktywnym Tasks zniknęły wszystkie lokalne rozmiary poniżej 11 px i
wszystkie `Colors.white`/`Colors.black` oraz ręczne tło kanwy.

Bramki: pełny `flutter test` **913/913 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty; odświeżone trzy goldeny Kanbanu. Pełny opis
decyzji i ograniczeń: wpis UX-T1 w
`docs/devplanner-standalone-refactor-handoff.md`. Kolejne pakiety: T2, T3.

### 2026-09-19 — UX-T2: jedna infrastruktura menu

Jeden publiczny komponent `AppContextMenu` zastąpił `TaskContextMenu`,
`WorkspaceContextMenu` i warianty `flat`/`glass`. Powstał
`DevPlannerMenuTheme` (`lib/foundation/theme/menu_theme.dart`) z jedną
powierzchnią (wiersz 32 px, ikona 16 px, tekst 13 px, promień 8 px), a komponent
obsługuje sekcje, skróty, `selected`/`disabled`/destructive, prawy klik
(`AppContextMenuRegion`), klawiaturę (strzałki, Home, End, Enter, Space, Escape)
oraz powrót focusu do aktywatora. Zmigrowano 48 wywołań w 22 plikach Tasks;
pickery przyjmują globalny `Offset`, a edytor czasu zadania używa wspólnej
powierzchni zamiast własnego dialogu.

Bramki: pełny `flutter test` **929/929 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Pełny opis, lista testów i pozycje
pozostawione do T4/T6: wpis UX-T2 w
`docs/devplanner-standalone-refactor-handoff.md`. Kolejny pakiet: T3.

### 2026-09-19 — UX-T3: wspólny dwurzędowy nagłówek zadań

Nagłówek przeniesiony do neutralnego `lib/workspaces/presentation/tasks/header/`
i przemianowany na `TasksHeader`; moduł montuje publiczny komponent, więc Lista
i Kanban dzielą ten sam chrome. Układ jest zawsze dwuwierszowy na tokenach
`DevPlannerTasksTheme`: wiersz kontekstu 44–48 px (projekt, licznik, zakładki,
obecność, menu projektu, CTA) oraz wiersz poleceń 36–40 px (zapisane widoki,
akcje widoku, a po zaznaczeniu jeden kontekstowy pasek akcji masowych). API
nagłówka nie zna już `GoRouter` — nawigację po wyjściu z projektu dostarcza
trasa przez `onProjectExited`.

Bramki: pełny `flutter test` **934/934 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty, golden nagłówka odświeżony. Testy obu widoków
dla 360/768/1024/1440/1920 px oraz dowód wspólnego chrome na poziomie trasy.
Kolejne pakiety: T4 (domknięcie Listy) i T5 (domknięcie Kanbanu).

### 2026-09-19 — UX-T4: domknięcie Listy

Filtry, sortowanie, grupowanie i kolumny Listy przeniesione do drugiego wiersza
wspólnego nagłówka (`chrome/task_list_command_bar.dart`), a pływający pasek akcji
masowych zastąpiony paskiem w tym samym wierszu
(`bulk/task_list_bulk_bar.dart` po przepisaniu na tokeny i `AppContextMenu`).
Stan Listy tworzy `chrome/task_list_chrome_host.dart` ponad nagłówkiem, więc
wiersz poleceń i tabela korzystają z jednego źródła. W Listnie nie ma już
surowych `PopupMenuButton` od filtrów ani drugiego paska nad treścią.

Bramki: pełny `flutter test` **940/940 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Dowody i pozycje pozostawione do T6: wpis
UX-T4 w `docs/devplanner-standalone-refactor-handoff.md`. Kolejny pakiet: T5.

### 2026-09-19 — macOS: stabilny podpis debugowej sesji Keychain

Debug i Profile targetu `Runner` nie dziedziczą już podpisu ad-hoc. Są ręcznie
podpisywane stałym lokalnym certyfikatem Apple Development; podpis ma niezmienne
wymaganie kodu dla `com.excellent.devplanner`. Desktopowy refresh token nadal
pozostaje wyłącznie w zwykłym macOS Keychain
(`usesDataProtectionKeychain: false`); nie włączono sandboxowych entitlements,
bo lokalny account nie ma provisioning profile dla tego bundle identifier.

Dowody: `flutter build macos --debug`, `codesign --verify --deep --strict` oraz
targeted auth suite **8/8** są PASS. Kontrola podpisu potwierdza authority Apple
Development i TeamIdentifier zamiast poprzedniego Signature=adhoc. Pierwsze
uruchomienie nowego artefaktu odtworzyło sesję i workspace bez promptu Keychain.
Pełne `flutter analyze` pozostaje obecnie zablokowane przez niezwiązane, brudne
zmiany w `tasks_board_bulk_bar_test.dart`; nie jest raportowane jako PASS.

### 2026-09-19 — UX-T5: domknięcie Kanbanu i wspólny pasek akcji

Pasek akcji masowych Kanbanu korzysta z tego samego komponentu co Lista
(`tasks/bulk/tasks_contextual_bulk_bar.dart`, `TasksContextualBulkBar` z
`TasksBulkButton`/`TasksBulkMenu`), więc drugi wiersz chrome jest jeden dla obu
widoków. Kanban obsługuje z niego przeniesienie zaznaczonych kart między
kolumnami, priorytet i termin; Lista zachowuje swój szerszy zestaw akcji z
selekcją całego wyniku. Pasek Listy przepisany na ten sam komponent, a nazwy
pomocników nagłówka odkanbanowione.

Paginacja kolumn, zwijanie kolumn, DnD z korektą indeksu, blokada workflow,
rollback 409 z komunikatem oraz resync realtime są potwierdzone istniejącymi
testami w `test/workspaces/presentation/tasks/tasks_board_cubit_test.dart`;
nowy test `test/.../board/tasks_board_bulk_bar_test.dart` dowodzi podłączenia
bulk move do wspólnego paska.

Bramki: pełny `flutter test` **941/941 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Kolejny pakiet: T6.

### 2026-09-19 — AUTH-AUDIT: plan domknięcia sesji desktopowej

Audyt przepływu Desktop PKCE, refresh, REST, SignalR, revoke i podpisu macOS
potwierdził poprawny fundament, ale wykrył otwarte luki produkcyjne: brak
runtime refresh/retry po 401, możliwość błędnego użycia refresh vaulta jako
źródła Bearera, zapis zrotowanego credentialu dopiero po `/me`, brak
single-flight wspólnego dla REST i SignalR, połowiczny kontrakt OIDC oraz brak
pełnego dowodu natychmiastowego revoke access tokena i aktywnego SignalR.

Plan wykonawczy A0–F1 zapisano w
`Front/docs/recovery/desktop-auth-session-hardening-plan.md`. Ustala on kolejno:
testy charakterystyczne, bezpieczny porządek rotacji, jeden koordynator tokenów,
pojedynczy retry REST, wspólny lifecycle SignalR, backendową walidację sesji,
revoke połączeń wielohostowych, domknięcie kontraktu OAuth/OIDC, odporność
callbacku, przenośny podpis developerski, podpis/notarization Release oraz
macierz live E2E. Ten pakiet jest wyłącznie dokumentacją; nie zmienia runtime i
nie oznacza żadnej z luk jako naprawionej.

### 2026-09-19 — AUTH-A1: trwała rotacja przed pobraniem profilu

Desktopowy transport PKCE zwraca teraz mały wynik tokenowy (`accessToken`,
`refreshToken`, `expiresIn`), a nie miesza exchange z pobraniem `/api/v1/me/`.
`DesktopPkceAuthAdapter` zapisuje nowy refresh token do OS vault przed
pobraniem profilu. Przejściowy błąd `/me` po prawidłowej rotacji nie pozostawia
więc w vault zużytego poprzednika. Jeżeli zapis vaulta zawiedzie, adapter
best-effort revokuje nowo wydany token i nie publikuje sesji.

Nie zmieniono Web BFF, PKCE, endpointów ani backendowego lifecycle tokenów.
Dowody Front: targeted `flutter test test/auth --reporter compact` **29/29
PASS**; scoped `flutter analyze` sześciu plików auth/testów: **No issues
found**; scoped `git diff --check`: PASS. Nie uruchamiano pełnego analyzera ani
realnego desktop E2E. Następny pakiet: A2 — wspólny koordynator single-flight.

### 2026-09-19 — UX-T6: martwe pozycje drzewa, ostatnie menu i dostęp do nawigacji

Drzewo renderuje wyłącznie pozycje z aktywną trasą: Automatyzacje, Whiteboardy,
Tablica korkowa i Wiki zniknęły z projektu do czasu własnych tras, a projekt
pokazuje Zadania (Lista, Kanban) i Pliki; kontrakt zasobów opisuje ten stan.
Ostatnie surowe `PopupMenuButton` w Tasks przeszły na wspólne `AppContextMenu`
(menu zapisanych widoków z dwustopniowym zarządzaniem, wielokrotny wybór pola
niestandardowego w szczegółach). Nie dodano żadnego endpointu.

Dodatkowo domknięto problem z audytu: po zwinięciu paska bocznego na wąskim
oknie (<960 px) drzewo było nieosiągalne — teraz ten sam klawisz otwiera je
w nakładce nad treścią.

Bramki: pełny `flutter test` **945/945 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Pozostaje T7: odbiór live z Backendem.

### 2026-09-19 — UX-T7 (częściowo): buildy i żywy Backend, GUI NOT RUN

Wykonane bramki: `flutter build web --wasm` PASS, `flutter build macos --debug`
PASS, `flutter analyze` bez uwag, pełny `flutter test` **945/945 PASS**,
`git diff --check` czysty w obu repozytoriach. Lokalny stos backendu (PostgreSQL
na 5440, Redis, MinIO, Mailpit, ClamAV, OnlyOffice) działa, API wstało przez
`Backend/start-local.sh` na porcie 5072 i wystawia 350 ścieżek OpenAPI; endpointy
`tasks/groups`, `kanban`, `me/tasks` oraz negocjacje hubów SignalR
`/api/v1/realtime/{tasks,chat,notifications}/negotiate` zwracają 401 bez tokenu,
co potwierdza żywy kontrakt i wymóg sesji.

NOT RUN bez przedstawiania jako sukces: scenariusz live GUI (create → inline edit
→ details → List ↔ Kanban → DnD → bulk → saved view → restart), dwa konta
i revoke, pomiary PostgreSQL po mutacjach, screenshoty 1024×768 / 1440×900 /
1920×1080 w light/dark oraz `flutter build windows` i `flutter build linux`
(brak hosta).

### 2026-09-19 — UX-T7 zamknięcie sesji: PASS na buildach i kontrakcie live, GUI odroczone

Decyzją właściciela w tej sesji nie wykonujemy fizycznych testów GUI, więc T7
pozostaje nieodebrany. Potwierdzone: `flutter build web --wasm` PASS,
`flutter build macos --debug` PASS, `flutter analyze` bez uwag, pełny
`flutter test` **952/952 PASS**, `git diff --check` czysty w obu repozytoriach,
żywy stos backendu z 350 ścieżkami OpenAPI i 401 na endpointach Tasks/Kanban
oraz negocjacjach hubów SignalR. Dodatkowo domknięto ostatnią lukę w testach
automatycznych kroku „inline edit”: rollback nie-konfliktowego błędu przywraca
poprzednią wartość wiersza i pokazuje komunikat przy tym wierszu.

Odroczone: scenariusz GUI, dwa konta z revoke, screenshoty trzech rozdzielczości
w light/dark. NOT RUN: `flutter build windows`, `flutter build linux` (brak
hosta). Runbook dokończenia: sekcja T7 w
`docs/recovery/tasks-list-kanban-ux-recovery-plan.md`.

### 2026-09-19 — UX-T7: zrzuty Listy i Kanbanu z realnej kompozycji

Odbiór GUI pozostaje odroczony decyzją właściciela, więc przygotowano materiał do
przeglądu bez uruchamiania aplikacji: `docs/recovery/visual-captures/` zawiera
12 czytelnych obrazów (Lista i Kanban × 1024×768, 1440×900, 1920×1080 ×
light/dark) wygenerowanych przez `tasks_visual_capture_test.dart` z tego samego
widgetu trasy, w motywie produktu i z załadowanymi fontami. Test pilnuje też
braku przepełnień na tych rozdzielczościach. To nie jest odbiór E2E — obrazy
pochodzą z renderu widgetów z fixture'em, nie z aplikacji na żywym Backendzie.

Bramki po zmianie: `flutter analyze` **No issues found**, pełny `flutter test`
**964/964 PASS**, `git diff --check` czysty.

### 2026-09-19 — AUTH-E1: przenośny podpis developerski macOS

Debug i Profile używają teraz `macos/Runner/Configs/Signing.xcconfig`; wersjonowana
konfiguracja zawiera wyłącznie ogólną politykę, a ignorowany
`Signing.local.xcconfig` zawiera lokalną tożsamość podpisu. Repozytorium nie
utrwala common name certyfikatu ani Team ID. Dwa kolejne buildy Debug miały ten
sam designated requirement i przeszły `codesign --verify --deep --strict`.

Na tej maszynie nie ma macOS provisioning profile dla
`com.excellent.devplanner`, więc sandboxowy podpis Release/notarization (E2)
pozostaje celowo otwarty; nie jest oznaczony jako PASS.

### 2026-09-19 — AUTH-A2–D1, B1–B2, C1: lifecycle desktopowej sesji

Desktopowy access token jest wyłącznie pamięciowy i odświeżany single-flight;
REST wykonuje najwyżej jeden retry po 401, a SignalR pobiera token z tego samego
providera. Refresh credential nigdy nie jest źródłem Bearera. Nowy refresh jest
zapisywany przed `/me`; `invalid_grant` usuwa credential, a awarie sieciowe go
zachowują. Desktopowy callback OAuth ignoruje obce żądania, ma limity i
timeouty, a desktop żąda wyłącznie `offline_access devplanner.api`.

Backend ustanawia 10-minutowy lifetime access tokena i waliduje aktywność
device session przy każdym desktopowym bearerze. Revoke po commit zrywa
połączenia Tasks, Chat, Wiki, Whiteboard i Notifications dla konkretnej sesji;
rejestr używa Redis dla wielu hostów. Targeted Front auth/HTTP/realtime tests,
Backend identity/realtime tests oraz realny test dwóch registry przez Redis
przeszły. Pełne E2E F1 pozostaje otwarte.

### 2026-09-19 — AUTH-A4: logout offline fail-closed

`AuthUseCases.signOut()` kończy widoczną sesję w `finally`, także gdy zdalny
revoke nie odpowie. Credential jest już czyszczony przez adapter, a router i
runtime otrzymują signed-out, więc nie mogą utrzymać starych REST/SignalR UI.
Nowy test potwierdza wyjątek revoke i jednocześnie stan signed-out.

### 2026-09-19 — Audyt parytetu Listy/Kanbanu i plan naprawy N0–N7

Przegląd kodu Front i Backend po odbiorze T7 wykazał, że Lista i Kanban mają
różne zestawy filtrów, ustawienia boardu (WIP, ukryte kolumny, gęstość, pola
karty) istnieją od kontraktu po Cubit, ale nie mają żadnego UI, a dwa elementy
interfejsu wymagają naprawy: nawigacja w modalu ustawień jest wyśrodkowana
(`TextButton.icon` bez `alignment`), a menu zapisanego widoku ma zdublowane
pozycje i drugie menu zakotwiczone w triggerze. Modal ustawień pracuje też na
historycznym `core/theme`/`core/l10n` (37 plików) i twardych stringach poza ARB.

Plan naprawy z pakietami N0–N7, listą delt Backendu (jedyna zmiana kontraktu to
opcjonalne filtry `GET /kanban`) oraz bramkami zapisano w
`docs/recovery/tasks-parity-and-ui-repair-plan.md`; kopia jest w Backendzie
(`cmp` identyczny).

### 2026-09-19 — N8: bezpieczny zapis ustawień widoku i wspólna powierzchnia błędów

Zgłoszenie właściciela (konflikt preferencji Kanbana przenosi pola ze starego
snapshotu, błędy Listy są maskowane poza arkuszem kolumn, błąd Kanbana ma tylko
nietrwały SnackBar, nieudany odczyt preferencji ginie w pustym handlerze, a błąd
ustawień tablicy przeładowuje Listę) domknięte w jednym pakiecie bez zmiany
zakresu T0–T7.

Kanban: `TasksBoardPreferenceCommands` trzyma kolejkę intencji i jedną pętlę
zapisu. Intencja opisuje wartość docelową, a nie różnicę, więc po konflikcie jest
nakładana na świeży snapshot z Backendu — ponowienie nie przenosi już
nieaktualnych pól, których użytkownik nie ruszył (dowód: nowy test
„ponowienie po konflikcie nie nadpisuje równoległej zmiany w innym polu").
Kliknięcia zgłoszone w trakcie zapisu trafiają do kolejnej partii zamiast zostać
odrzucone, a po udanym zapisie szybkiego filtra tablica wraca po świeży zestaw
kart. Po drugim konflikcie automatyczne ponawianie się zatrzymuje, intencja
zostaje widoczna i zaparkowana, a „Ponów" ponawia ją — nie odświeżony stan
serwera.

Lista: jedna szeregowana ścieżka zapisu (sortowanie i grupowanie nie mają już
własnej, omijającej kolejkę), a po konflikcie `mergeTaskListPreferences` scala
trzy strony — świeży stan serwera, ostatni potwierdzony zapis i draft — per pole,
z szerokościami kolumn scalanymi per kolumna. Draft użytkownika zostaje i jest
ponawiany, zamiast zostać porzucony przez `load()`.

Błędy: `TasksErrorBanner` + `TasksErrorBannerHost` pod nagłówkiem modułu Tasks
pokazują trwały komunikat z „Ponów", „Odśwież" i `traceId` dla Listy i Kanbana;
`mutationSerial` rozdzielono na `taskDataRevision` (rośnie tylko przy zmianie
danych zadań) oraz `TasksViewError? error` (bez licznika), dzięki czemu nieudany
zapis ustawień Kanbana nie każe Liście przeładowywać danych, a nieudany odczyt
preferencji przestaje być ignorowany.

Backend: nowe `TaskListVersionConflictException` i
`TaskListPolicyVersionConflictException` (strażnicy wersji w encjach rzucają je
zamiast `DbUpdateConcurrencyException`) mapowane w middleware na
`task_list.version_conflict` i `task_list.policy_version_conflict`; klient
rozpoznaje konflikt po stabilnym kodzie, a sam HTTP 409 zostaje jako zapas.
Komunikaty konfliktu Kanbana mówią „w innej sesji".

Bramki: `flutter gen-l10n` ok; `flutter analyze lib` i `flutter analyze test` —
No issues found; `flutter test --timeout 180s` — 1017/1017 PASS;
`flutter build web --wasm` — PASS; `flutter build macos --debug` — PASS
(`✓ Built build/macos/Build/Products/Debug/DevPlanner.app`);
`dotnet build veloryn-workspaces.csproj` — 0 ostrzeżeń, 0 błędów; testy Backendu
celowane (TaskList + macierz HTTP) — 18/18 PASS; pełna suite Backendu — 1156 PASS,
7 FAIL, 4 SKIP, gdzie wszystkie 7 to zastane `MeEndpointsTests` (potwierdzone
`git stash` moich zmian i tym samym wynikiem 7/17 na wersji bez N8);
`git diff --check` czysty w obu repozytoriach; `cmp` planu, handoffu i planu
parytetu w obu repozytoriach — identyczne. Kontrola mutacyjna: cofnięcie kodów
w middleware na `workspace.conflict` wysyła nowy test HTTP na czerwono, po
przywróceniu pliku wraca zieleń.

NOT RUN i dlaczego: Release macOS (lokalny Keychain nie ma profilu
provisioning dla `com.excellent.devplanner` — stan zastany, AUTH-E2), buildy
Windows/Linux (brak hosta) oraz live test dwóch sesji z widocznym komunikatem —
odroczony do wdrożenia nowej wersji Backendu przez właściciela.

Trzy testy pilnowały starego zachowania i zostały świadomie przepisane:
`UserPreferenceConcurrencyThrowsDbUpdateConcurrencyExceptionOnConflict` (Backend:
ogólny wyjątek → stabilny kod), „drugi konflikt preferencji pokazuje błąd
i zostawia stan serwera" oraz „autosave przy błędzie 409 conflict automatycznie
odświeża stan" (Front: porzucenie intencji → scalenie i zachowanie draftu).

### 2026-09-19 — N9: audyt transportu i stanu operacyjnego (P0 w odzyskiwaniu sesji)

Cztery defekty zgłoszone przez właściciela po odbiorze N8, z czego pierwszy
wyjaśnia pierwotną przyczynę raportowanych konfliktów Kanbana.

Transport desktopowy ponawiał **każde** żądanie: `onResponse` bezwarunkowo wołał
`_retryUnauthorized`, a jego bramka nie sprawdzała statusu. Ponieważ ten klient
akceptuje każdy status (`validateStatus: (status) => status != null`), także
odpowiedź 200 przechodziła przez `onResponse`, więc odzyskiwanie odświeżało token
i `_dio.fetch` powtarzał udane żądanie. Dla `PUT /kanban/preferences` pierwszy
zapis się udawał, a replay wysyłał to samo `expectedVersion`, które pierwsze
żądanie już zużyło — Backend słusznie odpowiadał 409, a klient raportował konflikt
na żądaniu, które się powiodło. Dotyczyło to każdego POST/PATCH/PUT/DELETE, więc
możliwe były podwójne operacje biznesowe. Warunek jest teraz dokładny:
`_retryUnauthorized` przyjmuje `statusCode` i wychodzi, gdy to nie 401;
`onResponse` podaje `response.statusCode`, a `onError` `error.response?.statusCode`
(błąd sieci bez statusu nie uruchamia odzyskiwania).

Błąd zapisu Listy cofał zmiany wykonane w trakcie żądania: `_publishFailure`
emitowało snapshot sprzed żądania, a pętla autosave kasowała `_hasPendingSave`,
więc zmiana zgłoszona podczas nieudanego zapisu znikała ze stanu i z kolejki.
Błąd jest nakładany na bieżący stan, a przy konflikcie bieżący draft przechodzi
przez to samo scalenie co zapis — świeże wartości serwera dla pól, których
użytkownik nie ruszył, jego zmiany zachowane. `_lastSaved` pozostaje ostatnim
potwierdzonym zapisem (baseline scalenia), a świeżą wersję niesie stan, więc
ponowienie używa właściwego `expectedVersion`.

Odczyt tablicy gubił stan operacyjny: `TasksBoardRuntimeCoordinator.load()`
budowało `TasksBoardReady` od zera i nie przenosiło `error`, `savingUserPreference`,
`taskDataRevision`, `pendingTaskIds`, `selectedTaskIds`, `loadingColumnKeys`,
`columnLoadErrors` ani `isBulkSaving`, więc niezwiązany resync po realtime mógł
ukryć banner niezapisanej preferencji. Odczyt aktualizuje istniejący stan przez
`copyWith(board:, filter:)`. Ujawniony dług: zaznaczenie po operacji masowej
czyściło się tylko jako skutek uboczny przebudowy — `_completeBulk` czyści je
teraz jawnie.

Log zdradzał ciało odpowiedzi: `api_repository.dart` wypisywał pierwsze 800
znaków dowolnego ciała błędu na wszystkich endpointach, także logowania,
odzyskiwania konta i aktywacji. Log podaje teraz kształt (`debugResponseShape`):
nazwy pól, liczbę elementów albo rozmiar tekstu — nigdy wartości.

Bramki: `flutter analyze lib test` — No issues found; `flutter test --timeout 180s`
— 1024/1024 PASS; `flutter build web --wasm` — PASS; `flutter build macos --debug`
— PASS; `git diff --check` czysty w obu repozytoriach; `cmp` dokumentów —
identyczne. Kontrola mutacyjna: bez bramki 401 padają oba nowe testy transportu,
bez zachowania bieżącego stanu pada test zmiany w trakcie zapisu, bez
`copyWith` w `load()` pada test resyncu tablicy.

Nowe testy: transport +2 (udana odpowiedź bez odzyskiwania i bez replay;
odpowiedź inna niż 401 bez odzyskiwania), Cubit Listy +1, Cubit Kanbana +1,
`test/core/data/api_repository_logging_test.dart` (3 przypadki).

NOT RUN bez zmian: live test dwóch sesji (czeka na wdrożenie nowej wersji
Backendu), Release macOS (brak profilu provisioning), buildy Windows/Linux
(brak hosta).

### 2026-09-19 — N10: enumy query/path, globalna diagnostyka HTTP i binding 400

- [x] Front nie wysyła już dartowych nazw enumów (`todo`, `inProgress`,
  `high`) ani obiektów enumów Retrofit w query/path. Jawne wartości kontraktowe
  PascalCase obejmują Tasks, Kanban, Notifications i kontekst dashboardu.
- [x] Audyt wszystkich deklaracji Retrofit `@Query`/`@Path` nie wykazuje już
  nieprymitywnych enumów; audyt mapperów transportowych nie wykazuje
  `status/priority/category/context/groupBy/involvement?.name`.
- [x] Aktywny `DevPlannerHttpTransport` ma jeden debugowy logger request,
  response i error z URL/query, statusem, czasem, nagłówkami i bezpiecznym
  opisem body. Bearer, cookies, CSRF, tokeny, hasła i dane wyszukiwania są
  redagowane; sukcesy nie zrzucają wartości DTO, a błędy pokazują wyłącznie
  `code`, `message`, `traceId` i nazwy pól.
- [x] Backend wymusza `RouteHandlerOptions.ThrowOnBadRequest`, dzięki czemu
  błędy bindera Minimal API trafiają również w Production do wspólnego
  `ApiExceptionMiddleware` zamiast zwracać puste 400.
- [x] Walidacja pakietu: backend build 0/0; backend targeted 2/2 PASS; frontend
  targeted 13/13 PASS; scoped `flutter analyze` bez problemów.
- [ ] Pełne suite/buildy platformowe pozostają poza tą punktową naprawą; ich
  wcześniejszy stan i niezależne blokady opisują N8/N9.
### 2026-09-19 — audyt nawigacji produktu i kreatora projektu

Audyt Front/Backend potwierdził, że Lista i Kanban są już dwoma widokami jednego
modułu Tasks, a ich rozdzielenie w drzewie jest wyłącznie decyzją prezentacyjną.
Backend ma pin/hide/order, archive/restore, szablony projektów i workflow oraz
rozbudowane funkcje Tasks, ale część nie jest osiągalna z aktywnego UI.

Wykryte luki kontraktu: brak listy archiwalnych projektów, brak `isHidden` w
`ProjectListItemResponse`, brak transferu projektu między workspace’ami, brak
publicznej `version/expectedVersion` mimo deklarowanej ochrony `xmin` oraz brak
atomowego, idempotentnego polecenia dla konfigurowalnego kreatora.

Plan P0–P8 zapisano w
`docs/recovery/product-navigation-and-project-wizard-refactor-plan.md`. Ustala
jeden węzeł Zadania z przełącznikiem Lista/Kanban, wspólne menu projektu,
optimistic UI z precyzyjnym rollbackiem i trwałym błędem, atomowy kreator z
preview oraz osobną decyzję dla transferu cross-workspace. §4.3 dodaje matrycę
Backend → adapter → stan → UI → test z rzeczywistymi ścieżkami i ujawnia piony
bez UI (capacity, schedule, kanban i workflow settings, kaskada harmonogramu)
oraz kontrakty bez konsumenta (`PUT /tasks/order`,
`PUT /projects/preferences/order`, `GET /tasks/search`). Ten pakiet jest
wyłącznie dokumentacją; nie zmienia runtime ani kontraktów API.

### 2026-09-19 — PN-P2: jeden węzeł Zadania, routing i preferencja widoku

- Drzewo ma jedną pozycję `Zadania` na projekt; `taskList` i `kanban`
  zniknęły z enuma, z drzewa i ze switchy shella. Projekt i jego pozycja
  `Zadania` prowadzą do tego samego `/tasks`, a gałąź z zaznaczonym dzieckiem
  nie podświetla się drugi raz.
- Wybór widoku modułu jest porównywany z adresem tylko wtedy, gdy adres
  wskazuje `?view=` jawnie; `/tasks` obejmuje wszystkie widoki modułu.
- Legacy linki `/tasks/list` i `/tasks/kanban` przekierowują na kanoniczne
  `?view=`, a trasa szczegółu zadania nie przechwytuje już `/tasks/list` jako
  `taskId`.
- „Ostatnio używany widok” to lokalna preferencja (port
  `TasksProjectViewPreferenceStore` + adapter `shared_preferences`) wczytywana
  raz przy starcie routera; odczyt jest synchroniczny, więc `/tasks` nie mruga
  Listą przed Kanbanem.
- Przepisane testy, które pinowały rozdzielone gałęzie:
  `workspace_navigation_foundation_test`, `workspace_navigation_tree_cubit_test`,
  `devplanner_shell_test` (selekcja i drzewo), `devplanner_root_router_compile_test`.
- Nowe testy: redirecty legacy, powrót do ostatniego widoku, wczytywanie
  i zapis preferencji oraz zachowanie przy braku implementacji persistence.
- Walidacja: `flutter analyze` — No issues found; dotknięte obszary 72/72 PASS;
  pełny `flutter test` 1039/1039 PASS.

### 2026-09-19 — PN-P5: jeden formularz tworzenia projektu

- Sidebar otwiera ten sam `CreateProjectDialog` co drzewo projektów;
  uproszczony `_CreateProjectFromSidebarDialog` został usunięty.
- Port `ProjectManagementGateway` i jego adapter zniknęły, bo obsługiwały
  wyłącznie ten drugi flow; shell dostaje pełne repozytorium projektów.
- Web BFF nadal nie wystawia akcji tworzenia (brak klienta API), bez zmiany
  zachowania. Kreator wieloetapowy pozostaje w P5b i wymaga kontraktu P4.
- Walidacja: `flutter analyze` — No issues found; testy shella 8/8 PASS,
  w tym nowy przypadek „sidebar opens the same project form as the project tree”.

### 2026-09-19 — PN-P6a: kaskada harmonogramu w stanie

- Preview i apply kaskady wyszły z widgetu do `TaskScheduleCascadeCubit`
  (`detail/cascade/cubit/`); widget przekazuje wyłącznie intencje i daty.
- Zapis bez podglądu jest odrzucany w cubicie, bo kontrakt wymaga
  `expectedVersion` każdego przesuwanego zadania.
- Nowy zestaw 6 testów: sukces podglądu, błąd podglądu, brak podglądu przy
  zapisie, wysłanie wersji, konflikt 409 z zachowanym podglądem, czyszczenie
  podglądu po zmianie dat.
- Walidacja: `flutter analyze` — No issues found; zestaw kaskady 6/6 PASS;
  testy prezentacji Tasks 421/421 PASS.

### 2026-09-19 — N10-followup: testy pinujące starą serializację enumów

Pięć testów nadal oczekiwało dartowych nazw pól (`inProgress`, `blocked`,
`critical`), które pakiet N10 zastąpił wartościami kontraktowymi. Asercje
przepisano na `wireValue` enuma, żeby pilnowały poprawnego kontraktu zamiast
wadliwego: `task_list_chrome_test` (2 przypadki) i
`project_tasks_list_cubit_test` (3 przypadki). Walidacja: oba pliki 60/60 PASS,
pełny `flutter test` bez czerwonych.

### 2026-09-19 — PN-P3: jedno menu projektu, optimistic-first z rollbackiem

- Drzewo projektów ma jedno menu kontekstowe (Otwórz, Przypnij/Odepnij, Ukryj
  dla mnie, Zmień nazwę i wygląd, Ustawienia, Utwórz szablon z projektu,
  Archiwizuj z potwierdzeniem, Przywróć, Usuń trwale po wpisaniu nazwy).
- `Przenieś do workspace` i `Opuść projekt` są jawnie wyłączone z powodem —
  brak kontraktu §6.4 i reguły ostatniego Ownera; nic nie udaje działającej
  funkcji.
- Pin/hide/order/lifecycle działają optimistic-first: jedno żądanie na projekt,
  scalanie intencji do ostatniej wartości, rollback wyłącznie pól własnej
  operacji (i tylko gdy rewizja pola się nie zmieniła), pełna lista w DnD,
  trwały baner błędu z kodem i `traceId`.
- Nowy stan drzewa rozbity po odpowiedzialnościach: fasada `ProjectsTreeCubit`
  plus kontrolery preferencji, kolejności i cyklu życia; produkcyjne pliki
  zmieściły się poniżej progu §9.4 po podziale.
- Walidacja: `flutter analyze` (cały projekt) — No issues found; zestawy
  `workspaces_home` i `projects` — 63/63 PASS (w tym 31 w `projects_tree/`);
  `flutter gen-l10n` bez ostrzeżeń.
- Otwarte: wpięcie drzewa w żywy shell i pełna lista archiwum (czeka na P1).

### 2026-09-19 — PN-P1: backend list/lifecycle/version/capabilities

- `GET /projects` przyjmuje `state=active|archived|all` oraz
  `visibility=visible|hidden|all`; `includeHidden` zostaje wspierany jako
  przestarzały alias (`true` → `visibility=all`) i jest tak opisany w OpenAPI.
- `ProjectListItemResponse` publikuje `isHidden`, `version` i `capabilities`,
  `ProjectResponse` — `version` i `capabilities`; nowy
  `ProjectCapabilitiesResponse` niesie `canManage`, `canArchive`, `canDelete`,
  `canManageMembers`, `canCreateTemplate`, `canLeave`, `canTransfer` (ostatnie
  zawsze `false`, bo transferu nie ma — §6.4).
- `version` to nieprzezroczysty `long` mapowany z `uint Xmin`; `expectedVersion`
  obsługują PATCH projektu, archive, restore i preferencje. Konflikty mają
  stabilne kody `project.version_conflict`, `project.preference_version_conflict`
  i `project.archived`, mapowane w `ApiExceptionMiddleware`.
- Reguły ACL są wyrażone raz (`ProjectAccessQueries.AccessibleProjects`), a
  rozstrzyganie roli i rangi trafiło do `ProjectRoleResolution`; mapper listy
  korzysta z istniejącego `ProjectResponseMapper` (bez drugiego mappera).
- Preferencje użytkownika mają własny token wersji (`ProjectUserPreference.Xmin`),
  więc przyjmują `expectedVersion` bez migracji i bez nowych pól encji.
- Walidacja: `dotnet build` — 0 ostrzeżeń, 0 błędów; `dotnet test --filter
  "FullyQualifiedName~Project"` — 136/136 PASS (w tym 8 testów HTTP na realnym
  PostgreSQL: dwie sesje, 409, archiwum, hidden, OpenAPI); pełny zestaw —
  1174 PASS / 4 SKIP / 7 FAIL, gdzie 7 to zastane `MeEndpointsTests`
  (potwierdzone `git stash` bez zmian w projekcie); `dotnet ef migrations script
  --idempotent` — exit 0, brak nowych migracji.
- Otwarte: przepisanie DTO/adapters Frontu na nowe pola oraz `expectedVersion`
  dla `DELETE` i handlerów członkostw.

### 2026-09-19 — PN-P4: atomowy kreator projektu w Backendzie

- `POST /workspaces/{id}/project-setups/preview` waliduje ACL, wersję szablonu
  i zależności, niczego nie zapisuje i zwraca znormalizowany plan z ostrzeżeniami;
  `POST /workspaces/{id}/project-setups` wykonuje całość w jednej transakcji
  PostgreSQL (projekt, workflow, członkowie, ustawienia widoku, harmonogram,
  capacity, automatyzacje, powiadomienia i outbox).
- Idempotencja jest trwała: rekord `workspaceId + userId + klucz` z hashem
  kanonicznego JSON-a żądania i zapisanym wynikiem. Powtórzenie tego samego
  żądania zwraca zapisany wynik (`replayed`), ten sam klucz z innym ciałem to
  409 `project_setup.idempotency_key_conflict`, a równoległe żądanie —
  `project_setup.idempotency_in_progress`. Retencja klucza to 48 godzin
  (konfigurowalna zmienną środowiskową) z zadaniem czyszczącym.
- Endpoint tylko mapuje HTTP: planowanie i zapis żyją w Application, reguły
  w Domain, persystencja i integracje w Infrastructure. Kroki korzystają
  z istniejących serwisów (materializer szablonu, katalog workflow, polityki
  listy i Kanbanu, capacity, powiadomienia) zamiast kopiować ich reguły.
- Migracja addytywna `AddProjectSetupIdempotency` dokłada tabelę rekordów oraz
  kolumnę `projects.DefaultTaskView` (domyślnie `List`, czyli dotychczasowe
  zachowanie); historyczne migracje nietknięte, skrypt idempotentny przechodzi.
- Walidacja: `dotnet build` — 0 ostrzeżeń, 0 błędów; `dotnet test --filter
  "FullyQualifiedName~ProjectSetup"` — 17/17 PASS (13 HTTP na PostgreSQL,
  4 jednostkowe hashera); pełny zestaw — 1191 PASS / 4 SKIP / 7 FAIL, gdzie te
  same 7 testów pada na czystym `HEAD` (MeEndpointsTests, niezwiązane);
  `dotnet ef migrations script --idempotent` — exit 0; `git diff --check` — czysty.
- Otwarte: `defaultTaskView` nie jest jeszcze wystawiony w `GET/PATCH /projects`
  (mały addytywny follow-up), kroki kreatora w Froncie (P5b) i transfer (P7).

### 2026-09-19 — PN-REVIEW-FIX: blokery z review

- Naprawiony [P0]: modele kreatora generowały niekompilujący się kod Freezed;
  adnotacje przeszły na `@Freezed(makeCollectionsUnmodifiable: false)` i pliki
  wygenerowały się ponownie. Pełny `flutter test` — 1077/1077 PASS.
- Shell udostępnia teraz `ProjectsRepository` i `ProjectsGateway` potomkom, więc
  menu projektu w sidebarze ma port mutacji zamiast być wyłączone.
- Preferencja widoku modułu Zadania jest per użytkownik: klucz zawiera `userId`,
  a router wczytuje ją ponownie po zmianie konta w tej samej sesji.
- Backend: `ProjectListItemResponse` publikuje `ArchivedAtUtc`; na działającej
  bazie `--filter Project` daje 153/153 PASS, a łańcuch migracji wykonuje się na
  czystej bazie (potwierdzone historią migracji bazy testowej); skrypt
  idempotentny generuje się z connection stringiem i zawiera nowe obiekty.

### 2026-09-19 — PN-P5b i PN-P1-FRONT: kreator z kroków §5 oraz konsumpcja kontraktu

- Kreator realizuje kroki §5 (start/podstawy/dostęp/workflow/sposób pracy/
  funkcje startowe/podsumowanie) na atomowym kontrakcie `project-setups`:
  jeden `Idempotency-Key` na draft, ponowienie po timeoucie z tym samym
  kluczem, 409 jako trwały błąd, brak projektu w drzewie przed odpowiedzią.
  24 nowe testy widgetowe; pełny `flutter test` — 1143/1143 PASS.
- Front konsumuje kontrakt P1: `isHidden`, `version`, `capabilities`,
  `archivedAtUtc`, `state`/`visibility` w zapytaniu listy, sekcje `Ukryte`
  i `Archiwum` pobierane z serwera (przetrwają restart), menu liczone
  z capabilities zamiast `myRole`, `expectedVersion` przy archiwizacji,
  przywróceniu i preferencjach; brak capabilities daje zachowanie zachowawcze
  z osobnym komunikatem.
- Domknięcia po review: pięć pozostałych dialogów zasobów ma jawny stan
  „brak połączenia w tej sesji” zamiast wyjątku (test to przypina), a backend
  przyjmuje `expectedVersion` także przy trwałym usunięciu projektu.
