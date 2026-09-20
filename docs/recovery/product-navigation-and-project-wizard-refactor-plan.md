# DevPlanner — plan refaktoryzacji nawigacji, Tasks i tworzenia projektu

Status: **plan wykonawczy po audycie kodu Front i Backend; bez zmian runtime**  
Data: 2026-09-19  
Repozytoria: `Backend` oraz `Front`  
Poprzednie plany: `tasks-list-kanban-ux-recovery-plan.md`,
`tasks-parity-and-ui-repair-plan.md`

## 1. Cel produktu

Interfejs ma prowadzić użytkownika przez pracę, a nie odzwierciedlać strukturę
endpointów. Docelowo:

1. drzewo boczne pokazuje workspace i projekty jako podstawowe obiekty;
2. projekt ma jeden moduł **Zadania**, a Lista i Kanban są dwoma widokami tego
   samego zbioru, wybieranymi w nagłówku modułu;
3. akcje istniejące w Backendzie są osiągalne w miejscu, w którym użytkownik
   ich szuka: menu projektu, pasek Zadania, szczegóły zadania i ustawienia;
4. utworzenie projektu uruchamia kreator: pusty projekt albo szablon, wygląd,
   widoczność, workflow, zespół, ustawienia i podsumowanie;
5. każda zwykła mutacja działa optimistic-first: UI od razu pokazuje wynik,
   request jest weryfikowany w tle, a porażka powoduje kontrolowany rollback;
6. błąd nigdy nie jest ukrywany. Po rollbacku pozostaje trwały, zrozumiały
   komunikat z akcją ponowienia/odświeżenia i `traceId`, jeśli Backend go zwrócił.

Plan nie zakłada przepisywania całej aplikacji ani tworzenia drugiego modelu
zadań. Lista i Kanban nadal używają jednego źródła danych oraz obecnych
kontraktów Tasks/Kanban.

## 2. Stan zastany potwierdzony w kodzie

### 2.1. Nawigacja i Tasks

- `WorkspaceNavigationTree._projectNode()` tworzy dziś węzeł `Zadania`, a pod
  nim dwa osobne liście-drzewa: `taskList` i `kanban`.
- Oba widoki są już częścią jednej kompozycji `TasksProjectView`; trasa i
  `tasks_board_page.dart` potrafią przełączać Listę/Kanban bez tworzenia dwóch
  domen. Rozdzielenie w sidebarze jest więc decyzją prezentacyjną, nie
  ograniczeniem Backendu.
- Poprzednie pakiety T0–T7 i N8–N10 dostarczyły wspólny nagłówek, bulk bar,
  trwały banner błędów, rollback mutacji, serializację preferencji i bezpieczny
  retry transportu. Nowy plan rozwija te fundamenty; nie wolno ich omijać.

### 2.2. Projekty — Backend już potrafi

| Możliwość | Kontrakt | Stan Frontu / problem |
|---|---|---|
| Utworzenie podstawowego projektu | `POST /workspaces/{workspaceId}/projects` | Dwa różne formularze; sidebar ma tylko nazwę, drugi dialog ma nazwę/opis/ikonę/kolor/widoczność. Brak kreatora. |
| Przypięcie i ukrycie projektu | `PATCH .../projects/{projectId}/preferences` | Repository istnieje, ale akcje nie są konsekwentnie wystawione w drzewie. |
| Ręczna kolejność projektów | `PUT .../projects/preferences/order` | Backend wymaga pełnej listy; brak docelowego DnD z bezpiecznym rollbackiem. |
| Archiwizacja/przywrócenie/usunięcie | `POST .../archive`, `POST .../restore`, `DELETE` | Akcje istnieją, ale aktywna lista nie udostępnia katalogu archiwum. |
| Członkowie i role | rodzina `/members` | Dostępne w ustawieniach; kreator ich nie używa. |
| Szablony całych projektów | `/project-templates`, w tym `details` i `apply` | UI administracyjne istnieje, lecz nie jest początkiem tworzenia projektu. |
| Szablony workflow | `/custom-workflow/templates` i `/templates/apply` | Dostępne po utworzeniu projektu; brak wyboru w kreatorze. |
| Milestones, etykiety, custom fields, harmonogram, capacity | osobne rodziny endpointów | Funkcje są rozproszone w ustawieniach i nie mają wspólnego onboarding flow. |
| Portfolia, dashboard projektu, workload | osobne endpointy | Nie należy wciskać ich do sidebaru jako martwych pozycji; wymagają własnego pionu UI. |
| Automatyzacje i recipes | `/automations`, `/catalog`, `/recipes` | Backend bogaty, ale pozycja została usunięta z drzewa, bo nie ma aktywnej trasy. |

### 2.3. Zadania — niewykorzystane możliwości Backendu

Backend poza podstawowym CRUD udostępnia m.in. szybkie tworzenie, szczegóły i
historię, archiwizację/przywracanie, kolejność, przenoszenie, zależności,
wykonawców, checklisty, kryteria akceptacji, obserwowanie, załączniki,
cykliczność, szablony zadań, zapisane widoki, etykiety, pola niestandardowe,
time tracking, harmonogram kaskadowy, capacity/workload, bulk selection oraz
realtime. Matryca **Backend → adapter → stan → UI → test** w §4.3 spina te
możliwości z rzeczywistymi plikami Frontu, aby istnienie endpointu nie było
mylone z gotową funkcją produktu.

### 2.4. Potwierdzone luki Backendu

1. `GET /projects` zwraca tylko aktywne projekty. `restore` istnieje, ale brak
   publicznego sposobu wylistowania archiwum, więc przywracanie jest praktycznie
   nieodkrywalne. **Domknięte w P1:** `?state=active|archived|all`.
2. `includeHidden=true` dołącza ukryte projekty, lecz `ProjectListItemResponse`
   nie zawiera `IsHidden`; klient nie potrafi odróżnić ukrytego elementu od
   zwykłego bez dodatkowego kontraktu. **Domknięte w P1:** `isHidden`, `version`
   i `capabilities` w elemencie listy, `?visibility=visible|hidden|all`.
