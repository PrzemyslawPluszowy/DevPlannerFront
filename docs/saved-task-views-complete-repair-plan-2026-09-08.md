# Pełny plan naprawy „Zapisanych widoków” zadań

Data: 2026-09-08  
Zakres: Flutter `ready_next` oraz tylko niezbędne kontrakty/testy `veloryn-workspaces`  
Odbiorca: agent implementujący, który nie zna wcześniejszej rozmowy  
Priorytet: wysoki — obecny przycisk działa technicznie, ale tworzy widok domyślny zamiast zapisywać stan użytkownika i nie pozwala wrócić do widoku domyślnego

## 1. Cel użytkowy

Po wdrożeniu użytkownik ma móc:

1. Ustawić filtry, wyszukiwanie, sortowanie, grupowanie oraz kolumny listy.
2. Kliknąć „Zapisane widoki” → „Zapisz bieżący widok”.
3. Nadać nazwę i zapisać dokładnie to, co aktualnie widzi.
4. Jednym kliknięciem przełączać się pomiędzy zapisanymi widokami.
5. Jednym kliknięciem wrócić do „Widoku domyślnego”.
6. Rozpoznać aktywny widok po nazwie i znaczniku wyboru.
7. Zobaczyć, że aktywny widok został lokalnie zmodyfikowany, jeśli bieżący układ różni się od zapisanej definicji.
8. Nadpisać aktywny widok albo zapisać jego kopię pod nową nazwą.
9. Zmienić nazwę, skonfigurować lub usunąć zapisany widok bez przypadkowej aktywacji.
10. Po ponownym uruchomieniu aplikacji otrzymać ostatnio aktywny widok.

Widoki są prywatne dla użytkownika i projektu. Nie dodawaj udostępniania widoków w tym zadaniu.

## 2. Potwierdzone problemy w obecnym kodzie

### P0 — „Utwórz widok” nie zapisuje bieżącego stanu

W `tasks_board_saved_views.dart`, metoda `_handleAction`, wywołuje:

```dart
CreateTaskSavedViewPayload(name: name, view: _defaultView())
```

To zawsze zapisuje stałą definicję:

- brak filtrów,
- sortowanie po pozycji rosnąco,
- brak grupowania,
- stały zestaw kolumn.

Przycisk zachowuje się więc inaczej, niż sugeruje nazwa „Zapisz widok”. Nie próbuj naprawiać tego przez zmianę samej etykiety. Trzeba przekazać rzeczywisty snapshot bieżącego widoku.

### P0 — brak przejścia do widoku domyślnego

`TaskSavedViewsCubit.select(String? viewId)` obsługuje `null`, lecz UI nigdy nie wywołuje `select(null)`. Po aktywacji widoku użytkownik nie może go wyłączyć bez usunięcia.

### P1 — dwa niezależne źródła stanu

Bieżące filtry znajdują się w `ProjectTasksListCubit`, natomiast układ kolumn, sortowanie i grupowanie częściowo w `TaskListPreferencesCubit`. Menu zapisanych widoków znajduje się wyżej w drzewie i nie ma bezpiecznego dostępu do kompletnego snapshotu. Nie wolno odtwarzać snapshotu przez zgadywanie ani przez `_defaultView()`.

### P1 — zapisany widok i preferencje mogą się wzajemnie nadpisywać

Backend ma kolejność wartości efektywnych obejmującą zapisany widok, preferencje użytkownika i politykę projektu. Flutter dodatkowo przekazuje `savedViewId`, `groupBy`, kolumny oraz lokalne filtry. Agent musi zachować jeden jawny model pierwszeństwa opisany w sekcji 5.

### P1 — błędy operacji są przechowywane, ale niewidoczne

`TaskSavedViewsReady.error` jest ustawiane przez cubit, jednak menu nie renderuje tego błędu. Użytkownik może kliknąć zapis/edycję/usunięcie i nie wiedzieć, że operacja się nie udała.

### P1 — kliknięcie zagnieżdżonego menu `…` może kolidować z wyborem widoku

Każdy widok jest `PopupMenuItem`, wewnątrz którego znajduje się kolejny `PopupMenuButton`. Trzeba przetestować propagację kliknięcia: wybranie „Zmień nazwę” nie może wcześniej aktywować widoku ani zamknąć niewłaściwego overlayu.

### P2 — konfigurator jest przeciążony i niespójny

W jednym długim dialogu znajdują się wszystkie ustawienia. Brakuje:

- czytelnego podziału na filtry, sortowanie/grupowanie i kolumny,
- licznika aktywnych filtrów,
- resetu sekcji,
- podglądu zmian,
- wyszukiwania kolumn przy dużej liczbie pól,
- walidacji zakresu dat,
- obsługi osób i etykiet pomimo obecności pól w modelu.

### P2 — kolejność kolumn jest niszczona

Konfigurator buduje `columnOrder` przez połączenie `Set` kolumn systemowych i pól własnych. To nie reprezentuje kolejności przeciąganej przez użytkownika i może zmienić kolejność po edycji widoku.

## 3. Ścisłe granice zadania

### Pliki Flutter do przeanalizowania i prawdopodobnej zmiany

