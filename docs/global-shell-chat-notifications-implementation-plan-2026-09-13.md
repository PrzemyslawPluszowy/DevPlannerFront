# Globalny shell, Chat i powiadomienia — plan pełnej implementacji

> Data audytu: 2026-09-13  
> Repozytoria: `ready_next` oraz `veloryn-workspaces`  
> Branch obowiązkowy: `workspace`

## 1. Cel i kolejność

Prace należy wykonać w następującej kolejności:

1. naprawić globalny shell aplikacji i kontrakt warstw `Overlay`;
2. ujednolicić modale, side sheety, bannery, menu i snackbar;
3. osadzić globalny panel Chat i centrum powiadomień w poprawionym shellu;
4. zbudować pełny klient Chat na istniejącym kontrakcie backendu;
5. dodać rozmowy zasobów, w pierwszej kolejności Chat pliku;
6. domknąć produkcyjne bramki backendu i testy wieloplatformowe.

Naprawa shellu jest bramką wejściową. Nie należy rozwijać docelowego drawera
Chat na obecnym układzie, ponieważ dziedziczy on błędną geometrię i kolejność
malowania globalnej belki.

## 2. Wynik audytu bieżącego stanu

### 2.1. Przyczyna problemu globalnego UI

`AppGlobalModuleWrapper` jest dziś tworzony w `MaterialApp.router.builder` i
buduje `Stack`, w którym:

- zawartość routera/Navigatora jest pierwszą warstwą;
- globalna belka jest `Positioned(top: 8, left: 12, right: 12, height: 42)` nad
  zawartością;
- globalny rail jest kolejną warstwą nad zawartością;
- belka nie ma własnego miejsca w geometrii strony;
- moduły kompensują ją ręcznie przez `top: 54` albo `top: 56`.

To powoduje kilka klas błędów:

- route overlay i modal mogą być malowane pod globalną belką;
- modal barrier nie zawsze zasłania wizualnie całą aplikację;
- strony niekorzystające z `AppModuleLayout` mogą wjeżdżać pod belkę;
- compact layout i desktop używają różnych magicznych offsetów;
- wysokość i położenie belki nie uwzględniają systemowego `viewPadding`;
- fullscreen modal, side sheet, menu, tooltip i snackbar nie mają jednego
  kontraktu z globalnym chrome;
- topbar łączy brand, breadcrumb, niedziałającą wyszukiwarkę, powiadomienia i
  Chat w 42 px, przez co jest wizualnie ciasny i słabo skaluje się responsywnie.

Problem jest zatem w composition root/router shell, a nie w pojedynczych
modalach.

### 2.2. Stan Flutter Chat i Notifications

Istnieją już:

- globalne ikony Chat i powiadomień na utility bar;
- prawy drawer rozmów i prawy drawer powiadomień;
- trasy `/chat`, `/chat/conversations/:conversationId` oraz deep link do
  wiadomości;
- podstawowy `ChatConversationCubit`, prosty composer tekstowy i odświeżanie po
  zdarzeniu realtime;
- `NotificationsCubit`, grupowanie, unread count, mark-as-read i deep linki;
- pełny klient Retrofit Chat oraz szeroki zestaw wygenerowanych modeli;
- klient SignalR Chat i Notifications.

Obecne ograniczenia klienta Chat:

- `ChatRepository` wystawia tylko trzy operacje: lista rozmów, lista wiadomości,
  wysłanie plain text;
- drawer jest listą skrótów, a kliknięcie opuszcza bieżący ekran i przechodzi do
  pełnej trasy zamiast utrzymać rozmowę w panelu;
- brak paginacji historii, trwałej kolejki offline, stabilnego UUID przy retry i
  stanów `sending/sent/failed` per wiadomość;
- realtime reaguje pełnym ponownym pobraniem listy i nie realizuje kompletnego
  `sequence/eventId/replay/resync`;
- brak rich text, kodu, odpowiedzi, wątków, reakcji, wzmianek, edycji, usuwania,
  pinów, bookmarków i forward;
