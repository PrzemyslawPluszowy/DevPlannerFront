# DevPlanner standalone — handoff zaakceptowanego stanu

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


Data stanu: **2026-09-17**  
Zakres: wyłącznie zaakceptowane pakiety 2D, 3D, 4B, 4C, 4D, 4E, 4F, 4G, 4H,
4I, 4J, 4N, 4O, 4P, 4Q, 4R-B, 4R Front, 4S, 6F i 6G.

Ten handoff jest wspólny dla:

- `/Users/przemyslawnowak/Desktop/dev/DevNote/Backend`
- `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`

Kopie planu i handoffu muszą być byte-for-byte identyczne. Pakiety 4R-B, 4R
Front i 4S obejmują wyłącznie zaakceptowane runtime/docs cleanup; nie zmieniano
historycznych migracji ani testów w ramach synchronizacji dokumentacji.

## Zaakceptowane pakiety

### 2D — sesje urządzeń i refresh tokeny

Zaakceptowane po wspólnym targeted suite **119/119**. Obejmuje lifecycle
`DeviceSession`, persistence, rotację rodzin refresh tokenów oraz revoke.

### 3D — frontend auth/admin/me

Zaakceptowane z `AuthComposition` oraz seamami admin/profile/session w ustalonym
zakresie. Produkcyjny transport i E2E nie są objęte tą akceptacją.

### 4B — schemat domeny, FK i indeksy

Zaakceptowane po poprawce przeglądu CSRF. Akceptacja nie obejmuje pozostałych,
niemigrowanych agregatów.

### 4C — OpenAPI oraz Chat/Notifications `UserId`

Zaakceptowane po korekcie indeksu migracji; walidacja PostgreSQL Notifications
wyniosła **41/41**.

### 4D — Tasks/Kanban lokalny `UserId`

Tasks/Kanban używa lokalnego UUID `UserId` w encjach, kontraktach,
query/handler/mapper, capacity, preferencjach Kanban, realtime/outbox/workers
oraz konfiguracji EF/indexes. Z tego pionu usunięto `*CoreUserId` i legacy Ready.
Nie dodano aliasów, dual-read/write, fallbacku ani backfillu.

Dowody:

- backend build: **0/0**, PASS, zero ostrzeżeń;
- targeted Tasks/Kanban unit/handler suite: **100/100**, PASS (69 + 31);
- idempotentny skrypt migracji EF: PASS.

PostgreSQL integration dla 4D nie zostało zweryfikowane. Filtr zatrzymał się na
nieprawidłowych credentials istniejącej instancji `127.0.0.1:5440`. Jest to
blokada środowiskowa, nie PASS; nie wolno przedstawiać jej jako dowodu działania
migracji na PostgreSQL.

### 4E — Projects/Workspace lokalny `UserId`

Pakiet zaakceptowany dla lokalnego UUID `UserId` w Projects/Workspace.

Dowody:

- backend build: **0/0**, PASS, zero błędów i ostrzeżeń;
- agent gate: **17/17**, PASS;
- dodatkowy root gate: **20**, PASS.

Dwa przypadki `WorkspaceRoleHttpIntegration` zakończyły się niepowodzeniem na
fixture setup, ponieważ środowiskowa baza testowa nie ma tabeli
`veloryn_workspaces.workspaces`. To problem fixture/provisioningu środowiskowej
bazy testowej, a nie błąd logiki. Należy zapewnić tabelę i ponowić te dwa
przypadki.

### 6F/6G — frontendowe typed adapters rename

Globalny Chat (6F) i Notifications (6G) są zaakceptowane w zakresie standalone
runtime wiring oraz rename do typowanych adapterów z lokalnym `UserId`.

Dowody:

- targeted frontend suite: **11/11**, PASS;
- `flutter analyze`: PASS.

Akceptacja nie obejmuje produkcyjnego transportu sesji ani pełnych E2E.

### 4F — frontend auth lokalny `UserId`

Zaakceptowano migrację aktywnego rdzenia auth Fluttera. `AuthUser` używa
kanonicznych pól `String userId` i `login`; w zakresie 4F usunięto aliasy
`CoreUserId`/Ready oraz stare call site'y auth w shellu, routerze, pickerze i
wątkach. Typed `/api/v1/me` jest kontraktem profilu. Nie dodano fallbacku
Ready/Core/DataBus ani dual-read/write.

Dowody:

- `flutter test test/core/auth`: **48/48** PASS;
- `flutter test test/auth`: **16/16** PASS;
- `flutter test test/app/router`: **9/9** PASS;
- suma targeted suite: **73/73** PASS;
- `flutter analyze`: PASS, bez problemów;
- `git diff --check`: PASS.

Pozostałe domenowe DTO frontendu, w szczególności Tasks, Projects i Storage,
są poza zakresem 4F i pozostają do osobnych migracji lokalnego `UserId`.

### 4G — Storage/Office/avatar/share/AI lokalny `UserId`

Storage entities/contracts, ACL, upload/download, Office/OnlyOffice, avatary,
współdzielenie, wyszukiwanie semantyczne i zadania AI używają lokalnego UUID
`UserId`. Usunięto parametry i aliasy `CoreUserId`/Ready oraz fallbacki; testy
bezpośrednie używają wyłącznie `X-Test-User-Id`.

Nie dodano migracji EF: schemat jest już lokalny, a
`StorageUserNotificationPreference` został poprawnie przemianowany w migracji
4C. Dodanie duplikatu migracji byłoby błędem.

Dowody: backend build **0/0**, wybrana suite **135/135** PASS, formatowanie i
`git diff --check` PASS. Szersza bramka HTTP/integration Storage pozostaje
otwarta z powodu fixture `42P01` i standalone guarda legacy environment; nie
jest to PASS.

### 4H — Wiki/Whiteboard/OKR lokalny `UserId`

Wiki/Whiteboard access grants używają `UserId`, Objective używa
`CreatedByUserId`, a StickyNote używa `AssigneeUserIds`; nie ma aliasów ani
fallbacków. Zastosowano rename-only migrację
`20260917074039_UseLocalUserIdForWikiWhiteboardAndOkr`.

Dowody: root selected suite **74/74** PASS (agent narrow **57/57**), build
**0/0**, migracja idempotentna i diff clean. Wiki HTTP/OpenAPI integration
była historycznie blokowana przez legacy JWKS environment; 4O usuwa tę
odziedziczoną konfigurację, ale szersza bramka Wiki HTTP nadal wymaga własnych
ukierunkowanych dowodów.

### 4I — frontend Tasks/Kanban lokalny `UserId`

Tasks/Kanban frontend używa lokalnych pól `userId`, `assigneeUserId`,
`assigneeUserIds` i `userIds` w modelach, payloadach, query, repozytoriach,
realtime oraz UI, w tym w profilach członków projektu, board/list/details,
templates, capacity i workload. Wygenerowane Freezed/JSON/Retrofit zostały
odświeżone; nie ma aliasów, fallbacku ani mapowania Ready/Core.

Dowody: targeted suite **116/116** PASS, generator 182 outputs PASS, scoped
analyze PASS, skan pakietu bez `CoreUserId`/`coreUserId`/`ReadyUserId`/
`readyUserId`/`ready_id`, `git diff --check` PASS. Późniejszy pełny analyze po
4J nie jest dowodem testów E2E Tasks/Kanban.

### 4J — frontend Workspace members, invitations i lokalny katalog

Kontrakty członków workspace i zaproszeń używają `userId`. Lokalny katalog
publikuje `userId`, `login`, `displayName`, `email`, `emailVerified` oraz
`avatarFileId`; repozytorium używa `searchLocalUsers`, bez fallbacku i
dual-read/write. Zaktualizowano bezpośrednie call-site’y Project/Storage oraz
artefakty generowane.

Dowody: focused suite **10/10** PASS, dodatkowa suite kontraktów i konsumentów
**11/11** PASS, generator 5 artefaktów PASS, `flutter analyze` PASS,
`git diff --check` PASS. Pozostałe workspace core `createdByCoreUserId`/
starsza wzmianka o feature actors i legacy DTO została zamknięta przez aktualny
source scan; nie rozszerza to dowodów na pełne E2E/platform.

### 4K — frontend Projects/Workspace core lokalny `UserId`

Zaakceptowano frontendowe kontrakty Projects/Workspace core. `ProjectResponse`,
`ProjectMemberResponse`, `PortfolioResponse` i `WorkspaceResponse`, listy oraz
mappery używają `createdByUserId` i `userId`. Zaktualizowano bezpośrednie
wywołania Project i artefakty generowane; bez aliasów, fallbacku ani
dual-read/write.

Dowody: agent suite **27/27** PASS, dodatkowy test generatora **1/1** PASS,
root cross-package selective suite **18/18** PASS, `flutter analyze` PASS oraz
`git diff --check` PASS. Aktualny source scan nie wykazuje dawniej wskazanych
legacy feature actors/DTO; pełne E2E/platform pozostają osobnym zakresem.

### 4L — frontend Storage/Wiki/Whiteboard/ACL lokalny `UserId`

Zaakceptowano kontrakty frontendowe Storage, Office, avatarów, share i AI oraz
Storage/Wiki/Whiteboard ACL. `Objective` używa `createdByUserId`, sticky notes
`assigneeUserIds`, a artefakty generowane są odświeżone. Zakres nie zawiera
aliasów `CoreUserId`/Ready, fallbacków ani dual-read/write.

Dowody: agent suite **23/23** PASS, root cross-package selective suite
**18/18** PASS, `flutter analyze` PASS oraz `git diff --check` PASS. Pełny
build runner dodatkowo wygenerował workspace responses, ale ich autorytatywnym
źródłem pozostaje pakiet 4K; nie rozszerza to zakresu 4L.

### 4N — backendowe aktywne identity names i transport

Pakiety 4N-A, 4N-B i 4N-C zaakceptowano dla aktywnych warstw backendu. Nie ma
w nich nazw identity `Core`/`Ready`; transport używa kanonicznych nazw
`userId`, `actorUserId` i `authorUserId` w zakresie Ops/Admin, globalnego
wyszukiwania Chat oraz cleanupu Projects. Nie dodano aliasów, fallbacków ani
dual-read/write.

Obowiązuje jedna rename-only migracja
`20260917082352_UseLocalUserIdForOpsInfrastructure`; nie należy utrzymywać
drugiej migracji wykonującej te same rename’y.

Dowody: 4N source scan PASS, backend build **0/0** PASS, idempotentny skrypt
migracji EF PASS, formatowanie PASS i `git diff --check` PASS.

Test HTTP/OpenAPI dla AdminOps i ChatSearch został następnie zamknięty przez
4Q jako **11/11 PASS**; pozostałe szerokie bramki HTTP/integration wymagają
osobnych fixture’ów i nie są przez to automatycznie PASS.

### 4O — standalone test host i lokalny Identity/OpenIddict

Pakiet zaakceptowany dla testowego hosta, fixture’ów i helperów lokalnego
standalone Identity/OpenIddict. Fixture’y testowe czyszczą zabronione,
odziedziczone `WORKSPACES_JWKS_URL`, `WORKSPACES_JWT_ISSUER` i
`WORKSPACES_JWT_AUDIENCE`, a następnie używają lokalnego issuera OpenIddict.
Nie zmieniano produkcyjnej logiki, aliasów ani fallbacków.

Dowody: backend build **0/0** PASS, Local Identity/OpenIddict tests **19/19**
PASS, scoped format verify helpera oraz `git diff --check` PASS.

Pełna weryfikacja formatu projektu ma niezależne, historyczne whitespace
diagnostics i nie jest issue produktu. Wcześniejsze `dotnet format` uruchamiane
z root repo było niejednoznaczne co do wyboru projektu; późniejsze weryfikacje
wykonywać jawnie, np. `dotnet format veloryn-workspaces.csproj
--verify-no-changes`.

