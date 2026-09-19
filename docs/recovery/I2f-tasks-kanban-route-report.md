# I2f — Tasks/Kanban route boundary

Status: **future route contract documented; no runtime route or clickable placeholder**.

## Zakres wykonany

- Zachowano w `DevPlannerRouteCatalog` kanoniczne buildery przyszłej trasy:
  `/workspaces/:workspaceId/projects/:projectId/tasks?view=kanban`. Nie są one
  wpisane do runtime routera.
- Drzewo menu projektu materializuje dzieci `Tasks` i `Kanban` jako
  nieklikalne węzły przyszłego kontraktu. Shell nie prowadzi do placeholdera.
- Węzły innych zasobów pozostają nieklikalne, dopóki ich kontrakt i ekran nie
  zostaną złożone.
- Zaktualizowano testy drzewa, aby uwzględniały istniejące węzły `Files` oraz
  nowe, nieklikalne dzieci `Tasks`/`Kanban`.

## Dlaczego nie zintegrowano Boardu

Próba zamknięcia produkcyjnego composition rootu ujawniła wcześniejszy,
niezależny blocker w wygenerowanym pionie Retrofit/Freezed. W 33 już
zmodyfikowanych artefaktach (`projects_api.g.dart`, `task_advanced_api.g.dart`,
`task_operations_api.g.dart`, `task_templates_api.g.dart`,
`task_views_api.g.dart`, `task_capacity_api.g.dart` i inne) generator zostawił
typ `InvalidType`. Przykłady błędów kompilacji:

```text
Error: Type 'InvalidType' not found.
Future<List<InvalidType>> listProjects(...)
Future<InvalidType> getWorkflow(...)
InvalidType.fromJson(...)
```

Przyczyna dotyczy istniejących zmian źródeł/generatora, nie granicy I2f.
Composition wymagałby bezpośrednich konstruktorów `ProjectsApi`,
`TaskAdvancedApi`, `TaskOperationsApi`, `TaskTemplatesApi`, `TaskViewsApi`,
`TaskCapacityApi` i ich adapterów. W obecnym stanie wciąga to nierozwiązywalne
artefakty do kompilacji. Nie dodano aliasu `InvalidType`, nie pominięto błędów
i nie użyto mocków jako produkcyjnego obejścia.

Nie dodano runtime route ani `TasksBoardRouteUnavailablePage`, aby nie
udokumentować niekompilowalnej ścieżki jako dostępnej funkcji. Następny pakiet
powinien najpierw odtworzyć artefakty generatora z aktualnych, istniejących
modeli i przejść osobny targeted analyze/test pionu Tasks/Kanban. Dopiero
potem można podłączyć repository providers do `TasksBoardPage`.

## Pliki

- `lib/app/router/devplanner_router.dart` — przyszłe buildery URL; brak wpisu
  Tasks/Kanban w runtime routerze.
- `lib/app/shell/devplanner_shell_navigation.dart` — Tasks/Kanban pozostają
  nieklikalne.
- `lib/workspaces/domain/navigation/workspace_navigation_tree.dart` — dzieci
  projektu Tasks/Kanban.
- `test/app/shell/devplanner_shell_test.dart` — dowód, że kliknięcie przyszłego
  Kanban nie zmienia trasy.
- `test/workspaces/presentation/navigation/workspace_navigation_foundation_test.dart`
  oraz `workspace_navigation_tree_cubit_test.dart` — testy struktury drzewa.

Nie zmieniano Backend, Chat, Notifications, legacy `workspaces_home` ani
implementacji Boardu.

## Walidacja

- `dart format` — PASS dla plików I2f i testów.
- Scoped `flutter analyze` — PASS, `No issues found!`.
- `flutter test test/app/router/devplanner_root_router_compile_test.dart` —
  **6/6 PASS** po usunięciu placeholderowej trasy.
- `flutter test` dla navigation foundation, navigation tree i shell —
  **12/12 PASS**, w tym dowód nieklikalności przyszłego Kanban.
- `git diff --check` — PASS.

Nie uruchamiano generatora ani nie naprawiano 33 cudzych artefaktów w tym
pakiecie. R01 staging hash: **nie dotyczy** — I2f nie używał materiału R01.

## Następny krok

Naprawić i zweryfikować wygenerowane artefakty Tasks/Projects (bez aliasów i
masowego ignorowania błędów), następnie dodać jawny `TasksBoardComposition`
oparty o `DevPlannerHttpTransport` i `WorkspaceScopedRealtimeFactory`, z
providerami dla istniejących repository interfaces. Dopiero po tym można
dodać trasę i klikalne węzły. Web bez tokenowego realtime ma pozostać
fail-closed; desktop może otworzyć Board dopiero po potwierdzeniu transportu i
testu 403/not-found.
