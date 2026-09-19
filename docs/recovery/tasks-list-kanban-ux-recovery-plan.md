# DevPlanner Tasks — plan domknięcia Listy i Kanbanu

Status: plan wykonawczy po audycie kodu, historii i kontraktów Backend  
Data: 2026-09-19  
Zakres: aktywny pion Tasks we Flutterze; Backend wyłącznie tam, gdzie audyt
ujawni rzeczywistą lukę kontraktu

## 1. Decyzja produktowa

DevPlanner nie otrzymuje osobnego ekranu „Przegląd” przed projektem. Kliknięcie
projektu prowadzi bezpośrednio do Zadań. Lista i Kanban są równorzędnymi
widokami jednego modułu i używają:

- jednego nagłówka projektu;
- jednego paska widoków i poleceń;
- jednego modelu filtrów, zapisanych widoków i zaznaczenia;
- jednego systemu menu kontekstowych;
- tych samych reguł uprawnień, błędów, realtime i optimistic concurrency.

Kanoniczny adres projektu to `/workspaces/:workspaceId/projects/:projectId/tasks`
i otwiera Listę. Kanban używa `?view=kanban`. Timeline, Workload i Recurrence
mogą pozostać zakładkami Tasks, ale nie mogą wypierać podstawowych akcji Listy
i Kanbanu.

Nie budujemy makiety ani placeholdera. Każda widoczna akcja ma działać na
rzeczywistym typed porcie albo nie jest renderowana.

## 2. Diagnoza

### P0 — trasa Listy omija właściwy moduł Tasks

`TasksBoardRoutePage._content` montuje pełny `TasksBoardPage` wyłącznie dla
literalnego `initialView == 'kanban'`. Brak query, `list`, `board`, `timeline`,
`workload` i `recurrence` prowadzą bezpośrednio do `ProjectTasksList`.

To jest bezpośrednia przyczyna obrazu ze screenshotu: Lista nie dostaje
wspólnego nagłówka, switchera, głównego CTA, saved views, user hub, ustawień ani
pełnej kompozycji realtime. Timeline, Workload i Recurrence są w praktyce
nieosiągalne po zmianie URL, mimo że istnieją w kodzie. Test route page utrwala
ten split zamiast chronić wspólny shell.

Pliki:

- `lib/workspaces/presentation/tasks/board/tasks_board_route_page.dart`;
- `test/workspaces/presentation/tasks/board/tasks_board_route_page_test.dart`;
- `lib/workspaces/presentation/tasks/board/tasks_board_page.dart`.

### P0 — kontrakt query jest niespójny

`DevPlannerRouteCatalog.projectTasks` buduje adres bez query, podczas gdy
`TasksProjectViewHost._viewFromQuery` traktuje brak query jako Board. Zmiana
widoku zapisuje wartości `board|list|timeline|workload|recurrence`, lecz route
page rozpoznaje wyłącznie historyczne `kanban`. Dodatkowo sidebar porównuje
surowy URI z query, więc `?view=list` nie zaznacza Listy. Rezultatem jest
nieprzewidywalny widok startowy, błędne zaznaczenie menu i utrata widoku po
przebudowie routera.

Pliki:

- `lib/app/router/devplanner_router.dart`;
- `lib/app/router/devplanner_router_pages.part.dart`;
- `lib/workspaces/presentation/tasks/board/tasks_project_view.dart`;
- `lib/app/shell/devplanner_shell_navigation.dart`.

### P0 — widoczne pozycje bez aktywnej funkcji

Drzewo pokazuje Whiteboard, Wiki, Corkboard i Automatyzacje, ale aktywna metoda
`_path` zwraca dla nich `null`. W Tasks najważniejszym skutkiem jest martwa
pozycja Automatyzacje obok działających Listy i Kanbanu. Do czasu jawnego
reaktywowania pionu nie wolno prezentować jej jak aktywnej funkcji.

### P1 — istniejący bogaty nagłówek nie tworzy jednego kontraktu UX

