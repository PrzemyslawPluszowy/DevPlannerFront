# R3 — root router compile

Data: 2026-09-17  
Zakres: tylko Front; bez zmian w Backend, bez commit/push i bez zmian w
`docs/devplanner-standalone-refactor-plan.md` ani handoffie.

## Cel

Przywrócić kompilowalny graf `bootstrap → DevPlannerApp → router → shell` i
udostępnić wyłącznie trasy, dla których istnieje rzeczywisty ekran oraz
kompozycja danych. Nie dodano atrap stron.

## Wykonane zmiany

- Dodano lokalny, typowany port `WorkspacesGateway`, model `WorkspaceSummary`,
  adapter HTTP `GET /api/v1/workspaces/` oraz `DevPlannerWorkspacesCubit`.
- Dodano `DevPlannerWorkspacesPage`, który renderuje dane z backendu, stan
  pusty, błąd HTTP i ponowienie. Brak transportu kończy się jawnym błędem
  konfiguracji, a nie fikcyjną listą.
- Router używa teraz tylko realnych tras rootu:
  `/login`, `/auth/activate`, `/auth/reset`, `/auth/mfa`, `/workspaces`, `/me`
  oraz `/admin`.
- Usunięto z osiągalnego grafu placeholderowe trasy workspace/project/task/
  file/wiki/whiteboard oraz `/storage`.
- Usunięto z rootowego menu i kompozycji Chat/Notifications, ponieważ aktualne
  strony prezentacyjne tych funkcji importują `package:ready_next` i nie są
  jeszcze standalone. Nie dodano „unavailable” stron jako substytutu.
- Bootstrap i `DevPlannerApp` nie tworzą już niekompilowalnego, legacy runtime
  Chat/Notifications. Ich przyszłe podłączenie wymaga osobnego pakietu
  migracji UI/domain do lokalnych kontraktów.
- Shell zawiera wyłącznie osiągalne `/workspaces` i `/me`; `/admin` pozostaje
  dostępne przez jawny route, z istniejącym fail-closed `/me`/BFF gate.

## Dowody

### Scoped analyze

Polecenie:

```bash
dart analyze lib/main.dart lib/bootstrap/app_bootstrap.dart \
  lib/app/devplanner_app.dart lib/app/router/devplanner_router.dart \
  lib/app/shell/devplanner_shell.dart \
  lib/workspaces/domain/models/workspace_summary.dart \
  lib/workspaces/domain/ports/workspaces_gateway.dart \
  lib/workspaces/data/standalone/workspaces_gateway.dart \
  lib/workspaces/presentation/cubit/devplanner_workspaces_cubit.dart \
  lib/workspaces/presentation/devplanner_workspaces_page.dart
```

Wynik: **No issues found!**. Jedno-metodowy port jest jawnie oznaczony jako
celowy, aby presentation nie zależało od transportu.

### Router tests

Polecenie:

```bash
flutter test \
  test/app/router/devplanner_root_router_compile_test.dart \
  test/app/router/devplanner_router_test.dart
```

Wynik: **10/10 PASS**. Testy obejmują auth guard, deep-link validation, admin
composition, realny workspace gateway route oraz fakt, że niezaimplementowane
Chat/Notifications/Storage nie są osiągalnymi trasami rootu.

### macOS build

Polecenie:

```bash
flutter build macos --debug
```

Wynik: **PASS** — `build/macos/Build/Products/Debug/DevPlanner.app`.
Flutter zgłosił jedynie istniejące ostrzeżenie pluginów bez obsługi Swift
Package Manager (`media_kit_libs_macos_video`, `media_kit_video`); nie blokuje
to tego buildu.

### Diff hygiene

Polecenia:

```bash
dart format lib/app lib/bootstrap/app_bootstrap.dart \
  lib/workspaces/data/standalone/workspaces_gateway.dart \
  lib/workspaces/domain/models/workspace_summary.dart \
  lib/workspaces/domain/ports/workspaces_gateway.dart \
  lib/workspaces/presentation/cubit/devplanner_workspaces_cubit.dart \
  lib/workspaces/presentation/devplanner_workspaces_page.dart \
  test/app/router/devplanner_root_router_compile_test.dart
git diff --check
```

Wynik: formatowanie bez błędów; `git diff --check` bez błędów whitespace.

## Ograniczenia i następny pakiet

Pełny `flutter analyze` repozytorium nadal obejmuje odziedziczone, nieosiągalne
pliki importujące `package:ready_next` oraz usunięte testy/moduły. Nie jest to
część R3-root-router-compile i nie zostało „naprawione” przez przywracanie
legacy zależności.

Następnym pakietem powinno być osobne standalone UI/data dla Chat i
Notifications (z lokalnym `UserId`, typed ports i cookie/BFF albo desktop
transportem), po czym można ponownie dodać te trasy oraz globalne akcje do
shella. Storage, projekty, zadania, Kanban, Wiki i Whiteboard pozostają poza
osiągalnym root routerem do czasu dostarczenia prawdziwych ekranów z lokalnymi
kontraktami.
