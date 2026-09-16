# Wytyczne AI — UI i architektura Ready Next

Status dokumentu: aktywne wytyczne dla implementacji menu, routingu i modułu
Workspaces. Dokument jest żywą checklistą: po zakończeniu punktu zaznaczamy
`[x]`, a decyzje zmieniamy tylko po uzgodnieniu i opisaniu powodu.

## Cel produktu

Ready Next ma być zwartą, szybką aplikacją Web i desktopową, łączącą gęstość
informacji ClickUp/Asana/Jira z czytelną hierarchią kontekstu. Menu ma zajmować
mało miejsca, ale umożliwiać szybkie przejście do dowolnego zasobu z URL,
powiadomienia albo wyszukiwarki.

Docelowa hierarchia nawigacji:

```text
Globalny shell
├── Prywatne: moje zadania, moje pliki
├── Workspace’y
│   └── Workspace → projekty → zadania/Kanban/whiteboard/wiki/pliki
└── Górny pasek: wyszukiwarka, powiadomienia, Chat (globalny, później)
```

Chat i powiadomienia nie są elementami menu Workspace. Są globalnymi panelami
overlay/drawer dla całego Ready Next: otwierają się nad treścią albo wysuwają z
prawej strony z animacją, bez opuszczania bieżącego workspace’u i widoku.

### Kryterium jakości wizualnej

Nie uznajemy menu za gotowe tylko dlatego, że routing i API działają. Docelowy
shell ma być produkcyjnie podobny klasą do nowoczesnych narzędzi typu
Monday/ClickUp/Asana — nie jako kopia 1:1, lecz przez porównywalną gęstość,
hierarchię i jakość interakcji. Obowiązuje następujący test akceptacyjny:

- [x] globalny shell ma wyraźny, lekki topbar oraz kompaktowy rail modułów;
- [x] katalog Workspace ma osobny kontekst, przełącznik i sekcje Prywatne,
  Ulubione oraz Workspace’y bez pustych, technicznych przestrzeni;
- [x] aktywny element ma czytelny stan selected, a hover/focus są widoczne
  bez agresywnych obramowań;
- [x] hierarchia Workspace → Projekt → zasób jest czytelna przy jednym
  spojrzeniu i nie wymaga otwierania przypadkowych ekranów;
- [x] szerokości, wysokości wierszy, odstępy i typografia są zoptymalizowane
  pod Web/Desktop oraz nie powodują overflow przy 1280 px;
- [x] stan zwinięty zachowuje sens jako pasek ikon, a stan rozwinięty pokazuje
  wystarczająco dużo danych bez wrażenia „formularza administracyjnego”;
- [ ] każda większa zmiana ma zrzut wizualny Web/Desktop i ocenę ręczną,
  zanim zostanie oznaczona jako ukończona.

## Zasady architektury

- [x] Kod Workspaces domyślnie trafia do `lib/workspaces`; `lib/shared` tylko
  dla komponentu używanego przez co najmniej dwa niezależne moduły.
- [x] Networking pozostaje w `data`; UI nigdy nie wywołuje Dio, REST,
  SignalR ani WebSocketu bezpośrednio.
- [x] Przepływ danych: `API client → repository/use case → domain → Cubit → UI`.
- [x] Cubity mają jedną odpowiedzialność, mały scope i żyją przy ekranie,
  feature’ze albo subfeature’ze; nie tworzymy globalnych „god Cubitów”.
- [x] Stany Cubitów są niemutowalnymi `sealed class`; nie używamy Freezed do
  stanów. Freezed jest dozwolony dla DTO/modeli, gdy generator ma uzasadnienie.
- [x] `RxDart` stosujemy do debounce, distinct, switchMap, synchronizacji
  strumieni i realtime; każda subskrypcja ma właściciela i jest zwalniana.
- [x] Tuż przed każdym opóźnionym `emit` sprawdzamy `isClosed`; przy zamykaniu
  anulujemy streamy, timery i requesty.
- [x] Widget renderuje stan i wysyła intencję; logika biznesowa nie trafia do
  widgetu. Mały, wyłącznie lokalny stan UI może użyć `ValueNotifier` albo
  `setState`.
