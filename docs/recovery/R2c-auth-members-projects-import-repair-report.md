# R2c — standalone importy Auth, Members i Projects

Data: 2026-09-18  
Status: **gotowe do niezależnego review rootu**.

## Ścisły zakres

Pakiet naprawia wyłącznie importy i ich bezpośrednie kontrakty w:

- `lib/workspaces/data/auth/api/auth_api.dart`;
- `lib/workspaces/presentation/members/**`;
- `lib/workspaces/presentation/projects/workspace_project_resource_catalog_page.dart`;
- `lib/workspaces/presentation/projects/workspace_projects_page.dart`;
- `lib/workspaces/shared/helpers/workspace_visual_helpers.dart`;
- bezpośrednim teście `workspace_members_cubit_test.dart`.

Po jawnej zgodzie rootu wykonano jedną minimalną zmianę kompozycji poza tym
zakresem: `lib/app/shell/devplanner_shell.dart` publikuje już posiadany
`ProjectsGateway` przez `RepositoryProvider.value` dla tras potomnych. Nie
zmieniono layoutu, routingu, backendu ani nie dodano adaptera UI. Dodano test
tego seamu w `test/app/shell/devplanner_shell_test.dart`.

## Zrealizowane naprawy

- Wszystkie importy `package:ready_next` w objętych źródłach i bezpośrednim
  teście wskazują teraz na istniejące, typowane kontrakty `package:devplanner`.
- `AuthApi` pozostaje klientem istniejącego `CurrentUserResponse` i nie zmienia
  endpointu ani kontraktu bieżącego użytkownika.
- `WorkspaceMembersCubit` zachowuje odczyt członków przez
  `WorkspacesRepository`; test używa lokalnych typów `userId` i
  `searchLocalUsers`, bez odziedziczonego katalogu Ready.
- Katalog zasobów projektu zachowuje `ProjectResourcesRepository` i używa
  istniejącego portu nawigacji `DevPlannerNavigation`.
- Strona projektów używa istniejącego kontraktu oczekiwanego przez
  `WorkspaceProjectsCubit`, czyli `ProjectsGateway`; shell dostarcza ten sam,
  już skonfigurowany gateway do potomnych tras.
- Nie dodano placeholderów, aliasów kompatybilności ani połączeń Ready/Core.

## Dowody

```text
dart format [9 zmienionych źródeł i testów]
# PASS

flutter analyze lib/app/shell/devplanner_shell.dart \
  lib/workspaces/data/auth/api/auth_api.dart \
  lib/workspaces/presentation/members \
  lib/workspaces/presentation/projects/workspace_project_resource_catalog_page.dart \
  lib/workspaces/presentation/projects/workspace_projects_page.dart \
  lib/workspaces/shared/helpers/workspace_visual_helpers.dart \
  test/app/shell/devplanner_shell_test.dart \
  test/workspaces/presentation/members/workspace_members_cubit_test.dart \
  test/workspaces/presentation/navigation/workspace_projects_cubit_test.dart
# PASS: No issues found!

flutter test test/workspaces/presentation/members/workspace_members_cubit_test.dart \
  test/workspaces/presentation/navigation/workspace_projects_cubit_test.dart \
  --reporter compact
# PASS: 3/3

rg -n 'package:ready_next|\\bReady\\b|CoreUserId|coreUserId|searchReadyUsers|ReadyDirectoryUserResponse' \
  [źródła R2c i bezpośrednie testy]
# PASS: brak wyników

git diff --check
# PASS
```

Test `test/app/shell/devplanner_shell_test.dart`, w tym nowy przypadek
udostępnienia `ProjectsGateway`, nie osiągnął uruchomienia z przyczyny poza
zakresem R2c: kompilacja testowego shella zatrzymuje się w istniejących plikach
Tasks List `task_list_header.dart` i `task_list_column_helper.dart`, gdzie
brakuje `customFieldTypeVisual`. To nie jest błąd importów ani seamu R2c;
źródeł Tasks List nie zmieniano. Po naprawie tamtego niezależnego pakietu root
powinien ponowić test shella.

## Następny krok

Root powinien niezależnie uruchomić analyzer, dwa przechodzące testy Cubitów,
test shella po odblokowaniu Tasks List oraz `git diff --check`. Tylko root
aktualizuje wspólne plan/handoff po akceptacji.