Kod ma rozbudowany `_BoardHeader`, lecz nazwa, układ i warunki są nadal
kanbanocentryczne. Lista dokłada pod nim osobny `TaskListFilters`, własne
kontrolki kolumn i pływający bulk bar. Kanban ma osobne quick filters, akcje
tworzenia i bulk. Użytkownik dostaje dwa różne produkty zamiast dwóch widoków
tych samych danych.

### P1 — trzy konkurencyjne systemy menu

Aktywne Tasks korzysta równolegle z:

- `TaskContextMenu` / `WorkspaceContextMenu`;
- `AppContextMenu` z wariantami `flat` i `glass`;
- surowych `PopupMenuButton` i `showMenu`.

Różnią się promieniem, cieniem, paddingiem, wysokością, typografią,
pozycjonowaniem i zachowaniem klawiatury. Część wspólnych menu nadal importuje
historyczny `core/theme`, a wariant `flat` hardkoduje kolory.

### P1 — gęstość została pomylona z miniaturyzacją

Globalny theme ustawia m.in. `labelMedium` i `labelSmall` na 10 px. Lokalnie
pojawiają się kolejne wartości 10–12 px. Jednocześnie chipy, kapsuły, obramowania
i zaokrąglenia zajmują więcej miejsca niż sam tekst. Efekt jest jednocześnie
ciasny i mało czytelny.

### P1 — funkcje Backend są słabo odkrywalne

Backend oraz typed frontend obsługują m.in. quick create, grupy, edycję
list-item, bulk przez selection token, saved views, szablony, workflow,
timeline, workload, recurrence, historię, zależności, checklistę, obserwowanie,
kryteria akceptacji, załączniki, timer, harmonogram, etykiety, pola własne,
ustawienia Kanbanu, własne statusy, WIP, paginację kolumn, bulk move/update i
realtime. Większość implementacji już istnieje, ale dojście jest rozproszone
między headerem, menu wiersza/karty, szczegółem i ustawieniami projektu.

### P2 — warstwa wizualna omija tokeny

W aktywnym Tasks występują hardkodowane powierzchnie jasne/ciemne, teksty poza
ARB oraz lokalne style. Utrudnia to uzyskanie spójności jasnego i ciemnego
motywu oraz skalowania tekstu.

## 3. Docelowy UX

### 3.1. Wejście i nawigacja

- Usunąć widoczny „Przegląd” jako pośredni krok do pracy projektowej.
- Kliknięcie projektu otwiera Listę zadań.
- Dzieci projektu pokazują co najmniej `Lista`, `Kanban` i `Pliki`.
- Aktywna zakładka i sidebar wynikają wyłącznie z URL.
- Back/Forward, refresh Web i restart desktopu zachowują widok i query.

### 3.2. Wspólny nagłówek Tasks

Nagłówek ma dwie zwarte warstwy:

1. wiersz kontekstu, 44–48 px: breadcrumb/nazwa projektu, licznik, zakładki
   Lista/Kanban/Timeline/Workload/Cykliczne, główne `Dodaj zadanie` oraz menu
   projektu;
2. wiersz poleceń, 36–40 px: wyszukiwanie, filtry, zapisane widoki, sortowanie,
   grupowanie, kolumny i akcje zależne od aktualnego widoku.

Po zaznaczeniu elementów drugi wiersz staje się jednym contextual bulk bar,
identycznym dla Listy i Kanbanu. Nie wolno renderować drugiego pływającego
bulk bara nad zawartością.

### 3.3. Lista

- header tabeli 36 px, wiersz bazowy 36–40 px, grupa 40 px;
- checkbox, klucz i tytuł pozostają stabilne przy poziomym scrollu;
- tytuł ma najwyższy kontrast; metadane i klucz są wtórne;
- edycja inline zachowuje optymistyczny stan, rollback i błąd z `traceId`;
- resize/reorder/visibility kolumn są częścią jednego menu `Kolumny`;
- filtry pokazują aktywny stan i dają `Wyczyść wszystko`;
- `Zaznacz wszystkie wyniki` używa istniejącego selection token, nie tylko
  załadowanej strony;
