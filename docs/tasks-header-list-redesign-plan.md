# Tasks — plan przebudowy wspólnego nagłówka i pełnoszerokiej listy

Status: plan produktowo-techniczny po audycie Fluttera, backendu Workspaces i obrazu referencyjnego  
Data: 2026-08-30  
Zakres: wspólny header dla Kanban/List/Timeline/Workload oraz nowa lista zadań  
Poza zakresem bieżącej implementacji: finalny redesign kart Kanban oraz mobile-first UI

## 1. Cel

Ekran zadań ma stać się gęstym, szybkim środowiskiem pracy na dużych ekranach,
a nie kolekcją dużych kart i modalnych formularzy. Najważniejsze cele:

- wspólny, kompaktowy nagłówek z pełnym kontekstem projektu i najczęstszymi akcjami;
- przełączanie Kanban/List/Timeline/Workload bez zmiany układu nagłówka;
- pełnoszeroka lista w formie tabeli-drzewa, bez sztucznego `maxWidth`;
- grupy analogiczne do sekcji na obrazie referencyjnym, ale oparte na danych
  Workspaces, a nie na kopii nazewnictwa lub wyglądu innego produktu;
- edycja pól bezpośrednio w komórkach;
- wszystkie pola systemowe i custom fields dostępne jako konfigurowalne kolumny;
- tworzenie zadania i podzadania bez opuszczania listy;
- drag-and-drop dla kolejności, grup i relacji parent/subtask;
- piękne, spójne menu kontekstowe dostępne prawym przyciskiem i klawiaturą;
- cursor pagination/infinite scroll bez pobierania tysięcy rekordów naraz;
- zachowanie filtrów, grupowania, kolumn, szerokości i pozycji scrolla.

## Checklist implementacji (aktualizowana po każdym zweryfikowanym zadaniu)

- [x] Audyt Fluttera, backendu i obrazu referencyjnego.
- [x] Header: kompaktowy układ dwóch rzędów oraz globalne tworzenie zadania.
- [x] Header: test widgetowy dialogu tworzenia, w tym zachowanie danych po błędzie.
- [x] Header: wąski układ — akcje nie ściskają tabów i przewijają się poziomo pod nimi.
- [x] Header: ręczna weryfikacja układu desktop/compact bez overflowu — 2026-08-30 ręcznie potwierdzono widok przy ok. 1280, 820 i 610 px: bez `RenderFlex overflow`, z widocznym dolnym paskiem przewijania dla szerokiej tabeli oraz z zachowaniem trasy Tasks podczas przejścia przez breakpoint.
- [x] Lista: usunięcie ograniczenia szerokości i nadmiarowego paddingu.
- [x] Lista: usunięcie karty/wrappera; pełna szerokość, szerokość minimalna wyliczana z aktywnych kolumn oraz stale widoczny poziomy pasek przewijania przy dolnej krawędzi obszaru listy.
- [x] Lista: checkbox nagłówka jest wyrównany z checkboxem i chevronem wiersza; każdy systemowy header kolumny ma spokojny pionowy separator/uchwyt, który pozwala na desktopie rozszerzać szerokość całej kolumny bez rozjeżdżania nagłówka i danych.
- [x] Lista: konfiguracja obsługiwanych kolumn systemowych z zapisanych widoków.
- [x] Kontrakt listy: `startAtUtc` od backendu do kolumny „Data rozpoczęcia”.
- [x] Kontrakt listy: lekkie wartości custom fields oraz `customFieldIds` zapisane w saved view.
- [x] Lista: pola systemowe niewystawione przez lekki kontrakt oraz dynamiczne custom fields w tabeli — projekcja obejmuje typ, metryki, utworzenie, czas pracy, etykiety i własny status; saved views serializują stabilne wartości enum, a custom fields pozostają oparte o `customFieldIds` i mają edytory text/number/date/boolean/single-/multi-select/user. Cubit potwierdza optymistyczny zapis pola własnego oraz podmianę tylko lokalnego wiersza, bez pobrania grup.
- [x] Backend: bogata projekcja listy i serwerowe grupowanie; endpoint `GET /tasks/groups` liczy metadane na pełnym, identycznie filtrowanym zbiorze, a każda grupa ma własny cursor.
- [x] Lista: leniwe drzewo zadań i inline create podzadań (jedna gałąź na żądanie).
- [x] Lista: zwarte, zwijane sekcje statusów z akcją „Dodaj zadanie” jako
  ostatnim wierszem każdej rozwiniętej grupy (nie w headerze i nie globalnie na
  dole ekranu); każda grupa ma własny header kolumn, a podzadania pozostają przy
  rodzicu z osobnym, krótszym headerem.
- [x] Lista: podlista podzadań jako zintegrowana mini-tabela — wdrożone własny header, węższe kolumny, prowadnica drzewa, gęste wiersze, inline create i osobny cursor/cache dzieci. Mini-tabela przyjmuje reorder wyłącznie między rodzeństwem; próba innej relacji pozostaje na kontrolce rodzica i przechodzi przez walidację domeny. Nieudany inline create pozostawia tekst w polu i pokazuje zwarty komunikat przy tej gałęzi, a Escape anuluje edycję. Cubit potwierdza wielostronicową gałąź z wieloma dziećmi, kolejność rodzeństwa i błąd konkretnej gałęzi. Ręczny odbiór po świeżym restarcie 2026-08-30 potwierdził istniejącą gałąź z dwoma dziećmi: header jest jeden dla gałęzi, oba wiersze pozostają zwarte i poprawnie wcięte pod rodzicem, prowadnica jest osadzona przy drzewie, a wiersz dodawania pozostaje na końcu mini-tabeli. Do projektu testowego dodano wyłącznie oznaczony rekord `[QA] podlista — odbiór wizualny`, oczekujący na usunięcie po potwierdzeniu użytkownika.
- [x] Lista: inline editing statusu i priorytetu z optimistic concurrency oraz rollbackiem; konflikt/błąd pozostawia przy wierszu kompaktowy znacznik z tooltipem, usuwany po udanym zapisie. Realtime jest krótkotrwale tłumiony podczas i bezpośrednio po własnej mutacji inline, custom field lub DnD, aby nie nadpisać stanu optymistycznego.
- [x] Lista: realtime jest aktualizowany różnicowo — zwykła mutacja patchuje wyłącznie załadowany wiersz, a zmiana statusu przenosi tylko ten wiersz oraz aktualizuje dwa liczniki grup; ta sama lokalna podmiana grup działa dla potwierdzonej edycji inline statusu. Wiersze i podlisty mają stabilne klucze, więc zachowują stan przy zmianie indeksu. Echo własnego PATCH jest rozpoznawane po wersji przed okresem ochronnym i ignorowane, więc nie uruchamia po 2 s `GET /tasks/groups`. Dwie szybkie edycje tej samej komórki są serializowane: druga dostaje `expectedVersion` z potwierdzonej pierwszej mutacji zamiast konfliktu i braku reakcji UI. Resync Kanbana zachowuje rewizję i konkretną mutację realtime, więc nie wywołuje wtórnego full-loading listy po debounce. `ProjectTasksList` utrzymuje własny Cubit przez zwykłe buildy Boarda, natomiast jego klucz obejmuje `workspaceId`, `projectId` i `savedViewId`, więc wyłącznie rzeczywista zmiana kontekstu tworzy nową listę. Pełne odczytanie pozostaje fallbackiem dla zmian bez lokalnego odpowiednika. Pokrycie: 2026-08-30 `flutter analyze`, 29 testów Cubita listy i 16 testów Cubita Boarda — zielone; ręcznie w świeżym runtime na tymczasowym podzadaniu QA: zmiana `Backlog → W toku`, odczekanie ponad 2 s i natychmiastowa zmiana `W toku → Zablokowane` podmieniły wyłącznie komórkę, bez loadingu, migania ani pełnego odczytu listy.
- [x] Lista: zdalne `archived` usuwa załadowany wiersz oraz obniża licznik jego
  grupy przez ten sam czysty reducer, bez `GET groups`; regresja Cubita
  potwierdza brak reloadu (2026-09-01).
- [x] Realtime: `created` i `restored` nie wstawiają atrapy ani nie pobierają
  listy. Klient odczytuje wyłącznie ACL-chroniony detal wskazanego zadania i
  przekazuje go do istniejącego reducera filtrów/saved view; zadanie pojawia
  się tylko wtedy, gdy pasuje do bieżącego root scope. Regresja Cubita
  potwierdza pojedynczy odczyt detailu oraz brak `GET groups` (2026-09-01).
  Zdalne podzadanie trafia od razu do cache wyłącznie już rozwiniętej gałęzi i
  zwiększa licznik rodzica, ale przechodzi ten sam filtr priorytetu/osoby,
  przypięcia i saved view co root; zamknięta gałąź pozostaje lekka do własnego
  odczytu.
- [x] Lista: DnD kolejności/grup/relacji parent — drop przed wierszem, do grupy statusu systemowego albo własnego workflow i na kontrolkę hierarchii rodzica; optimistic rollback oraz walidacja backendu według sąsiadów i ograniczenia jednego poziomu. Ruch do własnej grupy przekazuje stabilny `customStatusId`. Kontrakt i reguły domenowe potwierdzone 2026-08-30 przez 33 celowane testy `ProjectTaskHandlerTests` backendu.
- [x] Lista: lokalny model multi-select (checkboxy, Shift+click/Shift+Space, Ctrl/Cmd+A) oraz kompaktowy toolbar bulk dla załadowanych rekordów: status/grupa, priorytet, wykonawca, termin i archiwizacja przez wersjonowane mutacje. Zaznaczenie obejmuje także cache rozwiniętych podzadań, a bulk action mutuje właściwy wiersz potomka; potwierdzone testem Cubita 2026-08-30. Potwierdzone operacje aktualizują lub usuwają tylko zaznaczone wiersze i ich grupy, bez pełnego reloadu listy; błąd pozostawia rekord w miejscu z komunikatem.
- [x] Backend: token selekcji dla pełnego filtrowanego wyniku przechowuje po stronie serwera filtr (nie tysiące UUID), ma TTL oraz wiązanie z użytkownikiem/workspace/projektem.
- [x] Lista: toolbar udostępnia tokenową akcję statusu dla całego filtrowanego wyniku bez ładowania ID do klienta.
- [x] Backend/lista: atomowe bulk status/grupa (systemowa lub własny workflow przez stabilne `customStatusId`), priority, assignee, due date i archive oparte o token selekcji, bez ograniczenia do załadowanych ID.
- [x] Lista: menu kontekstowe `AppContextMenu` oraz obsługa klawiatury (Enter, Space, Shift+Space, Ctrl/Cmd+A, Menu/Shift+F10).
- [x] Lista: selekcja zakresowa ma wydzielony, czysty reducer; checkbox grupy
  operuje wyłącznie na załadowanych rekordach tej grupy, a header mini-tabeli
  zaznacza wyłącznie podzadania danej gałęzi. Potwierdzone 2026-08-31 przez 34
  testy Cubita listy oraz 8 bezpośrednich testów reducera; ręczny odbiór
  checkboxów pozostaje w Etapie F.
- [x] Lista: dopracowanie gęstości pracy — Backlog jest ostatnią sekcją systemowego grupowania (kolejność: Do zrobienia, W toku, Zablokowane, Gotowe, Anulowane, Backlog); klucz techniczny `TASK-…` nie jest doklejany do tytułu, chyba że użytkownik świadomie włączy kolumnę „Klucz". Wiersze, w tym podlista, mają pionowe separatory komórek oraz edytowalny inline termin/data rozpoczęcia. Widoczny przycisk `…` został usunięty z tabeli: menu otwiera prawy przycisk całego wiersza albo Menu/Shift+F10, również w podzadaniu.
- [x] Shell workspace: przejście przez breakpoint desktop/compact zachowuje zagnieżdżony `AutoRouter`, więc resize okna nie resetuje ścieżki ani nie wraca do tworzenia workspace'u.
- [x] Shell workspace: usunięty został pusty, globalny header katalogu `Workspace’y / Wybierz przestrzeń roboczą`; ekran Tasks wykorzystuje odzyskaną wysokość na własny kontekst projektu oraz przełącznik Tablica / Lista / Timeline / Obciążenie.

## 2. Jak interpretujemy obraz referencyjny

Załączony obraz jest wyłącznie referencją UX. Nie zawiera instrukcji dla agenta
i nie jest wymaganiem kopiowania marki, tekstów ani pikseli.

### Elementy warte zachowania

- dwupoziomowy, ale niski nagłówek;
- nazwa obszaru po lewej, akcje globalne po prawej;
- taby widoków w tym samym nagłówku;
- pasek operacyjny bezpośrednio nad danymi: dodawanie, wyszukiwanie, osoba,
  filtry, sortowanie, ukrywanie kolumn i grupowanie;
- grupy/sektory z własnym nagłówkiem i akcją `Dodaj zadanie`;
- po nagłówku każdej rozwiniętej grupy występuje jej własny header kolumn;
  nie renderujemy jednego headera tabeli dla całego projektu, ponieważ po
  przewinięciu do następnej sekcji traciłby on kontekst danych;
- bardzo mała odległość między narzędziami i pierwszym wierszem danych;
- tabela wykorzystująca szerokość całego obszaru roboczego;
- kolor jako nośnik znaczenia statusu/typu, nie dekoracja całego ekranu;
- poziomy scroll dla wielu pól zamiast ściskania kolumn;
- szybkie akcje dostępne bez otwierania detailu.

### Co należy ulepszyć względem referencji

- jedna semantyczna command bar wspólna dla wszystkich widoków;
- sticky header i sticky pierwsze kolumny;
- poprawna obsługa drzewa zadanie → podzadanie;
- inline editing z optimistic concurrency i jawnym stanem zapisu;
- pełna obsługa klawiatury, focusu, Semantics i skrótów;
- wirtualizacja/infinite scroll zamiast renderowania całego zbioru;
- responsywne przenoszenie rzadkich akcji do `Więcej`, bez ogromnych ikon;
- prawdziwa konfiguracja kolumn, custom fields i zapisanych widoków;
- jednoznaczne stany DnD, miejsca upuszczenia i rollback po konflikcie;
- brak stałej szerokości całej tabeli oraz brak dużych pustych marginesów.

## 3. Wynik audytu aktualnego Fluttera

