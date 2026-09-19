# I4f — migracja importów realtime Notifications

## Zakres

W tym batchu zmieniono wyłącznie plik:

- `lib/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart`

Trzy przestarzałe importy `package:ready_next/...` zostały zastąpione istniejącymi odpowiednikami `package:devplanner/...` dla modeli powiadomień, transportu SignalR i repozytorium powiadomień.

Nie zmieniano UI, routingu, hosta modali, testów ani Backend. Nie dodano aliasów, fallbacków, `setState` ani funkcji globalnych.

## Walidacja

Uruchomiono:

```text
dart format lib/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart
flutter analyze lib/workspaces/data/realtime/notifications
git diff --check
```

Wynik:

- `dart format`: plik był już sformatowany, 0 zmian formatowania;
- `flutter analyze`: `No issues found!`;
- `git diff --check`: bez błędów.

## Pozostałe blokery

Ten batch usuwa wyłącznie stare importy w warstwie realtime Notifications. Nie oznacza ukończenia globalnego overlayu powiadomień ani integracji lifecycle z shellem. Chat, globalny host overlayów oraz pełne testy end-to-end pozostają osobnymi etapami.