- [x] Widgety utrzymujemy zwykle poniżej 300 linii; duże widoki dzielimy na
  nazwane podkatalogi widgetów/bloców blisko właściciela.
- [x] Wszystkie publiczne elementy feature’u eksportujemy przez `*_export.dart`.
- [x] Komentarze i dokumentacja kodu są po polsku i opisują odpowiedzialność,
  kontrakt oraz powód decyzji, a nie oczywiste instrukcje kodu.

## Shell, menu i współdzielenie komponentów

- [x] Główne menu i menu Workspace są osobnymi poziomami, ale używają jednego
  kontraktu zachowania panelu.
- [x] Panel Workspace można ręcznie animować z pełnej szerokości do pionowego
  paska ikon. Stan zwinięcia zapisujemy lokalnie per użytkownik/urządzenie.
- [x] W trybie zwiniętym pokazujemy ikonę/kolor, aktywny stan i tooltipy;
  wszystkie akcje pozostają dostępne z klawiatury.
- [x] Tylko aktywny Workspace rozwija dzieci; pozostałe wiersze są kompaktowe.
- [x] Drag-and-drop kolejności jest dostępny w trybie rozwiniętym. W trybie
  zwiniętym nie uruchamiamy nieczytelnego przenoszenia ikon.
- [x] Ustalono, że nie używamy `ExpansionTile`; własny komponent nawigacyjny
  oprzemy na `Expansible` i `ExpansibleController`, z własnym wyglądem,
  hoverem, focusem,
  animacją chevronu i zachowaniem webowym.
- [x] Wydzielono kompatybilny shared `AppCollapsibleNavigationPanel` oraz
  `AppExpansibleNavigationItem` do katalogu shared navigation.
- [x] Ikony produktu są mapowane przez `AppIcons` i korzystają ze spójnego
  zestawu Lucide dla Web/Desktop; feature’y nie importują biblioteki ikon
  bezpośrednio.
- [x] Helpery stylu i motywu Workspaces mają osobny katalog
  `lib/workspaces/shared/helpers`; gradienty, glass surfaces i cienie nie są
  kopiowane pomiędzy widgetami.
- [x] Shared widget nie złamał istniejących konsumentów: rozszerzamy API
  kompatybilnie albo tworzymy nowy komponent.
- [ ] Zweryfikować animacje, szerokości, focus ring, tooltipy i drag-and-drop
  przy Web, Windows, macOS i Linux.

## Zakres menu i stan pusty

- [x] Warstwa „Prywatne” zawiera tylko dane użytkownika, np. moje zadania i
  moje pliki, niezależnie od aktywnego Workspace. Gdy backend nie ma jeszcze
  globalnego endpointu, ekran pokazuje jawny stan kontraktu niedostępnego.
- [x] Workspace zawiera: przegląd, projekty, pliki Workspace, wiki,
  aktywność oraz ustawienia/członków zgodnie z rolą.
- [x] Projekt zawiera elementy zależne od projektu: zadania, Kanban,
  whiteboardy, wiki i pliki projektu.
- [x] Chat został wyłączony z nowego menu Workspace; zostaje przyszłą funkcją globalnego
  górnego paska.
- [x] Powiadomienia są globalne dla Ready Next; globalny pasek ma już jawne
  wejścia do powiadomień i czatu. Skrzynka powiadomień ma grupować elementy,
  pokazywać liczniki i wykonywać akcje backendu bez opuszczania bieżącego
  kontekstu.
- [x] Globalny Chat jest panelem overlay/drawer, a nie pełną trasą strony;
  obsługuje listę rozmów, grupowanie, unread, historię, wysyłanie i deep link
  do konkretnej rozmowy/wiadomości z wyróżnieniem celu.
- [x] Overlaye używają natywnych animacji Fluttera, przezroczystości i
  gradientów wyliczanych z
  `ColorScheme`; muszą działać w jasnym i ciemnym Material Theme.
- [x] Panel nie traci stanu bieżącej trasy, wspiera Escape, kliknięcie poza
  panelem, focus trap i dostępność klawiatury przez wspólny
  `AppModalAccessibilityBoundary`.