- menu wiersza i prawy klik wystawiają ten sam zestaw akcji zależny od ACL;
- pusty stan ma jedną wyraźną akcję utworzenia zadania i informację o filtrach.

### 3.4. Kanban

- używa dokładnie tego samego nagłówka i command baru co Lista;
- kolumna ma zwarty header: nazwa, licznik, WIP, dodawanie i menu;
- karta eksponuje tytuł, klucz, priorytet, osobę, termin i sygnały blokady;
  pozostałe metadane są opcjonalne w preferencjach;
- DnD zachowuje placeholder, stan zapisu, rollback 409 i komunikat przyczyny;
- paginacja kolumn, collapsed columns i quick filter nie resetują scrolla;
- bulk update/move korzysta ze wspólnego contextual bara;
- ustawienia boardu, workflow i WIP są dostępne z menu projektu dla
  Owner/Admin, a nie rozrzucone po karcie.

### 3.5. Typografia, kolor i spacing

- Inter pozostaje fontem produktu;
- podstawowy tekst danych: 13 px / 18 px;
- nagłówek kolumny i kontrolki: 12 px / 16 px, 600;
- metadane: 11–12 px / 16 px; tekst interaktywny nie schodzi do 10 px;
- spacing opiera się na 4 px: 4/8/12/16/24;
- główny canvas ma jedną powierzchnię; separację tworzą cienkie linie i rytm,
  nie kapsuły wokół każdej kontrolki;
- niebieski akcent oznacza wybór i akcję, kolory statusów pozostają semantyczne;
- radius: 6–8 px dla menu/pól, 12 px tylko dla większych paneli;
- light/dark nie zawierają lokalnych `Colors.white`, `Colors.black` ani
  osobnych ręcznych teł Tasks.

### 3.6. Jedno menu kontekstowe

Docelowo istnieje jedna powierzchnia menu dla Tasks i wspólnych modułów:

- wiersz 32 px, ikona 16 px, tekst 12–13 px;
- sekcje, skróty klawiaturowe, selected, disabled i destructive;
- ten sam komponent dla kliknięcia `…`, prawego kliknięcia i pickerów;
- poprawne pozycjonowanie w root overlayu, focus trap, Escape i powrót focusu;
- brak wariantu glass w produktywnych widokach danych;
- brak importu `core/theme`.

## 4. Mapa funkcji Tasks do ekspozycji

| Obszar | Stan kodu | Docelowe dojście |
|---|---|---|
| create / quick create / template | istnieje | główne CTA z menu split-button |
| filtry / sort / group / columns | istnieje | wspólny command bar |
| saved views | istnieje | command bar, widoczna nazwa i dirty state |
| selection token / bulk | istnieje | jeden contextual bar Lista/Kanban |
| move / reorder / DnD | istnieje | inline + Kanban z rollbackiem |
| archive / restore / pin | istnieje | jedno menu wiersza/karty |
| assignees / labels / custom fields / milestone | istnieje | inline + szczegół |
| history / checklist / acceptance / dependencies | istnieje | szczegół zadania |
| watchers / attachments / recurrence / timer | istnieje | szczegół + skróty w menu |
| timeline / workload / recurrence manager | istnieje | zakładki wspólnego headera |
| workflow / WIP / board settings | istnieje | menu projektu, tylko ACL |
| automations | klient i UI istnieją, brak aktywnej trasy | poza tym pakietem do jawnej decyzji |

## 5. Plan dla agentów

Pakiety mają być wykonywane w tej kolejności. Agent nie może poszerzać swojego
zakresu ani „przy okazji” zmieniać sąsiedniego modułu.

### T0 — testy charakterystyczne i kontrakt trasy

Status: **DONE (2026-09-19)** — jeden host dla wszystkich widoków, `/tasks` =
Lista, `?view=kanban` = Kanban, alias `board` wejściowy, sidebar i wejście
projektu z adresu, brak widocznego „Przeglądu”. Dowody i ograniczenia w
`docs/devplanner-standalone-refactor-handoff.md` (wpis UX-T0). Bramki: pełny
`flutter test` 884/884, `flutter analyze` bez uwag, `git diff --check` czysty.

