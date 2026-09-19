# I5a — lokalny stan i rozdzielenie odpowiedzialności Kanbana

Data: 2026-09-18

## Cel pakietu

Pakiet usuwa `setState` z całego katalogu
`lib/workspaces/presentation/tasks/board/**` oraz rozdziela rzeczywisty
„god Cubit” Kanbana, bez zmiany publicznego API `TasksBoardCubit`, routingu,
modeli, kontraktów transportowych lub logiki UI poza board.

## Zmiany lokalnego stanu UI

Każdy krótko żyjący stan kontrolki jest teraz prywatnym `ValueNotifier` z
`ValueListenableBuilder` i jawnym `dispose`:

- `_TasksProjectViewHostState`: wybrany widok, cache listy i rewizja ustawień;
- `_QuickCreateTaskState`: tryb edycji, wysyłanie i wybór formatki;
- `_TaskQuickCreateDialogState`: kolumna, wysyłanie i formatka;
- `_TaskTemplatePickerListState`: identyfikator stosowanej formatki;
- `_TaskTemplateEditorState`: lokalna rewizja renderowania formularza;
- `_AssigneePickerSectionState`: filtr wyszukiwania wykonawców.

Nie ma `setState` ani globalnego mutowalnego stanu. Pozostałe w tym katalogu
top-level helpers zostały przeniesione do nazwanych klas (`TaskBoardColorParser`,
`TaskBoardAvatarPalette`, `TaskBoardColumnIdentity`,
`TaskBoardTimelineActions`, `TaskBoardWorkloadActions` i
`TaskTemplatePickerOverlay`). Asynchroniczne operacje tworzenia, formatki i
mutacji nadal trafiają do istniejących Cubitów oraz repozytoriów.

## Podział Cubitu

`TasksBoardCubit` jest cienką fasadą publicznego API i jedynym właścicielem
emisji `TasksBoardState`. Implementacja została rozdzielona na zwykłe,
nazwane klasy (bez mixinów i bez `part` jako ukrycia jednego Cubitu):

- `TasksBoardRuntimeCoordinator` — snapshot, lifecycle realtime, presence,
  workflow, katalog członków i deduplikacja zdarzeń;
- `TasksBoardCardCommands` — mutacje pojedynczej karty oraz cykliczność;
- `TasksBoardPreferenceCommands` — preferencje użytkownika, paginacja kolumn,
  quick create i stosowanie formatki;
- `TasksBoardBulkCommands` — zaznaczenie, operacje masowe, optimistic DnD i
  rollback;
- `TasksBoardCardStateMutator` — deterministyczna zamiana karty w snapshotcie;
- `TasksBoardCommandContext` — mały port emisji stanu, identyfikatorów oraz
  odświeżenia, bez zależności od UI.

Paginacja zachowuje licznik rewizji odczytu tablicy. Spóźniona odpowiedź
`loadMore` po odświeżeniu snapshotu jest nadal odrzucana.

Rozdzielenie Cubitu nie używa `part` ani mixinów. Cały katalog board nie ma już
pliku źródłowego przekraczającego 400 linii: najdłuższy
`tasks_board_page.dart` ma 380 linii.

## Podział ekranów i plików UI

Rozbicie nie ukrywa odpowiedzialności w kolejnych `part`:

- `tasks_project_view.dart` — publiczny enum widoku i host lokalnego stanu
  (`ValueNotifier`), przy zachowaniu eksportu `TasksProjectView` z poprzedniej
  biblioteki dla testów i importerów;
- `tasks_board_list_content.dart` — izolowany widok tabeli List;
- `tasks_board_columns_viewport.dart` — poziomy viewport, scroll i skróty
  kolumn;
- `tasks_board_drop_targets.dart` — drobne, samodzielne targety DnD;
- `tasks_board_template_choice_button.dart` — przycisk wyboru formatki quick
  create;
- `templates/cubit/task_template_picker_state.dart` — stan i wyniki Cubitu
  formatki, oddzielone od wykonawcy poleceń;
- `tasks_project_view_preferences.dart` — per-projektowy adapter preferencji;
- `task_board_date_formatter.dart` — formatter dat jako klasa, nie funkcja
  globalna.

## Pliki pakietu

- `lib/workspaces/presentation/tasks/board/tasks_board_page.dart`
- `lib/workspaces/presentation/tasks/board/tasks_project_view.dart`
- `lib/workspaces/presentation/tasks/board/tasks_project_view_preferences.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_list_content.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_drop_targets.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_template_choice_button.dart`
- `lib/workspaces/presentation/tasks/board/task_board_date_formatter.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_quick_create.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_header_quick_create_dialog.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_template_picker.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_template_picker_content.dart`
- `lib/workspaces/presentation/tasks/board/template_actions/template_editor_state.dart`
- `lib/workspaces/presentation/tasks/board/template_actions/template_editor_sections.dart`
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart`
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_command_context.dart`
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_runtime_coordinator.dart`
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_card_commands.dart`
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_preference_commands.dart`
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_bulk_commands.dart`
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_card_state_mutator.dart`
- `lib/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_state.dart`

## Dowody

Wykonano w katalogu `Front`:

```bash
dart format lib/workspaces/presentation/tasks/board/cubit
dart format lib/workspaces/presentation/tasks/board
flutter analyze lib/workspaces/presentation/tasks/board
flutter test test/workspaces/presentation/tasks/board --reporter compact
flutter test test/workspaces/presentation/tasks/tasks_board_cubit_test.dart \
  test/workspaces/data/projects/tasks/tasks_board_composition_test.dart \
  --reporter compact
rg -n "setState" lib/workspaces/presentation/tasks/board
find lib/workspaces/presentation/tasks/board -name '*.dart' -print0 | \
  xargs -0 wc -l | awk '$1 > 400 { print }'
git diff --check
```

Wyniki:

- scoped analyzer: `No issues found!`;
- suite board: **85/85 PASS**;
- dodatkowa suite Cubit/composition: **26/26 PASS**;
- `rg setState`: brak wyników;
- kontrola długości plików: brak plików `>400` linii;
- `git diff --check`: PASS.

## Otwarte granice

Pakiet nie integruje Chat/Notifications, nie zmienia backendu ani nie jest
dowodem desktopowego E2E z prawdziwym backendem. Zachowane starsze pliki
`part` służą wyłącznie kompozycji istniejącej biblioteki widgetów; rozdzielenie
Cubitu i nowe wyodrębnione odpowiedzialności używają zwykłych bibliotek Dart,
bez `part` i bez mixinów.