- [x] Gdy użytkownik nie ma Workspace, pokazujemy osobny empty state z dużym
  CTA „Utwórz swój pierwszy workspace”. Nie pokazujemy tego CTA po błędzie API.
- [x] Po utworzeniu Workspace odświeżyć listę, backend ustawia Ownera i przejść
  do jego strony bez utraty kontekstu na Web.

## Routing i deep linki

- [x] URL jest źródłem aktywnego kontekstu, a menu jest jego projekcją; wybór
  w pamięci nie może być wymagany do odtworzenia ekranu.
- [x] Trasy zachowują hierarchię: `/workspaces/:workspaceId`,
  `/workspaces/:workspaceId/projects/:projectId` oraz trasy zasobów, np.
  `tasks/:taskId`, `whiteboards/:whiteboardId`, `wiki/:pageId`.
- [x] Powtarzalne ekrany routingu używają unikalnych tras parametrycznych
  AutoRoute; nie rejestrujemy tej samej nazwy strony dla wielu ścieżek.
- [x] Link z powiadomienia może wskazać Workspace, projekt i konkretny zasób.
- [x] Po logowaniu zachowujemy pełny bezpieczny deep link, query i fragment.
- [ ] Działają odświeżenie strony, Back, nowa karta i wejście bezpośrednio w URL.
- [x] Przyjmujemy tylko wewnętrzne, dozwolone trasy; zewnętrzne URL-e z danych
  backendu nie są wykonywane automatycznie.
- [x] `401`, `403`, brak członkostwa, archiwizacja i błąd sieci mają jawny stan
  UI z komunikatem backendu; shell workspace nie renderuje dziecka routingu,
  dopóki lista członkostwa nie potwierdzi dostępu.
- [x] Parser deep linków ma testy root/private/resource, UUID, query/fragment
  oraz odrzucenie zewnętrznych i nieznanych tras.
- [ ] Dodać testy guardów sesji, odświeżenia Web i wejścia do ukrytego
  Workspace z poprawnym dostępem.
- [ ] Zweryfikować konfigurację SPA fallback serwera dla wszystkich tras Web.

## Pełne wykorzystanie kontraktu backendu

- [x] Lista Workspace korzysta z aktywnego członkostwa oraz bypassu SuperAdmina
  zgodnie z backendem; nie wymyślamy dodatkowego prawa modułowego.
- [x] Preferencje listy są osobiste i nie zmieniają członkostwa ani uprawnień.
- [x] Obsłużyć przypinanie, ukrywanie, przywracanie i atomową kolejność
  Workspace’ów przez istniejące endpointy preferencji/order; lista z
  `includeHidden=true` zwraca `isHidden`, a UI rozdziela oba katalogi.
- [x] Analogiczny zakres preferencji stosujemy do projektów, jeśli kontrakt
  projektu go udostępnia.
- [x] Operacje kolejności mają optymistyczny układ i rollback przy błędzie, z
  komunikatem backendu po błędzie.
- [x] Nie obiecujemy listy whiteboardów na poziomie Workspace, dopóki backend
  nie udostępnia agregatu; whiteboard, Wiki, foldery Storage i automatyzacje są
  ładowane w kontekście projektu z właściwych endpointów.
- [ ] Przed każdym ekranem potwierdzić endpoint, role, paginację, sortowanie,
  filtry, błędy i realtime w Swaggerze/implementacji C#.

## Jakość i weryfikacja

### Obowiązujące zasady dla modułu Files

Pełna instrukcja wykonawcza modułu Files znajduje się w
[`docs/workspaces-files-implementation-plan.md`](workspaces-files-implementation-plan.md),
sekcja „Obowiązkowa instrukcja implementacyjna dla agenta”. Jest wiążąca dla
każdej implementacji Files. W szczególności zabrania jednego globalnego
`FilesCubit`/`StorageCubit`, funkcji top-level i ręcznie pisanych plików Dart
powyżej 400 linii. Wymaga drzewiastej struktury widgetów, małych Cubitów per
odpowiedzialność, użycia istniejących shared widgetów oraz wizualnej spójności
z Tasks i Kanban przez `context.text`, `context.colors`, `Sizes`, `Gaps` i
centralne mapowanie ikon.