3. Backend nie ma operacji przeniesienia projektu między workspace’ami.
   `UpdateProjectOrder` zmienia wyłącznie kolejność w jednym workspace.
4. `Project` ma token `Xmin`, a opis endpointu deklaruje optimistic
   concurrency, lecz `ProjectResponse`, `ProjectListItemResponse` i
   `UpdateProjectRequest` nie publikują `Version/ExpectedVersion`. Klient nie
   może świadomie wykrywać konfliktu edycji projektu.
5. Podstawowe `CreateProjectRequest` i `ApplyProjectTemplateRequest` nie tworzą
   konfigurowalnego projektu w jednym atomowym poleceniu. Składanie kreatora z
   wielu requestów zostawiłoby częściowo utworzony projekt po błędzie.
6. Lista projektu publikuje `MyRole`, ale nie jawne capabilities. Nie wolno
   kopiować reguł ACL do Fluttera; serwer powinien zwrócić co wolno pokazać,
   nadal egzekwując każdą operację po swojej stronie.

## 3. Docelowy model nawigacji

### 3.1. Drzewo boczne

Docelowa hierarchia:

```text
Moje zadania
Moje pliki
Workspace
  Pliki
  Projekty
    Projekt A
      Zadania
      Pliki
```

Nie renderujemy pod `Zadania` dzieci `Lista` i `Kanban`. Kliknięcie `Zadania`
otwiera ostatnio używany widok dla danego użytkownika i projektu. W nagłówku
modułu znajduje się segment `Lista | Kanban` oraz menu zapisanych widoków.

### 3.2. Routing i kompatybilność

- Kanoniczna trasa: `/workspaces/:workspaceId/projects/:projectId/tasks`.
- Widok jako query/state: `?view=list` albo `?view=board`; wybór zapisuje się
  jako preferencja użytkownika, bez zmiany danych domenowych.
- Stare linki `/tasks/list` i `/tasks/kanban` pozostają jako redirecty przez co
  najmniej jeden cykl wydania. Nie duplikują stron ani Cubitów.
- Back/forward przeglądarki ma odtwarzać widok, filtr i zapisany widok.
- Zmiana Lista ↔ Kanban nie może resetować selekcji, filtrów ani scrolla bez
  wyraźnego powodu; stan wspólny pozostaje wspólny, stan layoutu jest per widok.

### 3.3. Projekt w drzewie

Każdy projekt ma jedno menu kontekstowe:

- Otwórz;
- Przypnij/Odepnij;
- Ukryj dla mnie;
- Zmień nazwę/wygląd — tylko przy capability zarządzania;
- Ustawienia;
- Utwórz szablon z projektu;
- Archiwizuj — z potwierdzeniem i opisem skutków;
- Przenieś do workspace — dopiero po dostarczeniu kontraktu z §6.4;
- Opuść projekt — jeśli reguła ostatniego Ownera pozwala;
- Usuń trwale wyłącznie z widoku Archiwum i po ponownym potwierdzeniu nazwy.

Przypięte projekty są na górze. DnD zmienia kolejność w obrębie sekcji
przypiętej lub zwykłej; UI nie może wysłać niepełnej listy wymaganej przez
Backend. Ukryte projekty znikają natychmiast, ale są dostępne w ekranie
`Ukryte`, skąd można je przywrócić.

## 4. Jeden moduł Zadania

### 4.1. Wspólny chrome

Jedna powierzchnia nad treścią zawiera:

- nazwę projektu i breadcrumb;
- przełącznik `Lista | Kanban`;
- wyszukiwanie, wspólne filtry, zapisane widoki;
- `+ Zadanie` i menu `z szablonu`;
- bulk bar pojawiający się w tym samym miejscu;
- trwały banner błędów bez zasłaniania danych;
- menu ustawień widoku właściwe dla Listy lub Kanbanu.

Filtry muszą mieć jedno źródło definicji. Różnice są dozwolone tylko wtedy,
gdy wynikają z semantyki widoku (np. ręczna kolejność kart w Kanbanie), i muszą
być jawnie opisane w UI oraz testach.

### 4.2. Mapa funkcji Tasks do powierzchni UI

| Funkcja | Powierzchnia docelowa | Minimalny dowód |
|---|---|---|
| pin/watch task | menu wiersza/karty i szczegóły | natychmiastowa ikona, request, rollback |
| move/status/custom workflow | DnD, picker statusu, bulk bar | 409 przywraca dokładną pozycję/status |
| assignees/labels/milestone | inline, karta/szczegóły, bulk | role i ACL, częściowa porażka bulk widoczna |
| checklist/acceptance criteria | szczegóły zadania | CRUD, kolejność, conflict/error |
| dependencies + cascade preview | szczegóły/harmonogram | preview bez zapisu, osobne Apply |
| recurrence | szczegóły i panel cykliczności | pause/resume/run-now i historia uruchomień |
| templates | menu `+ Zadanie` i biblioteka ustawień | podgląd przed apply |
| time tracking | szczegóły + aktywny timer w shellu | jeden timer użytkownika, submit/approve/reject |
| history | panel aktywności szczegółów | cursor/paginacja, brak przecieku ACL |
| workload/capacity | widok projektu/ustawienia zespołu | zakres dat, role, stan przeciążenia |
| saved views | wspólne menu Listy/Kanbanu | ten sam filtr danych po obu stronach |

Nie dodajemy wszystkich kontrolek naraz do nagłówka. Rzadkie akcje trafiają do
menu lub szczegółów, a częste do command baru. Każda widoczna akcja musi mieć
działający port, obsługę błędu i test. Stan realizacji tych powierzchni — razem
z rzeczywistymi plikami Frontu — opisuje matryca §4.3.

### 4.3. Matryca Backend → adapter → stan → UI → test

Stan odczytany z kodu 2026-09-19, nie z nazw endpointów. Ścieżki są względne
wobec `Front/`, a poprzedzone `Backend/` — wobec `Backend/`; skróty:
`D/` = `lib/workspaces/data/`, `P/` = `lib/workspaces/presentation/`,
`A/` = `D/projects/tasks/repositories/`,
`T/` = `test/workspaces/presentation/tasks/`. Kolumna `Ocena` mówi, co blokuje
uznanie wiersza za gotową funkcję; brak UI albo brak testu oznacza, że funkcji
nie wolno reklamować jako dostarczonej.