- brak uploadu/preview załączników, clipboard image i integracji szkiców;
- brak tworzenia DM/grupy/kanału i zarządzania członkami;
- brak wyszukiwarki, filtrów, presence/statusów i preferencji powiadomień;
- teksty Chat/Notifications są częściowo wpisane na stałe zamiast `intl/ARB`;
- brak UI czatu pliku mimo gotowego Resource Scope po stronie backendu.

### 2.3. Stan backendu `veloryn-workspaces`

Backendu Chat nie należy pisać od nowa. Aktualny kod zawiera:

- rozmowy `Direct`, `Group`, `Channel`, `Broadcast`, `Discussion`;
- Scope `Global`, `Workspace`, `Project`, `Resource` i registry providerów;
- provider plików delegujący autoryzację do Storage;
- członkostwa, role, archiwizację, placementy i politykę publikacji;
- wiadomości, idempotency/payload hash, optimistic concurrency i rewizje;
- reply/thread, named discussions, reakcje, piny, bookmarki i forward;
- wzmianki i access-safe suggestions;
- załączniki Storage, limity, AV gate i revocation-sensitive stream;
- drafts, conversation/thread mute, preferencje powiadomień i statusy;
- search/facets, snippets i bezpieczny link preview;
- SignalR, transactional outbox, cursor replay, presence i Redis backplane;
- integrację z istniejącym Notifications/outbox.

Notifications posiada trwały inbox, grupy, cursor pagination, unread count,
pin/archive/read, quick actions, reply-from-notification, digest, preferencje
dostarczenia i realtime.

Otwarte bramki backendowe istotne dla wdrożenia klienta:

- pełna macierz ról i Scope na HTTP/PostgreSQL/SignalR;
- natychmiastowa globalna revokacja/abort połączeń po odebraniu dostępu;
- testy Storage/AV/SSRF i access revoke dla załączników;
- testy concurrency, grouped notifications i retry outboxa;
- load/soak dla wiadomości, wyszukiwarki, presence i dwóch instancji;
- health/readiness Redis oraz runbook operacyjny;
- feature flag, rollback i bramka zgodności OpenAPI/SignalR.

## 3. Docelowa architektura globalnego shellu

### 3.1. Decyzja

Globalny chrome użytkownika uwierzytelnionego należy przenieść z
`MaterialApp.router.builder` do jawnego shell route GoRoutera. Publiczne trasy
(`login`, publiczny share pliku i ekran startowy, jeżeli wymaga osobnego chrome)
pozostają poza tym shellem.

Docelowa hierarchia:

```text
MaterialApp.router
└── root Navigator / root Overlay
    ├── public route
    └── authenticated ShellRoute
        └── AppGlobalShell
            ├── reserved top-bar slot
            ├── reserved collapsed rail slot
            ├── routed module content
            └── optional in-shell persistent panes

root Overlay entries
├── modal barrier
├── dialog / fullscreen dialog / bottom sheet
└── system-level transient UI
```

Root `Overlay` musi być nad całą trasą shellu. Dzięki temu każdy root modal i
jego barrier zakrywa belkę, rail oraz content w jednej, przewidywalnej warstwie.

### 3.2. Kontrakt geometrii

Wprowadzić jeden typ/ThemeExtension opisujący chrome, np. `AppShellMetrics`:

- `topBarHeight`;
- `topBarOuterInsets`;
- `collapsedRailWidth` i `expandedRailWidth`;
- `contentInsets`;
- breakpointy `compact`, `medium`, `wide`;
- minimalny obszar dotykowy i wysokości kontrolek.

Żaden ekran modułu nie może znać wartości `54`, `56` ani położenia globalnej
belki. `AppModuleLayout` ma otrzymać już obszar roboczy po odjęciu chrome.

### 3.3. Nowa belka

Belkę przebudować jako prosty, semantyczny pasek aplikacji:

- lewa sekcja: aktywny moduł i breadcrumb;
- środek: globalne wyszukiwanie/command palette, tylko gdy szerokość pozwala;
- prawa sekcja: powiadomienia, Chat, profil/status użytkownika;
- badge Chat: suma nieprzeczytanych rozmów, osobno od Notifications;
- wyraźny stan hover/focus/pressed oraz pełna nawigacja klawiaturą;
- jedna powierzchnia i separator zamiast pływającej kapsuły nad treścią;
- responsywne zwijanie breadcrumb i wyszukiwarki bez overflow;
- wszystkie teksty przez `context.l10n`.

