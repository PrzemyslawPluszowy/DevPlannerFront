# I1a — Workspace Home i navigation tree: raport migracji importów

## Zakres

Batch obejmował wyłącznie `lib/workspaces/presentation/workspaces_home`,
`lib/workspaces/presentation/navigation` oraz odpowiadające im testy. Nie
zmieniano globalnego shellu/routera, backendu, zadań, plików, czatu ani
powiadomień.

## Wynik

- Przed zmianą 24 pliki w zakresie zawierały bezpośrednie importy
  `package:ready_next` (w tym importy `core`, starego routera oraz modeli i
  repozytoriów Workspace).
- Importy foundation przełączono na canonical `devplanner/foundation`.
- Importy domenowe i prezentacyjne przełączono na `devplanner/...`.
- Stary kontrakt `context.router` zastąpiono `DevPlannerNavigation`;
  obserwację zmian trasy oparto na `GoRouter.of(context).routerDelegate`.
- Leniwe ładowanie projektów korzysta teraz z `ProjectsGateway`, zgodnie z
  aktualnym portem domenowym, a testowa implementacja używa typed gateway
  failures.
- Nie dodano aliasów, suppressions ani sztucznych modeli. Nie podłączano
  starego ekranu Home do nowego routingu.

## Walidacja

Polecenia wykonane z katalogu Front:

```text
dart format lib/workspaces/presentation/workspaces_home \
  lib/workspaces/presentation/navigation \
  test/workspaces/presentation/workspaces_home \
  test/workspaces/presentation/navigation

flutter analyze lib/workspaces/presentation/workspaces_home \
  lib/workspaces/presentation/navigation \
  test/workspaces/presentation/workspaces_home \
  test/workspaces/presentation/navigation
```

Analyzer zakończył się wynikiem `No issues found!`; uporządkowano również
wszystkie diagnostyki `directives_ordering` w bezpośrednim zakresie I1a.

```text
flutter test test/workspaces/presentation/navigation --reporter compact
```

Wynik: wszystkie 17 testów navigation passed.

```text
git diff --check
```

Wynik: bez błędów whitespace.

## Ograniczenia i następny batch

Testy legacy Home nie przechodzą jeszcze jako samodzielny target, ponieważ
ich zależności poza zakresem nadal importują `ready_next`, m.in.:

- `lib/workspaces/shared/helpers/workspace_icon_helper.dart`,
- `lib/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart`,
- stare modele/repozytoria Workspace i ich odpowiedzi/payloady.

To jest osobny batch migracji zależności transytywnych. W tym batchu nie
przenoszono ich, aby nie rozszerzać zakresu na data/domain i inne ekrany.

Workspace Home nie jest obecnie kanonicznym ekranem nowego routingu; nowy
shell korzysta z własnego drzewa nawigacji. Naprawa przywraca integralność
źródeł i testów na granicy tego zakresu, ale nie oznacza ponownego podłączenia
starego wizualnego Home.