#### 4.3.1. Tasks

| Funkcja | Backend | Adapter | Stan | UI | Test | Ocena |
|---|---|---|---|---|---|---|
| create i quick-create | `POST /tasks/`, `POST /tasks/quick-create` — `D/projects/tasks/api/tasks_api.dart:16,24` | `A/tasks_repository_impl.dart:121` | `P/tasks/list/cubit/task_list_creation_mixin.dart`, `P/tasks/board/cubit/tasks_board_preference_commands.dart:320` | `P/tasks/header/tasks_header_quick_create_dialog.dart`, `P/tasks/list/inline_create/task_list_inline_create.dart` | `T/list/project_tasks_list_cubit_test.dart` | gotowe |
| szczegóły zadania | `GET /tasks/{taskId}` — `tasks_api.dart:90` | `A/tasks_repository_impl.dart:121` | `P/tasks/detail/cubit/task_details_cubit.dart` | `P/tasks/detail/task_details_page.dart` | `T/task_details_cubit_test.dart` | gotowe |
| pin i watch | `PUT /tasks/{taskId}/preference`, `POST`/`DELETE` watch — `D/projects/tasks/api/task_operations_api.dart:144,63,73,84` | `A/task_collaboration_repository_impl.dart:38` | `P/tasks/board/cubit/tasks_board_card_commands.dart:25,58`, `P/tasks/list/cubit/task_list_item_mutation_mixin.dart:102,144` | `P/tasks/board/tasks_board_card_menu.dart:73`, `P/tasks/list/cells/task_cell_title.dart:211`, `P/tasks/detail/task_details_header.dart:42` | `T/tasks_board_cubit_test.dart` | gotowe |
| move i status | `PATCH /tasks/{taskId}/move`, `/list-item`, `/move-kanban` — `tasks_api.dart:135`, `D/kanban/api/kanban_api.dart:100` | `A/tasks_repository_impl.dart:165`, `D/kanban/repositories/kanban_repository_impl.dart` | `P/tasks/board/cubit/tasks_board_bulk_commands.dart:110`, `P/tasks/list/cubit/task_list_mutation_mixin.dart:7` | `P/tasks/board/tasks_board_drop_targets.dart:25`, `P/tasks/list/menu/pickers/task_status_picker.dart` | `T/board/kanban_card_interactions_test.dart` | gotowe |
| bulk | `PATCH /kanban/bulk-move`, `/kanban/bulk-update`, `POST /tasks/selection-token`, `PATCH /tasks/selection-token/bulk` — `kanban_api.dart:80,90`, `tasks_api.dart:97,106` | repozytoria Kanban i Tasks | `P/tasks/board/cubit/tasks_board_bulk_commands.dart:29`, `P/tasks/list/cubit/task_list_selection_mixin.dart:118,167` | `P/tasks/bulk/tasks_contextual_bulk_bar.dart`, `P/tasks/list/bulk/task_list_bulk_bar.dart` | `T/board/tasks_board_bulk_bar_test.dart`, `T/list/cubit/task_list_selection_test.dart` | gotowe |
| wykonawcy | `PUT /tasks/{taskId}/assignees` — `task_operations_api.dart:16` | `A/task_collaboration_repository_impl.dart:17` | `P/tasks/board/cubit/tasks_board_card_commands.dart:124`, `P/tasks/list/cubit/task_list_item_mutation_mixin.dart:50` | `P/tasks/list/cells/task_cell_assignees.dart`, `P/tasks/list/menu/pickers/task_assignee_picker.dart` | `T/task_details_cubit_test.dart` | gotowe |
| etykiety | `/tasks/{taskId}/labels`, CRUD `/labels` — `task_operations_api.dart:187-223` | `A/task_metadata_repository_impl.dart` | `P/tasks/detail/cubit/task_details_metadata_service.dart`, `P/tasks/list/cubit/task_list_item_mutation_mixin.dart:204` | `P/tasks/detail/task_details_labels.dart`, `P/tasks/list/cells/task_cell_labels.dart` | `T/settings/task_labels_settings_cubit_test.dart` | gotowe |
| kamień milowy | `D/projects/milestones/api/milestones_api.dart:14-81` | `D/projects/milestones/repositories/milestone_repository_impl.dart` | `P/tasks/detail/milestone/cubit/task_milestone_cubit.dart:99,126` | `P/tasks/detail/task_details_milestone.dart`, `P/tasks/list/cells/task_cell_milestone.dart` | `T/detail/task_milestone_cubit_test.dart` | gotowe |
| checklista | `task_operations_api.dart:27,38,50` | `A/task_checklist_repository_impl.dart` | `P/tasks/detail/cubit/task_details_checklist_service.dart` | `P/tasks/detail/task_details_checklist.dart`, `P/tasks/list/cells/task_checklist_popover.dart` | `T/detail/task_details_checklist_collaboration_service_test.dart` | gotowe |
| kryteria akceptacji | `task_operations_api.dart:96-131` | `A/task_acceptance_criteria_repository_impl.dart` | `P/tasks/detail/cubit/task_acceptance_criteria_service.dart` | `P/tasks/detail/task_details_acceptance.dart` | `T/detail/task_acceptance_criteria_service_test.dart` | gotowe |
| podzadania | `parentTaskId` w quick-create i move — `tasks_api.dart:24,135` | `A/tasks_repository_impl.dart` | `P/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart:251`, `P/tasks/list/cubit/task_list_subtasks_mixin.dart` | `P/tasks/board/tasks_board_card_subtasks.dart`, `P/tasks/list/table/task_list_subtasks.dart` | `T/board/cards/subtasks/cubit/kanban_subtasks_cubit_test.dart` | gotowe |
| zależności | `/tasks/{taskId}/dependencies` — `tasks_api.dart:176-209` | `A/tasks_repository_impl.dart:232` | `P/tasks/detail/cubit/task_details_dependencies_service.dart` | `P/tasks/detail/task_details_dependencies.dart` | `T/task_details_cubit_test.dart` | gotowe |
| kaskada harmonogramu | `POST /schedule/cascade/preview`, `POST /schedule/cascade` — `D/projects/tasks/api/task_schedule_api.dart:21,31` | `A/task_schedule_repository_impl.dart` | `P/tasks/detail/cascade/cubit/task_schedule_cascade_cubit.dart` (przeniesione z widgetu w P6a) | `P/tasks/detail/task_details_properties_planning.dart` (`_CascadePreview`) | `T/detail/cascade/task_schedule_cascade_cubit_test.dart` | gotowe (P6a) |
| cykliczność | `D/projects/tasks/api/task_advanced_api.dart:16-99` | `A/task_recurrence_repository_impl.dart` | `P/tasks/detail/recurrence/cubit/task_recurrence_cubit.dart`, `P/tasks/recurrence/cubit/project_recurrences_cubit.dart` | `P/tasks/detail/task_details_recurrence.dart`, `P/tasks/recurrence/project_recurrences_sheet.dart` | `T/detail/recurrence/task_recurrence_cubit_test.dart` | gotowe |
| szablony zadań | `D/projects/tasks/api/task_templates_api.dart:15-73` | `A/task_template_repository_impl.dart` | `P/tasks/board/templates/cubit/task_template_picker_cubit.dart`, `P/tasks/detail/templates/cubit/task_template_cubit.dart` | `P/tasks/board/tasks_board_template_picker.dart`, `P/tasks/board/template_actions/template_editor_view.dart` | `T/board/templates/task_template_picker_cubit_test.dart` | gotowe |
| zapisane widoki | `D/projects/tasks/api/task_views_api.dart:15-41` | `A/task_view_repository_impl.dart` | `P/tasks/views/cubit/task_saved_views_cubit.dart` | `P/tasks/views/widgets/task_saved_views_menu.dart`, `P/tasks/board/tasks_board_saved_views.dart` | `T/views/task_saved_views_cubit_test.dart` | gotowe |
| pola niestandardowe | `task_operations_api.dart:234-274` | `A/task_metadata_repository_impl.dart` | `P/tasks/detail/cubit/task_details_metadata_commands.dart` | `P/tasks/detail/task_details_custom_fields.dart`, `P/tasks/list/cells/custom_fields/task_cell_custom_field.dart` | `T/settings/task_custom_fields_settings_cubit_test.dart` | gotowe |
| time tracking | `D/projects/tasks/api/task_time_tracking_api.dart:15-81` | `A/task_time_tracking_repository_impl.dart` | `P/tasks/detail/time_tracking/cubit/task_time_tracking_cubit.dart` | `P/tasks/detail/task_details_time_tracking.dart`, `P/tasks/list/cells/task_cell_time_tracking.dart` | `T/detail/time_tracking/task_time_tracking_cubit_test.dart` | brak aktywnego timera w shellu z §4.2 |
| historia | `GET /tasks/{taskId}/history` — `task_advanced_api.dart:109` | `A/task_history_repository_impl.dart` | `P/tasks/detail/history/cubit/task_history_cubit.dart` | `P/tasks/detail/task_details_history.dart` | `T/detail/history/task_history_cubit_test.dart` | gotowe |
| archiwizacja i przywracanie | `POST /tasks/{taskId}/archive`, `/restore` — `tasks_api.dart:146,157` | `A/tasks_repository_impl.dart:188` | `P/tasks/detail/cubit/task_details_basic_mutation_service.dart:80`, `P/tasks/list/cubit/task_list_item_mutation_mixin.dart:9` | `P/tasks/list/table/rows/task_list_row_actions.dart`; board nie ma akcji | `T/list/project_tasks_list_cubit_test.dart` tylko dla archive | brak testu restore |
| kolejność zadań | `PUT /tasks/order` — `tasks_api.dart:168` | `A/tasks_repository_impl.dart:222` | brak — kolejność realizują `move` z `previousTaskId`/`nextTaskId` | brak | brak | kontrakt bez konsumenta |
| workload | `GET /projects/{projectId}/workload` — `D/projects/tasks/api/task_capacity_api.dart:70` | `A/task_capacity_repository_impl.dart` | `P/tasks/workload/cubit/task_workload_cubit.dart` | `P/tasks/board/tasks_board_workload.dart` | brak dedykowanego testu | częściowo |
| ustawienia capacity | `task_capacity_api.dart:14-59` | `A/task_capacity_repository_impl.dart` | `P/tasks/settings/cubit/task_capacity_settings_cubit.dart` | brak | `T/settings/task_capacity_settings_cubit_test.dart` | brak UI |
| załączniki | `task_operations_api.dart:155-184` | `A/task_attachment_repository_impl.dart` | `P/tasks/detail/attachments/cubit/task_attachments_cubit.dart` | `P/tasks/detail/task_details_attachments.dart` | `T/detail/attachments/task_attachments_cubit_test.dart` | gotowe |
| wyszukiwanie zadań | `GET /tasks/search` — `task_views_api.dart:64` | `A/task_view_repository_impl.dart:33` | brak | brak | brak | kontrakt bez konsumenta |