- [ ] Każdy Cubit ma testy stanów: loading, data, empty, error, forbidden,
  zamknięcie podczas requestu i rollback optymistycznej zmiany.
- [ ] Routing ma testy Web oraz testy nawigacji z powiadomienia do zasobu.
- [x] Shared panel ma testy animacji/logiki collapsed, klawiatury, tooltipów,
  aktywnej trasy i zachowania przy zmianie szerokości okna.
- [x] Wykonać `flutter analyze`, testy jednostkowe/widget/integracyjne oraz
  build Web i targetów desktopowych.
- [ ] Po każdej większej zmianie uruchomić wizualną kontrolę Web i desktopu:
  gęstość danych, overflow, hover/focus, drag-and-drop i stan pusty.
- [ ] Nie uznawać zadania za ukończone na podstawie samego builda; checklistę
  zamykamy dopiero po sprawdzeniu zachowania runtime i deep linków.

## Audyt realtime — stan kontraktu 2026-08-24

- [x] Backend udostępnia chroniony SignalR Notifications Hub pod
  `/api/v1/realtime/notifications`; połączenie dołącza automatycznie do
  prywatnej grupy `user:{coreUserId:N}` i emituje `notification.created` oraz
  `notification.group.updated`.
- [x] Backend udostępnia chroniony Chat Hub pod `/api/v1/realtime/chat`.
  Klient musi wywołać `SubscribeConversation(conversationId)` po połączeniu,
  a po reconnect odtworzyć zdarzenia przez `GetConversationEvents` z kursorem;
  dostęp do rozmowy jest sprawdzany po stronie huba.
- [x] Backend udostępnia także huby Tasks, Whiteboard i Wiki, ale ich kontrakty
  są zakresowe (projekt/tablica/strona), więc nie są częścią globalnego topbara.
- [x] Flutter ma dedykowany adapter `WorkspaceSignalRClient` oparty o
  `signalr_netcore` (Web/Desktop), z tokenem pobieranym przy każdym handshake,
  automatycznym reconnect/backoff oraz strumieniem stanu transportu. Adapter
  nie jest używany bezpośrednio w UI.
- [x] Globalne Notifications mają właściciela cyklu życia w sesji, deduplikację
  `eventId`/`RealtimeSequence`, REST replay grup po reconnect oraz bezpieczne
  zamknięcie przed logoutem. `NotificationsCubit` odświeża stan bezpośrednio
  po zdarzeniu realtime, ale nadal pokazuje jawne błędy REST.
- [x] Zakresowe huby Tasks/Whiteboard/Wiki mają wspólny, lokalnie tworzony
  adapter `WorkspaceScopedRealtimeService` z osobnymi metodami subskrypcji,
  replayem kursora, deduplikacją i jawnym zdarzeniem `resync-required`.
  [ ] Pozostaje podłączenie go do Cubitów konkretnych ekranów po ustaleniu ich
  modeli domenowych; nie udajemy, że sam adapter zastępuje repozytorium UI.
- [x] Chat ma lokalny adapter rozmowy z subskrypcją, typing/presence, replay
  kursora, deduplikacją i lokalnym lifecycle Cubita. Adapter obsługuje
  backendowy envelope `items`/`payloadJson`, a nie tylko uproszczony testowy
  kształt danych.

## Rejestr zmian

- [x] 2026-08-24 — zapisano ustalenia dotyczące hierarchii Prywatne →
  Workspace → Projekt, globalnego topbara, routingu webowego, animowanego
  panelu oraz użycia `Expansible` zamiast `ExpansionTile`.
- [x] 2026-08-24 — zapisano wymaganie dokumentacji po polsku, małych scope’ów
  Cubitów, limitu widgetów oraz obowiązkowej weryfikacji wizualnej/testowej.