- `lib/workspaces/presentation/tasks/board/tasks_board_saved_views.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_page.dart`
- `lib/workspaces/presentation/tasks/views/cubit/task_saved_views_cubit.dart`
- `lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart`
- `lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart`
- `lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart`
- `lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart`
- `lib/workspaces/presentation/tasks/list/project_tasks_list.dart`
- `lib/workspaces/presentation/tasks/list/table/task_list_table.dart`
- `lib/workspaces/data/projects/tasks/models/task_views_models.dart`
- `lib/workspaces/data/projects/tasks/models/task_list_configuration_models.dart`
- `lib/workspaces/domain/repositories/task_view_repository.dart`
- `lib/workspaces/data/projects/tasks/repositories/task_view_repository_impl.dart`
- odpowiadające pliki lokalizacji ARB

### Pliki backendu tylko do walidacji lub testów

- `veloryn-workspaces/Application/Tasks/Handlers/TaskSavedViewHandler.cs`
- `veloryn-workspaces/Application/Tasks/Handlers/ListProjectTasksHandler.cs`
- `veloryn-workspaces/Application/Tasks/Handlers/TaskListConfigurationHandler.cs`
- `veloryn-workspaces/Contracts/Tasks/TaskSavedViewContracts.cs`
- `veloryn-workspaces/Tests/Veloryn.Workspaces.Tests/TaskListConfigurationTests.cs`
- `veloryn-workspaces/Tests/Veloryn.Workspaces.Tests/ProjectTaskHandlerTests.cs`

Nie zmieniaj kontraktu backendowego, jeśli kompletny snapshot da się wysłać istniejącym `TaskSavedViewDefinition`. Obecny kontrakt ma już filtry, sortowanie, grupowanie, kolumny, pola własne i `columnOrder`.

### Poza zakresem

- szablony zadań,
- menu statusów Kanbana,
- realtime tasków,
- edytor szczegółów taska,
- udostępnianie widoków innym osobom,
- globalne widoki między projektami.

Repozytorium jest edytowane równolegle. Przed każdą zmianą uruchom `git status --short` oraz `git diff -- <plik>`. Nie cofaj cudzych zmian i nie formatuj całego repozytorium.

## 4. Docelowy model stanu

Dodaj niemutowalny snapshot reprezentujący dokładnie bieżącą konfigurację listy, np.:

```dart
final class TaskListViewSnapshot {
  const TaskListViewSnapshot({
    required this.filter,
    required this.sortField,
    required this.sortDirection,
    required this.groupBy,
    required this.columns,
    required this.customFieldIds,
    required this.columnOrder,
  });

  final TaskSavedViewFilter filter;
  final TaskSavedViewSortField sortField;
  final TaskSavedViewSortDirection sortDirection;
  final TaskSavedViewGroupBy groupBy;
  final List<TaskSavedViewColumn> columns;
  final List<String> customFieldIds;
  final List<String> columnOrder;

  TaskSavedViewDefinition toDefinition();
}
```

Można użyć bezpośrednio `TaskSavedViewDefinition`, jeśli nie powoduje to zależności warstwowej. Ważniejsze od nazwy klasy są następujące zasady:

1. Snapshot powstaje w jednym miejscu.
2. Snapshot zawiera wszystkie ustawienia, bez wartości domyślnych podstawianych przez menu.
3. Listy są kopiowane przed przekazaniem do cubita.
4. Porównanie snapshotów jest głębokie i ignoruje wyłącznie nieistotne różnice reprezentacji, np. `null` kontra pusta lista, jeśli backend traktuje je identycznie.
5. UI menu nie czyta prywatnych pól kilku cubitów osobno.

## 5. Jednoznaczne pierwszeństwo konfiguracji

Zaimplementuj i udokumentuj następującą regułę:

1. Wybrany zapisany widok dostarcza bazową definicję filtrów, sortowania, grupowania oraz kolumn.
2. Zmiany wykonane przez użytkownika w aktualnej sesji tworzą stan roboczy nad tą definicją.
3. Stan roboczy nie nadpisuje zapisanego widoku automatycznie.
4. Jeśli stan roboczy różni się od zapisanej definicji, przy nazwie pokaż znacznik `•` lub etykietę „Zmieniono”.
5. „Zapisz zmiany” aktualizuje aktywny widok z `expectedVersion`.
6. „Zapisz jako nowy” tworzy kopię i aktywuje ją.
7. „Widok domyślny” wywołuje `select(null)` i odbudowuje listę z efektywnej konfiguracji projektu/użytkownika bez `savedViewId`.

Nie zapisuj każdej zmiany filtra automatycznie do backendu widoków. To grozi spamem requestów i konfliktami wersji.

## 6. Przekazanie snapshotu do menu

Preferowane rozwiązanie:

1. W `_TasksBoardView` lub wspólnym kontrolerze utrzymuj aktualny `TaskListViewSnapshot` dostarczany przez `ProjectTasksList` callbackiem `onViewSnapshotChanged`.
2. Callback wywołuj tylko, gdy semantycznie zmieni się snapshot.
3. Przekaż snapshot do `_TaskSavedViewsMenu` jako wymagany parametr.
4. Menu podczas tworzenia używa `currentSnapshot.toDefinition()`, nigdy `_defaultView()`.
5. Jeśli snapshot nie jest jeszcze gotowy, przycisk tworzenia ma być wyłączony i pokazywać tooltip „Lista zadań jeszcze się ładuje”.

Nie pobieraj cubitów listy przez `context.read` z overlayu. `ProjectTasksList` tworzy własne providery niżej w drzewie; wcześniejsze błędy aplikacji pokazały, że kontekst overlayu nie jest bezpiecznym mechanizmem przekazywania zależności.