#### 4.3.2. Projekty

| Funkcja | Backend | Adapter | Stan | UI | Test | Ocena |
|---|---|---|---|---|---|---|
| lista projektów | `GET /projects` — `D/projects/api/projects_api.dart:34` | `D/projects/repositories/projects_repository_impl.dart` | `P/navigation/cubit/workspace_projects_cubit.dart` | `P/projects/workspace_projects_page.dart`, `P/workspaces_home/projects_tree/` | `test/workspaces/presentation/navigation/workspace_projects_cubit_test.dart` | gotowe |
| przypięcie i ukrycie | `PATCH /projects/{id}/preferences` — `projects_api.dart:243` | `D/projects/repositories/projects_repository_impl.dart:217` | `P/projects/settings/user_hub/cubit/project_user_hub_cubit.dart:76,120` | `P/projects/settings/user_hub/project_user_hub_modal.dart`; drzewo nie wystawia akcji | `test/workspaces/presentation/projects/user_hub/project_user_hub_cubit_test.dart` | stan bez powierzchni w drzewie — P3 |
| kolejność projektów | `PUT /projects/preferences/order` — `projects_api.dart:61` | `D/projects/repositories/projects_repository_impl.dart:236` | brak | brak | brak | kontrakt bez konsumenta — P3 |
| archiwizacja, przywracanie, usuwanie | `POST /archive`, `POST /restore`, `DELETE` — `Backend/Endpoints/Projects/ProjectEndpoints.cs:40,44,48` | `D/projects/repositories/projects_repository_impl.dart` | `P/projects/settings/general/cubit/project_general_settings_cubit.dart:91,116,141` | `P/projects/settings/general/widgets/project_danger_zone_section.dart` | brak dedykowanego testu | brak listy archiwum — P1/P3 |
| członkowie i role | `/projects/{id}/members…` — `projects_api.dart:141-231` | `D/projects/repositories/projects_repository_impl.dart` | `P/projects/settings/members/cubit/project_members_settings_cubit.dart` | `P/projects/settings/members/widgets/project_members_tab_view.dart` | `test/workspaces/data/projects/project_member_profiles_repository_test.dart` | gotowe |
| szablony projektów | `D/projects/templates/api/project_templates_api.dart:15-57` | `D/projects/templates/repositories/project_templates_repository_impl.dart` | `P/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart` | `P/projects/settings/admin/tabs/templates/project_templates_tab_view.dart` | `test/workspaces/presentation/projects/templates/project_templates_cubit_test.dart` | tworzenie projektu nie startuje z szablonu — P5 |
| szablony workflow | `D/projects/custom_workflow/api/custom_workflow_api.dart:65,74` | `D/projects/custom_workflow/repositories/custom_workflow_repository_impl.dart:64,73` | `P/tasks/settings/cubit/custom_workflow_settings_cubit.dart:45` | `P/projects/settings/workflow/widgets/project_workflow_tab_view.dart` | `test/workspaces/presentation/tasks/settings/custom_workflow_settings_cubit_test.dart` | gotowe |
| wejścia tworzenia projektu | `POST /projects/` — `projects_api.dart:49` oraz `D/standalone/project_management_gateway.dart:13` | dwa różne flow | `P/projects/dialogs/cubit/project_resource_creation_command_cubits.dart` | `P/projects/dialogs/create_project_dialog.dart`, `lib/app/shell/devplanner_shell_navigation.dart:351` | `test/workspaces/presentation/projects/dialogs/project_resource_creation_command_cubits_test.dart` | do ujednolicenia w P5 |