### 3.2. Audyt kompletności pól listy — 2026-08-30

Nie traktujemy listy jako osobnej, uboższej domeny. Zapisany widok musi być
jedynym miejscem konfiguracji kolumn, a każda kolumna musi mieć renderer,
edytor albo wyraźny status „tylko do odczytu”. Poniższe punkty są nową,
obowiązkową checklistą przed kolejnym oznaczeniem Tasks jako gotowego.

- [x] Backend: lekka projekcja `ProjectTaskListItemResponse` przekazuje
  `Labels`, `CustomStatusName` i `CustomStatusColor` poza samym mapperem,
  w `ListProjectTasksHandler.BuildPageAsync`; audyt kodu 2026-08-30 to
  potwierdził. Utrzymać celowany test handlera przy każdej zmianie projekcji.
- [ ] Systemowe kolumny: pełna macierz saved view dla wszystkich pól kontraktu:
  klucz, tytuł, status/własny status, priorytet, wykonawcy, etykiety, start,
  termin, checklist progress, utworzenie/aktualizacja, typ, size, complexity,
  risk, business value, estimate i actual time. Każde pole ma renderer, a
  pola możliwe do zapisu — inline editor z optimistic concurrency.
  Etykiety zostały domknięte 2026-08-30: renderer chipów oraz atomowy picker
  korzystają z `replaceLabels`, podmieniając wyłącznie wiersz i jego wersję.
- [ ] Właściciel i współpracownicy: w UI rozdzielić głównego wykonawcę
  (`Assignee.IsPrimary`) od pozostałych wykonawców (domena nazywa ich
  współpracownikami); jeden edytor „Osoby” ma umożliwiać wskazanie właściciela
  i współpracowników przez istniejący `PUT /tasks/{id}/assignees`, z rollbackiem.
  Picker 2026-08-30 jest menu zakotwiczonym w komórce/menu wiersza: osobno
  ustawia właściciela lub przełącza współpracownika i zapisuje atomową listę.
  Saved view ma osobne kolumny `Owner` i `Collaborators` oraz osobne akcje
  menu; historyczna `Assignees` pozostaje tylko dla kompatybilności istniejących
  widoków.
  Źródłem kandydatów jest endpoint Workspaces zgodny z ACL projektu, nie globalny
  katalog Core. Do odbioru pozostało wyszukiwanie po dużej liście kandydatów.
- [x] Obserwatorzy: dodać osobną opcjonalną kolumnę saved view i menu akcji,
  oparte o endpointy watcherów; nie mieszać ich z wykonawcami.
  Lekka projekcja przekazuje `watcherCount` i `isWatchedByMe`; komórka i menu
  przełączają obserwowanie lokalnie z aktualizacją wersji. Potwierdzone 2026-08-30
  przez 34 testy `ProjectTaskHandlerTests` oraz 31 testów Cubita listy.
- [ ] Custom fields: dla text, number, date, boolean, single select, multi
  select i user zapewnić typowany renderer i edytor w komórce; menu wyboru ma
  otwierać się przy klikniętej komórce, nie w stałej pozycji ekranu. Pole jest
  widoczne domyślnie tylko według konfiguracji saved view, nigdy nie jest
  usuwane ani ukrywane jako obejście błędu. Wdrożono 2026-08-30: boolean ma
  semantyczny znacznik, date format daty, select chipy, user avatar/nazwę,
  a number wyrównanie numeryczne; test Cubita potwierdza lokalny optimistic
  zapis custom field bez ponownego pobrania grup. Wybór pola oraz typy boolean,
  single/multi-select i user używają menu kontekstowego; text/number i data
  wymagają jeszcze edytora zakotwiczonego zamiast dialogu systemowego.
- [x] Context menu: prawy klik / Menu / Shift+F10 otwiera jedyne menu wiersza,
  bez widocznych `…`; menu zawiera zmianę statusu, priorytetu, terminu,
  właściciela/współpracowników, custom fields, tworzenie podzadania,
  duplikat i archiwizację. Ma działać identycznie dla parent i subtask.
  Część wdrożona 2026-08-30: status, priorytet, owner/collaborators, termin,
  podzadanie (wyłącznie dla parenta), duplikat i archiwizacja korzystają z tych
  samych lokalnych mutacji co komórki. Pin został dopięty 2026-08-30 jako
  osobista lokalna zmiana `isPinned`, potwierdzona testem Cubita bez reloadu.
  Obserwowanie i kolumna watcherów zostały zrealizowane w Etapie E; pola custom
  otwierają kompaktowy wybór pola, a następnie ten sam typowany edytor co
  komórka. Wszystkie akcje działają tak samo dla parenta i subtaska, poza
  tworzeniem podzadania, które jest świadomie niedostępne na drugim poziomie.

### 3.2.1. Korekta odbiorowa: edytory i osoby — 2026-08-30

- [x] Endpoint `GET /projects/{projectId}/members/profiles` zwraca osoby
  faktycznie możliwe do przypisania: dla Private wyłącznie aktywnych jawnych
  członków projektu, dla Shared aktywnych członków workspace z wyłączeniem osób
  jawnie cofniętych z projektu. Reguła cofnięcia jest identyczna z
  `TaskAssigneeAccess` (po `CoreUserId`), a test backendowy obejmuje oba tryby.
- [x] Lista osób nie pobiera globalnych wyników Core bez przecięcia z ACL;
  Core służy wyłącznie do wzbogacenia nazwy i avatara uprawnionych osób.
- [ ] Dla tysięcy uprawnionych osób dodać wyszukiwanie/cursor po stronie tego
  samego endpointu ACL; nie ładować katalogu Core ani wszystkich profili do UI.
  Parametr `search` został dodany do backendu i najpierw przecina wynik Core z
  ACL projektu; kontrakt Retrofit i repozytorium Flutter przekazują już frazę
  bez używania lokalnego cache. Pozostało podłączyć pole wyszukiwania w popupie
  oraz cursor/limit odpowiedzi.
- [ ] Nie używać `AlertDialog` do edycji wartości z listy. Pozostało zastąpić
  tekst/liczbę oraz wybór daty edytorami i pickerami zakotwiczonymi w komórce.

### 3.2.2. Zgłoszenia z odbioru użytkownika — obowiązkowe, 2026-08-30

- [ ] **Jeden wizualny wrapper menu.** Właściciel, współpracownicy, status,
  priorytet, terminy i custom fields używają `AppContextMenu`; zakazane są
  surowe popupy Material o odmiennym promieniu, cieniu lub paddingu.
  Wymaganie doprecyzowane: API i style nie mogą mieszkać lokalnie w widoku
  Tasks. Należy wydzielić wspólny komponent w warstwie shared/workspaces z
  wariantami action, single-select, multi-select, search i inline input,
  następnie przełączyć na niego status, priority, osoby, daty i custom fields.
- [ ] **Wyszukiwarka osób w menu.** Pole jest widoczne bezpośrednio w popupie
  ownera i collaborators, ma debounce, anulowanie spóźnionej odpowiedzi oraz
  wynik ograniczony przez endpoint ACL. Musi działać także z prawego kliku.
- [ ] **Nazwy osób bez atrap.** Tekst „Członek projektu” nie może pojawić się
  jako nazwa zalogowanego użytkownika. Backend pobiera profil po `ReadyUserId`,
  a gdy go brak — po `CoreUserId`; UI pokazuje bezpieczny skrót UUID tylko przy
  realnej niedostępności katalogu.
- [ ] **Realtime bez pełnego reloadu.** Zmiana statusu, priorytetu, tytułu lub
  daty od innej osoby podmienia wyłącznie załadowany wiersz/komórkę. Nie wolno
  wykonywać `GET groups` po dwusekundowym suppressie ani resetować scrolla.
  Niepełne eventy nie pokazują fałszywego komunikatu konfliktu.
- [ ] **Konflikt tylko przy prawdziwym wyścigu.** 409 dla własnej aktywnej
  mutacji zostawia lokalną wartość, daje zwięzły błąd przy komórce i nie kasuje
  ani nie przeładowuje całej listy; zewnętrzna zmiana bez lokalnej mutacji nie
  jest błędem dla użytkownika. Domknięto część własnej mutacji 2026-08-31:
  `updateListItem` zachowuje optimistic wartość wyłącznie dla HTTP 409 i
  przypina komunikat do wiersza; każdy inny błąd nadal wykonuje rollback.
  Test Cubita potwierdza zachowanie wartości oraz brak `GET groups`. Realtime
  nadal porównuje wersję wydarzenia z załadowanym wierszem i ignoruje echo o
  tej samej lub starszej wersji. Pozostał ręczny odbiór równoczesnej zmiany w
  drugiej sesji.

### 3.2.3. Przekazanie na jutro — stan faktyczny, 2026-08-31

Nie traktować tej sekcji jako listy pomysłów. To jest obowiązkowa kolejność
domknięcia po aktualnym odbiorze. Żaden punkt z `[ ]` nie może zostać opisany
jako „gotowy” bez kodu, testu i ręcznego sprawdzenia w uruchomionej aplikacji.

Stan po zakończeniu dzisiejszej pracy:

- [x] **Regresja po zmianie statusu nie gubi ikon osobistych.** `PATCH
  /list-item` w backendzie zwraca teraz aktualne `isPinned`, `watcherCount` i
  `isWatchedByMe` dla użytkownika wykonującego mutację — dokładnie jak `GET`
  listy. Flutter dodatkowo zachowuje bieżące wartości tych pól podczas
  potwierdzenia lekkiej edycji, więc niepełna odpowiedź starej instancji nie
  może zgasić pinezki ani oka. Regresje: 1 test handlera .NET i test Cubita
  „zmiana statusu nie gubi przypięcia ani obserwowania”; potwierdzone
  2026-08-31.
- [ ] **Pierwszy odbiór jutro:** na działającej instancji zmienić status
  przypiętego i obserwowanego zadania w Liście, następnie powtórzyć to dla
  Kanbana. Zweryfikować również rollback HTTP 403/409, bo testy jednostkowe
  nie zastępują uprawnień realnego użytkownika.
- [x] **Wspólny edytor cykliczności:** `task_recurrence_context_editor.dart`
  otwiera się zakotwiczony przy menu wiersza Listy lub przy ikonie serii na
  karcie Kanban. Tworzy albo aktualizuje tryb, częstotliwość, interwał, strefę,
  pierwszy/następny termin UTC, status wystąpienia i regułę otwartego
  poprzednika — bez przejścia do detailu. Po sukcesie Cubit podmienia tylko
  dany wiersz/kartę oraz wersję taska, bez `GET groups` i bez pobrania boarda.
  Regresja Kanbanu pokrywa lokalny patch odpowiedzi edytora; ręcznie odebrać
  panel, datę ISO i błąd 403/409 na działającej instancji.

- [x] Kontrakt saved view ma `Owner` i `Collaborators`; backend i Flutter
  rozpoznają oba stabilne identyfikatory, a nowy domyślny widok ma dwie osobne
  kolumny. Historyczne `Assignees` pozostaje dla kompatybilności widoków.
- [x] Endpoint osób ma ACL Private/Shared, regułę cofnięcia po `CoreUserId` i
  parametr `search`; test `ProjectAccessTests` pokrywa role oraz walidację
  nieprawidłowej frazy.
- [ ] **Dokończyć wygląd pickerów osób.** Kod rozpoczął migrację do
  `AppContextMenu.showCustom`; picker oraz wybór trybu są już przełączone ze
  zwykłego `showMenu` na wspólny wrapper. Ręcznie porównaj z menu
  statusu/prioritetu (padding, cień, promień, pozycja i dark mode) i usuń
  ewentualne różnice po odbiorze.
- [ ] **Dokończyć widoczną wyszukiwarkę w pickerze.** Istnieje panel z
  `TextField`, debounce 220 ms i odrzucaniem spóźnionych odpowiedzi oraz
  frontendowy `searchProfiles`; trzeba go osadzić w `AppContextMenu` dla
  kliknięcia komórki i prawego przycisku, a następnie potwierdzić rzeczywistym
  żądaniem `?search=`. Dodać test logiki debounce/ostatniej odpowiedzi, bez
  testu widgetowego.
- [x] **Kontrakt paginacji osób.** `GET members/profiles` zwraca teraz
  `CursorPageResponse` z `items` i `nextCursor`; przyjmuje `cursor` i limit
  1–100 (domyślnie 30), a kursor jest związany z frazą wyszukiwania. Workspaces
  pobiera z PostgreSQL wyłącznie stronę po ACL i stabilnym `(CreatedAtUtc, CoreUserId)`, a Flutter ma typ
  `ProjectMemberProfilePage`, Retrofit oraz `listProfilesPage`. Regresja
  backendu przechodzi przez trzy strony bez duplikatów (2026-09-01).
- [x] **Picker osób w wierszu listy jest stronicowany.** `TaskListRow` otwiera
  popup z pierwszą stroną, dociąga kolejną przy scrollu, deduplikuje po
  `CoreUserId`, zachowuje debounce 220 ms i odrzuca spóźnioną odpowiedź.
  Działa tak samo dla kliknięcia komórki i menu kontekstowego właściciela lub
  współpracowników. `flutter analyze` oraz 12 testów wierszy listy są zielone
  po tej zmianie (2026-09-01).
- [x] **Nie gubić pełnych katalogów w starszych widokach.** Zachowane
  `listProfiles` iteruje przez cursorowe strony i cache'uje kompletny katalog
  dla widoków, które go świadomie wymagają (np. workload); regresja repozytorium
  pokrywa dwie strony. Lista zadań nie korzysta z tej cięższej ścieżki.
- [ ] **Podłączyć stronicowanie do pozostałych interaktywnych pickerów osób.**
  Popupy poza wierszem listy powinny używać `listProfilesPage` i dociągać wynik
  po scrollu, zamiast otwierać pełny katalog.
- [x] **Backend profilu zalogowanego użytkownika.** Fallback
  `GetByCoreIdAsync` dla członkostwa bez `ReadyUserId` ma regresję w
  `ProjectAccessTests`: profil zwraca nazwę i avatar po stabilnym `CoreUserId`
  oraz przekazuje JWT do katalogu. Potwierdzone 2026-09-01: 11 testów
  `ProjectAccessTests` i czysta kompilacja backendu.
