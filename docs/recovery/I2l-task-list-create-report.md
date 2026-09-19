# I2l — tworzenie zadania z listy

Status: **zrealizowane w wąskim pionie create-task**.

## Zakres

Dodano desktopową kontrolkę tworzenia zadania głównego do standalone listy
Tasks. Zakres nie obejmuje routingu, shella, edycji, usuwania, sortowania,
szczegółów, Kanbana, Files, Chat ani Notifications.

## Kontrakt źródłowy

Backend został tylko odczytany. Źródło kontraktu:

- `../Backend/Endpoints/Tasks/ProjectTaskEndpoints.cs` — `POST /api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/quick-create`, wymagane uwierzytelnienie, odpowiedzi 201/400/401/403/404/409;
- `../Backend/Application/Tasks/Handlers/QuickCreateProjectTaskHandler.cs` — tytuł jest trimowany, wymagany i ograniczony do 240 znaków; odpowiedź zawiera pełną projekcję zadania;
- `lib/workspaces/domain/repositories/tasks_repository.dart` — typowany `quickCreateTask` zwracający `Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>`.

Nie dodano pól ani ścieżek poza potwierdzonym kontraktem.

## Zmiany

- `lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart`
  - dodano typowany `ProjectTaskCreationResult`;
  - Cubit odrzuca pusty tytuł i równoległe drugie wysłanie;
  - wywołuje istniejący `TasksRepository.quickCreateTask`;
  - po potwierdzonym sukcesie scala zwróconą projekcję do bieżącego snapshotu;
  - po błędzie API nie udaje sukcesu i nie odświeża/nie zmienia listy;
  - zachowano dotychczasowe `createRootTask` jako kompatybilną fasadę bool.
- `lib/workspaces/presentation/tasks/list/standalone/project_tasks_list_standalone.dart`
  - dodano lokalny pasek tworzenia z `TextField`, Enter, przyciskiem i stanem in-flight;
  - UI nie wykonuje HTTP ani nie mapuje transportu; korzysta z Cubita i typed `ApiError`;
  - 403/409/422 oraz walidacja lokalna są mapowane przez `context.l10n`;
  - przycisk i pole są blokowane podczas trwającego zapisu.
- `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb` oraz wygenerowane lokalizacje — dodano komunikaty walidacji, 403, 409 i stanu duplicate/unavailable.
- `test/workspaces/presentation/tasks/list/standalone_project_tasks_list_test.dart` — testy pustego tytułu, potwierdzonego utworzenia z blokadą duplicate submit oraz mapowania 403/409/422.
- `test/workspaces/presentation/tasks/list/project_tasks_list_cubit_test.dart` — test używa kanonicznego importu `foundation/error/api_error.dart`.

## Walidacja

- `flutter gen-l10n` — PASS;
- scoped `flutter analyze` dla Cubita, standalone widgetu i obu testów — PASS, `No issues found!`;
- focused `flutter test` dla standalone listy i istniejącej suite Cubita — PASS, `59/59`;
- bezpośredni skan zamkniętego pionu listy po `package:ready_next`, `package:devplanner/core`, `CoreUserId`, `coreUserId`, `ReadyUserId`, `readyUserId`, `ready_id`, `InvalidType` — 0 wyników;
- `git diff --check` — PASS.

Pełny `flutter analyze`, buildy platformowe i E2E nie były uruchamiane w tym
wąskim pakiecie.

## Następny krok

Po review można podłączyć tę kompozycję do docelowego ekranu `/workspaces` bez
zmiany jej kontraktu. Edit/delete/reorder/details powinny pozostać osobnymi
pionami.
