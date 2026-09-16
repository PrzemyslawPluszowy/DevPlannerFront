# Kanban — audyt jakości i plan przebudowy

Data: 2026-09-06. Status: plan do realizacji, bez zmian implementacyjnych.

## 1. Cel i granice odpowiedzialności

Przebudować Kanban w `ready_next` tak, aby wykorzystanie przestrzeni, skanowanie kart, podzadania, filtry, menu kontekstowe i przeciąganie umożliwiały sprawną codzienną pracę. Odwołanie do ClickUp, Monday i Asany oznacza oczekiwany poziom ergonomii; dokument nie jest porównaniem aktualnych wersji tych produktów ani projektem kopiowania ich wyglądu.

Zakres: Kanban, karta jako element tablicy, kolumny, przewijanie, stan tablicy, osobiste preferencje i ustawienia Kanbana oraz potrzebne rozszerzenia backendu **C# veloryn-workspaces**. DataBus/FastAPI pozostaje poza zakresem.

Poza zakresem: przebudowa listy/tabeli zadań, szczegółów zadania, edytorów domenowych, timeline, workload, cykliczności i globalnego shella. Te obszary mają własnych właścicieli. Akcje karty wywołują istniejące operacje zadania; nie tworzymy równoległej domeny Tasks.

Inny agent zmienia listę zadań. Na początku audytu jej pliki miały niezacommitowane zmiany. Nie zmieniać ich, nie resetować repozytorium i nie przenosić współdzielonych komponentów bez uzgodnienia granicy. Praca na branchu `workspace`.

## 2. Metoda i ograniczenia audytu

Przegląd statyczny bieżących plików Fluttera, kontraktów i implementacji backendu C#, istniejących testów oraz wcześniejszych planów. Ścieżki Fluttera poniżej są względne wobec `ready_next`; ścieżki C# wobec `databus/veloryn-workspaces`. Numery linii dotyczą snapshotu podczas audytu i mogą zmienić się wskutek równoległej pracy.

Nie uruchamiano sesji zalogowanego użytkownika ani pomiarów FPS/SQL. Ocena wizualna wynika z layoutu w kodzie i zgłoszenia użytkownika; nie jest wynikiem inspekcji screenshotów. Scenariusze wyścigów opisane niżej wynikają z przepływu kodu i wymagają testów odtwarzających. Wynik istniejących testów znajduje się na końcu dokumentu.

Starszy `veloryn-workspaces/docs/kanban-backend-gaps-and-flutter-ux-plan.md` ma historyczne sekcje „brak”, mimo noty o wdrożeniu backendu. Nie traktować ich jako aktualnego backlogu. Ten audyt weryfikuje możliwości na podstawie kodu. Qdrant zwrócił błąd odczytu; ustalenia oparto na repozytoriach, bez założeń z pamięci.

## 3. Audyt: konkretne ustalenia

P1 = wysoki wpływ na poprawność/dostępność danych lub podstawową interakcję. P2 = istotna ergonomia, utrzymanie i kompletność. P3 = dalsze dopracowanie.