W compact layout pasek zachowuje zarezerwowaną wysokość, a menu modułu otwiera
się jako poprawna modalna warstwa z focus trapem.

### 3.4. Kontrakt warstw i modalności

Wprowadzić wspólne API prezentacji, które jawnie rozróżnia:

- `appDialog` — modal centralny;
- `appSideSheet` — modalny panel boczny;
- `appBottomSheet` — modal od dołu;
- `persistentPane` — nie-modalny panel Chat współistniejący z treścią;
- `anchoredPopover` — menu/tooltip zakotwiczony w kontrolce;
- `toast/banner/snackbar` — komunikat przejściowy.

Domyślnie modalne elementy używają root navigatora. Wyjątek wymaga jawnej
decyzji i testu. Każdy wariant musi mieć:

- poprawny barrier nad całym shellem;
- `SafeArea`/`viewPadding`;
- focus trap, Escape, restore focus i semantyczny label;
- zablokowanie interakcji z tłem;
- poprawne zachowanie Back i deep linków;
- spójne animacje i tokeny motywu;
- test dla Web i desktopowych wymiarów.

Po wprowadzeniu API wykonać inwentaryzację wszystkich obecnych wywołań
`showDialog`, `showGeneralDialog`, `showModalBottomSheet` i stopniowo zastąpić
je wspólnym kontraktem. Najpierw migrować modale Workspaces, potem współdzielone,
BHP i Inwentaryzację.

## 4. Etapy implementacji

### Etap 0 — baseline i test odtwarzający błąd

- [ ] Dodać golden/screenshot bieżącego shellu dla 1920×1080, 1440×900,
  1280×720 i compact.
- [x] Dodać failing test: root dialog wraz z barrierem musi zasłonić topbar i
  rail.
- [x] Dodać failing test: routed page zaczyna się poniżej zarezerwowanej belki
  bez własnego top paddingu.
- [x] Dodać testy keyboard/focus: Tab, Shift+Tab, Escape i przywrócenie focusu.
- [x] Zapisać listę magicznych offsetów i bezpośrednich wywołań modalnych jako
  checklistę migracji.

### Etap 1 — root router i AppGlobalShell

- [x] W `app_router.dart` wydzielić authenticated shell route.
- [x] Login i publiczny share pozostawić poza prywatnym shellem.
- [x] Przenieść `AppGlobalModuleWrapper` z `MaterialApp.router.builder` do
  buildera shell route i zmienić go w `AppGlobalShell`.
- [x] Zastąpić pozycjonowaną belkę zarezerwowanym slotem w layoucie.
- [x] Zachować rail jako overlay tylko w stanie rozwiniętym; jego zwinięta
  szerokość musi być częścią geometrii.
- [x] Usunąć ręczne `top: 54/56` z `AppModuleLayout`,
  `AppCompactModuleLayout` i dashboardu.
- [ ] Zachować stan zagnieżdżonych routerów przy zmianie breakpointu.
- [ ] Zweryfikować odświeżenie URL, Back/Forward i bezpośrednie deep linki.

Kryterium odbioru: żadna prywatna strona nie wjeżdża pod topbar, a root dialog
zawsze jest nad topbarem, railem i contentem.

### Etap 2 — redesign belki i responsive chrome

- [x] Utworzyć `AppShellMetrics` i tokeny wizualne w theme.
- [x] Rozdzielić topbar na małe, testowalne sekcje odpowiedzialności.
- [x] Podłączyć realną command palette albo do czasu jej wdrożenia usunąć
  kontrolkę udającą aktywne wyszukiwanie.
- [ ] Dodać Chat unread badge, stan połączenia realtime i profil/custom status.
- [x] Zapewnić layout compact/medium/wide bez poziomego overflow.
- [x] Przenieść hardcoded teksty do ARB PL/EN i uruchomić generator l10n.
- [ ] Dodać goldeny light/dark oraz 100%, 125%, 150% text scaling.
- [x] Dodać deterministyczne snapshoty geometrii dla desktop/compact,
  jasnego/ciemnego motywu i raila zwiniętego/rozwiniętego.

