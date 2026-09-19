# R2a completion — lokalny pion realtime Tasks

Data: 2026-09-17 (Europe/Warsaw)
Status: **PASS scoped / gotowy do review rodzica**

## Zakres

Zmigrowano wyłącznie bezpośredni graf wymagany przez adapter Tasks i jego
focused test. Nie zmieniano Chat, Notifications, BFF/web, storage,
root/router ani innych pionów Workspaces. Nie wykonano `git clean`, `restore`,
`reset`, `checkout`, commit ani push.

| Ścieżka | Przed | Po | Dowód / kontrakt | SHA-256 po zmianie | Status |
|---|---|---|---|---|---|
| `lib/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart` | `package:ready_next`; `actorCoreUserId`/`coreUserId`; helpery poza klasą | `package:devplanner`; `actorUserId`/`userId`; helpery są prywatnymi metodami statycznymi klasy | patch stagingu R01b `01a0ae57…` ord. 236; Backend DTO `Contracts/Tasks/TaskRealtimeEventResponse.cs:7-29,34-44` | `3fcf8db2ee9ed77cd71023536479e7ae5a4b4c5cc00e5bfcf67cee7ee76eb8b0` | migrated |
| `lib/workspaces/domain/models/task_project_realtime_update.dart` | importy legacy; pola `actorCoreUserId`/`coreUserId` | importy lokalne; pola `actorUserId`/`userId` | Backend `TaskRealtimeEventResponse.cs:17`, `ProjectPresenceUserResponse.cs:35-37` | `aaa8e653e7258b15bf3e39a06073ee4d5e865b71480f6690dbe0b30c7bcc1a10` | migrated |
| `lib/workspaces/domain/repositories/task_project_realtime.dart` | importy `package:ready_next` | importy `package:devplanner` | bezpośredni port adaptera | `9ebfde8b8f19ef7d704cc48e367b468d5b942d5ad38aaf0adbc036c83e105400` | migrated |
| `lib/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart` | import SignalR przez `package:ready_next`; helpery globalne | import lokalny; helpery replay/payload są metodami klas | Backend hub `Infrastructure/Tasks/TaskEventsHub.cs:16-47` — `SubscribeProject`, `GetProjectEvents`, replay cursor | `94693ae5ae941df020bfcd30d5138688e70d53a30b5a1aab6d435a488fc88548` | migrated |
| `lib/workspaces/data/realtime/signalr/workspace_signalr_client.dart` | już lokalny, bez importu Ready/Core | brak zmiany; zweryfikowany jako bezpośrednia powierzchnia transportu | testowy interfejs `WorkspaceSignalRTransport`, lokalny `package:devplanner` | `3ca98eb57430d1a7edf6837d78338ac30b360d1b850463cf6650824c87c66f94` | verified |
| `test/workspaces/data/realtime/task_project_realtime_adapter_test.dart` | fixture presence `coreUserId`; brak asercji aktora lokalnego | fixture `userId`, `actorUserId`, `correlationId`; asercje lokalnych pól | rzeczywiste pola Backend DTO | `31b325447a05dbb336c26788e2c4db3f028578904a3eb4ed8ff4de6aeecc1706` | migrated |

## Kontrakt Backend — wykorzystane dowody

- `Backend/Contracts/Tasks/TaskRealtimeEventResponse.cs:7-29` definiuje
  `ActorUserId` jako opcjonalny lokalny identyfikator aktora; nie ma pola
  `ActorCoreUserId`.
- `Backend/Contracts/Tasks/TaskRealtimeEventResponse.cs:35-37` definiuje
  `ProjectPresenceUserResponse.UserId` i `ConnectionCount`; nie ma pola
  `CoreUserId`.
- `Backend/Infrastructure/Tasks/TaskEventsHub.cs:16-47` potwierdza wywołania
  `SubscribeProject(workspaceId, projectId)` i
  `GetProjectEvents(workspaceId, projectId, cursor, limit)`.
- `Backend/Infrastructure/Tasks/TaskRealtimeConnectionManager.cs:71-79`
  grupuje obecność po lokalnym `UserId` i emituje `project.presence.changed`.

Nie dodano fallbacku `CoreUserId`, nie zmieniono nazw pól backendowego
kontraktu i nie utrzymano aliasu kompatybilności z Ready.

## Walidacja

- `dart format` dla sześciu plików: **PASS**.
- `flutter test test/workspaces/data/realtime/task_project_realtime_adapter_test.dart`: **2/2 PASS**.
- `flutter analyze` dla sześciu plików pionu: **PASS**, 0 issues.
- `git diff --check`: **PASS**.
- skan pionu:

  ```text
  package:ready_next      0
  actorCoreUserId         0
  coreUserId              0
  ```

Raport wcześniejszej blokady
`docs/recovery/R2a-task-realtime-identity-report.md` pozostaje dowodem stanu
przed dokończeniem; ten dokument ją zamyka po migracji bezpośredniego grafu.

## Ograniczenie akceptacji

To jest scoped PASS wyłącznie dla pionu adaptera Tasks. Nie oznacza migracji
pozostałego `lib/workspaces` ani gotowości całego Frontu standalone. Plan i
handoff współdzielone z Backendem nie zostały zmienione, ponieważ pakiet dotyka
wyłącznie kodu Frontu zgodnie z decyzją koordynatora.