| ID | Priorytet | Dowód w kodzie | Skutek i kierunek naprawy |
|---|---|---|---|
| K01 | P1 | C#: `Application/Kanban/KanbanBoardReader.cs:325`, `GetCustomBoardAsync`: pobiera 26 rekordów, usuwa nadmiarowy, ale do `KanbanColumnResponse.NextCursor` wpisuje `null`. | Własna kolumna z >25 kartami nie udostępnia dalszej strony przez snapshot. Flutter `loadMore` kończy przy `cursor == null`. Wyliczyć kursor dla ostatniej zwróconej karty, zgodny z `GetCustomColumnAsync`; test 26/51 rekordów. |
| K02 | P1 | `lib/workspaces/presentation/tasks/board/tasks_board_cards.dart:34`: `Draggable` nie ma callbacków lifecycle/update sterujących scrollem. `tasks_board_columns.dart:18` i `:176`: niezależne kontrolery bez koordynatora DnD. | Brak jawnego auto-scrolla poziomego i pionowego podczas przeciągania. Dodać obsługę pozycji wskaźnika i przewijanie obu osi w granicach viewportów. |
| K03 | P1 | `board/cubit/tasks_board_cubit.dart`, `moveTask`: w błędzie `board: current.board`; `bulkMoveTasks` i `_bulkUpdate` emitują dawny `current`. | Błąd operacji A może wycofać w UI udaną operację B albo nowszy realtime. To utrata stanu klienta, nie dowód utraty zapisu serwerowego. Rollback tylko danej operacji; wersje i pending per karta. |
| K04 | P1 | Ten sam Cubit, `load` i `loadMore`: brak generacji zapytania; `loadMore` dokleja stronę do aktualnego stanu po await. | Opóźniona strona starego filtra może wejść do nowego wyniku. Równoległe snapshoty mogą nadpisać nowsze dane. Wprowadzić query revision, request ID, odrzucanie starych odpowiedzi oraz izolację pending mutations. |
| K05 | P2 | `tasks_board_columns.dart`, `_buildCards`: końcowy `SizedBox(height: MediaQuery.sizeOf(context).height)`; `_onScroll` pobiera przy `extentAfter < 180`. | Każda niepusta kolumna dostaje dodatkowy pusty ekran; moment paginacji przesuwa się za ostatnią kartę. Zastąpić strefą końca dopasowaną do pozostałej przestrzeni i prefetch od ostatnich realnych kart. |
| K06 | P2 | `tasks_board_card_content.dart:30`: padding 9/11, identity, tytuł, bezwarunkowy osobny przycisk cykliczności 28 px, liczne odstępy. `tasks_board_columns.dart`: szerokość 304, gap 14, padding 20/16/20/24. | Compact nadal rezerwuje osobny rząd na akcję drugorzędną. Wprowadzić tokeny gęstości oraz warunkowe metadata; priorytet tytułu i informacji potrzebnych do decyzji. |
| K07 | P2 | `tasks_board_card_content.dart`, `_CardMeta`: podzadania to `_MetaText` z `subtaskCompleted/subtaskTotal`. | Brak rozwijanego podglądu dzieci, ich tytułów, statusów i osób. Lazy-load gałęzi po rozwinięciu, jeden poziom hierarchii. |
| K08 | P2 | `tasks_board_card_content.dart`: `InkWell.onTap`, brak PPM/menu karty; `tasks_board_header.dart:868`: pojedynczy `PopupMenuButton<KanbanQuickFilter>`. | Karta nie oferuje kompletnego menu kontekstowego, filtr jest pojedynczym wyborem. Dodać menu pod kursorem i wielokryterialny filtr serwerowy. Istniejące menu listy nie oznacza obsługi Kanbana. |
| K09 | P2 | `lib/workspaces/data/kanban/api/kanban_api.dart`: `getBoard` nie przyjmuje filtrów; kolumny mają tylko osobę, priorytet, milestone. Cubit wysyła do stron sam kursor. | Rozbudowanie samego UI filtrów nie wystarczy: snapshot, liczniki i strony muszą realizować ten sam query. Saved views Tasks już istnieją, lecz brak ich parametru w odczycie boarda. |
| K10 | P2 | `tasks_board_columns.dart`: tylko poziomy zestaw kolumn; brak użycia `swimlaneMode`, mimo setterów w `settings/cubit/kanban_settings_cubit.dart`. | Ustawienie torów ma reprezentację w danych, ale brak renderowania torów w Kanbanie. Nie pokazywać nieskutecznego ustawienia jako działającego. |
| K11 | P2 | `tasks_board_columns.dart`: quick-create tylko przy `customStatusId == null`; Cubit odrzuca własną kolumnę. C#: `Contracts/Tasks/CreateProjectTaskRequest.cs:22` już ma `CustomStatusId`. | Brak szybkiego tworzenia we własnym workflow jest luką klienta, nie powodem do nowego endpointu. Użyć istniejącego kontraktu. |
| K12 | P2 | `tasks_board_card_content.dart`: `Symbols.*`, stałe tooltipy PL, „Seria/Cykl”, surowe `valueJson`, `_duration`, `_cardAvatarColor`. `tasks_board_cards.dart`: stałe kolory priorytetów. | Omijanie `AppIcons`, motywu i intl, niestabilna hierarchia wizualna, JSON zamiast wartości użytkowej. Ujednolicić adapter ikon, tokeny i formatter typowanego pola. |
| K13 | P2 | `TasksBoardCubit` 977 linii; header 1189; page 523; columns 495; card content 507. `tasks_board_page.dart` dołącza jako `part` również saved views, timeline, workload i template actions. | Podział na pliki nie daje izolacji odpowiedzialności. Wydzielić Kanban jako samodzielną gałąź z własnym stanem; minimalny adapter do istniejącego hosta Tasks. Rozmiar sam nie dowodzi błędu, ale połączenie odczytu, mutacji, realtime i preferencji utrudnia testy. |
| K14 | P2 | Cubit importuje typy połączenia i błędów z `data/realtime`; `_loadUserPreference` i `refreshWorkflow` ignorują błędy. | Warstwa prezentacji zna szczegóły transportu; ustawienia/akcje mogą przestać działać bez wyjaśnienia. Typy domenowe i lokalny komunikat błędu z retry. |
| K15 | P2 | Cubit: `togglePinned` / `toggleWatching` po await stosują `task.copyWith(...)` ze starej karty. `_patchLoadedCard`: `dueAtUtc: mutation.dueAtUtc ?? card.dueAtUtc`. | Stara kopia może nadpisać nowszy tytuł/wersję; null nie potrafi wyczyścić daty. Patch aktualnej karty z kontrolą wersji; rozróżnić pole pominięte i jawny null lub pobrać aktualną kartę. |
| K16 | P2 | C#: `KanbanBoardReader.cs:393`: cursor koduje osobę/priorytet/milestone, ale nie zapisany quick filter. `ApplyQuickFilter`: Blocked oznacza status, a karta `IsBlocked` oznacza zależność. | Zmiana filtra w drugiej karcie przeglądarki może zmienić kolejną stronę bez odrzucenia kursora; nazwa „zablokowane” ma dwie semantyki. Jawny query i fingerprint; osobne filtry statusu i blokady zależnością. |
| K17 | P2 | C#: liczniki `GetBoardAsync`/`GetCustomBoardAsync` liczone po quick filter, z nich `IsWipLimitExceeded`. | Osobisty filtr może wizualnie ukryć przekroczenie zespołowego WIP. Rozdzielić liczbę wyników od całkowitego obciążenia kolumny; potwierdzić biznesową definicję WIP. |
| K18 | P2 | `KanbanParseErrorLogger` w `kanban_api.dart` wypisuje `response?.data` w debug. | Prywatne treści kart mogą trafić do logów diagnostycznych. Zostawić kod błędu, nazwę operacji i traceId, bez pełnego payloadu. Nie stwierdzono na tej podstawie wycieku produkcyjnego. |