### Etap 3 — wspólny system modalny

- [x] Ujednolicić `AppModalSheet`, `AppExpandableSideSheet`, drawers Chat i
  Notifications na jednym hoście warstw.
- [ ] Usunąć lokalne obejścia `Overlay.maybeOf`, przypadkowe
  `Navigator.of(context)` oraz niejawne zagnieżdżone navigatory.
- [x] Dodać politykę `root` kontra `nested` w jednym helperze/serwisie UI.
- [x] Ujednolicić bariery, promienie, marginesy, szerokości i animacje.
- [x] Dodać kolejkę/koordynator, aby dwa systemowe panele nie otwierały się
  jednocześnie.
- [ ] Zweryfikować wszystkie 165 obecnych miejsc otwierających modal/sheet;
  przenosić je partiami z testem regresji per moduł.

Stan po pakiecie 3L: dwa pozostałe świadome `OverlayEntry` mają zamknięte
kontrakty. `AppSearchDropdown` jest anchored popoverem ownerowanym przez
kotwicę i zamyka się przy route/resize/dispose. `AppBubbleToastController`
jest sesyjnie wstrzykiwany przez `AppGlobalShell`; usuwa bieżący toast przy
wejściu modala i kolejkuje żądania FIFO do `release`. Rootowy builder modala
oraz callbacki shella muszą używać kontekstu spod scope'ów ownerów — nie
rootowego kontekstu navigatora pobranego przed buildem. Dalsze overlaye
wymagają lokalnego albo sesyjnego ownera, polityki lifecycle'u i testu z-orderu.

### Etap 4 — host globalnego Chat i Notifications

- [x] W `AppGlobalShell` utworzyć kontrolowany stan globalnych paneli, bez
  globalnego Bloc singletona; lifecycle należy do shellu sesji.
- [x] Chat i Notifications otwierać z topbara bez utraty bieżącej trasy.
- [x] Na szerokim ekranie umożliwić przypięty panel Chat, który rezerwuje
  szerokość i nie zasłania treści.
- [x] W trybie overlay i compact używać modalnego side sheetu.
- [x] Zapamiętać szerokość, stan przypięcia i ostatnią rozmowę jako osobistą
  preferencję lokalną; później można zsynchronizować ją przez backend.
- [x] Pełna trasa `/chat/...` pozostaje dla deep linku, pracy na dużym ekranie
  i otwierania w osobnym widoku.
- [ ] Notifications i Chat mają osobne liczniki, loading/error/offline i
  czytelny stan reconnect.

Stan po pakietach 4A–4B: istnieje sesyjny owner widoczności paneli, przypięty
Chat z rezerwacją szerokości, overlay dla compact/medium oraz lokalne
preferencje szerokości/przypięcia/ostatniej rozmowy. Rozmowa wybrana w panelu
otwiera się in-place i zachowuje URI; pełna trasa jest jawną akcją. Checkboxy
pozostają otwarte do czasu testu rzeczywistych akcji topbara i domknięcia
oddzielnych stanów unread oraz reconnect dla Chat i Notifications.

Weryfikacja 2026-09-15 domknęła sześć pierwszych kryteriów Etapu 4 aktualnym
testem routera i widgetowym prawdziwego shellu. `ChatRealtimeStatusCubit`
obserwuje wyłącznie istniejący transport aktywnej rozmowy; panel pokazuje
connecting/reconnecting/offline bez wywołania API w UI, a owner rozmowy zwalnia
realtime utworzony przez factory. Ostatni checkbox pozostaje otwarty: Chat nie
ma osobnego unread badge, ponieważ aktualny, zweryfikowany kontrakt
`GET /api/v1/chat/conversations` (`ChatConversationResponse`) nie zawiera
`unreadCount`, a `ChatApi` nie wystawia endpointu agregatu unread. Nie wolno
wyprowadzać go z inboxa Notifications ani tworzyć wartości lokalnej.