Właściciel: agent integracyjny.  
Pliki: router, route catalog, shell selection, `tasks_project_view` i testy.

- zamrozić `/tasks` = Lista oraz `?view=kanban` = Kanban;
- zawsze montować jeden pełny `TasksBoardPage`/host dla wszystkich widoków;
- usunąć route-level bypass do gołego `ProjectTasksList`;
- zachować alias wejściowy `kanban`, ale wewnętrznie używać jednego kanonicznego
  enum/query contract;
- projekt prowadzi bezpośrednio do Tasks;
- usunąć widoczny pośredni „Przegląd” bez kasowania bezpiecznego fallbacku dla
  konta bez workspace'u;
- pokryć deep link, query, refresh, Back/Forward i restart;
- nie zmieniać API ani UI tabeli/boardu.

Gate: router/shell tests, scoped analyzer, `git diff --check`.

### T1 — tokeny Tasks i typografia

Status: **DONE (2026-09-19)** — `DevPlannerTasksTheme` z typografią, geometrią
i powierzchniami Tasks, globalne etykiety 12/11 px, zero rozmiarów poniżej 11 px
i zero `Colors.white`/`Colors.black` w module. Bramki: pełny `flutter test`
913/913, `flutter analyze` bez uwag, `git diff --check` czysty, goldeny
odświeżone. Dowody i ograniczenia: wpis UX-T1 w handoffie.

Właściciel: agent design-system.  
Pliki: `foundation/theme`, nowy mały `tasks_theme` ThemeExtension i testy.

- dodać tokeny headera, command baru, tabeli, Kanbanu i menu;
- podnieść czytelność interaktywnych etykiet bez utraty gęstości;
- usunąć hardkodowane powierzchnie z aktywnego Tasks;
- nie przebudowywać widgetów funkcjonalnych.

Gate: light/dark, 100/125/150% text scale, golden/widget geometry, analyzer.

### T2 — jedna infrastruktura menu

Status: **DONE (2026-09-19)** — jeden komponent `AppContextMenu` z tokenami
`DevPlannerMenuTheme`, sekcjami, skrótami, klawiaturą, focusem, prawym klikiem
i pozycjonowaniem w root overlayu. `TaskContextMenu`, `WorkspaceContextMenu`
i wariant `glass` usunięte; 48 wywołań w 22 plikach Tasks zmigrowane. Bramki:
pełny `flutter test` 929/929, `flutter analyze` bez uwag, `git diff --check`
czysty. 12 surowych `PopupMenuButton` zostaje w powierzchniach T4/T6 zgodnie
z podziałem pakietów. Dowody: wpis UX-T2 w handoffie.

Właściciel: agent menus.  
Pliki: `shared/presentation/widgets/*context_menu*`, adapter Tasks i testy.

- wybrać jeden publiczny komponent;
- przenieść `TaskContextMenu`, `WorkspaceContextMenu` i aktywne użycia
  `AppContextMenu` na ten kontrakt;
- zachować funkcje i ACL, usunąć `glass` z aktywnego Tasks;
- dodać prawy klik, klawiaturę, focus i pozycjonowanie.

Gate: testy menu/pickerów/row actions/card actions; brak `core/theme` w zakresie.

### T3 — wspólny Tasks chrome

Status: **DONE (2026-09-19)** — nagłówek przeniesiony do
`lib/workspaces/presentation/tasks/header/` i przemianowany na `TasksHeader`,
montowany przez moduł dla wszystkich widoków. Zawsze dwa wiersze na tokenach
(`contextRowHeight` 44–48, `commandRowHeight` 36–40), jeden switcher, CTA,
zapisane widoki, menu projektu i jeden kontekstowy slot akcji masowych. API bez
`GoRouter` (nawigację dostarcza trasa). Bramki: pełny `flutter test` 934/934,
`flutter analyze` bez uwag, `git diff --check` czysty, golden odświeżony.
Selekcja i katalog akcji Listy/Kanbanu do unifikacji w T4/T5. Dowody: wpis UX-T3
w handoffie.