## 7. Nowy przepływ tworzenia widoku

Po kliknięciu „Zapisane widoki” → „Zapisz bieżący widok”:

1. Otwórz mały dialog.
2. Pole nazwy ma autofocus, limit 120 znaków i lokalną walidację pustej wartości.
3. Pokaż krótkie podsumowanie snapshotu:
   - liczba aktywnych filtrów,
   - sposób grupowania,
   - sposób sortowania,
   - liczba widocznych kolumn.
4. Przyciski: „Anuluj” oraz „Zapisz widok”.
5. Podczas requestu zablokuj ponowne wysłanie i pokaż spinner tylko w przycisku.
6. Po sukcesie zamknij dialog, aktywuj nowy widok i pokaż snackbar „Widok zapisany”.
7. Po błędzie pozostaw dialog otwarty, zachowaj nazwę i pokaż prawdziwy `ApiError.message`.

Opcjonalny drugi przycisk „Skonfiguruj przed zapisem” może otworzyć pełny edytor ze snapshotem jako wartością początkową. Nie wolno startować od `_defaultView()`.

## 8. Menu główne

Docelowa kolejność:

1. `Zapisz bieżący widok`.
2. `Widok domyślny` — zawsze widoczny; check, gdy `activeViewId == null`.
3. Separator.
4. Lista zapisanych widoków.

Wiersz widoku zawiera:

- check dla aktywnego widoku,
- ikonę zakładki dla nieaktywnego,
- nazwę,
- znacznik „Zmieniono” wyłącznie przy aktywnym zmodyfikowanym widoku,
- osobny przycisk `…` z semantyką i tooltipem.

Kliknięcie wiersza aktywuje widok. Kliknięcie `…` nie może go aktywować. Jeżeli zagnieżdżone `PopupMenuButton` nadal powoduje problemy, zastąp całość kontrolowanym menu/panelem, w którym akcje są osobnymi hit targetami.

W stanie `busy` nie blokuj całego przycisku i nie ukrywaj menu. Zablokuj tylko akcje mutujące, a wybór innego już załadowanego widoku może pozostać dostępny, o ile nie trwa zmiana aktywnej preferencji.

## 9. Edycja aktywnego widoku

Dodaj akcje:

- „Zapisz bieżące zmiany” — widoczna tylko, jeśli aktywny widok różni się od snapshotu,
- „Zapisz jako nowy”,
- „Konfiguruj”,
- „Zmień nazwę”,
- „Usuń”.

Aktualizacja musi używać najnowszego `version` z `TaskSavedViewResponse`. Po `409`:

1. Nie udawaj sukcesu.
2. Przeładuj listę widoków.
3. Pokaż komunikat, że widok został zmieniony w innej sesji.
4. Pozwól użytkownikowi ponowić na aktualnej wersji albo zapisać kopię.

## 10. Widok domyślny

Dodaj jawny wariant akcji menu, np. `_SavedViewMenuAction.selectDefault()`.

Obsługa:

```dart
cubit.select(null);
```

Po wyborze:

1. `activeSavedViewId` zostaje zapisane jako `null` w preferencjach backendowych.
2. `ProjectTasksList` otrzymuje nowy key z `savedViewId == null` i przeładowuje dane.
3. Kolumny nie mogą pozostać ze starego zapisanego widoku.
4. Grupowanie wraca do konfiguracji efektywnej: custom status dla custom workflow albo konfiguracja projektu/użytkownika zgodnie z ustaloną polityką.
5. Etykieta przycisku wraca do „Zapisane widoki” albo lepiej „Widok domyślny”.

Dodaj możliwość cofnięcia usunięcia aktywnego widoku tylko jeśli istnieje bezpieczny mechanizm. W przeciwnym razie potwierdzenie usunięcia musi jasno informować, że aplikacja wróci do widoku domyślnego.

## 11. Filtry wymagane w konfiguratorze

Obsłuż bez zgadywania wszystkie pola istniejącego `TaskSavedViewFilter`:

- `statuses`,
- `priorities`,
- `assigneeCoreUserIds`,
- `labelIds`,
- `parentTaskId` tylko jeśli UI ma bezpieczny selektor; inaczej nie usuwaj istniejącej wartości,
- `myInvolvement`,
- `dueFromUtc`,
- `dueToUtc`,
- `search`,
- `includeArchived`,
- `pinnedOnly`.

Ważne:

- edycja widoku nie może wyzerować filtrów, których formularz chwilowo nie renderuje,
- osoby pokazuj przez `displayName`, nigdy UUID,
- etykiety pokazuj przez nazwę i kolor,
- `dueFromUtc <= dueToUtc`; przy błędzie pokaż komunikat przy sekcji dat,
- pusta lista powinna być normalizowana do `null`, jeśli oznacza „bez filtra”.

## 12. Sortowanie, grupowanie i kolumny

### Sortowanie

Obsłuż wszystkie wartości `TaskSavedViewSortField` i kierunek. Etykiety mają pochodzić z lokalizacji, nie z `.name`.

### Grupowanie

Obsłuż:

- brak,
- status systemowy,
- status własny,
- priorytet,
- osoba przypisana.

Jeżeli `groupBy.none` backend w grupowanym endpointcie mapuje z powrotem na status, UI nie może obiecywać widoku niegrupowanego w trybie, który technicznie zawsze używa grup. Ustal poprawne zachowanie dla listy płaskiej i dodaj test.

### Kolumny

