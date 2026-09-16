# Plan naprawy menu kontekstowego, zmiany statusu i realtime na Kanbanie

Data analizy: 2026-09-08  
Repozytoria objęte planem:

- frontend Flutter: `Excellent/ready_next` (branch wymagany przez projekt: `workspace`),
- backend Workspaces: `excellent_databus/databus/veloryn-workspaces`.

Dokument jest planem implementacyjnym dla kolejnego agenta. Nie zawiera wdrożenia naprawy.

## 1. Zgłoszony objaw

Na Kanbanie:

- menu otwierane prawym przyciskiem myszy nie daje skutecznej zmiany statusu zadania głównego,
- podzadanie nie pozwala zmienić statusu z menu kontekstowego,
- część requestów prawdopodobnie dociera do backendu, ale UI nie pokazuje wyniku,
- zmiany wykonane przez jednego użytkownika nie są wiarygodnie widoczne u pozostałych użytkowników w czasie rzeczywistym.

## 2. Ustalenia potwierdzone w kodzie

### 2.1. Podzadania nie mają menu kontekstowego ani ścieżki zmiany statusu

`lib/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart` buduje `_SubtaskRow` wyłącznie z `InkWell.onTap`, który otwiera szczegóły. Nie ma `onSecondaryTapDown`/`onSecondaryTapUp`, przycisku menu, wywołania `TaskStatusPicker` ani intencji klawiaturowej.

`lib/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart` obsługuje tylko pobranie, paginację i tworzenie podzadania. Nie ma mutacji pojedynczego podzadania, optymistycznej podmiany elementu, rollbacku, obsługi konfliktu wersji ani błędu zapisu.

Wniosek: zmiana statusu podzadania z karty Kanbana nie jest obecnie niedziałającą implementacją — ta funkcja nie została podłączona.

### 2.2. Menu zadania głównego nie respektuje własnego workflow

`lib/workspaces/presentation/tasks/board/tasks_board_card_menu.dart` po wybraniu akcji `status` pokazuje wszystkie wartości `ProjectTaskStatus`, a następnie szuka kolumny warunkiem:

```dart
col.status == newStatus && col.customStatusId == null
```

Jeżeli projekt używa własnych statusów, kolumny mają `customStatusId`. Brak dopasowania kończy się `orElse: () => currentColumn`, po czym warunek `targetCol != currentColumn` jest fałszywy. Callback zwraca `false`, request nie jest wysyłany i użytkownik nie otrzymuje komunikatu. Picker pokazuje więc cele inne niż rzeczywiście dostępne kolumny boarda.

Dodatkowo dla dwóch różnych własnych kolumn o tej samej kategorii/fallback statusie sam `ProjectTaskStatus` nie identyfikuje celu. Menu musi operować na tożsamości kolumny (`customStatusId ?? status.name`), a nie wyłącznie na enumie systemowym.

### 2.3. Akcje menu omijają jednolity stan mutacji

W tym samym helperze:

- `status`, `pin` i `watch` przechodzą przez `TasksBoardCubit`,
- `priority`, `assignee` i `due_date` wywołują repozytoria bezpośrednio z widgetu,
- błędy `priority` i `assignee` są sprowadzane do `false`, bez wpisania `mutationError`,
- wynik requestu `due_date` jest ignorowany, po czym wykonywany jest pełny reload,
- część sukcesów kończy się `unawaited(cubit.load(force: true))`, co daje okno ze starym UI i nie zapewnia spójnej ochrony przed równoległą mutacją tej samej karty.

`TasksBoardCubit` ma już wspólny mechanizm `pendingTaskIds`, optymistyczny stan, rollback oraz `mutationError`/`mutationSerial`, ale menu nie używa go konsekwentnie. To tłumaczy zachowanie „request się wykonał, ale nic się nie odświeżyło” i brak informacji przy błędzie.

### 2.4. Kontrakt eventów Kanbana jest rozjechany między backendem i Flutterem

Backend podczas ruchu Kanbana zapisuje do outboxa:

- `task.kanban_moved`,
- `task.kanban_bulk_moved`,
- opcjonalnie `task.kanban_column_rebalanced`.

