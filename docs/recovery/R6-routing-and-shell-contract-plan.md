# R6 — kontrakt routingu i shella DevPlanner

Data: 2026-09-17  
Status: plan wykonawczy po usunięciu osobnej trasy Chat  
Zakres: Front, router, shell i kontrakty stron. Bez zmian backendu.

## Decyzja nadrzędna

DevPlanner ma jedną chronioną powłokę aplikacji. Chat i Notifications nie są
stronami ani trasami. W późniejszej fazie będą prawymi overlayami otwieranymi
z belki/shella, bez zmiany URL, historii, wybranego workspace/projektu lub
filtrów.

Osobna trasa `/chat` została usunięta z nowego root routera razem z
`ChatStandalonePage` i routerową kompozycją repozytorium. Nie usunięto danych,
repozytoriów, modeli, realtime ani widgetów domeny Chat — ich migracja do
globalnego overlayu jest ostatnim etapem.

## Audyt stanu bieżącego

Źródła dowodowe:

- `lib/app/router/devplanner_router.dart:33-98` — aktualny `GoRouter`, redirect
  `/` do `/workspaces`, ścieżki auth i trzy realne strony chronione:
  `/workspaces`, `/me`, `/admin`;
- `lib/app/router/devplanner_router.dart:240-270` — guard zachowujący
  chronioną ścieżkę w `returnTo` i odrzucający nieautoryzowany dostęp;
- `lib/app/router/devplanner_router.dart:273-336` — katalog ścieżek,
  istniejące buildery dla workspace/project/task/files oraz bezpieczny start;
- `lib/app/shell/devplanner_shell.dart:43-103` — obecna geometria: `SafeArea`,
  jawne 64 px belki, `NavigationRail` desktop i `NavigationBar` kompaktowy;
- `lib/app/shell/devplanner_shell.dart:105-170` — obecny top bar i opcjonalna
  akcja powiadomień; Chat nie jest już przyciskiem ani panelem;
- `test/app/router/devplanner_root_router_compile_test.dart:40-45` — test
  potwierdza, że `/chat`, `/notifications` i `/storage` nie są root routes;
- `test/app/router/devplanner_router_test.dart:20-94` — guard, kodowanie
  parametrów i odrzucenie starego `/dashboard`;
- `test/app/shell/devplanner_shell_test.dart:9-53` — test belki oraz akcji
  powiadomień, bez osobnego Chat route/panelu.

Obecny router nie ma jeszcze `GoRoute` dla zagnieżdżonych ekranów Tasks,
Kanban, Files i projektów. Buildery ścieżek istnieją, ale same w sobie nie
udostępniają strony użytkownikowi. Nie wolno uznawać ich za ukończony routing.
Najpierw trzeba podłączyć realną stronę i typed gateway, dopiero potem dodać
pozycję do menu.

## Docelowa mapa tras

Każda trasa chroniona poniżej jest dzieckiem jednego `ShellRoute`. Parametry
`workspaceId`, `projectId`, `taskId`, `fileId` i `resourceId` są dekodowane raz
na granicy routingu, walidowane jako niepuste identyfikatory i przekazywane do
composition/page jako typowane dane. Widget nie buduje ścieżek ad hoc.