1. Minimum jedna kolumna.
2. `title` powinien być wymagany albo interfejs musi zachować osobny stały obszar tytułu.
3. Użyj istniejącego `columnOrder` jako źródła kolejności.
4. Dodanie/usunięcie kolumny nie może przetasowywać pozostałych.
5. Pola własne zachowują identyfikatory `cf:<id>`.
6. Kolumny systemowe zachowują identyfikatory `sys:<enumName>`.
7. Nie buduj kolejności na końcu przez iterację po `Set`.

## 13. Obsługa błędów i lifecycle

Każda operacja cubita (`load/create/update/delete/select preference`) powinna mieć obserwowalny wynik.

Minimalnie:

- `busyAction`: `create`, `update`, `delete`, `select` lub `null`,
- `error`: komunikat dla bieżącej operacji,
- opcjonalny `successEvent`/numer seryjny do snackbara.

Nie połykaj błędu `_persistActiveViewPreference`. Obecnie wybór może zmienić UI lokalnie, a zapis preferencji może się nie udać bez informacji. W razie błędu:

1. albo cofnij `activeViewId` do poprzedniego,
2. albo pozostaw stan lokalny, ale pokaż „Widok aktywny tylko w tej sesji; nie udało się zapisać preferencji”.

Wybierz jedną politykę i przetestuj ją. Preferowana jest druga, bo nie powoduje nagłego przeskoku widoku po poprawnym załadowaniu danych.

Po każdym `await` przed użyciem `BuildContext` sprawdź `context.mounted`. Kontrolery tekstowe twórz poza builderem i zawsze zwalniaj. Nie wywołuj `setState` po zamknięciu dialogu.

## 14. Reakcja listy na zmianę widoku

Po wyborze widoku:

1. anuluj lub unieważnij wynik poprzedniego requestu listy,
2. wyczyść stare cursory i cache grup,
3. pokaż loading/skeleton tylko w części danych,
4. wyślij request z nowym `savedViewId`,
5. zastosuj kolumny i `columnOrder` tego samego widoku,
6. nie mieszaj odpowiedzi starego i nowego widoku,
7. zachowaj zaznaczenie tasków tylko wtedy, gdy nadal należą do wyniku; bezpieczniej wyczyścić selekcję.

Dodaj token/generację requestu, jeżeli `ProjectTasksListCubit` jeszcze jej nie ma. Test musi zasymulować: wolna odpowiedź widoku A, szybka odpowiedź widoku B; końcowy ekran ma pokazać B.

## 15. Backend — co zweryfikować, a czego nie przebudowywać

Istniejące endpointy CRUD są wystarczające:

- `GET task-views`,
- `POST task-views`,
- `PATCH task-views/{id}`,
- `DELETE task-views/{id}`.

Zweryfikuj testami:

1. Widoki są prywatne dla `CoreUserId`.
2. Widok z innego projektu nie może zostać aktywowany.
3. `expectedVersion` chroni aktualizację przed konfliktem.
4. Usunięcie aktywnego widoku skutkuje efektywnym `activeSavedViewId == null` albo backend nie zwraca martwego ID.
5. Wszystkie filtry zapisanej definicji są stosowane w `ListProjectTasksHandler`.
6. Jawne parametry listy mają udokumentowane pierwszeństwo nad saved view.
7. Custom field z innego projektu jest odrzucany.

Nie zmieniaj bazy danych bez potwierdzonej potrzeby. Nie dodawaj nowego endpointu tylko po to, by skopiować istniejący payload.

## 16. Testy Flutter — obowiązkowe

### Testy cubita `TaskSavedViewsCubit`

Dodaj przypadki:

1. `load` pobiera widoki i poprawnie wybiera aktywny ID z preferencji.
2. Martwy aktywny ID jest normalizowany do `null`.
3. `select(null)` zapisuje pusty aktywny widok.
4. Wybór widoku aktualizuje stan przed/po zapisie preferencji zgodnie z przyjętą polityką.
5. Błąd preferencji jest widoczny.
6. `create` wysyła przekazany snapshot, a nie `_defaultView()`.
7. `create` aktywuje utworzony widok.
8. `update` wysyła najnowsze `expectedVersion`.
9. Konflikt 409 nie usuwa lokalnego stanu roboczego.
10. Usunięcie aktywnego widoku czyści aktywność.
11. Usunięcie nieaktywnego widoku nie zmienia aktywnego.
12. Podwójne kliknięcie nie wysyła dwóch mutacji.

### Testy widgetowe menu

Dodaj osobny plik testowy, nie dopisuj wszystkiego do `widget_test.dart`:

1. Menu pokazuje „Widok domyślny”.
2. Check znajduje się przy właściwej pozycji.
3. Kliknięcie domyślnego wywołuje `select(null)`.
4. Tworzenie widoku wysyła dokładny bieżący snapshot.
5. Anulowanie dialogu nie wysyła requestu.
6. Pusta nazwa pokazuje błąd.
7. Błąd API pozostawia dialog i dane.
8. Kliknięcie `… → Zmień nazwę` nie aktywuje widoku.
9. Usunięcie wymaga potwierdzenia.
10. Aktywny zmodyfikowany widok pokazuje „Zmieniono”.
11. „Zapisz zmiany” znika, gdy snapshot ponownie zrówna się z definicją.
12. Tryb kompaktowy ma tooltip i poprawny hit target co najmniej 40×40.

### Test integracyjny widoku listy

