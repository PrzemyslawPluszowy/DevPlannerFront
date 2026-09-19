# I2 — audyt menu i fundament drzewa nawigacji

Data: 2026-09-17  
Repozytorium: `Front`  
Zakres: wyłącznie frontend; bez zmian w Backend, routerze i globalnym shellu.

## Wynik

Dodano mały, niezależny od UI fundament drzewa nawigacji oparty o rzeczywisty
lokalny kontrakt `WorkspacesGateway`. Fundament:

- sortuje workspace’y (przypięte najpierw, następnie alfabetycznie),
- zachowuje globalne pozycje `overview`, zadania osobiste i pliki osobiste,
- tworzy w każdym workspace strukturalną gałąź `projects`,
- oznacza gałąź projektów jako `isDataPending`, bo bieżące źródło projektów
  nie jest jeszcze lokalnym kontraktem DevPlanner,
- przechowuje pełną listę typów zasobów projektu: zadania, Kanban,
  whiteboardy, corkboard, wiki, pliki i automatyzacje,
- nie tworzy fikcyjnych projektów, zasobów, tras ani komunikatów dla użytkownika.

Nie podłączano tego fundamentu do ekranu, routera ani shella. Jest to celowe:
globalny shell ma zostać przebudowany dopiero po zamknięciu kontraktu drzewa
projektów i testów danych.

## Zasady wejściowe z design spec

Źródło: `docs/design/gmail-inspired-design-spec.md`.

Przyszła implementacja UI musi zachować:

1. zarezerwowaną belkę o wysokości około 64 px;
2. zwijany sidebar 256 px rozwinięty / 64–72 px zwinięty, z własnym scrollem;
3. content z marginesem 12–16 px i promieniem około 20 px;
4. wiersz menu około 36 px, ikonę około 20 px i hierarchię z wcięciami;
5. pełne drzewo workspace → projekty → zasoby, a nie pięć ogólnych przycisków;
6. Chat i powiadomienia jako panele globalne poniżej belki, bez zmiany trasy;
7. brak nakładania modali/paneli na zarezerwowaną belkę.

W I2 nie zmieniano wizualnego UI, ponieważ nie ma jeszcze kompletnego źródła
projektów, a zadanie zabraniało podłączać nowego menu na danych zastępczych.

## Graf istniejących źródeł

### Produkcyjny lokalny fragment

```text
DevPlannerRouter
  └─ DevPlannerWorkspacesPage
       └─ DevPlannerWorkspacesCubit
            └─ WorkspacesGateway
                 └─ DevPlannerWorkspacesGateway
                      └─ DevPlannerHttpTransport
                           └─ GET /api/v1/workspaces/?includeHidden=false
```

Istotne pliki:

- `lib/workspaces/domain/models/workspace_summary.dart` — lokalny model
  `WorkspaceSummary`;
- `lib/workspaces/domain/ports/workspaces_gateway.dart` — lokalny port,
  typowane powody błędu i status backendu;
- `lib/workspaces/data/standalone/workspaces_gateway.dart` — lokalny adapter
  HTTP i parser odpowiedzi;
- `lib/workspaces/presentation/cubit/devplanner_workspaces_cubit.dart` —
  obecny Cubit listy workspace’ów;
- `lib/workspaces/presentation/devplanner_workspaces_page.dart` — obecny
  ekran katalogu (siatka, nie docelowe menu Gmail-like);
- `lib/app/router/devplanner_router.dart` — nadal buduje trasę `/workspaces`;
- `lib/app/shell/devplanner_shell.dart` — obecny cienki shell z topbarem,
  NavigationRail i panelem Chat.

### Fragment niedopuszczony do nowego fundamentu

```text
WorkspaceProjectMenu
  └─ WorkspaceProjectsCubit
       └─ ProjectsRepository
            └─ ProjectsRepositoryImpl
                 ├─ package:ready_next/core/data/api_repository.dart
                 ├─ package:ready_next/.../ProjectListItem
                 ├─ package:ready_next/.../ProjectsApi
                 └─ generated Retrofit DTO
```

To nie jest jeszcze lokalny kontrakt DevPlanner. Nie podmieniano importów
mechanicznie i nie wciągano tego grafu do nowego portu.

### Niedopuszczony legacy UI

- `lib/workspaces/presentation/workspace_shell/navigation/workspace_static_menu.dart`
  importuje `ready_next` theme/l10n/shared widgets;
- `lib/workspaces/presentation/workspaces_home/directory_menu/workspace_directory_menu.dart`
  importuje stare route paths, Cubity, menu i dialogi;
- `lib/workspaces/presentation/workspaces_home/projects_tree/workspace_project_menu.dart`
  zawiera legacy router, repository, dialogi i `ready_next` modele;
- `lib/workspaces/presentation/workspaces_home/projects_tree/widgets/project_resource_menu_branch.dart`
  buduje ścieżki bezpośrednio w UI i również importuje `ready_next`.

Pliki te były wyłącznie audytowane. Nie kopiowano ich i nie modyfikowano.

## Mapa menu → nowy kontrakt

