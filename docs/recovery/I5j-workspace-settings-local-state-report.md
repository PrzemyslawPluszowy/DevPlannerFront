# I5j — stan lokalny ustawień przestrzeni

Status: **gotowe do niezależnego review rootu**.

## Zakres

Zmiana obejmuje wyłącznie `lib/workspaces/presentation/workspaces_settings/**`.
Zachowano obsługę ustawień ogólnych, członków, zaproszeń oraz preferencji
powiadomień; nie zmieniano routingu, backendu ani innych pionów. Moduł
przełączono z usuniętego katalogu Ready na istniejący lokalny kontrakt
użytkownika (`LocalUserDirectoryResponse` i `userId`).

## Decyzje

- Cubity pozostały właścicielami odczytu i mutacji danych domenowych.
- Przejściowy stan UI jest trzymany w małych `ValueNotifier`ach z jawnym
  `dispose`: aktywna zakładka, wybór ikony/koloru, draft powiadomień oraz
  wyszukiwanie i wybór osoby w dialogu zaproszenia.
- Drafty są niemutowalne. Dialog zaproszenia odrzuca spóźnioną odpowiedź
  wyszukiwania po zmianie zapytania.
- Usunięto wszystkie użycia `setState`, `StatefulBuilder` i `setDialogState`
  z modułu. Nie dodano I/O ani wywołań API w widokach.
- Opcje ikony i koloru wydzielono do `WorkspaceGeneralFormOptions`, aby każdy
  plik produkcyjny pozostał poniżej 400 linii.
- Wszystkie importy zakresu używają bezpośrednio `package:devplanner/...`;
  nie użyto aliasów ani pakietów zgodności.

## Walidacja

- `dart format` dla zmienionych plików: powodzenie.
- Skan `setState|StatefulBuilder|setDialogState`: 0 trafień.
- Skan importów `dart:io` i `package:http`: 0 trafień.
- Maksymalna długość pliku: 389 linii
  (`general/widgets/workspace_general_tab_view.dart`).
- `git diff --check`: powodzenie.
- `flutter analyze lib/workspaces/presentation/workspaces_settings`: **0
  problemów**.
- `flutter test
  test/workspaces/presentation/workspaces_settings/workspace_invitations_settings_cubit_test.dart`:
  **1 test przeszedł**. Test potwierdza wyszukiwanie przez aktualny lokalny
  katalog i kontrakt repozytorium.
