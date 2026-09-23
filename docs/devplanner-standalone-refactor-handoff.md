# DevPlanner standalone — handoff zaakceptowanego stanu

## 2026-09-23 — jawny probe inicjalizacji ONLYOFFICE

Po kolejnym timeout bez logu zasobu/JS rozszerzono host HTML: `api.js` jest
ładowany jawnie; bridge zgłasza Talkerowi jego sukces, błąd pobrania, wyjątek
konstruktora DocsAPI, `window.error` oraz `unhandledrejection`. Teksty błędów
redagują URL-e i wartości token/secret/authorization. Wcześniejsza zmiana
raportuje również wszystkie błędy zasobów WebView.

Pliki: `lib/workspaces/data/storage/transport/onlyoffice_editor_html_builder.dart`,
`lib/workspaces/presentation/storage/office/widgets/storage_onlyoffice_controller.dart`.
`flutter analyze --no-pub`, `dart format` i `git diff --check` PASS. Testów ani
runtime nie uruchamiano. Następny krok: uruchomić świeżo zbudowaną aplikację i
sprawdzić, czy pojawia się log sukcesu `api.js`, błędu JS/zasobu, czy nadal tylko
timeout.

## 2026-09-23 — diagnostyka blokady WebView ONLYOFFICE

Kolejne logi użytkownika potwierdziły HTTP 200 dla pobrania ticketu i
`office-session`, a Document Server jest publicznie osiągalny z tego środowiska
(healthcheck i `api.js` HTTP 200). Dotychczasowy `NavigationDelegate` ignorował
błędy zasobów, jeżeli `isForMainFrame == false`, przez co awaria `api.js`, assetu
lub dokumentu nie trafiała do logów. Dodano Talker dla błędów JS console
(error/warning) i wszystkich błędów zasobów; log nie ujawnia query, tokenów ani
ścieżek storage. Komunikat `evaluateJavaScript ... <null>` sam w sobie nie
identyfikuje przyczyny i wymaga korelacji z nowymi logami.

Pliki: `lib/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart`,
`lib/workspaces/presentation/storage/office/widgets/storage_onlyoffice_controller.dart`.
`flutter analyze --no-pub`, `dart format` i `git diff --check` PASS. Testów ani
runtime nie uruchamiano. Następny krok: odtworzyć otwarcie i zebrać pierwszy
log `[storage.onlyoffice][WEBVIEW]` lub `[storage.onlyoffice][JS error]`.

## 2026-09-23 — Talker i czytelne logi HTTP

Po zgłoszeniu nieczytelnego `body=<object fields=...>` w diagnostyce Storage
zmieniono `DevPlannerHttpDiagnosticsInterceptor`: odpowiedzi JSON są teraz
logowane z wartościami sanitizowanymi, zamiast samych nazw pól. Dla sesji Office
powinno to ujawnić bezpieczny `documentServerUrl`; JWT/tokeny są redagowane, a
adresy presigned pokazują host bez query i ścieżki. Request/response/error są
typowanymi logami Talker z kolorami. Bootstrap współdzieli Talkera dla
web/desktop HTTP oraz rejestruje globalne błędy Flutter/platformy.

Pliki: `lib/bootstrap/app_bootstrap.dart`,
`lib/foundation/http/devplanner_http_transport.dart`,
`lib/foundation/http/devplanner_http_diagnostics_interceptor.dart`.
Wykonano `dart format` zmienionych plików, `flutter analyze --no-pub` (PASS)
i `git diff --check` (PASS). Testów ani runtime nie uruchamiano. Następny krok:
odtworzyć timeout ONLYOFFICE i odczytać `documentServerUrl` oraz bezpieczne
pola odpowiedzi w logu.

## Indeks aktualnego statusu Chat — 2026-09-23

Najświeższe wpisy prac są na końcu tego pliku. Dawne sekcje G/F zachowują
historyczne check-boxy; ich niezaznaczone pola nie są aktualną listą braków,
jeśli późniejszy wpis dokumentuje implementację. Przed podjęciem pracy sprawdź
bieżący kod i status w `docs/devplanner-standalone-refactor-plan.md`.

- W kodzie są globalny panel, tworzenie rozmów, członkowie/role, akcje
  wiadomości, wyszukiwanie, wątki, statusy/realtime client, bogaty composer,
  emoji, linki i podłączony przepływ załączników. Wpisy CHAT-R61–R68 pokazują
  najnowsze wycinki i wyniki, nie całościowy odbiór produktu.
- CHAT-R71: systemowy picker Web i drop korzystają ze wspólnego preflightu
  limitów przed odczytem bajtów; `flutter analyze --no-pub`, testy załączników
  **20/20**, Web/Wasm build, macOS Debug build i `git diff --check` PASS.
  Zmiana Front; bez kontraktu/API/backendu.
- Nadal otwarte: zalogowany odbiór historii/composera/menu, ręczny drop, upload,
  pobranie i clipboard, odmowy/revoke i cleanup oraz dwu-sesyjne E2E SignalR.
  Ostatnia próba CUA pokazała okno Codex zamiast DevPlanner; nie traktować jej
  jako testu UI.
- Nie uruchamiać widget/golden tests przed akceptacją wyglądu przez użytkownika.

### CHAT-QA-R72 — ponowny przegląd krytycznych przepływów

- Statycznie przejrzano composer, formatowanie, tworzenie rozmów oraz modal
  członków. Kod udostępnia dodawanie osób, wybór typu rozmowy, statusy,
  kontekstowe menu formatowania, TXT dla długiego tekstu i stałe miejsce na
  akcje composera. Nie znaleziono nowego konkretnego błędu w tym wycinku.
- `flutter analyze --no-pub` i `git diff --check` PASS. Testów widgetowych/
  golden nie uruchamiano zgodnie z dyspozycją użytkownika.
- CUA potwierdziło zablokowany macOS; aktywnej rozmowy i załączników nie da się
  teraz sprawdzić wizualnie. Nie uruchomiono GUI ani nie pozostawiono instancji
  otwartej. Zalogowany odbiór UI i dwu-sesyjne realtime pozostają otwarte.

### CHAT-R71 — preflight przed odczytem w Web file pickerze (2026-09-23)

- Pliki: model `domain/storage/models/file_picker_constraints.dart`,
  `ConstrainedFilePickerPort`, `FilePickerPortImpl`, owner composera, drop
  adapter i ich testy.
- Problem: po zabezpieczeniu drag/drop webowa implementacja systemowego pickera
  nadal czytała każdy plik do `Uint8List` przed walidacją selekcji. Duże lub
  nadmiarowe pliki mogły więc zużyć pamięć mimo późniejszego odrzucenia.
- Zmiana: ograniczenia liczą też istniejący wybór i bieżący batch. Systemowy
  picker na Web odczytuje bytes tylko dla plików mieszczących się w liczbie,
  rozmiarze pliku i łącznym budżecie. Chat używa podinterfejsu
  `ConstrainedFilePickerPort`; pozostałe feature'y nadal korzystają z bazowego
  portu. Drop adapter współdzieli ten sam predykat limitów.
- Weryfikacja: constraints/drop/koordynator/Storage adapters **20/20 PASS**;
  pełny `flutter analyze --no-pub`, Web/Wasm build, macOS Debug build i
  `git diff --check` PASS. Widgetów/goldenów nie uruchamiano.
- Rzeczywisty webowy upload i zalogowany runtime pozostają do smoke testu.
  Bez zmian API, enumów transportowych, schematu i Backend.

### CHAT-R70 — preflight rozmiarów plików przeciągniętych do Chatu (2026-09-23)

- Pliki: `lib/workspaces/presentation/chat/attachments/composer/chat_attachment_drop_input_adapter.dart`,
  `lib/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_controls.dart`,
  test adaptera oraz lokalizacje EN/PL.
- Problem: adapter wykonywał równoległe `readAsBytes()` dla wszystkich plików
  przed walidacją w selekcji. Wielkie/ponadlimitowe pliki mogły alokować pamięć,
  mimo że backendowy pipeline i tak miał je odrzucić.
- Zmiana: najpierw pobierane są rozmiary; bajty czytamy tylko w granicach
  limitów per-file, pozostałej sumy i dostępnych slotów, z uwzględnieniem
  obecnej selekcji. Odrzucone pliki trafiają do istniejącego stanu walidacji
  jako nazwa+rozmiar, bez zawartości. Każdy powód odrzucenia ma osobny tekst.
- Weryfikacja: adapter **4/4 PASS**, pakiet koordynatora/adapterów **17/17**;
  `flutter analyze --no-pub`, macOS Debug build i `git diff --check` PASS.
- Bez zmian Backend/API/OpenAPI/enumów/schematu. Widget/golden i rzeczywisty
  runtime upload pozostają otwarte/odroczone. Następny krok: runtime w
  autoryzowanej rozmowie po odblokowaniu widoczności okna DevPlanner.

## 2026-09-23 — CHAT-R46: zgodny licznik uczestników grupy

W działającym stagingowym Chat nagłówek „Wydanie i testy” podawał 4 osoby,
chociaż modal członków i limit 50 (41 wolnych) potwierdzały 9 aktywnych osób.
Backend jawnie skraca listę `participants` w inboxie do maksymalnie czterech
profili i równocześnie zwraca pełny `participantCount`. Front wcześniej liczył
profile w skrócie. Zmieniono nagłówek, by wyświetlał pełne pole z API; na świeżym
macOS Debug buildzie runtime poprawnie pokazał „9 uczestników”. Test adaptera
sprawdza 2 profile / 9 łącznie (**10/10 PASS**); `flutter analyze`, macOS Debug
build i `git diff --check` obu repozytoriów PASS. Bez zmian Backend/API. Nie
wykonywano testów widgetowych/goldenów. Menu kontekstowe rozmowy również
obejrzano w runtime; globalny odbiór UI nadal OPEN.

## 2026-09-23 — ENUM-AUDIT: kontrakty JSON enumów

Front: audyt 80 wygenerowanych `EnumMap` względem enumów backendu znalazł
błędny casing `ChatNotificationPreference` (`All` było dekodowane jako `all`),
trzy błędne mapy AI oraz 26 kolejnych map JSON, które nie odzwierciedlały
PascalCase używanego przez backend. Dodano jawny alias `Digest` obok
`DailyDigest`, zgodny z backendowym aliasem wartości liczbowej. Zmieniono
deklaracje Dart, regenerowano kod i dodano regresje dekodowania/serializacji
dla Chat, powiadomień i DTO AI. Front/Backend `AGENTS.md` teraz wymagają
audytu enumów przy każdej zmianie. Backend nie zmieniony; deploy niewymagany.

`dart run build_runner build --delete-conflicting-outputs` (flaga jest
ignorowana przez zainstalowaną wersję build_runner, ale generacja zakończyła
sukcesem), oba zestawy kontraktowe **12/12 PASS**, `flutter analyze` PASS,
Front/Backend `git diff --check` PASS. Nie uruchamiano testów widgetowych ani
goldenów. Pobranie staging OpenAPI zwróciło HTTP 500; audyt oparto na mapach
JSON wygenerowanych przez json_serializable oraz definicjach i serializerze C#.

## CHAT-R45 — ochrona decyzji wklejania przed nadpisaniem (2026-09-23)

`ChatMessageComposer` serializuje odczyt schowka i blokuje nowe wklejenie oraz
„Tekst jako plik”, kiedy poprzednia karta decyzji lub przygotowanie załącznika
TXT jest aktywne. To usuwa ryzyko powiązania starego uploadu z nową treścią.
Weryfikacja: analyze PASS; zestaw jednostkowy pięciu plików (37 testów PASS);
macOS Debug build PASS; `git diff --check` PASS. Nie uruchamiano widget/golden
testów. Nie weryfikowano jeszcze aktywnej rozmowy w zalogowanym runtime.


## CHAT-R44 — spójny aktywny akcent ChatTheme (2026-09-23)

W `chat_panel_rail.dart`, `chat_panel_list_pane.dart`,
`chat_composer_rich_toolbar.dart`, `chat_emoji_picker.dart` i
`chat_selection_tile.dart` stany aktywne/zaznaczone używają zielonego
`chat.focusRing`. Niebieski `chat.linkText` zachowano dla rzeczywistych linków.
Weryfikacja: `flutter analyze` PASS, Front `git diff --check` PASS. Bez zmian
API/backendu; widget/golden testów nie uruchamiano. Zalogowany runtime i
macOS Debug build pozostają do sprawdzenia.


## CHAT-R43 — poprawka komunikatu pustej skrzynki (2026-09-23)

Screenshot potwierdził, że puste Archiwum pokazywało „Twoje aktywne rozmowy
pojawią się tutaj”. Dodano wspólny mapper filtrowanych empty state oraz
lokalizacje dla All/Unread/Direct/Groups/Channels/Mentions/Archived po polsku i
angielsku; oba widoki inboxa używają mappera. Mapper unit tests **2/2 PASS**,
`flutter gen-l10n`, `flutter analyze` i `flutter build macos --debug` PASS. Po
zamknięciu starej instancji świeży build pokazał błąd logowania; przycisk
otworzył zewnętrzny provider. Nie wpisano danych, więc poprawiony tekst nie
został jeszcze obejrzany na żywo. Brak zmian Backend/API/migracji/deployu.
Widgetów/goldenów nie uruchamiano. Następny krok: stabilna sesja, ponowny
odbiór Archiwum i aktywnej rozmowy.

## CHAT-R47 — czyszczenie wyboru po zmianie sekcji (2026-09-23)

Runtime przy 800×630 odtworzył błąd: zakładka Kanały miała pustą listę, ale
panel po prawej dalej pokazywał poprzednio wybraną grupę „Wydanie i testy”.
`_ChatSectionFilterSync` czyści teraz wybór przy przejściu między sekcjami,
zachowując zapamiętane filtry skrzynki.

Weryfikacja: `flutter analyze` PASS; macOS Debug build z API
`https://devnote.flutter-dev.pl` PASS. Po restarcie otwarto panel przez belkę,
a następnie Kanały: pusta lista i placeholder „Wybierz rozmowę” pojawiły się
zamiast starej grupy. Nie otwierano wiadomości i nie zmieniano danych staging.
Stan poprzedniej sekcji inicjalizuje się teraz z `ChatPanelSectionCubit`, więc
pierwsze przejście po przywróceniu rozmowy/deep linku również czyści wybór.
Weryfikacja po tej korekcie: `flutter analyze` PASS, testy logiki selection +
section **10/10 PASS**, macOS Debug build PASS. Widget/golden tests odroczone
zgodnie z instrukcją użytkownika. Backend bez zmian i bez deployu.

## 2026-09-23 — CHAT-R42: runtime shell/Chat i korekta tapety

Obejrzano działający shell Files/Tasks i panel Chat otwarty w Archiwum. Panel
pokazuje rail, listę Archiwum i pustą kolumnę rozmowy. Próby kliknięcia i
przejścia do inboxa zwracały `noWindowsAvailable`; nie zweryfikowano aktywnej
rozmowy ani problemu z małym obrazem. Poprzednia notatka o braku renderera była
błędna: `lib/app/shell/devplanner_shell_layout.dart` maluje
`assets/images/bg.jpeg` (3440×1440) przez `BoxFit.cover`, a panel jest nad
pełnym shellem. Dokumentacja skorygowana w planie Front i Backend; bez zmian
kodu/API/deployu. `git diff --check` PASS; analizę i testy pominięto, bo pakiet
zmieniał tylko dokumentację. Następny krok: stabilna interakcja z inboxem,
aktywna rozmowa i reprodukcja problemu kadru. Widgety/goldeny nadal czekają na
akceptację wyglądu.

## 2026-09-23 — CHAT-R28: opis przycisku listy członków

Ikona `group_add` w nagłówku rozmowy otwiera listę członków, ale używała
`chatMembersActions` („Akcje członka”), przeznaczonego dla menu pojedynczego
uczestnika. Dodano osobny lokalizowany klucz `chatMembersOpen` („Członkowie i
dodawanie osób”; EN „Members and add people”) i zmieniono tylko tooltip
nagłówka.

Weryfikacja: `flutter gen-l10n`, `flutter analyze`, `flutter build macos --debug`
i `git diff --check` PASS. Backend/API bez zmian. Runtime tooltip pozostaje
nieobejrzany, Mac zablokowany dla CUA.

## 2026-09-23 — CHAT-R27: usunięcie statusu w chwili wygaśnięcia

Timer w `ChatPeerStatusLine` czyści teraz lokalny status przed ponownym
żądaniem REST. Gdy żądanie po terminie wygaśnięcia zawiedzie, stara etykieta
nie zostaje na ekranie. Odświeżenie API nadal uzgadnia bieżący status.

Weryfikacja: `chat_port_adapters_test.dart` **16/16 PASS** (w tym polityka
`isExpiredAt`), `flutter analyze`, `flutter build macos --debug` i
`git diff --check` PASS. Nie uruchamiano testów widgetowych, więc sam timer
pozostaje bez weryfikacji widgetowej. Brak zmian Backend/API.

## 2026-09-23 — CHAT-R26: większy cel szybkiej reakcji

Kontrolka reakcji w pasku nad dymkiem miała 28×28 px. Zwiększono jej obszar do
36×36 px oraz ikonę do 18 px; menu reakcji i akcji wiadomości zachowuje tę samą
geometrię i logikę.

Weryfikacja: `flutter analyze`, `flutter build macos --debug` oraz
`git diff --check` PASS. Render hover/touch pozostaje niepotwierdzony, bo CUA
nadal nie może odczytać zablokowanego ekranu Maca.

## 2026-09-23 — CHAT-R25: etykieta piszącego w rozmowie 1:1

`_participantLabels()` celowo zwracało pustą mapę dla DM, by nie dodawać
prefiksu autora do dymków. Ta mapa była jednak współdzielona ze
`ChatTypingIndicator`, więc w DM pokazywał się generyczny tekst. Dodano
`_typingParticipantLabels()`: mapuje ID rozmówcy na nazwę z inboxa tylko dla
wskaźnika pisania.

Weryfikacja: test `chat_typing_label_test.dart` **7/7 PASS**, `flutter analyze`,
`flutter build macos --debug` i `git diff --check` PASS. Bez zmian Backend/API.
Nie uruchamiano widgetów/goldenów; Mac pozostaje zablokowany dla CUA.

## 2026-09-23 — CHAT-R24: aktualizacja regresji geometrii panelu

Istniejący widget test overlayu nadal zakładał panel startujący z 30% i
zwijanie po ruchu odpowiednim dla szerokości 420 px. Asercje zaktualizowano do
75%, maksimum 1120 px, modalności poniżej 960 px, braku uchwytu w overlayu
modalnym oraz dłuższego gestu zwijania. To korekta oczekiwań testu źródłowego,
nie jego uruchomienie.

Weryfikacja: `flutter analyze` i `git diff --check` PASS. Widget test pozostaje
odroczony do akceptacji UI, zgodnie z decyzją użytkownika.

## 2026-09-23 — CHAT-R23: odświeżanie statusu po wygaśnięciu

`ChatPeerStatusLine` wykrywa już wygasły status i ukrywa go. Dla aktywnego
statusu z `expiresAtUtc` ustawia timer, który ponownie pobiera wartość z API;
timer jest anulowany przy zmianie rozmówcy i przy dispose. Zapobiega to
pozostawieniu starego emoji/tekstu/DND w długo otwartej rozmowie.

Weryfikacja: adapter/statusy **21/21 + 5/5 PASS**, `flutter analyze`,
`flutter build macos --debug` PASS. Brak zmian Backend/API. Brak odbioru
wizualnego — CUA nadal zgłasza zablokowany Mac. Widgetów/goldenów nie uruchamiano.

## 2026-09-23 — CHAT-R22: poprawki statusu DM i dostępności członków

`ChatPeerStatusLine` dopisuje serwerowe DND do etykiety, a odpowiedzi z REST
sprawdza względem generacji żądania, więc wynik poprzedniego rozmówcy nie
nadpisze stanu po szybkiej zmianie konwersacji ani po dispose. Nagłówek pokazuje
akcję członków tylko dla rozmowy innej niż Direct i dostępnego portu członków.

Weryfikacja: `flutter analyze`, `flutter build macos --debug` i
`git diff --check` PASS. Bez zmian Backend/API. Mac nadal jest zablokowany dla
CUA, więc nie potwierdzono renderu; widgetów/goldenów nie uruchamiano.

## 2026-09-23 — CHAT-R21: domyślnie pełny układ komunikatora

Domyślne 30% powodowało, że panel nie mieścił inboxa i rozmowy obok siebie.
Zmieniono cel na 75% szerokości z minimum 734 px (minimum rail + inbox +
rozmowa + uchwyt) oraz limitem 1120 px; próg pełnoekranowego overlayu ustawiono
na 960 px. Przypięcie nadal jest dozwolone tylko wtedy, gdy aplikacja zachowuje
co najmniej 480 px treści. To bezpośrednia korekta względem późniejszych uwag
użytkownika o potrzebie pełnego komunikatora.

Weryfikacja: `chat_panel_size_test.dart` **7/7 PASS**, `flutter analyze`,
`flutter build macos --debug` i `git diff --check` PASS. CUA nadal zgłasza
zablokowany Mac, więc render niepotwierdzony. Bez testów widgetowych/goldenów
przed akceptacją wyglądu.

## 2026-09-23 — CHAT-R20: upload załączników Chat w Web/BFF

`DevPlannerApp` składa jedną `DevPlannerStorageComposition` i przekazuje tę
samą sesyjną `StorageRepository` do routera i `DevPlannerStandaloneRuntime`.
Webowy BFF może więc autoryzować żądanie ticketu i finalizacji przez cookie/CSRF;
upload bajtów używa osobnego `PresignedUploadTransport`, który dostaje wyłącznie
krótkotrwały URL i nigdy nie otrzymuje cookie, CSRF ani tokenu desktopowego.
Ścieżka nie zmienia możliwości uploadu w module Files. Menu „tekst jako plik” i
karta długiego wklejenia blokują tę akcję, gdy brak gotowego koordynatora uploadu.

Weryfikacja: test kompozycji BFF/fail-closed oraz adaptera uploadu **11/11
PASS**; `flutter analyze`, `flutter build web --debug
--no-tree-shake-icons --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl`,
`flutter build macos --debug` i `git diff --check` PASS. Preflight stagingowego
Storage dla `Origin: https://devnote.flutter-dev.pl`, metody `PUT` i nagłówka
`content-type` zwrócił HTTP 204 z dozwolonym originem i metodą. Nie wykonano
pełnego uploadu z przeglądarki, bo runtime zatrzymuje się na loginie BFF; ekran
macOS pozostaje zablokowany. Bez zmian Backend/API; widgetów/goldenów nie
uruchamiano.

## 2026-09-23 — CHAT-R19: zakres kontekstu akcji wiadomości

Rootowy `AppContextMenu` prezentuje trasę poza lokalnym drzewem rozmowy.
Callbacki reakcji oraz kopiowania zaznaczenia dostawały wcześniej kontekst tej
trasy, przez co mogły nie znaleźć lokalnego Cubita/`Actions`. Menu przekazuje
teraz do handlera kontekst przycisku, który je otworzył. Zmiana tylko we
Froncie; backend i kontrakt bez zmian.

Weryfikacja: `flutter analyze` PASS, `flutter run -d web-server` skompilował
aplikację, `flutter build macos --debug` PASS, `git diff --check` PASS po
aktualizacji dokumentacji. Zrzut przeglądarki pokazuje ekran „Przejdź do bezpiecznego logowania”
i URL `/login?returnTo=/workspaces`; nie ma aktywnej sesji, więc ekran czatu ani
akcje nie zostały wizualnie sprawdzone. macOS jest zablokowany. Widgetów i
goldenów nie uruchamiano zgodnie z decyzją użytkownika. Następny krok: obejrzeć
panel po uzyskaniu dostępnej, autoryzowanej sesji i zweryfikować reakcje oraz
kopiowanie zaznaczenia na żywym widoku.

## 2026-09-23 — CHAT-R18: pola formularzy Chat

Ujednolicono pola wstawiania kodu, wyszukiwarki emoji, statusu, selektora
powiadomień per rozmowa, dodawania linku i edycji wiadomości. Wszystkie używają
typografii/powierzchni ChatTheme, borderów i focus ringa; kod ma styl monospace.

Walidacja Front: `flutter analyze` i `flutter build macos --debug` PASS.
Widgetów/goldenów nie uruchamiano; render wymaga odblokowania Maca.

## 2026-09-23 — CHAT-R17: wycięcie legacy listy

Usunięto `ChatDrawerCubit`, jego stan, test i publiczny wrapper side-sheeta.
Panel tworzy teraz skrzynkę tylko z właściwej kompozycji hosta, więc nie wykonuje
równolegle drugiego odczytu przez stare repozytorium. Gdy skrzynki brak, używa
jawnego stanu niedostępności `ChatPanelListPane`; zniknęła zapasowa lista
`ListTile` z `scopeKey`. Tytuł rozmowy w nagłówku ma lokalizowany neutralny
fallback zamiast identyfikatora technicznego.

Walidacja Front: `flutter analyze` całego repo i `flutter build macos --debug`
PASS; `git diff --check` PASS. Bez testów widgetowych/goldenów. Mac jest
zablokowany, więc nie przeprowadzono wizualnego smoke testu.

## 2026-09-23 — CHAT-R16: race w trwałej kolejce

W ChatPendingSendStoreImpl operacje read-modify-write (save, remove,
clearForUser) są teraz serializowane per userId. Wcześniej save intencji
i usunięcie po potwierdzeniu mogły równolegle odczytać stary stan keychaina;
spóźniony zapis zostawiał potwierdzoną wiadomość jako oczekującą po restarcie.
Odczyt przywracanych intencji także czeka na zakończenie wcześniejszych zmian.
Ten sam porządek zapobiega przywróceniu intencji po wylogowaniu.

Walidacja Front: test trwałości kolejki **9/9 PASS**, flutter analyze bez
problemów, flutter build macos --debug PASS, git diff --check Front i
Backend PASS. Nie uruchamiano widgetów ani goldenów; Mac jest zablokowany.
Backend i kontrakt API bez zmian.

## 2026-09-23 — Wiersze wątku i załączników w ChatTheme

Usunięto pozostałe `ListTile` z odpowiedzi wątku i listy wybranych załączników.
Wątek ma kompaktowy wiersz z zachowanym kopiowaniem oraz menu kontekstowym;
załącznik ma kartę z elipsą długiej nazwy, lokalizowanym statusem i osobną akcją
usunięcia. `flutter analyze` czysty; świeży build macOS Debug zakończony osobno.
Nie uruchamiano testów widgetowych. Nadal brak ręcznego oglądu UI z powodu blokady
Maca.

## 2026-09-23 — Wiersze rewizji, przekazania i nazwy dyskusji

W dialogach akcji usunięto domyślne `ListTile` z historii rewizji i wyboru
rozmowy docelowej. Wiersze mają powierzchnię, typografię, odstępy oraz ripple
z ChatTheme; cel przekazania zachowuje tytuł i ellipsis podglądu. Panel dyskusji
korzysta z ChatTheme dla separatora, nagłówka, cytowanej wiadomości i pola nazwy.
`flutter analyze` czysty, cubity akcji i wątków **12/12 PASS**, build macOS
Debug PASS; brak testów widgetowych/goldenów i nadal brak ręcznego oglądu.

## 2026-09-23 — Długie linki i długie treści wiadomości

Renderer wstawia U+200B jako niewidoczne miejsce łamania wyłącznie w linkach
dłuższych niż 40 znaków. Recognizer i adres docelowy pozostają oryginalne.
Dymki zwijają wiadomości powyżej 1200 znaków także bez `\n`, z przyciskiem
rozwinięcia. `flutter analyze` czysty; rich-text, plain-text links, long-paste i
grouping **32/32 PASS**. Build macOS Debug PASS; nie uruchamiano widgetów ani
goldenów. Ręczny render wymaga odblokowania Maca.
Reguły przeniesiono do testowalnego `ChatMessageDisplayPolicy`; nowe testy
jednostkowe **6/6 PASS**, analyze i świeży build Debug PASS.

## 2026-09-23 — Geometria popovera i breakpoints panelu Chat

`AppContextMenuPositionDelegate` ogranicza teraz szerokość także do viewportu
minus marginesy; wcześniej ograniczona była tylko wysokość, więc `Nowy czat`
(max 420 px) mógł wyjść poza węższe okno. Czysta polityka geometrii ma testy dla
390 px, szerokości 200 px, niskiego viewportu oraz viewportu mniejszego niż
margines. Próg trzech kolumn wynika teraz jawnie z minimów 56 + 304 + 360 + 2 px
separatorów = 722 px; 760 px jest progiem modalności w hoście, a nie kolumn.
Analyze czysty, testy geometrii i polityki treści **15/15 PASS**, build Debug
PASS; bez testów widgetowych/goldenów.

## 2026-09-23 — CHAT-R14: root host i ChatSurfaceDialog

- Usunięto bezpośrednie `showDialog` z `ChatPersonCard`, emoji pickera, dialogu
  linku i podglądu załączonego obrazu. Szybkie reakcje używają wrappera
  `DevPlannerModalHost.showBottomSheet`; wspólny root stack porządkuje Escape,
  focus i warstwę nad panelem.
- Karta osoby ma avatar w nagłówku, rolę w podtytule, status i błąd w treści,
  a akcje zamknięcia/napisania w stopce `ChatSurfaceDialog`. Picker emoji dostał
  tę samą powierzchnię, wyszukiwanie w polu ChatTheme i ograniczoną wysokość
  siatki. Uchwyt/kształt/bariera bottom sheet są konfigurowane przez wspólny host.
- Pliki: `devplanner_modal_host.dart`, `chat_person_card.dart`,
  `chat_emoji_picker.dart`, `chat_format_actions.dart`,
  `chat_message_attachments.dart`, `chat_message_action_menu.dart`.
- Walidacja: `flutter analyze` bez problemów; logika emoji/formatowania/linków
  **40/40 PASS**; macOS Debug build PASS; `git diff --check` PASS. Bez
  widgetów/goldenów. Zbudowany macOS nie został obejrzany: CUA zgłasza Mac
  zablokowany.
- Następny krok: po odblokowaniu Maca obejrzeć trzy zmienione powierzchnie
  i poprawić geometrię/kontrast z realnego renderu.

## 2026-09-23 — CHAT-R12: wynik wyszukiwania poza inboxem

- Wynik wyszukiwania nie jest już wyłączany, gdy jego rozmowy nie ma w aktualnie
  załadowanych pozycjach inboxa. `ChatDrawer` używa kopii skrzynki, gdy jest
  dostępna; w przeciwnym razie pobiera szczegóły przez
  `ChatConversationRepository.getConversation(id)`, czyli ścieżkę REST z ACL.
  Odmowa/404 czyści stare trafienia i wyświetla neutralny komunikat bez
  ujawniania rozmowy; błąd transportu zostawia wyniki otwarte do ponowienia.
- Dla niecache'owanej grupy/kanału rola bieżącego użytkownika jest pobierana
  osobno z repozytorium członków. Wybór zapisuje `messageId`, a istniejący
  `ChatConversationCubit.ensureTargetLoaded` otwiera okno wokół starej wiadomości.
- Kontrakt callbacku `ChatSearchView` obsługuje stan otwierania i blokuje
  podwójne kliknięcie; wiersz używa nazwy z lokalnego inboxa lub bezpiecznej
  nazwy z hitu, nigdy technicznego ID jako nazwy rozmowy.
- Walidacja Front: `flutter analyze` bez problemów; test repozytorium i
  wyszukiwania/członków **21/21 PASS**; `flutter build macos --debug` PASS;
  `git diff --check` PASS. Nie uruchamiano testów widgetowych/goldenów.
- Otwarty odbiór: smoke test na rozmowie poza pierwszą stroną, przewinięcie do
  starego wyniku i odmowa ACL; Mac nadal jest zablokowany.

## 2026-09-22 — CHAT-R14: wspólna powierzchnia dialogów

- Dodano `ChatSurfaceDialog`, którego tło, obramowanie, promień, typografia,
  nagłówek i stopka korzystają z `ChatTheme` zamiast przypadkowych domyślnych
  powierzchni Material. Przeniesiono tworzenie rozmowy, edycję i rewizje
  wiadomości, usuwanie/przekazywanie, ustawienia czatu, ustawienia wyciszenia,
  wstawianie bloku kodu/linku oraz potwierdzenie archiwizacji.
- W naprawionej migracji rewizji analizator ujawnił nullable access i nadmiarowy
  parametr; poprawiono. `flutter analyze` — 0 problemów. Testy skrzynki i
  realtime **18/18 PASS**. `flutter build macos --debug` — PASS. `git diff
  --check` — PASS.
- To nie zamyka R14: statusy, karta osoby i picker emoji nadal mają własne
  powierzchnie; trzeba je porównać wizualnie i ujednolicić tam, gdzie odstają.
  Mac jest zablokowany, więc nie przeprowadzono oglądu działającego UI.
  Testów widgetowych ani goldenów nie uruchamiano przed akceptacją wyglądu.
- Kontynuacja: podgląd zdjęcia został przeniesiony na `ChatSurfaceDialog`, a
  szybkie reakcje zachowują teraz jawne powierzchnie `ChatTheme` w arkuszu.
  Weryfikacja po tej części: `flutter analyze` bez problemów, załączniki i akcje
  wiadomości **13/13 PASS**, `flutter build macos --debug` PASS,
  `git diff --check` PASS. To są testy logiki i kompilacji, nie dowód renderu.
- Kontynuacja 2: lista skrzynki i wiersze rozmów przestały pobierać powierzchnie,
  typografię, filtr-chip, szkic i badge nieprzeczytanych z domyślnego
  `ColorScheme`; używają ról i stylów `ChatTheme` (zachowana semantyka i
  dostępne akcje). Pełna analiza Frontu przechodzi; `chat_inbox_cubit_test.dart`
  **11/11 PASS**, `flutter build macos --debug` PASS i `git diff --check` PASS.
  Odbiór kontrastu/light-dark i wizualnego rytmu nadal wymaga działającego,
  odblokowanego UI.
- Kontynuacja 3: wyniki wyszukiwania wiadomości dostały własne wiersze z awatarem
  lub ikoną rozmowy, nazwą, autorem, czasem, fragmentem wiadomości i znacznikiem
  wzmianki. Pole, puste/błędne stany i wyniki używają `ChatTheme`; akcje kliknięcia,
  długiego przytrzymania i menu kontekstowego pozostały podłączone. `flutter analyze`
  bez problemów, `g5_search_and_members_test.dart` **12/12 PASS**, build macOS
  PASS i `git diff --check` PASS. Nie uruchamiano `testWidgets` ani goldenów.
- Kontynuacja 4: arkusz członków i podwidok dodawania osób używają jawnych
  wierszy z awatarami, rolami/statusami i menu moderacji oraz wyszukiwarki,
  chipów i checkboxów opartych na `ChatTheme`; wynik niepodłączonego konta i
  błędy też używają typografii i kolorów komunikatora. `flutter analyze` bez
  problemów, `g5_search_and_members_test.dart` **12/12 PASS**, build macOS PASS,
  `git diff --check` PASS. Testy widgetowe i goldeny nadal odłożone do akceptacji.
- Kontynuacja 5: podpowiedzi `@` mają powierzchnię z cieniem i `ChatTheme`,
  wiersze kandydatów z awatarami/etykietą/loginem, widoczny aktywny wybór oraz
  wyróżnioną pozycję `@all`; błąd, retry i puste stany nie korzystają już z
  globalnego `ColorScheme`. `flutter analyze` bez problemów, test kontrolera
  wzmianki + codec **23/23 PASS**, build macOS PASS i `git diff --check` PASS.
  Widgetów nadal nie uruchamiano.

## 2026-09-22 — CHAT-INBOX-REALTIME: invalidacja poza panelem

- Dodano sesyjne połączenie do Chat Hub i `ChatInboxCubit` współdzielony przez
  host panelu. `chat.inbox.changed` powoduje odczyt pierwszej strony oraz
  serwerowego badge'a przez REST; pierwszy connect i reconnect też uzgadniają
  stan. Działa przy zamkniętym panelu i nie zależy od powiadomień.
- Walidacja: testy inbox + realtime **18/18 PASS**, `flutter analyze` bez problemów,
  `flutter build macos --debug` PASS, `git diff --check` PASS. Backend testy
  huba i utworzenia rozmowy **6/6 PASS**, build i format verify PASS.
- GUI Mac nadal zablokowane, więc nie ma dowodu ze smoke testu dwóch sesji ani
  rzeczywistego renderu; widgety i goldeny pozostają odroczone do akceptacji.
- Review R13 zaktualizowane po inspekcji kodu: aktywna historia ma autora/awatar
  dla grup, godzinę, etykietę edycji oraz serwerowy status dostawy/odczytu i retry
  błędu. Wymaga to jeszcze oglądu przy rzeczywistym rozmiarze panelu.

## 2026-09-22 — CHAT-INBOX-WIRE i zwężanie panelu

Pliki: `lib/workspaces/data/shared/enums/chat_enums.dart`, `lib/workspaces/data/chat/models/chat_models.g.dart`, `lib/workspaces/data/chat/api/chat_api.dart`, `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart`, `lib/app/shell/overlays/devplanner_global_panels_host.dart`, test kontraktu skrzynki i test widgetowy hosta. Backend ma `JsonStringEnumConverter()` bez camelCase, więc odpowiedź zawiera `Direct`/`Global`; poprzedni parser oczekiwał `direct`/`global` i zamieniał błąd dekodowania na ogólne `chat.inbox.load_failed`. Retrofit dekoduje już po interceptorach Dio, dlatego dodano bezpieczny logger błędów parsowania. Row panelu dostaje szerokość tweena ograniczoną aktualnym oknem.

Weryfikacja: `flutter test test/workspaces/data/chat/chat_inbox_wire_contract_test.dart test/workspaces/data/chat/chat_inbox_repository_impl_test.dart` 10/10 PASS; celowana analiza czterech plików 0 problemów; `dart format --set-exit-if-changed` i `git diff --check` PASS. Test układu przed poprawką odtwarzał overflow 175 px, po poprawce 10/10 PASS w izolowanym checkoutcie. Stagingowe API `/health/ready` jest zdrowe, anonimowe `/api/v1/chat/inbox` zwraca prawidłowe 401. Pozostaje ręczna próba po przebudowaniu uruchomionej aplikacji; Frontu nie wdrażano ani nie restartowano z uwagi na równoległe prace.

## 2026-09-22 — CHAT-COMPLETION: plan pełnego podłączenia funkcji

- [x] Audyt tras Chat, wzmianek, snippetów, polityki załączników, Quill i geometrii shellu; [plan F0–F6](../../Backend/docs/global-chat-completion-plan-2026-09-22.md).
- [ ] F0–F6 pozostają do realizacji/ponownej weryfikacji względem bieżącego kodu. Dokument nie deklaruje napraw.
- Priorytety: kompozycja inboxa, kontrakt uczestników/publikacji, dodawanie osób, status w panelu, wzmianki, pliki/zdjęcia, kod i opcjonalny pełny Quill, historia/realtime, przypięcie i tapeta.
- Potwierdzono: pin znika przez compact panelu; padding hosta zmniejsza shell wraz z tapetą. Rozdzielić liczbę kolumn od możliwości przypięcia i rezerwację contentu od pełnego tła.
- Zmieniono tylko dokumentację. Testów aplikacji ani deployu nie uruchamiano. Testy partiami; widgety/goldeny dopiero po akceptacji wyglądu. Następny krok: F0 oraz geometria F6, następnie pozostałe piony.

## 2026-09-21 — CHAT-REVIEW-UI: korekta według referencji WhatsApp

- [x] Spisano [plan UI i napraw po review](global-chat-ui-remediation-2026-09-21.md): układ rail/lista/rozmowa, popover Nowy czat, grupy, kanały, ogłoszenia i rejestr R01–R14.
- [ ] Naprawy R01–R14, dodatkowe ryzyka, pakiety A–E i odbiór UI pozostają otwarte. Wcześniejsze wpisy G3–G7 opisują części implementacji, nie potwierdzają gotowości aktywnego panelu.
- Decyzja użytkownika: rozpoznawalna struktura WhatsApp w prawym panelu, komponenty i kolory DevPlanner. Testy partiami; widgety i goldeny dopiero po akceptacji wyglądu.
- Zmienione wyłącznie dokumenty: nowy plan korekt w Backend, odsyłacz/status planu bazowego oraz plan/handoff obu repo. Bez implementacji i deployu; testów aplikacji w tym pakiecie nie uruchamiano.
- Dalsza decyzja użytkownika: UI ma osobne zakładki Pliki i Zadania / Kanban, przygotowane pod rozmowy widoczne po dodaniu/wzmiance z respektowaniem ACL; teraz projekt i stany UI, integracja później (§2.7 planu korekt).
- Następny krok: pakiet A (ACL/liczniki/DM), następnie działający szkielet i kreator z pakietu B.

### 2026-09-21 — CHAT-G4 (domknięcie): serwerowy szkic rozmowy

Zakres: domknięcie luki z poprzedniego wpisu — szkic był wyłącznie lokalny, więc `isDraft`/`draftText` w skrzynce pozostawało puste, mimo że kontrakt je zwraca.

Pliki (Front, nowe): `lib/workspaces/domain/chat/composer/chat_server_draft_repository.dart`, `lib/workspaces/data/chat/repositories/chat_server_draft_repository_impl.dart`, `test/workspaces/data/chat/chat_server_draft_repository_test.dart`. Zmienione: `chat_composer_cubit.dart` (port serwerowy, preferencja świeższego szkicu z serwera, zapis lokalny **i** serwerowy, jedno ponowienie po konflikcie wersji), `chat_message_composer.dart`, `chat_api_error_mapper.dart` (`chat.drafts.load_failed`, `chat.drafts.save_failed`), `global_chat_composition.dart`, `devplanner_standalone_runtime.dart`, `devplanner_global_panels_host.dart` (porty szkicu i kolejki nad oba panele), `repositories.dart`.

Decyzje: lokalny secure storage zostaje jako kopia offline, a serwer jest źródłem prawdy dla wskaźnika szkicu w skrzynce. `restore()` preferuje szkic z serwera, bo jest świeższy i wspólny dla urządzeń; brak sieci nie gubi treści, bo zapis lokalny wykonuje się pierwszy. Wersja szkicu jest prowadzona po stronie cubita, a konflikt (ten sam użytkownik na dwóch urządzeniach) rozwiązuje jedno ponowienie po odświeżeniu wersji — bez pętli i bez kasowania treści użytkownika.

Walidacja (uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1467 (1460 przed tym domknięciem, +7 testów mapowania szkicu i zachowania composera); `git diff --check` — PASS; kontrakt OpenAPI↔Retrofit bez zmian (Swagger 463, Flutter 425).

Pozostaje otwarte w G4: powierzchnie UI (menu edycji/usuwania, forward, wskaźnik dostawy/doręczenia, pokazanie pending/failed/retry/cancel) należą do G5 i G7, a test widgetowy stabilnych kluczy wiersza jest odroczony razem z goldenami do akceptacji wyglądu.

## 2026-09-22 — CHAT-PANEL-UX: 30% okna na starcie, zwijanie gestem i niezawodne zamykanie

Zakres: trzy uwagi użytkownika z uruchomionej aplikacji — nie dawało się zamknąć okna czatu, panel powinien zajmować około 30% szerokości okna na starcie, a przeciągnięcie uchwytu poza limit powinno zwijać panel animacją. Wszystkie zmiany są w Front.

Domyślna szerokość: `ChatPanelSizeController` startuje z `defaultWidthFraction = .3` szerokości okna i idzie za oknem, dopóki użytkownik nie użyje uchwytu (`hasCustomWidth`); zakres uchwytu to teraz 320–1120 px, a zapamiętana szerokość jest nadal ograniczana do okna po jego zmianie. To zmienia §2.1 planu korekty (było „domyślnie 960, regulacja 760–1120”): próg 760 px nadal decyduje o układzie trzech kolumn, ale nie jest już minimum panelu, bo przy 30% okna panel startuje jako rail + jedna kolumna. Uchwyt jest widoczny zawsze, gdy panel nie zajmuje całego okna — to jedyna droga, żeby poszerzyć go do trzech kolumn.

Modalność zależy teraz od szerokości **okna**, nie panelu: przy wąskim oknie panel zajmuje całą przestrzeń roboczą i przyciemnia treść, a przy szerokim jest wąskim panelem obok aplikacji, która pozostaje klikalna (test sprawdza kliknięcie w treść przy otwartym panelu). Wcześniej 30% startowe czyniłoby panel modalnym z przyciemnieniem, czyli wracałby zarzut z pierwszego review.

Zwijanie gestem: przeciągnięcie uchwytu w prawo (zwężanie) nie schodzi poniżej minimum, ale nadwyżka ruchu jest liczona; gdy przekroczy 5% szerokości okna (`collapseDragFraction`), panel zamyka się animacją 220 ms (`TweenAnimationBuilder`), a samo dojście do minimum nie zamyka go przypadkiem. Ruch w prawo kasuje kandydata na zwinięcie, więc gest jest jednoznaczny.

Zamykanie: `DevPlannerPanelsController` ma `toggleChat`/`toggleNotifications`, a przyciski w belce ich używają — ponowne naciśnięcie chowa panel (potwierdzone testem). Escape działa teraz z całego shellu: skrót wisi na warstwie (`CallbackShortcuts` nad treścią aplikacji razem z panelem), więc zamyka panel także wtedy, gdy focus jest w treści aplikacji; modal jest bliżej focusu, więc jego własne Escape nadal wygrywa. Przycisk × w nagłówku kolumny listy zostaje jako widoczna droga zamknięcia.

Pliki (Front): `lib/workspaces/presentation/chat/shell/layout/chat_panel_size.dart` (30% okna, zakres 320–1120, `beginResize`/`endResize` i próg zwijania), `lib/foundation/presentation/devplanner_panels.dart` (`toggleChat`, `toggleNotifications`), `lib/app/shell/devplanner_shell_layout.dart` (belka używa przełączników), `lib/app/shell/overlays/devplanner_global_panels_host.dart` (modalność od szerokości okna, uchwyt dostępny także przy jednej kolumnie, animowane zwijanie przez notifier, Escape na całej warstwie).

Testy (nowe w `test/app/shell/overlays/devplanner_modal_layer_test.dart`): panel startuje z 30% okna i nie blokuje aplikacji; ponowne naciśnięcie przycisku w belce chowa panel; Escape chowa panel, gdy focus jest w aplikacji; przeciągnięcie uchwytu poza minimum zwija panel animacją (w trakcie animacji panel jest jeszcze widoczny, po `pumpAndSettle` znika); krótkie przeciągnięcie nie zamyka panelu i szerokość podąża za uchwytem.

Walidacja (uruchomione, Front): `flutter analyze` — 0 problemów; `flutter test` — PASS 1522 (+4 testy panelu/gestu); `flutter build web --wasm` — PASS; `git diff --check` — PASS.

Interpretacja do potwierdzenia: „przeciągnięcie poniżej 5%” zrealizowałem jako nadwyżkę przeciągnięcia poza minimum większą niż 5% szerokości okna (gest „odciągnij i puść”), a nie jako szerokość panelu poniżej 5% okna — panel nie zniknie w połowie gestu. Jeśli intencją była szerokość panelu schodząca poniżej 5% okna (panel zwija się dopiero przy prawie zerowej szerokości), to zmiana progu jest jednolinijkowa.

Następny krok: P1#3 (realtime skrzynki i badge) i P2#7 (doładowanie historii, skok po ID, odczyt tylko widocznych wiadomości).

## 2026-09-22 — CHAT-REMEDIACJA: naprawy po review UI (6 ustaleń, w tym 2× P1)

Zakres: ustalenia z review nowego panelu i popovera. Wszystkie dotyczyły kodu dodanego w poprzednim pakiecie, więc naprawy są w Front; backendu nie ruszano.

P1 „przełączenie rozmowy może wysłać wiadomość do poprzedniej”: `ChatPanelConversation` był bezstanowy i bez klucza, więc Flutter zachowywał providery i `ChatConversationCubit` rozmowy A, gdy nagłówek pokazywał już B, a dzierżawa realtime powstawała w `build` (nowe połączenie i zgubione subskrypcje przy każdej przebudowie). Naprawa: panel jest `StatefulWidget` z `keyFor(conversationId)` używanym przez panel (gałąź odtwarza się razem z Cubitami), dzierżawa powstaje w `initState` i należy do widoku (widok tworzy ją raz i zwalnia w `dispose`; `didUpdateWidget` wymienia ją przy zmianie rozmowy, gdy wywołujący nie dał klucza), a `ChatConversationCubit` nie jest już właścicielem cudzej dzierżawy. Test `chat_panel_conversation_identity_test.dart`: „zmiana rozmowy wymienia Cubit razem z identyfikatorem” (bez klucza Cubit zostaje przy A — kontrola mutacyjna to potwierdza) oraz „dzierżawa realtime powstaje raz na rozmowę i nie wycieka” na prawdziwej `WorkspaceChatRealtimeFactory` (`openConversationCount` 1 → 1 → 0; po przeniesieniu tworzenia dzierżawy do `build` licznik zostaje na 1, czyli połączenie nigdy się nie zamyka).

P1 „tworzenie DM z nowego popovera kończy się błędem”: popover startuje bez wyboru typu, a `startDirectWith` nie ustawiał `kind`, więc `submit()` czytał `state.kind!` i kończył wyjątkiem „Null check operator used on a null value”. Naprawa: `startDirectWith` sam ustawia `ChatConversationKind.direct` (kontrakt metody to „rozmowa 1:1 z tą osobą”). Test w `chat_creation_cubit_test.dart`: „klik osoby działa bez wcześniejszego wyboru typu (popover «Nowy czat»)”; kontrola mutacyjna po usunięciu ustawienia rodzaju odtwarza dokładnie ten wyjątek.

P2 „poprawka pustej strony nie działa w nowym UI”: kolumna listy pokazywała „brak wyników” bez stopki i bez drogi do dalszych stron. Naprawa: przy pustej stronie z kursorem komunikat mówi wprost, że strona nie zawiera dostępnych rozmów, a są kolejne, i daje akcję doładowania (przy trwającym pobraniu wskaźnik); to samo dotyczy lokalnej frazy, która odfiltrowała całą pobraną stronę. Nowy klucz ARB `chatInboxEmptyPageMore`.

P2 „zniknęło wejście do wyszukiwania wiadomości”: wróciła ikona w nagłówku kolumny listy (klucz `chat-panel-search`), która otwiera `ChatSearchCubit.open()`; pole w liście nadal filtruje wyłącznie nazwy już pobranych rozmów i to rozróżnienie jest opisane w kodzie.

P2 „zakładki nie działają poprawnie w compact przy otwartej rozmowie”: układ zawsze pokazywał rozmowę, więc kliknięcie Plików czy Kanałów nie dawało efektu, dopóki użytkownik nie cofnął się z rozmowy. Naprawa: `ChatPanelSectionCubit` prowadzi teraz stan `(section, showList)`, rail ustawia `showList`, a wybór rozmowy (lista, wyszukiwanie, popover, zakładka) przechodzi przez jedną metodę `_selectConversation`, która go czyści; w szerokim panelu stan nic nie zmienia. Testy `chat_panel_section_cubit_test.dart` (4 przypadki, m.in. ponowny wybór tej samej sekcji wraca z rozmowy do listy).

P2 „popover nie odświeża błędu i stanu wysyłania”: stan był czytany przez `read`, więc `isSubmitting` i kod porażki nie przebudowywały kontrolek. Naprawa: `BlocBuilder` wokół treści popovera, pasek postępu w trakcie wysyłki, blokada wierszy typów i wyników, a błąd pokazuje tekst z ARB wraz z kodem domenowym.

Walidacja (uruchomione, Front): `flutter analyze` — 0 problemów; `flutter test` — PASS 1518 (+4 testy nawigacji sekcji, +2 testy tożsamości rozmowy i dzierżawy, +1 test DM z popovera); `flutter build web --wasm` — PASS; `git diff --check` — PASS. Cztery kontrole mutacyjne (klucz rozmowy, dzierżawa w `build`, rodzaj w DM) opisane wyżej; pozostałe naprawy są pokryte testami stanu i bramkami kodu.

Uwaga o harnessie: pierwsza wersja testu tożsamości rozmowy montowała panel bez `Material` (`MaterialApp(home: ...)`), przez co pole tekstowe composera raportowało w testach wysokość sentinelową 100000 px. To artefakt harnessu (ten sam efekt daje gołe `TextField` w `MaterialApp`), nie produkt — oprawa testu dostała `Scaffold` i metryki są normalne.

Otwarte bez zmian: P1#3 (realtime skrzynki i badge), P2#7 (doładowanie historii rozmowy, skok po ID, odczyt tylko widocznych wiadomości), R10–R14, kompozycja załączników oraz odbiór wizualny z użytkownikiem.

Następny krok: P1#3 + P2#7, potem PAKIET C (R10–R13, załączniki) i odbiór wyglądu.

## 2026-09-21 — CHAT-REMEDIACJA PAKIET B (UI): układ §2.1–2.4 i zakładki kontekstowe §2.7

Zakres: docelowy układ komunikatora z §2.1–2.4 oraz przygotowanie zakładek Pliki i Zadania / Kanban z §2.7 — nadal bez integracji źródeł kontekstowych, zgodnie z granicą pakietu.

Pliki (Front, nowe, katalog `lib/workspaces/presentation/chat/shell/layout/`): `chat_panel_section.dart` (sekcje railu mapowane na filtry skrzynki), `cubit/chat_panel_section_cubit.dart`, `chat_panel_size.dart` (960 domyślnie, 760–1120, rail 56/52, lista 304–344, próg compact 760), `chat_panel_rail.dart`, `chat_panel_scaffold.dart` (trzy kolumny powyżej progu, jedna poniżej), `chat_panel_list_pane.dart` (nagłówek sekcji, szukanie rozmów, filtry, wiersze, stopka doładowania), `chat_compose_popover.dart` (zakotwiczony „Nowy czat” na wspólnej powierzchni `AppContextMenu.showCustom`), `chat_context_source.dart` + `chat_context_conversations_pane.dart` (typowane źródło `file`/`task`, uczciwy stan i podgląd UI), `chat_saved_messages_pane.dart` (zakładki z przejściem do rozmowy). Zmienione: `chat_drawer.dart` (panel składa się z railu, listy i rozmowy; popover zastępuje `AlertDialog`; sekcja pamięta filtr skrzynki), `inbox/components/chat_inbox_row.dart` (wiersz 72 px, awatar 44, etykieta „Szkic”, prefiks autora w grupie, stan zaznaczenia), `settings/chat_global_settings_modal.dart` (ustawienia komunikatora z railu), `app/shell/overlays/devplanner_global_panels_host.dart` (geometria panelu, uchwyt zmiany szerokości, przypięcie rezerwujące miejsce, niemodalny desktop, compact sheet), `lib/l10n/app_{pl,en}.arb` (+29 kluczy).

Decyzje: (1) rail jest jedynym miejscem wyboru sekcji, a sekcja to wyłącznie stan prezentacji — filtr serwerowej skrzynki ustawia osobny słuchacz, który pamięta filtr wybrany w każdej sekcji, więc przełączenie zakładki nie kasuje zaznaczonej rozmowy ani szkicu. (2) Desktop jest niemodalny: panel nie przyciemnia i nie blokuje aplikacji, a przypięcie rezerwuje szerokość w layoucie; na compact panel zajmuje całą przestrzeń roboczą, więc zamyka go Escape albo przycisk zamknięcia, a barrier zostaje dla węższych układów. (3) Kształt drzewa treści aplikacji nie zmienia się przy przypięciu (stałe `AnimatedPadding`), bo inaczej przełączenie trybu odtwarzałoby trasę i stan widoku. (4) Pliki i Zadania mają typowane źródło (`file`/`task`), uczciwy stan „Rozmowy plików/zadań będą dostępne tutaj” bez fałszywego zera nieprzeczytanych i bez spinnera, a pełne wiersze ogląda się w widocznym, oznaczonym podglądzie z danymi syntetycznymi, który nie trafia do żadnego repozytorium. (5) Wiersz rozmowy w grupie pokazuje autora z listy uczestników zwróconej przez serwer, a nazwy nigdy nie pochodzą ze `scopeKey` ani UUID.

Weryfikacja (uruchomione, Front): `flutter analyze` — 0 problemów; `flutter test` — PASS 1511 (+2 testy geometrii panelu: szerokość 960 i niemodalność na desktopie, modalny arkusz na compact); `flutter gen-l10n` — PASS; `flutter build web --wasm` — PASS (`✓ Built build/web`); `git diff --check` — PASS. Nowe testy geometrii siedzą w `test/app/shell/overlays/devplanner_modal_layer_test.dart` obok testów warstwy modali.

Ograniczenie dowodu: nowy układ nie ma jeszcze testów widgetowych ani goldenów i **nie został obejrzany w uruchomionej aplikacji** — plan korekty (§4) wprost odkłada widgety i goldeny do akceptacji wyglądu, a ZCode Computer Use nie ma na tej maszynie zgody na nagrywanie ekranu, więc zrzutów nie ma. To znaczy, że układ jest zaimplementowany i przechodzi bramki kodu, ale odbiór wizualny pozostaje otwarty i należy do użytkownika.

Otwarte po tym pakiecie: P1#3 (realtime skrzynki i badge) i P2#7 (doładowanie historii rozmowy, skok po ID niezależny od zbudowanego wiersza, odczyt tylko dla faktycznie widocznych wiadomości) oraz R10–R14 i załączniki z pakietu C, a także trwałość szerokości panelu między uruchomieniami (dziś stan sesji) i ręczne porównanie stylu powierzchni z Tasks/Storage z §2.6.

Następny krok: P1#3 + P2#7, potem PAKIET C (R10–R13, załączniki) i odbiór wizualny z użytkownikiem.

## 2026-09-21 — CHAT-REMEDIACJA PAKIET B: warstwa modali nad panelem (R03) i wyścigi skrzynki

Zakres: R03 z planu korekty (realny root modali nad panelem), P1#2 z review (akcje i trwała kolejka w aktywnym panelu), P2#4–P2#6 (pusty kursor, wyścig filtrów, Wstecz w kreatorze).

Przyczyna R03 (sprostowanie wcześniejszego wpisu): host paneli jest montowany w `MaterialApp.router(builder:)` (`lib/app/devplanner_app.dart:121`), a `WidgetsApp` stosuje `builder` **nad** `Router`em (`packages/flutter/lib/src/widgets/app.dart:1722`). Panel jest więc rodzeństwem aktywnej trasy i nie ma żadnego przodka `Navigator` — wywołane z panelu `Navigator.of(context, rootNavigator: true)` rzuca „Navigator operation requested with a context that does not include a Navigator”. Kreator nie otwierał się nie z powodu brakującego portu, a z powodu braku Navigatora. Wcześniejsze wyjaśnienie w tym handoffie („panel jest wewnątrz treści trasy, więc modal rootowy rysuje się nad panelem”) było sprzeczne z kodem i zostało sprostowane.

Naprawa: nowa warstwa `lib/app/shell/overlays/devplanner_modal_layer.dart` — host owija aplikację razem z panelem w `Navigator` (`DevPlannerModalLayer`), którego trasa-stojak (`/app`, nazwa `kDevPlannerAppRootRouteName`) zawiera całą aplikację. Modal otwarty z panelu trafia do tego samego stosu co aplikacja i maluje się nad panelem, z własnym barrierem, focusem i Escape; nie trzeba zmieniać ani `DevPlannerModalHost`, ani żadnego wywołania `showDialog`. Trasa-stojak czyta treść z `InheritedWidget` powyżej `Navigator`a, więc przebudowa hosta (np. zmiana sesji) aktualizuje aplikację w miejscu, zamiast trzymać pierwszy, nieaktualny widget trasy. `_PanelOverlay` dostał węzeł focusu od hosta, a host prosi go o focus przy otwarciu panelu — `autofocus` nie wystarczał w tym drzewie, a bez focusu w panelu Escape nie zamykał panelu. Back systemowy obsługuje `WidgetsBindingObserver.didPopRoute` hosta (obserwator rejestruje się przed routerem, bo host jest nad nim): modal zamyka się przed zmianą trasy, a poza modalem zdarzenie idzie do routera, więc zachowanie poza modalem jest niezmienione.

Kontrakt warstwy (zapisany w kodzie i w docu klasy): Escape zamyka najpierw modal, a potem panel; back systemowy zamyka modal, zanim router zmieni trasę; po zamknięciu modala focus wraca do panelu (weryfikacja w teście). Zdarzenia przeglądarki (historia Web) nadal należy do routera — warstwa ich nie przechwytuje i to jest jawnie zapisane jako ograniczenie, nie udawane pokrycie.

Zmiany w źródłach: `app/shell/overlays/devplanner_global_panels_host.dart` (warstwa, klucz stosu, węzeł focusu panelu, `didPopRoute`), `app/shell/overlays/devplanner_modal_layer.dart` (nowy), `presentation/chat/shell/chat_panel_conversation.dart` (`ChatMessageActionsCubit` wydany w panelu; `ChatConversationCubit` dostaje `currentUserId` i `ChatMessageDeliveryQueue` z trwałym magazynem zamiast pomijać jedno i drugie), `presentation/chat/inbox/cubit/chat_inbox_cubit.dart` (`_stateForPage`: pusta strona z `hasMore` zachowuje kursor i nie udaje braku rozmów; `_requestId`: odpowiedź wcześniejszego filtra nie zastępuje nowszej listy i nie ma emisji po zamknięciu Cubita), `presentation/chat/creation/cubit/chat_creation_cubit.dart` (Wstecz ze szczegółów wraca do wyboru typu, a nie do listy wybranych).

Testy: nowy `test/app/shell/overlays/devplanner_modal_layer_test.dart` — drzewo odwzorowuje produkcję (`MaterialApp.router` z hostem w `builder`), 3 przypadki: modal z panelu otwiera się i jego akcja nie zamyka panelu, back systemowy zamyka modal, Escape zamyka najpierw modal a dopiero potem panel. `test/workspaces/presentation/chat/inbox/chat_inbox_cubit_test.dart` +3: kursor przy pustej stronie z `hasMore`, pusta strona bez `hasMore` jako prawdziwy brak rozmów, wolniejsza odpowiedź starszego filtra.

Kontrola mutacyjna (dowód, że testy rozstrzygają, a nie tylko przechodzą): po odłączeniu warstwy (`_buildRootEntry` bez `DevPlannerModalLayer`) wszystkie 3 testy warstwy padają w `showGeneralDialog` na braku Navigatora — czyli dokładnie na objawie z review; po przywróceniu warstwy przechodzą. Pierwsza wersja tego testu była montowana w `MaterialApp(home:)`, gdzie panel **ma** przodka `Navigator`, i przechodziła także bez warstwy — została przepisana na `MaterialApp.router`, bo nie rozstrzygała niczego. Test wyścigu filtrów: z guardem 9 PASS w pliku, a po zastąpieniu `if (isClosed || requestId != _requestId) return;` przez `if (isClosed) return;` test „wolniejsza odpowiedź starszego filtra nie zastępuje nowszej listy” FAIL; pierwsza wersja atrapy czytała stronę po opóźnieniu, więc obie odpowiedzi niosły tę samą wartość i test nie wykrywał regresji — atrapa została poprawiona.

Walidacja (uruchomione, Front): `flutter test` — PASS 1509, FAIL 0; `flutter test test/workspaces/presentation/chat` — PASS 148; `flutter test test/app/shell/overlays` — PASS 8; `flutter analyze` — 0 problemów; `git diff --check` — PASS. Backend w tym pakiecie nietknięty.

Otwarte po tym pakiecie: P1#3 (realtime skrzynki i badge), P2#7 (doładowanie historii, skok po ID niezależny od zbudowanego wiersza, odczyt tylko dla faktycznie widocznych wiadomości) oraz cały układ z §2.1–2.4 (panel 960 px z regulacją 760–1120, rail, lista 72 px, zakotwiczony popover „Nowy czat”, niemodalny desktop) i §2.7 (osobne zakładki Pliki i Zadania / Kanban).

Następny krok: P1#3 + P2#7, potem układ panelu z §2.1–2.4 i §2.7, na końcu PAKIET C–E (R07, R10–R13, załączniki, wspólny styl powierzchni, odbiór manualny).

## 2026-09-21 — CHAT-REMEDIACJA PAKIET B (część): kreator rozmowy naprawdę działa

Zakres: R04 i R05 z planu korekty — brakujący Cubit katalogu w aktywnym flow oraz zakończenie rozmowy 1:1 kliknięciem osoby.

Pliki (Front, zmienione): `presentation/chat/creation/chat_creation_sheet.dart` (arkusz przyjmuje jawne `ChatDirectoryRepository` i tworzy `ChatDirectorySearchCubit` we własnym `MultiBlocProvider`), `creation/cubit/chat_creation_cubit.dart` (`startDirectWith`, `submit` idempotentny w trakcie wysyłki), `creation/participants/chat_creation_participants_step.dart` (Cubit wymagany, nie opcjonalny; 1:1 jako jednokrotny wiersz), `chat_drawer.dart` (przekazanie portu katalogu). Test: `test/workspaces/presentation/chat/creation/chat_creation_cubit_test.dart` (+2 przypadki).

Decyzje: katalog dostaje własny Cubit wydany jawnie przez flow, z lifecycle zamkniętym razem z arkuszem — wyszukiwanie nie może zależeć od tego, co przypadkiem jest w kontekście panelu. Dla 1:1 nie ma osobnego kroku szczegółów: klik osoby od razu rozwiązuje istniejący DM pary albo tworzy go, a panel otwiera to, co wróciło; podwójny klik nie tworzy duplikatu, bo wysyłka jest idempotentna, dopóki trwa.

Ustalenie do R03: brak przycisku nowej rozmowy w działającej aplikacji tłumaczy brakujący provider `ChatDirectoryRepository` w hoście panelu (naprawiony 2026-09-21), ale sam host modali był drugą, poważniejszą przyczyną — `DevPlannerModalHost.showDialog` używa `showGeneralDialog` z `useRootNavigator: true`, a panel nie ma przodka `Navigator` (host jest nad routerem), więc kreator nie miał gdzie się otworzyć. **Sprostowanie 2026-09-21:** zdanie z pierwotnej wersji tego wpisu, że „panel jest zamontowany wewnątrz treści trasy, więc modal rootowy rysuje się nad panelem”, było sprzeczne z kodem; warstwa modali i jej testy opisuje wpis „CHAT-REMEDIACJA PAKIET B: warstwa modali nad panelem (R03)”. R03 pozostaje otwarte do **ręcznego** przejścia kreatora, menu, edycji, potwierdzenia, Escape, focusu i resize w działającej aplikacji; sama analiza kodu nie jest odbiorem.

Walidacja (uruchomione, Front): `flutter analyze` — PASS, 0 problemów; `flutter test test/workspaces/presentation/chat` — PASS 145; pełny `flutter test` nie był używany jako bramka, zgodnie z §4 planu (może uruchomić odroczone widgety). `git diff --check` — PASS.

Otwarte w PAKIECIE B: R03 (ręczny przebieg w aplikacji), R06 (`ChatMessageActionsCubit` w aktywnym panelu, wersja i konflikt dla edycji/usunięcia z panelu) oraz szkielet z §2.1–2.4: rail 56 px z pozycjami Czaty/Grupy/Kanały/Pliki/Zadania/Archiwum/Zapisane/Profil/Ustawienia, lista rozmów wg §2.3 i zakotwiczony popover „Nowy czat” wg §2.4.

Następny krok: R06 + szkielet panelu z §2.1–2.4, potem PAKIET C (sesyjna persystencja, realtime inbox/badge, read visibility, loadMore, skok po ID, pełny wiersz wiadomości, załączniki).

## 2026-09-21 — CHAT-REMEDIACJA PAKIET A: ACL skrzynki, zakres Direct, monotoniczny znacznik odczytu

Zakres: pierwszy pakiet planu korekty po review (`docs/global-chat-ui-remediation-2026-09-21.md`) — R01, R02, R09 oraz weryfikacja monotoniczności znacznika odczytu. Ten plan ma pierwszeństwo nad wcześniejszymi oznaczeniami „gotowe” G3–G7.

Pliki (Backend, zmienione): `Infrastructure/Chat/ChatInboxReader.cs` (`VisibleTo` wymaga członkostwa i dostępu do zakresu; `ReadUnreadTotalsAsync` zwraca typowane wiersze `ChatInboxUnreadTotalRow` na tym samym predykacie; nowy `ReadConversationsAsync`), `Application/Chat/ChatInboxService.cs` (liczniki autoryzują zakres Resource u providera, spójnie ze stroną), `Application/Chat/ChatService.cs` (fallback Direct ograniczony do tego samego workspace/projektu, najstarsza rozmowa zamiast `SingleOrDefault`; atomiczny warunkowy UPDATE znacznika odczytu), `Domain/Entities/ChatConversationMember.cs` (`MarkRead` wyłącznie jako ścieżka dla dostawców bez `ExecuteUpdate`). Nowy test: `Tests/Veloryn.Workspaces.Tests/ChatRemediationAclTests.cs`.

Decyzje: sam wiersz członkostwa nie wystarcza — każdy odczyt sprawdza też zakres, więc revoke workspace/projektu odbiera rozmowę natychmiast, bez czekania na materializację członkostwa. Licznik nieprzeczytanych używa tego samego predykatu co lista plus autoryzacji providera dla Resource, więc badge nie może pokazać rozmowy, której lista nie pokazuje. Znacznik odczytu jest monotoniczny w parze `(CreatedAtUtc, Id)`, a kolejność UUID rozstrzyga PostgreSQL, dlatego zapisuje go atomowy warunkowy `UPDATE`, a encja jest odłączana — inaczej późniejszy `SaveChanges` (stan dostarczenia) nadpisywał znacznik wartością sprzed równoległego żądania.

Błąd znaleziony i naprawiony w trakcie: pierwsza wersja naprawy znacznika (odczyt znacznika w pamięci + zapis encji) była **niestabilna** — test równoległy przechodził 2 z 3 razy. Przyczyną był właśnie zapis zwrotny przez `SaveChanges`; po przejściu na pojedynczego właściciela zapisu (warunkowy UPDATE) 5 z 5 przebiegów jest zielonych. Wartością tego pakietu jest też to, że flaky test nie został zignorowany.

Walidacja (uruchomione, Backend): `dotnet build veloryn-workspaces.csproj --no-restore` — PASS, 0 ostrzeżeń; `dotnet test --filter "FullyQualifiedName~Chat|~Directory|~ApiEndpointTests"` — PASS 241, FAIL 0, SKIP 3 (drugi Redis na `localhost:6380`); nowy `ChatRemediationAclTests` — 5 PASS, stabilny w 5 kolejnych przebiegach: revoke workspace (lista i liczniki), revoke projektu na kolejnych stronach, zakres Direct pary w dwóch projektach i dawne duplikaty bez 500, monotoniczność znacznika przy równych czasach, równoległe odczyty na osobnych kontekstach. `git diff --check` — PASS.

Dowody dla R01/R02/R09 i monotoniczności są wpisane w samym planie korekty (wiersze oznaczone **NIE** = naprawione, z nazwami testów). Zgodnie z §4 planu punkty PAKIETU B–E pozostają otwarte, a „starsze oznaczenia G5 zamknięte nie stanowią odbioru funkcjonalnego”.

Następny krok: PAKIET B — R03 (realny Navigator/overlay root i jawne zależności popupów), R04/R05 (kreator: Cubit katalogu w aktywnym flow, klik kontaktu kończy DM), R06 (Cubit akcji w panelu) oraz szkielet UI z §2.1–2.4 (rail, lista, popover „Nowy czat”), bo bez tego klik tworzenia rozmowy w działającej aplikacji nadal nie otwiera kreatora.

## 2026-09-21 — CHAT-G6 (start): sesja załączników i rozpoznanie blokady kompozycji

Zakres: pierwszy krok G6 — brakująca produkcyjna implementacja portu sesji załączników, która była jedyną przeszkodą w złożeniu istniejącego adaptera uploadu.

Pliki (Front, nowe): `lib/workspaces/data/chat/attachments/chat_attachment_session_repository_impl.dart`, `test/workspaces/data/chat/attachments/chat_attachment_session_repository_impl_test.dart`. Zmienione: `lib/workspaces/data/chat/errors/chat_api_error_mapper.dart` (kod `chat.attachments.session_failed`).

Decyzje: adapter sesji nie przechowuje i nie zwraca ticketów, URL-i presigned ani tokenów Storage — sesja domenowa ma wyłącznie identyfikator, rozmowę i wygaśnięcie, a poświadczenia Storage pozostają w warstwie data, która wykonuje upload. Porażka wydania sesji ma własny kod (`chat.attachments.session_failed`), więc UI odróżnia odmowę dostępu od błędu sieci.

Walidacja (Front, uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1501 (1498 przed tym pakietem; +3 testy sesji: wydanie bez ujawniania poświadczeń, anulowanie, kod odmowy z zachowanym statusem); `git diff --check` — PASS. Backend nietknięty.

Rozpoznana blokada kompozycji (do domknięcia w G6): `ChatAttachmentUploadPortAdapter` wymaga trzech zależności — `ChatAttachmentSessionRepository` (właśnie dodane), `StorageRepository` i `UploadTransport`. `StorageRepositoryImpl` i `PresignedUploadTransport` powstają w routerze (`lib/app/router/devplanner_router.dart`, `devplanner_router_pages.part.dart`), a `DevPlannerStandaloneRuntime` jest konstruowany w `lib/app/devplanner_app.dart` tylko z `auth` i `transport`, więc `attachmentUploadPort` i `filePickerPort` pozostają `null` w produkcji i interfejs załączników jest bezczynny. Dwie realne przeszkody do rozstrzygnięcia, nie do obejścia: (1) runtime musi dostać `StorageRepository` i `UploadTransport` z tego samego miejsca, w którym powstaje transport sesji, żeby adapter dało się złożyć bez drugiego klienta HTTP; (2) `PresignedUploadTransport` jest dziś tworzony wyłącznie dla kompozycji desktopowej, więc trzeba jawnie ustalić, czym jest upload załącznika w Web (BFF) — albo bezpieczny transport przez BFF, albo jawne ograniczenie, zgodnie z zasadą z §6 planu o niewkładaniu prywatnej treści w nieszyfrowany magazyn przeglądarki i o nieobchodzeniu granicy sesji.

Pozostaje w G6 po tej części: złożenie `ChatAttachmentUploadPortAdapter` i file pickera w kompozycji, obraz ze schowka i drag/drop na ścieżce panelu, podgląd i pobranie załącznika przez autoryzowany endpoint, limity i komunikaty błędów oraz weryfikacja reautoryzacji po revoke i cleanupu osieroconych sesji; bramka zbiorcza G3–G6 z testami Storage/AV/ACL i ręcznym upload/cancel/retry.

Następny krok: złożyć adapter uploadu w kompozycji (runtime + app) razem z file pickerem i rozstrzygnąć transport uploadu dla Web.

## 2026-09-21 — CHAT-G5 (część 5, zamknięcie): archiwizacja z panelu i sygnał roli

Zakres: domknięcie dwóch ostatnich pozycji G5 — archiwizacja i przywracanie rozmowy z panelu oraz sygnał roli, który pozwala pokazać moderację cudzej treści bez udawania uprawnień.

Pliki (Front, nowe): `test/workspaces/presentation/chat/shell/chat_panel_selection_role_test.dart`. Zmienione: `shell/cubit/chat_panel_selection_cubit.dart` (rola w stanie wyboru + `canModerate`), `shell/chat_panel_conversation.dart` i `shell/chat_panel_conversation_parts.dart` (menu archiwizacji, `canModerate` w liście wiadomości), `chat_drawer.dart` (rola przekazywana przy wyborze z listy i z wyszukiwania), `app/shell/overlays/devplanner_global_panels_host.dart` (port zarządzania rozmowami nad panelem), `lib/l10n/app_{pl,en}.arb` (+5 kluczy).

Decyzje: rola pochodzi z serwerowej skrzynki (`role` w pozycji inboxa), a panel używa jej wyłącznie do ukrycia akcji moderacji — backend nadal egzekwuje uprawnienia, a brak roli daje `canModerate: false`, więc nieznana rola nie odblokowuje edycji cudzej treści. Archiwizacja wymaga potwierdzenia, bo zmienia listę rozmów; przywrócenie nie, bo jest odwracalne. Po sukcesie panel wraca do listy i odświeża skrzynkę, bo rozmowa wyszła z bieżącego widoku.

Walidacja (Front, uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1498 (1493 przed tym pakietem; +5 testów: role Owner/Moderator/Member/Observer, brak roli bez uprawnień, aktualizacja roli przy ponownym wyborze, archiwizacja i przywrócenie w porcie, porażka archiwizacji jako błąd); `git diff --check` — PASS; kontrakt OpenAPI↔Retrofit bez zmian (Swagger 463, Flutter 425). Backend nietknięty — endpointy archiwizacji i przywracania istnieją od początku pinu Chat.

Status G5: wszystkie powierzchnie akcji z planu są zbudowane na gotowych portach — reakcje, wątki i odpowiedzi, edycja/usuwanie z `Version` i konfliktem, przypięcia, zakładki, forward, wyszukiwanie z facetami i skokiem do wiadomości, członkowie z rolami i opuszczeniem, archiwizacja i przywracanie, wyciszenie i preferencje oraz obecność z własnym statusem, statusami członków i wskaźnikiem pisania z TTL. Otwarte pozostają wyłącznie dwie rzeczy spoza zakresu implementacji: testy widgetowe i goldeny panelu (odroczone do akceptacji wyglądu) oraz weryfikacja odbioru zdarzeń z żywego huba SignalR, w tym pisania i handshake'u cookie w Web (protokół dwóch sesji w G8).

Następny krok: G6 — załączniki wiadomości na istniejących attachment sessions i Storage/AV: upload adapter, stany `Clean/Ready`, progress, cancel, obraz ze schowka, drag/drop, podgląd i pobranie przez autoryzowany endpoint, limity i komunikaty błędów.

## 2026-09-21 — CHAT-G5 (część 4): wskaźnik pisania z TTL

Zakres: domknięcie ostatniej pozycji powierzchni obecności z G5 — pisanie w obie strony, z TTL pochodzącym z kontraktu serwera.

Pliki (Front, nowe): `lib/workspaces/presentation/chat/presence/cubit/chat_typing_cubit.dart`, `lib/workspaces/presentation/chat/presence/widgets/chat_typing_indicator.dart`, `test/workspaces/presentation/chat/presence/chat_typing_cubit_test.dart`. Zmienione: `domain/chat/realtime/chat_conversation_realtime_event.dart` (rodzaj `typingChanged` + `typingUserId`, `isTyping`, `typingExpiresAtUtc`), `domain/chat/realtime/chat_conversation_realtime_client.dart` (`setTyping` w porcie), `domain/chat/realtime/chat_conversation_realtime_reducer.dart` (pisanie pomijane bez zmiany historii i bez resyncu), `data/realtime/chat/chat_realtime_event_mapper.dart` (mapowanie `chat.typing.changed` z `userId`, `isTyping`, `expiresAtUtc`), `data/realtime/chat/workspace_chat_realtime_service.dart` (handler zdarzenia, `setTyping` przez port, delegacja w dzierżawie), `presentation/chat/cubit/chat_conversation_cubit.dart` (`notifyTyping`), `presentation/chat/composer/chat_message_composer.dart` (zgłoszenie pisania przy zmianie treści i „stop” po 4 s bezczynności), `presentation/chat/shell/chat_panel_conversation.dart` (kubit pisania + wskaźnik nad composerem).

Decyzje: TTL pochodzi z payloadu serwera (`ExpiresAtUtc`), a stały zapas 8 s służy tylko jako fallback, gdy serwer go nie poda — dzięki temu wskaźnik znika nawet bez zdarzenia „stop” i po zerwaniu połączenia. Pisanie jest pomijane przez reduktor historii, bo nie jest wiadomością i nie może wymuszać resyncu. Własne zdarzenia są odrzucane, bo nadawca nie jest dla siebie wskaźnikiem. `setTyping` weszło do portu subskrypcji rozmowy, więc widok i cubit nie sięgają do konkretnego serwisu SignalR, a dzierżawa przekazuje wywołanie dalej. Sygnał wychodzący jest best-effort: zerwane połączenie nie może przerwać pisania wiadomości.

Walidacja (Front, uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1493 (1486 przed tym pakietem; +7 testów: mapowanie zdarzenia z TTL i bez TTL, brak wpływu na historię i brak resyncu, wygaśnięcie po TTL serwera bez zdarzenia stop, natychmiastowe usunięcie po stop, pominięcie własnego pisania, brak klienta realtime); `git diff --check` — PASS; kontrakt OpenAPI↔Retrofit bez zmian (Swagger 463, Flutter 425). Backend nietknięty — kontrakt `chat.typing.changed` (`conversationId`, `userId`, `isTyping`, `expiresAtUtc`) był już w `Contracts/Chat/ChatRealtimePresenceContracts.cs` i w `ChatRealtimeConnectionManager`.

Uwaga o zasięgu weryfikacji: mapowanie, TTL i reduktor są pokryte testami jednostkowymi, ale odebranie rzeczywistego zdarzenia z huba przez SignalR nie zostało sprawdzone na żywym backendzie — to należy do protokołu dwóch sesji w G8, razem z wcześniej zapisaną luką „żywy handshake SignalR w Web niezweryfikowany”.

Pozostaje w G5: archiwizacja i przywracanie rozmowy z panelu oraz moderacja cudzej treści (czeka na sygnał roli z panelu). Testy widgetowe panelu pozostają odroczone do akceptacji wyglądu.

Następny krok: archiwizacja/przywracanie z panelu i rola dla moderacji, potem G6 (załączniki) — albo przejście do G6 zgodnie z kolejnością planu.

## 2026-09-21 — CHAT-G5 (część 3): wyciszenie, przypięte, zakładki i statusy

Zakres: domknięcie kolejnych powierzchni G5 — menu rozmowy z wyciszeniem i preferencjami, widoki list przypiętych wiadomości i zakładek oraz powierzchnia obecności dla własnego statusu i statusów członków. Wskaźnik pisania pozostaje otwarty i jest opisany niżej wraz z przyczyną techniczną.

Pliki (Front, nowe): `lib/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart`, `lib/workspaces/presentation/chat/message_actions/chat_message_list_sheets.dart`, `lib/workspaces/presentation/chat/presence/chat_status_dialog.dart`, `test/workspaces/presentation/chat/settings/chat_conversation_mute_cubit_test.dart`. Zmienione: `shell/chat_panel_conversation.dart` i `shell/chat_panel_conversation_parts.dart` (menu rozmowy, wejście do własnego statusu, port akcji w nagłówku), `members/chat_members_sheet.dart` (statusy członków), `chat_drawer.dart` (port ustawień powiadomień), `app/shell/overlays/devplanner_global_panels_host.dart` (port obecności), `lib/l10n/app_{pl,en}.arb` (+19 kluczy).

Decyzje: wyciszenie jest polityką serwera, a nie stanem UI — przełącznik zapisuje politykę rozmowy, a przy porażce wraca do stanu potwierdzonego przez backend, żeby nie kłamał. Menu rozmowy zbiera wyciszenie, przypięte, zakładki i preferencje, a każda pozycja ma realny skutek (listy czytają port akcji, preferencje otwierają istniejący modal montowany w rootowym hoście). Listy przypiętych i zakładek są tylko do odczytu i odpinania/usuwania po potwierdzeniu backendu, więc nie rozjeżdżają się ze stanem serwera. Statusy pokazujemy tam, gdzie są tożsamości: własny w dialogu z emoji, tekstem i DND, a statusy innych w liście członków — brak portu albo błąd zostawia wiersz bez statusu, więc lista pozostaje użyteczna.

Walidacja (Front, uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1486 (1483 przed tym pakietem; +3 testy wyciszenia: zapis polityki, drugie przełączenie, powrót do stanu serwera po porażce); `git diff --check` — PASS; kontrakt OpenAPI↔Retrofit bez zmian (Swagger 463, Flutter 425). Backend nietknięty.

Otwarte w G5 — wskaźnik pisania (typing): nie jest zaimplementowany i wymaga zmiany w warstwie realtime, nie tylko UI. `WorkspaceChatRealtimeService` potrafi wywołać `SetTyping`, ale nie rejestruje handlera `chat.typing.changed`, a `ChatConversationRealtimeEvent` nie ma rodzaju zdarzenia dla pisania — więc odebranie cudzego pisania wymaga mapowania w `ChatRealtimeEventMapper`, nowego rodzaju zdarzenia, stanu z TTL („Statusy online/typing mają TTL”), a po stronie wychodzącej rozszerzenia portu `ChatConversationRealtimeClient` o `setTyping`, bo dziś metoda istnieje tylko w konkretnym serwisie. To spójny pakiet do wykonania jako następny krok G5, razem z pozostałymi lukami: archiwizacja i przywracanie rozmowy z panelu, moderacja cudzej treści (czeka na sygnał roli) oraz odroczone testy widgetowe.

Następny krok: wskaźnik pisania (mapper + rodzaj zdarzenia + TTL + `setTyping` w porcie), potem archiwizacja z panelu i rola dla moderacji, a następnie G6 (załączniki).

## 2026-09-21 — CHAT-G5 (część 2): wątek z panelu, wyszukiwanie ze skokiem, lista członków

Zakres: domknięcie trzech powierzchni G5 wskazanych jako otwarte — otwieranie wątku i dyskusji z panelu, wyszukiwanie wiadomości ze skokiem do wiadomości oraz lista członków z rolami, usuwaniem i opuszczeniem rozmowy.

Pliki (Front, nowe): `lib/workspaces/presentation/chat/shell/chat_thread_sheet.dart`, `lib/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart`, `lib/workspaces/presentation/chat/search/components/chat_search_view.dart`, `lib/workspaces/presentation/chat/members/cubit/chat_members_cubit.dart`, `lib/workspaces/presentation/chat/members/chat_members_sheet.dart`, `test/workspaces/presentation/chat/g5_search_and_members_test.dart`. Zmienione: `chat_drawer.dart` (przycisk wyszukiwania, widok wyszukiwania w miejscu listy, wybór rozmowy z celem skoku), `shell/chat_panel_conversation.dart` i `shell/chat_panel_conversation_parts.dart` (cel skoku, podświetlenie i przewinięcie do wiadomości, przycisk członków), `shell/cubit/chat_panel_selection_cubit.dart` (stan `ChatPanelSelection` z `targetMessageId`), `app/shell/overlays/devplanner_global_panels_host.dart` (porty wątku, dyskusji, akcji, członków i wyszukiwania nad panelem), `lib/l10n/app_{pl,en}.arb` (+28 kluczy).

Decyzje: panel montuje wątek i dyskusję w bocznym arkuszu rootowego hosta modali, więc porty dostają jawnie przez `RepositoryProvider` — ta sama reguła co przy kreatorze i modalach ustawień. Skok z wyszukiwania jest częścią stanu wyboru, bo powtórny wybór tej samej rozmowy musi nadal przenieść widok do wskazanej wiadomości; podświetlenie i przewinięcie działają w ramach załadowanej historii, a pozycję spoza strony otwiera doładowanie historii (ta sama granica co w pełnym widoku, jawnie zapisana w komentarzu). Widok wyszukiwania jest sterowany stanem cubita (`isOpen`), a nie stanem widgetu, więc panel nie potrzebuje własnego `setState`. Lista członków pokazuje akcje tylko rolom, które mogą je wykonać, ale decyzję zawsze podejmuje backend; po mutacji lista odświeża się bez migotania pustym stanem, a opuszczenie rozmowy zamyka arkusz.

Walidacja (Front, uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1483 (1473 przed tym pakietem; +10 testów: 5 wyszukiwania i 5 członków); `git diff --check` — PASS; kontrakt OpenAPI↔Retrofit bez zmian (Swagger 463, Flutter 425). Backend nietknięty.

Błędy znalezione i naprawione w trakcie: (1) odświeżenie listy po mutacji nie było czekane, więc wołający mógł zobaczyć starą listę jako wynik zakończonej zmiany roli — teraz `_mutate` czeka na odświeżenie, a test to pinuje; (2) panel po mutacji migotał stanem ładowania — odświeżenie po mutacji jest ciche. Uwaga warsztatowa: przy przekształcaniu drawera w widget stanowy plik zebrał kilka nakładających się edycji; naprawiłem go punktowo (zniekształcona sygnatura `_buildPanelBody`, brakujące importy, osierocony fragment `Column`) zamiast cofać całego pliku, żeby nie stracić wcześniejszej pracy G3–G5.

Otwarte w G5 (pozostaje): (1) przełącznik mute i wejście do preferencji w menu rozmowy — jest modal ustawień, brak osobnego skrótu; (2) powierzchnia obecności: własny status, status rozmówcy, wskaźnik pisania; (3) widoki list przypiętych wiadomości i zakładek; (4) archiwizacja i przywracanie rozmowy z menu panelu mimo gotowego portu; (5) moderacja cudzej treści czeka na sygnał roli z panelu (`canModerate` jest na razie `false`); (6) testy widgetowe tych powierzchni pozostają odroczone do akceptacji wyglądu.

Następny krok: dokończyć G5 (mute i preferencje w menu, obecność, widoki przypiętych i zakładek, archiwizacja z panelu) albo przejść do G6 (załączniki) zgodnie z kolejnością planu.

## 2026-09-21 — CHAT-G5 (część): menu akcji wiadomości, reakcje i wątki

Zakres: pierwsze powierzchnie akcji na portach z G2 — menu wiadomości z realnym skutkiem, reakcje z agregatów serwera, przypięcia, zakładki, forward oraz adaptery wątku i dyskusji. Pozostałe powierzchnie G5 (wyszukiwanie, członkowie, mute, presence) pozostają otwarte i są wypisane niżej.

Pliki (Front, nowe): `lib/workspaces/presentation/chat/message_actions/chat_message_action_menu.dart`, `lib/workspaces/presentation/chat/message_actions/chat_message_action_dialogs.dart`, `lib/workspaces/presentation/chat/message_actions/cubit/{chat_message_secondary_actions_cubit,chat_message_secondary_actions_state}.dart`, `lib/workspaces/data/chat/repositories/chat_thread_repository_impl.dart`, `test/workspaces/presentation/chat/message_actions/chat_message_secondary_actions_test.dart`. Zmienione: `chat_panel_conversation_parts.dart` (menu i pasek reakcji w wierszu wiadomości, odczyt stanu z kontekstu), `chat_panel_conversation.dart` (BlocProvider cubita akcji, `onOpenThread`), `chat_message.dart` (agregaty reakcji w modelu domenowym), `chat_repository_impl.dart` (mapowanie agregatów), `global_chat_composition.dart`, `devplanner_standalone_runtime.dart`, `lib/l10n/app_{pl,en}.arb` (+17 kluczy).

Decyzje: akcje drugorzędne (przypięcia, zakładki, reakcje, forward) mają osobny cubit od edycji i usunięcia, bo tylko te drugie zmieniają treść i wymagają `Version` oraz rozstrzygania konfliktu. Każda pozycja menu jest wywołaniem portu; błąd wraca kodem domenowym przypisanym do wiadomości, więc menu pokazuje realny powód, a nie cichy brak skutku. Reakcje wyświetlamy z agregatu backendu (`ChatMessage.reactions`), dzięki czemu nie ma zapytania na wiadomość; pasek reakcji odróżnia własną reakcję i pozwala ją zdjąć. Dialogi (usunięcie z potwierdzeniem, edycja, wybór rozmowy do przekazania) są montowane w rootowym hoście modali, więc Escape, barrier i focus pochodzą z foundation. Edycja i usunięcie są widoczne tylko dla autora; moderacja cudzej treści czeka na sygnał roli z panelu i nie jest udawana.

Walidacja (Front, uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1473 (1467 przed tym pakietem, +6 testów cubita akcji: przypięcie/odpięcie, zakładka, reakcja, forward ze stabilnym `clientMessageId`, kod błędu przy wiadomości bez pętli, brak zdublowanego żądania przy równoległej akcji); `git diff --check` — PASS; kontrakt OpenAPI↔Retrofit bez zmian (Swagger 463, Flutter 425). Backend nietknięty w tym pakiecie.

Otwarte w G5 (świadomie, nie „prawie gotowe”): (1) wątek nie otwiera się jeszcze z panelu — `onOpenThread` nie ma dostarczyciela w drawerze i hoście, choć `ChatThreadSidePanel` i adapter wątku są gotowe; (2) brak powierzchni wyszukiwania wiadomości (facety i skok do wiadomości) mimo gotowego portu; (3) brak powierzchni członków (lista, role, usuwanie) mimo gotowego portu; (4) brak przełącznika mute i wejścia do preferencji w menu rozmowy — modal ustawień istnieje i jest podłączony; (5) brak powierzchni obecności (własny status, status rozmówcy, wskaźnik pisania); (6) brak widoków list przypiętych i zakładek; (7) testy widgetowe tych powierzchni pozostają odroczone razem z goldenami do akceptacji wyglądu.

Następny krok: dokończyć G5 — otwieranie wątku z panelu, wyszukiwanie wiadomości ze skokiem, lista członków z rolami, mute i preferencje w menu rozmowy oraz obecność i status; potem G6 (załączniki).

## 2026-09-21 — CHAT-G4: niezawodność wysyłki, odczyt i trwała kolejka

Zakres: cursor historii i stabilne klucze wierszy, dostawa/odczyt jako osobny lifecycle, widoczność odczytu (read tylko po faktycznym zobaczeniu), trwała kolejka wysyłki z jawnym ograniczeniem Web oraz testy bramki G4.

Pliki (Front, nowe): `lib/workspaces/domain/chat/delivery/chat_pending_send_store.dart`, `lib/workspaces/data/chat/delivery/chat_pending_send_store_impl.dart`, `test/workspaces/presentation/chat/conversation_delivery/chat_message_delivery_persistence_test.dart`, `test/workspaces/presentation/chat/chat_conversation_read_visibility_test.dart`. Zmienione: `chat_conversation_repository.dart` (+ `markMessageDelivered`, `markConversationRead`), `chat_repository_impl.dart`, `chat_api_error_mapper.dart`, `chat_message_delivery_queue.dart` (magazyn, `restorePending`, `clearForSession`, licznik prób), `chat_conversation_cubit.dart` (`currentUserId`, `markVisibleAsRead`, `restorePendingSends`, `clearForSignedOutSession`), `chat_conversation_message_list.dart` (stabilny `ValueKey` na wiadomość), `chat_panel_conversation.dart` (`_ChatPanelMessages`: odczyt tylko dla zamontowanego panelu z aktywną aplikacją + odświeżenie badge), `global_chat_composition.dart`, `devplanner_standalone_runtime.dart`, oraz pięciu fake’ów repozytorium w testach.

Decyzje: doręczenie i odczyt są osobnymi wywołaniami, bo HTTP 2xx przy `send` nie jest dowodem doręczenia. Odczyt wysyła widok, nie cubit przy pobraniu historii: `markVisibleAsRead` jest idempotentne, pomija wiadomości własne, lokalne (`local:`) i usunięte, a po udanym odczycie panel odświeża serwerowy badge skrzynki. Kolejka dostała trwały magazyn intencji: desktop zapisuje w systemowym secure storage i wznawia próby po restarcie oraz po ponownym otwarciu rozmowy, Web celowo **nie utrwala niczego**, żeby treść prywatna nie trafiła do nieszyfrowanego magazynu przeglądarki — ograniczenie offline Web jest więc jawne, a nie ukryte. Magazyn nie zawiera tokenów ani `userId` w rekordzie (użytkownik jest częścią klucza), a `clearForSession` usuwa intencje przy wylogowaniu i zmianie konta. Polityka ponowień: 400/401/403/409 nie są ponawiane automatycznie, retry zostaje decyzją użytkownika.

Walidacja (Front, uruchomione): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS 1460 (1447 przed tym pakietem; +8 testów trwałości/retry i +5 widoczności odczytu); `git diff --check` — PASS; porównanie OpenAPI z Retrofit — Swagger 463, Flutter 425, brakujące 40 i nadmiarowe 2 bez zmian (wszystkie poza Chat). Backend nie był w tym pakiecie zmieniany, więc jego ostatni zielony stan (278 PASS / 0 FAIL / 3 SKIP) obowiązuje bez zmian.

Otwarte w G4 (świadomie, nie „prawie gotowe”): (1) drafty nie są jeszcze utrwalane po stronie serwera — composer nadal korzysta z lokalnego secure storage, więc pole `isDraft`/`draftText` w skrzynce pozostaje w produkcji puste, mimo że kontrakt je zwraca; (2) powierzchnie UI dla akcji, które mają już porty i adaptery — menu edycji/usuwania, forward, wskaźnik dostawy/doręczenia przy wiadomości — należą do G5 i dopracowania wizualnego w G7; (3) stabilny klucz wiersza i zachowanie przewijania po doładowaniu strony nie mają testu widgetowego, bo te są odroczone do akceptacji wyglądu.

Następny krok: G5 — reakcje, wątki, edycja/usuwanie z menu, przypięcia, zakładki, forward i wyszukiwanie na gotowych portach, z testami ACL i braku eskalacji po G6.

## 2026-09-21 — CHAT-G3 (część 3): kreator rozmowy i bramka na dwóch żywych sesjach

Zakres: `creation/chooser`, `creation/participants`, `creation/details` na gotowym porcie katalogu, przycisk nowej rozmowy w nagłówku panelu oraz bramka G3 wykonana na dwóch rzeczywistych sesjach BFF z żywym backendem.

Pliki (Front, nowe): `lib/workspaces/presentation/chat/creation/chat_creation_sheet.dart`, `creation/cubit/{chat_creation_cubit,chat_creation_state}.dart`, `creation/participants/chat_creation_participants_step.dart`, `creation/participants/cubit/chat_directory_search_cubit.dart`, `creation/details/chat_creation_details_step.dart`, `creation/validation/chat_creation_validation_text.dart`, `test/workspaces/presentation/chat/creation/chat_creation_cubit_test.dart`. Zmienione: `chat_drawer.dart` (nagłówek z licznikiem i akcją nowej rozmowy), `lib/l10n/app_{pl,en}.arb` (+37 kluczy każdy) i regenerowane `app_localizations*`.

Pliki (Backend, nowe): `Tests/Veloryn.Workspaces.Tests/ChatCreationPostgresTests.cs`.

Decyzje: kreator to jedna sesyjna ścieżka (`ChatCreationCubit`) plus osobny cubit wyszukiwania katalogu z debounce i regułą dwóch znaków; walidacja powtarza reguły backendu (1:1 dokładnie jedna osoba, grupa 1–49 osób bez twórcy, nazwa wymagana dla kanału i ogłoszeń, limit 240 znaków), a ogłoszenia blokują wybór publikacji dla wszystkich. Kreator nie tworzy nawigacji: po sukcesie zwraca rozmowę i panel ją wybiera w tym samym widoku. Globalny kanał dostaje nieprzejrzysty klucz zakresu nadany raz przy tworzeniu, bo Scope Global nie ma zakresu poza rozmową; odpowiedź zwraca klucz kanoniczny z prefiksem, więc klient nie może odesłać go jako etykiety (test to pinuje). Duplikatu 1:1 nie pilnuje UI — `POST /conversations/resolve` zwraca istniejącą rozmowę pary, a panel otwiera to, co wróciło.

Bramka G3 — protokół na żywym stacku (uruchomione 2026-09-21, API `https://localhost:5173` przez BFF, sesje A = `misiek440` SystemAdmin i B = `kanban-b-1789899185` User, skrypt `/tmp/chat_g3_two_sessions.py`):
1. `GET /api/v1/chat/users?q=kanban` z sesji A → 200, katalog zwrócił konto B bez adresu e-mail.
2. `POST /api/v1/chat/conversations/resolve` (Direct, Global) z sesji A → 200, `scopeKey = direct:global:{B}:{A}`.
3. `POST …/messages` z sesji A → 200.
4. `GET /api/v1/chat/inbox` z sesji B → 200, `unreadCount = 1` z serwera, preview treści; `GET /api/v1/chat/inbox/unread-count` → `totalUnreadCount = 1`.
5. `POST …/messages/{id}/read` z sesji B → 204, po odczycie `unreadCount = 0` i ustawiony `lastReadMessageId`.
6. `POST /conversations/resolve` z sesji B dla tej samej pary z inną etykietą → ten sam identyfikator rozmowy (brak drugiego DM).
7. Kanał globalny z sesji A → 200; widoczny w skrzynce twórcy, nieobecny w skrzynce B (nieczłonek).
8. Stany błędów: za krótka fraza katalogu → 400 `validation.failed`; skrzynka bez sesji → 401 `auth.unauthorized`; `resolve` bez CSRF → 403 `auth.csrf_invalid`.

Znalazienie operacyjne z żywego przebiegu: lokalna baza deweloperska nie miała zastosowanej migracji `AddChatInboxReadMarker`, więc pierwszy `resolve` zwrócił 500 (`42703: column "LastReadMessageAtUtc" ... does not exist`). Aplikacja nie migruje bazy przy starcie — `dotnet ef database update --context WorkspaceDbContext` zastosował migrację, po czym cała bramka przeszła. To samo dotyczy stagingu i wchodzi do G9. Przy okazji: w tej bazie nie było żadnych wierszy członkostwa, więc backfill migracji nie miał tu na czym pracować.

Walidacja (uruchomione): backend `dotnet test --filter "~Chat|~Notification"` — PASS 278, FAIL 0, SKIP 3 (brak drugiego Redisa na `localhost:6380`), w tym 3 nowe testy tworzenia z dwiema tożsamościami; front `flutter analyze` — 0 problemów, `flutter test` — PASS 1447 (13 nowych testów kreatora i katalogu), `git diff --check` — PASS w obu repo. Zgodnie z planem testy widgetowe i goldeny panelu pozostają odroczone do akceptacji wyglądu.

Otwarte w bramce G3: część wizualna (light/dark, focus, compact, zachowanie trasy w GUI) wymaga uruchomionej aplikacji i zrzutów ekranu; na tym Macu Computer Use nie ma zgody na nagrywanie ekranu, więc zrzuty nie powstają — to blokada środowiskowa, nie brak implementacji. Widget testy dopiero po akceptacji wyglądu.

Środowisko: API zatrzymane po przebiegu (`pkill -f veloryn-workspaces`); do powtórzenia bramki wystarczy start w kształcie `ASPNETCORE_URLS="https://localhost:5173;http://localhost:5072"`, `DEVPLANNER_OPENIDDICT_ISSUER=https://localhost:5173/` i logowanie `/tmp/login.sh`.

## 2026-09-21 — CHAT-G3 (część 2): katalog lokalnych kont odblokowuje tworzenie rozmowy

Zakres: domknięcie luki backendowej wykrytej w części 1 G3. Powstał addytywny endpoint katalogu lokalnych kont dla czatu globalnego oraz port klienta, więc wybór uczestników nowej rozmowy nie wymaga już workspace ani uprawnień administracyjnych.

Pliki (Backend, nowe): `Contracts/Chat/ChatDirectoryContracts.cs`, `Application/Chat/ChatDirectoryService.cs`, `Tests/Veloryn.Workspaces.Tests/ChatDirectoryServiceTests.cs`. Zmienione: `Application/Directory/LocalUserProfileQuery.cs` (nowa metoda `SearchActiveAsync`), `Endpoints/Chat/ChatEndpoints.cs` (`GET /api/v1/chat/users`, parametry `q` i `limit` z domyślnymi wartościami), `Extensions/WorkspaceServiceExtensions.cs` (DI), `Tests/.../ApiEndpointTests.cs` i `ChatOpenApiContractTests.cs`.

Pliki (Front, nowe): `lib/workspaces/domain/chat/directory/{chat_directory_repository.dart,models/chat_directory_entry.dart}`, `lib/workspaces/data/chat/repositories/chat_directory_repository_impl.dart`. Zmienione: `chat_api.dart`, `chat_models.dart` (+ freezed/g), `chat_api_error_mapper.dart`, `repositories.dart`, `global_chat_composition.dart`, `devplanner_standalone_runtime.dart`, `test/workspaces/data/chat/chat_port_adapters_test.dart`.

Decyzje: katalog jest globalny, bo §4.3 zabrania używania workspace jako warunku globalnego DM; jedyne wcześniejsze źródło kandydatów było zakresowe po workspace. Bezpieczeństwo: fraza od 2 do 80 znaków, limit 1–50 (domyślnie 20), wyłącznie konta aktywne i potwierdzone, własne konto wykluczone, a odpowiedź nie zawiera adresu e-mail (kontrakt to `userId`, `login`, `displayName`, `avatarUrl`). Parametry są wiązane jawnie, żeby OpenAPI pokazywało `q` i `limit` małymi literami z wartościami domyślnymi, tak jak trasy inboxa.

Walidacja (Backend, uruchomione): `dotnet build veloryn-workspaces.csproj --no-restore` — PASS, 0 ostrzeżeń; `dotnet test --filter "FullyQualifiedName~Chat|~Notification|~Directory"` — PASS 288, FAIL 0, SKIP 3 (drugi Redis na `localhost:6380`); testy katalogu dowodzą braku kont nieaktywnych i niepotwierdzonych, braku e-maila w kontrakcie oraz odrzucenia frazy jednoznakowej i limitu powyżej 50.

Walidacja (Front, uruchomione): `dart run build_runner build --delete-conflicting-outputs` — PASS; `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS, 1434 testy; `git diff --check` — PASS. Bramka kontraktu na świeżym OpenAPI: Swagger 463, Flutter 425, brakujące 40 i nadmiarowe 2 bez zmian, **brak luk w trasach Chat** — nowa trasa katalogu jest po obu stronach. Wygenerowany `chat_models.freezed.dart` znowu zawierał linie z trailing whitespace; znormalizowano je po regeneracji.

Następny krok: `creation/chooser`, `creation/participants` i `creation/details` na froncie — typ rozmowy, wybór osób z katalogu, walidacja, duplicate DM przez `POST /conversations/resolve` i otwarcie nowej rozmowy w panelu; testy widgetowe dopiero po akceptacji wyglądu.

## 2026-09-21 — CHAT-G3 (część): lista skrzynki w panelu

Zakres: pierwszy pion G3 — komponenty `inbox/list` i `inbox/search` z cubitem skrzynki zastępują w panelu dotychczasową listę rozmów z kontraktu bazowego. Część tworzenia rozmowy (`creation/chooser`, `creation/participants`, `creation/details`) jest zablokowana brakiem katalogu użytkowników i opisana niżej jako luka backendowa.

Pliki (Front, nowe): `lib/workspaces/presentation/chat/inbox/cubit/{chat_inbox_cubit,chat_inbox_state}.dart`, `lib/workspaces/presentation/chat/inbox/components/{chat_inbox_list,chat_inbox_row}.dart`, `lib/workspaces/data/chat/models/chat_conversation_mapper.dart`, `test/workspaces/presentation/chat/inbox/chat_inbox_cubit_test.dart`.

Pliki (Front, zmienione): `chat_drawer.dart`, `chat_panel_conversation.dart`, `chat_panel_conversation_parts.dart`, `shell/cubit/chat_panel_selection_cubit.dart`, `chat_repository_impl.dart`, `chat_inbox_repository_impl.dart`, `chat_conversation_management_repository_impl.dart`, `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb` (+ regenerowane `app_localizations*`).

Decyzje: kubit skrzynki ma jedną odpowiedzialność (filtr, kursor, licznik) i nie zna widgetów; fraza filtruje już pobrane pozycje, bo wyszukiwanie wiadomości po serwerze należy do G5 — lokalny filtr nie udaje wyszukiwania po serwerze. Nagłówek panelu pokazuje serwerowy agregat nieprzeczytanych, a nie sumę widocznych pozycji. Wybór rozmowy przeniesiono na model domenowy `ChatConversation`, żeby panel nie zależał od DTO transportu; powstał jeden wspólny mapper DTO→domena używany przez wszystkie adaptery (usunięto trzy duplikaty). Lista z kontraktu bazowego została wyłącznie jako fallback kompozycji bez portu skrzynki; produkcja zawsze ma port. Panele 429/limitów, goldeny i testy widgetowe pozostają odroczone do akceptacji wyglądu, dlatego dodano tylko testy kubita (6).

Walidacja (Front, uruchomione): `flutter gen-l10n` — PASS; `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS, 1432 testy (1426 przed tym pakietem); `git diff --check` — PASS; porównanie OpenAPI z Retrofit — Swagger 462, Flutter 424, bez zmian. Uwaga: `dart format` na ARB przepisał całe pliki, więc je przywrócono i klucze dodano punktowo (po 29 linii na plik); formatowanie ograniczono do jawnej listy plików.

Luka backendowa blokująca G3 (tworzenie rozmowy): nie istnieje endpoint katalogu lokalnych kont dla czatu globalnego. Jedyne źródło kandydatów to `GET /api/v1/workspaces/{workspaceId}/users/search`, a §4.3 planu zabrania używania workspace jako warunku rozpoczęcia globalnego DM; `/api/v1/admin/users` wymaga uprawnienia administracyjnego. Bez addytywnego endpointu (np. `GET /api/v1/chat/users?q=`) nie da się zbudować wyboru uczestników bez naruszenia granicy produktu. Następny krok: dodać ten endpoint w backendzie razem z testami ACL, a potem `creation/*` na froncie.

## 2026-09-21 — CHAT-G2: rozdzielone porty klienta i jedno źródło sesji REST/SignalR

Zakres: domknięcie G2 na froncie — pozostałe porty klienta, transport realtime zgodny z Web BFF (cookie + CSRF), sesyjny właściciel subskrypcji oraz czyszczenie prywatnego stanu po zakończeniu sesji.

Pliki (Front, nowe): `lib/workspaces/domain/chat/management/{chat_conversation_management_repository.dart,models/chat_conversation_create_command.dart}`, `lib/workspaces/domain/chat/members/{chat_members_repository.dart,models/chat_member.dart}`, `lib/workspaces/domain/chat/search/{chat_search_repository.dart,models/chat_search_models.dart}`, `lib/workspaces/domain/chat/presence/{chat_presence_repository.dart,models/chat_user_status.dart}`, `lib/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart`, `lib/workspaces/data/chat/repositories/{chat_conversation_management,chat_members,chat_message_actions,chat_search,chat_presence}_repository_impl.dart`, `lib/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart`, testy: `chat_port_adapters_test.dart`, `workspace_realtime_credentials_test.dart`, `workspace_chat_realtime_factory_test.dart`, `secure_chat_draft_repository_test.dart`.

Pliki (Front, zmienione): `chat_message_actions_repository.dart` (+ `forward`, `pins`, `bookmarks`, `reactions`), `chat_message_revision.dart` (pola `authorUserId`/`editedByUserId` zamiast dawnych nazw Core), `chat_draft_repository.dart` (+ `deleteAllForUser`), `secure_chat_draft_repository.dart`, `workspace_signalr_client.dart`, `workspace_chat_realtime_service.dart`, `storage_realtime_composition.dart`, `workspace_scoped_realtime_service.dart`, `chat_drawer.dart`, `chat_panel_conversation.dart`, `chat_conversation_page.dart`, `chat_realtime_status_cubit.dart`, `global_chat_composition.dart`, `devplanner_standalone_runtime.dart`, `chat_realtime_event_mapper.dart`.

Decyzje: każdy obszar ma osobny port i adapter, więc panel nie dostaje jednego wielkiego repozytorium; modele domenowe nie zawierają pól transportu. Port `presence` obejmuje REST-owy status własny i cudzy, bo lease obecności i typing są wywołaniami huba i należą do portu subskrypcji rozmowy. Poświadczenia realtime pochodzą z tego samego transportu co REST: desktop z access tokenu PKCE, a Web z cookie BFF i nagłówka `X-DevPlanner-CSRF` przy negotiate — kod Flutter Web nadal nie czyta tokenu. Zamiast po jednym transporcie na każdy rebuild widoku jest sesyjny właściciel subskrypcji: ta sama rozmowa dostaje tę samą subskrypcję, połączenie zamyka się po ostatniej dzierżawie, a `closeAll` po zakończeniu sesji; kolejka wysyłki i historia żyją w Cubitach panelu, więc trwałym stanem prywatnym do usunięcia przy wylogowaniu są szkice w secure storage (`deleteAllForUser`). Envelope z nowszą wersją kontraktu jest mapowany na `unsupported`, co reduktor zamienia na pełny resync, zamiast stosować zdarzenie po staremu.

Walidacja (Front, uruchomione): `dart run build_runner build --delete-conflicting-outputs` — PASS; `flutter gen-l10n` — PASS; `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS, 1426 testów (1396 przed tym pakietem, +30 nowych: 13 adapterów portów, 7 poświadczeń, 5 właściciela subskrypcji, 3 magazynu szkiców, 2 wersji kontraktu); `git diff --check` — PASS; `python3 tool/verify_workspaces_contracts.py /tmp/swagger2.json` — Swagger 462, Flutter 424, brakujące 40 i nadmiarowe 2 bez zmian (wszystkie poza Chat). Uwaga warsztatowa: `dart format` przepisał niezwiązany `storage_realtime_client_adapter.dart`; plik przywrócono do HEAD, a pozostałe pliki formatowano z jawnej listy.

Ograniczenia i NOT RUN: ścieżka Web SignalR jest pokryta testami wyboru poświadczeń i nagłówków negotiate, ale nie została jeszcze zweryfikowana na działającym backendzie z prawdziwą przeglądarką — to zadanie G8 (dwie sesje), gdzie trzeba potwierdzić, że handshake z cookie faktycznie się autoryzuje. Nie ma też testu samego `DevPlannerStandaloneRuntime` (brak infrastruktury testowej dla runtime'u), a `flutter build macos`, GUI i staging pozostają NOT RUN.

Następny krok: G3 — zastąpić listę w `chat_drawer.dart` komponentami `inbox/list`, `inbox/search`, `creation/chooser`, `creation/participants`, `creation/details` na nowych portach i pokazać działającą demonstrację na dwóch sesjach.

## 2026-09-21 — CHAT-G2 (część): port ustawień powiadomień w hoście paneli

Zakres: domknięcie realnej dziury kompozycji wykrytej w audycie G0 — `ChatNotificationSettingsRepositoryImpl` istniał, ale żaden composition root go nie tworzył, więc oba modale ustawień powiadomień Chat (`chat_conversation_notification_settings_modal.dart`, `notifications/preferences/notification_preferences_modal.dart`) sięgały po nieistniejący provider i kończyły się `ProviderNotFoundException` w działającej aplikacji.

Pliki (Front): `lib/app/shell/overlays/devplanner_global_panels_host.dart`, `lib/workspaces/presentation/chat/global_chat_composition.dart`, `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart`, `test/app/shell/overlays/global_panels_host_providers_test.dart`.

Decyzje: port trafia do `DevPlannerGlobalChatComposition` i jest montowany w hoście nad `DevPlannerPanelsScope`, a nie w poddrzewie panelu, bo modale ustawień są rootowe i czytają port z kontekstu wywołującego. Przy braku kompozycji host celowo nie udostępnia portu, żeby brak adaptera nie zamienił się w cichą atrapę. To pierwszy test hosta paneli w repo (dotąd nie miał żadnego).

Walidacja (Front): `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS, 1396 testów (2 nowe hosta); `git diff --check` — PASS. Bramka kontraktu bez zmian: Swagger 462, Flutter 424, brakujące 40 (poza Chat), nadmiarowe 2. NOT RUN: GUI i staging.

Następny krok: pozostałe porty G2 (`conversation-management`, `message-actions`, `members`, `search`, `presence`), transport SignalR dla Web BFF (cookie/CSRF), session-scoped właściciel subskrypcji i czyszczenie prywatnego stanu po logout/401/revoke; potem G3.

## 2026-09-21 — CHAT-G2 (część): port skrzynki w kliencie

Zakres: pierwszy pion G2 na froncie — rozdzielony port `inbox` z adapterem, kontrakt DTO skrzynki i domknięcie luki kontraktowej z G0 (dwie brakujące trasy Retrofit). Pozostałe porty G2, transport SignalR dla Web BFF, lifecycle sesji i utwardzenie reducera pozostają otwarte.

Pliki (Front): `lib/workspaces/domain/chat/inbox/chat_inbox_repository.dart`, `lib/workspaces/domain/chat/inbox/models/{chat_inbox_filter,chat_inbox_item,chat_inbox_message_preview,chat_inbox_page,chat_inbox_participant,chat_inbox_unread_count,chat_inbox_export}.dart`, `lib/workspaces/data/chat/repositories/chat_inbox_repository_impl.dart`, `lib/workspaces/data/chat/api/chat_api.dart` (+ regenerowany `.g.dart`), `lib/workspaces/data/chat/models/chat_models.dart` (+ freezed/g), `lib/workspaces/data/chat/errors/chat_api_error_mapper.dart`, `lib/workspaces/data/chat/repositories/repositories.dart`, `lib/workspaces/presentation/chat/global_chat_composition.dart`, `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart`, `test/workspaces/data/chat/chat_inbox_repository_impl_test.dart`.

Decyzje: `inbox` jest osobnym portem, bo skrzynka ma własny kontrakt (serwerowy licznik, kursory, znacznik odczytu) i nie może wymagać pobrania historii do policzenia badge. `markRead` należy do portu skrzynki, bo zmienia serwerowy licznik; UI nie oznacza odczytu przy samym pobraniu historii. Modele domenowe nie zawierają identyfikatorów transportu i mają własne etykiety prezentacji (`displayName`, `label`) z bezpiecznym fallbackiem do `userId`, gdy profil nie jest widoczny. Filtr jest enumem z wartościami tekstowymi kontraktu, żeby UI nie budowało zapytań.

Walidacja (Front, uruchomione): `dart run build_runner build --delete-conflicting-outputs` — PASS; `flutter gen-l10n` — PASS; `flutter analyze` — PASS, 0 problemów; `flutter test` — PASS, 1394 testy (w tym 9 nowych adaptera skrzynki); `python3 tool/verify_workspaces_contracts.py /tmp/swagger2.json` — Swagger 462, Flutter 424, brakujące 40 (wyłącznie wcześniejsze luki poza Chat), nadmiarowe 2 (wcześniejszy rozjazd `auth/me` i `me/avatar`), brak luk inboxa; `git diff --check` — PASS. Uwaga warsztatowa: generator freezed 3.x odrzuca gołe `@Freezed` (plik używa `@freezed`), a wygenerowany plik zawierał 2 linie z trailing whitespace, które znormalizowano, żeby bramka `git diff --check` była czysta. NOT RUN: buildy platform (`flutter build macos`), GUI, staging, testy widgetowe i goldeny (odroczone do akceptacji wyglądu).

Następny krok: dokończyć G2 — rozdzielić pozostałe porty (`conversation-management`, `message-actions`, `members`, `search`, `presence`, `settings`), doprojektować transport SignalR dla Web BFF (cookie/CSRF) i session-scoped właściciela subskrypcji oraz wyczyścić prywatny cache/draft/queue po logout/401/revoke; następnie G3 zastępuje listę w `chat_drawer.dart` komponentami inboxa.

## 2026-09-21 — CHAT-G0/G1: audyt kontraktu i serwerowa skrzynka Chat

Zakres G0: audyt aktywnego Chat w obu repo względem §3 planu, porównanie wygenerowanego OpenAPI z klientem Retrofit i wypisanie luk. Zakres G1: backendowa skrzynka `GET /api/v1/chat/inbox` i `GET /api/v1/chat/inbox/unread-count` z serwerowym licznikiem nieprzeczytanych, podglądem ostatniej wiadomości, kursorem i ACL. Front nie został w tym pakiecie zmieniony.

Mapa §3 → stan po G0 (gotowe / wymaga podłączenia / backend gap):

| §3 | Stan | Uwaga |
| --- | --- | --- |
| Chat z belki w panelu, trasa i formularz zachowane | gotowe | `devplanner_shell_layout.dart`, `devplanner_global_panels_host.dart`, jeden `_activePanel` wymusza wzajemne wykluczanie z Notifications |
| Szerokość 380–640 px i tryb przypięty | wymaga podłączenia | brak preferencji i pinu; stała 420/448 px w hoście panelu |
| Nagłówek panelu (licznik, nowa rozmowa, wyszukiwanie, menu, pin) | wymaga podłączenia | zamknięcie i Escape działają; reszta brak |
| Lista rozmów (avatar, nazwa, ostatnia wiadomość, czas, unread, mute, draft) | backend domknięty w G1, front wymaga podłączenia | `GET /conversations` nie miał unread/preview; `/inbox` je dostarcza |
| Wejście w rozmowę i powrót bez zmiany trasy | gotowe | `ChatPanelSelectionCubit` |
| Historia cursorowa bez skakania | wymaga podłączenia | `listConversationMessages` zachowuje kursor, ale `ChatRepositoryImpl.listMessages` gubi `nextCursor` i hardkoduje limit 100 |
| Composer (Enter/Shift+Enter, reply, emoji, wzmianki, załącznik, upload) | częściowo | klawiatura i szkic gotowe; emoji i wzmianki brak; `attachmentUploadPort` i `filePickerPort` są `null` w produkcji |
| Stan per wiadomość sending/sent/failed + retry | częściowo | `ChatMessageDeliveryQueue` gotowa domenowo, brak wizualizacji i retry w UI |
| Tworzenie 1:1/grupa/kanał/ogłoszenia + katalog + duplicate DM | backend gotowy po G1, front wymaga podłączenia | brak UI tworzenia; poprawiono drugi DM tej samej pary |
| Menu wiadomości i rozmowy z realnym skutkiem | wymaga podłączenia | porty `ChatMessageActions`/`ChatThread`/`ChatDiscussion` zwracają `null` w produkcji |
| Wyszukiwanie czatu i skok do wiadomości | backend gotowy, front wymaga podłączenia | `/search` i `/search/facets` istnieją, brak wywołań |
| Unread badge z serwera, read po zobaczeniu | backend gotowy w G1, front wymaga podłączenia | `markRead` nigdy nie było wołane, brak pola unread w kontrakcie |
| Statusy online/typing z TTL, offline/reconnecting | częściowo | realtime ma `HeartbeatPresence`/`SetTyping`, brak UI i presencji w kliencie |
| Tokeny wizualne bez domyślnego Materialu | backend gap → G7 | popupy, menu i dialogi czatu wymagają przejścia na tokeny |
| ARB, skala tekstu, dostępność, brak technicznych ID w panelu | backend gap → G7 | lista pokazuje dziś `scopeKey` i skrót UUID |

Pliki G1 (Backend): `Contracts/Chat/ChatInboxContracts.cs`, `Infrastructure/Chat/ChatInboxReader.cs` (odczyt EF i wspólny predykat `ChatConversationVisibility.VisibleTo`), `Application/Chat/ChatInboxService.cs`, `Application/Chat/ChatInboxFilterParser.cs`, `Application/Chat/ChatConversationMapper.cs`, `Application/Chat/ChatCursor.cs`, `Application/Chat/ChatService.cs`, `Domain/Entities/ChatConversationMember.cs`, `Migrations/20260921135717_AddChatInboxReadMarker.cs`, `Endpoints/Chat/ChatEndpoints.cs`, `Extensions/WorkspaceServiceExtensions.cs`, `Tests/Veloryn.Workspaces.Tests/ChatInboxPostgresTests.cs`, `ChatOpenApiContractTests.cs`, `ApiEndpointTests.cs`.

Decyzje G1: wybrano jeden kontrakt — strona snapshotu plus osobny agregat `unread-count`, bez pola agregatu w stronie. Licznik nieprzeczytanych pochodzi wyłącznie z serwerowego, monotonicznego znacznika `LastReadMessageAtUtc` zapisywanego przy odczycie, z podłogą `JoinedAtUtc`; nie używa Notifications ani lokalnego zgadywania. Podgląd używa znormalizowanej treści wyszukiwania (bez sekretów) skróconej do 240 znaków; wiadomość usunięta ma `text = null`. Kolejność jest stabilna: malejący czas ostatniej aktywności, a przy równym czasie UUID rozmowy; czas aktywności to maksimum czasu wiadomości, a dla rozmowy bez wiadomości czas jej utworzenia. Rozmowa Resource wchodzi do skrzynki tylko z aktywnym członkostwem materializowanym przy pierwszym wejściu i jest dodatkowo reautoryzowana u providera (fail-closed). Globalny Direct ma kanoniczny klucz pary, więc etykieta klienta nie tworzy drugiej rozmowy 1:1, a stare klucze nadal trafiają w tę samą rozmowę pary. Odpowiedzi w wątkach liczą się do licznika i do czasu aktywności. Migracja jest addytywna: nowa kolumna plus jednorazowy backfill `LastReadMessageAtUtc` z `LastReadMessageId`; rollback to usunięcie kolumny, bo `LastReadMessageId` pozostaje źródłem.

Walidacja (Backend, uruchomione): `dotnet build veloryn-workspaces.csproj --no-restore` — PASS, 0 ostrzeżeń, 0 błędów. `dotnet test Tests/Veloryn.Workspaces.Tests/Veloryn.Workspaces.Tests.csproj --filter "FullyQualifiedName~Chat|FullyQualifiedName~Notification"` — PASS 272, FAIL 0, SKIP 3; pominięte to `ChatRedisIntegrationTests` (2) i `ChatSignalRTwoHostIntegrationTests` (1), bo wymagają drugiego Redisa na `localhost:6380`, którego lokalnie nie ma — to blokada dla weryfikacji dwóch instancji z G8, nie sukces. Bramka G0: `python3 tool/verify_workspaces_contracts.py /tmp/swagger2.json` w `Front` — Swagger 462 trasy, Flutter 422; 42 brakujące i 2 nadmiarowe. Wśród brakujących są wyłącznie 40 wcześniejszych luk poza Chat (admin/me/auth/BFF/task-list) oraz 2 nowe trasy inboxa, które G2 doda do Retrofit; nadmiarowe `GET /api/v1/auth/me` i `PUT /api/v1/me/avatar` to wcześniejszy rozjazd profilu, poza zakresem Chat. `git diff --check` w obu repo — PASS. Migracja przetestowana na PostgreSQL 5440 w każdym z 9 testów skrzynki (świeża baza + `MigrateAsync`). NOT RUN: pełna suite backendu, frontowe bramki (`flutter analyze`, `flutter test`), buildy platform, GUI, staging — pakiet nie zmienia Frontu.

Następny krok: G2 — rozdzielone porty klienta i lifecycle sesji, w tym dwie metody Retrofit inboxa, transport SignalR dla Web BFF i session-scoped właściciel subskrypcji; potem G3 zastępuje listę w `chat_drawer.dart` komponentami inboxa.

## 2026-09-21 — CHAT-G0: plan i oczyszczenie dokumentacji

Zakres: audyt aktywnego Chat w `Backend` i `Front`; nowy `Backend/docs/global-chat-implementation-plan-2026-09-21.md` określa funkcje, luki, pakiety G0–G9, ścieżki repozytoriów, reguły UI i staging. `Backend/docs/chat-messaging-implementation-plan.md` i `Front/docs/global-shell-chat-notifications-implementation-plan-2026-09-13.md` zastąpiono odsyłaczami; przepisano `Backend/docs/chat-messaging-client-contract.md` i `Backend/docs/chat-signalr-contract.md` na lokalną tożsamość. Zaktualizowano `Backend/README.md`, `Backend/docs/implementation-status.md` i opis tagu Chat w `Backend/Infrastructure/OpenApi/ChatDocumentFilter.cs`.

Decyzje: globalny prawy panel bez osobnej trasy; bieżący backend pozostaje źródłem prawdy, a G1 domyka inbox/unread. Front Web BFF nie udostępnia tokenu dla istniejącego adaptera SignalR i wymaga osobnego, zgodnego z cookie/CSRF rozwiązania. Testy uruchamiane zbiorczo po większych etapach; goldeny i testy widgetowe dopiero po akceptacji wyglądu. Ręczny deploy stagingu jest dopuszczony przez użytkownika, ale wymaga commita dostępnego dla skryptu; agent nie wykonuje commit/push bez polecenia.

Walidacja: audyt kodu i dokumentacji; `git diff --check` w obu repo — PASS; `dotnet build veloryn-workspaces.csproj --no-restore` — PASS, 0 ostrzeżeń i 0 błędów. Testy, aplikacja GUI i staging — NOT RUN, ponieważ ten pakiet zmienia plan i opisy, bez implementacji funkcjonalnej. Następny krok: G0/G1 — potwierdzić OpenAPI, zaprojektować serwerowy inbox i wykonać backendową implementację.


## 2026-09-19 — staging: desktop auth, commit 1c11573

- [x] Wdrożono Backend `1c11573fd37f1d0d42f989e11e26bb8ddcd62439`
  skryptem `devplanner-deploy-local` na VPS; automatyczny run Actions
  `35442774260` anulowano przed ręcznym wdrożeniem.
- [x] Build Release, oba migratory, kontener healthy, publiczne readiness
  `Healthy`, zapytanie kontrolne PostgreSQL i odrzucenie błędnego Bearera 401.
- [ ] Pełna suite Backend nie jest zielona: 1152 PASS, 7 FAIL, 1 SKIP;
  testowy kontener DI w `MeEndpointsTests` nie rejestruje
  `DeviceSessionRealtimeConnectionRegistry`. Produkcyjny kontener ją rejestruje.
- [ ] Desktopowy E2E Keychain/restart/update i dystrybucyjny instalator
  pozostają otwarte. To wdrożenie nie publikuje nowej aplikacji desktopowej.

Raport: `Backend/docs/recovery/desktop-auth-staging-deployment-2026-09-19.md`.
Nie wykonano dodatkowego commita; użyto commita dostarczonego przez użytkownika.


Data stanu: **2026-09-17**  
Zakres: wyłącznie zaakceptowane pakiety 2D, 3D, 4B, 4C, 4D, 4E, 4F, 4G, 4H,
4I, 4J, 4N, 4O, 4P, 4Q, 4R-B, 4R Front, 4S, 6F i 6G.

Ten handoff jest wspólny dla:

- `/Users/przemyslawnowak/Desktop/dev/DevNote/Backend`
- `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`

Kopie planu i handoffu muszą być byte-for-byte identyczne. Pakiety 4R-B, 4R
Front i 4S obejmują wyłącznie zaakceptowane runtime/docs cleanup; nie zmieniano
historycznych migracji ani testów w ramach synchronizacji dokumentacji.

## Zaakceptowane pakiety

### 2D — sesje urządzeń i refresh tokeny

Zaakceptowane po wspólnym targeted suite **119/119**. Obejmuje lifecycle
`DeviceSession`, persistence, rotację rodzin refresh tokenów oraz revoke.

### 3D — frontend auth/admin/me

Zaakceptowane z `AuthComposition` oraz seamami admin/profile/session w ustalonym
zakresie. Produkcyjny transport i E2E nie są objęte tą akceptacją.

### 4B — schemat domeny, FK i indeksy

Zaakceptowane po poprawce przeglądu CSRF. Akceptacja nie obejmuje pozostałych,
niemigrowanych agregatów.

### 4C — OpenAPI oraz Chat/Notifications `UserId`

Zaakceptowane po korekcie indeksu migracji; walidacja PostgreSQL Notifications
wyniosła **41/41**.

### 4D — Tasks/Kanban lokalny `UserId`

Tasks/Kanban używa lokalnego UUID `UserId` w encjach, kontraktach,
query/handler/mapper, capacity, preferencjach Kanban, realtime/outbox/workers
oraz konfiguracji EF/indexes. Z tego pionu usunięto `*CoreUserId` i legacy Ready.
Nie dodano aliasów, dual-read/write, fallbacku ani backfillu.

Dowody:

- backend build: **0/0**, PASS, zero ostrzeżeń;
- targeted Tasks/Kanban unit/handler suite: **100/100**, PASS (69 + 31);
- idempotentny skrypt migracji EF: PASS.

PostgreSQL integration dla 4D nie zostało zweryfikowane. Filtr zatrzymał się na
nieprawidłowych credentials istniejącej instancji `127.0.0.1:5440`. Jest to
blokada środowiskowa, nie PASS; nie wolno przedstawiać jej jako dowodu działania
migracji na PostgreSQL.

### 4E — Projects/Workspace lokalny `UserId`

Pakiet zaakceptowany dla lokalnego UUID `UserId` w Projects/Workspace.

Dowody:

- backend build: **0/0**, PASS, zero błędów i ostrzeżeń;
- agent gate: **17/17**, PASS;
- dodatkowy root gate: **20**, PASS.

Dwa przypadki `WorkspaceRoleHttpIntegration` zakończyły się niepowodzeniem na
fixture setup, ponieważ środowiskowa baza testowa nie ma tabeli
`veloryn_workspaces.workspaces`. To problem fixture/provisioningu środowiskowej
bazy testowej, a nie błąd logiki. Należy zapewnić tabelę i ponowić te dwa
przypadki.

### 6F/6G — frontendowe typed adapters rename

Globalny Chat (6F) i Notifications (6G) są zaakceptowane w zakresie standalone
runtime wiring oraz rename do typowanych adapterów z lokalnym `UserId`.

Dowody:

- targeted frontend suite: **11/11**, PASS;
- `flutter analyze`: PASS.

Akceptacja nie obejmuje produkcyjnego transportu sesji ani pełnych E2E.

### 4F — frontend auth lokalny `UserId`

Zaakceptowano migrację aktywnego rdzenia auth Fluttera. `AuthUser` używa
kanonicznych pól `String userId` i `login`; w zakresie 4F usunięto aliasy
`CoreUserId`/Ready oraz stare call site'y auth w shellu, routerze, pickerze i
wątkach. Typed `/api/v1/me` jest kontraktem profilu. Nie dodano fallbacku
Ready/Core/DataBus ani dual-read/write.

Dowody:

- `flutter test test/core/auth`: **48/48** PASS;
- `flutter test test/auth`: **16/16** PASS;
- `flutter test test/app/router`: **9/9** PASS;
- suma targeted suite: **73/73** PASS;
- `flutter analyze`: PASS, bez problemów;
- `git diff --check`: PASS.

Pozostałe domenowe DTO frontendu, w szczególności Tasks, Projects i Storage,
są poza zakresem 4F i pozostają do osobnych migracji lokalnego `UserId`.

### 4G — Storage/Office/avatar/share/AI lokalny `UserId`

Storage entities/contracts, ACL, upload/download, Office/OnlyOffice, avatary,
współdzielenie, wyszukiwanie semantyczne i zadania AI używają lokalnego UUID
`UserId`. Usunięto parametry i aliasy `CoreUserId`/Ready oraz fallbacki; testy
bezpośrednie używają wyłącznie `X-Test-User-Id`.

Nie dodano migracji EF: schemat jest już lokalny, a
`StorageUserNotificationPreference` został poprawnie przemianowany w migracji
4C. Dodanie duplikatu migracji byłoby błędem.

Dowody: backend build **0/0**, wybrana suite **135/135** PASS, formatowanie i
`git diff --check` PASS. Szersza bramka HTTP/integration Storage pozostaje
otwarta z powodu fixture `42P01` i standalone guarda legacy environment; nie
jest to PASS.

### 4H — Wiki/Whiteboard/OKR lokalny `UserId`

Wiki/Whiteboard access grants używają `UserId`, Objective używa
`CreatedByUserId`, a StickyNote używa `AssigneeUserIds`; nie ma aliasów ani
fallbacków. Zastosowano rename-only migrację
`20260917074039_UseLocalUserIdForWikiWhiteboardAndOkr`.

Dowody: root selected suite **74/74** PASS (agent narrow **57/57**), build
**0/0**, migracja idempotentna i diff clean. Wiki HTTP/OpenAPI integration
była historycznie blokowana przez legacy JWKS environment; 4O usuwa tę
odziedziczoną konfigurację, ale szersza bramka Wiki HTTP nadal wymaga własnych
ukierunkowanych dowodów.

### 4I — frontend Tasks/Kanban lokalny `UserId`

Tasks/Kanban frontend używa lokalnych pól `userId`, `assigneeUserId`,
`assigneeUserIds` i `userIds` w modelach, payloadach, query, repozytoriach,
realtime oraz UI, w tym w profilach członków projektu, board/list/details,
templates, capacity i workload. Wygenerowane Freezed/JSON/Retrofit zostały
odświeżone; nie ma aliasów, fallbacku ani mapowania Ready/Core.

Dowody: targeted suite **116/116** PASS, generator 182 outputs PASS, scoped
analyze PASS, skan pakietu bez `CoreUserId`/`coreUserId`/`ReadyUserId`/
`readyUserId`/`ready_id`, `git diff --check` PASS. Późniejszy pełny analyze po
4J nie jest dowodem testów E2E Tasks/Kanban.

### 4J — frontend Workspace members, invitations i lokalny katalog

Kontrakty członków workspace i zaproszeń używają `userId`. Lokalny katalog
publikuje `userId`, `login`, `displayName`, `email`, `emailVerified` oraz
`avatarFileId`; repozytorium używa `searchLocalUsers`, bez fallbacku i
dual-read/write. Zaktualizowano bezpośrednie call-site’y Project/Storage oraz
artefakty generowane.

Dowody: focused suite **10/10** PASS, dodatkowa suite kontraktów i konsumentów
**11/11** PASS, generator 5 artefaktów PASS, `flutter analyze` PASS,
`git diff --check` PASS. Pozostałe workspace core `createdByCoreUserId`/
starsza wzmianka o feature actors i legacy DTO została zamknięta przez aktualny
source scan; nie rozszerza to dowodów na pełne E2E/platform.

### 4K — frontend Projects/Workspace core lokalny `UserId`

Zaakceptowano frontendowe kontrakty Projects/Workspace core. `ProjectResponse`,
`ProjectMemberResponse`, `PortfolioResponse` i `WorkspaceResponse`, listy oraz
mappery używają `createdByUserId` i `userId`. Zaktualizowano bezpośrednie
wywołania Project i artefakty generowane; bez aliasów, fallbacku ani
dual-read/write.

Dowody: agent suite **27/27** PASS, dodatkowy test generatora **1/1** PASS,
root cross-package selective suite **18/18** PASS, `flutter analyze` PASS oraz
`git diff --check` PASS. Aktualny source scan nie wykazuje dawniej wskazanych
legacy feature actors/DTO; pełne E2E/platform pozostają osobnym zakresem.

### 4L — frontend Storage/Wiki/Whiteboard/ACL lokalny `UserId`

Zaakceptowano kontrakty frontendowe Storage, Office, avatarów, share i AI oraz
Storage/Wiki/Whiteboard ACL. `Objective` używa `createdByUserId`, sticky notes
`assigneeUserIds`, a artefakty generowane są odświeżone. Zakres nie zawiera
aliasów `CoreUserId`/Ready, fallbacków ani dual-read/write.

Dowody: agent suite **23/23** PASS, root cross-package selective suite
**18/18** PASS, `flutter analyze` PASS oraz `git diff --check` PASS. Pełny
build runner dodatkowo wygenerował workspace responses, ale ich autorytatywnym
źródłem pozostaje pakiet 4K; nie rozszerza to zakresu 4L.

### 4N — backendowe aktywne identity names i transport

Pakiety 4N-A, 4N-B i 4N-C zaakceptowano dla aktywnych warstw backendu. Nie ma
w nich nazw identity `Core`/`Ready`; transport używa kanonicznych nazw
`userId`, `actorUserId` i `authorUserId` w zakresie Ops/Admin, globalnego
wyszukiwania Chat oraz cleanupu Projects. Nie dodano aliasów, fallbacków ani
dual-read/write.

Obowiązuje jedna rename-only migracja
`20260917082352_UseLocalUserIdForOpsInfrastructure`; nie należy utrzymywać
drugiej migracji wykonującej te same rename’y.

Dowody: 4N source scan PASS, backend build **0/0** PASS, idempotentny skrypt
migracji EF PASS, formatowanie PASS i `git diff --check` PASS.

Test HTTP/OpenAPI dla AdminOps i ChatSearch został następnie zamknięty przez
4Q jako **11/11 PASS**; pozostałe szerokie bramki HTTP/integration wymagają
osobnych fixture’ów i nie są przez to automatycznie PASS.

### 4O — standalone test host i lokalny Identity/OpenIddict

Pakiet zaakceptowany dla testowego hosta, fixture’ów i helperów lokalnego
standalone Identity/OpenIddict. Fixture’y testowe czyszczą zabronione,
odziedziczone `WORKSPACES_JWKS_URL`, `WORKSPACES_JWT_ISSUER` i
`WORKSPACES_JWT_AUDIENCE`, a następnie używają lokalnego issuera OpenIddict.
Nie zmieniano produkcyjnej logiki, aliasów ani fallbacków.

Dowody: backend build **0/0** PASS, Local Identity/OpenIddict tests **19/19**
PASS, scoped format verify helpera oraz `git diff --check` PASS.

Pełna weryfikacja formatu projektu ma niezależne, historyczne whitespace
diagnostics i nie jest issue produktu. Wcześniejsze `dotnet format` uruchamiane
z root repo było niejednoznaczne co do wyboru projektu; późniejsze weryfikacje
wykonywać jawnie, np. `dotnet format veloryn-workspaces.csproj
--verify-no-changes`.

### 4P — konkretny kontrakt OpenAPI dla avatarów

Pakiet zaakceptowany dla endpointów `GET /api/v1/me/avatar` i
`GET /api/v1/users/{userId}/avatar`. Usunięto wildcard `image/*`; OpenAPI
publikuje dokładnie `image/jpeg`, `image/png` i `image/webp`, zgodnie z
walidacją uploadu i magic bytes. Upload, storage, cache/ETag i statusy błędów
pozostały bez zmian.

Dowody: backend build **0/0** PASS, OpenAPI avatar content types PASS oraz
avatar upload tests **3/3** PASS.

### 4Q — disposable fixture i kontrakt OpenAPI AdminOps

Pakiet zaakceptowany w zakresie standalone HTTP/OpenAPI. `AdminOpsPostgresFixture`
tworzy losową disposable bazę PostgreSQL, stosuje aktualne migracje
`WorkspaceDbContext` i `LocalIdentityDbContext`, a po testach ją usuwa. OpenAPI
waliduje standalone BFF cookie `BffSessionCookie` (`devplanner.bff`, `apiKey`
w `cookie`), bez `Bearer` i bez wewnętrznego `IdentityCookie`.

Dowody: niezależny build root **0/0** PASS, wybrane testy HTTP/OpenAPI **11/11
PASS** (AdminOps oraz `ApiEndpointTests.ChatSearchRateLimit`) i
`git diff --check` PASS. Pełnej suite nie uruchamiano. Fixture jest wzorcem dla
kolejnych standalone HTTP/integration testów; nie wracać do legacy connection
stringów, Bearer/JWT ani schematu IdentityCookie.

### 4R-B — standalone runtime readiness

Audyt README, `.env.example`, launch settings, `Program.cs`, `start-local.sh` i
Compose potwierdził lokalny standalone runtime bez połączeń Ready/Core/DataBus.
Na świeżej lokalnej bazie wykryto, że ręczna migracja
`20260822160000_AddAutomationRuleArchive` nie była odkrywana przez EF z powodu
braku atrybutów `DbContext`/`Migration`; dodano
`20260917100000_EnsureAutomationRuleArchiveColumn.cs` z guarded SQL.

Dowody: `docker compose config --quiet` PASS, build **0/0** PASS, migracje obu
kontekstów PASS, bounded boot `/health/live` 200, `/health/ready` 200 i Swagger
200. Po poprawce brak błędu `ArchivedAtUtc` oraz nieobsłużonego wyjątku
startowego. Nie uruchamiano pełnej suite, nie commitowano ani nie pushowano.

Pełny `start-local.sh` wymaga Docker Compose oraz usług pomocniczych zależnie od
funkcji (MinIO, ClamAV, Redis, OnlyOffice, Mailpit). Bounded probe użył tylko
disposable lokalnego PostgreSQL; MinIO zgłosił kontrolowany warning, a aplikacja
kontynuowała działanie. Nie wykonano połączeń Ready/Core/DataBus.

### 4R Front i 4S — frontend runtime oraz corrective cleanup

`flutter analyze` po 4S: PASS. Usunięto cały `lib/core/auth`, `AuthApi`, porty
kompatybilności oraz legacy dormant widgets/routes; aktywny Chat otrzymuje
jawny `userId`. Niezależny post-4S Web build przeszedł PASS w **98.7 s**.

### 5A/5B, 5I/5K, 5L/5M, 5N/5O i 5P

Zaakceptowano dormant legacy auth/DataBus cleanup (root build **0/0**, suite
**74/74**), disposable PostgreSQL i hermetyczne Storage/AI (**17/17**), lokalny
test seam `X-Test-User-Id` → `sub` oraz `/me` direct `302` (**1/1**), HTTP/OpenAPI
fixture (**57/57**) i ACL/automatyzacja/realtime proof (**33/33**). Są to dowody
zakresowe, nie pełna macierz E2E/platform.

### 5R — odporność równoczesnej rotacji refresh tokena

Pakiet jest zaakceptowany dla równoczesnych żądań rotacji refresh tokena w
PostgreSQL. Retry wykonuje maksymalnie jedną próbę i tylko wtedy, gdy
`PostgresException.SqlState == "40001"`. Ponowienie obejmuje pełną transakcję
wraz z audytem; rollback nie duplikuje audytu. Drugi request jest fail-closed:
wykrywa reuse i unieważnia rodzinę tokenów.

Dowody:

- `RefreshTokenPostgresConcurrencyTests`: **1/1** PASS;
- `dotnet build veloryn-workspaces.csproj --no-restore`: **0/0** PASS;
- `git diff --check`: PASS.

### 5S — workspace lifecycle, membership, invitations i preferences

Zaakceptowano wyłącznie lifecycle workspace, członkostwa, zaproszenia i
preferencje zweryfikowane na disposable PostgreSQL.

Dowody:

- targeted disposable PostgreSQL gate: **7/7** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

### 5T — Wiki PostgreSQL/HTTP standalone

Zaakceptowano standalone Wiki PostgreSQL/HTTP z `WebApplicationFactory` w
zakresie wskazanego kontraktu HTTP i persistence.

Dowody:

- standalone Wiki PostgreSQL/HTTP gate: **4/4** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

### 5U — frontend bounded auth/session/shell/router

Zaakceptowano bounded frontendowy zakres auth, session, shella i routera.

Dowody:

- targeted frontend suite: **53/53** PASS;
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5V — frontend global Chat/Notifications/realtime contracts

Zaakceptowano frontendowe kontrakty globalnego Chat, Notifications i realtime
wraz z fake/test suite. Ten wynik nie dowodzi live backend SignalR E2E.

Dowody:

- targeted frontend contract/fake suite: **67/67** PASS;
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5W — standalone Task HTTP/OpenAPI matrix

Zaakceptowano standalone Task HTTP/OpenAPI matrix uruchomioną przez
`WebApplicationFactory` i disposable PostgreSQL. Zakres obejmuje smoke test 100
operacji Tasks, role/access, workflow oraz statusy `400/401/403/404/409`. Test
używa wyłącznie GUID `UserId` przez `X-Test-User-Id`; usunięto z niego
wskaźniki/nazwy Ready/Core i legacy environment.

Dowody:

- standalone Task HTTP/OpenAPI matrix: **6/6** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

Nie jest to dowód pełnego E2E produktu.

### 5X — standalone local login backend/BFF

Zaakceptowano lokalne logowanie backendowe `GET/POST /auth/login` z
antiforgery, limitem **10/5 min/IP**, local-only `returnUrl`, aktywnym i
potwierdzonym kontem lokalnym, neutralnymi błędami oraz przejściem Identity
cookie → authorization BFF. Niejednoznaczne dopasowanie loginu/e-maila jest
fail-closed. Public register nie istnieje; provisioning dotyczy tylko
skonfigurowanych klientów OIDC.

Dowody:

- `LocalLogin` + `BffSecurity` + `LocalOpenIddict` +
  `LocalIdentityFoundation`: **36/36** PASS;
- backend build: **0/0** PASS;
- `git diff --check`: PASS.

Desktop PKCE i real browser E2E pozostają otwarte.

### 5Y — frontend web BFF root

Zaakceptowano frontendowy web BFF root: browser launcher, web composition i
restore przed `runApp`, CTA bez credentials, neutralny redirect bez error flash
oraz brak bearer transportu.

Dowody:

- targeted gates po review: **39/39**, następnie korekta review **24/24** PASS;
- scoped `flutter analyze`: PASS;
- web debug build: PASS.

Desktop PKCE i real browser E2E pozostają otwarte; pakiet nie dowodzi pełnego
E2E.

### 5Z — backend Desktop Authorization Code + PKCE contract

Zaakceptowano backendowy kontrakt Desktop Authorization Code + PKCE. Klient
`devplanner-desktop` jest publiczny i nie używa sekretu; wymagany jest code flow
z PKCE `S256`. Callback ma loopback URI
`http://127.0.0.1:<49152..65535>/callback`. Kontrakt obejmuje rotację,
wykrywanie reuse i revoke refresh-tokenów.

Dowody:

- targeted `LocalOpenIddict`: **13/13** PASS;
- backend build: PASS, bez ostrzeżeń;
- manual visual rendering: PASS.

Transport platformowy Front pozostaje w toku. Browser Playwright E2E jest
celowo zdepriorytetyzowane, a real browser E2E pozostaje otwarte.

### 6E — Desktop PKCE typed transport implementation

Zaakceptowano typed transport Desktop PKCE: publiczny klient
`devplanner-desktop`, Authorization Code + PKCE `S256`, losowany loopback port
`49152..65535` i system browser. Typed transport posiada `state`, `nonce` oraz
`code_verifier`; access token jest tylko w pamięci, refresh token tylko w OS
vault, a rotacja zastępuje wpis w vault. Odczyt autorytatywny to
`GET /api/v1/me/`, revoke to `POST /connect/revocation`, a lokalny vault jest
czyszczony również po błędzie zdalnego revoke. Obsługiwane są ścieżki launcherów
Windows/macOS/Linux.

Dowody:

- backend `LocalOpenIddict` + revocation targeted gates: **17/17** PASS;
- backend build: PASS, bez ostrzeżeń;
- frontend targeted suite: **13/13** PASS;
- scoped `flutter analyze`: PASS.

Ręczna weryfikacja native login/callback/refresh/logout na Windows, macOS i
Linux pozostaje do wykonania; nie należy twierdzić, że zakończyła się sukcesem.
Real browser E2E pozostaje celowo odroczone.

### 6E — macOS manual smoke status

Najnowszy macOS smoke potwierdził zaufany development certificate, discovery
backendu, aktywny native CTA i działający loopback listener. Dostarczenie URL
`/connect/authorize` do przeglądarki nie działa jednak ani przez
`Process.open`, ani przez `url_launcher`, mimo raportowanego sukcesu launchera.
Nie zweryfikowano przez to auth callbacku, sesji, `me`, refresh ani revocation.

Disposable runtime i baza zostały po próbie wyczyszczone. Browser E2E pozostaje
odroczone zgodnie z decyzją użytkownika. Desktop end-to-end jest zablokowane
konkretną usterką launchera i nie może być oznaczone jako ukończone. Wcześniej
HTTP nadal był prawidłowo odrzucany przez OpenIddict `ID2083`; TLS nie wyłączano
i keychain nie zmieniano.

## Otwarte blokady i następne kroki

1. Szerokie bramki HTTP/integration poza zaakceptowanymi zakresami wymagają
   osobnych fixture’ów i dowodów.
2. Wykonać pełne E2E token/session/revoke/realtime oraz walidację platform
   Windows, macOS i Linux. Web debug build jest już PASS (**98.7 s**).

Projekt jako całość pozostaje nieukończony. Nie przywracać aliasów, fallbacków
ani połączeń Ready/Core/DataBus. Nie commitować ani nie pushować bez wyraźnej
dyspozycji użytkownika.

### 2026-09-17 — R1/B0: integracja odzyskanych portów kompozycji rootu Frontu

Włączono tylko dwa produkcyjne pliki wymagane przez aktualny root/router:

- `Front/lib/workspaces/presentation/chat/global_chat_composition.dart`;
- `Front/lib/workspaces/presentation/notifications/global_notifications_composition.dart`.

Nie włączono strony `devplanner_workspaces_page.dart`, ponieważ staging oznacza
ją jako placeholder, ani pliku runtime `partial`. Nie włączono też adapterów Web
SignalR: aktualny kontrakt BFF wymaga jeszcze kompletnego transportu cookie,
CSRF i origin; nie wolno deklarować pozornej obsługi realtime.

Dowody: hash źródeł stagingu i decyzje są w
`Front/docs/recovery/R1-B0-root-integration-report.md`; `dart format`, scoped
`flutter analyze` dla dwóch plików oraz `git diff --check` — PASS. Nadal otwarte:
cały graf zależności `workspaces`, który zawiera importy `package:ready_next`.
Następny krok: osobny pakiet migracji jednego pionu domenowego, zaczynając od
portów Chat/Notifications i ich modeli, bez masowego rename i bez generatora
równolegle z migracją źródeł.

### 2026-09-17 — R1/B1a: foundation error/l10n

Przeniesiono importy aktywnego standalone kodu na istniejące, typowane
powierzchnie foundation bez fizycznego przenoszenia plików:

- `package:devplanner/foundation/error/error.dart` — 7 deklaracji;
- `package:devplanner/foundation/l10n/l10n.dart` — 5 deklaracji.

Objęto admin, me i odpowiadające testy. `flutter analyze` dla 7 źródeł,
`flutter test test/core/error/api_error_test.dart test/admin/...` (15/15) oraz
formatowanie i `git diff --check` zakończyły się PASS. Auth, theme, transport,
root/router/runtime, Chat, Notifications i realtime pozostały nietknięte.

`core/data`, `features/settings` oraz reszta Workspaces zostały jawnie
odroczone: ich bezpośrednie zależności nadal zwracają typy z
`package:ready_next`, więc sama podmiana importu błędu łamie kontrakt
`Either`. Szczegółowy audyt znajduje się w
`Front/docs/recovery/R1-B1a-error-l10n-report.md`.

## Weryfikacja synchronizacji

Po skopiowaniu plików wykonaj oba porównania:

```bash
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-plan.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-plan.md
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-handoff.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-handoff.md
```

### 2026-09-18 — I4a: odporność startu desktopowej sesji PKCE

Ręczne uruchomienie macOS wykryło realną awarię: odrzucony wpis refresh tokenu
z macOS Keychain zwracał odpowiedź OIDC HTTP 400 przed `runApp`, przez co
natywne okno pozostawało czarne. Transport desktopowy rozpoznaje teraz 400/401
wyłącznie w żądaniu `grant_type=refresh_token` jako nieodtwarzalną lokalną
sesję, a adapter usuwa wtedy wpis Keychain. Błędy połączenia, TLS i 5xx nie są
kasowaniem sesji. Bootstrap fail-closed publikuje ekran logowania nawet przy
niespodziewanym błędzie odtwarzania, jednocześnie raportując go diagnostycznie.

Dowody: scoped `flutter analyze` czterech plików PASS, targeted auth suite
**8/8** PASS, `git diff --check` PASS oraz ręczny `flutter run -d macos`:
po restarcie wystąpił log odrzucenia starej sesji bez wyjątku, a interfejs
macOS udostępnił przycisk „Logowanie”. Szczegóły są w
`Front/docs/recovery/I4a-desktop-startup-session-recovery-report.md`.

Pakiet nie stanowi dowodu kompletnego desktop E2E login/callback/`/me`/logout
ani innych platform; te pozostają otwarte.

### 2026-09-18 — I5e/I5g: katalog Workspaces i standalone importy menu

Pakiety zostały niezależnie zaakceptowane dla
`lib/workspaces/presentation/workspaces_home/**`,
`workspaces/shared/helpers/workspace_icon_helper.dart` oraz niezbędnych
importerów dialogów zasobów projektu. Katalog, wyszukiwanie, drzewo,
hover i dialogi używają prywatnych `ValueNotifier`ów z jawnym `dispose`, bez
`setState`/`StatefulBuilder`/`setDialogState`; produkcyjne pliki Workspaces
Home nie przekraczają 366 linii. Dotychczasowe top-level entrypointy dialogów
zastąpiono statycznym API klas dialogów. Stare importy `ready_next` zastąpiono
istniejącymi kontraktami `devplanner`, a usunięty router zastąpiono
`DevPlannerNavigation`, bez aliasu kompatybilności.

Regresja wykryta w niezależnym review została naprawiona: menu projektów
pokazuje `backendCode`, a gdy go nie ma — `statusCode` HTTP, więc komunikat
z kodem `503` nie znika. Dowody odbioru root: scoped analyzer PASS, pełne
widget tests Workspaces Home PASS **4/4**, Cubit tests PASS **8/8**, brak
starego stanu/importów oraz plików >400 i `git diff --check` PASS. Raporty:
`Front/docs/recovery/I5e-workspaces-home-local-state-report.md` oraz
`I5g-workspaces-home-import-unblock-report.md`. Nie jest to desktopowe E2E.

### 2026-09-18 — I5a: Kanban bez `setState` i god Cubitu

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/tasks/board/**`. Lokalny stan interakcji korzysta
z prywatnych `ValueNotifier`ów i obserwatorów, bez `setState`. `TasksBoardCubit`
ma teraz 166 linii i jest cienką fasadą; odpowiedzialności realnie rozdzielono
na zwykłe, nazwane klasy: runtime/realtime, komendy kart, preferencje oraz
operacje bulk. Nie użyto `part` ani mixinów do ukrycia jednego god objectu.
Wszystkie pliki Kanbanu mieszczą się w limicie 400 linii.

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/tasks/board --reporter compact`
PASS **85/85**, `flutter test .../tasks_board_cubit_test.dart` PASS **24/24**,
brak `setState`/`StatefulBuilder`/`setDialogState`, brak plików >400 i
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5a-task-board-local-state-report.md`. Pakiet nie jest
desktopowym E2E z backendem ani nie zastępuje aktywnego routingu.

### 2026-09-18 — I5b: lista zadań bez `setState` i plików ponad 400 linii

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/tasks/list/**`. Lokalny stan edycji, hover,
pickerów i arkuszy korzysta z prywatnych `ValueNotifier`ów oraz
`ValueListenableBuilder`/`AnimatedBuilder`, z jawnym `dispose`. Rozdzielono
tytuł/akcje komórki, picker czasu, arkusz kolumn i odpowiedzialności
`TaskListPreferencesCubit` (ładowanie, polityka projektu, sort), bez zmian
kontraktów API czy routingu. Wszystkie pliki w katalogu mieszczą się w limicie
400 linii.

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/tasks/list --reporter compact`
PASS **120/120**, brak `setState`/`StatefulBuilder`/`setDialogState`, brak
plików >400 oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5b-task-list-local-state-report.md`. Zakres nie jest
zastępstwem desktopowego E2E z backendem.

### 2026-09-18 — I5d: pliki i dokumenty bez `setState`

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/storage/**`. Lokalny stan interakcji Storage
używa prywatnych `ValueNotifier`ów i obserwatorów, a operacje OnlyOffice
przeniesiono do `StorageOfficeEditorActionsCubit` z niemutowalnym stanem.
Podzielono dialog Office i shell przeglądarki; żaden plik Storage nie
przekracza 400 linii. Zakres nie odtwarza placeholderów i nie zmienia
kontraktów backendu.

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/storage --reporter compact` PASS
**96/96**, brak `setState`/`StatefulBuilder`/`setDialogState`, brak
`package:ready_next` w produkcyjnych i bezpośrednich testach Storage, brak
plików >400 oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5d-storage-local-state-report.md`. Pakiet nie jest
desktopowym E2E z działającym backendem i OnlyOffice.

### 2026-09-18 — I5c: szczegóły zadania bez `setState`

Pakiet został niezależnie zaakceptowany dla
`lib/workspaces/presentation/tasks/detail/**`. Wszystkie lokalne formularze,
hover i drag-and-drop używają prywatnych `ValueNotifier`ów oraz
`ValueListenableBuilder`/`AnimatedBuilder`, z jawnym `dispose`. Operacje
odczytu i zapisu pozostają w wyspecjalizowanych Cubitach/repozytoriach.
Wydzielono `task_details_dependency_fields.dart`, aby żaden plik tego pionu
nie przekraczał 400 linii (największy ma 394).

Dowody odbioru wykonane przez root: scoped `flutter analyze` PASS,
`flutter test test/workspaces/presentation/tasks/detail --reporter compact`
PASS **24/24**, brak `setState`, brak plików >400 i `git diff --check` PASS.
Raport kontynuacyjny:
`Front/docs/recovery/I5c-task-detail-local-state-report.md`. Pakiet nie
dowodzi desktopowego E2E z backendem.

### 2026-09-18 — I4b–I4f: porządkowanie pionu powiadomień i lokalnego stanu shellu

To jest pakiet **częściowo zaakceptowany**, a nie zakończenie Chat ani
powiadomień. Przywrócono spójne nazewnictwo standalone w aktywnych kontraktach
powiadomień (`userId`, `recipientUserId`), zregenerowano typowane artefakty
Freezed/JSON/Retrofit oraz usunięto importy `ready_next` z warstw data/domain/
presentation powiadomień, gdy istnieje bezpośredni odpowiednik `devplanner`.
Scoped analyzer tych trzech warstw jest PASS, a test repozytoriów ustawień
powiadomień jest PASS **7/7**. Pełne drzewo testów data/domain/presentation
powiadomień jest PASS **46/46**; nie jest to jeszcze desktopowe E2E z backendem.

W prezentacji powiadomień użyto istniejącego
`DevPlannerModalHost` oraz standalone `DevPlannerNavigation`; nie odtworzono
starego `AppModalHost`, `AppRouter` ani Core deeplinków. Lokalny wybór trybu
odpowiedzi oraz zwijanie sidebara shellu używają prywatnych `ValueNotifier`
i `ValueListenableBuilder`, z jawnym `dispose`; w tym zakresie nie ma
`setState`. Żaden widget objęty pakietem nie przekracza 400 linii.

Chat pozostaje świadomie poza aktywnym routingiem: ma być później globalnym
overlayem po prawej stronie, a nie ekranem. W jego legacy UI nadal występują
trzy wcześniejsze użycia `setState`, których nie wolno kopiować do nowej
kompozycji. Pełny test pionu powiadomień i integracja globalnego overlayu są
otwarte do czasu domknięcia realtime oraz kompozycji shellu. Raporty zakresowe:
`I4b-chat-import-migration-report.md`,
`I4c-notifications-import-migration-report.md`,
`I4c-identity-terminology-repair-report.md`,
`I4d-shell-local-state-report.md` oraz
`I4e-notifications-test-imports-report.md`; realtime ma osobny raport
`I4f-notifications-realtime-import-migration-report.md` w
`Front/docs/recovery/`.

### 2026-09-18 — I4h: build i smoke test macOS

`flutter build macos --debug` jest PASS, a świeże `DevPlanner.app` renderuje
natywny ekran logowania zamiast wcześniejszego czarnego/pustego okna. Widoczny
w trakcie smoke testu komunikat nieudanego logowania nie jest maskowany ani
uznawany za E2E; wymaga osobnej weryfikacji z działającym backendem i ręcznie
wprowadzonymi przez użytkownika danymi. Szczegóły:
`Front/docs/recovery/I4h-macos-build-smoke-report.md`.

Pełne `flutter analyze --machine` po tym pakiecie zwróciło
`ERROR=0 WARNING=0 INFO=0`. Jest to bramka kompilacyjna, nie zwalnia jednak
z migracji **322 odziedziczonych** użyć `setState`; pierwsze trzy izolowane
pakiety obejmują kolejno Kanban, listę i szczegóły zadań.

### 2026-09-18 — I5h: dialogi tworzenia zasobów projektu

Pakiet `lib/workspaces/presentation/projects/dialogs/**` został niezależnie
zaakceptowany. Monolit dialogów tworzenia projektu, Whiteboardu, zadania,
strony Wiki, karty Corkboard i folderu zastąpiono klasową fasadą
`ProjectResourceCreationDialogs`, sześcioma niezależnymi formularzami oraz
małymi, nazwanymi Cubitami komend o niemutowalnym stanie. Wywołania repozytoriów
nie pozostają w UI; lokalne kontrolki używają prywatnych `ValueNotifier`ów i
mają `dispose`. Jedyny konieczny caller — menu projektów — korzysta z sześciu
metod statycznych fasady; nie zmieniono jego pozostałego UI ani routingu.

Odbiór rootu: scoped `flutter analyze` PASS; testy Cubitów komend **7/7** i
test menu **3/3** PASS; brak `setState`/`StatefulBuilder`/`setDialogState`,
brak importów `ready_next`, `core` i `http`, brak plików >400 linii (maks. 358)
oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5h-project-dialogs-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5f: ustawienia projektu bez lokalnego `setState`

Pakiet `lib/workspaces/presentation/projects/settings/**` został niezależnie
zaakceptowany. Modal ustawień podzielono na ramę, katalog zakładek, renderer
aktywnej zakładki oraz jawny registry composition/lifecycle dla lazy Cubitów.
Formularze pól własnych, szablony, członkowie, workflow, kamienie milowe,
etykiety, automatyzacje i centrum użytkownika zachowują funkcje, a operacje
asynchroniczne zostają w wyspecjalizowanych Cubitach. Globalne entrypointy
modalów zastąpiły klasowe fasady `ProjectSettingsDialogs` i
`ProjectUserHubDialogs`.

Odbiór rootu: scoped `flutter analyze` PASS; test modalów **4/4** PASS; brak
`setState`/`StatefulBuilder`/`setDialogState`, brak globalnych entrypointów
modalów, brak importów `ready_next` i zewnętrznego `http`, brak plików >400 linii
(maks. 388) oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5f-project-settings-local-state-report.md`. Pakiet nie
jest desktopowym E2E z działającym backendem.

### 2026-09-18 — I5j: ustawienia przestrzeni standalone

Pakiet `lib/workspaces/presentation/workspaces_settings/**` został niezależnie
zaakceptowany. Wszystkie importy `ready_next` zastąpiono bezpośrednimi
odpowiednikami `devplanner`; wyszukiwanie i zaproszenia używają lokalnego
katalogu użytkowników (`LocalUserDirectoryResponse`, `userId`), a nie Ready.
Zachowano ustawienia ogólne, członków, zaproszenia i preferencje powiadomień.
Lokalny stan formularzy ma lifecycle `ValueNotifier`, a spóźnione odpowiedzi
wyszukiwania zaproszeń są odrzucane.

Odbiór rootu: scoped `flutter analyze` PASS; test lokalnego katalogu
zaproszeń **1/1** PASS; brak `setState`/`StatefulBuilder`/`setDialogState`,
brak importów `ready_next` i zewnętrznego `http`, brak plików >400 linii
(maks. 389) oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5j-workspace-settings-local-state-report.md`. Brakuje
desktopowego E2E z działającym backendem.

### 2026-09-18 — I5i: recurrence z neutralnym stanem Cubita

Pakiet `lib/workspaces/presentation/tasks/recurrence/**` został niezależnie
zaakceptowany. Edytor, arkusz, historia i karty reguł zachowują tworzenie,
edycję, zapis, pauzę/wznowienie, usuwanie, natychmiastowe wykonanie i refresh.
UI-local state używa `ValueNotifier`ów, a pliki `part` zastąpiono zwykłymi
małymi widgetami. Launcher, formatter oraz mapper odpowiedzi są API klasowymi.
`TaskRecurrenceEditorCubit` i jego stan nie zależą od Flutter Material:
neutralny `TaskRecurrenceScheduledTime` chroni logikę UTC, a konwersja do
pickera pozostaje wyłącznie w UI.

Odbiór rootu: scoped `flutter analyze` PASS, testy recurrence **11/11** PASS
(w tym regresja czasu UTC), brak `setState`/`StatefulBuilder`/`setDialogState`,
`part`, globalnych helperów i Material UI w Cubicie/stanie, brak plików >400
linii (maks. 364) oraz `git diff --check` PASS. Raport:
`Front/docs/recovery/I5i-task-recurrence-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5k: zapisane widoki zadań bez `setState`

Pakiet `lib/workspaces/presentation/tasks/views/**` został niezależnie
zaakceptowany. Zachowano tworzenie, konfigurację, wybór, zmianę nazwy,
nadpisanie i usuwanie zapisanych widoków oraz obsługę konfliktu wersji 409.
Dialogi lokalnego stanu używają prywatnych `ValueNotifier`ów z `dispose`, a
menu rozbito o mały listener informacji zwrotnej; nie dodano globalnych helperów
ani legacy transportu.

Odbiór rootu: scoped `flutter analyze` PASS, testy **12/12** PASS, brak
`setState`/`StatefulBuilder`/`setDialogState`, importów `ready_next` i
zewnętrznego `http`/`dio`, brak plików >400 linii (maks. 383) oraz
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5k-task-saved-views-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5l: prywatne zadania bez logiki repozytorium w UI

Pakiet `lib/workspaces/presentation/private/**` został niezależnie
zaakceptowany. Odczyt, mapowanie i stronicowanie prywatnych zadań należą do
`PersonalSectionCubit`, a filtry są niemutowalne. Dialog i strona używają
lokalnego `ValueNotifier`a z lifecycle, istniejącego hosta pickerów oraz portu
nawigacji; UI nie wykonuje już odczytu repozytorium.

Odbiór rootu: scoped `flutter analyze` PASS, testy **5/5** PASS (brak
kontraktu, sukces, błąd, cursor i filtry), brak
`setState`/`StatefulBuilder`/`setDialogState`, importów `ready_next` i
zewnętrznego `http`/`dio`, brak plików >400 linii (maks. 346) oraz
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5l-private-tasks-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — I5m: profil i bezpieczeństwo sesji bez `setState`

Pakiet `lib/me/presentation/**` został niezależnie zaakceptowany. Rozbito
profil na komponenty danych osobowych, hasła, sesji i uprawnień; zachowano
edycję nazwy, awatar, zmianę hasła, unieważnienie sesji i kontrolę uprawnień.
Operacje pozostają w Cubitach oraz `MeGateway`, a lokalny stan formularzy ma
prywatny lifecycle `ValueNotifier`; nie ma plików `part` ani globalnych helperów.

Odbiór rootu: scoped `flutter analyze` PASS i testy `test/me` **34/34** PASS,
w tym zmiana hasła, sesje oraz błędy adaptera API. Brak
`setState`/`StatefulBuilder`/`setDialogState`, importów `ready_next` i
zewnętrznego `http`/`dio`, brak plików >400 linii (maks. 397) oraz
`git diff --check` PASS. Raport:
`Front/docs/recovery/I5m-profile-local-state-report.md`. Nie jest to
desktopowe E2E z backendem.

### 2026-09-18 — R2a/R2b: importy realtime czatu i shellu Workspaces

Niezależnie odebrano dwa pakiety migracji standalone. R2a usuwa `ready_next`
z realtime czatu i zachowuje SignalR, replay, deduplikację oraz typowane błędy;
kontrakt autora używa `authorUserId`. R2b usuwa legacy importy z shellu,
routingu i menu Workspaces, korzystając z `DevPlannerNavigation`,
`DevPlannerPanelsScope` i `AuthSessionPort`; zachowane są ścieżki zasobów,
Resource Chat oraz dostępność menu po zwinięciu.

Odbiór rootu: R2a scoped analyzer PASS i realtime **11/11** PASS; R2b scoped
analyzer PASS i testy menu **3/3** PASS. W obu zakresach brak `ready_next`,
zewnętrznego `http`/`dio` i plików >400 oraz `git diff --check` PASS. Raporty:
`R2a-chat-realtime-import-repair-report.md` i
`R2b-workspaces-shell-routing-import-repair-report.md` w `Front/docs/recovery/`.
Nie jest to zamknięcie globalnego Chat/Notifications ani desktopowe E2E.

### 2026-09-18 — T1/T2: odtworzenie kontraktów testowych standalone

Testy pozostałe po usunięciu `ready_next` zostały dopasowane do aktualnego
kontraktu DevPlanner, bez cofania produkcyjnej kompozycji. Obejmuje to bootstrap
i root aplikacji, router (powiadomienia nie są osobną trasą), User Hub projektu
oraz adapter uploadu załączników Chat. Zachowane są scenariusze sesji,
przekierowania fail-closed, preferencji projektu, opuszczenia projektu, ticketu,
uploadu, finalizacji i statusów skanowania pliku.

Odbiór rootu: `flutter analyze lib` PASS; shell **4/4**, User Hub **6/6**,
upload Chat **9/9**, router **3/3**, bootstrap/root **5/5** PASS oraz
`git diff --check` PASS. Raporty: `T1-bootstrap-app-tests-repair-report.md`,
`T2a-notifications-router-test-repair-report.md`,
`T2b-chat-attachment-upload-port-adapter-test-repair-report.md` i
`T2c-project-user-hub-test-import-repair-report.md` w `Front/docs/recovery/`.
Nie jest to pełne uruchomienie całej suite ani desktopowe E2E z backendem.

### 2026-09-18 — T3: kontrakty Chat i realtime po usunięciu legacy

Zaktualizowano pozostałe testy Chat/realtime po migracji namespace do
`devplanner`. Nie przywrócono modeli `ready_next`: kontrakty korzystają z
`authorUserId` i aktualnych adapterów. Zachowano serializację załączników,
repozytorium rozmów, reducer z deduplikacją/replayem, SignalR workspace oraz
Resource Chat pliku przez `DevPlannerPanelsScope`, bez osobnej trasy Chat.

Odbiór rootu: analyzer wszystkich zmienionych testów PASS; Chat/realtime data
**42/42** PASS, reducer **6/6** PASS, Resource Chat pliku **6/6** PASS,
`rg "package:ready_next/" test` nie zwraca wyników i `git diff --check` PASS.
Raporty: `T3a-chat-attachment-transport-contract-test-repair-report.md`,
`T3b-chat-repository-impl-test-repair-report.md` i
`T3c-workspace-realtime-tests-repair-report.md` w `Front/docs/recovery/`.
Nie jest to pełna suite, globalny panel Chat/Powiadomienia ani desktopowe E2E.

### 2026-09-18 — I6: Chat presentation bez `setState` i plików >400 linii

Rozbito ekran rozmowy, composer i panel rozmowy na małe komponenty o jasnej
odpowiedzialności: historię wiadomości, pola composera, elementy panelu oraz
lokalny wybór paneli. Stan odpowiedzi, wątku, dyskusji i drag-and-drop używa
prywatnych `ValueNotifier`ów z `dispose`; Cubity nadal wykonują wyłącznie
logikę rozmowy i załączników. Zachowano Resource Chat przez
`DevPlannerPanelsScope`, SignalR, deep link do wiadomości, Quill oraz blokadę
wysyłki podczas skanowania załączników.

Odbiór rootu: `flutter analyze lib/workspaces/presentation/chat` PASS, brak
`setState`/`StatefulBuilder`/`setDialogState`, brak plików >400 linii oraz
`git diff --check` PASS. Suite Chat **80/80** PASS; po ostatniej zmianie
kontrolek załączników testy wpływu **14/14** PASS. Nie jest to jeszcze
zamknięty globalny overlay Chat/Powiadomienia ani desktopowe E2E. `flutter
build macos --debug` PASS; pozostaje nieblokujące ostrzeżenie o przyszłym SPM
dla `media_kit_libs_macos_video` i `media_kit_video`.

### 2026-09-18 — I7: session-scoped globalny overlay Chat i Powiadomienia

Dodano jeden host `app/shell/overlays/devplanner_global_panels_host.dart`,
który renderuje panele po prawej stronie pod belką 64 px, nad aktywną trasą.
Nie powstaje osobna trasa Chat ani Notifications. Host zachowuje ekran,
scroll i formularze pod overlayem, obsługuje barrier, klawisz Escape oraz
przywrócenie poprzedniego focusu. Belka shellu wywołuje wyłącznie
`DevPlannerPanelsController` przez scope — nie zna HTTP, sesji ani Cubitów.

`DevPlannerApp` składa sesyjny `DevPlannerStandaloneRuntime` i przekazuje do
hosta jawne porty REST/realtime. `ChatRepositoryImpl` implementuje teraz
również kontrakt szczegółu rozmowy i Resource Chat pliku: zachowuje cursor,
Delta Quill, reply, załączniki oraz autoryzowany scope pliku. Brak kompozycji
sesji pokazuje jawny stan niedostępności, nigdy pusty panel. Wszystkie zależności
composera i SignalR są providerami composition rootu; UI nie tworzy klienta API.
Klucz prywatnych draftów został również przemianowany z historycznego prefiksu
`ready_next` na `devplanner`; zgodnie z decyzją projektu nie migrujemy lokalnych
danych po usuniętym produkcie.

Odbiór pakietu: analyzer zakresu PASS; adapter Chat **8/8**, host overlay
**2/2** (w tym provider Resource Chat dla aktywnej trasy), shell **4/4**, root
**3/3**, powiadomienia **1/1** — razem **18/18**
PASS. `git diff --check` PASS, `flutter build macos --debug` PASS. Pozostaje
nieblokujące ostrzeżenie Fluttera o przyszłym SPM dla `media_kit_libs_macos_video`
i `media_kit_video`. Nadal nie jest to manualne desktopowe E2E z lokalnym backendem.
Po końcowej korekcie scope Resource Chat pełny zakres presentation Chat przeszedł
**80/80**, a osobny zakres data Chat/realtime, reducer, Notifications i app/router
**117/117**. `flutter analyze lib`, synchronizacja obu dokumentów oraz skan braku
runtime `ready_next`/Ready/Core/DataBus w `lib` i `test` są PASS.
Kontrola uruchomienia ręcznego potwierdziła render ekranu logowania. README
opisuje kanoniczne uruchomienie desktopu z `https://localhost:5173`; test
logowania, `/me`, Chat/SignalR i logout nadal wymaga przejścia przez realną
sesję lokalnego użytkownika.

Podczas rzeczywistego kliknięcia panelu Chat wykryto i naprawiono błąd composera
DI: `AuthSessionPort` rozszerza `Listenable`, dlatego host używa
`ListenableProvider<AuthSessionPort>`, a nie `RepositoryProvider`. Zmiana
eliminuje czerwony ekran Provider przy otwieraniu globalnego Chatu.

Kolejna kontrola desktopowa ujawniła brak `Overlay` nad panelem zbudowanym w
`MaterialApp.router.builder`: tooltipy wewnątrz Chatu nie miały swojego
przodka `Overlay`. Host utrzymuje teraz jeden trwały `OverlayEntry` i w nim
renderuje zarówno trasę, jak i panele. Rzeczywisty klik Chat po tej korekcie
pokazał prawy panel „Brak rozmów” i jego zamknięcie bez czerwonego ekranu.
Test hosta i root aplikacji są PASS po korekcie.

Kontrola Powiadomień otwiera prawidłowy prawy panel, ale lokalny backend
zwraca błąd 500 podczas pobrania inboxa. Lokalna baza na porcie 5440 ma
zastosowaną ostatnią migrację `20260917100000_EnsureAutomationRuleArchiveColumn`,
a izolowane testy `NotificationServiceTests` są **41/41 PASS**. Nie wolno
maskować tego stanu w UI ani uznać E2E powiadomień za zakończone: pozostaje
odtworzenie autoryzowanego żądania do działającego procesu backendu i usunięcie
przyczyny 500.

### 2026-09-18 — I8: naprawa PostgreSQL inboxa powiadomień

Usunięto rzeczywistą przyczynę 500 w `GET /api/v1/notifications/groups`.
`NotificationService.ListGroupsAsync` budował prywatny rekord `GroupSummary`
przed sortowaniem; provider Npgsql nie tłumaczy `OrderBy` po takim
konstruktorze. Filtry i sortowanie odbywają się teraz na encji
`WorkspaceNotificationGroup`, a `GroupSummary` powstaje dopiero po
materializacji strony. Nie ma eval po stronie klienta przed `Take`, nie zmienia
to uprawnień Chat ani cursorowego kontraktu API.

Dodano test PostgreSQL `PostgresGroupListReturnsEmptyInboxWithoutServerError`.
Test razem z filtrowaniem kategorii jest **2/2 PASS**. Rzeczywiste,
autoryzowane żądanie desktopowego tokenu po restarcie lokalnego backendu
zwraca: `/notifications/unread-count`, `/notifications/` i
`/notifications/groups` — wszystkie **200**, a oba listujące endpointy mają
`items: []`. Backend uruchomiono ponownie przez
`start-desktop-auth-local.sh`; nie wykonano migracji ani nie zmieniono danych.
Końcowa kontrola po naprawie: backendowy zakres Notifications **44/44 PASS**;
frontend `flutter analyze lib` PASS, a testy root/overlay **5/5 PASS**.

### 2026-09-18 — L1: lokalny fixture do odbioru pionu Workspace/Tasks

Lokalna baza, wcześniej pusta z założenia projektu, otrzymała jawny fixture
odbiorowy: workspace `DevPlanner`, projekt `Planer` oraz zadanie `Pierwsze
zadanie` z jedną checklistą. Dane są własnością lokalnego konta administratora
i służą do wejścia w rzeczywiste drzewo menu, Tasks i Kanban; nie są atrapą
frontendową ani migracją starych danych. Rzeczywiste żądania lokalnym tokenem
potwierdziły: create workspace **201**, create project **201**, create task
**201**, lista zadań **200** z jedną pozycją oraz grupy Kanban **200** z
sześcioma workflow groups. Fixture zachować do desktopowego smoke testu, chyba
że użytkownik świadomie zdecyduje o jego usunięciu.

### 2026-09-18 — L2: trwałe klucze lokalnej sesji desktopowej

W `.env.local` ustawiono `DEVPLANNER_DATA_PROTECTION_KEYS_PATH` na lokalny
katalog poza repozytorium. Katalog ma uprawnienia właściciela `0700`; backend
po restarcie zapisał w nim pierwszy klucz. Eliminuje to efemeryczny key ring,
który po restarcie unieważniał możliwość odczytu refresh tokenów desktopowego
PKCE. Zmiana istniejącego key ringu wymusza jednorazowe ponowne logowanie i
odrzuca stare cookie formularza/CSRF — jest to oczekiwane i nie jest błędem
aplikacji. W środowisku wdrożeniowym klucze muszą nadal być szyfrowane przez
mechanizm hosta; lokalny katalog nie może być kopiowany do repozytorium.

### 2026-09-18 — R2a: kanoniczny deep link Tasks/Kanban

Aktywny router zachowuje teraz query w bezpiecznej lokalizacji startowej;
`?view=kanban` nie znika już przy restarcie desktopowej aplikacji. Dodano też
jawne przekierowanie historycznego adresu
`/workspaces/{workspaceId}/projects/{projectId}/kanban` do jedynej kanonicznej
trasy `.../tasks?view=kanban`, a historyczny adres samego projektu do jego
rzeczywistej listy `.../tasks`. Nie tworzono drugiego widoku Kanbanu ani
pustego dashboardu projektu; nie zmieniano kontraktów HTTP, Cubitów i
providerów — oba widoki nadal korzystają z jednego rzeczywistego composition
rootu Tasks.

Dodano także rzeczywistą trasę `/workspaces/{workspaceId}`. Karta workspace
prowadzi do istniejącego katalogu projektów zasilanego przez `ProjectsGateway`,
a kliknięcie projektu prowadzi do kanonicznej listy Tasks. UI przekazuje tylko
intencję nawigacji; pobranie projektów pozostaje w małym `WorkspaceProjectsCubit`.
Błędny UUID lub brak bramy pokazuje jawny komunikat i nie wykonuje żądania.

Dowód: `flutter test test/app/router/devplanner_root_router_compile_test.dart`
**13/13 PASS**, w tym test query po restarcie, przekierowania legacy oraz
przejście karta workspace → katalog projektów → Tasks;
`flutter analyze lib/app/router/devplanner_router.dart
test/app/router/devplanner_root_router_compile_test.dart` PASS oraz
`git diff --check` PASS. Jest to wyłącznie naprawa routingu R2, nie dowód
pełnego ręcznego desktopowego scenariusza Tasks/Kanban.

### 2026-09-18 — R2b: przywrócenie Plików projektu

`StorageScope.project` i jego URL istniały w domenie, lecz aktywne drzewo
projektu nie wystawiało pozycji Pliki, a router nie składał jej rzeczywistego
widoku. Przywrócono węzeł `Pliki` pod każdym projektem oraz trasę
`/workspaces/{workspaceId}/projects/{projectId}/files`. Trasa waliduje oba
UUID i przekazuje do istniejącego `StorageReadOnlyBrowserPage` dokładnie
`StorageScope.project(workspaceId, projectId)`. Współdzieli repository,
upload/download i egzekwowanie ACL z plikami workspace'u; nie zawiera mocka,
nowego klienta HTTP ani placeholdera. Błędny identyfikator pozostaje jawnym
stanem niedostępności.

Dowód: routerowy test Storage potwierdza odczyt z zakresem projektu, test
menu klika nowy węzeł i sprawdza jego kanoniczny URL; po zmianie zestaw
`router + navigation tree + scope codec` ma **22/22 PASS**. `flutter analyze
lib` oraz `git diff --check` są PASS. Nadal brakuje ręcznego desktopowego
scenariusza upload/download z MinIO; nie oznaczono go jako zakończonego.

### 2026-09-18 — R2c: przywrócenie „Moich plików”

Katalog tras zawierał `DevPlannerRouteCatalog.myFiles`, ale router i pozycja
`personalFiles` w sidebarze nie prowadziły do żadnego aktywnego widoku.
Dodano trasę `/me/files` z istniejącym `StorageReadOnlyBrowserPage` i
`StorageScope.personal`, a pozycja „Moje pliki” w drzewie nawigacji prowadzi
do tego URL. Nie ma dostępu HTTP w menu: menu przekazuje wyłącznie lokalizację,
a Storage zachowuje pojedynczą kompozycję repository oraz swoje stany błędów.

Dowód: test bezpośredniej trasy sprawdza `StorageScope.personal`, a test
sidebaru klika „Moje pliki” i sprawdza `/me/files`. Po zmianie zestaw
`router + navigation tree + scope codec` ma **23/23 PASS**; `flutter analyze
lib`, `git diff --check` i synchronizacja czterech dzienników są PASS.
Ręczny test desktopowy prywatnych uploadów nadal pozostaje do wykonania.

### 2026-09-18 — R2d: uczciwy dowód Storage i gotowość usług

Zweryfikowano lokalne usługi bez sesji użytkownika: MinIO
`/minio/health/live`, Backend `/health/live` i `/health/ready` zwracają
**200**, a Swagger lokalnego Backend jest dostępny. To jest dowód gotowości
infrastruktury, nie dowód uploadu wykonanego przez Flutter.

Skorygowano mylącą nazwę testu `StorageHttpTests`: wykorzystywał on
`IStorageService` w pamięci, a nie MinIO, choć nazywał się „RealMinIo”. Jest
teraz `StorageLifecycleFullPipelineWithHermeticStorageAndVerificationWorksCorrectly`,
a adapter testowy nosi nazwę `InMemoryStorageService` i ma polski komentarz
zakazujący traktowania go jako dowodu S3. Test po przebudowie **1/1 PASS**.
Prawdziwy upload/pobranie w UI nadal wymaga osobnego desktopowego smoke testu
z zalogowaną sesją — nie został ukryty przez test hermetyczny.

### 2026-09-18 — R2e: odzyskanie pełnego drzewa dawnego Workspace w nowym shellu

Po potwierdzeniu, że uproszczony shell nie spełniał wymogu zachowania menu
Workspace, `WorkspaceNavigationTree` otrzymało pełne poddrzewo projektu:
`Zadania → Lista/Kanban/Automatyzacje`, `Whiteboardy`, `Tablica korkowa`,
`Wiki` i `Pliki projektu`. Workspace zachowuje `Pliki workspace'u` i gałąź
`Projekty`, a katalog zachowuje Przegląd, zadania/pliki osobiste oraz realne
workspace'y. Chat i Powiadomienia pozostają globalnymi overlayami, bez trasy.

Shell nie renderuje już wszystkich dzieci stale. Właściciel shella trzyma
lokalny, niemutowalny `ValueNotifier<Set<String>>` tylko dla rozwiniętych
gałęzi; nie ma `setState`, globalnego Cubita ani logiki danych w UI. Węzły
rozwijają się chevronem, a przodkowie bieżącej trasy rozwijają się automatycznie.
Shell zachowuje pełny URI razem z query, więc `?view=kanban` zaznacza Kanban,
a nie ogólną Listę.
Rozbito wiersz drzewa do osobnego małego pliku; żaden widget nie przekracza
400 linii. Wszystkie widoczne tooltipy są w ARB.

Aktywne są wyłącznie realne piony i URL-e: Workspace/Projects, Lista Tasks,
Kanban jako `?view=kanban` oraz osobiste/workspace/project Files. Whiteboardy,
Wiki, Corkboard i Automatyzacje są widoczne jako odzyskana hierarchia, lecz
celowo nie mają fałszywej trasy ani placeholdera — ich pełny pion wymaga
oddzielnego typed gateway, Cubita, page, ACL i testów. Pełna mapa źródeł,
statusów i kolejności prac jest w repozytorium `Front`:
`docs/recovery/legacy-workspace-menu-map.md`.

Odbiór: `flutter test` dla routera, shella, drzewa i tokenów theme **29/29
PASS**; `flutter analyze lib` PASS; `git diff --check` PASS. Jest to odbiór
struktury i routingu, nie deklaracja ukończenia Whiteboard/Wiki/Corkboard/
Automatyzacji ani ręcznego desktopowego smoke testu Storage.

### 2026-09-18 — R2f: przywrócenie osobistych zadań

Dodano rzeczywistą trasę `/me/tasks` i pozycja „Zadania” w globalnym drzewie
prowadzi teraz do niej, a nie jest martwym wpisem. Router przyjmuje osobny,
typowany `TaskViewRepository`; produkcyjnie składa go z lokalnego transportu
do potwierdzonego endpointu `/api/v1/me/tasks`. Nie zależy od Kanbanu ani
SignalR. Wstrzyknięcie jawnego repozytorium pozwala testować router bez sieci.

Trasa wykorzystuje odzyskany `PersonalSectionCubit`: cursor, filtry,
stronicowanie, retry i link do szczegółu zadania pozostają w istniejących,
małych klasach. UI wykonuje tylko rendering i intencje, a jego bezpośrednie
importy `core` zostały zastąpione `foundation`. Adapter `TaskViewRepository`
nadal korzysta z historycznej osłony błędów `core`; jest to jawny dług migracji
warstwy data, nie zgoda na przywrócenie Core do routera/UI.

Odbiór: targeted analyzer PASS; test routera razem z trasami Workspace,
Tasks/Kanban i Files **21/21 PASS**. Nie uruchamiano aplikacji ani podglądu
GUI. Ręczny odbiór lokalnego desktopu pozostaje etapem stagingu.

### 2026-09-18 — R2g: zamknięcie zakresu odzyskania Workspace

Po doprecyzowaniu zakresu nie wolno budować nowych pionów, których dawny
Workspace nie dostarczał w gotowej postaci. Usunięto pięć niepodpiętych plików
rozpoczynających nowy pion Whiteboards (model domenowy, port, adapter i Cubit).
Nie zmieniły routingu, drzewa ani istniejącej funkcjonalności.

Do odbioru przywrócenia pozostają wyłącznie: rozwijane menu Workspace, pliki
(osobiste, workspace i projektowe), Tasks z listą i Kanbanem oraz istniejące
globalne panele Chat i Powiadomień. Whiteboardy, Wiki, Tablica korkowa i
Automatyzacje pozostają widocznymi, nieaktywnymi pozycjami odzyskanego menu;
nie wolno dla nich tworzyć ekranów, placeholderów ani klientów API bez nowej,
wyraźnej decyzji produktowej.

Odbiór po korekcie: **35/35 PASS** dla routera, shella, menu, zadań osobistych
i tokenów theme; `flutter analyze lib` PASS. Dodatkowy odbiór istniejących
pionów: **39/39 PASS** dla globalnych paneli, Powiadomień, listy/Kanbanu,
odczytu, uploadu i tworzenia folderu w Files. Nie uruchamiano aplikacji ani GUI.

### 2026-09-18 — R2h: aktualizacja macierzy parity do rzeczywistego grafu

`docs/recovery/feature-parity.md` otrzymał nadrzędny snapshot R2g. Historyczne
wpisy R0/R1 pozostają materiałem do odzyskania źródeł, ale nie mogą już
fałszywie opisywać aktywnego routera jako zbioru placeholderów. Snapshot
potwierdza aktualne trasy katalogu, projektów, listy/Kanbanu, szczegółu taska
oraz plików; potwierdza też Chat i Powiadomienia jako globalne overlaye bez
tras. Whiteboards, Wiki, Corkboard i OKR są jasno oznaczone jako nieaktywne
pozycje menu, bez dopisywania nowych pionów.

Do macierzy wpisano wyłącznie aktualne, automatyczne dowody: testy szczegółu
Taska, Chat i Powiadomień **27/27 PASS**, obok wcześniejszych pakietów 35/35
i 39/39 oraz `flutter analyze lib` PASS. Status `live` pozostaje `NIE` dla
każdego pionu — nie uruchomiono GUI ani desktopowego API, bo odbiór odbywa się
na stagingu. Pełny `flutter test` został przerwany po przekroczeniu limitu
obserwowanego procesu i nie jest raportowany jako wynik.

### 2026-09-18 — R2i: rozdzielenie logiki mutacji Powiadomień

`NotificationsCubit` został rozdzielony bez zmiany kontraktu UI lub API.
Nowa klasa `presentation/notifications/cubit/notifications_inbox_mutation_reducer.dart`
zawiera wyłącznie czyste, optymistyczne transformacje inboxa: odczyt,
archiwizację, pin oraz scalanie stron listy. Cubit pozostaje właścicielem I/O,
kolejki mutacji, rollbacku, błędów, cursorów i lifecycle realtime. Nie ma
`BuildContext`, routera ani I/O w reduktorze.

Po formacie Cubit ma 398 linii, reduktor 186 linii; oba mieszczą się w limicie
400. Odbiór: `notifications_cubit_test.dart`, `global_notifications_page_test.dart`
i `notification_reply_cubit_test.dart` **20/20 PASS**; analyzer katalogu
Powiadomień PASS. Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2j: podział modalu preferencji Powiadomień

`notification_preferences_modal.dart` nie jest już dużym widgetem mieszającym
composition i renderowanie trzech niezależnych stanów. Został hostem modalu
(119 linii): odczytuje porty, tworzy cztery istniejące Cubity i zachowuje ich
ten sam scope. Nowy `notification_preferences_sections.dart` (356 linii)
renderuje oddzielnie delivery, Storage i read-only digest; nie wykonuje HTTP
i komunikuje wyłącznie intencje do Cubitów. Nie zmieniono tras, API,
zachowania rollbacku ani zasięgu `DevPlannerModalHost`.

Odbiór: `notification_preferences_cubits_test.dart` **5/5 PASS** oraz
analyzer katalogu preferencji PASS. Oba widgety są poniżej 400 linii.
Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2k: weryfikacja kompilacji Backend przed stagingiem

W katalogu Backend są trzy projekty (`veloryn-workspaces.csproj` oraz dwa
projekty testowe), dlatego ogólne `dotnet build` wymaga jawnego wskazania
projektu i nie jest właściwą komendą odbioru. Zweryfikowano główny backend:
`dotnet build veloryn-workspaces.csproj --no-restore`.

Wynik: PASS, 0 ostrzeżeń, 0 błędów. Nie uruchamiano API, bazy, MinIO ani GUI;
wynik potwierdza wyłącznie aktualną kompilację przed wdrożeniem stagingowym.

### 2026-09-18 — R2l: foundation dla aktywnego panelu Powiadomień

Aktywne pliki globalnego panelu Powiadomień, jego widgetów, modalu preferencji,
sekcji preferencji i modalu odpowiedzi importują teraz lokalizację oraz theme
wyłącznie przez publiczne fasady `foundation/l10n` i `foundation/theme`.
Nie zmieniono danych, route, modal hosta ani API; jest to usunięcie sprzężenia
presentation z historyczną ścieżką `core`, nie mechaniczne kasowanie katalogu.

Odbiór po migracji: panel, inbox, preferencje i reply **28/28 PASS**;
analyzer całego katalogu Powiadomień PASS. Jeden import `core/l10n` pozostał
wyłącznie w nieaktywnym, historycznym `notifications/standalone/`; nie jest
częścią globalnego hosta i wymaga osobnego audytu, zamiast cichego usunięcia.
Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2m: test aktywnej listy globalnego Chatu

`devplanner_global_panels_host_test.dart` nie sprawdza już wyłącznie stanu
„Chat unavailable”. Dodano scenariusz z prawdziwym portem `ChatRepository`:
kliknięcie belki otwiera globalny panel, Cubit pobiera i renderuje rozmowę,
a ekran zadania pod panelem pozostaje w drzewie. Test korzysta z lokalizacji
takiej jak produkcyjny `MaterialApp`, więc wykrywa również brak delegatów.

Odbiór: test globalnego hosta **3/3 PASS**, analyzer testu PASS. Jest to
automatyczny dowód renderowania panelu i braku zmiany trasy, nie dowód
realtime, ACL ani wysyłki między dwoma użytkownikami; te scenariusze pozostają
do odbioru stagingowego. Nie uruchamiano GUI ani aplikacji.

### 2026-09-18 — R2n: foundation dla aktywnej ścieżki globalnego Chatu

Sześć komponentów renderowanych przez globalny panel Chat (`chat_drawer`,
lista wiadomości, composer i pola composera oraz oba fragmenty rozmowy)
korzysta teraz z publicznych fasad `foundation/l10n` i `foundation/theme`.
Nie zmieniono repository, Cubitów, SignalR, draftów, uploadu ani nawigacji;
to wyłącznie usunięcie sprzężenia presentation z historyczną ścieżką `core`.

Odbiór: host panelu, Cubit rozmowy i widget composera **19/19 PASS**; analyzer
katalogu Chat PASS. Sprawdzone pliki aktywnego panelu nie mają już importów
`core/l10n` ani `core/theme`. Nie uruchamiano GUI ani aplikacji.
### 2026-09-18 — R2o: Chat wyłącznie jako globalny panel

Globalny Chat nie może otwierać własnej trasy ani ekranu. Usunięto martwy
fallback, który po kliknięciu „pełny widok” zamykał panel i prowadził do
nieistniejącego `/chat/conversations/:id`. Akcja „otwórz pełny widok” jest
teraz opcjonalna i nie jest renderowana przez session-scoped host; rozmowa,
historia oraz composer pozostają w prawym overlayu nad aktualną trasą.

Usunięto również niepodłączone, historyczne wrappery pełnych stron Chat
(`chat_landing_page.dart` i `chat_route_pages.dart`). Nie usunięto domeny,
repository, Cubitów ani Resource Chat dla udostępnionych plików — są one
kontraktami panelu. Dodany test wybiera rozmowę w globalnym panelu, potwierdza
brak ikony przejścia do osobnego widoku oraz zachowanie ekranu pod overlayem.

Odbiór: `devplanner_global_panels_host_test.dart` **3/3 PASS**; pakiet
Chat (host, Cubit rozmowy, composer) **19/19 PASS**; analyzer aktywnego
katalogu Chat PASS. Nie uruchamiano GUI, backendu ani stagingu.
### 2026-09-18 — R2p: odbiór granicy overlayu i routera

Po usunięciu historycznych wrapperów sprawdzono cały produkcyjny katalog
`lib`: `flutter analyze lib` zakończył się PASS. Test katalogu root routera
potwierdził **16/16 PASS**, w tym realne trasy zadań, Kanban oraz plików.
Test hosta globalnych paneli potwierdził **3/3 PASS**. Nie ma już kodu
presentation prowadzącego do `/chat/conversations/:id`; pozostają wyłącznie
kontrakty HTTP API pod `/api/v1/chat/...`, potrzebne overlayowi.

Zgodność obu przekazywanych dokumentów została sprawdzona przez `cmp`,
a `git diff --check` dla Front i Backend nie wykazał błędów whitespace.
Nie uruchamiano GUI, desktopowego frontu, backendu, MinIO ani stagingu.
### 2026-09-18 — R2q: regresja priorytetowych pionów Workspace

Wykonano odbiór trzech zakresów wskazanych jako priorytet: Pliki, lista
zadań i Kanban. Testy potwierdzają, że domyślna trasa zadań używa bogatej
listy standalone, a trasa Kanban używa istniejącej implementacji board;
przepływ tworzenia zadania czeka na potwierdzenie i blokuje podwójne wysłanie.
Dla Files sprawdzono sidebar, toolbar, listę, breadcrumbs, menu desktopowe,
skrót Cmd/Ctrl+A, Escape i zachowanie po zwężeniu layoutu.

Odbiór: wskazane testy **20/20 PASS**. To automatyczna regresja komponentów
i tras, nie test stagingowy połączeń API/MinIO. Nie uruchamiano aplikacji,
backendu ani GUI.
### 2026-09-18 — R2r: rozdzielenie automatyzacji Tasks i zakaz setState

W aktywnym pionie Tasks usunięto ostatnie znalezione użycie `setState` z
przełącznika grupowania listy. Hover i focus są lokalnym, niemutowalnym stanem
`ValueNotifier` oraz `ValueListenableBuilder`; nie dotyczą danych domenowych.
Komponent korzysta też z publicznych fasad `foundation/l10n` i
`foundation/theme`.

`AutomationSettingsCubit` został podzielony bez zmiany endpointów lub UI:
stan jest w osobnym pliku, startowe odczyty są w
`AutomationSettingsLoader`, a odczyt tasków/dry-run w
`AutomationSettingsDryRunService`. Cubit nadal jest jedynym właścicielem
publikacji stanów, mutacji reguł, historii i lifecycle. Sama klasa ma teraz
392 linie, czyli mieści się w wymaganym limicie; nie użyto funkcji globalnych
ani `BuildContext` poza UI. Pełny raport: Front
`docs/recovery/R2r-task-settings-quality-report.md`.

Odbiór: przełącznik **1/1 PASS**, ustawienia automatyzacji **9/9 PASS**,
analyzer katalogu Cubitów PASS. Nie uruchamiano GUI, backendu ani stagingu.
### 2026-09-18 — R2s: foundation dla aktywnych Tasks i Files

Dwadzieścia cztery pliki renderowane przez Shell Plików, recurrence oraz Saved
Views Tasks przestały importować historyczne fasady `core/l10n` i
`core/theme`. Używają wyłącznie publicznych `foundation/l10n` i
`foundation/theme`. Nie zmieniono modeli, repository, endpointów, routera,
Cubiców ani zachowania UI; jest to usunięcie sprzężenia presentation, nie
mechaniczne kasowanie dawnego katalogu `core`.

Odbiór: analyzer trzech objętych gałęzi PASS; regresja Files, Saved Views i
recurrence **29/29 PASS**. Skan aktywnych Tasks/Files nie wykazuje już importów
`core/l10n` ani `core/theme`. Szczegóły i komendy:
`docs/recovery/R2s-active-tasks-storage-foundation-report.md`. Nie uruchamiano
GUI, backendu ani stagingu.
### 2026-09-18 — R2t: router bez jednej dużej klasy

Konfiguracja `GoRouter`, guard i lifecycle pozostały w
`devplanner_router.dart`; budowanie stron i redirectów przeniesiono do
`devplanner_router_pages.part.dart` z jawnym kontraktem getterów zależności.
Główna klasa routera mieści się w limicie, a komponent stron ma 209 linii.
Nie zmieniono konstruktora publicznego, URL-i, `?view=kanban`, walidacji UUID,
ACL ani composition Files/Tasks/Admin.

Odbiór: analyzer routera PASS; testy katalogu root routera, routera i
powiadomień **31/31 PASS**. Potwierdzono realne trasy katalogu, projektów,
Files, listy/Kanbanu/szczegółu taska, public share oraz fail-closed `/admin`.
Szczegóły: `docs/recovery/R2t-router-boundary-report.md`. Nie uruchamiano
GUI, backendu ani stagingu.
### 2026-09-18 — R2u: tylko dwa motywy DevPlanner

Z `MaterialTheme` usunięto cztery nieużywane warianty medium/high contrast,
ich publiczne fabryki oraz puste modele dodatkowych kolorów. Pozostają tylko
`light()` i `dark()` z tokenami Gmail-like shell, feedbacku i powierzchni.
Fabryka motywu ma 300 linii, nie przekracza limitu i nie wprowadza kolejnego
presetu sprzecznego ze specyfikacją.

Odbiór: analyzer theme/app/shell PASS; testy jasnego/ciemnego motywu,
`DevPlannerApp` i shell **9/9 PASS**. Raport:
`docs/recovery/R2u-two-theme-foundation-report.md`. Nie uruchamiano GUI,
backendu ani stagingu. Preferencja użytkownika w ustawieniach jest odrębnym
następnym krokiem, nie została pozorowana kontrolką bez persistence.
### 2026-09-18 — R2v: trwały wybór jasnego albo ciemnego motywu

Dodano drzewo `app/theme`: enum dwóch wariantów, port persistence, adapter
`shared_preferences` oraz mały `ThemePreferenceCubit`. Domyślnie aplikacja
startuje jasno; odczytuje zapis bez blokowania startu, a zmianę publikuje
dopiero po potwierdzonym zapisie. `DevPlannerApp` składa i zamyka Cubit, nie
tworząc nowego routera przy zmianie `themeMode`.

Belka ma jedną dostępną akcję przełączenia jasny/ciemny, sterowaną wyłącznie
przez Cubit. Nie dodano wariantu systemowego, presetów, `setState`, I/O w UI
ani nowego ekranu. Odbiór: analyzer PASS; Cubit, aplikacja i shell **11/11
PASS**. Szczegóły: `docs/recovery/R2v-theme-preference-report.md`. Nie
uruchamiano GUI, backendu ani stagingu.
### 2026-09-18 — R2w: audyt struktury aktywnego Frontu

Skan aktywnych `app/auth/foundation/workspaces` nie znajduje importów Ready,
DataBus ani dawnych połączeń zewnętrznych. W aktywnych App/Foundation/Tasks/
Files nie ma też `setState`. Skan plików >400 jest tylko wskazówką: router
ma osobne klasy i 209-linijkowy builder stron, automatyzacja ma Cubit 392 linii
oraz oddzielne state/loader/dry-run, a transport rozdziela request/response/
adaptery. Nie wykonywano mechanicznego dzielenia plików.

Dokładny zapis granic klas i ograniczeń odbioru:
`docs/recovery/R2w-structural-audit-report.md`. Wynik nie jest dowodem live;
backend, MinIO, SignalR, OnlyOffice i staging pozostają NOT RUN, ponieważ GUI
nie było uruchamiane.
### 2026-09-18 — R2x: chroniony zakres odzyskania Workspace

Zakres tej fazy jest zamknięty: przywracamy Files, Tasks i Kanban jako
działające piony oraz częściowy Chat i Powiadomienia wyłącznie jako globalne
prawe overlaye. Nie dodajemy osobnego ekranu/trasy Chat lub Powiadomień ani
nowych pionów Whiteboard, Wiki, Corkboard, OKR czy Automations.

Audyt Backend potwierdził brak aktywnego klienta/URL/konfiguracji Ready,
Core/DataBus; jedyny traf to fail-closed guard zakazujący `DATABUS`.
`dotnet build veloryn-workspaces.csproj --no-restore` kończy się 0 warnings,
0 errors. `flutter analyze` aktywnego Frontu i testów Files/Tasks/Shell/Router
kończy się `No issues found`. Raport i granice odbioru:
`docs/recovery/R2x-active-scope-and-standalone-audit-report.md`. Nie
uruchamiano GUI, Backend ani stagingu.
### 2026-09-18 — R2y: helpery Tasks bez funkcji globalnych

W aktywnych Tasks przeniesiono pomocniki grupowania listy, menu wiersza,
cykliczności, historii, załączników, awatarów współpracowników, pól własnych,
kolorów etykiet oraz launchery type/assignee/settings/archive do małych klas
jednej odpowiedzialności. Nie zmieniono tras, endpointów, modeli, danych ani
Cubitów. Analiza całego Tasks PASS, `task_list_grouping_test` **4/4 PASS**.
Pozostałe historyczne launchery UI są zapisane jako kolejny mały krok, bez
prawa do stworzenia wspólnego utility/God class. Raport:
`docs/recovery/R2y-tasks-helpers-boundary-report.md`.
### 2026-09-18 — R2z: dowód regresji pionu Files

Testy wertykalne potwierdzają istniejące zachowanie folderów, uploadu,
downloadu, sharingu, ACL/BFF read-only, wersjonowania i delete/restore. Pełny,
jednoznacznie zapisany końcowy wynik dla wersji oraz delete/restore to **13/13
PASS**; zakres i granica względem MinIO/staging są opisane w
`docs/recovery/R2z-storage-vertical-regression-report.md`. Nie uruchamiano
aplikacji, Backend, MinIO ani GUI.
### 2026-09-18 — R3a: rdzeń Kanban potwierdzony automatycznie

Trasa, ACL, loading/empty, DnD z rollbackiem, workflow, bulk operations,
quick create, filtry, preferencje i realtime boardu są pokryte wynikiem
**40/40 PASS**. Nie jest to odbiór live SignalR/Backend. Pełny zakres:
`docs/recovery/R3a-kanban-core-regression-report.md`.
### 2026-09-18 — R3b: globalne panele częściowo potwierdzone

Overlay Chat/Powiadomienia nie zmienia aktywnej trasy; testy obejmują czyszczenie
Chat po revoke, realtime, cursor/retry Inbox oraz odpowiedź do Chat. Wynik
**36/36 PASS** nie zastępuje desktopowego testu SignalR/Backend. Szczegóły:
`docs/recovery/R3b-global-panels-regression-report.md`.
### 2026-09-18 — R3c: kolejne launchery Tasks bez funkcji globalnych

`AnchoredTextEditor`, `TaskDatePicker`, `TaskComplexityPicker`,
`TaskSizePicker`, `TaskRiskPicker`, `TaskDurationEditor` i
`TaskBusinessValuePicker` zastępują funkcje plikowe w edycji
komórek, menu oraz template actions. Normalizacja daty UTC nie zmieniła
zachowania, a cały katalog Tasks po zmianie ma `flutter analyze` PASS. Kolejny
zakres i zasady: `docs/recovery/R2y-tasks-helpers-boundary-report.md`.
### 2026-09-18 — R3d: tabela i mapowania szczegółu Tasks

`TaskDetailsLabeler` i `TaskListGrid.visibleColumns` zastępują dwie funkcje
globalne bez zmiany danych. `project_tasks_list_rows_test` obejmujący tabelę,
daty, typy, metryki i menu kończy się **24/24 PASS**; cały Tasks analyzer PASS.
### 2026-09-18 — R3e: zależności, cykliczność i opis Tasks

Formularze szczegółu używają `TaskDependencyLabeler` i
`TaskRecurrenceModeLabeler`; odczyt Quill Delta/fallback tekstowy przejął
`TaskDetailsDescriptionControllerFactory`. Nie zmieniono requestów ani stanu
zadania. Analyzer katalogu szczegółów PASS.

### 2026-09-18 — R3f: czas pracy Tasks bez funkcji globalnych

`TaskTimeTrackingPresentation` przejął obliczanie minut aktywnego wpisu oraz
formatowanie czasu i statusu akceptacji. Zmiana jest czysto prezentacyjna:
nie zmienia requestów, stanu ani odpowiedzialności `TaskTimeTrackingCubit`.
`flutter analyze lib/workspaces/presentation/tasks/detail` kończy się PASS.

### 2026-09-18 — R3g: cykliczność Tasks bez funkcji globalnych

`TaskRecurrenceDialogLauncher` składa dialog z istniejącym repository i
`TaskRecurrenceCubit`, a `TaskRecurrenceFrequencyLabeler` lokalizuje etykiety.
Zapis cykliczności oraz kontrakty API nie zmieniły się. Analyzer szczegółów
Tasks PASS.

### 2026-09-18 — R3h: milestone Tasks bez funkcji globalnej

`TaskMilestonePickerLauncher` przejął wyłącznie otwarcie dolnego pickera z
istniejącym `TaskMilestoneCubit`; przypisanie i odpięcie nadal wykonuje Cubit.
Analyzer szczegółów Tasks PASS.

### 2026-09-18 — R3i: template Tasks bez funkcji globalnej

`TaskTemplateDialogLauncher` przejął kompozycję modalu z aktualnym zadaniem
i `TaskTemplateCubit`; sam zapis template pozostaje w Cubicie. Analyzer
szczegółów Tasks PASS.

### 2026-09-18 — R3j: akceptacja i checklista Tasks bez funkcji globalnych

`TaskDetailsTextEditor` obsługuje dialog krótkiego tekstu i deleguje mutacje
do `TaskDetailsCubit`; `TaskDependencyTypeLabeler` lokalizuje typ relacji.
Analyzer szczegółów oraz testy usług akceptacji/checklisty **5/5 PASS**.

### 2026-09-18 — R3k: pełna analiza Frontu bez ostrzeżeń

Naprawiono wyłącznie higienę testów: kolejność importów oraz trzy wywołania API
Flutter oznaczone jako przestarzałe. Nie zmieniono funkcjonalności produktu,
tras, kontraktów ani transportu. `flutter analyze` kończy się `No issues
found`; testy trasy logowania i tokenów motywu **5/5 PASS**.

### 2026-09-18 — R3l: artefakt desktopowego Frontu zbudowany

`flutter build macos --debug` zbudował `DevPlanner.app` bez uruchamiania GUI.
Flutter zgłasza wyłącznie nieblokujące ostrzeżenie przyszłej kompatybilności
Swift Package Manager dla `media_kit_libs_macos_video` i `media_kit_video`.
Przed stagingiem należy je śledzić przy aktualizacji Fluttera; nie jest to
obecny błąd kompilacji ani dowód odbioru live.

### 2026-09-18 — R3m: Backend kompiluje się bez ostrzeżeń

`dotnet build veloryn-workspaces.csproj --no-restore` kończy się powodzeniem:
**0 ostrzeżeń, 0 błędów**. Polecenie nie uruchamia Backend, bazy, MinIO ani
innych usług środowiskowych.

### 2026-09-18 — R3n: regresja aktywnych pionów Frontu

Testy routera/shella, Kanbanu oraz Files (wersje, delete/restore) kończą się
**57/57 PASS**. Testy globalnych overlayów Chat/Powiadomienia, realtime,
revoke, retry i odpowiedzi do Chat kończą się **36/36 PASS**. W szczególności
panel zachowuje aktywną trasę pod spodem. To dowód automatyczny, nie zastępuje
ręcznego scenariusza desktopowego z Backendem, MinIO i SignalR.

### 2026-09-18 — R3o: audyt granic aktywnego Frontu

W `app`, `auth`, `foundation` i `workspaces` nie ma wywołania `setState` ani
bezpośredniego klienta HTTP w warstwie prezentacji. Skan funkcji plikowych
aktywnych Tasks jest pusty. Najdłuższe klasy aktywnego UI/Cubit pozostają pod
limitem 400 linii: `TaskDurationEditor` ma 399, a
`AutomationSettingsCubit` 392; długie pliki generowane i modele/transport są
wyłączone z tego kryterium. Nie jest to test runtime.

### 2026-09-18 — R3p: aktywny Resource Chat pliku i cleanup placeholderów

Files ma aktywną trasę szczegółu `/storage/files/:fileId`; z listy prowadzi do
niej akcja „Szczegóły pliku”. `StorageFileDetailsCubit` pobiera świeże
uprawnienia, a „Czat pliku” jest widoczny tylko przy potwierdzonym
`canOpenResourceChat`. `ResourceChatCubit` ponownie autoryzuje zasób i otwiera
prawy globalny panel bez trasy Chat. Usunięto nieosiągalne źródła dawnych tras
z placeholderami oraz dawne widoki tras Whiteboard/Wiki/OKR. Analyzer PASS;
testy Resource Chat, routera i Files **31/31 PASS**, a katalog i przejście
Files → szczegóły **14/14 PASS**. Szczegóły:
`docs/recovery/R2x-active-scope-and-standalone-audit-report.md`.

### 2026-09-18 — R3q: ponowny build macOS po aktywacji Files Resource Chat

`flutter build macos --debug` po dodaniu szczegółu Files i cleanupie dawnych
tras zbudował `DevPlanner.app`. Nie uruchamiano GUI. Pozostaje wyłącznie znane,
nieblokujące ostrzeżenie przyszłej obsługi Swift Package Manager przez
`media_kit_libs_macos_video` i `media_kit_video`.

### 2026-09-19 — R3r: domyślne uruchomienie macOS ze stagingiem

Konfiguracja VS Code `DevPlanner macOS — staging` przekazuje teraz jedyny
standalone origin `https://devnote.flutter-dev.pl` jako
`DEVPLANNER_API_BASE_URL`. Ten sam adres obsługuje Flutter Web, BFF, API,
OpenIddict i SignalR, więc desktop korzysta z wdrożonego backendu bez lokalnego
API, PostgreSQL lub MinIO. Lokalna konfiguracja HTTPS pozostaje osobnym,
jawnym wyborem; bezpieczny domyślny adres kodu dla świeżego checkoutu nie został
zmieniony.

Odbiór konfiguracji: `https://devnote.flutter-dev.pl/health/ready` zwraca
`Healthy`; `jq empty .vscode/launch.json`, synchronizacja dokumentów
Front/Backend oraz `git diff --check` w obu repozytoriach są PASS. Nie
uruchomiono GUI ani nie wykonano loginu — to nie jest dowód desktopowego E2E.

### 2026-09-19 — R3s: ciągła rama Gmail-inspired shella

Zmieniono layout `lib/app/shell/devplanner_shell_layout.dart`, tokeny globalne
`lib/foundation/theme/theme.dart` oraz testy geometrii/typografii. Lewa
kolumna obejmuje teraz nagłówek marki i menu, a oddzielna prawa belka ma 40 px
i zachowuje sekcję bieżącego modułu oraz akcje globalne. Zwijany sidebar ma
52 px; menu ma wiersze 32 px, Inter 11 px i ikony 18 px. Globalny ThemeData
ustala mniejsze role tekstu i spójne ikony 18 px. Nie zmieniono routingu,
Chat, Notifications, API ani kontraktów danych.

Wykonane komendy: `dart format`, scoped `flutter analyze`, `flutter test`
shell/theme/typography (**7/7 PASS**), `flutter build macos --debug` (PASS)
i `git diff --check` (PASS). Następny krok: zamknąć i ponownie uruchomić
desktopową aplikację, a następnie wykonać manualne porównanie z referencją w
trybie jasnym i ciemnym przy 100%, 125% i 150% skalowania tekstu.

### 2026-09-19 — R3t: nowe drzewo lewego menu Workspace

Menu Workspace nie pobiera już projektów dla wszystkich workspace'ów przy
starcie. WorkspaceNavigationTreeCubit pobiera katalog, a projekty ładuje
leniwie dopiero po rozwinięciu gałęzi Projekty; równoległe kliknięcia dzielą
jedno żądanie, a błąd projektu pozostaje lokalny dla workspace'u. Nie zmieniono
kanonicznych tras Lista/Kanban/Files ani nie dodano tras dla nieukończonych
pionów.

Shell otrzymał wąski WorkspaceManagementGateway i przycisk tworzenia
workspace'u. Produkcyjny adapter używa istniejącego POST /api/v1/workspaces/;
po sukcesie katalog odświeża się, nowy workspace jest rozwijany, a aplikacja
przechodzi na jego kanoniczny URL. Chat i Powiadomienia nadal są overlayami,
nie elementami drzewa.

Odbiór: scoped flutter analyze PASS; testy lazy loadingu drzewa oraz shell i
router 23/23 PASS; git diff --check PASS. Nie uruchamiano GUI, Backend,
stagingu ani pełnego buildu platformowego. Następny krok: ręczny odbiór
desktopu z rzeczywistą sesją, w tym utworzenie workspace'u oraz dark/light i
125/150% tekstu.

### 2026-09-19 — R3u: globalne tokeny nawigacji

Dodano `lib/foundation/theme/navigation_theme.dart` i zarejestrowano go w
globalnym `ThemeData`. Shell oraz wszystkie aktywne warianty menu Workspace
używają wspólnych wymiarów: sidebar 224/56 px, nagłówek 56 px, wiersz 28 px,
ikona 18 px, tekst 12 px, etykieta sekcji 11 px, wcięcie 16 px i promień 14 px.
Zmieniono również test geometrii shella oraz test tokenów motywu.

Wykonane komendy: `dart format`, scoped `flutter analyze` (PASS) i targeted
`flutter test` dla motywu, shella oraz menu Workspace (**10/10 PASS**).
Następny krok: ręczne porównanie uruchomionej aplikacji desktopowej z
referencją przy 100%, 125% i 150% skalowania tekstu; należy zweryfikować
widok jasny i ciemny, długie nazwy oraz stan rozwiniętego projektu.

### 2026-09-19 — UX-A1: przekazanie audytu Listy/Kanbanu

Zakres był read-only poza nowym dokumentem planu. Przejrzano aktywny router,
composition Tasks, Listę, Kanban, theme, menu kontekstowe, kontrakty endpointów
Backend oraz historię Git od bootstrapu `d1cc273`.

Najważniejszy blocker: `TasksBoardRoutePage._content` zwraca pełny
`TasksBoardPage` tylko dla `initialView == 'kanban'`. Domyślna Lista i
pozostałe wartości query zwracają bezpośrednio `ProjectTasksList` z
`listenToBoardRealtime: false`. To wyjaśnia brak wspólnego headera i
niedostępność Timeline/Workload/Recurrence po zmianie URL. Nie należy kopiować
brakujących kontrolek do Listy; trzeba usunąć route-level bypass.

Gotowy plan:
`Front/docs/recovery/tasks-list-kanban-ux-recovery-plan.md`. Pierwszy krok T0
naprawia wyłącznie route/composition/query/tests. Potem T1/T2 stabilizują tokeny
i menu, T3 buduje wspólny Tasks chrome, T4 i T5 domykają równolegle Listę i
Kanban, T6 porządkuje ekspozycję istniejących funkcji Backend, a T7 wykonuje
rzeczywisty odbiór live. Nie uruchamiano GUI, Backend ani pełnych bramek, bo
pakiet nie zmienia kodu runtime.

### 2026-09-19 — UX-T0: jeden host Tasks i kontrakt trasy

Regresja kompozycji z `TasksBoardRoutePage` została usunięta: trasa zawsze
montuje ten sam `TasksBoardPage`, więc Lista, Kanban, Timeline, Workload i
Cykliczne dzielą nagłówek, zapisane widoki, ustawienia projektu i lifecycle
realtime.

Kanoniczny kontrakt `?view=` żyje w
`lib/workspaces/presentation/tasks/tasks_project_view_contract.dart`: `/tasks`
otwiera Listę, `?view=kanban` Kanban, `board` pozostaje aliasem wejściowym, a
`list|timeline|workload|recurrence` są rozpoznawane jak dotychczas. Serializacja
Kanbanu pozostała `kanban`, żeby menu projektu, sidebar i deep link używały
jednego adresu; `?view=` buduje wyłącznie
`DevPlannerRouteCatalog.projectTasksView`.

Zachowanie i granice:

- `TasksProjectViewHost` czyta widok wyłącznie z adresu. Per-projektowe
  zapamiętywanie widoku (`tasks_project_view_preferences.dart`) zostało
  usunięte, bo po restarcie mogło wybrać inny widok niż URL.
- `TasksBoardReadyView` nie montuje widoku, którego użytkownik nie otworzył, ale
  trzyma stabilne sloty Listy i Kanbanu. Domyślna Lista nie pobiera więc stron
  kolumn Kanbanu, a powrót między widokami nie gubi scrolla i stanu inline.
- Sidebar porównuje ścieżkę oraz widok z `?view=`, więc `?view=list` zaznacza
  Listę, `?view=kanban` Kanban, a szczegół zadania dziedziczy widok z adresu.
  Wiersz projektu prowadzi bezpośrednio do jego Listy zamiast być martwą pozycją.
- Drzewo nawigacji nie renderuje już pośredniego „Przeglądu”; `/workspaces`
  pozostaje bezpiecznym wejściem (`/` → `/workspaces`) dla konta bez workspace'u.
- Nie zmieniono API ani UI tabeli i boardu.

Dowody: `flutter test` **884/884 PASS**, w tym nowy
`test/app/router/devplanner_tasks_view_route_test.dart` (deep link, alias
wejściowy, restart, zmiana URL w obie strony, historia przeglądarki, zapis
kanonicznego `?view=`, fallback `/`) oraz `test/workspaces/presentation/tasks/tasks_project_view_contract_test.dart`.
Zaktualizowano testy shella i trasy Tasks; współdzielony fixture kompozycji to
`test/test_support/tasks_board_route_fixture.dart`. `flutter analyze`:
**No issues found**, `git diff --check` czysty.

Naprawiono zastany, czerwony test `workspace gateway route can render a real
workspace card`: przy domyślnym 800×600 shell jest compact (<960 px) i nie
renderuje marki, więc test otrzymał jawny rozmiar desktopowy 1280×900. Test
failował także na `eda6e56`, przed tym pakietem.

Ograniczenia: brak odbioru GUI/E2E, Backend nie był uruchamiany, Windows i Linux
pozostają NOT RUN. W drzewie roboczym równolegle pracuje inna sesja agenta
(Codex) rozszerzająca kompozycję Tasks o `ProjectsRepository` i test modali
ustawień projektu; te zmiany zachowano bez modyfikacji. Następny krok: T1 (tokeny
i typografia) oraz T2 (jedna infrastruktura menu).

### 2026-09-19 — UX-T1: tokeny Tasks, podłoga typografii i powierzchnie

Powstało rozszerzenie motywu `lib/foundation/theme/tasks_theme.dart`
(`DevPlannerTasksTheme`), wpięte do `MaterialTheme.theme(...)` dla wariantu
jasnego i ciemnego. Niesie jedną skalę dla całego modułu Tasks:

- typografia: nazwa projektu 15/20 w600, dane 13/18, dane wyróżnione 13/18 w600,
  tytuł karty Kanbanu 14/20 w600, kontrolki 12/16 w600, metadane 11/16, wiersz
  menu 12/16; style dziedziczą rodzinę Inter z motywu aplikacji;
- geometria: wiersz kontekstu 46, wiersz poleceń 38, nagłówek tabeli 36, wiersz
  tabeli 38, wiersz grupy 40, wiersz menu 32 z ikoną 16, promienie 8/8/12,
  odstępy 4/8/12/16/24;
- powierzchnie: `canvas`, `canvasBorder`, `commandBar*`, `card*`, `divider`,
  `rowHover`, `rowSelected`, `bulkBar*`, `selectionAccent`, `onAccent`, `shadow`
  i `scrim`.

Podniesiono globalną podłogę czytelności: `labelMedium` 10 → 12 px i
`labelSmall` 10 → 11 px w `lib/foundation/theme/theme.dart`. To była główna
przyczyna „ściskania do 10 px", bo tabela Listy i metadane kart korzystały
właśnie z tych tokenów.

Usunięte twarde wartości z aktywnego Tasks:

- lokalne tło kanwy (`0xFF11131C` / `0xFFF6F7FB`) zastąpione `tasksTheme.canvas`;
- wszystkie `Colors.white` i `Colors.black` w module zastąpione rolami
  `onAccent`, `shadow` i `scrim` — w module nie pozostało żadne;
- wszystkie rozmiary poniżej 11 px (10, 10.5, 9.5, 9, 8) podniesione do tokenów
  metadanych lub kontrolek — nie pozostało żadne;
- `kanban_card_tokens.dart` wylicza typografię karty z motywu; inicjał awatara
  dostał kolor tokenu, bo wcześniej był 9–10 px bez koloru i zależał od
  domyślnego koloru tekstu.

Zmiana jest celowo wizualna, więc odświeżono trzy goldeny Kanbanu
(`card_comfortable_light.png`, `card_comfortable_dark.png`,
`header_desktop_1280.png`). Artefakty starszego niepowodzenia w
`board/failures/` przywrócono do stanu z repozytorium.

Dowody: pełny `flutter test` **913/913 PASS** (dwa kolejne przebiegi), w tym nowe
`test/foundation/theme/tasks_theme_test.dart` (kontrakt tokenów: rozmiary,
interlinia, siatka 4 px, wysokości wierszy, promienie, powierzchnie z palety,
`copyWith`, `lerp`) oraz
`test/workspaces/presentation/tasks/board/tasks_board_text_scale_test.dart`
(18 kombinacji light/dark × 1024/1440/1920 px × 100/125/150 % bez overflow).
`flutter analyze`: **No issues found**, `git diff --check` czysty.

Uwaga o flake: w jednym z przebiegów pełnego suite czerwony był
`chat_composer_draft_persistence_test.dart` (debounce draftu). Test przechodzi
samodzielnie i w powtórzonym pełnym przebiegu **913/913**; nie dotyczy modułu
Tasks ani motywu.

Ograniczenia i następny krok:

- Semantyczne palety danych (priorytety, statusy, kolory kolumn) pozostały bez
  zmian, bo nie są powierzchniami. Audyt wykrył jednak cztery rozbieżne kopie
  palety priorytetów (timeline, header filters, cards, helper listy) — ich
  ujednolicenie należy do T5/T6.
- Nagłówek i command bar zachowują obecny układ. Tokeny są gotowe, ale
  dwurzędowy chrome z §3.2 buduje T3, a domknięcie Listy i Kanbanu to T4/T5.
- Globalna zmiana tokenów etykiet dotyczy całej aplikacji; pełny suite przechodzi,
  ale odbiór wizualny na Web i macOS pozostaje w T7.

### 2026-09-19 — UX-T2: jedna infrastruktura menu

Wybrany został jeden publiczny komponent: `AppContextMenu`
(`lib/shared/presentation/widgets/app_context_menu.dart`). Zastąpił trzy
współistniejące systemy: `TaskContextMenu` i `WorkspaceContextMenu` (oba pliki
usunięte) oraz warianty `flat`/`glass` (usunięte razem z refleksem, shaderem
i painterem obramowania).

Komponent po przebudowie:

- jedna powierzchnia z tokenów `DevPlannerMenuTheme`
  (`lib/foundation/theme/menu_theme.dart`): wiersz 32 px, ikona 16 px, tekst
  13 px, nagłówek sekcji 11 px, promień 8 px, minimalna szerokość 220 px,
  kolory z palety motywu (bez lokalnych `Colors.white`/`Colors.black`);
- trzy wejścia: `show` (akcje), `select<T>` (wybór wartości), `showCustom`
  (interaktywna zawartość, np. wyszukiwanie osób) oraz `AppContextMenuRegion`
  dla prawego klawisza myszy;
- sekcje (`sectionTitle`, grupowane bez powtórzeń), skróty (`shortcutLabel`),
  `selected`, `enabled`, `isDestructive`, `separatorBefore` i opcjonalne
  `leading`/`trailing`;
- klawiatura: strzałki z zawijaniem, Home, End, Enter, Space; Escape zamyka
  przez `DismissIntent` trasy;
- focus: `FocusScope` i `FocusTraversalGroup` wewnątrz powierzchni, a po
  zamknięciu focus wraca do widgetu, który menu otworzył;
- pozycjonowanie w root overlayu z marginesem 12 px od krawędzi ekranu.

Migracja objęła 48 wywołań `TaskContextMenu.show`/`positionFor` w 22 plikach
modułu Tasks (pickery tabeli, menu wiersza i karty, akcje nagłówka, szablony,
podzadania) oraz wszystkie użycia `WorkspaceContextMenu`. Pickery przyjmują
teraz globalną pozycję `Offset` zamiast `RelativeRect`, a edytor czasu zadania
korzysta z `showCustom` zamiast własnego `showDialog` z ręczną powierzchnią,
cieniem i `TaskDurationPickerAnchor` (plik usunięty jako zbędny).

Dowody: pełny `flutter test` **929/929 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty. Nowe testy:
`test/shared/presentation/widgets/app_context_menu_test.dart` (9 przypadków:
sekcje i skróty, wybór wartości, pozycja wyłączona, kolor destrukcyjny z tokenów
motywu, klawiatura, Escape z powrotem focusu, prawy klik, wykonanie akcji,
pozycjonowanie przy krawędzi ekranu) oraz
`test/shared/presentation/widgets/app_context_menu_boundary_test.dart`
(strażnik: zakres menu bez `core/theme`, bez lokalnych kolorów, bez wariantu
glass i starych klas; pickery korzystają ze wspólnego kontraktu).

Poza zakresem T2, świadomie zostawione do T4/T6: 12 surowych `PopupMenuButton`
w powierzchniach, które T4 przebudowuje (bulk bar 7, filtry 2, zapisane widoki 2)
oraz edytor pól niestandardowych w szczegółach (1). T4 zastępuje te kontrolki
wspólnym command barem, a nie migruje ich jeden do jednego.

Konflikt między sesjami: równoległa sesja agenta wymieniła tekstową markę shella
na logo (`devplanner-sidebar-brand-logo`) w `devplanner_shell_layout.dart` i
zaktualizowała `test/app/shell/devplanner_shell_test.dart`, ale nie
`test/app/router/devplanner_root_router_compile_test.dart`. Dostosowałem tam
jedną asercję (marka to dziś logo z etykietą semantyczną, a nazwę „DevPlanner”
niesie karta workspace'u), żeby suite wrócił do zielonego. Zmiana nie dotyczy
zachowania, tylko reprezentacji marki.

### 2026-09-19 — UX-T3: wspólny dwurzędowy nagłówek Listy i Kanbanu

Nagłówek przestał być kanbanocentryczny: pliki przeniesione do neutralnego
katalogu `lib/workspaces/presentation/tasks/header/`
(`tasks_header.dart`, `tasks_header_layout.dart`, `tasks_header_actions.dart`,
`tasks_header_create_actions.dart`, `tasks_header_command_bar.dart`,
`tasks_header_quick_create_dialog.dart`), a publiczny komponent nazywa się
`TasksHeader`. Moduł montuje teraz publiczny nagłówek, więc Lista i Kanban
używają dokładnie tego samego chrome i testy mają jeden typ do sprawdzenia.

Układ jest zawsze dwuwierszowy (§3.2) na tokenach `DevPlannerTasksTheme`:

- wiersz kontekstu (`contextRowHeight`, 44–48 px): ikona, nazwa projektu,
  licznik zadań, zakładki Lista/Kanban/Timeline/Workload/Cykliczne, obecność
  i menu projektu oraz główne CTA „Dodaj zadanie” z menu szablonów;
- wiersz poleceń (`commandRowHeight`, 36–40 px): zapisane widoki oraz akcje
  zależne od widoku (szybki filtr Kanbanu); po zaznaczeniu zadań ten wiersz
  staje się jednym kontekstowym paskiem akcji masowych, a widokowe kontrolki
  znikają, więc nie renderują się dwa paski naraz.

API nagłówka nie zna już `GoRouter`: wyjście z projektu (opuszczenie lub
usunięcie) dostarcza trasa przez `onProjectExited`, przekazywane przez
`TasksBoardPage` i host widoku.

Dowody: pełny `flutter test` **934/934 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty. Testy: przepisany
`tasks_board_header_responsive_test.dart` (dwa widoki × 360/768/1024/1440/1920 px,
geometria obu wierszy z tokenów, brak overflow, pasek masowy w drugim wierszu),
zaktualizowany `kanban_baseline_audit_test.dart` oraz golden nagłówka
(`goldens/header_desktop_1280.png` odświeżony, bo zmienił się układ), a także
dowód kompozycji w `tasks_board_route_page_test.dart`: ten sam `TasksHeader`
dla wszystkich widoków, wspólne zakładki i zapisane widoki oraz szybki filtr
tylko w widoku Kanbanu, plus sprawdzenie, że trasa dostarcza `onProjectExited`.

Świadomie zostawione do T4/T5: Lista nadal ma własny pływający pasek akcji
masowych oparty na `ProjectTasksListCubit`, a Kanban korzysta z paska nagłówka
opartego na `TasksBoardCubit`. Selekcja obu widoków nie jest jeszcze wspólna,
więc widoczny jest zawsze dokładnie jeden pasek, ale katalog akcji i wspólne
źródło zaznaczenia domyka T4 („usunąć pływający drugi bulk bar”) i T5
(„połączyć bulk z shared contextual bar”). Wiersz poleceń czeka też na filtry,
sortowanie, grupowanie i kolumny Listy, które przenosi T4.

### 2026-09-19 — UX-T4: domknięcie Listy

Wiersz poleceń Listy przeniósł się do wspólnego nagłówka, a Lista nie renderuje
już własnego paska filtrów ani pływającego paska akcji masowych nad treścią.

Nowe elementy (wszystkie w `tasks/list/**`):

- `chrome/task_list_chrome_host.dart` — właściciel stanu Listy. Tworzy
  `ProjectTasksListCubit` i `TaskListPreferencesCubit` **ponad** nagłówkiem,
  dzięki czemu drugi wiersz chrome i tabela opisują ten sam stan; oddaje
  nagłówkowi gotowy `commandBar` i `bulkBar` oraz informację o zaznaczeniu;
- `chrome/task_list_command_bar.dart` — filtry (status, priorytet, osoba,
  udział, przypięte), sortowanie, kierunek, grupowanie, kolumny i
  „Wyczyść wszystko”. Wszystkie menu używają wspólnego `AppContextMenu`, więc
  w Listnie nie ma już surowych `PopupMenuButton` od filtrów;
- `chrome/task_saved_view_selection.dart` — jedno miejsce wyprowadzające aktywny
  zapisany widok (id, grupowanie, kolumny, pola własne), używane przez nagłówek
  i treść Listy;
- `bulk/task_list_bulk_bar.dart` — przepisany na tokeny i wspólne menu:
  przewijany poziomo, wysokość kontrolki 28 px w wierszu 38 px, zachowane akcje
  (status, priorytet, termin dziś, wykonawca, archiwizacja, „Cały wynik” przez
  selection token oraz czyszczenie zaznaczenia). Siedem surowych
  `PopupMenuButton` zniknęło.

Usunięte: `filters/task_list_filters.dart` (jego kontrolki zastąpił command bar;
`TaskListFailureView` przeniesiony do `table/task_list_failure_view.dart`) oraz
pływający `TaskListBulkBar` z `task_list_table_view.part.dart`.

Nagłówek dostał sloty `commandBar`, `bulkBar` i `showBulkBar`, a
`ProjectTasksList` przyjmuje cubity od właściciela chrome (samodzielne użycie
nadal tworzy własne i je zamyka).

Dowody: pełny `flutter test` **940/940 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty. Nowe testy
`test/workspaces/presentation/tasks/list/chrome/task_list_chrome_test.dart`
(wiersz poleceń z filtrami/sort/grupowaniem/kolumnami, filtr statusu przez
wspólne menu z przeładowaniem zapytania, „Wyczyść wszystko”, zapis sortowania w
preferencjach, brak overflow przy 640 px, przełączenie na pasek akcji masowych i
zmiana statusu zaznaczonych). W teście trasy doszły asercje kompozycji: kontrolki
Listy są w drugim wierszu `TasksHeader`, a `TaskListBulkBar` nie istnieje poza
nagłówkiem.

Pozostawione świadomie: dwa `PopupMenuButton` w `views/widgets/task_saved_views_menu.dart`
(menu zapisanych widoków, poza katalogiem `tasks/list/**`) i jeden w edytorze pól
niestandardowych szczegółu — do domknięcia w T6.

### 2026-09-19 — macOS: stabilny podpis Keychain dla Debug/Profile

Cel: zatrzymać prompt macOS przy każdym hot resecie, gdy desktopowy PKCE czyta
i rotuje refresh token w Keychain.

Zmiana:

- `macos/Runner.xcodeproj/project.pbxproj`: Debug i Profile używają ręcznie
  wskazanego certyfikatu `Apple Development: Przemyslaw Nowak (9CZ5DH8V7A)`;
  usunięto odziedziczone wymuszenie `CODE_SIGN_IDENTITY = "-"` dla konfiguracji
  projektu. Release zachowuje poprzedni podpis ad-hoc, więc produkcyjny proces
  dystrybucji nie został domyślnie przekierowany na lokalny certyfikat.
- Nie podpinano `DebugProfile.entitlements`: wymagałoby to provisioning profile
  dla `com.excellent.devplanner`, którego lokalny account nie posiada. Aplikacja
  nadal używa zwykłego, szyfrowanego Keychain zgodnie z adapterem
  `platform_secure_secret_store_io.dart`.

Weryfikacja:

- `flutter build macos --debug`: PASS;
- `codesign --verify --deep --strict --verbose=2 .../DevPlanner.app`: PASS;
- requirement podpisu: identifier `com.excellent.devplanner`, Apple anchor i
  stały certyfikat Apple Development; nie jest to już Signature=adhoc;
- `flutter test test/auth/auth_platform_adapters_test.dart --reporter compact`:
  **8/8 PASS**;
- pierwsze uruchomienie nowego artefaktu przywróciło sesję i wyświetliło
  workspace bez promptu Keychain;
- `flutter analyze`: NOT PASS wyłącznie przez istniejące, niezwiązane błędy w
  brudnym `test/workspaces/presentation/tasks/board/tasks_board_bulk_bar_test.dart`.

Następny krok: użytkownik wykonuje `R`/hot restart w aktywnej sesji; prompt
Keychain nie powinien wracać. Jeśli pozostał pojedynczy prompt po migracji
podpisu, zatwierdzić go dla podpisanej aplikacji, a nie usuwać całego Keychain.

### 2026-09-19 — UX-T5: domknięcie Kanbanu

Pasek akcji masowych Kanbanu używa teraz tego samego komponentu co Lista:
`lib/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart`
(`TasksContextualBulkBar` + `TasksBulkButton` + `TasksBulkMenu`). Powstał w
neutralnym katalogu modułu, więc obie strony mają identyczny wygląd, przewijanie
poziome, licznik z ARB (`tasksBulkSelected`) i obsługę przez wspólne menu.
Zestaw akcji pozostaje zależny od widoku i ACL, zgodnie z §4 planu: Kanban
przenosi zaznaczone karty między kolumnami (`board_bulk_move`), zmienia priorytet
(`board_bulk_priority`) i termin (`board_bulk_due_date`); Lista ma dodatkowo
status, wykonawcę, archiwizację i „Cały wynik” przez selection token.

Pasek Listy przepisany na ten sam komponent (usunięte lokalne kopie kontrolek),
a `_BulkSelectionToolbar` w nagłówku zastąpiony wspólnym paskiem z akcjami
boardu. Przy okazji nazwy pomocników nagłówka przestały być kanbanocentryczne
(`_TasksHeaderHelpers`).

Potwierdzone zachowania Kanbanu (testy istniejące, wskazane jako dowód):

- paginacja kolumny i doładowanie strony: `tasks_board_cubit_test.dart`
  („ładuje snapshot, presence i kolejną stronę jednej kolumny”);
- zwijanie kolumn z wersją preferencji oraz zachowanie zwiniętych kolumn przy
  zmianie szybkiego filtra: dwa testy w tym samym pliku;
- DnD z optimistic move, korektą indeksu w tej samej kolumnie i blokadą
  niedozwoloną przez workflow: trzy testy;
- rollback 409 z komunikatem przyczyny: „przy błędzie przywraca tablicę sprzed
  optimistic move” (używa `ApiErrorType.conflict` i sprawdza `mutationError`);
- realtime: testy wypychające zdarzenia przez `TaskProjectRealtime`
  (`resync po status realtime zachowuje jego rewizję dla widoku listy`).

Nowy test `test/workspaces/presentation/tasks/board/tasks_board_bulk_bar_test.dart`
montuje realny `TasksBoardCubit` i dowodzi, że po zaznaczeniu kart drugi wiersz
nagłówka renderuje `TasksContextualBulkBar` z licznikiem „Wybrano: 2”, a wybór
kolumny wywołuje `bulkMove` na repozytorium boardu z identyfikatorami
zaznaczonych kart.

Dowody: pełny `flutter test` **941/941 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty.

### 2026-09-19 — AUTH-AUDIT: przekazanie planu sesji desktopowej

Zakres był read-only poza dokumentacją. Przejrzano aktywną kompozycję auth
Fluttera, Desktop Authorization Code + PKCE, vault macOS, wspólny transport
HTTP, provider SignalR, backendowy OpenIddict, lifecycle rodzin refresh tokenów,
revocation i rzeczywisty podpis artefaktu macOS.

Najważniejsze ustalenia:

- Keychain jest właściwym magazynem refresh tokena; wcześniejszy prompt storm
  wynikał z niestabilnej tożsamości podpisu, a aktualny podpis lokalny działa;
- runtime nie odświeża access tokena po wygaśnięciu/401;
- fallback `DevPlannerHttpTransport` może w przyszłej błędnej kompozycji użyć
  refresh tokena jako Bearera;
- nowy refresh token jest zapisywany dopiero po `/me`, więc przejściowy błąd
  profilu po udanej rotacji może pozostawić w vault zużyty token;
- REST i SignalR nie mają jednego koordynatora single-flight;
- klient wysyła OIDC `nonce`, ale nie waliduje ID tokena;
- backendowy refresh/reuse/revoke jest mocnym fundamentem, lecz natychmiastowy
  revoke już wydanego access tokena i aktywnego SignalR wymaga osobnego dowodu;
- osobisty certyfikat Debug/Profile w `project.pbxproj` nie jest przenośny, a
  Release nadal nie ma gotowego procesu podpisu/notarization.

Gotowy plan:
`Front/docs/recovery/desktop-auth-session-hardening-plan.md`. Pakiety A0–F1 są
sekwencyjne i zawierają ownership, zakazy, czerwone testy, kontrakty rotacji,
single-flight, REST retry, SignalR, backend revoke, decyzję OAuth zamiast
połowicznego OIDC, callback hardening, podpis macOS oraz pełną macierz live.
Nie zmieniano kodu runtime, migracji ani testów i nie uruchamiano bramek jako
dowodu implementacji. Następny dozwolony krok: A0.

### 2026-09-19 — AUTH-A1: wynik pakietu trwałej rotacji

Zmieniono wyłącznie Frontowy adapter Desktop PKCE i jego test doubles.
`DesktopTokenResult` oddziela odpowiedź token endpoint od profilu, zawiera
access token, refresh token i walidowany dodatni `expiresIn`. Adapter zapisuje
refresh token przed `fetchCurrentUser`; błąd profilu zachowuje nowy credential
na kolejny restore. Błąd vaulta nie publikuje sesji i wykonuje best-effort
revocation nowego tokena bez logowania jego wartości.

Dodane testy potwierdzają kolejność write → `/me`, przeżycie błędu `/me` oraz
revocation po błędzie Keychain. Dowody: `flutter test test/auth --reporter
compact` **29/29 PASS**, scoped analyzer **No issues found**, scoped `git diff
--check` PASS. Pełny analyzer i native E2E: NOT RUN. Następny pakiet: A2.

### 2026-09-19 — UX-T6: discoverability, martwe pozycje i domknięcie menu

Drzewo nawigacji renderuje wyłącznie pozycje z aktywną trasą. Zniknęły
Automatyzacje, Whiteboardy, Tablica korkowa i Wiki, a projekt pokazuje Zadania
(Lista, Kanban) oraz Pliki. Kontrakt `WorkspaceNavigationTree.projectResourceKinds`
opisuje teraz realnie renderowane zasoby, a rodzaje modułów zostają w enumie i
wrócą razem z własnymi trasami — pozycja bez trasy nie udaje działającej funkcji.

Ostatnie surowe menu w Tasks zniknęły (w module nie ma już ani jednego
`PopupMenuButton`):

- menu zapisanych widoków korzysta ze wspólnego `AppContextMenu.select`, a
  zarządzanie widokiem (konfiguracja, zmiana nazwy, usunięcie) to drugi krok
  tego samego menu; wiersze widoków zachowały znacznik „dirty” przez `trailing`,
  a wyłączony `OutlinedButton` w triggerze zastąpił kontener o tym samym
  wyglądzie, żeby klik docierał do aktywatora;
- wielokrotny wybór wartości pola niestandardowego w szczegółach zadania używa
  wspólnego menu z zaznaczeniem pozycji.

Zmiana poza pakietami planu, ale wprost zgłoszona w audycie: na wąskim oknie
(<960 px) pasek boczny zwijał się do ikon, a przez to drzewo stawało się
nieosiągalne. Teraz ten sam klawisz otwiera je w nakładce nad treścią (z
przygaszonym tłem i zamykaniem przez klik poza), a po zamknięciu wraca pasek
ikoniczny. Nowy test w `test/app/shell/devplanner_shell_test.dart` sprawdza
otwarcie i zamknięcie nakładki.

Discoverability: nie dodawano żadnego endpointu ani nie zmieniano kontraktu
Backendu; akcje pozostają ukrywane na podstawie capabilities projektu
(`canManage` dla ustawień i WIP), a Backend nadal autoryzuje każdą operację.

Dowody: pełny `flutter test` **945/945 PASS**, `flutter analyze`
**No issues found**, `git diff --check` czysty.

### 2026-09-19 — UX-T7 (częściowo): bramki buildów i żywy Backend, scenariusz GUI NOT RUN

Ten pakiet jest odbiorem rootu i obejmuje uruchomienie całego stosu. W tej sesji
wykonano część bramek i udokumentowano resztę jako NOT RUN, bez przedstawiania
części jako pełnego odbioru.

Wykonane i potwierdzone dowodami:

- `flutter build web --wasm` — **PASS** (`✓ Built build/web`).
- `flutter build macos --debug` — **PASS**
  (`✓ Built build/macos/Build/Products/Debug/DevPlanner.app`). Pierwsza próba
  padła w trakcie równoległej edycji drzewa przez inną sesję agenta
  (`Target kernel_snapshot_program failed`), powtórzenie przeszło.
- `flutter analyze` — **No issues found**; pełny `flutter test` — **945/945 PASS**;
  `git diff --check` czysty w obu repozytoriach.
- Stos lokalny działa: kontenery `backend-postgres-1` (przyjmuje połączenia),
  `backend-redis-1`, `backend-minio-1`, `backend-mailpit-1`,
  `backend-clamav-1`, `backend-onlyoffice-1`; API wstało przez
  `Backend/start-local.sh` na `http://localhost:5072` w trybie Development.
- Kontrakt na żywo: `GET /swagger/v1/swagger.json` zwraca **350** ścieżek, w tym
  wszystkie używane przez frontend Tasks/Kanban (`/tasks/groups`, `/kanban`,
  `/kanban/bulk-move`, `/kanban/bulk-update`, `/tasks/selection-token/bulk`,
  `/me/tasks`).
- Autoryzacja na żywo: `tasks/groups`, `kanban` i `me/tasks` zwracają **401**
  bez tokenu, a `POST /api/v1/realtime/{tasks,chat,notifications}/negotiate`
  również **401** — huby SignalR istnieją i wymagają sesji, zgodnie z route'ami
  z `Endpoints/Tasks/ProjectTaskEndpoints.cs`.

NOT RUN z powodem (nie zaliczam tego jako odbioru):

- scenariusz live GUI (create → inline edit → details → List ↔ Kanban → DnD →
  bulk → saved view → restart) — wymaga zalogowanej sesji BFF/PKCE; logowanie
  idzie przez aktywację e-mailem (Mailpit), więc nie zostało wykonane skryptem
  w tej sesji;
- dwa konta i revoke dostępu, weryfikacja SignalR w locie oraz pomiary
  PostgreSQL po mutacjach;
- screenshoty 1024×768 / 1440×900 / 1920×1080 w jasnym i ciemnym motywie;
- `flutter build windows` i `flutter build linux` — brak hosta (NOT RUN, nie
  sukces).

Uruchomiony przeze mnie proces API działa w tle (`start-local.sh` z `nohup`);
zatrzymanie: `pkill -f veloryn-workspaces`.

### 2026-09-19 — UX-T7 zamknięcie sesji: buildy i kontrakt live PASS, GUI odroczone decyzją właściciela

Właściciel zdecydował, że w tej sesji nie wykonujemy fizycznych testów GUI.
Zgodnie z tym decyzją pakiet T7 **nie jest odebrany** i nie jest tak
przedstawiany; poniżej stan zamknięcia sesji.

Wykonane i potwierdzone:

- `flutter build web --wasm` — PASS; `flutter build macos --debug` — PASS;
- `flutter analyze` — No issues found; pełny `flutter test` — **952/952 PASS**;
  `git diff --check` czysty w obu repozytoriach; plan i handoff identyczne (`cmp`);
- żywy stos backendu: PostgreSQL (5440), Redis, MinIO, Mailpit, ClamAV,
  OnlyOffice; API wystawia 350 ścieżek OpenAPI, a `tasks/groups`, `kanban`,
  `me/tasks` i negocjacje hubów SignalR zwracają 401 bez tokenu;
- domknięta ostatnia luka w automatycznym pokryciu kroku „inline edit”:
  `project_tasks_list_cubit_test.dart` ma teraz test rollbacku dla błędu
  nie-konfliktowego (wiersz wraca do poprzedniej wartości, komunikat błędu
  zostaje przypięty do tego samego wiersza), obok istniejącego testu 409.

Odroczone decyzją właściciela: scenariusz GUI, dwa konta z revoke, screenshoty
1024×768 / 1440×900 / 1920×1080 w light/dark. NOT RUN z braku hosta:
`flutter build windows`, `flutter build linux`.

Runbook dokończenia odbioru zapisano w
`docs/recovery/tasks-list-kanban-ux-recovery-plan.md` (sekcja T7): uruchomienie
stosu, trzy dopuszczalne ścieżki uzyskania loginu (hasło właściciela, reset
przez lokalny Mailpit z SMTP włączonym tylko w środowisku procesu, albo nowy
bootstrap administratora przez `start-desktop-auth-local.sh
--bootstrap-local-admin`), uruchomienie frontu na macOS lub Web oraz lista
kroków scenariusza i pomiarów.

Stan środowiska po sesji: lokalne API zatrzymane, kontenery Docker działają;
brak commitów — wszystkie zmiany pozostają w drzewie roboczym, moje wyłącznie
poza `lib/auth/**`, które należy do równoległej sesji agenta (desktop PKCE).

### 2026-09-19 — UX-T7: zrzuty widoków z realnej kompozycji (substytut bez GUI)

Skoro odbiór GUI jest odroczony decyzją właściciela, przygotowałem materiał do
przeglądu bez uruchamiania aplikacji: test
`test/workspaces/presentation/tasks/board/tasks_visual_capture_test.dart`
renderuje ten sam widget trasy Tasks z hermetycznym fixture'em, w motywie
produktu (`MaterialTheme.crm()`), z załadowanym Inter i ikonami, i zapisuje
12 obrazów do `docs/recovery/visual-captures/`:

- `lista_{1024x768,1440x900,1920x1080}_{light,dark}.png`,
- `kanban_{1024x768,1440x900,1920x1080}_{light,dark}.png`.

Zrzuty są czytelne (prawdziwe fonty i ikony) i pokazują to, co plan wymagał
obejrzeć: dwa wiersze wspólnego chrome (kontekst 44–48 px i polecenia 36–40 px),
ten sam nagłówek i command bar w Liście i Kanbanie, kolejkę poleceń w wierszu
drugim, kartę i nagłówek kolumny Kanbanu oraz tokenowe powierzchnie w trybie
jasnym i ciemnym. Test przy okazji pilnuje braku przepełnień na tych
rozdzielczościach (`takeException()` dla każdej kombinacji).

To nadal **nie jest odbiór GUI/E2E**: obrazy pochodzą z renderu widgetów
z fixture'em, a nie z aplikacji połączonej z żywym Backendem, więc nie zastępują
scenariusza z sekcji T7 planu.

### 2026-09-19 — AUTH-E1: podpis Debug/Profile

Dodano wersjonowaną politykę `macos/Runner/Configs/Signing.xcconfig`, przykład
lokalnego override i ignorowanie właściwego `Signing.local.xcconfig`. Build
Debug korzysta z lokalnej Apple Development identity bez wpisywania jej common
name ani Team ID do projektu. Dwa następujące buildy mają identyczny designated
requirement; `codesign --verify --deep --strict` przeszedł.

E2 pozostaje NOT RUN: lokalny Keychain nie ma macOS provisioning profile dla
`com.excellent.devplanner`, a zatem nie wykonano sandboxowego Release,
notarization ani Gatekeeper testu na czystym koncie.

### 2026-09-19 — AUTH-A2–D1, B1–B2, C1: backendowy revoke i token lifecycle

Desktopowy adapter ma wspólny single-flight access-token lifecycle, trwały zapis
rotacji przed `/me`, bezpieczną klasyfikację `invalid_grant` oraz jeden retry
401 dla REST. SignalR korzysta z tego samego providera. Backend wydaje
10-minutowy access token i sprawdza `sub` oraz `devplanner_session_id` wobec
aktywnej sesji, stanu konta i SecurityVersion przy każdym desktopowym bearerze.

Revoke po commit publikuje `sessionId` do Redis i abortuje wyłącznie właściwe
połączenia wszystkich hubów. Dowody: Front auth/HTTP/realtime test suite PASS,
Backend identity/realtime targeted suite PASS oraz dwuhostowy registry test z
dwoma `ConnectionMultiplexer` i lokalnym Redis `localhost:6379` PASS (3/3).
E2 i F1 nadal wymagają provisioning/notarization oraz ręcznego realnego E2E.

### 2026-09-19 — AUTH-A4: logout mimo błędu revoke

`AuthUseCases` ustawia `signedOut` w `finally`. Gdy revoke offline rzuca błąd,
adapter nadal usuwa refresh credential, a runtime otrzymuje zdarzenie kończące
realtime. Test `auth_foundation_test.dart` pokrywa ten wariant (PASS).

### 2026-09-19 — Audyt parytetu Listy/Kanbanu: ustalenia i plan N0–N7

Po domknięciu T7 przeszedłem kod obu repozytoriów pod kątem parytetu widoków
i zgłoszonych defektów UI. Ustalenia z dowodami:

- Filtry nie są równe: Lista ma status, priorytet, osobę, udział, przypięte,
  sortowanie, kierunek, grupowanie i kolumny; Kanban tylko szybki filtr.
  Mechanizm filtrowania na boardzie istnieje (`ApplyQuickFilter` w
  `KanbanBoardReader`, filtry wykonawcy/priorytetu/kamienia milowego w endpointcie
  kolumny, wykonywane w PostgreSQL), ale klient przekazuje do kolumny **tylko
  kursor** (`tasks_board_preference_commands.dart:149,155`), a board cubit nie zna
  `savedViewId`, więc filtr zapisanego widoku nie działa na Kanbanie.
- `GET /kanban` nie przyjmuje żadnych filtrów, więc bez rozszerzenia kontraktu
  liczniki kolumn i WIP nie mogą być spójne z filtrowanymi kartami.
- `KanbanSettingsCubit` (ukryte kolumny, WIP, gęstość, pola karty) **nie ma
  konsumenta** — cała powierzchnia ustawień boardu jest nieosiągalna w UI,
  mimo że Backend ją obsługuje.
- `swimlaneMode` jest tylko przechowywany i odsyłany; nie ma renderowania torów
  ani w Backendzie, ani w kliencie, więc wystawienie grupowania teraz byłoby
  martwą kontrolką.
- Modal ustawień: `_NavigationButton` (`project_settings_modal_frame.dart:339`)
  używa `TextButton.icon` bez `alignment`, więc pozycje są wyśrodkowane; plik
  pracuje na `core/theme`/`core/l10n` i twardych stringach poza ARB (37 plików
  w `projects/settings/**`).
- Menu zapisanego widoku (`task_saved_views_menu.dart:224`) ma zdublowaną
  pozycję „Zarządzaj" pod każdym widokiem i otwiera drugie menu zakotwiczone
  w triggerze — regresja z migracji menu w T6.

Plan naprawy z pakietami N0–N7, deltami Backendu i bramkami:
`docs/recovery/tasks-parity-and-ui-repair-plan.md` (kopia w Backendzie, `cmp`
identyczny). Rekomendowana kolejność: N0 (dwa defekty UI) i N1 (parytet filtrów
po stronie klienta) równolegle, N2 (opcjonalne filtry `GET /kanban`) po stronie
Backendu, potem N3 (ustawienia boardu w UI) i N4 (jedno wejście do zapisanych
widoków plus akcje masowe Kanbanu). N5 (modal ustawień na tokenach i w ARB)
wymaga uzgodnienia z sesją, która edytuje `projects/settings/**`. N6 to decyzja
o swimlane, N7 domyka odbiór.

W tym przeglądzie nie zmieniałem kodu runtime ani nie dotykałem plików
`lib/auth/**` należących do równoległej sesji.

### 2026-09-19 — UX-N0: nawigacja modala ustawień i wiersz akcji zapisanego widoku

Zamknięty pakiet N0 z planu parytetu (dwa defekty wskazane przez właściciela).

Pliki i decyzje:

- `lib/workspaces/presentation/projects/settings/widgets/project_settings_modal_frame.dart`
  — `_NavigationButton` ma jedną implementację dla obu wariantów i wyrównuje
  treść do lewej: `alignment: AlignmentDirectional.centerStart`, stała wysokość
  `Sizes.p36`, wcięcie 8 px wiersza i 12 px treści, `tapTargetSize.shrinkWrap`,
  tło `surfaceRoles.tintedBackground` + obramowanie `tintedBorder` dla pozycji
  zaznaczonej, `overlayColor` z `WidgetStateProperty` (`pressedOverlay`
  /`hoverOverlay`) i waga `w700`/`w600`. Nagłówki sekcji dostały to samo
  wcięcie 16 px co ikony pozycji. Wariant kompaktowy (okno < 768 px) to teraz
  zwarty chip 36 px wyśrodkowany w 44 px pasku, przewijany poziomo.
- `lib/workspaces/presentation/tasks/views/widgets/task_saved_views_menu.dart`
  — każdy wiersz widoku ma jedno „…" (`_SavedViewRowActions`), które liczy
  kotwicę w kontekście klikniętego wiersza, zamyka menu listy (`Navigator.pop`)
  i dopiero wtedy otwiera menu akcji widoku; nagłówkiem drugiego menu jest nazwa
  widoku, więc „Zapisane widoki" występuje raz. Usunięty wariant
  `TaskSavedViewMenuActionManage` i tekstowa pozycja „Zarządzaj" spod każdego
  widoku. Akcje widoku (zmiana nazwy, konfiguracja, usunięcie) dostały żywy
  kontekst strony zamiast kontekstu wiersza menu, dzięki czemu dialogi nie
  otwierają się z już zdjętego elementu.

Testy (nowe, wszystkie przechodzą):

- `test/workspaces/presentation/projects/settings/project_settings_modal_navigation_test.dart`
  — 5 przypadków: wspólna linia tekstu wszystkich pozycji i brak wyśrodkowania,
  stała wysokość wiersza, tło i obramowanie dokładnie jednej aktywnej pozycji,
  przeniesienie zaznaczenia po kliknięciu, kompaktowy pasek bez błędów układu.
- `test/workspaces/presentation/tasks/views/widgets/task_saved_views_menu_test.dart`
  — nowy przypadek: jedno „…" na widok, brak tekstowego duplikatu, zamknięcie
  listy pod spodem, kotwica w klikniętym wierszu (x i y), brak zmiany aktywnego
  widoku po kliknięciu „…"; mock repozytorium przyjmuje teraz listę widoków.
- Kontrola mutacyjna: na wersji `HEAD` modala wszystkie 5 testów pada; po
  cofnięciu kotwicy w menu akcji test kotwicy pada z `Expected: > 152.0,
  Actual: <52.0>`. Testy pilnują więc poprawki, a nie bieżącego stanu.

Bramki:

- `flutter analyze` — No issues found (całe repo).
- `flutter test` — 992/992 PASS.
- `flutter build web --wasm` — PASS (pierwsze uruchomienie padło z exit -15,
  bo proces budowania został uśmiercony przez zamknięcie powłoki narzędzia;
  powtórzone bez `&` kończy się `✓ Built build/web`).
- `git diff --check` — czysty.
- Nie uruchamiałem buildów Windows/Linux (brak hosta) i nie zmieniałem ARB.

Znalezisko przy okazji (defekt zastany, nie regresja N0): przy oknie 700 px
zakładka Szablony przelewa się o 53 px — `project_template_card.dart:88`
w `Row` z linii 62, bo próg `isNarrow < 580` (linia 45) nie łapie przypadku,
w którym same akcje karty są szersze niż próg. Powtarza się na `HEAD` po
cofnięciu zmian N0. Dopisane do planu jako §2.8 i do N5.

Następny krok: N1 (parytet filtrów Kanbanu po stronie klienta: przekazać
`priority`/`assigneeUserId`/`milestoneId` do `KanbanColumnQuery` i wystawić je
w wierszu poleceń) równolegle z N2 (Backend: opcjonalne filtry `GET /kanban`).
N5 tylko po uzgodnieniu z właścicielem `projects/settings/**`, bo N0 zmienił
tam jeden plik.

### 2026-09-19 — BE-N2: opcjonalne filtry boardu Kanban (Backend)

Zamknięta pierwsza część N2: filtry wykonawcy, priorytetu i kamienia milowego na
`GET /kanban`, tak aby liczniki kolumn, karty i kursor stron opisywały dokładnie
to samo. `savedViewId` świadomie odłożony do N2b (wymiary zapisanego widoku,
których board nie modeluje: etykiety, zaangażowanie, szukanie, daty, przypięte).

Zmiany:

- `Contracts/Kanban/KanbanContracts.cs` — `KanbanBoardQuery` z
  `AssigneeUserId`/`Priority`/`MilestoneId`, właściwością `IsFiltered` oraz
  `ToColumnQuery()`, która przenosi filtry tablicy na kursor kolumny.
- `Endpoints/Kanban/KanbanEndpoints.cs` — `GET /kanban` przyjmuje
  `[AsParameters] KanbanBoardQuery`; opis endpointu mówi o wspólnym zestawie
  filtrów dla liczników, kart i kursora.
- `Application/Kanban/KanbanBoardReader.cs` — nowa predykata `ApplyBoardFilter`
  dołożona do zapytania liczników, pierwszych stron kolumn i własnych kolumn
  (razem z ich licznikiem); kursory (`EncodeCursor`, `EncodeCustomCursor`)
  powstają z `query.ToColumnQuery()`, dzięki czemu kolejne strony dziedziczą
  filtry, a kursor użyty bez filtrów zwraca `400 validation.failed`;
  `ValidateBoardQuery` odrzuca pusty UUID i niezdefiniowany priorytet.
- `Application/Kanban/{IKanbanBoardReader,KanbanService}.cs` — sygnatury
  przenoszą filtr; kontrakt HTTP rozszerzony addytywnie, bez zmiany kształtu
  odpowiedzi.

Testy i bramki:

- `Tests/Veloryn.Workspaces.Tests/KanbanServiceTests.cs` +4 przypadki
  (spójność licznika i kart dla trzech filtrów; dziedziczenie filtrów przez
  kursor i odrzucenie kursora bez filtrów; własna kolumna z filtrem; walidacja),
- `Tests/Veloryn.Workspaces.Tests/KanbanEndpointTests.cs` +1 przypadek HTTP
  (liczniki, karty i strona kolumny po filtrze; `400 validation.failed` dla
  pustego UUID, `400 request.invalid` dla nieczytelnego priorytetu),
- `dotnet build` aplikacji, testów i harnessu bez błędów,
- `dotnet test --filter FullyQualifiedName~Kanban` — 56/56 PASS (jednostkowe,
  HTTP na realnym PostgreSQL, kontrakt OpenAPI, integracyjne),
- `git diff --check` czysty w obu repozytoriach.

Live HTTP na stosie lokalnym: **NIE URUCHOMIONE**. Stary proces API (pid 30141,
sprzątanie po T7) działał na poprzednim buildzie i został zatrzymany; nowy build
wymaga ponownego startu i logowania BFF (cookie + CSRF). Zachowanie HTTP jest
pokryte testem przechodzącym przez pełny pipeline ASP.NET z realnym PostgreSQL,
a odbiór live pozostaje w N7.

Następny krok: N1 (klient wystawia trzy filtry w wierszu poleceń Kanbanu i
przekazuje je do `GET /kanban` oraz do `KanbanColumnQuery` przy doładowaniu
kolumn), potem N2b (`savedViewId` na boardzie) i N3/N4.

### 2026-09-19 — UX-N1 (część): filtry tablicy Kanbanu i rozdział wierszy poleceń

Wykonana część N1: filtry wykonawcy i priorytetu na tablicy, „Wyczyść wszystko”,
plumbing filtra aż do Backendu oraz naprawa wiersza poleceń, który pokazywał
kontrolki Listy na Kanbanie.

Pliki i decyzje:

- `lib/workspaces/domain/repositories/kanban_repository.dart` — nowy
  `KanbanBoardFilter` (`isActive`, `activeCount`, `toColumnQuery`, `copyWith`
  z jawnym czyszczeniem wymiaru, equality z `@immutable`);
  `KanbanRepository.getBoard` przyjmuje filtr.
- `lib/workspaces/data/kanban/api/kanban_api.dart` + `kanban_repository_impl.dart`
  — trzy opcjonalne parametry zapytania; klient retrofita wygenerowany ponownie
  (`dart run build_runner build --delete-conflicting-outputs`).
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart` —
  `TasksBoardReady.filter` i `loadingFilter`.
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_runtime_coordinator.dart`
  — filtr żyje w koordynatorze lifecycle: `load()` wysyła go do `getBoard`,
  `setFilter()` publikuje `loadingFilter` i odświeża tablicę. Filtr przeżywa
  nieudany odczyt, więc ponowienie nie wraca po cichu do pełnego projektu.
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_filter_commands.dart`
  (nowy) + fasada `tasks_board_cubit.dart` — `setFilterAssignee`,
  `setFilterPriority`, `setFilterMilestone`, `clearFilters`.
- `lib/workspaces/presentation/tasks/board/cubit/tasks_board_preference_commands.dart`
  — `loadMore` dokłada filtr tablicy do `KanbanColumnQuery`, więc kolejna strona
  opisuje ten sam zestaw kart co licznik kolumny.
- `lib/workspaces/presentation/tasks/header/tasks_header_board_filters.dart`
  (nowy, część biblioteki widoku Tasks) — klawisze `board_filter_priority`,
  `board_filter_assignee`, `board_filter_clear` oparte na wspólnym komponencie.
- `lib/workspaces/presentation/tasks/chrome/tasks_command_menu.dart` (nowy) —
  `TasksCommandMenu` i `TasksCommandButton` wyjęte z paska Listy, żeby Lista
  i Kanban miały jeden klawisz poleceń (refaktor bez zmiany zachowania:
  `task_list_chrome_test.dart` przechodzi bez zmian).
- `lib/workspaces/presentation/tasks/header/tasks_header_layout.dart` — wiersz
  poleceń Listy montowany tylko poza widokiem tablicy.

Defekt wykryty przy tej okazji: na Kanbanie wisiał wiersz poleceń Listy
(Status/Priorytet/Osoba/Mój udział/Przypięte/Sortowanie/Grupowanie/Kolumny),
a jego kontrolki opisują kursorowy snapshot Listy, więc na tablicy nic nie
robiły. Dowodem jest zrzut z T7 (`docs/recovery/visual-captures/
kanban_1440x900_light.png`) sprzed zmiany; po zmianie tablica pokazuje szybki
filtr, Priorytet, Osobę i widok domyślny, a Lista zachowuje swoje kontrolki
(porównaj `lista_1440x900_light.png`). Timeline, Obciążenie i Cykliczne nadal
dziedziczą pasek Listy — do rozstrzygnięcia w N3/N4.

Otwarte po tej części N1:

- filtr kamienia milowego: `MilestoneRepository` jest w zasięgu trasy tablicy,
  ale lista kamieni nie ma kubita poza feature’em szczegółów zadania, więc
  kontrolka wymaga małego, osobnego pakietu (N1b) — nie wystawiamy jej wcześniej,
  żeby nie dodać martwego klawisza;
- chip aktywnego filtra dla nowych wymiarów (`_ActiveFilterStrip` obsługuje
  dzisiaj tylko szybki filtr);
- powiązanie filtra zapisanego widoku z boardem czeka na N2b (`savedViewId`).

Testy i bramki:

- `test/workspaces/presentation/tasks/tasks_board_cubit_test.dart` +3 przypadki
  (filtr w `getBoard` i w zapytaniu kolumny oraz „Wyczyść wszystko”; brak
  zbędnego odczytu przy powtórzonym filtrze; filtr przeżywa nieudany odczyt),
- `test/workspaces/presentation/tasks/board/tasks_board_filters_test.dart` (nowy,
  2 przypadki): klik Priorytet → odczyt tablicy z filtrem i pojawienie się
  „Wyczyść wszystko”, klik „Wyczyść wszystko” → odczyt bez filtra; drugi
  przypadek pilnuje, że pasek Listy nie jest montowany na tablicy,
- `test/test_support/tasks_board_route_fixture.dart` — `registerFallbackValue(
  KanbanBoardFilter.none)` i stub `getBoard` z parametrem `filter`, bo moduł
  zawsze wysyła filtr,
- `test/workspaces/presentation/tasks/board/goldens/header_desktop_1280.png`
  zaktualizowany świadomie (`--update-goldens`): wiersz poleceń tablicy zmienił
  się zgodnie z planem,
- ARB: `tasksBoardFilterAssignee` („Osoba”/„Person”) i
  `tasksBoardFilterAllPeople` („Wszystkie osoby”/„All people”) w pl i en,
  `flutter gen-l10n` uruchomione,
- bramki: `flutter analyze` — No issues found, `flutter test` — 997/997 PASS,
  `flutter build web --wasm` — PASS po zmianach N1 (`✓ Built build/web`),
  `git diff --check` czysty.

Następny krok: N1b (kontrolka kamienia milowego po dodaniu źródła danych
w hoście tablicy) oraz chipy aktywnego filtra, potem N2b (`savedViewId` na
boardzie) i N3 (ustawienia boardu w UI).

### 2026-09-19 — N8: bezpieczny zapis ustawień widoku i wspólna powierzchnia błędów

Zakres: sześć powiązanych defektów zgłoszonych przez właściciela — niebezpieczne
ponowienie zapisu preferencji Kanbana, maskowane błędy Listy, nietrwały SnackBar
Kanbana, ignorowany odczyt preferencji, przeładowanie Listy po błędzie ustawień
tablicy oraz zbyt ogólny kod konfliktu w Backendzie.

Pliki (Front): nowe `tasks/errors/tasks_view_error.dart`,
`tasks/errors/tasks_error_banner.dart`, `tasks/chrome/tasks_error_banner_host.dart`,
`tasks/list/preferences/cubit/task_list_preference_merge.dart`; zmienione
`board/cubit/tasks_board_preference_commands.dart` (kolejka intencji + rebase),
`board/cubit/tasks_board_state.dart` (`taskDataRevision`, `TasksViewError? error`),
`board/cubit/tasks_board_cubit.dart` (`retryFailedOperation`, `clearViewError`),
`board/cubit/tasks_board_runtime_coordinator.dart` (błąd odczytu preferencji,
`reloadUserPreference`), `board/tasks_project_view.dart` (SnackBar usunięty),
`board/tasks_board_page.dart` (banner pod nagłówkiem),
`list/chrome/task_list_chrome_host.dart` i `list/project_tasks_list.dart` (słuchają
`taskDataRevision`), `list/preferences/cubit/task_list_preferences_cubit.dart`,
`..._state.dart`, `..._loader.dart` (`fetch()` bez emisji),
`..._project_policy_controller.dart`, `.../widgets/task_columns_sheet_sections.dart`,
`l10n/app_{pl,en}.arb` + regenerowane `app_localizations*`.

Pliki (Backend): nowy `Domain/Rules/TaskListExceptions.cs`;
`Domain/Entities/TaskListUserPreference.cs`, `Domain/Entities/ProjectTaskListPolicy.cs`,
`Application/Tasks/Handlers/TaskListConfigurationHandler.cs`,
`Infrastructure/Http/ApiExceptionMiddleware.cs`, komunikaty konfliktu
w `Application/Kanban/{UserKanbanPreferenceService,KanbanSettingsService,KanbanTaskMover}.cs`
i `Application/Projects/ProjectCustomStatusService.cs`.

Decyzje: intencja opisuje wartość docelową (rebase jest idempotentny i nie
przenosi starych pól); po drugim konflikcie zatrzymujemy automatyczne
ponawianie, ale zachowujemy intencję/draft, więc „Ponów" ponawia zmianę
użytkownika, a nie stan serwera; błąd jest częścią stanu (trwały banner), a nie
zdarzeniem (SnackBar); sygnał danych zadań i sygnał błędów są rozdzielone;
konflikt rozpoznajemy po stabilnym kodzie `*.version_conflict`, a HTTP 409
zostaje jako zapas; arkusz kolumn zachowuje własny komunikat, bo jako modal
zasłania banner; strażnicy wersji w encjach rzucają wyjątki domenowe, bo to oni
odpowiadali za nieaktualny `expectedVersion`.

Testy dodane: Front — `tasks_error_banner_test.dart` (4 przypadki: banner
widoczny bez arkusza, „Ponów" ponawia draft, błąd odczytu bez „Ponów", `traceId`),
`tasks_board_cubit_test.dart` (+4: brak nadpisania równoległej zmiany, kliknięcie
w trakcie zapisu, nieudany odczyt preferencji z ponowieniem, brak przyrostu
`taskDataRevision` przy błędzie), `task_list_preferences_cubit_test.dart` (+3:
scalenie z równoległą zmianą sortowania, drugi konflikt z zachowanym draftem,
zmiana sortowania w trakcie zapisu) oraz rozpoznanie kodu konfliktu bez patrzenia
na sam status. Backend — `TaskListConfigurationTests` (+2: preferencje i polityka
zgłaszają własne wyjątki), przepisany przypadek preferencji oraz HTTP-owy
`TaskHttpOperationMatrixTests.TaskListConflictsUseDedicatedVersionConflictCodes`.

Komendy i wyniki: `flutter gen-l10n` ok; `flutter analyze lib` i
`flutter analyze test` — No issues found; `flutter test --timeout 180s` —
1017/1017 PASS; `flutter build web --wasm` — PASS; `flutter build macos --debug` —
PASS; `dotnet build veloryn-workspaces.csproj` — 0 ostrzeżeń, 0 błędów;
`dotnet test --filter "FullyQualifiedName~TaskList|FullyQualifiedName~TaskHttpOperationMatrix"`
— 18/18 PASS; pełna suite Backendu — 1156 PASS, 7 FAIL, 4 SKIP (wszystkie 7
w `MeEndpointsTests`, potwierdzone jako zastane przez `git stash` i wynik 7/17
bez N8); `git diff --check` czysty w obu repo; `cmp` dokumentów — identyczne.
Kontrola mutacyjna: `workspace.conflict` zamiast kodów `task_list.*` w middleware
→ `[FAIL]` nowego testu HTTP, po przywróceniu pliku zieleń.

NOT RUN: Release macOS (brak profilu provisioning w lokalnym Keychain — stan
zastany, AUTH-E2), buildy Windows/Linux (brak hosta) oraz live test dwóch sesji
z widocznym komunikatem — odroczony do wdrożenia nowej wersji Backendu.

Następny krok: właściciel wgrywa nową wersję Backendu, a po wdrożeniu uruchamiamy
live test dwóch sesji (konflikt ustawień widoku → trwały banner → „Ponów"
zapisuje intencję użytkownika), potem N3/N4 z planu parytetu.

### 2026-09-19 — N9: audyt transportu i stanu operacyjnego (P0 w odzyskiwaniu sesji)

Zakres: cztery defekty zgłoszone przez właściciela — podwójne żądania desktopowe,
cofanie zmian z czasu nieudanego zapisu Listy, gubiony stan operacyjny przy
odczycie tablicy oraz log ujawniający ciało odpowiedzi.

Pliki: `lib/foundation/http/devplanner_http_transport.dart` (bramka 401
w `_retryUnauthorized`, rozdzielenie `onResponse`/`onError`),
`lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart`
(`_publishFailure` na bieżącym stanie ze scaleniem, pętla autosave nie kasuje
zmiany z czasu żądania, `_lastSaved` jako baseline),
`lib/workspaces/presentation/tasks/board/cubit/tasks_board_runtime_coordinator.dart`
(odczyt przez `copyWith(board:, filter:)`),
`lib/workspaces/presentation/tasks/board/cubit/tasks_board_bulk_commands.dart`
(ja wne czyszczenie zaznaczenia), `lib/core/data/api_repository.dart`
(`debugResponseShape` zamiast zrzutu ciała).

Decyzje: retry sesji dotyczy wyłącznie 401 i jest sprawdzany po statusie
w obu ścieżkach, bo ten klient akceptuje każdy status i 401 przychodzi jako
odpowiedź, nie wyjątek; błąd zapisu nigdy nie cofa stanu — jest nakładany na
bieżący draft, a przy konflikcie draft przechodzi przez to samo scalenie co
zapis; odczyt tablicy wymienia wyłącznie dane tablicy i zachowuje stan
operacyjny (błąd, znacznik zapisu, rewizję, zaznaczenie); log diagnostyczny
opisuje kształt odpowiedzi, nie jej treść.

Komendy i wyniki: `flutter analyze lib test` — No issues found;
`flutter test --timeout 180s` — 1024/1024 PASS (w tym 7 nowych przypadków);
`flutter build web --wasm` — PASS; `flutter build macos --debug` — PASS;
`git diff --check` czysty w obu repo; `cmp` planu, handoffu i planu parytetu —
identyczne. Kontrola mutacyjna na trzech niezależnych mutacjach (bramka 401,
snapshot zamiast bieżącego stanu, stan od zera w `load()`) — każda wysyła na
czerwono właściwy nowy test, po przywróceniu plików zieleń.

Własność plików: naprawa P0 weszła w `foundation/http` (obszar drugiej sesji)
i `core/data` (legacy `core`); zmiany są punktowe, a cała suita transportu wraz
z pięcioma istniejącymi testami 401-retry przechodzi 10/10.

Następny krok: po wdrożeniu nowej wersji Backendu przez właściciela — live test
dwóch sesji (konflikt ustawień → trwały banner → „Ponów" zapisuje intencję),
a potem N3/N4 z planu parytetu.

### 2026-09-19 — N10: enumy transportowe i globalna diagnostyka HTTP

Przyczyna raportowanego `GET /tasks/groups` 400 była po stronie Frontu:
`TaskListQuery` wysyłał dartowe `.name` (`todo`, `inProgress`, `high`),
a binder ASP.NET Core 10 wymaga nazw enumów zgodnych z kontraktem (`Todo`,
`InProgress`, `High`). Audyt ujawnił ten sam rodzaj ryzyka w Kanbanie
(`TaskPriority` w query i `ProjectTaskStatus` w path), Notifications
(`NotificationCategory`) oraz dashboardzie (`DashboardContextKind`). Wszystkie
te granice mają teraz jawne `wireValue`, a klienty Retrofit przyjmują
prymitywny `String`, więc generator nie może ponownie użyć `Enum.toString()`.

Aktywny `DevPlannerHttpTransport` otrzymał globalny debugowy interceptor. Loguje
request/response/error, pełną zredagowaną URI, status, czas, nagłówki oraz
bezpieczny opis body. Redakcja obejmuje Authorization, Cookie/Set-Cookie, CSRF,
tokeny, sekrety, hasła, login/e-mail oraz tekst wyszukiwania. Dla odpowiedzi
sukcesu logowane są jedynie nazwy pól, a dla błędu `code`, `message`, `traceId`
i nazwy `fields`; wartości DTO i szczegóły pól nie trafiają do konsoli.

Backend ustawia `RouteHandlerOptions.ThrowOnBadRequest = true`. Dzięki temu
produkcyjny błąd bindera nie kończy się pustym 400, tylko przechodzi przez
istniejący `ApiExceptionMiddleware` i wspólny kontrakt błędu.

Pliki Front: `foundation/http/devplanner_http_diagnostics_interceptor.dart`,
`devplanner_http_transport.dart`, enumy shared, mapper `task_list_query.dart`,
API/repozytoria Tasks/Kanban/Notifications/Workspace oraz wygenerowane klienty.
Testy: `transport_enum_query_serialization_test.dart` i rozszerzona suita
`devplanner_http_transport_test.dart`. Backend: `Program.cs` oraz
`ApiEndpointTests.cs`.

Dowody: frontend targeted 13/13 PASS; scoped `flutter analyze` — No issues
found; backend build — 0 ostrzeżeń, 0 błędów; backend targeted 2/2 PASS.
Skan źródeł nie znalazł pozostałych enumów jako typów `@Query`/`@Path` ani
analogicznego `.name` w mapperach transportowych. Pełne suite i buildy
platformowe nie były częścią tej punktowej naprawy.

Następny krok: po wdrożeniu Backendu i ponownym uruchomieniu aplikacji potwierdzić
w logu `[HTTP][REQUEST]`, że filtr Tasks wysyła np. `status=InProgress`, oraz że
celowo błędny enum zwraca envelope `request.invalid` z `traceId` zamiast pustego
body.
### 2026-09-19 — PRODUCT-UX-AUDIT: nawigacja, wykorzystanie Backendu i kreator

Utworzono szczegółowy plan wykonawczy
`docs/recovery/product-navigation-and-project-wizard-refactor-plan.md` po
statycznym audycie obu repozytoriów. Plan nie zmienia kodu runtime.

Najważniejsze decyzje: jeden węzeł Zadania na projekt, Lista/Kanban jako widoki
we wspólnym nagłówku, jedno menu projektu wykorzystujące pin/hide/order/archive,
jeden wieloetapowy kreator dla wszystkich entrypointów oraz wspólny standard
optimistic-first z rollbackiem, trwałym komunikatem i `traceId`.

Potwierdzone braki Backendu rozpisane do implementacji: discoverable archiwum,
`isHidden` w liście, wersja projektu i stabilne 409, jawne capabilities,
atomowy/idempotentny project setup z preview oraz — tylko po decyzji produktowej
— bezpieczny transfer cross-workspace. Dokument definiuje pakiety P0–P8,
kontrakty, testy ról/IDOR/concurrency, bramki jakości i zakazy skrótów.

Status: **DONE dla zakresu dokumentacyjnego (2026-09-19)** — plan z matrycą
zapisany w obu repozytoriach; runtime i kontrakty API nietknięte.

Dowody (komendy i wyniki):
- `shasum -a 256` planu produktowego —
  `8c655ac6a9d039b90dd6f263c5099c6d65ec48f7a62523721944b7fde4b3a81d` w `Front`
  i w `Backend`.
- `cmp -s` dla trzech dokumentów współdzielonych
  (`devplanner-standalone-refactor-plan.md`,
  `devplanner-standalone-refactor-handoff.md`,
  `recovery/product-navigation-and-project-wizard-refactor-plan.md`) — pary
  Front↔Backend bez różnic.
- `git diff --check` w `Front` i w `Backend` — czysty.
- Kontrola 143 ścieżek wyciągniętych z §4.3 planu skryptem w Pythonie
  (`os.path.exists`) — wszystkie istnieją; wpis `Backend/…` wskazuje drugie
  repozytorium zgodnie z legendą.
- Audyt statyczny `grep` po `Backend/Contracts/Projects/`, `Domain/Entities/Project.cs`,
  `Infrastructure/Persistence/Configurations/ProjectConfiguration.cs`,
  `Endpoints/Projects/ProjectEndpoints.cs` oraz po `Front/lib/workspaces/**`
  potwierdził wszystkie sześć zgłoszonych luk, w tym `IsRowVersion` na encji
  `Project` bez publikacji wersji w DTO.

NOT RUN: `flutter analyze`, `flutter test`, `dotnet test` i buildy platformowe —
pakiet zmienia wyłącznie dokumentację, więc nie ma runtime do zweryfikowania.

Następny krok: P0 z planu — zamrozić testami obecne trasy, drzewo, oba
entrypointy tworzenia projektu i matrycę §4.3 (właściciel oraz stan każdego
wiersza).

### 2026-09-19 — PN-P2: jeden węzeł Zadania, routing i preferencja widoku

Status: **DONE (2026-09-19)**.

Pliki: `lib/workspaces/domain/navigation/workspace_navigation_node.dart` (usunięte
`taskList`/`kanban` z enuma), `.../workspace_navigation_tree.dart` (jedna pozycja
`Zadania`, projekt bez duplikatu gałęzi), `lib/app/shell/devplanner_shell_navigation.dart`
(switch-e, `_path`, `_isSelected` świadomy `?view=`, brak podwójnego podświetlenia
gałęzi z zaznaczonym dzieckiem), `lib/app/router/devplanner_router.dart` +
`devplanner_router_pages.part.dart` (redirecty `/tasks/list` i `/tasks/kanban`
przed trasą szczegółu, port preferencji w routerze), nowe
`lib/workspaces/domain/ports/tasks_project_view_preference_store.dart` i
`lib/workspaces/data/preferences/shared_preferences_tasks_project_view_store.dart`,
`lib/workspaces/presentation/tasks/board/{tasks_project_view,tasks_board_page,tasks_board_route_page}.dart`.

Decyzje: preferencja „ostatnio używany widok” jest lokalna jak motyw, a nie
domenowa — brak kontraktu backendowego na domyślny widok (sprawdzone w
`Contracts/`). Odczyt jest synchroniczny z cache wypełnianego raz przez `load()`
w konstruktorze routera; dzięki temu `/tasks` nie mruga Listą przed Kanbanem i
nie zależy od timingu platformy. Brak implementacji `shared_preferences`
(np. test widgetowy) jest normalnym stanem: cache działa w pamięci sesji, a
awaria persistence ląduje w logu diagnostycznym, nie w UI.

Świadomie przepisane testy (pinowały rozdzielone gałęzie): `workspace_navigation_foundation_test.dart`
(asercja `projectResourceKinds`), `workspace_navigation_tree_cubit_test.dart`
(dzieci `tasks`), `devplanner_shell_test.dart` (drzewo i selekcja — jeden wiersz
`Zadania` zaznaczony dla każdego widoku, projekt nie podświetla się drugi raz),
`devplanner_root_router_compile_test.dart` (brak węzłów `tasks:list`/`tasks:kanban`).
Nowe testy: `legacy view links redirect to the canonical Tasks query`,
`the canonical URL reopens the last used view`, `tasks_project_view_store_test.dart`
oraz `tasks_project_view_store_unavailable_test.dart` (osobny plik, bo mock
`shared_preferences` rejestruje się na cały proces).

Komendy i wyniki: `flutter analyze` — No issues found; `flutter test
test/app/router/ test/workspaces/data/preferences/ test/workspaces/presentation/navigation/
test/app/shell/` — 72/72 PASS; pełny `flutter test` — 1039/1039 PASS (przed P5 i P6a).

Następny krok: po wdrożeniu P1 pokazać w UI ukryte i archiwalne projekty oraz
sterować menu projektu przez `capabilities`.

### 2026-09-19 — PN-P5: jeden formularz tworzenia projektu

Status: **DONE dla ujednolicenia entrypointów (2026-09-19)**; kreator
wieloetapowy z §5 planu pozostaje otwarty jako P5b, bo wymaga kontraktu z P4.

Pliki: `lib/app/shell/devplanner_shell.dart` (shell przyjmuje `projectsRepository`,
akcja tworzenia otwiera `ProjectResourceCreationDialogs.showCreateProject`),
`lib/app/shell/devplanner_shell_navigation.dart` (usunięty
`_CreateProjectFromSidebarDialog`), `lib/app/router/devplanner_router.dart`
(`_resolvedShellProjectsRepository` zamiast bramy tworzenia), usunięte
`lib/workspaces/domain/ports/project_management_gateway.dart` i
`lib/workspaces/data/standalone/project_management_gateway.dart`.

Decyzja: wąski port `ProjectManagementGateway` miał jednego członka i jednego
konsumenta — drugi flow tworzenia. Zamiast utrzymywać dwa wejścia, sidebar
korzysta z repozytorium projektów i tego samego formularza co drzewo; Web BFF
nadal nie wystawia akcji (brak klienta API), więc zachowanie na webie się nie
zmienia. Nawigacja do utworzonego projektu czeka na przekazanie identyfikatora
z formularza (dziś oba wejścia tylko odświeżają gałąź workspace'u).

Komendy i wyniki: `flutter analyze` — No issues found; `flutter test
test/app/shell/devplanner_shell_test.dart` — 8/8 PASS, w tym nowy przypadek
`sidebar opens the same project form as the project tree`.

### 2026-09-19 — PN-P6a: kaskada harmonogramu w stanie

Status: **DONE (2026-09-19)**.

Pliki: nowy `lib/workspaces/presentation/tasks/detail/cascade/cubit/task_schedule_cascade_cubit.dart`
(stan + cubit), `lib/workspaces/presentation/tasks/detail/task_details_properties_planning.dart`
(dialog planowania używa cubita zamiast wołać `TaskScheduleRepository` wprost),
import w `task_details_page.dart` (part file dziedziczy importy biblioteki).

Decyzje: zapis kaskady bez podglądu jest odrzucany w cubicie, bo kontrakt wymaga
`expectedVersion` każdego przesuwanego zadania; konflikt 409 zostawia podgląd
i trwały komunikat, a zmiana dat zdejmuje podgląd, żeby nie opisywał innych
terminów niż te w polach.

Komendy i wyniki: `flutter analyze` — No issues found; `flutter test
test/workspaces/presentation/tasks/detail/cascade/` — 6/6 PASS; `flutter test
test/workspaces/presentation/tasks/` — 421/421 PASS.

### 2026-09-19 — N10-followup: testy pinujące starą serializację enumów

Pięć przypadków nadal oczekiwało dartowych nazw pól (`inProgress`, `blocked`,
`critical`), które pakiet N10 zastąpił wartościami kontraktowymi. Asercje
przepisano na `wireValue` (`task_list_chrome_test.dart` — 2 przypadki,
`project_tasks_list_cubit_test.dart` — 3 przypadki), więc pilnują teraz
poprawnego kontraktu, a nie wadliwej serializacji. Komendy i wyniki:
`flutter test` obu plików — 60/60 PASS; pełny `flutter test` — 1039/1039 PASS.

### 2026-09-19 — PN-P3: jedno menu projektu, optimistic-first z rollbackiem

Status: **DONE dla drzewa projektów (2026-09-19)**; wpięcie drzewa w żywy shell
i pełna lista archiwum pozostają otwarte (patrz „Następny krok”).

Pliki nowe (wszystkie pod `lib/workspaces/presentation/workspaces_home/projects_tree/`):
`cubit/{projects_tree_cubit,projects_tree_state,projects_tree_model,projects_tree_preferences,projects_tree_order,projects_tree_lifecycle}.dart`
oraz `widgets/{project_context_menu,project_context_dialogs,project_tree_actions,project_tree_items,projects_tree_projects,projects_tree_project_section,projects_tree_failure_banner}.dart`.
Zmienione: `workspace_project_menu.dart` (rozbudowane istniejące menu, bez drugiej
implementacji), `lib/l10n/app_pl.arb`, `lib/l10n/app_en.arb` (+ generaty).

Decyzje: jedno menu kontekstowe budowane raz (`buildProjectContextMenuEntries`)
i używane w drzewie, sekcji `Ukryte` i sekcji `Archiwum`; `Przenieś do workspace`
i `Opuść projekt` są widoczne, ale wyłączone z podanym powodem, bo nie mają
kontraktu (§6.4) i reguły ostatniego Ownera — plan §11 zabrania udawania
działającej funkcji. Pin/hide mają maksymalnie jedno żądanie na projekt i
scalają kolejne intencje do ostatniej wartości; rollback cofa wyłącznie pola tej
operacji i tylko wtedy, gdy rewizja pola się nie zmieniła, więc późniejsze
zmiany użytkownika nie giną. DnD kolejności wysyła pełną listę widocznych
projektów — niepełna lista jest odrzucana lokalnie. Błąd jest trwały (baner
z operacją, przyczyną, kodem i `traceId` + „Ponów”), a SnackBar służy wyłącznie
nietrwałym potwierdzeniom (ukrycie z „Cofnij”). Ukrycie i archiwizacja są
poznawane z własnej operacji, nie z `ProjectListItemResponse`, dlatego nie
dodano pól, których kontrakt jeszcze nie ma (P1).

Świadomie przepisane testy: brak — istniejące asercje `user_hub` i menu zostały
zachowane; nowe przypadki dodano obok nich.

Komendy i wyniki: `flutter analyze` (cały projekt) — No issues found;
`flutter test test/workspaces/presentation/workspaces_home/ test/workspaces/presentation/projects/`
— 63/63 PASS (w tym 31 w `projects_tree/`: 22 cubita i 9 widgetowych);
`flutter gen-l10n` — bez ostrzeżeń; `git diff --check` — czysty.

NOT RUN: bramka P3 z §8 wymagająca żywego Backendu i dwóch sesji (macierz ról,
konflikt 409, restart persistence) oraz scenariusze live — do odbioru w P8;
buildy platformowe poza zakresem pakietu.

Następny krok: wpiąć drzewo projektów w żywy shell (`WorkspaceProjectMenu` jest
dziś montowane tylko przez `workspace_directory_item.dart`, a sidebar rysuje
własne `WorkspaceNavigationTree`), przekazując mu `projectsRepository`, który
shell już trzyma; potem pokazać pełną listę archiwum na kontrakcie z P1.

### 2026-09-19 — PN-P1: backend list/lifecycle/version/capabilities

Status: **DONE po stronie Backendu (2026-09-19)**.

Pliki (Backend): `Contracts/Projects/ProjectCapabilitiesResponse.cs` (nowy),
`Contracts/Projects/ProjectListQuery.cs` (nowy), `ProjectListItemResponse.cs`,
`ProjectResponse.cs`, `UpdateProjectRequest.cs`, `UpdateProjectUserPreferenceRequest.cs`,
`ProjectUserPreferenceResponse.cs`, `Application/Projects/{ProjectHandlers,ProjectAccessService,ProjectResponseMapper,ProjectTemplateHandler,ProjectCapabilityContext,ProjectCapabilityPolicy,ProjectConcurrencyGuard}.cs`,
`Domain/Rules/{ProjectRoleResolution,ProjectVersionConflictException,ProjectPreferenceVersionConflictException,ProjectArchivedException}.cs`,
`Infrastructure/Http/ApiExceptionMiddleware.cs`, `Endpoints/Projects/ProjectEndpoints.cs`,
`Tests/Veloryn.Workspaces.Tests/{ProjectLifecycleReadTests,ProjectLifecycleHttpIntegrationTests}.cs`.

Decyzje: `version` to `long` z `uint Xmin` (nieprzezroczysty dla klienta);
capabilities liczone z rozstrzygniętego ACL, nie ze stanu encji — `canDelete`
wymaga roli Owner workspace, `canLeave` istnieje tylko przy jawnym członkostwie,
`canTransfer` jest zawsze `false`, bo transferu nie ma (§6.4); `MyRole` w liście
pozostaje rolą jawną (bez zmiany semantyki dla Frontu), a uprawnienia efektywne
niesie `capabilities`. Preferencje użytkownika mają token wersji z `Xmin`, więc
`expectedVersion` działa bez migracji. `project.archived` zastąpił 404 dla
operacji na zarchiwizowanym projekcie w PATCH projektu i preferencji; endpointy
członkostw zachowują dotychczasowe 404. Swashbuckle 9 nie ma flagi
`Deprecated`, więc przestarzałość `includeHidden` jest wyrażona w opisie
parametru i endpointu.

Świadomie przepisane testy: brak — nowe przypadki dodano obok zastanych.

Komendy i wyniki (Backend): `dotnet build Veloryn.Workspaces.slnx` — 0
ostrzeżeń, 0 błędów; `dotnet test --filter "FullyQualifiedName~Project"` —
136/136 PASS (baseline 119 + 17 nowych; w tym 8 testów HTTP na realnym
PostgreSQL: dwie sesje, 409, archiwum, hidden, OpenAPI);
`ProjectLifecycle*` — 20/20 PASS; pełny `dotnet test Tests/Veloryn.Workspaces.Tests`
— 1174 PASS / 4 SKIP / 7 FAIL, gdzie wszystkie 7 to zastane `MeEndpointsTests`
(potwierdzone `git stash`, ten sam zestaw bez zmian projektowych);
`dotnet ef migrations script --idempotent --context WorkspaceDbContext` — exit 0,
`git status Migrations/` pusty; `dotnet format --verify-no-changes` na zmienionych
ścieżkach — exit 0; `git diff --check` — czysty.

NOT RUN: nic z zakresu P1 — testy integracyjne z PostgreSQL zostały uruchomione
na lokalnym kontenerze (port 5440).

Następny krok: przepisać DTO i adaptery Frontu na `isHidden`/`version`/
`capabilities` i podłączyć je do menu projektu oraz widoków Ukryte/Archiwum
(P3 dziś utrzymuje tę wiedzę lokalnie, bo pól jeszcze nie było).

### 2026-09-19 — PN-P4: atomowy kreator projektu w Backendzie

Status: **DONE (2026-09-19)**.

Pliki nowe (Backend): `Contracts/Projects/ProjectSetupContracts.cs`,
`Application/Projects/Setups/{ProjectSetupPlan,ProjectSetupPlanner,ProjectSetupWriter,ProjectSetupHandler,ProjectSetupPreviewHandler,ProjectSetupRequestHasher,ProjectSetupJson,ProjectSetupIdempotencyRetentionService}.cs`,
`Application/Projects/{ProjectTemplateMaterializer,ProjectTemplateSnapshot,ProjectWorkflowTemplateCatalog}.cs`,
`Domain/Entities/ProjectSetupIdempotencyRecord.cs`, `Domain/Enums/ProjectSetupEnums.cs`,
`Domain/Rules/{ProjectSetupExceptions,ProjectWorkflowDefinition,ProjectDetailsRules}.cs`,
`Endpoints/Projects/ProjectSetupEndpoints.cs`,
`Infrastructure/Persistence/Configurations/ProjectSetupIdempotencyRecordConfiguration.cs`,
`Infrastructure/Projects/ProjectSetupIdempotencyRetentionWorker.cs`,
`Migrations/20260919203032_AddProjectSetupIdempotency.cs` (+ Designer, snapshot).
Zmienione: `Domain/Entities/{Project,ProjectKanbanSettings,ProjectTaskListPolicy}.cs`,
`Application/Projects/{ProjectTemplateHandler,ProjectCustomStatusService}.cs`,
`Extensions/{WorkspaceEndpointExtensions,WorkspaceServiceExtensions}.cs`,
`Infrastructure/Http/ApiExceptionMiddleware.cs`, `WorkspaceDbContext.cs`,
`ProjectConfiguration.cs`. Testy: `ProjectSetupRequestHasherTests.cs` (4),
`ProjectSetupHttpIntegrationTests.cs` (13, HTTP + PostgreSQL).

Decyzje: klucz idempotencji jest rezerwowany pierwszym `SaveChanges` jeszcze
przed utworzeniem projektu, więc równoległe żądania rozstrzyga unikalny indeks,
a nie logika aplikacji. Hash żądania liczy się z kanonicznego JSON-a (sortowane
klucze), dzięki czemu kolejność pól nie zmienia tożsamości żądania. Replay
odczytuje zapisany wynik przed planowaniem, więc działa nawet po zmianie
szablonu. Retencja klucza 48 h (zmienna `WORKSPACES_PROJECT_SETUP_IDEMPOTENCY_RETENTION_HOURS`,
1–168) z workerem co 6 h — po retencji klucz wraca do obiegu i jest to
udokumentowane w XML doc oraz w opisie endpointu. Capacity jest workspace'owa,
więc jej ustawienie wymaga roli Admin/Owner i kończy się 403 już w preview.
`taskView.defaultView` dostał addytywną kolumnę `projects.DefaultTaskView`
(domyślnie `List`), bo nie miał gdzie żyć; celowo nie rozszerzano
`ProjectResponse`/`UpdateProjectRequest`.

Komendy i wyniki (Backend): `dotnet build Veloryn.Workspaces.slnx` — 0 ostrzeżeń,
0 błędów (potwierdzone niezależnym przebiegiem agenta głównego);
`dotnet test --filter "FullyQualifiedName~ProjectSetup"` — 17/17 PASS (13 HTTP na
kontenerze PostgreSQL, 4 jednostkowe; potwierdzone niezależnie); pełny
`dotnet test` — 1191 PASS / 4 SKIP / 7 FAIL, gdzie te same 7 testów pada na
czystym `HEAD` (MeEndpointsTests, DI `DeviceSessionRealtimeConnectionRegistry`),
a jeden flaky przypadek z pierwszego przebiegu przeszedł w drugim i osobno 3/3;
`dotnet ef migrations script --idempotent --context WorkspaceDbContext` — exit 0
(skrypt zawiera tabelę idempotencji, unikalny indeks i `ADD "DefaultTaskView"`);
`dotnet format veloryn-workspaces.csproj --verify-no-changes` — exit 0;
`git diff --check` — czysty.

NOT RUN: buildy desktopowe i deploy/staging (repozytorium backendowe, brak hosta
i polecenia).

Następny krok: P5b w Froncie — kroki kreatora z §5 na tym kontrakcie (szablon,
dostęp, workflow, sposób pracy, funkcje startowe, podsumowanie) oraz wystawienie
`defaultTaskView` w `GET/PATCH /projects`.

### 2026-09-19 — PN-REVIEW-FIX: blokery z review (Freezed, provider, preferencja per konto)

Status: **DONE dla trzech blokerów (2026-09-19)**; konsumpcja kontraktu P1
w Froncie i testy kreatora są osobnymi pakietami w toku.

1. **[P0] Niekompilujący się kod Freezed** w nowych modelach kreatora
   (`lib/workspaces/data/projects/setups/models/*.dart`): generator freezed 3
   emitował dla kolekcji niepoprawne `final` w liście parametrów konstruktora.
   Naprawa: adnotacje `@freezed` zamienione na
   `@Freezed(makeCollectionsUnmodifiable: false)` (konwencja repo, m.in.
   `task_advanced_models.dart`, `task_schedule_models.dart`) i ponowne
   generowanie `dart run build_runner build --delete-conflicting-outputs`
   (11 plików wyjściowych). Ten błąd nie jest wykrywany przez `flutter analyze`,
   bo `analysis_options.yaml` wyklucza `*.freezed.dart` — bramką jest pełny
   `flutter test`.

2. **[P1] Zależności kreatora w drzewie**: `context.read<X?>()` w provider 6
   **zwraca `null`**, gdy providera nie ma (rzuca tylko dla typu nie-nullable),
   więc to nie było źródłem crashu. Realnym brakiem było to, że shell nie
   **udostępniał** `ProjectsRepository` potomkom — przez to menu projektu
   w sidebarze nie miało portu mutacji i wszystkie akcje były wyłączone.
   Naprawa: `DevPlannerShellRoute` opakowuje layout w `MultiRepositoryProvider`
   z `ProjectsRepository` i `ProjectsGateway`, z jawnym przypadkiem pustej listy
   providerów (`MultiRepositoryProvider` nie przyjmuje pustej listy).

3. **[P2] Preferencja widoku nie była izolowana per użytkownik**: klucz
   `devplanner.tasks-view.{workspaceId}.{projectId}` zamieniony na
   `devplanner.tasks-view.{userId}.{workspaceId}.{projectId}`. Tożsamość jest
   czytana w momencie operacji (`currentUserId`), a router wczytuje preferencje
   ponownie po zmianie konta w tej samej sesji klienta, żeby wybór widoku nie
   przechodził na następną osobę. Odczyt z cache innego konta zwraca brak
   preferencji, a nie cudzy widok.

Komendy i wyniki: `flutter analyze` (cały projekt) — No issues found;
`flutter test` — **1077/1077 PASS** (w tym nowe przypadki izolacji preferencji
między kontami i braku zalogowanego użytkownika); `flutter test test/app/shell/`
— 11/11 PASS; `git diff --check` — czysty.

Backend (domknięcie luk wskazanych w review):
- `ProjectListItemResponse` publikuje teraz także `ArchivedAtUtc`, żeby klient
  mógł odtworzyć listę archiwum bez drugiego żądania i bez zgadywania daty.
- `dotnet build Veloryn.Workspaces.slnx` — 0 ostrzeżeń, 0 błędów;
  `dotnet test --filter "FullyQualifiedName~Project"` na działającej bazie —
  **153/153 PASS** (wcześniejsze 39 niepowodzeń to wyłącznie wyłączony kontener
  PostgreSQL, nie regresja).
- Pełny `dotnet test Tests/Veloryn.Workspaces.Tests` na działającej bazie —
  **1191 PASS / 4 SKIP / 7 FAIL** (1202). Wszystkie 7 niepowodzeń to zastane
  `MeEndpointsTests`/`DeviceSessionRealtimeConnectionRegistryTests` (auth/identity,
  poza zakresem projektów i objęte ustaleniem o module auth); baseline `HEAD`
  pokazuje ten sam zestaw. Liczba testów wzrosła o 35 względem baseline
  (1167 → 1202) dzięki pakietom P1 i P4.
- Migracje: baza testowa `veloryn_admin_ops_*` ma jako ostatnią migrację
  `20260919203032_AddProjectSetupIdempotency`, co dowodzi, że pełny łańcuch
  (P1 + P4) wykonuje się na czystej bazie; `dotnet ef migrations script
  --idempotent --context WorkspaceDbContext` z ustawionym
  `ConnectionStrings__Workspaces`/`ConnectionStrings__Identity` — exit 0,
  9679 linii, zawiera `project_setup_idempotency_records` i
  `ADD "DefaultTaskView"`.

4. **Pozostałe dialogi zasobów** (`showCreateWhiteboard/Task/WikiPage/CorkboardCard/Folder`)
   czytały port nie-nullable, więc brak providera wywracał widok. Naprawione:
   opcjonalny odczyt + wspólny, jawny stan „Ten formularz nie ma połączenia
   z backendem w tej sesji, więc nic nie zostało zapisane.” (nowy klucz ARB
   `projectResourceUnavailableMessage`). Przypięte testem
   `project_resource_creation_dialogs_test.dart` (brak portu → jawny stan bez
   wyjątku; z portem → właściwy formularz). Wynik: analyze bez uwag, 2/2 PASS.

5. **Backend: `expectedVersion` dla `DELETE /projects/{id}`** — trwałe usunięcie
   jest nieodwracalne, więc opcjonalna wersja pozwala wykryć zmianę od czasu
   odczytu; konflikt mapuje się na 409 `project.version_conflict`.
   `dotnet build` — 0/0; `--filter Project` — 153/153 PASS.

Następny krok: przekazać `expectedVersion` w wywołaniach centrum ustawień
i policzyć widoczność zakładki członków z `canManageMembers` (poza zakresem
dotychczasowych pakietów).

### 2026-09-19 — PN-P5b: kreator projektu z kroków §5 i jego testy

Status: **DONE (2026-09-19)**.

Pliki: `lib/workspaces/presentation/projects/dialogs/wizard/**` (kubit kreatora,
walidator draftu, kroki `start/basics/access/workflow/working-style/starter/summary`,
shell i kafelki), wejście `ProjectResourceCreationDialogs.showCreateProject`
(z jawnym stanem „port niedostępny”), `lib/workspaces/data/projects/setups/**`
(API Retrofit + modele żądań/podglądu/wyniku), `lib/workspaces/domain/**`
(port `ProjectSetupsRepository`, modele domenowe setupu), ARB PL/EN (+generaty).

Decyzje: kroki opcjonalne można pominąć, a podsumowanie pokazuje wybrane
wartości domyślne; draft żyje lokalnie i przeżywa cofanie; submit wysyła jeden
`Idempotency-Key` na draft i używa tego samego klucza po timeoucie, a 409
(klucz albo wersja szablonu) jest trwałym błędem z wymianą klucza lub odświeżeniem
snapshotu; żaden projekt nie trafia do drzewa przed odpowiedzią serwera. Dwa
defekty znalezione przez nowe testy: komunikat błędu podglądu jednego szablonu
przeciekał na wszystkie karty (naprawione `templateErrorId`) i lista wyboru
przepełniała wiersz w wąskim oknie (`isExpanded` + ellipsis).

Komendy i wyniki: `flutter analyze` — No issues found (całe repo);
`flutter test test/workspaces/presentation/projects/` — 52/52 PASS (24 nowe
przypadki w 5 plikach: dymny bez opcjonalnych providerów, kroki i walidacja,
błędy planu/submit, idempotencja i timeout, katalog szablonów);
pełny `flutter test` — 1143/1143 PASS; `flutter build web --wasm` — ✓ Built.

### 2026-09-19 — PN-P1-FRONT: konsumpcja kontraktu projektów w Froncie

Status: **DONE (2026-09-19)**.

Pliki: `lib/workspaces/data/projects/**` (DTO `ProjectListItemResponse` z
`isHidden`/`version`/`capabilities`/`archivedAtUtc`, nowy DTO capabilities,
`state`/`visibility` w `ProjectsListApi` i Retrofit `ProjectsApi`,
`expectedVersion` na archive/restore/update/preferences, mapper i parsowanie
tolerancyjne starszego backendu), `lib/workspaces/domain/models/project_list_query.dart`
(`ProjectListState`, `ProjectListVisibility`, `fromLegacy`), `domain/models/project_action_capabilities.dart`,
`presentation/workspaces_home/projects_tree/**` (sekcje `Ukryte` i `Archiwum`
z serwera, `syncFromServer` ze zakresem listy, menu z capabilities, akcja
„Opuść projekt” przez `canLeave`), ARB (+5 kluczy).

Decyzje: brak `capabilities` daje zachowanie zachowawcze z innym komunikatem
(„Backend nie zwrócił uprawnień…”) niż odmowa uprawnień — menu nie liczy już
`myRole`; znaczniki ukrycia/archiwum ustawia zakres listy, którym je pobrano,
więc świeża lista aktywnych nie zdejmuje znacznika archiwum; intencje w locie
są pomijane w obu ścieżkach, żeby wolniejszy odczyt nie cofał optymistycznej
mutacji; brak GET-a preferencji oznacza, że po 409 porzucamy nieaktualną wersję
i pokazujemy trwały błąd z kodem (jawny „Ponów” zamiast wiecznego 409).

Komendy i wyniki: `flutter analyze` — No issues found; `flutter test` —
1143/1143 PASS; `flutter build web --wasm` — ✓ Built; `git diff --check` — czysty;
`dart run build_runner build --delete-conflicting-outputs` i `flutter gen-l10n`
— bez błędów.

Otwarte: zakładka członków w centrum ustawień nadal liczy rolę zamiast
`canManageMembers`, a wywołania `settings/**` nie przekazują `expectedVersion`
(oba poza zakresem pakietu); `dart format` w tym SDK przepisał 15 plików poza
zakresem — cofnięte, różnice były wyłącznie formatowaniem.

### 2026-09-20 — FILES-AUDIT: plan naprawy Plików

Status: **PLAN ONLY** — bez zmian runtime.

Audyt aktywnego routera wykazał, że osobiste, workspace'owe i projektowe trasy
Files montują `StorageReadOnlyBrowserPage`, a nie istniejący bogatszy
`StorageShellPage`. To wyjaśnia brak spójnego headera, wyszukiwarki i pełnej
powierzchni Lista/Siatka. Backend ma już share'y User/Workspace/Project/
PublicLink, foldery, placementy, historię wersji, historyczny stream i
OnlyOffice z identyfikacją użytkowników oraz wspólnym document key.

Pełny plan F0–F9 zapisano w
`Backend/docs/recovery/files-storage-ux-recovery-plan.md`. Najważniejsze nowe
zadania kontraktowe: atomowe przeniesienie placementu z concurrency, preview
historycznej wersji, weryfikacja share ACL i E2E dwóch równoległych sesji
OnlyOffice. Front ma przejść na jeden host, jeden dwurzędowy chrome zgodny z
Tasks/Kanban, trwałe preferencje oraz trwałe błędy z retry/traceId.

Wykonane sprawdzenia dokumentacyjne: pełny odczyt planu refaktoru, audyt tras,
komponentów Storage, repozytorium Flutter, endpointów i kontraktów Backend;
`git diff --check` bez błędów przed dopisaniem handoffu; kopie głównego planu
Backend/Front są identyczne. Nie uruchamiano buildów ani testów, ponieważ pakiet
nie zmienia kodu. Qdrant był niedostępny (`qdrant-find: 'document'`).

Następny krok: F0 — testy charakterystyczne i zamrożenie obecnego rozjazdu
routingu, potem F1 — jeden host dla personal/workspace/project.

### 2026-09-20 — WIZARD-UX: modal dwupanelowy, prawdziwy podgląd szablonu, język produktu

Status: **DONE** — zakres UX-1…UX-7 z
`docs/recovery/project-wizard-ux-completion-plan.md` jest w kodzie, ma goldeny
i przechodzi pełną regresję. Bramki Windows i Linux pozostają niewykonane, bo
ta maszyna jest hostem macOS.

Pliki (Front): nowe `widgets/project_setup_wizard_layout.dart`,
`widgets/project_setup_help_button.dart`, `widgets/preview/*` (panel, nagłówek,
przełącznik widoku, podgląd Kanban i listy, podsumowanie zawartości, modele
snapshotu, atomy) oraz pięć nowych plików testów kreatora
(`project_preview_snapshot_test`, `project_setup_wizard_layout_test`,
`project_setup_wizard_controls_test`, `project_setup_wizard_preview_test`,
`project_setup_wizard_golden_test`). Zmienione:
`widgets/project_setup_wizard_shell.dart`, `widgets/project_setup_wizard_controls.dart`,
`widgets/project_setup_step_timeline.dart`, wszystkie kroki `steps/*.dart`,
`l10n/project_setup_wizard_l10n.dart`, `shared/presentation/widgets/app_text_field.dart`
(wstecznie zgodny `autofocus`), `lib/l10n/app_pl.arb`, `app_en.arb` z
wygenerowanymi lokalizacjami, testy kreatora z fixture oraz
`docs/recovery/project-wizard-ux-completion-plan.md` (wskaźnik ze stanem).
Plan kanoniczny w Backendzie dostał pakiet UX-7 i sekcję 16 ze stanem.

Decyzje: rozmiar modala liczy `ProjectSetupWizardMetrics` z viewportu (1120×780
na dużym ekranie, nigdy ponad viewport), a od 960 px kontrolki i podgląd stoją
obok siebie — bez stałego `maxWidth: 720`. Podgląd korzysta wyłącznie z danych:
`ProjectTemplateDetailsResponse` dla szablonu i plan serwera dla podsumowania;
kolumna bez własnego koloru dostaje kolor motywu, a zadanie z nieznanym statusem
dokłada własną kolumnę zamiast zniknąć. Podgląd idzie za `defaultView` draftu,
ale gdy w tym widoku nie ma ani jednego wiersza, pokazuje tablicę z kolumnami;
wybór w przełączniku jest ważniejszy. Podgląd jest pamiętany per `templateId`,
więc powrót do szablonu nie miga szkieletem, a odświeżanie zostawia starą treść
pod cienkim wskaźnikiem. „Utwórz projekt” jest zablokowane, dopóki plan jest
nieaktualny, natomiast „Ponów” w bannerze błędu nadal ponawia submit. Teksty
kreatora przeszły audyt UX-7 (zniknęły „Brak wpiętego portu…”, „katalog
Backendu”, „Draft zmienił się…”, literówka „Dziennea pojemność”; formularz
zasobów mówi „Nie mamy teraz połączenia z serwerem…”).

Komendy i wyniki: `flutter test test/workspaces/presentation/projects/dialogs`
— 73/73 PASS (baseline pakietu 24); `flutter test` — 1186/1186 PASS;
`flutter analyze` — No issues found w chwili zakończenia pakietu (późniejsza
uwaga w `test/app/router/devplanner_root_router_compile_test.dart` należy do
pliku edytowanego równolegle przez innego agenta); goldeny (`--update-goldens`, a potem ten
sam test bez flagi) — 5/5 PASS i pięć plików PNG w
`test/workspaces/presentation/projects/dialogs/wizard/goldens/`;
`flutter gen-l10n` — bez błędów, klucze PL/EN zgodne; `flutter build web --wasm`
— ✓ Built; `flutter build macos --debug` — ✓ Built (ad-hoc; build release
wymaga `DEVPLANNER_RELEASE_CODE_SIGN_IDENTITY`, którego ta maszyna nie ma);
`dart format` w zakresie pakietu — wykonany; `git diff --check` — czysty.

Uwaga o równoległej pracy: przez kilka minut w trakcie pakietu
`flutter analyze lib` zgłaszał 12 błędów wyłącznie w
`lib/workspaces/presentation/storage/shell/*` (cudzy moduł w edycji), co
chwilowo blokowało goldeny i pełne bramki. Modułu nie ruszano; po jego
naprawie wszystkie bramki przeszły.

Domknięcie UX-5 po decyzji użytkownika (ten sam dzień): każda z trzech opcji
workflow ma miniaturę swoich kolumn (`_WorkflowColumnsPreview` z tego samego
snapshotu co panel; wybór katalogowy pokazuje sam kształt tablicy, bo nazw
kolumn nikt jeszcze nie zna), krok sposobu pracy pokazuje ustawienia wybranego
widoku, a drugi wchodzi przyciskiem „Dostosuj także ustawienia tablicy/listy”
z informacją, że ukryty widok trafi do projektu z wartościami domyślnymi (błąd
pola kafelka odsłania tablicę mimo bramki), a karty funkcji startowych mają
reguły „Gdy… → wtedy…” z jednego wspólnego widgetu
`project_setup_recipe_rule.dart`. Testy: nowy
`project_setup_wizard_step_simplification_test.dart` (6 przypadków), zaktualizowany
golden kroku workflow i kroku sposobu pracy.

Komendy po tych zmianach: `flutter test
test/workspaces/presentation/projects/dialogs/wizard` — 70/70 PASS;
`flutter test` — 1192/1192 PASS; `flutter analyze` — No issues found;
`flutter build web --wasm` — ✓ Built (71 s); `flutter build macos --debug` —
✓ Built; `git diff --check` — czysty.

Przegląd zewnętrzny (ten sam dzień) zgłosił cztery problemy i zastrzeżenie do
artefaktów goldenów; wszystkie potwierdzone i naprawione:

- **[P1] Podsumowanie gubiło zawartość szablonu** — plan podmienia teraz tylko
  kolumny (`_withPlanColumns`), a zadania, etykiety i pola z szablonu zostają.
  Testy: jednostkowy w `project_preview_snapshot_test.dart` i widgetowy na
  podsumowaniu (zadanie, „Etykiety: 2”, „Pola: 1”, kolumny planu po przełączeniu
  na Kanban).
- **[P1] Usunięcie statusu mogło zapisać dane sąsiada** — wiersz pamięta, co sam
  wysłał do draftu, i w `didUpdateWidget` przesynchronizowuje kontrolery, gdy
  draft niesie inną wartość. Nowy plik
  `project_setup_wizard_status_rows_test.dart` (4 przypadki: usunięcie środka,
  edycja po usunięciu, limit WIP, zgodność przełącznika z renderem).
- **[P2] Przełącznik podglądu mógł wskazywać inny widok niż renderowany** —
  `_resolvedMode` liczy się raz i trafia do przełącznika i renderera.
- **[P2] Test roli nie testował prawdziwego dropdownu** — test otwiera menu
  prawdziwym kliknięciem, sprawdza pozycje w overlayu i wybiera rolę akcją
  `SemanticsAction.tap` (ścieżka czytnika ekranu); kliknięcie w pozycję menu
  pokrywa test dropdownu gęstości.
- Katalog `failures/` z czterema obrazami usunięty, `.gitignore` dostał
  `**/failures/`; katalog `tasks/board/failures/` (z 19.09, inny zakres)
  zostawiony bez zmian.

Komendy po poprawkach: `flutter test
test/workspaces/presentation/projects/dialogs/wizard` — 75/75 PASS;
`flutter test` — 1230/1230 PASS; `flutter analyze` — No issues found; goldeny
5/5 po regeneracji; `flutter build web --wasm` — ✓ Built (88 s);
`flutter build macos --debug` — ✓ Built; `git diff --check` — czysty.

Druga runda przeglądu (ten sam dzień) wykryła, że finalny Kanban nie ma kart
z szablonu. Sedno było w kontrakcie Backendu: dla projektu z szablonu
`ProjectSetupPlanner.ResolveWorkflow` zwraca rodzaj domyślny z pustą listą
własnych statusów, a serwer kopiuje statusy i zadania wprost ze snapshotu
szablonu. Front czytał puste `customStatuses` jako „plan nie ma kolumn” i na
podsumowaniu pokazywał cztery statusy systemowe (kolumny, których projekt nie
dostanie) bez kart. Naprawa: dla draftu z szablonu plan nigdy nie podmienia
kolumn — snapshot zachowuje kolumny, karty, etykiety i pola szablonu i dostaje
znacznik `planApproved`, więc panel pisze „Zatwierdzone przez plan”; podmiana
kolumn została tylko dla pustego projektu. Przy okazji przestałem zgadywać
statusy systemowe: kontrakt nie wystawia ich nazw przed utworzeniem projektu,
a realny systemowy workflow ma sześć statusów, nie cztery — podgląd pokazuje
teraz kształt tablicy i liczbę kolumn z planu. Nowe testy: karty w kolumnie
szablonu z `planApproved`, brak wymyślonych nazw systemowych, dwa osobne testy
podsumowania (projekt z szablonu vs pusty projekt), plus regenerowany golden
podsumowania i kroku workflow.

Komendy tej rundy: `flutter test test/workspaces/presentation/projects/dialogs`
— 85/85 PASS; `flutter analyze lib` — No issues found; goldeny 5/5;
`flutter build web --wasm` — ✓ Built (75 s); `flutter build macos --debug` —
✓ Built; `git diff --check` — czysty. Pełnego `flutter test` nie da się teraz
uruchomić: równolegle trwa praca nad Kanbanem i jej testy nie kompilują się
(`TasksBoardViewPreferenceStore.readAssigneeColumns/readGrouping`, `TasksHeader`,
`KanbanBoardGroupingBar` w `test/workspaces/presentation/tasks/board/**`) — to
inny zakres, plików nie ruszano. Ostatni pełny przebieg przed tą rundą to
1230/1230 PASS.

Następny krok: do potwierdzenia w uruchomionej aplikacji — klik w pozycję menu
roli członka w kroku dostępu, gdy wiersz leży pod zgięciem panelu (w teście
widgetowym geometria tego jednego menu nie trafia, choć akcja czytnika ekranu
działa); opcjonalnie bramki Windows i Linux na właściwych hostach.
### 2026-09-20 — FILES-F1: jeden pełny host Plików dla trzech zakresów

Status: **DONE** — kod i testy; buildy platform i odbiór live pozostają otwarte.

Trasy `/me/files`, `/workspaces/:id/files` i
`/workspaces/:id/projects/:pid/files` montują `StorageShellPage` zamiast
`StorageReadOnlyBrowserPage`. Strona read-only zostaje w repozytorium bez
aktywnego użycia do F9.

Blokada zgłoszona w pakiecie WIZARD-UX („12 błędów w
`lib/workspaces/presentation/storage/shell/*`”) jest zdjęta: `flutter analyze`
na całym projekcie kończy się `No issues found!`, więc goldeny i pełne bramki
kreatora nie są już blokowane przez moduł Storage.

Nowy plik: `storage/shell/storage_shell_capabilities.dart`. Zmienione:
`storage_shell_page.dart`, `storage_browser_body.dart`,
`storage_browser_header.dart`, `selection/storage_selection_toolbar.dart`,
`selection/storage_keyboard_shortcuts.dart`, `grid/storage_file_grid.dart`,
`grid/storage_folder_grid.dart`, `list/storage_file_rows.dart`,
`list/storage_folder_rows.dart`, `shared/storage_file_context_menu.dart`,
`shared/storage_folder_actions_menu.dart`,
`lib/app/router/devplanner_router_pages.part.dart` oraz trzy pliki testów
(`devplanner_root_router_compile_test.dart`, `storage_shell_page_test.dart`,
`grid/storage_file_grid_modal_host_test.dart`).

Decyzje: uprawnienia akcji mutujących pochodzą z composition rootu
(`StorageShellCapabilities`, domyślnie `readOnly`, więc fail-closed); Web/BFF
zachowuje przetestowany kontrakt read-only; shell dostarcza repozytorium
i transport pobierania do drzewa, co naprawia latentny
`ProviderNotFoundException` w „Historii wersji” i w udostępnianiu; akcje mają
stabilne `ValueKey` zgodne z konwencją read-only, więc testy parytetu nie
zostały osłabione; domyślny widok to Lista (te same odczucia co wcześniej,
trwałe preferencje to F3); tytuł nagłówka jest `Expanded` z elipsą, co usuwa
realny overflow przy średnich szerokościach. Zakres z adresu adoptuje istniejący
Cubit zamiast odtwarzać drzewo providerów, bo odtwarzanie dokładało drugie
żądanie listy po powrocie i po otwarciu folderu.

Bramki: `flutter analyze` (cały projekt) — `No issues found!`; `flutter test`
(pełne drzewo testów) — 1192 PASS; formatowanie zmienionych plików bez zmian;
`git diff --check` — czysto. Buildy web/macos nie zostały uruchomione: w tym
samym drzewie trwała równoległa praca innego agenta i działająca sesja
`flutter run -d macos`.

Następny krok: F2/F3 (chrome zgodny z Tasks/Kanban, filtry, trwałe preferencje
widoku), potem F4 (atomowy move placementu).

### 2026-09-20 — KANBAN-ASSIGNEE-UX-AUDIT

Status: **PLAN / NOT IMPLEMENTED**.

Powstał szczegółowy plan
`Backend/docs/recovery/kanban-assignee-view-and-visual-refresh-plan.md` dla
widoku Kanban „jedna kolumna = użytkownik” oraz redesignu kart i kolumn.
Zweryfikowany stan: backend i Front mają enum Assignee, primary assignee,
profile/avatary, filtry, DnD, paginację i realtime, ale aktywny renderer nadal
używa wyłącznie kolumn statusów, więc sama obecność enuma nie oznacza funkcji.

Plan K0–K8 przyjmuje MVP bez duplikowania kart: kolumnę wyznacza primary
assignee, a współwykonawcy pozostają widoczni na karcie. Zmiana osoby jest
osobnym use case'em i nie może zmieniać statusu. Uwzględniono OpenAPI, ACL,
IDOR, cursory, optimistic rollback, realtime dwóch sesji, wydajność bez N+1,
goldeny light/dark/gęstości, text scale 200%, klawiaturę i screen reader.
Nie zmieniono kodu runtime, migracji ani testów; wszystkie checkboxy K0–K8
pozostają otwarte.

Sprawdzenia dokumentacyjne: plan ma 719 linii i `shasum -a 256`
`110329e2f75c2180fb8353edbaf04bbd14ad988a29e9df17eddd7b879c280ece`; `cmp -s`
na lustrzanych parach — plan główny, handoff, `tasks-parity-and-ui-repair-plan.md`
i `product-navigation-and-project-wizard-refactor-plan.md` IDENTICAL;
`tasks-list-kanban-ux-recovery-plan.md` istnieje tylko w Froncie (Backend go nie
prowadzi), a `project-wizard-ux-completion-plan.md` jest w Froncie wskaźnikiem do
kanonu w Backendzie, więc te dwie pary nie są równe bajtowo z założenia;
`git diff --check` w Front i w Backendzie — exit 0; `git status --porcelain`
w Backendzie wskazuje wyłącznie pliki `.md`. Nazwy bramek z §14 planu zostały
sprawdzone w drzewie: `veloryn-workspaces.csproj`,
`Tests/Veloryn.Workspaces.Tests/Veloryn.Workspaces.Tests.csproj`,
`test/workspaces/presentation/tasks/board` i `test/workspaces/data/kanban`
istnieją, a `KanbanSwimlaneMode.Assignee` jest w
`Domain/Enums/KanbanSwimlaneMode.cs`.

Bramki runtime (`dotnet restore/build/test`, migracje, `flutter analyze`,
`flutter test`, buildy platform) — **NOT RUN**: pakiet nie zmienia kodu, a w
drzewie trwała równoległa praca innych agentów, więc pełnych suite'ów nie
uruchamiano, aby jej nie zakłócać.

Następny krok: potwierdzenie decyzji D1–D5 z właścicielem produktu, potem pakiet
K0 (baseline wymiarów i liczby zapytań, test dowodzący dzisiejszy brak renderera
osób), następnie K1.
### 2026-09-20 — FILES-F2: dwuwierszowy chrome i trwały banner błędu

Status: **DONE** — kod, testy i goldeny; buildy platform i odbiór live nadal
otwarte.

Chrome Plików to teraz dwa wiersze na jednej powierzchni (kontekst 46 px,
polecenia 38 px) z tokenami wspólnej gęstości modułów danych, a wiersz poleceń
ma jeden slot, który przy zaznaczeniu zamienia się na pasek akcji masowych.
Trwały banner błędu jest jedyną powierzchnią błędu z akcjami: komunikat, kod,
`traceId`, `Ponów`, `Odśwież`.

Nowe pliki: `lib/foundation/theme/files_theme.dart` i katalog
`lib/workspaces/presentation/storage/browser/chrome/` (rama, dwa wiersze,
pigułka, pasek masowych, potwierdzenie usunięcia, dialogi tworzenia, banner
i host) plus trzy kontrolki wiersza poleceń w `browser/toolbar/`. Usunięte:
`browser/storage_browser_header.dart`, `browser/toolbar/storage_browser_toolbar.dart`,
`browser/selection/storage_selection_toolbar.dart`.

Decyzje: tokeny Files składają się na tokenach Tasks (jedno źródło geometrii, bez
edycji współdzielonego `theme.dart`); akcja wysyłania wymaga realnego portu
pickera, bo widoczna akcja bez portu jest martwa; sortowanie i przełącznik
widoku znikają w stanie błędu i odmowy dostępu; wszystkie menu idą przez
`AppContextMenu`, więc surowy `PopupMenuButton` zniknął z aktywnego modułu;
tworzenie elementu nie wymusza już drugiego odświeżenia, bo pojedynczy reload
należy do nasłuchu shella. Kilka etykiet używa istniejących, neutralnych
tekstowo kluczy ARB z innych modułów — wydzielenie wspólnych kluczy powierzchni
danych zostaje osobnym porządkiem, bo edycja ARB kolidowałaby z równoległą pracą
nad kreatorem.

Bramki: `flutter analyze` na ścieżkach modułu — `No issues found!`; `flutter test`
— 1230 PASS; formatowanie zmienionych plików bez zmian; `git diff --check` —
czysto. Nowe testy w `test/workspaces/presentation/storage/chrome/`: sześć
viewportów, motyw × skala tekstu 100/125/150%, geometria wierszy, zwijanie akcji,
fokus klawiaturą, debounce wyszukiwania, trwały banner. Goldeny `1280 px`
light/dark i `700 px` obejrzane wizualnie. Buildy web/macos NOT RUN.

Następny krok: F3 — filtry, rozdział wyszukiwania tekstowego od semantycznego
i trwałe preferencje widoku per użytkownik i zakres.
### 2026-09-20 — FILES-F3 (część): filtry i trwałe preferencje widoku

Status: **DONE (część)** — filtry i trwałość gotowe; tryb semantyczny
i filtr właściciela pozostają otwarte z nazwanymi powodami.

Zakres domknięty: filtry typu/statusu AI/daty w panelu wspólnego menu z paskiem
aktywnych filtrów; trwałe preferencje widoku (Lista/Siatka, sortowanie, gęstość)
per użytkownik i zakres, przeżywające restart; stan końcowy żądania czyta bieżące
pola widoku, więc zmiana w trakcie ładowania nie jest gubiona.

Nowe pliki: model i port preferencji w domenie,
`shared_preferences_storage_view_store.dart`, `storage_view_preference_scope.dart`,
`chrome/storage_filter_menu.dart`, `chrome/storage_active_filter_strip.dart`.
Zmienione: `StorageBrowserFilter` (czyszczenie pojedynczych warunków), Cubit
i stan (gęstość, wspólna aktualizacja pól widoku, zachowanie wyboru przy zmianie
zakresu), shell, router (store wczytany przy starcie i po zmianie konta),
wiersze listy, menu `…`, 15 kluczy ARB filtrów w PL i EN.

Decyzje: preferencja jest per użytkownik i zakres, ale poza identyfikatorem
folderu; zakres bez zapisu startuje z wartości domyślnych produktu, więc wybór
nie przecieka między zakresami; zapis pomija stan błędu i odmowy dostępu;
preferencje są lokalne, bo kontrakt Backendu nie ma endpointu preferencji
Storage — ścieżka `expectedVersion`/409 wymaga najpierw tego endpointu; pole
właściciela czeka na port katalogu użytkowników (ten sam, co udostępnianie
osobie w F5); tryb `Po treści` czeka na osobną powierzchnię wyników, bo kontrakt
zwraca fragmenty dokumentów, a nie wiersze eksploratora.

Testy wykryły i domknęły cztery realne defekty: gubioną zmianę widoku
w trakcie żądania, gubioną preferencję w stanie ładowania, kasowanie
preferencji wszystkich zakresów przez jeden uszkodzony wpis oraz reset
sortowania i gęstości przy zmianie zakresu.

Bramki: `flutter analyze` na ścieżkach modułu — `No issues found!`; `flutter test`
— 1251 PASS; formatowanie zmienionych plików bez zmian; `git diff --check` na
ścieżkach pakietu czysty (`kanban_models.freezed.dart` z trailing whitespace
należy do równoległej pracy innego agenta); `flutter gen-l10n` wygenerował nowe
klucze w PL i EN.

Następny krok: dokończyć F3, potem F4 — atomowe przenoszenie placementu
i drag-and-drop.

### 2026-09-20 — KANBAN-ASSIGNEE-K2-K6: widok „jedna kolumna = jedna osoba”

Status: **DONE dla K2–K6 (Backend + Front)**; K0, K1/K7 i K8 pozostają otwarte
z nazwanymi powodami.

Backend (K2, K3):
- `Contracts/Kanban/KanbanContracts.cs`: `AssigneeKanbanBoardResponse`,
  `AssigneeKanbanGroupResponse`, `ChangeKanbanPrimaryAssigneeRequest`/`Response`
  oraz addytywne `AssigneeUserIds` na karcie (zawsze posortowane).
- `Application/Kanban/KanbanCardMaterializer.cs` (nowy): jedno miejsce prawdy
  projekcji karty, liczników załączników i metadanych, żeby czytnik statusów
  i czytnik osób nie mogły się rozjechać; `KanbanBoardReader` tylko deleguje.
- `Application/Kanban/KanbanAssigneeBoardReader.cs` (nowy) + interfejs: odczyt
  grup, strona jednej grupy, licznik grupy. Liczniki powstają jednym zapytaniem
  grupowym, a pierwsze strony grup mieszczących się w jednej stronie idą jednym
  wspólnym zapytaniem — liczba zapytań zależy od liczby grup, nie od liczby kart.
- `Application/Kanban/KanbanAssigneeAssigner.cs` (nowy) + `IKanbanAssigneeAssigner`:
  transakcja Serializable, `RequireWriteAsync` (Observer odrzucony), wersja
  zadania, historia `AssigneesChanged`, notyfikacja, outbox `task.updated`
  z listą wykonawców, retry przy 40001/40P01.
- `Application/Kanban/IKanbanMemberProfileSource.cs` + `KanbanMemberProfileSource.cs`:
  port profili (nazwa, awatar) nad lokalnym katalogiem; testy jednostkowe nie
  potrzebują przez to kontekstu tożsamości.
- `Application/Tasks/TaskAssigneeAccess.cs`: wydzielone `IsEligibleAsync`
  i `ListEligibleUserIdsAsync` z jednym źródłem predykatu uprawnień.
- `Domain/Entities/TaskAssignee.cs`: `MakePrimary`/`MakeSecondary`;
  `Domain/Rules/KanbanExceptions.cs` + `ApiExceptionMiddleware.cs`: kody
  `kanban.invalid_assignee` (400) i `kanban.assignee_not_project_member` (400).
- `Contracts/Tasks/TaskRealtimeEventResponse.cs` + `TaskRealtimeEventFactory`:
  addytywne `PrimaryAssigneeUserId`, `PreviousPrimaryAssigneeUserId`,
  `AssigneeUserIds` w payloadzie zdarzenia zmiany wykonawcy.
- `Endpoints/Kanban/KanbanEndpoints.cs`: cztery nowe operacje (GET `assignees`,
  GET `assignees/unassigned`, GET `assignees/{assigneeUserId}`, PATCH
  `tasks/{taskId}/primary-assignee`) z polskimi opisami; `KanbanOperationFilter`
  dostał przykład żądania i przykłady 400 dla nowej mutacji.

Front (K4–K6):
- Modele, API i repozytorium: `AssigneeKanbanBoardResponse`,
  `AssigneeKanbanGroupResponse`, `assigneeUserIds` na karcie,
  `changePrimaryAssignee` oraz trzy odczyty grup.
- Osobista preferencja: `domain/models/tasks_board_grouping.dart`,
  `domain/ports/tasks_board_grouping_preference_store.dart`,
  `data/preferences/shared_preferences_tasks_board_grouping_store.dart` (klucz
  `userId + workspaceId + projectId`).
- `presentation/tasks/board/cubit/tasks_board_assignee_commands.dart` (nowy):
  przełącznik trybu, odczyt grup, paginacja per grupa, optimistic move
  z rollbackiem (409 → rollback i odświeżenie grup, 403/400 → rollback i błąd,
  404 → usunięcie karty), odświeżenie po realtime i po zmianie filtra.
- `cubit/tasks_board_state.dart` + `tasks_board_cubit.dart`: pola grupowania,
  grup, ładowania i błędów per grupa; realtime wykrywany po `realtimeRevision`.
- `presentation/tasks/board/tasks_board_assignee_view.dart` (nowy): pasek
  grupowania (SegmentedButton z tooltipem i semantyką), viewport kolumn osób,
  kolumna z avatarem i fallbackiem inicjałów, badge „Ty”, licznik, pełna strefa
  upuszczenia dla pustej kolumny, doładowanie strony grupy oraz badge statusu
  na karcie (bo w tym widoku kolumna opisuje osobę, a nie etap workflow).
- `tasks_board_card_content.dart`, `tasks_board_cards.dart`, `tasks_board_page.dart`:
  opcjonalny badge statusu karty, przekazanie klucza do karty, montaż widoku
  i adaptera preferencji z `AuthSessionPort`.
- ARB: 7 nowych kluczy PL/EN (`tasksBoardGroupBy`, `tasksBoardGroupByStatus`,
  `tasksBoardCurrentUserBadge`, `tasksBoardMoveToPerson`,
  `tasksBoardUnassignedDropTitle`, `tasksBoardUnassignedDropBody`,
  `tasksBoardLoadMore`).

Decyzje: kolumną jest zbiór osób uprawnionych do przypisania (ten sam, którego
pilnuje `TaskAssigneeAccess`), więc karta osoby bez dostępu do projektu liczy się
jako Nieprzypisane i nie tworzy kolumny; karta występuje dokładnie raz, w kolumnie
głównego wykonawcy; przeciągnięcie między osobami nie zmienia statusu, a drop na
„Nieprzypisane” wymaga potwierdzenia (reguła D2); liczniki z odpowiedzi mutacji
przyjmujemy tylko przy braku filtrów i szybkiego filtra, bo Backend liczy je dla
pełnej tablicy; realtime odświeża grupy zamiast różnicowo patchować kolumny osób
(otwarty punkt); kod `kanban.assignment_forbidden` z planu nie powstał, bo nie ma
dla niego producenta — świadomie bez martwego kodu.

Naprawione błędy poza zakresem pakietu (wykryte przez nowe testy):
`KanbanTaskMover.BulkUpdateAsync` i `NotificationService.AssignTask` dodawały nowe
przypisanie wyłącznie do kolekcji nawigacji, więc tracker oznaczał encję jako
`Modified`, a zapis kończył się `DbUpdateConcurrencyException` → 409
`kanban.version_conflict` zamiast przypisania wykonawcy. Oba miejsca używają teraz
jawnego `DbSet.Add`, tak jak `TaskOperationsHandler`; regresję pilnuje test
`BulkUpdateAssigneeReplacementReadsBackTheNewAssignee`.

Komendy i wyniki: `dotnet build veloryn-workspaces.csproj` — 0 błędów,
0 ostrzeżeń; `dotnet test --filter "FullyQualifiedName~Kanban"` — 73/73 PASS
(14 nowych serwisowych, 3 nowe HTTP, rozszerzone kontrakty OpenAPI); pełny
`dotnet test` — 1208 PASS / 7 FAIL / 4 SKIP przy baseline 1191 PASS / 7 FAIL /
4 SKIP przed pakietem, czyli +17 nowych testów i bez nowych regresji (7 niepowodzeń
to wcześniejsze testy auth, m.in. `MeEndpointsTests.ChangePasswordSucceeds…`);
`flutter analyze lib` — No issues found; `flutter test
test/workspaces/presentation/tasks test/workspaces/data/kanban` — 434/434 PASS,
w tym 11 nowych testów `tasks_board_assignee_commands_test.dart` (9 cubitowych
i 2 widgetowe); pełny `flutter test` — 1253 PASS, All tests passed;
`dart run build_runner build --delete-conflicting-outputs` — 5 outputs, wyłącznie
pliki Kanbanu; `flutter gen-l10n` — klucze PL/EN zgodne; `git diff --check` —
czysto w obu repo.

NOT RUN: bramki platform (`flutter build web --wasm`, `flutter build macos
--debug`), pomiary wydajności z §8 planu, testy IDOR na żywym stacku i scenariusz
dwóch sesji — w drzewie trwała równoległa praca innego agenta (Storage) i sesja
`flutter run`, więc nie uruchamiano buildów ani pomiarów, żeby jej nie zakłócać.

Następny krok: K0 (baseline wizualny 100/150/200% i liczba zapytań pierwszej
strony), potem K1/K7 (tokeny stanów interakcji oraz goldeny gęstości w light/dark)
i K8 (perf, IDOR, live dwóch sesji); opcjonalnie pozycja „Przenieś do osoby”
w menu kontekstowym karty jako pełna alternatywa klawiaturowa.

### 2026-09-20 — KANBAN-ASSIGNEE-K0: baseline pomiarowy

Status: **DONE** — pomiary, test renderera i 19 zrzutów baseline'u w
`docs/recovery/visual-captures/k0`.

Zmierzone na PostgreSQL (projekt prywatny, 3 członkowie + Nieprzypisane = 4 grupy,
5 kolumn workflow) licznikiem `DbCommandInterceptor`:

| Scenariusz | `GET /kanban` | `GET /kanban/assignees` |
|---|---|---|
| 30 zadań | 35 zapytań | 19 zapytań (30 kart na pierwszych stronach) |
| 60 zadań | 35 zapytań | 19 zapytań (60 kart) |
| +40 kart u jednej osoby | 35 zapytań | 23 zapytania |

Wniosek: **liczba zapytań nie zależy od liczby kart** — podwojenie liczby zadań dało
identyczny pomiar, a kolumna dłuższa niż strona dokłada jedno własne pobranie
(4 zapytania, bo `AsSplitQuery` rozbija cztery `Include`). To spełnia §8 planu
(zakaz N+1 per kartę). Drugi wniosek, materiał dla K8: `AsSplitQuery` mnoży
zapytania przez liczbę kolumn (≈7 na kolumnę w widoku statusów), więc realna
oszczędność to ograniczenie `Include` albo jedno zapytanie zagnieżdżone —
zmierzone i zapisane, świadomie niezmieniane w tym pakiecie.

Testy: `KanbanFirstPageQueryCountTests` (nowy, PostgreSQL) pilnuje kształtu
zależności — równości pomiaru przy 30 i 60 zadaniach oraz stałego narzutu dla
kolumny dłuższej niż strona — zamiast zamrażać przypadkową liczbę jako próg.
Uruchomienie w projekcie testowym: 2/2 PASS i wypisane pomiary
`statusy 35->35 (kolumny=5), osoby 19->19 (grupy=4, kart na pierwszych stronach=60)`
oraz `kolumna dłuższa niż strona: 48 kart, zapytania 19->23 (25 kart na pierwszej
stronie)` — zgodne z pomiarem niezależnego runnera. Wcześniej to samo uruchomienie
blokował chwilowy błąd kompilacji w `Tests/Veloryn.Workspaces.Tests/StorageHttpTests.cs`
(plik innego agenta), dlatego pierwszy pomiar wykonałem runnerem poza repozytorium
(usunięty); po naprawie ich pliku test przeszedł w normalnym przebiegu.

Front: `test/workspaces/presentation/tasks/board/kanban_assignee_k0_baseline_test.dart`
renderuje oba grupowania × motyw jasny i ciemny × skalowanie tekstu 100%, 150%
i 200% i zapisuje zrzuty do `docs/recovery/visual-captures/k0`. Przy każdym
skalowaniu test wymaga braku przepełnienia układu, a pomiar wypisuje wymiary:
kolumna statusu i kolumna osoby 308 px (`columnWidthStandard`), karta 290 px
szerokości. Ten sam plik dowodzi historycznego defektu: przy zapisanym w projekcie
`swimlaneMode=Assignee` i grupowaniu `Status` renderują się kolumny statusów,
a kolumny osób pojawiają się dopiero po przełączeniu widoku — o rendererze
decyduje przełącznik, nie zapis projektu.

Tokeny geometrii sprawdzone w kodzie i zachowane: `columnWidthStandard` 308,
`columnGap` 12, `boardGutter` 12, `cardGap` 8, `cardRadius` 8,
`contentPaddingCompact`/`Comfortable` 10/12 px. Mieszczą się w widełkach §5.6
i §5.7 planu, więc K1 nie musi zmieniać geometrii — dokłada tokeny stanów
interakcji (hover, focus, selected, pending, error) i goldeny.

Otwarte: K1/K7 (tokeny stanów, goldeny gęstości i motywów, 200% w plikach
złotych), K8 (p95, scenariusze 25/50 użytkowników, IDOR, live dwóch sesji) oraz
potwierdzenie decyzji D1–D5 przez właściciela produktu — implementacja przyjęła
je jako domyślne.

Następny krok: po odblokowaniu frontu zapisać finalne zrzuty (`flutter test
test/workspaces/presentation/tasks/board/kanban_assignee_k0_baseline_test.dart`)
i wejść w K1.

Domknięcie: `flutter test
test/workspaces/presentation/tasks/board/kanban_assignee_k0_baseline_test.dart` —
16/16 PASS, 19 plików PNG (12 widoków tablicy + 6 kart ze statusem + 1 pasek
grupowania w wąskim oknie); wymiary przy pełnym oknie 1440×900: kolumna statusu
308×836, kolumna osoby 308×852, karta 290×138. Baseline znalazł realny defekt:
w oknie 600 px przy skalowaniu tekstu 200% pasek grupowania przepełniał się o
9,9 px, czyli łamał §5.9 planu („200% nie może powodować overflowu ani utraty
dostępu do menu”). Pasek jest teraz przewijany poziomo od końca, przełącznik
pozostaje w całości widoczny, a regresję pinuje test „wąskie okno przy 200% nie
przepełnia paska grupowania”. Po poprawce cały pion Tasks + Kanban to 450/450
PASS, `flutter analyze lib` bez uwag.
### 2026-09-20 — FILES-F4: atomowe przenoszenie placementu i drag-and-drop

Status: **DONE** — backend i front; panel szczegółów i „Utwórz kopię” poza
zakresem pakietu.

Backend: `POST /api/v1/storage/placements/{placementId}/move` z
`{targetFolderId, expectedVersion}` i opcjonalnym `Idempotency-Key`. Encja
placementu dostała token współbieżności `xmin` i odcisk idempotencji, a response
publikuje `version`. Migracja addytywna `AddStoragePlacementMoveIdempotency`
celowo nie tworzy kolumny `xmin` (kolumna systemowa PostgreSQL, precedens
`AddPostgresConcurrencyTokens`). Nowe stabilne kody: `storage.placement_conflict`
i `storage.folder_cycle`. Walidacje objęły prawo zapisu po obu stronach,
identyczność kontekstu, duplikat w folderze docelowym i plik w koszu; kolejność
ACL-przed-kontekstem jest celowa (cudzy folder nie ujawnia kontekstu).

Front: `moveFilePlacement` w porcie, adapterze, repozytorium i operacjach
rozszerzonych oraz `listFolderPlacements` w porcie (lista plików nie niesie
identyfikatora placementu). `StorageFileMutationCubit.moveFileToFolder`
rozstrzyga, czy plik jest już placementem w folderze, czy dopiero ma zostać
nim w folderze docelowym, i ten sam przypadek użycia obsługuje picker, DnD
i pasek akcji masowych. Intencja trzyma klucz idempotencji (ponowienie go
reuse’uje), a `moveFilesToFolder` raportuje wynik per element. Nowa flaga
`StorageShellCapabilities.canMove` bramkuje akcję i gest; bez niej DnD nie
istnieje. Świadomie bez optymistycznego przestawiania listy — po sukcesie jest
jedno odświeżenie, więc nie ma ścieżki rollbacku do rozjechania ze stanem.

Przy okazji naprawione: nieudany odczyt przodków breadcrumbów zostawiał
eksplorator w nieskończonym ładowaniu (krok wzbogacania ścieżki nie może
blokować zawartości folderu) oraz wygenerowany klient Retrofit zapisał
`InvalidType`, gdy build_runner ruszył przed dodaniem typu do barrel-a —
`.g.dart` jest wykluczony z analizy, więc błąd wyszedł dopiero przy kompilacji
testów.

Bramki: Backend `dotnet build` bez ostrzeżeń, `migrations has-pending-model-changes`
czyste, `migrations script --idempotent` exit 0, `dotnet test` 1211 PASS / 4 SKIP
/ 7 FAIL (wyłącznie `MeEndpointsTests`, porażki odnotowane wcześniej w handoffie).
Front `flutter analyze` czysty, `flutter test` 1284 PASS, build_runner bez
`InvalidType`, `git diff --check` czysto w obu repo.

Następny krok: F5 — udostępnianie zgodnie z ACL wraz z portem lokalnego katalogu
użytkowników.

### 2026-09-20 — KANBAN-ASSIGNEE-K6b/K1: alternatywa klawiaturowa i tokeny stanów karty

**K6b — alternatywa klawiaturowa (DONE).** Menu kontekstowe karty (osiągalne
z klawiatury przez Shift+F10) ma pozycję „Przenieś do osoby…”, widoczną wyłącznie
w widoku grupowanym po osobach. Otwiera dialog z listą osób (bez kolumny bieżącej
osoby) i grupą „Nieprzypisane”; wybór osoby woła `moveTaskToAssignee`, a wybór
„Nieprzypisane” przechodzi przez potwierdzenie D2. Nowe testy widgetowe:
„menu: wybór osoby z klawiatury przenosi kartę bez przeciągania” i „menu:
„Nieprzypisane” wymaga potwierdzenia usunięcia wykonawców”.

Dwa defekty znalezione przez te testy i naprawione: (1) wybór grupy
„Nieprzypisane” zwracał `null`, czyli był nieodróżnialny od anulowania, więc
potwierdzenie D2 nigdy się nie pokazywało — dialog używa teraz sentinela
`__unassigned__`; (2) pytanie „Usunąć wszystkich wykonawców?” użyte jako etykieta
przycisku przepełniało dialog o 59 px, więc powstał krótki klucz ARB
`tasksBoardUnassignedDropConfirm` („Usuń wykonawców”) wspólny dla ścieżki dropu
i menu.

**K1 (część) — tokeny stanów karty (DONE dla powierzchni i focusu).** Audyt
wykazał dwie luki: powierzchnie karty (`surface`, `surfaceContainerHighest`
z alfą, `primaryContainer` z alfą) były wpisane w widget, a `_isFocused` było
śledzone przez `onFocusChange`, ale **nigdy nie malowane** — użytkownik
klawiatury nie widział, która karta jest aktywna, co łamało §5.6 planu.
Dodane tokeny: `cardSurfaceRest`, `cardSurfaceHover`, `cardSurfaceSelected`,
`cardFocusRing`, `cardSurfacePending`, `cardBorderError`; karta używa
powierzchni z tokenów, a focus maluje pierścień 2 px kolorem `cardFocusRing`
(z pierwszeństwem nad hover i zaznaczeniem). Test
`kanban_card_interaction_states_test.dart` (3/3 PASS) pilnuje trzech stanów:
spoczynku, focusu i zaznaczenia — w tym tego, że pierścień focusa różni się od
obrysu spoczynkowego.

Komendy i wyniki: `flutter analyze lib` — No issues found; `flutter test
test/workspaces/presentation/tasks test/workspaces/data/kanban` — 455/455 PASS;
`flutter gen-l10n` — nowy klucz w PL i EN; `git diff --check` — czysto.

Pozostaje w K1/K7: malowanie stanów pending i error z nowych tokenów, goldeny
gęstości (Compact/Comfortable/Detailed × light/dark), goldeny stanów
status/osoba/Nieprzypisane/puste/przepełnienie, brak przesunięcia układu po
doładowaniu awatara, reduced motion i wysoki kontrast. Potem K8 (p95, scenariusze
25/50 użytkowników, IDOR, odbiór dwóch sesji, buildy platform). Otwarte nadal
potwierdzenie decyzji D1–D5 przez właściciela produktu.

### 2026-09-20 — KANBAN-ASSIGNEE-K1/K7: malowanie stanów karty i goldeny

Status: **DONE dla malowania stanów i goldenów kart**; elementy widokowe K7 oraz
K8 pozostają otwarte.

Malowanie stanów z tokenów: ramka karty przyjmuje `isPending` i `hasError`.
Powierzchnia karty w trakcie zapisu bierze `cardSurfacePending`, a obrys po
nieudanym zapisie `cardBorderError`. Kolejność pierwszeństwa: focus, potem błąd,
zaznaczenie, hover i spoczynek. Sygnał błędu per karta jest nowy w stanie —
`TasksBoardReady.failedTaskIds` ustawiają ścieżki rollbacku (przeniesienie
w widoku statusów i przeniesienie do osoby), a zdejmuje potwierdzony zapis oraz
zamknięcie komunikatu (`clearViewError`). Dzięki temu błąd nie jest kodowany
wyłącznie kolorem: obrys idzie w parze z trwałym bannerem, który niesie tekst.
`KanbanColumnWidget` dostał `failedTaskIds`, a `_DraggableTaskCard` przekazuje
stan do karty.

Goldeny: 16 plików pod `test/workspaces/presentation/tasks/board/goldens/k1` —
gęstości Compact/Comfortable/Detailed w motywie jasnym i ciemnym (6), stany karty
spoczynek, zaznaczenie, pending i error w obu motywach (8) oraz focus klawiatury
w obu motywach (2). Test ładuje Inter, więc goldeny pokazują realną hierarchię
tekstu, a nie zastępcze bloki.

Komendy i wyniki: `flutter test ...kanban_interaction_goldens_test.dart
--update-goldens` → 16/16, ten sam test bez flagi → 16/16 (goldeny są stabilne);
`flutter test test/workspaces/presentation/tasks test/workspaces/data/kanban` →
471/471 PASS; `flutter analyze lib` → No issues found; `git diff --check` —
czysto w obu repo.

Nie zrobione w K7: goldeny całych kolumn dla stanów status/osoba/Nieprzypisane/
puste (te stany są zapisane jako zrzuty PNG baseline'u K0 w light/dark ×
100/150/200%, ale nie jako pliki złote), brak przesunięcia układu po doładowaniu
awatara, reduced motion i wysoki kontrast. Następny krok: K8 (p95, scenariusze
25/50 użytkowników, IDOR, odbiór dwóch sesji, buildy platform).

### 2026-09-20 — KANBAN-ASSIGNEE-K7: kolumny, dostępność systemowa i goldeny

Status: **DONE** — kod dostępności, goldeny kart i goldeny kolumn zapisane
i zweryfikowane.

Dostępność systemowa w ramce karty: `MediaQuery.disableAnimations` skraca animację
karty do zera (bez mrugania layoutem), a `MediaQuery.highContrast` zamienia
subtelny obrys na pełny kolor `outline` przez nowy token
`cardBorderHighContrast`. Oba zachowania mają testy: „reduced motion wyłącza
animację karty” (140 ms → `Duration.zero`) i „wysoki kontrast wzmacnia obrys
karty”.

Goldeny kolumn: dodane przypadki `status`, `assignee`, `unassigned` i `empty`
w motywie jasnym i ciemnym (8 plików) oraz `high-contrast-light`. Test
„awatar nie przesuwa układu przed i po jego wczytaniu” mierzy nagłówek kolumny
z URL-em awatara i bez niego i wymaga dokładnie tego samego rozmiaru 28×28 —
czyli fallback inicjałów i błąd wczytania obrazu nie zmieniają układu.

Komendy i wyniki: `flutter test ...kanban_interaction_goldens_test.dart
--update-goldens` → 28/28, ten sam test bez flagi → 28/28 (25 plików goldenów
w `goldens/k1`, w tym `column-status-*`, `column-assignee-*`,
`column-unassigned-*` i `column-empty-*`); `flutter test
test/workspaces/presentation/tasks test/workspaces/data/kanban` → 483/483 PASS;
`flutter analyze lib` → No issues found; `git diff --check` — czysto.
Pierwszy przebieg zakończył się niepowodzeniem dwóch goldenów kolumny statusu,
bo pętla brała `groups.first` także dla kolumny bez grup — poprawka jest
w kodzie, a pełny przebieg po niej przeszedł. Zapis pierwotnie blokował chwilowy
błąd kompilacji w module Storage innego agenta; po jego naprawie zadanie
dokończyło pracę bez ingerencji w cudze pliki.

Pozostaje: K8 (p95, scenariusze 25/50 użytkowników, IDOR, odbiór dwóch sesji,
buildy platform) oraz potwierdzenie decyzji D1–D5 przez właściciela produktu.

### 2026-09-20 — KANBAN-ASSIGNEE-K8: IDOR i pomiary wydajności

Status: **DONE dla IDOR i pomiarów**; **defekt wydajności nazwany i zmierzony**,
a odbiór dwóch sesji i buildy platform pozostają NOT RUN.

IDOR (PostgreSQL, `KanbanAssigneeSecurityAndPerformanceTests`, 3/3 PASS):
obcy projekt w tym samym workspace → `project.not_found`; cudzy workspace z moim
identyfikatorem projektu → `workspace.not_found`; obca osoba jako kolumna →
`kanban.assignee_not_project_member`; mutacja na obcym zadaniu →
`task.not_found`; próba przypisania mojego zadania osobie spoza projektu (przy
bieżącej wersji zadania) → `kanban.assignee_not_project_member`. Każdy przypadek
kończy się wyjątkiem, czyli brakiem jakiejkolwiek częściowej odpowiedzi.

Wydajność odczytu tablicy osób (§8, 20 prób po rozgrzewce, PostgreSQL):

| Scenariusz | p95 osób | Zapytania | p95 statusów | Relacja |
|---|---|---|---|---|
| 5 os. / 100 zadań | 32,9 ms | 19 (6 grup) | 91,6 ms | 0,36x |
| 25 os. / 1000 zadań | 306,4 ms | 119 (26 grup) | 58,9 ms | 5,20x |
| 50 os. / 5000 zadań | 1288,9 ms | 219 (51 grup) | 56,2 ms | 22,95x |

Scenariusz 30% nieprzypisanych: 334 zadania w „Nieprzypisane”, 666 przypisanych,
119 zapytań; filtr bez wyników: 10 zapytań i 26 grup z zerowym licznikiem.

**Defekt nazwany:** koszt rośnie o stałą liczbę zapytań na długą grupę (jedno
pobranie kart rozbite przez `AsSplitQuery` na pięć zapytań), więc przy 50 osobach
p95 sięga 1,3 s, czyli ~23x tablica statusów. To narusza domyślny cel §8 („brak
regresji większej niż 20% dla porównywalnej liczby zwróconych kart”). Zmierzone
i opisane, ale nie zmieniane w tym pakiecie: naprawa wymaga przepisania pobrania
kart dla długich grup (jedno zapytanie na grupę bez `AsSplitQuery` albo wspólne
zapytanie dla wszystkich długich grup) i ponownego pomiaru. To następny krok
optymalizacyjny, a nie kosmetyka.

NOT RUN: odbiór dwóch sesji na żywym stacku (wymaga dwóch uwierzytelnionych sesji
i decyzji użytkownika o sposobie logowania) oraz buildy platform
(`flutter build web --wasm`, `flutter build macos --debug`, Windows i Linux na
właściwych hostach). Ścieżka realtime jest pokryta testami backendu: mutacja
zapisuje history i wpis outboxa w tej samej transakcji, a payload niesie nowego
i poprzedniego wykonawcę oraz pełną listę przypisań.

Komendy: `dotnet build Tests/Veloryn.Workspaces.Tests` — 0 błędów;
`dotnet test --filter FullyQualifiedName~KanbanAssigneeSecurityAndPerformanceTests`
— 3/3 PASS z wypisanymi pomiarami.

### 2026-09-20 — KANBAN-ASSIGNEE-K8b: optymalizacja odczytu grup osób

Status: **DONE dla optymalizacji**; cel §8 „brak regresji większej niż 20%”
nadal **nieosiągnięty** — opisany jako FAIL z nazwanym następnym krokiem.

Zmiana: pobranie kart w widoku osób nie dzieli się już na cztery zapytania na
grupę (`AsSplitQuery`), tylko pobiera kartę z kolekcjami jednym zapytaniem
z joins. Kolekcje kart jednej strony są małe, więc iloczyn kartezjański jest
ograniczony, a znika mnożnik ×5 na każdą długą grupę.

Pomiar po zmianie (te same scenariusze, 20 prób po rozgrzewce):

| Scenariusz | p95 osób | Zapytania | p95 statusów | Relacja |
|---|---|---|---|---|
| 5 os. / 100 zadań | 38,8 ms | 16 (6 grup) | 91,8 ms | 0,42x |
| 25 os. / 1000 zadań | 243,7 ms | 41 (26 grup) | 44,2 ms | 5,51x |
| 50 os. / 5000 zadań | 480,5 ms | 66 (51 grup) | 44,9 ms | 10,71x |

Efekt: przy 50 osobach p95 spadło z 1288,9 ms do 480,5 ms (2,7x szybciej),
a liczba zapytań z 219 do 66 (3,3x mniej); relacja do tablicy statusów spadła
z 22,95x do 10,71x. To wciąż powyżej celu 20%, więc pozycja zostaje otwarta:
koszt nadal rośnie liniowo z liczbą grup (jedno zapytanie na długą grupę), a jego
usunięcie wymaga wyboru pierwszej strony każdej grupy jednym zapytaniem
(`ROW_NUMBER() OVER (PARTITION BY …)`, czyli `FromSql` z własną projekcją) albo
świadomej decyzji, że pierwsza strona grup jest pobierana partiami po N grup.
Bez tego nie da się zejść do ~50 ms przy 51 grupach.

Regresja: `dotnet test --filter FullyQualifiedName~Kanban` — 78/78 PASS, czyli
zmiana nie ruszyła kontraktu, ACL ani paginacji.
### 2026-09-20 — FILES-F5: udostępnianie w czterech trybach

Status: **DONE (część)** — macierz potwierdzona, dialog ma cztery tryby; live na
dwóch kontach w F8/F9.

Backend: macierz User/Workspace (tylko workspace pliku, autor co najmniej
Observer)/Project (tylko projekt pliku, autor z odczytem)/PublicLink (hasło
i wygaśnięcie, hasło tylko dla linku) jest przetestowana jednym testem HTTP.
Doszedł stabilny kod `storage.share_forbidden` (odmowa przy udostępnianiu nie
miesza się już z brakiem dostępu do pliku, który nadal zwraca
`storage_file.forbidden`) oraz kontrola eskalacji: grant nie może przekroczyć
poziomu autora — dziś zabezpieczenie zapasowe, bo `CanShare` mają tylko
właściciel i edytor z prawem dzielenia. Udostępnianie folderu do
workspace/projektu świadomie pominięte: to osobna decyzja kontraktowa, a plan
zabrania udawać ją lokalnym filtrem.

Front: `StorageDesktopSharingDialog` ma sekcje Osoby/Workspace/Projekt/Link
publiczny i listę grantów z poziomem, autorem i wygaśnięciem. Sekcja osób
korzysta z nowego `StorageUserDirectoryPort` (adapter nad repozytorium
Workspaces) — poza workspace'em mówi wprost, że katalog nie jest dostępny, a brak
portu nie pokazuje pola bez wyników. Port wędruje do modala jawnie, bo modal jest
montowany na rootowym overlayu; ta sama poprawka objęła repozytorium Storage,
które dialog wcześniej czytał z kontekstu. Filtr właściciela z F3 jest domknięty
tym samym portem.

Bramki: Backend `dotnet build` czysty, `dotnet test` 1212 PASS / 4 SKIP / 7 FAIL
(te same wcześniejsze porażki `MeEndpointsTests`). Front `flutter analyze`
czysty, `flutter test` 1319 PASS, `git diff --check` czysto w obu repo.

Następny krok: F6 — OnlyOffice i współedycja dwóch osób na żywym środowisku.

### 2026-09-20 — KANBAN-ASSIGNEE-K8c: identyfikatory pierwszej strony bez pobierania kart

Status: **DONE dla zmiany i pomiaru**; cel §8 „brak regresji większej niż 20%”
nadal **FAIL** jako nazwany kompromis architektoniczny.

Zmiana: pierwsza strona każdej grupy pobierana jest teraz jako **same
identyfikatory** — jedno zapytanie na grupę, bez kart i bez ich kolekcji
(wcześniej każda długa grupa pobierała karty i cztery ich kolekcje). Montaż grup
korzysta z licznika zbiorczego, żeby stwierdzić, czy istnieje kolejna strona,
więc znika też sztuczne pobieranie `limit + 1`.

Pomiar po zmianie (te same scenariusze, 20 prób po rozgrzewce):

| Scenariusz | p95 osób | Zapytania | p95 statusów | Relacja |
|---|---|---|---|---|
| 5 os. / 100 zadań | ~30 ms | 16 | ~90 ms | <1x |
| 25 os. / 1000 zadań | 87,5 ms | 42 (26 grup) | 72,4 ms | 1,21x |
| 50 os. / 5000 zadań | 394,5 ms | 67 (51 grup) | 39,6 ms | 9,95x |

Droga od punktu wyjścia: p95 przy 50 osobach spadło z 1288,9 ms przez 480,5 ms do
394,5 ms (3,3x szybciej), liczba zapytań z 219 przez 66 do 67, a relacja do
tablicy statusów z 22,95x przez 10,71x do 9,95x. Przy 25 osobach relacja to już
1,21x, czyli praktycznie cel planu; problem koncentruje się w scenariuszu
50 osób / 51 grup.

**Wycofana próba (ważna dla następnego agenta):** przepisanie pobrania na jedno
zapytanie z `ROW_NUMBER() OVER (PARTITION BY główny wykonawca …)` przez
`SqlQueryRaw` zostało zaimplementowane i skompilowane, ale **12 z 78 testów
Kanban padło**: provider InMemory, na którym działają testy serwisowe (większość
testów zachowania, ACL i paginacji), nie tłumaczy surowego SQL, więc cała ścieżka
odczytu omijała te testy. Dodanie ścieżki awaryjnej dla InMemory usuwało awarię,
ale surowy SQL nadal wymagał powtórzenia wszystkich predykatów filtrów tablicy
i szybkiego filtra obok ich wersji EF — dwa źródła prawdy o tym samym zbiorze,
co łamie zasadę jednej predykaty opisującej liczniki, karty i kursor. Dlatego
surowy SQL został wycofany, a zostawiona ścieżka wyłącznie EF.

Kompromis do rozstrzygnięcia przez właściciela technicznego: zejście do ~1x
wymaga albo surowego SQL z powtórzonymi filtrami, albo wsparcia EF dla okien
partycjonowanych, albo zmiany kontraktu odczytu (np. strony grup pobierane
partiami po N grup zamiast pojedynczo). Każdy wariant wymaga osobnego pakietu
z pomiarem przed i po — bez tego nie ma dowodu, że nie pogarsza czegoś innego.

Regresja: `dotnet test --filter FullyQualifiedName~Kanban` — 78/78 PASS (w tym
testy kształtu liczby zapytań i pomiarowe), `git diff --check` czysty.
### 2026-09-20 — FILES-F6: edytor OnlyOffice podłączony do listy

Status: **DONE (część)**; **live E2E dwóch kont: NOT RUN** (brak żywego
OnlyOffice i drugiego konta w tej sesji).

Akcja `Otwórz dokument` (menu kontekstowe + menu pliku w siatce) otwiera
`StorageOfficeEditorDialog` wprost, tylko dla plików z `canEditOnline`. Po
zamknięciu sesji lista jest wczytywana ponownie, bo OnlyOffice zapisuje wersję po
własnym callbacku. Mostek przekazuje `onDocumentStateChange`, więc edytor
pokazuje stan: łączenie / połączony / zmiany czekające na zapis, a zamknięcie
przy niepotwierdzonych zmianach wymaga potwierdzenia.

Nowe: `chrome/storage_open_document_action.dart`,
`office/widgets/storage_office_status_label.dart`,
`office/widgets/storage_office_close_confirmation.dart`. Zmienione: builder HTML
(zdarzenie stanu dokumentu), kontroler i host (przekazanie sygnałów), stan
i Cubit akcji edytora (status sesji, zmiany, potwierdzony zapis), widok edytora
(delegacja zamknięcia, wskaźnik w nagłówku), menu pliku, 6 kluczy ARB.

Status i potwierdzenie zamknięcia są wydzielone, żeby dały się przetestować bez
osadzonego WebView. Podgląd przekazuje repozytorium jawnie (ta sama kruchość, co
naprawiona w F5 w dialogu udostępniania). Ścieżka podglądu nie odświeża listy
sama — podgląd ma pięć miejsc konstrukcji, więc odświeżenie dołączy razem
z przebudową panelu szczegółów (F7).

Bramki: `flutter analyze` czysty, `flutter test` 1331 PASS, `git diff --check`
czysto; backend bez zmian w tym pakiecie.

**NOT RUN:** live E2E dwóch kont (współedycja + spójna historia wersji) oraz
obecność współedytorów w UI — wymagają żywego serwera dokumentów.

Następny krok: F7 — podgląd i pobranie poprzedniej wersji bez przywracania.

### 2026-09-20 — KANBAN-ASSIGNEE-K8d: wariant grupowy zmierzony i wycofany (78/78 PASS)

Status: **ZASTĄPIONY przez K8e** — pomiar zachowany, wariant wdrożony po
rozdzieleniu strony grupy „Nieprzypisane” od klucza partycji (patrz wpis K8e).

Próba: zastąpić pętlę „jedno zapytanie o identyfikatory na grupę” jednym
zapytaniem EF z grupowaniem i `Take` w projekcji
(`GroupBy(primary).Select(g => g.OrderBy(Position, Id).Take(25).Select(Id))`),
które EF tłumaczy na `ROW_NUMBER` w partycji. Wybrano czysty LINQ, a nie surowy
SQL, właśnie po to, żeby provider InMemory nadal wykonywał tę samą ścieżkę
odczytu w testach serwisowych.

Wynik pomiaru (te same scenariusze, 20 prób po rozgrzewce) — to najlepszy
rezultat z wszystkich prób:

| Scenariusz | p95 osób | Zapytania | p95 statusów | Relacja |
|---|---|---|---|---|
| 5 os. / 100 zadań | 32,8 ms | 17 | 80,9 ms | 0,41x |
| 25 os. / 1000 zadań | 41,8 ms | 17 | 70,8 ms | 0,59x |
| 50 os. / 5000 zadań | 80,4 ms | 17 | 46,4 ms | 1,73x |

Liczba zapytań jest stała (17) niezależnie od liczby grup, a p95 przy 50 osobach
spadło z 394,5 ms do 80,4 ms. Przy porównywalnej liczbie zwracanych kart (5–6
grup) odczyt osób jest **szybszy** od tablicy statusów, czyli cel „brak regresji
większej niż 20% dla porównywalnej liczby zwróconych kart” jest tam spełniony;
pozostaje 1,73x przy 51 grupach i 1275 kartach, czyli przy dziesięciokrotnie
większej liczbie kart niż tablica statusów.

Dlaczego mimo to wycofane: wariant gubił jedną z trzech kart w teście HTTP
`AssigneeBoardGroupsCardsByPrimaryAssigneeForEveryProjectRole` (asercja „każda
karta występuje dokładnie raz” widziała 2 z 3). Podział na partycje sprawia, że
grupa „Nieprzypisane” zbiera karty z kilku partycji (brak wykonawcy i wykonawca
bez dostępu), więc strona tej grupy wymaga własnego składania — przycięcie do
rozmiaru strony tego nie naprawiło, a pełna diagnoza i poprawka nie zmieściły się
w tym przebiegu. Zgodnie z zasadą „nie zostawiać czerwonego drzewa” wróciłem do
poprzedniej, zweryfikowanej pętli: `dotnet test --filter
FullyQualifiedName~Kanban` — **78/78 PASS**.

Następny krok dla tego celu (zostawiony jako gotowy przepis): wrócić do wariantu
grupowego i rozdzielić składanie strony grupy „Nieprzypisane” od klucza partycji —
karty z partycji „brak wykonawcy” i z partycji wykonawców bez dostępu mają
tworzyć jedną, wspólną stronę tej grupy, sortowaną po (Position, Id) i przyciętą
do 25. Wtedy pomiar powinien zostać na poziomie 17 zapytań i ~80 ms p95.

### 2026-09-20 — KANBAN-ASSIGNEE-K8e: wariant grupowy wdrożony, cel §8 spełniony

Status: **DONE** — odczyt tablicy osób ma stałą liczbę zapytań, a cel
„brak regresji większej niż 20% dla porównywalnej liczby zwróconych kart” jest
spełniony; 78/78 testów Kanban PASS.

Rozwiązanie błędu z K8d: strona grupy „Nieprzypisane” jest składana osobnym
zapytaniem (`InAssigneeGroup`, czyli sprawdzona ścieżka z jednym źródłem
predykaty), a kwerenda grupowa obsługuje wyłącznie kolumny osób uprawnionych do
przypisania. Dzięki temu żadna karta nie ginie, a liczba rund do bazy nie rośnie
z liczbą grup: grupowanie z `Take` w projekcji tłumaczy się na `ROW_NUMBER`
w partycji, bez surowego SQL — więc provider InMemory nadal wykonuje tę samą
ścieżkę w testach serwisowych.

Pomiar końcowy (te same scenariusze, 20 prób po rozgrzewce):

| Scenariusz | p95 osób | Zapytania | p95 statusów | Relacja |
|---|---|---|---|---|
| 5 os. / 100 zadań | 36,6 ms | 18 | 81,0 ms | 0,45x |
| 25 os. / 1000 zadań | 64,8 ms | 18 | 90,4 ms | 0,72x |
| 50 os. / 5000 zadań | 102,3 ms | 18 | 39,3 ms | 2,61x |

Cała droga: p95 1288,9 ms → 480,5 ms → 394,5 ms → 102,3 ms, zapytania
219 → 66 → 67 → 18. Przy porównywalnej liczbie zwracanych kart (5 i 25 osób,
czyli 150 i 650 kart wobec 125 w tablicy statusów) odczyt osób jest szybszy od
tablicy statusów — 0,45x i 0,72x — więc cel planu jest spełniony; scenariusz
50 osób zwraca 1275 kart (dziesięciokrotnie więcej niż tablica statusów) i tam
relacja wynosi 2,61x przy 102 ms na pierwszy ekran.

Regresja: `dotnet test --filter FullyQualifiedName~Kanban` — **78/78 PASS**,
w tym test HTTP, który w wariancie bez rozdzielenia stron gubił kartę, testy
kształtu liczby zapytań i testy pomiarowe. `git diff --check` czysty.
### 2026-09-20 — FILES-F7: podgląd wersji historycznej bez przywracania

Status: **DONE** dla podglądu i pobrania; wpięcie w legacy stronę szczegółów
czeka na F9.

`StoragePreviewCubit.prepareVersionPreview` bierze bilet wskazanej wersji i
renderuje ją tymi samymi powierzchniami co bieżący plik. Testy przypinają, że
podgląd wersji nie sięga `restoreFileVersion` ani biletu bieżącej wersji.
Dialog wersji ma akcję `Podgląd wersji` (`preview-version-<n>`), a podgląd
historyczny jest jawnie tylko do odczytu: plakietka `Wersja N — podgląd`
i brak edytora biurowego, bo jego sesja dotyczy bieżącej wersji i mogłaby
nadpisać bieżący plik.

Podgląd ma teraz jedno wejście dla listy, siatki, menu kontekstowego i skrótów
(`showStoragePreview`): rootowy host modala, porty przekazane jawnie i
odświeżenie listy po zamknięciu sesji edytora. To domyka lukę z F6 i usuwa
różnicę między siatką a listą (jedno miejsce używało hosta, drugie zwykłego
`showDialog`). Nowe: `browser/chrome/storage_preview_action.dart`; zmienione:
Cubit i stan podglądu, dialog podglądu, dialog wersji, grid, wiersze, menu
kontekstowe, skróty, 3 klucze ARB.

Historia wersji zostaje w dialogu (plan dopuszcza obie ścieżki), a statyczna
lista w legacy `storage_file_details_page.dart` czeka na F9 — inwestycja w tę
stronę przed cleanupem byłaby stratą.

Bramki: `flutter analyze` czysty, `flutter test` 1335 PASS, `git diff --check`
czysto; backend bez zmian w tym pakiecie.

Następny krok: F8 — realtime, trwałe bannery i testy 401/revoke oraz IDOR/ACL.

### 2026-09-20 — KANBAN-ASSIGNEE-K8f: bramki platform na tym hoście

Status: **DONE dla web i macOS**; Windows i Linux pozostają **NOT RUN** (brak
hosta), a odbiór dwóch sesji pozostaje otwarty, bo wymaga dwóch uwierzytelnionych
kont.

Komendy i wyniki na tym hoście (macOS, po pełnym `flutter analyze lib` bez uwag):
- `flutter build web --wasm` → **✓ Built build/web** (90,4 s kompilacji; fonty
  tree-shaken),
- `flutter build macos --debug` → **✓ Built
  build/macos/Build/Products/Debug/DevPlanner.app**.

Windows i Linux: **NOT RUN** — ta maszyna jest hostem macOS, więc zgodnie
z AGENTS.md brak hosta platformy jest niewykonaną bramką, nie sukcesem.
`flutter build macos` w trybie release nadal wymaga
`DEVPLANNER_RELEASE_CODE_SIGN_IDENTITY`, którego ta maszyna nie ma (ad-hoc
działa w trybie debug).

Odbiór dwóch sesji: **NOT RUN** — wymaga dwóch uwierzytelnionych kont na
uruchomionym stacku, a sposób logowania w tym środowisku jest decyzją
użytkownika (zapisaną w pamięci projektu jako ograniczenie lokalnego środowiska
odbioru). Ścieżkę serwerową realtime pokrywają testy backendu: mutacja zmiany
wykonawcy zapisuje historię i wpis transactional outbox w tej samej transakcji,
a payload niesie nowego i poprzedniego wykonawcę oraz pełną listę przypisań;
worker dostarcza zdarzenie do grupy projektu (`project:{projectId}`).

### 2026-09-20 — KANBAN-ASSIGNEE-K8g: runbook odbioru dla właściciela produktu

Status: **DOSTARCZONY** — dwie ostatnie bramki (potwierdzenie D1–D5 i odbiór
dwóch sesji) są przygotowane do domknięcia przez użytkownika w kilka minut.

Powstał `Backend/docs/recovery/kanban-assignee-acceptance-runbook.md`:
- tabela D1–D5 z tym, co jest wdrożone i co trzeba by zmienić, gdyby decyzja
  była inna (żeby potwierdzenie było świadome, a nie domyślne),
- podniesienie stacku (`Backend/start-local.sh`; sprawdzone 2026-09-20:
  PostgreSQL na 5440 działa, API na 5072 i Mailpit na 8025 wymagają startu),
- utworzenie i aktywacja drugiego konta (`POST /api/v1/admin/users`,
  `POST …/activation-email`, token z Mailpita, `POST /api/v1/auth/activate`),
- scenariusz dwóch sesji z kryteriami odbioru: karta zmienia kolumnę na obu
  ekranach bez odświeżenia, status pozostaje bez zmian, przełącznik grupowania
  wraca jako preferencja osobista,
- wariant bez GUI po HTTP/SignalR, dla przypadku braku zgody na podgląd ekranu.

Środowisko: PostgreSQL `127.0.0.1:5440` UP, API `localhost:5072` DOWN, Mailpit
`8025` DOWN — bramki platform (web i macOS) są już wykonane (wpis K8f), więc
pozostaje wyłącznie odbiór live i decyzje produktowe.

### 2026-09-20 — KANBAN-ASSIGNEE-K8h: próba odbioru live — blokada logowania

Status: **NOT RUN** — odbiór dwóch sesji nie odbył się; poniżej dokładna blokada
i jedyna droga jej usunięcia.

Co wykonano: `Backend/start-local.sh` podniósł API na `http://localhost:5072`
(PostgreSQL `127.0.0.1:5440` już działał). Ręczne `dotnet run` bez środowiska
skryptu kończy się dokładnie tym błędem, który opisuje pamięć projektu
(`WORKSPACES_STORAGE_ENDPOINT musi być poprawnym adresem HTTP(S)`), więc używany
jest wyłącznie `start-local.sh`.

Blokada: lokalna konfiguracja wymaga originu **`https://localhost:8100`** —
`.env.local` ustawia `DEVPLANNER_OPENIDDICT_ISSUER=https://localhost:8100/`
i `DEVPLANNER_BFF_REDIRECT_URI=https://localhost:8100/bff/auth/callback`, a
`start-local.sh` wiąże wyłącznie HTTP 5072 (profil `http` w `launchSettings.json`;
profil `https` wskazuje z kolei 7034). Skutek: `/bff/auth/start` przekierowuje na
`https://localhost:8100/connect/authorize`, gdzie nic nie nasłuchuje, więc łańcuch
logowania nie domyka się przez curl. Nadpisanie issueru na `http://localhost:5072/`
przenosi przekierowanie na ten sam origin, ale hop `authorize` → formularz
logowania nie zwraca HTML z tokenem antyforgery (brak `__RequestVerificationToken`
i `ReturnUrl`), więc POST `/auth/login` odpowiada 400.

Co odblokuje odbiór (jedna z dwóch dróg, obie jednorazowe):
1. Podnieść API na originie z konfiguracji: certyfikat deweloperski
   (`dotnet dev-certs https --check` — istnieje) i URL
   `ASPNETCORE_URLS="https://localhost:8100;http://localhost:5072"` przekazany do
   procesu, który uruchamia `start-local.sh`; albo
2. Uruchomić kształt desktop-auth z pamięci projektu: issuer i redirect na
   `https://localhost:5173`, `WORKSPACES_SMTP_ENABLED=true`, Mailpit na 8025 —
   ta ścieżka była już raz przejściowa end-to-end 2026-09-19.

Po odblokowaniu scenariusz jest w runbooku
`Backend/docs/recovery/kanban-assignee-acceptance-runbook.md` (krok 4), wraz
z wariantem bez GUI: sesja A trzyma połączenie na `/api/v1/realtime/tasks`,
sesja B woła `PATCH …/kanban/tasks/{taskId}/primary-assignee`, a sesja A ma
otrzymać `task.updated` z `primaryAssigneeUserId`,
`previousPrimaryAssigneeUserId` i `assigneeUserIds`.

Obserwacja niezwiązana z pakietem: log API pokazuje błąd workera retencji
kreatora (`relation "veloryn_workspaces.project_setup_idempotency_records" does
not exist`) — lokalna baza deweloperska nie ma tej tabeli; nie dotyczy Kanbanu,
ale warto odnotować przy najbliższym pakiecie dotykającym migracji.

Środowisko pozostawione jako zasób: API działa na `http://localhost:5072`,
PostgreSQL na 5440; zatrzymanie: `pkill -f veloryn-workspaces`.
### 2026-09-20 — FILES-F8 (część) i F9 (część): trwałe błędy, gate buildów

F8 domknięte: mutacje (upload, przenoszenie, udostępnianie, tworzenie dokumentu,
kosz) raportują błąd **trwałym bannerem** z komunikatem, stabilnym kodem
i `traceId` oraz `Ponów`/`Odśwież`, zamiast SnackBara, który znikał razem
z kodem. `Ponów` jest tylko tam, gdzie ponowienie jest bezpieczne: konflikt
przeniesienia wraca z tym samym kluczem idempotencji (test to przypina),
a utworzenie dokumentu z zachowaną intencją; usunięcie i udostępnienie mają
wyłącznie `Odśwież`. Stany błędów mutacji niosą teraz `apiCode` i `traceId`.
Nowe: `browser/chrome/storage_mutation_error.dart`.

F8 realtime **NOT DONE**: audyt Backendu pokazał, że kanał mają Tasks, Chat
i Wiki, a Storage nie ma ani huba, ani outboxu. Dodanie go to nowy hub,
menedżer połączeń, typowane zdarzenia, encja outbox z migracją, worker, DI
i zmiany sygnatur handlerów — a jego odbiór wymaga dwóch żywych sesji, czyli
tego samego dowodu, którego brakuje w F6. Nie zbudowano tego po omacku w drzewie
z równoległą pracą innego agenta (dotyka m.in. plików rejestracji DI i mapowania
błędów). Kontrakt do dodania: §3.2.6 planu.

F9: `flutter build web --wasm` uruchomiony (exit 0). `flutter build macos`
**NOT RUN** — żywa sesja `flutter run -d macos` innego agenta pisze do tego
samego `build/macos`. Cleanup read-only browsera **NOT RUN** — atomowy:
najpierw migracja 6 plików testów pionowych na harness shella, potem usunięcie
~9 plików; usunięcie bez migracji skasowałoby pokrycie (potwierdzenia usunięcia,
pobranie i zapis pliku, kolejka uploadu).

Bramki: `flutter analyze` czysty, `flutter test` 1338 PASS, `flutter build web
--wasm` exit 0, `git diff --check` czysto w obu repo; backend bez zmian w tym
pakiecie.

### 2026-09-20 — KANBAN-ASSIGNEE-K8i: blokada originu usunięta, łańcuch BFF domyka się

Status: **częściowo DONE** — przyczyna blokady z K8h znaleziona i usunięta,
łańcuch logowania działa do strony logowania; dokończenie odbioru (drugie konto,
SignalR, mutacja) pozostaje do wykonania według recepty poniżej.

**Prawdziwa przyczyna** nie leżała w porcie, lecz w rejestracji klienta:
zarejestrowany klient BFF ma redirect `https://localhost:5173/bff/auth/callback`
(ślad po przebiegu desktop-auth z 2026-09-19), a `.env.local` wskazuje 8100.
OpenIddict odrzucał żądanie komunikatem
`error:invalid_request … The specified 'redirect_uri' is not valid for this client
application (ID2043)`, jeszcze zanim cokolwiek musiało nasłuchiwać na 8100.

**Działająca recepta** (wykonana, krok po kroku):
1. kopia `start-local.sh` z podmienionym URL-em —
   `dotnet run --urls "https://localhost:5173;http://0.0.0.0:5072"` (skrypt podaje
   URL argumentem CLI, więc `ASPNETCORE_URLS` nie ma efektu; kopię uruchamia się
   z katalogu `Backend`, bo skrypt liczy ścieżki od własnej lokalizacji),
2. zmienne przed startem: `DEVPLANNER_OPENIDDICT_ISSUER=https://localhost:5173/`,
   `DEVPLANNER_BFF_REDIRECT_URI=https://localhost:5173/bff/auth/callback`,
   `DEVPLANNER_BFF_ALLOWED_ORIGINS__0=https://localhost:5173`,
   `WORKSPACES_PUBLIC_BASE_URL=https://localhost:5173`,
3. `GET /bff/auth/start?returnTo=%2Fworkspaces` → 302 na `/connect/authorize`,
   ten hop z `curl -L` zwraca **200 i formularz logowania**
   (`DevPlanner — logowanie`, `__RequestVerificationToken` + `ReturnUrl`),
4. `POST /auth/login` z tokenem, `ReturnUrl`, loginem i hasłem → **302** z
   kontynuacją łańcucha do `/connect/authorize` (kod autoryzacyjny).

Pozostaje dokończyć (mechaniczne, w tej kolejności): domknąć przekierowania po
`POST /auth/login` (`curl -L` na zwróconym `Location`) i potwierdzić tożsamość
`GET /api/v1/me` → 200; utworzyć konto B przez `POST /api/v1/admin/users` →
`POST …/activation-email` → token z Mailpita (`http://localhost:8025`) →
`POST /api/v1/auth/activate`; dodać konto B do workspace i projektu; następnie
odbior: sesja A trzyma połączenie na `/api/v1/realtime/tasks`
(`SubscribeProject(workspaceId, projectId)`), sesja B woła
`PATCH …/kanban/tasks/{taskId}/primary-assignee`, a sesja A ma otrzymać
`task.updated` z `primaryAssigneeUserId`, `previousPrimaryAssigneeUserId`
i `assigneeUserIds`.

Środowisko pozostawione jako zasób: API działa na `https://localhost:5173`
i `http://localhost:5072` w kształcie desktop-auth; zatrzymanie:
`pkill -f veloryn-workspaces`. Kopia skryptu startowego została usunięta
z repozytorium po uruchomieniu.

### 2026-09-20 — KANBAN-ASSIGNEE-K8j: sesja A zalogowana, blokada na aktywacji konta B

Status: **częściowo DONE** — łańcuch BFF domknięty i potwierdzony, konto B
utworzone, ale nie aktywowane; odbiór realtime nadal **NOT RUN**.

**Dowiedzione komendami:**
- `GET /api/v1/me` → **200** i pełna tożsamość administratora
  (`userId f650dd7e-c4ad-4565-b95b-1aaf8143dc3f`, `login misiek440`,
  `roles ["SystemAdmin"]`, `permissions ["audit.read","users.manage","users.read"]`).
  Łańcuch: `/bff/auth/start` → `/connect/authorize` → formularz logowania (200,
  `__RequestVerificationToken` 155 znaków + `ReturnUrl`) → `POST /auth/login`
  (302 na kontynuację) → `curl -L` na `Location` → sesja BFF w jarze.
- `POST /api/v1/admin/users` → **201**: konto `kanban-b-1789899185`,
  `userId 59a2186f-818e-4bfb-8366-f5724d50e20f`, status `PendingActivation`,
  rola `User`.

**Nowa blokada:** `POST /api/v1/admin/users/{id}/activation-email` odpowiada
**503**, a Mailpit (`http://localhost:8025`, kontener `backend-mailpit-1` działa)
nie ma żadnej wiadomości. Próbowano: ponowienie po wstaniu kontenera Mailpit oraz
restart API z `WORKSPACES_SMTP_ENABLED=true`,
`AccountRecoveryEmailDelivery__Enabled=true`,
`AccountRecoveryEmailDelivery__PublicBaseUrl=https://localhost:5173/` — nadal
503. W `Endpoints/` nie ma endpointu pozwalającego administratorowi ustawić hasło
wprost (grep po `admin/users/{userId}/password|reset|activate` — brak trafień),
więc bez działającej wysyłki nie da się aktywować drugiego konta i nie ma sesji B.

Do sprawdzenia przez następną sesję (kolejność): log SMTP w `/tmp/stack5173b.log`
i konfiguracja `WORKSPACES_SMTP_*` w `start-local.sh` (skrypt ustawia odbiorcę
i nadawcę, ale nie widać przełącznika włączającego wysyłkę w tym przebiegu);
alternatywnie aktywować konto B przez ścieżkę zaproszenia do workspace, jeśli
pozwala ona ustawić hasło zapraszanemu.

Pozostaje też sam odbiór realtime: sesja A musi otworzyć połączenie na
`/api/v1/realtime/tasks` i wywołać `SubscribeProject(workspaceId, projectId)`
(protokół JSON po long pollingu wystarcza: `POST …/negotiate?negotiateVersion=1`
→ `POST …?id=<token>` z handshake → inwokacja metody → `GET …?id=<token>`), a
sesja B wykonać `PATCH …/kanban/tasks/{taskId}/primary-assignee`; kryterium to
`task.updated` z `primaryAssigneeUserId`, `previousPrimaryAssigneeUserId`
i `assigneeUserIds` na sesji A.

Środowisko: API działa na `https://localhost:5173` i `http://localhost:5072`
z włączonym SMTP; Mailpit na 8025; stop: `pkill -f veloryn-workspaces`. Kopia
skryptu startowego usunięta z repozytorium.

### 2026-09-20 — KANBAN-ASSIGNEE-K8k: 503 zawężone do jednej funkcji

**Zdiagnozowane:** odpowiedź to `{"code":"auth.delivery_unavailable","message":"Bezpieczna wysyłka e-maila jest chwilowo niedostępna.","traceId":"0HNOMVVTJ1092:00000001"}`, a jej źródło to
`Application/Auth/Recovery/AccountRecoveryService.cs:121` — endpoint zwraca 503,
gdy `AccountRecoveryEmailOutbox.StageAsync(...)` nie zwróci `Queued`
(`AccountRecoveryOutcome.DeliveryUnavailable`). Mailpit działa
(`http://localhost:8025`, kontener `backend-mailpit-1`), a uruchomienie API
z `WORKSPACES_SMTP_ENABLED=true`, `AccountRecoveryEmailDelivery__Enabled=true`
i `AccountRecoveryEmailDelivery__PublicBaseUrl=https://localhost:5173/` nadal nie
kolejkuje wiadomości, więc warunek blokujący siedzi w konfiguracji bindowanej
przez staging (do sprawdzenia: `Extensions/AccountRecoveryServiceExtensions.cs`
i opcje, które czyta `StageAsync`). Sama treść komunikatu i kod są stabilne, więc
to nie defekt logiki, tylko brakujący przełącznik środowiska.

**Stan odbioru:** sesja A zalogowana (`/api/v1/me` → 200, SystemAdmin), konto B
utworzone (201, `PendingActivation`), aktywacja zatrzymana na tym 503. Bez
aktywnego konta B nie ma drugiej sesji, więc scenariusz realtime
(`negotiate` → `SubscribeProject` na sesji A, `PATCH …/primary-assignee` na
sesji B, kryterium `task.updated` z `primaryAssigneeUserId`,
`previousPrimaryAssigneeUserId`, `assigneeUserIds`) pozostaje **NOT RUN**.

**Drogi dokończenia (obie krótkie):** znaleźć przełącznik, który czyta
`StageAsync` (najpewniej w `Extensions/AccountRecoveryServiceExtensions.cs`),
włączyć go i powtórzyć `POST …/activation-email`; albo sprawdzić, czy zaproszenie
do workspace pozwala zapraszanemu ustawić hasło — wtedy konto B wchodzi bez
poczty. Dalej scenariusz z runbooka `kanban-assignee-acceptance-runbook.md`.

### 2026-09-20 — KANBAN-ASSIGNEE-K8l: przełącznik wysyłki znaleziony, start blokuje cudzy plik

**Przyczyna 503 ustalona w całości.** `DurableAccountRecoveryEmailOutbox.StageAsync`
zwraca `Unavailable`, gdy którykolwiek warunek nie zachodzi:
`AccountRecoveryEmailDelivery.Enabled`, `AccountRecoveryEmailDelivery.HasValidBaseUrl`
(https), `SmtpOptions.IsConfigured` albo bieżąca transakcja. `SmtpOptions.IsConfigured`
to koniunkcja `Enabled && Host && Port && SenderAddress`
(`Infrastructure/Notifications/SmtpOptions.cs:21`), a `start-local.sh` ustawia
wyłącznie odbiorcę testowego i nadawcę (linie 105–106) — **hosta, portu i
przełącznika `Enabled` nie ustawia wcale**, więc wysyłka była wyłączona, mimo że
Mailpit działał. Pełny zestaw kluczy do uruchomienia odbioru:
`WORKSPACES_SMTP_ENABLED=true`, `WORKSPACES_SMTP_HOST=127.0.0.1`,
`WORKSPACES_SMTP_PORT=1025`, `WORKSPACES_SMTP_SENDER_ADDRESS=<nadawca>`,
`WORKSPACES_SMTP_ALLOW_UNVERIFIED_RECIPIENTS=true`,
`AccountRecoveryEmailDelivery__Enabled=true`,
`AccountRecoveryEmailDelivery__PublicBaseUrl=https://localhost:5173/` — plus znany
już z K8i kształt originu (`https://localhost:5173`, redirect klienta BFF).

**Nowa blokada (cudza, chwilowa):** restart API z tym zestawem nie doszedł do
skutku, bo projekt przestał się kompilować w pliku innego agenta —
`Endpoints/Storage/StorageEndpoints.cs(1787,26): error CS1503: Argument 4: nie
można przekonwertować z „long" na „int?"`. Zgodnie z zasadą nieingerowania
w cudze pliki w trakcie edycji nie poprawiam tego; **API jest teraz zatrzymane**
(`pkill -f veloryn-workspaces`), PostgreSQL i Mailpit działają.

**Do wykonania po naprawie ich pliku (krótka sekwencja):** start z powyższymi
zmiennymi → `/tmp/login.sh` (sesja A) → `POST …/activation-email` dla konta
`59a2186f-818e-4bfb-8366-f5724d50e20f` → token z Mailpita
(`http://localhost:8025`) → `POST /api/v1/auth/activate` z hasłem → dodanie konta
B do workspace i projektu → scenariusz realtime: sesja A `negotiate` +
`SubscribeProject(workspaceId, projectId)`, sesja B
`PATCH …/kanban/tasks/{taskId}/primary-assignee`, kryterium: `task.updated`
z `primaryAssigneeUserId`, `previousPrimaryAssigneeUserId`, `assigneeUserIds`.

### 2026-09-20 — KANBAN-ASSIGNEE-K8m: wysyłka działa, aktywacja odrzuca token

**Potwierdzone:** `POST /api/v1/admin/users/{id}/activation-email` odpowiada teraz
**202**, a wiadomość faktycznie dochodzi do Mailpita — po restarcie API z
`WORKSPACES_SMTP_ENABLED=true`, `WORKSPACES_SMTP_HOST=127.0.0.1`,
`WORKSPACES_SMTP_PORT=1025`, nadawcą, `WORKSPACES_SMTP_ALLOW_UNVERIFIED_RECIPIENTS=true`,
`AccountRecoveryEmailDelivery__Enabled=true` i `PublicBaseUrl=https://localhost:5173/`.
Brakujący przełącznik z K8l był więc rzeczywiście przyczyną 503 (`SmtpOptions.IsConfigured`
wymaga hosta, portu i `Enabled`, których `start-local.sh` nie ustawia).

**Nowy problem:** `POST /api/v1/auth/activate` odrzuca token z treści maila
(link `https://localhost:5173/activate?token=5xJpRxOzdPDHvj0AXjHKZAnoRCbngv1xYCp4GijtN-I`)
odpowiedzią **400 `auth.reset_invalid`** — „Token resetu jest nieprawidłowy albo
wygasł". Ten sam 400 pojawił się dla tokenu wyciągniętego z treści wiadomości
w pierwszej próbie, więc problem nie jest w samym wyciąganiu. Kandydaci do
sprawdzenia w następnym kroku: pole żądania oczekiwane przez endpoint
(`token` vs inna nazwa), wymagany `userId` w ciele, albo ochrona tokenu kluczami
DataProtection, które w tym środowisku nie są trwałe między uruchomieniami —
jeśli klucze się rotują, token zakolejkowany w jednym przebiegu nie da się
odtworzyć w kolejnym i trzeba kolejkować i aktywować w tym samym procesie.

**Stan odbioru:** sesja A zalogowana (`GET /api/v1/me` → 200, SystemAdmin), konto
B `PendingActivation`, sesja B nie powstała, więc scenariusz realtime
(`negotiate` + `SubscribeProject` na sesji A, `PATCH …/primary-assignee` na sesji
B, kryterium `task.updated` z `primaryAssigneeUserId`,
`previousPrimaryAssigneeUserId`, `assigneeUserIds`) pozostaje **NOT RUN**.

Środowisko: API działa na `https://localhost:5173` i `http://localhost:5072`
z włączoną wysyłką; Mailpit na 8025; stop: `pkill -f veloryn-workspaces`.

### 2026-09-20 — KANBAN-ASSIGNEE-K8n: konto B aktywowane, sesja B zalogowana

**Rozwiązanie problemu z K8m:** endpoint `POST /api/v1/auth/activate` przyjmuje
`CompletePasswordResetRequest` z polami **`Token` i `NewPassword`**
(`Contracts/Auth/AccountRecoveryContracts.cs:13`), a nie `password`. To był mój
błąd w żądaniu, nie problem z tokenem ani z kluczami DataProtection — po
poprawieniu pola aktywacja zwróciła **204**, a hasło ustawiło się poprawnie.

**Dowiedzione komendami:**
- `POST /api/v1/auth/activate` z `{"token":"…","newPassword":"…"}` → **204**,
- logowanie konta B przez BFF (`/tmp/login.sh … kanban-b-1789899185`) →
  `GET /api/v1/me` → **200** z tożsamością
  `userId 59a2186f-818e-4bfb-8366-f5724d50e20f`, `login kanban-b-1789899185`,
  `roles ["User"]`, `permissions []`.

Dwie sesje są więc gotowe: A = `misiek440` (SystemAdmin), B = `kanban-b-…` (User).
Do odbioru realtime brakuje już tylko dwóch rzeczy:
1. **wspólnego projektu** — konto B nie ma jeszcze członkostwa, więc trzeba je
   zaprosić z sesji A (`POST /api/v1/workspaces/{ws}/invitations` z `{userId, role}`
   i akceptacja na sesji B — projekt bez członkostwa w workspace jest odrzucany),
   a projekt musi mieć co najmniej jedną kartę Kanban;
2. **scenariusza**: sesja A otwiera połączenie na `/api/v1/realtime/tasks`
   (`POST …/negotiate?negotiateVersion=1` z ciasteczkami i nagłówkiem
   `X-DevPlanner-CSRF` oraz pochodzeniem `https://localhost:5173`, potem
   `POST …?id=<connectionToken>` z handshakeiem JSON i inwokacja
   `SubscribeProject(workspaceId, projectId)`), sesja B wykonuje
   `PATCH …/kanban/tasks/{taskId}/primary-assignee` z `expectedVersion` i bieżącą
   wersją zadania, a sesja A odbiera `task.updated` z `primaryAssigneeUserId`,
   `previousPrimaryAssigneeUserId` i `assigneeUserIds`.

Środowisko: API na `https://localhost:5173` i `http://localhost:5072` z włączoną
wysyłką, Mailpit na 8025, PostgreSQL na 5440; hasło konta B:
`KanbanB-Local#2026`; stop: `pkill -f veloryn-workspaces`.

### 2026-09-20 — KANBAN-ASSIGNEE-K8o: konto B w workspace, brakuje projektu i SignalR

**Dowiedzione:** `POST /api/v1/workspaces/{ws}/invitations` z sesji A (rola
`Member`, `userId 59a2186f-…`) → **201**, zaproszenie `b3dd6275-4a5c-4f0f-aa91-6a405ed73ef6`
w workspace `9c0f5fd5-f505-4b92-bc8e-5302b73ec0d3`, a następnie
`POST /api/v1/workspaces/{ws}/invitations/{id}/accept` z sesji B → **200**, czyli
konto B jest członkiem workspace.

**Co zostało do odbioru:** wskazanie projektu z co najmniej jedną kartą Kanban
(odczyt listy projektów i tablicy zakończył się błędem parsowania w moim skrypcie,
bo zmienna z identyfikatorem projektu była pusta — nie jest to błąd API),
dodanie konta B do tego projektu, a potem scenariusz realtime: sesja A
`POST /api/v1/realtime/tasks/negotiate?negotiateVersion=1` (ciasteczka +
`X-DevPlanner-CSRF` + pochodzenie `https://localhost:5173`) → `POST …?id=<token>`
z handshakeiem JSON → inwokacja `SubscribeProject(workspaceId, projectId)`;
sesja B `PATCH /api/v1/workspaces/{ws}/projects/{p}/kanban/tasks/{taskId}/primary-assignee`
z `{targetUserId, expectedVersion}`; kryterium: sesja A odbiera `task.updated`
z `primaryAssigneeUserId`, `previousPrimaryAssigneeUserId` i `assigneeUserIds`.

**Stan sesji:** A = `misiek440` (SystemAdmin), B = `kanban-b-1789899185` (User,
członek workspace, hasło `KanbanB-Local#2026`), obie zalogowane przez BFF.
Środowisko: API `https://localhost:5173` i `http://localhost:5072` z włączoną
wysyłką, Mailpit 8025, PostgreSQL 5440; stop: `pkill -f veloryn-workspaces`.

### 2026-09-20 — KANBAN-ASSIGNEE-K8p: subskrypcja SignalR działa, brakuje karty dla sesji B

**Dowiedzione:** sesja A przeszła pełną ścieżkę SignalR —
`POST /api/v1/realtime/tasks/negotiate?negotiateVersion=1` (ciasteczka +
`X-DevPlanner-CSRF` + pochodzenie `https://localhost:5173`) zwrócił token,
`POST …/realtime/tasks?id=<token>` z handshakeiem JSON (`{"protocol":"json","version":1}` +
separator `0x1e`) został przyjęty, a inwokacja
`SubscribeProject(workspaceId, projectId)` wróciła **200**. Czyli transport,
uwierzytelnienie i subskrypcja grupy projektu działają na żywym stacku.

**Co zostało:** karta, którą sesja B mogłaby przypisać. Projekt utworzony
z sesji A (widoczność `Shared`) nie pojawił się w odczycie tablicy z sesji B
(`GET …/kanban/` nie zwrócił JSON-a, `PATCH …/primary-assignee` odpowiedział
**404**), więc konto B — choć jest członkiem workspace po zaakceptowaniu
zaproszenia (K8o) — nie ma jeszcze dostępu do tego projektu. Do sprawdzenia:
czy `Shared` nadaje dostęp członkom workspace od razu, czy wymagane jest jawne
członkostwo projektu (`POST …/projects/{p}/members`), oraz czy zaproszenie
workspace dla konta utworzonego przez admin API nie wymaga jeszcze potwierdzenia
e-maila przed dostępem do projektów.

**Kolejność dokończenia:** nadać koncie B dostęp do projektu (jawne członkostwo
albo potwierdzenie ścieżki `Shared`), odczytać z jego sesji tablicę i wersję
karty, potem `PATCH /api/v1/workspaces/{ws}/projects/{p}/kanban/tasks/{taskId}/primary-assignee`
z `{targetUserId: 59a2186f-…, expectedVersion: <wersja>}` i na sesji A odczytać
z połączenia SignalR zdarzenie `task.updated`, sprawdzając `primaryAssigneeUserId`,
`previousPrimaryAssigneeUserId` i `assigneeUserIds`.

Środowisko gotowe: API `https://localhost:5173` i `http://localhost:5072`
z włączoną wysyłką, Mailpit 8025, PostgreSQL 5440, sesja A `misiek440`,
sesja B `kanban-b-1789899185` (`KanbanB-Local#2026`), workspace
`9c0f5fd5-f505-4b92-bc8e-5302b73ec0d3`; stop: `pkill -f veloryn-workspaces`.

### 2026-09-20 — KANBAN-ASSIGNEE-K8q: subskrypcja powtarzalna, brak członkostwa projektu

**Powtórzone i stabilne:** `negotiate` → handshake → `SubscribeProject(workspaceId, projectId)`
na sesji A zwraca **200** przy każdym przebiegu (trzy razy z rzędu), więc ścieżka
realtime po stronie serwera i klienta curl jest potwierdzona.

**Czego brakuje (jedna nieznana ścieżka):** `POST …/projects/{p}/members` wymaga
`CreateProjectMembershipRequest { WorkspaceMembershipId, Role }`
(`Contracts/Projects/CreateProjectMembershipRequest.cs:7`), a ja nie zdobyłem
identyfikatora członkostwa workspace konta B — `GET /api/v1/workspaces/{ws}/members`
nie zwrócił JSON-a (zła nazwa zasobu), więc `add_member` nie został wywołany,
a odczyt tablicy z sesji B nadal nie zwraca danych. Dlatego `PATCH …/primary-assignee`
nie wykonał się i zdarzenie `task.updated` nie zostało odebrane.

**Następny krok (dwa wywołania):** odczytać listę członków workspace właściwym
zasobem (sprawdzić `Endpoints/Workspaces/WorkspaceEndpoints.cs`, grupa członków),
wziąć `WorkspaceMembershipId` konta `59a2186f-…`, dodać je do projektu rolą
`Member`, potem z sesji B odczytać tablicę i wersję karty, wykonać
`PATCH /api/v1/workspaces/{ws}/projects/{p}/kanban/tasks/{taskId}/primary-assignee`
z `{targetUserId: "59a2186f-…", expectedVersion: <wersja>}` i na sesji A odczytać
z otwartego połączenia `task.updated` z `primaryAssigneeUserId`,
`previousPrimaryAssigneeUserId` i `assigneeUserIds`.

Środowisko gotowe: API `https://localhost:5173` i `http://localhost:5072`,
Mailpit 8025, PostgreSQL 5440, projekt „Odbior Kanban” w workspace
`9c0f5fd5-f505-4b92-bc8e-5302b73ec0d3`, sesje A (`misiek440`) i B
(`kanban-b-1789899185`, `KanbanB-Local#2026`), stop: `pkill -f veloryn-workspaces`.

### 2026-09-20 — KANBAN-ASSIGNEE-K8r: członkostwo B znalezione, brak projektu z kartą

**Ustalone:** `GET /api/v1/workspaces/{ws}/members` **bez** parametru
`includeHidden` zwraca listę członków workspace (z `includeHidden` endpoint
odpowiadał błędem, co mylnie wyglądało jak brak dostępu). Członkostwo konta B to
`d8d5c463-aaaf-4c52-86cf-e1218ef99353` (sesja A, właściciel
`f650dd7e-…`). To jest dokładnie ten identyfikator, którego wymaga
`CreateProjectMembershipRequest { WorkspaceMembershipId, Role }`.

**Czego brakuje:** projekt z co najmniej jedną kartą. Wywołania
`POST /api/v1/workspaces/{ws}/projects` oraz
`POST …/projects/{p}/tasks/quick-create` nie doprowadziły do powstania projektu
widocznego w liście (`project=` puste, `quick_create=404`), więc `PATCH …`
nie miał czego przypisać i zdarzenie `task.updated` nie zostało odebrane.
Kolejny krok jest jednoznaczny: sprawdzić trasę i ciało tworzenia projektu w
`Endpoints/Projects/ProjectEndpoints.cs` (nazwa trasy i wymagane pola
`CreateProjectRequest`: `Name`, `Visibility`, `Status`), utworzyć projekt
widocznością `Shared`, dodać do niego konto B przez
`POST …/projects/{p}/members` z `d8d5c463-…` i rolą `Member`, utworzyć kartę,
a potem wykonać `PATCH …/kanban/tasks/{taskId}/primary-assignee` z sesji B
i odczytać z sesji A `task.updated` z `primaryAssigneeUserId`,
`previousPrimaryAssigneeUserId` i `assigneeUserIds`.

**Powtarzalne i potwierdzone:** subskrypcja SignalR na sesji A
(`negotiate` → handshake → `SubscribeProject`) zwraca **200** za każdym razem,
oboje użytkownicy są zalogowani (`me:200`), konto B aktywowane (204),
zaproszenie zaakceptowane (accept:200), członkostwo workspace odczytane.

### 2026-09-20 — KANBAN-ASSIGNEE-K8s: poprawna trasa projektu, ale tworzenie zwraca 500

**Ustalone:** `POST /api/v1/workspaces/{ws}/projects` **wymaga końcowego
ukośnika** (`group.MapPost("/", CreateAsync)` w `Endpoints/Projects/ProjectEndpoints.cs:21`);
bez niego endpoint odpowiada 404, co wcześniej sugerowało brak projektu.
Z poprawną trasą i ciałem `{"name":"Odbior Kanban","description":null,"icon":null,
"primaryColor":null,"visibility":"Shared","status":"Active"}` odpowiedź to
**500 `internal.error`** z `traceId 0HNON032ETO17:00000001` — czyli błąd
serwera, a nie odrzucenie danych wejściowych. To warto zbadać osobno (log API
w `/tmp/stack5173d.log` wokół tego traceId); nie należy do ścieżki Kanban, którą
ten plan realizuje, i nie było dotąd przedmiotem żadnego pakietu.

**Skutek dla odbioru:** brak projektu oznacza brak karty, więc `PATCH
…/kanban/tasks/{taskId}/primary-assignee` z sesji B nie ma czego przypisać,
a zdarzenie `task.updated` (`primaryAssigneeUserId`,
`previousPrimaryAssigneeUserId`, `assigneeUserIds`) nie zostało odebrane.
Wszystkie pozostałe ogniwa łańcucha są potwierdzone: oba konta zalogowane
(`me:200`), konto B aktywowane (204), zaproszenie zaakceptowane (`accept:200`),
członkostwo workspace B `d8d5c463-aaaf-4c52-86cf-e1218ef99353`, a subskrypcja
SignalR na sesji A (`negotiate` → handshake → `SubscribeProject`) zwraca **200**
za każdym przebiegiem.

**Kolejność dokończenia:** zbadać 500 z tworzenia projektu (albo użyć istniejącego
projektu w workspace `9c0f5fd5-…`, jeśli powstanie), dodać konto B przez
`POST …/projects/{p}/members` z `{workspaceMembershipId: "d8d5c463-…", role: "Member"}`,
utworzyć kartę, wykonać `PATCH` z sesji B i odczytać zdarzenie na sesji A.

### 2026-09-20 — KANBAN-ASSIGNEE-K8t: ODBIÓR DWÓCH SESJI ZALICZONY

**Kryterium DoD „realtime działa między dwiema sesjami” spełnione i dowiedzione.**

Przyczyną wcześniejszego 500 przy tworzeniu projektu była **przestarzała lokalna
baza**: `Npgsql.PostgresException 42703: column "DefaultTaskView" does not exist`
(traceId `0HNON032ETO17:00000001`). Po nałożeniu migracji (`dotnet ef database
update --project veloryn-workspaces.csproj --context WorkspaceDbContext`, wynik
`Done.`) projekt utworzył się poprawnie (`201`, `8eadff77-32b5-454b-8003-6c763f227a57`).
Ta sama przyczyna tłumaczy wcześniejszy błąd workera retencji kreatora
o brakującej tabeli `project_setup_idempotency_records`.

Przebieg odbioru (sesja A = `misiek440`, sesja B = `kanban-b-1789899185`):
1. konto B dodane do projektu (odpowiedź `409 project.membership_conflict`, czyli
   było już członkiem jako członek workspace, a dostęp do tablicy potwierdził odczyt),
2. karta utworzona: `POST …/tasks/quick-create` → **201**, zadanie
   `70326b2c-31eb-4cfe-9d08-8e3829b06e48`,
3. sesja A: `negotiate` → handshake → `SubscribeProject` → **200**,
4. sesja B: `PATCH /api/v1/workspaces/{ws}/projects/{p}/kanban/tasks/{taskId}/primary-assignee`
   z `{targetUserId: "59a2186f-…", expectedVersion: 4}` → **200**,
5. sesja A odebrała push na swoim połączeniu SignalR:

```
PUSH task.updated | primary: 59a2186f-818e-4bfb-8366-f5724d50e20f
                  | previous: None
                  | assignees: ['59a2186f-818e-4bfb-8366-f5724d50e20f']
```

Czyli zdarzenie `task.updated` dotarło do drugiej sesji i niesie wszystkie trzy
wymagane pola: `primaryAssigneeUserId` (konto B), `previousPrimaryAssigneeUserId`
(null, bo zadanie było wcześniej opróżnione z wykonawców) oraz `assigneeUserIds`
(lista z kontem B). Dodatkowo tym samym kanałem przyszło `project.presence.changed`,
co potwierdza działanie grupy projektu.

**Uwaga warsztatowa dla następnego agenta:** hub w tym środowisku odpowiada na
long polling **pustym ciałem** (`200`, 0 bajtów), a komunikaty oddaje dopiero
w kolejnych żądaniach `GET ?id=<token>` — trzeba wykonać 2–3 kolejne odpytania;
payload zdarzenia leży w `arguments[0]`, nie w korzeniu komunikatu.

Otwarte pozostają już tylko: potwierdzenie decyzji D1–D5 przez właściciela
produktu oraz bramki Windows i Linux (brak hosta na tej maszynie).

### 2026-09-20 — KANBAN-ASSIGNEE-K9: POTWIERDZENIE D1–D5 PRZEZ WŁAŚCICIELA PRODUKTU

**Status: potwierdzone.** Właściciel produktu potwierdził decyzje D1–D5 z §4 planu
w postaci wdrożonej, bez zmian. Kryterium wyjścia pakietu K0 („zakres MVP nie ma
otwartej niejednoznaczności wielu wykonawców”) jest spełnione.

Co dokładnie zostało potwierdzone:

| Decyzja | Potwierdzona treść |
|---|---|
| **D1** | Jedna karta występuje w jednej kolumnie użytkownika; kolumnę wyznacza `primaryAssigneeUserId`, brak wykonawcy trafia do „Nieprzypisane”, a współwykonawcy są widoczni na karcie bez duplikowania jej w innych kolumnach. |
| **D2** | Przeciągnięcie do osoby zmienia głównego wykonawcę: cel staje się głównym wykonawcą i dołącza do przypisań, poprzedni pozostaje współwykonawcą; przeciągnięcie do „Nieprzypisane” usuwa wszystkich wykonawców po jawnym potwierdzeniu. |
| **D3** | Tryb grupowania jest osobistą preferencją widoku (per `userId + workspaceId + projectId`) i nie zmienia wspólnego ustawienia projektu. |
| **D4** | Status pozostaje właściwością zadania: w widoku osób jest badge’em na karcie, a zmiana osoby nie dotyka statusu, pozycji ani workflow. |
| **D5** | Kolumny osób nie są ACL: backend autoryzuje każde żądanie po projekcie i zasobie, a widoczność kolumny nie nadaje ani nie odbiera dostępu. |

Konsekwencja: pakiety K0–K8 są zrealizowane i zweryfikowane. Duplikowanie kart dla
wszystkich wykonawców wraz z osobną kolejnością per osoba pozostaje świadomie
odłożonym etapem rozszerzonym (szacunek planu: 4–7 dni plus migracja i testy),
a nie zaległością tego zakresu.

Jedyne niewykonane bramki to **Windows i Linux**: ta maszyna jest hostem macOS,
więc zgodnie z AGENTS.md brak hosta platformy jest niewykonaną bramką, nie
sukcesem — do uruchomienia na właściwych hostach.

### 2026-09-20 — KANBAN-ASSIGNEE-K10: bramki Windows i Linux pominięte decyzją użytkownika

**Decyzja właściciela:** środowiska Windows i Linux nie są w tym projekcie
dostępne (brak hostów), więc bramki `flutter build windows` i `flutter build
linux` zostają **pominięte decyzją użytkownika** — nie są zaległością tego
zakresu ani powodem blokowania pakietu.

Sprawdzone przed decyzją: na tej maszynie nie ma hosta Windows ani Linux
(Docker działa jako `linux/arm64`, ale bez obrazu Fluttera i bez całego
toolchainu pulpitu), a jedyny skonfigurowany host zdalny
(`135.125.200.151`) nie odpowiada na porcie 22 (`Operation timed out`), więc
uruchomienie buildów nie było wykonalne bez instalowania toolchainu na cudzej
infrastrukturze.

Zakres planu domknięty: K0–K8 zweryfikowane i odebrane (w tym odbiór dwóch sesji
i cel wydajnościowy), decyzje D1–D5 potwierdzone przez właściciela produktu
(wpis KANBAN-ASSIGNEE-K9). Jedyne niewykonane komendy to buildy na platformach,
których projekt nie ma — zapisane jako pominięte, nie jako PASS.
### 2026-09-20 — FILES-F8-RT: kanał realtime dla pionu Storage (Backend)

Status: **DONE** w Backendzie; **live dwóch sesji NOT RUN**.

Kanał z §3.2.6 planu istnieje: outbox `storage_realtime_outbox_messages`
(addytywna migracja `AddStorageRealtimeOutbox`), typowane zdarzenia created /
updated / moved / deleted / restored / share changed / version created,
hub `StorageEventsHub` na `/api/v1/realtime/storage` z subskrypcją osobistą,
workspace'ową i projektową (te same bramki ACL co odczyt zakresu), odtworzenie
historii po nieprzezroczystym kursorze z precyzyjnym `ResyncRequired` (luka =
brak rekordu po kursorze), worker z ponowieniami oraz publikacja wpięta w siedem
miejsc mutacji (utworzenie dokumentu, opis, przeniesienie placementu, usunięcie,
przywrócenie, udostępnienie i cofnięcie, przywrócenie wersji) — w tym samym
`SaveChangesAsync` co zmiana.

Dowody: `dotnet build` czysty, `has-pending-model-changes` czyste,
`migrations script --idempotent` exit 0, testy kanału 7/7 (5 jednostkowych
+ 2 na realnym PostgreSQL: zapis zdarzenia w zakresie mutacji, izolacja zakresu
prywatnego, luka historii wymuszająca odświeżenie), a pełny zestaw testów
Backendu to **1223 powodzenia / 4 pominięte / 7 niepowodzeń / 1234 łącznie** —
wszystkie siedem niepowodzeń to wcześniejsze `MeEndpointsTests` (hasło, sesje),
żadnego w Storage ani realtime.

**NOT RUN:** live dwóch sesji (wymaga uruchomionego Backendu i dwóch klientów) —
razem z live E2E współedycji z F6. **Front nie konsumuje jeszcze kanału**:
typowy port i scalanie bez resetowania folderu, scrolla i zaznaczenia są
następnym pakietem; sam kanał bez odbiorcy nie zmienia UI.

### 2026-09-20 — KANBAN-ASSIGNEE-REVIEW: cztery uwagi z code review naprawione

Status: **DONE dla trzech P1 i jednego P2**; jedna rzecz z review pozostaje
otwarta i jest nazwana niżej.

**1. [P1] Kursor gubił aktywne filtry — naprawione.** `EncodeCursor` dostawał
puste `KanbanColumnQuery`, więc kursor nie niósł priorytetu, kamienia milowego
ani filtra wykonawcy, a strona druga przychodzi z tymi filtrami i walidacja
odsyłała własny kursor. Teraz kursor powstaje z `query.ToColumnQuery()`
(`Application/Kanban/KanbanAssigneeBoardReader.cs`). Test
`SecondPageLoadsWithActiveFilters`: 30 kart z priorytetem High przy filtrze
`Priority=High` → pierwsza strona 25, druga **5** i wszystkie High, karta w innym
priorytecie nie trafia na stronę.

**2. [P1] Rollback nadpisywał nowszy stan — naprawione.** Zamiast podmieniać
całą tablicę na snapshot sprzed mutacji, rollback działa na **bieżącym** stanie
i cofa wyłącznie własną kartę: przenosi ją z kolumny docelowej z powrotem do
źródłowej (albo usuwa przy 404), korygując dwa liczniki
(`tasks_board_assignee_commands.dart`). Test „rollback przeniesienia nie
nadpisuje zmian, które przyszły w trakcie” wstrzymuje odpowiedź mutacji,
w tym czasie doładowuje kolejną stronę grupy, potem kończy mutację błędem —
i wymaga, żeby doładowana karta przetrwała, a przenoszona wróciła do źródła.

**3. [P1] Retry używał zabrudzonego DbContext — naprawione.** Przed kolejną
próbą `ChangeTracker.Clear()` czyści graf encji w pamięci (podniesiona wersja
zadania, przygotowane przypisania, historia, powiadomienia i wpisy outboxa),
a stan jest pobierany od nowa przez `RequireWriteAsync`
(`Application/Kanban/KanbanAssigneeAssigner.cs`). **Otwarte za review:** nie
dodałem integracyjnego testu wymuszającego SQLSTATE 40001 lub deadlock —
deterministyczne wywołanie tego konfliktu w testach wymaga osobnej aranżacji
dwóch transakcji serializable, więc zostawiam je jako nazwane zadanie zamiast
udawać, że jest pokryte.

**4. [P2] Obserwator miał aktywne DnD — naprawione.** Kolumna osób czyta rolę
bieżącego użytkownika z `memberProfilesByUserId` (sesja z `AuthSessionPort`);
dla `Observer` karta nie jest opakowana w `Draggable`, a `DragTarget` odrzuca
upuszczenie. Brak informacji o roli nie odbiera prawa zapisu — backend nadal
egzekwuje autoryzację. Test „obserwator nie przeciąga kart i nie przyjmuje
upuszczenia” sprawdza oba warianty: Observer bez `Draggable`, Member z.

Komendy i wyniki: `flutter test test/workspaces/presentation/tasks
test/workspaces/data/kanban` → **485/485 PASS**; `flutter analyze lib
test/workspaces/presentation/tasks` → No issues found; `dotnet build
veloryn-workspaces.csproj` → 0 błędów; `dotnet test --filter
FullyQualifiedName~Kanban` → **79/79 PASS**; `git diff --check` czysty w obu repo.

### 2026-09-20 — KANBAN-ASSIGNEE-CHECKLIST: synchronizacja checklisty planu

Checklista w `Backend/docs/recovery/kanban-assignee-view-and-visual-refresh-plan.md`
(§11–§13) została zsynchronizowana z rzeczywistością: **103 punkty `[x]`**,
**7 `[ ]` z nazwaną przyczyną**. Wcześniej wszystkie 110 punktów było
nieodhaczonych, co przeczyło wpisom o zamknięciu K0–K8 — dlatego komplet
K0–K8 należy czytać z tą kwalifikacją.

Siedem punktów faktycznie otwartych:
1. K2 — audyt planu zapytania PostgreSQL dla indeksów (migracji nie dodano, bo
   ścieżka odczytu nie wymagała zmiany schematu).
2. K6 — przeładowanie grup po zmianie członkostwa (fail-closed).
3. K8 — weryfikacja dezaktywacji/revoke użytkownika przy otwartej tablicy.
4. K8 — odbiór Web BFF i desktop na tablicy osób (buildy wykonane, odbioru
   w przeglądarce nie było).
5. §13 — test preferencji grupowania dla dwóch użytkowników na jednym urządzeniu
   (klucz zawiera `userId`, brak testu).
6. §13 — odświeżenie capabilities po 403 (rollback i błąd są).
7. §13 — zachowanie zaznaczenia przy niepowiązanym resyncu realtime w widoku osób.

Reszta checklisty ma dowody z komend opisane w wpisach
`KANBAN-ASSIGNEE-K0` … `-K10` i `-REVIEW` powyżej.

### 2026-09-20 — DEMO-SEED-STAGING

Zmodyfikowano `Application/Development/Seeding/DemoSeedService.cs`, aby seeder
działał lokalnie w `Development` albo w jawnym procesie operatorskim ustawiającym
`DEVPLANNER_DEMO_SEED_STAGING_ENABLED=true`; samo API stagingowe nie ustawia tej
flagi. Dodano rootowy wrapper
`deployment/staging/server/devplanner-seed-demo`, wpis sudoers i instrukcję w
`deployment/staging/AGENT_ACCESS.md`. Wrapper pobiera login właściciela oraz
hasło tylko z plików `root:root 0600`, uruchamia jednorazowy kontener i nie
wypisuje poświadczeń.

Walidacja: `bash -n deployment/staging/server/devplanner-seed-demo` — PASS;
`dotnet build veloryn-workspaces.csproj --no-restore` — 0 ostrzeżeń i błędów;
`dotnet test Tests/Veloryn.Workspaces.Tests/Veloryn.Workspaces.Tests.csproj
--no-restore --filter FullyQualifiedName~DemoSeedOptionsTests` — 4/4 PASS;
`git diff --check` — PASS.

Następny krok: administrator VPS instaluje wrapper i zaktualizowany sudoers,
tworzy `/etc/devplanner/demo-seed.env` z bezpiecznie przekazanym hasłem testowym;
następnie agent wdraża commit i uruchamia `sudo -n
/usr/local/sbin/devplanner-seed-demo`.

Audyt VPS po wdrożeniu poprzedniego commita: `/usr/local/sbin/devplanner-seed-demo`
nie istnieje, a `sudo -l` zwraca obecnie `(ALL) NOPASSWD: ALL` dla
`codex-staging`, co przeczy wersjonowanemu modelowi najmniejszych uprawnień.
Nie należy wykorzystywać tego szerokiego uprawnienia do seedowania; najpierw
trzeba zainstalować ograniczony sudoers i dedykowany wrapper.

Pierwsze uruchomienie na stagingu ujawniło błąd w przejściu wersji
`README-demo.txt`: zapytanie wymagało wersji większej od 1, zanim seeder ją
utworzył. Naprawa wybiera jedyny plik README i dopiero potem tworzy wersję 2;
ponowne uruchomienie dokończy już utworzone, idempotentne dane.

Wdrożenie ręczne: `e91996d` zainstalował kontrolowany wrapper i ograniczony
sudoers; `3d735fd` wdrożył poprawkę idempotencji. Oba commity mają `[skip ci]`,
więc nie uruchomiły równoległego GitHub Actions. API stagingu działa jako
`ghcr.io/przemyslawpluszowy/devplanner-backend:3d735fd...`, status Docker to
`healthy`, a `/health/ready` zwraca sukces. Bieg `devplanner-seed-demo` po
poprawce zwraca `Demo seed is already current.` Potwierdzone odczytem SQL:
10 kont demo i awatarów, 1 workspace, 3 projekty, 9 milestone’ów, 31 zadań,
9 plików. Hasło kont demo pozostaje wyłącznie w `/etc/devplanner/demo-seed.env`
z prawami `root:root 0600`; nie zostało wypisane ani zapisane w repozytorium.

### 2026-09-20 — FILES-F8-RT-CLIENT: Front konsumuje kanał zmian

Status: **DONE** dla odbioru kanału; **live dwóch sesji NOT RUN**, macOS sprawdza
użytkownik, Windows/Linux NOT RUN (brak środowiska).

Front nie tylko publikuje i odbiera zdarzenia — po zdarzeniu odświeża bieżący
widok **w miejscu**: bez zmiany folderu, bez zwijania listy do pierwszej strony,
bez stanu ładowania i bez podmiany listy na ekran awarii. Seria zdarzeń jest
zbierana w oknie 250 ms, `resyncRequired` odświeża natychmiast, a błąd odświeżenia
idzie trwałym bannerem z kodem i `traceId` (z bezpiecznym `Ponów`), bo odczyt
listy jest idempotentny. Zaznaczenie zawęża się do elementów, które nadal
istnieją (`StorageSelectionCubit.retain`).

Kluczowe decyzje: port domenowy zamiast importu SignalR w prezentacji; kanał
zakresowy (osobisty / workspace / projekt) z adresem grupy zgodnym co do znaku
z serwerem (`{guid:N}` bez myślników); brak kanału dla kosza, udostępnionych,
ostatnich, ulubionych i zakresu zasobu — świadomie, bo hub ich nie adresuje;
kompozycja tylko dla klienta z tokenem dla huba (webowy BFF bez odświeżeń na
żywo, jak Zadania).

Dowody: `flutter analyze` bez uwag, `flutter test` **1357/1357**, `flutter gen-l10n`
bez zmian, `flutter build web --wasm` zbudowane, `git diff --check` czysto.

Lekcja: oczekiwanie `StreamSubscription.cancel()` w strefie testu widgetowego nie
kończy się nigdy (przyszłość domyka się w strefie głównej), więc sprzątanie
ekranu wisiało, a kanał nie dochodził do zwolnienia — koordynator nie wyczekuje
anulowania.

**NOT RUN:** live dwóch sesji (razem z live E2E współedycji z F6),
`flutter build macos` (użytkownik sprawdza sam), `flutter build windows` /
`flutter build linux` (brak środowiska).

### 2026-09-20 — KANBAN-ASSIGNEE-UI: trzy uwagi z użycia + auto-scroll przy przeciąganiu

Status: **DONE** — wszystkie cztery uwagi naprawione i pokryte testami.

**1. Awatary się nie wyświetlały.** Backend zwracał ścieżkę relatywną
(`/api/v1/users/{id}/avatar`), a klient ładuje awatar obrazem — względny adres
nie ma podstawy, więc zawsze trafiał w fallback inicjałów. Dodany
`PublicAssetUrlBuilder` buduje adres **absolutny** z `WORKSPACES_PUBLIC_BASE_URL`
(bez skonfigurowanego adresu zostaje ścieżka relatywna), a kolumny osób korzystają
z niego. Przy okazji `ProjectMemberProfileResponse` dostał addytywne pole
`AvatarUrl`, którego model frontu oczekiwał jako `avatarUrl` — dotąd było zawsze
`null`, więc awatary nie działały nigdzie (także w facepile i na kartach).
Testy: `PublicAssetUrlBuilderTests` (adres absolutny, fallback relatywny, brak
pliku → brak adresu).

**2. Brak paska przewijania na dole tablicy.** Viewport kolumn osób dostał
`Scrollbar` z widocznym uchwytem i własnym `ScrollController` (poziomy ListView nie
używa `PrimaryScrollController`, więc bez kontrolera pasek nie miał się do czego
przyczepić). Test „przy wielu osobach tablica ma poziomy pasek przewijania”
renderuje 12 kolumn w oknie 420 px i wymaga `thumbVisibility` oraz
`maxScrollExtent > 0`.

**3. Przełącznik wyglądał obco i był za duży.** Zamiast domyślnego
`SegmentedButton` jest teraz smukły pill 28 px w stylu przełącznika z listy zadań:
`surfaceContainerHigh` z subtelną ramką, zaznaczony segment w `primaryContainer`
z `onPrimaryContainer`, ikony i etykiety, hover, focus ring i `Semantics`
(button/selected/label). Kolor zaznaczenia bierze się z motywu, więc wybór widać
od pierwszego rzutu oka.

**4. Przeciąganie w prawo nie przewijało listy.** Kolumny osób i tablica
rejestrują teraz swoje kontrolery w `KanbanAutoScrollCoordinator` — tym samym,
którego używa widok statusów — a kolumna doładowuje kolejną stronę grupy po
dojechaniu do końca listy, tak jak kolumna statusu. Zachowanie obu trybów jest
identyczne.

Komendy i wyniki: `flutter test test/workspaces/presentation/tasks
test/workspaces/data/kanban` → **486/486 PASS**; `flutter analyze lib
test/workspaces/presentation/tasks` → No issues found; zrzuty baseline'u K0
przegenerowane (`--update-goldens`, 19 plików); `dotnet build
veloryn-workspaces.csproj` → 0 błędów; `dotnet test --filter
„Kanban|PublicAssetUrlBuilderTests”` → **82/82 PASS**; `git diff --check` czysty.

### 2026-09-20 — KANBAN-ASSIGNEE-UI2: kolumny wizualnie + dwie uwagi do dokończenia

Status: **częściowo DONE** — cztery zmiany wizualne wdrożone, dwie uwagi
użytkownika zostają otwarte z nazwaną przyczyną.

**Wdrożone (testy przechodzą):**
1. Tło kolumny to delikatny gradient od neutralnej powierzchni do koloru
   tożsamości: dla kolumny osoby kolor bierze się z hasha identyfikatora
   (`TaskBoardAvatarPalette.colorFor`), dla „Nieprzypisane” z `onSurfaceVariant`.
2. Ramka kolumny to przerywana linia rysowana `DottedRRectPainter` (kropka 2 px,
   odstęp 6 px) w kolorze zależnym od motywu: ciemny → biel 30%, jasny → czerń
   16%. Zamiast dotychczasowej cienkiej ramki ciągłej.
3. Hover nad kolumną zmienia tę ramkę na niebieską (`colors.primary`, grubsze
   kropki), a przeciąganie karty nad kolumną daje ten sam stan aktywny.
4. Kolumna zajmuje pełną wysokość planszy (`height: double.infinity`), więc
   upuszczenie działa na całej jej powierzchni, a nie tylko na wysokości kart.

**Otwarte 1 — brak przycisku dodawania zadania w kolumnie osoby.** Kolumna osób
nie montuje wiersza szybkiego dodawania, a kolumna statusu robi to przez
`_QuickCreateTask(column: …)` z `tasks_board_quick_create.dart`, który wymaga
`KanbanColumnResponse` (statusu), bo tworzenie zadania musi wskazać kolumnę
workflow. Potrzeba decyzji produktowej: czy „Dodaj zadanie” w kolumnie osoby ma
tworzyć zadanie w pierwszej kolumnie workflow z tą osobą jako głównym wykonawcą,
czy pytać o status. Do czasu decyzji nie wstawiam zgadywanego zachowania.

**Otwarte 2 — brak sposobu dodania podzadania, gdy karta ich nie ma.** Sekcja
podzadań na karcie renderuje się tylko wtedy, gdy `shows(subtasks) && subtaskTotal > 0`
(`tasks_board_card_content.dart`, `_hasSubtasksSection`), więc karta bez
podzadań nie pokazuje żadnej akcji. Dodanie przycisku dotyka karty wspólnej dla
obu widoków, więc wymaga ustalenia, czy akcja ma być na karcie, czy wyłącznie
w szczegółach zadania.

Komendy: `flutter test test/workspaces/presentation/tasks/tasks_board_assignee_commands_test.dart
test/workspaces/presentation/tasks/board/kanban_assignee_k0_baseline_test.dart
--update-goldens` → 32/32 PASS; `flutter analyze lib/workspaces/presentation/tasks/board`
→ No issues found; zrzuty baseline'u K0 przegenerowane (19 plików) i sprawdzone
wizualnie: gradient widać na każdej kolumnie, kolumny sięgają dołu planszy.

### 2026-09-20 — FILES-F9: sprzątanie martwej rodziny read-only

Status: **DONE**; live dwóch sesji NOT RUN, macOS sprawdza użytkownik,
Windows/Linux NOT RUN (brak środowiska).

Usunięta cała martwa rodzina `StorageReadOnlyBrowserPage` (9 plików, 1561 linii)
razem z 6 plikami testów pionowych, które jako jedyne ją montowały. Zamiast nich:
wspólny harness `test/test_support/storage_shell_harness.dart` oraz dwa nowe
zestawy na shellu — `shell/storage_shell_access_test.dart` (bramkowanie
kompozycji i ACL, powierzchnia 403) i
`shell/storage_shell_mutations_flow_test.dart` (dziewięć przepływów mutacji,
każdy rozliczony z jednego odświeżenia listy). Dwa pliki pionowe okrojone do
testów cubita (upload, wersje). W `lib` i `test` nie ma już żadnego odwołania do
`StorageReadOnly*`.

Przy migracji wyszedł realny defekt: trzy dialogi zwalniały kontroler pola
w trakcie animacji zamknięcia, więc przebudowa drzewa pod dialogiem sięgała po
zwolniony obiekt (`A TextEditingController was used after being disposed`).
Kontroler należy teraz do stanu dialogu.

Dowody: `flutter analyze` bez uwag; `flutter test` 1335 zielonych i 4 czerwone —
wszystkie cztery w Kanban innego agenta (nowe, nieśledzone jeszcze pliki testów
i goldeny przy trwających zmianach tokenów karty), żadna w Storage; zakres
Files + realtime 193/193; `flutter build web --wasm` zbudowane; `git diff --check`
czysto.

### 2026-09-20 — KANBAN-ASSIGNEE-UI3: przerywana ramka na kafelku (nie na kolumnie)

Status: **DONE** — poprawka zgodna z doprecyzowaniem użytkownika.

Użytkownik doprecyzował, że przerywana ramka miała być na **kafelku zadania**,
a nie na kolumnie. Poprawka:
- kafelek w spoczynku ma przerywaną ramkę rysowaną `DottedRRectPainter`
  (kropka 2 px, odstęp 6 px): w motywie ciemnym biel 30%, w jasnym czerń 16%;
- hover kafelka zamienia kropki na niebieskie (`colors.primary`), a focus i błąd
  zostają ciągłą ramką, bo niosą znaczenie, którego kropki nie zastąpią;
- wysokie kontrast wzmacnia kropki do pełnego koloru obrysu — nowy token
  `cardDashedBorderRest(colors, isDark:, highContrast:)` w `KanbanCardTokens`;
- kolumna osób **nie** ma już kropek: zostaje delikatny gradient z koloru
  tożsamości (hash osoby albo kolor statusu), ciągła subtelna ramka, niebieska
  ramka w hoverze i pełna wysokość jako strefa upuszczania.

Uwaga o odbiorze: użytkownik zgłosił „nic się nie zmieniło”, a przyczyną był
**przestarzały build web** (`build/web/main.dart.js` z 13:52 przy źródłach
zmienionych o 14:21) — po przebudowie zmiany są widoczne po odświeżeniu strony.
Poprawka awatarów wymaga natomiast restartu API, bo działa w nim proces
uruchomiony przed zmianą (`pkill -f veloryn-workspaces` i ponowny start).

Komendy i wyniki: `flutter test test/workspaces/presentation/tasks/board
--update-goldens` → wszystkie przechodzą (25 goldenów k1 przegenerowanych);
`flutter test test/workspaces/presentation/tasks test/workspaces/data/kanban`
→ **484/484 PASS**; `flutter analyze lib` → No issues found; `flutter build web
--wasm` — przebudowany; `git diff --check` czysty.

Po drodze: uszkodziłem własnym skryptem plik goldenów (`kanban_interaction_goldens_test.dart`)
i odtworzyłem go w całości — plik ma teraz 25 goldenów i trzy testy stanów,
analiza jest czysta, a zestaw zielony.

### 2026-09-20 — KANBAN-ASSIGNEE-UI4: kropki wróciły na kafelek, kolumny ujednolicone, wiersz dodawania na dole

Status: **DONE** — cztery uwagi z użycia domknięte, plus dowód live na poprawkę
awatarów.

**Przyczyna „karta nie ma żadnego dot border” (błąd, nie gust).** Wpis UI3
deklarował przerywaną ramkę kafelka, ale painter kropek nigdy nie trafiał do
drzewa dla prawdziwych kart: w `KanbanCardFrame._buildCard` gałąź
`onShowContextMenu != null` (czyli każda karta tablicy) przekazywała do
`Shortcuts`/`Actions` `child: card` zamiast `child: dashedCard`, więc
`CustomPaint(DottedRRectPainter)` był budowany i wyrzucany. Kropki rysowały się
wyłącznie na kartach bez menu kontekstowego — m.in. w goldenach i podglądzie
przeciągania, dlatego zestaw był zielony, a użytkownik nie widział obrysu.
Poprawka: `child: dashedCard`.

**Hover podświetla wyłącznie ramkę — w obu widokach.** Kafelek nie zmienia już
tła (`cardSurfaceHover` nieużywany) ani uniesienia: przy spoczynkowym
`cardElevationRest = 0.0` cała gałąź `boxShadow` była martwa i została usunięta,
a hover przemalowuje sam obrys na `cardFocusRing`. To świadome odejście od §5.6
planu kanbanowego („hover unosi kartę tylko minimalnie”): decyzja użytkownika
jest taka, że tło zostaje spokojne, żeby czytanie tablicy nie mrugało.

**Jedna powierzchnia kolumny dla statusów i osób.** Nowy plik-część
`tasks_board_column_surface.dart` (`KanbanColumnSurface`) trzyma gradient
akcentu (stały, `alpha .10`), promień 12 px, ciągłą ramkę
`outlineVariant @ .5` i niebieską ramkę 1.5 px w hoverze lub w aktywnej strefie
upuszczenia, plus pełną wysokość kolumny. `KanbanColumnWidget` (statusy) bierze
akcent z koloru statusu, `KanbanAssigneeColumn` (osoby) z hasha tożsamości
osoby — wygląd przestał się rozjeżdżać między trybami grupowania.

**Wiersz „Dodaj zadanie” przypięty na dole kolumny.** Stopka jest poza
przewijaną listą kart (`KanbanColumnSurface.footer`), więc nie ucieka pod
ekranem przy długiej kolumnie: w widoku statusów w **każdej** kolumnie, w widoku
osób **tylko w kolumnie „Nieprzypisane”** — nowe zadanie powstaje w Backlogu bez
wykonawcy, więc pojawia się dokładnie tam; w kolumnie osoby wiersz obiecywałby
kartę, która tam nie trafi. Etykieta i ikona biorą kolor `colors.primary`
(waga 600), hover rozjaśnia tło o 8% primary.

**Awatary — dowód live po restarcie API.** Działający proces pochodził z 12:19,
a poprawka `PublicAssetUrlBuilder` z 14:09–14:13, więc API nie mogło jej
serwować. Po restarcie (ten sam zestaw zmiennych środowiskowych,
`/private/tmp/restart-api-5173.sh`, porty 5173 + 5072) to samo konto i ten sam
projekt:

- przed: `GET /api/v1/workspaces/6de3bd7f…/projects/593185af…/members/profiles`
  → `{userId, displayName, avatarFileId, role}` bez `avatarUrl`;
- po: dodatkowo `"avatarUrl": "https://localhost:5173/api/v1/users/<id>/avatar"`
  (absolutny adres z `WORKSPACES_PUBLIC_BASE_URL`);
- `GET /api/v1/users/7da62c7a…/avatar` → `200`, `image/png`, 2954 B, PNG 396×396.

**Testy dopisane i przepisane świadomie.**
- nowy `test/workspaces/presentation/tasks/board/kanban_column_add_row_test.dart`
  — 4 testy: wiersz dodawania jest poza `ListView` i przy dolnej krawędzi
  kolumny, pusta kolumna też go ma, kolor z tokenu `primary @ .95`, hover
  zmienia ramkę, a gradient zostaje taki sam;
- `kanban_card_interaction_states_test.dart` — test spoczynku sprawdza teraz
  brak ciągłej ramki i kolor paintera, a nie `decoration.border`; doszedł skan
  pikseli (`darkPixelsInTopEdge` — dwa wiersze na górnej krawędzi kafelka,
  próg 20 jednostek od powierzchni) oraz test hoveru. Skan był najpierw
  fałszywie zielony (porównywałem kanał 0–1 z progiem 0–255), więc po naprawie
  zrobiłem kontrolę mutacyjną: po przywróceniu `child: card` test pikseli
  **failuje**, po naprawie przechodzi — dopiero to czyni go bramką;
- `tasks_board_assignee_commands_test.dart` — nowy test „wiersz dodawania
  zadania jest tylko w kolumnie Nieprzypisane” (prezent w grupie 0, brak
  w grupie osoby).

Komendy i wyniki: `flutter test
test/workspaces/presentation/tasks/board --update-goldens` → wszystkie
przechodzą (29 goldenów k1 przegenerowanych, w tym kolumny statusu/osoby/
nieprzypisane w obu motywach); `flutter test
test/workspaces/presentation/tasks test/workspaces/data/kanban` → **491/491
PASS**; pełny `flutter test` → **1344/1344 PASS**; `flutter analyze lib` → No
issues found; `dart format --output=none lib/workspaces/presentation/tasks/board/`
→ po sformatowaniu moich dwóch plików różni się już tylko
`cubit/tasks_board_runtime_coordinator.dart`, którego nie dotykam (plik innego
agenta); `flutter build web --wasm` → `✓ Built build/web` (`main.dart.wasm`
6,6 MB, 14:54); `git diff --check` czysty.

Otwarte (świadomie): pusta kolumna osoby nadal jest tylko strefą upuszczenia bez
widocznej podpowiedzi tekstowej (ma sam `Semantics`), a akcja dodania podzadania
na karcie bez podzadań pozostaje nierozwiązana — obie pozycje czekają na decyzję
o kształcie, nie na kod. Windows/Linux pozostają pominięte decyzją użytkownika
(brak hostów).

### 2026-09-20 — KANBAN-ASSIGNEE-UI5: akcja dodania podzadania na karcie bez podzadań

Status: **DONE** — domknięcie uwagi „jak nie ma podzadania to nie da się dodać,
nie ma przycisku”.

**Przyczyna.** `_hasSubtasksSection` wymagało `subtaskTotal > 0`, więc zadanie
bez podzadań nie montowało sekcji w ogóle — a formularz „Dodaj podzadanie”
żyje wewnątrz tej sekcji. Dodanie pierwszego podzadania wymagało wejścia
w szczegóły zadania. Gałąź licznika w `_CardPrimaryMeta`
(`shows(subtasks) && !hasSubtasksSection && subtaskTotal > 0`) była przy tym
**martwa od zawsze**: `!hasSubtasksSection` i `subtaskTotal > 0` nie mogą być
prawdziwe jednocześnie, więc fallback nigdy się nie rysował.

**Zmiana.** Sekcja montuje się, gdy pole `subtasks` jest widoczne — niezależnie
od liczby dzieci. Zadanie bez podzadań nie pokazuje jednak nagłówka z licznikiem
„(0/0)” i pustym paskiem postępu (to szum), a wprost akcję „Dodaj podzadanie”;
jej dotknięcie otwiera sekcję **razem** z polem nazwy (`_openAddSubtask`), więc
użytkownik nie klika dwa razy. Wiersz akcji jest teraz jednym widgetem
(`_buildAddSubtaskAction`) używanym i przez pustą kartę, i przez listę
podzadań — wcześniej ten sam kod istniał wyłącznie w treści rozwiniętej.
Martwa gałąź licznika w metadanych została usunięta, bo utrzymywała złudzenie,
że licznik gdzieś się pokazuje.

Komendy i wyniki: `flutter test test/workspaces/presentation/tasks/board` →
**185/185 PASS** (w tym nowy test „karta bez podzadań pokazuje akcję dodania,
bez nagłówka z licznikiem”, który sprawdza brak `(0/0)` i jedno dotknięcie do
pola nazwy); `flutter test test/workspaces/presentation/tasks
test/workspaces/data/kanban` → **492/492 PASS**; pełny `flutter test` →
**1345/1345 PASS**; `flutter analyze lib` → No issues found; `flutter build web
--wasm` → `✓ Built build/web` (`main.dart.wasm`, 15:05); `git diff --check`
czysty. Goldeny bez zmian: żaden ich scenariusz nie ma `subtasks` w
`visibleCardFields`, więc nowa akcja nie wchodzi na żadne istniejące
odniesienie.

Otwarte (świadomie): akcja dodaje podzadanie inline na karcie i nie pozwala
od razu ustawić terminu ani wykonawcy dziecka — te pola nadal ustawia się
w szczegółach zadania.

### 2026-09-20 — STORAGE-REVIEW-FIXES: sześć uwag z review

Status: **DONE**; live dwóch sesji NOT RUN, macOS sprawdza użytkownik,
Windows/Linux NOT RUN (brak środowiska).

Naprawione wszystkie cztery P1 i dwa P2:

1. **Historia workspace'u obejmuje projekty** — `ScopeQuery` zwraca dla zakresu
   workspace'u zdarzenia `Workspace` i `Project` z tym samym `WorkspaceId`, czyli
   ten sam zbiór, który worker wysyła do grupy workspace'u.
2. **Pierwsza subskrypcja nadrabia historię** — adapter czyta ją zawsze: bez
   kursora ogon historii (jedno żądanie), po wznowieniu strony od kursora do
   końca, więc okno między odczytem listy a dołączeniem do grupy jest zamknięte.
3. **Status edytora czeka na backend** — stan rozdziela „brak lokalnych zmian”,
   „oczekiwanie na serwer”, „wersja potwierdzona” i „zapis niepotwierdzony”;
   potwierdzeniem jest wyższa wersja pliku z `getFileDetails`, a nie sygnał
   edytora. Callback publikuje `storage.file.version.created`.
4. **Rejestr OnlyOffice obsługuje wielu edytujących** — zbiór sesji na dokument,
   autor tylko z jednoznacznego wskazania (akcja → konfiguracja edytora →
   jednoosobowa lista `users` → jednoznaczne przecięcie z rejestrem), a zapis bez
   autora idzie jako nieprzypisany z właścicielem pliku jako technicznym
   zapisującym i logiem `OnlyOfficeUnattributedSave`.
5. **Luka historii liczona względem zakresu** — `ResyncRequired` tylko wtedy, gdy
   kursor jest starszy niż `OldestSequence` zakresu; przerwy w globalnej numeracji
   od zdarzeń innych zakresów nie są już utratą historii.
6. **Stronicowanie historii** — kontrakt ma `HasMore`, klient pobiera strony do
   końca, a po przekroczeniu budżetu zgłasza jedno pełne odświeżenie.

Dowody: `dotnet build` czysty; `dotnet test` 1236 zielonych / 4 pominięte /
7 czerwonych (wszystkie wcześniejsze `MeEndpointsTests`); `has-pending-model-changes`
czyste; `flutter analyze` bez uwag w plikach pakietu; `flutter test` 1353/1353;
`flutter build web --wasm` zbudowane; `git diff --check` czysto.

### 2026-09-20 — STORAGE-REVIEW-LIVE: żywy test dwóch sesji

Status: **DONE** dla kanału i współedycji przez kontrakt; **NOT RUN** dla klikania
w prawdziwym edytorze w dwóch przeglądarkach (brak automatyzacji GUI na tym Macu).

Uruchomiono własną instancję API z dzisiejszym kodem (`https://localhost:5174` +
`http://localhost:5073`, klient desktopowy OpenIddict, kopia bazy `review_live`,
MinIO/PostgreSQL/ClamAV z istniejącego compose) i zalogowano dwie sesje klientem
desktopowym przez Authorization Code + PKCE: A = `misiek440`, B =
`kanban-b-1789899185`, oba w workspace `DevPlanner`.

**Kanał i odświeżenie listy.** B tworzy dokument w workspace → A (prawdziwy
`StorageRealtimeClientAdapter`, prawdziwy SignalR) dostaje zdarzenie live, a lista
czytana przez A zawiera nowy plik. Po rozłączeniu A i utworzeniu dokumentu
**w projekcie** tego workspace, powrót A odtwarza historię, która **obejmuje
zdarzenie projektowe** — to potwierdzenie poprawki P1-a w żywym systemie. Pomiar:
jedno zdarzenie live 1,0–1,6 s po mutacji, także po ponownym połączeniu.

**Współedycja.** A i B otwierają ten sam dokument (ten sam `documentKey`), zapis
bez rozstrzygalnego autora tworzy v2 z właścicielem pliku jako autorem
technicznym i zdarzeniem bez `actorUserId`, zapis z `actions[{userid: B}]` tworzy
v3 z autorem B, a kolejny zapis bez autora znowu trafia na właściciela — sesja
współedycji trwa, a żadna treść nie ginie.

**Znaleziska środowiskowe.** Instancja API bez backplane'u Redis w topologii z drugą
instancją zabiera część rekordów outboxa i publikuje je tylko do własnych pokoi, co
cicho odbiera zdarzenia klientom innych instancji (dlatego przebieg powtórzono na
izolowanej bazie); endpointy `admin/ops` wymagają claimu `permission` z Core, więc
licznik sesji nie jest lokalnie dostępny; allowlista pobrania callbacku przyjmuje
wyłącznie host:port z `WORKSPACES_ONLYOFFICE_URL`.

Dowody: `flutter test test_live/storage_realtime_live_test.dart` 1/1;
`flutter test test_live/storage_onlyoffice_two_editors_live_test.dart` 1/1;
`flutter analyze test_live` bez uwag; domyślny `flutter test` 1353/1353 z
`test_live/` poza zbiorem. Pliki testów leżą poza `test/` i bez zmiennych `LIVE_*`
są pomijane.

### 2026-09-20 — KANBAN-ASSIGNEE-REVIEW2: odświeżanie po filtrze, wyścig odczytów, kolumny vs filtr, belka nagłówka, gęstość

Status: **DONE dla sześciu uwag z review** — dwie funkcjonalne (P1), jedna produktowa
(P1) i trzy projektowe (P2). Kolejność wdrożenia jest tą z werdyktu review.

**1 [P1] Szybki filtr nie odświeżał tablicy grupowanej po osobach.** Po zapisie
`KanbanQuickFilter` kod wołał wyłącznie `reloadBoard()`, czyli odczyt kolumn
*statusów*; widok osób zostawał z kartami i licznikami sprzed filtra, dopóki inne
zdarzenie przypadkiem go nie odświeżyło. W `TasksBoardCommandContext` doszła
metoda `reloadActiveBoard(force)`, a `TasksBoardCubit` implementuje ją jako
`_runtime.load(...)` + `_assignee.reloadAfterFilterChange()` (drugie jest
no-opem poza widokiem osób). Wołają ją teraz wszystkie trzy miejsca, w których
zmiana preferencji zmienia zawartość kolumn: szybki filtr, szybkie utworzenie
zadania i zastosowanie szablonu. Test
`szybki filtr w widoku osób wraca po świeże grupy, a nie tylko po kolumny`
sprawdza drugie wywołanie `getAssigneeBoard`, nowe liczniki grup i zgaszenie
wskaźnika wczytywania; kontrola mutacyjna (usunięcie `reloadAfterFilterChange`)
daje `Expected: <2> Actual: <1>`.

**2 [P1] Późniejsza odpowiedź starszego żądania nadpisywała świeższe grupy.**
Odczyty tablicy osób nie miały odpowiednika `_boardQueryRevision`, więc przy
szybkiej zmianie filtra (High → Critical) odpowiedź dla High mogła wrócić
ostatnia i zastąpić poprawną tablicę. `TasksBoardAssigneeCommands` ma teraz
własną rewizję: rośnie przy starcie każdego `loadBoard()`, a odpowiedź jest
publikowana tylko wtedy, gdy rewizja się nie zmieniła **i** filtr w stanie jest
nadal tym, o który pytano (filtr może się zmienić bez nowego odczytu grup, np.
gdy użytkownik zdążył wrócić do statusów). Ten sam warunek chroni doładowanie
kolejnej strony grupy (`loadMore`), bo kursor należy do filtra, dla którego go
wydano. Test `późniejsza odpowiedź starszego żądania nie nadpisuje świeżych grup`
trzyma oba żądania otwarte i rozwiązuje je w odwrotnej kolejności; bez strażnika
ekran pokazuje grupę z żądania, które przyszło ostatnie (`Actual: 'Marta'`).

**3 [P1 produktowy] Filtr wykonawcy zastąpiony widocznością kolumn w widoku
osób.** Filtr osoby zniknął z wiersza poleceń, gdy `grouping == assignee` — tam
osoba jest osią kolumny, więc zawężanie jej zawartości jest mylące. Zamiast tego
doszło menu „Kolumny osób” (checkbox na osobę + licznik zadań), przełącznik
„Ukryj puste kolumny”, akcja „Pokaż wszystkie kolumny” oraz stan pusty, gdy
filtr widoczności nie zostawił żadnej kolumny (z tą samą akcją, żeby ekran nie
udawał, że projekt nie ma zadań). Filtrowanie listy grup jest **lokalne**
(`KanbanAssigneeColumnsViewport`), a Backend nadal zwraca wszystkie grupy.
Preferencja jest osobista i trwała — osobny port `TasksBoardViewPreferenceStore`
(dawny `TasksBoardGroupingPreferenceStore`, rozszerzony o widoczność kolumn),
adapter `SharedPreferencesTasksBoardViewStore`, wpis w `shared_preferences`
kluczowany użytkownikiem, workspace i projektem. **Świadome odejście od nazwy
z review:** w stanie trzymamy `hiddenAssigneeUserIds`, a nie
`visibleAssigneeColumnIds` — przy zapisanej liście *widocznych* nowy członek
projektu nie pojawiłby się na tablicy, dopóki ktoś nie zmieniłby ustawienia.
Zapis jest best-effort: publikujemy zmianę natychmiast, a zapis leci w tle.

**4 [P2] Przełącznik grupowania w wierszu poleceń.** `KanbanBoardGroupingBar`
nie jest już montowany nad tablicą (`_BoardContent` go nie zawiera), tylko jako
pierwsza kontrolka wiersza poleceń — hierarchia to dwa wiersze nagłówka i
tablica, bez trzeciej belki. Przy okazji: kontrolka straciła własny padding i
`Spacer`, a cubit czyta **w momencie kliknięcia**, nie w `buildzie` — nagłówek
jest montowany bez dostawcy cubita w testach nagłówka i wtedy build rzucał
`ProviderNotFoundException` (objawiał się jako overflow 99 158 px od widgetu
błędu). Test `przełącznik grupowania stoi w wierszu poleceń, a nie nad tablicą`
porównuje pas wiersza poleceń i środek kontrolki z kluczem filtra priorytetu.

**5 [P2] Gęstość zmienia szerokość kolumny.** Nowe tokeny
`columnWidthCompact = 264`, `columnWidthStandard = 308` (odniesienie),
`columnWidthDetailed = 356` i `columnWidthFor(density)`; korzysta z nich wspólna
`KanbanColumnSurface` (obie kolumny) oraz krok przewijania klawiszami
(`columnWidthFor + columnGap` zamiast zaszytego 318). Padding karty przestał być
różnicą kosmetyczną: compact 10 px, comfortable 14 px, detailed 16 px. Świadome
odejście od §5.7 planu („szerokość desktopowa około 288–320 px”): bez zejścia
poniżej 288 px wybór Compact nie mieści na ekranie ani jednej kolumny więcej,
czyli nie realizuje swojej obietnicy. Test
`gęstość tablicy zmienia szerokość kolumny` mierzy szerokość kolumny w compact i
detailed oraz porządek tokenów.

**6 [P2] Pasek aktywnych filtrów pokazywał tylko szybki filtr.** `_ActiveFilterStrip`
dostał jeden chip na każdy aktywny wymiar (szybki filtr, priorytet, osoba,
kamień milowy), każdy zdejmowany własnym „×”, plus jedną akcję „Wyczyść
wszystko”, która czyści też szybki filtr. Etykieta paska wyszła z hardkodowanego
polskiego tekstu do ARB (`tasksBoardActiveFilters`), a pasek pojawia się, gdy
aktywny jest jakikolwiek wymiar — wcześniej wymiar tablicy był aktywny bez
żadnej informacji na ekranie. Testy: `pasek aktywnych filtrów pokazuje priorytet
i daje się zdjąć` oraz zaktualizowany `wyświetla chip aktywnego filtra gdy
quickFilter != all` (dawniej oczekiwał przycisku „Wyczyść” dla samego chipu).

**Świadomie przepisane testy** (protokół wymaga wskazania): `wyświetla chip
aktywnego filtra…` — z „Wyczyść” na „Wyczyść wszystko” i klucz chipu; harness
`test_support/tasks_board_route_fixture.dart` dostał stub `getAssigneeBoard` i
stałą `assigneeKanbanBoardResult` (wcześniej żaden test trasy nie sięgał tablicy
osób, więc brak stubu był niewidoczny).

Komendy i wyniki: `flutter test test/workspaces/presentation/tasks
test/workspaces/data/kanban` → **ze zmianami w goldenach** po odświeżeniu
`--update-goldens` (29 w `k1` + `header_desktop_1280`), pełny `flutter test` →
**1370/1370 PASS**; `flutter analyze lib test` → jedyne znalezisko to
`eol_at_end_of_file` w `test/workspaces/presentation/storage/office/storage_office_session_status_test.dart`, pliku innego agenta (moje pliki czyste);
`flutter build web --wasm` → `✓ Built build/web` (20:01); `git diff --check`
czysty; `dart format --output=none` na moich katalogach nie zgłasza plików,
które ruszałem.

Otwarte (świadomie): odbiór w przeglądarce na tablicy osób nadal jest punktem 4
listy otwartych pozycji planu; widoczność kolumn zapisuje się lokalnie, więc nie
podróżuje między urządzeniami (to osobista preferencja klienta, jak grupowanie);
filtr kamienia milowego nie ma kontrolki w wierszu poleceń, więc jego chip w
pasku jest zabezpieczeniem na stan ustawiony skądinąd.

### 2026-09-20 — STORAGE-REVIEW2-FIXES: sześć uwag z drugiego review

Status: **DONE** dla wszystkich sześciu uwag i sześciu brakujących testów
regresyjnych; żywy przebieg powtórzony na nowym kodzie.

Naprawione:

1. **Próg potwierdzenia zapisu jest ruchomy** — każdy kolejny zapis w tej samej
   sesji wymaga własnej, nowszej wersji z backendu (`confirmedVersion` jako próg).
2. **Brak atrybucji nie omija ACL** — prawo zapisu sprawdzamy u uczestników
   dokumentu (ładunek + aktywne sesje), a gdy nikt nie może pisać, zapis jest
   odrzucany. Zapis bez autora powstaje bez autora: nowe, nullowalne
   `ChangedByUserId` (puste), właściciel wyłącznie jako techniczny zapisujący.
   Migracja addytywna z przeniesieniem autora w istniejących wersjach.
3. **Niejednoznaczne zamknięcie nie kasuje rejestru** — zamykamy tylko osoby
   wskazane przez `actions` albo ustalonego autora; inaczej nikt, TTL wygasi.
4. **Zamknięcie modala w stanie oczekiwania** ma osobny komunikat i czeka na
   wynik kontroli przed odświeżeniem listy.
5. **Handlery SignalR rejestrowane raz** w konstruktorze adaptera.
6. **Nieudane pierwsze połączenie** zostawia nasłuch stanów i ponawia z backoffem;
   koordynator nie blokuje ponowienia.

Dowody: `dotnet build` exit 0; `has-pending-model-changes` czyste;
`dotnet test` **1238 zielonych / 4 pominięte / 7 czerwonych / 1249** (wszystkie
siedem to znane `MeEndpointsTests`; w trakcie pakietu jeden test OnlyOffice padł
z mojej pomyłki w asercji i został naprawiony — zbiór OnlyOffice 43/43);
`flutter analyze` bez uwag w całym projekcie; `flutter test` 1370/1370;
`flutter build web --wasm` zbudowane; oba żywe testy zielone; `git diff --check`
czysto.

### 2026-09-20 — KANBAN-ASSIGNEE-REVIEW3: kontrolka w nieograniczonej szerokości, ukryty filtr osoby, kolejka zapisów

Status: **DONE dla trzech uwag z review** — jedna realna pułapka układu (P1),
jeden błąd stanu (P1) i jeden wyścig zapisu (P2). Wszystkie trzy mają test
z kontrolą mutacyjną.

**1 [P1] Kontrolka grupowania jako sam segmentowany przełącznik.** Uwaga
o `Spacer` w poziomym scrollu była trafna jako klasa błędu, choć w kodzie
zostało już tylko opakowanie w `Row` — wiersz poleceń daje nieograniczoną
szerokość, więc każdy element rozciągliwy kończy się komunikatem „RenderFlex
children have non-zero flex but incoming width constraints are unbounded”.
`KanbanBoardGroupingBar` zwraca teraz **bezpośrednio** przełącznik: `Container`
z `Row(mainAxisSize: min)` i wyłącznie nierozciągliwymi dziećmi (wskaźnik
wczytywania trafił do środka pigułki, zamiast stać obok w osobnym `Row`).
Test w nowym pliku `kanban_grouping_switch_test.dart` montuje kontrolkę w takim
wierszu i pilnuje trzech rzeczy: braku wyjątku, obecności obu segmentów i braku
własnego `SingleChildScrollView` w środku. **Kontrola mutacyjna**: po wstawieniu
`Spacer()` test failuje dokładnie komunikatem z review.

**2 [P1] Ukryty filtr wykonawcy zostawał aktywny po przełączeniu na osoby.**
Filtr osoby był ustawiany w widoku statusów, a po zmianie grupowania jego
kontrolka znikała — `state.filter.assigneeUserId` nadal jechał jednak do
`loadBoard()`, więc widok osób pokazywał jedną osobę bez widocznej przyczyny.
`TasksBoardCubit.setGrouping` zdejmuje teraz filtr wykonawcy **przed** odczytem
tablicy osób (przez `_filters.setAssignee(null)`, czyli tą samą drogą co
kontrolka, żeby filtr w runtime i w stanie nie mogły się rozjechać), zachowuje
pozostałe wymiary i nie przywraca usuniętego filtra po powrocie do statusów.
Test `wejście w widok osób zdejmuje filtr wykonawcy, reszta wymiarów zostaje`
sprawdza stan po przełączeniu, filtr faktycznie wysłany do Backendu (nowe
`assigneeBoardFilters` w atrapie repozytorium) i brak powrotu filtra.
**Kontrola mutacyjna**: bez czyszczenia test daje `Expected: null
Actual: 'user-2'`.

**3 [P2] Szybkie zmiany checkboxów mogły zapisać starszy wybór.** Zapisy
widoczności kolumn szły jako osobne `unawaited`, więc storage mógł zakończyć je
w odwrotnej kolejności i nadpisać świeższy wybór starszym (ekran poprawny, stan
po restarcie aplikacji nie). `_persistAssigneeColumns` prowadzi teraz kolejkę
„latest wins”: zapisy idą **jeden po drugim**, a w międzyczasie trzymany jest
wyłącznie najnowszy stan, który wchodzi na miejsce poprzedniego. Test
`szybkie zmiany widoczności kolumn zapisują się szeregowo i wygrywa najnowsza`
zatrzymuje pierwszy zapis completerem, sprawdza, że drugi **nie** wystartował
(`hasLength(1)`), liczy maksymalną równoległość (`maxConcurrentColumnWrites == 1`)
i po zwolnieniu pierwszego wymaga zapisania najnowszego stanu (`{user-1, user-2}`).
**Kontrola mutacyjna**: po powrocie do równoległych zapisów test failuje na
`Expected: an object with length of <1>`.

Komendy i wyniki: `flutter test test/workspaces/presentation/tasks
test/workspaces/data/kanban` → **504/504 PASS**; pełny `flutter test` →
**1374/1374 PASS**; `flutter analyze lib test` → No issues found; `flutter build
web --wasm` → `✓ Built build/web`; `git diff --check` czysty. Goldeny bez zmian
wizualnych (pigułka wygląda tak samo — zniknęło tylko opakowanie), więc
`--update-goldens` nie był potrzebny.

Otwarte bez zmian: odbiór w przeglądarce na tablicy osób, brak kontrolki filtra
kamienia milowego i lokalny zakres zapisu widoczności kolumn.

### 2026-09-20 — STORAGE-REVIEW3-FIXES: trzy uwagi z trzeciego review

Status: **DONE** dla wszystkich trzech uwag z brakującymi przypadkami testowymi.

1. **Zestaw mieszany uczestników nie omija już revoke** — przy braku
   rozstrzygalnego autora prawo zapisu musi mieć **każdy** wskazany uczestnik
   (ładunek + aktywne sesje); jeden cofnięty wystarcza do odrzucenia, a zestaw
   pusty też jest odrzucany. Dodany przypadek „właściciel + cofnięty”.
2. **Powiadomienie o wersji nie publikuje pustego UUID** — kontrakt zdarzenia i
   serwis przyjmują `Guid?` autora; przy `null` nikt nie jest wyciszany, a
   zdarzenie nie ma autora. Test: `UnattributedVersionNotifiesEveryoneAndPublishesNoAuthor`.
3. **Limit ponowień połączenia działa** — ponowienie ma osobną ścieżkę
   (`_retryConnect`, bez `_detachSubscription`), a licznik zeruje się dopiero po
   udanym połączeniu albo świadomym wejściu w zakres. Test: zatrzymanie na
   czwartej próbie i piąta po świadomym ponowieniu.

Dowody: `dotnet build` exit 0; `has-pending-model-changes` z `ConnectionStrings__Workspaces`
→ exit 0, model bez zmian; `dotnet test` **1239/4/7/1250** (wszystkie siedem to
znane `MeEndpointsTests`; OnlyOffice 43/43); `flutter analyze` bez uwag;
`flutter test` 1378/1378; `flutter build web --wasm` zbudowane; oba żywe testy
zielone; `git diff --check` czysto.

### 2026-09-20 — WIZ-PREVIEW-CARDS: plan nie może zgubić kart szablonu (mapowanie zadań do kolumn)

Status: **DONE (2026-09-20)** — uwaga P1 z review zweryfikowana u źródła kontraktu,
luka domknięta mapowaniem i testem, komunikat podglądu uściślony.

**Ustalenie po weryfikacji w kodzie i kontrakcie: scenariusz z review nie jest
osiągalny, ale luka była realna.** Review twierdził, że `_withPlanColumns()`
zastępuje kolumny planu bez kart, gubiąc zadania szablonu. Sprawdzone po obu
stronach: (1) `buildProjectPreviewSnapshot` ma osobną gałąź dla
`draft.usesTemplate`, która **nie** wchodzi w `_withPlanColumns` i zostawia
kolumny szablonu razem z kartami; (2) `templateId` jest czyszczony razem ze
zmianą startu na pusty projekt (`clearTemplate`), więc `template != null`
pociąga `usesTemplate`; (3) Backend dla projektu z szablonu zwraca w planie
`ProjectSetupWorkflowKind.Default` z **pustą** listą własnych statusów
(`ProjectSetupPlanner.ResolveWorkflow`), a statusy i zadania materializuje
snapshot szablonu — potwierdza to test integracyjny
`SetupFromTemplateRecreatesWorkflowLabelsAndTasks` (`workflow.kind == "Default"`,
`systemStatusCount == 6`, a w projekcie jest zadanie z szablonu). Czyli plan nie
może „zmienić nazw kolumn" projektu z szablonu, a przedmiotowa gałąź nigdy nie
widzi zadań szablonu.

**Co mimo to zostało naprawione.** (1) Mapowanie zadań na kolumny planu istnieje
teraz jawnie jako funkcja `mapProjectPreviewTasksToColumns` (dopasowanie po
nazwie statusu bez wielkości liter i nadmiarowych spacji; zadanie ze statusem,
którego plan nie zna, dostaje **własną kolumnę** zamiast zniknąć; liczniki
i wycinek tytułów liczone na wejściu) i jest używane przez `_withPlanColumns`,
więc podmiana kolumn jest bezstratna **z konstrukcji**, a nie tylko dlatego, że
gałąź jest nieosiągalna. (2) Test `plan z własnymi kolumnami nie odbiera
szablonowi kart` podaje plan z własnymi kolumnami („W realizacji”) i wymaga, by
kolumny szablonu i dwie karty zostały nietknięte — to odpowiedź na brakujące
w review twierdzenie. (3) Test jednostkowy mapowania sprawdza dopasowanie
„W realizacji” / „ w REALIZACJI ”, zachowanie koloru kolumny planu oraz własną
kolumnę dla nieznanego statusu. (4) Kolor statusu na liście podglądu bierze się
teraz z klucza znormalizowanego (`projectPreviewStatusKey`, wspólnego
z mapowaniem), więc inna pisownia statusu nie odbiera wierszowi koloru
(`template_list_preview.dart`); wcześniej było to dopasowanie dokładne.
(5) Nota podsumowania mówi „Zgodne z planem serwera" z ciałem wyjaśniającym, że
serwer sprawdził wersję szablonu i nie zmienia jego workflow — wcześniejszy
tytuł „Zatwierdzone przez plan" sugerował, że plan zatwierdził listę kolumn,
których dla projektu z szablonu w ogóle nie niesie.

**Świadomie przepisany test:** `podsumowanie projektu z szablonu zachowuje
kolumny i karty` — asercja tytułu noty z „Zatwierdzone przez plan" na
„Zgodne z planem serwera", z komentarzem dlaczego.

**Kontrola mutacyjna:** po zmianie mapowania na „pomiń zadanie bez pasującej
kolumny" (czyli zachowanie, które zarzuca review) test jednostkowy failuje:
`Expected: an object with length of <3> Actual: [2 kolumny]`.

Komendy i wyniki: `flutter test test/workspaces/presentation/projects` →
**109/109 PASS**; pełny `flutter test` → **1378/1378 PASS**;
`flutter analyze lib test` → No issues found; `flutter build web --wasm` →
`✓ Built build/web`; `git diff --check` czysty. Backend bez zmian: jego
zachowanie było już poprawne i pokryte testem integracyjnym, więc „poprawianie
backendu" nie miało tu czego naprawiać.

Otwarte (świadomie): podgląd nie zna identyfikatorów zadań, więc mapowanie
działa po nazwie statusu — **zaktualizowane tego samego dnia wpisem
`WIZ-PREVIEW-PLAN`**: to ograniczenie zniknęło, bo plan serwera niesie teraz
kolumny i zadania z nazwą kolumny docelowej, a front tylko je pokazuje.

### 2026-09-20 — OnlyOffice callback bez uczestników: fail-closed

Status: **DONE** — niejednoznaczny callback zapisu jest odrzucany także wtedy,
gdy podpisany payload i lokalny rejestr sesji nie wskazują żadnego uczestnika.
Warunek ACL sprawdza teraz `participants.Length == 0` obok uczestników bez
`CanEdit`; wcześniej komentarz deklarował fail-closed, lecz pusty zbiór omijał
pętlę i przechodził jako zapis techniczny właściciela. Test regresyjny dopisano
do `UnattributedOnlyOfficeSaveDoesNotBypassRevokedEditorAccess`.

### 2026-09-20 — WIZ-PREVIEW-PLAN: plan serwera niesie kolumny i mapowanie zadań (backend + front)

Status: **DONE (2026-09-20)** — poprzedni wpis `WIZ-PREVIEW-CARDS` domykał lukę
mapowaniem po stronie klienta; po uwadze „masz dostęp do backendu" mapowanie
wychodzi teraz z serwera, a front tylko je pokazuje.

**Kontrakt rozszerzony (tylko addytywnie, więc starszy klient działa dalej):**
- `ProjectSetupPreviewResponse.Tasks` — lista zadań, które powstaną, każde
  z nazwą kolumny docelowej: `ProjectSetupTaskPreviewResponse(Title, StatusName,
  Priority, Labels)`. Pisane wielką literą pole priorytetu to wartość kontraktu
  (`High`), etykiety to nazwy, bo identyfikatory źródłowe są wewnętrzne dla
  snapshotu. Dla pustego projektu lista jest pusta.
- `ProjectSetupWorkflowPreviewResponse.SystemStatusCount` przestał być stałą
  `TaskSystemWorkflowDefaults.Workflow.Count`, a stał się **liczbą statusów
  systemowych z planu**: dla projektu z szablonu jest to liczba statusów zapisanych
  w snapshotcie (z fallbackiem do domyślnych, gdy snapshot ich nie opisuje).
- `ProjectSetupWorkflowPreviewResponse.CustomStatuses` dla projektu z szablonu
  niesie **własne statusy szablonu** (nazwa, kolor, kategoria, pozycja, limit WIP,
  czy domyślny), czyli kolumny, które naprawdę powstaną. Wcześniej plan zwracał tu
  pustą listę, więc klient nie miał z czego zbudować finalnej tablicy.

**Skąd plan wie, do której kolumny trafi zadanie.** Nowa
`ProjectTemplateMaterializer.ColumnNameFor(task, snapshot)` używa dokładnie tej
samej reguły co materializacja: zadanie z własnym statusem dostaje nazwę tego
statusu, a pozostałe — nazwę statusu systemowego ze snapshotu (albo nazwę domyślną,
gdy snapshot go nie opisuje). `ProjectSetupPlanner.ResolveTaskPlans` buduje z niej
listę zadań planu w kolejności materializacji (pozycja, identyfikator), więc plan
i zapis nie mogą się rozjechać.

**Jedna pułapka zapisu, świadomie zamknięta.** Skoro plan deklaruje teraz własne
statusy szablonu, pętla `foreach (plan.Workflow.CustomStatuses)` w
`ProjectSetupWriter` dodałaby je **drugi raz** obok materiału snapshotu, więc dla
projektu z szablonu jest pominięta (komentarz w kodzie + asercja w teście, że
status występuje dokładnie raz).

**Front konsumuje plan, zamiast dopasowywać po nazwie.** `buildProjectPreviewSnapshot`
przyjmuje teraz cały `ProjectSetupPreviewResponse` (a nie sam `workflow`) i gdy plan
niesie zadania, buduje podsumowanie z planu: kolumny z jego statusów, karty
rozłożone po `statusName` (liczniki z pełnej listy, wycinek listy z pierwszych
wierszy), priorytet i etykiety wprost z planu, a etykiety i pola projektu nadal
z podglądu szablonu. Plan bez listy zadań (starszy Backend) zostawia dotychczasową
ścieżkę: kolumny i karty z szablonu — dzięki temu aktualizacja API nie jest
warunkiem działania kreatora. Mapowanie `mapProjectPreviewTasksToColumns` zostało
jako mechanika rozkładania, a nie jako zgadywanie nazw.

**Testy.** Backend: nowy `TemplatePreviewReportsColumnsAndColumnOfEachTask` —
podgląd zwraca własny status szablonu (`Default` + `systemStatusCount == 6`,
kolor `#7C3AED`), zadanie z nazwą kolumny docelowej (`statusName` = nazwa własnego
statusu) i po wykonaniu setupu dokładnie jeden taki status oraz jedno zadanie.
Front: nowy test `plan serwera jest źródłem kolumn i kart podsumowania` (kolumna
z planu, karty w niej, priorytet i etykiety z planu, licznik 2, źródło kolumn
z szablonu bo tam należy wybór użytkownika) plus zachowane testy ścieżki bez listy
zadań. Front: `flutter test test/workspaces/presentation/projects` → **110/110**;
pełny `flutter test` → **1379/1379 PASS**; `flutter analyze lib test` → No issues
found; `flutter build web --wasm` → `✓ Built build/web`. Backend:
`dotnet test --filter "FullyQualifiedName~ProjectSetup|FullyQualifiedName~Project"`
→ **160/160 PASS**; pełny `dotnet test` → **1240 PASS / 7 FAIL / 4 SKIP**, a te
7 to `MeEndpointsTests`, które **failują identycznie bez moich zmian** — dowód
przeprowadzony przez `git stash push` moich plików, ponowny przebieg (te same
7) i `git stash pop`; to znany, udokumentowany brak rejestracji
`DeviceSessionRealtimeConnectionRegistry` w kontenerze testowym. Model
`ProjectSetupTaskPreviewResponse` dostał `@Freezed(makeCollectionsUnmodifiable:
false)` — bez tego generator wypuszcza nieskompilowany plik, którego
`flutter analyze` nie widzi (patrz wcześniejszy wpis o freezed).

Otwarte (świadomie): podgląd nadal nie zna identyfikatorów zadań, tylko nazwy
kolumn — to wystarcza, bo nazwa kolumny jest unikalna w projekcie; gdyby kontrakt
kiedyś dopuścił dwie kolumny o tej samej nazwie, mapowanie trzeba oprzeć na
identyfikatorze statusu. Windows/Linux pozostają pominięte decyzją użytkownika.

### 2026-09-20 — KANBAN-ASSIGNEE-UI6: pasmo na pasek przewijania w obu widokach tablicy

Status: **DONE** — uwaga z użycia: pasek przewijania tablicy wchodził na kolumny.

Pasek przewijania tablicy jest poziomy i leży na dole, a kolumny mają pełną
wysokość, więc jego uchwyt nachodził na dolną krawędź kolumny — w widoku osób
na wiersz „Dodaj zadanie”, a w widoku statusów na strefę upuszczenia. Teraz obie
tablice rezerwują pod pasek własne pasmo:

- nowe tokeny `KanbanCardTokens.boardScrollbarThickness = 10` i
  `boardScrollbarReserve = 18` (pasmo = grubość paska plus margines);
- widok statusów: `padding` listy `fromLTRB(gutter, gutter, gutter, reserve)`,
  `thickness: boardScrollbarThickness`, `trackVisibility` i `interactive`
  bez zmian;
- widok osób: to samo pasmo i ta sama grubość, a przy okazji doszły
  `trackVisibility: true` i `interactive: true`, które miał tylko widok
  statusów — oba paski zachowują się teraz identycznie;
- kolumny kończą się nad pasmem, bo padding listy działa wewnątrz viewportu,
  więc treść nie może wejść pod uchwyt.

Test `kanban_board_scrollbar_reserve_test.dart` mierzy w obu widokach odstęp
między dolną krawędzią kolumny a dolną krawędzią tablicy i wymaga, by był nie
mniejszy niż grubość paska, oraz sprawdza, że oba paski używają tego samego
tokenu grubości (widok osób także `trackVisibility`). **Kontrola mutacyjna**:
po przywróceniu w widoku osób paddingu `vertical: 4` test failuje
(`Expected: >= 10.0, Actual: 4.0`).

Komendy i wyniki: `flutter test test/workspaces/presentation/tasks
test/workspaces/data/kanban` → **507/507 PASS**; pełny `flutter test` →
**1383/1383 PASS** (z późniejszymi zmianami z tej samej sesji, patrz
`KANBAN-ASSIGNEE-BACKEND2`); `flutter analyze lib test` → No issues found;
`flutter build web --wasm` → `✓ Built build/web`; `git diff --check` czysty.
Zrzuty `docs/recovery/visual-captures/kanban_*.png` odświeżyły się przy okazji
uruchomienia testu zrzutów (kolumny kończą się wyżej).

### 2026-09-20 — KANBAN-ASSIGNEE-BACKEND2: filtr statusu, domyślny Compact, jeden quick filter na snapshot

Status: **DONE dla trzech uwag backendowych z review** + **rekomendacje w dwóch
decyzjach produktowych**. Kolejność wdrożenia: najpierw dwa błędy (quick filter,
gęstość), potem zakres P1 (filtr statusu).

**1 [P1] Filtr statusu w widoku osób — kontrakt i oba readery.** Nowy model mówi,
że gdy osobę wybiera kolumnę, status jest filtrem **kart**. Kontrakt:
`KanbanBoardQuery` i `KanbanColumnQuery` mają teraz `Status` (`ProjectTaskStatus?`)
i `CustomStatusId` (`Guid?`); `IsFiltered` i `ToColumnQuery` je uwzględniają, więc
filtr dziedziczą liczniki, pierwsze strony i doładowania kolumn. Predykat jest
jeden (`ApplyStatusFilter`: własny status albo status systemowy) i używany przez
oba readery — `KanbanBoardReader` (kolumny statusów) i `KanbanAssigneeBoardReader`
(grupy osób). **Kursor jest częścią kontraktu filtra**: oba rekordy kursora niosą
`Status`/`CustomStatusId`, a `DecodeCursor` je porównuje — kursor wydany dla
`InProgress` jest odrzucany, gdy strona prosi o `Todo`, zamiast doklejać obcą
stronę. Walidacja odrzuca pusty `customStatusId` i status spoza enuma.

Front: `KanbanBoardFilter` i `KanbanColumnQuery` mają `status`/`customStatusId`
(transport wysyła `status` jako `wireValue` i `customStatusId`), doszły komendy
`setFilterStatus`/`setFilterCustomStatus`, a w wierszu poleceń pojawiło się menu
„Status" **tylko w widoku osób** — w widoku statusów kolumna sama jest statusem,
więc ten wymiar jest tam zbędny (odwrotnie niż filtr wykonawcy, który jest tylko
w widoku statusów). Pasek aktywnych filtrów dostał chip statusu z nazwą kolumny.

**Po drodze znalazłem realny błąd klasy „cichy brak odświeżenia”.**
`KanbanBoardFilter` miał własne `==`/`hashCode` obejmujące tylko trzy pola
(wykonawca, priorytet, kamień milowy). Filtr różniący się **wyłącznie** statusem
był więc uznawany za ten sam, a `TasksBoardRuntimeCoordinator.setFilter` pomija
identyczny filtr — zmiana nie odświeżyłaby tablicy. Równość obejmuje teraz
wszystkie wymiary (komentarz w kodzie mówi dlaczego).

**2 [P2] Domyślna gęstość to `Compact`.** Zmienione we wszystkich miejscach,
które ją ustawiały: encja `ProjectKanbanSettings` (konstruktor i reset
domyślnych), `KanbanSettingsService` (brak rekordu ustawień), kontrakt
(`DefaultCardDensity` w żądaniu) i plan kreatora
(`ProjectSetupPlanner.ResolveTaskView`). Front wysyłał gęstość jawnie
(`ProjectSetupDraft.boardDensity`), więc jego domyślna wartość też zmieniła się
na `compact` — inaczej kreator nadpisywałby serwerowy domyśl. **Aktualizacja (wpis `KANBAN-ASSIGNEE-BACKEND3`): backfill wycofany decyzją
właściciela.** Migracja `CompactDefaultKanbanCardDensity` została usunięta
z łańcucha, bo nadpisywała także świadome wybory użytkowników. Obowiązuje
„domyślna wartość tak, backfill nie": zmiana domyślnej gęstości obejmuje nowe
projekty i projekty bez zapisanych ustawień, a istniejące zachowują swoje
gęstości i mogą je zmienić w ustawieniach projektu. Test
`DensityDefaultsToCompactForProjectWithoutSettingsAndInRequest` pilnuje, że brak
rekordu i brak pola w żądaniu dają `Compact`, a jawny `Detailed` nadal wygrywa.

**3 [P2] Quick filter nakładany dwa razy.** `ProjectCards(...)` już aplikował
filtr, a `LoadFirstPageTaskIdsAsync` robił to ponownie — z **drugim**
`DateTime.UtcNow`, więc przy „DueSoon" liczniki i pierwsza strona mogły opisywać
przesunięte o mikrosekundy okno. Metoda przyjmuje teraz gotowe, przefiltrowane
źródło (`IQueryable<ProjectTask>`, bez dostępu do `db`, filtra i zegara — jest
`static`, więc ponowne nałożenie filtra jest niemożliwe z konstrukcji), a cały
snapshot liczy jedno `nowUtc`. Test
`DueSoonCountsAndFirstPageShareOneSnapshotInstant` sprawdza, że licznik grupy
i pierwsza strona wskazują tę samą kartę (termin +1 dzień), przy karcie poza
oknem (+8 dni) i przeterminowanej (-1 dzień).

**Decyzje produktowe, o które prosiło review.**
- **Gęstość: zostaje wspólnym ustawieniem projektu** (nie przenosimy jej do
  preferencji użytkownika). Model projektu, kreator i ustawienia już tak ją
  traktują, a przeniesienie do preferencji oznaczałoby zmianę kontraktu i pytanie
  w kreatorze o wartość, której projekt nie zapisuje. Domyślna wartość zmieniona
  na `Compact` + backfill wyżej.
- **Widoczność kolumn osób: rekomendacja — synchronizacja przez preferencję
  serwerową** (`UserKanbanPreference`, tam gdzie już są zwinięte kolumny i szybki
  filtr), bo dwie bliskie preferencje w dwóch różnych miejscach mylą. Teraz
  działa lokalnie (`SharedPreferencesTasksBoardViewStore`), a przeniesienie to
  osobny pakiet: zapis preferencji jest wersjonowany, więc szybkie przełączanie
  checkboxów wymaga tej samej kolejki intencji z rebase, którą ma
  `TasksBoardPreferenceCommands` — bez tego wracamy do wyścigu, który właśnie
  zamknąłem w `KANBAN-ASSIGNEE-REVIEW3`. Otwarte z nazwanym powodem, nie
  obietnica.

Komendy i wyniki: backend `dotnet test --filter
"FullyQualifiedName~Kanban|FullyQualifiedName~Project"` → **234/234 PASS**;
pełny `dotnet test` → **1245 PASS / 7 FAIL / 4 SKIP**, gdzie 7 to znane
`MeEndpointsTests` (brak rejestracji `DeviceSessionRealtimeConnectionRegistry`
w kontenerze testowym) — przy poprzedniej zmianie udowodniłem `git stash` +
ponownym przebiegiem, że failują bez moich zmian; `dotnet ef database update`
zastosował migrację na lokalnej bazie. Front: `flutter test` → **1383/1383
PASS**, `flutter analyze lib test` → No issues found, `flutter build web --wasm`
→ `✓ Built build/web`, `git diff --check` czysty w obu repo. Testy nowe: backend
`StatusFilterNarrowsPersonCountsAndFirstPage`,
`StatusFilterTravelsInTheCursorAndRejectsAForeignCursor`,
`StatusFilterNarrowsStatusBoardCountsColumnPagesAndCursor`,
`DueSoonCountsAndFirstPageShareOneSnapshotInstant`,
`DensityDefaultsToCompactForProjectWithoutSettingsAndInRequest`; front
`filtr statusu w widoku osób jedzie do odczytu grup i wraca po świeże`,
`filtr statusu pojawia się w widoku osób i zawęża grupy po stronie Backendu`.

Otwarte (świadomie): menu statusu w widoku osób pokazuje kolumny projektu
(systemowe i własne) — własny status jedzie wtedy jako `customStatusId`, ale
filtra kamienia milowego nadal nie ma kontrolki w wierszu poleceń; przeniesienie
widoczności kolumn do preferencji serwerowej czeka na pakiet opisany wyżej.

### 2026-09-20 — KANBAN-ASSIGNEE-BACKEND3: jeden wymiar statusu, wycofany backfill gęstości

Status: **DONE dla dwóch uwag z review** — P1 (dwa filtry statusu naraz) i P1
(migracja nadpisywała świadome wybory). Oba z testami i kontrolą mutacyjną.

**1 [P1] Status to jeden wymiar, pilnowany w modelu i w kontrakcie.** Review
wskazał trzy objawy jednej przyczyny: front ustawiał `status` i `customStatusId`
osobnymi komendami, „Pokaż wszystkie” wysyłał dwa niezależne wywołania (wyścig),
a powrót do widoku statusów nie zdejmował filtra statusu. Naprawa po kolei:

- **model**: `KanbanBoardFilter.copyWith` sam pilnuje niezmiennika — podanie
  `status` zdejmuje `customStatusId` i odwrotnie. Dwa naraz opisują sprzeczne
  zbiory kart (karta ma albo własny status, albo systemowy), więc nie może ich
  w ogóle dać się ustawić, niezależnie od tego, kto woła `copyWith`;
- **komenda**: `setStatus`/`setCustomStatus` zastąpione jedną
  `setStatusColumn({status, customStatusId})` — jeden wymiar, jedna operacja
  i jedno odświeżenie; „Pokaż wszystkie” i wybór kolumny idą tą samą drogą
  (wcześniej czyszczenie szło dwiema ścieżkami, a między nimi tablica była
  zawężona do jednego filtra);
- **grupowanie**: `setGrouping` zdejmuje filtr, którego kontrolka znika w danym
  widoku — wejście w widok osób czyści filtr wykonawcy (jak dotąd), a **powrót
  do widoków statusów czyści filtr statusu**, bo kolumna sama jest tam statusem
  i ukrytego filtra nie da się zmienić z UI;
- **backend**: `KanbanBoardReader` i `KanbanAssigneeBoardReader` odrzucają żądanie
  z oboma wymiarami naraz (`EnsureSingleStatusDimension`) komunikatem
  „Filtr statusu Kanban wskazuje jednocześnie status systemowy i własny; wybierz
  jeden z nich.” — zamiast po cichu AND-ować predykaty i zwracać pustą tablicę.
  Walidacja jest w walidatorach tablicy i kolumny, więc dotyczy też kursora.

Testy: front `status to jeden wymiar: własny zdejmuje systemowy jedną operacją`
(sprawdza też, że „Pokaż wszystkie” odświeża tablicę **dokładnie raz**) oraz
`powrót do widoku statusów zdejmuje filtr statusu`; backend
`SystemAndCustomStatusFilterTogetherAreRejected` i
`StatusBoardRejectsSystemAndCustomStatusFilterTogether` (oba readery, żądanie
tablicy i żądanie kolumny). **Kontrole mutacyjne**: po zdjęciu niezmiennika
z `copyWith` test frontu failuje (`Expected: null Actual: inProgress`), a po
usunięciu czyszczenia w `setGrouping` — `powrót do widoku statusów` failuje tak
samo.

**2 [P1] Backfill gęstości wycofany.** Review słusznie zauważył, że migracja
`CompactDefaultKanbanCardDensity` nadpisywała także świadome wybory, bo
w zapisanych wierszach nie da się odróżnić wartości domyślnej od jawnej.
Migracja jest **usunięta z łańcucha** (`dotnet ef database update` na poprzednią,
`dotnet ef migrations remove`; historia migracji kończy się teraz na
`20260920173627_AddStorageFileVersionChangedBy`), a snapshot wrócił do stanu
poprzedniego. Zmiana domyślnej wartości w kodzie zostaje — obejmuje nowe projekty
i projekty bez zapisanych ustawień, a istniejące zachowują swoje gęstości i mogą
je zmienić w ustawieniach projektu. Decyzja właściciela jest więc zapisana jako:
**domyślna wartość tak, backfill nie**.

Komendy i wyniki: backend `dotnet test --filter
"FullyQualifiedName~Kanban|FullyQualifiedName~Project"` → **236/236 PASS**, a
test wydajności `ReadLatencyAndQueryCountStayBoundedAcrossMemberScales` przechodzi
w izolacji (10 s) — jego pojedynczy fail w trakcie przebiegu był skutkiem
obciążenia maszyny (równolegle szły frontowe bramki i build web), nie regresją;
`dotnet test --filter "FullyQualifiedName~Kanban"` → **86/86 PASS**;
front `flutter test` → **1385/1385 PASS**; `flutter analyze lib test` → No issues
found; `flutter build web --wasm` → `✓ Built build/web`; `git diff --check`
czysty w obu repo. Wpis `KANBAN-ASSIGNEE-BACKEND2` ma
zaktualizowany akapit o gęstości (backfill wycofany), żeby dokument nie opisywał
stanu, który już nie istnieje.

## 2026-09-22 — CHAT-F0: blokery i kontrakty komunikatora (front)

Zakres: [plan F0–F6](../../Backend/docs/global-chat-completion-plan-2026-09-22.md),
pakiet F0; zadania frontowe F0.1 i F0.3.

Zmiany:
- `lib/app/shell/overlays/devplanner_global_panels_host.dart` — `_buildChatPanel`
  dostarcza `RepositoryProvider<ChatInboxRepository>` z
  `composition.inboxRepository`. Gdy portu brakuje, panel zwraca jawny błąd
  konfiguracji (`devplanner-chat-incomplete-composition`) zamiast bazowej listy
  rozmów udającej nowy produkt (wcześniej `context.read<ChatInboxRepository?>()`
  w `chat_drawer.dart` zwracał `null` i włączał `_LegacyConversationList`).
- `lib/workspaces/domain/chat/management/models/chat_conversation_create_command.dart`
  — nowe pole `postingPermission` (domyślnie `Everyone`) w `props`.
- `lib/workspaces/data/chat/repositories/chat_conversation_management_repository_impl.dart`
  — `createConversation` przekazuje `postingPermission` do
  `ResolveChatConversationPayload` (wcześniej wybór AdminsOnly ginął).
- `lib/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart` —
  `submit()` przenosi `state.postingPermission` do polecenia.
- Testy: nowy przypadek „pokazuje jawny błąd konfiguracji, gdy brakuje portu
  skrzynki” i fake `_InboxRepository` w teście hosta; asercja `postingPermission`
  w teście adaptera; nowy test Cubita „wybór AdminsOnly w kanale trafia do
  polecenia utworzenia”.

Komendy i wyniki:
`flutter test test/app/shell/overlays/devplanner_global_panels_host_test.dart`
→ **4/4 PASS**;
`flutter test test/workspaces/data/chat/chat_port_adapters_test.dart
test/workspaces/presentation/chat/creation/chat_creation_cubit_test.dart`
→ **32/32 PASS**.

Ograniczenia: pełnego `flutter test`, goldenów i testów widgetowych nie
uruchamiano (zgodnie z §10 planu — dopiero po akceptacji wyglądu). F0.6
(potwierdzenie nagłówka/Nowy czat/wyszukiwania/sekcji w realnym runtime) oraz
odbiór wizualny pozostają otwarte.

Następny krok: F0.6 w uruchomionej aplikacji oraz pakiet F1 (dodawanie osób,
profil/status w panelu bez pełnoekranowego modala).

## 2026-09-22 — CHAT-F1/F6 (front): dodawanie osób, profile członków, przypięcie i tapeta

Zakres: [plan F0–F6](../../Backend/docs/global-chat-completion-plan-2026-09-22.md) —
część F1 (dodawanie osób, profile) oraz geometria F6 wykonana po F0, bo blokowała
zgłoszenie użytkownika o znikającym przypięciu i kadrze tapety.

Zmiany:
- `lib/workspaces/presentation/chat/members/chat_add_members_view.dart` (nowy) —
  lokalny podwidok w arkuszu członków: wyszukiwanie katalogu
  (`ChatDirectorySearchCubit`), multiselect, chipsy wybranych, licznik wolnych
  miejsc, oznaczenie istniejących, Dodaj/Anuluj; błąd nie zamyka widoku.
- `chat_members_sheet.dart` — arkusz ma stan podwidoku, przekazuje
  `ChatDirectoryRepository`, pokazuje profil (`member.label`) zamiast UUID oraz
  przycisk „Dodaj osoby” tylko dla Owner/Moderator i nie w rozmowie 1:1.
- `cubit/chat_members_cubit.dart` — `addMembers(List<String>)`.
- DTO/model/adapter członka — `login`, `displayName`, `avatarUrl` + `ChatMember.label`.
- ARB en/pl — 9 kluczy dodawania osób; `flutter gen-l10n` przeszło.
- **F6** — `ChatPanelScaffold` ma `canPin` niezależne od trybu `compact` (wąski
  panel na szerokim ekranie nadal się przypina); `ChatPanelSizeController.canPinAt`
  + `minAppContentWidth = 480`; rezerwacja miejsca przeniesiona z hosta do treści
  shella przez `DevPlannerPanelsScope.reservedWidth`, więc tapeta pozostaje jedną
  warstwą pełnego okna i nie zmienia kadru przy pin/unpin; animacje respektują
  `MediaQuery.disableAnimations`.

Komendy i wyniki:
`flutter analyze lib test` → No issues found; `dart format` na zmienionych plikach;
`flutter test` jawnych ścieżek: `chat_panel_size_test.dart` **4/4**,
`g5_search_and_members_test.dart` + `chat_port_adapters_test.dart` **27/27**,
`test/app/shell/overlays/` + `test/workspaces/presentation/chat/shell/` **27/27**;
`flutter build web --wasm` uruchomiony (wynik w kolejnym wpisie, jeśli różny).

Ograniczenia: pełnego `flutter test`, goldenów i testów widgetowych nie uruchamiano
zgodnie z §10 planu. Bez odbioru wizualnego: scenariusze 1280×720, 1440×900, wąskie
okno, 100–150% tekstu, pin→resize→unpin oraz punkt kadru tapety pozostają do
potwierdzenia na uruchomionej aplikacji. Popover statusu (F1) wymaga prymitywu
popovera, którego host jeszcze nie ma.

### Uzupełnienie CHAT-F1/F6 (2026-09-22) — bramki frontu

`flutter build web --wasm` → `✓ Built build/web` (exit 0). Uruchomione jawnie:
`flutter analyze lib test` → No issues found; `dart format` na zmienionych plikach
bez zmian; testy domenowe/Cubita/repository/panelu: `chat_panel_size_test.dart` 4/4,
`g5_search_and_members_test.dart` + `chat_port_adapters_test.dart` 27/27,
`test/app/shell/overlays/` + `test/workspaces/presentation/chat/shell/` 27/27;
`git diff --check` czysty. Backend F2 (reguła pomijania kodu we wzmiankach) opisany
w handoffie `../Backend`; brak więc pingów z przykładów kodu bez pracy UI.

### Uzupełnienie CHAT-F5 (2026-09-22) — klient okna wiadomości

- `lib/workspaces/data/chat/api/chat_api.dart` — `getMessageWindow(conversationId, messageId, {before, after})`.
- `lib/workspaces/data/chat/models/chat_models.dart` — DTO `ChatMessageWindowResponse`
  (anchor, messages, hasMoreBefore/After, beforeCursor); `build_runner` przegenerował
  `chat_api.g.dart` i `chat_models.freezed.dart`.
- `test/workspaces/data/chat/global_chat_contract_test.dart` — test parsowania okna.

Bramki: `flutter analyze lib test` → No issues found; `flutter test
test/workspaces/data/chat/global_chat_contract_test.dart` → 3/3 PASS;
`git diff --check` czysty. UI skoku do starej wiadomości pozostaje otwarte (F5).

### Uzupełnienie CHAT-F1 (2026-09-22) — popover statusu bez pełnoekranowego modala

- `lib/workspaces/presentation/chat/presence/chat_status_menu.dart` (nowy) —
  `ChatStatusMenuButton`: zakotwiczony `MenuAnchor`, który najpierw pobiera
  bieżący status konta, potem edytuje emoji/tekst/DND/wygaśnięcie (bez / 1 h /
  24 h) i wystawia Wyczyść/Zapisz. Nie zamyka się przed potwierdzeniem zapisu;
  błąd zostawia wartości i pokazuje kod. Nagłówek pokazuje nazwę/login i bieżący
  status (sesja nie niesie `avatarUrl`).
- `presence/chat_status_label.dart` — `ChatStatusLabel` przeniesiony z usuniętego
  `chat_status_dialog.dart`; pełnoekranowy `ChatStatusDialog` usunięty.
- Rail przyjmuje teraz `Widget? profileAction` zamiast callbacku, żeby popover
  miał własne miejsce w drzewie; nagłówek rozmowy używa tego samego przycisku.
- ARB en/pl: etykiety wygaśnięcia i błędu pobrania statusu; `flutter gen-l10n` OK.

Bramki: `flutter analyze lib test` → No issues found; `flutter test
test/workspaces/presentation/chat/shell/` → 28/28 PASS;
`test/workspaces/presentation/chat/g5_search_and_members_test.dart` → PASS;
`git diff --check` czysty. Odbiór wizualny popovera pozostaje otwarty.

### Uzupełnienie CHAT-F2 (2026-09-22) — wspólny kontrakt wzmianek (front)

- `lib/workspaces/domain/chat/mentions/chat_mention_codec.dart` (nowy) —
  `ChatMentionCodec` z `tokenFor` (`@<uuid>`), `labelFor` (nazwa → login → UUID),
  `renderText` (token → etykieta do prezentacji), `toWireText` (etykiety → tokeny
  przy wysyłce, więc ręcznie wpisana nazwa bez wyboru osoby nie pinguje) oraz
  `activeQuery` (wykrycie `@` z frazą, pomija e-maile i spacje). `ChatMentionReference`
  niesie UUID + etykietę wybranej osoby.
- `test/workspaces/domain/chat/mentions/chat_mention_codec_test.dart` — 9 testów
  (token/etykieta, render z nieznanym ID, wykrycie frazy, samo `@`, e-mail i spacja,
  wysyłka etykiet → tokenów, brak pinga dla ręcznej nazwy, runda render↔wysyłka).

Bramki: `flutter test test/workspaces/domain/chat/mentions/chat_mention_codec_test.dart`
→ 9/9 PASS; `flutter analyze lib test` → No issues found; `git diff --check` czysty.
Picker `@` w polu tekstowym (debounce, strzałki/Enter/Escape, brak wyników/offline)
oraz badge/filtr „Wzmianki o mnie” pozostają otwarte. Serwerowa reguła pomijania
obszarów kodu jest po stronie `../Backend`.

### Uzupełnienie CHAT-F3 (2026-09-22) — załączniki podłączone w produkcyjnym runtime

- `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart` — runtime
  przyjmuje `storageRepository` i `attachmentUploadTransport`; `chatComposition`
  buduje `ChatAttachmentUploadPortAdapter` (sesja Chat + Storage + transport
  binarny) oraz `FilePickerPortImpl` wyłącznie, gdy istnieje bezpieczna ścieżka
  uploadu. Jawnie podane porty z konstruktora nadal mają pierwszeństwo.
- `lib/app/devplanner_app.dart` — przekazuje `widget.storageRepository` i
  `PresignedUploadTransport()` tylko dla kompozycji desktop PKCE
  (`!transport.isBffCookieTransport && transport.supportsStandaloneApiClients`).
  Web/BFF nie dostaje portu uploadu ani pickera, więc panel nie pokazuje akcji
  bez Bearera — ten sam warunek, którego używa moduł Files.

Bramki: `flutter analyze lib test` → No issues found; `dart format` na zmienionych
plikach; `flutter build web --wasm` → PASS. Odbiór wizualny paska załączników,
progresu/retry, wklejania i drag/drop oraz renderu multimediów w historii pozostaje
otwarty (F3 UI), podobnie jak forward mediów.

### Uzupełnienie CHAT-F4 (2026-09-22) — spójny renderer historii (delta Quill)

- `lib/workspaces/domain/chat/rich_text/chat_rich_text_codec.dart` (nowy) —
  `ChatRichTextCodec.tryParse(deltaJson)` zamienia deltę Quill na bloki (akapit,
  listy punktowana/numerowana, cytat, blok kodu z językiem) i spany inline
  (bold/italic/underline/strike/code, bezpieczny link HTTP/HTTPS albo ścieżka
  aplikacji). Nieczytelna delta → `null` (UI pokazuje tekst zapasowy), osadzony
  obiekt → znacznik „nieobsługiwana treść” bez psucia reszty.
- `lib/workspaces/presentation/chat/rich_text/chat_rich_text_body.dart` (nowy) —
  renderer historii: monospace, poziomy scroll, kopiowanie i zwijanie bloku
  dłuższego niż 12 linii; zero wykonywania HTML/skryptów. Wpięty w
  `chat_conversation_message_list.dart` i `chat_panel_conversation_parts.dart`.
- ARB en/pl: „Kopiuj kod”, „Skopiowano”, „Pokaż całość”, „Zwiń”,
  „[nieobsługiwana treść]”; `flutter gen-l10n` OK.

Bramki: `flutter test test/workspaces/domain/chat/rich_text/chat_rich_text_codec_test.dart`
→ 6/6 PASS; `flutter test test/workspaces/presentation/chat/shell/` → 22/22 PASS;
`flutter analyze lib test` → No issues found; `git diff --check` czysty.
Pozostaje: toolbar Quill i tryb „Formatowanie/Rozwiń edytor”, „Wstaw kod”,
snippet z długiego wklejenia i atomowość dołączania snippetu (F4 UI).

### Uzupełnienie CHAT-F5 (2026-09-22) — skok do starej wiadomości w panelu

- `lib/workspaces/domain/chat/conversation/models/chat_message_window.dart` (nowy) —
  `ChatMessageWindow` (`anchorMessageId`, `messages`, `hasMoreBefore/After`, `beforeCursor`).
- `ChatConversationRepository.loadMessageWindow(...)` + implementacja w
  `ChatRepositoryImpl` na `getMessageWindow`, więc skok nie zależy od liczby
  pobranych stron ani od bieżącego filtra skrzynki.
- `ChatConversationCubit.ensureTargetLoaded(messageId)` — doładowuje okno, scala
  wiadomości i przejmuje `beforeCursor`; brak dostępu odłącza historię, brak samej
  wiadomości ustawia `jumpFailureCode`. `ChatConversationReady` ma `copyWith`,
  `isJumpingToMessage` i `jumpFailureCode`.
- `chat_panel_conversation.dart` wywołuje skok po wczytaniu rozmowy z celem i
  pokazuje pasek: ładowanie albo komunikat z ponowieniem (zachowując historię).
- Atrapy w 8 plikach testowych dostały implementację nowej metody portu.

Bramki: `flutter test test/workspaces/presentation/chat/chat_conversation_cubit_test.dart`
→ 5/5 PASS (skok scala historię i kursor; brak wiadomości daje komunikat, nie pustą
historię); regresja zmodyfikowanych atrap → 24/24 PASS; `flutter analyze lib test`
→ No issues found; `git diff --check` czysty. Potwierdzenie w runtime otwarte.

### Poprawki po review CHAT-REVIEW-FIX (2026-09-22) — front

1. `ChatRichTextCodec.tryParse` akceptuje kontrakt transportu: **tablicę operacji**
   Quill oraz starszą kopertę `{"ops":[...]}`. Wcześniej renderer odrzucał
   prawidłową deltę z composera i pokazywał zwykły tekst; testy używają teraz
   realnego kształtu (`jsonEncode(ops)`).
2. Skok do starej wiadomości działa w jawnym **trybie okna**:
   `ChatConversationReady.jumpAnchorMessageId`/`isWindowedHistory`,
   `ChatConversationCubit.ensureTargetLoaded` zastępuje historię ciągłym zakresem
   (bez scalania z najnowszą stroną), `loadMore` używa kursora okna, realtime nie
   dopisuje niesąsiadujących wiadomości, a `exitWindowHistory()` →
   `load(replaceHistory: true)` czyści tryb bez luki. Panel pokazuje pasek
   „Widok wokół wskazanej wiadomości” z akcją „Pokaż najnowsze”.
3. ARB en/pl: `chatWindowHistoryBanner`, `chatWindowHistoryLatest`.

Bramki: `flutter analyze lib test` → No issues found;
`chat_rich_text_codec_test.dart` 7/7; `chat_conversation_cubit_test.dart` 5/5;
regresja `shell/`, `conversation_delivery/`, `thread/`, wątki/dyskusje oraz odczyt
→ 36/36; `git diff --check` czysty. Uwaga: wcześniejszy `dart format` na całym
katalogu `presentation/chat/` przestawił zawijanie linii w kilku niezwiązanych
plikach; poprawiono tylko lint w `chat_inbox_row.dart`, reszta to czyste formatowanie.

### Uzupełnienie CHAT-F2 (2026-09-22) — picker @ i pokrycie testami

- `lib/workspaces/presentation/chat/mentions/chat_mention_picker_controller.dart`
  (nowy) — `ChatMentionPickerController`: debounce, odrzucanie spóźnionych
  odpowiedzi (generation guard), fraza < 2 znaków nie pyta backendu, błąd z kodem
  i `retry()`, strzałki z zawijaniem, `close()`.
- `lib/workspaces/presentation/chat/mentions/chat_mention_suggestions.dart` (nowy) —
  zakotwiczona lista nad polem: kandydaci, brak wyników, ładowanie, odmowa z ponowieniem.
- Composer: `_syncMentionQuery` na kontrolerze tekstu (tekst i kursor), przejęcie
  `↑/↓/Enter/Escape` gdy lista otwarta, `_acceptMention` wstawia etykietę przez
  `ChatMentionCodec.applyMention` i rejestruje `ChatMentionReference`; picker czyta
  `ChatSearchRepository?` z kontekstu, więc brak portu = brak listy.
- `ChatComposerDraft.mentions` + `ChatComposerCubit.setMentions`; edycja tekstu
  przycina wzmianki przez `pruneMentions`, a `ChatConversationCubit.sendDraft`
  zamienia etykiety na tokeny `@<uuid>` dopiero na granicy wysyłki.
- ARB en/pl: `chatMentionPickerHint`, `chatMentionPickerEmpty`.

Testy: `chat_mention_codec_test.dart` **11/11** (token/etykieta, render, query,
applyMention, prune, runda render↔wysyłka), `chat_mention_picker_controller_test.dart`
**7/7** (debounce, spóźniona odpowiedź, za krótka fraza, błąd + retry, strzałki,
zamknięcie), `chat_conversation_cubit_test.dart` **6/6** (m.in. konwersja etykiety na
UUID w komendzie wysyłki), `chat_composer_draft_persistence_test.dart` **6/6**
(wzmianki przeżywają edycję, skasowana nazwa je usuwa); łącznie 49/49 w tych suitach;
`flutter analyze lib test` → No issues found; `git diff --check` czysty.
Otwarte: pozycja `@all` w pickerze, badge/filtr „Wzmianki o mnie”, odbiór wizualny.

### Uzupełnienie CHAT-F4 (2026-09-22) — akcja „Wstaw kod”

- `lib/workspaces/domain/chat/rich_text/chat_code_block_codec.dart` (nowy) —
  `ChatCodeBlockCodec.build/encode`: operacje delty z atrybutem `code-block`
  (język albo `true`) na operacji kończącej linię, limit 20 000 znaków, przycinanie
  końcowych pustych linii, pusty kod bez bloku.
- `lib/workspaces/presentation/chat/rich_text/chat_code_block_dialog.dart` (nowy) —
  mały formularz: język opcjonalny, kod monospace (Enter dodaje linię), „Wstaw”.
- Composer: przycisk `chat-composer-insert-code`; w trybie rich wstawia operacje do
  dokumentu Quill w miejscu kursora, w plain wstawia ogrodzenie ``` na zaznaczenie.
  ARB en/pl: `chatComposerInsertCode`, `chatComposerCodeLanguage`,
  `chatComposerCodeContent`, `chatComposerCodeSubmit`.

Bramki: `flutter test test/workspaces/domain/chat/rich_text/` → 12/12 (w tym 6 nowych
dla bloku kodu); `test/workspaces/presentation/chat/composer/` → 36/36;
`flutter analyze lib test` → No issues found; `git diff --check` czysty.
Pozostaje: pełny toolbar Quill i tryb rozszerzonego edytora, snippet z długiego
wklejenia i atomowość dołączania snippetu; odbiór wizualny całego composera.

### Uzupełnienie CHAT-F5 (2026-09-22) — sesyjny badge nieprzeczytanych (zamknięty panel)

- `lib/workspaces/presentation/chat/inbox/cubit/chat_unread_cubit.dart` (nowy) —
  `ChatUnreadCubit`: liczy wyłącznie z serwerowego agregatu `inbox/unread-count`,
  błąd nie zeruje ostatniego potwierdzonego stanu, `applySignal()` scala serię
  zdarzeń realtime w jedno odświeżenie, `reset()` czyści po zakończeniu sesji.
- Host (`devplanner_global_panels_host.dart`): tworzy sesyjny licznik, gdy kompozycja
  ma port skrzynki, pobiera pierwszy stan, zeruje go po zniknięciu kompozycji i
  podłącza sygnał `WorkspaceNotificationsRealtimeService.events` — każda wiadomość
  Chat publikuje powiadomienie dla odbiorcy, więc odświeżenie działa też przy
  zamkniętym panelu. Licznik jest montowany nad treścią (`BlocProvider`).
- Belka (`devplanner_shell_layout.dart`): ikona czatu pokazuje `Badge` z licznikiem
  (brak portu = brak badge, bez lokalnego zgadywania).
- Panel po realnym odczycie odświeża także licznik sesyjny, więc badge spada od razu.

Bramki: `chat_unread_cubit_test.dart` **5/5** (agregat, brak zerowania po błędzie,
scalanie sygnałów, reset); `test/app/shell/` + `test/workspaces/presentation/chat/inbox/`
→ **39/39**; `flutter analyze lib test` → No issues found; `git diff --check` czysty.
Do potwierdzenia w runtime: badge przy zamkniętym panelu na dwóch sesjach oraz
odświeżenie listy po dodaniu do rozmowy (eventy członkostwa idą tym samym kanałem
powiadomień, ale wymagają sprawdzenia na żywo).

### Uzupełnienie CHAT-F5 (2026-09-22) — metadane dymka i nazwa DM

- `lib/workspaces/presentation/chat/messages/chat_message_metadata.dart` (nowy) —
  `ChatMessageMetadata.timeLabel` (`HH:mm` lokalnie) i `statusFor` (własna,
  nieusunięta wiadomość: `sending` bez ponowienia, `failed` z ponowieniem, `sent`;
  cudza/usunięta bez statusu). Nic nie jest zgadywane — brak potwierdzenia serwera
  to „wysyłanie”, nigdy „dostarczono”.
- `chat_panel_conversation_parts.dart`: `_ChatMessageFooter` (autor w grupach,
  godzina, „edytowano”, status + „Ponów”) i `_StatusGlyph`; `participantLabels`
  przekazywane z panelu (mapa z katalogu skrzynki, w DM pusta). `ChatPanelConversationHeader`
  przyjmuje `title`, więc DM pokazuje etykietę rozmówcy zamiast `scopeKey`.
- `chat_panel_conversation.dart`: `_participantLabels` i `_conversationTitle` czytają
  skrzynkę i przekazują etykiety; retry czyta `ChatConversationCubit`.
- ARB en/pl: `chatMessageStatusSending/Sent/Failed`, `chatMessageEdited`, `chatMessageRetry`.

Bramki: `chat_message_metadata_test.dart` **6/6**;
`test/workspaces/presentation/chat/shell/` + `messages/` **22/22**;
`flutter analyze lib test` → No issues found; `git diff --check` czysty.
Otwarte: avatar autora w grupach oraz `delivered/read` per wiadomość (lokalny model
nie niesie danych dostawy), odbiór wizualny dymków.

### Uzupełnienie CHAT-F2 (2026-09-22) — propozycja `@all` w pickerze

- `ChatMentionPickerController` ma `allTokenEnabled` + `setAllTokenEnabled` i getter
  `suggestsAll`: propozycja `@all` pojawia się przy samym `@` oraz gdy fraza pasuje
  do tokenu, a wyłączenie uprawnień natychmiast ją chowa.
- `ChatMentionSuggestions` rysuje kafelek `@all` (ARB `chatMentionAllOption`) tylko
  gdy picker ma uprawnienia i właściciel podał `onSelectAll`.
- Composer: `mentionAllEnabled` przekazywane do kontrolera, `_acceptAllMention`
  wstawia `@all ` bez rejestrowania osoby — to nie jest wzmianka o koncie ani ACL.
- Panel: `_mentionAllEnabled` dopuszcza `@all` wyłącznie dla grupy/kanału/ogłoszeń
  i roli Owner/Moderator z serwerowej skrzynki; lista kandydatów nadal pochodzi z
  endpointu sugestii filtrowanego po dostępie.

Bramki: `chat_mention_picker_controller_test.dart` **11/11** (w tym 4 nowe dla `@all`);
mentions + composer + codec → **47/47**; `flutter analyze lib test` → No issues found;
`git diff --check` czysty. Otwarte: badge/filtr „Wzmianki o mnie”, odbiór wizualny.

### Uzupełnienie CHAT-F2 (2026-09-22) — chip „Wzmianki o mnie”

- `ChatInboxFilter.mentions` (`Mentions`) w domenie skrzynki; chip w sekcji Czaty
  (`chat_inbox_list.dart` oraz `chat_panel_section.dart`) z ARB `chatInboxFilterMentions`.
- Filtr jest serwerowy: backend zwraca rozmowy z rejestru wzmianek, więc wynik nie
  zależy od pobranej strony ani od lokalnej frazy wyszukiwania.

Bramki: `test/workspaces/presentation/chat/inbox/` + `shell/` → 30/30;
`flutter analyze lib test` → No issues found; `git diff --check` czysty.
Otwarte: odbiór wizualny chipa i odświeżanie listy po wzmiance w runtime.

### Uzupełnienie CHAT-F3 (2026-09-22) — karty załączników w historii

- `lib/workspaces/presentation/chat/attachments/history/chat_message_attachments.dart`
  (nowy) — karty z nazwą, rozmiarem (`formatChatFileSize`) i typem pliku oraz jawnym
  stanem „Plik niedostępny” dla usuniętych/nieczystych plików; brak udawania pobrania.
- DTO `ChatAttachmentResponse` i model `ChatMessageAttachment` niosą `fileName`,
  `fileSizeBytes`, `contentType`, `isAvailable`; wszystkie cztery adaptery mapują je
  spójnie. Karty wpięte w dymek panelu.
- ARB en/pl: `chatAttachmentUnavailable`.

Bramki: `chat_message_attachments_test.dart` (format rozmiaru) + `shell/` → 39/39;
`flutter analyze lib test` → No issues found; `git diff --check` czysty.
Otwarte: miniatury/otwieranie i pobieranie przez autoryzowaną ścieżkę Storage,
progres per plik, wklejanie obrazu, odbiór wizualny.

### Uzupełnienie CHAT-F5 (2026-09-22) — statusy dostawy/odczytu z serwera

- `ChatMessage` i DTO `ChatMessageResponse` niosą `deliveredToCount` i `readByCount`;
  wszystkie cztery adaptery mapują je spójnie.
- `ChatMessageMetadata.statusFor` dodaje rodzaje `delivered` i `read` (z licznikiem)
  i preferuje odczyt > dostawę > „Wysłano”; bez potwierdzeń status zostaje „Wysłano”,
  więc UI nie zgaduje dostarczenia.
- `_StatusGlyph` pokazuje licznik; ARB en/pl: `chatMessageStatusDelivered`,
  `chatMessageStatusRead` (placeholdery int).
- Przy okazji: `dart format` na całym drzewie `lib/workspaces/` sformatował niezwiązany
  plik `storage_realtime_client_adapter.dart`; cofnięto go do HEAD, a wygenerowany
  `chat_models.freezed.dart` ma usunięty trailing whitespace od generatora.

Bramki: `chat_message_metadata_test.dart` 9/9; `shell/` + `messages/` 25/25;
`flutter analyze lib test` → No issues found; `git diff --check` czysty.
Pozostaje: avatar autora w grupach, odbiór wizualny.

### Uzupełnienie CHAT-F5 (2026-09-22) — awatar autora w grupach, domknięcie dymków

- `lib/workspaces/presentation/chat/shell/chat_panel_conversation_parts.dart` —
  `_ChatMessageFooter` rysuje `AppUserAvatar` (promień 9, inicjał, `semanticsLabel`)
  obok etykiety autora i tylko razem z nią. Etykieta pochodzi z katalogu skrzynki,
  więc awatar pojawia się wyłącznie wtedy, gdy serwer potwierdził profil nadawcy;
  w DM autor nadal się nie pokazuje.
- Bez nowego pola w kontrakcie: awatar korzysta z istniejącego
  `/api/v1/users/{userId}/avatar` z fallbackiem na inicjały (Flutter cache'uje
  obrazy po URL, więc lista nie generuje zapytania per wiadomość).
- Decyzja: brak osobnego mapowania `userId -> avatarUrl`, bo URL awatara jest
  pochodną `userId` i nie wymaga rozszerzania DTO członków.

Bramki: `test/workspaces/presentation/chat/shell/` + `chat_message_metadata_test.dart`
→ 25/25; `flutter analyze lib test` → No issues found; `dart format` zmienionego pliku
→ 0 changed; `git diff --check` czysty.
Otwarte: odbiór wizualny (kontrast i rozmiar awatara w wąskim panelu).

### Uzupełnienie CHAT-F3 (2026-09-22) — otwieranie/pobieranie załącznika autoryzowaną ścieżką

- Nowy port `lib/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart`
  (`ChatAttachmentAccessPort.open(storageFileId)`, `ChatAttachmentAccessFailure`
  z `code`/`message`/`traceId`); `one_member_abstracts` wyciszony lokalnie
  z uzasadnieniem, że to seam kompozycji, a nie funkcja przekazywana argumentem.
- Adapter data-layer `lib/workspaces/data/chat/attachments/chat_attachment_access_port_adapter.dart`:
  Storage wystawia bilet `/api/v1/storage/files/{fileId}/download-ticket`, a zapis
  pliku na urządzeniu robi platformowy `DownloadTransport`. Presentation nie widzi
  presigned URL ani nagłówków.
- Kompozycja: `DevPlannerGlobalChatComposition.attachmentAccessPort`, runtime buduje
  adapter z `storageRepository` + `DownloadTransportImpl` (brak Storage ⇒ brak portu
  ⇒ brak akcji), host panelu udostępnia go przez `RepositoryProvider`.
- `chat_message_attachments.dart`: karta jest `InkWell` z ikoną pobrania, spinnerem
  w trakcie i SnackBar-em z komunikatem serwera po porażce; plik niedostępny i brak
  portu nie pokazują akcji. ARB en/pl: `chatAttachmentOpen`.

Bramki: `chat_attachment_access_port_adapter_test.dart` 3/3; `attachments/` + `shell/`
+ metadane → 48/48; `flutter analyze lib test` → No issues found; `flutter gen-l10n`
wykonany; `git diff --check` czysty.
Otwarte: miniatury/galeria w aplikacji, progres per plik, wklejanie obrazu,
forward mediów, odbiór wizualny.

### Uzupełnienie CHAT-F3 (2026-09-22) — miniatury obrazów przez autoryzowany port

- `ChatAttachmentAccessPort.thumbnail(storageFileId)` — ten sam bilet pobrania,
  `DownloadTransport.fetchBytes`; porażka wraca jako `null` (karta nie pokazuje
  fałszywego podglądu). Adapter: `chat_attachment_access_port_adapter.dart`.
- `ChatMessageAttachment.isImage` rozstrzyga po typie MIME z serwera, bez
  zgadywania po rozszerzeniu nazwy.
- `_AttachmentThumbnail` w `chat_message_attachments.dart`: 36 px `Image.memory`
  dla dostępnego obrazu przy obecnym porcie, w każdym innym przypadku ikona pliku.

Bramki: `chat_message_attachment_test.dart` 3/3; adapter 9/9; `attachments/` +
`shell/` + metadane → 48/48; `flutter analyze lib test` → No issues found;
`git diff --check` czysty.
Otwarte: galeria pełnoekranowa, progres per plik, wklejanie obrazu, forward mediów.

## 2026-09-22 — CHAT-UI U0: inwentaryzacja przed przebudową komunikatora

Zakres: `docs/global-chat-messenger-ui-spec-2026-09-22.md` (nadraty nad wcześniejszymi
ustaleniami UI). Ten wpis to wyłącznie rozpoznanie drzewa i kontraktów; wyglądu nie
zmieniano i nie odebrano.

### Produkcyjna ścieżka renderowania (faktycznie używana)

`lib/app/shell/overlays/devplanner_global_panels_host.dart` buduje panel z
`DevPlannerGlobalChatComposition` i udostępnia porty przez `RepositoryProvider`
(members, presence, search, upload, access, file picker). Rozmowę renderują:

- `lib/workspaces/presentation/chat/shell/chat_panel_conversation.dart`
  (`_ChatPanelConversationContentState`, `_ChatPanelMessages`,
  `ChatPanelConversationHeader`, `ChatPanelConnectionBanner`) — header, banner okna
  historii, lista, composer.
- `lib/workspaces/presentation/chat/shell/chat_panel_conversation_parts.dart`
  (`ChatPanelMessageList`, `_ChatMessageFooter`, `_StatusGlyph`) — wiersz wiadomości,
  reakcje, karty załączników, footer, menu akcji.
- `lib/workspaces/presentation/chat/inbox/components/*` — lista skrzynki i wiersz.

Współdzielone dalej: `rich_text/chat_rich_text_body.dart` (renderer treści),
`attachments/history/chat_message_attachments.dart` (karty + miniatura + galeria),
`mentions/`, `message_actions/`, `presence/widgets/chat_typing_indicator.dart`.

Drugi renderer: `lib/workspaces/presentation/chat/chat_conversation_page.dart`
(`ChatConversationPageView` + `chat_conversation_message_list.dart`) jest używany
wyłącznie przez `lib/workspaces/presentation/chat/discussion/chat_discussion_side_panel.dart`,
a nie przez globalny panel. Rozbieżność dwóch rendererów należy usunąć przez
współdzielenie, nie przez równoległe poprawianie obu.

### Fundament wyglądu

- Theme: `lib/foundation/theme/` ma `theme.dart`, `theme_extensions.dart`
  (`extension DevPlannerContextThemeX on BuildContext`, stałe `Sizes`/`Gaps`),
  `menu_theme.dart` (`DevPlannerMenuTheme extends ThemeExtension<DevPlannerMenuTheme>`),
  `files_theme.dart`, `navigation_theme.dart`, `shell_theme.dart`, `tasks_theme.dart`.
  Wzorcem dla `chat_theme.dart` jest `DevPlannerMenuTheme` (copyWith/lerp/rejestracja
  light+dark). Pliku `chat_theme.dart` jeszcze nie ma.
- Menu: `lib/shared/presentation/widgets/app_context_menu.dart` udostępnia
  `AppContextMenu.show/select/showCustom` oraz `AppContextMenuRegion` (prawy klik,
  geometria z ekranem). Nowe menu mają używać tego mechanizmu, nie własnych MenuAnchor.

### Tożsamość, status, pisanie

- Awatar: `lib/shared/presentation/widgets/app_user_avatar.dart` (`AppUserAvatar`)
  czyta `/api/v1/users/{userId}/avatar` i `/api/v1/me/avatar`, ma fallback inicjałów
  i deterministyczny kolor. Profile i uczestnicy niosą `avatarUrl` w DTO.
- Status własny: `ChatPresenceRepository.getUserStatus/setOwnStatus/clearOwnStatus`
  oraz `presence/chat_status_menu.dart`, który dziś używa `TextField` (x2),
  `SwitchListTile` i `DropdownButtonFormField` — do zastąpienia kartą profilu,
  presetami i menu czasu.
- Online/offline: BRAK kontraktu. Repozytorium obecności zna wyłącznie custom status
  (emoji/opis/wygaśnięcie/DND), więc do czasu osobnego pakietu presence UI musi
  pokazywać „brak danych”, a nie zielone online.
- Typing: `ChatTypingCubit` (strumień `ChatConversationRealtimeClient`, TTL
  `fallbackTtl` 8 s, wyklucza własne UserId) + dziś ogólny
  `presence/widgets/chat_typing_indicator.dart` bez nazw osób.

### Długie wklejenia / snippet

- Backend ma `POST /conversations/{conversationId}/snippet` (przygotowanie; 2 000 000
  znaków wejścia, 500 000 wyjścia, PlainText/Markdown, limit 10/min, bez zapisu pliku)
  i `POST /messages/{messageId}/snippet-attachment` (wymaga istniejącego messageId).
- Polityka siedzi w `ChatLinkOptions` (`Chat:Links`): `SnippetThresholdCharacters`
  = 2 000, `SnippetMaxCharacters` = 200 000, `SnippetInputMaxCharacters` = 1 000 000.
- Front nie ma żadnego klienta snippetów ani odczytu progu → potrzebny jawny,
  addytywny kontrakt polityki (np. `GET /chat/link-policy`), żeby UI nie kopiowało
  magicznej liczby 2 000.

### Emoji

- Brak zależności emoji w `pubspec.yaml` i brak jakiegokolwiek widgetu emoji.
  `ChatEmojiPicker` trzeba zbudować; decyzja otwarta: kuratorowany lokalny zbiór
  (bez nowej zależności, bez wyszukiwania pełnego Unicode) albo dodanie pakietu
  emoji z wyszukiwaniem i kategoriami.

### Załączniki

- Gotowe i do ponownego użycia: `attachments/selection`, `attachments/upload`
  (owner per plik + kolejka atomowa), `attachments/history` (karty, miniatura,
  galeria, otwieranie/pobieranie autoryzowanym portem `ChatAttachmentAccessPort`).

### Luki do domknięcia przed U2–U4

1. Kontrakt polityki snippet + klient snippetu i dwuetapowa intencja (wiadomość + TXT).
2. Brak źródła online/offline (obecność) — „brak danych” albo osobny pakiet backendu.
3. Brak wspólnego `ChatEmojiPicker`.
4. Dwa renderery historii (panel + strona dyskusji) do scalenia.
5. Brak `chat_theme.dart` i ról kolorów dymków/composera.

## 2026-09-22 — CHAT-UI U1 (część 1): motyw czatu i prawdziwe dymki

Zakres: fundament wyglądu z `docs/global-chat-messenger-ui-spec-2026-09-22.md` §3–§4.
Wygląd pozostaje NIEZAakceptowany — brak zrzutów i ręcznego odbioru.

- `lib/foundation/theme/chat_theme.dart` (nowy): `DevPlannerChatTheme extends
  ThemeExtension` z rolami powierzchni/dymków/metadanych (panelSurface, listSurface,
  conversationSurface, composerSurface, incoming/outgoingBubble i Text, metadataText,
  linkText, mentionSurface/Text, codeSurface, separator, hoverSurface, selectedSurface,
  focusRing, presenceOnline/Away/Dnd/Unknown, deliveryRead, error), stylami treści
  (14/1.4), autora (12.5 medium), metadanych (11.5) i monospace oraz miarami
  (radius dymka 16/composera 20, padding 10/12, seria 4, autor 12, gutter 16/12,
  78%/560 dymka z 88% w compact, rail 56/przycisk 40/ikona 22/gap 8, akcja composera 40,
  awatary 44/36/30/36). Kolory wynikają z jednego, jawnego mapowania palety; wychodzący
  dymek to tint akcentu, nie `primaryContainer`. Zarejestrowany w `theme.dart` dla light
  i dark; odczyt przez `context.chatTheme`.
- `lib/workspaces/presentation/chat/messages/chat_message_grouping.dart` (nowy):
  serie dymków — ten sam autor, okno 5 min, granica dnia, usunięcie rozdziela serie;
  `isOwnAuthor` z kanonicznego UserId sesji.
- `lib/workspaces/presentation/chat/messages/chat_message_bubble.dart` (nowy):
  `ChatMessageBubble` (własne na prawo, cudze na lewo, limit szerokości, nazwa autora
  na początku serii, stopka metadanych, menu `…` jako nakładka na hover/fokus, więc
  otwarcie menu nie zmienia geometrii dymka, podświetlenie celu skoku) oraz
  `ChatMessageSeriesView` (awatar 30 tylko dla cudzej serii, rezerwa miejsca dla
  kolejnych dymków serii).
- `chat_panel_conversation_parts.dart`: lista panelu renderuje serie i dymki zamiast
  wierszy `DecoratedBox` z czterema stałymi akcjami; limit szerokości liczony
  z dostępnych constraints, nie z rozmiaru monitora; usunięte `_ChatMessageFooter`
  i `_StatusGlyph` (przeniesione do komponentu dymka).
- `rich_text/chat_rich_text_body.dart`: cytat, kod inline, blok kodu z językiem,
  nagłówek bloku i link używają tokenów czatu (`separator`, `codeSurface`,
  `metadataText`, `linkText`, `monospaceStyle`).

Komendy i wyniki: `flutter analyze lib test` → No issues found;
`test/workspaces/presentation/chat/{shell,messages,attachments}` +
`test/workspaces/domain/chat` → **89/89 PASS** (w tym nowe
`chat_message_grouping_test.dart` 8/8); `git diff --check` czysty.

Otwarte w U1 (do domknięcia przed zgłoszeniem pakietu): reguły raila i responsywności
z §2 (breakpointy z constraints, rail 56 bez skalowania ikon, bardzo wąskie okno →
przycisk sekcji w nagłówku), separatory dat i „Nieprzerwane/Nowe wiadomości”,
zwijanie długiej treści po 12 liniach, awatar/nazwa w nagłówku DM, dark/light
i zrzuty szeroki/compact.

## 2026-09-22 — CHAT-UI U1 (część 2): responsywność, separatory dni, zwijanie treści

- `chat_panel_size.dart`: `narrowBreakpoint` 400 px, `separatorWidth`, `railWidth(bool)`
  i `fitsTwoColumns({available, compactRail})` — o liczbie kolumn decydują faktyczne
  constraints (lista ≥304 + rozmowa ≥360 + separatory), a nie stały próg 760 px.
  `compactBreakpoint` zostaje wyłącznie jako próg modalności okna w hoście panelu.
- `chat_panel_rail.dart`: belka ma stałe 56 px, przyciski 40×40, ikonę 22 i odstęp 8,
  a kolory pochodzą z `chatTheme` (`selectedSurface`, `linkText`, `metadataText`) —
  bez `primaryContainer` i bez skalowania ikon. Nowy `ChatPanelNarrowBar` zastępuje
  belkę poniżej 400 px: przycisk sekcji z menu, przypięcie, profil i ustawienia
  w jednym pasku; wybrana sekcja jest widoczna na przycisku.
- `chat_panel_section.dart`: `ChatPanelSection.listSections` jako jedno źródło
  kolejności pozycji dla belki i paska.
- `chat_panel_scaffold.dart`: układ rozstrzygany z `fitsTwoColumns`, tryb wąski
  (<400 px) bez belki, tryb jednokolumnowy z belką powyżej progu.
- Historia: `ChatMessageGrouping.timeline` wstawia `ChatTimelineDate` przed serią z
  nowego dnia (nowy widget `ChatMessageDateSeparator` używa lokalizacji Material);
  dymek zwija treść po 12 liniach z „Pokaż więcej/Pokaż mniej”, a pełny oryginał
  pozostaje dostępny.

Komendy i wyniki: `flutter analyze lib test` → No issues found; `chat_message_grouping_test.dart`
11/11 (w tym 3 nowe na timeline); `presentation/chat/{shell,messages,attachments}` +
`domain/chat` → **92/92 PASS**; `git diff --check` czysty.

Otwarte w U1: wskaźnik „N nowych wiadomości ↓” przy zdarzeniu poza dolną krawędzią,
awatar 36 i linia statusu/pisania w nagłówku DM, menu kontekstowe z
`AppContextMenu` dla wszystkich obiektów, SelectionArea, zrzuty light/dark i
szeroki/compact do odbioru.

## 2026-09-22 — CHAT-UI U2 (część 1): jedna powierzchnia pisania

Zakres: §5 specyfikacji UI (composer). Wygląd nadal NIEZAakceptowany.

- `composer/chat_composer_surface.dart` (nowy): `ChatComposerSurface` — jedna
  zaokrąglona powierzchnia (radius 20 z motywu) z akcjami o stałym boku 40,
  elastycznym edytorem i Wyślij; obwódka fokusu jest subtelna i tylko dla
  aktywnej kontrolki. `ChatComposerActionButton` (stałe 40 px, ikona 20–22)
  oraz `ChatComposerMoreMenu` (`+`) z pozycjami Zdjęcie, Plik, Kod,
  Tekst jako plik i Rozbudowany edytor.
- `chat_message_composer.dart`: usunięty stały `SegmentedButton` Plain/Rich i
  domyślne `OutlineInputBorder`; rozbudowany edytor włącza się z menu `+` bez
  konwersji dokumentu (ta sama ścieżka `_selectMode`, więc atrybuty, wzmianki i
  załączniki nie giną). Pole ma `minLines`/`maxLines` z motywu (1–6) i własny
  styl treści. Akcje „Zdjęcie” i „Plik” wołają `FilePickerPort.pickFiles`
  (`allowedExtensions` dla zdjęć) i przekazują wynik do koordynatora
  załączników; brak portu wyłącza pozycję, a „Tekst jako plik” jest jawnie
  niedostępny z powodem do czasu kontraktu polityki snippet.
- `chat_attachment_composer_controls.dart`: pasek załączników przestał być
  formularzem w ramce z przyciskiem „Dodaj załącznik”; pokazuje karty nazwa →
  stan → usuń, jawnie oznacza odrzucone pliki i oferuje ponowienie
  (`prepare`) po błędzie, nadal przyjmuje upuszczenie pliku.
- Wysyłka jest zablokowana przy pustej treści bez gotowego załącznika, w trakcie
  przygotowania oraz po błędzie; nadal respektuje stan koordynatora.
- ARB en/pl: `chatComposerMoreActions`, `chatComposerAddImage`,
  `chatComposerAddFile`, `chatComposerTextAsFile`,
  `chatComposerTextAsFileUnavailable`, `chatComposerExpandedEditor`,
  `chatAttachmentRetryAction` (usunięty duplikat `chatAttachmentsRemove`).

Komendy i wyniki: `flutter gen-l10n` wykonany; `flutter analyze lib test` →
No issues found; `presentation/chat/{shell,messages,attachments}` +
`domain/chat` → **92/92 PASS**; `git diff --check` czysty.

Otwarte w U2: picker emoji (`ChatEmojiPicker`) i wstawianie w pozycji kursora,
pasek formatowania zaznaczenia (Pogrubienie/Kursywa/Przekreślenie/Kod inline/Link),
panel kodu z językiem w composerze, wklejanie bez formatowania, link z kartą
preview, snippet → TXT z decyzją użytkownika, pełny roundtrip formatowania,
obsługa `Ctrl/Cmd+Enter` w rozbudowanym edytorze i limit wysokości pola
zależny od wysokości rozmowy.

## 2026-09-22 — CHAT-UI U2 (część 2): wspólny picker emoji i formatowanie zaznaczenia

- `presentation/chat/emoji/chat_emoji_catalog.dart` (nowy): kuratorowany katalog
  emoji z kategoriami, nazwami i słowami kluczowymi (PL/EN), wariantami odcienia
  dla znaków, które je wspierają, oraz listą szybkich reakcji. Bez nowej
  zależności i bez pobierania danych z sieci.
- `presentation/chat/emoji/chat_emoji_picker.dart` (nowy): wspólny picker dla
  composera, reakcji i statusu — wyszukiwanie, kategorie (w tym „Ostatnio użyte”),
  siatka o komórce 40 px, wybór odcienia skóry, jawny stan „brak pasujących”.
  `showChatEmojiPicker` zwraca wybrany znak albo `null` (zamknięcie nic nie
  zmienia i nie wysyła wiadomości). Dodatkowo `ChatEmojiQuickReactions` z
  sześcioma szybkimi reakcjami do dymka.
- `presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart` (nowy): sesyjna
  lista ostatnio użytych wyłącznie w pamięci; wpięta w host panelu obok
  `ChatUnreadCubit` (tworzona przy aktywnej kompozycji, czyszczona przy braku
  sesji, zamykana w `dispose`).
- Composer: akcja emoji o stałym boku wstawia znak w miejscu kursora
  (plain: `TextEditingController` z zachowaniem zaznaczenia; rich: `replaceText`
  w kontrolerze Quill) i przywraca focus; brak sesyjnego cubitu wyłącza akcję.
- `composer/chat_format_commands.dart` (nowy): mapowanie akcji P/ K/ przekreślenie/
  kod inline/link/wyłącz na atrybuty transportu, walidacja bezpieczeństwa adresu
  i normalizacja bez schematu — logika poza widgetami, pokryta testami.
- `composer/chat_composer_format_bar.dart` (nowy): pasek zaznaczenia nad
  powierzchnią pisania (nie przesłania zaznaczenia), aktywny atrybut wyróżniony,
  link przez mały dialog, „Wyłącz formatowanie” zdejmuje wszystkie atrybuty;
  skróty Ctrl/Cmd+B i Ctrl/Cmd+I działają w rozbudowanym edytorze.
- ARB en/pl: `chatComposerEmoji`, `chatEmojiSearchHint`, `chatEmojiRecent`,
  `chatEmojiSkinTone`, `chatEmojiEmpty`, etykiety kategorii, `chatComposerBold`,
  `chatComposerItalic`, `chatComposerStrike`, `chatComposerInlineCode`,
  `chatComposerLink`, `chatComposerClearFormat`, `chatComposerLinkTitle/Hint/Apply`.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`domain/chat` + `presentation/chat/{messages,emoji}` +
`composer/chat_format_commands_test.dart` + `data/chat` →
**141 PASS / 1 FAIL**; `git diff --check` czysty.

Uwagi o bramkach (ważne dla dalszej pracy):
- Zgodnie z §207 specyfikacji nie uruchamiam testów widgetowych/goldenów przed
  akceptacją wyglądu. Jedna z komend w tej sesji objęła ścieżkę
  `presentation/chat`, która zawiera istniejące testy widgetowe composera;
  od tego miejsca wybieram wyłącznie jawne ścieżki jednostkowe.
- Czerwony test `test/workspaces/data/chat/global_chat_contract_test.dart`
  („serializes conversation scope with local user UUIDs”) NIE pochodzi z tej
  pracy: równoległa, niezacommitowana zmiana w
  `lib/workspaces/data/shared/enums/chat_enums.dart` dodała `@JsonValue('Direct')`
  i pozostałe PascalCase, a test nadal podaje `type: 'direct'`. Nie dotykam
  cudzej zmiany ani jej testu; do decyzji właściciela tej zmiany (albo
  aktualizacja payloadu testu, albo akceptacja obu wariantów w enumie).

## 2026-09-22 — CHAT-UI U3 (część 1): nazwy osób piszących

- `presentation/chat/presence/chat_typing_label.dart` (nowy): decyzja o treści
  wskaźnika (jedna osoba / para / grupa z liczbą pozostałych / brak znanych nazw).
  Identyfikatory są sortowane, więc kolejność zbioru z realtime nie zmienia
  wyświetlanej osoby, a nieznana etykieta daje tekst neutralny zamiast UUID.
- `presence/widgets/chat_typing_indicator.dart`: trzy subtelne kropki z animacją
  cykliczną (przy wyłączonych animacjach systemu statyczne), wysokość 20 px
  zarezerwowana, więc pojawienie się pisania nie skacze układem.
- Panel przekazuje `_participantLabels(context)` do wskaźnika.
- ARB en/pl z pluralizacją: `chatTypingOne`, `chatTypingTwo`, `chatTypingMany`
  (`few`/`many` obsłużone), `chatTypingIndicator` jako neutralny fallback.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`chat_typing_label_test.dart` 7/7; `presence` + `emoji` + `messages` +
`composer/chat_format_commands_test.dart` + `domain/chat` → **91/91 PASS**;
`git diff --check` czysty.

## 2026-09-22 — CHAT-UI U3 (część 2) i U4 (start): karta statusu i reakcje

- `presence/chat_status_presets.dart` (nowy): presety (Skupienie, Na spotkaniu,
  Zaraz wracam, W drodze, Przerwa) z emoji oraz `ChatStatusDurations` — „Dzisiaj”
  to koniec lokalnego dnia (nie +24 h), z przejściem przez granicę miesiąca i roku;
  brak terminu nie tworzy daty. Testy: `chat_status_presets_test.dart` 6/6.
- `presence/chat_status_menu.dart`: formularz (ręczne pole emoji, `SwitchListTile`,
  `DropdownButtonFormField`) zastąpiony zakotwiczoną kartą profilu (max 340 px,
  clamp przez `MenuAnchor`): awatar `/me`, nazwa, aktualny status albo „Brak statusu”,
  gotowe statusy jednym kliknięciem, picker emoji ze wspólnego katalogu, jedno
  lekkie pole opisu, menu terminu (Za godzinę / Dzisiaj / Bez terminu) i DND.
  Termin istniejącego statusu nie jest zerowany bez wyboru („Bez zmian”), karta nie
  zamyka się przed potwierdzeniem zapisu, a błąd pokazuje kod i pozwala ponowić.
- Reakcje: pasek szybkich reakcji bierze znaki ze wspólnego katalogu i ma pozycję
  `+`, która otwiera pełny picker z wyszukiwaniem i kategoriami; emoji z pickera
  jest zapamiętywane w sesyjnej liście ostatnio użytych. Dymek pokazuje na hover
  mały przycisk „Dodaj reakcję” obok `…`, bez zmiany geometrii i bez stałych ikon.
- Obecność: w UI czatu nie ma żadnego miejsca, które wnioskuje „online”; brak
  kontraktu obecności pozostaje widoczny jako brak danych, a nie zielona kropka.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`presence` + `emoji` + `messages` + `composer/chat_format_commands_test.dart` +
`domain/chat` → **96/96 PASS**; `git diff --check` czysty.

Otwarte w U3/U4: sekcja uczestników z awatarami i wejściem „Dodaj osoby” z karty
nagłówka, karta osoby („Napisz”, rola), menu kontekstowe wszystkich obiektów z
`AppContextMenu` (rozmowa, link, załącznik, osoba, composer), długie wklejenie →
TXT (wymaga kontraktu polityki snippet), obecność z prawdziwego źródła.

## 2026-09-22 — CHAT-UI U3 (część 3): tożsamość w nagłówku i awatary członków

- `chat_panel_conversation_parts.dart` (`ChatPanelConversationHeader`): nagłówek ma
  teraz awatar 36 px z motywu (`AppUserAvatar`), nazwę z elipsą i jedną linię
  kontekstu pod nią; rzadkie akcje zostały tam, gdzie były, a Wstecz i zamknięcie
  nadal są osiągalne przy długim tytule.
- `chat_panel_conversation.dart`: jedno źródło danych o rozmowie (`_inboxItem`)
  dla etykiet autorów, roli `@all`, tytułu DM, awatara rozmówcy i liczby
  uczestników; licznik uczestników korzysta z ARB z polską pluralizacją
  (`chatHeaderParticipantCount`). Usunięto trzykrotne dublowanie pętli po skrzynce.
- `chat_members_sheet.dart`: każdy wiersz członka ma awatar 36 px, rolę i status,
  więc lista osób nie jest już surowym `ListTile` z samym tekstem.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`presence` + `emoji` + `messages` + `composer/chat_format_commands_test.dart` +
`domain/chat` → **96/96 PASS**; `git diff --check` czysty.

Otwarte w U3: karta osoby („Napisz”, rola, status) — wymaga przeciągnięcia
`onOpenConversation` z hosta przez arkusz członków po rozwiązaniu DM
(`ChatCreationCubit.startDirectWith` → `POST /conversations/resolve`), a także
wyszukiwanie w nagłówku i przeniesienie rzadkich akcji do menu `…`.

## 2026-09-22 — CHAT-UI U3 (część 4): karta osoby i akcja „Napisz”

- `members/chat_person_card.dart` (nowy): karta osoby z listy członków — awatar 44,
  nazwa, rola w rozmowie i status z portu obecności (brak portu albo błąd nie psuje
  widoku). „Napisz” rozwiązuje rozmowę 1:1 tym samym kontraktem co kreator
  (`ChatCreationCubit.startDirectWith` → `POST /conversations/resolve`) i otwiera ją
  przez `DevPlannerPanelsScope.openConversationOf`; brak portu albo nieudane
  rozwiązanie pokazuje komunikat zamiast pozornego sukcesu. Karta nie pojawia się
  jako akcja dla własnego konta.
- `foundation/presentation/devplanner_panels.dart`: dodany `openConversationOf`,
  spójny z istniejącym `openResourceConversationOf`.
- `members/chat_members_sheet.dart`: wiersz członka otwiera kartę osoby; port
  zarządzania rozmową jest przekazywany z `show()` przez ciało arkusza do listy.
- ARB en/pl: `chatPersonWrite`, `chatPersonWriteFailed`.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`presence` + `emoji` + `messages` + `composer/chat_format_commands_test.dart` +
`domain/chat` → **96/96 PASS**; `git diff --check` czysty.

## 2026-09-22 — CHAT-UI U1 (część 3): wskaźnik nowych wiadomości

- `chat_panel_conversation_parts.dart` (`ChatPanelMessageList`): lista ma własny
  `ScrollController` i liczy wiadomości, które przyszły, gdy użytkownik czytał
  starszy fragment. Wtedy nie przewraca mu widoku, tylko pokazuje nad dolną
  krawędzią wskaźnik „N nowych wiadomości ↓” (klikalny, wraca do najnowszych);
  przy dolnej krawędzi lista zachowuje się jak dotąd i sama pokazuje nowe wpisy.
  Licznik czyści się po powrocie na dół i po skoku z wskaźnika.
- ARB en/pl: `chatNewMessages` z polską pluralizacją (`few`/`many`).

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`presence` + `emoji` + `messages` + `composer/chat_format_commands_test.dart` +
`domain/chat` → **96/96 PASS**; `git diff --check` czysty.

Otwarte z §4: klikalny link i karta preview w historii, „Kopiuj wiadomość” /
„Kopiuj zaznaczenie”, zwijanie serii wg separatora (zrobione w grupowaniu),
SelectionArea dla zaznaczania myszą i klawiaturą.

## 2026-09-22 — CHAT-UI U4 (część 1): linki i kopiowanie wiadomości

- `presentation/chat/links/chat_external_link_port.dart` (nowy) +
  `data/chat/links/chat_external_link_port_adapter.dart` (nowy, `url_launcher`):
  otwieranie adresu poza aplikacją tylko dla `http`/`https`, bez odstępów w adresie
  i bez pustego hosta; odmowa systemu i błąd launchera wracają jako `false`, więc
  UI nie zgłasza sukcesu. Port wpięty w kompozycję, runtime i host panelu tak samo
  jak port załączników.
- `rich_text/chat_rich_text_body.dart`: linki w historii są klikalne (rozpoznawacze
  tworzone raz na blok i zwalniane w `dispose`/`didUpdateWidget`, bez wycieku),
  a kliknięcie otwiera `AppContextMenu` zakotwiczone w miejscu dotknięcia z pełnym
  adresem w nagłówku i akcjami „Otwórz” oraz „Kopiuj adres”. Kod bloku kodu nadal
  ma własne „Kopiuj”.
- `message_actions/chat_message_action_menu.dart`: dodane „Kopiuj wiadomość”
  (schowek z dokładnie zapisanym tekstem, bez dopisywania znaków; potwierdzenie albo
  komunikat błędu w SnackBarze), obok istniejących reakcji, odpowiedzi, przekazania,
  zapisu, przypięcia, wątku, edycji i usunięcia.
- ARB en/pl: `chatMessageCopy`, `chatMessageCopied`, `chatMessageCopyFailed`,
  `chatLinkOpen`, `chatLinkCopy`, `chatLinkOpenFailed`.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`chat_external_link_port_adapter_test.dart` **5/5** (bezpieczny adres, odrzucone
schematy, pusty/adres z odstępem, odmowa systemu, błąd launchera); pełny jawny
zestaw czatu (`presentation/chat/{presence,emoji,messages}` +
`composer/chat_format_commands_test.dart` + `domain/chat` + `data/chat/{links,attachments}`)
→ **119/119 PASS**; `git diff --check` czysty.

Otwarte z §5/§10: karta preview linku po stronie serwera, menu kontekstowe rozmowy
na liście i załącznika (Otwórz/Podgląd, Pobierz, Kopiuj nazwę), „Kopiuj zaznaczenie”
(razem z `SelectionArea`), menu composera (Wklej/Wklej bez formatowania/Zaznacz wszystko).

## 2026-09-22 — CHAT-UI U4 (część 2): menu kontekstowe rozmowy i załącznika

- `inbox/components/chat_inbox_row_menu.dart` (nowy): jedno menu rozmowy dla
  prawego kliku, długiego przytrzymania i klawiatury. Pokazuje wyłącznie akcje z
  realnym skutkiem: Otwórz, Wycisz/Włącz powiadomienia (tryb z `isMuted` w pozycji,
  powrót do wszystkich powiadomień), Archiwizuj/Przywróć (zależnie od sekcji) oraz
  Informacje (istniejący arkusz członków). Po akcji odświeża skrzynkę, a błąd portu
  pokazuje komunikatem; brak portu ukrywa pozycję. Przypięcia rozmowy celowo nie ma —
  to nie to samo co przypięcie wiadomości.
- `inbox/components/chat_inbox_row.dart`: wiersz ma `actionsBuilder`, długie
  przytrzymanie otwiera menu zakotwiczone przy wierszu (nazwa rozmowy w nagłówku);
  `AppContextMenuRegion` obsługuje prawy klik w miejscu kursora.
- `shell/layout/chat_panel_list_pane.dart`: buduje akcje dla wiersza,
  przekazuje je do wiersza i owija go obszarem menu; sekcja decyduje o
  archiwizacji vs przywróceniu.
- `attachments/history/chat_message_attachments.dart`: karta załącznika ma menu
  (prawy klik i długie przytrzymanie) z akcjami tylko tam, gdzie są wykonalne —
  obraz: Podgląd i Pobierz, dokument: Otwórz, zawsze: Kopiuj nazwę.
- ARB en/pl: `chatInboxOpen`, `chatInboxMute`, `chatInboxUnmute`, `chatInboxArchive`,
  `chatInboxRestore`, `chatInboxInfo`, `chatAttachmentPreview`,
  `chatAttachmentDownload`, `chatAttachmentCopyName`.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
pełny jawny zestaw (`presentation/chat/{presence,emoji,messages}` +
`composer/chat_format_commands_test.dart` + `domain/chat` + `data/chat/{links,attachments}`)
→ **119/119 PASS**; `git diff --check` czysty.

Otwarte z §10: menu composera (Wklej, Wklej bez formatowania, Zaznacz wszystko),
„Kopiuj zaznaczenie” razem z `SelectionArea`, przeniesienie rzadkich akcji nagłówka
do `…`, menu osoby w historii (awatar/nazwa autora) oraz wspólne menu dla wyników
wyszukiwania i wątku.

## 2026-09-22 — CHAT-UI U4 (część 3): zaznaczanie i kopiowanie zaznaczenia

- `rich_text/chat_rich_text_body.dart`: renderer treści używa `Text.rich` zamiast
  `RichText`, więc tekst jest zaznaczalny w regionie selekcji (myszą, klawiaturą i
  dotykiem) bez zmiany wyglądu; link pozostaje klikalny przez własny rozpoznawacz.
- `shell/chat_panel_conversation_parts.dart`: historia panelu jest w `SelectionArea`,
  więc zaznaczanie i skrót kopiowania działają jak w polach tekstowych, a wskaźnik
  nowych wiadomości i menu `…` pozostają nienaruszone.
- `message_actions/chat_message_action_menu.dart`: „Kopiuj wiadomość” kopiuje cały
  zapisany tekst, a „Kopiuj zaznaczenie” wysyła ten sam `CopySelectionTextIntent`,
  którego używa Ctrl+C w regionie zaznaczania — przy braku zaznaczenia nic nie
  kopiuje i nie zgłasza pozornego sukcesu. Świadomie nie czytamy zaznaczenia przez
  API prywatne: `SelectableRegionState` nie eksponuje treści zaznaczenia publicznie.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
pełny jawny zestaw czatu → **119/119 PASS**; `git diff --check` czysty.

Otwarte z §10: menu composera (Wklej/Wklej bez formatowania/Zaznacz wszystko),
przeniesienie rzadkich akcji nagłówka do `…`, menu osoby w historii, wspólne menu
dla wyników wyszukiwania i wątku.

## 2026-09-22 — CHAT-UI U2 (część 3): klient polityki snippetów i ocena długiego wklejenia

Domykamy stronę klienta dla nowego kontraktu backendu (`GET /api/v1/chat/link-policy`).

- `domain/chat/link_policy/chat_link_policy.dart` + `chat_link_policy_repository.dart`
  (nowe): model progów i port `getPolicy()`; presentation nie zna adresu endpointu.
- `data/chat/models/chat_link_policy_dto.dart` (nowy): ręczny DTO z `fromJson`
  (trzy liczby nie uzasadniają kodegenu) i `toDomain()`; brak pola to
  `FormatException`, a nie ciche zero.
- `data/chat/api/chat_api.dart` + regenerowany `chat_api.g.dart`: metoda
  `loadLinkPolicy()`; `data/chat/repositories/chat_link_policy_repository_impl.dart`
  mapuje odpowiedź i błędy przez `ChatApiErrorCode.loadLinkPolicy` (nowy kod
  `chat.link_policy.load_failed`).
- Kompozycja, runtime i host panelu udostępniają `ChatLinkPolicyRepository`;
  brak portu oznacza brak propozycji pliku TXT — klient nie zgaduje progów.
- `presentation/chat/composer/chat_long_paste_decision.dart` (nowy):
  `assess(text, policy)` rozstrzyga `text` / `file` / `overLimit` w tych samych
  granicach co backend (próg włącza propozycję, limit wejścia daje jawny stan
  przekroczenia), liczy znaki jak C# `string.Length` oraz bajty UTF-8 i buduje
  podgląd pierwszych trzech linii bez modyfikowania treści. Brak polityki
  zawsze zwraca `text`, więc UI nie proponuje pliku na podstawie zgadywanej liczby.

Komendy i wyniki: `dart run build_runner build --delete-conflicting-outputs`
(30 s, 2 wyjścia); `flutter analyze lib test` → No issues found;
`chat_long_paste_decision_test.dart` **8/8**; pełny jawny zestaw czatu →
**127/127 PASS**; `git diff --check` czysty.

Otwarte z §7: karta decyzji w composerze (nazwa, rozmiar, podgląd, „Jako plik” /
„Zostaw jako tekst” / „Anuluj wklejenie”), przygotowanie snippet-u i dwuetapowa
publikacja TXT (wiadomość + załącznik) z jawnym retry oraz obsługa `IsTruncated`.

## 2026-09-22 — CHAT-UI U2 (część 4): port przygotowania snippet-u (bez duplikatu kontraktu)

- `domain/chat/snippets/chat_snippet_repository.dart` (nowy): port `prepare(...)`
  i model `ChatSnippetPreparation` (treść, długość wejścia, nazwa/typ pliku oraz
  `isTruncated`), więc presentation nie sięga po surowy klient API.
- `data/chat/repositories/chat_snippet_repository_impl.dart` (nowy): adapter
  korzysta z **istniejącego** kontraktu `prepareSnippet` + `ChatSnippetPayload` /
  `ChatSnippetResponse` (F0–F6) i mapuje je na model domenowy; nowy kod błędu
  `chat.snippets.prepare_failed`.
- Świadomie usunięty mój wcześniejszy duplikat metody API i DTO — jedno źródło
  prawdy dla kontraktu snippet-u.
- Port wpięty w kompozycję, runtime i host panelu (`ChatSnippetRepository`),
  obok polityki snippetów.

Komendy i wyniki: `dart run build_runner build --delete-conflicting-outputs`
(24 s) po usunięciu duplikatu; `flutter analyze lib test` → No issues found;
`data/chat` + `domain/chat` + `presentation/chat/{presence,emoji,messages}` +
`composer/{chat_format_commands,chat_long_paste_decision}_test.dart` → wszystkie
przechodzą poza znanym, wcześniejszym `global_chat_contract_test.dart` (równoległa
zmiana `chat_enums.dart` z `@JsonValue('Direct')`); `git diff --check` czysty.

Otwarte z §7: karta decyzji w composerze (przechwycenie wklejenia, nazwa, rozmiar,
podgląd, „Jako plik” / „Zostaw jako tekst” / „Anuluj wklejenie”), stan `overLimit`
blokujący „Zostaw jako tekst” z powodem, a potem dwuetapowa publikacja TXT.

## 2026-09-22 — CHAT-UI U4 (część 4): długie wklejenie → TXT bez cichego obcinania

- `composer/chat_long_paste_card.dart` (nowy): karta decyzji nad powierzchnią
  pisania — nazwa pliku, rozmiar w bajtach UTF-8, podgląd pierwszych trzech linii
  w monospace oraz akcje „Wyślij jako plik”, „Zostaw jako tekst”, „Anuluj
  wklejenie”. W stanie przekroczenia limitu „Zostaw jako tekst” jest zablokowane
  z jawnym powodem, a komunikat o skróceniu treści przez serwer pojawia się przed
  jakąkolwiek publikacją.
- `composer/chat_message_composer.dart`: przechwycenie wklejenia przez
  `PasteTextIntent` (nadpisanie akcji edytora) — szkic **nigdy nie jest zmieniany
  po cichu**. Krótki tekst wkleja się jak dotąd; długi czeka na decyzję:
  - „Zostaw jako tekst” wstawia tekst w miejscu kursora (tylko w dozwolonym stanie),
  - „Anuluj wklejenie” czyści kartę, a szkic pozostaje dokładnie taki, jaki był,
  - „Wyślij jako plik” woła `ChatSnippetRepository.prepare` (sanitacja i wykrycie
    skrócenia po stronie serwera), a przygotowaną treść przekazuje jako
    `StorageUploadInput` do istniejącej kolejki załączników — publikacja idzie
    jedną, sprawdzoną ścieżką Storage, więc ponowienie nie tworzy drugiej
    wiadomości ani nie gubi treści,
  - polityka snippetów jest pobierana raz na sesję composera; jej brak oznacza brak
    propozycji pliku (żadnego zgadywania progów), a błąd przygotowania zostawia
    tekst w szkicu i pokazuje komunikat.
- Wysyłka jest dozwolona przy pustej treści, gdy załącznik jest już gotowy (plik
  TXT sam w sobie jest treścią wiadomości), co domyka przypadek „sam plik”.
- ARB en/pl: `chatLongPasteTitle`, `chatLongPasteFileDetails` (nazwa + rozmiar),
  `chatLongPasteSendAsFile`, `chatLongPasteKeepAsText`, `chatLongPasteCancel`,
  `chatLongPasteOverLimit`, `chatLongPasteTruncated`, `chatLongPastePrepareFailed`.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
`chat_long_paste_decision_test.dart` **8/8**; pozostałe jawne ścieżki czatu
przechodzą (jedyny czerwony to znany, wcześniejszy `global_chat_contract_test.dart`
z równoległej zmiany `chat_enums.dart`); `git diff --check` czysty.

Otwarte z §7: rzeczywiste zachowanie przy błędzie AV/limitu Storage i offline
(załącznik pokazuje stan i pozwala usunąć/ponowić przez istniejącą kolejkę),
pełny przepływ „tekst + krótki komentarz autora” w jednej wiadomości oraz odbiór
wizualny karty na realnej sesji.

## 2026-09-22 — CHAT-UI U4 (część 5): spójne menu i wspólny renderer

- Composer: menu kontekstowe edytora (prawy klik) z realnym skutkiem —
  „Wklej bez formatowania” (ta sama ścieżka oceny co Ctrl/Cmd+V, więc długi tekst
  nadal trafia do karty decyzji) i „Zaznacz wszystko” (plain: zaznaczenie całego
  pola, rich: zaznaczenie całego dokumentu Quill). Świadomie nie ma drugiej pozycji
  „Wklej”: composer zawsze wkleja czysty tekst, więc duplikat robiłby dokładnie to samo.
- Wątek (`thread/chat_thread_side_panel.dart`): treść wiadomości renderuje wspólny
  `ChatRichTextBody`, więc kod, listy, cytaty i formatowanie wyglądają tak samo jak
  w historii, a nie jako surowy tekst.
- Wyniki wyszukiwania (`search/components/chat_search_view.dart`): wiersz ma menu
  kontekstowe (prawy klik i długie przytrzymanie) z „Otwórz w rozmowie” i
  „Kopiuj fragment”; wynik bez widocznej rozmowy nie udaje akcji i nie pokazuje menu.
- ARB en/pl: `chatComposerPastePlain`, `chatComposerSelectAll`, `chatSearchOpenResult`,
  `chatSearchCopySnippet`.

Komendy i wyniki: `flutter gen-l10n`; `flutter analyze lib test` → No issues found;
jawne ścieżki czatu przechodzą poza znanym wcześniejszym
`global_chat_contract_test.dart`; `git diff --check` czysty.

Otwarte: pełne menu akcji w wątku (odpowiedz/edytuj/usuń według praw) oraz
przeniesienie rzadkich akcji nagłówka rozmowy do `…`.

## 2026-09-22 — CHAT-UI U1/U2/U3/U4: audyt stanu wobec §11 (bez odbioru wizualnego)

Sprawdzenie kodu i bramek wobec specyfikacji (stan faktyczny, nie deklaracja):

- **U0** — zamknięte i udokumentowane (rozpoznanie drzewa, kontraktów i braków).
- **U1** — kod dostarczony: `DevPlannerChatTheme` zarejestrowany w light/dark, belka 56 px
  z paskiem sekcji poniżej 400 px, serie dymków z separatorami dni, wskaźnik „N nowych
  wiadomości”, nagłówek z awatarem 36 i linią kontekstu, rzadkie akcje w menu `…`.
  Otwarte: zrzuty light/dark i szeroki/compact (odbiór), wyszukiwanie w nagłówku
  (dziś w kolumnie listy — świadomie nie dublujemy akcji).
- **U2** — kod dostarczony: jedna powierzchnia pisania z akcjami 40 px, odporne łamanie
  długich linków (bez zerowych spacji), wspólny picker emoji z odcieniami, rozbudowany
  edytor z toolbarlem i paskiem zaznaczenia, skróty Ctrl/Cmd+B/I i Ctrl/Cmd+Enter,
  kod jako dialog i blok, wklejenie bez formatowania oraz zaznacz wszystko w menu
  edytora, długie wklejenie → TXT przez przygotowanie snippet-u i wspólną kolejkę
  załączników. Otwarte: karta preview linku (wymaga kontraktu serwera), roundtrip
  formatowania do potwierdzenia na realnej sesji.
- **U3** — kod dostarczony: avatary (`AppUserAvatar`) w nagłówku, dymkach i liście osób,
  sesyjne presety statusu z terminem liczonym w czasie lokalnym, nazwy osób piszących
  z pluralizacją, lista uczestników z „Dodaj osoby”, karta osoby z „Napisz” przez
  `POST /conversations/resolve`. Otwarte: obecność online/offline — brak kontraktu,
  więc UI nie pokazuje zielonej kropki.
- **U4** — kod dostarczony: menu wiadomości, rozmowy, załącznika, linku, wyniku
  wyszukiwania i edytora na wspólnym `AppContextMenu`; reakcje z pełnym pickerem;
  załączniki z podglądem, pobraniem, galerią i kopiowaniem nazwy; długi tekst → TXT
  z jawnym komunikatem o skróceniu. Otwarte: pełne menu akcji w wątku.
- **U5** — nierozpoczęte po stronie agenta: wymaga uruchomionej aplikacji, danych
  demonstracyjnych i Twoich zrzutów; bez tego nie deklaruję gotowości wyglądu.

Utrzymanie bramek: `flutter gen-l10n` i `dart run build_runner build
--delete-conflicting-outputs` wykonane po zmianach; `flutter analyze lib test`
→ No issues found; testy jednostkowe jawne przechodzą poza znanym, wcześniejszym
`global_chat_contract_test.dart` (równoległa zmiana `chat_enums.dart`);
backend: build, 228/228 testów Chat i `dotnet format` (z jawnym projektem) zielone.

## 2026-09-22 — CHAT-UI U4 (część 6): akcje wiadomości w wątku

- `thread/chat_thread_side_panel.dart`: wiadomość w wątku ma wspólny renderer treści
  (`ChatRichTextBody`), stopkę z godziną i menu kontekstowe (prawy klik, długie
  przytrzymanie, klik) z realnym skutkiem — „Kopiuj wiadomość” przez wspólny helper
  ze schowkiem i potwierdzeniem.
- Świadomie nie dodaję w wątku edycji ani usuwania: `ChatThreadCubit` nie ma takich
  operacji, a pozorna pozycja w menu byłaby gorsza niż jej brak. Edycja i usuwanie
  pozostają w widoku rozmowy, gdzie mają pełne uprawnienia i retry; brak pozycji jest
  zapisany w handoffie jako decyzja, nie przeoczenie.

Komendy i wyniki: `flutter analyze lib test` → No issues found; `git diff --check` czysty.

## 2026-09-22 — CHAT-UI U1/U3 (porządki tokenów): audyt „primaryContainer/formularz”

Przegląd aktywnych widgetów czatu pod kątem reguł §3 (żadnego przypadkowego
`primaryContainer`, wygląd pól z tokenów czatu):

- `inbox/components/chat_inbox_row.dart`: tło zaznaczonego wiersza korzysta z
  `chatTheme.selectedSurface` zamiast `primaryContainer`.
- `mentions/chat_mention_suggestions.dart`: wyróżnienie podpowiedzi wzmianki
  z `chatTheme.selectedSurface`.
- `presence/chat_status_menu.dart`: pole opisu i wybór terminu nie używają już
  domyślnej ramki `OutlineInputBorder()`; mają miękkie, zaokrąglone obramowanie
  i tło z tokenów czatu, więc karta statusu nie wygląda jak formularz.
- Poza aktywną ścieżką (stary renderer strony rozmowy
  `chat_conversation_message_list.dart` oraz dialogi akcji wiadomości) pozostały
  pojedyncze użycia `primaryContainer`; to kod nieużywany przez globalny panel —
  zapisane jako znany dług do sprzątnięcia razem z usunięciem starego renderera.

Komendy i wyniki: `flutter analyze lib test` → No issues found; `git diff --check` czysty.

## 2026-09-22 — CHAT-UI U1 (§2): wyszukiwanie z kontekstu rozmowy + build web

- Menu `…` rozmowy ma pozycję „Szukaj w wiadomościach”, która wywołuje tę samą
  akcję co przycisk w kolumnie listy (`ChatSearchCubit.open()`), więc wyszukiwanie
  jest osiągalne także z otwartej rozmowy, bez dodawania kolejnej stałej ikony
  i bez drugiego widoku wyszukiwania.

Komendy i wyniki (świeże, uruchomione):
- `flutter build web --wasm` → **exit 0**, `✓ Built build/web` po 78,6 s
  (`main.dart.wasm` 7,1 MB, `main.dart.js` 9,8 MB) — całe drzewo frontu kompiluje
  się na docelową platformę web/wasm.
- `flutter analyze lib test` → No issues found.
- Jawne testy czatu (shell, domain, presence, emoji, messages, decyzja o długim
  wklejeniu, komendy formatowania, data/chat) przechodzą; jedyny czerwony to znany,
  wcześniejszy `global_chat_contract_test.dart` z równoległej zmiany `chat_enums.dart`.
- `git diff --check` czysty.

Otwarte nadal: odbiór wizualny (U5, zrzuty i macierz §12), karta preview linku
(kontrakt serwera), obecność online/offline (brak kontraktu), pełne menu akcji
w wątku (brak operacji w cubicie wątku), sprzątnięcie starego renderera rozmowy.

## 2026-09-22 — CHAT-UI U3 (§9): status rozmówcy w nagłówku DM

- `presence/widgets/chat_peer_status_line.dart` (nowy): jedna linia statusu
  rozmówcy — emoji i/lub opis z serwera, wczytywane raz na zmianę rozmówcy.
  Brak statusu to brak linii, a nie wymyślone „online”; obecność online/offline
  nadal nie ma kontraktu, więc nagłówek nie rysuje zielonej kropki.
- `ChatPanelConversationHeader` przyjmuje opcjonalny `subtitleWidget`, który ma
  pierwszeństwo przed tekstowym `subtitle`, bo niesie treść potwierdzoną przez serwer.
- Panel przekazuje tę linię tylko w rozmowie 1:1 (gdy znany jest rozmówca); w grupach
  zostaje licznik uczestników.

Komendy i wyniki: `flutter analyze lib test` → No issues found; jawne testy czatu
przechodzą poza znanym, wcześniejszym `global_chat_contract_test.dart`;
`git diff --check` czysty.

## 2026-09-22 — CHAT-UI U2 (§5): focus wraca do edytora po wysłaniu

- `composer/chat_message_composer.dart`: po udanym wysłaniu focus wraca do
  aktywnego edytora (plain albo rich), więc użytkownik pisze dalej bez klikania.
  Wspólny helper `_focusEditor()` obsługuje też wstawianie emoji i tekstu, żeby
  reguła fokusu była w jednym miejscu.

Komendy i wyniki: `flutter analyze lib test` → No issues found; jawny zestaw
(composer, domain, messages) przechodzi; `git diff --check` czysty.

## 2026-09-22 — podsumowanie sesji: co jest gotowe, co zostaje (bez odbioru wizualnego)

Zamknięte w kodzie i sprawdzone bramkami (U0–U4):

| Obszar | Artefakt | Dowód |
|---|---|---|
| Motyw czatu | `foundation/theme/chat_theme.dart` (role, style, miary, light/dark) | analyze + użycie w dymkach, composerze, belce |
| Dymki i historia | `messages/chat_message_bubble.dart`, `chat_message_grouping.dart`, `chat_message_date_separator.dart` | `chat_message_grouping_test.dart` 11/11 |
| Responsywność | `shell/layout/chat_panel_*` (belka 56 px, pasek sekcji < 400 px, breakpoint z constraints) | analyze; odbiór wizualny otwarty |
| Nowe wiadomości | licznik nad dolną krawędzią w `ChatPanelMessageList` | analyze; odbiór otwarty |
| Composer | `chat_composer_surface.dart`, `chat_composer_rich_toolbar.dart`, `chat_composer_format_bar.dart`, `chat_format_commands.dart` | `chat_format_commands_test.dart` 12/12 |
| Emoji | `emoji/chat_emoji_catalog.dart`, `chat_emoji_picker.dart`, `cubit/chat_emoji_recent_cubit.dart` | `chat_emoji_catalog_test.dart` 12/12 |
| Długie wklejenie → TXT | `chat_long_paste_decision.dart`, `chat_long_paste_card.dart`, port snippet-u | `chat_long_paste_decision_test.dart` 8/8 |
| Ludzie | awatary w nagłówku/dymkach/liście, `chat_peer_status_line.dart`, presety statusu, `chat_person_card.dart` | `chat_status_presets_test.dart` 6/6, `chat_typing_label_test.dart` 7/7 |
| Menu i linki | `AppContextMenu` w wiadomości, rozmowie, załączniku, linku, wyniku wyszukiwania, edytorze; port linków | `chat_external_link_port_adapter_test.dart` 5/5 |
| Backend | `GET /chat/link-policy` + `ChatLinkPolicyResponse` + `GetPolicy()` | 228/228 testów Chat, `dotnet format` exit 0 |

Bramki wykonane: `flutter analyze lib test` → No issues found; `flutter build web --wasm`
→ exit 0; testy jednostkowe jawne frontu → zielone poza znanym `global_chat_contract_test.dart`;
`git diff --check` czysty; backend: build 0 błędów, 228/228, format exit 0.

Świadomie otwarte (wymaga decyzji lub środowiska, nie kodu „na zapas”):
1. **U5 — odbiór wizualny** wg macierzy §12 (zrzuty light/dark, szeroki/compact, 1440×900 … 390×844,
   skala tekstu 100–200%). Bez uruchomionej aplikacji nie deklaruję gotowości wyglądu.
2. **Karta preview linku** — wymaga addytywnego kontraktu serwera; specyfikacja zabrania pobierania
   dowolnych URL-i z widgetu.
3. **Obecność online/offline** — brak kontraktu; UI pokazuje brak danych zamiast zielonej kropki.
   Jeśli ma się pojawić, potrzebny osobny pakiet presence (ACL, TTL, wiele sesji).
4. **Pełne menu akcji w wątku** (odpowiedz/edytuj/usuń) — brak operacji w `ChatThreadCubit`; dziś
   wątek ma kopiowanie, a edycja/usuwanie zostają w widoku rozmowy.
5. **Stary renderer rozmowy** (`chat_conversation_page.dart`, `chat_conversation_message_list.dart`)
   oraz ostatnie `primaryContainer` w dialogach — do usunięcia razem, za zgodą użytkownika
   (zmiana strukturalna; dziś poza aktywną ścieżką panelu).
6. **Czerwony test kontraktu** `global_chat_contract_test.dart` — skutek równoległej, niezacommitowanej
   zmiany `chat_enums.dart` (`@JsonValue('Direct')`), nie tej pracy.

Następny krok: po Twojej zgodzie albo (a) usunięcie starego renderera i domknięcie „tekst + komentarz”
przy wysyłce TXT, albo (b) uruchomienie UI i przejście macierzy §12 z korektami wizualnymi.

## 2026-09-22 — CHAT-MESSENGER-UI: kontrola działającej aplikacji

- Naprawiono runtime crash w `shell/layout/chat_panel_list_pane.dart`: `context.select`
  w callbacku `ListView.builder` wywoływał wyjątek Fluttera przy budowie wiersza.
  Wartość sekcji archiwum jest teraz czytana raz poza builderem i przekazywana do menu.
- Polskie liczniki Chat (`chatHeaderParticipantCount`, `chatNewMessages`, `chatTypingMany`)
  pokazywały dosłowne `#`; ARB ma jawne `{count}` i `{others}`, co generuje interpolację.
- „Tekst jako plik” w menu `+` composera uruchamia teraz rzeczywisty załącznik TXT z
  draftu. Upload idzie przez wspólną ścieżkę Storage; zachowuje pending card przy błędzie,
  nie tworzy drugiego TXT na retry i pokazuje błąd odrzuconej selekcji.
- `ChatLongPasteDecision` uwzględnia limit długości wiadomości z serwerowej polityki.
  DTO i model domenowy mapują `messageMaxCharacters`.
- Ogląd macOS: panel renderował czerwony błąd dla listy; po poprawce świeży build
  wyświetlił rozmowy. Po poszerzeniu widać trzy kolumny, dymki przychodzące/lewe i
  wychodzące/prawe, rail z Czaty/Grupy/Kanały/Pliki/Zadania/Archiwum/Zapisane oraz
  pojedynczą powierzchnię composera. W zrzucie liczba osób w grupie była `# uczestników`;
  ARB naprawiono później, bez kolejnego oglądu.
- `flutter analyze lib/workspaces/presentation/chat lib/foundation/theme/chat_theme.dart`
  → bez uwag; jawne testy jednostkowe czatu → 38/38; po ostatnich korektach test polityki
  oraz interpolacji → 10/10; build macOS przed ostatnią zmianą ARB → PASS. Nie uruchamiano
  testów widgetowych/goldenów ani pełnego `flutter test`.
- Otwarte: po zmianie ARB zrobić nowy macOS build; kontynuować ręczny test menu rozmowy
  i dodawania osób. System zablokował Maca podczas inspekcji. Dodatkowo na widocznym
  połączeniu pojawił się status „czat na żywo offline”; trzeba zweryfikować SignalR na
  dwóch sesjach, bo REST i historia działały. Wygląd nadal nie jest zaakceptowany (U5).
- Po tej kontroli dodano w nagłówku grupy bezpośrednią ikonę uczestników (`group_add`),
  która otwiera arkusz członków z „Dodaj osoby”. Własny status pozostaje dostępny
  z profilu w railu. Zmiana wymaga nowego builda i ręcznej kontroli po odblokowaniu Maca.

### Kontynuacja kontroli — 2026-09-22

- `flutter analyze` dla całego Frontu → **No issues found**.
- Najnowszy build macOS zawiera poprawki interpolacji ARB i bezpośredni przycisk
  członków grupy. CUA potwierdził, że system nadal jest zablokowany; nie ma
  dowodu wizualnego dla tych ostatnich zmian. Prośba o ręczne odblokowanie została
  wysłana; nie używano obejść ekranu blokady.
- Kontrola statyczna potwierdziła pozycje sekcji Pliki oraz Zadania/Kanban i
  warstwę tapety pod pełnym shellem. Nie oznacza to odbioru ich wyglądu ani
  integracji kontekstowych.
- Backend po poprawce wyścigu asercji Storage: pełna komenda testowa zakończona
  **1298 PASS, 0 FAIL, 4 SKIP**; `dotnet format --verify-no-changes` i
  `git diff --check` przechodzą.
- Następny krok pozostaje bez zmian: po odblokowaniu Maca otworzyć najnowszy
  build, sprawdzić licznik osób, otwarcie arkusza/dodawanie członków oraz układ
  przy wąskim i szerokim panelu. Nie uruchamiano widgetów ani goldenów.
- Dalszy code review znalazł domyślne menu Material w pięciu aktywnych miejscach.
  Composer, menu wiadomości, menu nagłówka rozmowy, menu ról członków oraz wybór
  sekcji w wąskim railu i termin statusu używają teraz wspólnego
  `AppContextMenu`. `rg 'PopupMenuButton' lib/workspaces/presentation/chat`
  nie znajduje już wystąpień.
- Po tych zmianach `flutter analyze lib/workspaces/presentation/chat` → No issues
  found, a `flutter build macos --debug --dart-define=DEVPLANNER_API_BASE_URL=...`
  kończy się sukcesem. Nadal bez odbioru ekranowego, bo Mac jest zablokowany.
- Ujednolicono pozostałe dropdowny statusu i powiadomień jako zakotwiczone
  `AppContextMenu.select`; centralny `DialogThemeData` ustawia produktowy kształt,
  powierzchnię i typografię dialogów zamiast niejawnych Material defaults.
  Weryfikacja po tej paczce: analiza `chat` + `foundation/theme` bez uwag,
  `rg 'PopupMenuButton|DropdownButton(FormField)?' lib/workspaces/presentation/chat`
  bez wyników, świeży build macOS PASS. Ręczny ogląd wciąż otwarty.
- Popover „Nowy czat” pokazuje ostatnie rozmowy przez wspólny `ChatInboxRow`
  (awatary, podgląd, unread), a wyniki katalogu używają zwróconych przez API
  avatarUrl i loginu. Główna lista pokazuje awatar profilu w DM oraz ikonę grupy,
  kanału lub broadcastu w rozmowach wieloosobowych; nie używa zdjęcia pierwszego
  członka jako rzekomego awatara grupy. `flutter analyze lib/workspaces/presentation/chat`
  i najnowszy `flutter build macos --debug ...` przechodzą.
# 2026-09-22 — Kontynuacja jakości Chat: presence i build macOS

- Klient realtime mapuje `chat.presence.changed` do typowanego snapshotu.
  Heartbeat presence odnawia 45-sekundowy lease co 15 s i zatrzymuje się po
  odsubskrypcji. Snapshot jest czyszczony przy odsubskrypcji; przed pierwszym
  snapshotem status peerów pozostaje unknown.
- `ChatConversationPresenceCubit` i status headera pokazują online/offline na
  podstawie backendu; dodano lokalizacje PL/EN. Testy realtime/presence/typing
  → 16/16 PASS.
- `flutter analyze` całego projektu → No issues found. `flutter build macos
  --debug` → PASS, `build/macos/Build/Products/Debug/DevPlanner.app`.
- Nie uruchamiano widgetów ani goldenów zgodnie z wcześniejszą instrukcją.
  CUA nadal raportuje zablokowany Mac, więc najnowszego renderu nie zweryfikowano
  ręcznie; U5 i akceptacja UI pozostają otwarte.
- Backend współpracujący z tym klientem wdrożono na staging po pełnej walidacji:
  commit `f7287e03a4d2743b75438b15e72a33f45087fb2e`, API healthy i readiness
  ready. Front pozostaje lokalny; nie wdrażano go.

## 2026-09-22 — Kontrakt klienta i paczka jednostkowa Chat

- Zbiorcza paczka jednostkowa wykryła nieaktualne fixture w
  `test/workspaces/data/chat/global_chat_contract_test.dart`: test parsował
  `direct`/`global`, choć rzeczywisty kontrakt backendu i wygenerowany klient
  używają `Direct`/`Global`. Fixture poprawiono i dodano asercje serializacji.
- Po poprawce: wskazane testy jednostkowe kontraktu, załączników, rich text,
  bloków kodu, wzmianek, formatowania, długiego wklejenia, emoji, unread i
  presence/typing → **85/85 PASS**. Pełny `flutter analyze` → No issues found;
  `git diff --check` → PASS.
- `flutter build macos --debug` z tego samego kodu aplikacji → PASS. Zmiana po
  buildzie dotyczyła wyłącznie fixture testu; nie zmienia binarki.
- Dodatkowo `flutter build web --wasm` → PASS (74,2 s); zatem aktywny Chat
  kompiluje się dla Web/Wasm i macOS Debug.
- Bez testów widgetowych/goldenów. CUA nadal zgłasza zablokowany Mac; najnowszy
  render i dodawanie osób czekają na ręczny odbiór po odblokowaniu.

## 2026-09-22 — Przywrócenie linków wiadomości i kart preview

- Audyt trasy DTO → domena → renderer wykazał, że `ChatMessageResponse.links`
  było ignorowane w historii, wątku, odpowiedzi akcji i realtime. Plain URL
  nie był klikalny, a `ChatApi.previewLink` nie miał żadnego konsumenta.
- Dodano `ChatMessageLink` i jeden `ChatLinkMapper`; wszystkie cztery ścieżki
  odpowiedzi zachowują linki, także po lokalnej zmianie stanu dostawy/usunięciu.
  `ChatPlainTextLinkCodec` rozdziela tekst tylko według URL-i zatwierdzonych
  przez backend, zachowuje oryginalny tekst i nie zamienia wewnętrznych ścieżek
  w zewnętrzne linki.
- Dodano `ChatLinkPreviewRepository` z adapterem Retrofit i kompozycją runtime.
  `ChatMessageBubble` pokazuje pierwszą dozwoloną kartę metadanych; pobranie
  wykonuje istniejący endpoint backendu, nie widget. Błąd preview nie ukrywa
  adresu i nie blokuje wiadomości. Karta korzysta z tokenów ChatTheme.
- Testy linków, mappera, adaptera preview, mapowania historii i realtime →
  **20/20 PASS**; pełny `flutter analyze` bez uwag; build macOS Debug i Web/Wasm
  → PASS; `git diff --check` → PASS.
- Nie uruchamiano widgetów/goldenów. Lokalny web-server doszedł do BFF login,
  dalszy chat wymaga sesji; danych konta nie użyto. Mac pozostaje zablokowany,
  więc karta i responsywność nadal potrzebują ręcznego odbioru.

## 2026-09-22 — Usunięcie syntetycznych rozmów z zakładek kontekstowych

- Code review potwierdził, że zakładki Pliki i Zadania pokazywały przycisk
  „Podgląd UI” oraz fikcyjne rozmowy z przykładowymi osobami, plikami i taskami.
  Mogło to wyglądać jak dane pochodzące z konta, mimo że integracji brak.
- Usunięto sample rows, przełącznik preview i nieużywane klucze ARB. Zakładki
  zachowują odrębny, responsywny stan pusty z motywem ChatTheme oraz komunikat
  o braku integracji; pozostają widoczne jako przygotowane miejsca docelowe.
- `flutter gen-l10n`, `flutter analyze` → No issues found, `flutter build macos
  --debug` → PASS, `git diff --check` → PASS. Nie uruchamiano widgetów/goldenów.
- CUA ponownie potwierdził blokadę Maca, więc brak dowodu z renderu aplikacji.
  Nadal otwarte: ręczny odbiór wizualny całego panelu i połączenie UI z sesją.

## 2026-09-22 — Naprawa dublowania formatowania w composerze

- Review `ChatMessageComposer` wykazał, że tryb Quill renderował stale
  `ChatComposerRichToolbar`, a przy zaznaczeniu dodatkowo `ChatComposerFormatBar`
  z powielonymi akcjami. Usunięto drugi pasek; obsługa formatowania jest w
  `chat_format_actions.dart`, wywoływana przez jedyny pasek rich text.
- Usunięto ostrą wewnętrzną ramkę pola Quill (outer composer już ma obwódkę i
  zaokrąglenie) oraz zmniejszono jego wysokość z 110/144 do 96/112 px.
- Testy `chat_format_commands_test.dart` i `chat_rich_text_codec_test.dart`:
  **19/19 PASS**; `flutter analyze` bez uwag; świeży build macOS Debug PASS;
  `git diff --check` PASS. Bez widgetów/goldenów.
- CUA nadal raportuje zablokowany Mac; poprawka jest skompilowana, ale nie ma
  dowodu wizualnej akceptacji. Następny krok: ręczny przegląd composera i całego
  panelu po odblokowaniu, a potem dalsze usterki z R01–R14.

## 2026-09-22 — R11: cursorowe strony historii w panelu Chat

- `ChatPanelMessageList` wywołuje `ChatConversationCubit.loadMore()` po dojściu
  do górnej krawędzi odwróconej listy. Jedno automatyczne żądanie na cursor
  zapobiega pętli; po błędzie stopka oferuje retry, w trakcie widać spinner.
- `ChatMessageGrouping.countNewArrivals` odróżnia wiadomości nowsze od poprzedniego
  końca historii od starszych rekordów dołączonych paginacją, dzięki czemu badge
  nowych wiadomości nie rośnie przy czytaniu archiwum.
- Testy `chat_conversation_cubit_test.dart` + `chat_message_grouping_test.dart`
  → **20/20 PASS**; `flutter analyze` czysty; build macOS Debug PASS;
  `git diff --check` PASS.
- Nie uruchamiano widgetów/goldenów. CUA zgłasza blokadę Maca, więc wizualne
  potwierdzenie zachowania scroll anchora pozostaje otwarte.

## 2026-09-22 — R10: read marker zależny od widoczności dymka

- Panel nie oznacza już najnowszej wiadomości jako przeczytanej wyłącznie przez
  sam fakt montowania. `ChatPanelMessageList` mierzy dymek najnowszej wiadomości
  względem clipowanego viewportu; wymagane jest ≥50% widocznego obszaru. Kontrola
  uwzględnia lifecycle i `ModalRoute.isCurrent`; przy zmianie scrolla, historii,
  focusu oraz po powrocie aplikacji geometria jest liczona ponownie.
- Odczyt wywołuje idempotentne `markVisibleAsRead`; ten sam messageId ma też
  blokadę żądania w locie, więc szybkie otwarcie/zamknięcie modala nie duplikuje
  requestu. Badge inboxa i globalny badge odświeżają się tylko po udanym zapisie.
- Testy Cubita, grouping i visibility geometry → **24/24 PASS**; `flutter analyze`
  bez uwag; świeży `flutter build macos --debug` PASS; `git diff --check` PASS.
- Brak testu widgetowego i ręcznego odbioru (Mac nadal zablokowany); R10
  implementacyjnie domknięte, zachowanie z overlay/scroll wymaga smoke testu.

## 2026-09-23 — CHAT-R14 follow-up: custom surfaces for creation and inbox

Zakres: dopasowanie pozostałych ekranów czatu do dedykowanego `ChatTheme`, bez
zmiany kontraktów backendu. Kreator rozmowy ma własne kafle wyboru typu i zasad
publikacji; wyniki wyszukiwania uczestników pokazują awatar oraz czytelny stan
zaznaczenia. Formularze kreatora, wyszukiwarka inboxu, filtry, stany puste,
reakcje i karty załączników używają własnych tokenów powierzchni, obramowań i
metadanych zamiast domyślnych pól i kontenerów Material. Zachowano akcje w rootowym
`DevPlannerModalHost`.

Uzupełnienie pakietu: tokeny błędu obejmują też ustawienia powiadomień, banner
kreatora i błędy skoku w historii; zapisane wiadomości używają własnych wierszy
Chat zamiast standardowego `ListTile`.

Weryfikacja po tej paczce: `flutter analyze` → No issues found; `git diff --check`
→ PASS; wskazany zestaw testów logiki emoji, formatowania, długiego wklejania i
linków → **35/35 PASS**; `flutter build macos --debug` → PASS (ostrzeżenie
SwiftPM istniejących pluginów `media_kit` pozostaje). Nie uruchamiano testów
widgetowych/goldenów. Mac jest nadal zablokowany według CUA, więc brak potwierdzenia
renderu, responsywności i obsługi kliknięć na żywo. Następny krok: uruchomić
zbudowaną aplikację po odblokowaniu i przejść scenariusze: nowa rozmowa, grupa,
dodawanie osób, wyszukiwanie, reakcja, załącznik i długi link.

### 2026-09-23 — Composer: przycisk wysyłania w ChatTheme

Code review composera wykazał pozostały `IconButton.filled`, którego wygląd
zależał od domyślnego stylu Material. Zastąpiono go okrągłą akcją o stałym boku
z tokenami tła i pierwszego planu ChatTheme oraz semantyką przycisku. Empty state
kolumny rozmowy także korzysta z ChatTheme. `flutter analyze` bez uwag,
`git diff --check` PASS i `flutter build macos --debug` PASS. Nie uruchamiano
testów widgetowych/goldenów. CUA nadal raportuje zablokowany Mac; wygląd akcji
w runtime nie jest wizualnie potwierdzony.

### 2026-09-23 — Popover „Nowy czat” w ChatTheme

W `chat_compose_popover.dart` wyszukiwarka dostała powierzchnię/obramowanie i
style ChatTheme, akcje grupy/kanału/ogłoszenia mają własne okrągłe ikony i
zaokrąglone kafle, a wynik katalogu prezentuje avatar, nazwę, login oraz ikonę
rozpoczęcia DM. Dodano retry po błędzie katalogu i czyszczenie query/result
Cubita z przycisku kasowania. Nie zmieniono API. `flutter analyze` bez uwag,
`chat_creation_cubit_test.dart` → **17/17 PASS**, `flutter build macos --debug`
PASS, `git diff --check` PASS. Bez testów widgetowych/goldenów. CUA nadal zgłasza
zablokowany Mac, więc wymaga ręcznego odbioru.

### 2026-09-23 — Wyścig odpowiedzi w wyszukiwaniu Chat

Review wyszukiwania wykazał, że zmiana frazy nie unieważniała odpowiedzi w locie,
a poprzednie wyniki pozostawały widoczne w okresie debounce. Naprawiono zarówno
`ChatDirectorySearchCubit` (nowy czat, dodawanie osób), jak i `ChatSearchCubit`
(wyszukiwanie wiadomości): nowa fraza czyści stronę/wyniki, natychmiast pokazuje
loading dla poprawnej długości zapytania i inkrementuje identyfikator żądania.
Starsza odpowiedź nie może nadpisać nowej. Dwa zestawy testów **33/33 PASS**,
`flutter analyze` bez uwag, macOS Debug build PASS, diff check PASS. CUA nadal
raportuje zablokowany Mac; testów widgetowych/goldenów nie uruchamiano.

Uzupełnienie kontroli współbieżności: ten sam błąd został znaleziony i naprawiony
w `ChatSearchCubit` dla wyszukiwania wiadomości. Zmiana terminu czyści poprzednią
stronę wyników, zachowuje otwarty panel, pokazuje loading podczas debounce i
unieważnia odpowiedź in-flight. Testy dwóch zestawów search/creation **33/33 PASS**;
`flutter analyze`, świeży macOS Debug build i diff check PASS.

### 2026-09-23 — Stany wyszukiwania w „Dodaj osoby”

Panel dodawania uczestników wcześniej pozostawiał pusty obszar przy pustej lub
jednoznakowej frazie, a błąd katalogu przekazywał jako surowy kod API. Dodano
instrukcję początkową, podpowiedź minimalnej długości, stan pusty i lokalizowany
błąd z retry; komunikat błędu mutacji również nie ujawnia technicznego kodu jako
głównego tekstu. Testy `g5_search_and_members_test.dart` i
`chat_creation_cubit_test.dart` → **33/33 PASS**; analyze, świeży macOS Debug
build i diff check PASS. Bez widgetów/goldenów; Mac pozostaje zablokowany.

### 2026-09-23 — Odświeżanie statusów listy członków

`_MembersList` pobierał statusy presence sekwencyjnie wyłącznie w `initState`;
nowo dodane osoby w otwartym arkuszu nie dostawały statusu, a stary skład mógł
ukończyć request po zmianie listy. Pobieranie jest teraz porcjowane po 8,
równoległe w partii, wznawiane dla nowych ID w `didUpdateWidget` i zabezpieczone
generacją requestu. Testy search/creation/member **33/33 PASS**, `flutter analyze`
bez uwag, świeży macOS Debug build i diff check PASS. Bez widgetów/goldenów.

### 2026-09-23 — Listy przypiętych i zapisanych wiadomości

W listach akcji wiadomości zastąpiono domyślne `ListTile` wierszem ChatTheme.
Pinned/bookmark nie pokazują technicznych identyfikatorów jako treści; pinned
wskazuje datę przypięcia, a kliknięcie zamyka sheet i wywołuje
`ChatConversationCubit.ensureTargetLoaded`, aby skoczyć do wiadomości. Zakładki
bez notatki pokazują lokalizowany fallback i datę zapisu. Dodano fallback PL/EN.
`flutter gen-l10n`, `flutter analyze`, macOS Debug build oraz diff check PASS.
Nie uruchamiano widgetów/goldenów. CUA nadal zgłasza zablokowany Mac.
### 2026-09-23 — Naprawa portów menu rozmowy

Review wykazał dwa niepodłączone wejścia nagłówka: port wiadomości nie był
przekazywany z hostowanego widoku, więc opcje przypiętych i zakładek mogły być
nieaktywne; skok zakładki do innej rozmowy szukał repozytorium providera
niegwarantowanego przez globalny panel. Port rozmowy i port akcji są teraz
przekazywane jawnie do nagłówka. `getConversation` służy jako ACL-owany fallback
poza bieżącą stroną inboxa. `flutter analyze` czysty; testy search/member/
conversation 25/25 PASS; macOS Debug build i diff check obu repozytoriów PASS.
Wśród testów uruchomiono omyłkowo istniejący widgetowy test tożsamości panelu;
nie uruchamiać dalszych widgetów/goldenów przed akceptacją UI. Backend bez zmian.

### 2026-09-23 — Front: wspólny styl dymków w starszym widoku rozmowy

Code review wykazał, że `ChatConversationMessageList` nadal renderował wiadomości
jako pełne wiersze z kilkoma stale widocznymi ikonami. Front przełączył ten widok
na wspólny `ChatMessageBubble`: własne wiadomości są wyrównane do prawej, szerokość
jest ograniczona, długie treści korzystają z istniejącego renderera rich text, a
reply/wątek/dyskusja/edycja/usunięcie są dostępne z jednego menu po hover/focus lub
menu kontekstowego. Dymki pozostają współdzielonym elementem także dla aktywnego
panelu.

Weryfikacja: `flutter analyze` PASS; `flutter build macos --debug` PASS (ostrzeżenie
pluginów media_kit o braku wsparcia Swift Package Manager, bez wpływu na build).
Widgetów/goldenów nie uruchamiano zgodnie z decyzją użytkownika. Mac nadal jest
zablokowany według CUA, więc odbiór wizualny działającego UI pozostaje otwarty.

### 2026-09-23 — Front: kontrolki i komunikaty aktywnej ścieżki Chat

Przegląd wyszukał w `presentation/chat` domyślny `SwitchListTile`, bezpośrednie
`SnackBar` oraz `MaterialBanner`. Kanały powiadomień mają teraz wiersze oparte o
`ChatTheme`; linki, błędy akcji i niedostępna rozmowa używają wspólnego `AppToast`;
starszy widok przerwanego realtime ma lokalizowany, lekki komunikat w motywie
Chat zamiast pustego `MaterialBanner`. Skan `rg` nie znajduje w gałęzi czatu
`PopupMenuButton`, `DropdownButton`, `SwitchListTile`, `AlertDialog`,
`MaterialBanner` ani bezpośrednich `SnackBar`.

Weryfikacja: `flutter gen-l10n`, `flutter analyze` bez uwag, `flutter build macos
--debug` PASS i `git diff --check` PASS. Build zgłasza ostrzeżenie o braku SPM w
`media_kit` plugins. Bez testów widgetowych/goldenów. Runtime UI nadal nie został
obejrzany, bo CUA zgłasza zablokowany Mac.

### 2026-09-23 — Front: bezpieczny odczyt przed edycją własnego statusu

Review karty statusu znalazł błąd: gdy REST `getUserStatus` zawodził, formularz
pozostawał edytowalny. Zapis przy nieznanym stanie mógł nadpisać wcześniejszy
status i wyzerować jego termin. Karta ma teraz osobny stan błędu odczytu, blokuje
edycję/zapis do skutecznego ponowienia i pokazuje lokalizowany komunikat. Błędy
zapisu nie pokazują już technicznego `apiCode` jako tekstu użytkownikowi.

Weryfikacja: `flutter gen-l10n`; test logiki presetów i terminów **5/5 PASS**;
`flutter analyze` bez uwag; `flutter build macos --debug` PASS (ostrzeżenie SPM
pluginów media_kit); `git diff --check` PASS. Widgetów/goldenów nie uruchamiano.

### 2026-09-23 — Front: anulowanie przygotowanego pliku z długiego wklejenia

Review znalazł błąd: po nieudanym uploadzie „Zostaw jako tekst” i „Anuluj”
usuwały kartę decyzji, ale pozostawiały wybrany plik TXT w composerze. Użytkownik
mógł wysłać go przypadkiem razem z wiadomością. Obie akcje wywołują teraz
`ChatAttachmentComposerCoordinator.remove`, który unieważnia sesję Storage i
czyści ID załącznika w drafcie; wysyłka jest zablokowana na czas cleanupu. Test
koordynatora potwierdza revoke sesji i pusty draft załączników.

Weryfikacja: test `chat_attachment_composer_coordinator_test.dart` **7/7 PASS**;
`flutter analyze` bez uwag; `flutter build macos --debug` PASS (ostrzeżenie SPM
pluginów media_kit); `git diff --check` PASS. Bez testów widgetowych/goldenów.

### 2026-09-23 — Front: poprawna degradacja podglądu załączników

Review galerii wykazał, że karta uznawała sam Future miniatury za dostępność obrazu.
Gdy Storage zwrócił `null`, menu nadal otwierało pusty preview zamiast standardowo
otworzyć/pobrać plik. Karta rozróżnia teraz pobrane bajty od trwającego/nieudanego
żądania; preview pojawia się tylko dla niepustych bajtów, a fallback prowadzi do
autoryzowanego otwarcia. Każda karta ma klucz po ID, więc stan miniatury nie
przechodzi na sąsiedni załącznik po zmianie listy. Nazwa, typ i rozmiar korzystają
z typografii ChatTheme.

Weryfikacja: `flutter analyze` bez uwag; `flutter build macos --debug` PASS
(ostrzeżenie SPM pluginów media_kit); `git diff --check` PASS. Nie uruchamiałem
widgetów/goldenów zgodnie z decyzją użytkownika. CUA nadal zgłasza zablokowany Mac.


### 2026-09-23 — Front: ukrycie kodów API w błędach kreatora

Review ścieżki tworzenia rozmowy wykazał, że kod API był renderowany obok
komunikatu błędu zarówno w popoverze, jak i w kreatorze. Interfejs pokazuje teraz
krótki komunikat lokalizowany, a identyfikatory techniczne nie zaśmiecają widoku.
`flutter analyze` PASS; `flutter build macos --debug` PASS (ostrzeżenie SPM dla
pluginów `media_kit`); `git diff --check` PASS. Testów widgetowych/goldenów nie
uruchamiano. Manualny odbiór wizualny pozostaje otwarty: CUA zgłasza zablokowany
Mac.


### 2026-09-23 — Front: awatary i obecność autorów w grupach

W historii grupowej/kanałowej awatary autorów korzystają teraz ze zdjęć profilu
z katalogu uczestników. Gdy autoryzowany snapshot SignalR potwierdza użytkownika
online, przy awatarze pojawia się zielony znacznik z etykietą dostępną przez
Tooltip; offline i nieznany stan nie są zgadywane. Weryfikacja: `flutter analyze`
PASS; `flutter build macos --debug` PASS (ostrzeżenie SPM pluginów `media_kit`);
`git diff --check` PASS. Bez widgetów/goldenów zgodnie z decyzją użytkownika.
Ręczny odbiór UI nadal OPEN, bo CUA zgłasza zablokowany Mac.


### 2026-09-23 — Front: poprawki modalu członków

Lista członków i karta osoby przekazują teraz `avatarUrl` z modelu profilu, więc
nie degradują wszystkich zdjęć do inicjałów. Błędy odczytu i zmian członkostwa nie
wyświetlają surowych komunikatów/kodów API; używają lokalizowanych tekstów.
Usunięcie członka wymaga jawnego potwierdzenia, a zwykłe menu zmiany roli nie
pozwala przypisać ani edytować roli Owner (własność ma osobny kontrakt).
Weryfikacja: test logiki członków `g5_search_and_members_test.dart` **14/14 PASS**;
`flutter gen-l10n`, `flutter analyze`, `flutter build macos --debug` i
`git diff --check` PASS. Widgetów/goldenów nie uruchamiano. Próba podglądu UI przez
CUA ponownie wykazała zablokowany Mac; ręczny odbiór pozostaje OPEN.


### 2026-09-23 — Front: bezpieczne zarządzanie rolami i usuwaniem

Modal członków nie pokazuje już opcji przypisania roli Owner, nie otwiera akcji
zarządzania istniejącym właścicielem i wymaga potwierdzenia przed usunięciem
osoby. Lista i karta profilu używają `avatarUrl`; błędy listy/mutacji mają
lokalizowane komunikaty zamiast kodów API. Weryfikacja: `flutter gen-l10n`,
`flutter analyze`, test logiki `g5_search_and_members_test.dart` **14/14**,
`flutter build macos --debug` i `git diff --check` PASS. Testów widgetowych/goldenów
nie uruchamiano. Odbiór wizualny OPEN: CUA nadal zgłasza zablokowany Mac.


### 2026-09-23 — Front: lokalizowane błędy aktywnych ekranów Chat

Wyszukiwanie rozmów/wiadomości, podpowiedzi wzmianek, własny status,
powiadomienia, listy przypiętych i zakładek, skrzynka, historia rozmowy, wątki,
dyskusje oraz akcje edycji pokazują lokalizowane komunikaty zamiast kodów API i
surowych `error.message`. Konflikt edycji informuje o konieczności ponownego
otwarcia edytora. Weryfikacja: `flutter gen-l10n`, `flutter analyze`, testy
`chat_message_actions_cubit_test.dart`, `chat_thread_cubit_test.dart` i
`chat_inbox_cubit_test.dart` **17/17 PASS**; `flutter build macos --debug` i
`git diff --check` PASS. Widgetów/goldenów nie uruchamiano.


### 2026-09-23 — Front: retry odczytu przypiętych i zakładek

Błąd pierwszego pobrania list przypiętych/zakładek zostawiał w głównym obszarze
spinner bez możliwości ponowienia. Oba widoki pokazują teraz zwięzły stan błędu
z przyciskiem retry; retry czyści stary błąd i wraca do loadera. `flutter analyze`,
`flutter build macos --debug` i `git diff --check` PASS. Widgetów/goldenów nie
uruchamiano. Próbny web-server Flutter uruchomił aplikację w przeglądarce, ale
widok został przekierowany do bezpiecznego logowania BFF, więc ekranów rozmów nie
dało się zweryfikować bez sesji.

### Kontrola jakości UI czatu — zapisane wiadomości (2026-09-23)

- Naprawiono widok zapisanych wiadomości w głównym panelu: retry po błędzie pierwszego pobrania, widoczny komunikat po nieudanym usunięciu oraz kolory i typografia zgodne z `ChatTheme`.
- Dodano wspólny formatter czasu dla listy rozmów i zapisanych wiadomości; usunięto surowe timestampy z sekundami.
- Weryfikacja Front: `dart format` PASS, `flutter analyze` PASS, `flutter test test/workspaces/presentation/chat/chat_timestamp_formatter_test.dart` PASS (2/2), `flutter build macos --debug` PASS, `git diff --check` PASS. Widget/golden tests pozostają odłożone do akceptacji wyglądu przez użytkownika.
- Zgodność sprawdzono statycznie względem specyfikacji UI i konwencji `ChatTheme`. Nie potwierdzono jeszcze wyglądu runtime: web preview przekierowuje do logowania BFF, a dostępny ekran macOS jest zablokowany. Wymagana pozostaje wizualna kontrola po uzyskaniu autoryzowanej sesji.

## Aktualizacja wykonania — 2026-09-23: szerokość trzech kolumn panelu

Naprawiono rozjazd breakpointu i szerokości listy: gdy panel osiąga minimum układu trzech kolumn (722 px), lista ma 304 px; zwiększa się do 344 px dopiero przy dostępnej nadwyżce. Chroni to układ przed ściskaniem/overflowem w przedziale 722–761 px. Reguła jest testowana bez widgetów. Weryfikacja Front: test `chat_panel_size_test.dart` 6/6 PASS, `flutter analyze` PASS, `flutter build macos --debug` PASS. `git diff --check` należy ponowić po aktualizacji dokumentacji. Zrzut macOS nadal pokazuje pulpit zamiast okna aplikacji; wizualny odbiór runtime pozostaje OPEN. Widgety/goldeny pozostają DEFERRED do akceptacji wyglądu przez użytkownika.

## Aktualizacja wykonania — 2026-09-23: wysokość edytora composera

Wspólna polityka ogranicza wysokość pola do min(160 px z ChatTheme, 30% dostępnej wysokości rozmowy), z minimum jednej linii. Zastosowano ją do plain text i Quill zamiast stałej wysokości 96/112 px dla Quill. Weryfikacja Front: test polityki 4/4 PASS, `flutter analyze` PASS, `flutter build macos --debug` PASS. Brak testów widgetowych/goldenów zgodnie z odroczeniem do akceptacji wyglądu. Ręczny odbiór pozostaje OPEN: macOS jest zablokowany i nie udostępnia okna DevPlanner przez CUA.

## Aktualizacja wykonania — 2026-09-23: wspólny renderer odpowiedzi w wątku

W panelu wątku zwykły tap nie kopiuje już automatycznie całej odpowiedzi. Lista jest objęta `SelectionArea`; menu oferuje kopiowanie całej wiadomości i zaznaczenia. Odpowiedzi korzystają ze wspólnego `ChatMessageBubble` głównej historii, co dodaje wyrównanie nadawcy, obsługę załączników/usunięcia/statusu i wspólne menu. Nagłówek/tekst stanu korzystają z `ChatTheme`. Weryfikacja Front: `flutter analyze` PASS i `flutter build macos --debug` PASS; widget/golden tests nieuruchomione zgodnie z odroczeniem. Runtime UI pozostaje nieobejrzany, ponieważ macOS jest zablokowany.

## Aktualizacja wykonania — 2026-09-23: retry historii wątku

Transientny błąd doładowania starszej strony nie usuwa już odpowiedzi ani kursora. Stan gotowy zachowuje wiadomości i udostępnia retry tej samej strony; błąd początkowego wczytania także ma retry, a odmowa/cofnięcie ACL nadal odłącza widok. UI pokazuje stan ładowania, komunikat i ponowienie przy stopce. Test `chat_thread_cubit_test.dart` 3/3 PASS (w tym błąd → zachowana historia/kursor → udane retry), `flutter analyze` PASS, build macOS Debug PASS. Testów widgetowych/goldenów nie uruchamiano; runtime wizualny wciąż OPEN przez blokadę macOS.

## Aktualizacja wykonania — 2026-09-23: rzeczywisty stan przypięć i zakładek

Panel aktywnej rozmowy uruchamia teraz odczyt przypięć dla danej rozmowy i prywatnych zakładek. Udane przypięcie/odpięcie oraz zapisanie/usunięcie zakładki aktualizują lokalne zbiory od razu, więc etykieta akcji menu zmienia się bez ponownego odczytu. Generacje odrzucają spóźniony odczyt, który inaczej mógłby cofnąć świeżą mutację. Test `chat_message_secondary_actions_test.dart` 7/7 PASS (w tym odczyt przypięć, natychmiastowa aktualizacja, cofnięcie i wyścig), `flutter analyze` PASS, build macOS Debug PASS. Widgety/goldeny nadal odroczone; runtime wizualny OPEN.

## Aktualizacja wykonania — 2026-09-23: pełniejsze akcje wiadomości w wątku

Root side sheet wątku dostaje jawnie repozytorium akcji, zakres moderacji i cele przekazania. Odpowiedzi korzystają z `ChatMessageActionMenu`: reakcje, copy całej wiadomości/zaznaczenia, pin/bookmark, forward oraz edit/delete z potwierdzeniem i wersją. Osobne Cubity są tworzone wewnątrz modala; sukces edycji/usunięcia podmienia wiadomość w historii wątku, a revoke zatrzymuje kolejkę. Menu pin/bookmark odczytuje stan z Cubita w chwili otwarcia, a nie z nieaktualnego snapshotu widgetu. Weryfikacja Front: testy logiki pin/bookmark i wątku 10/10 PASS, `flutter analyze` PASS, macOS Debug build PASS, `git diff --check` należy potwierdzić po dopisaniu wpisu. Testy widgetowe/goldenowe nadal odroczone; runtime visual review OPEN (Mac zablokowany).
### CHAT-R29 — realtime statusów uczestników (2026-09-23)

Front dodaje typowany strumień statusów w porcie rozmowy, mapuje kontrakt
`chat.user_status.changed` (`{userId,status}`), emituje jawne czyszczenie jako
`status: null` i aktualizuje status w nagłówku rozmówcy. Backend potwierdzony w
`Infrastructure/Chat/ChatRealtimeConnectionManager.cs` oraz
`Application/Chat/ChatUserStatusService.cs`; bez zmian backendu i migracji.
Dodano testy mapowania i emisji live statusu. Weryfikacja: mapper/usługa **9/9**,
test Cubita status/presence **3/3**, `flutter analyze`, `flutter build macos
--debug` i `git diff --check` PASS. Widgetów i goldenów nie uruchamiać przed
akceptacją UI. Ręczny odbiór wyglądu nadal OPEN, CUA raportuje zablokowany Mac.

### CHAT-R30 — kontrolki modali z własnym motywem Chat (2026-09-23)

`ChatSurfaceDialog` jest prezentowany przez root navigator i wcześniej pozwalał
akcjom/polom dziedziczyć style ekranu bazowego. Dialog aplikuje teraz
`DevPlannerChatTheme.applyControls` do całej zawartości, zachowując jego własne
powierzchnie i geometrię. Weryfikacja: `flutter analyze`, `flutter build macos
--debug` i `git diff --check` PASS. Widgetów/goldenów nie uruchamiano. Runtime
visual review pozostaje OPEN, ponieważ CUA nadal zgłasza zablokowany Mac.

### CHAT-R31 — własny motyw jasny/ciemny komunikatora (2026-09-23)

Paleta `DevPlannerChatTheme` nie wylicza już powierzchni i akcentu z niebieskiego
`ColorScheme` Material. Jasny wariant ma neutralną listę, kremową historię,
miętowy dymek wychodzący i zielone akcje; ciemny ma grafitowe powierzchnie,
zielony dymek i czytelny tekst. Dodano testy tokenów i `applyControls` (3/3).
`flutter analyze`, `flutter build macos --debug` i `git diff --check` PASS.
Widgetów/goldenów nie uruchamiano. Wizualny odbiór runtime pozostaje OPEN przez
blokadę Maca.

### CHAT-R32 — bez duplikowania wklejonej treści i pliku TXT (2026-09-23)

W `_keepPendingPasteAsText` cleanup załącznika odbywa się przed wstawieniem
tekstu do szkicu. Jeśli odwołanie sesji/załącznika zawiedzie, karta pokazuje błąd
i treść nie jest kopiowana do composera — użytkownik nie może wysłać jej
podwójnie. Testy `chat_attachment_composer_coordinator_test.dart` oraz
`chat_long_paste_decision_test.dart` **16/16 PASS**; `flutter analyze`,
`flutter build macos --debug` i `git diff --check` PASS. Widgetów/goldenów nie
uruchamiano; runtime UI nadal OPEN, Mac zablokowany dla CUA.

### CHAT-R33 — limit członków tylko dla grup (2026-09-23)

Backend egzekwuje `MaxConversationParticipants` wyłącznie dla rozmów `Group`;
UI wcześniej ograniczało też kanały i ogłoszenia do 50. `ChatMembersSheet`
przekazuje limit wolnych miejsc tylko dla grup, a `ChatAddMembersView` nie
pokazuje licznika/nie blokuje kanałów i ogłoszeń. Test
`g5_search_and_members_test.dart` **14/14 PASS**, `flutter analyze`, macOS Debug
build i `git diff --check` PASS. Nie uruchamiano testów widgetowych; runtime
visual review OPEN przez blokadę Maca.

### CHAT-R34 — menu wiersza skrzynki i błędy akcji (2026-09-23)

`ChatInboxRow` ma widoczny, lokalizowany przycisk opcji; menu otwiera się też
prawym kliknięciem, długim przytrzymaniem i klawiszem Menu/Shift+F10. Wszystkie
wejścia uruchamiają te same akcje. Wyciszanie i archiwizacja pokazują lokalizowany
błąd, nie surowy tekst API. `flutter gen-l10n`, `flutter analyze`, macOS Debug build oraz
`git diff --check` PASS. Testów widgetowych nie uruchamiano; runtime review OPEN,
Mac nadal zablokowany dla CUA.

### CHAT-R35 — poprawa geometrii kontrolki statusu (2026-09-23)

W `chat_status_menu.dart` rozdzielono selektor czasu wygaśnięcia i DND na dwa
pełnoszerokie wiersze karty. Poprzedni układ zestawiał pole i długi polski
przełącznik w jednym wierszu, co mogło ścisnąć lub obciąć tekst pola przy
maksymalnej szerokości popovera. Test logiki presetów/statusów **5/5 PASS** i
`flutter analyze` PASS; macOS Debug build oraz `git diff --check` do wykonania
po tej poprawce. Testów widgetowych/goldenów nie uruchamiano. CUA ponownie
potwierdził zablokowany Mac; render runtime pozostaje niezweryfikowany.

### CHAT-R35 — poprawa geometrii kontrolki statusu (uzupełnienie)

Weryfikacja po zmianie zakończona: test logiki statusów **5/5**, `flutter
analyze`, `flutter build macos --debug` i `git diff --check` PASS. Runtime
pozostaje nieobejrzany przez blokadę Maca.

### CHAT-R36 — wspólny przełącznik ChatTheme (2026-09-23)

Dodano `shared/chat_toggle.dart` i użyto `ChatToggle` dla DND oraz kanałów
powiadomień; usunięto systemowy `Switch.adaptive` z UI Chatu. Wyczyszczono też
podwójne `@override` w dispose composera. Test ustawień globalnych **3/3**,
logika statusów **5/5**, `flutter analyze`, macOS Debug build i `git diff
--check` Front PASS. Widgetów/goldenów nie uruchamiano. Mac zablokowany dla CUA,
więc runtime wygląd i focus pozostają do sprawdzenia.

### CHAT-R37 — menu ChatTheme w root navigatorze (2026-09-23)

`AppContextMenu._open` przechwytuje `ThemeData` wywołującego i przekazuje go do
rootowej `PopupRoute`, więc menu zachowuje lokalne style zamiast wracać do
motywu root overlayu. `DevPlannerChatTheme.applyControls` podmienia tokeny
`DevPlannerMenuTheme` w panelu i rootowych dialogach Chat: powierzchnie,
selekcję, hover, tekst,
separatory, promień 14 px i wysokość wiersza 40 px. `applyControls` styluje też
przyciski ikon, kursor i zaznaczenie pól. Testy ChatTheme **4/4** i
polityki geometrii **4/4**, `flutter analyze`, macOS Debug build oraz
`git diff --check` Front PASS. Testów widgetowych/goldenów nie uruchamiano;
runtime nadal OPEN z powodu zablokowanego Maca. Backend/API bez zmian.

Uzupełnienie R37: test tokenów potwierdza również kolor ikon i text selection;
`flutter analyze`, test ChatTheme **4/4**, macOS Debug build i diff check PASS.

### CHAT-R38 — pełnoekranowa rozmowa używana przez panel dyskusji (2026-09-23)

`ChatConversationPageView` pozostaje używany w `ChatDiscussionSidePanel` i
teście rozmowy. Zastąpiono hardkodowane `Czat` nowym kluczem PL/EN
`chatConversationPageTitle`, a nagłówek korzysta z ChatTheme; usunięto import
legacy `core/l10n` i `core/theme` na rzecz `foundation`. `flutter gen-l10n`,
`flutter analyze`, macOS Debug build i `git diff --check` PASS. Testów widgetowych
nie uruchamiano. Runtime nadal OPEN (Mac zablokowany).

### CHAT-R39 — importy presentation Chat z foundation (2026-09-23)

Zaktualizowano lokalizację/motyw w załącznikach, dyskusji, akcjach wiadomości i
modalnych ustawieniach powiadomień. Skan potwierdza brak
`package:devplanner/core/l10n` i `core/theme` w `presentation/chat`.
`dart format`, `flutter analyze`, macOS Debug build i `git diff --check` PASS.
Testów widgetowych nie uruchamiano; runtime pozostaje OPEN.

### Otwarte zgłoszenie UI — mały obraz i przycięta tapeta (2026-09-23)

Do odtworzenia na wskazanym przez użytkownika ekranie: przy mniejszym obrazie
znika element, a tapeta jest ucięta od dołu. Zgłoszenie jest nierozpoznane i nie
zostało naprawione. Renderer istnieje w `lib/app/shell/devplanner_shell_layout.dart`:
`assets/images/bg.jpeg` (3440×1440) jest malowany z `BoxFit.cover`, a panel jest
warstwą nad pełnym shellem. Oględziny runtime potwierdziły widok Files/Tasks i
panel Chat w Archiwum; kliknięcia kończyły się `noWindowsAvailable`, więc nie
uzyskano stabilnej reprodukcji aktywnej rozmowy ani kadru.

### CHAT-R40 — bieżący zestaw testów Backend Chat (2026-09-23)

Backend: komenda z filtrem `FullyQualifiedName~Chat` zakończyła się wynikiem
**231 PASS, 3 SKIP, 0 FAIL**. Trzy skipy zależą od Redis (`localhost:6380`), w
tym dwu-hostowy SignalR. Backend bez zmian; wynik nie zastępuje testów pełnego
backendu ani runtime UI.


### CHAT-R41 — fixture’y integracyjne Redis/SignalR (2026-09-23)

Naprawiono harnessy testowe: Redis worker dostał `WorkspaceDbContext` i
`IHubContext<ChatEventsHub>` w zakresie DI. Dwu-hostowy test SignalR tworzy
aktywne `LocalUser`/`DeviceSession` w PostgreSQL, podaje prawidłowe claimy
desktopowe i usuwa dane po teście, dzięki czemu przechodzi produkcyjny hub
filter i nadal sprawdzany jest revoke członkostwa rozmowy.

Weryfikacja: chat suite z Redisem **234/234 PASS, 0 SKIP**; build Backend
**0 warning/0 errors**; `dotnet format veloryn-workspaces.csproj
--verify-no-changes` PASS; idempotentne skrypty `WorkspaceDbContext` i
`LocalIdentityDbContext` PASS. Front `flutter analyze` i macOS Debug build
PASS. Nie zmieniono produkcyjnego API, schematu ani implementacji backendu;
deploy nie był potrzebny. UI nadal wymaga odbioru runtime — macOS jest
zablokowany dla CUA.

### CHAT-R42 — toolbar Quill w wąskim panelu (2026-09-23)

Naprawiono overflow paska rozbudowanego edytora: do 480 px pokazuje podstawowe
akcje formatowania i menu dla list, cytatu, bloku kodu oraz czyszczenia formatu;
szerszy panel pokazuje pełen zestaw. Dodano klucz PL/EN do ARB i wygenerowano
lokalizacje. `flutter analyze` oraz macOS Debug build PASS. Po ponownym otwarciu
builda w oknie 800×630 CUA potwierdziło brak obciętych ikon i komplet pięciu
opisanych akcji w menu. Bez testów widgetowych/golden i bez backendowych zmian.

### CHAT-R43 — ręczny odbiór przepływów 800×630 (2026-09-23)

W runtime obejrzano modal członków, widok „Dodaj osoby” (41 wolnych), wyszukanie
Piotra Wiśniewskiego i lokalny stan zaznaczenia; zaznaczenie cofnięto i modal
anulowano bez modyfikacji rozmowy. Sprawdzono menu statusu (presety, status
własny, wygaśnięcie, DND) bez zapisu. W kreatorze grupy przejrzano wybór osób
oraz szczegóły: nazwa i polityka publikowania „Wszyscy członkowie” albo „Tylko
właściciel i moderatorzy”; kreator anulowano bez utworzenia grupy. Wyszukiwarki
zwróciły wyniki dla „Pi”. Menu wiadomości obejrzano: odpowiedź, kopiowanie,
wątek, reakcja, przekazanie, edycja/usunięcie, przypięcie i zakładka.
`flutter test` dla format commands i wysokości composera: **16/16 PASS**.
Brak zmian danych stagingowych. Testów widgetowych/golden nie uruchamiano.

## CHAT-R48 — usunięcie redundantnego filtra kategorii (2026-09-23)

Zakładki Grupy, Kanały i Archiwum miały tylko jeden chip filtra o tej samej
nazwie co nagłówek sekcji. Ukryłem chip, gdy `visibleFilters.length <= 1`;
filtry wielokrotne w Czatach pozostają widoczne. Świeży build przy 800×630
potwierdził, że Grupy pokazuje nagłówek, wyszukiwarkę i rozmowy bez
powtórzonego chipu. `flutter analyze`, macOS Debug build i `git diff --check`
PASS. Widget/golden tests odroczone zgodnie z instrukcją użytkownika; nie
otwierano rozmowy ani nie zmieniano danych staging.

### CHAT-R49 — przewijana lista popovera „Nowy czat” (2026-09-23)

`ChatComposePopover` przekazuje ograniczoną wysokość do zawartości; wewnętrzne
`Flexible` pozwala przewijać wyłącznie kontakty/wyniki, a tytuł, wyszukiwarka i
akcje tworzenia pozostają widoczne. MacOS 800×630 potwierdził to w runtime na
stagingu. `/health/live`, `/health/ready`, chat inbox, unread count i workspaces
zwróciły HTTP 200. `flutter analyze`, macOS Debug build i Front `git diff
--check` PASS. Nie otwierano konwersacji i nie zmieniano danych stagingowych.
Testowa instancja została zamknięta (CUA: `DevPlanner isRunning=false`).
Widget/golden testów nie uruchamiano zgodnie z instrukcją; pełny odbiór wyglądu
Chat i zgłoszonego kadru tapety nadal jest otwarty.

### CHAT-R50 — menu formatowania Quill w ChatTheme (2026-09-23)

W `chat_composer_rich_toolbar.dart` zastąpiono domyślny `PopupMenuButton`
`AppContextMenu`. Akcje formatowania zachowują ikony, lokalizowane nazwy, stan
zaznaczenia i dotychczasowe komendy. Skan aktywnego `presentation/chat` nie
znajduje innych domyślnych menu/list wyboru/dialogów Material ani bezpośrednich
bannerów/toastów; `MenuAnchor` karty statusu jest celowo custom. `flutter analyze`
i macOS Debug build PASS. Nie otwierano konwersacji; runtime preview menu
kompozytora oraz testy widget/golden pozostają odroczone do odbioru UI.

### CHAT-R51 — poprawka hit targetu globalnego Chat (2026-09-23)

Odtworzony błąd: etykieta Badge z liczbą nieprzeczytanych przejmowała klik
ikony Chat. `devplanner_shell_layout.dart` pokazuje teraz badge jako warstwę
`IgnorePointer` nad niezmienionym przyciskiem i zachowuje semantyczną etykietę
licznika. Runtime staging przy 33 nieprzeczytanych potwierdził otwarcie Chat
jednym kliknięciem po zamknięciu panelu. Nie otwierano rozmów ani nie zmieniano
danych. `flutter analyze`, macOS Debug build i diff check PASS; instancja
zamknięta (CUA: `DevPlanner isRunning=false`).

### CHAT-R52 — responsywny układ popovera

`chat_compose_popover.dart` zwęża padding/odstępy i układa akcje grupy, kanału i
ogłoszenia w jednym rzędzie przy niskiej wysokości, pozostawiając wyszukiwarkę
oraz przewijany obszar wyników. `flutter analyze` i macOS Debug build PASS.
Odbiór runtime małego viewportu **OPEN**: po resize wykonanym przez CUA widok
aplikacji zajmował tylko górną część okna, a reszta była pusta; nie ustalono
przyczyny i nie uznano tego za poprawny test. Nie otwierano konwersacji.
Instancja testowa zamknięta (CUA: `DevPlanner isRunning=false`).

### CHAT-R53 — jedna instancja podczas ręcznego QA (2026-09-23)

Dodano do `AGENTS.md` regułę, by przy desktopowym QA używać najwyżej jednej
instancji, preferować działającą sesję i zamykać proces po kontroli. Po zgłoszeniu
użytkownika wykonano wyłącznie `pgrep -alf 'DevPlanner|devplanner|flutter run'`;
wynik zawierał sam proces polecenia `pgrep`, bez aplikacji ani sesji Flutter.
Nie uruchamiano aplikacji. `BoxFit.cover` w shellu oraz tapeta 3440×1440 zostały
statycznie sprawdzone, lecz nie potwierdzają reprodukcji zgłoszonego kadru.
`flutter analyze`, build macOS i testy nie były potrzebne, bo zmiana dotyczy
wyłącznie instrukcji QA.

### CHAT-R54 — staging health i weryfikacja kompozycji załączników (2026-09-23)

Staging zwrócił HTTP 200 dla `/health/live` i `/health/ready`. Jedna podglądowa
instancja DevPlanner pokazała ekran logowania; nie klikano przycisku, który
uruchamia zewnętrznego dostawcę, i nie wpisywano danych. Zamknięto aplikację
przez `Quit DevPlanner`, po czym CUA zgłosiło `isRunning=false`.

Nieaktualny wpis G6 twierdził, że produkcyjny composition root nie dostarcza
Storage ani transportu uploadu. Aktualny `DevPlannerApp` tworzy
`DevPlannerStorageComposition`, przekazuje repozytorium i izolowany presigned
transport do `DevPlannerStandaloneRuntime`, a ten udostępnia picker i porty
załączników globalnemu Chatowi. Test kompozycji: **2/2 PASS**; `flutter analyze`
bez problemów; `flutter build macos --debug` PASS. Rzeczywisty upload/pobranie
pozostają niezweryfikowane bez sesji logowania; danych stagingowych nie
zmieniano.

### CHAT-R55 — łączenie dymków wiadomości w serie (2026-09-23)

W globalnym panelu pozycja wiadomości w serii trafia teraz do `ChatMessageBubble`.
Samodzielne dymki zachowują pełne zaokrąglenie; w serii narożniki po stronie
nadawcy stykające się z kolejnymi dymkami są mniejsze. Dla wiadomości własnych
układ jest lustrzany. Dzięki temu kilka kolejnych wiadomości wygląda jak jedna
zwarta seria zamiast powtarzających się, odrębnych kart.

`flutter analyze` bez problemów; `flutter build macos --debug` PASS;
`git diff --check` PASS. Nie uruchamiano aplikacji ani testów widget/golden.
Runtime odbiór wyglądu pozostaje otwarty do czasu zalogowanej sesji.

### CHAT-R56 — kontrakt enumów transportowych Chat (2026-09-23)

Dodano test pełnego zestawu i round-trip wartości przewodowych dla typów
rozmowy, zakresu, preferencji powiadomień i statusu dostarczenia. Sprawdzono
również jawne wartości query filtra inbox oraz ról członków. Test
`chat_enum_wire_contract_test.dart`: **1/1 PASS**. `ChatInvitationStatus` nie
został sklasyfikowany jako transportowy, ponieważ nie ma endpointu backendu,
który obecnie go wystawia. Backendowy test OpenAPI/serializacji: **8/8 PASS**;
Swagger staging nadal zwraca HTTP 500.

### CHAT-R57 — zawijanie długich URL-i bez metadanych linku (2026-09-23)

`ChatRichTextBody` dodawał punkty łamania tylko do linków potwierdzonych przez
backend. Gdy odpowiedź nie zawierała metadanych, bardzo długi URL renderował się
jak zwykły, niełamliwy tekst. Renderer dodaje teraz niewidoczne możliwości
zawinięcia do URL-i HTTP(S) w zwykłych segmentach tekstu; nie czyni ich
klikalnymi ani nie zmienia tekstu domenowego. Test reguł wyświetlania **8/8
PASS**, analiza trzech zmienionych plików PASS, `git diff --check` PASS. Bez
widget/golden testów i bez uruchamiania aplikacji; wygląd runtime pozostaje
niezweryfikowany.

### CHAT-R58 — serwerowe wyszukiwanie skrzynki (2026-09-23)

Backend `GET /api/v1/chat/inbox` przyjmuje opcjonalny `query` (2–80 znaków) i
wyszukuje tytuły rozmów oraz nazwy/login aktywnych uczestników przed filtrem i
paginacją, z zachowaniem ACL. Front wysyła query po debounce 300 ms; nowa fraza
resetuje kursor, dalsze strony zachowują frazę, a wejście krótsze niż dwa znaki
pozostaje lokalne dla aktualnej strony. Wygenerowano klienta Retrofit.

Backend pełny test suite: **1304 PASS, 0 FAIL, 4 SKIP**; testy inbox/OpenAPI
**20/20 PASS**; `dotnet format` zmienionych plików PASS; idempotentny skrypt EF
został wygenerowany dla `WorkspaceDbContext`; `git diff --check` PASS. Front
test adaptera/Cubita **22/22 PASS**, `flutter analyze` zmienionych źródeł/testów
PASS i `git diff --check` PASS. Build macOS Debug **PASS** (ostrzeżenie: dwa media-kit pluginy nie wspierają
Swift Package Manager); GUI, widget/golden testy ani deploy nie były uruchamiane. Schemat bazy się nie zmienił.

### CHAT-R59 — błąd PostgreSQL w snapshotach presence (2026-09-23)

Podczas odbioru na stagingu znaleziono powtarzane błędy translacji EF w
`ChatPresenceStore.ListActiveAsync`; dotyczyły snapshotów online uczestników.
Backend sortuje teraz grupy po kluczu przed projekcją kontraktu, z testem na
rzeczywistym PostgreSQL. Test `ChatPresenceStorePostgresTests` **1/1 PASS**;
testy łączone realtime/inbox/OpenAPI **28/28 PASS**. Staging nadal działa na starej
wersji i lokalnej poprawki jeszcze tam nie ma. Na stagingowym buildzie macOS ręcznie otwarto inbox, rozmowę, modal
dodawania osób i menu kontekstowe wiadomości; nie wykonano mutacji. Build
zamknięto i potwierdzono brak procesu. Nie uruchamiano testów widgetowych.

### CHAT-R60 — kompletność wyszukiwania kontaktów inboxu (2026-09-23)

Backend nie obcina już dopasowań kontaktów do pierwszych 50 użytkowników
globalnego katalogu. Wyszukiwanie bierze kandydatów z aktywnych uczestników
rozmów widocznych dla bieżącego użytkownika, a następnie szuka loginu i nazwy
(bez e-maila). PostgreSQL sprawdził kompletność na 51 pasujących kontaktach:
`ChatInboxPostgresTests` **13/13 PASS**. Zmienione pliki przeszły
`dotnet format --verify-no-changes` i `git diff --check`. Bez zmian Fluttera,
API, OpenAPI, enumów ani schematu. Nie uruchamiano GUI ani widget/golden testów;
nie wykonano deployu, commitu ani pushu.

### CHAT-R61 — zakotwiczone menu emoji composera (2026-09-23)

Pliki: `lib/workspaces/presentation/chat/emoji/chat_emoji_picker.dart` i
`lib/workspaces/presentation/chat/composer/chat_message_composer.dart`.
Picker wywołany z composera przyjmuje `GlobalKey` kotwicy i używa
`showMenu`/`RelativeRect`, stylując popup tokenami `ChatTheme`. Ten sam widget
zachowuje istniejący picker modalny dla reakcji i statusu. W runtime menu
pojawiło się nad ikoną bez scrim; Escape zamknął je bez wpisania emoji.

Weryfikacja: `dart format` PASS; `flutter analyze --no-pub` PASS; macOS Debug
build z `DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl` PASS; smoke test
jednej instancji PASS. Po kontroli wybrano Quit DevPlanner i potwierdzono
`isRunning=false`. Nie uruchamiano widget/golden tests ani nie zmieniano danych.
Następny krok: kontynuować przegląd aktywnych wymagań UI/realtime; aplikację
uruchamiać tylko na pojedynczy odbiór i zamykać po nim.

### CHAT-R62 — badge’e nieprzeczytanych zgodne z ChatTheme (2026-09-23)

Pliki: `lib/workspaces/presentation/chat/inbox/components/chat_inbox_row.dart`,
`lib/workspaces/presentation/chat/shell/layout/chat_panel_list_pane.dart`,
`lib/app/shell/devplanner_shell_layout.dart`. Badge’e wiersza, sumy panelu i
globalnej ikony Chat używają teraz powierzchni/tekstu przycisku wysyłki z
`ChatTheme`, zamiast `linkText` (niebieski) i `colorScheme.error` (czerwony).
Flutter analyze i macOS Debug build PASS. W pojedynczej instancji sprawdzono
wszystkie trzy badge’e jako zielone oraz menu emoji zakotwiczone przy composerze.
Aplikację zamknięto i potwierdzono `isRunning=false`. Widget/golden testów nie
uruchamiano zgodnie z dyspozycją użytkownika; Backend/API bez zmian.

### CHAT-R63 — runtime QA Chat i rewalidacja macOS (2026-09-23)

Front: `flutter analyze` bez uwag oraz macOS Debug build PASS. Na jednej
instancji obejrzano rozmowę, menu kontekstowe wiadomości (odpowiedz, kopiuj,
wątek, reakcja, forward, edytuj/usuń/przypnij/zapisz), menu emoji, listę
uczestników, wyszukanie „Jan” w dodawaniu osób i początek kreatora grupy.
Przepływy anulowano bez zmian w danych. Pierwszy stan po wybraniu rozmowy
pokazał `offline`, ale znikał po załadowaniu historii; brak dwu-sesyjnego
potwierdzenia zdarzeń. Aplikację zamknięto, CUA potwierdziło
`isRunning=false`. Widget/golden testów nie uruchamiano.

### CHAT-R64 — fałszywy początkowy stan offline (2026-09-23)

- Pliki: `lib/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart`,
  `test/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit_test.dart`.
- Przyczyna: `BehaviorSubject` klienta SignalR odtwarza `disconnected` jako
  wartość początkową. Prezentacyjny Cubit interpretował tę wartość jako błąd,
  zanim transport rozpoczął próbę połączenia.
- Zmiana: ignorowany jest tylko początkowy `disconnected`; po pierwszym innym
  stanie wszystkie kolejne przejścia, w tym rzeczywisty disconnect, są emitowane
  bez opóźnienia. Nie dodano debounce ani timera.
- Weryfikacja: `flutter test --no-pub test/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit_test.dart test/workspaces/data/realtime/workspace_signalr_client_test.dart`
  **12/12 PASS**; `dart analyze` obu zmienionych plików **PASS**.
- Runtime/UI oraz dwu-sesyjne E2E nadal otwarte. Nie uruchamiano GUI/widgetów/
  goldenów; Backend/API/schemat bez zmian. Następny krok: kontynuować weryfikację
  pełnego UI oraz połączenia realtime w dwóch sesjach, po sprawdzeniu że aplikacja
  nie działa już w tle.

### CHAT-R65 — skok do starszej zapisanej wiadomości (2026-09-23)

- Plik: `lib/workspaces/presentation/chat/chat_drawer.dart`.
- Problem: skok spoza aktualnie wczytanego inboxa skanował maksymalnie 10 stron,
  po czym kończył się bez komunikatu. Starsze rozmowy mogły być niedostępne
  mimo istnienia backendowego endpointu szczegółów rozmowy.
- Zmiana: pobranie rozmowy po ID przez `ChatConversationRepository`, które
  ponownie sprawdza dostęp ACL; błędny/niedostępny wynik pokazuje lokalizowany
  toast zamiast cichego braku reakcji.
- Weryfikacja: `dart analyze` zmienionych plików oraz pełny
  `flutter analyze --no-pub` **PASS**; `flutter test --no-pub` repozytorium
  Chat + realtime + status Cubita **21/21 PASS**; macOS Debug build **PASS**
  (ostrzeżenie SPM dwóch istniejących pluginów `media_kit`);
  `git diff --check` **PASS**.
- Bez zmian Backend/API/OpenAPI/schematu. GUI/widget/golden testów nie
  uruchamiano. Następny krok: kontynuować przegląd działających przepływów UI;
  po akceptacji użytkownika wykonać widgetowe/golden testy i dwu-sesyjne E2E.

### CHAT-R66 — smoke test panelu i popovera compose (2026-09-23)

- Świeży macOS Debug build otwarto w jednej instancji. Globalny Chat otworzył
  się jednym kliknięciem; obejrzano rail, inbox i widok pustej rozmowy.
- Ciemny wariant ChatTheme ma grafitowe powierzchnie, zielony akcent i oddzielne
  tło rozmowy. Popover „Nowy czat” pokazuje wyszukiwanie osób, ostatnie kontakty
  oraz akcje „Nowa grupa”, „Nowy kanał”, „Nowe ogłoszenia”.
- Popover zamknięto Escape; nie wybrano kontaktu/rozmowy i nie zmieniono danych.
  Przywrócono poprzedni jasny motyw. DevPlanner zamknięto, CUA potwierdziło
  `isRunning=false`.
- Istniejące rozmowy celowo nie były otwierane, ponieważ mogłoby to zmienić
  unread. Odbiór wewnątrz rozmowy i dwu-sesyjne realtime nadal otwarte;
  widget/golden testów nie uruchamiano.

### CHAT-R67 — komentarze serwerowego wyszukiwania inboxa (2026-09-23)

- Pliki: `lib/workspaces/presentation/chat/chat_drawer.dart` oraz
  `lib/workspaces/presentation/chat/shell/layout/chat_panel_list_pane.dart`.
- Komentarze błędnie sugerowały lokalne filtrowanie już załadowanych rozmów.
  Zaktualizowano je do obecnego kontraktu: query inboxa wyszukuje po stronie
  serwera nazwy rozmów i aktywnych uczestników; treść wiadomości ma osobny widok.
- `git diff --check` PASS. Nie uruchamiano testów, bo zmiana dotyczy komentarzy.

### CHAT-R68 — stała strefa dropu załączników w composerze (2026-09-23)

- Pliki: `lib/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_controls.dart`,
  `lib/workspaces/presentation/chat/composer/chat_message_composer.dart` oraz
  lokalizacje EN/PL w `lib/l10n/app_*.arb` i wygenerowanych plikach.
- Przyczyna: `DropTarget` znajdował się w zwijanym pasku załączników; przy
  pustej kolejce pasek miał rozmiar zero, więc nie odbierał pierwszego dropu.
- Zmiana: trwała strefa obejmuje całe pole composera, a aktywny drag pokazuje
  nakładkę ChatTheme. Zdarzenia idą przez istniejący adapter i koordynator;
  podczas oczekiwania na potwierdzenie nie przyjmuje kolejnych dropów. Pasek
  kart jest `StatelessWidget` bez pozostawionego stanu drag/drop. Błąd odczytu
  upuszczonego pliku pokazuje lokalizowany toast zamiast nieobsłużonego wyjątku.
- Weryfikacja: testy koordynatora i adaptera **13/13 PASS**; analiza całego
  Frontu i macOS Debug build PASS (Flutter zgłasza istniejące ostrzeżenia SPM
  pluginów `media_kit`); `git diff --check` PASS.
- Nie uruchamiano testów widgetowych/golden. Otworzono i zamknięto jedną
  instancję DevPlanner, ale bez testowania interakcji w rozmowie. Ręczny drop w
  zalogowanej rozmowie pozostaje do sprawdzenia; bez zmian backendu/API/OpenAPI,
  enumów lub schematu. Następny krok: ręczny smoke test dropu w runtime.

### CHAT-R69 — fail-closed przy niepełnej integracji załączników (2026-09-23)

- Pliki: `lib/workspaces/presentation/chat/composer/chat_message_composer.dart`,
  `lib/workspaces/presentation/chat/composer/chat_composer_surface.dart` oraz
  lokalizacje EN/PL i pliki wygenerowane.
- Problem: samo istnienie file pickera odblokowywało wybór zdjęcia/pliku, nawet
  gdy runtime nie dostarczył portu uploadu. Wybrany plik trafiał do `_addInputs`,
  który kończył działanie bez komunikatu, bo koordynator był `null`.
- Zmiana: obie akcje wymagają file pickera i koordynatora. Menu `+` wyjaśnia
  lokalizowanym podtytułem, dlaczego załączniki są wyłączone.
- Weryfikacja: `flutter gen-l10n`; `flutter analyze --no-pub`; załączniki,
  adapter, long-paste i trwałość draftu **28/28 PASS**; macOS Debug build oraz
  `git diff --check` PASS. Widgetów/goldenów nie uruchamiano.
- Bez zmian API/backendu/OpenAPI/enumów/schematu. Następny krok: ręczny runtime
  po uzyskaniu widocznej, zalogowanej rozmowy.

### CHAT-R70 — kolory akcji Chat i kontrola tworzenia grupy (2026-09-23)

Zmiana w `lib/foundation/theme/chat_theme.dart` rozdziela kolor tekstowych
akcji (`actionText`) od koloru odnośników (`linkText`): akcje w dialogach są
zielone w obu trybach, a linki w wiadomościach zachowują własny kolor. Test
`chat_theme_test.dart` sprawdza kolory obu trybów i theme kontrolek.

Ręcznie obejrzano świeży macOS build: nowy chat, kreator grupy, wyszukanie i
zaznaczenie `Michał Dąbrowski` (`demo.user08`). Wybranie go do grupy nie
wyświetla już notki o istniejącym DM; flow anulowano bez zapisu. Testy motywu,
kreatora i wyszukiwania/members **38/38 PASS**; pełny `flutter analyze --no-pub`,
build macOS Debug i `git diff --check` PASS. Instancję zamknięto; `ps` nie
wykazał działającego DevPlanner. Nie uruchamiano widget/golden tests ani nie
otwierano rozmowy, która zmieniłaby unread.

Backend: brak zmian API/schematu w tym pakiecie. Staging `/health/ready` = 200,
ale `/` = 500; read-only SSH wykazał brak `/srv/devplanner/frontend/current`.
Pozostają otwarte dwu-sesyjne realtime i wdrożenie statycznego Frontu.

### CHAT-R71 — dolne zakotwiczenie tapety (2026-09-23)

W `lib/app/shell/devplanner_shell_layout.dart` `DecorationImage` używa
`alignment: Alignment.bottomCenter` razem z `BoxFit.cover`. Normalne proporcje
nie zmieniają kadru; przy pionowym cropie związanym z bardzo szerokim oknem
widoczny pozostaje dół tapety. `flutter analyze --no-pub` oraz świeży macOS
Debug build PASS; `dart format` i `git diff --check` PASS. Próba resize przez
CUA nie zmieniła geometrii okna, więc nie potwierdzono wizualnie zgłoszonego
przypadku na małym/ultra-wide oknie. Widget/golden testów nie uruchamiano.
Testową instancję zamknięto.

### CHAT-R72 — testy kompozycji Storage i lifecycle załączników (2026-09-23)

Przegląd statyczny potwierdził: session/ticket/finalize/download idą przez
transport sesyjny i ACL Storage; binarny upload idzie osobnym `UploadTransport`
na krótkotrwały URL. Web nie przekazuje do tego klienta cookie ani Bearera.
UI fail-closed ukrywa akcje bez dostępnych portów.

Wyniki: testy upload queue, upload Cubita, selekcji, composera/koordynatora,
decyzji długiego wklejenia, drop adaptera, portów upload/download i Storage
composition **50/50 PASS**. Brak testów widgetowych/golden zgodnie z dyspozycją.
Rzeczywisty upload/download w zalogowanej rozmowie pozostaje niezweryfikowany;
nie wykonano stagingowej mutacji ani nie otwierano rozmowy z unread.

### CHAT-R73 — dopasowanie kreatora nowego czatu do wzorca (2026-09-23)

- Runtime macOS pokazał szeroki popover „Nowy czat” oraz ogólny tytuł
  „Nowa rozmowa” również w kroku tworzenia grupy. Zmniejszono limit szerokości
  popovera z 420 do 320 px, dialogu kreatora z 520 do 440 px i dopasowano
  nagłówek do grupy/kanału/ogłoszenia.
- Weryfikacja: `dart format`, `flutter analyze --no-pub` oraz build macOS Debug
  z `--dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl`
  PASS. Wcześniejszy build bez `--dart-define` pokazał ekran logowania, więc nie
  jest traktowany jako dowód integracji ze stagingiem.
- Po poprawnym buildzie workspace się otworzył, ale CUA zgłosiło zmianę stanu
  aplikacji przez użytkownika przed ręcznym sprawdzeniem nowych wymiarów i
  tytułu. Nie otwierano rozmów ani nie zmieniano danych. Widget/golden tests
  odroczone zgodnie z dyspozycją.
- Nadal otwarte: staging Front HTTP 500 (brak katalogu
  `/srv/devplanner/frontend/current`), dwu-sesyjne SignalR i runtime QA
  załączników.

### macOS — minimalny i startowy rozmiar okna (2026-09-23)

Front: `macos/Runner/MainFlutterWindow.swift` ustawia minimalny i początkowy
rozmiar okna na 1280×720 punktów oraz centruje okno. To natywna zmiana okna,
bez wpływu na backend/API. Build i ręczny resize do weryfikacji.

Weryfikacja po zmianie okna: `git diff --check` PASS. `flutter analyze --no-pub`
FAIL na istniejących zmianach Chat: brak getterów `chatMentionUnknownMember` w
`chat_message_composer.dart` i `chat_mention_suggestions.dart` oraz nieużywany
import w `chat_conversation_cubit.dart`. `flutter build macos --debug` FAIL na
tych samych zmianach, dodatkowo `ChatMentionReference` jest nierozpoznany w
`chat_pending_send_store.dart`. Ostrzeżenia SPM istniejących pluginów
`media_kit`. Nie zmieniano tych plików. Ręczny resize nie był sprawdzany.

### CHAT-R74 — reguła wielkości widgetów i dokumentacja po polsku (2026-09-23)

Przegląd wykazał, że `chat_message_composer.dart` ma 1149 linii i łączy
odpowiedzialności edycji, wzmianek, wklejania/TXT, załączników, emoji,
klawiatury oraz prezentacji. Doprecyzowano `AGENTS.md`: 400 linii to twardy
limit ręcznie utrzymywanego pliku/klasy produkcyjnej, typowy widget powinien
zwykle pozostać poniżej 300, a przenoszenie całej klasy do `part`/mixina nie
spełnia celu. Dokumentacja, wytyczne i komentarze architektoniczne repozytorium
mają być po polsku; tekst interfejsu pozostaje w ARB.

Do `docs/global-chat-repair-plan-2026-09-23.md` dodano C24 jako osobny pakiet
refaktoryzacji composera po ustabilizowaniu aktualnych napraw Quill i wysyłki.
W tej zmianie nie modyfikowano kodu composera ani nie uruchamiano testów.
Weryfikacja dokumentacji: sprawdzono liczbę linii (`1149`), `git diff --check`.
Następny krok: dokończyć bieżące poprawki funkcjonalne, potem wydzielić
odpowiedzialności composera do klas/plików poniżej limitu i zweryfikować jeden
większy pakiet analizą oraz uzgodnioną bramką.

### CHAT-R75 — staging odrzuca Delta z atrybutem zagnieżdżonym (2026-09-23)

Użytkownik dostarczył pięć powtarzalnych odpowiedzi `400 validation.failed`
dla `POST /api/v1/chat/conversations/{id}/messages`. Backend zwraca:
„Wartość atrybutu Delta wiadomości Chat musi być wartością prostą JSON.”
Trace ID: `0HNOPHJ6073M9:00000001` oraz `0HNOPHJ6073MA:00000001`–
`0HNOPHJ6073MD:00000001`.

Statyczny walidator w `../Backend/Domain/Entities/ChatMessage.cs` odrzuca
wartość dowolnego `attributes.*`, jeśli jest obiektem lub tablicą. Inspekcja
formatowania Quill ujawniła konkretną przyczynę: `ChatLineFormatCommands`
zapisywał `attributes.list` jako tablicę `['bullet']`/`['ordered']`, podczas gdy
backend i renderer `ChatRichTextCodec` oczekują prostego tekstu. Zmieniono
formatowanie i rozpoznawanie aktywnej listy na wartościach `'bullet'`/`'ordered'`;
toolbar przekazuje do Quill jego skalarne atrybuty `ul`/`ol`. Przejrzano
pozostałe operacje formatowania w composerze — ustawiają boolean/string albo
skalarne atrybuty kodu. `dart analyze` komend, toolbaru i renderera PASS;
`git diff --check` PASS. Test `chat_format_commands_test.dart` **12/12 PASS**,
obejmuje typ skalarny `list` i odrzucenie starej tablicy. Zmiana nie wymaga
backendu ani nowego formatu API. Wysłanie i odczyt listy na stagingu pozostają
do sprawdzenia.

### CHAT-R76 — style edytora Quill zgodne z ChatTheme (2026-09-23)

Użytkownik zgłasza brak widocznego pogrubienia i oznaczeń list oraz pyta o
kolory/czcionki. Statycznie `ChatComposerRichTextField` używał domyślnych styli
Quill z `ThemeData`, bez `customStyles` Chat. Dodano jawne style Chat dla
akapitu, list, cytatu, kodu, linku i pogrubienia; renderer historii zwiększa
wagę bold z `w600` do `w700`. Znaczniki list w historii są renderowane przez
`ChatRichTextCodec`; ich atrybut Delta naprawiono w CHAT-R75.

Weryfikacja: `dart format` i `dart analyze` plików rich field, renderer,
toolbaru i mapowania komend PASS. Test jednostkowy mapowania formatów **12/12
PASS** (bez testów widgetowych/golden); brak runtime potwierdzenia widoczności.
Backend dopuszcza `color`, `background`,
`font`, `size`, ale toolbar i renderer Front nie obsługują tych formatów —
zakres do jawnego zaprojektowania bez obietnicy utraty formatowania po wysłaniu.

### CHAT-R77 — ponowny raport widoczności formatowania i realtime odczytu (2026-09-23)

Użytkownik zgłasza ponownie, że pogrubienie i markery list `123.`/kropek nie są
widoczne w zaawansowanym edytorze. Zapisano to jako C27: style C26 są zmianą
statyczną, bez odbioru runtime; baza czcionki ma 14 px i nie deklaruje rodziny,
a UI nie ma wyboru fontu, rozmiaru ani koloru. Do odtworzenia są oba motywy,
stan edycji/aktywnego formatowania, listy wielocyfrowe i treść po ponownym
otwarciu. Nie deklarować naprawy po samym analizatorze; testy widgetowe i golden
pozostają wstrzymane do akceptacji UI.

Równolegle dodano mapowanie istniejących backendowych eventów
`chat.message.read`/`chat.message.delivered`: reducer zwraca decyzję odświeżenia
statusu, a Cubit pobiera autorytatywne liczniki konkretnej wiadomości przez
istniejące okno historii, również dla starej wiadomości. Nie wyliczamy liczby
odbiorców lokalnie. Dodano testy mappera i reducera: **14/14 PASS**. `dart analyze` dotkniętych
eventów, reducera, mappera, Cubita i testów oraz `git diff --check` PASS.
Odbiór na dwóch kontach pozostaje otwarty.


### CHAT-R78 — pełny audyt formatów Quill i zgodność Delta (2026-09-23)

Log stagingowy z trace `0HNOPHJ607482:00000001` i `0HNOPHJ607483:00000001`
pokazał POST odrzucony 400: `attributes.code` nie jest dozwolony. Audyt bieżącego
paska Quill porównał formaty inline `bold`, `italic`, `strike`, `code`, `link`
oraz liniowe `list` (`bullet`/`ordered`), `blockquote` i `code-block` z walidacją
`ChatMessage.AllowedDeltaAttributes`, `ChatMentionParser` i `ChatRichTextCodec`.
Jedyną brakującą nazwą transportową było `code`: Quill `Attribute.inlineCode`
zapisuje właśnie ten klucz, a parser backendowy już go rozpoznawał. Dodano `code`
do allowlisty oraz test regresyjny `QuillDeltaAllowsInlineCodeProducedByFlutterQuill`.

Zgłoszony wygląd: listy użytkownik widzi, bold nadal jest nieczytelny, cytat jest
niewidoczny. Wzmocniono bold do `w900` w edytorze i historii; cytat dostał
widoczne tło, padding i akcent `ChatTheme.focusRing` w obu miejscach. Test Front
parsera rozszerzono o jednoczesne bold, inline code i cytat.

Weryfikacja: Backend restore/build PASS (0 ostrzeżeń), pełna suite **1307 PASS /
4 SKIP / 0 FAIL**, pełny `dotnet format --verify-no-changes` PASS oraz diff check
PASS. Skrypt SQL migracji nie został wygenerowany: zmiana nie dotyczy schematu, a
repo nie ma ustawionego `ConnectionStrings:Workspaces`; EF wymaga także osobnego
wyboru jednego z dwóch contextów. Front parsera, code block i mapowania formatów
**25/25 PASS**, `dart analyze` dotkniętych plików i diff check PASS. Bez testów
widgetowych/golden. Commit `446116a45b387db64f8affcc56a679c0013622b2` wdrożono
ręcznym skryptem stagingowym. Po deployu API healthy, readiness `ready`,
publiczny `/health/ready` zwrócił `Healthy`; migrator potwierdził aktualność
schematu. Nie wysłano sztucznej wiadomości do cudzej rozmowy. Odbiór wyglądu
Quilla pozostaje otwarty.

### STORAGE-IMAGE-PREVIEW — autoryzowany podgląd obrazów (2026-09-23)

Przyczyną niedziałającego podglądu PNG był chroniony endpoint
`/api/v1/storage/files/{id}/stream?inline=true`: dotychczasowy `Image.network`
wywoływał go bez uwierzytelnienia. Niezalogowane żądanie na stagingu zwracało
302 do logowania. Metadane stagingowej `makieta.png` (rozmiar i SHA-256)
odpowiadały poprawnemu PNG seedera; zgodność faktycznych bajtów w storage
pozostaje do sprawdzenia przez autoryzowany odczyt.

Zmienione pliki Front: `storage_repository.dart`, `storage_repository_impl.dart`,
`storage_preview_cubit.dart`, `storage_preview_state.dart` i
`storage_preview_dialog.dart`. Bieżące obrazy i wersje są pobierane przez
istniejący autoryzowany Storage API (`streamFile`/`streamFileVersion`), a
widok używa `Image.memory`. Zachowano obsługę błędu pobrania i dekodowania.
Backend, endpointy, enumy transportowe, OpenAPI i schemat bez zmian.

`dart format` PASS; `flutter analyze --no-pub` dla zmienionych plików PASS;
`git diff --check` PASS. Pełne `flutter analyze --no-pub` zwróciło jedno
niezwiązane ostrzeżenie `unawaited_return_in_try_block` w
`chat_message_secondary_actions_cubit.dart:194`. Nie dodawano ani nie
uruchamiano testów. Frontu nie opublikowano. Następny krok: odbiór bieżącej i
historycznej PNG w działającej aplikacji po publikacji Frontu, a w razie
błędu sprawdzenie faktycznych bajtów MinIO.

### STORAGE-ONLYOFFICE-READY — lifecycle CSV/TXT (2026-09-23)

Po zgłoszeniu timeoutu `metryki.csv` logi pokazały `apiLoaded`,
`editorCreated` i `onAppReady`, lecz brak `onDocumentReady`. Oficjalny
lifecycle ONLYOFFICE wskazuje, że CSV/TXT mogą wymagać wyboru kodowania lub
separatora przez użytkownika przed `onDocumentReady`. Poprzedni loader
zasłaniał ramkę do tego momentu, po czym po 30 s zastępował ją błędem.
Na ekranie aplikacji `notatki-prywatne.txt` otworzył się z treścią seedera;
użytkownik potwierdził również działanie poprawionego podglądu obrazu.

Front: `onlyoffice_editor_html_builder.dart` wysyła `appReady` i
`userActionRequired`; `storage_onlyoffice_controller.dart` przekazuje
zdarzenia i loguje bezpieczne etapy; `storage_onlyoffice_host.dart` odsłania
edytor po `onAppReady`, a gdy potrzebny jest wybór użytkownika, anuluje
timeout dokumentu. Jeśli dokument nadal nie jest gotowy po 30 s, pokazuje
nieblokujący komunikat na widocznej ramce. Sygnatura fake kontrolera w
`storage_onlyoffice_host_test.dart` została dopasowana do portu; nie dodano
ani nie uruchomiono testów. Backend i kontrakt API bez zmian.

`dart format`, analiza zmienionych plików i `git diff --check`: PASS.
`flutter build macos --debug --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl`
PASS po dopisaniu `onUserActionRequired`; ręczny odbiór CSV pozostaje do
potwierdzenia. Logowany wcześniej `iframeAttached=false` wynikał z
niepoprawnego selektora hosta i został usunięty; `onAppReady` potwierdza
uruchomienie ramki. Nie potwierdzono jeszcze zapisania edycji CSV.


### CHAT-R79 — pin/unpin sygnalizuje wyłącznie sukces API (2026-09-23)

`ChatMessageActionMenu._handle` wywoływał `onPinnedChanged` po `togglePin`, mimo
że Cubit zwracał `Future<void>` i przechowywał błąd wyłącznie w stanie. Zmieniono
`togglePin` na wynik `succeeded/failed/ignored`; menu odpala callback wyłącznie
po `succeeded`. Wspólny `_run` Cubita sprząta pending w `finally`, żeby błąd
wyjątkowy nie zablokował kolejnej próby.

Weryfikacja: `chat_message_secondary_actions_test.dart` **8/8 PASS** (success,
API forbidden, duplicate podczas requestu i istniejące akcje), `dart analyze`
dotkniętych plików PASS, `git diff --check` PASS. Widgetów/goldenów nie
uruchamiano. Zmiana tylko w Front; runtime callbacku po stagingu pozostaje do
odbioru.

### CHAT-R80 — monotoniczny odczyt wiadomości (2026-09-23)

Test `chat_conversation_read_visibility_test.dart` reprodukował błąd: Cubit
wysyłał mark-read dla własnej wiadomości mimo że odczyt powinien dotyczyć
wiadomości drugiej osoby. Dodano jawne pominięcie autora bieżącej sesji.
Dodatkowo deduplikacja lokalnego kursora porównuje wiadomości według
`(CreatedAtUtc, Id)`, tak jak backend; spóźniony callback widoczności starszej
wiadomości nie cofa już kursora ani nie wysyła zbędnego mark-read.

Zmienione pliki: `chat_conversation_cubit.dart`,
`chat_conversation_read_visibility_test.dart`, plan napraw Chat i ten handoff.
Weryfikacja: test widoczności **6/6 PASS**, `dart analyze` obu zmienionych plików
PASS, `git diff --check` PASS. Bez widget/golden tests. Nie zmieniano Backend,
API, OpenAPI ani enumów; nie wdrażano. Pozostaje runtime odbiór na dwóch sesjach.

### CHAT-R81 — brak przebudowy całego composera przy każdym znaku (2026-09-23)

Quill `onRichTextChanged` emituje nowy draft dla każdego znaku. Bez `buildWhen`
`BlocBuilder` przebudowywał całe drzewo composera na każdą zmianę Delta, łącznie
z aktywnym edytorem i toolbarami. Dodano `ChatComposerState.shouldRebuildComparedTo`
i podłączono go do buildera. Tekst/Delta nadal zapisują się na bieżąco w Cubicie,
ale rodzic przebudowuje się tylko przy zmianie trybu, pustego/niepustego draftu,
reply, załączników lub wzmiankowanych osób.

Zmienione pliki: `chat_composer_state.dart`, `chat_message_composer.dart`,
`chat_composer_state_test.dart`, plan napraw Chat i ten handoff. Weryfikacja:
`chat_composer_state_test.dart` **2/2 PASS**, `dart analyze` dotkniętych plików
PASS, `git diff --check` PASS. Bez testów widgetowych/golden i bez uruchamiania
aplikacji; odbiór IME oraz live typing pozostaje otwarty.

### CHAT-R82 — automatyczna zamiana długiego wklejenia na TXT (2026-09-23)

`_handlePaste` po rozpoznaniu długiej treści tylko otwierał kartę i oczekiwał
ręcznego kliknięcia. Po przekroczeniu progu polityki automatycznie uruchamia teraz
`_sendPendingPasteAsFile`; treść trafia do szkicu jako oryginalny plik TXT,
bez publikowania wiadomości przed kliknięciem Wyślij. Gdy brak
`ChatSnippetRepository` albo przygotowanie nie zwróci treści, klient przechodzi
na upload pełnego oryginału przez Storage. Przy błędzie uploadu wyjątek czyści stan busy, a karta zachowuje
tekst do retry lub zachowania jako treści wiadomości.

Zmieniony plik Front: `chat_message_composer.dart`; aktualizacja planu i handoff.
Weryfikacja: `chat_long_paste_decision_test.dart` **9/9 PASS**, `dart analyze`
dotkniętego zakresu PASS, `git diff --check` PASS. Testów widgetowych nie
uruchamiano; pełne przechwycenie clipboard w runtime desktop/mobile pozostaje
do odbioru. Nie zmieniano Backend/API/OpenAPI ani enumów.

### STORAGE-ONLYOFFICE-ACTIONS — porządkowanie zapisu, kopii i druku (2026-09-23)

Zmieniono `storage_office_editor_actions_cubit.dart`,
`storage_office_editor_view.dart`, `storage_onlyoffice_controller.dart`,
`storage_office_close_confirmation.dart`, `onlyoffice_editor_html_builder.dart`
oraz dostosowano istniejące oczekiwanie testu buildera do ukrytej akcji
`Save Copy as`. Eksporty są pojedyncze, a odpowiedź po timeoutcie nie może
zostać przypisana kolejnemu żądaniu. Jeden krzyżyk zostaje w pasku aplikacji;
status zapisu i postęp operacji są stale widoczne. Zamknięcie podczas eksportu
jest zablokowane, a stan niepotwierdzonego zapisu wymaga decyzji. Główna ramka
WebView nie może przejść do strony z logo. Backend ukrywa pluginy, pomoc,
wewnętrzny druk i krzyżyk oraz nie włącza wewnętrznego „Save Copy as”.
Samo logo może pozostać widoczne w Community Edition, która nie gwarantuje
obsługi opcji brandingu; kliknięcie nie przenosi głównej ramki na obcą stronę.
Po potwierdzeniu nowszej wersji Backend Front pokazuje trwały pasek „Zapisano”
i jednorazowy komunikat; brak potwierdzenia daje ostrzeżenie.
Publiczny kontrakt API, enumy i schemat bez zmian. Następny krok: ręczny odbiór
na stagingu zapisu nowej wersji, kopii i druku; bez niego trwałość pozostaje
niepotwierdzona.

### CHAT-R83 — bezpieczne przekazanie własności i opuszczenie (2026-09-23)

Backend `ChatService.UpdateMemberRoleAsync` już transakcyjnie obsługuje
przekazanie roli Owner: wybrany członek staje się Ownerem, dotychczasowy Owner
zostaje Moderatorem. Front wcześniej ukrywał rolę Owner w menu członka i
pozwalał jedynemu Ownerowi wysłać leave, po czym pokazywał tylko ogólny błąd.
Dodano opcję „Przekaż własność”, wykrywanie jedynego Ownera, blokadę leave z
wyjaśnieniem po polsku/angielsku i kontekstową wiadomość przy błędzie wyścigu.
Po potwierdzonym opuszczeniu panel wraca do inboxa i odświeża skrzynkę oraz
licznik unread, co zwalnia lease realtime odmontowanej rozmowy.

Zmienione pliki Front: `chat_members_cubit.dart`, `chat_members_sheet.dart`,
`chat_panel_conversation.dart`, `app_pl.arb`, `app_en.arb` i wygenerowane
lokalizacje; test `g5_search_and_members_test.dart`; plan napraw i handoff.
Weryfikacja: `flutter gen-l10n`, suite search/members **15/15 PASS**,
`dart analyze` zakresu PASS, `git diff --check` PASS. Bez testów widgetowych,
bez zmian Backend/API/OpenAPI/enumów i bez deployu. Pozostaje ręczny scenariusz
Owner → transfer → leave i potwierdzenie w drugiej sesji.