1. Ustaw filtr `High`, sortowanie po tytule malejąco i własną kolejność kolumn.
2. Zapisz widok.
3. Zmień konfigurację listy.
4. Wybierz zapisany widok.
5. Zweryfikuj parametry requestu, kolejność kolumn i wynik.
6. Wybierz „Widok domyślny”.
7. Zweryfikuj brak `savedViewId` i przywrócenie konfiguracji domyślnej.

## 17. Testy backendu — obowiązkowe przy zmianie backendu

Uruchom istniejące i dodaj brakujące przypadki w:

- `TaskListConfigurationTests.cs`,
- `ProjectTaskHandlerTests.cs`.

W szczególności dodaj test usunięcia aktywnego widoku oraz test łączący filtr, sortowanie, grupowanie i pola własne w jednej definicji. Nie wystarczy test samego CRUD.

## 18. Kolejność implementacji

Agent ma wykonać dokładnie w tej kolejności:

1. Sprawdź `git status` i diff plików zakresu.
2. Napisz test pokazujący, że obecne tworzenie zapisuje `_defaultView()` zamiast bieżącego snapshotu.
3. Wprowadź `TaskListViewSnapshot` i test jego konwersji/normalizacji.
4. Wyprowadź kompletny snapshot z listy i preferencji.
5. Przekaż snapshot callbackiem do poziomu menu.
6. Zmień tworzenie na „Zapisz bieżący widok”.
7. Dodaj „Widok domyślny” i `select(null)`.
8. Dodaj wykrywanie stanu zmodyfikowanego.
9. Dodaj „Zapisz zmiany” oraz „Zapisz jako nowy”.
10. Napraw widoczność błędów i konflikty 409.
11. Napraw zachowanie zagnieżdżonego menu `…`.
12. Zachowaj prawdziwy `columnOrder`.
13. Uzupełnij osoby, etykiety i walidację dat w konfiguratorze.
14. Dodaj pełne testy widgetowe.
15. Uruchom analizę i testy.
16. Wykonaj ręczny smoke test.

Nie zaczynaj od kosmetyki. Najpierw snapshot, aktywacja/dezaktywacja i testy stanu.

## 19. Obowiązkowa jakość kodu i struktura katalogów

Ta sekcja jest warunkiem odbioru, a nie sugestią. Funkcjonalność nie może zostać dopisana jako kolejne setki linii do `tasks_board_saved_views.dart` ani do `tasks_board_page.dart`.

### 19.1. Najpierw przeczytaj instrukcje projektu

Przed edycją agent musi:

1. Wyszukać wszystkie `AGENTS.md` od katalogu repozytorium do katalogu docelowego.
2. Przeczytać je w całości.
3. Przeczytać w całości obowiązujący dokument [`docs/ai-ui-architecture-guidelines.md`](./ai-ui-architecture-guidelines.md). Jest on nadrzędnym standardem UI i architektury Ready Next dla tego zadania.
4. Sprawdzić istniejące konwencje sąsiednich funkcjonalności.
5. W podsumowaniu wskazać, których zasad jakościowych przestrzegał.

Jeśli `AGENTS.md` nie istnieje w repozytorium Fluttera, nadal obowiązują zasady z tego planu oraz `docs/ai-ui-architecture-guidelines.md`. Brak pliku nie jest zgodą na monolit. W przypadku sprzeczności ogólnego przykładu z planu z wytycznymi AI UI agent ma zastosować wytyczne AI UI i opisać różnicę w podsumowaniu.

Z dokumentu AI UI bezwzględnie obowiązują tutaj:

- kod Workspaces pozostaje w `lib/workspaces`; nic nie trafia do `lib/shared`, dopóki nie ma co najmniej dwóch niezależnych konsumentów,
- przepływ danych pozostaje `API client → repository/use case → domain → Cubit → UI`,
- UI nie wywołuje Dio, REST, SignalR ani WebSocketu,
- cubity mają mały scope i jedną odpowiedzialność; nie rozbudowuj `TasksBoardCubit` do god cubita,
- stany cubita są niemutowalnymi `sealed class`, bez Freezed,
- RxDart służy do `debounce`, `distinct` i `switchMap`, jeśli te mechanizmy są potrzebne,
- przed opóźnionym `emit` sprawdzaj `isClosed`; subskrypcje i timery mają właściciela oraz `dispose/close`,
- widget renderuje stan i wysyła intencję; nie zawiera logiki biznesowej,
- ręcznie pisane widgety pozostają zwykle poniżej 300 linii,
- publiczne elementy feature’u są eksportowane przez `*_export.dart`,
- komentarze i dokumentacja kodu są po polsku i opisują kontrakt/powód,
- ikony produktu są mapowane przez `AppIcons` i spójny zestaw Lucide; nie dodawaj bezpośrednich importów biblioteki ikon w nowych widgetach,
- overlay/dialog musi wspierać Escape, focus trap, klawiaturę i wspólną granicę dostępności,
- stany `401`, `403`, empty i failure są jawne, nie zamieniane na pustą listę,
- ukończenie wymaga analizy, testów, builda oraz kontroli wizualnej Web/Desktop.

### 19.2. Docelowa struktura katalogów

Utwórz osobny moduł prezentacyjny zapisanych widoków. Preferowana struktura:

