# Ledger warstw modalnych — 2026-09-13

## Metoda i wynik

Skan obejmuje `lib/**/*.dart` przez:

```text
showDialog / showGeneralDialog / showModalBottomSheet / OverlayEntry /
showDatePicker / showTimePicker
```

W chwili audytu wynik to **104 leksykalne punkty**: 82 `showDialog`, 1
`showGeneralDialog`, 5 `showModalBottomSheet`, 2 `OverlayEntry`, 9
`showDatePicker` i 5 `showTimePicker`. Dwa wywołania dialogów, jedno side-sheet
i jedno bottom-sheet są prawidłową implementacją centralnego `AppModalHost`, a
nie kandydatami do migracji. Po ich odjęciu pozostaje **81 bezpośrednich
systemowych route'ów**, 14 pickerów systemowych i 2 overlaye. Jest to stan
bazowy audytu; kolejne małe migracje są odnotowywane poniżej bez ponownego
nadpisywania historycznej metody skanu.

To jest ledger, nie zgoda na migrację masową: każdy wpis musi dostać regresyjny
test modułu przed zmianą.

## Klasyfikacja

| Klasa | Liczba | Kontrakt migracji | Priorytet |
| --- | ---: | --- | --- |
| System dialog / confirm / form | 74 | `AppModalHost.showDialog` albo kompatybilne `AppModalSheet.show` | P1 |
| System bottom sheet | 3 | `AppModalHost.showBottomSheet` / `AppDraggableSheet` z root scope | P0 |
| System date/time picker | 14 | osobny adapter pickerów z root navigator, focus i testem | P1 |
| Anchored popover | 1 | lokalny overlay, owner kotwicy i zamknięcie na route/resize | P1 |
| Toast transient | 1 | root transient layer poniżej aktywnej bariery; usunąć globalny singleton | P1 |

P0 dla topbara nie tworzą zwykłe `showDialog`: Flutter domyślnie używa root
navigatora. Cztery surowe bottom sheety domyślnie używają najbliższego
navigatora i w prywatnym shellu mogą mieć barierę pod topbarem/railem:

- `lib/workspaces/presentation/storage/browser/grid/storage_file_grid.dart`;
- `lib/workspaces/presentation/tasks/detail/task_details_milestone.dart`;
- `lib/features/dashboard/presentation/widgets/dashboard_collapsed_tray.dart`;
- `lib/features/dashboard/presentation/wallpaper_picker/dashboard_wallpaper_picker_sheet.dart`.

`app_search_dropdown.dart` jest anchored popoverem, nie modalem. `app_bubble_toast.dart`
używa root overlay, ale jego statyczny stan może wstawić toast nad aktywną
barierą; to nie może zostać rozwiązane przez `AppModalHost`.

## Pełny ledger systemowych route'ów

### Storage — 12 (po pakiecie 3I)

- `storage/shell/storage_shell_page.dart` — dialog nowego dokumentu;
- `storage/versions/storage_versions_dialog.dart` — dialog wersji;
- `storage/browser/storage_browser_header.dart` — 2 dialogi;
- `storage/browser/list/storage_file_rows.dart` — dialog;
- `storage/browser/shared/storage_folder_actions_menu.dart` — 2 dialogi;
- `storage/browser/shared/storage_file_context_menu.dart` — dialog;
- `storage/browser/selection/storage_selection_toolbar.dart` — confirm;
- `storage/browser/selection/storage_keyboard_shortcuts.dart` — dialog;
- `storage/office/widgets/storage_office_editor_dialog.dart` — 2 dialogi.

### Tasks — 25

- `tasks/board/tasks_board_header.dart`,
  `tasks/board/tasks_board_template_picker.dart`,
  `tasks/board/tasks_board_template_picker_actions.dart` (łącznie 4);
- `tasks/detail/task_details_acceptance.dart`, `attachments.dart`,
  `custom_fields.dart`, `dependencies.dart` (2), `description.dart`,
  `header.dart`, `history.dart`, `labels.dart`, `milestone.dart` (P0 bottom
  sheet), `properties.dart` (2), `recurrence.dart`, `subtasks.dart`,
  `templates.dart`, `time_tracking.dart` (łącznie 16);
- `tasks/list/menu/pickers/task_duration_picker.dart`,
  `task_type_picker.dart`, `tasks/list/preferences/widgets/task_list_columns_sheet.dart`
  (łącznie 3);
- `tasks/views/widgets/task_saved_view_editor_dialog.dart` i
  `task_saved_view_name_dialog.dart` (2).

### Projects — 26

- `projects/dialogs/project_resource_creation_dialogs.dart` (6);
- `projects/settings/admin/tabs/templates/project_templates_tab_view.dart` (5);
- `projects/settings/custom_fields/widgets/project_custom_fields_tab_view.dart` (1);
- `projects/settings/general/widgets/project_danger_zone_section.dart` (2);
- `projects/settings/labels/widgets/project_labels_tab_view.dart` (3);
- `projects/settings/members/widgets/project_members_tab_view.dart` (2) oraz
  `project_members_table.dart` (1);