- [x] 2026-08-24 — skorygowano statusy: `[x]` oznacza decyzję lub potwierdzony
  kontrakt, a `[ ]` oznacza funkcję, która wymaga implementacji i weryfikacji
  runtime/testami; nie oznaczamy planowanego routingu jako działającego.
- [x] 2026-08-24 — rozszerzono kontrakt listy o `isHidden`, dodano przywracanie
  workspace’u oraz jawne stany i testy warstwy prywatnej bez udawania danych,
  których backend jeszcze nie udostępnia globalnie.
- [x] 2026-08-24 — utworzenie workspace’u odświeża katalog i nawiguje do
  utworzonego kontekstu po identyfikatorze zwróconym przez backend.
- [x] 2026-08-24 — menu używa wspólnego `AppExpansibleNavigationItem` opartego
  na `Expansible`; automatycznie rozwija wyłącznie aktywny workspace, a
  pozostałe pozostawia w kompaktowym stanie.
- [x] 2026-08-24 — dodano adapter `AppIcons` i Lucide Icons zamiast mieszanego
  zestawu domyślnych ikon Material; decyzja jest odwracalna bez zmian w UI.
- [x] 2026-08-24 — ustalono, że globalny Chat i Powiadomienia są panelami
  overlay/drawer z pełną funkcjonalnością backendu, grupowaniem, akcjami,
  animacjami oraz Material Theme-aware przezroczystościami i gradientami.
- [x] 2026-08-24 — wejście z globalnego paska otwiera powiadomienia jako
  animowany drawer bez zmiany bieżącej trasy; lista jest zasilana przez
  `NotificationsRepository`, a stany `401`, `403`, pusty i błąd są jawne.
- [x] 2026-08-24 — rail modułów ma neutralny Material Theme-aware wygląd,
  szerokość 56 px w stanie kompaktowym i 220 px po ręcznym rozwinięciu;
  docelowa kontrola wizualna Web/Desktop nadal pozostaje obowiązkowa.
- [x] 2026-08-24 — rozwinięcie workspace’u uruchamia lazy-loading projektów
  przez osobny `ProjectsRepository`/`WorkspaceProjectsCubit`; błędy są
  wyświetlane przy właściwej gałęzi, a nie zastępowane pustym fallbackiem.
- [x] 2026-08-24 — rozwinięty globalny rail nakłada się nad treścią zamiast
  zabierać stałe 220 px szerokości; zwinięty pozostaje paskiem ikon.
- [x] 2026-08-24 — deep link rozmowy ma rzeczywistą historię i wysyłanie
  wiadomości przez `ChatRepository`; deep link wiadomości wyróżnia i
  przewija wskazany element.
- [x] 2026-08-24 — menu projektu ma lazy-loading whiteboardów, drzewa Wiki,
  folderów Storage i aktywnych automatyzacji przez osobny repository/Cubit;
  ekrany katalogów również korzystają z tego kontraktu.
- [x] 2026-08-24 — globalny rail podzielono na wrapper, listę modułów oraz
  akcje/konto; każdy widget pozostaje poniżej około 300 linii.
- [x] 2026-08-24 — rail ma bezpieczny fallback bez `Overlay`: zwykły `ListView`
  zastępuje `ReorderableListView` tylko w izolowanych kontekstach testowych;
  produkcyjny shell zachowuje reorder i tooltipy.
- [x] 2026-08-24 — kolejność workspace synchronizuje pełny zbiór widocznych
  UUID bezpośrednio przed zapisem, zgodnie z walidacją backendu.
- [x] 2026-08-24 — stan rozwinięcia globalnego raila jest zapisywany przez
  `LocalSettingsCubit` per konto; ponowne zbudowanie shella nie resetuje
  ręcznego wyboru użytkownika.
- [x] 2026-08-24 — rozdzielono katalog workspace’ów i gałąź zasobów projektu
  na mniejsze widgety; wszystkie pozostają poniżej limitu 300 linii, a lista
  raila używa `ClampingScrollPhysics`, aby stopka nie wypadała poza viewport.
- [x] 2026-08-24 — globalne powiadomienia rozdzielono na ekran/drawer oraz
  osobne widgety listy; trasy Chatu mają własny plik, a adapter eksportu
  zachowuje kompatybilność istniejących importów.
