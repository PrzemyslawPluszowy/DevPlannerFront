# Macierz równoważności funkcji DevPlanner

Status: **R2g — bieżąca inwentaryzacja statyczna i automatyczna; nie dowód
działania aplikacji desktopowej**.  
Data pierwszego audytu: 2026-09-17. Aktualizacja stanu tras: 2026-09-18.

## Cel i granice audytu

Ten dokument jest rejestrem odzyskania funkcji, a nie listą życzeń ani
deklaracją ukończenia. Zestawia kod odzyskany z commit `d1cc273`, aktualne
drzewo `lib/` i testy Frontu z **źródłami endpointów C# w `../Backend`**.
Nie uznaje adnotacji Retrofit za potwierdzenie endpointu: w kolumnie
„endpoint” występuje `POTWIERDZONY`, tylko gdy ścieżkę odczytano także w
`../Backend/Endpoints/`; w przeciwnym razie widnieje `NIEZWERYFIKOWANY`.

„Wcześniej działała” oznacza wyłącznie, że istnieje odzyskany widok oraz test
lub adapter. Nie jest to wynik smoke testu. `live` pozostaje `NIE` bez
uruchomionej sesji desktop + lokalny Backend i scenariusza użytkownika. To
rozróżnienie chroni przed uznaniem samego kodu albo zielonego analyzera za
odzyskaną funkcję.

### Legenda statusów

| Pole | Znaczenie |
|---|---|
| `wcześniej` | `częściowa` = istnieje kod/test, ale brak dowodu historycznego live; `plan` = wymieniona w planie bez odnalezionego pełnego widoku. |
| `odzyskanie` | `zachowany` = źródła są w drzewie; `blokada R1` = zależność/usunięty plik uniemożliwia kompilację lub połączenie; `plan R3` = brak pełnego pionu UI. |
| `live` | `NIE` = brak aktualnego testu end-to-end; `NIE — placeholder` = aktywna trasa nie uruchamia funkcji. |
| `uprawnienia` | Poza anonimowymi krokami startu auth, wskazane endpointy wymagają autoryzacji. „ACL” oznacza, że serwer ma ponownie zweryfikować dostęp do workspace/projektu/obiektu; ukrycie przycisku w UI nie wystarcza. |

## Bieżąca synchronizacja R2g — stan nadrzędny nad historycznymi wpisami R0/R1

Poniższy rejestr koryguje historyczne sformułowania „placeholder” i „brak
importu” w dalszej części dokumentu. Tabele R0/R1 zachowano jako materiał
odzyskania źródeł, ale nie opisują już aktywnego grafu routera. `live: NIE`
pozostaje celowo: użytkownik odłożył uruchomienie aplikacji do stagingu, więc
nie ma ręcznego desktopowego dowodu z backendem.

| ID parity | Stan kodu i aktywna trasa | Dowód automatyczny na obecnym drzewie | Live |
|---|---|---|---|
| NAV-01, NAV-04, NAV-06 | `DevPlannerRouter` prowadzi `/workspaces` do rzeczywistego katalogu, a `/workspaces/:workspaceId` do katalogu projektów; wejście projektu zachowuje historyczny URL i przekierowuje do Tasks bez pustego dashboardu. | `devplanner_root_router_compile_test.dart`: katalog, projekt i deep link; pakiet R2g 35/35 PASS. | NIE — staging |
| NAV-07, TSK-01–TSK-10 | `/workspaces/:workspaceId/projects/:projectId/tasks` składa realny board/list, `?view=kanban` jest kanonicznym widokiem Kanban, a `/tasks/:taskId` składa typowany ekran szczegółu. | `tasks_board_route_page_test.dart`, `standalone_project_tasks_list_test.dart`, `tasks_details_route_page_test.dart`; szczegóły i Chat/Notifications: 27/27 PASS. | NIE — staging |
| NAV-11, STO-01–STO-03 | Trasy plików osobistych, workspace i projektu składają rzeczywisty `StorageRepository`; desktop wystawia upload, a Web BFF pozostaje fail-closed dla presigned PUT. | `devplanner_root_router_compile_test.dart`, `storage_shell_page_test.dart`, `storage_read_only_browser_page_test.dart`, `storage_upload_vertical_test.dart`, `storage_folder_create_vertical_test.dart`; 39/39 PASS dla pakietu Files/Tasks/paneli. | NIE — staging + MinIO |
| NAV-14 | `DevPlannerShell` ma zarezerwowaną belkę, zwijane drzewo i lokalny `ValueNotifier` rozwinięcia; nie ma `setState`, globalnego Cubita ani I/O w menu. | `devplanner_shell_test.dart`, `workspace_navigation_foundation_test.dart`, `workspace_navigation_tree_cubit_test.dart`; 35/35 PASS. | NIE — staging |
| NAV-15, CHT-01–CHT-05 | Chat pozostaje globalnym panelem po prawej, bez trasy; rozmowy, wiadomości, draft/retry i realtime są odzyskanymi częściami istniejącego pionu. | `devplanner_global_panels_host_test.dart`, `chat_drawer_cubit_test.dart`, `chat_conversation_cubit_test.dart`; 27/27 PASS. | NIE — staging z dwoma użytkownikami |
| NOT-01–NOT-02 | Powiadomienia są globalnym panelem, nie ekranem ani trasą; inbox/retry/reply są składane w istniejącym panelu. | `global_notifications_page_test.dart`, `notifications_inbox_cubit_test.dart`, `notifications_cubit_test.dart`, `notification_reply_cubit_test.dart`; 27/27 PASS. | NIE — staging + realtime |
| NAV-08–NAV-10, RES-01–RES-04 | Whiteboards, Wiki, Corkboard i OKR nie miały gotowych pionów UI do odzyskania. Są widoczne jako nieaktywne wpisy odzyskanego menu, bez placeholdera, fałszywej trasy lub nowej implementacji. | `workspace_navigation_foundation_test.dart` potwierdza strukturę; brak testu pełnego pionu jest jawny. | NIE — poza uzgodnionym zakresem bieżącej naprawy |

