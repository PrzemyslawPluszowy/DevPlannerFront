# T1 — naprawa testów bootstrapu i rootu aplikacji

**Status:** gotowe do review rootu.

## Zakres

Zaktualizowano wyłącznie testy `app_bootstrap` i `DevPlannerApp`. Nie zmieniono
kodu produkcyjnego ani nie przywrócono `Runtime`, `AppGlobalPanels`, globalnego
Chatu lub globalnych powiadomień.

## Aktualny kontrakt sprawdzany przez testy

- Bootstrap przekazuje dostarczoną kompozycję Auth i transport HTTP do
  `DevPlannerApp`; aktywna sesja renderuje samodzielny `DevPlannerShellRoute`.
- Nieaktywna sesja pozostaje fail-closed i renderuje `AuthRoutePage`.
- Root standalone renderuje `DevPlannerWorkspacesPage` dla zalogowanej sesji.
- Dawna ścieżka `/chat` nie jest trasą globalnego overlayu: bezpośredni start
  jest sanitizowany do dostępnego rootu Workspace, bez tworzenia panelu Chat.

## Walidacja

- `flutter analyze test/bootstrap/app_bootstrap_test.dart test/app/devplanner_app_test.dart`:
  **brak problemów**.
- `flutter test --reporter compact test/bootstrap/app_bootstrap_test.dart test/app/devplanner_app_test.dart`:
  **5 testów zakończonych sukcesem**.
- Skan obu testów dla `Runtime`, `AppGlobalPanels`, starego globalnego API Chat
  i Notifications: brak zależności od usuniętej kompozycji.
- `git diff --check`: bez błędów białych znaków.