- `projects/settings/milestones/widgets/project_milestones_tab_view.dart` (1);
- `projects/settings/project_settings_modal.dart` (1);
- `projects/settings/user_hub/project_user_hub_modal.dart` (1) oraz
  `widgets/project_user_profile_tab_view.dart` (1);
- `projects/settings/workflow/widgets/project_workflow_tab_view.dart` (2).

### Workspaces, private i moduły pozostałe — 14

- `workspaces_home/manage_workspace/create_workspace_dialog.dart` i
  `edit_workspace_dialog.dart` (2);
- `workspaces_settings/workspace_settings_modal.dart`,
  `members/widgets/workspace_members_tab_view.dart`,
  `members/widgets/workspace_members_table.dart`,
  `general/widgets/workspace_danger_zone_section.dart` (4);
- `private/private_pages.dart` (1);
- `features/inventory/presentation/inventory_home_page.dart` oraz
  `.../create_arkusz/create_arkusz_modal.dart` (2);
- `features/bhp/.../position_standard_editor_modal.dart` (1);
- `features/dashboard/.../weather_detailed_forecast_modal.dart`,
  `weather_location_picker_sheet.dart`, `dashboard_collapsed_tray.dart`,
  `wallpaper_picker/dashboard_wallpaper_picker_sheet.dart` (4);

## Pełny ledger pickerów

- `workspaces/presentation/private/my_tasks_filters_dialog.dart` — data;
- `workspaces/presentation/storage/sharing/widgets/storage_public_link_form.dart`
  — data;
- `workspaces/presentation/projects/settings/milestones/widgets/project_milestone_editor_dialog.dart`
  — data;
- `workspaces/presentation/tasks/board/tasks_board_header.dart` — data;
- `workspaces/presentation/tasks/detail/task_details_custom_fields_editor.dart`
  i `task_details_shared.dart` — data;
- `workspaces/presentation/tasks/recurrence/task_recurrence_context_editor.dart`
  — data i czas;
- `workspaces/presentation/tasks/views/widgets/sections/task_saved_view_date_range_filter.dart`
  — 2 daty;
- `features/inventory/.../inventory_detail_modal.dart` — 2 czasy;
- `features/inventory/.../arkusz_detail_modal_management.part.dart` — 2 czasy.

## Pełny ledger overlayów

- `lib/shared/presentation/widgets/app_search_dropdown.dart` — anchored popover;
- `lib/shared/presentation/widgets/app_bubble_toast.dart` — toast na root overlay.

## Stan migracji

Fundament centralnego hosta, `AppModalSheet`, `AppExpandableSideSheet`,
`AppDraggableSheet`, confirm i globalne wejścia Chat/Notifications są już
zmigrowane w wcześniejszych pakietach. Pakiet 3G migruje wyłącznie dialog
`StorageSharingDialog`; pakiet 3I migruje preview dialog `StorageFileGrid`.
Context menu bottom sheet tej siatki zostało przeniesione wcześniej przy
korekcie 3H. Pozostałe 12 route'ów Storage i jego date picker pozostają
świadomie poza tym małym slice'em.

## Korekta 3J — stan bieżącego skanu

Ponowny skan `lib/**/*.dart` wykazał **0** bezpośrednich wywołań
`showDialog`/`showModalBottomSheet`/`showGeneralDialog` poza centralnym hostem.
`StorageOfficeEditorDialog.show` korzysta teraz z `AppModalHost.showDialog`
z root policy i niedomykalną barierą.

Pozostały wyłącznie 14 systemowych pickerów daty/czasu: `my_tasks_filters_dialog`,
`storage_public_link_form`, `project_milestone_editor_dialog`,
`task_saved_view_date_range_filter` (2), `task_details_shared`,
`tasks_board_header`, `task_recurrence_context_editor` (2),
`task_details_custom_fields_editor`, `inventory_detail_modal` (2) oraz
`arkusz_detail_modal_management` (2). Są też 2 `OverlayEntry`:
`app_search_dropdown` (anchored popover) i `app_bubble_toast` (root toast).
Historyczne liczby route'ów wyżej są stanem bazowym, nie listą pozostałych
migracji.

## Pakiet 3K-A — pierwsza mała migracja pickerów

`AppModalPickerHost.showDate` obsługuje teraz cztery istniejące wywołania,
zawsze przez rootowy navigator. Nie zmieniono granic ani wartości początkowych
wyboru daty:

- `workspaces/presentation/private/my_tasks_filters_dialog.dart`;
- `workspaces/presentation/storage/sharing/widgets/storage_public_link_form.dart`;
- `workspaces/presentation/projects/settings/milestones/widgets/project_milestone_editor_dialog.dart`;
- `workspaces/presentation/tasks/board/tasks_board_header.dart`.