| Stara pozycja/funkcja | Docelowy typ w drzewie | Stan I2 | Warunek podłączenia |
| --- | --- | --- | --- |
| Przegląd workspace’ów | `overview` | gotowe jako model | lokalny `WorkspaceSummary` |
| Zadania osobiste | `personalTasks` | gotowe jako węzeł semantyczny | nowy routing/shell |
| Pliki osobiste | `personalFiles` | gotowe jako węzeł semantyczny | nowy routing/shell |
| Workspace | `workspace` | gotowe | `WorkspacesGateway` |
| Projekty workspace’u | `projects` | struktura gotowa, dane oczekują | lokalny `ProjectsGateway` |
| Projekt | `project` | typ zarezerwowany, bez fikcyjnych danych | lokalny list project response + mapper |
| Zadania | `tasks` | typ zarezerwowany | lokalny projekt i route contract |
| Kanban | `kanban` | typ zarezerwowany | lokalny projekt i Kanban contract |
| Whiteboardy | `whiteboards` | typ zarezerwowany | local whiteboard contract |
| Corkboard | `corkboard` | typ zarezerwowany | local corkboard contract |
| Wiki | `wiki` | typ zarezerwowany | local wiki contract |
| Pliki projektu | `files` | typ zarezerwowany | local storage scope/route contract |
| Automatyzacje | `automations` | typ zarezerwowany | local automation contract |
| Chat | overlay, nie węzeł trasy | poza I2 | istniejąca kompozycja + shell overlay |
| Powiadomienia | overlay, nie węzeł trasy | poza I2 | istniejąca kompozycja + shell overlay |

## Zmienione pliki

Nowe pliki:

- `lib/workspaces/domain/navigation/workspace_navigation_node.dart` — enumy i
  immutable semantic node;
- `lib/workspaces/domain/navigation/workspace_navigation_tree.dart` — budowa
  snapshotu z realnych `WorkspaceSummary` i pełna lista resource kinds;
- `lib/workspaces/domain/navigation/navigation_export.dart` — eksport domeny;
- `lib/workspaces/presentation/navigation/workspace_navigation_export.dart` —
  osobny eksport nowego fundamentu, bez dołączania legacy navigation barrel;
- `lib/workspaces/domain/ports/workspace_navigation_gateway.dart` — wąski
  port drzewa;
- `lib/workspaces/data/standalone/workspace_navigation_gateway.dart` — adapter
  istniejącego `WorkspacesGateway`, bez nowego I/O;
- `lib/workspaces/presentation/navigation/cubit/workspace_navigation_state.dart`
  — sealed state z typowanym błędem;
- `lib/workspaces/presentation/navigation/cubit/workspace_navigation_cubit.dart`
  — mały Cubit ładowania drzewa;
- `test/workspaces/presentation/navigation/workspace_navigation_foundation_test.dart`
  — test sortowania/pending source/Cubit failure.

Nie zmodyfikowano istniejącego `navigation_export.dart`, ponieważ eksportuje
legacy Cubity i nie może stać się zależnością nowego fundamentu. Żaden nowy
zmieniony plik nie importuje `package:ready_next`. Nie dodano aliasów,
globalnych funkcji ani logiki HTTP do UI.

## Najważniejsza blokada i następny krok

Nie wolno podłączać `ProjectsRepository` do tego fundamentu przed wykonaniem
osobnej migracji kontraktu projektów:

1. zdefiniować lokalny `ProjectListItem` bez importów `ready_next`;
2. zdefiniować lokalne enumy status/visibility/role albo przenieść ich realne
   kontrakty do `devplanner`;
3. zdefiniować lokalny `ProjectsGateway` z `listProjects(workspaceId)`;
4. dodać parser/mapping odpowiedzi C# i testy braku enumeracji dostępu;
5. dopiero potem dodać `project` nodes i resource children do
   `WorkspaceNavigationTree`;
6. dopiero po tym podłączyć nowy shell/sidebar do Cubita.

Nie należy rozwiązywać tej blokady przez:

- masową zamianę `package:ready_next` na `package:devplanner`;
- kopiowanie `WorkspaceProjectMenu` lub `WorkspaceDirectoryMenu`;
- tworzenie przykładowych projektów w kodzie produkcyjnym;
- przywracanie starego routera, Core, Ready ani DataBus;
- dodawanie osobnej głównej trasy Chat/Notifications.

## Walidacja

Wykonano po zmianach:

```text
dart format --output=none \
  lib/workspaces/domain/navigation \
  lib/workspaces/domain/ports/workspace_navigation_gateway.dart \
  lib/workspaces/data/standalone/workspace_navigation_gateway.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_cubit.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_state.dart \
  lib/workspaces/presentation/navigation/workspace_navigation_export.dart \
  test/workspaces/presentation/navigation/workspace_navigation_foundation_test.dart
PASS — 9 files, no changes needed

flutter test \
  test/workspaces/presentation/navigation/workspace_navigation_foundation_test.dart
PASS — 3 tests

flutter analyze \
  lib/workspaces/domain/navigation \
  lib/workspaces/domain/ports/workspace_navigation_gateway.dart \
  lib/workspaces/data/standalone/workspace_navigation_gateway.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_cubit.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_state.dart \
  test/workspaces/presentation/navigation/workspace_navigation_foundation_test.dart
PASS — No issues found

git diff --check
PASS
```

Repozytorium było już mocno zmodyfikowane przed rozpoczęciem (w tym usunięte
legacy pliki aplikacji i stare importy). Nie wykonywano `restore`, `clean`,
`reset`, `checkout`, commit ani push; nie zmieniano cudzych plików.