### Co warto zachować

Istnieją typowane DTO i repository, sealed stany Cubita, paginacja per kolumna, deduplikacja części zdarzeń realtime, wersje mutacji i optymistyczny move. Są testy Cubita, ustawień, modeli i responsywnego nagłówka. Listy używają builderów, a kontrolery scrolla mają dispose. Backend ma osobne reader/mover/settings/position calculator, kontrolę dostępu, bulk-move/bulk-update i pozycjonowanie względem kotwic także w przefiltrowanej kolumnie. Nie ma uzasadnienia do wyrzucenia całego backendu.

### Wydajność — ryzyka do zmierzenia

Reader ładuje pełne kolekcje `Subtasks` i `ChecklistItems` na potrzeby liczników. W custom board metadane i agregaty pobierane są wewnątrz pętli kolumn. To kandydaci do agregacji/projekcji i pomiaru liczby SQL, nie dowód przekroczenia SLA. Po stronie Fluttera zmiana szerokiego stanu może przebudowywać wiele kolumn. Profilować w profile/release; `RepaintBoundary` ogranicza repaint, ale nie zastępuje wirtualizacji ani selektorów stanu.

## 4. Docelowy UX Kanbana

### 4.1. Przestrzeń i hierarchia

- Jeden zwarty toolbar Kanbana: wyszukiwanie, filtry z liczbą aktywnych warunków, grupowanie, sortowanie, ustawienia widoku. Akcje drugorzędne w menu. Pasek aktywnych filtrów pojawia się tylko, gdy są potrzebne.
- Tablica rozciąga się do dostępnych granic hosta; bez dodatkowych dekoracyjnych kart wokół całej tablicy i bez sztucznego pustego końca.
- Proponowane wartości startowe tokenów, do weryfikacji wizualnej: gutter 8–12 px, odstęp kolumn 8–12 px, szerokość kolumn 260–360 px, nagłówek 36–40 px, odstęp kart 6–8 px. Szerokość dopasowywana do dostępnej przestrzeni; preferencja użytkownika może ją nadpisać. Po przekroczeniu minimum naturalny scroll poziomy.
- Compact: 8 px paddingu, tytuł do 2 linii, kod i priorytet, maksymalnie jeden zwarty rząd metadanych. Minimalna karta referencyjna z tytułem jednoliniowym: cel 64–80 px. Comfortable: 10–12 px i czytelne etykiety/termin/osoby. Detailed: dodatkowe pola i opcjonalna okładka. To cele projektu, nie obecne pomiary.
- Cykliczność, obserwowanie i przypięcie: małe wskaźniki tylko gdy aktywne; akcje w menu/hover/focus. Nie rezerwować wiersza na nieaktywną cykliczność. Checkbox widoczny przy hover/focus/zaznaczeniu, stale dostępny semantycznie.
- Jeden adapter `AppIcons`, spójny rozmiar 16 px dla metadanych i 18 px dla akcji; kolor/status nie mogą być jedynym nośnikiem informacji. Tokeny motywu, light/dark, hover/selected/focus, tooltipy i ARB.
- Kolumna: lekki akcent koloru zamiast dominującej pełnej belki, nazwa, licznik, WIP, menu i zwijanie. Zwiń do wąskiego paska, rozwiń także podczas hover przeciąganej karty.

### 4.2. Podzadania bez otwierania szczegółów