- [ ] **Ręczny odbiór profilu zalogowanego użytkownika.** UI nie może pokazywać
  „Członek projektu”; obecny awaryjny skrót UUID jest tylko bezpiecznym stanem
  degradacji, nie docelową nazwą. Sprawdzić na działającym Core dla konta bez
  `ReadyUserId` oraz przy rzeczywistej niedostępności katalogu.
- [ ] **Dokończyć realtime bez reloadu.** Usunięto dwusekundowy mechanizm,
  który wywoływał pełne `GET groups`, i lokalnie patchowane są `updated` oraz
  `statusChanged`; 32 testy Cubita potwierdzają brak późniejszego reloadu po
  własnej edycji. Sprawdzić i przetestować kolejno dwa szybkie statusy,
  zmianę z innej sesji oraz 409; eventy archiwizacji/tworzenia/niepełnej
  projekcji nadal wymagają świadomego local-patch lub subtelnego wskaźnika
  „są nowe zmiany”, nigdy automatycznego resetu viewportu.
- [x] **Zastąpić pozostałe modale.** Custom text/number i data są teraz
  zakotwiczonymi elementami `AppContextMenu`: wspólny kalendarz obsługuje
  termin, datę rozpoczęcia i date custom field, a custom text/number zachowuje
  Enter oraz Escape bez mutacji. Świadome „Wyczyść” jest odróżnione od
  anulowania, a daty są normalizowane do północy UTC. Test widgetowy potwierdza
  otwarcie kalendarza bez `showDatePicker` i wyczyszczenie terminu; `flutter
  analyze`, 34 testy Cubita i 5 testów wiersza są zielone. Dialogi tworzenia
  zadań pozostają w osobnym punkcie P1, bo zostaną zastąpione inline create.
- [ ] **Pełna macierz kolumn/systemowych operacji.** Kontynuować punkt 3.2:
  type, size, complexity, risk, business value, estimate, actual time,
  created/updated i wszystkie custom fields muszą mieć spójny renderer i — gdy
  API pozwala — akcję menu, bez atrap i bez detailu jako jedynej drogi. Audyt
  2026-08-31: wszystkie 23 wartości `TaskSavedViewColumn` mają renderer w
  `_TaskListCell`. Niezamknięta część to lekka edycja `taskType`, `size`,
  `complexity`, `risk`, `businessValue` i `estimatedMinutes`: pełny kontrakt je
  zna, lecz `UpdateTaskListItemPayload` jeszcze ich nie przekazuje.
  `actualMinutes` ma pozostać tylko do odczytu, bo backend świadomie odrzuca
  klientską zmianę i aktualizuje je po zatwierdzeniu czasu.
  Pierwszy etap lekkiego PATCH-a jest gotowy po backendzie (2026-08-31):
  `taskType`, `size`, `complexity`, `risk`, `businessValue` i
  `estimatedMinutes` są opcjonalne i zachowują obecną wartość, gdy nie są
  przesłane; historia zapisuje poprzednią i nową wartość. Test handlera
  potwierdza atomowy zapis oraz brak możliwości zmiany `actualMinutes` (38
  testów zielonych). Pozostało po stronie Fluttera rozszerzyć typowany payload,
  optimistic patch i renderery-edytory; czyszczenie nullable metryk wymaga
  osobnych flag, nie semantyki niejednoznacznego null.
  Transport Fluttera i optimistic patch zostały dopięte 2026-08-31:
  `UpdateTaskListItemPayload` przenosi te sześć pól, a Cubit scala je lokalnie
  przed odpowiedzią API i zachowuje dotychczasową obsługę 409. Wygenerowane
  modele oraz 36 testów Cubita są zielone. Flagi `ClearSize`,
  `ClearComplexity`, `ClearRisk`, `ClearBusinessValue` i
  `ClearEstimatedMinutes` są już zsynchronizowane przez backend oraz Flutter i
  optymistycznie czyszczą lokalny wiersz.
  Refactor UI 2026-08-31: zakotwiczony `_CustomTextFieldPanel` nie przyjmuje
  już definicji custom field, tylko neutralne `title` i `isNumber`; custom
  fields zachowują identyczne zachowanie, a panel można bez duplikacji podłączyć
  do metryk systemowych. `flutter analyze` jest zielony.
  Czytelność 2026-08-31: wszystkie `_SystemTextCell` pokazują pełną wartość w
  tooltipie (a brak jako „Brak wartości”), więc skrócenie kolumny nie ukrywa
  informacji przed ukończeniem inline editorów. Test widgetowy regresji
  kolumny systemowej jest zielony (7 testów wiersza).
  Pierwszy kompletny pionowy slice UI 2026-08-31: komórka `taskType` jest
  klikalna i otwiera neutralny, zakotwiczony `_CustomTextFieldPanel`; po
  zatwierdzeniu wywołuje typowany callback Cubita i istniejący lekki PATCH.
  Anulowanie nie wysyła żądania, zaś pusty tekst jest przed wysłaniem
  normalizowany do `Task`, dokładnie jak w domenie C#. Test widgetowy wykonuje
  tap, wpisanie i zatwierdzenie (`8` testów wiersza zielonych); `flutter
  analyze` i `git diff --check` są zielone.
  Domknięcie metryk 2026-08-31: `size`, `complexity`, `risk`,
  `businessValue` oraz `estimatedMinutes` współdzielą `_EditableSystemMetricCell`
  z liczbą całkowitą i jawnym przyciskiem „Wyczyść”. Jeden callback przekazuje
  `TaskSavedViewColumn` i `int?`, a kompozycja listy mapuje go wyczerpująco na
  poprawne pole payloadu oraz odpowiadającą mu flagę `Clear…`; `actualMinutes`
  nadal używa wyłącznie rendereru read-only. Widgetowy test regresji potwierdza
  zarówno zapis liczby, jak i czyszczenie. Dodatkowa regresja gwarantuje, że
  renderer bez callbacku mutacji pozostaje read-only i nie otwiera panelu,
  więc nie może wykonać wywołania przez `null`. Pakiet wierszy ma 10 zielonych
  testów; `flutter analyze` oraz `git diff --check` pozostają zielone.
  Najbliższa praca nad tą checklistą nie dotyczy już transportu ani inline
  edycji systemowych pól — pozostaje ręczny odbiór podlisty opisany poniżej.
  Naprawa domeny 2026-08-31: `ProjectTask.UpdateSystemFields` podnosi teraz
  `Version` tylko przy rzeczywistej zmianie, więc przyszły lekki edytor będzie
  poprawnie współpracował z optimistic concurrency; 36 celowanych testów
  `ProjectTaskHandlerTests` jest zielonych. Pełny handler przekazuje jawnie
  `incrementVersion: false`, bo jego własne `Update` już podnosi wersję — jedna
  złożona mutacja nie może zwiększać jej dwukrotnie. Regresja 2026-08-31
  wykonuje pełny update z `TaskType`, `Size` i `EstimatedMinutes` oraz
  potwierdza pojedynczy przyrost wersji; po końcowej walidacji 2026-08-31
  celowany zestaw `ProjectTaskHandlerTests` ma 38 zielonych testów.
- [ ] **Odbiór podlisty.** Ręcznie sprawdzić własny header, pionowe separatory,
  poziomy scroll na dole całego ekranu, brak overflowu i menu/edycję dla
  parenta oraz subtaska. Nie dodawać testów widgetowych; dodać tylko Cubit/
  backend logic tam, gdzie zmieni się logika.
- [ ] **Końcowa walidacja po każdym domkniętym bloku:** `flutter analyze`,
  `flutter test test/workspaces/presentation/tasks/list/project_tasks_list_cubit_test.dart`,
  celowane `dotnet test`, `git diff --check` oraz ręczny odbiór bez hot reload.
  Weryfikacja automatyczna 2026-08-31 po systemowych edytorach: `flutter
  analyze`, 10 testów `project_tasks_list_rows_test.dart`, 36 testów
  `project_tasks_list_cubit_test.dart`, 38 celowanych testów backendu oraz
  `git diff --check` są zielone. Pozostaje ręczny odbiór bez hot reload.
  Historyczny pełny `flutter test --reporter compact` z 2026-08-31 zatrzymał
  się po 478 testach. Naprawiono dwa błędy raila (fixture dostarcza teraz
  wymagany `CurrentUserAvatarCubit`) i flakiness `widget_test.dart`: testy
  podają pamięciowe repozytorium preferencji, nie uruchamiają huba powiadomień
  i jawnie odmontowują aplikację. Przy tej okazji poprawiono kontrakt startu:
  domyślne ustawienie „Pulpit” zachowuje trasę przekazaną przez hosta, zaś
  zapisany nie-domyślny moduł nadal ją zastępuje. 2026-08-31 zielone są:
  `flutter analyze`, 4 testy `widget_test.dart`, 2 testy raila, 36 testów
  Cubita listy, 18 testów detailu oraz `git diff --check`. Końcowy pełny
  `flutter test --reporter silent` zakończył się powodzeniem 2026-08-31
  (646 sukcesów, bez błędów). Kontraktowe testy Inventory są bezpiecznie
  pomijane, gdy brakuje `INVENTORY_CONTRACT_BASE_URL` oraz
  `INVENTORY_CONTRACT_BEARER_TOKEN`; adres środowiska i token nie są zapisane
  w repozytorium. Ostrzeżenia HTTP 400 w widget testach są oczekiwanym
  zachowaniem `TestWidgetsFlutterBinding`, nie rzeczywistymi połączeniami
  sieciowymi.
  Kompilacja platformowa 2026-08-31: `flutter build macos` zakończył się
  powodzeniem (ostrzeżenia pochodzą z zależności CocoaPods). `flutter build web
  --wasm` jest obecnie zablokowany przez zestaw Flutter 3.47.0/Dart 3.13.0:
  narzędzie przekazuje już usunięty `--enable-experiment=record-use`, choć repo
  nie zawiera tej flagi. To problem SDK, nie kodu Tasks; po aktualizacji albo
  dopasowaniu SDK należy ponowić build Wasm przed odbiorem Web.

### 3.2.4. Błędy odbiorowe użytkownika — priorytet P0/P1, 2026-08-30

Poniższe punkty zostały zgłoszone podczas realnej pracy. Są ważniejsze niż
dalsze kosmetyczne rozszerzenia; nie mogą zostać zamknięte przez sam analizator.
Każdy wymaga testu logiki/Cubita tam, gdzie zmienia stan, oraz ręcznego odbioru
na uruchomionej aplikacji.

#### P0 — stabilność viewportu i poprawność operacji

- [ ] **Resize kolumny nie ujawnia obciętego tekstu.** Po rozszerzeniu kolumny
  tytuł/wartość musi otrzymać nową szerokość layoutu; sprawdzić constraints,
  `SizedBox`/cache szerokości oraz poziomy scroll. Nie zostawiać `…` gdy miejsca
  jest wystarczająco dużo. Naprawa constraints 2026-08-31: `_TaskListCell`
  przekazuje już ciasną, bieżącą szerokość `Container` do rendererów komórek;
  wcześniejszy pośredni `Align` rozluźniał constraint, więc wewnętrzny
  `SizedBox` zachowywał bazową szerokość po resize. Kolumna zaznaczenia została
  też poszerzona do 72 px, aby checkbox Material i kontrolka drzewa nie
  powodowały `RenderFlex overflow`. `flutter analyze`, 34 testy Cubita i 4
  testy wiersza są zielone. Przed zamknięciem wymagany ręczny odbiór:
  rozszerzyć tytuł, własny status, datę i metrykę po poziomym scrollu oraz
  potwierdzić zniknięcie ellipsy, gdy tekst mieści się w kolumnie.
- [ ] **Menu kontekstowe otwiera się w losowym miejscu.** Menu komórki,
  nagłówka i bulk action musi być zakotwiczone do globalnego prostokąta
  klikniętego pola (dla prawego kliknięcia: przy kursorze), a nie do lokalnego
  `BuildContext` o innej transformacji. Wspólny wrapper koryguje pozycję tylko
  przy krawędzi viewportu. Zweryfikować listę po poziomym scrollu i mini-tabelę
  podzadań. Naprawa 2026-08-31: `WorkspaceContextMenu` otwiera popup na root
  navigatorze, zgodnym z overlayem, względem którego lista wylicza
  `RelativeRect`; pomocnik komórek etykiet korzysta z tego samego root overlay,
  a jego bezpośredni popup również wymusza root navigator. Dzięki temu pozycja
  nie miesza układów współrzędnych zagnieżdżonego `AutoRouter`. `flutter
  analyze` jest zielony. Pozostał ręczny odbiór kliknięcia i prawego kliknięcia
  po poziomym scrollu oraz w mini-tabeli.
- [ ] **Widoczne trzy kropki.** Wiersz listy ma działać prawym kliknięciem,
  klawiaturą i touch fallbackiem, lecz widoczne `…` nie mogą zostać przypadkowo
  renderowane w zwykłym desktopowym układzie. Sprawdzić `showActions` dla listy
  głównej i podlisty oraz usunąć je z normalnego widoku. Naprawa 2026-08-31:
  domyślny wariant `TaskListRow` nie renderuje akcji, a ścieżka listy nie
  przekazuje już parametru, który mógłby przypadkiem je włączyć. Test widgetowy
  potwierdza brak `Icons.more_horiz_rounded`; menu pozostaje dostępne przez
  prawy przycisk, Menu/Shift+F10 i long press. Ręcznie sprawdzić touch fallback
  na urządzeniu lub emulatorze.
- [ ] **Zaznaczenie grupy jest nieprawidłowe.** Zaznaczenie „W toku” ma objąć
  wyłącznie rekordy tej grupy (lub jawnie zaznaczony token tej grupy), nigdy
  elementy pozostałych grup. Implementacja lokalnego zakresu i test Cubita są
  gotowe 2026-08-31; przed zamknięciem punktu pozostaje ręczny odbiór oraz
  grupowy token dla rekordów z niezaładowanych stron.
- [ ] **Podzadania: zaznacz wszystko.** Header mini-tabeli musi mieć checkbox
  select-all działający tylko na rozwiniętej gałęzi; Shift/Space i bulk muszą
  obejmować parent/subtask zgodnie z regułą jednego poziomu. Checkbox gałęzi,
  zachowanie zaznaczenia rodzica i test Cubita wdrożono 2026-08-31; pozostał
  ręczny odbiór klawiatury i toolbaru na uruchomionej aplikacji.
