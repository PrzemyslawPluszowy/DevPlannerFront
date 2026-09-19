# I2u — rozdzielenie akcji szablonów Kanbanu

## Zakres

Rozdzielono monolityczny plik `lib/workspaces/presentation/tasks/board/tasks_board_template_picker_actions.dart` (2112 linii) odpowiedzialny za menu akcji szablonu, edytor formatki oraz pola formularza. Zmiana dotyczy wyłącznie organizacji kodu UI Kanbanu. Nie zmieniono kontraktów repozytoriów, routingu, transportu HTTP, plików, czatu ani powiadomień.

## Nowa struktura

Plik wejściowy pozostawiono jako pusty element kompatybilności, a deklaracje `part` przeniesiono do `tasks_board_page.dart`. Kod znajduje się w drzewie:

```text
lib/workspaces/presentation/tasks/board/template_actions/
├── template_picker_actions.dart       # kafel szablonu, otwieranie edycji i akcje
├── template_editor_state.dart         # stan formularza i cykl życia
├── template_editor_loading.dart       # ładowanie szczegółów i status domyślny
├── template_editor_mutations.dart     # walidacja, zapis, wybory i dirty state
├── template_editor_view.dart          # widok formularza i pasek akcji
├── template_editor_basic.dart         # sekcja podstawowa
├── template_editor_planning.dart      # status, priorytet, daty, estymata
├── template_editor_responsibility.dart # wykonawcy
├── template_editor_scope.dart         # checklista i kryteria akceptacji
├── template_editor_classification.dart # typ, rozmiar, złożoność, ryzyko
├── template_editor_metadata.dart      # etykiety i pola własne
├── template_editor_sections.dart      # karta sekcji i picker wykonawców
├── template_editor_fields.dart        # edytory list i pól własnych
├── template_editor_values.dart        # pola dat, badge i pickery wartości
└── template_editor_management.dart    # zmiana nazwy i usuwanie szablonu
```

Logika została rozdzielona na rozszerzenia stanu oraz małe klasy akcji (`_TemplateManagementActions`, `_TemplateManagementDialogs`, `_TemplateEditorHelpers`), a nie przeniesiona do jednego „serwisu” ani funkcji globalnych. Publiczne API `TaskTemplateEditor`, `SelectedTemplateStatus` i zachowanie menu pozostały bez zmian. Rozszerzenia formularza używają prywatnego `_updateEditorState` w stanie edytora; dzięki temu nie odwołują się bezpośrednio do chronionego `State.setState`.

## Kontrola jakości

- Najdłuższy plik produkcyjny w nowym drzewie: `template_editor_fields.dart` — 353 linie (wszystkie 15 plików poniżej limitu 400).
- Żaden plik w `template_actions/` nie przekracza 400 linii.
- `flutter analyze lib/workspaces/presentation/tasks/board/tasks_board_page.dart` (analizuje bibliotekę wraz ze wszystkimi 15 częściami `template_actions`) — **No issues found**.
- `flutter test test/workspaces/presentation/tasks/board/templates/task_template_picker_widget_test.dart test/workspaces/presentation/tasks/board/templates/task_template_picker_cubit_test.dart` — **21 testów zaliczonych**.
- `git diff --check` — bez błędów białych znaków.
- Skan nowego drzewa nie wykazał `package:ready_next`, `package:devplanner/core`, `InvalidType` ani globalnych funkcji pomocniczych.

## Kryteria zachowania

Zachowane i objęte istniejącymi testami są: tworzenie szablonu, edycja, ładowanie szczegółów i retry, walidacja nazwy, zapis tylko raz, obsługa błędu API, niezapisane zmiany, wybór statusu customowego, wykonawcy, pól własnych oraz usuwanie/zmiana nazwy z potwierdzeniem.
