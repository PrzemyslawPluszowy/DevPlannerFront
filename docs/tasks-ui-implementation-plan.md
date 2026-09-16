# Veloryn Workspaces — plan wdrożenia zakładki Tasks we Flutterze

Status: plan implementacyjny  
Data analizy: 2026-08-26  
Zakres: Flutter Web, Windows, macOS i Linux  
Backend referencyjny: `veloryn-workspaces`, branch `workspace`

## Stan realizacji — 2026-08-26

Zakończony pierwszy pionowy pakiet:

- dodano `TasksRepository` i `KanbanRepository` z centralnym mapowaniem błędów;
- repozytoria są zarejestrowane w `WorkspacesModuleBindings` oraz
  `MultiRepositoryProvider`;
- dodano typowane query listy Tasks i cursorowych kolumn Kanban;
- dodano typowany adapter eventów Tasks oraz presence;
- `/tasks` i `/kanban` renderują backendowy snapshot Kanbana;
- kolumny systemowe i własne zachowują kolejność backendu;
- każda kolumna ma niezależny infinite scroll i deduplikację kart;
- ekran ma lokalny lifecycle SignalR, wskaźnik połączenia i presence bez
  ujawniania surowych identyfikatorów użytkowników;
- eventy bezpieczne do częściowego scalenia aktualizują kartę lokalnie, a
  zmiany strukturalne wykonują debounce resync;
- dodano test Cubita snapshot/presence/paginacja oraz test parsera SignalR.
- dodano desktop/web drag-and-drop także do pustej kolumny;
- pozycja jest wysyłana jako `PreviousTaskId`/`NextTaskId` wraz z
  `ExpectedVersion`, a wersja karty jest aktualizowana z odpowiedzi backendu;
- strefy dropu przed, między i za kartami są aktywnymi celami DnD; przy
  sortowaniu w tej samej kolumnie indeks jest korygowany po usunięciu karty,
  więc backend otrzymuje faktycznych sąsiadów, a nie pozycję przesuniętą o jeden;
- nadrzędny kontener kolumny nie jest już celem DnD, aby nie konkurował ze
  strefami dokładnej pozycji; strefy mają minimalną wysokość 16 px i wyraźnie
  rozszerzają się przy najechaniu przeciąganą kartą;
- DnD działa optymistycznie, aktualizuje liczniki i WIP, a błąd — w tym 409 —
  przywraca poprzedni snapshot oraz pokazuje nieblokujący komunikat;
- dodano testy sukcesu i rollbacku operacji `moveTask`.
- `/tasks/:taskId` działa jako zagnieżdżony deep link w trwałym shellu Tasks;
- otwarcie detailu nie demontuje Kanbana, więc zachowuje jego scroll, realtime i
  stan cursorów;
- pełny agregat `ProjectTaskDetailsResponse` jest ładowany przez osobny Cubit z
  jawnymi stanami forbidden/not-found/conflict/offline;
- dodano nowoczesny, responsywny panel read-only z właściwościami, opisem,
  checklistą, podzadaniami i zależnościami oraz testy Cubita.
- detail pozwala edytować tytuł, status i priorytet; statusy są ograniczone do
  przejść udostępnionych przez workflow projektu;
- zapis pól podstawowych wysyła pełny payload z `ExpectedVersion`, przyjmuje
  nową wersję agregatu z odpowiedzi, a przy 409 pobiera najnowszy detail i
  pokazuje komunikat bez nadpisania cudzych zmian;
- testy detailu pokrywają odczyt, 403, udany zapis oraz conflict refetch.
- detail pozwala ustawiać i czyścić datę rozpoczęcia, termin oraz estymację;
- walidacja blokuje ujemną/zerową estymację i termin wcześniejszy od rozpoczęcia
  jeszcze przed wywołaniem backendu;
- dodano `TaskCollaborationRepository` oraz obserwowanie i zaprzestanie
  obserwowania taska przez bieżącego użytkownika;
- po zmianie obserwowania detail pobiera pełny agregat, aby zachować spójność
  listy obserwatorów, `isWatchedByMe` i wersji taska;
- detail pokazuje responsywną sekcję obserwatorów z maksymalnie pięcioma
  avatarami, tooltipami oraz fallbackiem inicjałów; obraz jest używany wyłącznie
  gdy backend zwróci `avatarUrl`.
- dodano osobiste przypinanie taska: nie zmienia wersji współdzielonego
  agregatu, aktualizuje UI optymistycznie po potwierdzeniu backendu i nie
  wykonuje zbędnego refetchu detailu.
- poprawiono kontrakt enumów Kanban do PascalCase używanego przez backend
  (`None`, `Assignee`, `Comfortable` i pozostałe wartości); logger Retrofit
  wypisuje teraz w debuggerze surową odpowiedź oraz pełny stack trace błędu
  parsowania pod prefiksem `[KANBAN][PARSING]`.
- naprawiono desktopowy Scrollbar tablicy: poziomy `ListView` i `Scrollbar`
  współdzielą teraz prywatny `ScrollController`, więc nie korzystają błędnie z
  `PrimaryScrollController` i nie rzucają assertion bez `ScrollPosition`.
- widok Kanbana podzielono na prywatne części biblioteki (`page`, `header`,
  `columns`, `cards`, `states`), a edytor pól własnych na `section` i `editor`;
  każdy z tych plików ma mniej niż 300 linii bez zmiany publicznego API ani
  zachowania widoku.
- działania ustawień Tasks zostały wydzielone z nagłówka do osobnego komponentu;
  przy szerokości poniżej 960 px pięć ikon (etykiety, pola własne, milestone’y,
  workflow i automatyzacje) przechodzi do jednego menu, aby presence i status
  realtime pozostały widoczne zamiast przepełniać nagłówek.
- panel automatyzacji zachowuje równoległe aktualizacje stanu: późno zakończone
  pobranie historii nie nadpisuje przełącznika ani innych świeżych mutacji
  reguły; wynik dry-run jest dodatkowo wiązany z konkretną regułą i zadaniem,
  więc nie może pojawić się w innym oknie symulacji.
- dodano przełącznik Tablica/Lista w nagłówku Tasks. Lista korzysta z
  rzeczywistego endpointu cursorowego projektu, obsługuje filtry statusu i
  priorytetu, deduplikację, retry oraz bezpiecznie czyści cursor po ostatniej
  stronie; kliknięcie elementu otwiera ten sam detail zadania co Kanban.
- przy szerokości poniżej 720 px przełącznik widoku przechodzi z segmentów do
  jednego menu ikonowego, aby nie przepełniać nagłówka z presence, ustawieniami
  i stanem realtime.
- karty Kanbana respektują teraz `visibleCardFields` i `defaultCardDensity`
  zwrócone w snapshotcie: konfiguracja decyduje o etykietach, wykonawcy,
  terminie, checklistach, podzadaniach, czasie, blokadach, okładce i skrótach
  pól własnych; gęstość `Compact`/`Comfortable`/`Detailed` zmienia rytm oraz
  ilość widocznego kontekstu bez dodatkowego requestu.
- po uruchomieniu tablicy pobierane są osobiste preferencje Kanbana; zwinięcie
  kolumny systemowej lub własnej jest optymistycznie zapisywane z
  `ExpectedVersion`, a błąd przywraca poprzedni układ i pokazuje komunikat.
- dodano inline `quick create` w systemowych kolumnach: tytuł jest walidowany,
  tworzenie zawsze wysyła status kolumny, a po sukcesie snapshot jest
  odświeżany. Kontrolka nie jest pokazywana w kolumnach własnych, ponieważ
  kontrakt `CreateProjectTaskPayload` nie ma `customStatusId`.