Właściciel: agent composition.  
Pliki: `tasks/board/tasks_board_header*`, nowy neutralny katalog
`tasks/header`, composition tests.

- przemianować i przenieść kanbanocentryczny header do wspólnego Tasks;
- zbudować dwa wiersze opisane w 3.2;
- jeden switcher, create CTA, saved views i menu projektu;
- jeden contextual bulk slot;
- API widgetu nie może znać klientów HTTP ani `GoRouter`.

Gate: ten sam header w testach Listy i Kanbanu, responsive 1024–1920 px.

### T4 — domknięcie Listy

Status: **DONE (2026-09-19)** — filtry, sortowanie, grupowanie i kolumny
w wierszu poleceń wspólnego nagłówka; pływający `TaskListBulkBar` usunięty,
a akcje masowe Listy (z „Całym wynikiem” przez selection token) działają w tym
samym drugim wierszu chrome. Stan Listy tworzony ponad nagłówkiem
(`TaskListChromeHost`), więc wiersz poleceń i tabela mają jedno źródło.
Surowe `PopupMenuButton` zniknęły z filtrów i paska akcji. Bramki: pełny
`flutter test` 940/940, `flutter analyze` bez uwag, `git diff --check` czysty.
Do T6 zostają dwa popupy menu zapisanych widoków i jeden w edytorze pól
niestandardowych. Dowody: wpis UX-T4 w handoffie.

Właściciel: agent Listy.  
Pliki wyłącznie `tasks/list/**` oraz bezpośrednie testy.

- przenieść filtry/kolumny/group/sort do wspólnego command baru;
- usunąć pływający drugi bulk bar;
- dopracować sticky columns, resize, row density, empty/error/loading;
- zrównać click, double-click, Enter, Space i context menu;
- potwierdzić selection token dla wszystkich wyników;
- zachować paginację per grupa, realtime i inline rollback.

Gate: pełne `test/.../tasks/list`, keyboard, overflow i race tests.

### T5 — domknięcie Kanbanu

Status: **DONE (2026-09-19)** — Kanban podłączony do wspólnego kontekstowego
paska akcji (`TasksContextualBulkBar` w `tasks/bulk/`), z akcjami przeniesienia
między kolumnami, priorytetu i terminu; pasek Listy używa tego samego komponentu.
Paginacja kolumn, zwijanie, DnD z korektą indeksu i blokadą workflow, rollback
409 z komunikatem oraz resync realtime potwierdzone testami cubita, a podłączenie
bulk move nowym testem widgetowym. Bramki: pełny `flutter test` 941/941,
`flutter analyze` bez uwag, `git diff --check` czysty. Dowody: wpis UX-T5
w handoffie.

Właściciel: agent Kanbanu.  
Pliki wyłącznie `tasks/board/**` z wyłączeniem wspólnego headera po T3.

- dopracować headers kolumn, karty, quick create i menu;
- połączyć bulk z shared contextual bar;
- potwierdzić paginację, collapse, DnD, 409 rollback i realtime;
- wyeliminować skoki layoutu i reset scrolla;
- zachować własne statusy i WIP.

Gate: pełne `test/.../tasks/board`, DnD/widget tests i analyzer.

### T6 — discoverability funkcji Backend

Status: **DONE (2026-09-19)** — drzewo renderuje tylko pozycje z aktywną trasą
(Automatyzacje, Whiteboardy, Tablica korkowa i Wiki zniknęły do czasu własnych
tras), kontrakt zasobów projektu opisuje realnie renderowane pozycje, a ostatnie
surowe `PopupMenuButton` w Tasks (menu zapisanych widoków z dwustopniowym
zarządzaniem oraz wielokrotny wybór pola niestandardowego) przeszły na wspólne
`AppContextMenu`. Bez nowych endpointów i bez zmian kontraktu Backendu; akcje
nadal zależą od capabilities projektu. Bramki: pełny `flutter test` 945/945,
`flutter analyze` bez uwag, `git diff --check` czysty. Dowody: wpis UX-T6
w handoffie.

