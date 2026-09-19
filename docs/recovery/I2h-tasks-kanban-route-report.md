# I2h — real desktop Tasks/Kanban route

## Cel

Podłączono rzeczywistą stronę Tasks/Kanban do nowego routera DevPlanner i do
drzewa menu. Węzły Tasks/Kanban są aktywne wyłącznie wtedy, gdy istnieje
bezpieczna, desktopowa `TasksBoardComposition`; przeglądarka BFF nie dostaje
pozornej obsługi realtime.

## Zmienione pliki

- `lib/app/router/devplanner_router.dart`
  - dodano trasę `/workspaces/:workspaceId/projects/:projectId/tasks`;
  - `view=kanban` jest przekazywane jako `initialView`;
  - identyfikatory workspace i projektu przechodzą przez ścisłą walidację UUID;
  - trasa tworzy `TasksBoardRoutePage` tylko z
    `TasksBoardComposition.fromTransport` albo z jawną kompozycją hosta;
  - brak kompozycji kończy się stanem fail-closed, bez mocków i danych
    zastępczych.
- `lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart`
  - nowy cienki composition widget wystawiający do Boardu wyłącznie typowane
    repozytoria oraz lokalny `AuthSessionPort`;
  - nie zawiera HTTP, tokenów ani logiki biznesowej;
  - `TasksBoardTransportUnavailablePage` jest używany tylko poza normalną
    ścieżką desktopową, gdy BFF nie może dostarczyć tokenu SignalR.
- `lib/app/shell/devplanner_shell.dart`
- `lib/app/shell/devplanner_shell_layout.dart`
- `lib/app/shell/devplanner_shell_navigation.dart`
  - shell otrzymuje flagę dostępności rzeczywistego Boardu;
  - tylko węzły `tasks` i `kanban` z poprawnymi UUID oraz dostępną kompozycją
    dostają callback nawigacyjny;
  - pozostałe przyszłe zasoby nadal są widoczne jako nieklikalne w drzewie;
  - ścieżki budowane są przez `DevPlannerRouteCatalog`, bez duplikowania
    kontraktu routingu.
- `test/app/router/devplanner_root_router_compile_test.dart`
  - test desktopowego transportu, realnych workspace/project UUID i kliknięcia
    w węzeł Kanban; sprawdza kanoniczny URL z `view=kanban`.

## Granice bezpieczeństwa i architektury

- `TasksBoardComposition.fromTransport` pozostaje źródłem prawdy: desktop z
  providerem access tokenu tworzy pełny graf repozytoriów i realtime, a webowy
  BFF zwraca `null`, ponieważ nie udostępnia tokenu SignalR po stronie Fluttera.
- Router nie przyjmuje niezaufanych identyfikatorów jako scope'u API: oba
  parametry muszą być UUID wersji 1–5 z poprawnym wariantem.
- Widget trasy przekazuje porty przez provider; transport i adaptery pozostają
  w warstwie data/composition.
- Nie zmieniano Backend, Chat, Notifications, Files ani implementacji Boardu;
  istniejące stany loading/error/403/conflict/retry pozostają własnością
  obecnych cubitów i repozytoriów.

## Walidacja

Wykonano w katalogu `Front`:

```text
dart format lib/app/router/devplanner_router.dart \
  lib/app/shell/devplanner_shell.dart \
  lib/app/shell/devplanner_shell_layout.dart \
  lib/app/shell/devplanner_shell_navigation.dart \
  lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart \
  test/app/router/devplanner_root_router_compile_test.dart

flutter analyze \
  lib/app/router/devplanner_router.dart \
  lib/app/shell/devplanner_shell.dart \
  lib/app/shell/devplanner_shell_layout.dart \
  lib/app/shell/devplanner_shell_navigation.dart \
  lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart \
  test/app/router/devplanner_root_router_compile_test.dart
```

Wynik analizatora: `No issues found!`.

```text
flutter test \
  test/workspaces/data/projects/tasks/tasks_board_composition_test.dart \
  test/app/shell/devplanner_shell_test.dart \
  test/app/router/devplanner_root_router_compile_test.dart
```

Wynik: wszystkie testy przeszły (`12` testów w tej paczce). Dodatkowo
`git diff --check` zakończył się bez błędów.

Test routingu celowo nie wykonuje sieciowego `pump` po wejściu do Boardu;
sprawdza kliknięcie i kanoniczny URL bez uruchamiania niekontrolowanego requestu
do lokalnego backendu. Rzeczywista kompozycja desktop/BFF jest sprawdzona
osobnym `tasks_board_composition_test.dart`. Pełny test UI z atrapą transportu
HTTP należy dodać razem z testowym portem preferencji lokalnych, zanim zostanie
włączony do automatycznej macierzy E2E.

## Następny krok

Uruchomić ręczny desktop flow z backendem: workspace → projekt → Kanban oraz
zweryfikować odpowiedzi 200, 403, 409 i retry na prawdziwych kontraktach C#.
Web/BFF pozostawić bez klikalnego Tasks/Kanban do czasu uzgodnienia osobnego
kontraktu realtime opartego o cookie/CSRF.
