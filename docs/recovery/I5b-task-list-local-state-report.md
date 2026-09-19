# I5b — lokalny stan UI listy zadań

Data: 2026-09-18

## Cel i zakres

Pakiet usuwa jawne `setState` oraz `StatefulBuilder` wyłącznie z
`lib/workspaces/presentation/tasks/list/**`. Nie zmienia kontraktów API,
modeli, domenowych Cubitów, routingu, board/detail, Chat, Notifications ani
Backendu.

## Zmiany

- Krótkotrwały stan tworzenia zadania, tworzenia podzadania, hoverów,
  zaznaczania etykiet, checklisty, daty, wyboru osób, arkusza kolumn i tabeli
  jest własnością prywatnych `ValueNotifier`ów. Każdy notifier ma jawny
  `dispose`.
- `ValueListenableBuilder` lub `AnimatedBuilder` przebudowuje wyłącznie
  kontrolkę zależną od lokalnego stanu. Stan biznesowy nadal pochodzi z
  `ProjectTasksListCubit` i `TaskListPreferencesCubit`.
- `TaskListTable` zachowuje istniejące lokalne kolekcje/sterowanie tabelą, ale
  powiadamia widok przez prywatną rewizję `ValueNotifier`, zamiast przez
  `State.setState`.
- Picker czasu nie używa już `StatefulBuilder`; suma minut jest utrzymywana w
  lokalnym `ValueNotifier`.

Zmodyfikowane pliki:

- `standalone/project_tasks_list_standalone.dart`
- `table/task_list_table.dart`
- `table/task_list_subtasks.dart`
- `cells/empty/task_cell_empty_placeholder.dart`
- `cells/task_cell_labels.dart`
- `cells/task_checklist_popover.dart`
- `cells/task_checklist_item_tile.dart`
- `cells/task_checklist_ui_state.dart`
- `menu/pickers/task_date_picker.dart`
- `menu/pickers/task_assignee_picker.dart`
- `menu/pickers/task_assignee_search_menu.dart`
- `menu/pickers/task_duration_picker.dart`
- `preferences/widgets/components/task_column_pool_chip.dart`
- `preferences/widgets/task_list_columns_sheet.dart`

Po dalszym podziale limit 400 linii jest spełniony przez każdy plik Dart w
`tasks/list/**`. Największe wcześniej pliki zostały rozdzielone na małe,
nazwane odpowiedzialności:

- `task_cell_title.dart`: `TaskCellKey` i akcje hovera są osobnymi
  komponentami; akcje dostają jawne callbacki, więc nie tworzą cyklicznego
  importu;
- `task_duration_picker.dart`: formatowanie i wyliczanie bezpiecznej pozycji
  okna są odrębnymi klasami;
- `task_list_columns_sheet.dart`: zakres, nagłówek, pula kolumn, sekcje i
  akcje stopki są rozdzielone bez `part` files;
- `TaskListPreferencesCubit`: odczyt konfiguracji, polityka projektu i wybór
  kolejnego sortowania należą do odrębnych klas. Cubit nadal jest jedyną
  właścicielską granicą stanu biznesowego listy.

## Walidacja

Wykonano w katalogu `Front`:

```bash
dart format lib/workspaces/presentation/tasks/list
flutter analyze lib/workspaces/presentation/tasks/list --no-fatal-infos
flutter test test/workspaces/presentation/tasks/list --reporter compact
rg -n 'setState\\s*\\(' lib/workspaces/presentation/tasks/list
rg -n 'StatefulBuilder|setDialogState' lib/workspaces/presentation/tasks/list
git diff --check
```

Wyniki:

- scoped analyzer: `No issues found!`;
- testy listy: `120/120` PASS;
- oba skany lokalnego `setState` / `StatefulBuilder`: brak wyników;
- `git diff --check`: PASS.

## Dalszy podział odpowiedzialności

W czasie review pakietu rozdzielono także dwa konkretne pliki ponad limit:

- `task_checklist_popover.dart`: 497 -> 377 linii; niezależny wiersz checklisty
  i immutable local UI state mają własne nazwane pliki;
- `task_assignee_picker.dart`: 446 -> 152 linie; wyszukiwanie, debounce i
  stronicowanie osób są własnością `TaskAssigneeSearchMenu` (339 linii).

Po tym podziale scoped analyzer nadal kończy się PASS, a pełna suite listy
pozostaje **120/120 PASS**.

## Granice

Pakiet nie przenosi logiki domenowej ani nie zmienia zachowania listy,
Kanbanu, szczegółów zadania, kontraktów backendu ani importerów poza katalogiem
listy. Nie dodaje żadnego wywołania HTTP do UI, nowego globalnego helpera,
`part` file ani mixinu maskującego odpowiedzialność klasy. Wcześniejsze
historyczne pliki `part` poza przebudowanymi elementami nie były rozszerzane.