### Etap 5 — fundament klienta Chat

- [ ] Rozszerzyć `ChatRepository` na pełny, pogrupowany kontrakt domenowy zamiast
  bezpośredniego eksponowania wygenerowanych DTO.
- [ ] Podzielić prezentację na subfeature’y: conversations, conversation,
  composer, threads, search, members, settings, attachments i resource chat.
- [ ] Dodać `ChatShellCubit` dla listy/wyboru, lokalny `ConversationCubit` per
  otwarta rozmowa i osobny owner kolejki offline.
- [ ] Wprowadzić cursor pagination starszych wiadomości i wirtualizowaną listę.
- [ ] Wprowadzić local message model z UUID `clientMessageId`, stanami
  `sending/sent/failed`, ręcznym retry i kontrolą konfliktu payload hash.
- [x] Zachować draft tekstu, Delta, reply target i kolejność załączników;
  debounce zapisu oraz flush przy zamknięciu.
- [ ] Obsłużyć replay po `sequence`, deduplikację `eventId`, `resyncRequired` i
  pełne odświeżenie tylko wtedy, gdy wymaga tego kontrakt.
- [ ] Po `401/403` natychmiast odpiąć rozmowę, wyczyścić prywatny cache i pokazać
  typowany komunikat.

### Etap 6 — pełne funkcje wiadomości

- [x] Composer plain text + kontrolowany Quill Delta.
- [x] Skróty Enter/Shift+Enter, obsługa IME i dostępność klawiatury.
- [x] Reply, thread oraz named discussion w prawym podpanelu.
- [x] Edycja/usunięcie z `Version`, obsługa `409` i historia rewizji.
- [ ] Reakcje, piny, bookmarki i forward.
- [ ] Wzmianki z debounce, minimum 2 znaki, `Retry-After` po 429 i stabilnym
  `CoreUserId`.
- [ ] Render bezpiecznych linków, preview i bloków kodu.
- [ ] Search/facets z filtrami, kursorem i przejściem do wiadomości.
- [ ] Presence, typing, delivery/read receipts oraz custom status/DND.
- [ ] Tworzenie Direct/Group/Channel/Broadcast i zarządzanie członkami zgodnie z
  capabilities zwróconymi przez API.
- [ ] Mute per rozmowa i per wątek, archiwizacja, przypinanie rozmów i
  preferencje powiadomień.

### Etap 7 — załączniki i schowek

- [ ] Wspólna kolejka uploadu wykorzystująca Storage, z postępem, anulowaniem i
  retry.
- [ ] Drag-and-drop oraz paste image na Web/Wasm, Windows, macOS i Linux przez
  typowaną abstrakcję platformową.
- [ ] Walidacja 20 plików, 50 MB per plik i 100 MB per wiadomość także przed
  uploadem; backend pozostaje źródłem prawdy.
- [ ] Stan `Processing/Scanning/Clean/Infected/Failed` bez przedwczesnego
  udostępniania linku.
- [ ] Preview obrazów, wideo, PDF i dokumentów tylko przez autoryzowany Storage.
- [ ] Długi paste: zaproponować snippet `.txt/.md`, nigdy nie zamieniać tekstu
  bez potwierdzenia.
- [ ] Po revoke usunąć podgląd i URL z pamięci klienta.

### Etap 8 — Chat pliku i innych zasobów

Chat pliku ma być tą samą rozmową Chat, a nie nowym modelem komentarzy.

> Walidacja backendu po 8B: pełne `dotnet test` — **1006 sukcesów,
> 3 pominięte, 0 błędów; 1009 testów łącznie, 2 min 58 s**. Ten wynik należy
> zachować jako dowód kontraktu capability; nie zastępuje testów UI z tej
> checklisty.

- [ ] Na ekranie szczegółów pliku dodać akcję „Czat pliku” tylko gdy plik jest
  udostępniony w systemie i backend zwraca prawo odczytu Resource Scope.
- [ ] Wywołać idempotentne `POST /api/v1/chat/conversations/resolve` z providerem
  `files`, typem zasobu i `fileId`.