Potwierdzają to:

- `veloryn-workspaces/Application/Kanban/KanbanTaskMover.cs`,
- `veloryn-workspaces/Application/Tasks/TaskRealtimeEventFactory.cs`,
- `veloryn-workspaces/Infrastructure/Tasks/TaskRealtimeOutboxWorker.cs`.

Frontend rejestruje w `WorkspaceScopedRealtimeService._methods` i mapuje w `TaskProjectRealtimeAdapter` wyłącznie:

- `task.created`,
- `task.updated`,
- `task.status_changed`,
- `task.archived`,
- `task.restored`,
- `task.recurrence_changed`.

Nie rejestruje ani nie mapuje trzech eventów Kanbana. SignalR może je wysyłać poprawnie, ale handler Fluttera ich nie odbierze. Replay `GetProjectEvents` również nie naprawi sytuacji, jeżeli adapter nie rozpoznaje typu eventu.

### 2.5. Rozwinięte podzadania są odseparowanym, nierozwijanym snapshotem

Każda sekcja podzadań tworzy własny `KanbanSubtasksCubit`. `loadInitial()` przerywa, gdy lista jest już wczytana. Cubit nie dostaje eventów realtime i nie ma metody patch/reload wymuszającej odświeżenie.

Nawet gdy `TasksBoardCubit` odświeży kartę rodzica, stan lokalnego `KanbanSubtasksCubit` pozostaje stary. Nie ma też `didUpdateWidget`, które synchronizowałoby `subtaskTotal` i `subtaskCompleted` po otrzymaniu nowej wersji rodzica.

### 2.6. Payload realtime nie pozwala tanio rozpoznać rodzica podzadania

`TaskRealtimeEventResponse` / `TaskRealtimeMutation` przenosi `taskId`, status, wersję i wybrane pola, ale nie przenosi `parentTaskId` ani `customStatusId`. Dla eventu dotyczącego podzadania klient nie może jednoznacznie:

- wskazać karty rodzica, której licznik trzeba zmienić,
- odróżnić własnej kolumny workflow tylko po fallback enumie,
- zaktualizować niewczytanego dziecka bez resynchronizacji.

### 2.7. Obecne testy przechodzą, lecz nie pokrywają zgłoszonego przepływu

Uruchomiono:

```text
flutter test \
  test/workspaces/data/realtime/task_project_realtime_adapter_test.dart \
  test/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit_test.dart \
  test/workspaces/presentation/tasks/tasks_board_cubit_test.dart
```

Wynik: 30 testów zaliczonych. Brakuje jednak testów dla PPM, zagnieżdżonego pickera, custom statusu, eventów `task.kanban_*`, aktualizacji rozwiniętego podzadania i scenariusza dwóch klientów.

## 3. Docelowy model zachowania

1. PPM, przycisk `…` i `Shift+F10` uruchamiają tę samą typowaną akcję menu.
2. Menu zadania głównego pokazuje dokładnie kolumny bieżącego boarda, wraz z własnymi statusami i dozwolonymi przejściami workflow.
3. Menu podzadania pozwala zmienić jego status przez endpoint Tasks (`PATCH .../list-item`), ponieważ podzadanie nie jest osobną kartą Kanbana i backend słusznie blokuje przenoszenie go endpointem Kanban.
4. Każda mutacja daje natychmiastowy stan optymistyczny, blokuje duplikat dla tego rekordu, a odpowiedź backendu potwierdza nową wersję. Błąd przywraca poprzedni stan i jest widoczny.
5. Event z outboxa jest odbierany przez wszystkie połączone klienty, deduplikowany po `eventId`, odrzucany, jeśli ma wersję starszą lub równą, i patchuje snapshot albo uruchamia kontrolowany resync.
6. Nadawca requestu nie zależy od powrotu własnego eventu SignalR do pokazania sukcesu. SignalR synchronizuje inne sesje i leczy rozjazdy, a nie zastępuje obsługi odpowiedzi HTTP.

## 4. Plan implementacji

### Etap A — zamknąć kontrakt realtime backend ↔ Flutter

