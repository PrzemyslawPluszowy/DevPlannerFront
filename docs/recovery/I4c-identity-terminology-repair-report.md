# I4c — standalone identity w kontraktach powiadomień

## Zakres

Ten batch usuwa pozostałości nazewnictwa `coreUserId` i
`recipientCoreUserId` z pionu powiadomień. Backend standalone zwraca i przyjmuje
identyfikatory lokalnych użytkowników jako `userId` oraz `recipientUserId`,
dlatego frontend nie utrzymuje aliasów ani podwójnych pól JSON.

## Zmienione elementy

- transportowe modele powiadomień używają `userId` i `recipientUserId`;
- domenowe snapshoty preferencji dostarczania i Storage używają `userId`;
- domenowe ustawienia powiadomień Chat używają `userId`;
- adaptery preferencji powiadomień oraz Chat mapują pola backendu bez warstwy
  zgodności z Core;
- bezpośrednie Cubity i fixture’y zależne od tych kontraktów zostały
  dostosowane do nowych nazw;
- wygenerowano ponownie Freezed/JSON dla modeli oraz Retrofit dla
  `NotificationsApi`. Wygenerowany klient jest typowany i nie zawiera już
  `InvalidType`.

## Zasady jakościowe

Nie dodano aliasów, fallbacków ani równoległych nazw JSON. Zmiana nie dotyka
UI, routingu, modala ani prezentacyjnej implementacji Chat. Logika mapowania
pozostaje w adapterach repozytoriów, a modele domenowe nie zależą od transportu.

## Walidacja

```text
dart run build_runner build \
  --build-filter=lib/workspaces/data/notifications/models/notification_models.freezed.dart \
  --build-filter=lib/workspaces/data/notifications/models/notification_models.g.dart \
  --build-filter=lib/workspaces/data/notifications/api/notifications_api.g.dart
```

Wynik: artefakty wygenerowane poprawnie; `notifications_api.g.dart` zawiera
konkretne typy `CursorPageResponse`, modeli powiadomień i payloadów, bez
`InvalidType`.

```text
dart analyze \
  lib/workspaces/data/notifications/models/notification_models.dart \
  lib/workspaces/data/notifications/api/notifications_api.dart \
  lib/workspaces/data/notifications/repositories/notification_preferences_repository_impl.dart \
  lib/workspaces/data/chat/repositories/chat_notification_settings_repository_impl.dart \
  lib/workspaces/domain/notifications/models/notification_preferences.dart \
  lib/workspaces/domain/notifications/models/chat_notification_settings.dart
```

Wynik: brak błędów; pozostała wyłącznie istniejąca informacja o kolejności
importów w `notifications_api.dart`.

Pełny zakres testów prezentacyjnych powiadomień nie jest jeszcze wiarygodnym
gatem tego batcha, ponieważ istniejące fixture’y i widgety w tej gałęzi nadal
mają niezależne importy `package:ready_next` oraz brakujący `AppModalHost`.
