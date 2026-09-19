# I0 — generyczna domena Workspace

## Status

Batch zakończony i zweryfikowany w ograniczonym zakresie. Zmiana dotyczy
wyłącznie importów kontraktu błędu w pięciu generycznych interfejsach domeny.
Nie zmieniano nazw publicznych pól, semantyki modeli ani zachowania runtime.

## Dokładny zakres

### Włączone

- `lib/workspaces/domain/models/**`
- `lib/workspaces/domain/navigation/**`
- `lib/workspaces/domain/ports/**`
- generyczne kontrakty:
  - `repositories/project_member_profiles_repository.dart`
  - `repositories/project_resources_repository.dart`
  - `repositories/projects_repository.dart`
  - `repositories/workspace_features_repository.dart`
  - `repositories/workspaces_repository.dart`

W pięciu kontraktach zastąpiono `package:devplanner/core/error/api_error.dart`
kanonicznym `package:devplanner/foundation/error/api_error.dart`.

### Wyłączone celowo

- `domain/chat/**` i `domain/repositories/chat_repository.dart`;
- `domain/notifications/**` i `domain/repositories/notifications_repository.dart`;
- `domain/storage/**` oraz `domain/repositories/storage_repository.dart`;
- zadaniowe repozytoria i modele (`task_*`, Kanban, milestone, OKR,
  automatyzacje, workflow i szablony), ponieważ są obsługiwane przez osobne
  aktywne batch’e;
- UI, routing, shell, warstwa data, generatory i backend.

Żaden plik spoza powyższych pięciu kontraktów nie został zmodyfikowany przez
ten batch.

## Diagnostyka

Przed zmianą w zakresie włączonym wykryto 5 importów `devplanner/core`.
Po zmianie:

```text
flutter analyze lib/workspaces/domain/models \
  lib/workspaces/domain/navigation \
  lib/workspaces/domain/ports \
  lib/workspaces/domain/repositories/project_member_profiles_repository.dart \
  lib/workspaces/domain/repositories/project_resources_repository.dart \
  lib/workspaces/domain/repositories/projects_repository.dart \
  lib/workspaces/domain/repositories/workspace_features_repository.dart \
  lib/workspaces/domain/repositories/workspaces_repository.dart
No issues found!
```

Skan zakresu włączonego nie zwraca `package:ready_next` ani
`package:devplanner/core`. `git diff --check` przechodzi bez błędów.

Testy skoncentrowane na katalogu Workspace, drzewie nawigacji i mapowaniu
członków projektu:

```text
flutter test \
  test/workspaces/presentation/navigation/workspace_navigation_foundation_test.dart \
  test/workspaces/presentation/navigation/workspace_navigation_tree_cubit_test.dart \
  test/workspaces/presentation/navigation/workspace_projects_cubit_test.dart \
  test/workspaces/data/workspace_mappers_test.dart \
  test/workspaces/data/projects/project_member_profiles_repository_test.dart \
  --reporter compact
All tests passed! (12 tests)
```

## Pozostała mapa zależności

Skan wyłączonych obszarów nadal pokazuje historyczne importy `core`/`ready_next`
(46 plików w tym przeglądzie). Nie są one częścią tego batcha i nie powinny być
usuwane mechanicznie, dopóki odpowiadające im pionowe migracje Chat,
Notifications, Files i Tasks nie zostaną zamknięte. Kolejny batch musi ponownie
wyznaczyć dokładny zakres i uruchomić analizę tylko po jego właścicielskich
plikach.

## Kandydaci do osobnej decyzji

`WorkspaceListItem.createdByCoreUserId` oraz jego argument `copyWith` nadal
mają nazwę historyczną. Nie zmieniono ich mechanicznie: jest to publiczny
kontrakt domeny i rename wymaga jednoczesnej aktualizacji mapperów, testów oraz
wszystkich konsumentów. Kandydat do osobnego, semantycznego batcha:
`createdByUserId`, po potwierdzeniu zgodności z aktualnym kontraktem C#.

