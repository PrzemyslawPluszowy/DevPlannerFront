# T2a — naprawa testu routera dawnych powiadomień

**Status:** gotowe do review rootu.

Test nie tworzy już kompozycji ani repozytorium powiadomień. Sprawdza aktualny
kontrakt `DevPlannerRouter`: `/notifications` nie jest ścieżką standalone,
zalogowana sesja trafia do Workspace root, a niezalogowana pozostaje
fail-closed na ekranie logowania. Harness używa rzeczywistego motywu i
lokalizacji standalone wymaganych przez shell.

Walidacja:

- `flutter analyze test/app/router/devplanner_notifications_router_test.dart`:
  brak problemów;
- `flutter test --reporter compact test/app/router/devplanner_notifications_router_test.dart`:
  3 testy przeszły;
- nie zmieniono produkcji ani nie przywrócono API/overlayu powiadomień.