### 4P — konkretny kontrakt OpenAPI dla avatarów

Pakiet zaakceptowany dla endpointów `GET /api/v1/me/avatar` i
`GET /api/v1/users/{userId}/avatar`. Usunięto wildcard `image/*`; OpenAPI
publikuje dokładnie `image/jpeg`, `image/png` i `image/webp`, zgodnie z
walidacją uploadu i magic bytes. Upload, storage, cache/ETag i statusy błędów
pozostały bez zmian.

Dowody: backend build **0/0** PASS, OpenAPI avatar content types PASS oraz
avatar upload tests **3/3** PASS.

### 4Q — disposable fixture i kontrakt OpenAPI AdminOps

Pakiet zaakceptowany w zakresie standalone HTTP/OpenAPI. `AdminOpsPostgresFixture`
tworzy losową disposable bazę PostgreSQL, stosuje aktualne migracje
`WorkspaceDbContext` i `LocalIdentityDbContext`, a po testach ją usuwa. OpenAPI
waliduje standalone BFF cookie `BffSessionCookie` (`devplanner.bff`, `apiKey`
w `cookie`), bez `Bearer` i bez wewnętrznego `IdentityCookie`.

Dowody: niezależny build root **0/0** PASS, wybrane testy HTTP/OpenAPI **11/11
PASS** (AdminOps oraz `ApiEndpointTests.ChatSearchRateLimit`) i
`git diff --check` PASS. Pełnej suite nie uruchamiano. Fixture jest wzorcem dla
kolejnych standalone HTTP/integration testów; nie wracać do legacy connection
stringów, Bearer/JWT ani schematu IdentityCookie.

### 4R-B — standalone runtime readiness

Audyt README, `.env.example`, launch settings, `Program.cs`, `start-local.sh` i
Compose potwierdził lokalny standalone runtime bez połączeń Ready/Core/DataBus.
Na świeżej lokalnej bazie wykryto, że ręczna migracja
`20260822160000_AddAutomationRuleArchive` nie była odkrywana przez EF z powodu
braku atrybutów `DbContext`/`Migration`; dodano
`20260917100000_EnsureAutomationRuleArchiveColumn.cs` z guarded SQL.

Dowody: `docker compose config --quiet` PASS, build **0/0** PASS, migracje obu
kontekstów PASS, bounded boot `/health/live` 200, `/health/ready` 200 i Swagger
200. Po poprawce brak błędu `ArchivedAtUtc` oraz nieobsłużonego wyjątku
startowego. Nie uruchamiano pełnej suite, nie commitowano ani nie pushowano.

Pełny `start-local.sh` wymaga Docker Compose oraz usług pomocniczych zależnie od
funkcji (MinIO, ClamAV, Redis, OnlyOffice, Mailpit). Bounded probe użył tylko
disposable lokalnego PostgreSQL; MinIO zgłosił kontrolowany warning, a aplikacja
kontynuowała działanie. Nie wykonano połączeń Ready/Core/DataBus.

### 4R Front i 4S — frontend runtime oraz corrective cleanup

`flutter analyze` po 4S: PASS. Usunięto cały `lib/core/auth`, `AuthApi`, porty
kompatybilności oraz legacy dormant widgets/routes; aktywny Chat otrzymuje
jawny `userId`. Niezależny post-4S Web build przeszedł PASS w **98.7 s**.

### 5A/5B, 5I/5K, 5L/5M, 5N/5O i 5P

Zaakceptowano dormant legacy auth/DataBus cleanup (root build **0/0**, suite
**74/74**), disposable PostgreSQL i hermetyczne Storage/AI (**17/17**), lokalny
test seam `X-Test-User-Id` → `sub` oraz `/me` direct `302` (**1/1**), HTTP/OpenAPI
fixture (**57/57**) i ACL/automatyzacja/realtime proof (**33/33**). Są to dowody
zakresowe, nie pełna macierz E2E/platform.

### 5R — odporność równoczesnej rotacji refresh tokena

Pakiet jest zaakceptowany dla równoczesnych żądań rotacji refresh tokena w
PostgreSQL. Retry wykonuje maksymalnie jedną próbę i tylko wtedy, gdy
`PostgresException.SqlState == "40001"`. Ponowienie obejmuje pełną transakcję
wraz z audytem; rollback nie duplikuje audytu. Drugi request jest fail-closed:
wykrywa reuse i unieważnia rodzinę tokenów.

Dowody:

- `RefreshTokenPostgresConcurrencyTests`: **1/1** PASS;
- `dotnet build veloryn-workspaces.csproj --no-restore`: **0/0** PASS;
- `git diff --check`: PASS.

### 5S — workspace lifecycle, membership, invitations i preferences

Zaakceptowano wyłącznie lifecycle workspace, członkostwa, zaproszenia i
preferencje zweryfikowane na disposable PostgreSQL.

Dowody:

- targeted disposable PostgreSQL gate: **7/7** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

### 5T — Wiki PostgreSQL/HTTP standalone

Zaakceptowano standalone Wiki PostgreSQL/HTTP z `WebApplicationFactory` w
zakresie wskazanego kontraktu HTTP i persistence.

Dowody:

- standalone Wiki PostgreSQL/HTTP gate: **4/4** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

### 5U — frontend bounded auth/session/shell/router

Zaakceptowano bounded frontendowy zakres auth, session, shella i routera.

Dowody:

- targeted frontend suite: **53/53** PASS;
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5V — frontend global Chat/Notifications/realtime contracts

Zaakceptowano frontendowe kontrakty globalnego Chat, Notifications i realtime
wraz z fake/test suite. Ten wynik nie dowodzi live backend SignalR E2E.

Dowody:

- targeted frontend contract/fake suite: **67/67** PASS;
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5W — standalone Task HTTP/OpenAPI matrix

Zaakceptowano standalone Task HTTP/OpenAPI matrix uruchomioną przez
`WebApplicationFactory` i disposable PostgreSQL. Zakres obejmuje smoke test 100
operacji Tasks, role/access, workflow oraz statusy `400/401/403/404/409`. Test
używa wyłącznie GUID `UserId` przez `X-Test-User-Id`; usunięto z niego
wskaźniki/nazwy Ready/Core i legacy environment.

Dowody:

- standalone Task HTTP/OpenAPI matrix: **6/6** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

Nie jest to dowód pełnego E2E produktu.

### 5X — standalone local login backend/BFF

Zaakceptowano lokalne logowanie backendowe `GET/POST /auth/login` z
antiforgery, limitem **10/5 min/IP**, local-only `returnUrl`, aktywnym i
potwierdzonym kontem lokalnym, neutralnymi błędami oraz przejściem Identity
cookie → authorization BFF. Niejednoznaczne dopasowanie loginu/e-maila jest
fail-closed. Public register nie istnieje; provisioning dotyczy tylko
skonfigurowanych klientów OIDC.

Dowody:

- `LocalLogin` + `BffSecurity` + `LocalOpenIddict` +
  `LocalIdentityFoundation`: **36/36** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

Desktop PKCE i real browser E2E pozostają otwarte.

### 5Y — frontend web BFF root

Zaakceptowano frontendowy web BFF root: browser launcher, web composition i
restore przed `runApp`, CTA bez credentials, neutralny redirect bez error flash
oraz brak bearer transportu.

Dowody:

- targeted gates po review: **39/39**, następnie korekta review **24/24** PASS;
- scoped `flutter analyze`: PASS;
- web debug build: PASS.

Desktop PKCE i real browser E2E pozostają otwarte; pakiet nie dowodzi pełnego
E2E.

### 5Z — backend Desktop Authorization Code + PKCE contract

Zaakceptowano backendowy kontrakt Desktop Authorization Code + PKCE. Klient
`devplanner-desktop` jest publiczny i nie używa sekretu; wymagany jest code flow
z PKCE `S256`. Callback ma loopback URI
`http://127.0.0.1:<49152..65535>/callback`. Kontrakt obejmuje rotację,
wykrywanie reuse i revoke refresh-tokenów.

Dowody:

- targeted `LocalOpenIddict`: **13/13** PASS;
- backend build: PASS, bez ostrzeżeń;
- manual visual rendering: PASS.

Transport platformowy Front pozostaje w toku. Browser Playwright E2E jest
celowo zdepriorytetyzowane, a real browser E2E pozostaje otwarte.

### 6E — Desktop PKCE typed transport implementation

Zaakceptowano typed transport Desktop PKCE: publiczny klient
`devplanner-desktop`, Authorization Code + PKCE `S256`, losowany loopback port
`49152..65535` i system browser. Typed transport posiada `state`, `nonce` oraz
`code_verifier`; access token jest tylko w pamięci, refresh token tylko w OS
vault, a rotacja zastępuje wpis w vault. Odczyt autorytatywny to
`GET /api/v1/me/`, revoke to `POST /connect/revocation`, a lokalny vault jest
czyszczony również po błędzie zdalnego revoke. Obsługiwane są ścieżki launcherów
Windows/macOS/Linux.

Dowody:

- backend `LocalOpenIddict` + revocation targeted gates: **17/17** PASS;
- backend build: PASS, bez ostrzeżeń;
- frontend targeted suite: **13/13** PASS;
- scoped `flutter analyze`: PASS.

Ręczna weryfikacja native login/callback/refresh/logout na Windows, macOS i
Linux pozostaje do wykonania; nie należy twierdzić, że zakończyła się sukcesem.
Real browser E2E pozostaje celowo odroczone.

### 6E — macOS manual smoke status

Najnowszy macOS smoke potwierdził zaufany development certificate, discovery
backendu, aktywny native CTA i działający loopback listener. Dostarczenie URL
`/connect/authorize` do przeglądarki nie działa jednak ani przez
`Process.open`, ani przez `url_launcher`, mimo raportowanego sukcesu launchera.
Nie zweryfikowano przez to auth callbacku, sesji, `me`, refresh ani revocation.

Disposable runtime i baza zostały po próbie wyczyszczone. Browser E2E pozostaje
odroczone zgodnie z decyzją użytkownika. Desktop end-to-end jest zablokowane
konkretną usterką launchera i nie może być oznaczone jako ukończone. Wcześniej
HTTP nadal był prawidłowo odrzucany przez OpenIddict `ID2083`; TLS nie wyłączano
i keychain nie zmieniano.

## Otwarte blokady i następne kroki

1. Szerokie bramki HTTP/integration poza zaakceptowanymi zakresami wymagają
   osobnych fixture’ów i dowodów.
2. Wykonać pełne E2E token/session/revoke/realtime oraz walidację platform
   Windows, macOS i Linux. Web debug build jest już PASS (**98.7 s**).

Projekt jako całość pozostaje nieukończony. Nie przywracać aliasów, fallbacków
ani połączeń Ready/Core/DataBus. Nie commitować ani nie pushować bez wyraźnej
dyspozycji użytkownika.

### 2026-09-17 — R1/B0: integracja odzyskanych portów kompozycji rootu Frontu

Włączono tylko dwa produkcyjne pliki wymagane przez aktualny root/router:

- `Front/lib/workspaces/presentation/chat/global_chat_composition.dart`;
- `Front/lib/workspaces/presentation/notifications/global_notifications_composition.dart`.

Nie włączono strony `devplanner_workspaces_page.dart`, ponieważ staging oznacza
ją jako placeholder, ani pliku runtime `partial`. Nie włączono też adapterów Web
SignalR: aktualny kontrakt BFF wymaga jeszcze kompletnego transportu cookie,
CSRF i origin; nie wolno deklarować pozornej obsługi realtime.