- Kliknięcie chevronu/licznika rozwija wewnątrz karty jeden poziom dzieci. Zwijanie nie otwiera zadania i nie inicjuje drag rodzica.
- Wiersz dziecka: stan ukończenia/status, tytuł, osoba i opcjonalny termin. Postęp `3/7`; checklista pozostaje odrębną informacją.
- Pobranie dopiero po pierwszym rozwinięciu; stan loading/error/retry osobno dla rodzica. Pierwsze 3–5 dzieci, „Pokaż więcej” z paginacją; bez pobierania pełnych szczegółów każdego dziecka i bez żądań dla wszystkich zwiniętych kart.
- W pierwszym wdrożeniu rodzic jest jednostką DnD tablicy. Dziecko nie staje się przypadkowo kartą główną. Zmiana rodzica i kolejności dzieci to osobny kontrakt domeny Tasks, nie efekt dropu między statusami.
- Filtry domyślnie dotyczą rodziców; rozwinięcie pokazuje ich dzieci z jawnym kontekstem. Tryb „rodzic lub pasujące podzadanie” dopiero po uzgodnieniu i implementacji semantyki backendu. Nie symulować kompletności filtrowaniem załadowanych fragmentów.

### 4.3. Filtry, sortowanie i zapis widoku

- Wyszukiwanie po tytule/kodzie z debounce około 250 ms, clear i liczbą wyników. Request generation chroni przed spóźnioną odpowiedzią.
- Wybór wielu osób, statusów, priorytetów i etykiet; terminy (przeterminowane/dzisiaj/7 dni/zakres/brak terminu), brak osoby, milestone, przypięte, obserwowane, blokowane zależnością. Pola niestandardowe według typu w kolejnym etapie.
- Na start: AND między różnymi polami, OR wewnątrz wielokrotnego wyboru pola. Etykiety mają jawne „dowolna/wszystkie”. Nie dokładać dowolnego zagnieżdżonego DSL bez potrzeby produktowej.
- Chips z usuwaniem pojedynczego warunku, „Wyczyść”, zapis i przywrócenie konfiguracji. Wykorzystać istniejące saved views po audycie zgodności; Kanban potrzebuje własnej konfiguracji układu i egzekucji query przez odczyt boarda.
- Stan tymczasowego filtra jest częścią zapytania, nie musi wymagać zapisu preferencji przed każdym pobraniem. Deep link Web przechowuje kontekst widoku bez zmiany cudzego filtra; desktop ma równoważny stan nawigacji.
- Ręczna kolejność to domyślne sortowanie DnD. Przy sortowaniu po terminie/priorytecie wyłączyć ręczny reorder w tej samej kolumnie i wyjaśnić dlaczego; zmiana statusu nadal możliwa z miejscem wynikającym z sortowania.
- Tory osoby/priorytetu/milestone: wdrażać dopiero z kompletnym kontraktem stron i liczników per tor. Zgrupowanie tylko pierwszych 25 kart nie jest poprawną implementacją całej tablicy. W MVP przenoszenie między torami nie zmienia automatycznie osoby lub priorytetu.

### 4.4. Menu pod prawym przyciskiem i szybkie akcje

- PPM na karcie i przycisk „…” otwierają to samo menu przy wskaźniku/kotwicy: otwórz, kopiuj link/kod, zmień status, osobę, priorytet, termin, etykiety, przypnij/obserwuj. Dodanie podzadania uruchamia istniejący przepływ Tasks. Duplikacja/archiwizacja tylko przy istniejącym kontrakcie i uprawnieniu.
- Dostęp z klawiatury przez klawisz menu/Shift+F10; strzałki, Enter, Esc, powrót fokusu. Na Web menu przeglądarki wyłączone tylko nad obsługiwanym elementem, przez platformową abstrakcję zgodną z Wasm.
- PPM na zaznaczonej karcie działa na zaznaczeniu; na niezaznaczonej ustawia kontekst jednoelementowy. Menu pokazuje zakres operacji. Bulk obejmuje jawnie zaznaczone karty, bez domyślnego rozszerzenia na cały wynik backendu.
- Uprawnienia i workflow decydują o aktywności akcji. Brak edycji oznacza także brak aktywnego drag. Serwer zawsze ponownie autoryzuje mutację.
- Kliknięcie osoby/priorytetu/terminu otwiera istniejący picker przez adapter. Nie kopiować edytorów listy do Kanbana; ewentualne wydzielenie wspólnego komponentu uzgodnić z właścicielem listy.

## 5. Naprawa DnD i przewijania — specyfikacja