- tablica pobiera workflow projektu przez wydzielone `TaskWorkflowRepository`;
  DnD między statusami systemowymi jest blokowane przed requestem, gdy przejście
  nie występuje w kontrakcie backendu. Przy braku odpowiedzi workflow oraz dla
  własnych statusów zachowane zostaje bezpieczne rozstrzygnięcie po stronie API.
- ta sama reguła jest użyta przez `onWillAcceptWithDetails`, dlatego niedozwolona
  strefa DnD nie podświetla się już przed upuszczeniem; backend nadal pozostaje
  ostatecznym źródłem autoryzacji i walidacji mutacji.
- panel „Przejścia workflow” w nagłówku pozwala włączać i wyłączać każdą
  kierunkową relację statusów. Zapis przekazuje komplet statusów, komplet
  przejść oraz `ExpectedVersion`; błąd nie zmienia lokalnej konfiguracji, a po
  zamknięciu panelu tablica odświeża własną macierz DnD bez ponownego wejścia na
  ekran.
- model sesji obsługuje opcjonalne `avatarUrl`; panel konta w globalnym railu
  pokazuje obraz z fallbackiem inicjałów także przy błędzie sieciowym.
- detail zadania pozwala archiwizować i przywracać zadanie z `ExpectedVersion`;
  archiwizacja ma wyraźne potwierdzenie, a konflikt korzysta z istniejącego
  bezpiecznego refetchu agregatu.
- historia cursorowa jest dostępna z nagłówka detailu: `TaskHistoryRepository`
  korzysta z `TaskAdvancedApi`, jest zarejestrowane w DI, a lokalny
  `TaskHistoryCubit` ładuje kolejne strony tylko przez czas życia dialogu;
  panel deduplikuje `eventId`, ma retry dla pierwszej i kolejnej strony oraz
  pokazuje aktora, zmiany before/after, czas i wersję zdarzenia.
- detail obsługuje pełną cykliczność przez wydzielone `TaskRecurrenceRepository`
  i lokalny `TaskRecurrenceCubit`: tworzenie na wersji agregatu taska, edycję,
  pauzę i wznowienie na wersji serii oraz odświeżenie detailu po sukcesie;
  konfigurator pokazuje harmonogram, częstotliwość, interwał, status, datę i
  `skipIfPreviousOpen`. Kontrakt nie udostępnia katalogu stref, więc UI wymaga
  jawnego identyfikatora IANA (domyślnie `Etc/UTC`) zamiast błędnego skrótu OS.
- rozpoczęto załączniki: `TaskAttachmentRepository` i jego adapter są już w DI
  oraz obejmują listę, taskowe bilety bulk i bulk-complete; załączniki są
  widoczne w detailu, a picker `file_selector` obsługuje Web i desktop.
  Adapter `TaskAttachmentPresignedUploadTransport` jest już w DI: wysyła bajty
  przez PUT bez tokenu aplikacji i bez logowania presigned URL; do wykonania
  pozostaje orkiestracja oraz UI. Orkiestracja jest już gotowa w lokalnym
  `TaskAttachmentsCubit`: żąda biletów, wykonuje upload kolejno z wynikiem per
  plik, wysyła `bulk-complete` tylko dla udanych plików i czeka na odświeżenie
  listy przed zakończeniem operacji. Natywne przeciąganie z systemu jest
  dostępne przez `desktop_drop` (Windows, macOS, Linux i Web), korzysta z tego
  samego wejścia uploadu co picker i podświetla powierzchnię dropzone.
- rozpoczęto time tracking: `TaskTimeTrackingRepository` i adapter do
  `TaskTimeTrackingApi` są w DI i obejmują listę, ręczne wpisy, start/stop
  timera oraz submit/approve/reject z `expectedVersion`. Lokalny
  `TaskTimeTrackingCubit` pobiera wpisy, wykonuje mutacje z ponownym odczytem,
  aktualizuje czas aktywnego timera z UTC i anuluje ticker w `close`; pozostał
  panel detailu i dialog wpisu ręcznego. Panel jest gotowy: pokazuje sumę,
  timer, wpisy, ręczne dodanie i przesłanie szkicu. Akcje akceptacji/odrzucenia
  są dostępne w repozytorium, lecz detail nie dostarcza access-safe uprawnienia
  do ich pokazania; UI nie zgaduje roli użytkownika i czeka na ten kontrakt.
- dodano `TaskMetadataRepository` i responsywny, wielokrotny selektor etykiet
  z katalogu projektu; zapis jest atomowy z `ExpectedVersion`, deduplikuje ID,
  przechowuje nową wersję taska i obsługuje standardowy refetch po konflikcie.
- zapis planowania zachowuje pozostałe pola oraz Delta JSON opisu, korzysta z
  tego samego mechanizmu wersjonowania i obsługi 409;
- repo nie ma obecnie wspólnego edytora Quill/Delta, dlatego rich text nie jest
  zastępowany zwykłym polem tekstowym, które mogłoby utracić formatowanie.
- dodano małe `TaskChecklistRepository` zamiast uzależniać presentation od
  szerokiego `TaskOperationsApi`; repozytorium jest zarejestrowane w DI;
- checklista w drawerze obsługuje dodawanie, ukończenie/ponowne otwarcie i
  usuwanie, pokazuje postęp oraz aktualizuje kolejne wersje agregatu;
- każda mutacja checklisty wysyła aktualne `ExpectedVersion`, a konflikt 409
  korzysta ze wspólnego bezpiecznego refetchu detailu.
- dodano osobne `TaskAcceptanceCriteriaRepository` z pełnymi mutacjami kryteriów
  akceptacji oraz rejestracją w DI;
- UI pozwala tworzyć, edytować, akceptować/cofać akceptację i usuwać kryteria;
- zarówno elementy checklisty, jak i kryteria mają pełną edycję tekstu, więc
  ich zakres obejmuje rzeczywisty CRUD, a nie tylko toggle.
- naprawiono runtime crash `ProviderNotFoundException`: wspólny
  `WorkspaceScopedRealtimeFactory` jest teraz zarejestrowany w globalnym
  `MultiRepositoryProvider`, obok fabryki Chat;
- test aplikacyjny ekranu Workspaces sprawdza obecność scoped realtime factory
  w kontekście potomnym, chroniąc routing Tasks przed regresją zakresu DI.
- detail został rozdzielony na małe pliki (`page`, `checklist`, `acceptance`,
  `dependencies`, `header`, `properties`, `shared`); każdy ma obecnie mniej
  niż 300 linii i zachowuje prywatne API biblioteki przez `part`;
- model Kanbana akceptuje kanoniczny backendowy enum `swimlaneMode: "None"`
  oraz ma test regresji serializacji/deserializacji kontraktu.
- `TasksRepository` obsługuje teraz pobranie, utworzenie i usunięcie zależności;
- drawer pozwala wyszukać zadanie projektu, wybrać typ relacji i dodać ją bez
  ręcznego wpisywania identyfikatora; blokady są wyróżnione wizualnie;
- create wykonuje kontrolowany refetch pełnego detailu, ponieważ odpowiedź
  mutacji nie zawiera bezpiecznego podglądu zadania powiązanego; delete aktualizuje
  lokalnie wersję i listę zależności.