- [ ] **Bulk nie może reloadować listy.** Status, priority, owner,
  collaborator, due date, group i archive aktualizują lokalnie tylko rekordy
  objęte selekcją/tokenem. Nie wolno zamykać rozwiniętych podzadań, resetować
  scrolla ani wywoływać pełnego `GET groups` po powodzeniu/błędzie bulk.
  Implementacja tokenowa została domknięta 2026-08-31: Flutter przekazuje do
  backendu identyfikatory aktualnie załadowanych rekordów (maks. 500), backend
  zwraca ich nowe wersje, a Cubit lokalnie podmienia status/grupę, priorytet,
  wykonawców i termin albo usuwa zarchiwizowane rekordy. Test Cubita potwierdza
  lokalną wartość, nową wersję i brak kolejnego `GET groups`; 34 testy Cubita
  oraz 34 celowane testy `ProjectTaskHandlerTests` są zielone. Punkt pozostaje
  otwarty wyłącznie do ręcznego odbioru scrolla i rozwiniętych podzadań.
- [ ] **Błąd optimistic concurrency.** Komunikat „obiekt został zmodyfikowany
  przez innego użytkownika” nie może pojawiać się po prawidłowej własnej lub
  zewnętrznej synchronizacji realtime. 409 tylko przy rzeczywistym wyścigu tej
  samej własnej mutacji; wtedy błąd należy przypiąć do komórki/wiersza i dać
  możliwość świadomego odświeżenia, bez pełnego reloadu. Implementacja 2026-
  08-31 pozostawia optimistic wartość tylko dla `ApiErrorType.conflict`; test
  Cubita obejmuje HTTP 409, komunikat wiersza i brak reloadu. Ręczny odbiór
  drugiej sesji pozostaje wymagany przed zamknięciem punktu.
- [ ] **Filtry nie mogą psuć listy po 403.** Zgłoszenie odbiorowe 2026-08-31:
  część filtrów zwraca HTTP 403 i pozostawia widok w nieużywalnym stanie.
  Ustalić dokładnie, który endpoint/parametr odmawia dostępu, zachować ostatni
  poprawny snapshot listy, pokazać komunikat przy konkretnym filtrze i umożliwić
  jego wyłączenie bez resetowania pozostałych filtrów, scrolla i podzadań.
  Nie traktować samego testu mockującego jako zamknięcia — wymagany test
  Cubita dla 403 oraz ręczny odbiór na działającej instancji.
  Odporność klienta domknięta 2026-09-01: rozpoczęcie zmiany filtrów nie
  zamienia już gotowej listy w loading, a nieudane żądanie (w tym 403)
  zachowuje poprzedni snapshot, rozwinięte podzadania i scroll; komunikat
  „Nie zastosowano filtrów” jest widoczny bezpośrednio pod filtrowaniem.
  Regresja Cubita potwierdza zachowanie danych po 403. Backendowy audyt nie
  wykazał ACL zależnego od konkretnego parametru — jedyną bramą jest odczyt
  projektu — dlatego nadal wymagane jest wskazanie realnego endpointu/żądania
  z runtime przed uznaniem tego punktu za zamknięty.
- [ ] **Przypinanie i obserwowanie muszą działać w listie oraz Kanbanie.**
  Zgłoszenie odbiorowe 2026-08-31: obecne akcje są widoczne, ale nie działają
  poprawnie. Sprawdzić kontrakt `TaskUserPreference` i watcherów, uprawnienia,
  optimistic patch, nową wersję oraz obsługę 403/409. Po sukcesie widok ma
  zmienić wyłącznie dany rekord/kartę, bez pobierania całej listy czy boarda;
  po błędzie musi wrócić poprzednia wartość i pozostać czytelny komunikat.
  Pokryć listę i Kanban osobnymi regresjami oraz ręcznie sprawdzić obie akcje.
  Część listy naprawiona 2026-08-31: każde zadanie ma widoczne `…`, z którego
  dostępne są duplikowanie, przypięcie i obserwowanie; nie wymagają prawego
  kliknięcia. Klient obserwowania przekazuje teraz wymagany przez backend
  `expectedVersion`. Domknięto też kontrakt oraz lokalne akcje Kanbanu:
  `isPinned`, `watcherCount` i `isWatchedByMe` są zwracane dla snapshotu,
  stron kolumn oraz odpowiedzi po przesunięciu; klikalne ikony na karcie
  podmieniają tylko daną kartę. Pozostało ręczne sprawdzenie HTTP 403/409.
  Krytyczna regresja listy domknięta 2026-08-31: odpowiedź `PATCH /list-item`
  dotąd mapowała pola osobiste na domyślne wartości, przez co zmiana statusu
  usuwała widoczną pinezkę i oko. Handler pobiera już preferencję oraz
  obserwatorów dla wykonującego mutację, a Cubit utrzymuje lokalny snapshot
  tych pól jako warstwę zgodności; test backendu i regresja Cubita pokrywają
  przypadek przypiętego, obserwowanego zadania.
  Audyt backendu 2026-08-31 ujawnił dodatkowy błąd kontraktu: `GET`
  ustawień Kanbana nie opisywał parametrów workspace/projekt w OpenAPI.
  Parametry zostały opisane, a test `KanbanOpenApiContractTests` weryfikuje
  teraz brak opisu czytelnym komunikatem z nazwą parametru zamiast wyjątku
  `KeyNotFoundException`.

#### P1 — spójny szybki UX listy

- [x] **Kalendarz terminu w kontekście.** Termin start/due i date custom field
  używają jednego kompaktowego, zakotwiczonego pickera `AppContextMenu`;
  `showDatePicker` nie występuje już w tych ścieżkach listy. Potwierdzone
  2026-08-31 testem widgetowym oraz analizą.
- [x] **Tworzenie zadań w kontekście.** „Dodaj zadanie” w grupie otwiera teraz
  inline pusty `TextField` jako ostatni wiersz jej tabeli, a akcja „Dodaj podzadanie”
  z menu wiersza rozwija właściwą gałąź i uruchamia ten sam input mini-tabeli.
  Enter zapisuje, Escape anuluje, błąd pozostawia draft; nie ma już dialogów
  tworzenia w widoku listy. Potwierdzone 2026-08-31 przez `flutter analyze`
  oraz 34 testy Cubita, w tym tworzenie root task i podzadania.
- [x] **Tworzenie root task bez pełnego reloadu.** Od 2026-08-31 nie ma już
  stałego wiersza na dole całego ekranu. Każda możliwa do utworzenia grupa ma
  własny ostatni wiersz „Dodaj zadanie”; przy widoku bez grupowania odpowiada
  mu pojedynczy końcowy wiersz z jawnym statusem `Todo`. Po sukcesie
  `createRootTask` zamienia odpowiedź API w lekki rekord i dopisuje go wyłącznie
  do lokalnego cache docelowej grupy, aktualizując jej licznik — bez `load()` i
  bez utraty scrolla, filtrów albo rozwiniętych podzadań. Regresja Cubita
  potwierdza brak dodatkowego odczytu grup oraz lokalne dopisanie rekordu do
  wcześniej pustej grupy statusu; `flutter analyze`, 36 testów Cubita i `git
  diff --check` są zielone.
  Krytyczna poprawka 2026-08-31: `CreateProjectTaskHandler` wybiera kolumnę
  tworzenia z `TargetStatus`, a nie z obowiązkowego `Status`. Lista wysyłała
  tylko `Status`, przez co każde zadanie trafiało do pierwszego statusu workflow
  (w tym projekcie Backlog). `createRootTask` oraz `createSubtask` wysyłają
  teraz `targetStatus` równy statusowi klikniętej grupy; regresje Cubita
  asercyjnie sprawdzają oba pola payloadu. Audyt wszystkich wywołań
  `CreateProjectTaskPayload` dopiął także podzadanie tworzone z detailu oraz
  tworzenie Task jako zasobu projektu; Kanban miał `targetStatus` już wcześniej.
  Regresja `task_details_cubit_test.dart` sprawdza teraz, że detail wysyła oba
  statusy dla podzadania; 18 jego testów, `flutter analyze` i `git diff --check`
  są zielone.
- [ ] **Filtr użytkownika i prezentacja osób.** Lista ma trzy niezależne,
  serwerowe filtry: „Osoba” (wybrany członek projektu albo `Nieprzypisane`),
  „Mój udział” (`PrimaryAssignee`/właściciel, `Collaborator`, `Watcher`) oraz
  status/priorytet. Backend 2026-08-31 przyjmuje `UnassignedOnly` zarówno dla
  listy, jak i grup, odrzuca sprzeczne połączenie z `AssigneeCoreUserId` i
  stosuje filtr przed liczeniem grup oraz cursorami. Flutter zachowuje te
  parametry przy doładowaniu grup; menu osób pokazuje nazwę i avatar z katalogu
  członków projektu, nie UUID. Potwierdzone przez `flutter analyze`, 36 testów
  Cubita oraz 35 testów `ProjectTaskHandlerTests`. Status ponownie otwarty po
  zgłoszeniu odbiorowym 2026-08-31: część filtrów zwraca 403; obowiązuje punkt
  P0 „Filtry nie mogą psuć listy po 403” aż do sprawdzenia kontraktu i runtime.
- [ ] **Tooltipy i język bulk.** Każda ikona, checkbox, resize handle i bulk
  akcja ma `Tooltip`/Semantics opisujące dokładny skutek, np. „Zmień status
  12 zaznaczonych zadań”, „Archiwizuj 12 zadań”, „Zaznacz tylko tę grupę”.
  Audyt 2026-08-31 domknął uchwyt resize (tooltip i Semantics z nazwą kolumny),
  checkbox nagłówka grupy/gałęzi oraz checkbox pojedynczego zadania (cel z
  kluczem zadania); test widgetowy pokrywa header. Pozostał audyt dokładnej
  liczebności w etykietach wszystkich akcji bulk na uruchomionej liście.
  Toolbar musi pokazywać zakres selekcji i różnicę między załadowanymi ID a
  tokenem całego wyniku. Domknięcie kodu 2026-08-31: wszystkie akcje bulk dla
  zaznaczenia wskazują w tooltipie bieżącą liczbę zadań (status, priorytet,
  termin, wykonawca, archiwizacja i czyszczenie), zaś akcje tokenowe jawnie
  mówią „cały filtrowany wynik”. Widoczny licznik zmieniono z niejednoznacznego
  `zazn.` na `N zaznaczonych`. `flutter analyze`, 36 testów Cubita i `git
  diff --check` są zielone; pozostaje ręczny odbiór tooltipów i fokusowania.

#### P1 — kompletność domeny i saved views

- [ ] **Powtarzalność zadań.** Istniejąca funkcja recurrence musi być dostępna
  z menu kontekstowego/inline szybkiej edycji taska ORAZ z karty Kanban;
  użytkownik ma móc dodać, zmienić, wstrzymać i wznowić regułę bez otwierania
  detailu. Wiersz i karta powinny pokazywać dyskretny znacznik powtarzalności
  i tooltip z regułą. Audyt
  kontraktu 2026-08-31: backend ładuje `RecurrenceRule` dla lekkiej listy, ale
  `ProjectTaskResponseMapper.ToListItem` nie przekazuje żadnego podsumowania
  do `ProjectTaskListItemResponse`; Flutter również nie miał takiego pola.
  Etap kontraktu rozpoczęty 2026-08-31: DTO lekkiej listy ORAZ kontrakt karty
  Kanban mają opcjonalne `recurrence`, mapowane z istniejącej `RecurrenceRule`.
  Wiersz listy i karta pokazują już ikonę z tooltipem (aktywną lub wstrzymaną
  serię); 11 testów wiersza Fluttera oraz regresja backendowa Kanbana
  potwierdzają częstotliwość, interwał, aktywność i źródło serii dla boarda i
  strony kolumny. Lista ma już lokalne pause/resume z menu kontekstowego,
  optimistic patch, rollbackiem błędu i wersją reguły; dwie regresje Cubita
  potwierdzają brak kolejnego `GET groups`. Do domknięcia bez odstępstw: (1)
  wspólny, zakotwiczony edytor pełnej reguły uruchamiany z menu kontekstowego
  dla listy i Kanbana (ikona powtarzania jest tylko skrótem do tego samego
  panelu), (2)
  create/update oraz pause/resume także na Kanbanie z optimistic patch i wersją
  reguły, (3) regresje mutacji obu widoków i ręczny odbiór. Nie pobierać pełnego detailu dla każdego wiersza/karty ani nie
  udawać szybkiej edycji przez nawigację do detailu.
  Implementacja edytora 2026-09-01: wspólny zakotwiczony panel jest dostępny
  z menu kontekstowego Listy i ikony cykliczności każdej karty Kanban (także
  gdy reguły jeszcze nie ma). Zapis tworzy/aktualizuje pełny kontrakt, a
  `ProjectTasksListCubit` i `TasksBoardCubit` stosują odpowiedź lokalnie z
  nową wersją zadania; test Kanbanu potwierdza brak drugiego pobrania boarda.
  Panel także wstrzymuje/wznawia istniejącą serię na wersji reguły; szybka
  akcja pause/resume w Liście pozostaje skrótem do tej samej operacji.
  Pozostaje ręczny odbiór panelu oraz dopisanie widgetowej regresji tworzenia
  reguły z Listy.
- [ ] **Pełne kolumny.** Audyt enumu backend/Flutter i konfiguratora saved view:
  użytkownik ma zobaczyć każdą wspieraną kolumnę systemową oraz każde custom
  field, z rendererem i opisem editable/read-only. Brakujące pozycje naprawić
  kontraktem, nie ukrywaniem pola. Audyt 2026-09-01 potwierdził zgodność 22
  systemowych wartości enumu backend–Flutter oraz ich rendererów; poprawiono
  też konfigurację domyślną listy, która powielała `Owner` i
  `Collaborators` mimo późniejszej deduplikacji. Regresja wierszy wymusza
  unikalność domyślnych kolumn i obecność obu ról; `flutter analyze` zielone.
  Walidacja saved view backendu 2026-09-01: `CustomFieldIds` musi należeć do
  bieżącego workspace i projektu. Wcześniej można było zapisać UUID pola z
  innego projektu, tworząc martwą kolumnę; regresja
  `SavedViewRejectsCustomFieldFromAnotherProject`, 44 testy handlerów i build
  backendu bez ostrzeżeń są zielone.