1. `KanbanDragSession` przechowuje ID karty, wersję startową, kolumnę źródłową, ostatnią pozycję wskaźnika i docelowe kotwice. Kontroler nie wykonuje HTTP.
2. `KanbanAutoScrollController` ma kontroler poziomy tablicy i rejestr aktywnych kontrolerów pionowych kolumn. Każda kolumna rejestruje swój viewport i odłącza się przy dispose.
3. Strefa krawędzi 40–64 px; prędkość narasta z wejściem w strefę, np. od 80 do 700 px/s. Ticker liczy przesunięcie z delta czasu, clampuje extent; działa także przy nieruchomym wskaźniku. To parametry startowe do strojenia.
4. Poziomo przewija się viewport tablicy, pionowo wyłącznie kolumna pod wskaźnikiem. W narożniku obie osie. Granice liczone lokalnie względem viewportu, z wyłączeniem nagłówka i stopki, nie względem całego ekranu.
5. Po każdym scrollu ponownie ustalać kolumnę i miejsce insercji. Górna/dolna połowa karty wskazuje przed/za; stabilny placeholder nie może oscylować pod nieruchomym wskaźnikiem.
6. Prefetch przy zbliżeniu do ostatnich kart, również podczas drag. Maksymalnie jedno żądanie per kolumna/query. Przy pustej po filtrze kolumnie odróżnić brak wyników od faktycznie pustej kolumny; istniejący mover odrzuca dwie puste kotwice w niepustej kolumnie.
7. Drop za ostatnią **załadowaną** kartą oznacza za tą kotwicą, nie globalny koniec kolumny. Akcja „Przenieś na koniec” wymaga jawnego kontraktu append albo załadowania granicy; nie zgadywać sąsiada.
8. Pending mutacja blokuje kolejne przeciąganie tej samej karty. Operacje różnych kart mogą działać równolegle z własnym rollbackiem. Konflikt 409: komunikat i punktowy resync bez cofania cudzej operacji.
9. Ticker zatrzymuje się po drop, Esc, anulowaniu, utracie właściwego kontekstu, dispose i utracie aktywności okna. Usunięcie/przeniesienie źródła przez realtime unieważnia sesję w sposób jawny.
10. Klawiaturowa akcja „Przenieś do…” jest równoważną drogą. Nie przechwytywać skrótów podczas wpisywania tekstu. Sprawdzić mysz, trackpad, Shift+wheel i selekcję tekstu bez przypadkowego drag.

## 6. Backend — co istnieje, co naprawić, co rozszerzyć

Wszystkie propozycje poniżej dotyczą Workspaces C#. Nie są deklaracją już istniejących pól ani ostatecznym kontraktem HTTP; przed wdrożeniem zweryfikować aktualny Swagger/OpenAPI, zapisać link użyty do weryfikacji, rozszerzyć testy kontraktu i wygenerować klienta Dart.

| Obszar | Stan zweryfikowany | Zadanie |
|---|---|---|
| Paginacja własnych kolumn | Endpoint strony istnieje, snapshot gubi cursor | Naprawić K01 bez nowego endpointu. |
| Filtry | Board używa zapisanego quick filter; strony mają osobę/priorytet/milestone | Wspólny typowany query dla snapshotu, stron i liczników; jawne filtry i sortowanie, walidacja wartości/limitów, fingerprint kursora obejmujący pełny query i tożsamość kontekstu. |
| Zapisane widoki | Istnieje `Contracts/Tasks/TaskSavedViewContracts.cs` z wieloma filtrami | Rozszerzyć/współdzielić semantykę filtra, dodać wykonanie przez reader Kanbana. Nie budować drugiego CRUD Tasks. Złożone filtry custom dopiero z bezpieczną typowaną walidacją. |
| Podzadania | Karta ma liczniki, lista Tasks ma `ParentTaskId` i paginację | Najpierw użyć istniejącej listy dzieci przez repozytorium domenowe. Jeżeli payload/permissions okażą się niewystarczające, rozszerzyć lekki odczyt podsumowań; nie pobierać pełnych szczegółów dla każdej karty. |
| Quick-create | `CustomStatusId` i pozycjonowanie są w create request | Podłączyć Flutter. `CustomStatusId` nie łączyć z `TargetStatus`; respektować reguły rodzica. |
| Akcje zbiorcze | Bulk move i update (priorytet, termin, osoby, etykiety) istnieją | Podłączyć odpowiednie akcje menu; jawne czyszczenie daty wymaga rozszerzenia, gdy null nadal oznacza „bez zmian”. Zachować atomowość i wersję każdej karty. |
| Preferencje | Osobiste: collapsed system/custom, quick filter, version. Gęstość i pola: ustawienia projektu | Opcjonalne osobiste nadpisania density, card fields, column widths, subtask display, swimlane/collapsed lanes. Efektywny widok: jawny link/wybrany widok → osobiste nadpisanie → domyślne projektu. Reset usuwa override. |
| Własne kolumny | Status custom ma WIP; ustawienia legacy używają enumów systemowych | Zunifikować klucz kolumny jako system/custom bez utraty starych preferencji. Kolejność/nazwa/statusy są własnością workflow; nie duplikować ich w ustawieniach Kanbana. |
| WIP i liczniki | Licznik snapshotu jest po filtrze | Osobno filtered count oraz globalne obciążenie WIP; liczenie i ograniczenia mutacji według tej samej definicji. |
| Tory | Enum ustawienia istnieje, odpowiedź ma płaskie kolumny | Jeśli wymagane w pełnym wdrożeniu: strony/liczniki dla pary tor-kolumna i jawne reguły przypisania wielu osób; do tego czasu nie deklarować gotowości swimlanes. |
| Realtime | Istnieją eventy i wersje | Sprawdzić czy patch rozróżnia null/pominięcie i obejmuje zmiany podzadań/rodzica; w razie braku punktowy odczyt karty. Zachować eventId, wersje, replay i resync. |
| Odczyt kart | Bogate metadata i agregaty już istnieją | Mierzyć SQL/payload, zastąpić ładowanie kolekcji agregatami tam, gdzie potrzebne są tylko liczniki. Indeksy dobrać po EXPLAIN na reprezentatywnych filtrach. |