Wynik jakości aktualnego kodu: `flutter analyze lib` PASS. Wersje dokumentów
standalone Front/Backend są porównywane `cmp`; `git diff --check` w obu
repozytoriach PASS. Nie jest to wynik pełnego `flutter test`: pełny przebieg
przekroczył limit pojedynczego obserwowanego procesu i został zatrzymany bez
interpretowania tego jako PASS lub FAIL.

## Historyczne fakty blokujące potwierdzone w R0

- `lib/app/router/devplanner_router.dart` prowadzi do placeholderów trasy
  workspace, plików workspace, projektu, tasks, task details, resources,
  file details, Wiki i Whiteboard. `/storage` jest również placeholderem.
- Router importuje trzy brakujące źródła: `presentation/devplanner_workspaces_page.dart`,
  `presentation/chat/global_chat_composition.dart` oraz
  `presentation/notifications/global_notifications_composition.dart`.
  Runtime `data/standalone/devplanner_standalone_runtime.dart` istnieje, ale
  importuje dwa ostatnie pliki; nie jest więc dowodem uruchamialności.
- Autorytatywny `docs/recovery/R00-analyzer-baseline.md` ustala **497 plików
  produkcyjnych i 2364 deklaracje importu** `package:ready_next/...`, a dalej
  **121 plików testowych i 801 deklaracji**. Pakiet nazywa się `devplanner`;
  jest to blokada R1, nie kosmetyka.
- Limit 400 linii nie jest metryką „wszystkich plików Dart”. R00, po
  wyłączeniu artefaktów generatora i l10n, wykazuje **58 plików
  produkcyjnych** oraz **16 testowych** ponad limitem. Wśród produkcyjnych są
  widgety, Cubity i inne klasy; tylko widgety/klasy produkcyjne podlegają
  wymaganiu podziału według odpowiedzialności. `*.g.dart`, `*.freezed.dart`
  i l10n są wyjątkami od tej metryki.
- `WorkspaceStaticMenu` jest jawnie opisanym szkieletem bez rzeczywistych
  callbacków nawigacji. Nie jest źródłem kompletnego menu. Pełniejszym źródłem
  jest katalog/projektowe drzewo w `workspaces_home/`.
- Stare strony routingu `presentation/routing/` istnieją, ale nie są importowane
  przez aktywny `DevPlannerRouter`; nie są aktualną ścieżką użytkownika.

### Uzgodnienie wcześniejszych liczników pomocniczych

W pierwszej wersji tej macierzy padły liczby `498/2375` dla `lib` i `112`
plików `lib` ponad 400 linii. Był to jednorazowy, surowy skan wykonany na
współdzielonym, brudnym worktree, bez zapisanego manifestu ścieżek i bez
wyłączenia artefaktów. Różnica wobec R00 to odpowiednio **+1 plik i +11
deklaracji**; bieżący powtórzony raw scan nadal pokazuje tę samą różnicę,
dlatego nie wolno przypisać jej konkretnej zmianie bez porównywalnego snapshotu
ścieżek R00. Nie jest to regresja funkcjonalna ani dodatkowy zakres do
mechanicznego rename’u.

Na potrzeby planowania i raportowania obowiązuje R00 (`497/2364` oraz
`121/801`), bo jest jedynym raportem z określonym stanem wejściowym,
komendą i analizatorem. Różnicę trzeba rozstrzygnąć w R1 przez ponowne
zapisanie manifestu importerów po ustabilizowaniu grafu; do tego czasu nie
łączyć obu pomiarów ani nie deklarować liczby `498/2375` jako baseline.

Analogicznie surowe `112` nie jest naruszeniem „limitu widgetów”: obecny skan
techniczny rozdziela 61 niegenerowanych plików `lib`, 50 artefaktów generatora
i 1 plik l10n ponad 400 linii. Zmiana między tym snapshotem a R00 (58
produkcyjnych) pozostaje skutkiem niezablokowanego worktree; architektoniczną
bramką pozostaje klasyfikacja R00: 58 produkcyjnych i 16 testowych, z osobnym
review odpowiedzialności każdego dużego widgetu/Cubitu/klasy.

## Docelowa lokalizacja

Skróty w kolumnie „docelowo”: `spaces`, `projects`, `tasks/{board,list,details,…}`,
`storage/{browser,upload,preview,sharing,office}`, `chat`, `notifications`,
`wiki`, `whiteboard`, `corkboard`, `okr`, `auth`, `admin/users`, `profile` i
`settings` oznaczają dokładnie gałęzie `lib/features/<…>/{data,domain,presentation}`
z sekcji 4 planu. Każdy Cubit jest lokalny dla subfeature’u, UI nie wykonuje
I/O, a pojedynczy widget/klasa produkcyjna ma nie przekraczać 400 linii.

W komórkach tabel znak `…/presentation/` oznacza pełny prefiks
`lib/workspaces/presentation/`, a `…/data/` —
`lib/workspaces/data/`; skrót służy wyłącznie czytelności tabeli i nie oznacza
nieznanej ścieżki. `d1cc273:` zawsze oznacza dokładnie ścieżkę z tego commitu.

### Rejestr potwierdzonych baz tras HTTP

Każda pozycja oznaczona nazwą pliku endpointów w tabelach poniżej odwołuje się
do poniższego rejestru; `{…}` oznacza parametr GUID egzekwowany przez Backend.
To są odczytane grupy `MapGroup`, nie zgadywane skróty klienta.