#### P1 — jakość architektury i utrzymywalność

- [ ] **Rozbić `ProjectTasksListCubit`.** Cubit przekroczył rozsądny zakres
  (~2000 linii). Wydzielić bez `BuildContext`: query/group paging, tree/subtask
  branches, selection/bulk, inline mutation/realtime reconciliation oraz
  immutable helper/reducer. Zachować publiczne API etapami i dodać testy Cubita
  dla każdego wydzielonego reduktora; nie robić jednego ryzykownego rewrite.
  Pierwszy bezpieczny etap wykonano 2026-09-01: stan (`ProjectTasksListState`,
  `Loading`, `Failure`, `Ready`) mieszka w `project_tasks_list_state.dart` i
  pozostaje eksportowany przez dotychczasowy plik Cubita, więc publiczne importy
  nie pękają. Czyste transformacje snapshotu — deduplikacja załadowanych
  rekordów, zakresy grup/podzadań, podmiana z przeniesieniem między grupami i
  usuwanie — są w `task_list_snapshot.dart`; Cubit deleguje je bez I/O. 42
  regresje Cubita, `flutter analyze` oraz `git diff --check` są zielone.
  Drugi etap wykonano 2026-09-01: `task_list_query.dart` jest jedynym miejscem
  składania filtrów dla pierwszego odczytu, zwykłej paginacji i paginacji
  pojedynczej grupy. `status`, `priority`, osoba, udział, nieprzypisane,
  przypięte i `savedViewId` nie mogą rozjechać się między tymi trzema
  requestami. 42 regresje Cubita ponownie przeszły. Następny etap:
  branch/subtask i bulk, zachowując bieżące testy jako kontrakt.
  Etap branch/subtask rozpoczęto 2026-09-01: `task_list_tree_snapshot.dart`
  zawiera czyste przejścia loading/błąd/scalanie kursora jednej gałęzi. Cubit
  zostawia w sobie wyłącznie I/O. Przy okazji podzadania korzystają z
  `TaskListQuery`, a więc dziedziczą komplet aktywnych filtrów, nie tylko
  status i priorytet. `flutter analyze`, 42 testy Cubita i `git diff --check`
  są zielone. Backendowa regresja naprawiona 2026-09-01:
  `ListProjectTasksHandler` daje teraz jawnemu `ParentTaskId` requestu
  pierwszeństwo przed zakresem saved view. Bez tego saved view z domyślnym
  `ParentTaskId = null` zwracał przy rozwijaniu gałęzi taski główne zamiast
  dzieci. Test `ExplicitParentOverridesSavedViewsRootTaskScope` oraz 40
  celowanych testów handlerów są zielone; projekt backendu kompiluje się bez
  ostrzeżeń. Regresja bulk 2026-09-01: token „cały filtrowany wynik” przenosi
  teraz identyczny zakres co lista — status, priorytet, osoba, udział,
  przypięcie i nieprzypisane. Wcześniej gubił trzy ostatnie filtry, więc bulk
  mógł objąć rekordy niewidoczne w liście. Typowany payload Fluttera ma też
  `unassignedOnly`; testy Cubita pokrywają pełny filtr oraz ten boolean.
  Stabilność paginacji grup 2026-09-01: drugi równoległy request tego samego
  `groupKey` jest ignorowany, a odpowiedź scala się z najnowszą grupą w stanie,
  nie ze snapshotem sprzed await — nie może więc cofnąć równoległej mutacji
  lokalnej. Regresja Cubita wymusza opóźnioną stronę i potwierdza jeden request.
  Szeroka walidacja po tych zmianach: pełne `flutter test --reporter compact`
  zakończyło się 2026-09-01 powodzeniem (504 testy, 4 świadomie pominięte).
  Logi HTTP 400 w testach widgetowych są oczekiwanymi odpowiedziami atrapowego
  adresu API, nie połączeniem z uruchomioną aplikacją.
  Porządkowanie reducerów 2026-09-01: pomyślne archiwizowanie wiersza używa
  `TaskListSnapshot.removeTask`, tak samo jak bulk tokenowy; usunięto drugą,
  rozchodzącą się kopię aktualizacji grup, podzadań, zaznaczenia i błędów.
  Istniejąca regresja archiwizacji oraz 44 testy Cubita pozostają zielone.
  Walidacja backendu bulk 2026-09-01: endpoint tworzenia tokenu odrzuca teraz
  sprzeczne `UnassignedOnly` i `AssigneeCoreUserId`, identycznie jak zwykła
  lista oraz lista grup. Nie tworzy już pustej, pozornie poprawnej selekcji.
  Regresja `SelectionTokenRejectsContradictoryUnassignedAndAssigneeFilters`,
  41 testów handlerów i build backendu bez ostrzeżeń są zielone.
  Refaktor create 2026-09-01: konwersja pełnej odpowiedzi utworzonego taska
  do lekkiego wiersza i dopisanie go lokalnie do grupy są w
  `TaskListSnapshot.appendCreatedRootTask`; Cubit pozostawia sobie request.
  Zachowano deduplikację echa realtime po stabilnym ID. `flutter analyze`,
  44 testy Cubita i `git diff --check` są zielone.
  Poprawność create przy filtrach 2026-09-01: lokalny dopis po sukcesie następuje
  tylko, gdy nowy task spełnia znane filtry (status, priorytet, osoba,
  nieprzypisane). Przy pinezce, saved view albo „mój udział” klient nie zgaduje
  wyniku serwerowego i nie wstrzykuje wiersza poza widok; pokaże się przy
  naturalnym odświeżeniu. Regresja priorytetu oraz 45 testów Cubita są zielone.
  Dalsze skrócenie Cubita 2026-09-01: wyszukiwanie bieżącego taska w grupach i
  cache podzadań jest `TaskListSnapshot.findLoadedTask`, używanym przez realtime,
  serializację lekkiego PATCH-a, move i bulk. `flutter analyze`, 45 testów
  Cubita i `git diff --check` są zielone.
  Pełny create dla własnego workflow 2026-09-01: kontrakt backendu i Fluttera
  ma `CustomStatusId`. Backend waliduje aktywną kolumnę tego projektu,
  odrzuca połączenie z `TargetStatus`/podzadaniem i wyprowadza status systemowy
  z kategorii kolumny. Inline „Dodaj zadanie” jest dostępne w prawidłowej
  grupie custom (nie w pseudo-grupie `none`), a reducer dopisuje odpowiedź do
  tej grupy bez reloadu. Regresje: 46 testów Cubita Fluttera oraz 42 testy
  handlerów backendu; analizator, build backendu i `git diff --check` zielone.
  Izolacja create custom workflow 2026-09-01: `CustomStatusId` z innego
  projektu/workspace jest odrzucany przez backend; regresja handlera wraz z
  poprzednim testem pozytywnym daje 43 zielone testy `ProjectTaskHandlerTests`.
  Transport create custom workflow 2026-09-01: test kontraktu JSON Fluttera
  potwierdza serializację i odczyt `customStatusId`, więc pole przechodzi przez
  Retrofit do backendu, nie tylko przez Cubit. `flutter analyze`, test kontraktu
  oraz 46 testów Cubita są zielone.
  Końcowa walidacja backendu 2026-09-01: pełne `dotnet test` zakończyło się
  powodzeniem — 831 testów zielonych, 3 świadomie pominięte, bo lokalny Redis
  testowy pod `localhost:6380` nie był dostępny. Macierz HTTP Tasks obejmuje
  teraz wszystkie 88 operacji Swaggera; smoke request tokenu selekcji wysyła
  poprawny kontrakt `{ "query": {} }`, więc sprawdza rzeczywisty pipeline,
  zamiast maskować błąd żądaniem bez wymaganego body.
  **Na jutro / odbiór ręczny bez hot reload:** sprawdzić na uruchomionej przez
  użytkownika instancji dodanie root taska w każdej kolumnie custom workflow,
  zachowanie pinezki i obserwowania po zmianie statusu oraz cykliczność z menu
  kontekstowego Listy i Kanbana. Nie uruchamiać drugiej instancji Fluttera.
  Refaktor bulk 2026-09-01: `TaskListSnapshot.applyBulkMutation` jest jedynym
  reducerem potwierdzonej odpowiedzi tokenowej. Zachowuje wersje tylko
  widocznych rekordów, przenoszenie między grupami, archiwizację i czyszczenie
  zaznaczenia; Cubit zostawia sobie wyłącznie I/O tokenu i emisję stanu. `flutter
  analyze`, 54 regresje Cubita/listowego zaznaczania oraz 3 niezależne testy
  snapshotu są zielone. Snapshot pokrywa przeniesienie wyłącznie potwierdzonego
  rekordu między grupami i archiwizację wyłącznie rekordów zwróconych przez
  backend. Poprawka licznika 2026-09-01: `removeTask` zmniejsza `totalCount`
  tylko, gdy usuwa główny wiersz z grupy; usunięcie dziecka z cache rozwiniętej
  gałęzi pozostawia licznik zadań głównych bez zmian. Regresja backendu
  2026-09-01: odpowiedź `PATCH /list-item` musi mieć pełną zgodność z lekką
  projekcją; poza pinezką i obserwowaniem zwraca teraz aktywne etykiety oraz
  nazwę/kolor własnego statusu. Bez tego zwykła edycja tytułu lub priorytetu
  mogła zgasić te elementy w jednym wierszu. Regresja handlera, 43 celowane
  testy backendu i build bez ostrzeżeń są zielone. Następny mały etap
  refaktoru: wyprowadzić orkiestrację gałęzi podzadań, bez zmiany publicznego
  API.
  Szeroka walidacja końcowa 2026-09-01: pełne `flutter test --reporter compact`
  przeszło (511 testów, 4 kontrolowane skipy), zaś pełne `dotnet test` Workspaces
  przeszło (832 testy, 3 kontrolowane skipy bez lokalnego Redis). Przy tej
  walidacji znaleziono i naprawiono niedeterministyczne sortowanie osobistych
  workspace: `UpdateWorkspaceOrderHandler` po zapisie kolejności sortuje teraz
  według pinezki, zapisanej pozycji, nazwy i UUID — nie według przypadkowej
  kolejności bazy. Regresja integracyjna preferencji oraz build backendu są
  zielone.
  Refaktor gałęzi podzadań 2026-09-01: `TaskListTreeSnapshot.toggleExpansion`
  jest czystą decyzją zwinięcia, rozwinięcia z cache albo pierwszego pobrania.
  Cubit wykonuje I/O wyłącznie dla ostatniego wariantu i dostaje jawny zbiór
  rozwiniętych ID. Trzy regresje snapshotu pokrywają te warianty; `flutter
  analyze` oraz celowany zestaw listy są zielone.
  Kontrakt grupowania 2026-09-01: kolejność systemowego workflow została
  wydzielona do `task_list_grouping.dart` i ma cztery regresje Fluttera. Audyt
  ujawnił odpowiadający błąd backendu: bez zapisanej konfiguracji workflow API
  numerowało grupy według deklaracji enuma (`Backlog` przed `Todo`).
  `ListProjectTasksHandler` zwraca teraz deterministycznie `Todo → InProgress
  → Blocked → Done → Cancelled → Backlog`; regresja handlera (44 testy) i build
  backendu bez ostrzeżeń są zielone. Custom workflow nadal zachowuje pozycję
  zapisaną przez backend. Uzupełnienie fallbacku: gdy projekt nie ma jeszcze
  zapisanych statusów, response grup zawiera również polskie nazwy i kolory
  (`Do zrobienia`, `W toku`, itd.), a nie techniczne teksty enuma. Regresja
  potwierdza nazwę i kolor; 45 testów handlera oraz build backendu są zielone.
  Spójność anulowania 2026-09-01: audyt wykazał, że `Cancelled` istniał w
  enumie i grupie listy, ale nie był częścią domyślnego `ProjectTaskWorkflow`.
  Dodano go jako terminalny status `Anulowane` z własną pozycją, więc widoczna
  grupa ma identyczne wsparcie konfiguracji, przejść i walidacji co pozostałe
  statusy. Regresja potwierdza pełny zestaw enumów; 46 testów handlera i build
  bez ostrzeżeń są zielone. Dodano też idempotentną migrację danych
  `20260901000000_AddCancelledTaskWorkflowStatus`, która uzupełnia istniejące
  projekty bez nadpisywania własnej konfiguracji (`ON CONFLICT DO NOTHING`);
  wygenerowany skrypt EF potwierdza jej obecność i insert `Anulowane`.
  Dodatkowa ochrona runtime: `ProjectTaskWorkflowService.EnsureDefaultsAsync`
  uzupełnia każdy brakujący status także wtedy, gdy środowisko startuje przed
  wykonaniem migracji; nie dotyka istniejących nazw, kolorów, pozycji ani
  statusu początkowego. Regresja dawnego workflow pięciostatusowego potwierdza
  wyłącznie dodanie `Cancelled`; 47 testów handlera oraz build są zielone.
  Refaktor katalogu workflow 2026-09-01: `TaskSystemWorkflowDefaults` jest
  jedynym źródłem systemowych statusów, nazw, kolorów, pozycji i terminalności
  dla Listy, Kanbana oraz `ProjectTaskWorkflowService`; lista korzysta tylko z
  osobnej kolejności prezentacji. Usunięto trzy rozchodzące się definicje,
  przez które Kanban nie znał `Cancelled`. Celowane testy handlera i Kanbana
  (61) oraz build backendu są zielone.
  Naprawa unassigned custom workflow 2026-09-01: klucz prezentacyjny
  `custom-status:none` nie jest UUID i wcześniej trafiał dosłownie do requestu
  drag-and-drop, powodując błąd walidacji. Wspólny kontrakt grup rozpoznaje go
  teraz jako semantyczne „wyczyść custom status”; Cubit wysyła bieżący status
  systemowy (obsługiwana już ścieżka backendu, która czyści `CustomStatusId`).
  Regresja Cubita potwierdza payload i lokalny wynik bez pełnego odczytu;
  51 testów listy oraz `flutter analyze` są zielone.
  Bulk custom workflow 2026-09-01: ta sama grupa była dostępna w akcji „Grupa
  wszystkich”, lecz bulk nie miał wcześniej kontraktu na usunięcie statusu
  custom bez nadpisania systemowego. Dodano pełne pole API
  `ClearCustomStatus` (wyklucza `Status`, `CustomStatusId` i archiwizację),
  implementację atomowego handlera i aktualizację lokalnego snapshotu do
  `custom-status:none`. Menu przekazuje typowaną intencję, więc sentinel nigdy
  nie trafia do JSON. Regresje: 54 testy Flutter list/Cubit, 45 testów handlera
  Workspaces, analizator oraz build backendu bez ostrzeżeń.
  Test backendu porównuje też wersję i `UpdatedAtUtc` response bulk z rekordem
  po zapisie, więc kolejna mutacja klienta nie może dostać starego tokenu
  optimistic concurrency. Regresja kontraktu JSON Fluttera osobno potwierdza
  serializację `clearCustomStatus: true`, odróżniając ją od braku zmiany.
  Pełna walidacja po kontraktach workflow 2026-09-01: `flutter test --reporter
  compact` zakończył się sukcesem (520 testów, 4 kontrolowane skipy), a pełne
  `dotnet test` Workspaces sukcesem (833 testy, 3 kontrolowane skipy bez
  lokalnego Redis/SignalR). Nie uruchamiano aplikacji Flutter ani lokalnej
  instancji backendu. `git diff --check` jest zielony dla obu repozytoriów.