#### 4.3.3. Piony do domknięcia przed odbiorem

- Kontrakty bez konsumenta: `PUT /tasks/order`, `PUT /projects/preferences/order`
  i `GET /tasks/search`. Każdy wymaga decyzji: użyć w P3/P6 albo zapisać jako
  świadomie nieużywany razem z uzasadnieniem.
- Cubity bez UI: `TaskCapacitySettingsCubit`, `TaskScheduleSettingsCubit`,
  `TaskWorkflowSettingsCubit` (`P/tasks/settings/cubit/`) oraz
  `KanbanSettingsCubit` — dziś konsumują je wyłącznie testy. Pierwszeństwo
  w P6; półprodukt bez trasy pozostaje poza drzewem i nie jest reklamowany.
- Kaskada harmonogramu ma preview i apply wołane wprost z widgetu, bez cubita
  i bez testu; P6 przenosi to do stanu i pokrywa testem.
- `restore` zadania nie ma testu, a board nie wystawia archiwizacji — P6.
- Pin, hide i reorder projektów istnieją w API i stanie, ale nie w drzewie — P3.
- Dwa entrypointy tworzenia projektu — P5.

## 5. Kreator projektu

### 5.1. Wejścia

Wszystkie entrypointy (`+` w sidebarze, menu workspace, pusty stan projektów,
command palette) otwierają ten sam `ProjectCreationWizard`. Usuwamy uproszczony
`_CreateProjectFromSidebarDialog`; nie wolno utrzymywać dwóch różnych flow.

### 5.2. Kroki

1. **Sposób startu** — pusty projekt lub szablon całego projektu. Karty
   szablonów pokazują nazwę, opis, workflow, liczbę zadań, etykiet i pól.
2. **Podstawy** — nazwa, opis, ikona, kolor, status początkowy.
3. **Dostęp** — Shared/Private z opisem skutków; dla Private wybór startowych
   członków i ról. Owner tworzący jest zawsze zaznaczony i nieusuwalny.
4. **Workflow** — Standardowy albo katalog Backendowy
   (Standardowy/Marketing/Produkcja/HR/IT), ewentualnie konfiguracja kolumn,
   WIP i stanu domyślnego. Przy szablonie projektu pokazujemy snapshot i
   pozwalamy tylko na bezpieczne override’y z kontraktu.
5. **Sposób pracy** — tryb harmonogramu, domyślny widok Tasks, gęstość i pola
   kart, opcjonalne capacity; kontrolki zależą od realnego kontraktu.
6. **Funkcje startowe** — instalacja wybranych automation recipes i opcjonalne
   utworzenie struktur startowych. Funkcja bez aktywnej trasy nie może być
   domyślnie zaznaczona ani reklamowana jako gotowa.
7. **Podsumowanie** — czytelny plan: co zostanie utworzone, ilu członków,
   jakie workflow/szablon/ustawienia oraz ostrzeżenia. Dopiero tutaj `Utwórz`.

Kroki 3–6 można pominąć, ale kreator pokazuje wybrane wartości domyślne. Draft
jest lokalny i przeżywa cofanie między krokami; nie zapisuje projektu przed
finalnym potwierdzeniem.

### 5.3. Ładowanie i błędy kreatora

