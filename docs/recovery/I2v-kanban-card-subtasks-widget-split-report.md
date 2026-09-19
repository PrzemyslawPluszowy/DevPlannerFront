# I2v — rozdzielenie podzadań karty Kanbana

## Cel

Rozdzielono monolityczny plik prezentacji podzadań karty Kanbana, aby przywrócić
czytelną strukturę drzewa i limit 400 linii na plik. Zachowano publiczny punkt
wejścia `KanbanCardSubtasksSection`, istniejące klucze testowe oraz wszystkie
interakcje: rozwijanie, odświeżanie realtime, paginację, dodawanie podzadania,
zmianę statusu, menu kontekstowe, skróty klawiaturowe i przejście do szczegółu.

## Zmieniona struktura

- `lib/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart`
  - pozostaje publicznym punktem wejścia sekcji;
  - zawiera stan rozwijania, cykl życia Cubita oraz nagłówek sekcji;
  - pełni rolę małej biblioteki prezentacji z częściami współdzielącymi
    prywatne symbole.
- `lib/workspaces/presentation/tasks/board/cards/subtasks/kanban_card_subtasks_content.dart`
  - zawiera rozszerzenie stanu odpowiedzialne za zawartość rozwiniętą:
    ładowanie, błąd, listę, paginację i formularz dodawania;
  - nie pobiera danych i nie zna HTTP — korzysta wyłącznie z Cubita.
- `lib/workspaces/presentation/tasks/board/cards/subtasks/kanban_card_subtasks_support.dart`
  - zawiera listener opcjonalnego stanu planszy, skeleton, wiersz podzadania,
    skróty/menu statusu i awatar wykonawcy;
  - lokalna klasa `KanbanSubtaskAvatarColors` izoluje prezentacyjne kolory
    awatarów bez dodawania globalnej funkcji.

Plik `tasks_board_page.dart` importuje oraz eksportuje dawny publiczny punkt
wejścia, więc istniejące użytkowania i testy nie musiały zmieniać importu.

## I2v.1 — zgodność z zasadą lokalnego stanu UI

Po dodatkowym przeglądzie usunięto wszystkie `setState` z nowego drzewa
podzadań. Stan krótkotrwały sekcji (`expanded`, formularz dodawania i focus
wiersza) jest utrzymywany przez `ValueNotifier` i renderowany przez
`ValueListenableBuilder`; notifiery są zwalniane w `dispose`.

Logikę zmiany statusu wydzielono z Cubita do części
`kanban_subtasks_status_mutation.dart`. Dzięki temu główny Cubit ma 344 linie,
a odpowiedzialność za mutację statusu pozostaje w jego rozszerzeniu. Rozszerzenie
nie wywołuje chronionego `emit` bezpośrednio: korzysta z wąskiego
`_emitMutationState` zdefiniowanego w Cubicie, który sprawdza `isClosed` przed
emisją. Nie utworzono drugiego serwisu ani globalnej funkcji.

Skan `setState` dla nowych plików pionu (`tasks_board_card_subtasks.dart`,
`cards/subtasks/**`) nie zwraca wyników. Istniejące `setState` w
`tasks_board_page.dart` należą do niezależnego, starszego zakresu planszy i nie
zostały wprowadzone ani zmienione przez I2v.1.

## Kontrola jakości

Wszystkie pliki pionu mają mniej niż 400 linii:

| Plik | Linie |
| --- | ---: |
| `tasks_board_card_subtasks.dart` | 297 |
| `kanban_card_subtasks_content.dart` | 300 |
| `kanban_card_subtasks_support.dart` | 345 |
| `kanban_subtasks_cubit.dart` | 344 |
| `kanban_subtasks_status_mutation.dart` | 112 |

Wykonano ponownie:

```text
flutter analyze \
  lib/workspaces/presentation/tasks/board/tasks_board_page.dart \
  lib/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart \
  lib/workspaces/presentation/tasks/board/cards/subtasks/kanban_card_subtasks_content.dart \
  lib/workspaces/presentation/tasks/board/cards/subtasks/kanban_card_subtasks_support.dart \
  lib/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart \
  lib/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_status_mutation.dart
No issues found!

flutter test \
  test/workspaces/presentation/tasks/board/kanban_card_interactions_test.dart \
  test/workspaces/presentation/tasks/board/kanban_card_visual_reset_test.dart
All tests passed! (11 tests)

git diff --check
OK
```

Zakres zmian nie zawiera importów `ready_next`, `devplanner/core` ani
`InvalidType`. Nie dodano połączeń API do warstwy UI, globalnych funkcji ani
nowego Cubita. Skan `setState` w nowych plikach zwraca pusty wynik.

## Uwagi dla kolejnego agenta

Nie przenosić z powrotem kodu z części do pliku głównego bez ponownego
sprawdzenia limitu 400 linii. Przy zmianach zachować import/eksport w
`tasks_board_page.dart`, ponieważ starsze testy i konsumenci korzystają z tego
pliku jako publicznego wejścia do `KanbanCardSubtasksSection`.