- [ ] Otwierać zwróconą rozmowę w globalnym panelu bez opuszczania widoku pliku.
- [ ] Pokazać nazwę pliku, właściciela, access level i bezpieczny link powrotny w
  nagłówku rozmowy.
- [ ] Share/revoke ma natychmiast aktualizować dostęp; Chat nie może zachować
  historii w UI po 403.
- [ ] Opcjonalne zdarzenie nowej wersji pliku publikować jako wiadomość systemową
  dopiero po decyzji produktowej; nie dublować go z Notifications.
- [ ] Ten sam mechanizm następnie wykorzystać dla task, project, wiki,
  whiteboard, portfolio i OKR.

Warunek widoczności nie może opierać się wyłącznie na lokalnym polu
`isShared`. Ostateczną decyzję podejmuje provider Scope w backendzie.

### Etap 9 — pełne centrum powiadomień

- [x] Utrzymać jeden globalny `NotificationsCubit` w lifecycle sesji, aby unread
  badge i otwarty inbox używały jednego strumienia stanu.
- [x] Dodać cursor pagination grup i elementów, filtry kategorii/unread oraz
  przypięte elementy.
- [ ] Obsłużyć quick actions, archive, read group/read all i optimistic UI z
  rollbackiem.
- [x] Dodać reply-from-notification przez rootowy modal bez zmiany URI.
- [ ] Dodać przejście do dokładnej wiadomości Chat po explicit deep linku.
- [ ] Po deep linku ponownie autoryzować zasób; powiadomienie nie nadaje dostępu.
- [ ] Dodać ekran preferencji globalnych, Chat i Storage oraz digest.
- [ ] Realtime scalać po `eventId`; po reconnect uzupełniać przez REST cursor.
- [ ] Ukrywać/redukować payload po revoke bez wycieku tytułu lub treści zasobu.

### Etap 10 — domknięcie backendu i wdrożenie

- [ ] Zsynchronizować aktualny OpenAPI z klientem i dodać breaking-change gate.
- [ ] Domknąć natychmiastowy revoke/abort oraz pełną reautoryzację Resource.
- [ ] Dodać brakujące testy REST/PostgreSQL/SignalR/Redis/Storage/AV.
- [ ] Wykonać load/soak z ustalonym SLO dla list, send, search, outbox i
  presence.
- [ ] Dodać health/readiness Redis, monitoring outbox lag i alarmy.
- [ ] Przygotować runbook: reconnect storm, stuck outbox, Redis down, AV down,
  migracja i rollback.
- [ ] Włączyć rollout feature flagą: pracownicy testowi → wybrany workspace →
  cała firma.
- [ ] Po stabilizacji usunąć flagę i tymczasowe ścieżki zgodności.

## 5. Testy obowiązkowe

### UI shell i modale

- root dialog/barrier nad całym chrome;
- brak nakładania na topbar przy każdej trasie prywatnej;
- nested navigation, deep links, refresh i Back;
- compact/medium/wide, light/dark i text scaling;
- focus trap, Escape, restore focus i screen reader labels;
- dwa panele systemowe nie konkurują o warstwę ani focus.

### Chat

- cursor pagination bez duplikatów i przeskoków scrolla;
- optimistic send, offline, retry z tym samym `clientMessageId` i konflikt
  innego payloadu;
- ordering, duplicate event, reconnect, replay i resync;
- edit/delete conflict, replies/threads, reactions i mentions;
- drafts na dwóch urządzeniach;
- role Direct/Group/Channel/Broadcast/Resource;
- revoke w czasie otwartej rozmowy;
- upload/AV/preview/clipboard na Web/Wasm i desktop;
- brak wycieku danych między workspace’ami i tenantami.

### Notifications

- grupowanie i unread count po live event/reconnect;
- mute/DND/digest oraz priorytety mention/DM/reply;
- quick actions i reply-from-notification;
- revoke usuwa dostęp mimo istniejącego deep linku;
- SuperAdmin bez członkostwa nie otrzymuje komunikacji workspace.

## 6. Sugerowany podział kodu Flutter

