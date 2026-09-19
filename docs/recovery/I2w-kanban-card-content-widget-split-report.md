# I2w — rozbicie zawartości karty Kanban

## Zakres

Rozbito dotychczasowy plik `tasks_board_card_content.dart` (752 linie) bez
zmiany publicznego entry pointu `KanbanTaskCard`, aliasu
`KanbanDottedCardFrame` ani zachowania karty. Zmiana dotyczy wyłącznie
prezentacji karty Kanban. Nie zmieniano routingu, Files, Chat, Notifications,
podzadań karty ani kontraktów HTTP.

## Nowa struktura

- `tasks_board_card_content.dart` — cienki entry point karty i składanie sekcji;
- `cards/content/kanban_card_frame.dart` — obramowanie, hover, focus,
  zaznaczenie, semantyka oraz skróty klawiaturowe menu;
- `cards/content/kanban_card_identity.dart` — checkbox selekcji, kod,
  cykliczność, priorytet i menu akcji;
- `cards/content/kanban_card_metadata.dart` — metadane główne i szczegółowe,
  etykiety, pola niestandardowe, awatar oraz wskaźnik priorytetu.

Każdy plik ma mniej niż 400 linii (odpowiednio: 155, 158, 114 i 301).
`tasks_board_page.dart` włącza pliki przez `part`, więc prywatne elementy
pozostają prywatne dla biblioteki i nie powstało nowe globalne API.

## Zasady jakościowe

- zachowano klucze, semantykę, callbacki, uprawnienia i istniejące modele;
- nie dodano wywołań HTTP/API ani logiki biznesowej do widgetów;
- stan hover/focus jest krótkotrwałym stanem UI przez `ValueNotifier` i
  `AnimatedBuilder`/`ValueListenableBuilder`; w zmienionych plikach nie ma
  `setState`;
- nie dodano `ready_next`, `devplanner/core`, `InvalidType` ani globalnego
  stanu;
- zachowano istniejący alias kompatybilności `KanbanDottedCardFrame`.

## Walidacja

Wykonano:

```text
dart format <zmienione pliki>
flutter analyze lib/workspaces/presentation/tasks/board/tasks_board_page.dart \
  lib/workspaces/presentation/tasks/board/tasks_board_card_content.dart \
  lib/workspaces/presentation/tasks/board/cards/content/kanban_card_frame.dart \
  lib/workspaces/presentation/tasks/board/cards/content/kanban_card_identity.dart \
  lib/workspaces/presentation/tasks/board/cards/content/kanban_card_metadata.dart
```

Wynik analizy: `No issues found!`.

Próba testów:

```text
flutter test test/workspaces/presentation/tasks/board/kanban_card_interactions_test.dart \
  test/workspaces/presentation/tasks/board/kanban_card_visual_reset_test.dart \
  test/workspaces/presentation/tasks/board/kanban_baseline_audit_test.dart
```

Testy nie wystartowały z powodu istniejącego błędu kompilacji poza zakresem
I2w w `ProjectTasksListCubit`: niepoprawna kolejność `with`/`implements` oraz
brak metod wymaganych przez widok listy (`loadMore`, `moveTask`, mutacje i
pozostałe). Błąd należy naprawić w osobnym zadaniu; nie zmieniano tego pliku
w ramach I2w.

`git diff --check` zakończył się bez błędów. Skan zmienionych plików nie znalazł
`setState`, `package:ready_next`, `package:devplanner/core` ani `InvalidType`.