Test `test/app/shell/overlay/app_modal_picker_host_test.dart` tworzy zagnieżdżony
navigator i potwierdza, że route pickerów daty i czasu trafia wyłącznie do
navigatora rootowego; wariant czasu sprawdza też `Locale('pl')` i custom
builder. Skan `rg -n "showDatePicker\\(|showTimePicker\\(" lib --glob '*.dart'
-g '!app_modal_picker_host.dart'` wykazuje dokładnie **10 surowych pickerów**
w sześciu plikach: `task_saved_view_date_range_filter.dart` (2),
`task_details_shared.dart` (1), `task_recurrence_context_editor.dart` (2),
`task_details_custom_fields_editor.dart` (1), `inventory_detail_modal.dart`
(2) i `arkusz_detail_modal_management.part.dart` (2). Dwa wywołania wewnątrz
samego adaptera nie są kandydatami do migracji.

## Korekta 3K-D — zamknięcie migracji pickerów

Aktualny skan `rg -n "showDatePicker\\(|showTimePicker\\(" lib --glob '*.dart'
-g '!app_modal_picker_host.dart'` zwraca **0 surowych wywołań**. Jedyne dwa
systemowe wywołania są centralnie zamknięte w
`lib/app/shell/overlay/app_modal_picker_host.dart`: `showDatePicker` i
`showTimePicker`, oba z jawną polityką rootowego navigatora.

`test/app/shell/overlay/app_modal_picker_host_test.dart` pokrywa oba typy
pickera z kontekstu zagnieżdżonego navigatora. Weryfikuje route na navigatorze
rootowym, a dla czasu dodatkowo `Locale('pl')` oraz custom builder. Adapter
zachowuje parametry daty/czasu, locale i builder; ponieważ bieżący Flutter SDK
nie przyjmuje locale bezpośrednio w `showTimePicker`, adapter stosuje
`Localizations.override` bez zmiany publicznego API.

Poza pickerami pozostają dokładnie dwa świadome `OverlayEntry`, o odrębnych
kontraktach:

- `lib/shared/presentation/widgets/app_search_dropdown.dart` — anchored
  popover, którego ownerem jest kotwica; musi się zamykać przy zmianie route'u
  lub rozmiaru;
- `lib/shared/presentation/widgets/app_bubble_toast.dart` — transient root
  toast, który musi pozostać poniżej aktywnej bariery modalnej i nie może
  odzyskać globalnego lifecycle'u.

## Pakiet 3L — zamknięcie overlayów z ledgeru

Aktualny skan `rg -n "showDialog\\(|showGeneralDialog\\(|showModalBottomSheet\\(|OverlayEntry" lib --glob '*.dart'`
zwraca wyłącznie dwa `OverlayEntry`, oba jako jawni ownerzy kontraktów
prezentacyjnych: `app_search_dropdown.dart` i `app_bubble_toast.dart`. Nie ma
pozostałych surowych overlayów ani systemowych route'ów poza centralnymi
adapterami.

- `AppSearchDropdown` zostaje w najbliższym overlayu kotwicy, więc nie wychodzi
  ponad chrome private shella. `AppOverlayRouteLifecycle`, należący do
  `AppGlobalShell`, zamyka go przy zmianie trasy; `WidgetsBindingObserver`
  zamyka go przy resize, a dispose i kontrola `RenderBox` usuwają wpis po
  utracie kotwicy.
- `AppBubbleToastController` jest sesyjnym ownerem tworzonym przez
  `AppGlobalShell` i przekazywanym przez `AppBubbleToastScope`. Kompatybilna
  fasada `AppBubbleToast.show` nie ma żadnego statycznego stanu. Controller
  usuwa istniejący toast na wejściu bariery modalnej i odkłada nowe żądania w
  kolejce FIFO do chwili `AppModalCoordinator.release`; następny toast pojawia
  się dopiero po zamknięciu poprzedniego. Root toast nie może więc renderować
  nad aktywnym modalem.
- `AppModalHost` przekazuje oba prezentacyjne ownery również do rootowego
  buildera modala. Callbacky `AppGlobalShell`, w tym changelog, otrzymują
  kontekst spod scope'ów, a nie context sprzed root navigatora; toast wywołany
  z formularza modala zachowuje zatem ten sam kontrakt bariery.

Walidacja 3L:

- `flutter test test/shared/presentation/widgets/app_search_dropdown_test.dart test/shared/presentation/widgets/app_bubble_toast_test.dart` — 5 sukcesów;
- `flutter test test/app/shell/overlay/app_modal_host_test.dart test/app/shell/overlay/app_modal_router_test.dart test/app/shell/overlay/app_global_shell_modal_integration_test.dart` — 15 sukcesów;
- scoped `flutter analyze` plików ownerów, hosta i testów — bez diagnostyk;
- pełne `flutter analyze` — 4 istniejące informacje poza 3L, wyłącznie w
  `notification_reply_modal.dart` i jego testach (directive ordering,
  redundant argument, braces i `const`); brak błędów lub ostrzeżeń 3L;
- `git diff --check` — sukces.