Następny pakiet zaczyna się od pozostałych punktów Etapu 1: rejestracji
zaawansowanych API/repozytoriów, pełnego mapowania błędów na stany UI oraz cache
profili członków. Następnie należy dodać detail taska jako drawer z deep linkiem.
W Etapie 4 nadal pozostają: sprawdzenie macierzy przejść workflow przed dropem,
multi-select/bulk actions oraz obsługa klawiatury i dostępności.

## 1. Cel produktu

Zakładka Tasks ma być głównym środowiskiem pracy projektu, inspirowanym
czytelnością Monday i gęstością funkcji ClickUp, ale opartym wyłącznie na
kontraktach `veloryn-workspaces`.

Widok ma zapewniać:

- Kanban jako domyślny widok projektu;
- przełączanie między Kanbanem, listą, harmonogramem/Ganttem i workloadem;
- tworzenie i pełną edycję zadań bez opuszczania kontekstu projektu;
- ustawienia workflow, kolumn, WIP, kart, pól, etykiet, capacity i automatyzacji;
- aktualizacje realtime z odtwarzaniem zmian po reconnect;
- awatary osób aktualnie obecnych w widoku;
- filtrowanie, zapisane widoki, operacje zbiorcze i skróty klawiaturowe;
- pełne respektowanie ACL i optimistic concurrency;
- responsywny Web/Desktop bez zubożonej wersji którejkolwiek platformy.

## 2. Zweryfikowane możliwości backendu

### 2.1. Zadania i szczegóły

Backend udostępnia:

- CRUD zadań głównych i jednopoziomowych podzadań;
- archiwizację i przywracanie;
- cursorową listę z filtrami, sortowaniem i limitem do 100;
- pełny detail zadania;
- globalne numery `TASK-n`;
- status, własny status projektu, priorytet, terminy, pozycję i milestone;
- wielu wykonawców z głównym wykonawcą;
- checklistę;
- kryteria akceptacji;
- zależności, w tym blokowanie z ochroną przed cyklem;
- obserwatorów i osobiste przypięcie zadania;
- etykiety i pola niestandardowe;
- opis rich text jako Delta JSON;
- załączniki z bulk upload tickets i bulk complete;
- historię biznesową z aktorem, before/after, correlation ID i wersją;
- zadania cykliczne z pause/resume;
- szablony zadań i osobisty szablon domyślny;
- pełnotekstowe wyszukiwanie globalne;
- listę „Moje zadania” ze wszystkich projektów.

### 2.2. Kanban

Backend udostępnia:

- snapshot tablicy z konfiguracją i pierwszą stroną każdej kolumny;
- osobną cursorową paginację kolumn systemowych i własnych;
- atomowe przesunięcie jednej karty między kolumnami i w obrębie kolumny;
- `PreviousTaskId`/`NextTaskId` oraz `ExpectedVersion` dla bezpiecznego DnD;
- bulk move i bulk update do 100 kart;
- swimlanes: brak, wykonawca, priorytet albo milestone;
- limity WIP i sygnał ich przekroczenia;
- ukrywane kolumny;
- własne kolumny/statusy z nazwą, kolorem, kategorią i kolejnością;
- predefiniowane szablony workflow;
- konfigurowalne pola widoczne na karcie;
- gęstość kart;
- osobiste zwijanie kolumn i quick filter;
- dane karty: checklisty, załączniki, czas, podzadania, blokady, etykiety,
  pola własne i cover.

### 2.3. Ustawienia i narzędzia projektu

Backend udostępnia:

- konfigurację systemowego workflow i przejść;
- własne statusy oraz szablony workflow;
- etykiety projektu;
- definicje pól niestandardowych;
- zapisane osobiste widoki Tasks;
- ustawienia Kanbana wspólne dla projektu;
- osobiste preferencje Kanbana;
- milestone’y i przypisywanie do nich zadań;
- tryb automatycznego harmonogramu, preview/apply kaskady i dni wolne;
- workspace capacity i projektowe override’y użytkowników;
- workload zespołu;
- reguły automatyzacji, katalog, recipes, dry-run i historię uruchomień;
- szablony projektu i zadań;
- dashboard projektu;
- timeline/Gantt;
- time tracking, timer oraz akceptację/odrzucenie czasu;
- integracje Tasks z Whiteboard, Wiki i Corkboardem.

### 2.4. Realtime i presence

Hub: `/api/v1/realtime/tasks`.

Obsługiwane elementy:

- `SubscribeProject(workspaceId, projectId)`;
- `UnsubscribeProject(projectId)`;
- `GetProjectEvents(workspaceId, projectId, cursor, limit)`;
- eventy create/update/status/archive/restore/recurrence;
- deduplikacja przez `EventId`;
- uporządkowanie i replay przez cursor/sequence;
- automatyczna ponowna subskrypcja po reconnect;
- `project.presence.changed` z `CoreUserId` i `ConnectionCount`;
- automatyczne usunięcie z grupy po odebraniu dostępu.

Flutter ma już ogólny `WorkspaceScopedRealtimeService` obsługujący hub Tasks,
reconnect, replay i deduplikację. Brakuje typowanego adaptera domenowego oraz
podłączenia do stanu ekranu.

### 2.5. Aktualny stan Fluttera

Istnieją już klienty Retrofit i modele dla:

- podstawowego Tasks API;
- operacji zadania;
- workflow, historii, recurrence i timeline;
- saved views, My Tasks i global search;
- templates;
- capacity/workload;
- schedule;
- time tracking;
- Kanbana i jego preferencji;
- SignalR scoped realtime.

Braki:

- większość klientów nie jest rejestrowana w `WorkspacesModuleBindings`;
- brak spójnego repozytorium domenowego Tasks/Kanban;
- brak feature’u prezentacyjnego Tasks;
- brak typowanego store/reducera zdarzeń realtime;
- brak cache członków potrzebnego do awatarów;
- brak obsługi konfliktów wersji w UX;
- brak testów kontraktowych wszystkich istniejących klientów po stronie Fluttera.

## 3. Docelowy UX

### 3.1. Shell zakładki

Nagłówek projektu:

- breadcrumb workspace → projekt → Tasks;
- nazwa projektu i kolor;
- przełącznik widoku: Kanban / Lista / Timeline / Workload;
- globalne wyszukiwanie w projekcie;
- quick filters;
- zapisane widoki;
- grupa awatarów osób online z tooltipem i liczbą połączeń;
- przycisk „Nowe zadanie”;
- menu ustawień widoczne według uprawnień.

Pasek narzędzi:

- assignee, priority, milestone, label, due date, blocked i tekst;
- sortowanie i grupowanie;
- licznik aktywnych filtrów oraz reset;
- wybór wielu kart i toolbar operacji zbiorczych;
- wskaźnik połączenia realtime: online, reconnecting, offline.

### 3.2. Kanban

- poziomy scroll z zachowaniem pozycji;
- niezależny infinite scroll każdej kolumny;
- sticky header kolumny z liczbą kart i WIP;
- szybkie dodawanie zadania na dole kolumny;
- DnD między kolumnami i w kolumnie;
- optimistic update z rollbackiem przy błędzie;
- wizualizacja dozwolonego/niedozwolonego przejścia;
- ostrzeżenie WIP bez ukrywania wyniku backendu;
- swimlanes zgodne z ustawieniem backendu;
- zwinięcie kolumny jako osobista preferencja;
- gęstość compact/comfortable;
- karta pokazująca tylko pola skonfigurowane przez backend/użytkownika;
- zaznaczanie kart i bulk move/update;
- skeleton per kolumna, nie dla całej tablicy.

### 3.3. Drawer szczegółów zadania