- Skeleton występuje tylko przy pierwszym pobraniu katalogu szablonów.
- Przejścia kroków są lokalne i bez spinnerów.
- Podgląd szablonu ma cache per `templateId`; ponowne wejście nie miga.
- Finalny przycisk natychmiast przechodzi do stanu `Tworzenie projektu…`, ale
  nie dodaje fałszywego projektu do trwałego drzewa przed odpowiedzią, jeśli
  Backend nie przydzielił ID. Po sukcesie wstawia odpowiedź i otwiera projekt.
- Błąd walidacji zostaje przy konkretnym polu. Błąd globalny pozostaje w
  podsumowaniu, nie zamyka kreatora i zachowuje draft.
- Timeout/utrata odpowiedzi po submit nie może prowadzić do duplikatu;
  ponowienie używa tego samego klucza idempotencji i sprawdza wynik operacji.

## 6. Zmiany Backendu

### 6.1. Kontrakt listy i lifecycle projektów — P0

Status: **zrealizowane w P1** (Backend, 2026-09-19).

Rozszerzyć odczyt addytywnie:

- `GET /projects?state=active|archived&visibility=visible|hidden|all`;
- `ProjectListItemResponse`: `isHidden`, `version`, `capabilities`;
- `ProjectResponse`: `version`, `capabilities`;
- stabilne kody: `project.version_conflict`, `project.archived`,
  `project.last_owner`, `project.preference_version_conflict`.

Nie przeciążać `includeHidden` kolejnymi znaczeniami. W okresie przejściowym
parametr może pozostać wspierany, ale OpenAPI oznacza go jako deprecated.

`ProjectCapabilitiesResponse` ma być jawny, np. `canManage`, `canArchive`,
`canDelete`, `canManageMembers`, `canCreateTemplate`, `canLeave`,
`canTransfer`. Flutter używa go do discoverability; Backend nadal sprawdza ACL
na każdym endpointcie i zwraca 404 dla niedostępnego zasobu.

### 6.2. Prawdziwa optimistic concurrency projektu — P0

Status: **zrealizowane w P1** (Backend, 2026-09-19); `expectedVersion` dla
`DELETE` i handlerów członkostw pozostaje otwarte.

- Udostępnić nieprzezroczystą `version` mapowaną z `xmin`.
- `PATCH`, `archive`, `restore`, preferencje i operacje destrukcyjne przyjmują
  `expectedVersion` tam, gdzie stan może się ścierać między sesjami.
- Konflikt zwraca 409 ze stabilnym kodem i aktualną reprezentacją tylko wtedy,
  gdy nie narusza ACL. Klient może wtedy wykonać rebase intencji albo pokazać
  porównanie; nie wolno ślepo powtarzać starego pełnego payloadu.
- Dla pin/hide intencją jest wartość docelowa (`isPinned=true`), nie toggle.

### 6.3. Atomowe polecenie kreatora — P0

Status: **zrealizowane w P4** (Backend, 2026-09-19).

Dodać jeden use case, nie god handler endpointu. Endpoint mapuje HTTP, a
orchestrator aplikacyjny deleguje do istniejących serwisów workflow, templates,
memberships, settings i automation.

Proponowany kontrakt:

```http
POST /api/v1/workspaces/{workspaceId}/project-setups/preview
POST /api/v1/workspaces/{workspaceId}/project-setups
Idempotency-Key: <uuid>
```

Żądanie `CreateProjectSetupRequest` zawiera:

- `source`: `Blank` albo `ProjectTemplate` + `templateId` i jego
  `expectedVersion`;
- `project`: name/description/icon/color/visibility/status;
- `memberAssignments` dla Private;
- `workflow`: default, katalogowy `workflowTemplateKey` lub jawne statusy;
- `taskView`: domyślny widok i ustawienia Kanbanu/Listy;
- `scheduleMode` i opcjonalne capacity;
- `automationRecipeKeys`.

`preview` waliduje ACL, wersję szablonu i zależności, niczego nie zapisuje oraz
zwraca znormalizowany plan i ostrzeżenia. `POST project-setups` wykonuje wszystko
w jednej transakcji PostgreSQL. Outbox/notifications zapisują się w tej samej
transakcji; efekty zewnętrzne wykonują się po commit. Porażka dowolnego kroku
nie zostawia projektu częściowego.

Idempotency jest trwałe, ograniczone do `workspaceId + userId + key`, przechowuje
hash żądania i wynik. Ten sam klucz + inne body zwraca 409. Klient może bezpiecznie
sprawdzić wynik po zerwaniu połączenia. Retencja i cleanup rekordu muszą być
jawnie ustalone.

### 6.4. Przeniesienie projektu między workspace’ami — P1, osobna decyzja

Obecny Backend tego nie obsługuje. Nie implementować jako zmianę `WorkspaceId`
ani sekwencję operacji z Fluttera. Najpierw dostarczyć:

```http
POST /api/v1/workspaces/{sourceId}/projects/{projectId}/transfer-preview
POST /api/v1/workspaces/{sourceId}/projects/{projectId}/transfer
```

Preview wylicza: uprawnienia Owner/Admin w źródle i celu, kolizje członków,
role, storage/quota, udziały publiczne, automatyzacje, portfolio, milestone,
Wiki/Whiteboard/Chat/Notifications, aktywne timery i niedostępne integracje.
Apply wymaga `expectedVersion`, `targetWorkspaceId`, decyzji mapowania członków
i jednorazowego `previewToken`; działa atomowo lub przez trwałą operację ze
stanem i kompensacją. Do czasu przejścia pełnej macierzy transferu akcja jest
ukryta, nie `disabled` bez wyjaśnienia.

Jeśli „przenoszenie” oznacza tylko kolejność w sidebarze, korzystamy z obecnego
`PUT /preferences/order` i nie budujemy transferu między workspace’ami.

### 6.5. Braki poza pierwszym wydaniem

Automatyzacje, portfolio, OKR, Wiki, Whiteboard i Corkboard mają Backend, ale
nie powinny wrócić do drzewa tylko dlatego, że endpoint istnieje. Każdy moduł
wraca osobnym pionem: route + adapter + state + ACL + błędy + testy + live
smoke. Kreator może zapisać ustawienie tylko dla funkcji rzeczywiście
osiągalnej po zakończeniu.

