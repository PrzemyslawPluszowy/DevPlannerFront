# R4b — Notifications: lokalny model inboxa i port repozytorium

Data: 2026-09-17 21:28 (Europe/Warsaw)
Status: **SCOPED PASS — inbox boundary only**

## Zakres zamkniętej granicy

Zmigrowano najmniejszy kompilowalny pion używany przez globalny inbox i jego
composition: transportowe powiadomienie, grupa z referencjami aktorów oraz port
`NotificationsRepository`. Nie zmieniano routera, shella, globalnej strony,
Chat, reply, realtime, BFF ani Backend. Nie wykonano `git clean`, `restore`,
`reset`, `checkout`, commit ani push.

| Ścieżka | Przed | Po | Dowód / źródło | SHA-256 po zmianie | Status |
|---|---|---|---|---|---|
| `lib/workspaces/data/notifications/models/notification_models.dart` | enum import `package:ready_next`; `NotificationActorAvatarResponse.coreUserId` | enum import `package:devplanner`; lokalne `NotificationActorAvatarResponse.userId` | Backend `Contracts/Notifications/WorkspaceNotificationResponse.cs:29-53`, `NotificationGroupMetadata.cs:51-64` | `522a7e0f7cf851b61f5c2714ef387c2ef55ee7f44ec85d9f0fadcc157efeee48` | migrated |
| `lib/workspaces/data/notifications/models/notification_models.freezed.dart` | wygenerowane `coreUserId` dla aktora | wygenerowane `userId` dla aktora | kontrolowany `build_runner` output; nieedytowany ręcznie | `e49c2b9480d79dadbeddd8618be5eb0b60586d02d6ffc9c1da30b02fb6fbdf06` | generated |
| `lib/workspaces/data/notifications/models/notification_models.g.dart` | JSON `coreUserId` dla aktora | JSON `userId` dla aktora | kontrolowany `build_runner` output; nieedytowany ręcznie | `a4bb3cecbb106904ce21932b8940f86dfee7334e6f99457b992b63cb04a65071` | generated |
| `lib/workspaces/domain/repositories/notifications_repository.dart` | port importował Ready/Core | port importuje lokalny `ApiError`, lokalne DTO, cursor i enum | global composition wymaga wyłącznie tego portu; `backend-contract-map.md:103` | `0042a6976a446f41a4b185f3ab1f4dc2c6d3d3b6bcf8e3e30a3fe964ae047b15` | migrated |
| `test/workspaces/data/notifications/notification_models_local_contract_test.dart` | brak focused testu lokalnego modelu | test JSON `UserId` + typed `ApiError.parsing` | Backend DTO i lokalny error contract | `3ed9053c14ca4fc36d29b5dcbc251cef45477c757f0aaa7e49cc166d445b6fc3` | added |

## Kontrakt Backend

- `Backend/Contracts/Notifications/WorkspaceNotificationResponse.cs:7-29`
  definiuje lokalne identyfikatory powiadomienia, eventu i opcjonalnego
  workspace; inbox nie otrzymuje żadnego Core/Ready ID.
- `Backend/Contracts/Notifications/WorkspaceNotificationResponse.cs:29-40`
  definiuje `NotificationGroupResponse` i referencje aktorów.
- `Backend/Contracts/Notifications/WorkspaceNotificationResponse.cs:51-53`
  definiuje `NotificationActorAvatarResponse.UserId` i `AvatarUrl`.
- `Backend/Contracts/Notifications/NotificationGroupMetadata.cs:51-64`
  wyciąga wyłącznie `actorUserId` z metadanych JSON i buduje lokalne
  `NotificationActorAvatarResponse`.
- `Backend/Endpoints/Notifications/NotificationEndpoints.cs` jest źródłem
  endpointów inboxa, unread, groups, read/archive i quick-action.

## Celowe ograniczenie

Plik transportowych modeli zawiera jeszcze dwa osobne kontrakty preferencji:
`NotificationDeliveryPreferenceResponse` i
`StorageNotificationPreferenceResponse`, które nadal mają `coreUserId`.
Nie zmieniałem ich w R4b, ponieważ ich implementacje zależą od całego legacy
`NotificationsApi`, dodatkowych repozytoriów preferencji i ścieżek Chat. Ich
częściowe przemianowanie bez migracji tego grafu złamałoby kompilację i byłoby
fałszywym sukcesem. To osobny pakiet preferencji, nie część zamkniętej granicy
globalnego inboxa.

Analogicznie nie zmieniałem `notifications_api.dart`: obecny interfejs obejmuje
reply do Chat, preferencje i endpoint administracyjny, a jego bezpośredni
`ChatMessageResponse` nadal należy do niemigrowanego pionu Chat. Nie dodano
lokalnych aliasów ani fallbacków.

## Walidacja

- kontrolowany generator:
  `dart run build_runner build --build-filter='lib/workspaces/data/notifications/models/notification_models.freezed.dart'` oraz
  `...notification_models.g.dart`: **PASS**; wygenerowane pliki nie były
  edytowane ręcznie;
- `dart format` dla źródeł i focused testu: **PASS**;
- `flutter analyze` dla modelu, portu i testu: **PASS**, 0 issues;
- `flutter test test/workspaces/data/notifications/notification_models_local_contract_test.dart`: **2/2 PASS**;
- `git diff --check`: **PASS**.

Focused test potwierdza mapowanie backendowego `userId` w actor avatarze oraz
typowanie błędu parsowania przez `ApiError`. Nie deklaruje migracji preferencji,
reply ani pełnego API Notifications.
