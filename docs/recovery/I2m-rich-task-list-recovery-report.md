# I2m — odzyskanie bogatej listy zadań

## Zakres

Przywrócono do samodzielnego desktopowego wejścia Tasks dojrzałą listę
`ProjectTasksList`. Nie zmieniano routera, shella, Kanbana, plików, czatu ani
powiadomień. Backend nie został zmieniony.

## Co zostało połączone

- domyślna gałąź `TasksBoardRoutePage` używa teraz `ProjectTasksList`, a nie
  prymitywnej listy kart;
- route nadal dostaje wyłącznie repozytoria przez `MultiRepositoryProvider`;
  widok nie wykonuje HTTP/Dio bezpośrednio;
- lista zachowuje istniejące grupowanie, tabelę kolumnową, preferencje kolumn,
  inline create, podzadania, filtry i mutacje wierszy obsługiwane przez
  `ProjectTasksListCubit`;
- dla samodzielnej listy wyłączono jedynie listener `TasksBoardCubit`, którego
  ta strona nie posiada. Nie tworzono fikcyjnego providera ani fałszywego
  realtime;
- kompozycja desktopowa dostarcza prawdziwe `MilestoneRepository`, wymagane
  przez tabelę do pobierania metadanych kamieni milowych.

## Ważna naprawa kontraktu

Przy podpinaniu milestone API ujawniono uszkodzony wygenerowany plik
`milestones_api.g.dart` z `InvalidType` oraz źródłowe importy `ready_next`.
Zostały wygenerowane ponownie wyłącznie artefakty milestone i poprawiono ich
importy na `devplanner`. Nie maskowano `InvalidType` aliasem.

## Walidacja

Uruchomiono:

```text
dart run build_runner build --build-filter=lib/workspaces/data/projects/milestones/api/milestones_api.g.dart
flutter analyze lib/workspaces/data/projects/tasks/tasks_board_composition.dart \
  lib/workspaces/presentation/tasks/list/project_tasks_list.dart \
  lib/workspaces/presentation/tasks/list/table \
  lib/workspaces/presentation/tasks/list/cubit \
  lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart \
  test/workspaces/presentation/tasks/board/tasks_board_route_page_test.dart
flutter test test/workspaces/presentation/tasks/board/tasks_board_route_page_test.dart \
  test/workspaces/presentation/tasks/list/standalone_project_tasks_list_test.dart
git diff --check
```

Testy: **10 passed** (4 testy route i 6 testów standalone). Po uporządkowaniu
importów oraz usunięciu redundantnego argumentu dokładny zakres analyzer kończy
się komunikatem **No issues found!**. `InvalidType` nie występuje już w
`milestones_api.g.dart`. `git diff --check` przechodzi.

## Pozostałe prace listy

1. Przenieść importy `core/l10n` i `core/theme` z tabeli/cells do foundation,
   bez zmiany zachowania.
2. Dodać test trasy w trybie `initialView == null`, który stubuje prawdziwy
   kontrakt listy i potwierdza render tabeli po odpowiedzi API.
3. Podłączyć zapisane widoki i profile członków do samodzielnej listy, gdy
   route contract będzie już stabilny.
4. Dopiero potem prowadzić osobne migracje szczegółów zadania, delete/update
   oraz brakujących wygenerowanych rodzin API. Nie rozszerzać tego pionu o
   chat ani notifications.
