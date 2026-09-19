# I2c — kompozycja drzewa workspace → projekty

Data: 2026-09-17  
Repozytorium: `Front`  
Zakres: clean domena/presentation; bez legacy UI, routera, shella i Backend.

## Wynik

Po zaakceptowanym I2 i I2b istnieją dwa niezależne, typowane porty:
`WorkspaceNavigationGateway` zwracający lokalne `WorkspaceSummary` oraz
`ProjectsGateway` zwracający lokalne `ProjectListItem`. I2c połączył je w
`WorkspaceNavigationTreeCubit`, który buduje jeden spójny snapshot drzewa.

Po udanym odczycie każdy workspace ma dokładnie jedną gałąź `projects`, a
projekty są materializowane wyłącznie pod workspace’em z tym samym UUID.
Projekt ma semantyczny węzeł `project`, `projectId`, nazwę z kontraktu i
`isDataPending: true` dla jego zasobów. Nie dodano fikcyjnych zadań, Kanbanów,
plików ani innych dzieci projektu.

Awaria katalogu projektów nie emituje częściowego drzewa ani danych zastępczych.
Stan zachowuje źródło awarii, workspace UUID, powód typowany, status HTTP, kod,
komunikat i `traceId` (jeżeli dostarczył je adapter). Odrzucono również
odpowiedź z projektem należącym do innego workspace’u oraz duplikatem ID.

## Pliki w zakresie I2c

Zmodyfikowane/dodane w clean graph:

- `lib/workspaces/domain/navigation/workspace_navigation_tree.dart` — nowa
  fabryka `fromWorkspacesWithProjects` oraz bezpieczne materializowanie węzłów
  projektów;
- `lib/workspaces/presentation/navigation/cubit/workspace_navigation_tree_cubit.dart`
  — kontroler kompozycji portów, bez HTTP, routingu i widgetów;
- `lib/workspaces/presentation/navigation/cubit/workspace_navigation_tree_state.dart`
  — stany initial/loading/ready oraz typowane źródła błędu;
- `lib/workspaces/presentation/navigation/workspace_navigation_export.dart` —
  eksport kontrolera i stanu clean;
- `test/workspaces/presentation/navigation/workspace_navigation_tree_cubit_test.dart`
  — testy materializacji, zakresu workspace, pustej listy, błędów 403/401 i
  odpowiedzi o złym scope.

Wszystkie nowe bezpośrednie importy używają `package:devplanner`; skan
`ready_next`/`core` dla zakresu I2c zwrócił 0 wyników.

## Inwarianty

- kolejność workspace’ów pozostaje: przypięte, następnie nazwa;
- globalne węzły `overview`, `personal-tasks` i `personal-files` pozostają
  przed workspace’ami;
- `projects` jest nagłówkiem nieklikalnym;
- brak wpisu workspace w mapie projektu oznacza `isDataPending`, nie pustą
  udawaną odpowiedź;
- dzieci zasobów projektu nie są tworzone przed osobnym kontraktem danych;
- nieznane klucze mapy projektów nie mogą wprowadzić węzła do drzewa;
- snapshot nie jest emitowany po błędzie żadnego workspace’u/projektu.

## Zakres odrzucony

Celowo nie zmieniono:

- `workspaces_home`, starego menu i starych Cubitów;
- root routera, app shella, topbara ani wizualnego Gmail-like UI;
- Chat/Notifications — pozostają globalnymi overlayami na późniejszy etap;
- Kanban, files/storage, realtime i kontrakt Backend;
- żadnego routingu, API, transportu ani placeholderowych projektów.

Następny krok może podać ten snapshot do nowego, dopiero budowanego
collapsible sidebara. Nie należy podłączać do niego legacy `ProjectsRepository`
ani renderować węzłów zasobów bez ich lokalnych kontraktów.

## Liczniki przed/po

| Kontrola | Przed I2c | Po I2c |
| --- | ---: | ---: |
| Clean controller kompozycji portów | 0 | 1 |
| Fabryka drzewa z listą projektów | 0 | 1 |
| Testy tego pionu | 0 | 5 |
| Nowe bezpośrednie importy `ready_next`/`core` | 0 | 0 |
| Zmieniony router/shell/legacy UI | 0 | 0 |

## Walidacja

Uruchomiono w repozytorium `Front`:

```text
dart format \
  lib/workspaces/domain/navigation/workspace_navigation_tree.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_tree_cubit.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_tree_state.dart \
  lib/workspaces/presentation/navigation/workspace_navigation_export.dart \
  test/workspaces/presentation/navigation/workspace_navigation_tree_cubit_test.dart
PASS — Formatted 5 files (0 changed) in 0.03s

flutter analyze \
  lib/workspaces/domain/navigation/workspace_navigation_tree.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_tree_cubit.dart \
  lib/workspaces/presentation/navigation/cubit/workspace_navigation_tree_state.dart \
  lib/workspaces/presentation/navigation/workspace_navigation_export.dart \
  test/workspaces/presentation/navigation/workspace_navigation_tree_cubit_test.dart
PASS — No issues found! (ran in 2.8s)

flutter test \
  test/workspaces/presentation/navigation/workspace_navigation_tree_cubit_test.dart
PASS — 5 tests passed

git diff --check
PASS
```

Nie wykonano `restore`, `clean`, `reset`, `checkout`, commit ani push. Backend
pozostaje nietknięty.
