# I2x — rozdzielenie Cubita listy zadań

## Cel

`ProjectTasksListCubit` miał 1702 linie i łączył w jednym miejscu ładowanie
cursorowe, redukcję realtime, mutacje wierszy, podzadania, selekcję oraz akcje
bulk. Taki układ utrudniał testowanie i był sprzeczny z zasadą cienkiej warstwy
prezentacji. Publiczne API Cubita zostało zachowane, aby istniejące strony i
wiersze listy nie musiały zmieniać kontraktu.

## Zmieniona struktura

Cubitem nadal zarządza wyłącznie strumieniem stanu, zależnościami i stanem
koordynacyjnym. Operacje są wydzielone do osobnych, nazwanych odpowiedzialności
w katalogu `lib/workspaces/presentation/tasks/list/cubit/`:

| Plik | Odpowiedzialność | Linie |
|---|---|---:|
| `project_tasks_list_cubit.dart` | kontrakt hosta, zależności, stan realtime, publiczne API bazowe i lifecycle | 341 |
| `task_list_realtime_mixin.dart` | redukcja aktualizacji SignalR, deduplikacja wersji, przenoszenie między grupami | 218 |
| `task_list_loading_mixin.dart` | doładowanie listy i grup cursorowych | 200 |
| `task_list_creation_mixin.dart` | tworzenie zadania głównego | 239 |
| `task_list_mutation_mixin.dart` | przenoszenie, cykliczność i własne pola | 287 |
| `task_list_selection_mixin.dart` | zaznaczanie, zakresy i mutacje bulk | 234 |
| `task_list_item_mutation_mixin.dart` | archiwizacja, assignee, przypięcie, obserwowanie i etykiety | 262 |
| `task_list_subtasks_mixin.dart` | rozwijanie, cache i doładowanie podzadań | 55 |

Każdy plik ma mniej niż 400 linii. Mixin działa wyłącznie przez jawny
`ProjectTasksListCubitPort`; nie ma dostępu do `BuildContext`, routera ani
globalnego API. Dostęp do repozytoriów pozostaje w warstwie data/domain —
operacje listy nie wykonują HTTP bezpośrednio.

## Zachowane zachowanie

- filtry, grupowanie i `updateGroupBy`;
- ładowanie początkowe, odświeżenie i paginacja listy/grup;
- deduplikacja i ochrona wersji przy realtime;
- optymistyczna edycja komórek z rollbackiem i obsługą konfliktu;
- tworzenie root taska i podzadań;
- rozwijanie/cache/doładowanie podzadań;
- selekcja pojedyncza, zakresowa, grupowa i selekcja podzadań;
- bulk dla załadowanych rekordów i dla całego wyniku przez token;
- move, recurrence, custom fields, archiwizacja, assignee, pin, watching oraz
  labels;
- anulowanie timera realtime podczas `close()`.

## Walidacja

Uruchomiono:

```text
flutter analyze lib/workspaces/presentation/tasks/list/cubit
No issues found!

flutter test \
  test/workspaces/presentation/tasks/list/project_tasks_list_cubit_test.dart \
  test/workspaces/presentation/tasks/list/project_tasks_list_flow_test.dart \
  test/workspaces/presentation/tasks/list/cubit/task_list_snapshot_test.dart \
  test/workspaces/presentation/tasks/list/cubit/task_list_selection_test.dart
70 testów — All tests passed!
```

Zakres zmiany sprawdzono także przez:

```text
rg -n 'setState|package:ready_next|package:devplanner/core' \
  lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart \
  lib/workspaces/presentation/tasks/list/cubit/task_list_*_mixin.dart
```

Wynik: brak dopasowań. W wydzielonym kodzie nie użyto `setState`, importów
`ready_next` ani starego `core`.

## Uwaga dla kolejnego agenta

Przed kolejnymi zmianami nie przenosić logiki z powrotem do Cubita. Nową akcję
dopisywać do odpowiedzialnego pliku operacyjnego, a jeśli przekracza 400 linii
— wydzielić kolejny koordynator. Każdą zmianę zakończyć zakresem `flutter
analyze`, testami Cubita oraz aktualizacją tego raportu lub nowym raportem w
`docs/recovery/`.

## Korekta po review

W `task_list_query.dart` przeniesiono `_groupByWireValue` i
`_involvementWireValue` do prywatnych metod statycznych `TaskListQuery`. Dzięki
temu plik nie zawiera funkcji na poziomie top-level, a mapowanie wartości
wire pozostało identyczne.

Po korekcie ponownie uzyskano `No issues found!` dla zakresu Cubit oraz
`70 testów — All tests passed!`. Skan funkcji top-level i `git diff --check`
nie wykazały problemów.