| Kod źródła Backend | Potwierdzona baza trasy |
|---|---|
| `WorkspaceEndpoints.cs` | `/api/v1/workspaces` |
| `ProjectEndpoints.cs` | `/api/v1/workspaces/{workspaceId}/projects`, `/api/v1/workspaces/{workspaceId}/project-templates` |
| `ProjectTaskEndpoints.cs` | `/api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks`, `/api/v1/workspaces/{workspaceId}/task-templates`, `/api/v1/me/tasks`, `/api/v1/tasks/search` |
| `KanbanEndpoints.cs` / `KanbanUserPreferenceEndpoints.cs` | `/api/v1/workspaces/{workspaceId}/projects/{projectId}/kanban`, `/kanban/preferences` |
| `StorageEndpoints.cs` | `/api/v1/storage`, `/api/v1/me/avatar` |
| `ChatEndpoints.cs` | `/api/v1/chat` |
| `NotificationEndpoints.cs` | `/api/v1/notifications`, `/api/v1/admin/notifications` |
| `WikiEndpoints.cs` / `WikiPageAccessEndpoints.cs` | `/api/v1/workspaces/{workspaceId}/wiki`, `/api/v1/workspaces/{workspaceId}/projects/{projectId}/wiki`, `/api/v1/wiki/pages/{pageId}`, `/access` |
| `WhiteboardEndpoints.cs` / `WhiteboardAccessEndpoints.cs` | `/api/v1/workspaces/{workspaceId}/projects/{projectId}/whiteboards`, `/api/v1/whiteboards/{whiteboardId}`, `/access` |
| `CorkboardEndpoints.cs` / `CorkboardAiEndpoints.cs` | `/api/v1/workspaces/{workspaceId}/projects/{projectId}/corkboard` |
| `OkrEndpoints.cs` | `/api/v1/workspaces/{workspaceId}/okr` |
| `ProjectCustomStatusEndpoints.cs` / `ProjectMilestoneEndpoints.cs` / `AutomationEndpoints.cs` | `/custom-workflow`, `/milestones`, `/automations` pod projektem |
| `TaskCapacityEndpoints.cs` / `TaskTimeTrackingEndpoints.cs` / `TaskWorkloadEndpoints.cs` / `ProjectScheduleEndpoints.cs` | `/capacity`, `/time-tracking`, `/workload`, `/schedule` w kontekście workspace/projektu zgodnym z handlerem |
| `MeEndpoints.cs` / `LocalUserAdminEndpoints.cs` / `AdminOpsEndpoints.cs` | `/api/v1/me`, `/api/v1/admin/users`, `/api/v1/admin/ops` |
| `AccountRecoveryEndpoints.cs` / `MfaEndpoints.cs` / `BffEndpoints.cs` / `LocalLoginEndpoints.cs` | `/api/v1/auth`, `/api/v1/auth/mfa`, BFF i lokalny login zgodnie z endpoint source; nie nadaje to prawa publicznej rejestracji |

## Tożsamość, profil i administracja