| Trasa docelowa | Dostęp | Status | Strona/kontrakt |
|---|---|---|---|
| `/` | publiczna | istnieje jako redirect | przekierowanie do `/workspaces` |
| `/login` | publiczna | istnieje | login + bezpieczne `returnTo` |
| `/auth/activate` | publiczna | istnieje | aktywacja konta administratora |
| `/auth/reset` | publiczna | istnieje | reset hasła |
| `/auth/mfa` | publiczna | istnieje | drugi składnik, gdy wymagany |
| `/workspaces` | zalogowany | istnieje | lista workspace’ów z `WorkspacesGateway` |
| `/workspaces/:workspaceId` | członek workspace | planowana | workspace home, realne menu projektów |
| `/workspaces/:workspaceId/projects/:projectId` | członek projektu | planowana | projekt i jego podzasoby |
| `/workspaces/:workspaceId/projects/:projectId/tasks` | członek projektu | planowana | lista zadań, filtry i query `view` |
| `/workspaces/:workspaceId/projects/:projectId/tasks/:taskId` | dostęp do zadania | planowana | szczegóły zadania |
| `/workspaces/:workspaceId/projects/:projectId/tasks?view=kanban` | dostęp do projektu | planowana | Kanban tego samego kontraktu Tasks; bez osobnego root `/kanban` |
| `/workspaces/:workspaceId/files` | dostęp do workspace | planowana | Files scope workspace |
| `/workspaces/:workspaceId/projects/:projectId/files` | dostęp do projektu | planowana | Files scope projektu |
| `/workspaces/:workspaceId/projects/:projectId/files/:fileId` | capability pliku | planowana | szczegóły/wersje/akcje pliku |
| `/me` | zalogowany | istnieje | profil i ustawienia użytkownika |
| `/me/tasks` | zalogowany | planowana | osobisty widok zadań |
| `/me/files` | zalogowany | planowana | osobisty Storage; istnieje codec scope |
| `/admin` | BFF + permission admin | istnieje | admin users; composition po `/me` |
| `/storage/public/:shareToken` | publiczny link | osobny wyjątek | read-only share, bez wejścia do chronionego shellu |

`resourceKind` w istniejącym `projectResource` nie może pozostać dowolnym
łańcuchem. Przy implementacji katalog routingu ma dopuścić wyłącznie realne,
zmapowane podfunkcje, np. `whiteboards`, `wiki`, `corkboard`, `automations` i
`files`; każda musi mieć własny gateway/page albo nie może trafić do menu.

Istniejące źródła realnych ekranów i kontraktów, które należy podłączać pionami:

- workspace: `lib/workspaces/presentation/workspaces_home/**`,
  `lib/workspaces/presentation/workspace_shell/**`;
- projekty: `lib/workspaces/presentation/projects/**`;
- Tasks/Kanban: `lib/workspaces/presentation/tasks/**`,
  `lib/workspaces/data/kanban/**`;
- Files: `lib/workspaces/presentation/storage/**`,
  `lib/workspaces/data/storage/**`, `lib/workspaces/presentation/storage/shell/storage_scope_route_codec.dart`;
- istniejące buildery i oczekiwane kodowanie: `DevPlannerRouteCatalog` oraz
  `test/app/router/devplanner_router_test.dart:60-77`.

## Co świadomie nie jest przenoszone

Nie dodawać do nowego root routera ani menu następujących ścieżek:

- `/dashboard`, `/bhp` i dawny dashboard modułowy — nie należą do standalone
  DevPlanner;
- `/tasks`, `/kanban`, `/files` i `/storage` jako globalne root routes — zasoby
  muszą mieć kontekst `workspaceId`/`projectId`, a Tasks/Kanban wspólny kontrakt;
- `/chat` oraz `/chat/conversations/:conversationId` — Chat jest overlayem,
  nie stroną i nie zmienia adresu;
- `/notifications` — powiadomienia są overlayem, bez route/deep-link;
- stare nazwy i ścieżki `context.router.navigatePath(...)` z legacy drzewa —
  należy je przepiąć na `DevPlannerNavigation` dopiero przy migracji danego
  feature’u;
- dowolne placeholdery typu „unavailable” jako pozycje menu. Brak realnej
  strony oznacza brak trasy do czasu ukończenia vertical slice.

Występujące w `lib/auth/domain/models/auth_models.dart` allowlisty historycznych
ścieżek (`/chat`, `/notifications`, `/storage`) wymagają osobnego sprzątnięcia
przy finalizacji auth return-to. Nie są dowodem, że te trasy powinny wrócić do
routera.

Publiczny `/storage/public/:shareToken` jest wyjątkiem, bo reprezentuje link
udostępniony poza aplikacją. Nie należy mylić go z prywatnym root `/storage`.

## Kontrakt Gmail-inspired shell

Docelowy shell implementować według
`docs/design/gmail-inspired-design-spec.md:35-147` oraz reguł kompozycji z
`docs/design/gmail-inspired-design-spec.md:148-204`:

1. warstwa tła/gradientu lub późniejszej tapety;
2. stała, zarezerwowana belka `64 logical px` — content nigdy pod nią nie
   wchodzi;