```text
lib/app/shell/
├── app_global_shell.dart
├── app_shell_metrics.dart
├── app_shell_overlay_coordinator.dart
├── top_bar/
└── system_panels/

lib/workspaces/presentation/chat/
├── chat_export.dart
├── shell/
├── conversations/
├── conversation/
│   ├── cubit/
│   ├── message_list/
│   ├── composer/
│   ├── thread/
│   └── attachments/
├── create_conversation/
├── members/
├── search/
├── settings/
└── resource_chat/

lib/workspaces/presentation/notifications/
├── cubit/
├── inbox/
├── preferences/
└── widgets/
```

Dokładny podział ma wynikać z odpowiedzialności. Nie należy przenosić całego
Chat do jednego globalnego Bloca ani jednego dużego widgetu.

## 7. Pliki o najwyższym priorytecie zmian

Frontend:

- `lib/app/ready_next_app.dart`;
- `lib/app/router/app_router.dart`;
- `lib/shared/presentation/widgets/app_global_module_wrapper.dart`;
- `lib/shared/presentation/widgets/app_global_utility_bar*.dart`;
- `lib/shared/presentation/widgets/app_module_lauout/app_module_layout.dart`;
- `lib/shared/presentation/widgets/app_module_lauout/app_compact_module_layout.dart`;
- `lib/shared/presentation/widgets/app_modal_sheet.dart`;
- `lib/workspaces/domain/repositories/chat_repository.dart`;
- `lib/workspaces/data/chat/`;
- `lib/workspaces/presentation/chat/`;
- `lib/workspaces/presentation/notifications/`;
- `lib/workspaces/presentation/storage/`.

Backend — wyłącznie domknięcie kontraktu i jakości, nie przebudowa modułu:

- `Endpoints/Chat/ChatEndpoints.cs`;
- `Endpoints/Notifications/NotificationEndpoints.cs`;
- `Application/Chat/`;
- `Application/Notifications/`;
- `Application/Storage/StorageAccessService.cs`;
- infrastruktura SignalR/outbox/Redis i odpowiadające jej testy.

## 8. Definicja ukończenia

Zakres jest ukończony dopiero, gdy:

- topbar ma zarezerwowane miejsce i nie nachodzi na żadną stronę;
- root dialog, side sheet i barrier zawsze mają poprawny z-order;
- Chat można otworzyć z każdego prywatnego miejsca bez utraty kontekstu;
- pełna trasa Chat i panel używają tego samego stanu domenowego i komponentów;
- użytkownik może prowadzić DM, grupy, kanały i rozmowy zasobów;
- udostępniony plik ma ten sam, autoryzowany Resource Chat;
- wszystkie funkcje wiadomości, offline/retry, realtime/reconnect, załączniki,
  wyszukiwanie, presence i preferencje działają zgodnie z OpenAPI;
- Notifications mają kompletny inbox, grupy, akcje, preferencje i niezawodny
  reconnect;
- nie ma wycieku danych po revoke ani między workspace’ami;
- testy Flutter przechodzą na Web/Wasm i desktop, backend przechodzi pełne
  bramki REST/PostgreSQL/SignalR/Redis/Storage;
- dokumentacja, OpenAPI, plan główny i checklisty statusu są zaktualizowane.

## 9. Pierwszy pakiet wykonawczy

Pierwszy commit implementacyjny powinien obejmować wyłącznie fundament shellu:

1. test odtwarzający kolizję modal/topbar;
2. authenticated shell route;
3. zarezerwowany topbar slot i usunięcie magicznych offsetów;
4. poprawny root overlay dla dialogu i side sheetu;
5. testy routingu, modali, desktop/compact i light/dark;
6. aktualizację tego planu po walidacji.

Nie należy w tym samym commicie wdrażać funkcji Chat. Pozwoli to rozdzielić
ryzyko infrastruktury UI od dużej integracji produktowej.

## 9B. Zweryfikowany kontrakt backendowy widoczności powiadomień