Na dużym ekranie detail otwiera się w prawym panelu bez utraty tablicy. URL ma
zawierać `taskId`, aby refresh i deep link działały. Na małym ekranie używamy
pełnej strony.

Sekcje:

- tytuł, kod, status, priorytet i archiwizacja;
- opis rich text;
- wykonawcy i obserwatorzy;
- terminy, milestone, estymacja i zarejestrowany czas;
- etykiety i pola własne;
- checklisty i kryteria akceptacji;
- podzadania;
- zależności i blokady;
- załączniki z drag-and-drop;
- recurrence;
- timer i wpisy czasu;
- historia aktywności;
- powiązania Whiteboard/Wiki/Corkboard;
- akcja utworzenia szablonu.

## 4. Architektura Fluttera

Proponowana struktura:

```text
lib/workspaces/presentation/tasks/
├── tasks_export.dart
├── shell/
├── board/
│   ├── cubit/
│   ├── columns/
│   ├── cards/
│   ├── drag_drop/
│   └── bulk_actions/
├── list/
├── detail/
│   ├── cubit/
│   ├── overview/
│   ├── checklist/
│   ├── dependencies/
│   ├── attachments/
│   ├── time_tracking/
│   └── history/
├── filters/
├── saved_views/
├── presence/
├── timeline/
├── workload/
└── settings/
    ├── workflow/
    ├── kanban/
    ├── statuses/
    ├── labels/
    ├── custom_fields/
    ├── templates/
    ├── schedule/
    ├── capacity/
    └── automations/
```

Warstwa domenowa powinna wystawić osobne repozytoria zamiast jednego dużego:

- `TasksRepository`;
- `KanbanRepository`;
- `TaskConfigurationRepository`;
- `TaskTimeRepository`;
- `TaskScheduleRepository`;
- `TaskTemplatesRepository`;
- `TaskRealtimeRepository` albo typowany adapter serwisu scoped.

Każdy Cubit ma jedną odpowiedzialność. `TasksBoardCubit` zarządza snapshotem,
kolumnami, filtrami i optimistic DnD, ale nie formularzem detailu ani
ustawieniami. Każda cursorowa kolumna ma własny stan ładowania i cursor.

## 5. Strategia realtime

1. Ekran tworzy lokalny serwis Tasks i subskrybuje projekt.
2. Pierwszy snapshot pochodzi z REST.
3. Eventy SignalR są mapowane do typowanego `TaskRealtimeEvent`.
4. Reducer aktualizuje kartę tylko, jeśli wersja eventu jest nowsza.
5. Event częściowy aktualizuje znane pola; detail pobieramy tylko, gdy jest
   otwarty albo event nie wystarcza do spójnej aktualizacji.
6. `task.created` dodaje kartę tylko, jeśli spełnia aktywne filtry; w przeciwnym
   razie aktualizuje licznik kolumny.
7. `status_changed` przenosi kartę i aktualizuje liczniki/WIP.
8. `archived` usuwa kartę z aktywnego widoku.
9. Po reconnect wykonywany jest replay; gdy nie da się zagwarantować spójności,
   wykonujemy kontrolowany refetch tablicy.
10. Konflikt `409` anuluje optimistic update, scala nowszy snapshot i pokazuje
    nieblokujący komunikat.
11. Profile presence są ładowane poza snapshotem Kanbana, a ich niepowodzenie
    nie blokuje tablicy ani nie ujawnia identyfikatorów użytkowników.

## 6. Awatary i presence — wymagane sklejenie danych

Event presence zwraca tylko `CoreUserId` i `ConnectionCount`. Zrealizowane
sklejenie danych pobiera jeden, ACL-safe katalog aktywnych członków projektu,
cache’uje go na parę workspace/projekt i buduje mapę
`CoreUserId → displayName/avatarUrl`. UI:

- zachować fallback inicjałów i deterministycznego koloru;
- pokazuje jednego użytkownika raz, a `ConnectionCount` pozostaje agregatem
  zdarzenia realtime;
- nie interpretować presence jako członkostwa ani uprawnienia.

`ProjectMemberResponse` nadal celowo zawiera wyłącznie identyfikatory i rolę.
Warstwę prezentacyjną dostarcza nowy endpoint zbiorczy
`GET .../members/profiles`, kontrolowany ACL projektu — nie ma bezpośredniego
dostępu Fluttera do katalogu Core.

### 6.1 Awatar bieżącego użytkownika

Kontrakt Storage ma endpointy `GET`, `PUT` i `DELETE /api/v1/me/avatar/`.
Aplikacja korzysta z nich przez niezależną funkcję profilu:

- pobranie pliku avatara podczas uruchomienia sesji oraz po zmianie;
- bezpieczne pobranie obrazu przez autoryzowany strumień Storage albo bilet
  pobrania — `StorageFileResponse` nie zawiera publicznego URL;
- ustawienie avatara po istniejącym procesie uploadu (`upload-ticket` → upload
  binarny → `complete-upload` → `PUT /me/avatar`);
- usunięcie avatara i natychmiastowy fallback do inicjałów;
- wspólny komponent awatara, który obsługuje obraz, inicjały i deterministyczny
  kolor bez duplikowania logiki w railu, zadaniach i presence.

Awatar bieżącego użytkownika korzysta z prywatnego Storage, a pozostałych osób
z katalogu członków projektu. Oba źródła pozostają odseparowane i sprawdzane
przez backend Workspaces.

## 7. Plan realizacji i checklista

### Etap 0 — kontrakt i fundament

- [ ] Wygenerować aktualny OpenAPI backendu i porównać wszystkie modele Fluttera.
- [ ] Naprawić każdą rozbieżność enumów, nullability, cursorów i envelope.
- [x] Ustalić źródło nazw/avatarów dla presence.
- [x] Dodać awatar bieżącego użytkownika do panelu konta i ustawień profilu.

Zrealizowano: edycja avatara w ustawieniach profilu korzysta z istniejącego,
prywatnego Storage Workspaces (`upload-ticket` → upload binarny →
`complete-upload` → `PUT /me/avatar`) i pobiera obraz przez krótki bilet
pobrania. Karta obsługuje wybór PNG/JPEG/WebP/GIF, limit 5 MB, usunięcie oraz
fallback do inicjałów. Wspólny `CurrentUserAvatarCubit` jest ładowany przy
wejściu do sesji, czyści się przy wylogowaniu i zasila również panel konta.
- [x] Doprecyzować backendowy kontrakt publicznych danych członka projektu:
  `coreUserId`, `displayName`, opcjonalne `avatarUrl`.
- [x] Spisać macierz uprawnień per akcja i rola projektu.
- [x] Ustalić kanoniczne URL-e widoków i detailu taska.
- [x] Dodać wszystkie teksty do ARB PL/EN.

Kontrakt URL Tasks: widoki projektu używają
`/workspaces/:workspaceId/projects/:projectId/tasks?view=board|list|timeline|workload`,
a drawer szczegółu używa
`/workspaces/:workspaceId/projects/:projectId/tasks/:taskId`. Wszystkie wejścia
z Kanbana, listy, powiadomień i parsera deep linków muszą zachować tę pełną
ścieżkę; parametr `view` nie zastępuje trasy detailu.

Macierz uprawnień Tasks jest egzekwowana przez `ProjectAccessService` i nie
polega wyłącznie na ukrywaniu elementów UI:

| Akcja | Observer | Member | Admin | Owner |
| --- | :---: | :---: | :---: | :---: |
| Odczyt tablicy, list, detailu, historii, presence | ✓ | ✓ | ✓ | ✓ |
| Tworzenie i edycja zadań, DnD, checklisty, zależności, czas, komentarze | — | ✓ | ✓ | ✓ |
| Konfiguracja Kanbana, workflow, własne statusy, pola, etykiety, milestones, capacity i automatyzacje | — | — | ✓ | ✓ |
| Zarządzanie rolami Owner i trwałe usunięcie archiwalnego projektu | — | — | zależnie od roli workspace | ✓ (Owner workspace) |

Frontend ukrywa akcje administracyjne dla ról innych niż Admin/Owner; backend
każdą mutację ponownie weryfikuje jako `RequireWriteAsync`,
`RequireManageAsync` albo `RequireDeleteAsync`.

Teksty prezentacyjne modułu Tasks są pobierane przez `context.l10n` z
`app_pl.arb` i `app_en.arb`; scan widoków Tasks nie wykazuje literalnych,
niezlokalizowanych etykiet użytkownika. Dane utworzone przez użytkownika lub
opis akcji zwrócony przez backend pozostają danymi, a nie zasobami językowymi.

### Etap 1 — data/domain/DI

- [x] Zarejestrować wszystkie Tasks/Kanban API w module bindings.
- [x] Dodać małe repozytoria domenowe z `Either<ApiError, T>`.
- [x] Dodać mapowanie błędów `400/403/404/409` na jawne stany UI.
- [x] Dodać typowane modele filtrów, cursorów i operacji DnD.
- [x] Dodać adapter realtime oraz parser wszystkich eventów Tasks/presence.
- [x] Dodać cache członków i profili projektu.
- [ ] Dodać testy kontraktowe JSON dla każdego response/request.

`WorkspacesModuleBindings` tworzy i udostępnia wszystkie API oraz małe
repozytoria Tasks/Kanban przez `RepositoryProvider`; repozytoria normalizują
błędy do `Either<ApiError, T>`. Profile członków są cache’owane per para
workspace/projekt, z jawnym `forceRefresh` i `invalidate` po zmianie danych.

Audyt kontraktu trwa: aktualny Swagger backendu został pobrany z uruchomionej
aplikacji. Automatyczny verifier tras porównał `401` metod HTTP Fluttera z
`401` trasami OpenAPI i wykazał `0` brakujących oraz `0` nadmiarowych. Zweryfikowano
enumy, nullability i pola dla Kanbana, szablonów zadań oraz automatyzacji.
Test JSON automatyzacji pokrywa payloady utworzenia/aktualizacji/aktywności,
dry-run i recipe oraz odpowiedzi reguł, katalogu i historii. Pozostałe moduły
wymagają analogicznych fixture’ów, więc oba szerokie punkty kontraktowe pozostają
otwarte do końcowego audytu.

### Etap 2 — shell i routing

- [x] Dodać trasę `/workspaces/:workspaceId/projects/:projectId/tasks`.
- [x] Dodać deep link detailu `/tasks/:taskId` jako drawer/page.
- [x] Zachować Back, refresh i bezpośrednie wejście Web.
- [x] Zbudować nagłówek, view switcher, toolbar filtrów i presence.
- [x] Obsłużyć stany loading/empty/failure/forbidden/offline.

Nagłówek Tasks zawiera przełącznik Kanban/Lista/Timeline/Workload, zapisane
widoki, osobisty quick filter, akcje administratora, obecność z awatarami i
stan połączenia realtime. Akcje bulk przechodzą do drugiego wiersza na węższym
widoku, żeby zachować czytelność.

### Etap 3 — Kanban podstawowy

- [x] Załadować snapshot tablicy.
- [x] Renderować kolumny systemowe i własne w kolejności backendu.
- [x] Dodać infinite scroll per kolumna.
- [x] Dodać karty zgodne z `VisibleCardFields` i density.
- [x] Dodać quick create w kolumnie.
- [x] Dodać otwarcie detailu bez resetu scrolla.
- [x] Dodać filtry backendowe i quick filters.
- [x] Dodać skeleton/error/retry per kolumna.

### Etap 4 — DnD i operacje zbiorcze

- [x] Dodać desktop/web DnD jednej karty.
- [x] Wyliczać `previousTaskId` i `nextTaskId` po faktycznym dropie.
- [x] Wysyłać `ExpectedVersion` i przechowywać nową wersję z odpowiedzi.
- [x] Dodać optimistic update, rollback i obsługę 409.
- [x] Respektować dozwolone przejścia workflow.
- [x] Aktualizować liczniki i WIP.
- [x] Dodać multi-select, bulk move i bulk update.
- [x] Dodać obsługę klawiatury i dostępność.

Postęp częściowy: checkbox na karcie kontroluje centralny wybór w Cubicie,
a pasek w nagłówku wywołuje atomowy `bulk-move` z aktualną wersją każdej karty
i po sukcesie odświeża snapshot. Ten sam pasek wykonuje `bulk-update`
priorytetu oraz ustawienie terminu normalizowane do UTC. Do wykonania pozostaje
zbiorcza zmiana wykonawców i etykiet oraz jawne czyszczenie terminu (wymaga
jednoznacznego kontraktu backendu). Sterowanie klawiaturą jest dostępne:
`Ctrl`/`Command`+`A` zaznacza wyłącznie aktualnie wczytane karty, a `Escape`
czyści zaznaczenie.

### Etap 5 — detail i pełne możliwości taska

- [x] Edycja pól podstawowych i rich text.

Zrealizowano: edycja tytułu, statusu, priorytetu, terminów i estymacji jest
gotowa. Opis korzysta z pełnego edytora Quill na Web i desktopie: renderuje
istniejący Delta JSON, zachowuje formatowanie przy zapisie oraz zapisuje
plain-text i kanoniczny Delta z `ExpectedVersion`.
- [x] Wykonawcy i watchers.

Zrealizowano: obserwowanie, od-obserwowanie i prezentacja obserwatorów są
gotowe. Drawer pozwala też atomowo zastąpić wielu wykonawców z
`ExpectedVersion`, korzystając z ACL-safe katalogu profili projektu. Selektor
pokazuje nazwy, role i avatary z fallbackiem, deduplikuje osoby i nie ujawnia
surowych identyfikatorów użytkowników.
- [x] Checklisty i kryteria akceptacji.
- [x] Podzadania.

Postęp częściowy: detail tworzy jednopoziomowe podzadanie przez istniejący CRUD
Tasks, z `parentTaskId` rodzica i kontrolowanym odświeżeniem agregatu; sekcja
pokazuje także pusty stan. Kliknięcie podzadania otwiera istniejący
`WorkspaceTaskDetailsRoute`, dzięki czemu podzadanie używa tego samego pełnego
draweru: edycji, archiwizacji, historii i deep-linków, bez duplikowania logiki
rodzica.
- [x] Zależności i wizualizacja blokad.

Zrealizowano: wyszukiwanie zadania, tworzenie/usuwanie relacji i wizualizacja
blokad są gotowe. Detail pozwala wybrać oraz później zmienić `dependencyKind`
i `lagDays`; nowy, wersjonowany endpoint backendu aktualizuje wyłącznie parametry
harmonogramowe bez zmiany kierunku ani typu biznesowego relacji.
- [x] Etykiety i pola własne.