3. rozwijane menu lewe: około `256 px` otwarte, `64–72 px` zwinięte;
4. opcjonalna prawa utility rail wyłącznie dla realnych funkcji;
5. centralna zaokrąglona powierzchnia content, margines `12–16 px`, promień
   około `20 px`, własny toolbar bez drugiego globalnego top bara.

Obecny `NavigationRail` jest tylko etapem przejściowym. Refaktor nie może
zmienić `GoRouter` przy każdym zwinięciu menu. Stan expanded/collapsed należy
do właściciela shellu, a trasa wybranego ekranu pozostaje bez zmian.

Akcje globalne Chat/Notifications będą w przyszłości przekazane do jednego
`OverlayHost` shella. Overlay:

- otwiera się poniżej top bara, przy prawej krawędzi;
- nie zmienia `GoRouter` location ani historii;
- ma reserved geometry, barrier/focus, Escape, klik poza panelem i zwrot
  fokusu do przycisku;
- nie zawiera logiki API; dostaje typed composition z root;
- nie pojawia się w `topLevelPaths` ani w menu jako strona.

## Kolejność integracji

### R6.0 — kontrakt routingu

- Utrzymać mały `DevPlannerRouteCatalog` jako jedyne miejsce builderów.
- Dodać parser parametrów i whitelistę `resourceKind`; nie przenosić logiki do
  Cubitów.
- Dodać realne `GoRoute` dopiero razem z page + gateway + testem; brak strony
  oznacza brak route.
- Utrzymać guard auth, bezpieczne `returnTo`, odrzucenie hostów/schematów i
  brak legacy fallbacków.

### R6.1 — shell, belka i lewe menu

- Zbudować reserved topbar/sidebar/content canvas bez dotykania kontraktów
  Tasks/Files.
- Zastąpić zbyt ogólny `NavigationRail` drzewiastym menu workspace → project
  → resource, z trybem collapsed i osobnym scrollem.
- Testy: 1280×800, 1440×900, 1920×1080; expanded/collapsed; resize; focus;
  URL bez zmian; dark/light theme; brak overflow przy 125/150% tekstu.

### R6.2 — Tasks i Kanban

- Podłączyć `/tasks` i `?view=kanban` do istniejącego typed gateway/page.
- Zachować parametry workspace/project/task i query view przy refresh/back/deep
  link.
- Testy route parsera, list/detail, reorder Kanban, 403/timeout/retry,
  permission i desktop rendering.

### R6.3 — Files

- Podłączyć scope codec do `/me/files`, workspace files i project files.
- Wykorzystać zweryfikowaną warstwę `lib/workspaces/data/storage/**` oraz
  porty; UI nie importuje Dio/Retrofit/storage.
- Testy ACL, folder/placement, upload/download, version route, public share,
  back/refresh i modal z reserved shell geometry.

### R6.4 — Chat i Notifications (ostatni etap)

- Nie dodawać żadnej trasy.
- Wprowadzić jeden shell overlay host i dopiero wtedy podłączyć realne
  repozytoria Chat/Notifications.
- Testować otwarcie z każdej chronionej strony, zachowanie location, Escape,
  outside click, focus restore, reconnect/retry i pusty/error state.

## Definition of Done dla R6

- `DevPlannerRouter` zawiera wyłącznie publiczne auth + realne chronione
  strony; nie ma `/chat` ani `/notifications`.
- Każda trasa w menu ma prawdziwy page, typed gateway, loading/empty/error/
  retry i test kontraktu; brak placeholderów.
- Parametry są kodowane/odkodowywane w jednym miejscu i przeżywają refresh,
  back oraz deep link na Web i desktopie.
- Shell rezerwuje topbar/sidebar/content geometry i nie przykrywa modali ani
  stron; dark/light, resize i 150% tekstu są sprawdzone.
- Chat/Notifications pozostają overlayami bez route i są wdrażane dopiero po
  Tasks/Kanban oraz Files.
- Weryfikacja końcowa: scoped `flutter analyze`, testy router/shell/feature,
  manualny desktop browser flow oraz `git diff --check`.