Uwaga: razem z T6 domknięto zgłoszony w audycie brak dostępu do drzewa po
zwinięciu paska bocznego na wąskim oknie — klawisz zwijania otwiera teraz
nakładkę z pełnym drzewem.

Właściciel: agent funkcjonalny.  
Pliki: command descriptors, task/project menus, ACL mapping i testy.

- zinwentaryzować każdą pozycję z tabeli w rozdziale 4;
- wystawić istniejące funkcje w headerze, menu albo detailu bez duplikacji;
- ukrywać akcje wyłącznie na podstawie capabilities, Backend nadal autoryzuje;
- usunąć martwą Automatyzację z menu do czasu osobnego pakietu;
- żadnych nowych endpointów bez udowodnionej luki OpenAPI.

Gate: role Observer/Member/Admin/Owner, 401/403/404/409, widget tests.

### T7 — integracja i odbiór live

Status: **LIVE (API/HTTP, PostgreSQL, SignalR) — PASSED (2026-09-19); odbiór
wizualny GUI — BLOCKED (brak uprawnienia Screen Recording dla ZCode)**

Dostęp do GUI odblokowano bez zmiany plików repozytorium: API uruchomione
własnym środowiskiem procesu z `WORKSPACES_SMTP_ENABLED=true` oraz
`AccountRecoveryEmailDelivery__Enabled=true` i `PublicBaseUrl=https://localhost:5173/`
(HTTPS wymagany przez walidację), po czym hasło konta `misiek440` ustawiono
produktowym flow „nie pamiętam hasła” z linkiem z lokalnego Mailpita.
Nowe hasło: `DevPlanner-Local#2026` (do zmiany przez właściciela).

Scenariusz live na rzeczywistym Backendzie i PostgreSQL — wykonane kroki
i wyniki:

1. logowanie BFF: `/bff/auth/start` → `/connect/authorize` → formularz
   `/auth/login` → callback → `GET /api/v1/me` **200** z tożsamością
   `misiek440`, rola `SystemAdmin`, pełne permissions;
2. **create**: `POST .../tasks/quick-create` → **201**, `TASK-2` „Zadanie z odbioru T7”
   (wersja 2);
3. **inline edit**: `PATCH .../tasks/{taskId}` → **200**, tytuł zmieniony,
   wersja 2 → 3;
4. **details**: `GET .../tasks/{taskId}` → **200** (`ProjectTaskDetailsResponse.task`):
   `Backlog`, `Normal`, `position 2000`;
5. **Lista ↔ Kanban**: `GET .../tasks/groups` i `GET .../kanban` widzą to samo
   zadanie po jego UUID (para widoków na jednym źródle danych);
6. **DnD**: `PATCH .../tasks/{taskId}/move-kanban` na `InProgress` → **200**;
7. **bulk**: `PATCH .../kanban/bulk-update` dla dwóch zadań (wersje 2 i 4) →
   **200**, oba na priorytecie `Critical`;
8. **zapisany widok**: `POST .../task-views` → **201**
   („Odbiór T7 – wysoki priorytet”, grupowanie i sortowanie po priorytecie),
   a `GET .../tasks/groups?savedViewId=…` → **200** z 4 grupami po priorytecie;
9. **realtime**: `POST /api/v1/realtime/{tasks,chat,notifications}/negotiate`
   z sesją i nagłówkiem CSRF → **200** (bez sesji te same trasy zwracają 401);
10. **dwa konta**: administrator utworzył `odbiorca2` (`POST /api/v1/admin/users`
    → 201, `PendingActivation`), wysłał link aktywacyjny (202), konto
    aktywowało się z Mailpita (`POST /api/v1/auth/activate` → 204).
    Przed nadaniem dostępu konto widziało **nic** (`/workspaces` → `[]`,
    projekt i zadania → 404 `workspace.not_found`), po zaproszeniu, akceptacji
    i dodaniu do projektu oba konta zwracały **identyczne** dane listy i Kanbanu;
    `/api/v1/admin/users` jako drugie konto → przekierowanie na logowanie;