## 7. Standard optimistic UI i rollbacku

### 7.1. Model operacji

Każda mutacja ma obiekt `MutationIntent`:

- stabilne `operationId`;
- identyfikator zasobu i oczekiwaną wersję;
- wartość docelową, nie anonimowy toggle;
- minimalny snapshot do odwrócenia;
- funkcje `applyOptimistic`, `commit(serverDto)`, `rollback(error)`;
- informację, czy może być kolejkowana/scalana.

UI najpierw stosuje intencję lokalnie. Żądanie idzie w tle. Sukces zastępuje
stan odpowiedzią serwera (serwer jest źródłem wersji i wartości
normalizowanych). Porażka odwraca wyłącznie pola tej operacji, bez cofania
późniejszych zmian użytkownika.

### 7.2. Współbieżność

- Maksymalnie jedna mutacja per zasób/pole; kolejne intencje są serializowane
  lub scalane do ostatniej wartości docelowej.
- 409: pobrać świeży stan, nałożyć intencję na nową bazę i ponowić najwyżej raz,
  tylko gdy operacja jest bezpiecznie rebase’owalna.
- DnD: zapamiętać źródłowy indeks, kolumnę i scroll; rollback przywraca dokładne
  położenie, nie przeładowuje całego boardu.
- Bulk: wynik musi rozróżnić sukcesy i porażki. Nie cofać poprawnych elementów,
  jeśli kontrakt nie obiecuje atomowości; dla atomowego endpointu cofnąć całość.
- Realtime dla własnej operacji deduplikować po `operationId`/wersji, aby nie
  zastosować wyniku dwa razy.
- Nigdy nie ponawiać automatycznie POST/PATCH/PUT/DELETE po błędzie sieci bez
  idempotency albo dowodu, że serwer operacji nie wykonał.

### 7.3. Widoczność błędów

- błąd pola: inline przy polu;
- błąd jednej karty/wiersza: inline przy zasobie oraz w trwałym bannerze, jeśli
  wpływa na cały widok;
- błąd modułu: `TasksErrorBanner`/analogiczna powierzchnia z `Ponów`, `Odśwież`,
  `traceId` i możliwością skopiowania diagnostyki bez sekretów;
- toast/SnackBar tylko dla nietrwałego potwierdzenia, nigdy jako jedyny nośnik
  błędu;
- rollback nie może być cichy: komunikat mówi co cofnięto i dlaczego;
- 401 uruchamia istniejący single-flight refresh i maksymalnie jeden retry;
  403/404/409/422/429/5xx mają osobne komunikaty i nie są maskowane jako
  „coś poszło nie tak”.

## 8. Pakiety wykonawcze

### P0 — kontrakty charakterystyczne i baseline

- Zamrozić testami obecne trasy, drzewo, oba entrypointy tworzenia projektu i
  matrycę endpointów Backend → Front.
- Dodać testy czerwone dla: jednego węzła Zadania, archiwum, `isHidden`, wersji,
  capabilities, atomowego kreatora i rollbacku pin/reorder.
- Nie zmieniać jeszcze UI.

Gate: targeted Backend/Front tests, OpenAPI snapshot, `git diff --check`.

### P1 — backend list/lifecycle/version/capabilities

Status: **DONE po stronie Backendu (2026-09-19)**; przepisanie DTO/adapters
Frontu na nowe pola pozostaje otwarte (wpis PN-P1).

- Zrealizować §6.1–6.2 addytywnie, bez edycji historycznych migracji.
- Uzupełnić OpenAPI po polsku oraz wspólne błędy.
- Zaktualizować typed Flutter DTO/adapters i generaty.

Gate: unit + PostgreSQL HTTP dla Observer/Member/Admin/Owner, 400/401/403/404/
409, hidden/archive restore, concurrency dwóch sesji, OpenAPI.

### P2 — jeden węzeł Zadania i routing

Status: **DONE (2026-09-19)** — drzewo ma jedną pozycję `Zadania`, redirecty
legacy działają, wybór widoku jest lokalną preferencją użytkownika. Dowody
w planie głównym i handoffie (wpis PN-P2).

- Usunąć dzieci `taskList`/`kanban` z renderowanego drzewa.
- Dodać kanoniczną trasę i redirecty legacy.
- Przenieść wybór widoku do wspólnego headera i zapisać preferencję.
- Zapewnić keyboard navigation, focus, tooltipy i stan collapsed sidebar.

Gate: router, deep links, back/forward, 1024/1440/1920, text scale 200%,
klawiatura i screen reader semantics.

### P3 — menu projektu i wykorzystanie istniejących kontraktów

Status: **DONE dla drzewa projektów (2026-09-19)**; wpięcie drzewa w żywy
shell i pełna lista archiwum pozostają otwarte (wpis PN-P3).

- Pin/hide/order optimistic-first z rollbackiem.
- Widoki `Ukryte` i `Archiwum`; restore i delete według capabilities.
- Jedno menu projektu we wszystkich miejscach, bez rozbieżnych implementacji.

Gate: role matrix, reorder z błędem, multi-session 409, restart persistence.

### P4 — backend atomowego kreatora

Status: **DONE (2026-09-19)** — preview, transakcyjny setup i trwała idempotencja
z retencją; dowody w planie głównym i handoffie (wpis PN-P4).

- Zrealizować preview, setup i idempotency z §6.3.
- Użyć małych serwisów domenowych/aplikacyjnych; handler nie może zawierać
  skopiowanej logiki wszystkich modułów.
- Dodać audyt utworzenia i jeden spójny event/outbox po commit.

Gate: transakcja rollback na każdym kroku, ten sam klucz/idempotent replay,
inny payload/ten sam klucz 409, stale template 409, ACL i neutralne 404.

### P5 — frontend kreatora

Status: **DONE dla jednego entrypointu (2026-09-19)**; kroki §5 i draft
pozostają otwarte jako P5b i wymagają kontraktu P4. Dowody w planie głównym
i handoffie (wpis PN-P5).