Postęp częściowy: odczyt, prezentacja i wersjonowana edycja etykiet są gotowe.
Warstwa danych pól własnych ma już atomowy zapis wartości i scalanie odpowiedzi
z detailem. Detail ma typowany formularz dla tekstu, liczby, daty, boolean oraz
wyboru pojedynczego/wielokrotnego. Typ `User` korzysta z ACL-safe katalogu
członków projektu i nie ujawnia surowych identyfikatorów. Konfiguracja definicji
pól na poziomie projektu jest dostępna z ustawień Tasks. Niepoprawna liczba jest
zatrzymywana w UI, także dla pola opcjonalnego — nie jest interpretowana jako
wyczyszczenie wartości.
- [x] Milestone i terminy.

Zrealizowano: data rozpoczęcia, termin i estymacja korzystają z wersjonowanego
zapisu planowania. Przypisanie milestone'u jest odczytywane z rzeczywistego
katalogu projektu i pozwala przypisać, odpiąć albo bezpiecznie zmienić kamień
milowy zgodnie z kontraktem backendu.
- [x] Załączniki bulk + drag-and-drop.
- [x] Recurrence.
- [x] Time tracking i timer.
- [x] Historia cursorowa.
- [x] Archiwizacja/przywrócenie.
- [x] Przypinanie zadania i szablony.

Postęp częściowy: przypinanie jest gotowe, a z panelu szczegółów można zapisać
aktualne zadanie jako nazwany szablon. Szybkie tworzenie na tablicy otwiera
katalog i tworzy zadanie przez endpoint zastosowania szablonu, po czym odświeża
snapshot Kanbana; gwiazdka ustawia albo czyści osobisty szablon domyślny. Brakuje
pełny edytor pól szablonu jest gotowy; katalog pozwala już zmienić nazwę
i usunąć szablon z potwierdzeniem. Edytor obsługuje tytuł, opis, status,
priorytet, daty, typ, parametry planowania, estymatę, checklistę, kryteria
akceptacji, etykiety oraz domyślnych wykonawców wybieranych z ACL-safe katalogu
członków projektu, a także typowane wartości pól własnych.

### Etap 6 — saved views i alternatywne widoki

- [x] Lista zadań z paginacją, sortowaniem i grupowaniem.
- [x] Tworzenie, edycja, wybór i usuwanie saved views.
- [x] Timeline/Gantt z zależnościami.
- [x] Preview i apply kaskady harmonogramu.
- [x] Workload z zakresem dat i capacity.
- [x] Zachowanie aktywnego widoku w URL/preferencjach.

Zrealizowano: `?view=board|list|timeline|workload` ma pierwszeństwo jako
deterministyczny deep link, a przy braku parametru aplikacja odtwarza lokalną,
per-workspace i per-projekt preferencję ostatniego widoku. Każda zmiana widoku
aktualizuje parametr przez webowy `History.replaceState`, nie zastępuje żywej
trasy AutoRoute i dzięki temu nie resetuje listy, realtime ani scrolla; desktop
korzysta z no-op implementacji tej samej abstrakcji.

Postęp częściowy: kontrakt `TaskViewsApi` ma repozytorium i DI dla CRUD
prywatnych widoków projektu, a menu nagłówka pozwala utworzyć, wybrać,
przemianować i usunąć widok. Endpoint cursorowej listy przyjmuje `savedViewId`
i po stronie backendu wykonuje definicję widoku (statusy, priorytety,
wykonawców, etykiety, udział użytkownika, terminy, wyszukiwanie, przypięcie
i sortowanie), dlatego filtry nie są niebezpiecznie nakładane na snapshot
Kanbana. Edytor zapisuje sortowanie i kierunek, grupowanie, wybór kolumn,
statusy, priorytety, udział użytkownika, przypięcie i archiwum. Nadal pozostaje
objęcie definicją widoku tablicy Kanban oraz bardziej rozbudowane selektory
wykonawców, etykiet i zakresu dat.

Postęp częściowy: widok „Lista” jest dostępny z przełącznika obok Kanbana.
Ładuje cursorową listę projektu, przekazuje wybrany `savedViewId`, deduplikuje
granice stron i otwiera istniejący detail taska. Backend wykonuje filtry oraz
sortowanie zapisanej definicji, a konfigurator widoku nie eksponuje technicznych
nazw enumów. Lista renderuje również grupy statusu, priorytetu i wykonawcy z
nazwami z ACL-safe katalogu profili projektu.
Stan paginacji rozdziela „istnieje następna strona” od „trwa request”, więc
spinner kolejnej strony pozostaje widoczny podczas pobierania, a znika dopiero
po odpowiedzi bez następnego cursora.
Po pierwszym przełączeniu oba widoki pozostają zamontowane, więc powrót do
Kanbana nie resetuje jego scrolla/realtime, a powrót do listy nie resetuje jej
cursorów ani filtrów. Skróty i panel operacji zbiorczych są aktywne wyłącznie
na widocznej tablicy, więc nie wykonują mutacji ukrytych kart podczas pracy na
liście.

Postęp częściowy: prywatna trasa „Moje zadania” korzysta z rzeczywistego
`/api/v1/me/tasks/` przez repozytorium i pokazuje pierwszą stronę jako klikalną
listę z workspace’em, projektem i terminem zamiast fałszywego stanu „brak
endpointu”. Cursorowa paginacja, deduplikacja i retry kolejnej strony są gotowe;
filtry statusu, priorytetu i udziału użytkownika również tworzą nowy cursorowy
odczyt backendu. Gotowy jest także walidowany zakres terminów „od–do”.

### Etap 7 — ustawienia projektu/Tasks

- [x] Ustawienia workflow systemowego i przejść.
- [x] Własne statusy: CRUD, reorder, WIP i fallback przy archiwizacji.
- [x] Szablony workflow i bezpieczne potwierdzenie replace.
- [x] Ustawienia Kanbana: swimlane, hidden columns, fields, density, WIP.
- [x] Osobiste preferencje: collapsed columns i quick filter.

Zwijanie kolumn systemowych i własnych oraz szybki filtr są trwałymi
preferencjami per użytkownik. Filtry `Mine`, `Unassigned`, `Blocked` i
`DueSoon` (termin od teraz do siedmiu dni UTC) są wykonywane w PostgreSQL przed
zliczaniem, pobraniem pierwszej strony i pobraniem kolejnych stron kolumn;
zmiana filtra odświeża snapshot tablicy.
Ustawienia Kanbana są już dostępne z nagłówka tablicy jako osobny panel. Panel
zawsze zaczyna od `GET .../kanban/settings`, więc bazuje na wersji konfiguracji
z backendu (a nie na niepełnym snapshotcie tablicy), a następnie zapisuje pełny
payload przez `PATCH` z `expectedVersion`. Obsługuje swimlane, widoczność
systemowych kolumn, pola kart, gęstość i limity WIP; przełączniki pozostają
lokalne aż do jawnego „Zapisz”. Po pomyślnym zapisie modal zamyka się i wymusza
odświeżenie snapshotu tablicy, więc zmienione pola kart, kolumny i gęstość są
od razu widoczne. Test cubitu pokrywa normalizację danych, brak przedwczesnego
requestu oraz kontrolę wersji.

Zweryfikowano kontrakt backendu własnego workflow: implementuje już pełne CRUD,
reorder i archiwizację z fallbackiem pod
`/custom-workflow/statuses` oraz katalog i bezpieczne zastosowanie szablonów
pod `/custom-workflow/templates`. Flutter ma zgodne modele, repozytorium i DI,
a panel ustawień obsługuje listę, utworzenie, edycję nazwy/kategorii/koloru/
default/WIP, archiwizację z fallbackiem, drag-and-drop kolejności oraz katalog
szablonów z jawnym potwierdzeniem zastąpienia. Test Cubita pokrywa fallback i
wersję archiwizacji, pełną edycję oraz payloady reorder i replace szablonu.
- [x] Etykiety projektu.

