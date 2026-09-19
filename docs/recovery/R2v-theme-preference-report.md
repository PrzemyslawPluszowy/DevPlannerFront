# R2v — trwała preferencja jasnego/ciemnego motywu

Data: 2026-09-18  
Status: zakończony automatyczny odbiór; desktop/staging: **NIE URUCHAMIANO**.

## Zakres

Wdrożono jedyną dozwoloną preferencję wyglądu: jasny albo ciemny. Nie ma
wariantu systemowego, presetów kolorystycznych ani stanu globalnego poza
kontrolowanym lifecycle aplikacji.

| Plik | Odpowiedzialność |
|---|---|
| `lib/app/theme/theme_preference.dart` | enum dwóch wariantów i port persistence. |
| `lib/app/theme/shared_preferences_theme_preference_store.dart` | adapter lokalnego `shared_preferences`; UI go nie zna. |
| `lib/app/theme/theme_preference_cubit.dart` | odczyt, potwierdzony zapis i przełączenie bez `BuildContext`. |
| `lib/app/devplanner_app.dart` | composition i lifecycle Cubita; `MaterialApp.router` dostaje `themeMode` bez tworzenia nowego routera. |
| `lib/app/shell/devplanner_shell_layout.dart` | dostępna akcja belki przełączająca tylko dwa warianty przez Cubit. |

## Reguły błędów i lifecycle

- Domyślny wariant jest jasny.
- Błąd odczytu storage nie blokuje uruchomienia i zachowuje jasny wariant.
- Błąd zapisu nie publikuje niepotwierdzonej zmiany.
- Cubit jest tworzony i zamykany przez `DevPlannerApp`; nie ma `setState`,
  HTTP, tokenów ani logiki biznesowej w widoku belki.
- W testach samego shella brak providera oznacza brak tej akcji, co zachowuje
  niezależność testowalnego shella od root composition.

## Odbiór

```text
flutter analyze [app/theme, DevPlannerApp, shell i testy]
PASS — no issues found

flutter test [theme preference cubit, DevPlannerApp, DevPlannerShell]
PASS 11/11
```

Test aplikacji potwierdza odczyt zapisanej wartości ciemnej, kliknięcie akcji
belki, trwały zapis jasnej wartości i zmianę `Theme.of(...).brightness` bez
zmiany trasy. Nie uruchamiano GUI, backendu ani stagingu.