Dowody: hash źródeł stagingu i decyzje są w
`Front/docs/recovery/R1-B0-root-integration-report.md`; `dart format`, scoped
`flutter analyze` dla dwóch plików oraz `git diff --check` — PASS. Nadal otwarte:
cały graf zależności `workspaces`, który zawiera importy `package:ready_next`.
Następny krok: osobny pakiet migracji jednego pionu domenowego, zaczynając od
portów Chat/Notifications i ich modeli, bez masowego rename i bez generatora
równolegle z migracją źródeł.

### 2026-09-17 — R1/B1a: foundation error/l10n

Przeniesiono importy aktywnego standalone kodu na istniejące, typowane
powierzchnie foundation bez fizycznego przenoszenia plików:

- `package:devplanner/foundation/error/error.dart` — 7 deklaracji;
- `package:devplanner/foundation/l10n/l10n.dart` — 5 deklaracji.

Objęto admin, me i odpowiadające testy. `flutter analyze` dla 7 źródeł,
`flutter test test/core/error/api_error_test.dart test/admin/...` (15/15) oraz
formatowanie i `git diff --check` zakończyły się PASS. Auth, theme, transport,
root/router/runtime, Chat, Notifications i realtime pozostały nietknięte.

`core/data`, `features/settings` oraz reszta Workspaces zostały jawnie
odroczone: ich bezpośrednie zależności nadal zwracają typy z
`package:ready_next`, więc sama podmiana importu błędu łamie kontrakt
`Either`. Szczegółowy audyt znajduje się w
`Front/docs/recovery/R1-B1a-error-l10n-report.md`.

## Weryfikacja synchronizacji

Po skopiowaniu plików wykonaj oba porównania:

```bash
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-plan.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-plan.md
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-handoff.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-handoff.md
```

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

Zmieniono layout `lib/app/shell/devplanner_shell_layout.dart`, tokeny globalne
`lib/foundation/theme/theme.dart` oraz testy geometrii/typografii. Lewa
kolumna obejmuje teraz nagłówek marki i menu, a oddzielna prawa belka ma 40 px
i zachowuje sekcję bieżącego modułu oraz akcje globalne. Zwijany sidebar ma
52 px; menu ma wiersze 32 px, Inter 11 px i ikony 18 px. Globalny ThemeData
ustala mniejsze role tekstu i spójne ikony 18 px. Nie zmieniono routingu,
Chat, Notifications, API ani kontraktów danych.

Wykonane komendy: `dart format`, scoped `flutter analyze`, `flutter test`
shell/theme/typography (**7/7 PASS**), `flutter build macos --debug` (PASS)
i `git diff --check` (PASS). Następny krok: zamknąć i ponownie uruchomić
desktopową aplikację, a następnie wykonać manualne porównanie z referencją w
trybie jasnym i ciemnym przy 100%, 125% i 150% skalowania tekstu.

### 2026-09-19 — R3t: nowe drzewo lewego menu Workspace

Menu Workspace nie pobiera już projektów dla wszystkich workspace'ów przy
starcie. WorkspaceNavigationTreeCubit pobiera katalog, a projekty ładuje
leniwie dopiero po rozwinięciu gałęzi Projekty; równoległe kliknięcia dzielą
jedno żądanie, a błąd projektu pozostaje lokalny dla workspace'u. Nie zmieniono
kanonicznych tras Lista/Kanban/Files ani nie dodano tras dla nieukończonych
pionów.

Shell otrzymał wąski WorkspaceManagementGateway i przycisk tworzenia
workspace'u. Produkcyjny adapter używa istniejącego POST /api/v1/workspaces/;
po sukcesie katalog odświeża się, nowy workspace jest rozwijany, a aplikacja
przechodzi na jego kanoniczny URL. Chat i Powiadomienia nadal są overlayami,
nie elementami drzewa.

Odbiór: scoped flutter analyze PASS; testy lazy loadingu drzewa oraz shell i
router 23/23 PASS; git diff --check PASS. Nie uruchamiano GUI, Backend,
stagingu ani pełnego buildu platformowego. Następny krok: ręczny odbiór
desktopu z rzeczywistą sesją, w tym utworzenie workspace'u oraz dark/light i
125/150% tekstu.

### 2026-09-19 — R3u: globalne tokeny nawigacji

Dodano `lib/foundation/theme/navigation_theme.dart` i zarejestrowano go w
globalnym `ThemeData`. Shell oraz wszystkie aktywne warianty menu Workspace
używają wspólnych wymiarów: sidebar 224/56 px, nagłówek 56 px, wiersz 28 px,
ikona 18 px, tekst 12 px, etykieta sekcji 11 px, wcięcie 16 px i promień 14 px.
Zmieniono również test geometrii shella oraz test tokenów motywu.

Wykonane komendy: `dart format`, scoped `flutter analyze` (PASS) i targeted
`flutter test` dla motywu, shella oraz menu Workspace (**10/10 PASS**).
Następny krok: ręczne porównanie uruchomionej aplikacji desktopowej z
referencją przy 100%, 125% i 150% skalowania tekstu; należy zweryfikować
widok jasny i ciemny, długie nazwy oraz stan rozwiniętego projektu.

### 2026-09-19 — UX-A1: przekazanie audytu Listy/Kanbanu

Zakres był read-only poza nowym dokumentem planu. Przejrzano aktywny router,
composition Tasks, Listę, Kanban, theme, menu kontekstowe, kontrakty endpointów
Backend oraz historię Git od bootstrapu `d1cc273`.

Najważniejszy blocker: `TasksBoardRoutePage._content` zwraca pełny
`TasksBoardPage` tylko dla `initialView == 'kanban'`. Domyślna Lista i
pozostałe wartości query zwracają bezpośrednio `ProjectTasksList` z
`listenToBoardRealtime: false`. To wyjaśnia brak wspólnego headera i
niedostępność Timeline/Workload/Recurrence po zmianie URL. Nie należy kopiować
brakujących kontrolek do Listy; trzeba usunąć route-level bypass.

Gotowy plan:
`Front/docs/recovery/tasks-list-kanban-ux-recovery-plan.md`. Pierwszy krok T0
naprawia wyłącznie route/composition/query/tests. Potem T1/T2 stabilizują tokeny
i menu, T3 buduje wspólny Tasks chrome, T4 i T5 domykają równolegle Listę i
Kanban, T6 porządkuje ekspozycję istniejących funkcji Backend, a T7 wykonuje
rzeczywisty odbiór live. Nie uruchamiano GUI, Backend ani pełnych bramek, bo
pakiet nie zmienia kodu runtime.

### 2026-09-19 — UX-T0: jeden host Tasks i kontrakt trasy

Regresja kompozycji z `TasksBoardRoutePage` została usunięta: trasa zawsze
montuje ten sam `TasksBoardPage`, więc Lista, Kanban, Timeline, Workload i
Cykliczne dzielą nagłówek, zapisane widoki, ustawienia projektu i lifecycle
realtime.

Kanoniczny kontrakt `?view=` żyje w
`lib/workspaces/presentation/tasks/tasks_project_view_contract.dart`: `/tasks`
otwiera Listę, `?view=kanban` Kanban, `board` pozostaje aliasem wejściowym, a
`list|timeline|workload|recurrence` są rozpoznawane jak dotychczas. Serializacja
Kanbanu pozostała `kanban`, żeby menu projektu, sidebar i deep link używały
jednego adresu; `?view=` buduje wyłącznie
`DevPlannerRouteCatalog.projectTasksView`.

Zachowanie i granice:

- `TasksProjectViewHost` czyta widok wyłącznie z adresu. Per-projektowe
  zapamiętywanie widoku (`tasks_project_view_preferences.dart`) zostało
  usunięte, bo po restarcie mogło wybrać inny widok niż URL.
- `TasksBoardReadyView` nie montuje widoku, którego użytkownik nie otworzył, ale
  trzyma stabilne sloty Listy i Kanbanu. Domyślna Lista nie pobiera więc stron
  kolumn Kanbanu, a powrót między widokami nie gubi scrolla i stanu inline.
- Sidebar porównuje ścieżkę oraz widok z `?view=`, więc `?view=list` zaznacza
  Listę, `?view=kanban` Kanban, a szczegół zadania dziedziczy widok z adresu.
  Wiersz projektu prowadzi bezpośrednio do jego Listy zamiast być martwą pozycją.
- Drzewo nawigacji nie renderuje już pośredniego „Przeglądu”; `/workspaces`
  pozostaje bezpiecznym wejściem (`/` → `/workspaces`) dla konta bez workspace'u.
- Nie zmieniono API ani UI tabeli i boardu.

Dowody: `flutter test` **884/884 PASS**, w tym nowy
`test/app/router/devplanner_tasks_view_route_test.dart` (deep link, alias
wejściowy, restart, zmiana URL w obie strony, historia przeglądarki, zapis
kanonicznego `?view=`, fallback `/`) oraz `test/workspaces/presentation/tasks/tasks_project_view_contract_test.dart`.
Zaktualizowano testy shella i trasy Tasks; współdzielony fixture kompozycji to
`test/test_support/tasks_board_route_fixture.dart`. `flutter analyze`:
**No issues found**, `git diff --check` czysty.

Naprawiono zastany, czerwony test `workspace gateway route can render a real
workspace card`: przy domyślnym 800×600 shell jest compact (<960 px) i nie
renderuje marki, więc test otrzymał jawny rozmiar desktopowy 1280×900. Test
failował także na `eda6e56`, przed tym pakietem.

Ograniczenia: brak odbioru GUI/E2E, Backend nie był uruchamiany, Windows i Linux
pozostają NOT RUN. W drzewie roboczym równolegle pracuje inna sesja agenta
(Codex) rozszerzająca kompozycję Tasks o `ProjectsRepository` i test modali
ustawień projektu; te zmiany zachowano bez modyfikacji. Następny krok: T1 (tokeny
i typografia) oraz T2 (jedna infrastruktura menu).

### 2026-09-19 — UX-T1: tokeny Tasks, podłoga typografii i powierzchnie

Powstało rozszerzenie motywu `lib/foundation/theme/tasks_theme.dart`
(`DevPlannerTasksTheme`), wpięte do `MaterialTheme.theme(...)` dla wariantu
jasnego i ciemnego. Niesie jedną skalę dla całego modułu Tasks:

- typografia: nazwa projektu 15/20 w600, dane 13/18, dane wyróżnione 13/18 w600,
  tytuł karty Kanbanu 14/20 w600, kontrolki 12/16 w600, metadane 11/16, wiersz
  menu 12/16; style dziedziczą rodzinę Inter z motywu aplikacji;
- geometria: wiersz kontekstu 46, wiersz poleceń 38, nagłówek tabeli 36, wiersz
  tabeli 38, wiersz grupy 40, wiersz menu 32 z ikoną 16, promienie 8/8/12,
  odstępy 4/8/12/16/24;
- powierzchnie: `canvas`, `canvasBorder`, `commandBar*`, `card*`, `divider`,
  `rowHover`, `rowSelected`, `bulkBar*`, `selectionAccent`, `onAccent`, `shadow`
  i `scrim`.

Podniesiono globalną podłogę czytelności: `labelMedium` 10 → 12 px i
`labelSmall` 10 → 11 px w `lib/foundation/theme/theme.dart`. To była główna
przyczyna „ściskania do 10 px", bo tabela Listy i metadane kart korzystały
właśnie z tych tokenów.

Usunięte twarde wartości z aktywnego Tasks:

- lokalne tło kanwy (`0xFF11131C` / `0xFFF6F7FB`) zastąpione `tasksTheme.canvas`;
- wszystkie `Colors.white` i `Colors.black` w module zastąpione rolami
  `onAccent`, `shadow` i `scrim` — w module nie pozostało żadne;
- wszystkie rozmiary poniżej 11 px (10, 10.5, 9.5, 9, 8) podniesione do tokenów
  metadanych lub kontrolek — nie pozostało żadne;
