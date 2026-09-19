# I2i — status testu widgetowego Board

Data: 2026-09-18

## Zakres

Pakiet domknięty w ograniczonym zakresie izolowanego testu widgetowego
`TasksBoardRoutePage`. Nie zmieniano routera, shella, kontraktów backendu ani
Files.

## Zachowane zmiany

| Ścieżka | Stan | Uwagi |
|---|---|---|
| `lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart` | istniejąca, nie zmieniana w tym pakiecie | route page wystawia typed composition i lokalną sesję auth |
| `lib/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart` | zaakceptowana seam testowa | `WorkspaceScopedRealtimeFactory` jest rozszerzalna dla nietransportowego fake hubu; komentarz dokumentuje cel DI testów |
| `test/workspaces/presentation/tasks/board/tasks_board_route_page_test.dart` | PASS | explicit mock repositories, local `AuthSessionController`, fake SignalR transport, loading/empty/403 boundaries |
| `pubspec.yaml` / `pubspec.lock` | zaakceptowana zależność testowa | `shared_preferences_platform_interface` dostarcza in-memory platformę dla `SharedPreferencesAsync` |

## Dowody

- Test widgetowy: **3/3 PASS** — loading, empty board z przekazaniem
  `workspaceId`/`projectId` oraz forbidden boundary 403 bez żądania sieciowego.
- Scoped `flutter analyze` dla route page, realtime seam i testu: **PASS**,
  `No issues found!`.
- Scoped scan runtime/test: **PASS**, zero `package:ready_next`,
  `package:devplanner/core`, `CoreUserId`, `ReadyUserId` i ich camelCase
  wariantów.
- `git diff --check`: PASS.

## Granice

To jest dowód kompozycji i boundary UI bez sieci, a nie pełne E2E backendu,
SignalR ani akceptacja routera/shella. Nie wykonano commit/push.