- [ ] **Rozbić widgety listy.** Oddzielić registry kolumn/renderery, menu
  kontekstowe, edytory, selection/keyboard, tree painter i wiersze. Wspólne
  menu ma mieszkać w `shared/workspaces`, nie jako kolejne lokalne helpery w
  `project_tasks_list_rows.dart`.
- [x] Podlista: własny header i pionowe separatory są obowiązkowe; title,
  status, owner/collaborators, start i due date są edytowalne bez detailu.
  Ten sam `TaskListRow` obsługuje rodzica i dziecko, więc picker osób oraz
  wersjonowane edytory dat działają także w mini-tabeli.
- [x] Kolejność grup statusu: domyślnie `Do zrobienia → W toku → Zablokowane
  → Gotowe → Anulowane → Backlog`; custom workflow zachowuje kolejność
  backendu. Zrealizowano 2026-09-01: czysty moduł `task_list_grouping.dart`
  jest pojedynczym kontraktem kluczy, kolejności i dozwolonych grup tworzenia;
  cztery regresje chronią kolejność, case-insensitive parsing oraz tworzenie w
  grupie systemowej/custom workflow. Ewentualne ręczne ustawianie kolejności
  przez użytkownika wymaga osobnego kontraktu zapisanego widoku — nie jest
  obecnie symulowane po stronie klienta.

### 3.3. Macierz kontraktu backendu i plan domknięcia — 2026-08-30

Poniższy audyt jest oparty o faktyczny kontrakt Workspaces, nie o założenia UI:
`ProjectTaskListItemResponse`, `TaskSavedViewDefinition`, `TaskOperationsHandler`,
`GetProjectTaskHandler` i endpointy operacji zadania. To jest obowiązująca
kolejność dalszych prac. Punkt może zostać oznaczony jako wykonany wyłącznie po
kodzie i teście Cubita albo testach backendowych; nie po samym wyglądzie.

| Zakres backendu | Stan lekkiej listy | Wymagane zachowanie jak w Monday |
| --- | --- | --- |
| Klucz, tytuł, status, własny status, priorytet, start, termin, checklist, podzadania, wersja | Dostępne | typowane komórki; tytuł/status/priorytet/start/termin zapisują PATCH z `expectedVersion`; status przenosi wyłącznie jeden wiersz między grupami. |
| Wykonawcy | Dostępni jako `Assignees`; pierwszy `IsPrimary` to właściciel, reszta to współpracownicy | jedna komórka „Osoby” pokazuje ownera i avatarów współpracowników; klik otwiera picker, gdzie pierwszy wybrany jest ownerem; zapis `PUT /assignees` z rollbackiem. |
| Etykiety | Dostępne w lekkiej liście | renderer chipów i picker/edytor oparty o istniejące API etykiet; kolumna saved view. |
| Typ, size, complexity, risk, business value, estimate, actual time, created/updated | Dostępne w lekkiej liście | każda wartość ma własny renderer; pola zapisywalne mają edytor albo wyraźny stan read-only, nigdy pustą/szarą atrapę. |
| Custom fields: text, number, date, boolean, single select, multi select, user | Dostępne jako stabilne `custom:{fieldId}` i wartości lekkiej projekcji | renderer zależny od typu oraz edytor zakotwiczony w klikniętej komórce; wartości select jako chipy, user jako avatar/nazwa, boolean jako semantyczny znacznik, data/number sformatowane. |
| Obserwatorzy | Lekka projekcja ma `watcherCount` i `isWatchedByMe`, a lista ma kolumnę saved view oraz follow/unfollow lokalnie | Dokończyć te same akcje i lokalny patch na Kanbanie; sprawdzić runtime 403/409 i nie mylić obserwatorów z ownerem ani collaboratorami. |
| Szczegóły: opis, acceptance criteria, dependencies, recurrence, workflow, pin, archive | Dostępne przez pełny task/detail i osobne operacje | nie ładować ich masowo do każdego wiersza. Dać akcje menu/quick edit tam, gdzie API jest lekkie; rozbudowane edycje pozostają w detailu. |

Kolejne etapy realizacji:

- [x] **Etap A — people i daty w obu tabelach.** Ujednolicić picker ownera/
  collaboratorów z detalem, podłączyć go do rodzica i podzadania, zachować
  optimistic update, rollback i serializację szybkich zmian. Dopiąć ten sam
  standard dla startu i terminu. Zrealizowano 2026-08-30; `flutter analyze`
  oraz 29 testów Cubita listy są zielone.
- [x] **Etap B — custom fields bez atrap.** Zastąpić tekstowy renderer
  rendererami typowanymi; menu single-select/boolean/user ma być pozycjonowane
  przy komórce. Zachować wszystkie zdefiniowane pola użytkownika — błędna nazwa
  nie jest powodem do ich ukrywania. Zrealizowano 2026-08-30; `flutter analyze`
  oraz 29 testów Cubita listy są zielone.
- [ ] **Etap C — macierz systemowych kolumn i konfigurator saved view.**
  Udostępnić każdy istniejący enum kolumny w konfiguratorze, z opisem
  read-only/editable; dodać brakujące kolumny backendowe dopiero z migracją
  kontraktu Flutter + Workspaces i testem serializacji.
- [x] **Etap D — pełne menu kontekstowe.** Jedno zwarte menu (prawy klik,
  klawisz Menu, Shift+F10) z grupami: zmiana statusu/prioritetu, osoby,
  terminy, custom fields, podzadanie, duplikat, pin/obserwowanie i archiwum.
  Menu używa tych samych mutacji co komórki, więc nie robi pełnego reloadu.
  Zrealizowano 2026-08-30; weryfikacja `flutter analyze` i 31 testów Cubita.
- [x] **Etap E — obserwatorzy i lekka projekcja.** Rozszerzyć backend oraz
  saved view o watchers, dopisać testy handlera i Cubita; nie pobierać detailu
  każdego zadania tylko po to, aby wyrenderować kolumnę. Zrealizowano
  2026-08-30; backend liczy zbiorczo obserwatorów załadowanej strony.
- [ ] **Etap F — odbiór ergonomii.** Ręcznie sprawdzić scroll dolny, resize,
  grupy, rodzica z kilkoma podzadaniami, prawy klik, szybką serię dwóch zmian,
  konflikt wersji i realtime. Dopiero wtedy zamknąć checklistę redesignu.

### Co już istnieje i należy wykorzystać

- `TasksBoardPage` utrzymuje wspólny shell i przełącza cztery widoki:
  `board`, `list`, `timeline`, `workload`.
- wybrany widok jest synchronizowany z URL i lokalną preferencją;
- `_BoardHeader` już jest współdzielony pomiędzy widokami;
- istnieją saved views z filtrami, sortowaniem, grupowaniem i listą kolumn;
- lista ma cursor pagination i automatyczne doładowanie;
- Kanban ma paginację per kolumna, DnD, optimistic update i rollback;
- istnieją bulk actions, quick filters, presence i status realtime;
- istnieją ustawienia workflow, statusów, pól custom, etykiet, milestone,
  capacity, automatyzacji i harmonogramu;
- istnieje wspólny `AppContextMenu`, w tym wariant `glass`, oraz obsługa
  secondary tap w innych częściach aplikacji;
- istnieje pełny detail zadania, repozytoria mutacji, custom fields, etykiet,
  wykonawców, checklist, zależności i archiwizacji;
- drzewo danych dopuszcza tylko jeden poziom podzadań, zgodnie z domeną.

### Główne problemy obecnego headera

- identyfikacja sprowadza się do dużej ikony `Tasks`, tytułu i licznika;
  brakuje czytelnego `Workspace / Projekt / Zadania` i nazwy projektu;
- pierwszy wiersz zajmuje dużo wysokości, mimo że nie zawiera głównej akcji
  `Nowe zadanie` ani wyszukiwarki;
- taby mają ikony i tworzą dodatkową wizualną masę;
- quick filter istnieje tylko dla Kanbana, zamiast wspólnego modelu filtrów;
- saved views, ustawienia, presence i połączenie są wymieszane w jednym rzędzie;
- wiele funkcji administracyjnych ukrywa jedno duże menu ustawień, a często
  używane funkcje listy są w samej liście;
- bulk actions zmieniają wysokość headera na węższych viewportach;
- header nie definiuje wspólnego miejsca na zakres dat dla Timeline/Workload.

### Główne problemy obecnej listy

- `Center` + `ConstrainedBox(maxWidth: 1180)` sztucznie ogranicza szerokość;
- padding `20/18/20/26` odsuwa dane od headera i bocznego menu;
- filtry Status/Priority są powtórzone wewnątrz listy zamiast command bar;
- tabela ma stałe kolumny: zadanie, status, priorytet, owner, termin, postęp;
- konfiguracja `TaskSavedViewDefinition.columns` nie steruje renderem tabeli;
- brak pól: start, typ, size, complexity, risk, business value, estymata,
  actual/logged time, labels, custom status, custom fields i updated time;
- grupowanie odbywa się lokalnie tylko dla aktualnie pobranej strony;
  licznik grupy jest więc licznikiem fragmentu danych, nie całej grupy;
- nagłówki grup nie są zwijane i nie mają własnego cursoru;
- podzadanie jest tylko wierszem z ikoną; nie istnieje kontrolowane rozwijanie
  drzewa ani lazy loading dzieci;
- ikona drag handle nie uruchamia reorderu w liście;
- menu wiersza używa zwykłego `PopupMenuButton`, ma tylko trzy akcje, a callbacki
  nie są podłączone przez listę;
- brak secondary click, multi-select, shift-select i akcji grupowych;
- komórki nie są edytowalne inline;
- brak sticky kolumn, zmiany szerokości, kolejności i ukrywania kolumn;
- horyzontalny i pionowy scroll nie mają zapisanego stanu widoku;
- wiersz ma 54 px wysokości bez trybu gęstości.

### 3.1. Docelowy wzorzec podlisty podzadań

Podzadania nie są drugim, niezależnym panelem ani kolejną grupą statusu. Po
rozwinięciu rodzica powstaje bezpośrednio pod jego wierszem **osadzona tabela
potomków**, wizualnie należąca do tego jednego rodzica. Wzorcem jest układ z
referencji: rodzic pozostaje normalnym wierszem głównej tabeli, a dzieci są
czytelnie wcięte, mają krótszy zestaw kolumn i kończą się wierszem dodawania.

```text
┌ główna tabela ──────────────────────────────────────────────────────────┐
│ ▾ [ ] Zadanie rodzica             Status | Owner | Termin | …           │
│ │  ┌ podlista rodzica ────────────────────────────────────────────────┐ │
│ │  │ [ ] Element podrzędny       Owner  | Status | Data                │ │
│ │  ├─────────────────────────────────────────────────────────────────┤ │
│ │  │ [ ] Pierwsze podzadanie     …                                    │ │
│ │  │ [ ] Drugie podzadanie       …                                    │ │
│ │  ├─────────────────────────────────────────────────────────────────┤ │
│ │  │     + Dodaj podzadanie                                           │ │
│ │  └─────────────────────────────────────────────────────────────────┘ │
│ + Dodaj zadanie                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

Zasady prezentacji i interakcji:

- Każdy rodzic może zostać rozwinięty — również przy `subtaskCount == 0`, aby
  utworzyć pierwsze dziecko inline. Chevron zawsze pozostaje w pierwszej
  kolumnie rodzica, obok checkboxa — nie jako osobny, duży przycisk.
- Z lewej strony mini-tabeli biegnie subtelna szara prowadnica; od wiersza
  rodzica odchodzi poziomy łącznik, a przy kolejnych dzieciach końce linii są
  zaokrąglone. Nie rysujemy linii przez tekst ani przez całą szerokość tabeli.
- Kontener podlisty zaczyna się po kolumnie zaznaczenia rodzica (około 42–54
  px wcięcia), ma delikatną lewą krawędź w kolorze statusu rodzica i własną,
  cienką ramkę. Nie ma karty, cienia ani dużego pionowego odstępu.
- Header mini-tabeli ma tę samą wysokość co header listy (około 32–36 px), ale
  tylko kolumny potrzebne do szybkiej pracy: `Podzadanie`, `Owner`, `Status`,
  `Termin`; opcjonalne dodatkowe pola są otwierane przez `+ Pole`, a nie przez
  odziedziczenie wszystkich kolumn rodzica.
- Wiersze dzieci są gęstsze niż rodzic (36–40 px), w pełni inline-editable w
  tych samych zasadach optimistic concurrency. Kliknięcie nazwy otwiera detail,
  a kliknięcie komórki edytuje tę komórkę bez rozwijania całego zadania.
- Ostatni wiersz to zawsze spokojna akcja `+ Dodaj podzadanie`, wewnątrz tej
  samej siatki i wyrównana do kolumny tytułu. Po kliknięciu pojawia się inline
  input z Enter = zapisz, Escape = anuluj; po sukcesie nowy rekord zostaje w
  cache rozwiniętej gałęzi bez odświeżania całej listy.
- Podlista ma własne doładowanie/cursor, stan `ładowanie` oraz pusty stan. Przy
  więcej niż jednej stronie na dole pojawia się zwarty wiersz `Pokaż kolejne`,
  nigdy nie renderujemy wszystkich dzieci naraz.
- DnD działa również w granicach tej tabeli: reorder dziecka wśród rodzeństwa,
  upuszczenie na rodzicu jako jego dziecko oraz przeniesienie dziecka do listy
  głównej. Backend zachowuje ograniczenie dokładnie jednego poziomu.
- Zwijanie rodzica zachowuje cache dzieci i zaznaczenie; realtime aktualizuje
  tylko niezmieniane lokalnie dzieci, aby nie usuwać aktywnej edycji.

## 4. Docelowa architektura informacji

Ekran Tasks składa się z trzech stałych warstw:

```text
Workspace navigation / menu aplikacji
└── TasksViewShell
    ├── TasksCommandHeader
    │   ├── ContextAndGlobalActionsRow
    │   └── ViewsAndControlsRow
    └── ActiveTaskView
        ├── Kanban
        ├── List
        ├── Timeline
        └── Workload