```text
lib/workspaces/presentation/tasks/views/
├── task_saved_views_export.dart
├── cubit/
│   ├── task_saved_views_cubit.dart
│   └── task_saved_views_state.dart
├── models/
│   ├── task_list_view_snapshot.dart
│   └── task_saved_view_draft.dart
├── mappers/
│   └── task_saved_view_snapshot_mapper.dart
├── widgets/
│   ├── task_saved_views_button.dart
│   ├── task_saved_views_menu.dart
│   ├── task_saved_view_menu_item.dart
│   ├── task_saved_view_name_dialog.dart
│   ├── task_saved_view_editor_dialog.dart
│   ├── task_saved_view_dirty_badge.dart
│   └── sections/
│       ├── task_saved_view_filters_section.dart
│       ├── task_saved_view_sort_section.dart
│       ├── task_saved_view_group_section.dart
│       ├── task_saved_view_columns_section.dart
│       ├── task_saved_view_people_filter.dart
│       ├── task_saved_view_labels_filter.dart
│       └── task_saved_view_date_range_filter.dart
└── helpers/
    ├── task_saved_view_labels.dart
    ├── task_saved_view_normalization.dart
    └── task_saved_view_validation.dart
```

Jeżeli część tych katalogów byłaby sztuczna dla jednego małego pliku, można połączyć `helpers` z `models`, ale nie wolno z powrotem skleić całego UI w jeden plik.

`task_saved_views_export.dart` ma eksportować wyłącznie publiczny kontrakt feature’u potrzebny rodzicowi. Nie eksportuj prywatnych implementacji sekcji, helperów ani elementów używanych tylko wewnątrz modułu.

Testy mają odzwierciedlać strukturę produkcyjną:

```text
test/workspaces/presentation/tasks/views/
├── cubit/
│   └── task_saved_views_cubit_test.dart
├── models/
│   └── task_list_view_snapshot_test.dart
└── widgets/
    ├── task_saved_views_menu_test.dart
    ├── task_saved_view_name_dialog_test.dart
    └── task_saved_view_editor_dialog_test.dart
```

Nie twórz jednego pliku testowego zawierającego wszystkie scenariusze.

### 19.3. Jedna odpowiedzialność na plik

Każdy plik ma mieć jedną główną odpowiedzialność:

- `cubit` wykonuje orkiestrację asynchroniczną i zmienia stan,
- `state` opisuje stan i zdarzenia, bez requestów i widgetów,
- `models` przechowują niemutowalne dane robocze,
- `mappers` konwertują snapshot ↔ kontrakt API,
- `validation` waliduje nazwę, daty i spójność kolumn,
- `labels` mapuje enumy na lokalizowane etykiety,
- widget menu wyłącznie renderuje menu i emituje intencje,
- dialog nazwy nie zna repozytorium ani API,
- dialog edytora zarządza szkicem formularza, ale zapis deleguje callbackiem,
- sekcja filtrów nie zarządza nawigacją ani aktywnym saved view.

Nie wolno:

- wywoływać repozytorium bezpośrednio z widgetu,
- wykonywać mapowania payloadu wewnątrz `build`,
- trzymać logiki walidacji w `onPressed`,
- przekazywać kilkunastu luźnych wartości, jeśli stanowią jeden model,
- używać globalnego mutable state,
- kopiować tej samej mapy etykiet do kilku widgetów.

### 19.4. Limity wielkości

Limity dotyczą kodu pisanego ręcznie; nie dotyczą plików generowanych Freezed/JSON:

- plik widgetu: cel 120–220 linii, twardy limit 300 linii,
- plik cubita: cel poniżej 300 linii, twardy limit 450 linii,
- metoda `build`: maksymalnie około 80 linii,
- zwykła metoda/funkcja: maksymalnie około 40 linii,
- maksymalnie 6–8 parametrów konstruktora widgetu; przy większej liczbie wprowadź model konfiguracji lub kontroler,
- maksymalnie 3 poziomy zagnieżdżenia warunków w metodzie,
- dialog z trzema lub większą liczbą sekcji musi być podzielony na osobne widgety.

Przekroczenie limitu jest dopuszczalne tylko z krótkim komentarzem architektonicznym wyjaśniającym, dlaczego podział pogorszyłby spójność. „Nie było czasu” nie jest uzasadnieniem.

### 19.5. Zakaz wielkiego pliku `part of`

Obecny `tasks_board_saved_views.dart` jest `part of 'tasks_board_page.dart'`. Nie rozwijaj dalej tego wzorca.

Docelowo:

1. Nowe widgety mają być normalnymi bibliotekami Dart z jawnymi importami.
2. Publiczny punkt wejścia może być eksportowany przez mały plik barrel, jeśli repozytorium używa takiej konwencji.
3. Prywatne klasy potrzebne w testach nie mogą być ukrywane wyłącznie dlatego, że cały moduł jest jednym `part`.
4. `tasks_board_page.dart` ma jedynie złożyć zależności i przekazać callbacki.
5. Stary plik `tasks_board_saved_views.dart` ma zostać ograniczony do cienkiego adaptera albo usunięty po przeniesieniu kodu.

Nie przenoś jednak całego pliku mechanicznie bez testów. Najpierw wydziel modele i małe widgety, następnie przełącz importy, na końcu usuń martwy kod.

### 19.6. Wzorzec komunikacji UI

Preferuj jawne intencje, np.:

```dart
sealed class TaskSavedViewIntent {
  const TaskSavedViewIntent();
}

final class SelectDefaultView extends TaskSavedViewIntent {
  const SelectDefaultView();
}

final class SaveCurrentView extends TaskSavedViewIntent {
  const SaveCurrentView(this.name, this.snapshot);

  final String name;
  final TaskListViewSnapshot snapshot;
}
```