- `kanban_card_tokens.dart` wylicza typografię karty z motywu; inicjał awatara
  dostał kolor tokenu, bo wcześniej był 9–10 px bez koloru i zależał od
  domyślnego koloru tekstu.

Zmiana jest celowo wizualna, więc odświeżono trzy goldeny Kanbanu
(`card_comfortable_light.png`, `card_comfortable_dark.png`,
`header_desktop_1280.png`). Artefakty starszego niepowodzenia w
`board/failures/` przywrócono do stanu z repozytorium.

Dowody: pełny `flutter test` **913/913 PASS** (dwa kolejne przebiegi), w tym nowe
`test/foundation/theme/tasks_theme_test.dart` (kontrakt tokenów: rozmiary,
interlinia, siatka 4 px, wysokości wierszy, promienie, powierzchnie z palety,
`copyWith`, `lerp`) oraz
`test/workspaces/presentation/tasks/board/tasks_board_text_scale_test.dart`
(18 kombinacji light/dark × 1024/1440/1920 px × 100/125/150 % bez overflow).
`flutter analyze`: **No issues found**, `git diff --check` czysty.

Uwaga o flake: w jednym z przebiegów pełnego suite czerwony był
`chat_composer_draft_persistence_test.dart` (debounce draftu). Test przechodzi
samodzielnie i w powtórzonym pełnym przebiegu **913/913**; nie dotyczy modułu
Tasks ani motywu.

Ograniczenia i następny krok:

- Semantyczne palety danych (priorytety, statusy, kolory kolumn) pozostały bez
  zmian, bo nie są powierzchniami. Audyt wykrył jednak cztery rozbieżne kopie
  palety priorytetów (timeline, header filters, cards, helper listy) — ich
  ujednolicenie należy do T5/T6.
- Nagłówek i command bar zachowują obecny układ. Tokeny są gotowe, ale
  dwurzędowy chrome z §3.2 buduje T3, a domknięcie Listy i Kanbanu to T4/T5.
- Globalna zmiana tokenów etykiet dotyczy całej aplikacji; pełny suite przechodzi,
  ale odbiór wizualny na Web i macOS pozostaje w T7.

### 2026-09-19 — UX-T2: jedna infrastruktura menu

Wybrany został jeden publiczny komponent: `AppContextMenu`
(`lib/shared/presentation/widgets/app_context_menu.dart`). Zastąpił trzy
współistniejące systemy: `TaskContextMenu` i `WorkspaceContextMenu` (oba pliki
usunięte) oraz warianty `flat`/`glass` (usunięte razem z refleksem, shaderem
i painterem obramowania).

Komponent po przebudowie:

- jedna powierzchnia z tokenów `DevPlannerMenuTheme`
  (`lib/foundation/theme/menu_theme.dart`): wiersz 32 px, ikona 16 px, tekst
  13 px, nagłówek sekcji 11 px, promień 8 px, minimalna szerokość 220 px,
  kolory z palety motywu (bez lokalnych `Colors.white`/`Colors.black`);
- trzy wejścia: `show` (akcje), `select<T>` (wybór wartości), `showCustom`
  (interaktywna zawartość, np. wyszukiwanie osób) oraz `AppContextMenuRegion`
  dla prawego klawisza myszy;
- sekcje (`sectionTitle`, grupowane bez powtórzeń), skróty (`shortcutLabel`),
  `selected`, `enabled`, `isDestructive`, `separatorBefore` i opcjonalne
  `leading`/`trailing`;
- klawiatura: strzałki z zawijaniem, Home, End, Enter, Space; Escape zamyka
  przez `DismissIntent` trasy;
- focus: `FocusScope` i `FocusTraversalGroup` wewnątrz powierzchni, a po
  zamknięciu focus wraca do widgetu, który menu otworzył;
- pozycjonowanie w root overlayu z marginesem 12 px od krawędzi ekranu.

Migracja objęła 48 wywołań `TaskContextMenu.show`/`positionFor` w 22 plikach
modułu Tasks (pickery tabeli, menu wiersza i karty, akcje nagłówka, szablony,
podzadania) oraz wszystkie użycia `WorkspaceContextMenu`. Pickery przyjmują
teraz globalną pozycję `Offset` zamiast `RelativeRect`, a edytor czasu zadania
korzysta z `showCustom` zamiast własnego `showDialog` z ręczną powierzchnią,
cieniem i `TaskDurationPickerAnchor` (plik usunięty jako zbędny).

Dowody: pełny `flutter test` **929/929 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty. Nowe testy:
`test/shared/presentation/widgets/app_context_menu_test.dart` (9 przypadków:
sekcje i skróty, wybór wartości, pozycja wyłączona, kolor destrukcyjny z tokenów
motywu, klawiatura, Escape z powrotem focusu, prawy klik, wykonanie akcji,
pozycjonowanie przy krawędzi ekranu) oraz
`test/shared/presentation/widgets/app_context_menu_boundary_test.dart`
(strażnik: zakres menu bez `core/theme`, bez lokalnych kolorów, bez wariantu
glass i starych klas; pickery korzystają ze wspólnego kontraktu).

Poza zakresem T2, świadomie zostawione do T4/T6: 12 surowych `PopupMenuButton`
w powierzchniach, które T4 przebudowuje (bulk bar 7, filtry 2, zapisane widoki 2)
oraz edytor pól niestandardowych w szczegółach (1). T4 zastępuje te kontrolki
wspólnym command barem, a nie migruje ich jeden do jednego.