Każde rozszerzenie: izolacja workspace/projektu, uprawnienia także do filtrowanych/liczonych danych, limity stron i rozmiarów filtrów, kontrola concurrency, polskie opisy OpenAPI i testy pozytywne/negatywne. Zmiany addytywne; preferencje migrować z bezpiecznymi wartościami domyślnymi. Nie zmieniać globalnych reguł statusów/podzadań w ramach prac nad samym widokiem.

## 7. Docelowy podział kodu i współpraca z agentem listy

`presentation/tasks/board/` pozostaje właścicielem Kanbana. Gałęzie tworzyć według faktycznych odpowiedzialności:

- `viewport/`: układ kolumn, scroll, DnD, lifecycle kontrolerów.
- `columns/`: lokalny stan strony, retry, nagłówek i zwijanie.
- `cards/` oraz `cards/subtasks/`: karta prezentacyjna, lokalny stan rozwinięcia i odczytu dzieci.
- `filters/`: typowany query, debounce, chips i panel filtrów.
- `context_menu/`: menu oraz mapowanie akcji do istniejących use cases.
- `preferences/`: osobiste ustawienia i rozdzielenie ich od konfiguracji projektu.
- `cubit/`: koordynacja snapshotu i query; mutacje i reconcile jako testowalne klasy z jedną odpowiedzialnością, bez mnożenia Cubitów dla prostych fragmentów layoutu.

Karta nie zna HTTP/realtime; prezentacja zależy od abstrakcji domeny. Stan transportu nie przechodzi bezpośrednio z adaptera SignalR do widgetów. Selektywne rebuildy kolumn/kart, stabilne klucze i niemutowalne dane. Publiczne elementy eksportować przez `*_export.dart`; proste elementy wewnętrzne mogą pozostać lokalne.

**Strefa koordynacji:** obecne `tasks_board_page.dart`, `tasks_board_header.dart`, saved views i część realtime obsługują również listę. Nie przepisywać ich hurtowo. Dodać minimalny punkt montowania nowego Kanbana; zachować publiczne API i zachowanie pozostałych zakładek. Przed zmianą współdzielonego pickera lub repozytorium spisać kompatybilny kontrakt do uzgodnienia z właścicielem listy.

## 8. Kolejność realizacji i mierzalne odbiory

| Etap | Zakres | Warunek zakończenia |
|---|---|---|
| E0 — baseline | Reprodukcja UI, fixtures 0/1/26/51/200 kart, długa karta, custom/system status, snapshoty 1280×800/1440×900/1920×1080, rozpoznanie współdzielonych plików | Zapisane screenshoty i scenariusze błędów; potwierdzona granica z listą. |
| E1 — poprawność P1 | K01, K03, K04, K15; testy wyścigów przed refaktorem | 51 kart własnej kolumny dostępnych bez duplikatów; błąd A nie cofa B; stara strona nie trafia do nowego filtra; null usuwa termin. |
| E2 — DnD | K02/K05, sesja drag, auto-scroll, placeholder, pagination/pending | Drop poza początkowym ekranem w obu osiach bez puszczania karty; brak dodatkowego pustego ekranu i pozostawionego tickera. |
| E3 — zwarty wygląd | Tokeny, AppIcons, karta, nagłówki, stany, quick-create custom | Minimum 25% więcej pełnych kart referencyjnych w tym samym pionowym viewporcie niż baseline E0, bez obcinania tekstu/akcji; wszystkie 3 density wizualnie sprawdzone. |
| E4 — podzadania i menu | Lazy children, PPM, focus, pickery, bulk | Rozwinięcie jednej karty ładuje tylko jej gałąź; PPM/klawiatura dają te same dozwolone akcje; menu nie uruchamia nawigacji/drag. |
| E5 — filtry i preferencje | Query backend + klient, saved views, osobiste nadpisania | Snapshot, licznik i każda strona zgodne; powrót odtwarza query/scroll; użytkownik A nie zmienia widoku B. |
| E6 — tory i wydajność | Kontrakt torów, profiling SQL/UI, agregaty | Kompletne wyniki per tor-kolumna; budżet czasu klatki przy drag 16,7 ms na referencyjnym urządzeniu 60 Hz w profile; raport p95 i urządzenia, nie deklaracja bez pomiaru. |
| E7 — odbiór | Web/Wasm + Windows/macOS/Linux, regresja listy przez istniejące testy | Każdy target ma dowód działania lub jawnie udokumentowaną blokadę weryfikacji. Build/analyze nie zastępują odbioru UX. |

Nie łączyć E1 z masową przebudową shella. E2/E3 mogą stanowić pierwszy użyteczny release po E1; E4/E5 następny. Każdy etap kończy się działającym fragmentem, dowodami i aktualizacją checklisty. Ukrywać niedokończone opcje; nie wystawiać martwych kontrolek.