```

Header jest właścicielem wyłącznie wspólnego kontekstu i intencji UI. Dane
konkretnego widoku pozostają w jego Cubicie. Wspólny `TasksViewControllerCubit`
przechowuje wybrany widok, aktywny saved view, search, filtry, groupBy, sort,
widoczne kolumny i gęstość. Poszczególne widoki tłumaczą ten stan na swoje
zapytania, bez bezpośredniego uzależniania listy od Cubita Kanbana.

## 5. Wspólny kompaktowy header

### 5.1. Wymiary i układ desktopowy

- cały header: docelowo 84–96 px wysokości dla dwóch rzędów;
- padding poziomy: 12 px przy menu, 16 px po prawej;
- padding pionowy: 6–8 px;
- odstęp do danych: 0–6 px, bez osobnego dużego marginesu;
- dolna krawędź subtelna, header może być sticky;
- żadnej dekoracyjnej ikony 38×38 w głównej ścieżce pracy;
- kontrolki wysokości 30–34 px, ikony 16–18 px;
- tekst tabów bez dużych ikon; aktywny widok wskazany linią lub delikatnym tłem.

### 5.2. Pierwszy rząd — kontekst i funkcje projektu

Od lewej:

1. breadcrumb `Workspace / Projekt` z możliwością przejścia lub zmiany projektu;
2. tytuł `Zadania` lub nazwa aktywnego saved view;
3. mały licznik wyników, jeżeli backend zna total;
4. opcjonalna gwiazdka/przypięcie aktywnego widoku.

Od prawej:

1. `Automatyzacje` — otwiera istniejący modal/panel;
2. `Ustawienia` — workflow, statusy, pola, etykiety, milestone, harmonogram,
   capacity i ustawienia Kanban;
3. `Szablony`;
4. `Udostępnij/Zaproś` jako przyszła integracja z projektem;
5. presence w zwartej postaci;
6. stan realtime tylko przy problemie; poprawne połączenie nie powinno stale
   zajmować miejsca;
7. `Więcej` dla funkcji rzadkich.

W pierwszym etapie dopuszczalne są tekstowe mock-buttony, ale każdy musi mieć
docelową intencję i wskazany istniejący modal. Nie tworzymy nieaktywnych ikon bez
tooltipu i planu podłączenia.

### 5.3. Drugi rząd — widoki i praca na danych

Od lewej:

1. taby `Kanban`, `Lista`, `Timeline`, `Obciążenie`;
2. `+ Widok` do utworzenia saved view;
3. dzielnik;
4. primary split button `Nowe zadanie ▾`:
   - Nowe zadanie,
   - Nowe zadanie z szablonu,
   - Importuj zadania — widoczne dopiero po wdrożeniu;
5. wyszukiwarka rozszerzana od ikony do pola, ze skrótem `/` lub `Ctrl/Cmd+K`
   tylko w scope Tasks;
6. `Filtry` z liczbą aktywnych warunków;
7. `Sortuj`;
8. `Grupuj`;
9. `Kolumny`/`Pola`;
10. przełącznik gęstości;
11. `Więcej`.

Po prawej, zależnie od widoku:

- Kanban: quick filter, swimlane, ukryte kolumny;
- Lista: drzewo/płasko, pokaż zakończone, sticky columns;
- Timeline: zakres dat, zoom dzień/tydzień/miesiąc, pokaż bez dat;
- Workload: zakres dat, jednostka godziny/dni, sposób grupowania osób;
- podczas zaznaczenia: wspólny contextual bulk toolbar zastępuje prawą część
  drugiego rzędu bez zwiększania wysokości headera.

### 5.4. Zachowanie responsywne

- `>= 1280 px`: pełne dwa rzędy;
- `900–1279 px`: opisy mniej ważnych przycisków chowają się, zostają tooltipy;
- `640–899 px`: akcje projektu trafiają do `Więcej`, kontrolki danych do
  przewijanego poziomo paska;
- `< 640 px`: osobna compact composition; lista przechodzi w czytelne rekordy,
  ale zachowuje te same dane i mutacje;
- zmiana szerokości okna nie może resetować widoku, filtrów ani scrolla.

## 6. Pełnoszeroka lista jako tabela-drzewo

### 6.1. Kontener

- usunąć `Center`, `ConstrainedBox(maxWidth: 1180)` i zewnętrzną kartę 12 px;
- lista zajmuje całą szerokość od krawędzi treści przy menu do prawej krawędzi;
- lewy padding 8–12 px, prawy 0–8 px, dolny 8–12 px;
- pionowy i poziomy viewport są częścią jednego gridu;
- nagłówek kolumn jest sticky;
- checkbox/drag, klucz i tytuł mogą być sticky poziomo;
- poziomy scroll pojawia się dopiero po przekroczeniu viewportu;
- szerokość tabeli wynika z sumy widocznych kolumn, bez sztucznego maksimum;
- gęstość: compact 36 px, comfortable 44 px, roomy 52 px.

### 6.2. Model kolumn

Wszystkie pola nie muszą być widoczne naraz, ale każde musi być dostępne w
pickerze i renderowane przez typowany `TaskColumnDefinition`.

Kolumny systemowe:

- selection/drag;
- expand/collapse;
- key;
- title;
- status i custom status;
- priority;
- assignees;
- task type;
- start date;
- due date;
- size;
- complexity;
- risk;
- business value;
- estimated time;
- actual/logged time;
- checklist progress;
- subtask progress;
- labels;
- blocked/dependencies;
- attachment count;
- created/updated date;
- created by;
- actions.

Każde aktywne custom field staje się dynamiczną kolumną identyfikowaną przez
`custom:{fieldId}`. Typ pola wybiera renderer/editor: text, number, date,
boolean, user, single-select lub multi-select.

Konfiguracja kolumn przechowuje:

- stabilny klucz kolumny;
- widoczność;
- kolejność;
- szerokość i min/max width;
- pinned left/right;
- sposób wyrównania;
- opcjonalne sortowanie i grupowanie;
- wybraną agregację w stopce grupy.

### 6.3. Grupy

Lista domyślnie może grupować po statusie albo pokazywać saved view użytkownika.
Obsługiwane docelowo grupowania:

- status/custom status;
- assignee;
- priority;
- due bucket;
- milestone;
- task type;
- label;
- wybrane custom field typu select/user/date/boolean.

Każda grupa ma:

- kolor/znacznik wynikający z wartości pola;
- nazwę i prawdziwy total z backendu;
- expand/collapse zapisywany w stanie widoku;
- własny cursor i lazy loading;
- `+ Dodaj zadanie` tworzące rekord z wartością grupującą;
- menu grupy: zwiń, rozwiń wszystkie, sortuj, ukryj, przenieś zaznaczone,
  ustaw domyślną wartość i konfiguruj agregacje;
- opcjonalną stopkę z agregatami, np. czas, liczba, postęp.

Grupowanie nie może być wykonywane wyłącznie na aktualnej stronie klienta.
Inaczej sekcja `W toku 8` może faktycznie zawierać setki rekordów, a kolejna
strona zmieni strukturę już wyrenderowanych grup.

### 6.4. Drzewo zadań

- zadanie główne ma chevron i licznik aktywnych podzadań;
- rozwinięcie ładuje dzieci osobnym cursorem dopiero na żądanie;
- podzadanie jest wcięte 24 px i połączone subtelną linią drzewa;
- podzadanie nie ma chevronu, bo domena dopuszcza jeden poziom;
- rozwinięty rodzic otwiera własną mini-tabelę: osobny header z kolumnami
  podzadań, osobne wiersze i dolny wiersz `+ Dodaj podzadanie`; nie stosujemy
  wyłącznie wcięcia w tabeli zadań głównych;
- relacja rodzic → podzadania jest narysowana lekkim `CustomPainter`em:
  pionowa linia od rodzica, krótkie odgałęzienia do wierszy dziecka i spokojny
  szary kolor zgodny z obrysem tabeli, bez ciężkich ikon lub kart;
- `+ Dodaj podzadanie` jest dostępne po hoverze pod rozwiniętym rodzicem oraz
  z menu kontekstowego;
- Enter zatwierdza szybkie tworzenie, Escape anuluje, Tab przechodzi do pól;
- utworzenie optymistycznie dodaje draft row, ale finalny identyfikator i wersja
  zawsze pochodzą z backendu;
- przeniesienie zadania pod rodzica musi być osobną, autoryzowaną mutacją;
- nie wolno pozwolić upuścić podzadania pod inne podzadanie.

### 6.5. Inline editing

Kliknięcie komórki wybiera rekord; podwójne kliknięcie, Enter albo bezpośredni
klik kontrolki uruchamia edycję. W zależności od typu:

- title/text/number: mały editor w komórce;
- status/priority/type/select: searchable popover;
- assignee/user: picker członków z awatarem;
- date: date picker z akcjami Dziś/Jutro/Wyczyść;
- boolean: switch/check;
- labels/multi-select: token picker;
- time: edytor godzin/minut z walidacją;
- custom field: renderer zgodny z definicją backendu.

Zapis:

1. lokalny draft w `TaskGridEditingCubit`;
2. optimistic update komórki;
3. mały wskaźnik zapisu, bez blokowania całego wiersza;
4. request z `expectedVersion`;
5. podmiana pełnego snapshotu/wersji odpowiedzi;
6. przy `409`: cofnięcie komórki, komunikat i akcja `Odśwież/Porównaj`;
7. realtime własnej mutacji jest deduplikowany przez event/version.

Kliknięcie zwykłego tekstu nie powinno od razu otwierać dużego modala. Detail
otwieramy przez klucz/tytuł, Enter przy nieedytowanej komórce, ikonę lub menu.

### 6.6. Drag-and-drop

Obsługujemy trzy jawnie rozróżnione operacje:

1. reorder w tej samej grupie;
2. przeniesienie do innej grupy, które zmienia wartość grupującą;
3. utworzenie/usunięcie relacji parent dla zadania i podzadania.

UI pokazuje linię insercji albo obrys rodzica, nigdy niejednoznaczne podświetlenie
całego wiersza. Autoscroll działa pionowo i poziomo. Escape anuluje DnD. Po
upuszczeniu UI wykonuje optimistic move, a konflikt przywraca wcześniejszy
snapshot i scroll. Reorder musi używać sąsiadów/ranku, nie pełnej listy tysięcy
ID pobranych do klienta.

### 6.7. Menu kontekstowe

Użyć istniejącego `AppContextMenu` i rozszerzyć go o sekcje, skróty i stan
disabled. Menu otwieramy prawym przyciskiem, `Shift+F10`, klawiszem menu oraz
przyciskiem `…` w wierszu.

Proponowane sekcje:

```text
Otwórz                         Enter
Edytuj tytuł                   F2
──────────────────────────────────
Ustaw status                 ▶
Ustaw priorytet              ▶
Przypisz osobę               ▶
Ustaw termin                 ▶
Pola niestandardowe          ▶
──────────────────────────────────
Dodaj podzadanie
Duplikuj
Przenieś / Zmień rodzica
Kopiuj link
──────────────────────────────────
Obserwuj / Przestań obserwować
Przypnij / Odepnij
Archiwizuj
```

Akcje ryzykowne są oddzielone i respektują rolę/uprawnienia. Podmenu można
zrealizować jako drugi panel obok menu, nie jako dialog. Menu działa również
dla wielu zaznaczonych rekordów i pokazuje tylko operacje wspólne dla selekcji.

### 6.8. Klawiatura i zaznaczenie

- strzałki: nawigacja po komórkach;
- Tab/Shift+Tab: kolejna/poprzednia edytowalna komórka;
- Enter: edycja/zatwierdzenie;
- Escape: anulowanie edycji, menu lub DnD;
- Space: zaznaczenie wiersza;
- Shift+click/Shift+Space: zakres;
- Ctrl/Cmd+A: wszystkie załadowane, druga akcja opcjonalnie wybiera cały wynik
  przez token selekcji backendowej;
- F2: edycja aktywnej komórki;
- Delete/Backspace nie archiwizuje bez potwierdzenia;
- `Ctrl/Cmd+Enter`: szybkie dodanie zadania w aktywnej grupie.

Focus i selection są niezależne. Rebuild jednej komórki nie może przebudowywać
całej tabeli.

### 6.9. Zaznaczenie wielokrotne i operacje masowe — następny etap

- checkbox w headerze wybiera aktualnie załadowane rekordy; Shift+click i
  Shift+Space wybierają zakres, Ctrl/Cmd+A zaznacza aktualny wynik;
- `TaskGridSelectionCubit` przechowuje IDs, anchor zakresu i tryb „wszystkie
  wyniki” oparty o token backendu, aby nie ładować tysięcy ID do klienta;
- po zaznaczeniu druga linia wspólnego headera zamienia się w niski bulk toolbar
  (status, priorytet, osoba, termin, grupa, archiwizacja), bez zmiany wysokości
  ekranu i bez osobnego modala;
- endpoint bulk mutation musi otrzymać filtr/token selekcji oraz wersje tylko
  wtedy, gdy operacja wymaga ochrony przed konfliktem. Realtime odświeża
  zaznaczony snapshot bez utraty focusu.

## 7. Zachowanie pozostałych widoków

### Kanban

- używa tego samego headera, filtrów, saved view i primary create action;
- pozostaje pełnoszeroki;
- obecna paginacja per kolumna i DnD są dobrym fundamentem;
- ustawienia kart i swimlane trafiają do kontekstowej części drugiego rzędu;
- nie duplikujemy osobnego tytułu i paska filtrów w samym Kanbanie.

### Timeline

- usuwa własny duży tytuł i padding 20 px;
- zakres dat i zoom trafiają do wspólnego headera;
- lewa tabela pól i prawa oś czasu dzielą pionowy scroll;
- w przyszłości możliwa bezpośrednia zmiana dat przez drag/resize z concurrency;
- pagination musi doładowywać `nextCursor`, którego obecny UI nie konsumuje.

### Workload

- usuwa `ConstrainedBox(maxWidth: 1060)` i własny duży tytuł;
- zajmuje pełną szerokość;
- zakres dat trafia do headera;
- docelowo tabela osoba × okres, z capacity, assigned, logged i remaining;
- karty mogą pozostać fallbackiem dla małego ekranu, nie głównym desktop UI.

## 8. Audyt backendu — co jest już kompletne

Backend `veloryn-workspaces` ma już:

- tworzenie zadania głównego i jednopoziomowego podzadania;
- cursorową listę z filtrami: status, priority, assignee, involvement, search,
  due range, archive, pinned i saved view;
- pełny detail i większość wymaganych pól systemowych;
- optimistic concurrency na mutacjach;
- aktualizację podstawowych pól zadania;
- osobne mutacje assignees, labels i custom fields;
- reorder pełnej gałęzi;
- Kanban move po `previousTaskId`/`nextTaskId`;
- historię, realtime, deduplikację i reconnect cursor;
- custom statusy, workflow, labels i custom field definitions;
- saved views z filtrem, sortem, groupBy i kolumnami;
- Timeline z zakresem, cursor pagination i zależnościami;
- Workload i capacity dla zakresu;
- bulk update Kanbana;
- archiwizację, przywracanie, przypięcie i obserwowanie.

Nie ma potrzeby tworzyć nowego backendu ani równoległego modelu Tasks.

## 9. Braki backendu konieczne dla docelowej listy

### P0 — blokujące wdrożenie pełnej listy

1. **Bogaty kontrakt list item.** `ProjectTaskListItemResponse` nie zawiera
   większości pól, których wymaga tabela. Potrzebny projekcyjny kontrakt listy,
   zawierający wybrane pola systemowe, labels i wartości wskazanych custom fields.
   Nie wolno pobierać detailu osobno dla każdego wiersza.
2. **Dynamiczny wybór pól.** Request listy powinien przyjmować bezpieczną listę
   `fieldKeys`/`customFieldIds`, aby projekcja nie zwracała wszystkich ciężkich
   pól przy każdym widoku.
3. **Grupowanie serwerowe.** Potrzebny endpoint/tryb odpowiedzi z grupami,
   prawdziwym `totalCount`, osobnym `nextCursor` i opcjonalnymi agregatami.
4. **Pełny katalog sort/group.** Saved views obsługują tylko 5 sortów, 4 grupy
   i 9 stałych kolumn. Należy dodać pola systemowe oraz typowane referencje do
   custom fields, bez mnożenia enumów per pole użytkownika.
5. **Reorder sąsiedni/rankowy dla listy.** Obecny `/tasks/order` wymaga pełnej
   kolejności jednej gałęzi. Przy infinite scroll nie znamy pełnej listy.
   Potrzebna mutacja `taskId + previousTaskId + nextTaskId + expectedVersion +
   targetGroup/parent`, analogiczna do dojrzałego move Kanbana.
6. **Zmiana parent.** Obecny update nie udostępnia bezpiecznej operacji awansu
   zadanie↔podzadanie. Potrzebny jawny endpoint z walidacją jednego poziomu,
   projektu, uprawnień, cykli i concurrency.
7. **Uprawnienia per pole.** Otwarty punkt głównego planu: widoczność,
   edytowalność, required-before-transition, kolejność i role pól. UI nie może
   zgadywać, czy komórka jest edytowalna.

### P1 — potrzebne dla jakości i dużej skali

1. `totalCount` dla całego zapytania oraz grup;
2. agregaty grup: count, sum estimated/logged, checklist/subtask progress;
3. batch inline update dla wielu pól/wierszy z per-item version albo atomową
   semantyką opisaną kontraktem;
4. selection token dla akcji `wszystkie wyniki`, aby nie wysyłać tysięcy ID;
5. zapis preferencji szerokości, kolejności, pinning i density — albo w saved
   view, albo w osobnej preferencji użytkownika;
6. filtry custom fields wykonywane w PostgreSQL;
7. indeksy wynikające z rzeczywistych filtrów/sortów, potwierdzone `EXPLAIN`;
8. pełna pagination Timeline w kliencie i ewentualne grupowanie Workload;
9. batch create dla szybkiego wklejania wielu wierszy — opcjonalnie po P0.

### Proponowany kształt kontraktu listy

To szkic semantyczny, nie gotowa nazwa endpointu:

```text
TaskGridQuery
├── filter
├── sort[]
├── groupBy?
├── fieldSelection[]
├── parentMode: roots | childrenOf | flat
├── limit
└── cursor