| ID / funkcja | stare źródło → obecne źródło | docelowo / trasa | endpoint Backend | zależności i uprawnienia | test / wcześniej / odzyskanie / live / wymagany dowód |
|---|---|---|---|---|---|
| ID-01 Login desktop/Web BFF | `d1cc273:lib/core/auth/*` → `lib/auth/{data,domain,presentation}` | `auth`; `/login` | **POTWIERDZONY:** BFF i login w `Endpoints/Auth/BffEndpoints.cs`, `LocalLoginEndpoints.cs` | system browser + PKCE/vault desktop albo BFF+CSRF web; anonimowy start, konto tworzy admin | `test/auth/auth_*`; wcześniej: częściowa; odzyskanie: zachowany; live: NIE; dowód: login→callback→`/me` na macOS |
| ID-02 Aktywacja, reset, MFA | `d1cc273:lib/workspaces/data/auth/*` → `lib/auth/presentation/auth_route_page.dart` | `auth`; `/auth/activate`, `/auth/reset`, `/auth/mfa` | **POTWIERDZONY:** `Endpoints/Auth/AccountRecoveryEndpoints.cs`, `MfaEndpoints.cs` | lokalny issuer; neutralne recovery, MFA i rate limit po stronie serwera | `test/auth/auth_route_page_test.dart`; wcześniej: częściowa; odzyskanie: zachowany; live: NIE; dowód: activation/reset/MFA failure+success bez wycieku konta |
| ID-03 Sesja, refresh, logout | `d1cc273:lib/core/auth/*` → `lib/auth`, `lib/foundation/http` | `auth`; brak osobnej trasy | **POTWIERDZONY:** BFF/session source `Endpoints/Auth/BffEndpoints.cs` | jeden owner transportu, serializacja refresh, vault/cookie, shutdown realtime | `test/auth/auth_foundation_test.dart`, `web_bff_bootstrap_test.dart`; wcześniej: częściowa; odzyskanie: zachowany; live: NIE; dowód: restart, refresh i logout czyści cache/realtime |
| ID-04 `/me`, profil, hasło, urządzenia | `d1cc273:lib/workspaces/data/auth/*` → `lib/me/*` | `profile`; `/me`, `/me/:section` | **POTWIERDZONY:** `Endpoints/Auth/MeEndpoints.cs` | zalogowany własny `userId`; UI nie ufa claims launch contextu | `test/me/*`; wcześniej: częściowa; odzyskanie: zachowany; live: NIE — `/me/:section` placeholder; dowód: read/update/password/sessions i 401 |
| ID-05 Katalog lokalnych użytkowników | `d1cc273:lib/workspaces/data/workspaces/*` → `lib/workspaces/data/workspaces/*` | `spaces`; brak aktywnej trasy osobnej | **POTWIERDZONY:** `Endpoints/Auth/LocalUserAdminEndpoints.cs` (lokalny katalog) | zalogowany; wynik ograniczony serwerowo, UUID `userId` | `test/workspaces/data/projects/project_member_profiles_repository_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: search i brak dostępu do niedozwolonych danych |
| ID-06 Admin użytkowników i Ops | `d1cc273:lib/workspaces/data/admin/*` → `lib/admin/*`, dawny adapter nadal w `lib/workspaces/data/admin` | `admin/users`; `/admin` | **POTWIERDZONY:** `Endpoints/Auth/LocalUserAdminEndpoints.cs`, `Endpoints/Admin/AdminOpsEndpoints.cs` | `/me` + BFF cookie w routerze; SuperAdmin dla Ops, backend policy | `test/admin/*`; wcześniej: częściowa; odzyskanie: zachowany; live: NIE (fail-closed unavailable bez verified `/me`); dowód: admin CRUD/role + forbidden user |

## Menu i przestrzenie robocze

| ID / pozycja menu lub funkcja | stare źródło → obecne źródło | docelowo / trasa | endpoint Backend | zależności i uprawnienia | test / wcześniej / odzyskanie / live / wymagany dowód |
|---|---|---|---|---|---|
| NAV-01 Katalog Workspaces | `d1cc273:…/workspaces_home/*` → `lib/workspaces/presentation/workspaces_home/*` | `spaces`; `/workspaces` | **POTWIERDZONY:** `Endpoints/Workspaces/WorkspaceEndpoints.cs` | `WorkspacesHomeCubit`, repository, local settings; członkostwo workspace | `test/workspaces/presentation/workspaces_home_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE (brak importowanego `devplanner_workspaces_page.dart`); dowód: lista/loading/empty/error |
| NAV-02 Ulubione, ukryte i kolejność workspaces | `d1cc273:…/directory_menu/{favorite_workspace_link,hidden_workspaces_section}.dart` → te same pliki | `spaces`; `/workspaces` | **POTWIERDZONY:** `WorkspaceEndpoints.cs` (preferences/order) | osobiste preferencje, ACL workspace | `workspace_directory_menu_empty_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: favorite/hide/reorder po restarcie |
| NAV-03 Utwórz/edytuj/archive workspace | `d1cc273:…/manage_workspace/*` → `lib/workspaces/presentation/workspaces_home/manage_workspace/*` | `spaces`; `/workspaces`, `/workspaces/:workspaceId` | **POTWIERDZONY:** `WorkspaceEndpoints.cs` | create policy; edycja/archive tylko rola serwerowa workspace | test tylko pośredni `workspaces_home_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE — route placeholder; dowód: CRUD + 403 |
| NAV-04 Drzewo projektów | `d1cc273:…/projects_tree/workspace_project_menu.dart` → ten sam plik | `projects`; `/workspaces/:workspaceId/projects/:projectId` | **POTWIERDZONY:** `Endpoints/Projects/ProjectEndpoints.cs` | `ProjectResourcesRepository`, membership i resource ACL | `workspace_project_menu_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE — route placeholder; dowód: expand/collapse, selection i deep link |
| NAV-05 Pozycja Dashboard | `d1cc273:…/workspace_shell/navigation/workspace_static_menu.dart` → ten sam plik | `spaces/dashboard`; docelowo `/workspaces/:workspaceId` | **POTWIERDZONY:** `HomeDashboardEndpoints.cs`, `DashboardPreferenceEndpoints.cs` | workspace access; preferences własne | brak targeted testu; wcześniej: plan; odzyskanie: plan R3A; live: NIE — statyczne menu/skeleton; dowód: dashboard z API, empty/error |
| NAV-06 Pozycja Projekty | `d1cc273:…/workspace_static_menu.dart`, `workspace_project_menu.dart` → te same | `projects`; `/workspaces/:workspaceId/projects` | **POTWIERDZONY:** `ProjectEndpoints.cs` | workspace membership, project ACL | `workspace_projects_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE — route placeholder; dowód: browse/create/open project |
| NAV-07 Pozycja Zadania/Kanban | `d1cc273:…/projects_tree/*` → `workspace_project_menu.dart` | `tasks/board`; `/…/projects/:projectId/tasks` | **POTWIERDZONY:** `ProjectTaskEndpoints.cs`, `KanbanEndpoints.cs` | project access + task permissions; shared task repository | `tasks_board_cubit_test.dart`; wcześniej: częściowa; odzyskanie: zachowany UI, blokada R1; live: NIE — route placeholder; dowód: board/list/detail flow |
| NAV-08 Pozycja Whiteboards | `d1cc273:…/projects_tree/project_resource_menu_branch.dart` → ten sam | `whiteboard`; `/…/projects/:projectId/whiteboards` | **POTWIERDZONY:** `WhiteboardEndpoints.cs` | project/whiteboard ACL, realtime port | brak obecnego pełnego UI testu; wcześniej: plan; odzyskanie: plan R3E; live: NIE — route absent/placeholder; dowód: list/open/edit object/realtime |
| NAV-09 Pozycja Corkboard | `d1cc273:…/projects_tree/workspace_project_menu.dart` → ten sam | `corkboard`; `/…/projects/:projectId/corkboard` | **POTWIERDZONY:** `CorkboardEndpoints.cs`, `CorkboardAiEndpoints.cs` | project ACL, AI service when used | brak UI testu; wcześniej: plan; odzyskanie: plan R3E; live: NIE — route absent; dowód: create/move/archive card + 403 |
| NAV-10 Pozycja Wiki | `d1cc273:…/projects_tree/*` → `workspace_project_menu.dart`, `routing/*wiki*` | `wiki`; `/…/projects/:projectId/wiki` | **POTWIERDZONY:** `WikiEndpoints.cs` | workspace/project/page ACL and realtime port | brak pełnego UI testu; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE — route placeholder; dowód: tree/edit/revision/ACL |
| NAV-11 Pozycja Pliki | `d1cc273:…/projects_tree/*`, `storage/shell/*` → te same | `storage/browser`; `/workspaces/:workspaceId/files`, `/storage` | **POTWIERDZONY:** `StorageEndpoints.cs` | storage ACL, picker/download platform adapters, MinIO/ClamAV/OnlyOffice by operation | `storage_shell_page_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE — active routes placeholders; dowód: file smoke R3C |
| NAV-12 Menu workspace: ustawienia/członkowie/zaproszenia/powiadomienia | `d1cc273:…/workspaces_settings/*` → te same | `spaces/{settings,members,invitations}`; docelowo pod workspace | **POTWIERDZONY:** `WorkspaceEndpoints.cs`, `NotificationEndpoints.cs` | workspace role; invitations and membership checked server-side | `workspace_members_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE — brak aktywnej trasy; dowód: role/invite/revoke/preferences |
| NAV-13 Menu projektu: settings/resources | `d1cc273:…/projects/settings/*`, `workspace_project_resource_catalog_page.dart` → te same | `projects/settings`; docelowo `/…/projects/:projectId/settings` | **POTWIERDZONY:** `ProjectEndpoints.cs`, task config endpoints | project manager/Owner/Admin per action; resource ACL | `project_settings_and_user_hub_modals_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: resource tree and settings persistence |
| NAV-14 Shell menu zwijane | `d1cc273:…/workspace_shell/{workspace_shell,navigation}/*` → te same | `app/shell/navigation`; globalny shell | NIEZWERYFIKOWANY — layout nie ma endpointu | local settings, focus/keyboard, route port; bez danych domenowych | `workspace_static_menu_test.dart`, `workspace_menu_visual_smoke_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE — statyczny skeleton; dowód: expanded/collapsed/flyout at 1280–1920 |
| NAV-15 Chat i Notifications w topbarze | historyczny `lib/app/shell/panels/*` (usunięty) → `lib/app/shell/devplanner_shell.dart` + global compositions (brak) | `app/shell/overlays`; `/chat`, `/notifications` | **POTWIERDZONY:** `ChatEndpoints.cs`, `NotificationEndpoints.cs` | single overlay host, focus/Escape/restore focus; session runtime | `devplanner_shell_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1 (missing compositions); live: NIE; dowód: panel bez zmiany trasy/edycji |

## Projects, członkostwo i konfiguracja

| ID / funkcja | stare źródło → obecne źródło | docelowo / trasa | endpoint Backend | zależności i uprawnienia | test / wcześniej / odzyskanie / live / wymagany dowód |
|---|---|---|---|---|---|
| PRJ-01 CRUD projektu, archive/restore/delete | `d1cc273:lib/workspaces/data/projects/*` → `lib/workspaces/data/projects/{api,repositories,payloads,responses}` | `projects`; `/…/projects/:projectId` | **POTWIERDZONY:** `ProjectEndpoints.cs` | workspace membership; mutation permission in backend | `workspace_projects_cubit_test.dart`; wcześniej: częściowa; odzyskanie: zachowany data, blokada R1 UI; live: NIE; dowód: CRUD/reload/403/conflict |
| PRJ-02 Członkowie projektu i role | `d1cc273:…/projects/*members*` → data + `presentation/projects/settings/members/*` | `projects/members`; settings route | **POTWIERDZONY:** `ProjectEndpoints.cs` | project role + local directory; backend blocks IDOR | `project_member_profiles_repository_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: add/change/remove/self-leave and forbidden |
| PRJ-03 Portfolio i dashboard projektu | `d1cc273:…/projects/portfolios/*` → data remains; no full presentation | `projects/portfolios`; docelowa route per resource | **POTWIERDZONY:** `PortfolioEndpoints.cs`, `ProjectDashboardEndpoints.cs` | workspace/project ACL | brak UI testu; wcześniej: plan; odzyskanie: plan R3A; live: NIE; dowód: portfolio membership/dashboard empty and error |
| PRJ-04 Szablony projektu | `d1cc273:…/projects/templates/*` → data + `presentation/projects/settings/admin/tabs/templates/*` | `projects/templates`; settings route | **POTWIERDZONY:** `ProjectEndpoints.cs` (project templates) | manager/Owner/Admin according to endpoint policy | `project_templates_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: CRUD/apply and optimistic conflict |
| PRJ-05 Workflow, statuses, milestones, automations | `d1cc273:…/projects/{custom_workflow,milestones}/*` → data + settings Cubits | `tasks/workflow`, `tasks/settings`; project settings | **POTWIERDZONY:** `ProjectCustomStatusEndpoints.cs`, `ProjectMilestoneEndpoints.cs`, `AutomationEndpoints.cs` | project manage role; workspace admin for some schedules | `custom_workflow_settings_cubit_test.dart`, `milestone_settings_cubit_test.dart`, `automation_settings_cubit_test.dart`; wcześniej: częściowa; odzyskanie: zachowany source, blokada R1; live: NIE; dowód: CRUD/reorder/WIP/automation error handling |

## Zadania: board, lista i szczegóły

| ID / funkcja | stare źródło → obecne źródło | docelowo / trasa | endpoint Backend | zależności i uprawnienia | test / wcześniej / odzyskanie / live / wymagany dowód |
|---|---|---|---|---|---|
| TSK-01 Board snapshot i kolumny | `d1cc273:…/presentation/tasks/board/*` → `lib/workspaces/presentation/tasks/board/*` | `tasks/board`; `/…/tasks?view=board` | **POTWIERDZONY:** `KanbanEndpoints.cs` | shared task snapshot, project ACL | `tasks_board_cubit_test.dart`, `kanban_baseline_audit_test.dart`; wcześniej: częściowa; odzyskanie: UI zachowany, blokada R1; live: NIE — router placeholder; dowód: loaded/empty/error/retry |
| TSK-02 Drag/drop, reorder, WIP i conflicts | `d1cc273:…/board/{columns,cards,viewport}/*` → te same | `tasks/board`; jw. | **POTWIERDZONY:** `KanbanEndpoints.cs`, `ProjectTaskEndpoints.cs` (`move`, `order`) | write task permission, WIP and optimistic version server-side | `kanban_auto_scroll_coordinator_test.dart`, `kanban_card_interactions_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: drag, 409 refresh and forbidden |
| TSK-03 Karta, quick create, template | `d1cc273:…/board/{tasks_board_card*,quick_create,template_picker}*` → te same | `tasks/board`; jw. | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` (create/templates) | create task permission; template ACL | `task_template_picker_*_test.dart`, card golden tests; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: create from blank/template + validation |
| TSK-04 Board preferences, collapse columns, saved views | `d1cc273:…/board/{view_preferences,saved_views}*` → te same | `tasks/{board,views}`; query `view` | **POTWIERDZONY:** `KanbanUserPreferenceEndpoints.cs`, `ProjectTaskEndpoints.cs` task-views | own user preferences + project read | `task_saved_views_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: persist collapse/filter/view after restart |
| TSK-05 Realtime board | `d1cc273:…/data/realtime/tasks/*` → same source | `tasks/board`; no route change | POTWIERDZONY REST contract; hub path **NIEZWERYFIKOWANY** in this audit | typed SignalR port, replay/dedup/revoke, project ACL | `task_project_realtime_adapter_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: two-user update/reconnect/revoke |
| TSK-06 Lista: query, grouping, sort/filter | `d1cc273:…/presentation/tasks/list/{cubit,filters,grouping}/*` → same | `tasks/list`; `/…/tasks?view=list` | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` list/groups | project read; one shared task model | `project_tasks_list_flow_test.dart`, `task_list_grouping_test.dart`; wcześniej: częściowa; odzyskanie: UI preserved, blokada R1; live: NIE; dowód: group/sort/filter/empty/error |
| TSK-07 Lista: columns, resize/reorder | `d1cc273:…/list/{table,preferences}/*` → same | `tasks/list`; jw. | **POTWIERDZONY:** task-views in `ProjectTaskEndpoints.cs` | personal saved view, local controller lifecycle | `task_list_columns_sheet_test.dart`, `task_list_preferences_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: resize/reorder persists and 150% text |
| TSK-08 Lista: inline create/edit, context menu | `d1cc273:…/list/{inline_create,menu,cells}/*` → same | `tasks/list`; jw. | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` create/update/list-item | task write permission, validation/version | `project_tasks_list_rows_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: edit/create failure and 409 |
| TSK-09 Lista: multi-select i bulk | `d1cc273:…/list/{bulk,cubit/task_list_selection.dart}*` → same | `tasks/list`; jw. | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` selection-token/bulk | write permission on every selected resource | `task_list_selection_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: bulk partial forbidden/result reconciliation |
| TSK-10 Szczegół, opis, properties, priority, dates | `d1cc273:…/tasks/detail/{task_details_page,description,properties}*` → same | `tasks/details`; `/…/tasks/:taskId` | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` get/update | task ACL, optimistic version | `task_details_cubit_test.dart`; wcześniej: częściowa; odzyskanie: UI preserved, blokada R1; live: NIE — route placeholder; dowód: edit/reload/conflict |
| TSK-11 Assignees, watchers, labels | `d1cc273:…/detail/{collaboration,labels}*` → same | `tasks/details`; jw. | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` assignees/watchers/labels | project members + task write/read; label manage role | `task_models_contract_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: replace/follow/label + 403 |
| TSK-12 Checklisty, podzadania, acceptance criteria | `d1cc273:…/detail/{checklist,subtasks,acceptance}*` → same | `tasks/details`; jw. | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` checklist/acceptance and move parent | task write, one-level subtask rule backend | `kanban_subtasks_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: add/reorder/complete and validation |
| TSK-13 Dependencies i schedule cascade | `d1cc273:…/detail/task_details_dependencies.dart` → same | `tasks/details`, `tasks/schedule`; jw. | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` dependencies; `ProjectScheduleEndpoints.cs` | project read/write; cycle and expected version server-side | brak targeted UI testu; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: create cycle rejected, preview/apply cascade |
| TSK-14 Custom fields, milestone | `d1cc273:…/detail/{custom_fields,milestone}*` → same | `tasks/details`, `tasks/settings` | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` custom-fields; `ProjectMilestoneEndpoints.cs` | manage definitions vs task value write; ACL | `task_custom_fields_settings_cubit_test.dart`, `task_milestone_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: field CRUD/value and milestone set |
| TSK-15 Historia i załączniki taska | `d1cc273:…/detail/{history,attachments}/*` → same | `tasks/details`; jw. | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` history/attachments | task read + storage attachment ACL | `task_history_cubit_test.dart`, `task_attachments_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: history after mutation, attach/list/download |
| TSK-16 Recurrence i templates | `d1cc273:…/tasks/{detail/recurrence,recurrence,detail/templates}/*` → same | `tasks/{details,recurrence,templates}` | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` recurrence/task-templates | task write; template author/workspace admin rules | `task_recurrence_cubit_test.dart`, `task_template_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: create/pause/run/reuse template |
| TSK-17 Time tracking, timeline, workload, capacity | `d1cc273:…/tasks/{detail/time_tracking,timeline,workload}/*` → same | `tasks/{details,timeline,workload,capacity}` | **POTWIERDZONY:** `TaskTimeTrackingEndpoints.cs`, `TaskWorkloadEndpoints.cs`, `TaskCapacityEndpoints.cs`, `ProjectTaskEndpoints.cs` timeline | project/task ACL; capacity own/admin by endpoint | `task_time_tracking_cubit_test.dart`, `task_capacity_settings_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: timer/report/capacity and access denial |
| TSK-18 Workflow, automations, labels/configuration | `d1cc273:…/tasks/settings/*` → same | `tasks/settings`; project settings | **POTWIERDZONY:** `ProjectTaskEndpoints.cs`, `AutomationEndpoints.cs`, `ProjectCustomStatusEndpoints.cs` | project manager/Admin/Owner per action | settings cubit tests listed above; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: settings mutation and server-enforced role |
| TSK-19 My tasks i global search | `d1cc273:…/tasks/views/task_views_api.dart` → same data; no current page | `tasks/search`; `/me/tasks` (catalog only) | **POTWIERDZONY:** `ProjectTaskEndpoints.cs` `/api/v1/me/tasks`, `/api/v1/tasks/search` | authenticated user, access-safe global filtering | no presentation test; wcześniej: plan; odzyskanie: plan R3B; live: NIE — catalog has no GoRoute; dowód: cross-project list/search no data leak |

## Storage

| ID / funkcja | stare źródło → obecne źródło | docelowo / trasa | endpoint Backend | zależności i uprawnienia | test / wcześniej / odzyskanie / live / wymagany dowód |
|---|---|---|---|---|---|
| STO-01 Browser folderów/plików, grid/list, selection | `d1cc273:…/presentation/storage/{shell,browser}/*` → same | `storage/browser`; `/storage`, `/workspaces/:id/files` | **POTWIERDZONY:** `StorageEndpoints.cs` | Storage ACL, route codec, selection local state | `storage_browser_cubit_test.dart`, `storage_shell_page_test.dart`; wcześniej: częściowa; odzyskanie: source zachowany, blokada R1; live: NIE — active routes placeholders; dowód: browse/grid/list/keyboard |
| STO-02 Upload, progress, cancel, retry, create document | `d1cc273:…/storage/{upload,browser/mutations}/*` → same | `storage/upload`; within browser | **POTWIERDZONY:** `StorageEndpoints.cs` upload-ticket/bulk-complete/create | picker/upload adapter, MinIO, antivirus; storage write ACL | `storage_mutations_and_upload_test.dart`, `storage_document_creation_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: upload/cancel/retry and persistent content |
| STO-03 Download, rename/move/delete, versions | `d1cc273:…/storage/{transport,browser/mutations,versions}/*` → same | `storage/browser`; file detail | **POTWIERDZONY:** `StorageEndpoints.cs` download, folder/files mutation, versions | platform download port + object ACL/version checks | `transport_test.dart`, `storage_file_details_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: download hash, move/delete/restore/version |
| STO-04 Preview media/PDF/text | `d1cc273:…/storage/preview/*` → same | `storage/preview`; file detail | **POTWIERDZONY:** `StorageEndpoints.cs` stream/file detail | read ACL, safe content type | `storage_preview_cubit_test.dart`, `text_preview_loader_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: preview/error/forbidden |
| STO-05 Sharing, public link i ACL | `d1cc273:…/storage/{sharing,public_share}/*` → same | `storage/sharing`; public share route needs explicit catalog entry | **POTWIERDZONY:** `StorageEndpoints.cs`; object grants also access-control endpoints | share permission; public token handled server-side | `storage_sharing_cubit_test.dart`, `storage_public_share_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: grant/revoke/public link and 403 |
| STO-06 OnlyOffice i file chat | `d1cc273:…/storage/office/*`, `chat/resource/*` → same | `storage/office`, `chat/resource` | **POTWIERDZONY:** `StorageEndpoints.cs` office session; `ChatEndpoints.cs` resolve | OnlyOffice availability, Storage+Chat ACL; panel port | `storage_office_cubit_test.dart`, `resource_chat_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: edit session + file chat preserves route |
| STO-07 Avatar, AI/search, admin storage | `d1cc273:…/storage/api/storage_api.dart` → same data; no dedicated complete UI | `profile/avatar`, `storage/ai`, `admin/ops` | **POTWIERDZONY:** `StorageEndpoints.cs`, `AdminOpsEndpoints.cs` | own avatar; object/workspace ACL; SuperAdmin admin endpoints; AI provider | `app_user_avatar_test.dart`, serialization tests; wcześniej: częściowa; odzyskanie: plan R3C; live: NIE; dowód: avatar upload/delete, semantic result ACL, provider failure |

## Chat i powiadomienia

| ID / funkcja | stare źródło → obecne źródło | docelowo / trasa | endpoint Backend | zależności i uprawnienia | test / wcześniej / odzyskanie / live / wymagany dowód |
|---|---|---|---|---|---|
| CHT-01 Globalny panel i lista rozmów | historyczny `lib/app/shell/panels/*`; `d1cc273:…/presentation/chat/{drawer,landing,shell}/*` → same UI, missing global composition | `chat`; `/chat` | **POTWIERDZONY:** `ChatEndpoints.cs` conversations | authenticated conversation ACL, session runtime, overlay host | `chat_drawer_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1 (missing composition); live: NIE/unavailable; dowód: open/close panel without route reset |
| CHT-02 Conversation/messages/drafts/delivery/retry | `d1cc273:…/chat/{chat_conversation_page,composer,conversation_delivery}/*` → same | `chat/conversation`; `/chat/conversations/:id` | **POTWIERDZONY:** `ChatEndpoints.cs` messages/draft/delivery | conversation ACL, secure draft repo, idempotent client ID | `chat_conversation_cubit_test.dart`, `chat_composer_*_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: send/retry/draft/reload |
| CHT-03 Threads, discussions, reactions, pins/bookmarks | `d1cc273:…/chat/{thread,discussion,message_actions}/*` → same | `chat`; conversation panel | **POTWIERDZONY:** `ChatEndpoints.cs` thread/reaction/pin/bookmark endpoints | conversation membership/role | `chat_thread_cubit_test.dart`, `chat_thread_and_discussion_ui_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: thread and action denied/allowed |
| CHT-04 Chat attachments/resource chat | `d1cc273:…/chat/attachments/*`, `chat/resource/*` → same | `chat`; conversation/resource panel | **POTWIERDZONY:** `ChatEndpoints.cs`, `StorageEndpoints.cs` | chat+storage ACL, picker/upload lifecycle | attachment upload/selection tests; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: select/upload/cancel/attach and revoke |
| CHT-05 Chat realtime/reconnect/status | `d1cc273:…/data/realtime/chat/*` → same | `chat`; no route change | REST **POTWIERDZONY:** `ChatEndpoints.cs`; hub route **NIEZWERYFIKOWANY** here | typed realtime port, desktop token/BFF rules, dedup/revoke | `workspace_chat_realtime_*_test.dart`, `chat_realtime_status_cubit_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: two users/reconnect/revoke |
| NOT-01 Inbox, unread, groups, read/all-read/pin/archive | `d1cc273:…/notifications/{global_notifications_page,cubit}/*` → same UI, missing global composition | `notifications`; `/notifications` | **POTWIERDZONY:** `NotificationEndpoints.cs` | own notification only; runtime/overlay | `notifications_cubit_test.dart`, `global_notifications_page_test.dart`; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE/unavailable; dowód: group/read-all/deep link |
| NOT-02 Reply, preferences, digest, realtime | `d1cc273:…/notifications/{reply,preferences}/*`, realtime notifications → same | `notifications/settings`; panel | **POTWIERDZONY:** `NotificationEndpoints.cs`; hub route **NIEZWERYFIKOWANY** here | own preference; reply rechecks Chat ACL; reconnect/revoke | `notification_reply_*_test.dart`, preferences tests; wcześniej: częściowa; odzyskanie: blokada R1; live: NIE; dowód: reply/403/preferences/realtime |

## Wiki, Whiteboard, Corkboard i OKR

| ID / funkcja | stare źródło → obecne źródło | docelowo / trasa | endpoint Backend | zależności i uprawnienia | test / wcześniej / odzyskanie / live / wymagany dowód |
|---|---|---|---|---|---|
| RES-01 Wiki tree/page/revision/ACL/AI | `d1cc273:lib/workspaces/data/wiki/*`, `presentation/routing/workspace_resource_extra_pages.dart` → same; no complete feature UI | `wiki`; `/…/wiki`, `/…/wiki/:pageId` | **POTWIERDZONY:** `WikiEndpoints.cs`, `WikiPageAccessEndpoints.cs` | workspace/project/page ACL, realtime, AI optional | no full UI test; wcześniej: częściowa; odzyskanie: plan R3E; live: NIE — active route placeholder, old page is incomplete; dowód: edit/revision/restore/ACL |
| RES-02 Whiteboard objects/pages/templates/export/AI/ACL | `d1cc273:lib/workspaces/data/whiteboard/*`, routing resource pages → same; no complete presentation tree | `whiteboard`; `/…/whiteboards/:id` | **POTWIERDZONY:** `WhiteboardEndpoints.cs`, `WhiteboardAiEndpoints.cs`, `WhiteboardAccessEndpoints.cs` | whiteboard ACL + realtime; AI/export service | no full UI test; wcześniej: plan; odzyskanie: plan R3E; live: NIE — route placeholder; dowód: object CRUD, realtime, export, ACL |
| RES-03 Corkboard cards i AI | `d1cc273:lib/workspaces/data/corkboard/*`, project menu → same; no dedicated presentation | `corkboard`; `/…/corkboard` | **POTWIERDZONY:** `CorkboardEndpoints.cs`, `CorkboardAiEndpoints.cs` | project ACL, AI optional | no UI test; wcześniej: plan; odzyskanie: plan R3E; live: NIE — absent active route; dowód: card CRUD/order/archive + AI failure |
| RES-04 OKR objective/key results | `d1cc273:lib/workspaces/data/okr/*`, `presentation/okr/*` → same | `okr`; `/…/okr/objectives/:id` | **POTWIERDZONY:** `OkrEndpoints.cs` | workspace ACL, creator/assignment data server-checked | `okr_objective_details_cubit_test.dart`; wcześniej: częściowa; odzyskanie: plan R3E; live: NIE — old route not active; dowód: objective/key result CRUD and access denial |

## Martwe, placeholderowe albo mylące trasy — do usunięcia dopiero po migracji

| Ścieżka / element | Stan potwierdzony | Wymagane bezpieczne zastąpienie |
|---|---|---|
| `/workspaces/:workspaceId` | `DevPlannerRoutePlaceholderPage`; nie otwiera dashboardu ani workspace context. | R2 podłączyć prawdziwy `spaces` composition albo jawny redirect do działającego overview. |
| `/workspaces/:workspaceId/files`, `/storage` | oba placeholdery mimo istniejącego Storage UI. | R2/R3C: route codec + `StorageShellPage` z local transportem; test deep link. |
| `/workspaces/:workspaceId/projects/:projectId` oraz `/…/tasks` | placeholdery mimo source Projects/Board/List. | R2: prawdziwe project/tasks pages, shared task snapshot, preserved `?view=`. |
| `/…/tasks/:taskId`, `/…/resources/:resourceId`, `/…/files/:fileId` | placeholdery, nie detail. | R2/R3: typed params, ACL/data state, 404/403/409. |
| `/workspaces/:workspaceId/wiki/:pageId`, `/…/whiteboards/:whiteboardId` | placeholdery; old routing is not active. | R3E: dedicated feature pages; no generic empty wrapper. |
| `/me/:section` | placeholder; `DevPlannerRouteCatalog` also defines `/me/tasks` and `/me/files` without `GoRoute`. | Implement profile sections and my tasks/files or remove catalog entries only after explicit migration/redirect. |
| `presentation/routing/workspace_resource_pages.dart` / `workspaces_section_pages.dart` | contains `SizedBox.shrink()` contexts and `WorkspacesSectionPlaceholder`; no import from active router; legacy `ready_next` imports. | Treat as recovery source only; port each verified feature to target tree and then delete with consumer scan. |
| `WorkspaceStaticMenu` | comments explicitly call it a static skeleton; only Dashboard/Projects/Files actions. | Do not use it as final navigation; rebuild all `NAV-*` entries with permission-aware router. |
| `/chat`, `/notifications` | routes exist, but become unavailable because missing compositions prevent runtime construction. | R1 restore compositions and R2 wire secure session runtime; overlay smoke test. |

## Kolejność działania po tej inwentaryzacji

1. R1: odzyskać wyłącznie brakujące źródła wskazane w sekcji R1 planu, opisać
   ich pochodzenie w `file-recovery-manifest.md`, a następnie naprawić importy
   według grafu zależności. Nie kasować odzyskanych board/list/details/storage.
2. R2: właściciel routera podłącza najpierw katalog → workspace → projekt →
   tasks/list/board/details → Storage; zastępuje tylko wymienione placeholdery
   funkcją o równoważnym kontrakcie, nie pustym ekranem.
3. R3: wykonywać piony według ID tej macierzy. Po każdym scenariuszu wpisać
   konkretną komendę, revision, wynik, dane syntetyczne i status `live`.
4. R4: przed przenosiną utworzyć `file-moves.md`; wszystkie pliki >400 linii
   rozdzielać w docelowe Cubity, use case’y i małe widgety. Nie wolno używać
   globalnego Cubitu jako obejścia istniejących composition roots.

## Minimalny dowód zamknięcia pojedynczego ID

Każdy rekord może przejść na `live: TAK` dopiero po: działającej aktywnej trasie,
rzeczywistym endpointcie lokalnego Backend, scenariuszach success/loading/empty/
forbidden/failed/retry (oraz 409 i realtime, gdy dotyczy), teście automatycznym
odpowiedniej gałęzi i ręcznym smoke desktop. Wyniki sprzed aktualnego drzewa,
same mocki albo brak błędu po kliknięciu nie są dowodem równoważności.
