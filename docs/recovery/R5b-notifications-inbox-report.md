# R5b — standalone Notifications inbox

## Cel i granice

R5b dodaje mały, samodzielny pion skrzynki Notifications w repozytorium
Front. Pion jest gotowy do osadzenia przez przyszły shell, ale nie rejestruje
trasy i nie zmienia root routera, Chat ani istniejących stron legacy. Nie
korzysta z `ready_next`, Core, DataBus ani odziedziczonego
`NotificationsRepository`/`NotificationsApi`.

Zakres obejmuje tylko:

- listę cursorową powiadomień,
- licznik nieprzeczytanych,
- oznaczenie pojedynczego powiadomienia jako przeczytanego,
- lokalny Cubit/state oraz osadzalny panel z loadingiem, pustym stanem,
  błędem/retry i paginacją.

## Kontrakt źródłowy

Źródłem prawdy był istniejący Backend, bez jego modyfikacji. Dowody w kodzie:
`Backend/Endpoints/Notifications/NotificationEndpoints.cs:20-22,43-44,53`,
`Backend/Contracts/Notifications/WorkspaceNotificationResponse.cs:7-27` oraz
`Backend/Contracts/Notifications/UnreadNotificationCountResponse.cs:5-7`.

| Operacja | Kontrakt |
| --- | --- |
| Lista | `GET /api/v1/notifications/`, query `cursor`, `limit` 1–100, `category`, `isUnreadOnly`; odpowiedź `CursorPageResponse<WorkspaceNotificationResponse>` z `items` i `nextCursor` |
| Licznik | `GET /api/v1/notifications/unread-count`; odpowiedź `{ count }` |
| Odczyt | `POST /api/v1/notifications/{id:guid}/read`; sukces `204 No Content` |

Mapowane pola wpisu pochodzą z `WorkspaceNotificationResponse`: `id`,
`eventType`, `title`, `body`, `createdAtUtc`, `readAtUtc`, `category`,
`priority`, `deepLink` i `groupKey`. Enumy są sprawdzane jawnie i nie mają
fikcyjnego fallbacku. Błędy zachowują typ HTTP, `apiCode` i `traceId`.

## Dodane pliki

- `lib/workspaces/presentation/notifications/standalone/domain/notifications_inbox_models.dart`
  — ograniczone modele domenowe bez tożsamości Ready/Core.
- `lib/workspaces/presentation/notifications/standalone/domain/notifications_inbox_gateway.dart`
  — wąski port list/count/mark-read.
- `lib/workspaces/presentation/notifications/standalone/data/devplanner_notifications_inbox_gateway.dart`
  — adapter `DevPlannerHttpTransport` do realnych endpointów Backend.
- `lib/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_state.dart`
  — lokalny, typowany stan.
- `lib/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_cubit.dart`
  — lifecycle-safe orkiestracja listy, paginacji i mark-read.
- `lib/workspaces/presentation/notifications/standalone/presentation/notifications_inbox_panel.dart`
  — osadzalny panel UI; bez routingu i bez zależności transportowych.
- `test/workspaces/presentation/notifications/standalone/devplanner_notifications_inbox_gateway_test.dart`
  — mapowanie kontraktu, query, błędy typed i mark-read.
- `test/workspaces/presentation/notifications/standalone/notifications_inbox_cubit_test.dart`
  — ready, cursor pagination, mark-read, failure i retry.

## Walidacja

Wykonano w repo Front:

```text
dart format lib/workspaces/presentation/notifications/standalone test/workspaces/presentation/notifications/standalone
flutter analyze lib/workspaces/presentation/notifications/standalone test/workspaces/presentation/notifications/standalone
flutter test test/workspaces/presentation/notifications/standalone/devplanner_notifications_inbox_gateway_test.dart
flutter test test/workspaces/presentation/notifications/standalone/notifications_inbox_cubit_test.dart
git diff --check
```

Wynik: format bez zmian, analyze `No issues found`, wszystkie testy gateway i
Cubita zaliczone, diff check bez błędów.

## Następny krok

Composition root może utworzyć `DevPlannerNotificationsInboxGateway` z już
skonfigurowanym `DevPlannerHttpTransport` i osadzić panel w nowym shellu.
Integracja z root routerem, globalnym hostem oraz realtime Notifications jest
celowo poza R5b i wymaga osobnego review, aby nie reaktywować legacy graph.