Nie jest obowiązkowe wprowadzenie dokładnie tych klas, ale przepływ musi być równie czytelny: widget emituje intencję, cubit wykonuje operację, stan informuje UI o wyniku.

Nie przekazuj `BuildContext` do cubita, repozytorium, mappera ani walidatora.

### 19.7. Niemutowalność i kolekcje

- Snapshot oraz draft nie mogą przechowywać referencji do mutowalnych list pochodzących ze stanu widgetu.
- Kopiuj listy przy konstrukcji i zwracaniu.
- Do wykrywania `dirty` użyj wartościowej równości, nie porównania referencji.
- Znormalizuj kolejność tylko tam, gdzie semantycznie nie ma znaczenia. `columnOrder` jest uporządkowane i nie wolno go sortować.
- Nie używaj `Set` jako źródła kolejności kolumn.
- Nie modyfikuj obiektów Freezed przez bezpośrednią zmianę list, nawet jeśli obecnie mają `makeCollectionsUnmodifiable: false`.

### 19.8. Lokalizacja i dostępność

- Wszystkie nowe teksty użytkownika dodaj do polskiego i angielskiego ARB.
- Nie dodawaj nowych polskich stringów bezpośrednio w widgetach.
- Nowe ikony pobieraj przez `AppIcons`; nie importuj bezpośrednio Material Symbols/Lucide w nowych plikach feature’u.
- Każdy przycisk ikonowy musi mieć tooltip.
- Menu i dialogi muszą działać z klawiatury: focus, Enter, Escape i logiczna kolejność Tab.
- Hit target przycisków ikonowych minimum 40×40, preferowane 44×44.
- Stan aktywny i stan błędu nie mogą być komunikowane wyłącznie kolorem.
- Długie nazwy widoków muszą mieć ellipsis i pełną nazwę w tooltipie.
- Dialog/overlay ma użyć istniejącego `AppModalAccessibilityBoundary` lub równoważnego wspólnego komponentu wskazanego w wytycznych projektu; nie implementuj kolejnej lokalnej wersji focus trapu.

### 19.9. Obsługa async

- Nie używaj `unawaited` dla operacji, których wynik decyduje o zamknięciu dialogu lub pokazaniu sukcesu.
- Każdy async callback blokujący UI musi obsłużyć sukces, błąd i anulowanie.
- Po `await` sprawdź `mounted`/`context.mounted` przed nawigacją, snackbarami i `setState`.
- Odpowiedzi starych requestów muszą być ignorowane za pomocą request ID, cancellation tokenu albo generacji stanu.
- `dispose` musi zwolnić każdy controller, focus node, debounce i subskrypcję.
- Nie zamykaj dialogu przed potwierdzeniem sukcesu API.

### 19.10. Wymagania code review

Przed oddaniem agent ma wykonać samodzielny przegląd diffu i odpowiedzieć na pytania:

1. Czy którykolwiek ręcznie pisany plik przekroczył 300 linii? Jeśli tak, dlaczego?
2. Czy `build` zawiera logikę domenową albo budowanie payloadu?
3. Czy istnieje widget przyjmujący więcej niż 8 parametrów?
4. Czy jakaś operacja API jest uruchamiana bez obsługi błędu?
5. Czy istnieje ścieżka pokazująca UUID użytkownika?
6. Czy `columnOrder` może zostać zmienione przez `Set` albo sortowanie?
7. Czy kliknięcie `…` może aktywować widok?
8. Czy stary request może nadpisać nowy widok?
9. Czy wszystkie kontrolery są zwalniane?
10. Czy test widgetowy obejmuje prawdziwy przepływ, a nie tylko wywołanie jednej metody?
11. Czy publiczne API feature’u przechodzi przez `task_saved_views_export.dart`?
12. Czy nowe widgety używają `AppIcons`, a nie bezpośredniego importu zestawu ikon?
13. Czy wykonano i obejrzano zrzuty Web/Desktop zgodnie z dokumentem AI UI?

Jeśli odpowiedź ujawnia problem, agent ma poprawić kod przed przekazaniem pracy, a nie opisać problem jako „do zrobienia później”.

### 19.11. Automatyczne warunki odrzucenia

Rozwiązanie należy odrzucić bez dalszego review, jeśli wystąpi choć jeden z poniższych punktów:

- jeden nowy ręcznie pisany widget ma około 500–1000 linii,
- większość funkcjonalności pozostała w `tasks_board_saved_views.dart`,
- brak testów widgetowych,
- payload tworzony jest w metodzie `build`,
- błędy API są ignorowane albo zamieniane na `null`,
- dodano teksty bez lokalizacji,
- w UI może pojawić się UUID,
- utworzenie widoku nadal używa `_defaultView()`,
- nie ma akcji powrotu do widoku domyślnego,
- agent sformatował lub zmienił pliki spoza zakresu,
- agent nadpisał zmiany innego agenta.
- agent nie przeczytał lub naruszył `docs/ai-ui-architecture-guidelines.md`,
- nowe publiczne elementy feature’u nie są eksportowane przez `*_export.dart`,
- nowe widgety omijają `AppIcons` i importują bibliotekę ikon bezpośrednio,
- duża zmiana UI nie ma zrzutu Web/Desktop oraz ręcznej oceny wizualnej.

