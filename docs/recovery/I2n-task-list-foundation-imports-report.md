# I2n — migracja importów foundation w direct Task List

## Zakres

Wykonano ograniczoną migrację importów w direct presentation Task List:

- `lib/workspaces/presentation/tasks/list/table`
- `lib/workspaces/presentation/tasks/list/cells`
- `lib/workspaces/presentation/tasks/list/filters`
- `lib/workspaces/presentation/tasks/list/inline_create`
- `lib/workspaces/presentation/tasks/list/menu`
- `lib/workspaces/presentation/tasks/list/preferences`
- `lib/workspaces/presentation/tasks/list/bulk`

Zmieniono 47 plików źródłowych. Importy `package:devplanner/core/l10n/l10n_extensions.dart` zastąpiono przez `package:devplanner/foundation/l10n/l10n.dart`, a `package:devplanner/core/theme/theme.dart` przez `package:devplanner/foundation/theme/theme.dart`.

## Uzasadnienie

Foundation udostępnia dokładnie te same kontrakty używane przez direct Task List:

- `DevPlannerL10nContextX` udostępnia `BuildContext.l10n` i `BuildContext.intl`.
- `foundation/theme/theme.dart` eksportuje rozszerzenia motywu oraz kontrakty `ThemeData` i `BuildContext` używane przez komórki, pickery, tabelę i preferencje.

Nie dodano aliasów, obejść, globalnego stanu ani zastępczych wizualizacji. Zachowanie i identyfikatory domenowe pozostały bez zmian.

## Walidacja

Wykonano:

```text
flutter analyze lib/workspaces/presentation/tasks/list test/workspaces/presentation/tasks/list
# No issues found!

flutter test test/workspaces/presentation/tasks/list --reporter compact
# 120 tests passed

git diff --check
# bez błędów
```

Skan zakresu po zmianie nie znajduje:

- bezpośrednich importów `package:devplanner/core/l10n/...` ani `package:devplanner/core/theme/...`,
- importów `package:ready_next`,
- `InvalidType`.

## Celowo pozostawione zależności

Migracja dotyczyła wyłącznie wskazanego direct Task List. Poza zakresem pozostają inne obszary aplikacji oraz kompatybilnościowa warstwa `lib/core`, która może być usuwana dopiero po zamknięciu migracji wszystkich pozostałych feature'ów. Nie zmieniano routera, shell, Board, Files, Chat, Notifications ani Backend.
