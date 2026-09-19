# I2s — rozbicie nagłówka Kanbana

## Zakres

Rozbito monolityczny plik `tasks_board_header.dart` (1492 linii) na małe, logicznie spójne części. Publiczne API `TasksBoardHeader`, układ, skróty, uprawnienia, akcje masowe i dialog szybkiego tworzenia pozostają bez zmian.

## Nowa struktura

- `tasks_board_header.dart` — publiczny komponent i cienki koordynator danych nagłówka.
- `tasks_board_header_layout.dart` — czysty układ wizualny dwóch wariantów responsywnych.
- `tasks_board_header_actions.dart` — menu „Więcej”, bulk toolbar, przyciski i pasek aktywnego filtra.
- `tasks_board_header_create_actions.dart` — CTA tworzenia zadania i koordynacja otwarcia dialogu.
- `tasks_board_header_quick_create_dialog.dart` — formularz szybkiego tworzenia zadania.
- `tasks_board_header_filters.dart` — menu szybkich filtrów i typowane wartości prezentacyjne.

Każdy plik pozostaje częścią biblioteki `tasks_board_page.dart`, dzięki czemu nie zmieniono kontraktu prywatnych elementów między istniejącymi częściami planszy. Odczyt stanu oraz operacje nadal są wywoływane przez istniejące Cubity/repozytoria; nowe pliki nie dodają globalnych funkcji ani zależności od Ready/Core.

## Kryteria jakości

- każdy plik ma mniej niż 400 linii;
- zachowane zostały klucze semantyczne, skróty, warianty desktop/mobile, uprawnienia i akcje masowe;
- brak zmian w routerze, Files, Chat i Notifications;
- po zmianie wykonano analizę zakresu, testy planszy oraz `git diff --check`.

## Walidacja

Kontrola struktury po finalnym formatowaniu: `wc -l` zwróciło odpowiednio 197, 367, 356, 164, 254 i 222 linii. `git diff --check` zakończył się bez komunikatów. Skan plików nie wykazał importów `ready_next`, `devplanner/core` ani funkcji globalnych.

## Wyniki walidacji

- `flutter analyze` dla biblioteki planszy i sześciu nowych części: **No issues found!**
- `flutter test test/workspaces/presentation/tasks/board/tasks_board_header_responsive_test.dart test/workspaces/presentation/tasks/board/tasks_board_route_page_test.dart test/workspaces/data/projects/tasks/tasks_board_composition_test.dart`: **17 testów, wszystkie zaliczone**.
- `git diff --check`: bez błędów.
