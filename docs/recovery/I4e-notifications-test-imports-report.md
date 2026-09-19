# I4e — migracja importów testów powiadomień

## Zakres

Ten etap dotyczył wyłącznie źródeł testowych w katalogach:

- `test/workspaces/data/notifications/`
- `test/workspaces/domain/notifications/`
- `test/workspaces/presentation/notifications/`

Nie zmieniano kodu produkcyjnego, routingu, modali ani zachowania funkcjonalnego.

## Wykonane zmiany

1. Wszystkie importy `package:ready_next/...` w powyższym zakresie zamieniono na `package:devplanner/...`.
2. Zaktualizowano fixture'y i asercje do lokalnego kontraktu identyfikatorów:
   - `coreUserId` → `userId`,
   - `authorCoreUserId` → `authorUserId`,
   - `attachedByCoreUserId` → `attachedByUserId`.
3. Zachowano istniejące scenariusze testowe, nazwy testów i ich semantykę.

## Walidacja

Weryfikacja `rg` dla objętego zakresu nie zwraca już `package:ready_next`, `coreUserId`, `recipientCoreUserId`, `authorCoreUserId` ani `attachedByCoreUserId`.

Uruchomiono zestaw testów:

```text
flutter test test/workspaces/data/notifications \
  test/workspaces/domain/notifications \
  test/workspaces/presentation/notifications --reporter compact
```

Testy nie mogą jeszcze zakończyć się poprawnie z powodu istniejącej zależności produkcyjnej poza zakresem tego zadania. Kompilacja wchodzi do:

`lib/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart`

Plik nadal importuje `package:ready_next/...` dla:

- `workspaces/data/notifications/models/notification_models.dart`,
- `workspaces/data/realtime/signalr/workspace_signalr_client.dart`,
- `workspaces/domain/repositories/notifications_repository.dart`.

W konsekwencji kompilator zgłasza również brak typów `WorkspaceNotificationResponse`, `NotificationGroupResponse`, `WorkspaceSignalRTransport`, `WorkspaceSignalRConnectionState` i `NotificationsRepository`. To jest następny etap migracji produkcyjnej realtime i celowo nie zostało zmienione tutaj.

Część testów, która nie dotknęła tej zależności, została załadowana i wykonała się poprawnie; pełny zestaw pozostaje zablokowany przez wymienione importy produkcyjne.

## Kontynuacja

Następny agent powinien najpierw zmigrować wskazany serwis realtime oraz jego zależności do `devplanner`, a następnie powtórzyć pełny zestaw testów powiadomień. Nie należy przywracać aliasu `ready_next` ani wyłączać testów.
