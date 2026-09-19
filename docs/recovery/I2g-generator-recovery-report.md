# I2g — odzyskanie generatora dla Board/Kanban

Status: **zakończone w ograniczonym grafie Board/Kanban**.

## Zakres i źródło kontraktu

Zakres obejmował wyłącznie API/model graph wymagany przez kompozycję tablicy:

- `lib/workspaces/data/kanban/api/kanban_api.dart`
- `lib/workspaces/data/projects/api/projects_api.dart`
- `lib/workspaces/data/projects/tasks/api/tasks_api.dart`
- `lib/workspaces/data/projects/tasks/api/task_advanced_api.dart`
- `lib/workspaces/data/projects/tasks/api/task_operations_api.dart`
- `lib/workspaces/data/projects/tasks/api/task_templates_api.dart`
- `lib/workspaces/data/projects/tasks/api/task_views_api.dart`
- `lib/workspaces/data/projects/tasks/api/task_capacity_api.dart`

Zależności repository zostały prześledzone od `KanbanRepositoryImpl`,
`TasksRepositoryImpl`, workflow, recurrence, collaboration, metadata,
templates, views, capacity i profili członków projektu. Wymagane modele lokalne
pozostają w `workspaces/data/kanban`, `workspaces/data/projects/tasks` oraz
`workspaces/data/projects/responses`.

Kontrakt C# został odczytany wyłącznie z Backend, bez zmian w tym repo:

- `Backend/Endpoints/Kanban/KanbanEndpoints.cs` — trasy Kanban wymagają
  `workspaceId`, `projectId` i `taskId` jako `guid`; opisują odpowiedzi boardu,
  kolumn, ustawień, move i błędy 400/401/403/404/409.
- `Backend/Endpoints/Tasks/ProjectTaskEndpoints.cs` — chronione grupy Tasks,
  task templates i task views pod `/api/v1/workspaces/{workspaceId}/projects/{projectId}`.
- `Backend/Endpoints/Tasks/TaskCapacityEndpoints.cs` — workspace capacity i
  project capacity overrides z autoryzacją oraz optimistic concurrency.
- `Backend/Contracts/Kanban/KanbanContracts.cs` — typy boardu, kart, kolumn,
  ustawień i payloadów Kanban.

Źródłem Fluttera pozostały istniejące lokalne klasy `devplanner`; nie dodano
aliasów Ready/Core, dual-read/write ani definicji `InvalidType`.

## Kontrolowana regeneracja

Uruchomiono tylko filtry build_runner dla wymaganych artefaktów:

```text
dart run build_runner build --build-filter=lib/workspaces/data/projects/tasks/api/tasks_api.g.dart
  wrote 6 outputs

dart run build_runner build \
  --build-filter=lib/workspaces/data/projects/tasks/api/task_advanced_api.g.dart \
  --build-filter=lib/workspaces/data/projects/tasks/api/task_operations_api.g.dart \
  --build-filter=lib/workspaces/data/projects/tasks/api/task_templates_api.g.dart \
  --build-filter=lib/workspaces/data/projects/tasks/api/task_views_api.g.dart \
  --build-filter=lib/workspaces/data/projects/tasks/api/task_capacity_api.g.dart
  wrote 16 outputs

dart run build_runner build --build-filter=lib/workspaces/data/projects/api/projects_api.g.dart
  wrote 13 outputs
```

Wygenerowane artefakty obejmowały odpowiednie `*.g.dart` i `*.freezed.dart`
modeli zależnych od tych API. Nie edytowano ręcznie żadnego pliku
generowanego. Importy źródłowe siedmiu API uporządkowano tak, aby lokalne
importy modeli były jawne i analizowalne.

## Wynik skanu `InvalidType`

Skan przed regeneracją wykazywał `InvalidType` w wyżej wymienionym grafie.
Po regeneracji wynik dla następujących plików wynosi zero:

- `projects_api.g.dart`
- `tasks_api.g.dart`
- `task_advanced_api.g.dart`
- `task_operations_api.g.dart`
- `task_templates_api.g.dart`
- `task_views_api.g.dart`
- `task_capacity_api.g.dart`

Skan poleceniem:

```text
rg -n "InvalidType" lib/workspaces/data/kanban \
  lib/workspaces/data/projects/api/projects_api.g.dart \
  lib/workspaces/data/projects/tasks/api/tasks_api.g.dart \
  lib/workspaces/data/projects/tasks/api/task_advanced_api.g.dart \
  lib/workspaces/data/projects/tasks/api/task_operations_api.g.dart \
  lib/workspaces/data/projects/tasks/api/task_templates_api.g.dart \
  lib/workspaces/data/projects/tasks/api/task_views_api.g.dart \
  lib/workspaces/data/projects/tasks/api/task_capacity_api.g.dart
=> PASS, brak wyników
```

Pozostały osobne rodziny `InvalidType`, wyłączone z I2g:

- access control, admin, auth;
- corkboard, notifications, OKR, whiteboard, wiki;
- project custom workflow, milestones, portfolios, templates;
- task schedule i task time tracking;
- workspace automation i workspace feature.

Nie regenerowano tych rodzin ani nie wykonywano globalnego replace.

## Bezpieczeństwo kompozycji

Dodano `lib/workspaces/data/projects/tasks/tasks_board_composition.dart`.
`TasksBoardComposition.fromTransport` tworzy pełny graf repository z jednego
`DevPlannerHttpTransport` i `WorkspaceScopedRealtimeFactory`.

- desktop z token providerem buduje kompozycję bez wywołań sieci;
- web BFF zwraca `null`, bo Flutter nie otrzymuje bearer tokenu dla SignalR;
- nie ma fallbacku, danych przykładowych ani aliasu poświadczeń.

Test: `test/workspaces/data/projects/tasks/tasks_board_composition_test.dart`.

## Walidacja

- scoped `flutter analyze` dla Kanban, wybranych Tasks API, `ProjectsApi`,
  composition i testu: **PASS, 0 issues**;
- test composition: **2/2 PASS**;
- `dart format`: **PASS**;
- `git diff --check`: **PASS**.

Nie zmieniano routera, shella, files, Chat, Notifications ani Backend.