Backend reautoryzuje istniejące powiadomienia w chwili listowania, grupowania,
digestu, licznika unread i dostarczenia realtime/e-mail. Po utracie capability
nie wolno renderować ani zachowywać payloadu. Dla grup backend może wysłać
`notification.group.removed` z samym `groupKey` i `realtimeSequence`; reducer
usuwa wtedy grupę wyłącznie, gdy sequence nie jest starszy od zapisanego. Gdy
event nie dotrze (reconnect), klient wykonuje zwykły resync `/notifications`
i `/notifications/groups`; nie wolno odtwarzać danych z lokalnego cache jako
źródła prawdy.

## 9E-A. Globalne preferencje dostarczania, Storage i read-only digest

- [x] Udostępnić wyłącznie osobiste ustawienia dostarczania e-mail dla kategorii
  globalnych oraz niezależną preferencję Storage, przez porty domenowe i
  adaptery data.
- [x] Utrzymać trzy małe, rozłączne Cubity: globalny delivery, Storage i
  read-only digest. Żaden nie jest globalnym ownerem inboxa ani nie zależy od
  widgetów, routera lub transportu.
- [x] Otwierać preferencje z pełnej strony i globalnego panelu Notifications
  przez `AppModalHost`, bez zmiany URI.
- [x] Dodać PL/EN ARB, wygenerować lokalizacje oraz testy rollbacku zapisu,
  pustego/błędnego digestu i dostępności obu wejść.
- [ ] Chat preferences, reply-from-notification i wszystkie pozostałe elementy
  etapu 9 pozostają osobnymi pakietami; nie rozszerzać 9E-A o ich stan ani UI.

## 9E-B. Ustawienia powiadomień Chat

- [x] Udostępnić globalne kanały Chat: in-app, e-mail, push i digest, przez
  osobny `ChatNotificationSettingsRepository`, bez transportu w widgetach.
- [x] Dodać lokalne cubity dla globalnego snapshotu i dla jednej rozmowy;
  każdy ma własną generację żądań, loading/save/error oraz stan revoke dla
  401/403. Nie łączyć ich z `NotificationsCubit` ani composerem.
- [x] Osadzić globalną sekcję Chat w istniejącym rootowym modalu preferencji,
  a politykę rozmowy (`all`, `mentionsOnly`, `muted`, `highOnly`) udostępnić
  z panelu i pełnego widoku Chat przez `AppModalHost`, bez zmiany URI.
- [x] Dodać PL/EN ARB, runtime DI, testy mapowania częściowego zapisu,
  rollbacku/revoke 401/403 oraz dostępności obu powierzchni.
- [ ] DND oraz mute wątków nie są częścią 9E-B: nie istnieje dla nich
  zatwierdzony port domenowy ani kontrakt backendu.

## 9F. Odpowiedź Chat z powiadomienia

- [x] Udostępnić odrębny port `NotificationReplyRepository`, adapter Retrofit
  i runtime DI dla `POST /api/v1/notifications/{id}/reply`; widgety nie znają
  URI, DTO ani transportu.
- [x] Utrzymać mały, lokalny `NotificationReplyCubit` na lifecycle jednego
  modala. Nowa próba otrzymuje UUID v4 `clientMessageId`; zwykły błąd zachowuje
  tekst, Delta i ten sam UUID dla retry, zaś 401/403 przechodzą do revoke i
  nie zachowują prywatnego draftu.
- [x] Kwalifikować affordance wyłącznie dla `entityType == ChatMessage` albo
  niepustego `metadata.chatMessageId` / `metadata.messageId`. Typ
  `NotificationReplyTarget` trzyma tę politykę poza widgetem; format ID i
  bieżące uprawnienie rewaliduje serwer.
- [x] Udostępnić akcję z pełnej strony i z globalnego panelu Notifications;
  oba wejścia otwierają rootowy `AppModalHost` i nie zmieniają URI.
- [x] Dodać PL/EN ARB, wygenerować lokalizacje oraz testy sukcesu przez
  metadata, kwalifikacji obu pól i `ChatMessage`, 401/403 revoke, retry ze
  stabilnym UUID oraz osiągalności z obu powierzchni.
- [ ] Przejście po odpowiedzi do dokładnej wiadomości pozostaje osobnym
  deep-linkiem: aktualny pakiet zamyka modal i odświeża inbox, bez zmiany
  bieżącej trasy.
