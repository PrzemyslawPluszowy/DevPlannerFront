# I2k — list view w kanonicznej trasie Tasks

## Zakres

Rozszerzono istniejącą, chronioną trasę projektu:

```text
/workspaces/:workspaceId/projects/:projectId/tasks
```

Nie dodano drugiej trasy. Wybór widoku jest wyłącznie parametrem query:

- `view=kanban` — istniejący, rzeczywisty `TasksBoardPage`;
- brak `view` albo `view=list` — `StandaloneProjectTasksList`;
- menu projektu używa listy bez query dla Tasks i `?view=kanban` dla Kanban.

## Zmienione pliki

- `lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart`
  - wybiera Board/List na podstawie `initialView`;
  - listę zasila tym samym `composition.tasksRepository`, bez nowego klienta
    HTTP i bez danych zastępczych;
  - zachowuje provider `AuthSessionPort` i pełny graf portów dla Boardu.
- `test/app/router/devplanner_root_router_compile_test.dart`
  - desktopowy test menu sprawdza oba węzły: Tasks prowadzi do kanonicznej
    ścieżki listy, Kanban do tej samej ścieżki z `view=kanban`.
- `test/workspaces/presentation/tasks/standalone_project_tasks_list_test.dart`
  - test pustej listy z typowanym repozytorium;
  - test odpowiedzi 403 z zachowaniem przycisku retry i komunikatu domenowego.

## Kontrakty i zachowanie

- Walidacja UUID workspace/project pozostaje na granicy routera.
- Desktopowa kompozycja jest jedynym źródłem `TasksRepository` dla trasy.
- BFF/web nadal nie tworzy kompozycji realtime i nie dostaje klikalnych węzłów
  Tasks/Kanban.
- Nie zmieniano implementacji Board, Files, Chat/Notifications ani Backend.
- Obsługa loading/empty/403/retry listy pozostaje w istniejącym cubicie i
  standalone presenterze; UI nie wykonuje wywołań API.

## Walidacja

```text
dart format \
  lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart \
  test/app/router/devplanner_root_router_compile_test.dart \
  test/workspaces/presentation/tasks/standalone_project_tasks_list_test.dart

flutter analyze \
  lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart \
  lib/app/router/devplanner_router.dart \
  lib/app/shell/devplanner_shell.dart \
  lib/app/shell/devplanner_shell_layout.dart \
  lib/app/shell/devplanner_shell_navigation.dart \
  test/app/router/devplanner_root_router_compile_test.dart \
  test/workspaces/presentation/tasks/standalone_project_tasks_list_test.dart
```

Analyzer: `No issues found!`.

```text
flutter test \
  test/workspaces/presentation/tasks/standalone_project_tasks_list_test.dart \
  test/app/router/devplanner_root_router_compile_test.dart
```

Wynik: wszystkie testy przeszły (`11` testów). `git diff --check` również
przeszedł bez błędów.

## Następny krok

Dodać desktopowy test widgetowy listy z kontrolowanym adapterem HTTP, jeśli
potrzebny będzie test pełnego routingu z montowaniem strony listy. Obecne testy
celowo izolują listę przez typowane repozytorium, dzięki czemu nie wykonują
żądania do lokalnego backendu.