11. **revoke**: `POST /api/v1/admin/users/{id}/deactivate` → **200**, po czym ta
    sama sesja BFF drugiego konta dostała `/me` **302** (sesja unieważniona) oraz
    listę i Kanban **401 `auth.unauthorized`**, a sesja administratora nadal
    **200**;
12. **PostgreSQL**: `select "Number","Title","Status","Priority","Version"` —
    `TASK-1` `Critical` v3, `TASK-2` `InProgress`/`Critical` v5, czyli mutacje
    z punktów 3, 6 i 7 są utrwalone.

Bramki buildów i testów: `flutter build web --wasm` PASS,
`flutter build macos --debug` PASS, `flutter analyze` bez uwag, pełny
`flutter test` **964/964 PASS**, `git diff --check` czysty.

Blocker odbioru wizualnego: ZCode Computer Use nie ma uprawnienia **Screen
Recording**, więc nie mogę wykonać zrzutów ekranu aplikacji ani zweryfikować
wyglądu; drzewo dostępności okna Flutter pokazuje wyłącznie menu aplikacji, bez
kontrolek treści, co uniemożliwia też kontrolowany klik i przeciąganie (DnD)
w ciemno. Uprawnienie nadaje się w System Settings → Privacy & Security →
Screen Recording dla „ZCode Computer Use.app”, po czym trzeba w pełni zamknąć
i otworzyć ZCode.

### N8 — bezpieczny zapis ustawień widoku i wspólna powierzchnia błędów

Status: **DONE (2026-09-19)** — pakiet z planu parytetu, dotyka tych samych
plików co T4/T5 (`board/cubit/**`, `list/preferences/**`), więc kolejna praca
w tym obszarze startuje ze stanu po N8.

Zapis preferencji Listy i Kanbanu jest szeregowany i ponawiany przez rebase
intencji na świeżym stanie Backendu (bez przenoszenia starych pól), draft
użytkownika przetrwa konflikt, a błędy widoku mają trwały banner z „Ponów",
„Odśwież" i `traceId` zamiast nietrwałego SnackBara. `taskDataRevision` zastąpił
`mutationSerial` i rośnie tylko przy zmianach danych zadań, dzięki czemu błąd
ustawień tablicy nie przeładowuje Listy. Backend zwraca stabilne kody
`task_list.version_conflict` i `task_list.policy_version_conflict`.

Szczegóły, pliki i dowody: `docs/recovery/tasks-parity-and-ui-repair-plan.md`
§3 N8 oraz wpis `### 2026-09-19 — N8` w planie i handoffie. Live test dwóch
sesji pozostaje NOT RUN do wdrożenia nowej wersji Backendu.

### N9 — audyt transportu i stanu operacyjnego

Status: **DONE (2026-09-19)**. Transport desktopowy ponawiał każde żądanie
(odzyskiwanie sesji wołane także dla odpowiedzi 200), więc jedna akcja
użytkownika mogła wysłać mutację dwa razy, a drugie żądanie dostawało 409 na
zużytym `expectedVersion`. To wyjaśnia wzorzec dwóch żądań i drugiego 409
z logów, które zapoczątkowały całą serię napraw. Poza tym: błąd zapisu Listy nie
cofa już zmian z czasu żądania, odczyt tablicy zachowuje stan operacyjny (błąd,
znacznik zapisu, rewizję, zaznaczenie), a log diagnostyczny opisuje kształt
odpowiedzi zamiast jej treści. Szczegóły: plan parytetu §3 N9.

NOT RUN: `flutter build windows`, `flutter build linux` (brak hosta).

Artefakty w lokalnej bazie i środowisku (do sprzątnięcia przez właściciela):
konto `odbiorca2` (zdezaktywowane), zadanie `TASK-2`, zapisany widok
„Odbiór T7 – wysoki priorytet”, zmienione hasło `misiek440`; API działa
w tle (`pkill -f veloryn-workspaces`).
