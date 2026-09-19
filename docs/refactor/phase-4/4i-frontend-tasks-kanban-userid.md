# Faza 4I — frontend Tasks/Kanban lokalny `UserId`

**Status: implementation slice complete — 2026-09-17 (Front only).**

Ten pakiet przenosi aktywny pion Tasks/Kanban na kontrakt backendu 4D. Wszystkie
identyfikatory osób w warstwie data/domain/presentation są lokalnymi UUID-ami
`userId`; nie zachowano nazw Core/Ready, aliasów ani dual parsing.

## Kontrakt

- Query listy zadań i kolumn Kanban używają `assigneeUserId`.
- Payloady wykonawców, szablonów, widoków, współpracy i bulk używają
  `userIds`/`assigneeUserIds` zgodnie z OpenAPI backendu.
- Odpowiedzi używają `primaryAssigneeUserId`, `createdByUserId`,
  `completedByUserId`, `acceptedByUserId`, `reviewedByUserId`, `userId` oraz
  `userIds`.
- Preferencje listy/Kanbanu, capacity/workload, historia, watchers, presence,
  realtime i profile członków projektu nie wykonują mapowania legacy.
- Nazwy JSON są generowane z kanonicznych pól Dart; nie dodano `JsonKey` z
  dawną nazwą, fallbacku ani odczytu alternatywnego.

## Zmienione elementy

- `lib/workspaces/data/projects/tasks/models/` — modele zadań, capacity,
  historii, widoków, szablonów i harmonogramów oraz generated Freezed/JSON.
- `lib/workspaces/data/kanban/models/` — karty, preferencje i payloady Kanban
  oraz generated Freezed/JSON.
- `lib/workspaces/data/projects/tasks/api/` i
  `lib/workspaces/data/kanban/api/` — typowane parametry query/payloadów oraz
  wygenerowane Retrofit clients.
- `lib/workspaces/data/projects/tasks/repositories/`,
  `lib/workspaces/data/kanban/repositories/` i realtime — przekazywanie
  kanonicznych identyfikatorów bez aliasów.
- `lib/workspaces/domain/models/project_member_profile.dart`,
  `task_project_realtime_update.dart` oraz repozytoria — lokalny `userId` dla
  profili, presence i zdarzeń Tasks.
- `lib/workspaces/presentation/tasks/` — board, lista, szczegóły, assignee
  picker, capacity/workload, templates, saved views, watchers, history i
  wszystkie bezpośrednio wymagane komponenty UI.
- `lib/workspaces/data/projects/responses/project_member_profile_response.dart`
  — profil członka projektu mapowany bezpośrednio z `userId`.

## Walidacja

- `dart run build_runner build --delete-conflicting-outputs` — PASS; generator
  zakończył pracę i zapisał 182 outputs. Toolchain zgłosił wyłącznie istniejące
  ostrzeżenie o constraint `json_annotation`.
- `flutter analyze` dla 11 ścieżek pakietu — PASS, `No issues found!`.
- Targeted suite — **116/116 PASS**:
  `kanban_models_test.dart`, `task_models_contract_test.dart`,
  `project_member_profiles_repository_test.dart`,
  `task_project_realtime_adapter_test.dart`, `tasks_board_cubit_test.dart`,
  `project_tasks_list_cubit_test.dart`, `task_details_cubit_test.dart`,
  `task_template_picker_cubit_test.dart`.
- `git diff --check` — PASS.
- Search w pełnym zakresie pakietu nie znajduje `CoreUserId`, `coreUserId`,
  `ReadyUserId`, `readyUserId` ani `ready_id`.

## Poza zakresem

Nie zmieniano katalogu workspace, zaproszeń/członkostw workspace, Storage,
Wiki, Whiteboard, OKR, Chat/Notifications, Auth ani common docs. Pozostałe
legacy nazwy w tych domenach wymagają odrębnych pakietów.

## Następny krok

Wykonać review pozostałych domen frontendowych i dopiero po ich migracji uruchomić
końcowy integracyjny audit Front + Backend. Nie przywracać aliasów, fallbacków
ani połączeń Ready/Core/DataBus.
