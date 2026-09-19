# I5g — odblokowanie importów Workspaces Home

Data: 2026-09-18

## Cel i granice

Pakiet obejmuje wyłącznie dwa istniejące pliki blokujące analizę Workspaces
Home:

- `lib/workspaces/shared/helpers/workspace_icon_helper.dart`;
- `lib/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart`.

Cel: usunąć bezpośrednie importy `package:ready_next/...` i skierować je do
istniejących powierzchni `package:devplanner/...`. Nie zmieniono modeli,
kontraktów API, Cubitów, UI, `setState`, routingu jako katalogu ani Backendu.

## Zmiany

- Importy theme i ikon helpera Workspaces wskazują teraz pakiet
  `devplanner`.
- Dialogi tworzenia zasobów projektu korzystają z istniejących importów
  standalone `devplanner`.
- Usunięty wcześniej `AppRouter` nie ma fizycznego odpowiednika pod starą
  ścieżką. Dlatego sześć istniejących wywołań `context.router.navigatePath`
  skierowano do istniejącego, typowanego portu
  `context.plannerNavigation.go`. Zachowano dokładnie te same wewnętrzne
  ścieżki docelowe; nie dodano aliasu, fallbacku, nowego routingu ani globalnej
  funkcji.

## Walidacja

Wykonano w katalogu `Front`:

```bash
dart format lib/workspaces/shared/helpers/workspace_icon_helper.dart \
  lib/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart
flutter analyze lib/workspaces/shared/helpers/workspace_icon_helper.dart \
  lib/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart \
  lib/workspaces/presentation/workspaces_home
rg -n 'package:ready_next' \
  lib/workspaces/shared/helpers/workspace_icon_helper.dart \
  lib/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart
git diff --check
```

Wyniki:

- formatowanie: PASS, bez dodatkowych zmian;
- scoped analyzer: `No issues found!`;
- skan `package:ready_next` obu plików: brak wyników;
- `git diff --check`: PASS.

## Następny krok

Ten pakiet jest wyłącznie odblokowaniem grafu importów Workspaces Home. Nie
stanowi odbioru całego Home ani desktopowego E2E. Następny pakiet powinien
osobno przejrzeć funkcjonalność katalogu Workspaces i jego testy, bez
przywracania legacy importów.