- Jeden entrypoint i kroki z §5.
- Cache katalogów, lokalny draft, walidacja per krok, summary i retry.
- Po sukcesie uzupełnić drzewo odpowiedzią serwera i przejść do Zadania bez
  pełnego globalnego reloadu; w tle wykonać reconciliation.

Gate: widget/cubit/golden tests, błąd każdego kroku, utrata odpowiedzi po
submit, duplicate click, zamknięcie z niezapisanym draftem, accessibility.

### P6 — discoverability funkcji Tasks

Status: **częściowo DONE (2026-09-19)** — kaskada harmonogramu przeniesiona do
cubita z testami (wpis PN-P6a); pozostałe piony z §4.3.3 są otwarte.

- Pracować pionami z §4.3, maksymalnie jedna rodzina funkcji na pakiet.
- Najpierw domknąć wiersze z §4.3.3 (kaskada bez cubita i testu, brak testu
  `restore`, cubity bez UI); potem time tracking, schedule/capacity/workload.
- Każdy pion kończy się live scenariuszem z Backendem, nie samym adapterem.

### P7 — transfer projektu, tylko po decyzji produktowej

Status: **ZABLOKOWANY decyzją produktową** — plan §6.4 wymaga rozstrzygnięcia,
czy chodzi o reorder, czy o transfer cross-workspace, zanim powstanie kontrakt.

- Ustalić, czy chodzi o reorder czy cross-workspace transfer.
- Jeśli transfer: wykonać preview, apply, migrację zależności i macierz rollbacku
  z §6.4. Nie łączyć tego z P3/P5.

### P8 — odbiór całości

- Live: create blank, create from template, przerwanie/retry, pin/hide/reorder,
  archive/restore, Tasks List ↔ Kanban, DnD/bulk, restart i druga sesja.
- PostgreSQL: brak częściowych projektów i duplikatów po idempotent retry.
- Realtime: brak podwójnego zastosowania własnej mutacji.
- Screenshoty light/dark: 1024×768, 1440×900, 1920×1080.
- Web BFF i macOS desktop; Windows/Linux jawnie NOT RUN bez odpowiedniego hosta.

## 9. Wytyczne jakości dla wykonawcy

1. Najpierw czytaj aktualne DTO, endpoint i test; nie zgaduj kontraktu z nazwy.
2. Nie twórz drugiego repository/Cubita, jeśli istniejący port ma tę operację.
3. Endpoint tylko mapuje HTTP. Orkiestracja jest w Application, reguły w Domain,
   persistence/integracje w Infrastructure.
4. Plik produkcyjny powyżej ok. 350–400 linii wymaga uzasadnienia albo podziału.
5. Żadnych `catch (_) {}`. Każdy błąd jest mapowany, raportowany i testowany.
6. Żadnego `setState` dla złożonego flow kreatora; stan ma typed, testowalny
   controller/Cubit i jawne stany `editing/previewing/submitting/succeeded/failed`.
7. Teksty użytkownika wyłącznie ARB PL/EN; enum transportowy ma jawny mapper,
   nigdy `.name`.
8. Uprawnienia w UI po capabilities, lecz bezpieczeństwo wyłącznie po ACL
   Backendu. Testować IDOR dla każdego nowego odczytu/mutacji po ID.
9. Nie logować body kreatora, nazw prywatnych projektów, członków, tokenów ani
   cookies. Diagnostyka zachowuje tylko kształt, kod i `traceId`.
10. Nie edytować historycznych migracji. Nowe indeksy/tabele idempotencji są
    addytywną migracją z idempotentnym skryptem i rollbackiem.
11. Nie deklarować PASS bez faktycznego uruchomienia bramki. NOT RUN jest
    poprawnym wynikiem i musi mieć powód.
12. Po każdym pakiecie zaktualizować ten plan, główny plan i handoff w obu
    repozytoriach; kopie mają być byte-for-byte identyczne.

## 10. Definition of Done

- Sidebar ma jeden węzeł Zadania na projekt; Lista/Kanban są przełącznikiem
  jednego modułu i stare deep linki działają przez redirect.
- Pin, hide, reorder, archive, restore i dozwolone akcje projektu są osiągalne,
  korzystają z capabilities i mają optimistic rollback z trwałym błędem.
- Archiwalne i ukryte projekty da się odnaleźć oraz przywrócić bez znajomości ID.
- Każda mutacja projektu używa wersji albo udokumentowanej semantyki
  idempotentnej; 409 nie nadpisuje cudzego stanu.
- Wszystkie entrypointy tworzenia projektu otwierają jeden kreator.
- Kreator obsługuje pusty projekt i szablon, pokazuje preview, zapisuje atomowo
  i jest odporny na podwójny klik oraz utratę odpowiedzi.
- Żaden błąd zapisu nie znika w SnackBarze ani logu; rollback jest widoczny.
- Matryca §4.3 (Backend → adapter → stan → UI → test) ma aktualny stan dla
  każdej funkcji Tasks/Projects; wiersz oznaczony jako „brak UI", „brak testu"
  albo „kontrakt bez konsumenta" nie jest raportowany jako gotowa funkcja.
- `dotnet restore`, build, targeted + pełne testy, idempotentny skrypt migracji,
  `dotnet format --verify-no-changes`, `flutter analyze`, pełny `flutter test`,
  build Web/macOS, `git diff --check` i synchronizacja dokumentów przechodzą;
  pozostałe platformy mają jawny wynik PASS/FAIL/NOT RUN.

## 11. Zakazy skrótów

- Nie budować kreatora jako sekwencji `create → patch → apply template → add
  members` bez transakcyjnego endpointu.
- Nie dodawać projektu do trwałego drzewa z losowym lokalnym ID.
- Nie odświeżać całej aplikacji po każdej mutacji; reconcile tylko odpowiedni
  zasób i zachowaj stan operacyjny.
- Nie maskować 403/404/409 jako sukcesu optimistic UI.
- Nie usuwać Listy ani Kanbanu; usuwamy wyłącznie ich duplikację w nawigacji.
- Nie wystawiać transferu między workspace’ami na podstawie samego reorderu.
- Nie przywracać martwych modułów do drzewa przed pełnym pionem runtime.