Postęp częściowy: z nagłówka Kanbana dostępny jest katalog etykiet projektu.
Obsługuje odczyt, utworzenie, zmianę nazwy i koloru oraz archiwizację z
potwierdzeniem. Ekran opiera się na rzeczywistym CRUD backendu; widoczność
mutacji dla ról będzie wymagała jawnego kontraktu uprawnień projektu.
- [x] Pola niestandardowe.

Postęp częściowy: repozytorium metadanych obejmuje już pełny CRUD definicji
pól własnych (odczyt, utworzenie, aktualizacja i archiwizacja), oddzielony od
atomowego zapisu wartości na zadaniu. Panel konfiguracji definicji pozostaje do
podłączenia; typ pola po utworzeniu nie może być w nim zmieniany, bo backend
nie udostępnia takiej mutacji. Gotowy jest też niezależny Cubit konfiguracji,
który normalizuje opcje selectów, wymaga co najmniej jednej opcji dla
`SingleSelect`/`MultiSelect` i wyznacza pozycję nowego pola.
Katalog jest dostępny z nagłówka Kanbana i umożliwia utworzenie, edycję oraz
archiwizację definicji z potwierdzeniem. Formularz wymusza opcje selectów,
czyści duplikaty i blokuje zmianę typu już istniejącego pola zgodnie z
kontraktem backendu. Pokrycie Cubita obejmuje tworzenie, normalizację opcji,
walidację, aktualizację i archiwizację.
- [x] Szablony zadań i domyślny szablon.

Postęp częściowy: warstwa danych, katalog używany przy szybkim tworzeniu,
zastosowanie szablonu oraz ustawianie i czyszczenie osobistego domyślnego
szablonu są podłączone. Katalog umożliwia zmianę nazwy i usunięcie z
potwierdzeniem. Pełny edytor zachowuje optimistic concurrency i pozwala zmienić
wszystkie pola kontraktu, w tym wykonawców, etykiety oraz typowane wartości pól
własnych.
- [x] Milestone’y.

Postęp częściowy: pełny kontrakt backendu milestone’ów jest dostępny w
warstwie domenowej i DI (lista, CRUD, odczyt przypisanych zadań oraz
przypisanie/odpięcie). Z nagłówka Kanbana można już otworzyć dopracowany panel
listy, utworzyć i edytować nazwę, opis, termin oraz status, a także usunąć
kamień milowy po potwierdzeniu. Szczegóły zadania odczytują faktyczne
przypisanie przez listę zadań każdego milestone’u i pozwalają je przypisać lub
odpiąć. Zmiana istniejącego przypisania jest celowo dwuetapowa (najpierw
odpięcie), bo kontrakt backendu nie gwarantuje atomowego przeniesienia między
milestone’ami. Panel projektu leniwie ładuje rozwijaną listę przypisanych
zadań i pozwala odpiąć zadanie bez przechodzenia do jego detailu.
- [x] Schedule mode i kalendarz dni wolnych.

Kontrakt backendowy jest kompletny: `GET /schedule` zwraca aktualny tryb,
`GET /calendar/holidays` listę dni wolnych, a `DELETE` usuwa wpis. Z nagłówka
Kanbana dostępny jest panel harmonogramu z trzema trybami, dodawaniem dnia
wolnego przez wybór daty i nazwę oraz usunięciem wpisu. Zapisy są odporne na
błędy. W edycji terminów zadania osobny przepływ kaskady najpierw pokazuje
zmienione zadania i ścieżkę krytyczną, a następnie zatwierdza atomowo kaskadę
z wersjami optimistic concurrency zwróconymi przez backend.
- [x] Capacity workspace i override’y projektu.

Postęp częściowy: pełny kontrakt `TaskCapacityRepository` jest zarejestrowany
w DI. Obejmuje odczyt i wersjonowany zapis domyślnej pojemności workspace,
listę oraz pełny CRUD override’ów projektu, a także odczyt workloadu w zakresie
dat. Ekrany wymagają osobnego, bezpiecznego źródła profili członków, aby nie
prezentować identyfikatorów `coreUserId` jako nazw użytkowników. Gotowy
`TaskCapacitySettingsCubit` pobiera oba zasoby, zapisuje domyślną capacity z
wersją i wykonuje wersjonowany CRUD override’ów. Panel jest podłączony do menu
ustawień Tasks i korzysta z ACL-safe `ProjectMemberProfilesRepository`, więc
wyświetla nazwy członków projektu zamiast surowych `coreUserId`. Widok
Workload używa tego samego katalogu profili oraz pozwala wybrać zakres dat.
- [ ] Automatyzacje: katalog, recipes, builder, dry-run i runs.

Postęp częściowy: `AutomationRepository` i jego adapter są zarejestrowane w
DI. Pokrywają pełny kontrakt backendu: listę, katalog obsługiwanych typów,
przepisy, tworzenie/edycję/archiwizację, zmianę aktywności z wersją, instalację
przepisu, dry-run i historię uruchomień. Gotowy `AutomationSettingsCubit` ładuje reguły, katalog i
przepisy, zapisuje aktywność z `ExpectedVersion`, archiwizuje oraz instaluje
przepis lokalnie po odpowiedzi backendu. Panel jest dostępny z ikony
automatyzacji w nagłówku Kanbana i pokazuje reguły, przełącznik aktywności,
archiwizację oraz instalację przepisu. Historia uruchomień jest ładowana leniwie
z ikony historii reguły i pokazuje stan, datę, czas oraz komunikat błędu bez
blokowania panelu. Dry-run wybiera rzeczywiste zadanie z pierwszej strony
projektu, nie zapisuje zmian i pokazuje dopasowanie warunków oraz planowane
akcje. Wyniki opóźnionych żądań scalają się z najnowszym stanem Cubita, dzięki
czemu historia nie cofa zmiany aktywności reguły. Kreator tworzy reguły bez
komunikacji presentation z `AutomationApi`: obsługuje nazwę, wyzwalacze
taskowe (w tym walidowany horyzont `TaskDueSoon`) oraz bezpieczne akcje
ustawienia statusu/prioritetu, wyczyszczenia terminu i utworzenia podzadania.
Kreator obsługuje też wersjonowaną edycję tych reguł oraz typowane warunki
statusu, priorytetu, terminu w ciągu liczby dni (0–365), fragmentu tytułu
(maksymalnie 500 znaków), wykonawcy oraz etykiety. Wykonawca pochodzi z
ACL-bezpiecznego katalogu profili, a etykieta z katalogu projektu; historyczne
niedostępne wartości są zachowywane bez pokazywania identyfikatorów. Test Cubita
weryfikuje payload tworzenia, pełną aktualizację, lokalne scalenie odpowiedzi i
ładowanie obu katalogów. Do pełnego zamknięcia punktu pozostają formularze
pozostałych akcji katalogu; dostępne są już także bezpieczne akcje przypisania
wykonawcy, dodania/usunięcia etykiety oraz ustawienia albo wyczyszczenia
terminu z wyborem daty i normalizacją UTC. Dostępne jest również powiadomienie
konkretnego członka z limitem treści i katalogiem ACL.

Ograniczenie buildera zweryfikowane w aktualnym kontrakcie: katalog zwraca dla
wyzwalaczy, warunków i akcji jedynie typ, opis oraz (gdzie ma zastosowanie)
`supported`. Nie zawiera schematu wymaganych parametrów ani źródeł bezpiecznych
wartości dla użytkownika i etykiety. Dlatego obecny kreator udostępnia wyłącznie
akcje o kompletnych, lokalnie walidowalnych parametrach. Pełny builder wymaga
tych metadanych w OpenAPI lub jawnej specyfikacji walidacji backendu.
- [x] Ukryć mutacje administracyjne dla ról bez uprawnień.