## 20. Komendy walidacyjne

Flutter, z katalogu `ready_next`:

```bash
dart format <wyłącznie zmienione pliki dart>
dart analyze <lista zmienionych plików i testów>
flutter test test/workspaces/presentation/tasks/views/
flutter test test/workspaces/presentation/tasks/board/ --plain-name "saved view"
flutter build web --wasm
git diff --check
```

Backend, tylko jeśli został zmieniony:

```bash
dotnet test Tests/Veloryn.Workspaces.Tests/Veloryn.Workspaces.Tests.csproj --filter "FullyQualifiedName~TaskListConfigurationTests|FullyQualifiedName~ProjectTaskHandlerTests" --no-restore --verbosity minimal
git diff --check
```

Jeżeli istnieją inne błędy analizy pochodzące z równoległej pracy, pokaż dokładnie, które nie dotyczą tego zakresu. Nie naprawiaj ich przy okazji.

## 21. Ręczny smoke test

Po pełnym hot restartcie Fluttera:

1. Otwórz listę tasków projektu.
2. Ustaw priorytet `Wysoki`, frazę wyszukiwania i sortowanie po tytule.
3. Zmień widoczne kolumny oraz ich kolejność.
4. Kliknij „Zapisane widoki” → „Zapisz bieżący widok”.
5. Nazwij go „Wysokie priorytety”.
6. Sprawdź, że widok jest aktywny i ma check.
7. Przeładuj stronę — ten sam widok powinien pozostać aktywny.
8. Zmień filtr — powinien pojawić się znacznik „Zmieniono”.
9. Kliknij „Zapisz zmiany”, przeładuj i sprawdź utrwalenie.
10. Kliknij „Zapisz jako nowy” i sprawdź, że powstała osobna pozycja.
11. Wybierz „Widok domyślny” i sprawdź brak `savedViewId` w requestach.
12. Edytuj nazwę nieaktywnego widoku — nie może się aktywować.
13. Usuń nieaktywny widok.
14. Usuń aktywny widok i sprawdź powrót do domyślnego.
15. Sprawdź tryb wąskiego ekranu/kompaktowy.
16. Obserwuj logi: brak `ProviderNotFound`, lookup deactivated context i `setState after dispose`.
17. Wykonaj zrzut Web/Desktop, oceń gęstość, overflow, hover, focus, jasny/ciemny motyw i dołącz wynik kontroli do podsumowania.

## 22. Kryteria odbioru

Zadanie jest ukończone dopiero, gdy wszystkie punkty są prawdziwe:

- [ ] Nowy widok zapisuje dokładny bieżący stan, nie `_defaultView()`.
- [ ] Istnieje widoczna akcja „Widok domyślny”.
- [ ] Aktywny widok utrzymuje się po restarcie.
- [ ] Filtry, sortowanie, grupowanie i kolumny są spójne po wyborze.
- [ ] Kolejność kolumn jest zachowana.
- [ ] Zmodyfikowany aktywny widok jest oznaczony.
- [ ] Można nadpisać widok i zapisać kopię.
- [ ] Błędy create/update/delete/select są widoczne.
- [ ] Konflikt wersji nie niszczy zmian użytkownika.
- [ ] Kliknięcie menu zarządzania nie aktywuje widoku.
- [ ] UI nie pokazuje UUID użytkowników i pól własnych.
- [ ] Szybkie przełączanie nie pozwala staremu requestowi nadpisać nowego.
- [ ] Testy cubita, widgetów i backendu przechodzą.
- [ ] Brak wyjątków providerów i lifecycle.
- [ ] Ręczny smoke test został wykonany.
- [ ] Żaden nowy ręcznie pisany widget nie przekracza 300 linii bez uzasadnienia.
- [ ] `tasks_board_saved_views.dart` został odchudzony do cienkiej integracji albo usunięty.
- [ ] Kod produkcyjny i testy są podzielone według odpowiedzialności i struktury z sekcji 19.
- [ ] Wszystkie nowe teksty mają polską i angielską lokalizację.
- [ ] Agent wykonał checklistę code review z sekcji 19.10.
- [ ] Implementacja jest zgodna z `docs/ai-ui-architecture-guidelines.md`.
- [ ] Publiczne elementy feature’u są eksportowane przez `task_saved_views_export.dart`.
- [ ] Nowe widgety używają `AppIcons` zamiast bezpośredniego zestawu ikon.
- [ ] Wykonano kontrolę wizualną Web/Desktop i zapisano wynik.

## 23. Zakazy

- Nie zostawiaj `_defaultView()` w ścieżce „Zapisz bieżący widok”.
- Nie odczytuj `ProjectTasksListCubit` z kontekstu menu znajdującego się ponad jego providerem.
- Nie zapisuj automatycznie widoku przy każdym kliknięciu filtra.
- Nie ignoruj błędu zapisu aktywnego widoku w preferencjach.
- Nie zamieniaj wszystkich błędów na ogólny snackbar „Spróbuj ponownie”.
- Nie wyświetlaj UUID jako nazwy osoby, etykiety lub pola własnego.
- Nie niszcz `columnOrder` przez ponowne budowanie z `Set`.
- Nie dodawaj migracji ani endpointu bez udowodnionej potrzeby.
- Nie zmieniaj innych funkcjonalności Kanbana.
- Nie nadpisuj i nie cofaj pracy innych agentów.
- Nie uznawaj zadania za skończone bez testu widgetowego pełnego przepływu.