1. W backendowym `Contracts/Tasks/TaskRealtimeEventResponse.cs` rozszerzyć payload o:
   - `Guid? ParentTaskId`,
   - `Guid? CustomStatusId`.
2. W `Application/Tasks/TaskRealtimeEventFactory.cs` uzupełnić oba pola zarówno w nowym snapshotcie, jak i w ścieżce odtwarzania. Zachować kompatybilność deserializacji starych rekordów outboxa (pola nullable).
3. Ustalić jeden kanoniczny zestaw typów eventów. Rekomendacja: zachować rozróżnienie backendowe i dodać do klienta:
   - `task.kanban_moved`,
   - `task.kanban_bulk_moved`,
   - `task.kanban_column_rebalanced`.
   Nie zmieniać ich sztucznie na `task.status_changed`, bo ruch w tej samej kolumnie oraz rebalance mają inną semantykę.
4. Rozszerzyć backendowy opis SignalR w `Infrastructure/OpenApi/TaskDocumentFilter.cs`, aby dokumentował pełną listę emitowanych eventów i nowe pola.
5. We Flutterze rozszerzyć:
   - `lib/workspaces/domain/models/task_project_realtime_update.dart` o typy `kanbanMoved`, `kanbanBulkMoved`, `kanbanColumnRebalanced` oraz pola `parentTaskId`, `customStatusId`,
   - `lib/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart` o rejestrację metod `task.kanban_*`,
   - `lib/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart` o ich mapowanie.
6. `TasksBoardCubit._onRealtimeUpdate` powinien:
   - dla `updated` patchować pola niezmieniające kolumny,
   - dla `statusChanged`, `kanbanMoved`, `kanbanBulkMoved`, `kanbanColumnRebalanced`, create/archive/restore wykonywać debounced resync boarda,
   - zawsze zwiększać `realtimeRevision` po zaakceptowanym eventcie,
   - zachować deduplikację `eventId` i monotoniczność wersji per task,
   - nie gubić eventu nowszego, który przyszedł podczas `load(force: true)`; istniejący `_boardQueryRevision` należy zachować i dopisać test wyścigu.

### Etap B — wydzielić typowane menu i cele workflow

1. W `tasks_board_card_menu.dart` zastąpić stringi (`'status'`, `'priority'`, itd.) prywatnym enumem/ sealed action. Usuwa to literówki i upraszcza testowanie.
2. Nie używać ogólnego `TaskStatusPicker` do wyboru kolumny Kanbana. Dodać picker celu Kanbana przyjmujący listę `KanbanColumnResponse` i zwracający klucz kolumny lub samą kolumnę.
3. Etykieta i ikona pozycji powinny pochodzić z danych kolumny/workflow. Dla custom statusu pokazać jego nazwę i kolor; dla systemowego użyć `TaskStatusVisualHelper`.
4. Wyłączyć bieżącą kolumnę i przejścia zabronione przez `TasksBoardCubit.canMoveTaskTo`. Nie pokazywać celu, którego nie ma na aktualnym boardzie.
5. Pozycję submenu liczyć względem root overlay, ale nie używać ponownie surowego punktu PPM bez korekty krawędzi. Zachować `useRootNavigator: true`; dodać test dla scrollowanego boarda i menu przy prawej/dolnej krawędzi.
6. Zapewnić identyczną ścieżkę dla PPM, `…` i `Shift+F10`. `KanbanCardFrame` powinien mieć `Shortcuts`/`Actions` lub równoważną obsługę klawisza menu kontekstowego.

### Etap C — przenieść wszystkie mutacje karty do `TasksBoardCubit`

1. Dodać metody Cubita, np.:
   - `moveTaskToColumn(...)`,
   - `updateTaskPriority(...)`,
   - `updateTaskDueDate(...)`,
   - `replaceTaskAssignees(...)`.