### Etap 8 — realtime i presence

- [x] Podłączyć lokalny lifecycle SignalR do ekranu projektu.
- [x] Dodać typowany reducer eventów.
- [x] Dodać replay, deduplikację i wersjonowanie.
- [x] Dodać indicator online/reconnecting/offline.
- [x] Dodać presence avatars z cache profili.
- [x] Dodać kontrolowany resync przy luce lub błędzie parsowania.
- [x] Zweryfikować odebranie ACL podczas aktywnej sesji.
- [x] Zweryfikować wiele kart/urządzeń jednego użytkownika.

`TaskRealtimeConnectionManager` przechowuje subskrypcje per połączenie i
projekt. Cofnięcie członkostwa projektu lub workspace wywołuje usunięcie każdej
aktywnej subskrypcji użytkownika z grupy SignalR oraz publikuje nowy presence.
Test integracyjny managera obejmuje dwie karty tego samego użytkownika i
sprawdza, że oba połączenia są odłączane, bez dotykania innych użytkowników.

Zrealizowano: endpoint `GET .../members/profiles` jest sprawdzany przez ACL
projektu i zwraca tylko `coreUserId`, nazwę, opcjonalny avatar oraz rolę.
Flutter cache’uje wynik na parę workspace/projekt, ładuje go poza krytyczną
ścieżką Kanbana i używa go w presence. Gdy katalog nie zwróci danych lub obraz
jest niedostępny, UI zachowuje deterministyczny kolor i inicjały — nigdy surowe
`coreUserId`.

### Etap 9 — jakość i dostępność

- [x] Wszystkie teksty przez ARB PL/EN.
- [ ] Semantics, focus order i pełna obsługa klawiatury.
- [x] Responsywność przy zmianie rozmiaru okna.
- [ ] Testy Web/Wasm oraz Windows/macOS/Linux w zakresie platformowym.
- [x] Testy reducerów, cursorów, filtrów i optimistic rollback.
- [ ] Widget testy Kanbana, detailu, settings i presence.
- [ ] Test integracyjny REST + SignalR + reconnect.
- [x] Test dużych danych: wiele kolumn i tysiące kart.
- [ ] Pomiar rebuildów, czasu pierwszego renderu i płynności DnD.

Zweryfikowano komponent wspólnego rozszerzalnego panelu bocznego przez
`flutter test --platform chrome` oraz `flutter test --wasm --platform chrome`.
Oba przebiegi pokrywają otwarcie, animowane rozszerzenie, Escape, wąski
viewport i stałą szerokość contentu podczas animacji. Zakres Windows/macOS/Linux
wymaga jeszcze uruchomienia w macierzy CI
na docelowych hostach, więc punkt pozostaje otwarty.

Dodano workflow `.github/workflows/flutter-tasks-quality.yml` z macierzą
Linux/Windows/macOS oraz osobnymi przebiegami Chrome/Wasm. Każdy job generuje
lokalizacje, uruchamia analizę i testy Tasks, realtime oraz layoutu; oznaczenie
punktu jako wykonane nastąpi po pierwszym zielonym przebiegu na hostach CI.

Desktopowy `AppModuleLayout` używa stabilnego stosu warstw, stałej szerokości
treści i composited transform przy zwijaniu nawigacji. Test layoutu potwierdza
brak relayoutu w klatkach animacji; pomiar czasu pierwszego renderu i liczby
rebuildów w runtime pozostaje osobnym punktem jakościowym.

Test responsywności zmienia viewport z desktopowego na compact i z powrotem,
potwierdzając zachowanie treści oraz brak overflowu po obu przełączeniach.

Wiersze tabeli Tasks mają semantyczny opis klucza, tytułu, statusu i priorytetu
oraz aktywację myszy i klawiatury przez `FocusableActionDetector` (Enter/Spacja)
na istniejącym deeplinku. Pełna macierz focus order i skrótów klawiaturowych dla
wszystkich ekranów pozostaje do audytu.
Dodano widgetowy test wiersza listy, który sprawdza renderowanie danych,
semantykę, aktywację Enter/Spacja i brak overflowu daty przy szerokości tabeli.

Test `TasksBoardCubit` tworzy snapshot 20 kolumn z 1000 kartami, zaznacza
wszystkie załadowane elementy i następnie usuwa jedno zaznaczenie. Chroni to
przed duplikacją lub gubieniem identyfikatorów przy dużej tablicy.

Pokrycie logiki obejmuje reducer zdarzeń realtime, cursorową listę i historię,
filtry listy oraz Kanbana, a także rollback optimistic DnD przy konflikcie
wersji. Osobne testy Cubitów chronią również aktualizacje wersjonowane detailu.

Warstwa realtime ma dodatkowo test kontraktowy na sztucznym transporcie:
ponowne połączenie wykonuje REST replay, emituje świeży snapshot i nie
powiela zdarzeń. Pełny test integracyjny z uruchomionym REST + SignalR nadal
pozostaje zadaniem dla środowiska E2E.

W tej sesji potwierdzono build Web/Wasm oraz debug build macOS. Weryfikacja
Windows i Linux pozostaje wymagana na natywnych hostach tych platform.

Postęp częściowy: nagłówek Kanbana zachowuje jednoliniowy układ desktopowy,
a przy szerokości poniżej 820 px przenosi akcje bulk do drugiego wiersza, aby
nie ściskać tytułu, presence ani wskaźnika realtime. Zaznaczanie kart używa
natywnego checkboxa dostępnego z klawiatury i ma semantyczną etykietę z kodem
zadania. `Ctrl`/`Command`+`A` i `Escape` mają zakres ograniczony do tablicy i
nie działają na niewczytanych stronach kolumn; do wykonania pozostaje pełna
obsługa skrótów i kolejności focusu.

## 8. Strategia uruchamiania testów podczas implementacji

Po małej zmianie uruchamiamy wyłącznie:

- `flutter analyze`;
- test zmienionego Cubita/repozytorium/widgetu;
- ewentualnie jeden sąsiedni test kontraktowy.

Pełnego `flutter test` nie uruchamiamy po każdej zmianie. Pełny zestaw jest
przeznaczony dla końca większego etapu, CI albo jawnej prośby użytkownika.

## 9. Kolejność rekomendowana

Najpierw należy dostarczyć pionowy, produkcyjny przekrój:

1. kontrakty + repozytoria + DI;
2. shell + Kanban read-only + presence;
3. detail read-only;
4. create/update + realtime;
5. DnD z concurrency;
6. pełny detail;
7. ustawienia;
8. widoki alternatywne i funkcje zaawansowane.

Nie należy zaczynać od samego wyglądu kart. Największym ryzykiem jest spójność
REST/SignalR/optimistic concurrency oraz poprawne rozdzielenie ustawień projektu
od osobistych preferencji użytkownika.

## 10. Kryterium ukończenia

Zakładka jest gotowa, gdy użytkownik może wykonać z Fluttera każdą dozwoloną
operację backendu dotyczącą Tasks/Kanban/ich konfiguracji, zmiany są widoczne
realtime na drugim kliencie, reconnect nie gubi eventów, presence pokazuje
poprawne osoby, konflikty wersji nie nadpisują cudzej pracy, a Web i desktop
oferują ten sam pełny przepływ.
