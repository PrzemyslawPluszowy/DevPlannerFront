# I2j — standalone fundament listy zadań

Data: 2026-09-18

## Zakres wykonany

Zamknięto mały pion odczytowy bez routera i shella:

- `StandaloneProjectTasksList` tworzy lokalny `ProjectTasksListCubit`;
- pobiera rzeczywisty `ProjectTaskGroupedListResponse` przez
  `TasksRepository.listProjectTaskGroups`;
- renderuje loading, prawdziwe grupy/wiersze, empty oraz failure;
- zachowuje typ błędu i status HTTP, więc 403 nie jest zamieniany w pusty
  sukces ani cache fallback;
- UI nie zna Dio, HTTP, auth storage ani realtime.

## Kontrakt backendu

Zweryfikowano read-only w Backend:

- `Endpoints/Tasks/ProjectTaskEndpoints.cs` publikuje
  `GET /api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/groups`;
- endpoint zwraca `ProjectTaskGroupedListResponse` z `TotalCount`, `GroupBy`
  i grupami zawierającymi `Key`, `DisplayName`, `Color`, `Position`,
  `TotalCount`, `Items`, `NextCursor`;
- `Contracts/Tasks/ProjectTaskResponse.cs` publikuje pola listy zgodne z
  frontendowym `ProjectTaskListItemResponse`, w tym lokalne `UserId` w
  assignees i brak nazw Core/Ready.

## Zmienione pliki

| Plik | Zmiana | Status |
|---|---|---|
| `lib/workspaces/presentation/tasks/list/standalone/project_tasks_list_standalone.dart` | typed, read-only composition i render boundary | PASS |
| `lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart` | foundation `ApiError`; failure zachowuje type/status/backend/api/trace | PASS |
| `lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart` | typed failure metadata oraz `isForbidden` | PASS |
| `lib/workspaces/domain/repositories/tasks_repository.dart` | domain import przeniesiony z Core do foundation | PASS |
| `test/workspaces/presentation/tasks/list/standalone_project_tasks_list_test.dart` | loading/real row/empty/403 bez sieci | PASS |

## Walidacja

- `flutter analyze` dla zamkniętego graphu: **PASS**, `No issues found!`;
- focused widget suite: **3/3 PASS**;
- scan graphu: **PASS**, zero `package:ready_next`,
  `package:devplanner/core`, `CoreUserId`, `ReadyUserId`, `ready_id` i
  `InvalidType`;
- `git diff --check`: **PASS**.

## Granice i następny krok

Nie zmieniano routera, shella, Kanbana, Files, Chat, Notifications ani
Backend. Istniejący rozbudowany `ProjectTasksList`/`TaskListTable` nadal ma
osobny zakres preferencji i mutacji; nie został udawanie podmieniony przez ten
fundament. Kolejny pakiet może podłączyć tę composition do właściwej trasy po
zamknięciu decyzji shell/router, a następnie osobno migrować tabelę, preferencje
i mutacje.