2. Każda metoda ma:
   - znaleźć najnowszą kartę po `taskId`, zamiast ufać DTO przechwyconemu przed otwarciem menu,
   - użyć najnowszego `version` jako `expectedVersion`,
   - oznaczyć task w `pendingTaskIds`,
   - wykonać lokalną optymistyczną zmianę,
   - na sukces podmienić kartę odpowiedzią lub wykonać pojedynczy, jawny resync, gdy endpoint nie zwraca pełnej karty,
   - na `409` wymusić resync i wyświetlić komunikat o zmianie przez innego użytkownika,
   - na inny błąd wykonać rollback i ustawić `mutationError` + zwiększyć `mutationSerial`,
   - usunąć task z `pendingTaskIds` w każdej ścieżce końcowej.
3. Helper menu ma wywoływać wyłącznie intencje Cubita. Nie powinien pobierać bezpośrednio `TasksRepository` ani `TaskCollaborationRepository`.
4. Nie zamykać submenu bez informacji, gdy callback zwraca `false`. Jeżeli operacja nie ruszyła, pokazać konkretną przyczynę.
5. Teksty snackbara i etykiety menu przenieść do ARB (`app_pl.arb`, `app_en.arb`) i wygenerować lokalizacje.

### Etap D — dodać zmianę statusu podzadania

1. Rozszerzyć `_SubtaskRow` o:
   - `onSecondaryTapUp` lub `onSecondaryTapDown`,
   - przycisk `…` widoczny na hover/focus i dostępny semantycznie,
   - `Shift+F10`/klawisz menu kontekstowego,
   - zatrzymanie propagacji tak, aby PPM dziecka nie otwierał menu rodzica ani szczegółów.
2. Dodać małe, typowane menu podzadania. Status wybiera `TaskStatusPicker`; akcja `Otwórz` może współdzielić routing, ale nie należy używać `KanbanRepository.moveTask`, ponieważ backend zabrania osobnej karty dla podzadania.
3. Dodać do `KanbanSubtasksCubit` metodę `updateStatus(taskId, newStatus)` opartą o `TasksRepository.updateListItem` i `UpdateTaskListItemPayload(status: ..., expectedVersion: latest.version)`.
4. Mutacja lokalna ma działać analogicznie do `ProjectTasksListCubit.updateListItem`:
   - kolejka/in-flight per `taskId`, aby szybka druga zmiana nie użyła starej wersji,
   - optymistyczna podmiana statusu,
   - aktualizacja `subtaskCompleted` przy wejściu/wyjściu ze statusu `done`,
   - podmiana DTO i wersji odpowiedzi na sukces,
   - rollback na zwykły błąd,
   - przy `409` resync listy dzieci i czytelny błąd konfliktu.
5. Stan `KanbanSubtasksReady` rozszerzyć o `pendingSubtaskIds`, błąd mutacji i licznik/serial błędu. UI ma wyłączać ponowną akcję dla zapisywanego dziecka i pokazywać progress bez zmiany geometrii wiersza.
6. Po sukcesie zsynchronizować licznik karty rodzica w `TasksBoardCubit`. Najprostsza bezpieczna opcja to celowana metoda `applySubtaskStatusResult(parentTaskId, wasDone, isDone, childVersion)` albo debounced `load(force: true)`. Preferować lokalny licznik + późniejsze potwierdzenie snapshotem.

### Etap E — podłączyć rozwinięte podzadania do realtime bez osobnych połączeń SignalR

1. Nie tworzyć połączenia SignalR dla każdej karty. Właścicielem jednego połączenia projektu pozostaje `TasksBoardCubit`.
2. Sekcja podzadań powinna użyć `BlocListener<TasksBoardCubit, TasksBoardState>` i reagować na zmianę `realtimeRevision`/`latestRealtimeMutation`.
3. Gdy `mutation.parentTaskId == widget.task.id`:
   - jeżeli `taskId` jest załadowany i payload ma komplet potrzebnych pól, wykonać wersjonowany patch,
   - dla create/archive/restore albo brakujących danych wykonać debounced `refresh(force: true)` lokalnego Cubita.
4. Gdy event dotyczy załadowanego dziecka, porównać `version`; nie cofać lokalnie potwierdzonego nowszego stanu.
5. Dodać w `KanbanSubtasksCubit` jawne `refresh()` niekorzystające z obecnego guardu `state is Ready && subtasks.isNotEmpty`.
6. Dodać `didUpdateWidget` w sekcji, aby po zmianie `widget.task.version` zsynchronizować liczniki rodzica. Jeżeli zmienił się `task.id`, zamknąć stary Cubit i utworzyć nowy albo nadać widgetowi stabilny klucz po `task.id`; nie wolno przenosić stanu dzieci między kartami po reorderze.