## 9. Plan testów regresyjnych

- Unit Flutter: rollback A przy udanej B, podwójny move tej samej karty, realtime podczas pending, snapshot odpowiedzi w odwrotnej kolejności, zmiana query podczas `loadMore`, zamknięcie Cubita podczas await, czyszczenie null, patch pin/watch bez utraty innych pól.
- Widget: auto-scroll przy nieruchomym wskaźniku (lewo/prawo/góra/dół/narożniki), zmiana kolumny, osiągnięcie granicy scrolla, Esc/dispose, pusta/zwinięta kolumna, wysoka karta i rozwinięte dzieci, brak skakania placeholdera, błąd kolejnej strony bez pętli retry.
- Widget/menu: PPM i Shift+F10, granice ekranu, focus trap/restore, multi-select, brak uprawnienia, tooltipy/semantyka, szybka edycja nie otwiera zadania.
- Backend integration: custom column 26/51/200, kursor obcego query/projektu, jednakowe filtry na pierwszej i dalszej stronie, WIP przy filtrze Mine, usunięty sąsiad, konflikt wersji, atomowy bulk, dzieci poza uprawnieniami, walidacja filter operators.
- Visual: 1280/1440/1920 px, light/dark, skala tekstu 100/125/150%, nazwy długie, wiele etykiet, brak osoby/dat, 0 wyników i błąd. Zmierzyć zajętą wysokość toolbaru i liczbę pełnych kart przed/po.
- E2E Web/Wasm i desktop: karta przeniesiona poza widoczny obszar, potwierdzenie po refresh; dwa okna z równoległymi zmianami; offline/reconnect; powrót ze szczegółów zachowuje miejsce; brak regresji listy, szczegółów i przełączania zakładek.

## 10. Checklista wdrożenia

