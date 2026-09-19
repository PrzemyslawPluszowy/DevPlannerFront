# R2a — adapter realtime Tasks: migracja importów i audyt identity

Data audytu: 2026-09-17 21:07 (Europe/Warsaw)
Status: **PARTIAL / BLOCKED BY DTO MODEL MISMATCH — NOT READY FOR ACCEPTANCE**

## Zakres i ograniczenia

Pakiet obejmował wyłącznie aktywny adapter Tasks oraz jego bezpośredni test:

| Ścieżka | Wcześniej | Teraz | Źródło decyzji | SHA-256 teraz | Status | Zależności |
|---|---|---|---|---|---|---|
| `lib/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart` | importy `package:ready_next`; helpery jako funkcje poza klasą; odczyt `actorCoreUserId`/`coreUserId` | importy `package:devplanner`; helpery przeniesione do prywatnych metod statycznych klasy; stare pola identity pozostają jawnie zablokowane do czasu migracji modelu | `docs/recovery/R01b-partial-recovery-report.md`; patch Codex `01a0ae57…`, ord. 236, 2026-09-17 07:54:21Z; backend DTO poniżej | `193aa0f7f67556c89018146b7f1bb3658d00d123654147a446ed00539211100e` | partial | lokalne `workspace_scoped_realtime_service.dart`, `workspace_signalr_client.dart`, model i port nadal mają importy legacy |
| `test/workspaces/data/realtime/task_project_realtime_adapter_test.dart` | importy `package:ready_next`; fixture presence używa legacy `coreUserId` | importy `package:devplanner`; test pozostawiony bez fałszywej asercji identity, bo aktywny model nie ma lokalnych pól | bezpośredni test adaptera; backend contract map | `93fe575c984487eccdc3a607fe01ac58a50e51b8292a48cb5d17459d450e59ec` | partial | test nie ładuje się dopóki bezpośredni graf modeli/usług nie zostanie zmigrowany |

Nie wykonano zmian w routerze, globalnym chacie, powiadomieniach, kliencie SignalR,
BFF, strukturze katalogów ani w innych rodzinach realtime. Nie wykonano
`git clean`, `restore`, `reset`, `checkout`, commit ani push.

## Potwierdzony kontrakt Backend

Źródła:

- `Backend/Contracts/Tasks/TaskRealtimeEventResponse.cs:7-29` — event zawiera
  `ActorUserId`, nie `ActorCoreUserId`; identyfikatory workspace/project/task są
  lokalnymi UUID.
- `Backend/Contracts/Tasks/TaskRealtimeEventResponse.cs:34-44` — presence
  zawiera `UserId` i `ConnectionCount`.
- `Backend/Infrastructure/Tasks/TaskEventsHub.cs:16-47` — `sub` jest lokalnym
  `Guid`, a `SubscribeProject` i replay są chronione ACL.
- `Backend/Infrastructure/Tasks/TaskRealtimeConnectionManager.cs:68-80` —
  snapshot presence grupuje po lokalnym `UserId` i emituje
  `project.presence.changed`.
- `docs/recovery/backend-contract-map-review.md:62` oraz
  `docs/recovery/backend-contract-map.md:114` — Frontowy adapter był oznaczony
  jako niezgodny właśnie z powodu pól Core/Ready.

## Blokada, której nie wolno maskować

Aktywny model
`lib/workspaces/domain/models/task_project_realtime_update.dart:23-84`
ma nadal:

- konstruktor i pole `actorCoreUserId` zamiast `actorUserId`;
- konstruktor i pole `coreUserId` zamiast `userId`;
- importy `package:ready_next` dla enumów.

Port
`lib/workspaces/domain/repositories/task_project_realtime.dart:1-3` oraz
serwis
`lib/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart:4`
również importują `package:ready_next`.

Nie mapowałem `actorUserId` do pola `actorCoreUserId` ani `userId` do
`coreUserId`. Byłoby to semantycznie fałszywe i utrwalałoby kontrakt Ready/Core.
Nie usunąłem też użytkowników presence po cichu. Dokończenie poprawnego mappera
wymaga osobnego, jawnie zatwierdzonego pakietu migracji bezpośrednich modeli i
portów; rozszerzenie zakresu w tym R2a łamałoby ograniczenie „tylko adapter i
focused test”.

## Walidacja

- `dart format` dla obu plików: **PASS**, bez zmian po formatowaniu.
- `flutter analyze lib/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart test/workspaces/data/realtime/task_project_realtime_adapter_test.dart`: **PASS**, 0 issues.
- `git diff --check`: **PASS**.
- `flutter test test/workspaces/data/realtime/task_project_realtime_adapter_test.dart`: **BLOCKED/FAIL** przed uruchomieniem testu. Kompilator nie może rozwiązać `package:ready_next` z bezpośrednich zależności (`workspace_scoped_realtime_service.dart`, model, port, enumy); nie jest to błąd testowanej asercji.

## Następny bezpieczny krok

W osobnym pakiecie należy zmigrować dokładnie bezpośredni graf adaptera:

1. model `task_project_realtime_update.dart` do `actorUserId`/`userId`;
2. jego enumy oraz port `task_project_realtime.dart` do importów `devplanner`;
3. `workspace_scoped_realtime_service.dart` do lokalnego klienta SignalR;
4. dopiero wtedy zmienić adapter na odczyt `actorUserId`/`userId` i dodać
   asercje testowe oparte o rzeczywiste pola backendu;
5. uruchomić test focused i dopiero po PASS oznaczyć R2a jako zaakceptowany.

Do czasu wykonania tych kroków nie należy oznaczać adaptera jako zmigrowanego,
przenosić go do innych pakietów ani usuwać modeli legacy.
