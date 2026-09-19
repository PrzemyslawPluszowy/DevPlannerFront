# DevPlanner Tasks — plan naprawy parytetu Listy i Kanbanu oraz UI

Status: plan wykonawczy po przeglądzie kodu Front i Backend  
Data: 2026-09-19  
Zakres: Front (Tasks, modal ustawień projektu), Backend (kontrakt Kanban, bez
przepisywania logiki domenowej)  
Poprzednik: `docs/recovery/tasks-list-kanban-ux-recovery-plan.md` (T0–T7,
T0–T6 domknięte, T7 odebrane na poziomie API)

## 1. Decyzje wstępne

- Nie pokazujemy kontrolki, która nie ma działającego portu. Wszystko, co
  wystawiamy w wierszu poleceń, musi wykonywać realną operację — inaczej
  odkładamy to do pakietu, który najpierw dostarcza backend.
- Preferujemy filtry po stronie PostgreSQL (istniejący pipeline), a nie
  filtrowanie w kliencie po załadowanej stronie, bo liczniki kolumn muszą
  zgadzać się z zawartością kart.
- Nie dodajemy nowych endpointów, jeśli luka da się zamknąć istniejącym
  kontraktem; jedyna planowana zmiana kontraktu to opcjonalne filtry boardu
  (N2), bo bez nich parytetu nie da się zrobić uczciwie.

## 2. Diagnoza z dowodami

### 2.1. Filtry: Lista ma ich sześć, Kanban jeden

| Kontrolka | Lista | Kanban | Dowód |
|---|---|---|---|
| Status, Priorytet, Osoba, Mój udział, Przypięte | tak | brak | `list/chrome/task_list_command_bar.dart` (`command_filter_*`) kontra `header/tasks_header_layout.dart:228` (tylko `_KanbanQuickFilterMenu`) |
| Sortowanie + kierunek | tak | brak | tamże (`command_sort`, `command_sort_direction`) |
| Grupowanie | tak (`groupBy`) | brak w UI | `swimlaneMode` występuje 2× w prezentacji Tasks i **nie jest renderowany** — Backend tylko go przechowuje i odsyła |
| Kolumny (widoczność) | arkusz kolumn | brak w UI | `hiddenColumns` obsługiwane przez Backend i model, brak ekranu |
| Zapisany widok: filtr | backend stosuje (`savedViewId` w zapytaniu listy) | **nie stosuje** | board cubit nie ma `savedViewId` (0 wystąpień); `ProjectTasksListCubit` przekazuje go w zapytaniu (`project_tasks_list_cubit.dart:296`) |

Mechanizm filtrowania na boardzie już istnieje: `KanbanBoardReader.GetBoardAsync`
stosuje osobisty szybki filtr do liczników i kart
(`Application/Kanban/KanbanBoardReader.cs:57`, `ApplyQuickFilter`), a endpoint
kolumny przyjmuje `AssigneeUserId`, `Priority`, `MilestoneId` i wykonuje je
w PostgreSQL (`Contracts/Kanban/KanbanContracts.cs:71`,
`Endpoints/Kanban/KanbanEndpoints.cs:30-42`). Klient ma te pola w porcie
(`domain/repositories/kanban_repository.dart:9-19`), ale przekazuje **tylko
kursor** (`board/cubit/tasks_board_preference_commands.dart:149,155`).

Czego brakuje po stronie Backendu: `GET /kanban` nie przyjmuje żadnych
parametrów poza identyfikatorami — więc filtr obejmowałby tylko dokładane
strony kolumn, a liczniki w nagłówkach pozostałyby niefiltrowane.

### 2.2. Przełącznik workflow na Kanbanie

`TaskListWorkflowSegmentedSwitch` jest montowany wyłącznie w Liście
(`list/project_tasks_list.dart:294`) i przełącza grupowanie listy między
statusem systemowym a statusem workflow. Na boardzie nie ma odpowiednika,
ponieważ kolumny przychodzą z Backendu: przy żywym API projekt bez własnych
statusów zwraca sześć kolumn systemowych (`customStatusId: null`), a projekt
z workflow zwraca kolumny własne. Kontrakt nie ma przełącznika źródła kolumn.

Wniosek: nie kopiujemy tego przełącznika. Kanban dostaje własne, realne
odpowiedniki (widoczność kolumn), a grupowanie torów (swimlane) wchodzi tylko
razem z renderowaniem po obu stronach — patrz N6.

### 2.3. Ustawienia boardu są nieosiągalne w UI

`presentation/tasks/settings/cubit/kanban_settings_cubit.dart` obsługuje ukryte
kolumny, limity WIP, gęstość kart i tryb swimlane, ale **nie ma ani jednego
konsumenta** — żaden plik w `lib` go nie importuje. Backend tę powierzchnię
obsługuje w pełni (`PATCH /kanban/settings`, `ProjectKanbanSettingsResponse`).
To największa pojedyncza luka discoverability w Kanbanie: funkcja istnieje od
kontraktu po Cubit i kończy się na Cubicie.

### 2.4. Menu w modalu ustawień jest wyśrodkowane

`projects/settings/widgets/project_settings_modal_frame.dart:339` —
`_NavigationButton` używa `TextButton.icon(...)` bez `alignment`. Material
centruje zawartość przycisku, a przycisk w pionowym `ListView` zajmuje pełną
szerokość 230 px, więc pozycje stoją na środku zamiast przy lewej krawędzi.
Dodatkowo pozycja zaznaczona różni się tylko kolorem tekstu.

### 2.5. Menu zapisanego widoku ma zduplikowane pozycje i złe zakotwiczenie