- [x] 2026-08-24 — Chat i Powiadomienia używają wspólnej granicy dostępności
  draweru: request focus, FocusTraversalGroup, Escape i zamknięcie przez
  barierę modalną; dodano testy klawiatury.
- [x] 2026-08-24 — dodano izolowany adapter `WorkspaceSignalRClient` dla
  Web/Desktop z JWT `accessTokenFactory`, reconnect/backoff i jawnym stanem
  połączenia; adapter pozostaje zamknięty w warstwie data i nie przecieka do UI.
- [x] 2026-08-24 — Notifications otrzymały właściciela lifecycle sesji,
  deduplikację i replay REST po reconnect; `NotificationsCubit` reaguje na
  zdarzenia przez ciche odświeżenie bez logiki SignalR w widgetach.
- [x] 2026-08-24 — Chat otrzymał lokalny adapter per rozmowa z subskrypcją,
  replayem `items`/`payloadJson`, typing/presence, deduplikacją i lifecycle
  `ChatConversationCubit`; błędy realtime są widoczne przy historii rozmowy.
- [x] 2026-08-24 — wspólny `AppModalSheet` rozdzielono od panelu wizualnego,
  zachowując publiczne API i limit rozmiaru głównego pliku.
- [x] 2026-08-24 — lokalny skrypt backendu jawnie eksportuje
  `ConnectionStrings__Workspaces`; usunięto przyczynę startu Workspaces API
  z błędem „Brak konfiguracji ConnectionStrings:Workspaces”.
- [x] 2026-08-24 — AutoRoute zachowuje rzeczywisty adres Web przy starcie i
  odświeżeniu; `launchContext.initialRoute` jest używany tylko dla root.
- [x] 2026-08-24 — konflikt nazwy pola Wiki `toJson` z metodą Freezed rozwiązano
  przez `toJsonValue` + `@JsonKey(name: 'toJson')`; kontrakt JSON pozostaje
  kompatybilny.
- [x] 2026-08-24 — shell bezpośredniego deep linku workspace’u blokuje treść
  przy braku członkostwa oraz jawnie pokazuje stany 401/403/błąd zamiast
  renderować pozorny ekran sukcesu.
- [x] 2026-08-24 — parser bezpiecznych deep linków jawnie odrzuca pusty root
  (`/`) zamiast odwoływać się do nieistniejącego segmentu; dodano regresję dla
  tras prywatnych `/me/tasks` i `/me/files`.
- [x] 2026-08-24 — dodano polską instrukcję wymaganej konfiguracji SPA
  fallbacku dla Nginx/CDN; odhaczenie wdrożeniowej kontroli nadal wymaga testu
  na konkretnym serwerze publikującym `build/web`.
- [x] 2026-08-24 — backendowy audyt potwierdził, że Workspaces nie wymagają
  osobnego permission: zwykły użytkownik widzi aktywne członkostwa, a
  `bswfms.custom_modules.RNext-admin` daje SuperAdminowi bypass; nie dodajemy
  fikcyjnego `RNext-workspaces`.
- [x] 2026-08-24 — testy Cubitów projektu, czatu, powiadomień i menu oraz
  buildy Web/macOS przechodzą; pełny test suite nadal zawiera niezależne testy
  integracyjne Inventory wymagające działającego backendu Inventory.
- [x] 2026-08-24 — usunięto blokadę rozwijania nieaktywnego workspace’u/projektu:
  menu używa `initiallyExpanded` dla automatycznego wejścia z trasy, a użytkownik
  może ręcznie rozwijać dowolną gałąź; tryb kontrolowany pozostaje dostępny dla
  właścicieli, którzy muszą wymusić stan.
- [x] 2026-08-24 — shell workspace’u pokazuje nazwę i opis workspace’u po
  potwierdzeniu członkostwa zamiast technicznego UUID z URL; przy ładowaniu i
  błędzie pozostaje neutralny, czytelny kontekst bez ujawniania identyfikatora.
