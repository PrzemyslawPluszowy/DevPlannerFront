# R2u — fundament dokładnie dwóch motywów

Data: 2026-09-18  
Status: zakończony automatyczny odbiór; desktop/staging: **NIE URUCHAMIANO**.

## Zakres

Specyfikacja wizualna DevPlanner definiuje tylko dwa warianty: jasny i ciemny.
`MaterialTheme` zawierał cztery nieużywane statyczne presety medium/high
contrast oraz puste modele dodatkowych kolorów. Nie były wywoływane przez
aplikację ani testy.

Usunięto:

- `lightMediumContrastScheme`, `lightHighContrastScheme`,
  `darkMediumContrastScheme`, `darkHighContrastScheme` i ich fabryki
  `ThemeData`;
- nieużywane `ExtendedColor`, `ColorFamily` i pusty getter `extendedColors`.

Pozostają wyłącznie `MaterialTheme.light()` i `MaterialTheme.dark()` oraz
semantyczne rozszerzenia feedbacku, surfaces i Gmail-like shell. Fabryka
motywu ma teraz 300 linii i nie przekracza limitu.

## Odbiór

```text
flutter analyze lib/foundation/theme lib/app/devplanner_app.dart lib/app/shell
PASS — no issues found

flutter test [foundation theme, DevPlannerApp, DevPlannerShell]
PASS 9/9

rg [usunięte API] lib test
brak wyników
```

Nie uruchamiano aplikacji, backendu ani stagingu. Pakiet nie implementuje
jeszcze ekranu ustawień preferencji motywu; jest to osobny, jawny krok, a nie
powód dodawania kolejnych presetów.