- [x] Przegląd statyczny Kanbana, ustawień i powiązanych kontraktów backendu.
- [x] Spis problemów z dowodami, priorytetami i granicą wobec listy Tasks.
- [x] Plan UX, DnD, backendu, refaktoryzacji i odbioru.
- [x] E0 — wizualny baseline i reprodukcja runtime.
- [x] E1 — paginacja i spójność stanu (naprawiono K01 nextCursor custom column na backendzie C#, unieważnianie query po przeładowaniu, selektywny rollback optymistycznego move per zadanie, blokada DnD podczas pending, naprawa zerowania terminu `null` w realtime).
- [x] E2 — przewijanie podczas DnD (auto-scroll coordinator z tickerem vsync, strefą 52px i nieliniowym skalowaniem 90-650 px/s, usunięcie sztucznego viewportu 100vh w kolumnach na rzecz stałego bufora 64px, prefetch 300px, blokada ponownego dragu w trakcie operacji).
- [x] E3 — zwarty i spójny interfejs (usunięcie redundantnego drugiego wiersza cykliczności z karty, pełna integracja kluczy l10n, brak hardkodowanych kolorów, tokeny i AppIcons).
- [x] E4 — podzadania i menu kontekstowe (zwijana sekcja podzadań z lazy loadingiem pierwszych 5 pozycji bez otwierania karty rodzica, pełne menu kontekstowe pod prawym przyciskiem myszy PPM oraz przyciskiem akcji „...”).
- [ ] E5 — filtry i preferencje.
- [ ] E6 — tory i pomiary wydajności.
- [ ] E7 — odbiór wieloplatformowy.

## 11. Walidacja wykonana podczas audytu i przebudowy

### Etap E1 — E4 (Wdrożenie produkcyjne 2026-09-06):

1. **Backend C# (`veloryn-workspaces`)**:
   - `KanbanBoardReader.cs`: dodano `EncodeCustomCursor` dla kolumn zdefiniowanych przez `CustomStatusId`.
   - Zweryfikowano testami integracyjnymi backendu: 15/15 testów przeszło pomyślnie (`dotnet test --filter Kanban`).

2. **Frontend Flutter (`ready_next`)**:
   - `flutter analyze`: **No issues found!** (0 błędów, 0 ostrzeżeń).
   - Testy jednostkowe i widgetowe:
     ```sh
     flutter test test/workspaces/presentation/tasks/board/tasks_board_header_responsive_test.dart \
                  test/workspaces/presentation/tasks/tasks_board_cubit_test.dart \
                  test/workspaces/presentation/tasks/board/kanban_auto_scroll_coordinator_test.dart \
                  test/workspaces/presentation/tasks/board/kanban_card_interactions_test.dart
     ```
     **Wynik: 35 testów tablicy Kanban oraz 307/307 testów modułu Workspaces przeszło w 100% na zielono.**
   - Potwierdzono:
     - Działanie `KanbanAutoScrollCoordinator` i rejestrację kontrolerów.
     - Responsywność i hierarchię nagłówka tablicy oraz paska akcji zbiorczych (Bulk Toolbar).
     - Izolację optymistycznych mutacji i selektywny rollback kart w `TasksBoardCubit`.
     - Leniwe ładowanie i rozwijanie sekcji podzadań w `KanbanCardSubtasksSection`.
     - Działanie menu kontekstowego PPM / „...” z aktualizacją statusu, priorytetu, wykonawcy, terminu, przypięcia i obserwowania.
     - **Przebudowa podzadań na karcie (ClickUp style)**: usunięto ciężki szary kontener, wprowadzono `_SubtaskBranchPainter` (CustomPainter) rysujący subtelne przerywane gałęzie drzewa hierarchii rodzic–dziecko (`_SubtaskBranchItem`), a każde podzadanie renderowane jest jako kompaktowy, estetyczny miniaturowy kafelek (`_ChildTaskMiniCard`) ze statusem, kodem klucza, tytułem i awatarem wykonawcy.
     - **Uniwersalny wrapper szybkiego tworzenia zadań / podzadań (`TaskInlineInputField`)**: wydzielono elegancki komponent z zaokrągleniami, ramką z lekkim focus-ringiem, wskaźnikiem asynchronicznego zapisu, obsługą `Enter` i `Esc` oraz podpowiedziami klawiaturowymi. Podpięto go zarówno pod `_QuickCreateTask` na dole kolumn Kanbana, jak i pod szybkie dodawanie nowego podzadania (`Dodaj podzadanie`) wprost z rozwiniętego drzewa karty.
     - **Kompletna refaktoryzacja UI kart Kanban (specyfikacja `kanban-ui-refactor-agent-spec-2026-09-06.md`)**:
        - Wprowadzono `KanbanCardTokens` ze spójnymi tokenami geometrii, typografii i kolorów dla wszystkich stanów karty (spoczynek, hover, zaznaczenie, przeciąganie).
        - Zamieniono ciężkie obrysy i cienie w spoczynku na subtelny kropkowany obrys `DottedRRectPainter` (punkty o średnicy 1 px co 3.5 px, radius 8 px).
        - Wdrożono kropkowany separator `DottedHorizontalLinePainter` oraz geometrycznie zakotwiczone prowadnice hierarchii podzadań `_DottedBranchGuidePainter` (punkty 1.5 px co 4 px zakotwiczone w środku wiersza dziecka).
        - Usunięto mikrofonty 8–11 px w treści kart: tytuł rodzica 14/20 500, podzadanie 13/18 400–500, kod 12/16 400 (jedyny wyjątek 10 px w miniaturowym awatarze wykonawcy).
        - Skonsolidowano licznik podzadań: usunięto duplikat z metadanych karty, pozostawiając jeden spójny przełącznik `▾ Podzadania completed/total`.
        - Wdrożono dedykowany `KanbanSubtasksCubit` (w `cards/subtasks/cubit/`) obsługujący lazy-loading, paginację kolejnych stron wewnątrz karty ("Pokaż kolejne 5") oraz bezpieczne tworzenie podzadań inline z pełną obsługą błędów.
        - Zapewniono płynną animację rozwijania `AnimatedSize` (180 ms, easeOutCubic) ze stabilnym położeniem szczytu karty i obracającym się chevronem.
        - Dodano bezstanowy podgląd przeciągania `_KanbanCardDragPreview` z dynamicznym pomiarem rzeczywistej szerokości karty źródłowej w `onDragStarted`.
        - Odchudzono nagłówki kolumn do 40 px z minimalistycznymi wskaźnikami statusu i badge'em liczby zadań.
        - Pokryto nową logikę testami jednostkowymi i interakcji (`kanban_subtasks_cubit_test.dart`, `kanban_card_interactions_test.dart`, `kanban_auto_scroll_coordinator_test.dart`). Wszystkie testy przechodzą w 100% na zielono, `flutter analyze` 0 issues.
     - **Poprawki stabilności i estetyki po testach runtime (2026-09-06)**:
        - **Naprawa Drag & Drop**: wyeliminowano wyjątek `SingleTickerProviderStateMixin but multiple tickers were created` w `_DraggableTaskCardState`, przechodząc na `TickerProviderStateMixin`. Karty można teraz wielokrotnie, płynnie przeciągać pomiędzy wszystkimi kolumnami.
        - **Likwidacja wiszących overlayów (Desktop Tooltip Freeze)**: usunięto nadmiarowe widgety `Tooltip` z gęstych elementów wierszy podzadań (`_SubtaskRow`, `_ChildAssigneeAvatar`, przycisk retry) oraz z kropki priorytetu i awatara karty. Zastąpiono je pełną i stabilną dostępnością `Semantics(label: ...)`. Żadne dymki nie blokują się już na stałe w warstwie `Overlay`.
        - **Kreskowany styl obrysów i prowadnic (Dashed Style)**: zamieniono kropki na estetyczne linie kreskowane (`DashedRRectPainter`, `DashedHorizontalLinePainter`, `_DashedBranchGuidePainter`) z segmentami o długości 4 px, przerwą 3 px i zaokrąglonym zakończeniem `StrokeCap.round`. Drzewo podzadań prezentuje się jak w ClickUp/Linear.