Konflikt między sesjami: równoległa sesja agenta wymieniła tekstową markę shella
na logo (`devplanner-sidebar-brand-logo`) w `devplanner_shell_layout.dart` i
zaktualizowała `test/app/shell/devplanner_shell_test.dart`, ale nie
`test/app/router/devplanner_root_router_compile_test.dart`. Dostosowałem tam
jedną asercję (marka to dziś logo z etykietą semantyczną, a nazwę „DevPlanner”
niesie karta workspace'u), żeby suite wrócił do zielonego. Zmiana nie dotyczy
zachowania, tylko reprezentacji marki.

### 2026-09-19 — UX-T3: wspólny dwurzędowy nagłówek Listy i Kanbanu

Nagłówek przestał być kanbanocentryczny: pliki przeniesione do neutralnego
katalogu `lib/workspaces/presentation/tasks/header/`
(`tasks_header.dart`, `tasks_header_layout.dart`, `tasks_header_actions.dart`,
`tasks_header_create_actions.dart`, `tasks_header_command_bar.dart`,
`tasks_header_quick_create_dialog.dart`), a publiczny komponent nazywa się
`TasksHeader`. Moduł montuje teraz publiczny nagłówek, więc Lista i Kanban
używają dokładnie tego samego chrome i testy mają jeden typ do sprawdzenia.

Układ jest zawsze dwuwierszowy (§3.2) na tokenach `DevPlannerTasksTheme`:

- wiersz kontekstu (`contextRowHeight`, 44–48 px): ikona, nazwa projektu,
  licznik zadań, zakładki Lista/Kanban/Timeline/Workload/Cykliczne, obecność
  i menu projektu oraz główne CTA „Dodaj zadanie” z menu szablonów;
- wiersz poleceń (`commandRowHeight`, 36–40 px): zapisane widoki oraz akcje
  zależne od widoku (szybki filtr Kanbanu); po zaznaczeniu zadań ten wiersz
  staje się jednym kontekstowym paskiem akcji masowych, a widokowe kontrolki
  znikają, więc nie renderują się dwa paski naraz.

API nagłówka nie zna już `GoRouter`: wyjście z projektu (opuszczenie lub
usunięcie) dostarcza trasa przez `onProjectExited`, przekazywane przez
`TasksBoardPage` i host widoku.

Dowody: pełny `flutter test` **934/934 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty. Testy: przepisany
`tasks_board_header_responsive_test.dart` (dwa widoki × 360/768/1024/1440/1920 px,
geometria obu wierszy z tokenów, brak overflow, pasek masowy w drugim wierszu),
zaktualizowany `kanban_baseline_audit_test.dart` oraz golden nagłówka
(`goldens/header_desktop_1280.png` odświeżony, bo zmienił się układ), a także
dowód kompozycji w `tasks_board_route_page_test.dart`: ten sam `TasksHeader`
dla wszystkich widoków, wspólne zakładki i zapisane widoki oraz szybki filtr
tylko w widoku Kanbanu, plus sprawdzenie, że trasa dostarcza `onProjectExited`.

Świadomie zostawione do T4/T5: Lista nadal ma własny pływający pasek akcji
masowych oparty na `ProjectTasksListCubit`, a Kanban korzysta z paska nagłówka
opartego na `TasksBoardCubit`. Selekcja obu widoków nie jest jeszcze wspólna,
więc widoczny jest zawsze dokładnie jeden pasek, ale katalog akcji i wspólne
źródło zaznaczenia domyka T4 („usunąć pływający drugi bulk bar”) i T5
(„połączyć bulk z shared contextual bar”). Wiersz poleceń czeka też na filtry,
sortowanie, grupowanie i kolumny Listy, które przenosi T4.

### 2026-09-19 — UX-T4: domknięcie Listy

Wiersz poleceń Listy przeniósł się do wspólnego nagłówka, a Lista nie renderuje
już własnego paska filtrów ani pływającego paska akcji masowych nad treścią.

Nowe elementy (wszystkie w `tasks/list/**`):

- `chrome/task_list_chrome_host.dart` — właściciel stanu Listy. Tworzy
  `ProjectTasksListCubit` i `TaskListPreferencesCubit` **ponad** nagłówkiem,
  dzięki czemu drugi wiersz chrome i tabela opisują ten sam stan; oddaje
  nagłówkowi gotowy `commandBar` i `bulkBar` oraz informację o zaznaczeniu;
- `chrome/task_list_command_bar.dart` — filtry (status, priorytet, osoba,
  udział, przypięte), sortowanie, kierunek, grupowanie, kolumny i
  „Wyczyść wszystko”. Wszystkie menu używają wspólnego `AppContextMenu`, więc
  w Listnie nie ma już surowych `PopupMenuButton` od filtrów;
- `chrome/task_saved_view_selection.dart` — jedno miejsce wyprowadzające aktywny
  zapisany widok (id, grupowanie, kolumny, pola własne), używane przez nagłówek
  i treść Listy;
- `bulk/task_list_bulk_bar.dart` — przepisany na tokeny i wspólne menu:
  przewijany poziomo, wysokość kontrolki 28 px w wierszu 38 px, zachowane akcje
  (status, priorytet, termin dziś, wykonawca, archiwizacja, „Cały wynik” przez
  selection token oraz czyszczenie zaznaczenia). Siedem surowych
  `PopupMenuButton` zniknęło.

Usunięte: `filters/task_list_filters.dart` (jego kontrolki zastąpił command bar;
`TaskListFailureView` przeniesiony do `table/task_list_failure_view.dart`) oraz
pływający `TaskListBulkBar` z `task_list_table_view.part.dart`.

Nagłówek dostał sloty `commandBar`, `bulkBar` i `showBulkBar`, a
`ProjectTasksList` przyjmuje cubity od właściciela chrome (samodzielne użycie
nadal tworzy własne i je zamyka).

Dowody: pełny `flutter test` **940/940 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty. Nowe testy
`test/workspaces/presentation/tasks/list/chrome/task_list_chrome_test.dart`
(wiersz poleceń z filtrami/sort/grupowaniem/kolumnami, filtr statusu przez
wspólne menu z przeładowaniem zapytania, „Wyczyść wszystko”, zapis sortowania w
preferencjach, brak overflow przy 640 px, przełączenie na pasek akcji masowych i
zmiana statusu zaznaczonych). W teście trasy doszły asercje kompozycji: kontrolki
Listy są w drugim wierszu `TasksHeader`, a `TaskListBulkBar` nie istnieje poza
nagłówkiem.

Pozostawione świadomie: dwa `PopupMenuButton` w `views/widgets/task_saved_views_menu.dart`
(menu zapisanych widoków, poza katalogiem `tasks/list/**`) i jeden w edytorze pól
niestandardowych szczegółu — do domknięcia w T6.

### 2026-09-19 — macOS: stabilny podpis Keychain dla Debug/Profile

Cel: zatrzymać prompt macOS przy każdym hot resecie, gdy desktopowy PKCE czyta
i rotuje refresh token w Keychain.

Zmiana:

- `macos/Runner.xcodeproj/project.pbxproj`: Debug i Profile używają ręcznie
  wskazanego certyfikatu `Apple Development: Przemyslaw Nowak (9CZ5DH8V7A)`;
  usunięto odziedziczone wymuszenie `CODE_SIGN_IDENTITY = "-"` dla konfiguracji
  projektu. Release zachowuje poprzedni podpis ad-hoc, więc produkcyjny proces
  dystrybucji nie został domyślnie przekierowany na lokalny certyfikat.
- Nie podpinano `DebugProfile.entitlements`: wymagałoby to provisioning profile
  dla `com.excellent.devplanner`, którego lokalny account nie posiada. Aplikacja
  nadal używa zwykłego, szyfrowanego Keychain zgodnie z adapterem
  `platform_secure_secret_store_io.dart`.

Weryfikacja:

- `flutter build macos --debug`: PASS;
- `codesign --verify --deep --strict --verbose=2 .../DevPlanner.app`: PASS;
- requirement podpisu: identifier `com.excellent.devplanner`, Apple anchor i
  stały certyfikat Apple Development; nie jest to już Signature=adhoc;
- `flutter test test/auth/auth_platform_adapters_test.dart --reporter compact`:
  **8/8 PASS**;
- pierwsze uruchomienie nowego artefaktu przywróciło sesję i wyświetliło
  workspace bez promptu Keychain;
- `flutter analyze`: NOT PASS wyłącznie przez istniejące, niezwiązane błędy w
  brudnym `test/workspaces/presentation/tasks/board/tasks_board_bulk_bar_test.dart`.

Następny krok: użytkownik wykonuje `R`/hot restart w aktywnej sesji; prompt
Keychain nie powinien wracać. Jeśli pozostał pojedynczy prompt po migracji
podpisu, zatwierdzić go dla podpisanej aplikacji, a nie usuwać całego Keychain.

### 2026-09-19 — UX-T5: domknięcie Kanbanu

Pasek akcji masowych Kanbanu używa teraz tego samego komponentu co Lista:
`lib/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart`
(`TasksContextualBulkBar` + `TasksBulkButton` + `TasksBulkMenu`). Powstał w
neutralnym katalogu modułu, więc obie strony mają identyczny wygląd, przewijanie
poziome, licznik z ARB (`tasksBulkSelected`) i obsługę przez wspólne menu.
Zestaw akcji pozostaje zależny od widoku i ACL, zgodnie z §4 planu: Kanban
przenosi zaznaczone karty między kolumnami (`board_bulk_move`), zmienia priorytet
(`board_bulk_priority`) i termin (`board_bulk_due_date`); Lista ma dodatkowo
status, wykonawcę, archiwizację i „Cały wynik” przez selection token.

Pasek Listy przepisany na ten sam komponent (usunięte lokalne kopie kontrolek),
a `_BulkSelectionToolbar` w nagłówku zastąpiony wspólnym paskiem z akcjami
boardu. Przy okazji nazwy pomocników nagłówka przestały być kanbanocentryczne
(`_TasksHeaderHelpers`).

Potwierdzone zachowania Kanbanu (testy istniejące, wskazane jako dowód):

- paginacja kolumny i doładowanie strony: `tasks_board_cubit_test.dart`
  („ładuje snapshot, presence i kolejną stronę jednej kolumny”);
- zwijanie kolumn z wersją preferencji oraz zachowanie zwiniętych kolumn przy
  zmianie szybkiego filtra: dwa testy w tym samym pliku;
- DnD z optimistic move, korektą indeksu w tej samej kolumnie i blokadą
  niedozwoloną przez workflow: trzy testy;
- rollback 409 z komunikatem przyczyny: „przy błędzie przywraca tablicę sprzed
  optimistic move” (używa `ApiErrorType.conflict` i sprawdza `mutationError`);
- realtime: testy wypychające zdarzenia przez `TaskProjectRealtime`
  (`resync po status realtime zachowuje jego rewizję dla widoku listy`).

Nowy test `test/workspaces/presentation/tasks/board/tasks_board_bulk_bar_test.dart`
montuje realny `TasksBoardCubit` i dowodzi, że po zaznaczeniu kart drugi wiersz
nagłówka renderuje `TasksContextualBulkBar` z licznikiem „Wybrano: 2”, a wybór
kolumny wywołuje `bulkMove` na repozytorium boardu z identyfikatorami
zaznaczonych kart.

Dowody: pełny `flutter test` **941/941 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty.

### 2026-09-19 — AUTH-AUDIT: przekazanie planu sesji desktopowej

Zakres był read-only poza dokumentacją. Przejrzano aktywną kompozycję auth
Fluttera, Desktop Authorization Code + PKCE, vault macOS, wspólny transport
HTTP, provider SignalR, backendowy OpenIddict, lifecycle rodzin refresh tokenów,
revocation i rzeczywisty podpis artefaktu macOS.

Najważniejsze ustalenia:

- Keychain jest właściwym magazynem refresh tokena; wcześniejszy prompt storm
  wynikał z niestabilnej tożsamości podpisu, a aktualny podpis lokalny działa;
- runtime nie odświeża access tokena po wygaśnięciu/401;
- fallback `DevPlannerHttpTransport` może w przyszłej błędnej kompozycji użyć
  refresh tokena jako Bearera;
- nowy refresh token jest zapisywany dopiero po `/me`, więc przejściowy błąd
  profilu po udanej rotacji może pozostawić w vault zużyty token;
- REST i SignalR nie mają jednego koordynatora single-flight;
- klient wysyła OIDC `nonce`, ale nie waliduje ID tokena;
- backendowy refresh/reuse/revoke jest mocnym fundamentem, lecz natychmiastowy
  revoke już wydanego access tokena i aktywnego SignalR wymaga osobnego dowodu;
- osobisty certyfikat Debug/Profile w `project.pbxproj` nie jest przenośny, a
  Release nadal nie ma gotowego procesu podpisu/notarization.

Gotowy plan:
`Front/docs/recovery/desktop-auth-session-hardening-plan.md`. Pakiety A0–F1 są
sekwencyjne i zawierają ownership, zakazy, czerwone testy, kontrakty rotacji,
single-flight, REST retry, SignalR, backend revoke, decyzję OAuth zamiast
połowicznego OIDC, callback hardening, podpis macOS oraz pełną macierz live.
Nie zmieniano kodu runtime, migracji ani testów i nie uruchamiano bramek jako
dowodu implementacji. Następny dozwolony krok: A0.

### 2026-09-19 — AUTH-A1: wynik pakietu trwałej rotacji

Zmieniono wyłącznie Frontowy adapter Desktop PKCE i jego test doubles.
`DesktopTokenResult` oddziela odpowiedź token endpoint od profilu, zawiera
access token, refresh token i walidowany dodatni `expiresIn`. Adapter zapisuje
refresh token przed `fetchCurrentUser`; błąd profilu zachowuje nowy credential
na kolejny restore. Błąd vaulta nie publikuje sesji i wykonuje best-effort
revocation nowego tokena bez logowania jego wartości.

Dodane testy potwierdzają kolejność write → `/me`, przeżycie błędu `/me` oraz
revocation po błędzie Keychain. Dowody: `flutter test test/auth --reporter
compact` **29/29 PASS**, scoped analyzer **No issues found**, scoped `git diff
--check` PASS. Pełny analyzer i native E2E: NOT RUN. Następny pakiet: A2.

### 2026-09-19 — UX-T6: discoverability, martwe pozycje i domknięcie menu

Drzewo nawigacji renderuje wyłącznie pozycje z aktywną trasą. Zniknęły
Automatyzacje, Whiteboardy, Tablica korkowa i Wiki, a projekt pokazuje Zadania
(Lista, Kanban) oraz Pliki. Kontrakt `WorkspaceNavigationTree.projectResourceKinds`
opisuje teraz realnie renderowane zasoby, a rodzaje modułów zostają w enumie i
wrócą razem z własnymi trasami — pozycja bez trasy nie udaje działającej funkcji.

Ostatnie surowe menu w Tasks zniknęły (w module nie ma już ani jednego
`PopupMenuButton`):

- menu zapisanych widoków korzysta ze wspólnego `AppContextMenu.select`, a
  zarządzanie widokiem (konfiguracja, zmiana nazwy, usunięcie) to drugi krok
  tego samego menu; wiersze widoków zachowały znacznik „dirty” przez `trailing`,
  a wyłączony `OutlinedButton` w triggerze zastąpił kontener o tym samym
  wyglądzie, żeby klik docierał do aktywatora;
- wielokrotny wybór wartości pola niestandardowego w szczegółach zadania używa
  wspólnego menu z zaznaczeniem pozycji.

Zmiana poza pakietami planu, ale wprost zgłoszona w audycie: na wąskim oknie
(<960 px) pasek boczny zwijał się do ikon, a przez to drzewo stawało się
nieosiągalne. Teraz ten sam klawisz otwiera je w nakładce nad treścią (z
przygaszonym tłem i zamykaniem przez klik poza), a po zamknięciu wraca pasek
ikoniczny. Nowy test w `test/app/shell/devplanner_shell_test.dart` sprawdza
otwarcie i zamknięcie nakładki.

Discoverability: nie dodawano żadnego endpointu ani nie zmieniano kontraktu
Backendu; akcje pozostają ukrywane na podstawie capabilities projektu
(`canManage` dla ustawień i WIP), a Backend nadal autoryzuje każdą operację.

Dowody: pełny `flutter test` **945/945 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty.

### 2026-09-19 — UX-T7 (częściowo): bramki buildów i żywy Backend, scenariusz GUI NOT RUN

Ten pakiet jest odbiorem rootu i obejmuje uruchomienie całego stosu. W tej sesji
wykonano część bramek i udokumentowano resztę jako NOT RUN, bez przedstawiania
części jako pełnego odbioru.

Wykonane i potwierdzone dowodami:

- `flutter build web --wasm` — **PASS** (`✓ Built build/web`).
- `flutter build macos --debug` — **PASS**
  (`✓ Built build/macos/Build/Products/Debug/DevPlanner.app`). Pierwsza próba
  padła w trakcie równoległej edycji drzewa przez inną sesję agenta
  (`Target kernel_snapshot_program failed`), powtórzenie przeszło.
- `flutter analyze` — **No issues found**; pełny `flutter test` — **945/945 PASS**;
  `git diff --check` czysty w obu repozytoriach.
- Stos lokalny działa: kontenery `backend-postgres-1` (przyjmuje połączenia),
  `backend-redis-1`, `backend-minio-1`, `backend-mailpit-1`,
  `backend-clamav-1`, `backend-onlyoffice-1`; API wstało przez
  `Backend/start-local.sh` na `http://localhost:5072` w trybie Development.
- Kontrakt na żywo: `GET /swagger/v1/swagger.json` zwraca **350** ścieżek, w tym
  wszystkie używane przez frontend Tasks/Kanban (`/tasks/groups`, `/kanban`,
  `/kanban/bulk-move`, `/kanban/bulk-update`, `/tasks/selection-token/bulk`,
  `/me/tasks`).
- Autoryzacja na żywo: `tasks/groups`, `kanban` i `me/tasks` zwracają **401**
  bez tokenu, a `POST /api/v1/realtime/{tasks,chat,notifications}/negotiate`
  również **401** — huby SignalR istnieją i wymagają sesji, zgodnie z route'ami
  z `Endpoints/Tasks/ProjectTaskEndpoints.cs`.

NOT RUN z powodem (nie zaliczam tego jako odbioru):

- scenariusz live GUI (create → inline edit → details → List ↔ Kanban → DnD →
  bulk → saved view → restart) — wymaga zalogowanej sesji BFF/PKCE; logowanie
  idzie przez aktywację e-mailem (Mailpit), więc nie zostało wykonane skryptem
  w tej sesji;
- dwa konta i revoke dostępu, weryfikacja SignalR w locie oraz pomiary
  PostgreSQL po mutacjach;
- screenshoty 1024×768 / 1440×900 / 1920×1080 w jasnym i ciemnym motywie;
- `flutter build windows` i `flutter build linux` — brak hosta (NOT RUN, nie
  sukces).

Uruchomiony przeze mnie proces API działa w tle (`start-local.sh` z `nohup`);
zatrzymanie: `pkill -f veloryn-workspaces`.

### 2026-09-19 — UX-T7 zamknięcie sesji: buildy i kontrakt live PASS, GUI odroczone decyzją właściciela

Właściciel zdecydował, że w tej sesji nie wykonujemy fizycznych testów GUI.
Zgodnie z tym decyzją pakiet T7 **nie jest odebrany** i nie jest tak
przedstawiany; poniżej stan zamknięcia sesji.

Wykonane i potwierdzone:

- `flutter build web --wasm` — PASS; `flutter build macos --debug` — PASS;
- `flutter analyze` — No issues found; pełny `flutter test` — **952/952 PASS**;
  `git diff --check` czysty w obu repozytoriach; plan i handoff identyczne (`cmp`);
- żywy stos backendu: PostgreSQL (5440), Redis, MinIO, Mailpit, ClamAV,
  OnlyOffice; API wystawia 350 ścieżek OpenAPI, a `tasks/groups`, `kanban`,
  `me/tasks` i negocjacje hubów SignalR zwracają 401 bez tokenu;
- domknięta ostatnia luka w automatycznym pokryciu kroku „inline edit”:
  `project_tasks_list_cubit_test.dart` ma teraz test rollbacku dla błędu
  nie-konfliktowego (wiersz wraca do poprzedniej wartości, komunikat błędu
  zostaje przypięty do tego samego wiersza), obok istniejącego testu 409.

Odroczone decyzją właściciela: scenariusz GUI, dwa konta z revoke, screenshoty
1024×768 / 1440×900 / 1920×1080 w light/dark. NOT RUN z braku hosta:
`flutter build windows`, `flutter build linux`.

Runbook dokończenia odbioru zapisano w
`docs/recovery/tasks-list-kanban-ux-recovery-plan.md` (sekcja T7): uruchomienie
stosu, trzy dopuszczalne ścieżki uzyskania loginu (hasło właściciela, reset
przez lokalny Mailpit z SMTP włączonym tylko w środowisku procesu, albo nowy
bootstrap administratora przez `start-desktop-auth-local.sh
--bootstrap-local-admin`), uruchomienie frontu na macOS lub Web oraz lista
kroków scenariusza i pomiarów.

Stan środowiska po sesji: lokalne API zatrzymane, kontenery Docker działają;
brak commitów — wszystkie zmiany pozostają w drzewie roboczym, moje wyłącznie
poza `lib/auth/**`, które należy do równoległej sesji agenta (desktop PKCE).

### 2026-09-19 — UX-T7: zrzuty widoków z realnej kompozycji (substytut bez GUI)

Skoro odbiór GUI jest odroczony decyzją właściciela, przygotowałem materiał do
przeglądu bez uruchamiania aplikacji: test
`test/workspaces/presentation/tasks/board/tasks_visual_capture_test.dart`
renderuje ten sam widget trasy Tasks z hermetycznym fixture'em, w motywie
produktu (`MaterialTheme.crm()`), z załadowanym Inter i ikonami, i zapisuje
12 obrazów do `docs/recovery/visual-captures/`:

- `lista_{1024x768,1440x900,1920x1080}_{light,dark}.png`,
- `kanban_{1024x768,1440x900,1920x1080}_{light,dark}.png`.

Zrzuty są czytelne (prawdziwe fonty i ikony) i pokazują to, co plan wymagał
obejrzeć: dwa wiersze wspólnego chrome (kontekst 44–48 px i polecenia 36–40 px),
ten sam nagłówek i command bar w Liście i Kanbanie, kolejkę poleceń w wierszu
drugim, kartę i nagłówek kolumny Kanbanu oraz tokenowe powierzchnie w trybie
jasnym i ciemnym. Test przy okazji pilnuje braku przepełnień na tych
rozdzielczościach (`takeException()` dla każdej kombinacji).

To nadal **nie jest odbiór GUI/E2E**: obrazy pochodzą z renderu widgetów
z fixture'em, a nie z aplikacji połączonej z żywym Backendem, więc nie zastępują
scenariusza z sekcji T7 planu.

### 2026-09-19 — AUTH-E1: podpis Debug/Profile

Dodano wersjonowaną politykę `macos/Runner/Configs/Signing.xcconfig`, przykład
lokalnego override i ignorowanie właściwego `Signing.local.xcconfig`. Build
Debug korzysta z lokalnej Apple Development identity bez wpisywania jej common
name ani Team ID do projektu. Dwa następujące buildy mają identyczny designated
requirement; `codesign --verify --deep --strict` przeszedł.

E2 pozostaje NOT RUN: lokalny Keychain nie ma macOS provisioning profile dla
`com.excellent.devplanner`, a zatem nie wykonano sandboxowego Release,
notarization ani Gatekeeper testu na czystym koncie.

### 2026-09-19 — AUTH-A2–D1, B1–B2, C1: backendowy revoke i token lifecycle

Desktopowy adapter ma wspólny single-flight access-token lifecycle, trwały zapis
rotacji przed `/me`, bezpieczną klasyfikację `invalid_grant` oraz jeden retry
401 dla REST. SignalR korzysta z tego samego providera. Backend wydaje
10-minutowy access token i sprawdza `sub` oraz `devplanner_session_id` wobec
aktywnej sesji, stanu konta i SecurityVersion przy każdym desktopowym bearerze.

Revoke po commit publikuje `sessionId` do Redis i abortuje wyłącznie właściwe
połączenia wszystkich hubów. Dowody: Front auth/HTTP/realtime test suite PASS,
Backend identity/realtime targeted suite PASS oraz dwuhostowy registry test z
dwoma `ConnectionMultiplexer` i lokalnym Redis `localhost:6379` PASS (3/3).
E2 i F1 nadal wymagają provisioning/notarization oraz ręcznego realnego E2E.

### 2026-09-19 — AUTH-A4: logout mimo błędu revoke

`AuthUseCases` ustawia `signedOut` w `finally`. Gdy revoke offline rzuca błąd,
adapter nadal usuwa refresh credential, a runtime otrzymuje zdarzenie kończące
realtime. Test `auth_foundation_test.dart` pokrywa ten wariant (PASS).

### 2026-09-19 — Audyt parytetu Listy/Kanbanu: ustalenia i plan N0–N7

Po domknięciu T7 przeszedłem kod obu repozytoriów pod kątem parytetu widoków
i zgłoszonych defektów UI. Ustalenia z dowodami:

- Filtry nie są równe: Lista ma status, priorytet, osobę, udział, przypięte,
  sortowanie, kierunek, grupowanie i kolumny; Kanban tylko szybki filtr.
  Mechanizm filtrowania na boardzie istnieje (`ApplyQuickFilter` w
  `KanbanBoardReader`, filtry wykonawcy/priorytetu/kamienia milowego w endpointcie
  kolumny, wykonywane w PostgreSQL), ale klient przekazuje do kolumny **tylko
  kursor** (`tasks_board_preference_commands.dart:149,155`), a board cubit nie zna
  `savedViewId`, więc filtr zapisanego widoku nie działa na Kanbanie.
- `GET /kanban` nie przyjmuje żadnych filtrów, więc bez rozszerzenia kontraktu
  liczniki kolumn i WIP nie mogą być spójne z filtrowanymi kartami.
- `KanbanSettingsCubit` (ukryte kolumny, WIP, gęstość, pola karty) **nie ma
  konsumenta** — cała powierzchnia ustawień boardu jest nieosiągalna w UI,
  mimo że Backend ją obsługuje.
- `swimlaneMode` jest tylko przechowywany i odsyłany; nie ma renderowania torów
  ani w Backendzie, ani w kliencie, więc wystawienie grupowania teraz byłoby
  martwą kontrolką.
- Modal ustawień: `_NavigationButton` (`project_settings_modal_frame.dart:339`)
  używa `TextButton.icon` bez `alignment`, więc pozycje są wyśrodkowane; plik
  pracuje na `core/theme`/`core/l10n` i twardych stringach poza ARB (37 plików
  w `projects/settings/**`).
- Menu zapisanego widoku (`task_saved_views_menu.dart:224`) ma zdublowaną
  pozycję „Zarządzaj" pod każdym widokiem i otwiera drugie menu zakotwiczone
  w triggerze — regresja z migracji menu w T6.

Plan naprawy z pakietami N0–N7, deltami Backendu i bramkami:
`docs/recovery/tasks-parity-and-ui-repair-plan.md` (kopia w Backendzie, `cmp`
identyczny). Rekomendowana kolejność: N0 (dwa defekty UI) i N1 (parytet filtrów
po stronie klienta) równolegle, N2 (opcjonalne filtry `GET /kanban`) po stronie
Backendu, potem N3 (ustawienia boardu w UI) i N4 (jedno wejście do zapisanych
widoków plus akcje masowe Kanbanu). N5 (modal ustawień na tokenach i w ARB)
wymaga uzgodnienia z sesją, która edytuje `projects/settings/**`. N6 to decyzja
o swimlane, N7 domyka odbiór.

W tym przeglądzie nie zmieniałem kodu runtime ani nie dotykałem plików
`lib/auth/**` należących do równoległej sesji.

### 2026-09-19 — UX-N0: nawigacja modala ustawień i wiersz akcji zapisanego widoku

Zamknięty pakiet N0 z planu parytetu (dwa defekty wskazane przez właściciela).

Pliki i decyzje:

- `lib/workspaces/presentation/projects/settings/widgets/project_settings_modal_frame.dart`
  — `_NavigationButton` ma jedną implementację dla obu wariantów i wyrównuje
  treść do lewej: `alignment: AlignmentDirectional.centerStart`, stała wysokość
  `Sizes.p36`, wcięcie 8 px wiersza i 12 px treści, `tapTargetSize.shrinkWrap`,
  tło `surfaceRoles.tintedBackground` + obramowanie `tintedBorder` dla pozycji
  zaznaczonej, `overlayColor` z `WidgetStateProperty` (`pressedOverlay`
  /`hoverOverlay`) i waga `w700`/`w600`. Nagłówki sekcji dostały to samo
  wcięcie 16 px co ikony pozycji. Wariant kompaktowy (okno < 768 px) to teraz
  zwarty chip 36 px wyśrodkowany w 44 px pasku, przewijany poziomo.
- `lib/workspaces/presentation/tasks/views/widgets/task_saved_views_menu.dart`
  — każdy wiersz widoku ma jedno „…" (`_SavedViewRowActions`), które liczy
  kotwicę w kontekście klikniętego wiersza, zamyka menu listy (`Navigator.pop`)
  i dopiero wtedy otwiera menu akcji widoku; nagłówkiem drugiego menu jest nazwa
  widoku, więc „Zapisane widoki" występuje raz. Usunięty wariant
  `TaskSavedViewMenuActionManage` i tekstowa pozycja „Zarządzaj" spod każdego
  widoku. Akcje widoku (zmiana nazwy, konfiguracja, usunięcie) dostały żywy
  kontekst strony zamiast kontekstu wiersza menu, dzięki czemu dialogi nie
  otwierają się z już zdjętego elementu.

Testy (nowe, wszystkie przechodzą):

- `test/workspaces/presentation/projects/settings/project_settings_modal_navigation_test.dart`
  — 5 przypadków: wspólna linia tekstu wszystkich pozycji i brak wyśrodkowania,
  stała wysokość wiersza, tło i obramowanie dokładnie jednej aktywnej pozycji,
  przeniesienie zaznaczenia po kliknięciu, kompaktowy pasek bez błędów układu.
- `test/workspaces/presentation/tasks/views/widgets/task_saved_views_menu_test.dart`
  — nowy przypadek: jedno „…" na widok, brak tekstowego duplikatu, zamknięcie
  listy pod spodem, kotwica w klikniętym wierszu (x i y), brak zmiany aktywnego
  widoku po kliknięciu „…"; mock repozytorium przyjmuje teraz listę widoków.
- Kontrola mutacyjna: na wersji `HEAD` modala wszystkie 5 testów pada; po
  cofnięciu kotwicy w menu akcji test kotwicy pada z `Expected: > 152.0,
  Actual: <52.0>`. Testy pilnują więc poprawki, a nie bieżącego stanu.

Bramki:

- `flutter analyze` — No issues found (całe repo).
- `flutter test` — 992/992 PASS.
- `flutter build web --wasm` — PASS (pierwsze uruchomienie padło z exit -15,
  bo proces budowania został uśmiercony przez zamknięcie powłoki narzędzia;
  powtórzone bez `&` kończy się `✓ Built build/web`).
- `git diff --check` — czysty.
- Nie uruchamiałem buildów Windows/Linux (brak hosta) i nie zmieniałem ARB.

Znalezisko przy okazji (defekt zastany, nie regresja N0): przy oknie 700 px
zakładka Szablony przelewa się o 53 px — `project_template_card.dart:88`
w `Row` z linii 62, bo próg `isNarrow < 580` (linia 45) nie łapie przypadku,
w którym same akcje karty są szersze niż próg. Powtarza się na `HEAD` po
cofnięciu zmian N0. Dopisane do planu jako §2.8 i do N5.

Następny krok: N1 (parytet filtrów Kanbanu po stronie klienta: przekazać
`priority`/`assigneeUserId`/`milestoneId` do `KanbanColumnQuery` i wystawić je
w wierszu poleceń) równolegle z N2 (Backend: opcjonalne filtry `GET /kanban`).
N5 tylko po uzgodnieniu z właścicielem `projects/settings/**`, bo N0 zmienił
tam jeden plik.

### 2026-09-19 — BE-N2: opcjonalne filtry boardu Kanban (Backend)

Zamknięta pierwsza część N2: filtry wykonawcy, priorytetu i kamienia milowego na
`GET /kanban`, tak aby liczniki kolumn, karty i kursor stron opisywały dokładnie
to samo. `savedViewId` świadomie odłożony do N2b (wymiary zapisanego widoku,
których board nie modeluje: etykiety, zaangażowanie, szukanie, daty, przypięte).

Zmiany:

- `Contracts/Kanban/KanbanContracts.cs` — `KanbanBoardQuery` z
  `AssigneeUserId`/`Priority`/`MilestoneId`, właściwością `IsFiltered` oraz
  `ToColumnQuery()`, która przenosi filtry tablicy na kursor kolumny.
- `Endpoints/Kanban/KanbanEndpoints.cs` — `GET /kanban` przyjmuje
  `[AsParameters] KanbanBoardQuery`; opis endpointu mówi o wspólnym zestawie
  filtrów dla liczników, kart i kursora.
- `Application/Kanban/KanbanBoardReader.cs` — nowa predykata `ApplyBoardFilter`
  dołożona do zapytania liczników, pierwszych stron kolumn i własnych kolumn
  (razem z ich licznikiem); kursory (`EncodeCursor`, `EncodeCustomCursor`)
  powstają z `query.ToColumnQuery()`, dzięki czemu kolejne strony dziedziczą
  filtry, a kursor użyty bez filtrów zwraca `400 validation.failed`;
  `ValidateBoardQuery` odrzuca pusty UUID i niezdefiniowany priorytet.
- `Application/Kanban/{IKanbanBoardReader,KanbanService}.cs` — sygnatury
  przenoszą filtr; kontrakt HTTP rozszerzony addytywnie, bez zmiany kształtu
  odpowiedzi.

Testy i bramki:

- `Tests/Veloryn.Workspaces.Tests/KanbanServiceTests.cs` +4 przypadki
  (spójność licznika i kart dla trzech filtrów; dziedziczenie filtrów przez
  kursor i odrzucenie kursora bez filtrów; własna kolumna z filtrem; walidacja),
- `Tests/Veloryn.Workspaces.Tests/KanbanEndpointTests.cs` +1 przypadek HTTP
  (liczniki, karty i strona kolumny po filtrze; `400 validation.failed` dla
  pustego UUID, `400 request.invalid` dla nieczytelnego priorytetu),
- `dotnet build` aplikacji, testów i harnessu bez błędów,
- `dotnet test --filter FullyQualifiedName~Kanban` — 56/56 PASS (jednostkowe,
  HTTP na realnym PostgreSQL, kontrakt OpenAPI, integracyjne),
- `git diff --check` czysty w obu repozytoriach.

Live HTTP na stosie lokalnym: **NIE URUCHOMIONE**. Stary proces API (pid 30141,
sprzątanie po T7) działał na poprzednim buildzie i został zatrzymany; nowy build
wymaga ponownego startu i logowania BFF (cookie + CSRF). Zachowanie HTTP jest
pokryte testem przechodzącym przez pełny pipeline ASP.NET z realnym PostgreSQL,
a odbiór live pozostaje w N7.

Następny krok: N1 (klient wystawia trzy filtry w wierszu poleceń Kanbanu i
przekazuje je do `GET /kanban` oraz do `KanbanColumnQuery` przy doładowaniu
kolumn), potem N2b (`savedViewId` na boardzie) i N3/N4.

### 2026-09-19 — UX-N1 (część): filtry tablicy Kanbanu i rozdział wierszy poleceń

Wykonana część N1: filtry wykonawcy i priorytetu na tablicy, „Wyczyść wszystko”,
plumbing filtra aż do Backendu oraz naprawa wiersza poleceń, który pokazywał
kontrolki Listy na Kanbanie.

Pliki i decyzje:

- `lib/workspaces/domain/repositories/kanban_repository.dart` — nowy
  `KanbanBoardFilter` (`isActive`, `activeCount`, `toColumnQuery`, `copyWith`
  z jawnym czyszczeniem wymiaru, equality z `@immutable`);
  `KanbanRepository.getBoard` przyjmuje filtr.
- `lib/workspaces/data/kanban/api/kanban_api.dart` + `kanban_repository_impl.dart`
  — trzy opcjonalne parametry zapytania; klient retrofita wygenerowany ponownie
  (`dart run build_runner build --delete-conflicting-outputs`).
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart` —
  `TasksBoardReady.filter` i `loadingFilter`.
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_runtime_coordinator.dart`
  — filtr żyje w koordynatorze lifecycle: `load()` wysyła go do `getBoard`,
  `setFilter()` publikuje `loadingFilter` i odświeża tablicę. Filtr przeżywa
  nieudany odczyt, więc ponowienie nie wraca po cichu do pełnego projektu.
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_filter_commands.dart`
  (nowy) + fasada `tasks_board_cubit.dart` — `setFilterAssignee`,
  `setFilterPriority`, `setFilterMilestone`, `clearFilters`.
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_preference_commands.dart`
  — `loadMore` dokłada filtr tablicy do `KanbanColumnQuery`, więc kolejna strona
  opisuje ten sam zestaw kart co licznik kolumny.
- `lib/workspaces/presentation/tasks/header/tasks_header_board_filters.dart`
  (nowy, część biblioteki widoku Tasks) — klawisze `board_filter_priority`,
  `board_filter_assignee`, `board_filter_clear` oparte na wspólnym komponencie.
- `lib/workspaces/presentation/tasks/chrome/tasks_command_menu.dart` (nowy) —
  `TasksCommandMenu` i `TasksCommandButton` wyjęte z paska Listy, żeby Lista
  i Kanban miały jeden klawisz poleceń (refaktor bez zmiany zachowania:
  `task_list_chrome_test.dart` przechodzi bez zmian).
- `lib/workspaces/presentation/tasks/header/tasks_header_layout.dart` — wiersz
  poleceń Listy montowany tylko poza widokiem tablicy.

Defekt wykryty przy tej okazji: na Kanbanie wisiał wiersz poleceń Listy
(Status/Priorytet/Osoba/Mój udział/Przypięte/Sortowanie/Grupowanie/Kolumny),
a jego kontrolki opisują kursorowy snapshot Listy, więc na tablicy nic nie
robiły. Dowodem jest zrzut z T7 (`docs/recovery/visual-captures/
kanban_1440x900_light.png`) sprzed zmiany; po zmianie tablica pokazuje szybki
filtr, Priorytet, Osobę i widok domyślny, a Lista zachowuje swoje kontrolki
(porównaj `lista_1440x900_light.png`). Timeline, Obciążenie i Cykliczne nadal
dziedziczą pasek Listy — do rozstrzygnięcia w N3/N4.

Otwarte po tej części N1:

- filtr kamienia milowego: `MilestoneRepository` jest w zasięgu trasy tablicy,
  ale lista kamieni nie ma kubita poza feature’em szczegółów zadania, więc
  kontrolka wymaga małego, osobnego pakietu (N1b) — nie wystawiamy jej wcześniej,
  żeby nie dodać martwego klawisza;
- chip aktywnego filtra dla nowych wymiarów (`_ActiveFilterStrip` obsługuje
  dzisiaj tylko szybki filtr);
- powiązanie filtra zapisanego widoku z boardem czeka na N2b (`savedViewId`).

Testy i bramki:

- `test/workspaces/presentation/tasks/tasks_board_cubit_test.dart` +3 przypadki
  (filtr w `getBoard` i w zapytaniu kolumny oraz „Wyczyść wszystko”; brak
  zbędnego odczytu przy powtórzonym filtrze; filtr przeżywa nieudany odczyt),
- `test/workspaces/presentation/tasks/board/tasks_board_filters_test.dart` (nowy,
  2 przypadki): klik Priorytet → odczyt tablicy z filtrem i pojawienie się
  „Wyczyść wszystko”, klik „Wyczyść wszystko” → odczyt bez filtra; drugi
  przypadek pilnuje, że pasek Listy nie jest montowany na tablicy,
- `test/test_support/tasks_board_route_fixture.dart` — `registerFallbackValue(
  KanbanBoardFilter.none)` i stub `getBoard` z parametrem `filter`, bo moduł
  zawsze wysyła filtr,
- `test/workspaces/presentation/tasks/board/goldens/header_desktop_1280.png`
  zaktualizowany świadomie (`--update-goldens`): wiersz poleceń tablicy zmienił
  się zgodnie z planem,
- ARB: `tasksBoardFilterAssignee` („Osoba”/„Person”) i
  `tasksBoardFilterAllPeople` („Wszystkie osoby”/„All people”) w pl i en,
  `flutter gen-l10n` uruchomione,
- bramki: `flutter analyze` — No issues found, `flutter test` — 997/997 PASS,
  `flutter build web --wasm` — PASS po zmianach N1 (`✓ Built build/web`),
  `git diff --check` czysty.

Następny krok: N1b (kontrolka kamienia milowego po dodaniu źródła danych
w hoście tablicy) oraz chipy aktywnego filtra, potem N2b (`savedViewId` na
boardzie) i N3 (ustawienia boardu w UI).

### 2026-09-19 — N8: bezpieczny zapis ustawień widoku i wspólna powierzchnia błędów

Zakres: sześć powiązanych defektów zgłoszonych przez właściciela — niebezpieczne
ponowienie zapisu preferencji Kanbana, maskowane błędy Listy, nietrwały SnackBar
Kanbana, ignorowany odczyt preferencji, przeładowanie Listy po błędzie ustawień
tablicy oraz zbyt ogólny kod konfliktu w Backendzie.

Pliki (Front): nowe `tasks/errors/tasks_view_error.dart`,
`tasks/errors/tasks_error_banner.dart`, `tasks/chrome/tasks_error_banner_host.dart`,
`tasks/list/preferences/cubit/task_list_preference_merge.dart`; zmienione
`board/cubit/tasks_board_preference_commands.dart` (kolejka intencji + rebase),
`board/cubit/tasks_board_state.dart` (`taskDataRevision`, `TasksViewError? error`),
`board/cubit/tasks_board_cubit.dart` (`retryFailedOperation`, `clearViewError`),
`board/cubit/tasks_board_runtime_coordinator.dart` (błąd odczytu preferencji,
`reloadUserPreference`), `board/tasks_project_view.dart` (SnackBar usunięty),
`board/tasks_board_page.dart` (banner pod nagłówkiem),
`list/chrome/task_list_chrome_host.dart` i `list/project_tasks_list.dart` (słuchają
`taskDataRevision`), `list/preferences/cubit/task_list_preferences_cubit.dart`,
`..._state.dart`, `..._loader.dart` (`fetch()` bez emisji),
`..._project_policy_controller.dart`, `.../widgets/task_columns_sheet_sections.dart`,
`l10n/app_{pl,en}.arb` + regenerowane `app_localizations*`.

Pliki (Backend): nowy `Domain/Rules/TaskListExceptions.cs`;
`Domain/Entities/TaskListUserPreference.cs`, `Domain/Entities/ProjectTaskListPolicy.cs`,
`Application/Tasks/Handlers/TaskListConfigurationHandler.cs`,
`Infrastructure/Http/ApiExceptionMiddleware.cs`, komunikaty konfliktu
w `Application/Kanban/{UserKanbanPreferenceService,KanbanSettingsService,KanbanTaskMover}.cs`
i `Application/Projects/ProjectCustomStatusService.cs`.

Decyzje: intencja opisuje wartość docelową (rebase jest idempotentny i nie
przenosi starych pól); po drugim konflikcie zatrzymujemy automatyczne
ponawianie, ale zachowujemy intencję/draft, więc „Ponów" ponawia zmianę
użytkownika, a nie stan serwera; błąd jest częścią stanu (trwały banner), a nie
zdarzeniem (SnackBar); sygnał danych zadań i sygnał błędów są rozdzielone;
konflikt rozpoznajemy po stabilnym kodzie `*.version_conflict`, a HTTP 409
zostaje jako zapas; arkusz kolumn zachowuje własny komunikat, bo jako modal
zasłania banner; strażnicy wersji w encjach rzucają wyjątki domenowe, bo to oni
odpowiadali za nieaktualny `expectedVersion`.

Testy dodane: Front — `tasks_error_banner_test.dart` (4 przypadki: banner
widoczny bez arkusza, „Ponów" ponawia draft, błąd odczytu bez „Ponów", `traceId`),
`tasks_board_cubit_test.dart` (+4: brak nadpisania równoległej zmiany, kliknięcie
w trakcie zapisu, nieudany odczyt preferencji z ponowieniem, brak przyrostu
`taskDataRevision` przy błędzie), `task_list_preferences_cubit_test.dart` (+3:
scalenie z równoległą zmianą sortowania, drugi konflikt z zachowanym draftem,
zmiana sortowania w trakcie zapisu) oraz rozpoznanie kodu konfliktu bez patrzenia
na sam status. Backend — `TaskListConfigurationTests` (+2: preferencje i polityka
zgłaszają własne wyjątki), przepisany przypadek preferencji oraz HTTP-owy
`TaskHttpOperationMatrixTests.TaskListConflictsUseDedicatedVersionConflictCodes`.

Komendy i wyniki: `flutter gen-l10n` ok; `flutter analyze lib` i
`flutter analyze test` — No issues found; `flutter test --timeout 180s` —
1017/1017 PASS; `flutter build web --wasm` — PASS; `flutter build macos --debug` —
PASS; `dotnet build veloryn-workspaces.csproj` — 0 ostrzeżeń, 0 błędów;
`dotnet test --filter "FullyQualifiedName~TaskList|FullyQualifiedName~TaskHttpOperationMatrix"`
— 18/18 PASS; pełna suite Backendu — 1156 PASS, 7 FAIL, 4 SKIP (wszystkie 7
w `MeEndpointsTests`, potwierdzone jako zastane przez `git stash` i wynik 7/17
bez N8); `git diff --check` czysty w obu repo; `cmp` dokumentów — identyczne.
Kontrola mutacyjna: `workspace.conflict` zamiast kodów `task_list.*` w middleware
→ `[FAIL]` nowego testu HTTP, po przywróceniu pliku zieleń.

NOT RUN: Release macOS (brak profilu provisioning w lokalnym Keychain — stan
zastany, AUTH-E2), buildy Windows/Linux (brak hosta) oraz live test dwóch sesji
z widocznym komunikatem — odroczony do wdrożenia nowej wersji Backendu.

Następny krok: właściciel wgrywa nową wersję Backendu, a po wdrożeniu uruchamiamy
live test dwóch sesji (konflikt ustawień widoku → trwały banner → „Ponów"
zapisuje intencję użytkownika), potem N3/N4 z planu parytetu.

### 2026-09-19 — N9: audyt transportu i stanu operacyjnego (P0 w odzyskiwaniu sesji)

Zakres: cztery defekty zgłoszone przez właściciela — podwójne żądania desktopowe,
cofanie zmian z czasu nieudanego zapisu Listy, gubiony stan operacyjny przy
odczycie tablicy oraz log ujawniający ciało odpowiedzi.

Pliki: `lib/foundation/http/devplanner_http_transport.dart` (bramka 401
w `_retryUnauthorized`, rozdzielenie `onResponse`/`onError`),
`lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart`
(`_publishFailure` na bieżącym stanie ze scaleniem, pętla autosave nie kasuje
zmiany z czasu żądania, `_lastSaved` jako baseline),
`lib/workspaces/presentation/tasks/board/cubit/tasks_board_runtime_coordinator.dart`
(odczyt przez `copyWith(board:, filter:)`),
`lib/workspaces/presentation/tasks/board/cubit/tasks_board_bulk_commands.dart`
(ja wne czyszczenie zaznaczenia), `lib/core/data/api_repository.dart`
(`debugResponseShape` zamiast zrzutu ciała).

Decyzje: retry sesji dotyczy wyłącznie 401 i jest sprawdzany po statusie
w obu ścieżkach, bo ten klient akceptuje każdy status i 401 przychodzi jako
odpowiedź, nie wyjątek; błąd zapisu nigdy nie cofa stanu — jest nakładany na
bieżący draft, a przy konflikcie draft przechodzi przez to samo scalenie co
zapis; odczyt tablicy wymienia wyłącznie dane tablicy i zachowuje stan
operacyjny (błąd, znacznik zapisu, rewizję, zaznaczenie); log diagnostyczny
opisuje kształt odpowiedzi, nie jej treść.

Komendy i wyniki: `flutter analyze lib test` — No issues found;
`flutter test --timeout 180s` — 1024/1024 PASS (w tym 7 nowych przypadków);
`flutter build web --wasm` — PASS; `flutter build macos --debug` — PASS;
`git diff --check` czysty w obu repo; `cmp` planu, handoffu i planu parytetu —
identyczne. Kontrola mutacyjna na trzech niezależnych mutacjach (bramka 401,
snapshot zamiast bieżącego stanu, stan od zera w `load()`) — każda wysyła na
czerwono właściwy nowy test, po przywróceniu plików zieleń.

Własność plików: naprawa P0 weszła w `foundation/http` (obszar drugiej sesji)
i `core/data` (legacy `core`); zmiany są punktowe, a cała suita transportu wraz
z pięcioma istniejącymi testami 401-retry przechodzi 10/10.

Następny krok: po wdrożeniu nowej wersji Backendu przez właściciela — live test
dwóch sesji (konflikt ustawień → trwały banner → „Ponów" zapisuje intencję),
a potem N3/N4 z planu parytetu.

### 2026-09-19 — N10: enumy transportowe i globalna diagnostyka HTTP

Przyczyna raportowanego `GET /tasks/groups` 400 była po stronie Frontu:
`TaskListQuery` wysyłał dartowe `.name` (`todo`, `inProgress`, `high`),
a binder ASP.NET Core 10 wymaga nazw enumów zgodnych z kontraktem (`Todo`,
`InProgress`, `High`). Audyt ujawnił ten sam rodzaj ryzyka w Kanbanie
(`TaskPriority` w query i `ProjectTaskStatus` w path), Notifications
(`NotificationCategory`) oraz dashboardzie (`DashboardContextKind`). Wszystkie
te granice mają teraz jawne `wireValue`, a klienty Retrofit przyjmują
prymitywny `String`, więc generator nie może ponownie użyć `Enum.toString()`.

Aktywny `DevPlannerHttpTransport` otrzymał globalny debugowy interceptor. Loguje
request/response/error, pełną zredagowaną URI, status, czas, nagłówki oraz
bezpieczny opis body. Redakcja obejmuje Authorization, Cookie/Set-Cookie, CSRF,
tokeny, sekrety, hasła, login/e-mail oraz tekst wyszukiwania. Dla odpowiedzi
sukcesu logowane są jedynie nazwy pól, a dla błędu `code`, `message`, `traceId`
i nazwy `fields`; wartości DTO i szczegóły pól nie trafiają do konsoli.

Backend ustawia `RouteHandlerOptions.ThrowOnBadRequest = true`. Dzięki temu
produkcyjny błąd bindera nie kończy się pustym 400, tylko przechodzi przez
istniejący `ApiExceptionMiddleware` i wspólny kontrakt błędu.

Pliki Front: `foundation/http/devplanner_http_diagnostics_interceptor.dart`,
`devplanner_http_transport.dart`, enumy shared, mapper `task_list_query.dart`,
API/repozytoria Tasks/Kanban/Notifications/Workspace oraz wygenerowane klienty.
Testy: `transport_enum_query_serialization_test.dart` i rozszerzona suita
`devplanner_http_transport_test.dart`. Backend: `Program.cs` oraz
`ApiEndpointTests.cs`.

Dowody: frontend targeted 13/13 PASS; scoped `flutter analyze` — No issues
found; backend build — 0 ostrzeżeń, 0 błędów; backend targeted 2/2 PASS.
Skan źródeł nie znalazł pozostałych enumów jako typów `@Query`/`@Path` ani
analogicznego `.name` w mapperach transportowych. Pełne suite i buildy
platformowe nie były częścią tej punktowej naprawy.

Następny krok: po wdrożeniu Backendu i ponownym uruchomieniu aplikacji potwierdzić
w logu `[HTTP][REQUEST]`, że filtr Tasks wysyła np. `status=InProgress`, oraz że
celowo błędny enum zwraca envelope `request.invalid` z `traceId` zamiast pustego
body.