### Etap F — zabezpieczyć lifecycle i wyścigi

1. Po każdym `await` w helperach UI sprawdzić `context.mounted`; Cubity sprawdzają `isClosed` przed `emit`.
2. Timer resync anulować w `close()`; sprawdzić, że `TasksBoardCubit.close()` zamyka `_updates`, `_connections`, `_realtimeErrors`, `_resyncDebounce` i adapter realtime.
3. Podczas HTTP mutation event SignalR może przyjść przed odpowiedzią. Reguła rozstrzygania: większa `version` wygrywa; odpowiedź HTTP o starszej wersji nie może nadpisać nowszego eventu.
4. Po reconnect replay rozpoczynać od ostatniego zaakceptowanego kursora i deduplikować po `eventId`. Event nieznanego typu powinien zostać zalogowany diagnostycznie w trybie debug/telemetrii, a nie bezgłośnie zgubiony.
5. Dla eventu `kanban_column_rebalanced` preferować jeden debounced reload całej dotkniętej kolumny/boarda, nie serię reloadów per event.

## 5. Testy wymagane do zamknięcia naprawy

### 5.1. Flutter unit/widget

1. `task_project_realtime_adapter_test.dart`:
   - mapuje wszystkie `task.kanban_*`,
   - mapuje `parentTaskId` i `customStatusId`,
   - replay i live dają ten sam model.
2. `workspace_scoped_realtime_service_test.dart`:
   - transport rejestruje handler dla każdego kanonicznego eventu Kanbana.
3. `tasks_board_cubit_test.dart`:
   - custom-status menu/intent przenosi do właściwego `customStatusId`,
   - optymistyczna zmiana jest natychmiastowa,
   - sukces zapisuje wersję odpowiedzi,
   - błąd cofa tylko zmienianą kartę,
   - 409 resynchronizuje stan,
   - event `kanban_moved` innego użytkownika odświeża kolumny,
   - event wcześniejszy od lokalnej wersji jest ignorowany,
   - burst eventów rebalance daje jeden resync.
4. `kanban_subtasks_cubit_test.dart`:
   - zmiana statusu aktualizuje dziecko i licznik done,
   - sukces podmienia wersję,
   - błąd robi rollback,
   - konflikt wymusza refresh,
   - dwie szybkie mutacje serializują `expectedVersion`,
   - realtime nowszy niż odpowiedź HTTP nie jest nadpisany.
5. Nowy widget test menu:
   - PPM na karcie otwiera menu,
   - `…` i `Shift+F10` otwierają ten sam zestaw akcji,
   - kliknięcie statusu otwiera picker kolumn,
   - custom status jest widoczny i przekazuje poprawny identyfikator,
   - PPM podzadania otwiera menu dziecka, nie rodzica,
   - po zapisie status/tytuł przekreślony/licznik zmienia się bez ręcznego reloadu,
   - błąd jest widoczny.

### 5.2. Backend .NET

1. Test fabryki/outboxa: payload ruchu zawiera `ParentTaskId`, `CustomStatusId`, poprzedni status i wersję.
2. Test `TaskRealtimeOutboxWorker`: publikuje dokładnie zapisany typ eventu do grupy projektu.
3. Test huba/replay: `GetProjectEvents` zwraca `task.kanban_moved`, `task.kanban_bulk_moved` i `task.kanban_column_rebalanced` w kolejności sekwencji.
4. Test endpointu list-item dla podzadania: status i wersja są aktualizowane, event ma `parentTaskId`.
5. Test izolacji: subskrybent innego projektu/workspace nie dostaje eventu.

### 5.3. Test integracyjny dwóch klientów

Uruchomić backend z PostgreSQL i workerem outbox, a następnie dwa niezależne klienty A i B zapisane do tego samego projektu:

1. A zmienia status zadania głównego z menu; A aktualizuje się od odpowiedzi HTTP, B od SignalR.
2. A zmienia status podzadania; u A i B zmienia się wiersz dziecka oraz licznik ukończenia rodzica.
3. B ma rozwiniętą listę podzadań przed zmianą A — mimo to widzi zmianę bez zwijania/rozwijania.
4. Rozłączyć B, wykonać dwie zmiany przez A, połączyć B ponownie; replay doprowadza B do końcowej wersji bez duplikatów.
5. A i B zmieniają ten sam task z tą samą wersją; jeden request kończy się 409, przegrany klient pokazuje konflikt i pobiera stan zwycięzcy.
6. Powtórzyć dla systemowego i własnego workflow.

### 5.4. Macierz platform

Minimalna walidacja ręczna/automatyczna:

| Platforma | PPM | `…` | `Shift+F10` | pozycja popupu po scrollu | realtime dwóch okien |
|---|---:|---:|---:|---:|---:|
| Flutter Web HTML/CanvasKit używany w projekcie | tak | tak | tak | tak | tak |
| Flutter Web Wasm | tak | tak | tak | tak | tak |
| Windows desktop | tak | tak | tak | tak | tak |
| macOS desktop | tak | tak | tak | tak | tak |
| Linux desktop | tak | tak | tak | tak | tak |

## 6. Kolejność wdrożenia i bezpieczne commity

1. Backend: rozszerzenie payloadu i testy kontraktu (zmiana kompatybilna wstecznie).
2. Flutter: obsługa pełnego katalogu eventów i testy adaptera.
3. Flutter: typowany wybór rzeczywistej kolumny oraz przeniesienie mutacji menu do `TasksBoardCubit`.
4. Flutter: menu i mutacja statusu podzadania.
5. Flutter: synchronizacja lokalnych Cubitów podzadań z eventami nadrzędnego Cubita.
6. Testy dwóch klientów, Web/Wasm i desktop.
7. Dopiero po zielonej macierzy usunąć ewentualne tymczasowe logi diagnostyczne.

Nie łączyć wszystkiego w jeden commit. Każdy etap powinien mieć test regresyjny, aby dało się wskazać, czy problem leży w kontrakcie, odbiorze eventu, reducerze stanu czy obsłudze gestu.

## 7. Kryteria akceptacji

- PPM działa na zadaniu głównym i podzadaniu na Web oraz desktopie.
- Systemowe i własne statusy są wybierane na podstawie realnych kolumn/workflow.
- Po skutecznym requestcie inicjujący klient zmienia UI natychmiast i zachowuje wersję odpowiedzi.
- Po błędzie UI wraca do poprzedniego stanu i pokazuje przyczynę.
- Drugi użytkownik widzi zmianę bez ręcznego odświeżenia i bez ponownego otwierania sekcji podzadań.
- Reconnect + replay odtwarza wszystkie ruchy Kanbana bez duplikatów i cofania wersji.
- Nie powstaje osobne połączenie SignalR per karta/podzadanie.
- Testy jednostkowe, widgetowe, backendowe i scenariusz dwóch klientów są zielone.

## 8. Pułapki, których agent wdrażający ma uniknąć

- Nie wysyłać podzadania do endpointu `kanban/move`; backend celowo dopuszcza tam tylko zadania główne.
- Nie utożsamiać `ProjectTaskStatus` z tożsamością kolumny w custom workflow.
- Nie polegać wyłącznie na własnym evencie SignalR po requestcie HTTP.
- Nie wykonywać pełnego reloadu osobno dla każdego eventu w serii rebalance.
- Nie tworzyć SignalR connection w każdym `KanbanSubtasksCubit`.
- Nie ignorować `Either`/wyniku repozytorium i nie zamykać menu bez feedbacku.
- Nie używać DTO przechwyconego przy otwarciu menu po długim `await`; przed mutacją znaleźć najnowszą wersję w stanie.
- Nie nadpisywać istniejących, niezacommitowanych zmian wizualnych Kanbana. Przed implementacją ponownie sprawdzić `git status` i ograniczyć diff do funkcji opisanych w tym planie.