`views/widgets/task_saved_views_menu.dart:224` dokłada po każdej nazwie widoku
drugą pozycję „Zarządzaj", więc menu czyta się naprzemiennie. Drugie menu jest
otwierane przez `AppContextMenu.positionFor(context)` z kontekstem triggera, nie
klikniętej pozycji, więc pojawia się w tym samym miejscu co pierwsze. Tytuł
„Zapisane widoki" występuje podwójnie (nagłówek menu i nagłówek sekcji). To
regresja wprowadzona przy migracji menu w T6.

### 2.6. Modal ustawień nie korzysta z warstwy theme produktu

37 plików w `workspaces/presentation/projects/settings/**` importuje
historyczny `core/theme` albo `core/l10n` (w całym `lib` jest ich 120), a teksty
takie jak „Szukaj ustawień...", „Zobacz jako rola", „Domyślna (…)" są twarde
i poza ARB. To tłumaczy, dlaczego modal ustawień wygląda inaczej niż Lista
i Kanban, które przeszły na tokeny w T1.

### 2.7. Katalogi akcji Lista/Kanban

Komponent paska jest wspólny od T5, ale zestawy się różnią: Lista ma status,
priorytet, termin, wykonawcę, archiwizację i „Cały wynik"; Kanban ma
przeniesienie między kolumnami, priorytet i termin. Backend obsługuje więcej,
niż Kanban pokazuje: `PATCH /kanban/bulk-update` przyjmuje `assigneeIds`
i `labelIds` (`BulkUpdateKanbanTasksRequest`), czego pasek Kanbanu nie używa.

### 2.8. Zakładka Szablony przelewa się w wąskim oknie (defekt zastany)

Przy oknie 700 px szerokości modal ustawień otwiera zakładkę Szablony
i `project_template_card.dart:88` zgłasza
`A RenderFlex overflowed by 53 pixels on the right`; nagłówek karty dostaje
7,5 px, bo akcje karty są nierozciągliwalne w `Row` (`project_template_card.dart:62`).
Próg `isNarrow = constraints.maxWidth < 580` (linia 45) nie łapie tego przypadku,
bo sama lista akcji jest szersza niż próg. Defekt jest **zastany** — powtarza się
na `HEAD` po cofnięciu zmian N0 (sprawdzone testem), więc nie jest regresją
nawigacji. Naprawa wymaga decyzji o układzie akcji karty (zawijanie vs próg
liczony z szerokości akcji), dlatego trafia do N5.

## 3. Pakiety

### N0 — dwa zgłoszone defekty UI

Status: **DONE (2026-09-19)** — poniżej wynik i dowody.

Właściciel: agent UI.  
Pliki: `projects/settings/widgets/project_settings_modal_frame.dart`,
`tasks/views/widgets/task_saved_views_menu.dart`, bezpośrednie testy.

- wyrównać `_NavigationButton` do lewej (`AlignmentDirectional.centerStart`),
  dodać stałą wysokość, wcięcie i tło dla pozycji zaznaczonej;
- w menu zapisanego widoku przywrócić zwięzłe „…" w wierszu widoku, z własnym
  `Builder`, żeby drugie menu zakotwiczyło się do klikniętej pozycji; usunąć
  duplikat nagłówka i pozycję „Zarządzaj" spod każdego widoku;
- pokryć oba zachowania testami widgetowymi (wyrównanie lewej krawędzi, brak
  duplikatów pozycji, zakotwiczenie drugiego menu).

Gate: testy widgetowe, `flutter analyze`, `git diff --check`.

**Wynik N0:**

- `_NavigationButton` ma teraz jedną strukturę dla obu wariantów (panel pionowy
  i przewijany pasek kompaktowy): wyrównanie `centerStart`, stała wysokość
  `Sizes.p36`, wcięcie 8 px w wierszu i 12 px w treści, tło i obramowanie
  zaznaczenia z `AppSurfaceRoles` (`tintedBackground`/`tintedBorder`), hover
  i pressed z `hoverOverlay`/`pressedOverlay`, waga `w700`/`w600`; nagłówki
  sekcji stoją na tej samej linii 16 px co ikony pozycji;
- wiersz menu zapisanego widoku ma jedno „…" (`_SavedViewRowActions`), które
  liczy kotwicę w kontekście klikniętego wiersza, zamyka menu listy
  (`Navigator.pop`) i dopiero wtedy otwiera akcje widoku; nagłówkiem drugiego
  menu jest nazwa widoku, więc tytuł „Zapisane widoki" występuje raz;
