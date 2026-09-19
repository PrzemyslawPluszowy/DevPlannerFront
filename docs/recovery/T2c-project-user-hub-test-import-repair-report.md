# T2c — naprawa importów testu Project User Hub

Data: 2026-09-18  
Status: **gotowe do niezależnego review rootu**.

## Zakres

Zmieniono wyłącznie
`test/workspaces/presentation/projects/user_hub/project_user_hub_cubit_test.dart`.
Nie modyfikowano kodu produkcyjnego, routingu, backendu ani kontraktów API.

## Zrealizowane zmiany

- Importy `package:ready_next` zastąpiono istniejącymi, bezpośrednimi importami
  `package:devplanner` dla błędów, modeli, enumów, repozytorium i Cubita.
- Fixture `ProjectMemberResponse` używa kanonicznego lokalnego pola `userId`
  zamiast odziedziczonego `coreUserId`.
- Zachowano wszystkie przypadki testowe: pobieranie projektu, zachowanie
  preferencji, przypięcie, ukrycie, opuszczenie projektu oraz błąd opuszczenia.

## Dowody

```text
dart format test/workspaces/presentation/projects/user_hub/project_user_hub_cubit_test.dart
# PASS

flutter analyze test/workspaces/presentation/projects/user_hub/project_user_hub_cubit_test.dart
# PASS: No issues found!

flutter test test/workspaces/presentation/projects/user_hub/project_user_hub_cubit_test.dart --reporter compact
# PASS: 6/6

rg -n 'package:ready_next|\\bReady\\b|CoreUserId|coreUserId|ReadyDirectoryUserResponse|searchReadyUsers' \
  test/workspaces/presentation/projects/user_hub/project_user_hub_cubit_test.dart
# PASS: brak wyników

git diff --check
# PASS
```

## Następny krok

Root powinien niezależnie powtórzyć analyzer, test oraz `git diff --check`.
Po akceptacji tylko root aktualizuje wspólny plan i handoff.
