# R2b — naprawa importów shella i routingu workspace’ów

Status: **gotowe do niezależnego review rootu**.

## Zakres

Zmieniono wyłącznie wskazane piony prezentacji workspace’ów oraz ich
bezpośrednie testy: shell, routing, sekcje, stronę główną i sekcję workspace.
Nie zmieniano globalnego shellu DevPlanner, globalnego routera ani backendu.

## Wykonane naprawy

- Wszystkie importy `package:ready_next/...` w zakresie zastąpiono istniejącymi
  bezpośrednimi importami `package:devplanner/...`.
- Stary mechanizm nawigacji widoków workspace’u zastąpiono portem
  `DevPlannerNavigation`; zachowano te same ścieżki menu, kart sekcji i plików.
- Otwarcie Resource Chat korzysta z istniejącego `DevPlannerPanelsScope`, więc
  nie odtwarza usuniętego scope’a globalnego.
- Klucze lokalnej preferencji rozwinięcia menu nadal są rozdzielone per
  zalogowany użytkownik przez `AuthSessionPort`, z bezpiecznym fallbackiem
  `anonymous`.
- Zachowano konkretne dashboardy, widoki zasobów i menu; nie dodano
  placeholderów ani warstw zgodności.

## Walidacja

- `flutter analyze` dla pełnego zakresu R2b i bezpośrednich testów:
  **0 problemów**.
- `flutter test test/workspaces/presentation/workspace_shell/workspace_static_menu_test.dart`:
  **2 testy przeszły**.
- `flutter test test/workspaces/presentation/workspace_menu_visual_smoke_test.dart`:
  **1 test przeszedł**.
- Skan `package:ready_next|package:http|package:dio|dart:io|Ready|Core|DataBus`:
  0 trafień w zakresie.
- Najdłuższy plik produkcyjny: 334 linii
  (`routing/workspace_resource_pages.dart`).
- `git diff --check`: powodzenie.