- [x] 2026-08-24 — wspólny element hierarchii menu dostał spójny kontrast
  selected, hover i focus: aktywna ikona korzysta z koloru primary, tekst ma
  wyraźną wagę, a focus z klawiatury nie jest ukrywany przez styl tła.
- [x] 2026-08-24 — katalog boczny ma osobną sekcję `Ulubione` opartą o
  osobiste `isPinned`; sekcja używa tego samego bezpiecznego routingu i nie
  miesza preferencji użytkownika z członkostwem workspace’u.
- [x] 2026-08-24 — małe szerokości używają modalnego overlay sidebara zamiast
  stałego panelu; treść zachowuje pełną szerokość, a menu ma jawne otwieranie,
  zamykanie i dismiss poza panelem.
- [x] 2026-08-24 — collapsed workspace switcher używa backendowej ikony/koloru
  z bezpiecznym fallbackiem Material, bez podwójnych tooltipów; nagłówek shellu
  dostał szybki przełącznik pomiędzy dostępnymi workspace’ami.
- [x] 2026-08-24 — pozycje hierarchii mają focus ring oraz skróty ArrowLeft/
  ArrowRight do zwijania i rozwijania gałęzi; globalny rail desktopowy ma
  szerokość 220 px, aby ograniczyć obcinanie nazw modułów.
- [x] 2026-08-24 — katalog projektu ładuje zadania przez lokalny
  `ProjectResourcesCubit` i `TasksApi`, z tym samym lazy-loadingiem co Wiki,
  Whiteboardy, Pliki i Automatyzacje; dodano test stanu `Ready`.
- [x] 2026-08-24 — wejście bezpośrednio w `/projects/:projectId/:resourceKind/:id`
  waliduje zasób przez lokalny `WorkspaceResourceAccessCubit`; poprawny zasób
  pokazuje tytuł i metadane, brakujący ma jawny stan not-found, a błędy backendu
  zachowują kod i akcję ponowienia. Widok szczegółu jest podzielony poniżej
  limitu 300 linii.
- [x] 2026-08-24 — lokalny build Web został obejrzany w przeglądarce na
  viewportach desktop i 390×844; ekran logowania zachowuje kontrast, proporcje
  i brak overflow. Pełny audyt menu nadal wymaga zalogowanej sesji użytkownika.
- [x] 2026-08-24 — test widgetu potwierdza obsługę `Tab` + `ArrowRight`/
  `ArrowLeft` dla rozwijania i zwijania hierarchii; skróty nie są tylko
  deklaracją w kodzie, lecz mają sprawdzony przepływ klawiaturowy.
- [x] 2026-08-24 — poprawne trasy sekcji workspace’u nie renderują już surowych
  identyfikatorów ani technicznego tekstu; używają spójnego landing view z
  kartami Overview i linkami do sekcji. Nieznany segment nadal ma jawny ekran
  not-found.
- [x] 2026-08-24 — deep link `/storage/files/:fileId` otrzymał dedykowaną trasę
  `StorageFileRoute`, więc link z powiadomienia nie trafia już do
  `UnknownModulePage`; deklaracja parsera i wygenerowany AutoRoute są spójne.
- [x] 2026-08-24 — bezpośredni URL projektu weryfikuje `projectId` przez lokalny
  `WorkspaceProjectAccessCubit` po potwierdzeniu członkostwa workspace’u;
  niedostępny projekt i błąd backendu mają osobny, jawny stan, a Cubit żyje
  dokładnie tak długo jak strona routingu projektu.
- [x] 2026-08-24 — parametryczne trasy sekcji workspace’u/projektu nie pokazują
  już technicznego placeholdera dla nieznanego segmentu; widoki walidują
  allowlistę i renderują jawny ekran „Nie znaleziono tej sekcji”.
- [x] 2026-08-24 — strony routingu zasobów rozdzielono na kontekst nawigacji
  (`workspace_resource_pages.dart`) i szczegóły zasobów
  (`workspace_resource_detail_pages.dart`); oba pliki pozostają poniżej
  limitu 300 linii, a publiczny eksport zachowuje kompatybilność generatora
  AutoRoute.