- nowe testy: `test/workspaces/presentation/projects/settings/project_settings_modal_navigation_test.dart`
  (5 przypadków: wspólna linia tekstu pozycji i brak wyśrodkowania, stała
  wysokość wiersza, tło i obramowanie dokładnie jednej pozycji, przeniesienie
  zaznaczenia po kliknięciu, kompaktowy pasek bez błędów układu) oraz nowy
  przypadek w `task_saved_views_menu_test.dart` (jedno „…" na widok, brak
  tekstowego duplikatu, zamknięcie listy pod spodem, kotwica w klikniętym
  wierszu, brak zmiany aktywnego widoku po kliknięciu „…");
- kontrola mutacyjna: na wersji `HEAD` modala wszystkie 5 nowych testów pada,
  a po cofnięciu kotwicy w menu akcji test kotwicy pada z `Expected: > 152.0,
  Actual: <52.0>` — testy faktycznie pilnują poprawki, a nie współbieżnego stanu;
- bramki: `flutter analyze` czysty, `flutter test` 992/992, `git diff --check`
  czysty, `flutter build web --wasm` — PASS.

Uwaga: N0 **nie** usuwa twardych stringów ani importów `core/theme` z modala —
to zakres N5; przy okazji wykryto defekt z §2.8.

### N1 — parytet filtrów Kanbanu (klient)

Status: **częściowo DONE (2026-09-19)** — wykonawca, priorytet, „Wyczyść
wszystko”, plumbing filtrów i rozdział wierszy poleceń; otwarte: kamień milowy
i chipy.


Właściciel: agent Kanbanu.  
Pliki: `tasks/board/cubit/**`, `tasks/header/**`, `tasks/bulk/**`, testy.

- przekazać `priority`, `assigneeUserId`, `milestoneId` do `KanbanColumnQuery`
  przy doładowaniu kolumn i do pierwszego odczytu — **zrobione**: filtr tablicy
  żyje w koordynatorze lifecycle (`TasksBoardRuntimeCoordinator._filter`),
  `load()` wysyła go do `getBoard`, a `loadMore` dokłada go do zapytania kolumny;
- wystawić w wierszu poleceń Kanbanu: Priorytet, Osoba, Kamień milowy oraz
  „Wyczyść wszystko", obok istniejącego szybkiego filtra — **Priorytet, Osoba i
  „Wyczyść wszystko” zrobione**; kamień milowy czeka na źródło danych w hoście
  boardu (`MilestoneRepository` jest w zasięgu trasy, ale nie ma kubita listy
  kamieni poza feature’em szczegółów zadania — to osobny, mały pakiet N1b);
- pokazać aktywny filtr jako chip (istniejący `_ActiveFilterStrip` rozszerzyć
  o nowe wymiary) — **otwarte**; dzisiaj aktywny filtr widać na klawiszu
  (podświetlenie + nazwa wartości) i w licznikach kolumn;
- powiązać filtr zapisanego widoku z boardem dopiero po N2b (`savedViewId`);
  mapowanie filtra widoku na trzy parametry byłoby niepełne, więc go nie robimy.

Gate: testy Cubita (zapytanie kolumny niesie filtr), testy widgetowe command
baru, brak regresji paginacji i WIP.

**Wynik N1 (część wykonana):**

- warstwa danych: `KanbanBoardFilter` w `domain/repositories/kanban_repository.dart`
  (`isActive`, `activeCount`, `toColumnQuery`, `copyWith` z jawnym czyszczeniem
  wymiaru, equality przez `@immutable`), `KanbanApi.getBoard` i implementacja
  repozytorium przekazują trzy filtry do `GET /kanban` (retrofit wygenerowany
  ponownie przez `build_runner`);
- Cubit: `TasksBoardReady.filter` + `loadingFilter`, nowy
  `tasks_board_filter_commands.dart` (`setAssignee`, `setPriority`,
  `setMilestone`, `clearFilters`) wystawiony przez fasadę, `loadMore` dokłada
  filtr do kursora. Filtr **nie** jest preferencją, więc nie idzie do
  `PATCH /kanban/preferences`; mieszka w koordynatorze, dzięki czemu przeżywa
  nieudany odczyt i ponowienie nie wraca po cichu do pełnego projektu;
- prezentacja: nowy `_KanbanBoardFilters` (`header/tasks_header_board_filters.dart`,
  część biblioteki widoku Tasks) z klawiszami `board_filter_priority`,
  `board_filter_assignee`, `board_filter_clear`; prywatne `_CommandMenu`
  i `_CommandButton` z paska Listy wyjęte do wspólnego
  `tasks/chrome/tasks_command_menu.dart` (`TasksCommandMenu`,
  `TasksCommandButton`), więc Lista i Kanban używają jednego klawisza poleceń;
- **defekt wykryty przy tej okazji i naprawiony**: wiersz poleceń Listy był
  montowany na widoku Kanbanu (dowód: zrzut `docs/recovery/visual-captures/
  kanban_1440x900_light.png` sprzed zmiany pokazywał Status/Priorytet/Osoba/Mój
  udział/Przypięte/Sortowanie/Grupowanie/Kolumny nad tablicą), a jego kontrolki
  opisują kursorowy snapshot Listy, więc na tablicy nie działały. Teraz
  `_commandRow` montuje kontrolki Listy tylko poza widokiem tablicy. Uwaga na
  przyszłość: na widokach Timeline, Obciążenie i Cykliczne pasek Listy nadal
  wisi bez wpływu na te widoki — do rozstrzygnięcia w N3/N4;
- testy: `KanbanServiceTests` w Backendzie (N2) + `tasks_board_cubit_test.dart`
  +3 (filtr w `getBoard` i w zapytaniu kolumny oraz „Wyczyść wszystko”; brak
  zbędnego odczytu przy tym samym filtrze; filtr przeżywa nieudany odczyt),
  nowy `tasks_board_filters_test.dart` +2 (klik Priorytet → odczyt tablicy
  z filtrem, „Wyczyść wszystko” → odczyt bez filtra; brak paska Listy na
  tablicy), rozszerzony `tasks_board_route_page_test.dart` i fixture
  (`registerFallbackValue(KanbanBoardFilter.none)`, stub `getBoard` z filtrem);
- ARB: nowe klucze `tasksBoardFilterAssignee` i `tasksBoardFilterAllPeople`
  (pl/en) + `flutter gen-l10n`;
- golden: `goldens/header_desktop_1280.png` zaktualizowany świadomie
  (`--update-goldens`), bo wiersz poleceń tablicy zmienił się zgodnie z planem;
- bramki: `flutter analyze` czysty, `flutter test` 997/997 PASS,
  `flutter build web --wasm` PASS (po zmianach N1: `✓ Built build/web`),
  `git diff --check` czysty.

### N2 — Backend: opcjonalne filtry boardu

Status: **DONE dla filtrów wykonawcy, priorytetu i kamienia milowego (2026-09-19)**; `savedViewId` na boardzie pozostaje otwarty jako N2b.

Właściciel: agent Backend.  
Pliki: `Endpoints/Kanban/KanbanEndpoints.cs`, `Contracts/Kanban/KanbanContracts.cs`,
`Application/Kanban/{IKanbanBoardReader,KanbanBoardReader,KanbanService}.cs`,
testy w `Tests/`.

- dodać opcjonalne `priority`, `assigneeUserId`, `milestoneId`, `savedViewId` do
  `GET /kanban` (parametry opcjonalne, kontrakt rozszerzany addytywnie);
- zastosować tę samą predykatę w zapytaniu liczników i w zapytaniach stron
  kolumn, żeby `totalTaskCount` i WIP opisywały dokładnie to, co widać;
- przy `savedViewId` stosować filtr zapisanego widoku (te same wymiary, które
  obsługuje lista), bez zmiany kolumn i grupowania boardu.

Gate: testy Backendu dla filtrów, liczników i 404/403, live HTTP na stosie
lokalnym, `git diff --check`.

**Wynik N2 (część filtrów):**

- `Contracts/Kanban/KanbanContracts.cs`: nowy `KanbanBoardQuery`
  (`AssigneeUserId`, `Priority`, `MilestoneId`) z `IsFiltered` i
  `ToColumnQuery()`, który przenosi filtry tablicy do kursora kolumny;
- `Endpoints/Kanban/KanbanEndpoints.cs`: `GET /kanban` przyjmuje
  `[AsParameters] KanbanBoardQuery`; opis endpointu mówi wprost, że liczniki,
  karty i kursor kolumny dzielą ten sam zestaw filtrów;
- `Application/Kanban/KanbanBoardReader.cs`: nowa predykata `ApplyBoardFilter`
  dokładana do zapytania liczników, pierwszych stron kolumn oraz własnych
  kolumn razem z ich licznikiem; kursor (`EncodeCursor`/`EncodeCustomCursor`)
  powstaje z `query.ToColumnQuery()`, więc dalsze strony dziedziczą filtry, a
  użycie kursora bez filtrów kończy się `400 validation.failed`;
  `ValidateBoardQuery` odrzuca pusty UUID i niezdefiniowany priorytet;
- decyzja: `savedViewId` **nie** jest jeszcze przyjmowany. Filtr zapisanego
  widoku ma wymiary, których board nie modeluje (etykiety, zaangażowanie,
  szukanie, daty, przypięte), a §1 zabrania pokazywania kontrolki bez realnego
  portu. N2b dostarczy ten wymiar razem z wpięciem w klienta (N1);
- testy: `KanbanServiceTests` +4 (spójność licznika i kart dla priorytetu,
  kamienia milowego i wykonawcy; dziedziczenie filtrów przez kursor i odrzucenie
  kursora bez filtrów; własna kolumna z filtrem; walidacja pustych UUID i
  nieznanego priorytetu) oraz `KanbanEndpointTests` +1 HTTP (liczniki, karty i
  strona kolumny po filtrze; `400 validation.failed` dla pustego UUID;
  `400 request.invalid` dla nieczytelnego priorytetu);
- bramki: `dotnet build` (aplikacja, testy, harness) bez błędów,
  `dotnet test --filter FullyQualifiedName~Kanban` 56/56 PASS (jednostkowe, HTTP
  z realnym PostgreSQL, OpenAPI, integracyjne), `git diff --check` czysty;
- live HTTP na stosie lokalnym: **NIE URUCHOMIONE** w tym kroku. Stary proces API
  działał na poprzednim buildzie i został zatrzymany jako sprzątanie po T7;
  ponowny start z nowym buildem wymaga logowania BFF (cookie + CSRF). Zachowanie
  HTTP jest natomiast pokryte testem przechodzącym przez pełny pipeline ASP.NET
  z realnym PostgreSQL. Odbiór live zostaje w N7.

### N3 — ustawienia boardu w UI

Właściciel: agent Kanbanu.  
Pliki: nowy `tasks/settings/**` (ekran/arkusz), `header/**`, testy.

- wystawić istniejący `KanbanSettingsCubit`: widoczność kolumn, limity WIP,
  gęstość kart, pola karty;
- wejście z menu projektu dla Owner/Admin (zgodnie z §3.4 poprzedniego planu),
  nie z karty;
- WIP pokazywać w nagłówku kolumny tylko wtedy, gdy limit jest ustawiony;
- tryb swimlane **bez zmian** do czasu N6.

Gate: testy widgetowe (ACL, zapis z wersją ustawień, rollback przy 409), live
HTTP na `PATCH /kanban/settings`.

### N4 — jedno wejście do zapisanych widoków i akcje masowe Kanbanu

Właściciel: agent funkcjonalny.  
Pliki: `tasks/views/widgets/**`, `tasks/bulk/**`, `tasks/header/**`, testy.

- scalić „Widok domyślny" i „Zapisz widok" w jedno menu z akcją zapisu na górze;
- dodać do paska Kanbanu to, co Backend już przyjmuje: wykonawca i etykiety
  (`bulk-update`), obok przeniesienia, priorytetu i terminu;
- potwierdzić, że `assigneeIds` zastępuje skład (kontrakt) i pokazać to w nazwie
  akcji, żeby nie sugerować dodawania.

Gate: testy widgetowe paska i menu, testy Cubita na payload bulk-update.

### N5 — modal ustawień na tokenach i w ARB

Właściciel: agent design-system.  
Pliki: `workspaces/presentation/projects/settings/**` (37 plików), ARB.

- zamienić `core/theme`/`core/l10n` na `foundation/theme` i ARB, zaczynając od
  ramy modala i nawigacji, potem zakładki;
- przenieść twarde stringi („Szukaj ustawień...", „Zobacz jako rola",
  „Domyślna (…)") do ARB z wersją angielską;
- naprawić przelewanie się karty szablonu w wąskim oknie (§2.8):
  `project_template_card.dart:45/62/88` — próg `isNarrow` policzyć z szerokości
  akcji karty (albo zawijać akcje), a nie ze stałych 580 px;
- nie zmieniać kontraktów danych ani logiki zakładek.

Uwaga na konflikt: katalog `projects/settings/**` jest w tej chwili edytowany
przez równoległą sesję agenta (desktop PKCE/ustawienia), więc pakiet wymaga
uzgodnienia właściciela plików przed startem.

Gate: testy widgetowe modala w jasnym i ciemnym motywie, brak wystąpień
`core/theme`/`core/l10n` w zakresie, `flutter analyze`.

### N6 — decyzja o swimlane i grupowaniu Kanbanu

Właściciel: root + Backend.  
Zakres: analiza, nie implementacja bez decyzji.

- Backend przechowuje i odsyła `swimlaneMode`, ale nie grupuje kart w payloadzie;
  klient go nie renderuje. Wystawienie kontrolki teraz byłoby martwą akcją;
- wariant A: implementacja torów po obu stronach (payload + render + testy) —
  nowy pakiet, większy niż N0–N4 razem;
- wariant B: pozostawić `swimlaneMode` w kontrakcie, nie wystawiać w UI i opisać
  to w handoffie jako świadome ograniczenie.

Rekomendacja: wariant B do czasu, gdy pojawi się realna potrzeba produktowa.

### N7 — odbiór parytetu

Właściciel: root.  
Zakres: testy, live, dokumentacja.

- uruchomić pełne bramki Frontu i Backendu, w tym suite Tasks i router/shell;
- przejść live: filtr priorytetu i osoby na Kanbanie, saved view z filtrem na obu
  widokach, ustawienia boardu (WIP + ukrycie kolumny), brak martwej kontrolki;
- zapisać zrzuty 1024×768, 1440×900, 1920×1080 w light/dark po zmianach;
- zaktualizować plan i handoff w obu repozytoriach (`cmp` identyczny),
  `git diff --check` czysty.

### N8 — bezpieczny zapis ustawień widoku i wspólna powierzchnia błędów

Status: **DONE (2026-09-19)** — poniżej wynik i dowody.

Zgłoszenie właściciela: konflikt wersji preferencji Kanbana jest obsługiwany
niebezpiecznie (ponowienie niesie pola ze starego snapshotu i może nadpisać
równoległą zmianę), błędy Listy są maskowane poza arkuszem kolumn, błąd Kanbana
ma tylko nietrwały SnackBar, nieudany odczyt preferencji jest ignorowany,
a błąd ustawień Kanbana niepotrzebnie przeładowuje Listę.

Właściciel: agent Tasks (Lista + Kanban) oraz Backend dla kodów konfliktu.

Pliki (Front): `tasks/errors/tasks_view_error.dart` (nowy),
`tasks/errors/tasks_error_banner.dart` (nowy),
`tasks/chrome/tasks_error_banner_host.dart` (nowy),
`tasks/list/preferences/cubit/task_list_preference_merge.dart` (nowy),
`board/cubit/tasks_board_preference_commands.dart`, `board/cubit/tasks_board_state.dart`,
`board/cubit/tasks_board_cubit.dart`, `board/cubit/tasks_board_runtime_coordinator.dart`,
`board/cubit/tasks_board_card_commands.dart`, `board/cubit/tasks_board_bulk_commands.dart`,
`board/cubit/tasks_board_card_state_mutator.dart`, `board/tasks_project_view.dart`,
`board/tasks_board_page.dart`, `list/chrome/task_list_chrome_host.dart`,
`list/project_tasks_list.dart`, `list/preferences/cubit/task_list_preferences_cubit.dart`,
`list/preferences/cubit/task_list_preferences_state.dart`,
`list/preferences/cubit/task_list_preferences_loader.dart`,
`list/preferences/cubit/task_list_project_policy_controller.dart`,
`list/preferences/widgets/task_columns_sheet_sections.dart`, `l10n/app_{pl,en}.arb`
+ regenerowane `app_localizations*`.

Pliki (Backend): `Domain/Rules/TaskListExceptions.cs` (nowy),
`Domain/Entities/TaskListUserPreference.cs`, `Domain/Entities/ProjectTaskListPolicy.cs`,
`Application/Tasks/Handlers/TaskListConfigurationHandler.cs`,
`Infrastructure/Http/ApiExceptionMiddleware.cs`, komunikaty konfliktu w
`Application/Kanban/**` i `Application/Projects/ProjectCustomStatusService.cs`.

Zakres:

- szeregować zapisy preferencji na jeden przebieg i nie ignorować kliknięć
  zgłoszonych w trakcie zapisu;
- zamienić ślepe ponowienie na rebase intencji na świeżym snapshotcie z Backendu;
- zachować draft Listy i skalować go ze świeżym stanem serwera po konflikcie;
- pokazać trwały komunikat błędu (z „Ponów”, „Odśwież” i `traceId`) w całym
  module Tasks, a SnackBar zostawić tylko dla informacji niekrytycznych;
- rozdzielić sygnał zmian danych zadań od zdarzeń błędów;
- dodać stabilne kody konfliktu po stronie Backendu.

Gate: `flutter analyze`, pełny `flutter test`, buildy platform, testy Backendu,
`git diff --check`, `cmp` dokumentów w obu repozytoriach.

**Wynik N8:**

- **Kanban — zapis preferencji**: `TasksBoardPreferenceCommands` trzyma kolejkę
  intencji (`_ColumnCollapseIntent`, `_QuickFilterIntent`) i jedną pętlę zapisu.
  Intencja opisuje wartość docelową, a nie różnicę, więc ponowienie nakłada ją
  na świeży snapshot z Backendu i nie przenosi nieaktualnych pól, których
  użytkownik nie ruszył. Kliknięcia zgłoszone w trakcie zapisu trafiają do
  kolejnej partii zamiast zostać odrzucone; po udanym zapisie szybkiego filtra
  tablica wraca po świeży zestaw kart (`reloadBoard(force: true)`).
- **Kanban — konflikt**: po drugim konflikcie automatyczne ponawianie się
  zatrzymuje, intencja zostaje w kolejce i widoczna na ekranie, a `error` niesie
  `tasks.view.version_conflict`; „Ponów” ponawia intencję użytkownika, nie
  odświeżony stan serwera. `TasksBoardCubit.retryFailedOperation()` ponawia
  najpierw zapis, a gdy nie ma czego zapisać — odczyt preferencji.
- **Lista — zapis preferencji**: jedna szeregowana ścieżka zapisu (sortowanie,
  grupowanie i zapisany widok idą przez tę samą kolejkę co autosave, więc
  kliknięcie w trakcie zapisu nie ginie). Po konflikcie
  `mergeTaskListPreferences` scala trzy strony — świeży stan serwera,
  ostatni zapisany i draft — per pole, a szerokości kolumn per kolumna; draft
  użytkownika zostaje i to on jest ponawiany.
- **Wspólna powierzchnia błędów**: `TasksErrorBanner` (+ `TasksErrorBannerHost`)
  montowany pod nagłówkiem modułu Tasks pokazuje trwały komunikat dla Listy
  i Kanbana, z „Ponów”, „Odśwież” i `traceId`; arkusz kolumn zachowuje własny
  komunikat, bo jest modalny i zasłania banner. SnackBar z błędów mutacji
  zniknął z widoku projektu.
- **Rozdział sygnałów**: `TasksBoardReady.mutationSerial` →
  `taskDataRevision` (rośnie tylko przy zmianie danych zadań), a błędy mają
  osobne pole `TasksViewError? error` bez licznika; Lista (`task_list_chrome_host.dart`,
  `project_tasks_list.dart`) słucha wyłącznie `taskDataRevision`, więc błąd
  ustawień Kanbana nie uruchamia już przeładowania Listy.
- **Nieudany odczyt preferencji**: `_loadUserPreference` publikuje
  `tasks.view.preferences_load_failed` zamiast pustego handlera, a ponowienie
  odczytuje preferencje (`reloadUserPreference`).
- **Backend — stabilne kody**: nowe `TaskListVersionConflictException`
  i `TaskListPolicyVersionConflictException`; middleware mapuje je na
  `task_list.version_conflict` i `task_list.policy_version_conflict` (wcześniej
  ogólny `workspace.conflict`). Strażnicy wersji w encjach rzucają teraz te
  wyjątki, bo to oni odpowiadali za nieaktualny `expectedVersion`. Klient
  rozpoznaje konflikt po stabilnym kodzie (`*.version_conflict`), a sam HTTP 409
  zostaje tylko jako zapas dla odpowiedzi bez kodu domenowego. Komunikaty
  konfliktu Kanbana mówią „w innej sesji” zamiast „przez innego użytkownika”.
- Nowe testy Frontu: 4 w `test/workspaces/presentation/tasks/errors/tasks_error_banner_test.dart`
  (banner widoczny bez arkusza, „Ponów” ponawia draft, błąd odczytu bez „Ponów”,
  `traceId`), w `tasks_board_cubit_test.dart`: „ponowienie po konflikcie nie
  nadpisuje równoległej zmiany w innym polu” (dowód P0: ponowienie niesie
  `quickFilter` z serwera, nie ze starego snapshotu), „kliknięcie w trakcie
  zapisu preferencji nie jest ignorowane”, „nieudany odczyt preferencji pokazuje
  trwały błąd i da się ponowić”, a przebudowany test drugiego konfliktu dowodzi
  zachowania intencji i braku przyrostu `taskDataRevision`; w
  `task_list_preferences_cubit_test.dart`: scalenie draftu z równoległą zmianą
  sortowania, „drugi konflikt przerywa ponawianie i pokazuje trwały błąd
  z zachowanym draftem”, „zmiana sortowania w trakcie zapisu nie jest
  ignorowana” oraz rozpoznanie kodu konfliktu bez patrzenia na sam status.
- Nowe testy Backendu: `TaskListConfigurationTests.ProjectPolicyConcurrencyThrowsStableTaskListPolicyVersionConflict`,
  przebudowany `UserPreferenceConcurrencyThrowsStableTaskListVersionConflict`
  oraz HTTP-owy `TaskHttpOperationMatrixTests.TaskListConflictsUseDedicatedVersionConflictCodes`
  (200 → 409 `task_list.version_conflict` → 200 → 409 `task_list.policy_version_conflict`).
- Kontrola mutacyjna: podmiana kodów w middleware na `workspace.conflict`
  powoduje `[FAIL]` nowego testu HTTP (1 niepowodzenie), po przywróceniu pliku
  test wraca do zielonego — test pilnuje mapowania, a nie współbieżnego stanu.
- Bramki: `flutter gen-l10n` ok, `flutter analyze lib` i `flutter analyze test`
  — No issues found, `flutter test --timeout 180s` — 1017/1017 PASS,
  `dotnet build veloryn-workspaces.csproj` — 0 ostrzeżeń, 0 błędów, testy
  Backendu (filtr TaskList + macierz HTTP) — 18/18 PASS, `git diff --check`
  czysty w obu repozytoriach, `cmp` planu i handoffu w obu repozytoriach —
  identyczne.
- Świadomie przepisane testy, które pilnowały starego zachowania:
  `UserPreferenceConcurrencyThrowsDbUpdateConcurrencyExceptionOnConflict`
  (Backend, ogólny wyjątek → stabilny kod), „drugi konflikt preferencji pokazuje
  błąd i zostawia stan serwera” (Front, porzucenie intencji → zachowanie
  intencji) i „autosave przy błędzie 409 conflict automatycznie odświeża stan”
  (Front, `load()` + utrata draftu → scalenie i zachowanie draftu).
- Bramki platform: `flutter build web --wasm` — PASS, `flutter build macos` —
  PASS; Windows i Linux — NOT RUN (brak hosta na tej maszynie).

### N9 — audyt transportu i stanu operacyjnego (P0 w odzyskiwaniu sesji)

Status: **DONE (2026-09-19)** — poniżej wynik i dowody.

Zgłoszenie właściciela po odbiorze N8: cztery defekty, w tym jeden krytyczny,
który najprawdopodobniej był pierwotną przyczyną raportowanych konfliktów
Kanbana.

Zakres i naprawa:

- **P0 — transport desktopowy ponawiał każde żądanie.** `onResponse`
  bezwarunkowo wołał `_retryUnauthorized`, a wewnętrzna bramka nie sprawdzała
  statusu. Ten klient akceptuje każdy status (`validateStatus: (status) =>
  status != null`), więc odpowiedź 200 też przechodziła przez `onResponse`:
  odzyskiwanie odświeżało token i `_dio.fetch` **powtarzał udane żądanie**.
  Dla `PUT /kanban/preferences` pierwszy zapis się udawał, a replay wysyłał to
  samo `expectedVersion`, które pierwsze żądanie już zużyło — Backend słusznie
  zwracał 409, a klient raportował konflikt na żądaniu, które się powiodło.
  To samo dotyczyło każdego POST/PATCH/PUT/DELETE (podwójne operacje
  biznesowe). Warunek jest teraz dokładny: `_retryUnauthorized` przyjmuje
  `statusCode` i wychodzi, gdy nie jest to 401; `onResponse` podaje
  `response.statusCode`, `onError` — `error.response?.statusCode`, więc błąd
  sieci bez statusu nie uruchamia odzyskiwania.
- **P1 — błąd zapisu Listy cofał zmiany z czasu żądania.** `_publishFailure`
  emitowało snapshot sprzed żądania, a pętla autosave dodatkowo kasowała
  `_hasPendingSave`, więc zmiana wykonana w trakcie nieudanego zapisu znikała
  ze stanu i z kolejki. Błąd jest teraz nakładany na bieżący stan, a przy
  konflikcie bieżący draft przechodzi przez to samo scalenie co zapis (świeże
  wartości serwera dla pól, których użytkownik nie ruszył; jego zmiany zostają).
  Baseline scalenia `_lastSaved` pozostaje ostatnim **potwierdzonym** zapisem —
  świeżą wersję niesie stan, więc ponowienie używa właściwego `expectedVersion`.
- **P1 — odczyt tablicy gubił stan operacyjny.** `TasksBoardRuntimeCoordinator.load()`
  budowało `TasksBoardReady` od zera, przenosząc tylko część pól: ginęły
  `error`, `savingUserPreference`, `taskDataRevision`, `pendingTaskIds`,
  `selectedTaskIds`, `loadingColumnKeys`, `columnLoadErrors` i `isBulkSaving`.
  Niezwiązany resync po realtime mógł więc ukryć banner niezapisanej
  preferencji. Odczyt aktualizuje teraz istniejący stan przez
  `copyWith(board:, filter:)`. Ujawniony dług: zaznaczenie po operacji masowej
  czyściło się wyłącznie jako skutek uboczny przebudowy stanu, więc
  `_completeBulk` czyści je teraz jawnie.
- **P1 — log zdradzał ciało odpowiedzi.** `api_repository.dart` wypisywał
  pierwsze 800 znaków dowolnego ciała błędu, na wszystkich endpointach, także
  logowania, odzyskiwania konta i aktywacji. Zamiast treści log podaje kształt
  (`debugResponseShape`): nazwy pól dla mapy, liczbę elementów dla listy, rozmiar
  dla tekstu — nigdy wartości.

Testy dodane: `devplanner_http_transport_test.dart` +2 („successful desktop
response is never refreshed or replayed" — jedna odpowiedź, jedno żądanie, zero
odzyskiwań; „non-401 error response is not refreshed or replayed"),
`task_list_preferences_cubit_test.dart` +1 (zmiana w trakcie nieudanego zapisu
zostaje w stanie i w kolejce), `tasks_board_cubit_test.dart` +1 (resync tablicy
nie ukrywa trwałego błędu i nie cofa `taskDataRevision`), nowy
`test/core/data/api_repository_logging_test.dart` (3 przypadki: brak wartości
w logu, sam rozmiar dla tekstu/listy, ucinanie długiej listy pól).

Kontrola mutacyjna: usunięcie bramki `statusCode != 401` wysyła na czerwono oba
nowe testy transportu; przywrócenie emitowania snapshotu sprzed żądania wysyła
na czerwono test zmiany w trakcie zapisu; przywrócenie budowania stanu od zera
w `load()` wysyła na czerwono test resyncu. Wszystkie pliki przywrócone
(`grep` po markerach mutacji — zero trafień).

Bramki: `flutter analyze lib test` — No issues found, `flutter test --timeout
180s` — 1024/1024 PASS, `flutter build web --wasm` i `flutter build macos
--debug` — PASS, `git diff --check` czysty w obu repozytoriach.

Uwaga o własności plików: naprawa P0 dotknęła `lib/foundation/http/devplanner_http_transport.dart`
(moduł transportu sesji, w którym pracuje druga sesja) oraz `lib/core/data/api_repository.dart`
(legacy `core`); zmiany są punktowe (bramka statusu i sposób logowania), a testy
401-retry tej samej suity przechodzą 10/10.

## 4. Delty Backendu

| Zmiana | Rodzaj | Powód |
|---|---|---|
| `GET /kanban`: `priority`, `assigneeUserId`, `milestoneId`, `savedViewId` | **nowy kontrakt, addytywny** | bez tego liczniki i pierwsze strony kolumn nie mogą być filtrowane spójnie |
| `GET /kanban/columns/{status}` i `/columns/custom/{id}` | już istnieje | filtry wykonawcy, priorytetu i kamienia milowego działają w PostgreSQL; klient ich nie używa |
| `PATCH /kanban/settings` | już istnieje | WIP, ukryte kolumny, gęstość, pola karty, swimlaneMode; brak UI w kliencie |
| `PATCH /kanban/bulk-update` | już istnieje | przyjmuje `assigneeIds` i `labelIds`, czego pasek Kanbanu nie używa |
| `POST/PATCH /task-views` | już istnieje | zapisane widoki; zastosowanie filtra na boardzie zależy od N2 |
| `PUT /task-list/preferences` i `PUT /task-list/policy`: `task_list.version_conflict`, `task_list.policy_version_conflict` | **nowy kod błędu, addytywny** | wcześniej oba zwracały ogólny `workspace.conflict`; klient nie mógł odróżnić konfliktu ustawień widoku od innych konfliktów 409 (N8) |

## 5. Kolejność i równoległość

1. ~~N0 równolegle z N1 (różne pliki)~~ — N0 DONE, N1 pozostaje otwarte.
2. N2 równolegle z N1 (Backend), ale N1 domyka parytet dopiero po N2.
3. N3 i N4 po N1 (dzielą command bar i pasek akcji).
4. N5 dopiero po uzgodnieniu z właścicielem `projects/settings/**`; N0 zmienił
   dwa pliki w tym katalogu (`project_settings_modal_frame.dart`), więc
   właściciel N5 musi o tym wiedzieć.
5. N6 to decyzja, N7 domyka odbiór.
6. ~~N8 (bezpieczny zapis ustawień widoku i wspólna powierzchnia błędów)~~ —
   DONE 2026-09-19; N8 nie zależy od N1–N4 i nie zmienia ich zakresu, ale
   dotyka tych samych plików co N3/N4 (`board/cubit/**`, `list/preferences/**`),
   więc kolejny pakiet w tym obszarze zaczyna od stanu po N8.
7. ~~N9 (audyt transportu i stanu operacyjnego)~~ — DONE 2026-09-19; N9 dotyka
   `foundation/http` i `core/data`, czyli warstw wspólnych dla całej aplikacji,
   i był warunkiem sensowności dalszego debugowania konfliktów: dopóki każde
   żądanie desktopowe szło dwa razy, każdy zapis wersjonowany mógł zgłaszać
   fałszywy 409. Kolejne prace nad Listą/Kanbanem zakładają, że jedna akcja
   użytkownika to jedno żądanie.

## 6. Definition of Done

- Lista i Kanban mają ten sam zestaw filtrów albo jawnie udokumentowany,
  uzasadniony różny zakres oparty na kontrakcie; żadna widoczna kontrolka nie
  jest martwa.
- Zapisany widok filtruje dane identycznie w obu widokach (albo różnica jest
  opisana jako ograniczenie kontraktu).
- Ustawienia boardu (WIP, kolumny, gęstość) są osiągalne z UI dla Owner/Admin.
- Modal ustawień ma nawigację wyrównaną do lewej i nie powiela pozycji menu.
- Menu zapisanego widoku ma jedno wejście i poprawne zakotwiczenie.
- `projects/settings/**` nie importuje `core/theme`/`core/l10n`, a jego teksty są
  w ARB.
- Bramki: pełny `flutter test`, `flutter analyze`, testy Backendu, live HTTP,
  `git diff --check` i `cmp` dokumentów w obu repozytoriach.

## 7. Ryzyka i ograniczenia

- `projects/settings/**` jest aktywnie edytowany przez inną sesję — N5 może
  kolidować; bez uzgodnienia nie ruszamy tych plików.
- Rozszerzenie `GET /kanban` o filtry zmienia zachowanie liczników; wymaga
  testów na zgodność z paginacją kolumn i z limitami WIP.
- Swimlane pozostaje nieskończony po obu stronach; dopóki tak jest, nie wolno go
  wystawiać w UI.
- Parytet nie obejmuje sortowania Kanbanu: Backend sortuje karty w kolumnie
  własną kolejnością pozycji, więc „sortowanie" na boardzie wymagałoby odrębnej
  decyzji produktowej i kontraktu.