TaskGridResponse
├── totalCount
├── fieldDefinitions[]
├── groups[]
│   ├── key / displayName / color
│   ├── totalCount
│   ├── aggregateValues
│   ├── items[]
│   └── nextCursor
└── ungroupedNextCursor?
```

Kontrakt sukcesu pozostaje typowany, OpenAPI po polsku, błędy zachowują
`code/message/fields/traceId`, a wszystkie zapisy używają expected version.

## 10. Plan kodu Flutter

Docelowa odpowiedzialność plików:

```text
presentation/tasks/
├── shell/
│   ├── tasks_view_shell.dart
│   └── cubit/tasks_view_controller_cubit.dart
├── header/
│   ├── tasks_command_header.dart
│   ├── tasks_context_row.dart
│   ├── tasks_controls_row.dart
│   ├── tasks_view_tabs.dart
│   ├── tasks_primary_create_button.dart
│   └── tasks_contextual_controls.dart
├── list/
│   ├── task_grid_view.dart
│   ├── cubit/task_grid_cubit.dart
│   ├── editing/cubit/task_grid_editing_cubit.dart
│   ├── selection/cubit/task_grid_selection_cubit.dart
│   ├── columns/task_column_definition.dart
│   ├── columns/task_column_registry.dart
│   ├── cells/...
│   ├── groups/task_grid_group.dart
│   ├── tree/task_grid_tree_branch.dart
│   ├── dnd/task_grid_drag_controller.dart
│   └── context_menu/task_grid_context_menu.dart
├── board/...
├── timeline/...
└── workload/...
```

Nie wykonujemy jednego wielkiego refaktoru `tasks_board_page.dart`. Najpierw
wydzielamy header i kontroler widoku z kompatybilnym API, potem wymieniamy listę.
Publiczne elementy eksportujemy istniejącym barrel. Każdy Cubit ma jeden scope i
nie zna `BuildContext`.

### Stan listy

`TaskGridCubit` powinien jawnie modelować:

- initial loading;
- ready z grupami/branchami i cursorami;
- loading more per grupa/branch;
- refreshing bez zerowania scrolla;
- partial error per grupa;
- stale/realtime reconciliation;
- brak wyników;
- brak kolejnej strony.

Edycja, selection i DnD nie powinny przebudowywać całego stanu ładowania.

## 11. Etapy wdrożenia

### Etap 0 — kontrakt i prototyp layoutu

- zaakceptować ten dokument i docelową gęstość;
- przygotować statyczny widget test/mockup headera oraz gridu na danych fake;
- ustalić default columns i default groupBy;
- zatwierdzić macierz uprawnień inline edit;
- zamrozić semantyczny kontrakt Task Grid w OpenAPI.

Kryterium: na szerokościach 900, 1280, 1440 i 1920 px header nie overflowuje,
a grid dochodzi do prawej krawędzi i pokazuje poziomy scroll dla wielu pól.

### Etap 1 — wspólny header

- wydzielić `TasksCommandHeader`;
- dodać kontekst workspace/projekt;
- przenieść taby, saved views, search, filter, sort, group i columns;
- podłączyć istniejące settings/modal actions;
- dodać split button tworzenia;
- zakres Timeline/Workload przenieść do contextual controls;
- zachować URL, preferencję widoku i realtime state;
- usunąć duplikaty tytułów/filtrów z widoków.

Kryterium: wszystkie cztery widoki używają identycznego headera i nie zmieniają
jego wysokości podczas przełączania ani zaznaczania.

### Etap 2 — pełnoszeroki read-only grid

- usunąć max width i duże paddingi;
- wdrożyć registry kolumn i render z saved view;
- sticky header/pierwsze kolumny, resize, reorder, hide/show;
- dodać gęstość i zapis preferencji;
- użyć bogatego kontraktu listy;
- wdrożyć serwerowe grupy z osobnymi cursorami;
- zachować scroll per saved view.

Kryterium: 1000+ rekordów nie powoduje renderowania całego zbioru, grupy mają
prawdziwe liczniki, a wszystkie pola i custom fields są dostępne w pickerze.

### Etap 3 — drzewo i szybkie tworzenie

- lazy subtask branches;
- expand/collapse i licznik dzieci;
- inline `Dodaj zadanie` w grupie;
- inline `Dodaj podzadanie` pod rodzicem;
- draft rows, walidacja, Escape/Enter/Tab;
- create from template w primary action.

Kryterium: zadanie i podzadanie można utworzyć bez modala, a błędny zapis nie
usuwa wprowadzonego tekstu.

### Etap 4 — inline editing

- edytory typów systemowych;
- edytory wszystkich typów custom fields;
- optimistic concurrency, rollback i 409 UX;
- deduplikacja realtime;
- batch edit dla selection;
- pełna nawigacja klawiaturą.

Kryterium: każde edytowalne pole można zmienić bez detailu, a konflikt nigdy nie
nadpisuje po cichu zmiany innego użytkownika.

### Etap 5 — DnD i menu kontekstowe

- neighbor-based reorder;
- move między grupami;
- zmiana parent z regułą jednego poziomu;
- autoscroll i keyboard alternative;
- `AppContextMenu` dla single/multi selection;
- podmenu status/priority/assignee/date/custom fields;
- uprawnienia i disabled reasons.

Kryterium: każda operacja DnD ma równoważną akcję klawiaturową/menu i poprawny
rollback po błędzie.

### Etap 6 — ujednolicenie Timeline i Workload

- usunąć ich ograniczenia szerokości i lokalne tytuły;
- podłączyć wspólny search/filter/saved view tam, gdzie kontrakt pozwala;
- doładować wszystkie strony Timeline;
- przygotować pełnoszeroki grid Workload;
- zachować fallback compact.

## 12. Testy i kryteria jakości

### Flutter unit/widget

- reducer filtrów, sortów, grup, kolumn i zapisanych widoków;
- osobne cursory grup i branchy drzewa;
- brak duplikatów po realtime/reconnect;
- optimistic edit success/rollback/409;
- DnD: reorder, group move, parent move i niedozwolony drugi poziom;
- menu kontekstowe prawym przyciskiem, klawiaturą i przyciskiem;
- resize/reorder/pinning kolumn;
- focus order, Semantics i skróty;
- zachowanie scrolla po detail/back i zmianie viewportu;
- golden/widget layout dla 900/1280/1440/1920 oraz dark/light;
- brak overflow po lokalizacji PL/EN.

### Backend

- OpenAPI wszystkich nowych parametrów i kontraktów;
- izolacja workspace/project i role Owner/Admin/Member/Observer/SuperAdmin;
- filtr/sort/group dla każdego wspieranego typu, również custom fields;
- cursor stability przy równoległych insertach i edycjach;
- group totals i agregaty;
- neighbor reorder na pierwszej, środkowej i niezaładowanej pozycji;
- parent move i ochrona jednego poziomu/cykli;
- concurrency 409 dla inline i DnD;
- projekcja nie wykonuje N+1 dla labels/custom fields/users;
- pomiar PostgreSQL na reprezentatywnym zbiorze.

### Platformy

- Flutter Web/Wasm: scroll, pointer, right click, browser zoom, routing/back;
- Windows/macOS/Linux: secondary click, menu key, drag, shortcuts, resize;
- co najmniej jeden test E2E REST + SignalR dla edit/reorder/reconnect.

### Budżety wydajnościowe do potwierdzenia pomiarem

- brak fetchu detail per row;
- nie więcej niż jedna strona per rozwinięta grupa przy wejściu;
- płynny scroll przy widocznych 40–80 wierszach i 20+ kolumnach;
- zmiana jednej komórki nie przebudowuje całego viewportu;
- search debounced i odporny na wyścigi;
- pamięć nie rośnie liniowo bez limitu podczas wielogodzinnego scrollowania.

## 13. Definition of Done

Przebudowa jest zakończona, gdy:

- header jest wspólny, kompaktowy i zawiera wszystkie funkcje projektu/widoku;
- lista używa całej dostępnej szerokości i ma mały dolny padding;
- użytkownik może wybrać każde pole systemowe i custom field jako kolumnę;
- grupowanie i liczniki są poprawne dla całego wyniku, nie tylko jednej strony;
- zadania i podzadania tworzy się inline;
- pola edytuje się inline z bezpiecznym concurrency;
- działa DnD kolejności, grupy i parent/subtask;
- menu kontekstowe jest kompletne i dostępne klawiaturą;
- infinite scroll, realtime, filtry i powrót z detailu nie gubią stanu;
- widoki Kanban/List/Timeline/Workload zachowują wspólną command bar;
- Web/Wasm i desktop przechodzą testy funkcjonalne i dostępności;
- OpenAPI, testy kontraktowe i dokumentacja są zaktualizowane;
- nie pozostaje równoległy stary header ani stara implementacja listy.

## 14. Rekomendowana kolejność najbliższych prac

1. Najpierw wdrożyć kompaktowy wspólny header na istniejących danych.
2. Równolegle zaprojektować i zatwierdzić backendowy kontrakt Task Grid.
3. Następnie wymienić obecną listę na pełnoszeroki read-only grid.
4. Dopiero po stabilnym gridzie dodać drzewo, inline create i inline editing.
5. Na końcu uruchomić DnD oraz kompletne menu kontekstowe.

Ta kolejność daje szybki efekt wizualny bez budowania edycji na kontrakcie,
który nie potrafi jeszcze dostarczyć wszystkich pól ani prawdziwych grup.