- [x] 2026-08-24 — dodano deklaratywny smoke test hierarchii menu, który
  sprawdza reprezentatywny układ private/favorites/workspace/project bez
  overflow; zrzut obrazu pozostaje osobnym krokiem QA wymagającym zalogowanej
  sesji web/desktop.
## Ostatnia walidacja implementacyjna

- [x] 2026-08-25 — pusty katalog workspace’u w sidebarze pokazuje ten sam CTA
  „Utwórz workspace”, co główny onboarding; compact overlay ma wspólny focus,
  traversal i Escape, a jego przycisk nie zasłania topbara.
- [x] 2026-08-25 — deep-link `/storage/files/:fileId` ładuje szczegóły przez
  `StorageRepository` i sealed `StorageFileDetailsCubit`, pokazując jawnie
  metadane, wersje, uprawnienia oraz kod błędu backendu.
- [x] 2026-08-25 — runtime Web zachowuje chroniony deep-link workspace’u przy
  bezpośrednim wejściu bez sesji: `WebHostBridge` normalizuje dynamiczne trasy
  przez `AppDeepLink`, a listener auth nie zastępuje chwilowego adresu
  `/workspaces/{id}/...` domyślnym `/dashboard`. Świeży serwer Web potwierdził
  przekierowanie do `/login?redirect=/workspaces/{id}/projects`; testy parsera
  i polityki auth: 15/15.
- [x] 2026-08-25 — kontekstowy katalog workspace’u pokazuje także członków,
  cele OKR, zaproszenia i ustawienia; dostęp jest rozstrzygany przez backend,
  więc frontend nie zakłada fikcyjnych uprawnień modułowych.
- [x] 2026-08-25 — pełny zakres testów aplikacji (`core`, `shared`, `workspaces`,
  `app`, `settings`) zakończył się wynikiem 124/124; `flutter analyze` i build
  Web zakończyły się poprawnie.
- [x] 2026-08-25 — testy widgetowe potwierdzają Escape dla compact sidebara oraz
  brak spinnera w kompaktowym empty state bez workspace’u.
- [x] 2026-08-25 — przełącznik workspace’u w kontekstowym menu grupuje pozycje
  jako „Ulubione” i „Wszystkie workspace’y”, zachowując backendową ikonę, kolor
  oraz aktywny stan bieżącej przestrzeni.
- [x] 2026-08-25 — parametryczna trasa Wiki projektu korzysta z tego samego
  `WorkspaceResourceAccessCubit` co katalog zasobów; nie renderuje już surowego
  identyfikatora i pokazuje jawne stany loading/not-found/failure.
- [x] 2026-08-25 — deep-link celu OKR korzysta z `OkrRepository` i lokalnego,
  sealed `OkrObjectiveDetailsCubit`; pokazuje postęp oraz kluczowe rezultaty,
  a błąd backendu ma jawny komunikat i retry.
- [x] 2026-08-25 — sekcja „Członkowie” workspace’u korzysta z endpointu
  `GET /api/v1/workspaces/{workspaceId}/members`, lokalnego Cubita i jawnego
  stanu błędu; role są renderowane z kontraktu backendowego.
- [x] 2026-08-25 — sekcja członków nie pokazuje surowych `coreUserId` ani UUID;
  UI prezentuje bezpieczny numer członka i rolę, dopóki backend nie udostępni
  nazwy prezentacyjnej użytkownika.
- [x] 2026-08-25 — pozostałe trasy Wiki workspace’u i zaproszenia nie pokazują
  już surowych identyfikatorów jako treści; komunikują jawnie ograniczenie
  kontekstowego endpointu zamiast udawać załadowane dane.
- [x] 2026-08-25 — po rozszerzeniu menu rozdzielono pliki, które przekroczyły
  limit 300 linii: szczegóły zasobów, katalog workspace’u i menu kontekstowe;
  zachowano publiczne eksporty, routing AutoRoute i istniejące zachowanie.
- [x] 2026-08-25 — dodano test Cubita członków workspace’u, który potwierdza
  ładowanie ról z backendowego kontraktu bez ujawniania identyfikatorów UI.
