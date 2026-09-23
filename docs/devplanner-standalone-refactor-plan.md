# DevPlanner standalone — zaakceptowany stan refaktoryzacji

## Bieżący status Chat — 2026-09-23

Ten blok jest aktualnym indeksem stanu. Dalsze wpisy datowane niżej są
dziennikami prac: ich niezaznaczone pola opisują stan z dnia danego wpisu i nie
oznaczają automatycznie bieżących braków. Przed rozpoczęciem pracy w Chat
porównaj kod i najnowszy handoff.

- **W kodzie:** globalny panel i sekcje inboxa; tworzenie DM/grup/kanałów/
  ogłoszeń; wyszukiwanie i dodawanie członków; role/statusy; reakcje, menu
  wiadomości, wątki, wyszukiwanie wiadomości, szkice, wzmianki, rich text/Quill,
  emoji, linki oraz przepływ uploadu załączników. To nie jest równoznaczne z
  akceptacją wizualną całej aplikacji.
- **Ostatnio zweryfikowane bramki Front:** po CHAT-R71 `flutter analyze
  --no-pub`, testy constraints/adaptera dropu/koordynatora/uploadu **20/20**,
  Web/Wasm build, macOS Debug build i `git diff --check` PASS. To nie jest pełny
  przebieg całej suite.
- **Otwarte:** ręczny przegląd aktywnej rozmowy w zalogowanej sesji; rzeczywisty
  drop/upload/pobranie i clipboard; limity, revoke/ACL oraz cleanup sesji; test
  realtime na dwóch sesjach. Ostatnia próba runtime przechwyciła okno Codex
  zamiast DevPlanner, więc nie stanowi dowodu odbioru UI ani dropu.
- **Ponowna kontrola 2026-09-23:** `flutter analyze --no-pub` PASS; statyczny
  przegląd composera, formatowania, tworzenia rozmów i członków nie wykrył
  nowego błędu. CUA potwierdziło blokadę macOS, więc kolejna kontrola GUI nie
  była możliwa.
- **Odroczone na życzenie użytkownika:** testy widgetowe i golden do czasu
  akceptacji wyglądu. Nie uruchamiać ich wcześniej.
- **Zakres UI:** utrzymać dedykowany `ChatTheme` i wzorce kompozycji/menu aplikacji;
  sekcje Pliki i Zadania/Kanban pozostają przygotowane pod przyszłą integrację,
  bez udawania, że źródłowe konwersacje już są podłączone.

## 2026-09-23 — CHAT-R71: preflight systemowego pickera Web

- [x] Webowy `FilePickerPortImpl` nie wczytuje już bajtów wybranych plików,
  które przekraczają limit pliku, łączny budżet lub liczbę slotów Chat.
- [x] Dodano kompatybilny `ConstrainedFilePickerPort`; Chat przekazuje do niego
  budżet już wybranej selekcji. Istniejące użycia Storage nadal wołają bazowy
  port bez ograniczeń.
- [x] Polityka ograniczeń jest współdzielona z drag/drop, więc obie ścieżki
  identycznie rozstrzygają pozostałe sloty i łączny rozmiar.
- [x] Testy constraints/adaptera/koordynatora/uploadu **20/20 PASS**; pełny
  `flutter analyze --no-pub`, `flutter build web --wasm`, macOS Debug build i
  `git diff --check` PASS. Build zgłosił wyłącznie istniejące ostrzeżenie SPM
  `media_kit` oraz standardowy notice dla WebAssembly.
- [ ] Rzeczywisty wybór/upload Web i runtime w zalogowanej rozmowie nadal
  wymagają smoke testu. Widget/golden testy pozostają odroczone.
- [x] Bez zmian HTTP/API/OpenAPI/backendu/enumów transportowych/schematu.

## 2026-09-23 — CHAT-R70: walidacja rozmiarów przed odczytem bajtów dropu

- [x] Adapter dropu najpierw pobiera wyłącznie rozmiary. Treść wczytuje tylko
  dla plików mieszczących się w limicie per-file, pozostałym budżecie wiadomości
  i wolnych slotach selekcji; uwzględnia już wybrane pliki. Odrzucone pozycje
  zachowują nazwę/rozmiar, ale nie alokują bajtów.
- [x] Pasek załączników pokazuje osobny lokalizowany powód odrzucenia: za dużo
  plików, za duży pojedynczy plik albo przekroczony łączny rozmiar.
- [x] Testy adaptera (normalny plik, ponad limit pliku, budżet łączny i sloty)
  **4/4 PASS**; wspólny pakiet z koordynatorem i adapterem Storage **17/17**;
  `flutter analyze --no-pub`, macOS Debug build i `git diff --check` PASS.
- [ ] Ręczny upload w zalogowanej rozmowie nadal otwarty; bez widget/golden testów.
- [x] Bez zmian Backend/API/OpenAPI/enumów/schematu.

## 2026-09-23 — CHAT-R69: wyłącz niedostępny wybór załączników

- [x] Pozycje zdjęcia/pliku w menu `+` są aktywne tylko wtedy, gdy dostępne są
  zarówno file picker, jak i koordynator uploadu. Wcześniej sam picker
  odblokowywał wybór, a po jego zakończeniu brak koordynatora po cichu porzucał
  pliki.
- [x] Gdy integracja jest niepełna, menu pokazuje lokalizowane wyjaśnienie.
- [x] `flutter gen-l10n`, pełne `flutter analyze --no-pub`, zestaw testów
  załączników/kompozytora **28/28**, macOS Debug build i `git diff --check`
  PASS.
- [ ] Ręczny runtime i widget/golden testy pozostają otwarte/odroczone jak w
  bieżącym statusie wyżej.

## 2026-09-23 — CHAT-R68: strefa drag-and-drop załączników w composerze

- [x] `DropTarget` obejmuje niezwijany composer, więc ma niezerowy hit-target
  również przed wybraniem pierwszego pliku. Wcześniej znajdował się w pasku,
  który zwracał `SizedBox.shrink()` przy pustej kolejce.
- [x] Podczas przeciągania wyświetla się nakładka z lokalizowanym komunikatem;
  drop nadal trafia do istniejącego koordynatora uploadu/skanowania. Zablokowana
  kolejka oczekująca na potwierdzenie nie przyjmuje następnych plików. Błąd
  odczytu bajtów przy dropie ma lokalizowany komunikat błędu zamiast
  nieobsłużonego wyjątku.
- [x] Testy koordynatora i adaptera uploadu **13/13 PASS**, `flutter analyze
  --no-pub` oraz macOS Debug build PASS; `git diff --check` PASS.
- [ ] Ręczny drop na działającej, zalogowanej rozmowie pozostaje do smoke testu.
  Otworzono i zamknięto jedną instancję; nie testowano interakcji w rozmowie.
  Testów widgetowych/golden nie uruchamiano zgodnie z decyzją użytkownika.
- [x] Backend/API/OpenAPI/enumy/schemat bez zmian; staging/deploy niepotrzebne.

## 2026-09-23 — CHAT-R46 Front: pełna liczba osób w nagłówku grupy

- [x] Nagłówek używa serwerowego `participantCount`, a nie rozmiaru skróconej
  listy `participants` (backend ogranicza podgląd inboxa do czterech profili).
  Runtime pokazał wcześniej 4 w nagłówku przy 9 osobach w panelu członków;
  świeży build pokazuje zgodne „9 uczestników”.
- [x] Test repozytorium: dwa profile w podglądzie nie ograniczają liczby
  całkowitej (9); test inboxa **10/10 PASS**, `flutter analyze`, macOS Debug
  build i oba `git diff --check` PASS.
- [ ] Nie uruchamiano widgetów/goldenów; odbiór całości UI nadal OPEN.
- [x] Backend/API bez zmian.

## 2026-09-23 — ENUM-AUDIT Front: wartości enumów zgodne z backendem

- [x] Audyt wszystkich 80 wygenerowanych map enumów JSON w Front względem
  publicznych enumów backendu wykrył błędne lowercase mapowanie
  `ChatNotificationPreference` (`all` zamiast `All`), trzech enumów AI
  (`AiProviderKind`, `AiProviderStatus`, `AiOperationStatus`) i 26 dalszych
  map o niezgodnym casing. Zmieniono mapowanie wejścia/wyjścia na PascalCase.
- [x] `NotificationEmailDeliveryMode.Digest` pozostaje jawnie wspieranym
  aliasem backendu dla `DailyDigest`; osobny `@JsonValue('Digest')` zachowuje
  dekodowanie obu przewodowych nazw.
- [x] Dodano testy dekodowania/serializacji odpowiedzi i requestów Chat,
  powiadomień oraz DTO AI. W `AGENTS.md` Front i Backend dodano obowiązkowy
  audyt wartości wire, serializerów, OpenAPI, aliasów i nazw różniących się
  między klientem i serwerem przy każdej zmianie enuma.
- [x] `build_runner` PASS; testy kontraktu powiadomień i AI **12/12 PASS**;
  `flutter analyze` i `git diff --check` Front PASS. Nie uruchamiano widgetów
  ani goldenów. Odczyt OpenAPI staging zwraca HTTP 500, dlatego porównanie
  oparto na 80 wygenerowanych mapach JSON i źródłowym serializerze backendu.
- [x] Backend/API/schemat bez zmian; deploy nie jest potrzebny.

## 2026-09-23 — CHAT-R45: nie nadpisuj oczekującego wklejenia

- [x] Komendy Paste i „Tekst jako plik” nie mogą nadpisać tekstu ani lokalnego
  ID załącznika, gdy trwa odczyt schowka, istnieje karta decyzji albo trwa
  przygotowanie TXT. Zapobiega to skojarzeniu nowej treści ze starym plikiem.
- [x] `flutter analyze`, pięć zestawów testów jednostkowych (w tym limity
  wklejenia, wysokość composera, formatowanie, layout menu, empty state i
  trwałość szkicu; **37 asercji/testów zaliczonych**) oraz macOS Debug build
  PASS. `git diff --check` PASS.
- [ ] Zalogowany runtime pozostaje do odbioru; widgety/goldeny bez zmian.


## 2026-09-23 — CHAT-R44: zielony akcent aktywnych elementów czatu

- [x] Aktywna ikona raila, aktywny filtr inboxa, zaznaczona kategoria emoji,
  zaznaczone narzędzie formatowania i wybory uczestników korzystają z
  `chat.focusRing` (zieleń ChatTheme), a `chat.linkText` pozostaje kolorem
  zwykłych odnośników.
- [x] `flutter analyze` i `git diff --check` PASS.
- [ ] Runtime po zalogowaniu i macOS Debug build do kolejnego odbioru; widgety/
  goldeny pozostają odroczone do akceptacji wyglądu.


## 2026-09-23 — CHAT-R43: empty state zgodny z filtrem skrzynki

- [x] Pusta skrzynka opisuje wybrany filtr: nieprzeczytane, DM, grupy, kanały,
  wzmianki lub archiwum; komunikat o aktywnych rozmowach zostaje tylko dla
  filtra Wszystkie. PL/EN pochodzą z ARB.
- [x] Błąd potwierdzono na działającym macOS: Archiwum wyświetlało tekst
  „Twoje aktywne rozmowy pojawią się tutaj”. Mapper ma test jednostkowy
  **2/2 PASS**; `flutter gen-l10n`, `flutter analyze`, macOS Debug build i
  `git diff --check` PASS.
- [ ] Po restarcie świeżego buildu aplikacja pokazała błąd logowania, a przycisk
  otworzył zewnętrzny provider logowania. Nie wpisano danych; poprawionego
  empty state nie udało się powtórnie obejrzeć. Widgety/goldeny odroczone.

## 2026-09-23 — CHAT-R42: ponowny odbiór działającego UI i tapety

- [x] Obejrzano działający shell na macOS; aktywny renderer tapety to
  `assets/images/bg.jpeg` z `BoxFit.cover` w
  `lib/app/shell/devplanner_shell_layout.dart`. Poprzednia notatka o braku
  renderera była błędna.
- [x] Panel Chat udało się zobaczyć w sekcji Archiwum; screenshot potwierdza
  trzy kolumny w tym stanie. Nie jest to odbiór aktywnej rozmowy ani pełnych
  interakcji: sterowanie natywnym oknem zwracało `noWindowsAvailable`.
- [ ] Nie odtworzono zgłoszenia z małym obrazem i tapetą uciętą od dołu;
  potrzebna stabilna sesja oraz wskazanie ekranu/reprodukcja. Widgety/goldeny
  pozostają odroczone do akceptacji wyglądu.
- [x] Pakiet obejmował przegląd dokumentacji i ręczną obserwację; bez zmian
  kodu, backendu ani deployu.

## 2026-09-23 — CHAT-R28: czytelny tooltip przycisku członków

- [x] Nagłówek używa osobnej lokalizacji „Członkowie i dodawanie osób”; menu
  akcji konkretnego uczestnika zachowuje „Akcje członka”.
- [x] `flutter gen-l10n`, `flutter analyze` i macOS Debug build PASS.
- [ ] Tooltip pozostaje do obejrzenia w działającym panelu po odblokowaniu Maca.

## 2026-09-23 — CHAT-R27: lokalne wygaśnięcie statusu rozmówcy

- [x] Gdy mija `expiresAtUtc`, etykieta jest usuwana lokalnie natychmiast,
  niezależnie od wyniku ponownego żądania REST; nadal odświeżamy stan z API.
- [x] Adaptery/status modelu **16/16 PASS**, `flutter analyze` i macOS Debug
  build PASS.
- [ ] Widgetowy timer i render pozostają nieuruchomione/nieobejrzane zgodnie
  z odroczeniem widgetów i blokadą Maca.

## 2026-09-23 — CHAT-R26: większy przycisk reakcji na dymku

- [x] Cel dotykowy szybkiej reakcji zwiększono z 28×28 do 36×36 px, a ikonę
  z 16 do 18 px; układ reszty menu kontekstowego pozostaje bez zmian.
- [x] `flutter analyze`, macOS Debug build i `git diff --check` PASS.
- [ ] Rzeczywisty wygląd hover/touch do sprawdzenia po odblokowaniu Maca.

## 2026-09-23 — CHAT-R25: imię rozmówcy w wskaźniku pisania DM

- [x] Wskaźnik pisania dostaje osobną mapę etykiet: dla DM używa rozmówcy z
  inboxa, a dymki DM nadal nie renderują niepotrzebnego prefiksu autora.
- [x] Test polityki etykiet **7/7 PASS**, `flutter analyze` i macOS Debug build
  PASS; `git diff --check` po aktualizacji dokumentacji.
- [ ] Render w rzeczywistym DM do potwierdzenia po odblokowaniu Maca.

## 2026-09-23 — CHAT-R24: zgodność regresji panelu z nową szerokością

- [x] Zaktualizowano istniejące oczekiwania testu overlayu: domyślne 75%,
  modalność poniżej 960 px, szerokość bez uchwytu na modalnym panelu i dłuższy
  gest zwijania przy większym panelu.
- [x] `flutter analyze` oraz `git diff --check` PASS.
- [ ] Widget test pozostaje **nieuruchomiony** zgodnie z decyzją użytkownika;
  wymaga późniejszego uruchomienia po akceptacji wyglądu.

## 2026-09-23 — CHAT-R23: wygaśnięcie statusu rozmówcy

- [x] Etykieta rozmówcy po odczycie statusu planuje odświeżenie na `expiresAt`;
  wygasły status jest od razu ukrywany, a timer jest anulowany przy zmianie
  rozmówcy i dispose.
- [x] Testy adaptera/statusów **21/21 + 5/5 PASS**, `flutter analyze` oraz
  macOS Debug build PASS. `git diff --check` uruchomione po aktualizacji.
- [ ] Potwierdzić zmianę etykiety po czasie w runtime na odblokowanym Macu.
  Nie uruchamiano testów widgetowych/goldenów.

## 2026-09-23 — CHAT-R22: statusy rozmówcy i akcja członków

- [x] Linia statusu DM uwzględnia DND; starsze żądanie statusu nie może
  nadpisać wyniku po przełączeniu rozmówcy ani po usunięciu widgetu.
- [x] Akcja członków w nagłówku jest widoczna tylko dla niebezpośrednich
  rozmów i gdy sesja udostępnia `ChatMembersRepository`.
- [x] `flutter analyze`, `flutter build macos --debug` i `git diff --check`
  PASS. Bez backend/API changes.
- [ ] Runtime UI statusu i członków pozostaje do obejrzenia na odblokowanym
  Macu. Testów widgetowych/goldenów nie uruchamiano.

## 2026-09-23 — CHAT-R21: pełny układ komunikatora po otwarciu

- [x] Domyślna szerokość panelu to 75% okna z minimum na trzy kolumny (plus
  uchwyt) i maksimum 1120 px. Na typowym desktopie rail, inbox i aktywna
  rozmowa są widoczne jednocześnie; panel przypięty nadal respektuje minimum
  480 px treści aplikacji.
- [x] Próg modalności wzrósł do 960 px; mniejsze okna używają pełnego overlayu.
- [x] Test geometrii `chat_panel_size_test.dart` **7/7 PASS**, `flutter
  analyze`, build macOS Debug i `git diff --check` PASS.
- [ ] Potwierdzić rzeczywisty render na odblokowanym Macu. Czysta analiza kodu
  i test geometrii nie są odbiorem wizualnym. Widgety/goldeny pozostają
  odroczone do akceptacji wyglądu.

## 2026-09-23 — CHAT-R20: upload załączników Chat w Web/BFF

- [x] Wspólny composition root przekazuje tę samą `StorageRepository` do
  routera i globalnego Chatu. Web używa BFF cookie/CSRF do ticketu i finalizacji;
  binarny PUT używa osobnego transportu i wyłącznie krótkotrwałego presigned URL.
- [x] Nie zmieniono Backend/API ani upload capabilities pionu Files. Akcje
  „plik TXT” są wyłączone, jeśli runtime nie ma kompletnego portu uploadu.
- [x] Testy kompozycji fail-closed i adaptera Chat **11/11 PASS**;
  `flutter analyze`, Web Debug build, macOS Debug build i `git diff --check`
  PASS. Stagingowy preflight CORS dla `PUT` z originu aplikacji zwraca 204.
- [ ] Rzeczywiste wysłanie pliku w zalogowanej przeglądarce wymaga jeszcze
  smoke testu; lokalny runtime pokazuje login BFF, a macOS jest zablokowany.

## 2026-09-23 — CHAT-R19: kontekst lokalnych akcji w menu wiadomości

- [x] Callbacki rootowego `AppContextMenu` wracają do kontekstu widgetu, który
  otworzył menu. Reakcje i kopiowanie zaznaczenia zachowują dostęp do lokalnych
  providerów/`Actions` rozmowy zamiast szukać ich w trasie overlayu.
- [x] `flutter analyze` PASS; `flutter run -d web-server` skompilował i
  uruchomił aplikację; `flutter build macos --debug` PASS. `git diff --check`
  PASS po aktualizacji dokumentacji.
- [ ] Render czatu i interakcje menu wymagają zalogowanej sesji. Przeglądarka
  pokazuje bezpieczne logowanie BFF, a natywny ekran macOS jest zablokowany.
  Widgety/goldeny pozostają odłożone do akceptacji wyglądu.

## 2026-09-23 — CHAT-R18: spójniejsze pola i stany focus

- [x] Pola wstawiania kodu, wyszukiwarki emoji, statusu, trybu powiadomień,
  dodawania linku i edycji wiadomości używają powierzchni/typografii ChatTheme,
  separatora i focus ringa. Blok kodu korzysta ze stylu monospace.
- [x] `flutter analyze` całego Frontu i macOS Debug build PASS.
- [ ] Odbiór renderu nadal otwarty; Mac jest zablokowany. Bez testów widgetowych
  i goldenów przed akceptacją wyglądu.

## 2026-09-23 — CHAT-R17: usunięcie starej listy i technicznych tytułów

- [x] Usunięto legacy drawer/cubit i jego dodatkowy odczyt rozmów. Brak portu
  skrzynki kończy się istniejącym jawnym stanem niedostępności; panel nie wraca
  do Material ListTile, `scopeKey` ani drugiego requestu listy.
- [x] Nagłówek bez nazwy kontaktu/rozmowy pokazuje lokalizowany neutralny tytuł,
  nie techniczny `scopeKey`. `flutter analyze` całego Frontu i macOS Debug build PASS.
- [ ] Ręczny odbiór wyglądu i interakcji pozostaje otwarty; Mac jest zablokowany.
  Widgetów/goldenów nie uruchamiano.

## 2026-09-23 — CHAT-R16: bezpieczna kolejność trwałych wysyłek

- [x] Front serializuje odczyty i modyfikacje rekordu secure storage per
  użytkownik. Opóźniony zapis nie może nadpisać późniejszego usunięcia
  potwierdzonej wiadomości ani czyszczenia przy wylogowaniu; restore czeka na
  zakończenie zapisu.
- [x] Regresja z kontrolowanym opóźnieniem keychaina oraz testy polityki kolejki:
  **9/9 PASS**; flutter analyze, flutter build macos --debug i
  git diff --check obu repozytoriów PASS. Bez zmian backendu/API.
- [ ] Ręczny odbiór działającego UI i przepływu na dwóch sesjach nadal otwarty;
  Mac jest zablokowany. Widgety/goldeny pozostają odłożone do akceptacji wyglądu.

## 2026-09-23 — CHAT-R14 follow-up: działające skoki z zapisanych wiadomości

- [x] Jawnie przekazano `ChatConversationRepository` przez panel do menu
  konwersacji. Skok z zakładki najpierw wybiera rozmowę ze skrzynki, a gdy
  brakuje jej na aktualnej stronie, pobiera ją przez ACL-owany `getConversation`.
- [x] Nagłówek przekazuje także port `messageActions`; menu przypiętych i
  zapisanych wiadomości nie pozostaje wyłączone przez brakujące spięcie.
- [x] `flutter analyze` czysty; testy search/member/conversation **25/25 PASS**;
  `flutter build macos --debug` i oba `git diff --check` PASS.
- [ ] Ręczny runtime review zależy od odblokowania Maca. Uwaga: zestaw zawierał
  istniejący test widgetowy tożsamości panelu, uruchomiony omyłkowo; nie
  uruchamiać kolejnych testów widgetowych/goldenów przed akceptacją wyglądu.

## 2026-09-23 — CHAT-R14 follow-up: spójne wiersze wątku i załączników

- [x] Odpowiedzi wątku używają własnej powierzchni i rytmu Chat zamiast
  domyślnego `ListTile`; wiersz wyboru załącznika pokazuje nazwę, status i
  usuwanie na powierzchni `ChatTheme`, z kontrolowanym ellipsis długich nazw.
- [x] `flutter analyze` czysty; świeży build macOS Debug zakończony osobno.
  Bez testów widgetowych.

## 2026-09-23 — CHAT-R14 follow-up: akcje wiadomości i dyskusja

- [x] Rewizje i wybór celu przekazania wiadomości dostały wiersze z własną
  typografią, obramowaniem i powierzchnią ChatTheme. Pole nazwy dyskusji ma
  jawny styl tekstu, etykiety, focus ring i stan wypełnienia z ChatTheme.
- [x] `flutter analyze` czysty; testy cubitów akcji wiadomości i wątków
  **12/12 PASS**; build macOS Debug PASS. Bez testów widgetowych/goldenów.

## 2026-09-23 — CHAT-R14 follow-up: długie linki i długie wiadomości

- [x] Renderer dodaje punkty łamania zerowej szerokości wyłącznie do
  prezentowanego tekstu długiego URL-a; cel otwierania i kopiowany adres
  pozostają kanoniczne. Wiadomości powyżej 1200 znaków zwijają się także,
  gdy nie zawierają znaków nowej linii.
- [x] `flutter analyze` czysty; rich-text/link/long-paste/grouping **32/32 PASS**;
  macOS Debug build PASS. Nie uruchamiano widgetów ani goldenów.
- [x] Reguły zwijania i łamania linku wydzielono do `ChatMessageDisplayPolicy`;
  nowe testy jednostkowe **6/6 PASS**, analyze i świeży build Debug PASS.

## 2026-09-23 — CHAT-R15: ograniczenia szerokości popovera i breakpoint kolumn

- [x] Wspólny popover ogranicza szerokość do viewportu z marginesem i obniża
  też minimalną szerokość, gdy ekran jest węższy od preferowanego minimum.
- [x] Próg trzech kolumn jest jawnie wyliczany z railu, listy, rozmowy i
  separatorów; 760 px pozostaje progiem modalności hosta.
- [x] Testy geometrii menu/panelu i polityki wiadomości **15/15 PASS**;
  `flutter analyze` czysty; build macOS Debug PASS. Bez widgetów/goldenów.

## 2026-09-23 — CHAT-R14: jeden host i wspólna powierzchnia akcji

- [x] Karta osoby, picker emoji, dialog dodawania linku, podgląd zdjęcia i
  szybkie reakcje korzystają z `DevPlannerModalHost`; karta osoby i picker emoji
  używają wspólnego `ChatSurfaceDialog`. Root modal zachowuje Escape, focus i
  kolejność nad overlayem Chatu.
- [x] Host bottom sheet przyjmuje opcjonalny uchwyt, kształt i kolor bariery;
  dotychczasowi klienci Storage zachowują domyślne ustawienia.
- [x] Bramki: `flutter analyze` czysty, testy katalogu emoji/formatowania/linków
  **40/40 PASS**, `flutter build macos --debug` PASS, `git diff --check` PASS.
- [ ] Nie uruchamiano testów widgetowych/goldenów. Mac pozostaje zablokowany,
  więc ręczny ogląd karty osoby, emoji i szybkich reakcji pozostaje otwarty.

## 2026-09-23 — CHAT-R12: skok z wyszukiwania spoza bieżącej strony

- [x] Wynik wyszukiwania zawsze otwiera się po `conversationId`: najpierw z
  potwierdzonych danych inboxa, a przy braku pozycji przez `GET` szczegółów
  rozmowy, który ponownie egzekwuje ACL. Nie konstruujemy rozmowy z hitu.
- [x] Dla grupy/kanału rola bieżącego użytkownika jest odczytywana przez
  repozytorium członków; po uzyskaniu rozmowy panel przechodzi do istniejącego
  skoku `ensureTargetLoaded(messageId)`. Odmowa/404 czyści nieaktualne trafienia
  i pokazuje neutralny komunikat; błąd transportu pozostawia wyniki do ponowienia.
- [x] Bramka: `flutter analyze` bez problemów; test repozytorium i testy
  wyszukiwania/członków **21/21 PASS**; build macOS Debug i `git diff --check`
  PASS. Bez testów widgetowych/goldenów.
- [ ] Ręczny skok do rozmowy poza pierwszą stroną/filtrami, scroll do starej
  wiadomości i odmowa ACL pozostają do smoke testu w działającym UI; Mac jest
  zablokowany.

## 2026-09-22 — CHAT-INBOX-REALTIME

- [x] Sesyjna invalidacja inboxa poza panelem; dane zawsze pobiera ACL-owany
  endpoint. Obejmuje wiadomości i utworzenie/uzupełnienie rozmowy, niezależnie
  od preferencji powiadomień; reconnect wymusza uzgodnienie bieżącego stanu.
- [ ] Dwu-sesyjne smoke testy SignalR i odbiór UI pozostają otwarte z powodu
  zablokowanego Maca. Bez testów widgetowych/goldenów przed akceptacją wyglądu.

## 2026-09-22 — CHAT-PRESENCE i bramki nowego klienta

- [x] Klient obsługuje `chat.presence.changed`, status unknown/online/offline
  i heartbeat co 15 s; testy eventów/lease/presence/typing → 16/16 PASS.
- [x] Fixture kontraktu zostało skorygowane do backendowych enumów
  `Direct`/`Global`; zbiorcze testy jednostkowe kontraktu, załączników, rich
  text, kodu, wzmianek, formatowania, długich wklejeń, emoji, unread i statusów
  → 85/85 PASS.
- [x] `flutter analyze` całego projektu → No issues found; `flutter build macos
  --debug` i `flutter build web --wasm` → PASS; `git diff --check` → PASS.
- [ ] Nie uruchamiano testów widgetowych ani goldenów. CUA nadal widzi zablokowany
  Mac, dlatego aktualny render, dodawanie osób i responsywność czekają na ręczny
  odbiór. Build i testy jednostkowe nie zamykają akceptacji wizualnej.
- [x] Kompatybilny backend wdrożono na staging jako
  `f7287e03a4d2743b75438b15e72a33f45087fb2e`; API healthy, readiness ready.
  Front nie został opublikowany.
- [x] Naprawiono zgubione linki wiadomości: DTO z backendu mapuje je w historii,
  odpowiedziach akcji i realtime; renderer klika wyłącznie adresy potwierdzone
  przez serwer, a dozwolony zewnętrzny URL pobiera kartę preview z istniejącego
  endpointu backendu. Wewnętrzne ścieżki nie są otwierane jako zewnętrzne URL-e.
- [x] Link codec/mapper/preview/repository i realtime tests → 20/20 PASS;
  pełne `flutter analyze`, build macOS Debug, build Web/Wasm oraz `git diff
  --check` → PASS.
- [ ] Odbiór karty linku i długiego URL-a w realnej rozmowie pozostaje otwarty:
  lokalny web-server pokazuje stronę BFF logowania, a Mac jest zablokowany.
  Nie używano danych konta ani testów widgetowych/goldenów.

## 2026-09-22 — CHAT-INBOX-WIRE i zwężanie panelu

- [x] Parser Chat przyjmuje serwerowe wartości enumów `Direct`/`Group` i `Global`/`Workspace`; ten sam kontrakt jest wysyłany przy tworzeniu rozmowy. Błąd parsowania Retrofit jest raportowany w trybie debug bez treści odpowiedzi i sekretów.
- [x] Animowana szerokość panelu jest ograniczona aktualną szerokością okna; regresja po zwężeniu 3400 → 845 px przechodzi w izolowanym checkoutcie (10/10 testów pliku).
- [ ] Ręczny odbiór na uruchomionym desktopie po ponownej kompilacji aplikacji oraz stagingowy odczyt skrzynki w zalogowanej sesji pozostają otwarte.

## 2026-09-22 — CHAT-COMPLETION: plan pełnego podłączenia funkcji

- [x] Audyt tras Chat, wzmianek, snippetów, polityki załączników, Quill i geometrii shellu; [plan F0–F6](../../Backend/docs/global-chat-completion-plan-2026-09-22.md).
- [ ] F0–F6 pozostają do realizacji/ponownej weryfikacji względem bieżącego kodu. Dokument nie deklaruje napraw.
- [x] F0 (częściowo): front F0.1 (port skrzynki w hoście + jawny błąd niekompletnej kompozycji) i F0.3 (`postingPermission` przez command/adapter/DTO) wykonane; backend F0.2/F0.4/F0.5/F0.7 po stronie `../Backend`. F0.6 i reszta pakietów otwarte; szczegóły w handoffie 2026-09-22 (CHAT-F0).
- [x] Geometria F6 wykonana po F0: `canPin` niezależne od trybu compact, minimalna szerokość treści 480 px, rezerwacja miejsca w treści shella (tapeta stałą warstwą pełnego okna), reduced motion. Test `chat_panel_size_test.dart` 4/4; odbiór wizualny otwarty (CHAT-F1/F6).
- [x] F1 częściowo: profile członków bez UUID i podwidok „Dodaj osoby” (wyszukiwanie, multiselect, chipsy, licznik, istniejący oznaczeni, błąd zachowuje wybór). Popover statusu i F2–F5 pozostają otwarte.
- Priorytety: kompozycja inboxa, kontrakt uczestników/publikacji, dodawanie osób, status w panelu, wzmianki, pliki/zdjęcia, kod i opcjonalny pełny Quill, historia/realtime, przypięcie i tapeta.
- Potwierdzono: pin znika przez compact panelu; padding hosta zmniejsza shell wraz z tapetą. Rozdzielić liczbę kolumn od możliwości przypięcia i rezerwację contentu od pełnego tła.
- Zmieniono tylko dokumentację. Testów aplikacji ani deployu nie uruchamiano. Testy partiami; widgety/goldeny dopiero po akceptacji wyglądu. Następny krok: F0 oraz geometria F6, następnie pozostałe piony.

## 2026-09-21 — CHAT-REVIEW-UI: korekta według referencji WhatsApp

- [x] Spisano [plan UI i napraw po review](../../Backend/docs/global-chat-ui-remediation-2026-09-21.md): układ rail/lista/rozmowa, popover Nowy czat, grupy, kanały, ogłoszenia i rejestr R01–R14.
- [x] PAKIET B z planu korekt: warstwa `DevPlannerModalLayer` daje panelowi przodka `Navigator` (host jest nad routerem, więc wcześniej `Navigator.of` z panelu rzucał wyjątek i kreator się nie otwierał) — modale otwarte z panelu malują się nad panelem, Escape zamyka najpierw modal a potem panel, back systemowy zamyka modal przed zmianą trasy, a focus wraca do panelu; panel wydaje `ChatMessageActionsCubit` i kolejkę z `ChatPendingSendStore`, skrzynka respektuje pusty kursor z `hasMore`, wyścig filtrów i Wstecz w kreatorze. Bramki: `flutter test` 1509 PASS, `flutter analyze` 0 problemów, `git diff --check` czysty; kontrola mutacyjna warstwy i wyścigu filtrów opisana w handoffie.
- [x] PAKIET B (UI) z planu korekt: układ §2.1–2.4 (rail 56 px z sekcjami Czaty/Grupy/Kanały/Pliki/Zadania/Archiwum/Zapisane/Profil/Ustawienia, lista 304–344 px, rozmowa, panel 960 px z uchwytem 760–1120 i przypięciem, niemodalny desktop, compact sheet, zakotwiczony popover „Nowy czat”, wiersz 72 px z etykietą „Szkic” i prefiksem autora) oraz zakładki kontekstowe §2.7 z uczciwym stanem bez danych syntetycznych. Bramki: `flutter test` 1511 PASS, `flutter analyze` 0 problemów, `git diff --check` czysty. Odbiór wizualny pozostaje otwarty — bez zrzutów i bez testów widgetowych zgodnie z §4 planu korekt.
- [x] Naprawy po review UI (2026-09-22): tożsamość rozmowy w panelu (klucz + dzierżawa realtime poza `build`), DM z popovera bez wyjątku `state.kind!`, pusta strona z kursorem ma drogę do dalszych stron, wróciło wejście do wyszukiwania wiadomości, zakładki działają w compact przy otwartej rozmowie, popover odświeża błąd i stan wysyłania. Bramki: `flutter test` 1518 PASS, `flutter analyze` 0 problemów, `flutter build web --wasm` PASS, `git diff --check` czysty; 4 kontrole mutacyjne.
- [x] Panel czatu wg uwag z uruchomionej aplikacji (2026-09-22): start z ~30% szerokości okna, zamknięcie przyciskiem ×, Escape z całego shellu i przełącznikiem w belce, zwijanie animacją po przeciągnięciu uchwytu poza minimum o więcej niż 5% szerokości okna; modalność zależy od szerokości okna, nie panelu. Bramki: `flutter test` 1522 PASS, `flutter analyze` 0 problemów, `flutter build web --wasm` PASS, `git diff --check` czysty.
- [ ] Naprawy R01–R14, dodatkowe ryzyka, pakiety A–E i odbiór UI pozostają otwarte. Wcześniejsze wpisy G3–G7 opisują części implementacji, nie potwierdzają gotowości aktywnego panelu.
- Decyzja użytkownika: rozpoznawalna struktura WhatsApp w prawym panelu, komponenty i kolory DevPlanner. Testy partiami; widgety i goldeny dopiero po akceptacji wyglądu.
- Zmienione wyłącznie dokumenty: nowy plan korekt w Backend, odsyłacz/status planu bazowego oraz plan/handoff obu repo. Bez implementacji i deployu; testów aplikacji w tym pakiecie nie uruchamiano.
- Dalsza decyzja użytkownika: UI ma osobne zakładki Pliki i Zadania / Kanban, przygotowane pod rozmowy widoczne po dodaniu/wzmiance z respektowaniem ACL; teraz projekt i stany UI, integracja później (§2.7 planu korekt).
- Następny krok: pakiet A (ACL/liczniki/DM), następnie działający szkielet i kreator z pakietu B.

## 2026-09-21 — CHAT-G4 (domknięcie): serwerowy szkic rozmowy

- [x] Port `ChatServerDraftRepository` z adapterem i zapisem write-through w composerze: szkic trafia lokalnie (offline) i na serwer, `restore()` preferuje świeższy szkic z serwera, pusty szkic usuwa oba, a konflikt wersji rozwiązuje jedno ponowienie. Wskaźnik `isDraft`/`draftText` w skrzynce ma wreszcie realne źródło.
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1467 PASS, `git diff --check` czysty, kontrakt bez zmian.
- [ ] Pozostaje w G4 wyłącznie UI akcji (G5) i wskaźniki stanu wysyłki (G5/G7) oraz odroczony test widgetowy kluczy.

## 2026-09-21 — CHAT-G6 (start): sesja załączników

- [x] Produkcyjna implementacja portu sesji załączników (`ChatAttachmentSessionRepositoryImpl`) — brakujący element, który blokował złożenie istniejącego adaptera uploadu; sesja domenowa nie niesie ticketów ani URL-i Storage, a odmowa ma własny kod `chat.attachments.session_failed`.
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1501 PASS (+3 testy sesji), `git diff --check` czysty.
- [x] Pierwotna blokada kompozycji załączników została usunięta w aktualnym stanie (CHAT-R54): `DevPlannerApp` rozwiązuje `StorageRepository` i izolowany `PresignedUploadTransport`, a `DevPlannerStandaloneRuntime` przekazuje je do portów uploadu/pobrania i file pickera globalnego Chatu. Test `devplanner_storage_composition_test.dart` 2/2 PASS; analyze i macOS Debug build PASS.
- [ ] Pozostaje w G6: ręcznie potwierdzić rzeczywisty upload i pobranie po zalogowaniu; schowek i drag/drop na ścieżce panelu; limity i komunikaty błędów; reautoryzację po revoke; cleanup osieroconych sesji oraz bramkę zbiorczą G3–G6.

## 2026-09-21 — CHAT-G5 (część 5, zamknięcie): archiwizacja i moderacja

- [x] Archiwizacja i przywracanie rozmowy z menu panelu na porcie zarządzania: potwierdzenie przed archiwizacją, brak potwierdzenia przy przywróceniu, powrót do listy i odświeżenie skrzynki po sukcesie.
- [x] Sygnał roli: rola z serwerowej skrzynki trafia do stanu wyboru i steruje widocznością moderacji (`Owner`/`Moderator` mogą, brak roli nie odblokowuje niczego); backend nadal egzekwuje uprawnienia.
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1498 PASS (+5 testów roli i archiwizacji), `git diff --check` czysty, kontrakt bez zmian.
- [x] G5 zamknięte w zakresie implementacji: wszystkie powierzchnie akcji z planu działają na gotowych portach.
- [ ] Poza implementacją: testy widgetowe i goldeny panelu (odroczone do akceptacji wyglądu) oraz weryfikacja odbioru zdarzeń z żywego huba SignalR, w tym pisania i handshake'u cookie w Web — protokół dwóch sesji w G8.

## 2026-09-21 — CHAT-G5 (część 4): wskaźnik pisania z TTL

- [x] Pisanie w obie strony: `chat.typing.changed` jest mapowane (rodzaj `typingChanged` + `userId`, `isTyping`, `expiresAtUtc`), subskrybowane w serwisie realtime i pomijane przez reduktor historii (bez zmiany wiadomości i bez resyncu).
- [x] TTL z kontraktu serwera: wskaźnik znika po `ExpiresAtUtc` (fallback 8 s), znika też natychmiast po zdarzeniu stop i po zerwaniu połączenia; własne pisanie jest pomijane.
- [x] `setTyping` weszło do portu `ChatConversationRealtimeClient` (z delegacją w dzierżawie), composer zgłasza pisanie przy zmianie treści i „stop” po 4 s bezczynności; wskaźnik pokazuje się nad composerem.
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1493 PASS (+7 testów pisania), `git diff --check` czysty, kontrakt bez zmian.
- [ ] Zasięg weryfikacji: odbiór zdarzenia z żywego huba przez SignalR należy do protokołu dwóch sesji w G8. Pozostaje też archiwizacja/przywracanie z panelu i moderacja cudzej treści.

## 2026-09-21 — CHAT-G5 (część 3): wyciszenie, przypięte, zakładki, statusy

- [x] Menu rozmowy: przełącznik wyciszenia zapisujący politykę serwera (z powrotem do potwierdzonego stanu przy porażce), lista przypiętych wiadomości, lista zakładek i wejście do preferencji powiadomień.
- [x] Widoki list przypiętych i zakładek na porcie akcji: odczyt, odpięcie i usunięcie po potwierdzeniu backendu, stany pusty/błąd.
- [x] Powierzchnia obecności: dialog własnego statusu (emoji, tekst, DND) oraz statusy członków w liście członków; brak portu lub błąd nie psuje listy.
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1486 PASS (+3 testy wyciszenia), `git diff --check` czysty, kontrakt bez zmian.
- [ ] Otwarte w G5: wskaźnik pisania (wymaga mapowania `chat.typing.changed`, nowego rodzaju zdarzenia, stanu z TTL i `setTyping` w porcie realtime), archiwizacja/przywracanie rozmowy z panelu, moderacja cudzej treści oraz odroczone testy widgetowe.

## 2026-09-21 — CHAT-G5 (część 2): wątek, wyszukiwanie i członkowie

- [x] Wątek i dyskusja otwierają się z panelu bocznym arkuszem rootowego hosta modali; porty `ChatThreadRepository` i `ChatDiscussionRepository` są dostarczane jawnie, a nagłówek rozmowy ma wejście do listy członków.
- [x] Wyszukiwanie wiadomości w panelu: fraza, facety, stany pusty/błąd/429, doładowanie kursorem oraz skok do wiadomości, który wybiera rozmowę i cel przewinięcia (podświetlenie + `ensureVisible` dla załadowanej historii).
- [x] Lista członków z rolami, zmianą roli, usuwaniem i opuszczeniem rozmowy; akcje widoczne dla ról, które mogą je wykonać, decyzja po stronie backendu, odświeżenie po mutacji bez migotania.
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1483 PASS (+10 testów wyszukiwania i członków), `git diff --check` czysty, kontrakt bez zmian.
- [ ] Otwarte w G5: mute i preferencje w menu rozmowy, obecność i statusy, widoki przypiętych i zakładek, archiwizacja/przywracanie z panelu, moderacja cudzej treści (czeka na sygnał roli) oraz odroczone testy widgetowe.

## 2026-09-21 — CHAT-G5 (część): menu akcji, reakcje i wątki

- [x] Menu wiadomości z realnym skutkiem: odpowiedz, otwórz wątek, reakcja, forward, edycja i usunięcie z `Version`, przypięcie, zakładka. Każda pozycja woła port, a błąd wraca kodem domenowym przy wiadomości.
- [x] Reakcje z agregatu backendu (bez zapytania na wiadomość), z odróżnieniem własnej reakcji i możliwością jej zdjęcia; szybki wybór emoji.
- [x] Dialogi akcji w rootowym hoście modali: potwierdzenie usunięcia, edycja treści, wybór rozmowy docelowej dla forward.
- [x] Adaptery wątku i dyskusji (`ChatThreadRepositoryImpl` obsługuje oba porty) oraz ich podłączenie w kompozycji i runtime.
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1473 PASS (+6 testów cubita akcji), `git diff --check` czysty, kontrakt bez zmian.
- [ ] Otwarte w G5: otwieranie wątku z panelu (`onOpenThread` bez dostarczyciela), powierzchnia wyszukiwania ze skokiem do wiadomości, lista członków z rolami, mute i preferencje w menu rozmowy, obecność i statusy, widoki przypiętych i zakładek oraz odroczone testy widgetowe.

## 2026-09-21 — CHAT-G4: niezawodność wysyłki, odczyt i trwała kolejka

- [x] Cursor historii działa przez `listConversationMessages` (kursor + `loadMore`), a wiersze mają stabilny `ValueKey` po identyfikatorze wiadomości.
- [x] Reply, edycja/usuwanie z `Version` i konfliktem oraz forward mają porty i adaptery; `ChatMessageActionsCubit` rozróżnia konflikt od utraty dostępu (testy istnieją), a powierzchnie menu dochodzą w G5.
- [x] Dostawa i odczyt to osobne wywołania portu (`markMessageDelivered`, `markConversationRead`); odczyt oznacza widok i tylko dla zamontowanego panelu z aktywną aplikacją, idempotentnie, z pominięciem własnych, lokalnych i usuniętych wiadomości oraz z odświeżeniem serwerowego badge.
- [x] Trwała kolejka wysyłki: desktop zapisuje intencje w secure storage i wznawia je po restarcie, Web celowo nie utrwala treści (jawne ograniczenie offline), magazyn nie zawiera tokenów, a `clearForSession` usuwa intencje przy wylogowaniu i zmianie konta.
- [x] Testy bramki G4: idempotentny retry, konflikt payloadu bez automatycznej pętli, rozłączenie przed/po HTTP 2xx bez duplikatu, odmowa dostępu bez retry, wznowienie po restarcie z tym samym `clientMessageId`, wylogowanie czyszczące magazyn, brak utrwalania na Web oraz widoczność odczytu (5 testów). Reorder eventów jest pokryty testem reduktora.
- [ ] Otwarte: drafty po stronie serwera (composer nadal lokalny, więc `isDraft`/`draftText` w skrzynce jest puste), powierzchnie UI dla edycji/usuwania, forward i wskaźnika dostawy (G5/G7) oraz test widgetowy stabilnych kluczy i przewijania (odroczony z goldenami).
- [x] Bramki: `flutter analyze` bez problemów, `flutter test` 1460 PASS, `git diff --check` czysty, kontrakt OpenAPI↔Retrofit bez zmian. Backend nietknięty w tym pakiecie.

## 2026-09-21 — CHAT-G3 (część 3): kreator rozmowy i bramka na dwóch sesjach

- [x] Front: `creation/chooser`, `creation/participants`, `creation/details` z `ChatCreationCubit` i osobnym cubitem katalogu (debounce, minimum dwóch znaków); przycisk nowej rozmowy w nagłówku panelu otwiera kreator, a po utworzeniu panel wybiera rozmowę bez zmiany trasy.
- [x] Walidacja zgodna z backendem: 1:1 dokładnie jedna osoba, grupa 1–49 osób bez twórcy, nazwa wymagana dla kanału i ogłoszeń do 240 znaków, ogłoszenia blokują publikację dla wszystkich; duplikat 1:1 rozstrzyga `resolve`, nie UI.
- [x] Bramka G3 na dwóch żywych sesjach BFF: katalog → utworzenie DM → wiadomość → skrzynka drugiej sesji z serwerowym `unreadCount` → odczyt zerujący licznik → ponowne otwarcie pary bez duplikatu → kanał globalny widoczny tylko dla twórcy → 400/401/403 dla frazy, braku sesji i braku CSRF. Protokół i wyniki w handoffie.
- [x] Znalazienie z przebiegu: aplikacja nie migruje bazy przy starcie, a lokalna baza nie miała migracji G1 — po `dotnet ef database update` bramka przeszła; to samo wejdzie do G9.
- [ ] Otwarte w G3: część wizualna (light/dark, focus, compact, GUI) — blokada środowiskowa (Computer Use bez zgody na nagrywanie ekranu), więc zrzuty nie powstają; testy widgetowe i goldeny odroczone do akceptacji wyglądu.
- [x] Bramki: backend `dotnet test` 278 PASS / 0 FAIL / 3 SKIP, front `flutter analyze` bez problemów i `flutter test` 1447 PASS, `git diff --check` czysty w obu repo.

## 2026-09-21 — CHAT-G3 (część 2): katalog kont dla nowej rozmowy

- [x] Backend: addytywny `GET /api/v1/chat/users` (katalog lokalnych kont, globalny — bez workspace i bez uprawnień administracyjnych), fraza 2–80 znaków, limit 1–50, wyłącznie konta aktywne i potwierdzone, bez adresu e-mail w odpowiedzi.
- [x] Front: port `ChatDirectoryRepository` z adapterem i trasą Retrofit; luka kontraktu zamknięta po obu stronach.
- [x] Bramki: backend `dotnet build` PASS i `dotnet test` 288 PASS / 0 FAIL / 3 SKIP; front `flutter analyze` bez problemów, `flutter test` 1434 PASS, `git diff --check` czysty; OpenAPI (463 trasy) bez luk w trasach Chat.
- [ ] G3: `creation/chooser`, `creation/participants`, `creation/details` do zbudowania; testy widgetowe i goldeny dopiero po akceptacji wyglądu.

## 2026-09-21 — CHAT-G3 (część): lista skrzynki w panelu

- [~] G3: komponenty `inbox/list` i `inbox/search` z cubitem skrzynki zastąpiły w panelu listę z kontraktu bazowego; wybór rozmowy przeniesiono na model domenowy, a nagłówek pokazuje serwerowy agregat nieprzeczytanych.
- [ ] G3: tworzenie rozmowy (`creation/chooser`, `creation/participants`, `creation/details`) jest zablokowane brakiem endpointu katalogu lokalnych kont; jedyne dostępne źródło kandydatów jest zakresowe po workspace, czego §4.3 zabrania dla globalnego DM. Następny krok: addytywny `GET /api/v1/chat/users?q=` w backendzie z testami ACL.
- [x] Bramki (front): `flutter gen-l10n` PASS, `flutter analyze` bez problemów, `flutter test` 1432 PASS, `git diff --check` czysty, porównanie OpenAPI z Retrofit bez zmian.
- [ ] Odroczone zgodnie z planem: testy widgetowe i goldeny panelu do czasu akceptacji wyglądu; brak testu manualnego na dwóch sesjach (G8).

## 2026-09-21 — CHAT-G2: porty klienta i jedno źródło sesji

- [x] G2: rozdzielone porty `inbox`, `conversation-management`, `message-actions`, `members`, `search`, `presence`, `settings` z adapterami w `workspaces/data/chat` i modelami domenowymi; panel nie dostał jednego wielkiego repozytorium.
- [x] G2: jedno źródło sesji REST/SignalR — desktop używa access tokenu PKCE, Web cookie BFF z nagłówkiem CSRF przy negotiate; Flutter Web nie czyta tokenu.
- [x] G2: sesyjny właściciel subskrypcji realtime — ta sama rozmowa dostaje tę samą subskrypcję, połączenie zamyka się po ostatniej dzierżawie, a koniec sesji zamyka wszystko i usuwa prywatne szkice (`deleteAllForUser`).
- [x] G2: reduktor realtime — dedupe po `eventId`, monotoniczna sekwencja, replay z kursorem, `resyncRequired`, a nieznana wersja kontraktu wymusza pełny resync.
- [x] Bramki (front): `build_runner`, `flutter gen-l10n`, `flutter analyze` bez problemów, `flutter test` 1426 PASS, `git diff --check` czysty, porównanie OpenAPI z Retrofit bez nowych luk.
- [ ] Ograniczenie: ścieżka Web SignalR nie była jeszcze uruchomiona na żywym backendzie z przeglądarką — weryfikacja w G8; brak testu `DevPlannerStandaloneRuntime` i buildów platform.

## 2026-09-21 — CHAT-G2 (część): port ustawień powiadomień w hoście paneli

- [x] G2: port `ChatNotificationSettingsRepository` jest tworzony w runtime i udostępniany panelom oraz rootowym modalom przez host; dwa nowe testy hosta dowodzą, że port jest osiągalny, a brak kompozycji nie tworzy cichej atrapy.
- [x] Bramki (front): `flutter analyze` bez problemów, `flutter test` 1396 PASS, `git diff --check` czysty.

## 2026-09-21 — CHAT-G2 (część): port skrzynki w kliencie

- [~] G2: rozdzielone porty klienta. Gotowy port `inbox` z adapterem, modelami domenowymi i domknięciem dwóch tras Retrofit; `conversation-management`, `message-actions`, `members`, `search`, `presence` i `settings` pozostają do rozdzielenia.
- [x] G2: kompozycja portów w hoście paneli — port ustawień powiadomień Chat jest tworzony przez runtime i montowany nad oba panele; to usuwa `ProviderNotFoundException` w modalach ustawień.
- [~] G2: jedno źródło sesji REST/SignalR. Nie rozpoczęte: transport SignalR dla Web BFF wymaga cookie/CSRF, a po logout/401/revoke musi zamykać połączenia i czyścić prywatny cache, draft i queue.
- [~] G2: realtime reducer. Nie rozpoczęte: wersja kontraktu, monotoniczna sekwencja per rozmowa i session-scoped właściciel subskrypcji.
- [x] Bramki po G0–G2 (front, wykonane): `build_runner`, `flutter gen-l10n`, `flutter analyze` bez problemów, `flutter test` 1394 PASS, porównanie OpenAPI z Retrofit bez luk Chat, `git diff --check` czysty.

## 2026-09-21 — CHAT-G0/G1: kontrakt skrzynki i serwerowe nieprzeczytane

- [x] G0: audyt §3 względem aktywnego kodu; mapa `gotowe / wymaga podłączenia / backend gap` zapisana w handoffie.
- [x] G0: wygenerowany OpenAPI (462 trasy) porównany z Retrofit (`tool/verify_workspaces_contracts.py`); luki Chat poza nowym inboxem: brak.
- [x] G0: fixture dwóch lokalnych kont w testach PostgreSQL oraz przejście dwóch stron (nadawca i odbiorca) w scenariuszach skrzynki.
- [x] G1: `GET /api/v1/chat/inbox` (cursor, limit, filter: All/Unread/Direct/Groups/Channels/Archived) i `GET /api/v1/chat/inbox/unread-count`; odczyt EF wydzielony z `ChatService`.
- [x] G1: serwerowy licznik nieprzeczytanych z monotonicznego znacznika odczytu i addytywna migracja `AddChatInboxReadMarker` z backfillem.
- [x] G1: poprawka ACL/idempotencji — jedna rozmowa 1:1 na parę w Scope Global, niezależnie od etykiety klienta.
- [x] G1: testy PostgreSQL (9) — stronicowanie z równymi czasami, licznik i znacznik odczytu, filtry, archiwum, mute i szkic, usunięty członek, podgląd i redakcja sekretów, stała liczba zapytań; testy OpenAPI wszystkich pól i 401 przez HTTP.
- [ ] G2–G9: porty klienta, UI skrzynki, niezawodność wysyłki, załączniki, dopracowanie wizualne, akceptacja wyglądu, E2E na dwóch sesjach i staging pozostają otwarte.

## 2026-09-21 — CHAT-G0: plan globalnego komunikatora i porządek dokumentacji

- [x] Audyt aktywnego backendu Chat, globalnego panelu Frontu, kontraktów i stagingu.
- [x] Plan G0–G9: `Backend/docs/global-chat-implementation-plan-2026-09-21.md`.
- [x] Usunięto stare, niedokończone checklisty Chat i nieaktualne opisy tożsamości z dokumentacji kontraktowej; historyczne nazwy plików pozostają jako odsyłacze.
- [x] Potwierdzono decyzję produktu: Chat tylko jako prawy globalny panel, bez osobnej trasy i bez integracji kontekstowych w tym pakiecie.
- [x] Ustalono zbiorcze uruchamianie testów po większych etapach. Goldeny i testy widgetowe dopiero po akceptacji wyglądu przez właściciela.
- [ ] Implementacja G1–G9, manualny odbiór UI i staging pozostają otwarte. Ten wpis nie jest potwierdzeniem funkcjonalnej gotowości Chat.


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


Status: **częściowo zrealizowane; poniższy dokument opisuje wyłącznie stan zaakceptowany**.

Dokument jest wspólny dla repozytoriów:

- `/Users/przemyslawnowak/Desktop/dev/DevNote/Backend`
- `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`

Obie kopie muszą być byte-for-byte identyczne. Nie zmieniaj kodu, migracji ani
testów w ramach samej synchronizacji dokumentacji.

## 1. Obowiązujące decyzje

- DevPlanner działa jako standalone i używa lokalnej tożsamości `UserId` typu
  UUID (`Guid` w backendzie). `ReadyUserId`, `CoreUserId` oraz aliasy tych pól
  nie są kontraktem docelowym.
- Backend, OpenAPI i Flutter używają lokalnego `UserId`; nie dodano aliasów,
  dual-read/write, fallbacku ani importu legacy.
- Zakres produktu obejmuje workspace, projekty, zadania, Kanban, Storage, Wiki,
  Whiteboard, Chat, Notifications, ustawienia i administrację użytkownikami.
- Ready/Core/DataBus i ich połączenia runtime pozostają poza standalone.

## 2. Pakiety zaakceptowane

### 2D — sesje urządzeń i refresh tokeny

Pakiet jest zaakceptowany po wspólnym targeted suite **119/119**. Zaakceptowany
zakres obejmuje lifecycle sesji urządzenia, rotację rodzin refresh tokenów,
revoke oraz persistence.

### 3D — frontend auth/admin/me

Pakiet jest zaakceptowany z `AuthComposition` oraz podłączonymi seamami
auth/admin/profile/session w uzgodnionym zakresie. Produkcyjne bramki transportu
i E2E pozostają otwarte i nie są dowodem ukończenia całego produktu.

### 4B — świeży schemat domeny, FK i indeksy

Pakiet jest zaakceptowany po poprawce przeglądu CSRF. Akceptacja dotyczy
zatwierdzonego schematu i kontraktów; pozostałe agregaty domenowe nadal wymagają
osobnych pakietów.

### 4C — OpenAPI oraz Chat/Notifications `UserId`

Pakiet jest zaakceptowany po korekcie indeksu migracji. Walidacja PostgreSQL dla
Notifications zakończyła się wynikiem **41/41**.

### 4D — Tasks/Kanban lokalny `UserId`

Pakiet jest zaakceptowany w zakresie lokalnego `UserId` dla Tasks/Kanban.
Zmiana obejmuje encje, kontrakty, query/handler/mapper, capacity i preferencje
Kanban, realtime/outbox/workery oraz konfigurację EF/indexes. Usunięto nazwy
`*CoreUserId` i legacy Ready z tego pionu; nie dodano aliasów, dual-read/write,
fallbacku ani backfillu.

Dowody zaakceptowane dla 4D:

- backend build: **0/0** (PASS, zero ostrzeżeń);
- targeted Tasks/Kanban unit/handler suite: **100/100** (PASS; 69 + 31);
- idempotentny skrypt migracji EF: PASS.

Walidacja integracyjna PostgreSQL dla 4D **nie została zweryfikowana**: filtr
był zablokowany przez nieprawidłowe credentials istniejącej instancji
`127.0.0.1:5440`. Nie wolno przedstawiać tego jako PASS ani jako dowodu
działania migracji na PostgreSQL.

### 4E — Projects/Workspace lokalny `UserId`

Pakiet jest zaakceptowany dla lokalnego UUID `UserId` w Projects/Workspace.

Dowody zaakceptowane dla 4E:

- backend build: **0/0** (PASS, zero błędów i ostrzeżeń);
- agent gate: **17/17** (PASS);
- dodatkowy root gate: **20** testów (PASS).

Dwa przypadki `WorkspaceRoleHttpIntegration` nie przeszły konfiguracji fixture,
ponieważ środowiskowa baza testowa nie zawiera tabeli
`veloryn_workspaces.workspaces`. Jest to problem provisioning/fixture bazy
testowej, a nie błąd logiki pakietu; nie zmienia akceptacji 4E. Tabelę należy
zapewnić przed ponownym uruchomieniem tych dwóch przypadków.

### 6F/6G — frontendowe typed adapters rename

Pakiety globalnego Chat (6F) i Notifications (6G) są zaakceptowane w zakresie
standalone runtime wiring oraz rename do typowanych adapterów opartych o lokalny
`UserId`.

Dowody zaakceptowane dla wspólnego zakresu 6F/6G:

- targeted frontend suite: **11/11** (PASS);
- `flutter analyze`: PASS.

Nie jest to akceptacja produkcyjnego transportu sesji ani pełnych testów E2E.

### 4F — frontend auth lokalny `UserId`

Pakiet jest zaakceptowany dla aktywnego rdzenia autoryzacji Fluttera. `AuthUser`
używa kanonicznych pól `String userId` i `login`; w zakresie 4F usunięto
aliasy `CoreUserId`/Ready oraz bezpośrednie odwołania do starych call site'ów
auth w shellu, routerze, pickerze i wątkach. Typed `/api/v1/me` pozostaje
kontraktem profilu. Nie dodano fallbacku Ready/Core/DataBus ani dual-read/write.

Dowody zaakceptowane dla 4F:

- `flutter test test/core/auth`: **48/48** (PASS);
- `flutter test test/auth`: **16/16** (PASS);
- `flutter test test/app/router`: **9/9** (PASS);
- suma targeted suite: **73/73** (PASS);
- `flutter analyze`: PASS, bez problemów;
- `git diff --check`: PASS.

Pozostałe domenowe DTO frontendu (m.in. Tasks, Projects i Storage) pozostają
poza zakresem 4F i nadal wymagają osobnych pakietów migracji do lokalnego
`UserId`.

### 4G — Storage/Office/avatar/share/AI lokalny `UserId`

Pakiet jest zaakceptowany dla Storage, upload/download, ACL, współdzielenia,
integracji Office/OnlyOffice, avatarów, wyszukiwania semantycznego i zadań AI.
Encje, kontrakty, serwisy oraz bezpośrednie testy używają lokalnego UUID
`UserId`; usunięto parametry i aliasy `CoreUserId`/Ready oraz fallbacki.

Nie dodano migracji EF. Odpowiedni schemat jest już lokalny, a
`StorageUserNotificationPreference` został poprawnie przemianowany w migracji
4C; tworzenie duplikatu migracji byłoby błędem.

Dowody zaakceptowane dla 4G:

- backend build: **0/0** (PASS, zero błędów i ostrzeżeń);
- wybrana suite Storage/Office/avatar/share/AI: **135/135** (PASS);
- formatowanie i `git diff --check`: PASS.

Szersza bramka HTTP/integration Storage pozostaje otwarta z powodu fixture
`42P01` oraz standalone guarda odrzucającego legacy środowisko; nie jest to
wynik PASS.

### 4H — Wiki/Whiteboard/OKR lokalny `UserId`

Pakiet jest zaakceptowany dla lokalnego `UserId` w grantach dostępu Wiki i
Whiteboard, `Objective.CreatedByUserId` oraz `StickyNote.AssigneeUserIds`.
Usunięto aliasy i fallbacki Ready/Core. Zastosowano wyłącznie rename-only
migrację `20260917074039_UseLocalUserIdForWikiWhiteboardAndOkr`.

Dowody zaakceptowane dla 4H:

- backend build: **0/0** (PASS);
- root selected suite: **74/74** (PASS; agent narrow suite 57/57);
- idempotentność migracji i `git diff --check`: PASS.

Wiki HTTP/OpenAPI integration była historycznie blokowana przez legacy JWKS
environment; 4O usuwa odziedziczoną konfigurację fixture’ów, ale szersza
bramka Wiki HTTP nadal wymaga własnych, ukierunkowanych dowodów.

### 4I — frontend Tasks/Kanban lokalny `UserId`

Pakiet jest zaakceptowany dla aktywnego frontendu Tasks/Kanban. Modele,
payloady, query, repozytoria, realtime oraz UI używają kanonicznych pól
`userId`, `assigneeUserId`/`assigneeUserIds` i `userIds`; obejmuje to także
profile członków projektu, board/list/details, templates, capacity i workload.
Odświeżono wygenerowane Freezed/JSON/Retrofit. Nie ma aliasów, fallbacku,
dual-read/write ani mapowania Ready/Core.

Dowody zaakceptowane dla 4I:

- targeted frontend suite: **116/116** (PASS);
- generator: PASS, 182 outputs zapisane (wyłącznie istniejące ostrzeżenie
  constraint `json_annotation`);
- scoped `flutter analyze`: PASS, bez problemów;
- pełny skan zakresu pakietu nie znalazł `CoreUserId`, `coreUserId`,
  `ReadyUserId`, `readyUserId` ani `ready_id`;
- `git diff --check`: PASS.

Pełny `flutter analyze` po 4J nie jest dowodem testów E2E Tasks/Kanban.

### 4J — frontend Workspace members, invitations i lokalny katalog

Pakiet jest zaakceptowany dla członkostw workspace, zaproszeń oraz lokalnego
katalogu użytkowników. `WorkspaceMemberResponse`, zaproszenia i payloady
używają `userId`, a `LocalDirectoryUserResponse` publikuje dokładny kontrakt
`userId`, `login`, `displayName`, `email`, `emailVerified`, `avatarFileId`.
Wyszukiwanie korzysta z `searchLocalUsers`; bez fallbacku i dual-read/write.
Zaktualizowano bezpośrednie call-site’y Project/Storage wymagane przez te
kontrakty, w tym użycie `avatarFileId`, oraz odświeżono artefakty generowane.

Dowody zaakceptowane dla 4J:

- focused members/workspace suite: **10/10** (PASS);
- dodatkowa suite kontraktów i konsumentów: **11/11** (PASS);
- generator: PASS, 5 artefaktów;
- `flutter analyze`: PASS, `No issues found!`;
- `git diff --check`: PASS.

Aktualny source scan nie wykazuje już tych legacy pól DTO ani feature actors;
starsza wzmianka nie jest już blokadą. Nie rozszerza to jednak dowodów na pełne
E2E ani platformy.

### 4K — frontend Projects/Workspace core lokalny `UserId`

Pakiet jest zaakceptowany dla frontendowych kontraktów Projects/Workspace core.
`ProjectResponse`, `ProjectMemberResponse`, `PortfolioResponse` i
`WorkspaceResponse` oraz listy i mappery używają kanonicznych pól
`createdByUserId` i `userId`. Zaktualizowano także bezpośrednie wywołania
Project oraz odświeżono artefakty generowane; nie dodano aliasów, fallbacku ani
dual-read/write.

Dowody zaakceptowane dla 4K:

- agent suite: **27/27** (PASS);
- dodatkowy kontraktowy test generatora: **1/1** (PASS);
- root cross-package selective suite: **18/18** (PASS);
- `flutter analyze`: PASS;
- `git diff --check`: PASS.

Zakres 4K nie obejmuje pozostałych workspace feature actors, niezależnych
DTO dostępu/automatyzacji/realtime ani produktu E2E.

### 4L — frontend Storage/Wiki/Whiteboard/ACL lokalny `UserId`

Pakiet jest zaakceptowany dla frontendowych kontraktów Storage, Office,
avatarów, share i AI oraz pozostałych Storage/Wiki/Whiteboard ACL. `Objective`
publikuje `createdByUserId`, a sticky notes używają kanonicznego
`assigneeUserIds`; artefakty generowane zostały odświeżone. W tym zakresie nie
ma aliasów `CoreUserId`/Ready, fallbacków ani dual-read/write.

Dowody zaakceptowane dla 4L:

- agent suite: **23/23** (PASS);
- root cross-package selective suite: **18/18** (PASS);
- `flutter analyze`: PASS;
- `git diff --check`: PASS.

Pełny build runner w trakcie 4L dodatkowo wygenerował workspace responses, ale
ich źródłem autorytatywnym pozostaje pakiet 4K. 4L nie obejmuje pozostałych
workspace feature actors, niezależnych DTO dostępu/automatyzacji/realtime ani
produktu E2E.

### 4N — backendowe aktywne identity names i transport

Pakiety 4N-A, 4N-B i 4N-C są zaakceptowane w zakresie aktywnych warstw
backendu. Warstwy te nie używają nazw identity `Core`/`Ready`; kanoniczne
nazwy transportowe to `userId`, `actorUserId` i `authorUserId`. Dotyczy to
infrastruktury Ops/Admin, globalnego wyszukiwania Chat oraz objętego zakresem
cleanupu Projects. Nie dodano aliasów, fallbacków ani dual-read/write.

Obowiązuje jedna rename-only migracja
`20260917082352_UseLocalUserIdForOpsInfrastructure` dla tych rename’ów; nie
tworzyć równoległej migracji wykonującej te same zmiany.

Dowody zaakceptowane dla 4N:

- 4N source scan: PASS;
- backend build: **0/0** (PASS);
- idempotentny skrypt migracji EF, formatowanie i `git diff --check`: PASS.

Test HTTP/OpenAPI pozostaje otwarty i nie jest wynikiem PASS: zatrzymuje go
legacy fixture `WORKSPACES_JWKS_*`. Obsługa tej blokady została zamknięta przez
pakiety 4O i 4Q dla objętego nimi zakresu.

### 4O — standalone test host i lokalny Identity/OpenIddict

Pakiet jest zaakceptowany dla testowego hosta, fixture’ów i helperów lokalnego
standalone Identity/OpenIddict. Fixture’y nie ustawiają już zabronionych
`WORKSPACES_JWKS_URL`, `WORKSPACES_JWT_ISSUER` ani
`WORKSPACES_JWT_AUDIENCE`; czyszczą odziedziczone klucze i używają lokalnego
issuera OpenIddict. Produkcyjna logika, aliasy i fallbacki nie zostały zmienione.

Dowody zaakceptowane dla 4O:

- backend build: **0/0** (PASS);
- Local Identity/OpenIddict tests: **19/19** (PASS);
- scoped format verify helpera i `git diff --check`: PASS.

Pełna weryfikacja formatu projektu pozostaje osobnym porządkiem technicznym z
istniejącymi whitespace diagnostics; nie jest to błąd produktu ani podstawą do
cofnięcia akceptacji. Historyczne uruchomienia `dotnet format` z root repo były
niejednoznaczne co do wyboru projektu; kolejne weryfikacje wykonywać z jawnym
plikiem projektu, np. `dotnet format veloryn-workspaces.csproj
--verify-no-changes`.

### 4P — konkretny kontrakt OpenAPI dla avatarów

Pakiet jest zaakceptowany dla `GET /api/v1/me/avatar` oraz
`GET /api/v1/users/{userId}/avatar`. Wildcard `image/*` zastąpiono trzema
konkretnymi typami odpowiedzi: `image/jpeg`, `image/png` i `image/webp`, zgodnie
z walidacją uploadu i magic bytes. Nie zmieniono uploadu, storage, cache/ETag ani
statusów błędów.

Dowody zaakceptowane dla 4P:

- backend build: **0/0** (PASS);
- OpenAPI publikuje dokładnie trzy obsługiwane typy bez wildcardu (PASS);
- avatar upload tests: **3/3** (PASS).

### 4Q — disposable fixture i kontrakt OpenAPI AdminOps

Pakiet jest zaakceptowany w zakresie standalone HTTP/OpenAPI. Fixture
`AdminOpsPostgresFixture` tworzy losową, disposable bazę PostgreSQL, stosuje
aktualne migracje `WorkspaceDbContext` i `LocalIdentityDbContext`, a następnie
sprząta bazę po testach. OpenAPI wymaga standalone BFF cookie
`BffSessionCookie` (`devplanner.bff`, `apiKey` w `cookie`) i nie publikuje
legacy `Bearer` ani wewnętrznego `IdentityCookie`.

Dowody zaakceptowane dla 4Q:

- niezależny build z root: **0/0** (PASS);
- wybrane testy HTTP/OpenAPI: **11/11** (PASS), obejmujące AdminOps i
  `ApiEndpointTests.ChatSearchRateLimit`;
- `git diff --check`: PASS.

Nie uruchamiano pełnej suite; fixture i kontrakt są wzorcem dla kolejnych
odblokowywanych standalone HTTP/integration testów. Nie wracać do legacy
connection stringów, Bearer/JWT ani schematu IdentityCookie.

### 4R-B — standalone runtime readiness

Pakiet jest zaakceptowany w zakresie lokalnej konfiguracji startowej, świeżego
schematu i bounded bootu backendu. Audyt README, `.env.example`, launch
settings, `Program.cs`, `start-local.sh` i Compose potwierdził topologię
standalone bez runtime endpointów Ready/Core/DataBus.

W świeżej bazie wykryto brak kolumny `project_automation_rules.ArchivedAtUtc`:
ręczna migracja `20260822160000_AddAutomationRuleArchive` nie była odkrywana
przez EF, bo nie miała atrybutów `DbContext`/`Migration`. Dodano addytywną,
idempotentną migrację `20260917100000_EnsureAutomationRuleArchiveColumn`; nie
zmieniano historycznych migracji.

Dowody zaakceptowane dla 4R-B:

- `docker compose config --quiet`: PASS;
- backend build: **0/0** PASS;
- migracje `WorkspaceDbContext` i `LocalIdentityDbContext` na disposable
  PostgreSQL: PASS;
- bounded boot: `/health/live` 200, `/health/ready` 200, Swagger 200;
- po poprawce brak błędu `ArchivedAtUtc` i nieobsłużonego wyjątku startowego;
- nie uruchamiano pełnej suite ani długotrwałego procesu.

Pełny `start-local.sh` nadal wymaga Docker Compose; MinIO, ClamAV, Redis,
OnlyOffice i Mailpit są prerequisite'ami odpowiednich funkcji, lecz nie były
uruchamiane w bounded probe. Nie przywracać konfiguracji ani endpointów
Ready/Core/DataBus.

### 4R Front — frontend runtime readiness

Pakiet jest zaakceptowany dla audytu standalone Flutter runtime. Kanoniczny
start prowadzi przez `lib/main.dart` i `DevPlannerApp`, a aktywna konfiguracja
używa wyłącznie `DEVPLANNER_API_BASE_URL`; nie ma aktywnych endpointów ani
kluczy Ready/Core/DataBus. Pakiet 4S domknął cleanup nieosiągalnych legacy
widgetów i tras; z `lib/core/auth` nie pozostaje żaden kod.

Dowody: `flutter analyze` po 4S — PASS (`No issues found!`). Niezależny
`flutter build web --debug --no-tree-shake-icons` po 4S zakończył się PASS w
**98.7 s**.

### 4S — frontend legacy auth corrective cleanup

Pakiet jest zaakceptowany: usunięto cały `lib/core/auth`, `AuthApi` i każdy
port kompatybilności, stare endpointy logowania/refresh, dedykowane testy oraz
nieosiągalne legacy dormant widgets/routes. Aktywny Chat otrzymuje jawny
`userId` z kompozycji użytkownika. `lib/auth` pozostaje jedynym aktywnym
standalone auth; nie dodano fallbacku ani aliasu.

Dowody: `flutter analyze` po 4S — PASS; `flutter gen-l10n` i `git diff
--check` — PASS; post-4S Web build PASS (**98.7 s**).

### 5A/5B — dormant legacy auth i DataBus cleanup

Pakiety są zaakceptowane: usunięto dormant DataBus/Core resource-scope,
zewnętrzny JWKS/JWT bearer oraz nieużywane legacy auth/configuration paths.
Aktywna kompozycja pozostaje lokalnym OpenIddict/BFF; skan źródeł nie wykazuje
już tych klas, rejestracji ani pakietu JwtBearer.

Dowody: root review backend build **0/0** (PASS) oraz wybrana suite **74/74**
(PASS). Nie oznacza to ukończenia pełnej macierzy E2E/platform.

### 5I/5K — hermetic PostgreSQL oraz Storage/AI HTTP

Disposable PostgreSQL i hermetyczne Storage/AI fixtures są zaakceptowane.
Walidacja ukierunkowanego zakresu zakończyła się wynikiem **17/17** (PASS).

### 5L/5M — lokalny test seam i sesja BFF

Pozytywny test seam używa wyłącznie `X-Test-User-Id` i emituje `sub`; pozytywne
oczekiwania OpenAPI używają lokalnych identyfikatorów. Kontrakt `/me` sprawdza
bezpośrednie `302` BFF przy wyłączonych redirectach. Root validation: **1/1**
(PASS). Nie przywrócono bearer/JWT.

### 5N/5O — HTTP/OpenAPI fixture i kontrakt

Pozostała ukierunkowana bramka HTTP/OpenAPI na disposable fixture zakończyła się
wynikiem **57/57** (PASS), obejmując aktualny BFF session scheme i kontrakty
OpenAPI.

### 5P — ACL, automatyzacja i realtime

Pakiet jest zaakceptowany po proof suite **33/33** (PASS) dla ACL,
automatyzacji i realtime. Wynik dotyczy wskazanego zakresu testów, nie pełnej
macierzy E2E ani wszystkich platform.

### 5R — odporność równoczesnej rotacji refresh tokena

Pakiet jest zaakceptowany dla równoczesnych żądań rotacji refresh tokena w
PostgreSQL. Retry jest ograniczony do maksymalnie jednej próby i uruchamia się
wyłącznie dla `PostgresException.SqlState == "40001"`. Ponowienie obejmuje
pełną operację w jednej transakcji razem z zapisem audytu; rollback nie duplikuje
wpisu audytowego. Drugi równoczesny request kończy się fail-closed po wykryciu
reuse i unieważnia rodzinę tokenów.

Dowody zaakceptowane dla 5R:

- `RefreshTokenPostgresConcurrencyTests`: **1/1** (PASS);
- `dotnet build veloryn-workspaces.csproj --no-restore`: **0/0** (PASS);
- `git diff --check`: PASS.

### 5S — workspace lifecycle, membership, invitations i preferences

Pakiet jest zaakceptowany dla lifecycle workspace, członkostw, zaproszeń i
preferencji na disposable PostgreSQL. Dowody obejmują wyłącznie ten zakres
HTTP/integration i nie rozszerzają akceptacji na pełne E2E produktu.

Dowody zaakceptowane dla 5S:

- targeted disposable PostgreSQL gate: **7/7** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

### 5T — Wiki PostgreSQL/HTTP standalone

Pakiet jest zaakceptowany dla standalone Wiki PostgreSQL/HTTP z użyciem
`WebApplicationFactory`. Wynik potwierdza wskazany kontrakt HTTP i persistence
Wiki; nie jest dowodem pełnej macierzy E2E ani wszystkich platform.

Dowody zaakceptowane dla 5T:

- standalone Wiki PostgreSQL/HTTP gate: **4/4** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

### 5U — frontend bounded auth/session/shell/router

Pakiet jest zaakceptowany dla bounded frontendowego zakresu auth, session,
shella i routera.

Dowody zaakceptowane dla 5U:

- targeted frontend suite: **53/53** (PASS);
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5V — frontend global Chat/Notifications/realtime contracts

Pakiet jest zaakceptowany dla frontendowych kontraktów globalnego Chat,
Notifications i realtime oraz ich fake/test suite. Wynik nie dowodzi live
backend SignalR E2E; ten zakres pozostaje częścią otwartej macierzy E2E.

Dowody zaakceptowane dla 5V:

- targeted frontend contract/fake suite: **67/67** (PASS);
- scoped `flutter analyze`: PASS;
- `git diff --check`: PASS.

### 5W — standalone Task HTTP/OpenAPI matrix

Pakiet jest zaakceptowany dla standalone Task HTTP/OpenAPI matrix przez
`WebApplicationFactory` i disposable PostgreSQL. Zakres obejmuje smoke test 100
operacji Tasks, role/access, workflow oraz kontrakty błędów `400/401/403/404/409`.
Test używa wyłącznie GUID `UserId` przekazywanego przez `X-Test-User-Id`; z
testu usunięto wskaźniki i nazwy Ready/Core oraz legacy environment.

Dowody zaakceptowane dla 5W:

- standalone Task HTTP/OpenAPI matrix: **6/6** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

Pakiet nie jest dowodem pełnego E2E produktu.

### 5X — standalone local login backend/BFF

Pakiet jest zaakceptowany dla lokalnego logowania backendowego przez `GET/POST
/auth/login`. Zakres obejmuje antiforgery, rate limit **10/5 min/IP**,
`returnUrl` ograniczony do adresów lokalnych, aktywne i potwierdzone konto
lokalne, neutralne błędy oraz przejście z cookie Identity do autoryzacji BFF.
Nieudane lub niejednoznaczne dopasowanie loginu/e-maila kończy się fail-closed.
Publiczna rejestracja nie istnieje; provisioning dotyczy wyłącznie
skonfigurowanych klientów OIDC.

Dowody zaakceptowane dla 5X:

- `LocalLogin` + `BffSecurity` + `LocalOpenIddict` +
  `LocalIdentityFoundation`: **36/36** (PASS);
- backend build: **0/0** (PASS);
- `git diff --check`: PASS.

Pakiet nie zamyka desktop PKCE ani real browser E2E.

### 5Y — frontend web BFF root

Pakiet jest zaakceptowany dla frontendowego web BFF root: browser launcher,
web composition i restore wykonywane przed `runApp`, CTA bez credentials,
neutralny redirect bez error flash oraz brak bearer transportu.

Dowody zaakceptowane dla 5Y:

- targeted gates po review: **39/39**, następnie korekta review **24/24**
  (PASS);
- scoped `flutter analyze`: PASS;
- web debug build: PASS.

Desktop PKCE pozostaje otwarte, podobnie jak real browser E2E; ten pakiet nie
jest dowodem pełnego E2E.

### 5Z — backend Desktop Authorization Code + PKCE contract

Pakiet backendowy jest zaakceptowany dla kontraktu Desktop Authorization Code +
PKCE. Publiczny klient ma `client_id=devplanner-desktop` i nie ma sekretu.
Wymagany jest code flow z PKCE `S256`; callback używa loopback URI
`http://127.0.0.1:<49152..65535>/callback`. Kontrakt obejmuje rotację,
wykrywanie reuse i revoke refresh-tokenów.

Dowody zaakceptowane dla 5Z:

- targeted `LocalOpenIddict` gate: **13/13** (PASS);
- backend build: PASS, bez ostrzeżeń;
- manual visual rendering: PASS.

Implementacja transportu platformowego po stronie Front pozostaje w toku.
Browser Playwright E2E jest celowo zdepriorytetyzowane; real browser E2E nadal
pozostaje otwarte.

### 6E — Desktop PKCE typed transport implementation

Pakiet jest zaakceptowany dla typed transportu Desktop PKCE. Klient używa
publicznego `devplanner-desktop`, Authorization Code + PKCE `S256`, losowego
portu loopback `49152..65535` i system browsera. `state`, `nonce` i
`code_verifier` należą do typed transportu; access token pozostaje wyłącznie w
pamięci, a refresh token wyłącznie w OS vault. Rotacja zastępuje wartość w
vault. Autorytatywnym odczytem użytkownika jest `GET /api/v1/me/`, a wylogowanie
używa `POST /connect/revocation`; lokalny vault jest czyszczony także wtedy,
gdy zdalne revoke zwróci błąd. Transport obejmuje ścieżki launcherów
Windows/macOS/Linux.

Dowody zaakceptowane dla 6E:

- backend `LocalOpenIddict` + revocation targeted gates: **17/17** (PASS);
- backend build: PASS, bez ostrzeżeń;
- frontend targeted suite: **13/13** (PASS);
- scoped `flutter analyze`: PASS.

Pozostaje ręczna weryfikacja native login/callback/refresh/logout na każdym z
systemów Windows/macOS/Linux; nie jest ona jeszcze dowodem sukcesu. Real browser
E2E pozostaje celowo odroczone.

### 6E — macOS manual smoke status

Najnowszy macOS smoke potwierdził zaufany development certificate, discovery
backendu, aktywny native CTA oraz pracę loopback listenera. Dostarczenie adresu
`/connect/authorize` do przeglądarki kończy się jednak niepowodzeniem zarówno
przez `Process.open`, jak i `url_launcher`, mimo że samo uruchomienie launchera
raportuje sukces. W efekcie nie zweryfikowano auth callbacku, sesji, `me`,
refresh ani revocation.

Po próbie disposable runtime i baza zostały wyczyszczone. Browser E2E pozostaje
odroczone zgodnie z decyzją użytkownika, a desktop end-to-end jest zablokowane
konkretną usterką dostarczenia URL przez launcher; nie wolno oznaczać go jako
ukończonego. Wcześniejsze uruchomienie po HTTP nadal prawidłowo kończy się
OpenIddict `ID2083`; nie wyłączano TLS ani nie zmieniano keychain.

### Front post-4S — Web build

Niezależny frontendowy `flutter build web --debug --no-tree-shake-icons` po 4S
zakończył się PASS w **98.7 s**; `flutter analyze` również pozostaje PASS.

## 3. Stan otwarty

- Szerokie, dotąd nieuruchomione bramki HTTP/integration poza zaakceptowanymi
  zakresami oraz pełne E2E nadal wymagają osobnych fixture’ów i dowodów.
- Pozostają pełne E2E token/session/revoke/realtime oraz walidacja platform
  Windows, macOS i Linux. Web debug build jest już PASS (**98.7 s**).
- Projekt jako całość pozostaje nieukończony; powyższe akceptacje są zakresowe.

## 4. Reguła aktualizacji

Każda kolejna zaakceptowana zmiana musi zostać opisana jednocześnie w tym planie
i w handoffie, a następnie skopiowana do obu repozytoriów i sprawdzona:

```bash
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-plan.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-plan.md
cmp /Users/przemyslawnowak/Desktop/dev/DevNote/Backend/docs/devplanner-standalone-refactor-handoff.md \
    /Users/przemyslawnowak/Desktop/dev/DevNote/Front/docs/devplanner-standalone-refactor-handoff.md
```

Nie commituj i nie pushuj bez wyraźnej dyspozycji użytkownika.

### R1/B0 — bezpieczne przywrócenie kompozycji rootu Frontu

Pakiet jest **częściowo zintegrowany**. Przywrócono wyłącznie dwa odzyskane,
produkcyjne porty kompozycji wymagane przez aktywny `DevPlannerApp` i router:
`lib/workspaces/presentation/chat/global_chat_composition.dart` oraz
`lib/workspaces/presentation/notifications/global_notifications_composition.dart`.
Nie włączono placeholderowej strony Workspaces, pliku runtime oznaczonego
`partial` ani pozornej obsługi Web SignalR/BFF. Scoped `flutter analyze` dla obu
plików i `dart format --output=none` zakończyły się PASS, a
`git diff --check` zakończył się PASS.

Pakiet nie zamyka odbudowy Workspaces: istniejące zależności domenowe i
realtime nadal importują `package:ready_next` i wymagają osobnych, małych
pakietów migracji do `package:devplanner`. Szczegóły, hash stagingu i dowody są
w `Front/docs/recovery/R1-B0-root-integration-report.md`.

### R1/B1a — foundation surface error/l10n

Pakiet zakończono częściowym PASS dla aktywnych standalone importerów poza
legacy grafem Workspaces. Bez fizycznego przenoszenia plików skierowano
potwierdzone importery do istniejących powierzchni
`package:devplanner/foundation/error/error.dart` oraz
`package:devplanner/foundation/l10n/l10n.dart`, które zachowują ten sam typ i
rozszerzenie lokalizacji. Zmieniono 7 deklaracji error i 5 deklaracji l10n w
admin, me oraz odpowiadających testach. Scoped analyzer tych źródeł i testy
`api_error` + admin zakończyły się PASS; `git diff --check` i formatowanie także
PASS.

Nie zmieniano auth, theme, transportu, root/router/runtime, Chat, Notifications
ani realtime. Importery Workspaces i legacy `core/data`/`features/settings`
pozostawiono do osobnego pionu, ponieważ ich kontrakty nadal używają
`package:ready_next` i zamiana samego typu błędu powoduje niezgodność `Either`.
Szczegóły oraz liczniki są w
`Front/docs/recovery/R1-B1a-error-l10n-report.md`.

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

Desktopowy shell renderuje nagłówek marki jako górną część lewej kolumny,
zamiast jako fragment pełnej belki nad sidebarem. Sidebar i jego nagłówek mają
więc wspólne, ciągłe tło gradientowe; prawa belka ma kompaktowe 40 px i zawiera
tylko kontekst modułu oraz akcje globalne. Nie zmieniono tras, composition,
portów, danych ani kontraktu Chat/Notifications. Typografia menu i kontekstu
belki używa lokalnego Intera 11 px, a marka 12 px. Globalny `ThemeData`
ustala spójne, mniejsze role tekstu i ikonę domyślną 18 px; nie dodano
skalowania tekstu, które omijałoby ustawienia dostępności systemu.

Odbiór: scoped analyzer PASS; shell oraz testy theme/typography **7/7 PASS**;
`flutter build macos --debug` PASS z istniejącym nieblokującym ostrzeżeniem
Swift Package Manager dla `media_kit_*`; `git diff --check` PASS. Manualny
odbiór z relaunchu desktopowego pozostaje następnym krokiem.

### 2026-09-19 — R3t: nowe drzewo lewego menu Workspace

Zatwierdzono nową implementację menu bez przywracania legacy UI: katalog
workspace'ów jest odczytywany przy starcie, a projekty są pobierane dopiero po
rozwinięciu konkretnej gałęzi. Błąd projektu pozostaje lokalny i nie usuwa
innych workspace'ów. Shell otrzymał wąski kontrakt tworzenia workspace'u,
odświeżenie katalogu i przejście na nową przestrzeń po sukcesie.

Kanoniczne trasy Lista/Kanban/Files, polityki Backend oraz globalne overlaye
Chat/Powiadomienia nie zmieniły się. Pionów Whiteboard/Wiki/Corkboard/
Automations nie dodano jako klikalnych placeholderów.

### 2026-09-19 — R3u: globalna gęstość i typografia nawigacji

Po ręcznym porównaniu z referencją Gmail-inspired ustalono jeden kontrakt
geometrii dla nawigacji: rozwinięty sidebar ma 224 px, zwinięty 56 px,
nagłówek 56 px, a wiersz menu 28 px. `DevPlannerNavigationTheme` jest
rozszerzeniem globalnego `ThemeData` i publikuje także rozmiar ikon 18 px,
tekst wiersza Inter 12 px, etykietę sekcji 11 px, wcięcie drzewa 16 px oraz
promień zaznaczenia 14 px.

Shell, katalog workspace'ów, ulubione workspace'y, drzewa rozwijane i gałęzie
zasobów korzystają z tych samych tokenów. Aktywny element zachowuje tylko
delikatne tło — usunięto dodatkowe obramowania i dekoracyjne kafelki ikon z
nawigacji. Prywatna sekcja katalogu nie otrzymuje już osobnej ramki, dzięki
czemu hierarchię tworzą wcięcia i nagłówki, a nie zagnieżdżone kapsuły. Nie
zmieniono tras, danych, portów ani kontraktów API.

### 2026-09-19 — UX-A1: audyt i plan domknięcia Listy/Kanbanu

Audyt kodu, historii `d1cc273..eda6e56` oraz kontraktów Backend potwierdził
regresję kompozycji w `TasksBoardRoutePage`: pełny `TasksBoardPage` jest
montowany wyłącznie dla literalnego `view=kanban`, a domyślna Lista oraz
`board/list/timeline/workload/recurrence` omijają wspólny nagłówek, przełącznik
widoków, saved views, akcje projektu i lifecycle realtime. Istniejący test route
page utrwala ten split. Pierwszy pakiet naprawczy musi zawsze montować jeden
pełny host Tasks i ustalić `/tasks` jako Listę oraz `?view=kanban` jako Kanban.

Audyt potwierdził również trzy konkurencyjne systemy menu, brak parytetu akcji
Lista/Kanban, zbyt małą globalną typografię interaktywną, hardkodowane
powierzchnie Tasks oraz martwe pozycje modułów bez aktywnej trasy. Nie wolno
przepisywać Backend: większość funkcji Tasks/Kanban ma już typed klienty,
repozytoria i UI; problemem jest kompozycja, discoverability i spójność.

Plan wykonawczy, kolejność pakietów, ownership agentów, bramki oraz Definition
of Done zapisano w
`Front/docs/recovery/tasks-list-kanban-ux-recovery-plan.md`. Decyzja produktowa:
bez pośredniego ekranu „Przegląd”; kliknięcie projektu prowadzi bezpośrednio do
Zadań. Ten pakiet nie zmienia runtime ani nie jest odbiorem GUI/E2E.

### 2026-09-19 — UX-T0: jeden host Tasks i kontrakt trasy

Pakiet T0 z planu domknięcia Listy/Kanbanu wykonany. `TasksBoardRoutePage`
montuje zawsze ten sam `TasksBoardPage`, a `?view=` nie może już wybrać innego
ekranu. Nowy kanoniczny kontrakt widoku
(`lib/workspaces/presentation/tasks/tasks_project_view_contract.dart`) ustala
`/tasks` jako Listę, `?view=kanban` jako Kanban i zachowuje `board` jako alias
wejściowy; `?view=` buduje wyłącznie
`DevPlannerRouteCatalog.projectTasksView`. Sidebar porównuje ścieżkę i widok z
adresu, wiersz projektu prowadzi bezpośrednio do Listy, a drzewo nie renderuje
już pośredniego „Przeglądu” (widok `/workspaces` pozostaje fallbackiem `/`).

Bramki: pełny `flutter test` **884/884 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Pełne pliki, decyzje i ograniczenia opisuje
wpis UX-T0 w `docs/devplanner-standalone-refactor-handoff.md`. Nie zmieniano API
ani UI tabeli i boardu; brak odbioru GUI/E2E. Kolejne pakiety: T1, T2.

### 2026-09-19 — UX-T1: tokeny Tasks i podłoga typografii

Powstał `DevPlannerTasksTheme` w `lib/foundation/theme/tasks_theme.dart` z jedną
skalą dla całego modułu Tasks (typografia 13/18, 12/16 w600, 11/16, 14/20 w600,
15/20 w600; geometria wierszy 36–46 px; odstępy 4/8/12/16/24; promienie 8/8/12;
powierzchnie canvas/command bar/karta/menu/bulk bar oraz role akcentu, cienia
i scrimu). Globalne `labelMedium` i `labelSmall` podniesiono z 10 px do 12 i 11
px, a w aktywnym Tasks zniknęły wszystkie lokalne rozmiary poniżej 11 px i
wszystkie `Colors.white`/`Colors.black` oraz ręczne tło kanwy.

Bramki: pełny `flutter test` **913/913 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty; odświeżone trzy goldeny Kanbanu. Pełny opis
decyzji i ograniczeń: wpis UX-T1 w
`docs/devplanner-standalone-refactor-handoff.md`. Kolejne pakiety: T2, T3.

### 2026-09-19 — UX-T2: jedna infrastruktura menu

Jeden publiczny komponent `AppContextMenu` zastąpił `TaskContextMenu`,
`WorkspaceContextMenu` i warianty `flat`/`glass`. Powstał
`DevPlannerMenuTheme` (`lib/foundation/theme/menu_theme.dart`) z jedną
powierzchnią (wiersz 32 px, ikona 16 px, tekst 13 px, promień 8 px), a komponent
obsługuje sekcje, skróty, `selected`/`disabled`/destructive, prawy klik
(`AppContextMenuRegion`), klawiaturę (strzałki, Home, End, Enter, Space, Escape)
oraz powrót focusu do aktywatora. Zmigrowano 48 wywołań w 22 plikach Tasks;
pickery przyjmują globalny `Offset`, a edytor czasu zadania używa wspólnej
powierzchni zamiast własnego dialogu.

Bramki: pełny `flutter test` **929/929 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Pełny opis, lista testów i pozycje
pozostawione do T4/T6: wpis UX-T2 w
`docs/devplanner-standalone-refactor-handoff.md`. Kolejny pakiet: T3.

### 2026-09-19 — UX-T3: wspólny dwurzędowy nagłówek zadań

Nagłówek przeniesiony do neutralnego `lib/workspaces/presentation/tasks/header/`
i przemianowany na `TasksHeader`; moduł montuje publiczny komponent, więc Lista
i Kanban dzielą ten sam chrome. Układ jest zawsze dwuwierszowy na tokenach
`DevPlannerTasksTheme`: wiersz kontekstu 44–48 px (projekt, licznik, zakładki,
obecność, menu projektu, CTA) oraz wiersz poleceń 36–40 px (zapisane widoki,
akcje widoku, a po zaznaczeniu jeden kontekstowy pasek akcji masowych). API
nagłówka nie zna już `GoRouter` — nawigację po wyjściu z projektu dostarcza
trasa przez `onProjectExited`.

Bramki: pełny `flutter test` **934/934 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty, golden nagłówka odświeżony. Testy obu widoków
dla 360/768/1024/1440/1920 px oraz dowód wspólnego chrome na poziomie trasy.
Kolejne pakiety: T4 (domknięcie Listy) i T5 (domknięcie Kanbanu).

### 2026-09-19 — UX-T4: domknięcie Listy

Filtry, sortowanie, grupowanie i kolumny Listy przeniesione do drugiego wiersza
wspólnego nagłówka (`chrome/task_list_command_bar.dart`), a pływający pasek akcji
masowych zastąpiony paskiem w tym samym wierszu
(`bulk/task_list_bulk_bar.dart` po przepisaniu na tokeny i `AppContextMenu`).
Stan Listy tworzy `chrome/task_list_chrome_host.dart` ponad nagłówkiem, więc
wiersz poleceń i tabela korzystają z jednego źródła. W Listnie nie ma już
surowych `PopupMenuButton` od filtrów ani drugiego paska nad treścią.

Bramki: pełny `flutter test` **940/940 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Dowody i pozycje pozostawione do T6: wpis
UX-T4 w `docs/devplanner-standalone-refactor-handoff.md`. Kolejny pakiet: T5.

### 2026-09-19 — macOS: stabilny podpis debugowej sesji Keychain

Debug i Profile targetu `Runner` nie dziedziczą już podpisu ad-hoc. Są ręcznie
podpisywane stałym lokalnym certyfikatem Apple Development; podpis ma niezmienne
wymaganie kodu dla `com.excellent.devplanner`. Desktopowy refresh token nadal
pozostaje wyłącznie w zwykłym macOS Keychain
(`usesDataProtectionKeychain: false`); nie włączono sandboxowych entitlements,
bo lokalny account nie ma provisioning profile dla tego bundle identifier.

Dowody: `flutter build macos --debug`, `codesign --verify --deep --strict` oraz
targeted auth suite **8/8** są PASS. Kontrola podpisu potwierdza authority Apple
Development i TeamIdentifier zamiast poprzedniego Signature=adhoc. Pierwsze
uruchomienie nowego artefaktu odtworzyło sesję i workspace bez promptu Keychain.
Pełne `flutter analyze` pozostaje obecnie zablokowane przez niezwiązane, brudne
zmiany w `tasks_board_bulk_bar_test.dart`; nie jest raportowane jako PASS.

### 2026-09-19 — UX-T5: domknięcie Kanbanu i wspólny pasek akcji

Pasek akcji masowych Kanbanu korzysta z tego samego komponentu co Lista
(`tasks/bulk/tasks_contextual_bulk_bar.dart`, `TasksContextualBulkBar` z
`TasksBulkButton`/`TasksBulkMenu`), więc drugi wiersz chrome jest jeden dla obu
widoków. Kanban obsługuje z niego przeniesienie zaznaczonych kart między
kolumnami, priorytet i termin; Lista zachowuje swój szerszy zestaw akcji z
selekcją całego wyniku. Pasek Listy przepisany na ten sam komponent, a nazwy
pomocników nagłówka odkanbanowione.

Paginacja kolumn, zwijanie kolumn, DnD z korektą indeksu, blokada workflow,
rollback 409 z komunikatem oraz resync realtime są potwierdzone istniejącymi
testami w `test/workspaces/presentation/tasks/tasks_board_cubit_test.dart`;
nowy test `test/.../board/tasks_board_bulk_bar_test.dart` dowodzi podłączenia
bulk move do wspólnego paska.

Bramki: pełny `flutter test` **941/941 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Kolejny pakiet: T6.

### 2026-09-19 — AUTH-AUDIT: plan domknięcia sesji desktopowej

Audyt przepływu Desktop PKCE, refresh, REST, SignalR, revoke i podpisu macOS
potwierdził poprawny fundament, ale wykrył otwarte luki produkcyjne: brak
runtime refresh/retry po 401, możliwość błędnego użycia refresh vaulta jako
źródła Bearera, zapis zrotowanego credentialu dopiero po `/me`, brak
single-flight wspólnego dla REST i SignalR, połowiczny kontrakt OIDC oraz brak
pełnego dowodu natychmiastowego revoke access tokena i aktywnego SignalR.

Plan wykonawczy A0–F1 zapisano w
`Front/docs/recovery/desktop-auth-session-hardening-plan.md`. Ustala on kolejno:
testy charakterystyczne, bezpieczny porządek rotacji, jeden koordynator tokenów,
pojedynczy retry REST, wspólny lifecycle SignalR, backendową walidację sesji,
revoke połączeń wielohostowych, domknięcie kontraktu OAuth/OIDC, odporność
callbacku, przenośny podpis developerski, podpis/notarization Release oraz
macierz live E2E. Ten pakiet jest wyłącznie dokumentacją; nie zmienia runtime i
nie oznacza żadnej z luk jako naprawionej.

### 2026-09-19 — AUTH-A1: trwała rotacja przed pobraniem profilu

Desktopowy transport PKCE zwraca teraz mały wynik tokenowy (`accessToken`,
`refreshToken`, `expiresIn`), a nie miesza exchange z pobraniem `/api/v1/me/`.
`DesktopPkceAuthAdapter` zapisuje nowy refresh token do OS vault przed
pobraniem profilu. Przejściowy błąd `/me` po prawidłowej rotacji nie pozostawia
więc w vault zużytego poprzednika. Jeżeli zapis vaulta zawiedzie, adapter
best-effort revokuje nowo wydany token i nie publikuje sesji.

Nie zmieniono Web BFF, PKCE, endpointów ani backendowego lifecycle tokenów.
Dowody Front: targeted `flutter test test/auth --reporter compact` **29/29
PASS**; scoped `flutter analyze` sześciu plików auth/testów: **No issues
found**; scoped `git diff --check`: PASS. Nie uruchamiano pełnego analyzera ani
realnego desktop E2E. Następny pakiet: A2 — wspólny koordynator single-flight.

### 2026-09-19 — UX-T6: martwe pozycje drzewa, ostatnie menu i dostęp do nawigacji

Drzewo renderuje wyłącznie pozycje z aktywną trasą: Automatyzacje, Whiteboardy,
Tablica korkowa i Wiki zniknęły z projektu do czasu własnych tras, a projekt
pokazuje Zadania (Lista, Kanban) i Pliki; kontrakt zasobów opisuje ten stan.
Ostatnie surowe `PopupMenuButton` w Tasks przeszły na wspólne `AppContextMenu`
(menu zapisanych widoków z dwustopniowym zarządzaniem, wielokrotny wybór pola
niestandardowego w szczegółach). Nie dodano żadnego endpointu.

Dodatkowo domknięto problem z audytu: po zwinięciu paska bocznego na wąskim
oknie (<960 px) drzewo było nieosiągalne — teraz ten sam klawisz otwiera je
w nakładce nad treścią.

Bramki: pełny `flutter test` **945/945 PASS**, `flutter analyze` **No issues
found**, `git diff --check` czysty. Pozostaje T7: odbiór live z Backendem.

### 2026-09-19 — UX-T7 (częściowo): buildy i żywy Backend, GUI NOT RUN

Wykonane bramki: `flutter build web --wasm` PASS, `flutter build macos --debug`
PASS, `flutter analyze` bez uwag, pełny `flutter test` **945/945 PASS**,
`git diff --check` czysty w obu repozytoriach. Lokalny stos backendu (PostgreSQL
na 5440, Redis, MinIO, Mailpit, ClamAV, OnlyOffice) działa, API wstało przez
`Backend/start-local.sh` na porcie 5072 i wystawia 350 ścieżek OpenAPI; endpointy
`tasks/groups`, `kanban`, `me/tasks` oraz negocjacje hubów SignalR
`/api/v1/realtime/{tasks,chat,notifications}/negotiate` zwracają 401 bez tokenu,
co potwierdza żywy kontrakt i wymóg sesji.

NOT RUN bez przedstawiania jako sukces: scenariusz live GUI (create → inline edit
→ details → List ↔ Kanban → DnD → bulk → saved view → restart), dwa konta
i revoke, pomiary PostgreSQL po mutacjach, screenshoty 1024×768 / 1440×900 /
1920×1080 w light/dark oraz `flutter build windows` i `flutter build linux`
(brak hosta).

### 2026-09-19 — UX-T7 zamknięcie sesji: PASS na buildach i kontrakcie live, GUI odroczone

Decyzją właściciela w tej sesji nie wykonujemy fizycznych testów GUI, więc T7
pozostaje nieodebrany. Potwierdzone: `flutter build web --wasm` PASS,
`flutter build macos --debug` PASS, `flutter analyze` bez uwag, pełny
`flutter test` **952/952 PASS**, `git diff --check` czysty w obu repozytoriach,
żywy stos backendu z 350 ścieżkami OpenAPI i 401 na endpointach Tasks/Kanban
oraz negocjacjach hubów SignalR. Dodatkowo domknięto ostatnią lukę w testach
automatycznych kroku „inline edit”: rollback nie-konfliktowego błędu przywraca
poprzednią wartość wiersza i pokazuje komunikat przy tym wierszu.

Odroczone: scenariusz GUI, dwa konta z revoke, screenshoty trzech rozdzielczości
w light/dark. NOT RUN: `flutter build windows`, `flutter build linux` (brak
hosta). Runbook dokończenia: sekcja T7 w
`docs/recovery/tasks-list-kanban-ux-recovery-plan.md`.

### 2026-09-19 — UX-T7: zrzuty Listy i Kanbanu z realnej kompozycji

Odbiór GUI pozostaje odroczony decyzją właściciela, więc przygotowano materiał do
przeglądu bez uruchamiania aplikacji: `docs/recovery/visual-captures/` zawiera
12 czytelnych obrazów (Lista i Kanban × 1024×768, 1440×900, 1920×1080 ×
light/dark) wygenerowanych przez `tasks_visual_capture_test.dart` z tego samego
widgetu trasy, w motywie produktu i z załadowanymi fontami. Test pilnuje też
braku przepełnień na tych rozdzielczościach. To nie jest odbiór E2E — obrazy
pochodzą z renderu widgetów z fixture'em, nie z aplikacji na żywym Backendzie.

Bramki po zmianie: `flutter analyze` **No issues found**, pełny `flutter test`
**964/964 PASS**, `git diff --check` czysty.

### 2026-09-19 — AUTH-E1: przenośny podpis developerski macOS

Debug i Profile używają teraz `macos/Runner/Configs/Signing.xcconfig`; wersjonowana
konfiguracja zawiera wyłącznie ogólną politykę, a ignorowany
`Signing.local.xcconfig` zawiera lokalną tożsamość podpisu. Repozytorium nie
utrwala common name certyfikatu ani Team ID. Dwa kolejne buildy Debug miały ten
sam designated requirement i przeszły `codesign --verify --deep --strict`.

Na tej maszynie nie ma macOS provisioning profile dla
`com.excellent.devplanner`, więc sandboxowy podpis Release/notarization (E2)
pozostaje celowo otwarty; nie jest oznaczony jako PASS.

### 2026-09-19 — AUTH-A2–D1, B1–B2, C1: lifecycle desktopowej sesji

Desktopowy access token jest wyłącznie pamięciowy i odświeżany single-flight;
REST wykonuje najwyżej jeden retry po 401, a SignalR pobiera token z tego samego
providera. Refresh credential nigdy nie jest źródłem Bearera. Nowy refresh jest
zapisywany przed `/me`; `invalid_grant` usuwa credential, a awarie sieciowe go
zachowują. Desktopowy callback OAuth ignoruje obce żądania, ma limity i
timeouty, a desktop żąda wyłącznie `offline_access devplanner.api`.

Backend ustanawia 10-minutowy lifetime access tokena i waliduje aktywność
device session przy każdym desktopowym bearerze. Revoke po commit zrywa
połączenia Tasks, Chat, Wiki, Whiteboard i Notifications dla konkretnej sesji;
rejestr używa Redis dla wielu hostów. Targeted Front auth/HTTP/realtime tests,
Backend identity/realtime tests oraz realny test dwóch registry przez Redis
przeszły. Pełne E2E F1 pozostaje otwarte.

### 2026-09-19 — AUTH-A4: logout offline fail-closed

`AuthUseCases.signOut()` kończy widoczną sesję w `finally`, także gdy zdalny
revoke nie odpowie. Credential jest już czyszczony przez adapter, a router i
runtime otrzymują signed-out, więc nie mogą utrzymać starych REST/SignalR UI.
Nowy test potwierdza wyjątek revoke i jednocześnie stan signed-out.

### 2026-09-19 — Audyt parytetu Listy/Kanbanu i plan naprawy N0–N7

Przegląd kodu Front i Backend po odbiorze T7 wykazał, że Lista i Kanban mają
różne zestawy filtrów, ustawienia boardu (WIP, ukryte kolumny, gęstość, pola
karty) istnieją od kontraktu po Cubit, ale nie mają żadnego UI, a dwa elementy
interfejsu wymagają naprawy: nawigacja w modalu ustawień jest wyśrodkowana
(`TextButton.icon` bez `alignment`), a menu zapisanego widoku ma zdublowane
pozycje i drugie menu zakotwiczone w triggerze. Modal ustawień pracuje też na
historycznym `core/theme`/`core/l10n` (37 plików) i twardych stringach poza ARB.

Plan naprawy z pakietami N0–N7, listą delt Backendu (jedyna zmiana kontraktu to
opcjonalne filtry `GET /kanban`) oraz bramkami zapisano w
`docs/recovery/tasks-parity-and-ui-repair-plan.md`; kopia jest w Backendzie
(`cmp` identyczny).

### 2026-09-19 — N8: bezpieczny zapis ustawień widoku i wspólna powierzchnia błędów

Zgłoszenie właściciela (konflikt preferencji Kanbana przenosi pola ze starego
snapshotu, błędy Listy są maskowane poza arkuszem kolumn, błąd Kanbana ma tylko
nietrwały SnackBar, nieudany odczyt preferencji ginie w pustym handlerze, a błąd
ustawień tablicy przeładowuje Listę) domknięte w jednym pakiecie bez zmiany
zakresu T0–T7.

Kanban: `TasksBoardPreferenceCommands` trzyma kolejkę intencji i jedną pętlę
zapisu. Intencja opisuje wartość docelową, a nie różnicę, więc po konflikcie jest
nakładana na świeży snapshot z Backendu — ponowienie nie przenosi już
nieaktualnych pól, których użytkownik nie ruszył (dowód: nowy test
„ponowienie po konflikcie nie nadpisuje równoległej zmiany w innym polu").
Kliknięcia zgłoszone w trakcie zapisu trafiają do kolejnej partii zamiast zostać
odrzucone, a po udanym zapisie szybkiego filtra tablica wraca po świeży zestaw
kart. Po drugim konflikcie automatyczne ponawianie się zatrzymuje, intencja
zostaje widoczna i zaparkowana, a „Ponów" ponawia ją — nie odświeżony stan
serwera.

Lista: jedna szeregowana ścieżka zapisu (sortowanie i grupowanie nie mają już
własnej, omijającej kolejkę), a po konflikcie `mergeTaskListPreferences` scala
trzy strony — świeży stan serwera, ostatni potwierdzony zapis i draft — per pole,
z szerokościami kolumn scalanymi per kolumna. Draft użytkownika zostaje i jest
ponawiany, zamiast zostać porzucony przez `load()`.

Błędy: `TasksErrorBanner` + `TasksErrorBannerHost` pod nagłówkiem modułu Tasks
pokazują trwały komunikat z „Ponów", „Odśwież" i `traceId` dla Listy i Kanbana;
`mutationSerial` rozdzielono na `taskDataRevision` (rośnie tylko przy zmianie
danych zadań) oraz `TasksViewError? error` (bez licznika), dzięki czemu nieudany
zapis ustawień Kanbana nie każe Liście przeładowywać danych, a nieudany odczyt
preferencji przestaje być ignorowany.

Backend: nowe `TaskListVersionConflictException` i
`TaskListPolicyVersionConflictException` (strażnicy wersji w encjach rzucają je
zamiast `DbUpdateConcurrencyException`) mapowane w middleware na
`task_list.version_conflict` i `task_list.policy_version_conflict`; klient
rozpoznaje konflikt po stabilnym kodzie, a sam HTTP 409 zostaje jako zapas.
Komunikaty konfliktu Kanbana mówią „w innej sesji".

Bramki: `flutter gen-l10n` ok; `flutter analyze lib` i `flutter analyze test` —
No issues found; `flutter test --timeout 180s` — 1017/1017 PASS;
`flutter build web --wasm` — PASS; `flutter build macos --debug` — PASS
(`✓ Built build/macos/Build/Products/Debug/DevPlanner.app`);
`dotnet build veloryn-workspaces.csproj` — 0 ostrzeżeń, 0 błędów; testy Backendu
celowane (TaskList + macierz HTTP) — 18/18 PASS; pełna suite Backendu — 1156 PASS,
7 FAIL, 4 SKIP, gdzie wszystkie 7 to zastane `MeEndpointsTests` (potwierdzone
`git stash` moich zmian i tym samym wynikiem 7/17 na wersji bez N8);
`git diff --check` czysty w obu repozytoriach; `cmp` planu, handoffu i planu
parytetu w obu repozytoriach — identyczne. Kontrola mutacyjna: cofnięcie kodów
w middleware na `workspace.conflict` wysyła nowy test HTTP na czerwono, po
przywróceniu pliku wraca zieleń.

NOT RUN i dlaczego: Release macOS (lokalny Keychain nie ma profilu
provisioning dla `com.excellent.devplanner` — stan zastany, AUTH-E2), buildy
Windows/Linux (brak hosta) oraz live test dwóch sesji z widocznym komunikatem —
odroczony do wdrożenia nowej wersji Backendu przez właściciela.

Trzy testy pilnowały starego zachowania i zostały świadomie przepisane:
`UserPreferenceConcurrencyThrowsDbUpdateConcurrencyExceptionOnConflict` (Backend:
ogólny wyjątek → stabilny kod), „drugi konflikt preferencji pokazuje błąd
i zostawia stan serwera" oraz „autosave przy błędzie 409 conflict automatycznie
odświeża stan" (Front: porzucenie intencji → scalenie i zachowanie draftu).

### 2026-09-19 — N9: audyt transportu i stanu operacyjnego (P0 w odzyskiwaniu sesji)

Cztery defekty zgłoszone przez właściciela po odbiorze N8, z czego pierwszy
wyjaśnia pierwotną przyczynę raportowanych konfliktów Kanbana.

Transport desktopowy ponawiał **każde** żądanie: `onResponse` bezwarunkowo wołał
`_retryUnauthorized`, a jego bramka nie sprawdzała statusu. Ponieważ ten klient
akceptuje każdy status (`validateStatus: (status) => status != null`), także
odpowiedź 200 przechodziła przez `onResponse`, więc odzyskiwanie odświeżało token
i `_dio.fetch` powtarzał udane żądanie. Dla `PUT /kanban/preferences` pierwszy
zapis się udawał, a replay wysyłał to samo `expectedVersion`, które pierwsze
żądanie już zużyło — Backend słusznie odpowiadał 409, a klient raportował konflikt
na żądaniu, które się powiodło. Dotyczyło to każdego POST/PATCH/PUT/DELETE, więc
możliwe były podwójne operacje biznesowe. Warunek jest teraz dokładny:
`_retryUnauthorized` przyjmuje `statusCode` i wychodzi, gdy to nie 401;
`onResponse` podaje `response.statusCode`, a `onError` `error.response?.statusCode`
(błąd sieci bez statusu nie uruchamia odzyskiwania).

Błąd zapisu Listy cofał zmiany wykonane w trakcie żądania: `_publishFailure`
emitowało snapshot sprzed żądania, a pętla autosave kasowała `_hasPendingSave`,
więc zmiana zgłoszona podczas nieudanego zapisu znikała ze stanu i z kolejki.
Błąd jest nakładany na bieżący stan, a przy konflikcie bieżący draft przechodzi
przez to samo scalenie co zapis — świeże wartości serwera dla pól, których
użytkownik nie ruszył, jego zmiany zachowane. `_lastSaved` pozostaje ostatnim
potwierdzonym zapisem (baseline scalenia), a świeżą wersję niesie stan, więc
ponowienie używa właściwego `expectedVersion`.

Odczyt tablicy gubił stan operacyjny: `TasksBoardRuntimeCoordinator.load()`
budowało `TasksBoardReady` od zera i nie przenosiło `error`, `savingUserPreference`,
`taskDataRevision`, `pendingTaskIds`, `selectedTaskIds`, `loadingColumnKeys`,
`columnLoadErrors` ani `isBulkSaving`, więc niezwiązany resync po realtime mógł
ukryć banner niezapisanej preferencji. Odczyt aktualizuje istniejący stan przez
`copyWith(board:, filter:)`. Ujawniony dług: zaznaczenie po operacji masowej
czyściło się tylko jako skutek uboczny przebudowy — `_completeBulk` czyści je
teraz jawnie.

Log zdradzał ciało odpowiedzi: `api_repository.dart` wypisywał pierwsze 800
znaków dowolnego ciała błędu na wszystkich endpointach, także logowania,
odzyskiwania konta i aktywacji. Log podaje teraz kształt (`debugResponseShape`):
nazwy pól, liczbę elementów albo rozmiar tekstu — nigdy wartości.

Bramki: `flutter analyze lib test` — No issues found; `flutter test --timeout 180s`
— 1024/1024 PASS; `flutter build web --wasm` — PASS; `flutter build macos --debug`
— PASS; `git diff --check` czysty w obu repozytoriach; `cmp` dokumentów —
identyczne. Kontrola mutacyjna: bez bramki 401 padają oba nowe testy transportu,
bez zachowania bieżącego stanu pada test zmiany w trakcie zapisu, bez
`copyWith` w `load()` pada test resyncu tablicy.

Nowe testy: transport +2 (udana odpowiedź bez odzyskiwania i bez replay;
odpowiedź inna niż 401 bez odzyskiwania), Cubit Listy +1, Cubit Kanbana +1,
`test/core/data/api_repository_logging_test.dart` (3 przypadki).

NOT RUN bez zmian: live test dwóch sesji (czeka na wdrożenie nowej wersji
Backendu), Release macOS (brak profilu provisioning), buildy Windows/Linux
(brak hosta).

### 2026-09-19 — N10: enumy query/path, globalna diagnostyka HTTP i binding 400

- [x] Front nie wysyła już dartowych nazw enumów (`todo`, `inProgress`,
  `high`) ani obiektów enumów Retrofit w query/path. Jawne wartości kontraktowe
  PascalCase obejmują Tasks, Kanban, Notifications i kontekst dashboardu.
- [x] Audyt wszystkich deklaracji Retrofit `@Query`/`@Path` nie wykazuje już
  nieprymitywnych enumów; audyt mapperów transportowych nie wykazuje
  `status/priority/category/context/groupBy/involvement?.name`.
- [x] Aktywny `DevPlannerHttpTransport` ma jeden debugowy logger request,
  response i error z URL/query, statusem, czasem, nagłówkami i bezpiecznym
  opisem body. Bearer, cookies, CSRF, tokeny, hasła i dane wyszukiwania są
  redagowane; sukcesy nie zrzucają wartości DTO, a błędy pokazują wyłącznie
  `code`, `message`, `traceId` i nazwy pól.
- [x] Backend wymusza `RouteHandlerOptions.ThrowOnBadRequest`, dzięki czemu
  błędy bindera Minimal API trafiają również w Production do wspólnego
  `ApiExceptionMiddleware` zamiast zwracać puste 400.
- [x] Walidacja pakietu: backend build 0/0; backend targeted 2/2 PASS; frontend
  targeted 13/13 PASS; scoped `flutter analyze` bez problemów.
- [ ] Pełne suite/buildy platformowe pozostają poza tą punktową naprawą; ich
  wcześniejszy stan i niezależne blokady opisują N8/N9.
### 2026-09-19 — audyt nawigacji produktu i kreatora projektu

Audyt Front/Backend potwierdził, że Lista i Kanban są już dwoma widokami jednego
modułu Tasks, a ich rozdzielenie w drzewie jest wyłącznie decyzją prezentacyjną.
Backend ma pin/hide/order, archive/restore, szablony projektów i workflow oraz
rozbudowane funkcje Tasks, ale część nie jest osiągalna z aktywnego UI.

Wykryte luki kontraktu: brak listy archiwalnych projektów, brak `isHidden` w
`ProjectListItemResponse`, brak transferu projektu między workspace’ami, brak
publicznej `version/expectedVersion` mimo deklarowanej ochrony `xmin` oraz brak
atomowego, idempotentnego polecenia dla konfigurowalnego kreatora.

Plan P0–P8 zapisano w
`docs/recovery/product-navigation-and-project-wizard-refactor-plan.md`. Ustala
jeden węzeł Zadania z przełącznikiem Lista/Kanban, wspólne menu projektu,
optimistic UI z precyzyjnym rollbackiem i trwałym błędem, atomowy kreator z
preview oraz osobną decyzję dla transferu cross-workspace. §4.3 dodaje matrycę
Backend → adapter → stan → UI → test z rzeczywistymi ścieżkami i ujawnia piony
bez UI (capacity, schedule, kanban i workflow settings, kaskada harmonogramu)
oraz kontrakty bez konsumenta (`PUT /tasks/order`,
`PUT /projects/preferences/order`, `GET /tasks/search`). Ten pakiet jest
wyłącznie dokumentacją; nie zmienia runtime ani kontraktów API.

### 2026-09-19 — PN-P2: jeden węzeł Zadania, routing i preferencja widoku

- Drzewo ma jedną pozycję `Zadania` na projekt; `taskList` i `kanban`
  zniknęły z enuma, z drzewa i ze switchy shella. Projekt i jego pozycja
  `Zadania` prowadzą do tego samego `/tasks`, a gałąź z zaznaczonym dzieckiem
  nie podświetla się drugi raz.
- Wybór widoku modułu jest porównywany z adresem tylko wtedy, gdy adres
  wskazuje `?view=` jawnie; `/tasks` obejmuje wszystkie widoki modułu.
- Legacy linki `/tasks/list` i `/tasks/kanban` przekierowują na kanoniczne
  `?view=`, a trasa szczegółu zadania nie przechwytuje już `/tasks/list` jako
  `taskId`.
- „Ostatnio używany widok” to lokalna preferencja (port
  `TasksProjectViewPreferenceStore` + adapter `shared_preferences`) wczytywana
  raz przy starcie routera; odczyt jest synchroniczny, więc `/tasks` nie mruga
  Listą przed Kanbanem.
- Przepisane testy, które pinowały rozdzielone gałęzie:
  `workspace_navigation_foundation_test`, `workspace_navigation_tree_cubit_test`,
  `devplanner_shell_test` (selekcja i drzewo), `devplanner_root_router_compile_test`.
- Nowe testy: redirecty legacy, powrót do ostatniego widoku, wczytywanie
  i zapis preferencji oraz zachowanie przy braku implementacji persistence.
- Walidacja: `flutter analyze` — No issues found; dotknięte obszary 72/72 PASS;
  pełny `flutter test` 1039/1039 PASS.

### 2026-09-19 — PN-P5: jeden formularz tworzenia projektu

- Sidebar otwiera ten sam `CreateProjectDialog` co drzewo projektów;
  uproszczony `_CreateProjectFromSidebarDialog` został usunięty.
- Port `ProjectManagementGateway` i jego adapter zniknęły, bo obsługiwały
  wyłącznie ten drugi flow; shell dostaje pełne repozytorium projektów.
- Web BFF nadal nie wystawia akcji tworzenia (brak klienta API), bez zmiany
  zachowania. Kreator wieloetapowy pozostaje w P5b i wymaga kontraktu P4.
- Walidacja: `flutter analyze` — No issues found; testy shella 8/8 PASS,
  w tym nowy przypadek „sidebar opens the same project form as the project tree”.

### 2026-09-19 — PN-P6a: kaskada harmonogramu w stanie

- Preview i apply kaskady wyszły z widgetu do `TaskScheduleCascadeCubit`
  (`detail/cascade/cubit/`); widget przekazuje wyłącznie intencje i daty.
- Zapis bez podglądu jest odrzucany w cubicie, bo kontrakt wymaga
  `expectedVersion` każdego przesuwanego zadania.
- Nowy zestaw 6 testów: sukces podglądu, błąd podglądu, brak podglądu przy
  zapisie, wysłanie wersji, konflikt 409 z zachowanym podglądem, czyszczenie
  podglądu po zmianie dat.
- Walidacja: `flutter analyze` — No issues found; zestaw kaskady 6/6 PASS;
  testy prezentacji Tasks 421/421 PASS.

### 2026-09-19 — N10-followup: testy pinujące starą serializację enumów

Pięć testów nadal oczekiwało dartowych nazw pól (`inProgress`, `blocked`,
`critical`), które pakiet N10 zastąpił wartościami kontraktowymi. Asercje
przepisano na `wireValue` enuma, żeby pilnowały poprawnego kontraktu zamiast
wadliwego: `task_list_chrome_test` (2 przypadki) i
`project_tasks_list_cubit_test` (3 przypadki). Walidacja: oba pliki 60/60 PASS,
pełny `flutter test` bez czerwonych.

### 2026-09-19 — PN-P3: jedno menu projektu, optimistic-first z rollbackiem

- Drzewo projektów ma jedno menu kontekstowe (Otwórz, Przypnij/Odepnij, Ukryj
  dla mnie, Zmień nazwę i wygląd, Ustawienia, Utwórz szablon z projektu,
  Archiwizuj z potwierdzeniem, Przywróć, Usuń trwale po wpisaniu nazwy).
- `Przenieś do workspace` i `Opuść projekt` są jawnie wyłączone z powodem —
  brak kontraktu §6.4 i reguły ostatniego Ownera; nic nie udaje działającej
  funkcji.
- Pin/hide/order/lifecycle działają optimistic-first: jedno żądanie na projekt,
  scalanie intencji do ostatniej wartości, rollback wyłącznie pól własnej
  operacji (i tylko gdy rewizja pola się nie zmieniła), pełna lista w DnD,
  trwały baner błędu z kodem i `traceId`.
- Nowy stan drzewa rozbity po odpowiedzialnościach: fasada `ProjectsTreeCubit`
  plus kontrolery preferencji, kolejności i cyklu życia; produkcyjne pliki
  zmieściły się poniżej progu §9.4 po podziale.
- Walidacja: `flutter analyze` (cały projekt) — No issues found; zestawy
  `workspaces_home` i `projects` — 63/63 PASS (w tym 31 w `projects_tree/`);
  `flutter gen-l10n` bez ostrzeżeń.
- Otwarte: wpięcie drzewa w żywy shell i pełna lista archiwum (czeka na P1).

### 2026-09-19 — PN-P1: backend list/lifecycle/version/capabilities

- `GET /projects` przyjmuje `state=active|archived|all` oraz
  `visibility=visible|hidden|all`; `includeHidden` zostaje wspierany jako
  przestarzały alias (`true` → `visibility=all`) i jest tak opisany w OpenAPI.
- `ProjectListItemResponse` publikuje `isHidden`, `version` i `capabilities`,
  `ProjectResponse` — `version` i `capabilities`; nowy
  `ProjectCapabilitiesResponse` niesie `canManage`, `canArchive`, `canDelete`,
  `canManageMembers`, `canCreateTemplate`, `canLeave`, `canTransfer` (ostatnie
  zawsze `false`, bo transferu nie ma — §6.4).
- `version` to nieprzezroczysty `long` mapowany z `uint Xmin`; `expectedVersion`
  obsługują PATCH projektu, archive, restore i preferencje. Konflikty mają
  stabilne kody `project.version_conflict`, `project.preference_version_conflict`
  i `project.archived`, mapowane w `ApiExceptionMiddleware`.
- Reguły ACL są wyrażone raz (`ProjectAccessQueries.AccessibleProjects`), a
  rozstrzyganie roli i rangi trafiło do `ProjectRoleResolution`; mapper listy
  korzysta z istniejącego `ProjectResponseMapper` (bez drugiego mappera).
- Preferencje użytkownika mają własny token wersji (`ProjectUserPreference.Xmin`),
  więc przyjmują `expectedVersion` bez migracji i bez nowych pól encji.
- Walidacja: `dotnet build` — 0 ostrzeżeń, 0 błędów; `dotnet test --filter
  "FullyQualifiedName~Project"` — 136/136 PASS (w tym 8 testów HTTP na realnym
  PostgreSQL: dwie sesje, 409, archiwum, hidden, OpenAPI); pełny zestaw —
  1174 PASS / 4 SKIP / 7 FAIL, gdzie 7 to zastane `MeEndpointsTests`
  (potwierdzone `git stash` bez zmian w projekcie); `dotnet ef migrations script
  --idempotent` — exit 0, brak nowych migracji.
- Otwarte: przepisanie DTO/adapters Frontu na nowe pola oraz `expectedVersion`
  dla `DELETE` i handlerów członkostw.

### 2026-09-19 — PN-P4: atomowy kreator projektu w Backendzie

- `POST /workspaces/{id}/project-setups/preview` waliduje ACL, wersję szablonu
  i zależności, niczego nie zapisuje i zwraca znormalizowany plan z ostrzeżeniami;
  `POST /workspaces/{id}/project-setups` wykonuje całość w jednej transakcji
  PostgreSQL (projekt, workflow, członkowie, ustawienia widoku, harmonogram,
  capacity, automatyzacje, powiadomienia i outbox).
- Idempotencja jest trwała: rekord `workspaceId + userId + klucz` z hashem
  kanonicznego JSON-a żądania i zapisanym wynikiem. Powtórzenie tego samego
  żądania zwraca zapisany wynik (`replayed`), ten sam klucz z innym ciałem to
  409 `project_setup.idempotency_key_conflict`, a równoległe żądanie —
  `project_setup.idempotency_in_progress`. Retencja klucza to 48 godzin
  (konfigurowalna zmienną środowiskową) z zadaniem czyszczącym.
- Endpoint tylko mapuje HTTP: planowanie i zapis żyją w Application, reguły
  w Domain, persystencja i integracje w Infrastructure. Kroki korzystają
  z istniejących serwisów (materializer szablonu, katalog workflow, polityki
  listy i Kanbanu, capacity, powiadomienia) zamiast kopiować ich reguły.
- Migracja addytywna `AddProjectSetupIdempotency` dokłada tabelę rekordów oraz
  kolumnę `projects.DefaultTaskView` (domyślnie `List`, czyli dotychczasowe
  zachowanie); historyczne migracje nietknięte, skrypt idempotentny przechodzi.
- Walidacja: `dotnet build` — 0 ostrzeżeń, 0 błędów; `dotnet test --filter
  "FullyQualifiedName~ProjectSetup"` — 17/17 PASS (13 HTTP na PostgreSQL,
  4 jednostkowe hashera); pełny zestaw — 1191 PASS / 4 SKIP / 7 FAIL, gdzie te
  same 7 testów pada na czystym `HEAD` (MeEndpointsTests, niezwiązane);
  `dotnet ef migrations script --idempotent` — exit 0; `git diff --check` — czysty.
- Otwarte: `defaultTaskView` nie jest jeszcze wystawiony w `GET/PATCH /projects`
  (mały addytywny follow-up), kroki kreatora w Froncie (P5b) i transfer (P7).

### 2026-09-19 — PN-REVIEW-FIX: blokery z review

- Naprawiony [P0]: modele kreatora generowały niekompilujący się kod Freezed;
  adnotacje przeszły na `@Freezed(makeCollectionsUnmodifiable: false)` i pliki
  wygenerowały się ponownie. Pełny `flutter test` — 1077/1077 PASS.
- Shell udostępnia teraz `ProjectsRepository` i `ProjectsGateway` potomkom, więc
  menu projektu w sidebarze ma port mutacji zamiast być wyłączone.
- Preferencja widoku modułu Zadania jest per użytkownik: klucz zawiera `userId`,
  a router wczytuje ją ponownie po zmianie konta w tej samej sesji.
- Backend: `ProjectListItemResponse` publikuje `ArchivedAtUtc`; na działającej
  bazie `--filter Project` daje 153/153 PASS, a łańcuch migracji wykonuje się na
  czystej bazie (potwierdzone historią migracji bazy testowej); skrypt
  idempotentny generuje się z connection stringiem i zawiera nowe obiekty.

### 2026-09-19 — PN-P5b i PN-P1-FRONT: kreator z kroków §5 oraz konsumpcja kontraktu

- Kreator realizuje kroki §5 (start/podstawy/dostęp/workflow/sposób pracy/
  funkcje startowe/podsumowanie) na atomowym kontrakcie `project-setups`:
  jeden `Idempotency-Key` na draft, ponowienie po timeoucie z tym samym
  kluczem, 409 jako trwały błąd, brak projektu w drzewie przed odpowiedzią.
  24 nowe testy widgetowe; pełny `flutter test` — 1143/1143 PASS.
- Front konsumuje kontrakt P1: `isHidden`, `version`, `capabilities`,
  `archivedAtUtc`, `state`/`visibility` w zapytaniu listy, sekcje `Ukryte`
  i `Archiwum` pobierane z serwera (przetrwają restart), menu liczone
  z capabilities zamiast `myRole`, `expectedVersion` przy archiwizacji,
  przywróceniu i preferencjach; brak capabilities daje zachowanie zachowawcze
  z osobnym komunikatem.
- Domknięcia po review: pięć pozostałych dialogów zasobów ma jawny stan
  „brak połączenia w tej sesji” zamiast wyjątku (test to przypina), a backend
  przyjmuje `expectedVersion` także przy trwałym usunięciu projektu.

### 2026-09-20 — FILES-AUDIT: plan naprawy Plików

Audyt Front/Backend wykazał, że aktywne trasy plików osobistych, workspace i
projektu montują uproszczony `StorageReadOnlyBrowserPage`, mimo że repozytorium
zawiera bogatszy `StorageShellPage` z nagłówkiem, wyszukiwaniem, listą/siatką,
selekcją, uploadem i preview. To główna przyczyna wrażenia atrapy. Backend ma
już fundamenty share User/Workspace/Project/PublicLink, folderów, placementów,
OnlyOffice i historii wersji; braki dotyczą atomowego move placementu,
osiągalności funkcji w UI, współedycji odebranej na dwóch kontach oraz podglądu
historycznej wersji przed restore.

Plan F0–F9 zapisano w
`Backend/docs/recovery/files-storage-ux-recovery-plan.md`. Ustala jeden host
Files zgodny wizualnie z Tasks/Kanban, pełny header i command bar, trwałe
preferencje Lista/Siatka, atomowe przenoszenie, cztery tryby udostępniania,
OnlyOffice dla wielu osób, podgląd poprzednich wersji, realtime, macierz testów
i kolejność cleanupu. Ten pakiet jest wyłącznie audytem i dokumentacją; nie
zmienia runtime ani nie oznacza żadnej funkcji jako naprawionej.
### 2026-09-20 — FILES-F1: jeden pełny host Plików dla trzech zakresów

Status: **DONE** dla F0/F1; pakiety F2–F9 pozostają otwarte.

Aktywne trasy `/me/files`, `/workspaces/:id/files` i
`/workspaces/:id/projects/:pid/files` montują teraz `StorageShellPage` zamiast
uproszczonej `StorageReadOnlyBrowserPage`. `_storageBrowserRoutePage` przekazuje
repozytorium, uprawnienia kompozycji i porty transferu. Strona read-only
pozostaje w repozytorium bez aktywnego użycia; jej usunięcie należy do F9, po
migracji testów pionowych.

Nowy plik: `lib/workspaces/presentation/storage/shell/storage_shell_capabilities.dart`.
Zmienione: `storage_shell_page.dart`, `storage_browser_body.dart`,
`storage_browser_header.dart`, `selection/storage_selection_toolbar.dart`,
`selection/storage_keyboard_shortcuts.dart`, `grid/storage_file_grid.dart`,
`grid/storage_folder_grid.dart`, `list/storage_file_rows.dart`,
`list/storage_folder_rows.dart`, `shared/storage_file_context_menu.dart`,
`shared/storage_folder_actions_menu.dart` oraz
`lib/app/router/devplanner_router_pages.part.dart`.

Decyzje:

- O widoczności akcji mutujących decyduje `StorageShellCapabilities` z
  composition rootu, nie widget ani rola zapisana lokalnie. Wartość domyślna to
  `readOnly` (fail-closed), więc brak jawnej decyzji nigdy nie odsłania mutacji.
  Web/BFF zachowuje dzisiejszy kontrakt read-only, a desktop otrzymuje
  `StorageShellCapabilities.desktop`. Rozszerzenie uprawnień Web/BFF to osobna
  decyzja produktowa, nie efekt uboczny tego pakietu.
- Shell dostarcza `StorageRepository` i `DownloadTransport` do drzewa. To
  naprawia latentny `ProviderNotFoundException` przy „Historii wersji”
  i udostępnianiu otwieranych z siatki oraz menu kontekstowego.
- Akcje shella mają stabilne `ValueKey` zgodne z konwencją read-only
  (`file-details-*`, `share-file-*`, `download-file-*`), dzięki czemu routerowe
  testy parytetu działają bez osłabiania asercji.
- Domyślny tryb widoku to Lista, czyli ten sam kształt ekranu co przed zmianą;
  trwałe preferencje Lista/Siatka należą do F3.
- Nagłówek: tytuł jest `Expanded` z elipsą, bo przy średnich szerokościach
  akcje wypychały zawartość poza dostępne miejsce. Overflow był realny
  i wykrył go routerowy test, nie przegląd.
- Zakres odtworzony z adresu jest adoptowany przez istniejący Cubit
  (`_StorageShellViewState.didUpdateWidget`), a nie przez odtworzenie drzewa
  providerów kluczem `ValueKey(routedScope)`. Klucz zmieniał się przy każdej
  zmianie zakresu i dokładał drugie, zbędne żądanie listy po powrocie oraz po
  otwarciu folderu — czyli dokładnie to, czego bramka F1 zabrania. Zachowanie
  przypina `folder deep link opens the folder inside the Files shell`: jedno
  `listFolders` na deep link i jedno na powrót.

Bramki (faktycznie uruchomione):

- `flutter analyze` (cały projekt) — `No issues found!`;
- `flutter test` (pełne drzewo testów) — 1192 testy PASS;
- `dart format --output=none --set-exit-if-changed` na zmienionych plikach —
  bez zmian;
- `git diff --check` — czysto.

Buildy `flutter build web --wasm` i `flutter build macos` nie zostały
uruchomione: w drzewie trwała równoległa praca innego agenta oraz działająca
sesja `flutter run -d macos`, więc build nie jest tu wiarygodnym dowodem i nie
wolno go było uruchamiać.

Nowe dowody:

- `workspace Files route renders the one full Files shell`,
  `project Files route uses the real project-scoped browser` i
  `personal Files route uses the real personal Storage scope` asertują
  `StorageShellPage`, breadcrumbs i dokładnie jeden `listFolders` swojego
  zakresu;
- `folder deep link opens the folder inside the Files shell` dowodzi deep linku
  `?folder=`, breadcrumbs oraz braku podwójnego żądania;
- `Web BFF Files route fails closed for upload composition` dowodzi, że ten sam
  pełny shell renderuje się na BFF bez „Prześlij pliki”, „Nowy folder”
  i „Nowy dokument”, zachowując sidebar i breadcrumbs.

Następny krok: F2/F3 — jeden dwurzędowy chrome zgodny z Tasks/Kanban, filtry
oraz trwałe preferencje widoku.

### 2026-09-20 — KANBAN-ASSIGNEE-UX-AUDIT: plan grupowania po osobach i redesignu

Audyt Microsoft Planner oraz aktywnego pionu Tasks/Kanban potwierdził, że
DevPlanner ma już `KanbanSwimlaneMode.Assignee`, profile członków z avatarami,
wiele przypisań, primary assignee, filtry, paginację, DnD i realtime. Tryb
Assignee jest jednak wyłącznie zapisywany i zwracany: renderer nadal buduje
kolumny statusów, karta publikuje tylko `PrimaryAssigneeUserId`, a DnD kolumny
oznacza zmianę statusu.

Szczegółowy plan K0–K8 zapisano w
`Backend/docs/recovery/kanban-assignee-view-and-visual-refresh-plan.md`.
Ustala MVP z jedną kartą w kolumnie primary assignee, osobistym przełącznikiem
Status/Osoba, kolumną Nieprzypisane, avatarami, osobnym use case'em zmiany
primary, cursorami związanymi z grupą, realtime dwóch sesji oraz pełnym
odświeżeniem kart i kolumn inspirowanym czytelnością Planner, bez kopiowania
brandingu. Dokument zawiera kontrakty, pakiety, macierze testów, dostępność,
wydajność, bramki i Definition of Done. Jest to wyłącznie plan; runtime nie
został zmieniony i żaden pakiet K0–K8 nie jest ukończony.

Sprawdzenia dokumentacyjne: plan ma 719 linii i `shasum -a 256`
`110329e2f75c2180fb8353edbaf04bbd14ad988a29e9df17eddd7b879c280ece`; `cmp -s` na
lustrzanych parach — plan główny, handoff, plan parity/UI oraz plan nawigacji
produktu są IDENTICAL; `git diff --check` w Front i w Backendzie — exit 0. Bramki
runtime — NOT RUN: pakiet nie zmienia kodu, a w drzewie trwała równoległa praca
innych agentów. Następny krok: potwierdzenie D1–D5 i pakiet K0.
### 2026-09-20 — FILES-F2: dwuwierszowy chrome i trwały banner błędu

Status: **DONE**.

Chrome Plików składa się z dwóch wierszy na jednej powierzchni: kontekstu
(46 px) i poleceń (38 px) — te same wysokości, promienie i odstępy 4 px co
w Tasks/Kanban. Wiersz poleceń ma jeden slot akcji kontekstowych: przy aktywnym
zaznaczeniu zastępuje go pasek masowych, więc nigdy nie ma dwóch pasków masowych.

Nowe pliki: `lib/foundation/theme/files_theme.dart` oraz
`lib/workspaces/presentation/storage/browser/chrome/` (rama chrome'u, wiersz
kontekstu, wiersz poleceń, pigułka, pasek masowych, potwierdzenie usunięcia,
dwa dialogi tworzenia, banner błędu i jego host) i trzy kontrolki wiersza
poleceń (pole wyszukiwania, menu sortowania, przełącznik Lista/Siatka).

Usunięte: `browser/storage_browser_header.dart`,
`browser/toolbar/storage_browser_toolbar.dart`,
`browser/selection/storage_selection_toolbar.dart` — ich odpowiedzialności
przejęły pliki chrome'u, więc w module nie zostały dwa równoległe style paska.

Zmienione: Cubit i stan (stabilny `apiCode` i `traceId` w stanie błędu, jawny
`setViewMode`, `setSort` zapamiętuje wybór także w stanie pustym i początkowym,
`searchQuery` nie ginie przy zmianie widoku), shell, widoki stanu, menu folderu,
skróty klawiaturowe i ciało eksploratora.

Decyzje:

- `DevPlannerFilesTheme` nie kopiuje miar: składa się na
  `DevPlannerTasksTheme`, więc geometria modułów danych ma jedno źródło prawdy.
  Dzięki temu nie trzeba też zmieniać współdzielonego `theme.dart`.
- Trwały banner błędu jest jedyną powierzchnią błędu zakresu z akcjami:
  pokazuje komunikat, stabilny kod, `traceId`, `Ponów` i `Odśwież`. Ciało nie
  powtarza komunikatu drugi raz, a pasek znika dopiero po naprawie stanu.
- Kluczowe akcje chrome'u wymagają realnego portu, nie tylko flagi:
  `Prześlij pliki` pojawia się wyłącznie z portem pickera kompozycji, bo widoczna
  akcja bez portu byłaby martwa. Router desktopowy przekazuje go tak jak dotąd.
- Sortowanie i przełącznik widoku znikają w stanie błędu i odmowy dostępu —
  nie mają tam na czym działać, a widoczne wyglądałyby na zepsute.
- Wszystkie menu (tworzenie, akcje drugorzędne, sortowanie, menu folderu)
  korzystają z `AppContextMenu`. Surowy `PopupMenuButton` zniknął z aktywnego
  modułu.
- Akcje tworzące nie wymuszają już drugiego odświeżenia po mutacji — pojedynczy
  reload należy do nasłuchu shella, więc jedna mutacja to jedno żądanie listy.
- Etykiety chrome'u używają istniejących, neutralnych tekstowo kluczy ARB
  („Dodaj”, „Odśwież”), których nazwy pochodzą z innych modułów. Wydzielenie
  wspólnych kluczy powierzchni danych jest osobnym porządkiem; edycja ARB
  w trakcie pracy innego agenta nad tym samym plikiem nie jest bezpieczna.

Bramki (faktycznie uruchomione):

- `flutter analyze` na ścieżkach modułu, motywu i testów — `No issues found!`;
- `flutter test` (pełne drzewo testów) — 1230 testów PASS;
- `dart format --output=none --set-exit-if-changed` na zmienionych plikach —
  bez zmian;
- `git diff --check` — czysto.

Nowe dowody: `test/workspaces/presentation/storage/chrome/` zawiera testy
sześciu viewportów (360–1920 px), macierz motyw × skala tekstu 100/125/150%
× trzy szerokości, geometrię wierszy z tokenów, zwijanie akcji na wąskim
ekranie, fokus klawiaturą z nazwami dostępnymi, debounce wyszukiwania oraz
trwały banner (brak w zdrowym stanie, komunikat + kod + `traceId` + `Ponów`
w stanie błędu). Goldeny: `1280 px` w light i dark oraz `700 px`, obejrzane
wizualnie. Buildy web/macos nadal NOT RUN z powodu równoległej pracy w drzewie
i działającej sesji `flutter run -d macos`.

Następny krok: F3 — filtry, rozdzielenie wyszukiwania tekstowego i
semantycznego oraz trwałe preferencje Lista/Siatka/sortowania per użytkownik
i zakres.
### 2026-09-20 — FILES-F3 (część): filtry i trwałe preferencje widoku

Status: **DONE (część)** — filtry i trwałość gotowe; tryb semantyczny i filtr
właściciela pozostają otwarte z nazwanymi powodami.

Zakres domknięty:

- filtry typu (rozszerzenie), statusu analizy AI i daty dodania, w panelu
  wspólnego menu, z paskiem aktywnych filtrów i jednym wyjściem do ich zdjęcia;
- trwałe preferencje widoku (Lista/Siatka, sortowanie, gęstość) per użytkownik
  i zakres, przeżywające restart klienta;
- porządkowanie odpowiedzi: istniejący debounce wyszukiwania i strażnik
  generacji żądań zostały utrzymane, a stan końcowy żądania czyta bieżące pola
  widoku.

Nowe pliki: `lib/workspaces/domain/storage/models/storage_view_preference.dart`,
`lib/workspaces/domain/ports/storage_view_preference_store.dart`,
`lib/workspaces/data/preferences/shared_preferences_storage_view_store.dart`,
`lib/workspaces/presentation/storage/shell/storage_view_preference_scope.dart`
oraz `browser/chrome/storage_filter_menu.dart` i
`browser/chrome/storage_active_filter_strip.dart`.

Zmienione: `StorageBrowserFilter` (jawne czyszczenie pojedynczych warunków),
`StorageBrowserCubit` i stan (gęstość, wspólna aktualizacja pól widoku,
zachowanie sortowania i gęstości przy zmianie zakresu), shell (zastosowanie
zapisu przy wejściu w zakres i zapis reakcji użytkownika), router (store jak dla
Tasks: jeden port, wczytywany przy starcie i po zmianie konta), wiersze listy
(gęstość), menu `…` (gęstość), ARB (15 kluczy filtrów w PL i EN).

Decyzje:

- Preferencja jest per użytkownik i per zakres, ale **poza** identyfikatorem
  folderu: przejście w głąb drzewa nie gubi wybranego widoku.
- Wejście w zakres stosuje jego własny zapis; zakres bez zapisu startuje
  z wartości domyślnych produktu, więc wybór nie przecieka między zakresami.
  Kompozycja bez portu trwałości zachowuje bieżący widok.
- Zapis pomija stan błędu i odmowy dostępu: stan bez listy nie niesie tych pól,
  więc awaria sieci nie przestawiłaby zapisanego widoku.
- Preferencje są lokalne (jak motyw i widok Zadania). Kontrakt Backendu nie ma
  endpointu preferencji Storage, dlatego ścieżka `expectedVersion`/409 nie ma
  dziś czego wersjonować — dołożenie jej wymaga najpierw endpointu, a nie
  lokalnego obejścia.
- Pole właściciela nie jest wystawione, bo katalog lokalnych użytkowników nie
  jest dostępny przez typowany port Storage. To ten sam port, którego potrzebuje
  udostępnianie pliku osobie (F5), więc pole dołączy razem z nim — do tego czasu
  brak pola zamiast pola, które nic nie robi.
- Tryb `Po treści` (wyszukiwanie semantyczne) pozostaje otwarty. Kontrakt ma
  endpoint `GET /files/search/semantic`, ale wynik to fragmenty dokumentów
  (`fileId`, `version`, `chunkIndex`, tekst), a nie wiersze eksploratora, więc
  wymaga osobnej powierzchni wyników. Usługa semantyczna jest dziś niedostępna,
  więc tryb dałoby się sprawdzić wyłącznie na mocku — a to nie jest dowód, że
  działa. Zwykłe wyszukiwanie jest zaimplementowane i przetestowane, a jego
  niedostępność nie zależy od AI.

Defekty znalezione i naprawione w tym pakiecie (wszystkie przez testy):

- zmiana widoku albo sortowania w trakcie trwającego żądania była gubiona, bo
  stan końcowy używał wartości uchwyconych na starcie żądania;
- preferencja zastosowana w trakcie ładowania była gubiona, bo aktualizacja pól
  widoku nie obsługiwała stanu ładowania;
- jeden uszkodzony wpis w magazynie kasował preferencje wszystkich zakresów
  użytkownika (brak izolacji wpisów);
- sortowanie i gęstość były resetowane przy każdej zmianie zakresu.

Bramki (faktycznie uruchomione):

- `flutter analyze` na ścieżkach modułu, motywu, routera i testów —
  `No issues found!`;
- `flutter test` (pełne drzewo testów) — 1251 testów PASS;
- `dart format --output=none --set-exit-if-changed` na zmienionych plikach —
  bez zmian;
- `git diff --check` na ścieżkach tego pakietu — czysto. (Cały `git diff
  --check` zgłasza trailing whitespace w `kanban_models.freezed.dart`, pliku
  zmienionym przez równoległą pracę innego agenta, nie przez ten pakiet.)
- `flutter gen-l10n` — 15 nowych kluczy filtrów wygenerowanych w PL i EN.

Nowe dowody: `test/workspaces/data/preferences/storage_view_store_test.dart`
(restart, brak przecieku między zakresami i kontami, izolacja uszkodzonego
wpisu, kolejka zapisów), `test/workspaces/presentation/storage/storage_view_persistence_test.dart`
(zapisany widok wraca po restarcie, zmiana widoku jest zapisywana, zakres bez
zapisu nie dziedziczy cudzego) oraz testy filtrów w
`test/workspaces/presentation/storage/chrome/` (panel, zapytanie z filtrem,
pasek aktywnych filtrów, zdjęcie warunku).

Następny krok: dokończyć F3 (tryb semantyczny na osobnej powierzchni wyników,
pole właściciela po porcie katalogu), potem F4 — atomowe przenoszenie
placementu i drag-and-drop.

### 2026-09-20 — KANBAN-ASSIGNEE-K2-K6: implementacja widoku osób

Status: **DONE dla K2–K6 (Backend + Front)**; K0, K1/K7 i K8 pozostają otwarte.

Backend dostał kontrakty i endpointy grupowania po osobach (`GET kanban/assignees`,
`GET kanban/assignees/unassigned`, `GET kanban/assignees/{assigneeUserId}`) oraz
osobną mutację `PATCH kanban/tasks/{taskId}/primary-assignee` z wersją zadania,
historią, outboxem `task.updated` i kodami `kanban.invalid_assignee` /
`kanban.assignee_not_project_member`. Karta publikuje `assigneeUserIds`, a
projekcja karty ma jedno miejsce prawdy (`KanbanCardMaterializer`), więc widok
statusów i widok osób nie mogą rozjechać się co do pól karty. Front dostał modele
i repozytorium, osobistą preferencję grupowania (per użytkownik, workspace
i projekt), nowy komponent komend `TasksBoardAssigneeCommands` oraz widok kolumn
osób z badge statusu, potwierdzeniem dropu na „Nieprzypisane” i paginacją per
grupa.

Przy okazji naprawiono dwa realne błędy: zbiorcza aktualizacja Kanbanu i
przypisanie zadania z powiadomienia dodawały nowe `TaskAssignee` wyłącznie do
kolekcji nawigacji, co kończyło się konfliktem 409 zamiast zapisu; oba miejsca
używają teraz jawnego `DbSet.Add`.

Bramki: `dotnet build` bez błędów; `dotnet test --filter Kanban` 73/73 PASS;
pełny `dotnet test` 1208 PASS / 7 FAIL / 4 SKIP (bez nowych regresji, te same
wcześniejsze testy auth); `flutter analyze lib` — No issues found; testy pionu
Tasks + Kanban 434/434 PASS z 11 nowymi; pełny `flutter test` 1253 PASS;
`git diff --check` czysto w obu repo. NOT RUN: buildy platform, pomiary wydajności
i odbiór live dwóch sesji — równoległa praca innego agenta w Storage.

### 2026-09-20 — KANBAN-ASSIGNEE-K0: baseline pomiarowy

Status: **DONE** — pomiary, test renderera i 19 zrzutów w
`docs/recovery/visual-captures/k0`.

Zmierzone na PostgreSQL (4 grupy, 5 kolumn): `GET /kanban` = 35 zapytań,
`GET /kanban/assignees` = 19 zapytań, a podwojenie liczby zadań (30 → 60) nie
zmienia ani jednej z tych liczb — liczba zapytań zależy od liczby kolumn i grup,
a nie od liczby kart. Kolumna dłuższa niż strona dokłada 4 zapytania (efekt
`AsSplitQuery`), co jest kandydatem do optymalizacji w K8.

Testy: `KanbanFirstPageQueryCountTests` (2/2 PASS w projekcie testowym; kształt
zależności zamiast wymyślonego progu) oraz `kanban_assignee_k0_baseline_test.dart`
(16/16 PASS; oba grupowania × light/dark × 100/150/200%, brak przepełnień, pomiar
308 px kolumny i 290 px karty, dowód że o rendererze decyduje przełącznik, a nie
`swimlaneMode` projektu).

Tokeny geometrii (308/12/8/8/10–12 px) mieszczą się w widełkach §5.6–§5.7, więc
K1 dokłada tylko tokeny stanów interakcji i goldeny. Otwarte: K1/K7, K8 oraz
potwierdzenie D1–D5 przez właściciela produktu.

Domknięcie: test baseline'u 16/16 PASS i 19 zrzutów PNG (widoki obu grupowań
i kart ze statusem w light/dark × 100/150/200% oraz pasek grupowania w wąskim
oknie). Baseline wykrył realny defekt: w oknie 600 px przy 200% tekstu pasek
grupowania przepełniał się o 9,9 px (§5.9 planu); pasek jest teraz przewijany
poziomo, a regresję pinuje test. Po poprawce pion Tasks + Kanban: 450/450 PASS,
`flutter analyze lib` bez uwag.
### 2026-09-20 — FILES-F4: atomowe przenoszenie placementu i drag-and-drop

Status: **DONE** dla przenoszenia pojedynczego i zbiorczego oraz DnD; panel
szczegółów i „Utwórz kopię” pozostają poza tym pakietem.

Backend — nowy atomowy kontrakt:

- `POST /api/v1/storage/placements/{placementId}/move` z ciałem
  `{targetFolderId, expectedVersion}` i opcjonalnym nagłówkiem `Idempotency-Key`.
- `StorageFilePlacement` dostał token współbieżności `xmin` oraz odcisk
  idempotencji (`LastMoveIdempotencyKey`, `LastMoveTargetFolderId`), a
  `StorageFilePlacementResponse` publikuje `version`, więc klient ma czym
  potwierdzić wersję. Migracja `AddStoragePlacementMoveIdempotency` jest
  addytywna i celowo **nie** tworzy kolumny `xmin` — PostgreSQL trzyma ją jako
  kolumnę systemową (precedens `AddPostgresConcurrencyTokens`).
- Stabilne kody konfliktów: `storage.placement_conflict` (nieaktualna wersja,
  duplikat w folderze docelowym, ponowne użycie klucza z innym celem) oraz
  `storage.folder_cycle` (przeniesienie folderu do własnego poddrzewa, wcześniej
  kończące się kodem walidacji).
- Walidacje: prawo zapisu do folderu źródłowego, docelowego i do pliku;
  identyczność kontekstu źródła i celu (baza odrzuca to triggerem 23514, co
  middleware zamieniłby na błąd serwera); duplikat placementu; plik w koszu.
- Kolejność walidacji jest celowa: ACL celu idzie przed zgodnością kontekstu,
  więc cudzy folder nie ujawnia swojego kontekstu (403 zamiast 400), a plik
  w koszu jest niewidoczny dla warstwy uprawnień (404).
- Metryki rozdzielają `MovePlacement` od `CreatePlacement`.

Front — jedno wejście dla trzech dróg:

- `moveFilePlacement` w porcie, adapterze API, repozytorium i operacjach
  rozszerzonych; `listFolderPlacements` dodane do portu, bo lista plików nie
  niesie identyfikatora placementu.
- `StorageFileMutationCubit.moveFileToFolder` rozstrzyga przypadek: plik
  wewnątrz folderu jest tam placementem (przeniesienie istniejącej referencji
  z jej wersją), a plik na poziomie zakresu placementu nie ma (utworzenie
  referencji). Ten sam przypadek użycia obsługuje picker, drag-and-drop i pasek
  akcji masowych.
- Intencja przeniesienia trzyma klucz idempotencji, więc ponowienie nie tworzy
  drugiej referencji, a nowa intencja dostaje nowy klucz.
- `moveFilesToFolder` raportuje wynik per element przez stan częściowego sukcesu,
  więc nieudane elementy są nazwane, a nie ukryte.
- Picker folderu (`StorageFolderPickerDialog`) pokazuje wyłącznie foldery tego
  samego zakresu i nie pozwala wskazać folderu źródłowego.
- Drag-and-drop (`StorageFileDragSource` / `StorageFolderDropTarget`) używa tej
  samej komendy co picker i jest bramkowany nowym `StorageShellCapabilities.canMove`;
  bez tej flagi gest nie istnieje, więc nie może wywołać niedozwolonej akcji.
- Świadomie **bez** optymistycznego przestawiania listy: po sukcesie następuje
  jedno odświeżenie z serwera, więc nie istnieje ścieżka „rollbacku”, która
  mogłaby rozjechać się ze stanem backendu.

Defekty znalezione i naprawione przy okazji:

- nieudany odczyt przodków breadcrumbów (np. wyjątek nie-`Exception`) zostawiał
  eksplorator w nieskończonym stanie ładowania; krok wzbogacania ścieżki łapie
  teraz każdą awarię i nie blokuje zawartości folderu;
- wygenerowany klient Retrofit zapisał `InvalidType` dla nowej metody, gdy
  build_runner ruszył przed dodaniem typu do barrel-a. Pliki `.g.dart` są
  wykluczone z `flutter analyze`, więc błąd ujawnił się dopiero przy kompilacji
  testów (45 plików testowych nie wczytało się).

Bramki (faktycznie uruchomione):

- Backend: `dotnet build` (bez ostrzeżeń i błędów), `dotnet ef migrations
  has-pending-model-changes` — „No changes have been made to the model since the
  last migration.”, `dotnet ef migrations script --idempotent` — exit 0,
  `dotnet test` — 1211 PASS, 4 SKIP, 7 FAIL (wyłącznie `MeEndpointsTests`;
  to porażki odnotowane wcześniej w handoffie, niezwiązane z tym pakietem);
  test `StorageHttpTests.MovePlacement…` na realnym PostgreSQL: 401, konflikt
  wersji 409, obcy kontekst 400, duplikat 409, plik w koszu 404, cudzy folder
  403, przeniesienie i ponowienie z tym samym kluczem 200, ponowne użycie klucza
  z innym celem 409, cykl folderu 409, oraz zmiana `version` po przeniesieniu.
- Front: `flutter analyze` — `No issues found!`, `flutter test` — 1284 PASS,
  `dart run build_runner build --delete-conflicting-outputs` — wygenerowany
  klient bez `InvalidType`, `git diff --check` — czysto.

Następny krok: F5 — udostępnianie użytkownikowi, workspace, projektowi i linkiem
publicznym zgodnie z ACL (razem z portem lokalnego katalogu użytkowników, którego
potrzebuje też filtr właściciela z F3).

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

Status: **DONE (część)** — macierz User/Workspace/Project/PublicLink potwierdzona
i widoczna w jednym dialogu; live na dwóch kontach pozostaje w F8/F9.

Backend — potwierdzenie macierzy i domknięcie dwóch braków:

- Udokumentowana i przetestowana macierz: `User`, `Workspace` (tylko workspace
  pliku, autor musi mieć w nim co najmniej Observer), `Project` (tylko projekt
  pliku, autor musi mieć w nim odczyt) oraz `PublicLink` (hasło i wygaśnięcie,
  hasło odrzucane poza linkiem). Poziom `Owner` nie może być nadany
  udostępnieniem, a duplikat aktywnego grantu jest odrzucany.
- Nowy stabilny kod `storage.share_forbidden`: odmowa specyficzna dla
  udostępniania nie jest już raportowana kodem dostępu do pliku. Brak dostępu do
  samego pliku nadal zwraca `storage_file.forbidden`, więc klient nie mówi
  „nie możesz udostępniać” osobie, która nie widzi pliku (test IDOR to przypina).
- Doszła kontrola eskalacji: poziom grantu nie może przekroczyć efektywnego
  poziomu autora. Dziś jest to zabezpieczenie zapasowe — `CanShare` mają wyłącznie
  właściciel i edytor z prawem dzielenia, a oba poziomy mieszczą nadawalne
  wartości — ale zapobiega cichej eskalacji, gdyby model uprawnień się zmienił.
  Zapisane wprost, bo nie da się tego przejść przez HTTP w obecnym ACL.
- Udostępnienie folderu do workspace/projektu **nie** zostało dołożone: to
  decyzja kontraktowa (dziś folder ma share bezpośredni tylko do użytkownika),
  a plan zabrania udawać ją lokalnym filtrem.

Front — jeden dialog z czterema trybami:

- `StorageDesktopSharingDialog` ma sekcje: Osoby, Workspace, Projekt, Link
  publiczny oraz listę aktywnych udostępnień z poziomem, autorem i wygaśnięciem.
- Sekcja osób korzysta z lokalnego katalogu użytkowników przez nowy
  `StorageUserDirectoryPort` (adapter nad repozytorium Workspaces), a więc
  z tego samego zakresu co ustawienia workspace'u. Poza workspace'em sekcja mówi
  wprost, że katalog nie jest dostępny, a brak portu nie pokazuje pola bez
  wyników.
- Port wędruje do modala jawnie z miejsca otwarcia, bo modal jest montowany na
  rootowym overlayu i nie ma wśród przodków providerów modułu Pliki. Ta sama
  poprawka objęła repozytorium Storage: dialog przestał polegać na odczycie
  z kontekstu, co było kruche i nieprzetestowane w shellu.
- Filtr właściciela z F3 jest domknięty: panel filtrów ma sekcję właściciela
  korzystającą z tego samego portu i tego samego zakresu.

Bramki (faktycznie uruchomione):

- Backend: `dotnet build` bez ostrzeżeń, `dotnet test` — 1212 PASS, 4 SKIP,
  7 FAIL (te same, wcześniej odnotowane porażki `MeEndpointsTests`), w tym nowy
  test macierzy share'ów.
- Front: `flutter analyze` — `No issues found!`, `flutter test` — 1319 PASS,
  `flutter gen-l10n` z nowymi kluczami sekcji, `git diff --check` — czysto.

Otwarte po F5: live na dwóch kontach (F8/F9), udostępnianie folderu do
workspace/projektu jako osobna decyzja kontraktowa, oraz „Utwórz kopię”.

Następny krok: F6 — podłączenie istniejącego edytora OnlyOffice i weryfikacja
współedycji dwóch osób na żywym środowisku.

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

Status: **DONE (część)** — akcja, status i odświeżenie po sesji gotowe;
**live E2E dwóch kont: NOT RUN** (wymaga żywego OnlyOffice).

Zakres domknięty:

- Akcja `Otwórz dokument` w menu kontekstowym i w menu pliku w siatce otwiera
  `StorageOfficeEditorDialog` bezpośrednio, zamiast prowadzić przez generyczny
  podgląd. Pokazuje się wyłącznie dla plików z `canEditOnline`, więc tryb
  edycji pochodzi z capability pliku, a nie ze zgadywania po rozszerzeniu.
- Po zamknięciu sesji lista jest wczytywana ponownie. OnlyOffice zapisuje nową
  wersję po własnym callbacku, więc bez tego użytkownik widziałby nazwę i rozmiar
  sprzed edycji. Odświeżenie nie zmienia folderu ani zaznaczenia.
- Mostek przekazuje teraz `onDocumentStateChange`, a edytor pokazuje stan:
  łączenie, połączony bez zmian, zmiany czekające na zapis. Sygnał pochodzi
  z samego edytora — ekran nie zgaduje stanu zapisu z upływu czasu.
- Zamknięcie przy niepotwierdzonych zmianach wymaga decyzji: bez zmian edytor
  zamyka się od razu, a przy zmianach pojawia się ostrzeżenie z wyjściem
  „Anuluj” (wróć do edycji) i „Zamknij”.

Nowe pliki: `chrome/storage_open_document_action.dart`,
`office/widgets/storage_office_status_label.dart`,
`office/widgets/storage_office_close_confirmation.dart`.

Zmienione: `onlyoffice_editor_html_builder.dart` (zdarzenie stanu dokumentu),
`storage_onlyoffice_controller.dart` i `storage_onlyoffice_host.dart` (przekazanie
sygnałów), `storage_office_editor_actions_state.dart` i `.cubit.dart` (status
sesji, zmiany, potwierdzony zapis), `storage_office_editor_view.dart` (delegacja
zamknięcia, wskaźnik w nagłówku), menu kontekstowe i menu siatki, ARB (6 kluczy).

Decyzje:

- Status i potwierdzenie zamknięcia są wydzielone jako osobne widgety/funkcje,
  żeby dały się przetestować bez osadzonego WebView — inaczej cała logika stanu
  sesji byłaby osiągalna tylko przez żywy edytor.
- Podgląd przekazuje repozytorium do edytora jawnie. Wcześniej czytał je
  z kontekstu rootowanego modala, co jest tą samą kruchością, którą F5 naprawił
  w dialogu udostępniania.
- Ścieżka podglądu nadal nie odświeża listy sama: podgląd ma pięć miejsc
  konstrukcji, a przeniesienie do niego odświeżenia należy do przebudowy panelu
  szczegółów (F7). Akcja `Otwórz dokument` z listy odświeża listę już teraz.

Bramki (faktycznie uruchomione):

- Front: `flutter analyze` — `No issues found!`, `flutter test` — 1331 PASS,
  `git diff --check` — czysto.
- Backend: bez zmian w tym pakiecie (ostatni przebieg: 1212 PASS, 4 SKIP,
  7 wcześniejszych FAIL w `MeEndpointsTests`), `git diff --check` — czysto.

**NOT RUN — live E2E dwóch kont.** Plan (F6) wymaga dowodu, że dwie osoby
współedytują ten sam dokument na żywym OnlyOffice i że historia wersji jest
spójna. Nie ma dziś uruchomionego serwera dokumentów ani drugiego konta
w tej sesji, a mock nie jest dowodem — dlatego pozycja zostaje otwarta,
a nie oznaczona jako zrobiona.

Do domknięcia razem z live E2E: obecność współedytorów w UI (wymaga zdarzeń
współpracy OnlyOffice) oraz odświeżenie listy także po ścieżce podglądu.

Następny krok: F7 — podgląd i pobranie poprzedniej wersji bez przywracania,
razem z panelem szczegółów pliku.

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

Status: **DONE** dla podglądu i pobrania wersji; wpięcie akcji w legacy stronę
szczegółów czeka na F9.

Zakres domknięty:

- `StoragePreviewCubit.prepareVersionPreview` pobiera bilet **wskazanej wersji**
  i renderuje ją tymi samymi powierzchniami co bieżący plik (PDF, tekst, media).
  Wersja nie jest przy tym przywracana: testy przypinają, że wywołanie podglądu
  nie sięga ani `restoreFileVersion`, ani biletu bieżącej wersji.
- Dialog wersji ma obok pobrania i przywrócenia akcję `Podgląd wersji`
  z kluczem `preview-version-<n>`.
- Podgląd wersji historycznej jest jawnie tylko do odczytu: nagłówek pokazuje
  plakietkę `Wersja N — podgląd`, a edytor biurowy jest w tym trybie
  niedostępny. Jego sesja dotyczy bieżącej wersji, więc otwarcie go na starej
  treści pokazywałoby coś innego niż wybrana wersja i mogło nadpisać bieżący
  plik. Dla dokumentów biurowych zostaje czytelna informacja i pobranie.
- Podgląd pliku ma teraz jedno wejście dla listy, siatki, menu kontekstowego
  i skrótów klawiaturowych (`showStoragePreview`), które zawsze otwiera modal na
  rootowym hoście, przekazuje porty jawnie i **odświeża listę po zamknięciu
  sesji edytora**. To domyka otwartą w F6 lukę i usuwa różnicę między siatką
  a listą, gdzie jedno miejsce używało hosta modalnego, a drugie zwykłego
  `showDialog`.

Nowe pliki: `browser/chrome/storage_preview_action.dart`.
Zmienione: `storage_preview_cubit.dart` i `storage_preview_state.dart` (tryb
wersji), `storage_preview_dialog.dart` (tryb historyczny, hook po sesji edytora,
jawne repozytorium), `versions/storage_versions_dialog.dart` (akcja podglądu,
współdzielony Cubit podglądu), grid, wiersze listy, menu kontekstowe, skróty
klawiaturowe, ARB (3 klucze).

Decyzje:

- Historia wersji zostaje w dialogu, a nie w osobnym panelu: plan dopuszcza obie
  ścieżki, a dialog ma już pobieranie i przywracanie z kontrolą `expectedVersion`.
- Podgląd historycznej wersji biurowej nie otwiera edytora — bezpieczniejsza
  jest informacja z pobraniem niż sesja, której zapis dotyczy innej treści.
- `showStoragePreview` wymaga repozytorium i Cubita przeglądarki z drzewa
  modułu, więc test siatki dostał `RepositoryProvider` — harness odzwierciedla
  teraz kompozycję produkcyjną.

Bramki (faktycznie uruchomione):

- Front: `flutter analyze` — `No issues found!`, `flutter test` — 1335 PASS,
  `flutter gen-l10n` z nowymi kluczami, `git diff --check` — czysto.
- Backend: bez zmian w tym pakiecie (ostatni przebieg: 1212 PASS, 4 SKIP,
  7 wcześniejszych FAIL w `MeEndpointsTests`).

Otwarte po F7: wpięcie tej samej akcji w legacy stronę szczegółów pliku
(`browser/standalone/storage_file_details_page.dart` pokazuje dziś statyczną
listę wersji) — ta strona jest kandydatem do F9, więc inwestycja w nią przed
cleanupem byłaby stratą. Do tego dochodzą odłożone wcześniej: tryb `Po treści`
(F3), udostępnianie folderu do workspace/projektu (F5) i live E2E dwóch kont
(F6).

Następny krok: F8 — realtime w module Pliki, trwałe bannery retry/refresh oraz
testy 401/revoke i IDOR/ACL, potem F9 — cleanup martwego read-only browsera
i pełne bramki projektu (w tym buildy web/macos).

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

Status: **DONE (część)** dla F8; **F8 realtime NOT DONE**;
**F9 build web DONE, build macOS NOT RUN, cleanup NOT RUN** — powody niżej.

F8 — domknięte (trwałe błędy):

- Mutacje nie pokazują już SnackBara: upload, przenoszenie, udostępnianie,
  tworzenie dokumentu i kosz raportują błąd **trwałym bannerem** zgodnym
  z Tasks — komunikat, stabilny kod, `traceId`, `Ponów` i `Odśwież`.
- `Ponów` pojawia się tylko tam, gdzie ponowienie jest bezpieczne: konflikt
  przeniesienia wraca z zachowaną intencją i tym samym kluczem idempotencji
  (test przypina identyczność kluczy), a utworzenie dokumentu z zachowaną
  intencją. Usunięcie i udostępnienie nie udają ponowienia — mają wyłącznie
  `Odśwież`, bo nie odtwarzają intencji bez udziału użytkownika.
- Stan błędu mutacji niesie teraz `apiCode` i `traceId` (plik, folder, dokument,
  placement), więc konflikt wersji jest rozpoznawalny po kodzie, a nie po treści
  komunikatu.
- Błąd mutacji jest stanem krótkotrwałym tej powierzchni z jawnym właścicielem
  (`ValueNotifier` w widoku shella, zwalniany w `dispose`).

Nowe pliki: `browser/chrome/storage_mutation_error.dart`.
Zmienione: stany i Cubity mutacji (kod + `traceId`), `storage_shell_page.dart`
(banner zamiast SnackBarów, przekazanie notifiera do treści), ARB (1 klucz).

F8 — czego **nie** zrobiono i dlaczego:

**Realtime dla pionu Storage nie istnieje i nie został dodany.** Audyt
Backendu: hubs i outbox mają Tasks (`TaskEventsHub`), Chat (`ChatEventsHub`)
i Wiki (`WikiRealtimeOutboxWorker`); Storage nie ma żadnego kanału ani encji
outbox. Dodanie go to nowy hub, menedżer połączeń, typowane zdarzenia
(created/updated/moved/deleted/restored/share changed/version created), encja
outbox z migracją, worker, rejestracja DI i zmiany sygnatur kilku handlerów —
a weryfikacja końcowa tego kanału wymaga dwóch żywych sesji, czyli dokładnie
tego dowodu, którego brakuje też w F6. Nie zbudowałem tego po omacku w drzewie,
w którym równolegle pracuje inny agent (dotyka m.in. `WorkspaceServiceExtensions`
i `ApiExceptionMiddleware`, czyli plików rejestracji i mapowania błędów, których
ten kanał wymaga). Pozycja zostaje otwarta z gotowym kontraktem do dodania.

F9 — domknięte i otwarte:

- `flutter build web --wasm` — **uruchomiony, exit 0** (`✓ Built build/web`).
- `flutter build macos` — **NOT RUN**: w drzewie działa żywa sesja
  `flutter run -d macos` drugiego agenta, a build pisze do tego samego
  `build/macos`, więc byłby ingerencją w cudzą pracę. Do uruchomienia, gdy
  drzewo będzie spokojne.
- Cleanup martwego read-only browsera — **NOT RUN**: jego jedynymi konsumentami
  są 6 plików testów pionowych (`storage_read_only_browser_page` w 6 plikach),
  a wewnętrzne widgety rodziny (`storage_read_only_*`, `storage_delete_actions`,
  `storage_folder_create_action`, `storage_restore_actions`,
  `storage_share_action`) są używane wyłącznie przez tę stronę. Usunięcie
  strony bez migracji tych testów skasowałoby realne pokrycie (potwierdzenia
  usunięcia, pobranie i zapis pliku, kolejka uploadu), dlatego cleanup jest
  atomowy: najpierw migracja 6 plików na harness shella, potem usunięcie
  ~9 plików. Plan sam ustawia ten krok jako ostatni.

Bramki (faktycznie uruchomione):

- Front: `flutter analyze` — `No issues found!`, `flutter test` — 1338 PASS,
  `flutter build web --wasm` — exit 0, `git diff --check` — czysto.
- Backend: bez zmian w tym pakiecie (ostatni przebieg: 1212 PASS, 4 SKIP,
  7 wcześniejszych FAIL w `MeEndpointsTests`), `git diff --check` — czysto.

Otwarte po tym pakiecie: realtime Storage (Backend, kontrakt w §3.2.6 planu),
cleanup F9 (blokowany migracją testów), build macOS (blokowany żywą sesją),
live E2E dwóch kont (F6), tryb `Po treści` (F3), udostępnianie folderu do
workspace/projektu (F5), wpięcie podglądu wersji w legacy stronę szczegółów (F7).

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
### 2026-09-20 — FILES-F8-RT: kanał realtime dla pionu Storage

Status: **DONE** dla kanału w Backendzie i jego testów; **live dwóch sesji
NOT RUN** (brak żywego środowiska z dwoma klientami w tej sesji).

Zakres domknięty w Backendzie:

- **Encja outboxa** `StorageRealtimeOutboxMessage` adresowana zakresem
  (`StorageFolderType` + właściciel/workspace/projekt), z sekwencją, statusem
  dostarczenia, próbami i błędem. Migracja `AddStorageRealtimeOutbox` jest
  addytywna (samo `CreateTable` + indeksy), `has-pending-model-changes` czyste,
  a `migrations script --idempotent` przechodzi.
- **Typowane zdarzenia** zgodnie z §3.2.6: `storage.file.created`,
  `storage.file.updated`, `storage.file.moved`, `storage.file.deleted`,
  `storage.file.restored`, `storage.share.changed`, `storage.file.version.created`.
  Koperta niesie zakres, identyfikatory pliku i folderu, numer wersji, autora
  i znacznik czasu — bez treści pliku i bez adresów, więc sygnał nie może
  wyciec niczego, czego nie widzi lista.
- **Hub** `StorageEventsHub` na `/api/v1/realtime/storage` z subskrypcją
  osobistą, workspace'ową i projektową. Dołączenie do grupy przechodzi te same
  bramki dostępu co odczyt zakresu (`RequireRoleAsync` dla workspace'u,
  `RequireReadAsync` dla projektu), więc kanał nie jest obejściem ACL.
- **Odtworzenie po reconnect**: `GetPersonalEvents` / `GetWorkspaceEvents` /
  `GetProjectEvents` czytają historię zakresu po nieprzezroczystym kursorze.
  `ResyncRequired` jest liczone precyzyjnie: luka to brak rekordu bezpośrednio po
  kursorze, a nie tylko „kursor starszy niż wszystko” — poprzednia reguła nie
  wykrywała ubytku w środku historii i klient nigdy nie dowiedziałby się
  o zmianie.
- **Worker** `StorageRealtimeOutboxWorker` dostarcza zatwierdzone zdarzenia
  z ponowieniem, wykładniczym opóźnieniem i limitem prób; zmiana w projekcie
  leci także do grupy workspace'u, bo widok workspace'u pokazuje pliki projektów.
- **Wpięcie w miejsca mutacji**: utworzenie dokumentu, zmiana opisu, przeniesienie
  placementu, usunięcie, przywrócenie, udostępnienie i cofnięcie udostępnienia
  oraz przywrócenie wersji. Publikacja wchodzi do tego samego `SaveChangesAsync`
  co mutacja, więc zdarzenie istnieje dokładnie wtedy, gdy istnieje zmiana.

Nowe pliki: `Domain/Entities/StorageRealtimeOutboxMessage.cs`,
`Domain` niezmieniony poza tym, `Contracts/Storage/StorageRealtimeContracts.cs`,
`Application/Storage/StorageRealtimeScope.cs`,
`Application/Storage/StorageRealtimeEventFactory.cs`,
`Application/Storage/StorageRealtimePublisher.cs`,
`Infrastructure/Storage/StorageRealtimeConnectionManager.cs`,
`Infrastructure/Storage/StorageRealtimeEventStore.cs`,
`Infrastructure/Storage/StorageEventsHub.cs`,
`Infrastructure/Storage/StorageRealtimeOutboxWorker.cs`,
`Infrastructure/Persistence/Configurations/StorageRealtimeOutboxMessageConfiguration.cs`,
migracja `AddStorageRealtimeOutbox` oraz
`Tests/…/StorageRealtimeEventTests.cs`.

Dowody (faktycznie uruchomione):

- `dotnet build` — bez ostrzeżeń i błędów;
- `dotnet ef migrations has-pending-model-changes` — „No changes have been made
  to the model since the last migration.”;
- `dotnet ef migrations script --idempotent` — exit 0, tabela outboxa obecna
  w skrypcie;
- `dotnet test` — testy kanału: 5 jednostkowych (kursor, koperta bez treści,
  grupy docelowe, walidacja zakresu, ponowienia) i 2 na realnym PostgreSQL
  (mutacja zapisuje zdarzenie ze swoim zakresem; odczyt w zakresie workspace
  widzi je, zakres prywatny tego samego użytkownika nie; kursor w luce historii
  żąda pełnego odświeżenia, a kursor bez luki nie).
- `dotnet test` (pełny zestaw) — **powodzenie 1223, pominięte 4, niepowodzenie 7,
  łącznie 1234**. Wszystkie siedem niepowodzeń to wcześniejsze, niezwiązane
  `MeEndpointsTests` (hasło i sesje); żadne nie dotyczy Storage ani realtime.
  To potwierdza w pełnym przebiegu, a nie tylko w izolacji, że test retencji
  opisany niżej jest już stabilny.

**NOT RUN — live dwóch sesji.** Dowód, że dwa podłączone klienty widzą zmianę
bez odświeżania, wymaga uruchomionego Backendu i dwóch sesji UI. Nie ma ich
w tej sesji, a test jednostkowy nie jest tym dowodem. Do domknięcia razem
z live E2E współedycji z F6.

Uwaga o teście retencji: pierwsza wersja zakładała, że kolejność nadania
sekwencji odpowiada kolejności wywołań publikacji. Tak nie jest — EF batchuje
zapisy, więc rekord „środkowy” bywał najniższą sekwencją i test padał tylko
w pełnym przebiegu. Poprawka jest w teście (odczyt i sortowanie po sekwencji),
a nie w regule wykrywania luki, bo to ona jest poprawna: luką jest brak rekordu
bezpośrednio po kursorze.

Do domknięcia w kolejnych krokach: **Front nie konsumuje jeszcze tego kanału**
(typowy port + scalanie bez resetowania folderu, scrolla i zaznaczenia).
Backend publikuje zdarzenia i umie je odtworzyć; strona kliencka jest następnym
pakietem, bo bez odbiorcy sam kanał niczego nie zmienia w UI.

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

### 2026-09-20 — DEMO-SEED-STAGING: kontrolowany seeder danych testowych

Status: **kod i kontrakt operatorski GOTOWE; instalacja rootowa na VPS WYMAGANA**.

Seeder pozostaje niedostępny przez HTTP i domyślnie odrzucony poza
`Development`. Staging może go uruchomić wyłącznie jednorazowym kontenerem
przez rootowy wrapper `deployment/staging/server/devplanner-seed-demo`, który
przekazuje jawną flagę zezwalającą, login właściciela i hasło z chronionego
`/etc/devplanner/demo-seed.env`. Delegowane konto `codex-staging` dostaje tylko
prawo wykonania dokładnie tego wrappera; nie dostaje powłoki root, Dockera ani
odczytu sekretów. Instalacja wrappera, sudoers i pliku hasła wymaga uprawnień
root, których agent celowo nie posiada.

Pierwszy bieg stagingowy wykrył i naprawił defekt przejścia wersji pliku
`README-demo.txt`: selekcja pliku nie może wymagać wersji 2 przed jej
utworzeniem. Poprawka została wdrożona jako `3d735fd`; ponowny bieg jest
idempotentny. Staging potwierdza: 10 kont z awatarami, workspace, 3 projekty,
9 milestone’ów, 31 zadań i 9 plików.

### 2026-09-20 — FILES-F8-RT-CLIENT: Front konsumuje kanał zmian

Status: **DONE** dla odbioru kanału i odświeżania listy; **live dwóch sesji
NOT RUN**, **macOS sprawdza użytkownik**, **Windows/Linux NOT RUN** (brak
środowiska).

Zakres domknięty we Froncie:

- **Port domenowy** `StorageRealtimeClient` (`domain/storage/ports/`) z typowanym
  `StorageRealtimeEvent` (7 typów serwera + lokalny `resyncRequired`) i
  `StorageRealtimeTarget` (`domain/storage/models/`). Prezentacja nie importuje
  SignalR; właścicielem cyklu życia jest ekran, który tworzy kanał.
- **Adapter** `StorageRealtimeClientAdapter` nad wspólnym transportem SignalR:
  jedena z siedmiu metod zdarzeń, subskrypcja zależna od zakresu
  (`SubscribePersonal` / `SubscribeWorkspace` / `SubscribeProject`), odtworzenie
  historii po nieprzezroczystym kursorze po ponownym połączeniu, deduplikacja po
  `eventId` i zamiana `resyncRequired` na zdarzenie lokalne. Brak połączenia
  degraduje kanał, a nie ekran: lista i ręczne odświeżenie działają dalej.
- **Adresowanie grup** musi być zgodne co do znaku z serwerem (`{guid:N}` —
  małe litery, bez myślników), inaczej odłączenie od nieistniejącej grupy cicho
  nic nie robi i zostają aktywne subskrypcje poprzedniego zakresu. Pokryte
  testem zmiany zakresu.
- **Koordynator** `StorageRealtimeRefreshCoordinator`: zdarzenie jest sygnałem,
  nie danymi, więc odświeża bieżący widok **w miejscu** — bez zmiany folderu,
  bez zwijania listy do pierwszej strony (`limit` = tyle, ile widać), bez stanu
  ładowania i bez podmiany listy na ekran awarii. Seria zdarzeń jest zbierana
  w oknie 250 ms; `resyncRequired` odświeża natychmiast, bo zwłoka pokazywałaby
  listę, o której wiadomo, że jest nieaktualna.
- **Błąd odświeżenia** idzie istniejącym trwałym bannerem F8 (komunikat, kod,
  `traceId`) i oferuje `Ponów`, bo odczyt listy jest idempotentny. Lista pod
  bannerem zostaje bez zmian — użytkownik nie traci tego, co widzi.
- **Zaznaczenie** zawęża się do elementów, które nadal istnieją
  (`StorageSelectionCubit.retain`), a uprawnienia zaznaczonych plików pochodzą
  ze świeżej odpowiedzi.
- **Kompozycja**: fabryka kanału powstaje tylko dla klienta z tokenem dla huba
  (desktop) i tylko dla zakresów, które mają odpowiednik w hubie. Kosz,
  udostępnione, ostatnie, ulubione i zakres zasobu zostają bez kanału — świadomie,
  zamiast podszywać się pod zakres prywatny, który pokazuje inny zbiór plików.
  Webowy BFF bez tokenu działa jak dotąd, bez odświeżeń na żywo (jak Zadania).

Nowe pliki: `domain/storage/models/storage_realtime_event.dart`,
`domain/storage/models/storage_realtime_target.dart`,
`domain/storage/ports/storage_realtime_client.dart`,
`data/realtime/storage/storage_realtime_client_adapter.dart`,
`data/realtime/storage/storage_realtime_composition.dart`,
`presentation/storage/shell/storage_realtime_refresh.dart`,
testy `test/workspaces/data/realtime/storage_realtime_client_adapter_test.dart`,
`test/workspaces/presentation/storage/realtime/storage_realtime_refresh_test.dart`,
`test/workspaces/presentation/storage/realtime/storage_realtime_shell_test.dart`,
`test/test_support/storage_realtime_fake_client.dart`.
Zmienione: `storage_shell_page.dart` (właściciel kanału, start przy zmianie
zakresu, zwolnienie razem z ekranem), `storage_browser_cubit.dart`
(`refreshFromRealtime`, odroczenie odświeżenia na czas ładowania),
`storage_selection_cubit.dart` (`retain`), router (fabryka w kompozycji trasy).

Dowody (faktycznie uruchomione):

- `flutter analyze` — **No issues found**;
- `flutter test` (pełny zestaw) — **1357 testów, wszystkie zielone**, w tym
  6 testów adaptera, 8 testów odświeżenia (cubit + koordynator) i 3 testy
  widgetowe shella (kanał zakresu trasy, brak kanału dla kosza, zamknięcie
  kanału przy wyjściu);
- `flutter gen-l10n` — bez zmian w wygenerowanych plikach (pakiet nie dodaje
  tekstów);
- `flutter build web --wasm` — zbudowane, `build/web/main.dart.wasm` obecny;
- `git diff --check` — czysto w obu repozytoriach.

Lekcja z bramki: oczekiwanie `StreamSubscription.cancel()` w zamknięciu ekranu
nie kończy się w strefie testów widgetowych (przyszłość domyka się w strefie
głównej), więc sprzątanie po ekranie wisiało, a kanał nie dochodził do
zwolnienia. Koordynator nie wyczekuje anulowania — spójnie z zasadą „zamknięcie
ekranu nie czeka na odsubskrybowanie”, a transport i tak zamyka się razem
z klientem. Atrapa kanału w testach nie używa kontrolera synchronizowanego.

**NOT RUN.** Live dwóch sesji (kanał + współedycja OnlyOffice) wymaga
uruchomionego Backendu, żywego serwera dokumentów i dwóch klientów — tego dowodu
w tej sesji nie ma. `flutter build macos` **sprawdza użytkownik sam** (żywa sesja
`flutter run -d macos` innego agenta pisze do tego samego `build/macos`).
`flutter build windows` i `flutter build linux` — NOT RUN, brak środowiska.

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

Status: **DONE** dla migracji testów i usunięcia martwego kodu; **live dwóch sesji
NOT RUN**, macOS sprawdza użytkownik, Windows/Linux NOT RUN (brak środowiska).

Zakres:

- **Wspólny harness shella** `test/test_support/storage_shell_harness.dart`:
  jedno `pumpStorageShell` z zakresem, kompozycją, portami, locale i viewportem
  oraz przykładowe pliki i foldery. Wszystkie nowe testy modułu montują ten sam
  host, więc nie odtwarzają własnych wrapperów i nie rozjeżdżają się z runtime.
- **Nowe testy zamiast pionowych**: `shell/storage_shell_access_test.dart`
  (kompozycja read-only nie pokazuje akcji mutujących, desktop je pokazuje, ACL
  pliku wyłącza akcję mimo uprawnień kompozycji, typed 403 pokazuje powierzchnię
  odmowy, a nie pustą listę) oraz `shell/storage_shell_mutations_flow_test.dart`
  (utworzenie i zmiana nazwy folderu, usunięcie pliku i folderu z
  potwierdzeniem, anulowanie potwierdzenia, pobranie pliku z wiersza,
  przywrócenie z kosza, udostępnienie workspace'owi z potwierdzeniem,
  zakończony upload). Każda mutacja jest rozliczana z **jednego** odświeżenia
  listy.
- **Usunięte**: 6 plików testów pionowych montujących read-only browser oraz
  9 plików martwej rodziny `StorageReadOnlyBrowserPage` (strona, treść, błąd,
  kafel, podgląd, akcje usuwania/przywracania/udostępniania/tworzenia folderu —
  1561 linii). Dwa pliki pionowe zostały okrojone do swoich testów cubita
  (upload, wersje), bo tylko ich testy widgetowe zależały od rodziny. Po
  sprzątnięciu nie ma w `lib` ani `test` żadnego odwołania do
  `StorageReadOnly*`.

**Defekt znaleziony przy migracji i naprawiony.** Trzy dialogi zwalniały
`TextEditingController` w trakcie animacji zamknięcia: `whenComplete(controller
.dispose)` w dialogu nowego folderu i nowego dokumentu oraz `dispose()` zaraz po
`await showDialog` w zmianie nazwy folderu. Każda przebudowa drzewa w tym oknie
(jak odświeżenie listy po zdarzeniu realtime albo zmiana stanu pod dialogiem)
sięgała po zwolniony kontroler: w debug `A TextEditingController was used after
being disposed`, w release martwe pole. Kontroler należy teraz do stanu dialogu
i jest zwalniany w `State.dispose()`, czyli wtedy, gdy widżet naprawdę znika.

Świadoma różnica względem starej strony: przywrócenie pliku z kosza w shellu nie
pyta o potwierdzenie (stara strona pytała). Przywrócenie jest nieodwracalnie
niegroźne, a test przypina kontrakt, który ma znaczenie: jedno odświeżenie listy
po udanej operacji.

Dowody (faktycznie uruchomione):

- `flutter analyze` — **No issues found**;
- `flutter test` (pełny zestaw) — **1335 zielonych, 4 czerwone**; wszystkie cztery
  czerwone to testy Kanban innego agenta (nowe, jeszcze nieśledzone pliki
  `kanban_card_interaction_states_test.dart` i `kanban_interaction_goldens_test.dart`
  oraz goldeny przy trwających zmianach w `kanban_card_tokens.dart`), zero
  powiązania ze Storage;
- `flutter test test/workspaces/presentation/storage test/workspaces/data/realtime`
  — **193/193**;
- `flutter build web --wasm` — zbudowane po sprzątnięciu (`build/web/main.dart.wasm`
  obecny);
- `git diff --check` — czysto w obu repozytoriach.

**NOT RUN.** Live dwóch sesji (kanał i współedycja OnlyOffice), `flutter build
macos` (sprawdza użytkownik), `flutter build windows` i `flutter build linux`
(brak środowiska).

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

### 2026-09-20 — STORAGE-REVIEW-FIXES: sześć uwag z review naprawionych

Status: **DONE dla wszystkich sześciu uwag** (4 × P1, 2 × P2); live dwóch sesji
nadal NOT RUN, macOS sprawdza użytkownik, Windows/Linux NOT RUN (brak środowiska).

**[P1-a] Historia workspace pomijała zdarzenia projektowe.** Worker wysyła
zdarzenia projektu także do grupy workspace'u, ale historia zakresu filtrowała
wyłącznie `ScopeType.Workspace`, więc klient workspace'u po reconnect nie
odtwarzał zmian z projektów. `StorageRealtimeEventStore.ScopeQuery` zwraca teraz
dla zakresu workspace'u zdarzenia `Workspace` **oraz** `Project` z tym samym
`WorkspaceId` — dokładnie ten sam zbiór, który dostaje na żywo z grupy.

**[P1-b] Pierwsze połączenie miało okno utraty zdarzeń.** Lista i kanał startują
równolegle, a adapter nie odtwarzał historii przy pierwszej subskrypcji, więc
zmiana między odczytem listy a dołączeniem do grupy nie docierała do ekranu.
Adapter nadrabia teraz historię **zawsze**, także przy pierwszej subskrypcji:
bez kursora czyta ogon historii (jedno żądanie, kursor startowy na końcu
historii), a po wznowieniu strony od swojego kursora aż do końca. Zdarzenia
z nadrobienia przechodzą tą samą drogą co live, więc ekran dostaje jedno
odświeżenie po podłączeniu zamiast zostać ze starą listą.

**[P1-c] Edytor ogłaszał „zapisano” przed potwierdzeniem backendu.**
`onDocumentStateChange(false)` mówi tylko, że edytor nie ma lokalnych zmian.
Stan sesji rozdziela teraz trzy rzeczy: brak zmian w edytorze, oczekiwanie na
serwer i potwierdzoną wersję. Po przejściu na „bez zmian” cubit pyta o szczegóły
pliku i potwierdza zapis dopiero wyższą wersją (`confirmedVersion`), a po oknie
kontroli przechodzi w jawny stan „zapis niepotwierdzony”. Wersja i flaga
odświeżenia listy powstają więc z odpowiedzi backendu, a nie z sygnału edytora —
to działa też w webowym BFF, gdzie nie ma realtime, który by to skorygował.
Callback OnlyOffice publikuje dodatkowo `storage.file.version.created`
w tym samym zapisie co wersja, więc inne sesje dostają sygnał odświeżenia.

**[P1-d] Rejestr OnlyOffice obsługiwał jedną sesję na dokument.** Drugi edytor
nadpisywał pierwszego, a callback bez jednoznacznego `actions.userid` mógł
przypisać zapis ostatniej osobie, która otworzyła dokument. Rejestr trzyma teraz
zbiór sesji pod kluczem dokumentu (`ActiveCount` = edytujący, nowe
`ActiveDocumentCount`), a zapytanie o autora odpowiada tylko jednoznacznie:
lista kandydatów z podpisanego callbacku zawęża wybór, a przy dwóch edytujących
bez jednoznacznego wskazania nie ma autora. Kolejność w `OnlyOfficeService` to
akcja z callbacku, potem konfiguracja edytora, a lista `users` wyłącznie gdy
wskazuje jedną osobę — pierwszy element listy nie jest już autorem. Zapis bez
ustalonego autora nadal powstaje (utrata treści byłaby gorsza), ale idzie jako
nieprzypisany: technicznym zapisującym jest właściciel pliku, zdarzenie realtime
nie dostaje `actorUserId`, a log `OnlyOfficeUnattributedSave` (7105) nazywa
sytuację. Zapis kończy też sesję wyłącznie tego edytora, który go wykonał.

**[P2-a] Globalna sekwencja powodowała fałszywe luki.** Numer zdarzenia jest
globalny, więc przerwy między zdarzeniami jednego zakresu są naturalne, a stara
reguła „brak rekordu bezpośrednio po kursorze” zgłaszała `ResyncRequired`
w normalnym ruchu wieloużytkownikowym. Utratę historii rozpoznajemy teraz po
horyzoncie zakresu: `ResyncRequired` jest prawdą, gdy kursor klienta jest
starszy niż najstarsze zachowane zdarzenie tego zakresu (strona zwraca
`OldestSequence`). Kursor zerowy („od początku historii”) nigdy nie jest utratą.

**[P2-b] Odtworzenie zatrzymywało się po pierwszych 100 zdarzeniach.** Kontrakt
strony niesie teraz `HasMore`, a klient pobiera kolejne strony, aż historia się
skończy. Po przekroczeniu budżetu stron (20 × 100) klient zgłasza jedno pełne
odświeżenie, więc kursor nigdy nie przeskakuje po cichu pominiętego fragmentu.

Nowe i zmienione pliki backendu: `Infrastructure/Storage/StorageRealtimeEventStore.cs`,
`Infrastructure/Storage/StorageEventsHub.cs`, `Contracts/Storage/StorageRealtimeContracts.cs`,
`Infrastructure/Ops/OnlyOfficeSessionRegistry.cs`,
`Application/Storage/OnlyOfficeService.cs`,
`Application/Storage/OnlyOfficeCallbackLog.cs`, `Endpoints/Storage/StorageEndpoints.cs`.
Frontu: `data/realtime/storage/storage_realtime_client_adapter.dart`,
`presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart`,
`.../storage_office_editor_actions_state.dart`, `.../widgets/storage_office_status_label.dart`
oraz teksty `storageOfficeSavingChanges` i `storageOfficeSaveUnconfirmed`.

Dowody (faktycznie uruchomione):

- `dotnet build` — 0 ostrzeżeń i błędów;
- `dotnet test` (pełny zestaw) — **1236 zielonych, 4 pominięte, 7 czerwonych,
  1247 łącznie**; wszystkie siedem czerwonych to wcześniejsze `MeEndpointsTests`
  (hasło i sesje), żadna w Storage, realtime ani OnlyOffice;
- `dotnet ef migrations has-pending-model-changes` — „No changes have been made
  to the model since the last migration.” (ten pakiet nie zmienia modelu);
- `flutter analyze` — bez uwag w plikach tego pakietu (dwie uwagi `unused_import`
  są w świeżym, nieśledzonym jeszcze pliku testowym modułu Kanban innego agenta);
- `flutter test` — **1353/1353**;
- `flutter build web --wasm` — zbudowane po zmianach;
- `git diff --check` — czysto w obu repozytoriach.

Nowe testy scenariuszy z review: przeplatane zakresy nie żądają odświeżenia
(`InterleavedScopesDoNotAskForFullRefresh`), historia workspace'u widzi zdarzenia
projektu (`WorkspaceHistoryIncludesProjectEventsOfThatWorkspace`), ponad 100
zdarzeń stronicuje się do końca (`HistoryBeyondOnePageReportsHasMoreAndContinues`),
horyzont zakresu wyznacza utratę historii
(`CursorOlderThanRetentionHorizonAsksForFullRefresh`), dwóch edytujących jednego
dokumentu (`TwoEditorsOnOneDocumentKeepTheirOwnSessions`), wieloosobowy callback
nie przypisuje zapisu pierwszemu z listy
(`SeveralUsersInCallbackDoNotAttributeTheSaveToTheFirstOne`), nadrobiona historia
odświeża listę po pierwszej subskrypcji (Front), a brak potwierdzenia kończy się
jawnym stanem, nie fałszywym „zapisano” (Front).

### 2026-09-20 — STORAGE-REVIEW-LIVE: żywy test dwóch sesji

Status: **DONE** dla kanału i współedycji na poziomie kontraktu; **NOT RUN** dla
klikania w prawdziwym edytorze OnlyOffice w dwóch przeglądarkach (brak automatyzacji
GUI na tym Macu) oraz dla buildów macOS/Windows/Linux.

**Środowisko.** Własna instancja API z dzisiejszym kodem (`dotnet run --urls
"https://localhost:5174;http://0.0.0.0:5073"`, issuer `https://localhost:5174/`,
klient desktopowy OpenIddict, kopia bazy `review_live`), MinIO/PostgreSQL/ClamAV
z istniejącego compose, kontener OnlyOffice bez zmian. Instancja innego agenta na
`5173` została nietknięta. Sesje: A = `misiek440` (SystemAdmin), B =
`kanban-b-1789899185`, oba w workspace `DevPlanner`; tokeny z Authorization Code
+ PKCE klienta `devplanner-desktop`.

**Test 1 — kanał zmian i odświeżenie listy** (`test_live/storage_realtime_live_test.dart`,
prawdziwy `StorageRealtimeClientAdapter` + prawdziwy SignalR):

- A subskrybuje kanał workspace (Bearer) i nadrabia historię;
- B tworzy dokument w workspace przez HTTP → **A dostaje zdarzenie live
  `storage.file.created`**, a lista czytana przez A zawiera ten plik (to jest
  stan, który odświeża widok po zdarzeniu);
- A rozłącza kanał, B tworzy dokument **w projekcie** tego workspace;
- A wraca → odtworzenie historii workspace **obejmuje zdarzenie projektowe**
  (dowód na P1-a w żywym systemie), a po nadrobieniu kolejne zdarzenia live
  docierają normalnie.

Pomiar na izolowanym workerze: każda mutacja → jedno zdarzenie live 1,0–1,6 s po
`HTTP 201`, w tym po ponownym połączeniu.

**Test 2 — współedycja jednego dokumentu** (`test_live/storage_onlyoffice_two_editors_live_test.dart`):

- A i B otwierają sesję edytora **tego samego dokumentu** → ten sam `documentKey`
  (rejestr nie nadpisuje pierwszego edytora);
- zapis wymuszony bez rozstrzygalnego autora (`users: [A, B]`, brak `actions`,
  podpisany JWT, treść pobrana z serwera na zaufanym adresie OnlyOffice; backend
  pobiera, skanuje i zapisuje wersję) → **v2 z autorem = właściciel pliku**
  (techniczny zapisujący), a zdarzenie realtime nowej wersji ma `actorUserId`
  **puste**;
- zapis z `actions[{userid: B}]` → **v3 z autorem B**, zdarzenie z autorem B;
- kolejny zapis bez autora → v4 znowu właściciel, czyli sesja współedycji trwa.

Stan w bazie po przebiegu: wersje v1 (utworzenie), v2 i v4 (zapis bez autora →
właściciel), v3 (autor B), wszystkie w jednym `documentKey`.

**Czego to nie dowodzi.** Prawdziwego klikania w edytorze: na tym Macu ZCode nie
ma zgody na nagrywanie ekranu, więc nie da się automatyzować GUI. Testowana
ścieżka to jednak dokładnie ta, którą napędza Document Server (dwie sesje, podpisany
callback, pobranie treści, skan, nowa wersja, zdarzenie), więc brakuje wyłącznie
warstwy przeglądarki. Odświeżenie widżetu po zdarzeniu pokrywają testy widgetowe
(`storage_realtime_refresh_test.dart`, `storage_realtime_shell_test.dart`).

**Znaleziska środowiskowe (nie defekty produktu, ale warte nazwania).**

1. Instancja API **bez** `WORKSPACES_SIGNALR_REDIS` w topologii z drugą instancją
   zabiera część rekordów outboxa (wspólna tabela) i publikuje je wyłącznie do
   własnych pokoi, więc klient podłączony do instancji z backplane'em **cicho nie
   dostaje tych zdarzeń**. To wyjaśnia pierwotną niestabilność żywego testu;
   dlatego przebieg powtórzono na izolowanej bazie. Wniosek operacyjny: w jednym
   wdrożeniu backplane musi być ustawiony na **wszystkich** instancjach — kod
   pilnuje tylko tego, że przy ustawionym Redisie jest unikalny identyfikator
   instancji.
2. Endpointy `/api/v1/admin/ops/*` wymagają claimu `permission` z Core, którego
   lokalny token OpenIddict nie niesie, więc licznik sesji OnlyOffice nie jest
   dostępny przez API lokalnie; stan rejestru rozstrzygnął test wersji i autorów
   wersji.
3. Allowlista pobrania callbacku przyjmuje wyłącznie host:port z
   `WORKSPACES_ONLYOFFICE_URL`, więc serwer treści testu działa na tym adresie
   (stały port), a kontener OnlyOffice pozostał nietknięty.

Nowe pliki: `Front/test_live/storage_realtime_live_test.dart`,
`Front/test_live/storage_onlyoffice_two_editors_live_test.dart` (poza `test/`, więc
nie wchodzą do domyślnego przebiegu; bez zmiennych `LIVE_*` są pomijane, żeby nie
zgłaszały fałszywego wyniku).

Dowody: `flutter test test_live/storage_realtime_live_test.dart` — **1/1**;
`flutter test test_live/storage_onlyoffice_two_editors_live_test.dart` — **1/1**;
`flutter analyze test_live` — bez uwag; `flutter test` (domyślny zestaw) —
**1353/1353**, `test_live/` poza zbiorem.

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

Status: **DONE dla wszystkich sześciu uwag** (3 × P1, 3 × P2) razem z testami
regresyjnymi, których brak wskazał review; żywy przebieg powtórzony na nowym
kodzie.

**[P1-1] Drugi zapis w tej samej sesji potwierdzał się poprzednią wersją.**
Próg potwierdzenia był stały (wersja z chwili otwarcia), więc po pierwszym
zapisie każda kolejna edycja „potwierdzała się” wersją, którą utworzył zapis
pierwszy. Próg jest teraz ruchomy: przy każdym wejściu w oczekiwanie ustawia się
na ostatnią wersję znaną jako zapisaną (`confirmedVersion`, a bez niej na wersję
z otwarcia), a po potwierdzeniu przesuwa się na nową wersję. Test: „drugi zapis
w tej samej sesji wymaga własnej, nowszej wersji”.

**[P1-2] Brak atrybucji omijał cofnięcie uprawnień.** Gdy autor nie był
rozstrzygalny, backend podstawiał właściciela pliku i sprawdzał ACL dla niego, co
zamieniało utratę atrybucji w eskalację (callback przypisany cofniętemu
użytkownikowi był odrzucany, a ten sam callback niejednoznaczny przechodził).
Teraz prawo zapisu sprawdzamy u **uczestników dokumentu** — kandydatów
z podpisanego ładunku i aktywnych sesji z rejestru. Gdy nikt z nich nie może już
pisać, zapis jest **odrzucany**. Gdy ktoś może, zapis powstaje, ale **bez
autora**: wersja ma nowe, nullowalne pole `ChangedByUserId` (puste przy braku
atrybucji), a `CreatedByUserId` pozostaje wyłącznie technicznym zapisującym.
Dodana migracja `AddStorageFileVersionChangedBy` jest addytywna i przenosi w
istniejących wersjach autora z zapisującego, żeby historia nie pokazywała
„autora brak” dla danych sprzed zmiany. Test:
`UnattributedOnlyOfficeSaveDoesNotBypassRevokedEditorAccess`.

**[P1-3] Niejednoznaczne zamknięcie usuwało wszystkie sesje dokumentu.**
Zamknięcie bez ustalonego autora wołało `Complete(key, null)`, co kasowało cały
dokument z rejestru razem z osobami, które wciąż edytują — i osłabiało atrybucję
kolejnych zapisów. Teraz zamykamy wyłącznie jednoznacznie wskazanych: najpierw
użytkowników z `actions`, a bez nich ustalonego autora; przy braku rozstrzygnięcia
nie zamykamy nikogo (sesje wygasza TTL). Test:
`UnattributedOnlyOfficeCloseKeepsOtherEditorsRegistered`.

**[P2-1] Zamknięcie modala przerywało potwierdzanie zapisu.** Stan „edytor bez
zmian, backend nie potwierdził wersji” nie był brany pod uwagę przy zamykaniu:
dialog pytał tylko o `hasUnsavedChanges`, a zamknięcie anulowało kontrolę, więc
webowy BFF mógł odświeżyć listę przed callbackiem. Dialog ma teraz **osobny
komunikat** dla tego stanu („Poczekać na potwierdzenie zapisu?”) z przyciskiem
„Poczekaj”, a zamknięcie czeka na wynik kontroli (`waitForConfirmedSave`,
ograniczony oknem kontroli), zanim odświeży listę. Testy: cztery przypadki
dialogu oraz `oczekiwanie na potwierdzenie kończy się wynikiem dla wołającego`.

**[P2-2] Handlery SignalR kumulowały się przy zmianie zakresu.** Rejestracja
odbywała się w każdym `start()`, a produkcyjny transport trzyma listę funkcji na
metodę, więc przejścia personal → workspace → project dokładały kolejne kopie
i mnożyły dekodowanie zdarzeń. Handlery są teraz rejestrowane **raz**
w konstruktorze adaptera. Test: „zmiana zakresu nie dokłada handlerów zdarzeń”
(otrata transportu w testach ma teraz produkcyjną semantykę listy na metodę).

**[P2-3] Nieudane pierwsze połączenie wyłączało kanał na stałe.** Po wyjątku
z `connect()` adapter odłączał subskrypcję i przestawał słuchać transportu, a
koordynator pomijał ponowienie tego samego zakresu. Teraz nasłuchiwanie stanów
zostaje, a kolejne próby idą z ograniczonym backoffem (trzy próby, odstęp
wstrzykiwany w testach); koordynator nie blokuje ponowienia. Test: „nieudane
pierwsze połączenie samo wraca do pracy”.

**Testy regresyjne wskazane przez review** (wszystkie dodane i zielone):
dwa kolejne zapisy w jednej sesji, wieloznaczny callback bez prawa zapisu
(odrzucenie) i z prawem (zapis bez autora), wieloznaczne zamknięcie zachowujące
współedytujących, zamknięcie modala w stanie oczekiwania, wielokrotna zmiana
zakresu z produkcyjną semantyką handlerów, nieudane pierwsze połączenie
z odzyskaniem.

Dowody (faktycznie uruchomione):

- `dotnet build` — exit 0, bez ostrzeżeń;
- `dotnet ef migrations has-pending-model-changes` — „No changes have been made
  to the model since the last migration.” (po dodaniu migracji);
- `dotnet test` (pełny zestaw) — **1238 zielonych, 4 pominięte, 7 czerwonych,
  1249 łącznie**; wszystkie siedem czerwonych to znane wcześniejsze
  `MeEndpointsTests` (hasło i sesje). W trakcie pakietu jeden test OnlyOffice
  padł z mojej własnej pomyłki w asercji (podmieniona oczekiwana liczba wersji
  przez zbyt szerokie podstawienie w edycji testów); po przywróceniu wartości
  cały zbiór OnlyOffice jest zielony (43/43);
- `flutter analyze` — **No issues found** (cały projekt, także pliki Kanban
  innego agenta);
- `flutter test` — **1370/1370**;
- `flutter build web --wasm` — zbudowane po zmianach;
- żywe testy na własnej instancji z dzisiejszym kodem — oba zielone
  (`storage_realtime_live_test.dart`, `storage_onlyoffice_two_editors_live_test.dart`),
  z zaostrzonymi asercjami autorstwa: brak atrybucji → `changedByUserId` puste,
  a właściciel wyłącznie jako techniczny zapisujący;
- `git diff --check` — czysto w obu repozytoriach.

**Uwaga operacyjna:** migracja `AddStorageFileVersionChangedBy` jest wymagana,
zanim nowy kod obsłuży zapis wersji; na współdzielonej bazie lokalnej trzeba ją
zastosować (`dotnet ef database update`), a instancja innego agenta działa na
starym kodzie, więc jej nie przeszkadza.

**Lekcja własna (kosztowała czas):** `dotnet build … | tail -3` ukrył błąd
CA1848 przez kilka iteracji i testy biegły na starej assembly, co przez chwilę
wyglądało jak defekt produktu. Od teraz bramkę budowania rozliczam z kodu wyjścia,
nie z ogona logu.

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

Status: **DONE dla wszystkich trzech uwag** (1 × P1, 2 × P2) wraz z brakującymi
przypadkami testowymi.

**[P1] Zestaw mieszany uczestników omijał cofnięcie dostępu.** Reguła „wystarczy
jeden uczestnik z prawem zapisu” pozwalała utrwalić treść wspólną dla całej sesji,
gdy właściciel nadal mógł pisać, a drugi współedytor był już po revoke. Przy braku
rozstrzygalnego autora wymagamy teraz prawa zapisu od **każdego** wskazanego
uczestnika (kandydaci z podpisanego ładunku i aktywne sesje rejestru). Jeden
cofnięty uczestnik wystarcza, żeby odrzucić zapis. Zestaw pusty też jest
odrzucany: nie ma kogo upoważnić, więc zapis nie może zostać przyjęty bez
podstawy. Test: przypadek „właściciel + cofnięty” w
`UnattributedOnlyOfficeSaveDoesNotBypassRevokedEditorAccess` (wcześniej wystarczał
właściciel, więc ten test jest regresyjny, nie opisowy).

Kontrola follow-up po review obejmuje również **pusty zbiór uczestników**:
callback bez `users`, `actions` i lokalnej sesji jest odrzucany fail-closed,
zanim powstanie rezerwacja obiektu lub wersja technicznie przypisana właścicielowi.

**[P2] Powiadomienie publikowało pusty UUID jako autora.** Domena i historia
wersji mówiły już „autor nieznany” (`ChangedByUserId = null`), ale
`StorageFileVersionNotificationService` przyjmował zwykły `Guid`, więc przy braku
atrybucji powstawało zdarzenie z autorem `00000000-…`. Kontrakt
`StorageFileVersionCreatedEvent` ma teraz `Guid? ChangedByUserId`, serwis
przyjmuje `Guid?`, a przy braku autora **nie wycisza nikogo** (właściciel dostaje
powiadomienie o zapisie, którego jest technicznym zapisującym) i publikuje
zdarzenie bez autora. Test: `UnattributedVersionNotifiesEveryoneAndPublishesNoAuthor`.

**[P2] Limit ponowień połączenia nigdy się nie wyczerpywał.** Timer retry wołał
`start(target)`, a to zaczynało od `_detachSubscription()`, które zerowało licznik
prób — każde niepowodzenie było więc znowu „pierwszą próbą” i kanał mógł
handshake'ować w nieskończoność. Ponowienie ma teraz osobną ścieżkę
(`_retryConnect`), która łączy się bez rozbierania subskrypcji, a licznik zeruje
się wyłącznie po udanym połączeniu albo przy świadomym wejściu w zakres (zmiana
zakresu bądź ponowne otwarcie). Test: `po wyczerpaniu limitu prób kanał przestaje
ponawiać` — po pierwszej próbie i trzech ponowieniach liczba prób zatrzymuje się
na 4, a świadome ponowienie wykonuje piątą.

Dowody (faktycznie uruchomione):

- `dotnet build` — **exit 0** (bramkę rozliczam z kodu wyjścia, nie z ogona logu);
- `dotnet ef migrations has-pending-model-changes` — z wymaganym
  `ConnectionStrings__Workspaces`: **exit 0**, „No changes have been made to the
  model since the last migration.”;
- `dotnet test` (pełny zestaw) — **1239 zielonych, 4 pominięte, 7 czerwonych,
  1250 łącznie**; wszystkie siedem czerwonych to znane wcześniejsze
  `MeEndpointsTests`; zbiór OnlyOffice 43/43, powiadomienia wersji zielone;
- `flutter analyze` — **No issues found** (cały projekt);
- `flutter test` — **1378/1378**;
- `flutter build web --wasm` — zbudowane;
- żywe testy na własnej instancji z nowym kodem — oba zielone;
- `git diff --check` — czysto w obu repozytoriach.

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

## 2026-09-22 — Composer Chat: pojedynczy pasek rich text

- [x] Usunięto drugi pasek, który pojawiał się przy zaznaczeniu i dublował
  akcje formatowania zawsze widocznego paska Quill. Akcje rich text mają teraz
  jedną implementację i jeden wiersz przewijany poziomo.
- [x] Pole Quill nie rysuje już ostrej ramki wewnątrz zaokrąglonej powierzchni
  composera; wysokość edytora jest mniejsza, a odstępy pochodzą z tokenów.
- Bramki: testy format commands + rich text codec **19/19 PASS**,
  `flutter analyze` bez problemów, `flutter build macos --debug` PASS,
  `git diff --check` PASS. Widget/golden pominięte zgodnie z decyzją właściciela.
- Otwarty odbiór: nie potwierdzono renderu; CUA zgłasza zablokowany Mac.

## 2026-09-22 — Historia panelu Chat: cursorowe doładowanie

- [x] Podłączono `ChatConversationCubit.loadMore()` do przewijania historii:
  lista pobiera starszą stronę przy dojściu do jej górnej krawędzi i nie odpala
  równolegle dwóch żądań dla tego samego cursora.
- [x] Dodano wskaźnik pobierania oraz widoczny retry na błędzie. Doładowanie
  starszych wiadomości nie zwiększa licznika nowych — testuje to funkcja
  `ChatMessageGrouping.countNewArrivals`.
- Testy Cubita i grupowania **20/20 PASS**; `flutter analyze` bez problemów;
  `flutter build macos --debug` PASS; `git diff --check` PASS. Bez widgetów.
- Niezweryfikowane na ekranie: zachowanie anchor/offset przy wielu stronach.
  Mac pozostaje zablokowany.

## 2026-09-22 — Odczyt wiadomości tylko po faktycznej widoczności (R10)

- [x] Zastąpiono warunek „panel zamontowany + aplikacja wznowiona” sprawdzeniem
  geometrii najnowszego dymka: co najmniej 50% jego obszaru musi przecinać
  viewport historii. W tle oraz na trasie przykrytej modalem odczyt nie idzie.
- [x] Po wznowieniu aplikacji, zmianie scrolla i zmianie historii widoczność jest
  ponownie sprawdzana. `markVisibleAsRead` pozostaje idempotentne, a badge
  odświeża się tylko po zaakceptowanym zapisie.
- Testy Cubita, grupowania i geometrii widoczności **24/24 PASS**;
  `flutter analyze` czysty; build macOS Debug PASS; `git diff --check` PASS.
- Otwarty: ręczny test scrolla i modala na działającym panelu oraz widgety/goldeny
  po akceptacji wyglądu. CUA nadal zgłasza zablokowany Mac.

## 2026-09-23 — CHAT-R14 follow-up: custom surfaces for creation and inbox

- [x] Kreator rozmowy korzysta z własnych kafli wyboru typu i zasad pisania;
  lista uczestników pokazuje avatary i stan zaznaczenia, a wyszukiwarka oraz
  pola formularza używają tokenów `ChatTheme`.
- [x] Skrzynka rozmów, chipy filtrów, reakcje i karty załączników korzystają z
  tokenów komunikatora zamiast domyślnych powierzchni/kolorów Material.
- [x] Ten sam motyw obejmuje listę zapisanych wiadomości, błędy w ustawieniach
  i banner błędu kreatora; lista zapisów używa własnego wiersza Chat zamiast
  standardowego `ListTile`.
- [x] Wspólne akcje modali, karty osoby, emoji i podglądu załącznika korzystają
  z rootowego hosta, żeby zachować focus, Escape i zgodną warstwę UI.
- [x] `flutter analyze` bez uwag; czysty `git diff --check`; wybrane testy czystej
  logiki **35/35 PASS**; `flutter build macos --debug` PASS.
- [ ] Otwarty odbiór: render UI i interakcje na żywo. CUA nadal zgłasza, że Mac
  jest zablokowany. Testy widgetowe i goldeny pozostają odłożone do akceptacji
  wyglądu przez właściciela.

### CHAT-R14 follow-up: akcja wysyłania i pusty panel

- [x] Przycisk wysyłania jest okrągły, ma stały dotykowy rozmiar i kolory
  dedykowane ChatTheme; usunięto zależność od domyślnego `IconButton.filled`.
- [x] Stan pustej kolumny rozmowy używa typografii i kolorów ChatTheme.
- [x] `flutter analyze`, `git diff --check` i macOS Debug build PASS.
- [ ] Render aplikacji czeka na odblokowanie Maca; brak oceny wizualnej na żywo.

### CHAT-R14 follow-up: popover „Nowy czat”

- [x] Wyszukiwarka katalogu, akcje grupa/kanał/ogłoszenie i wynik osoby mają
  powierzchnie, obramowania, typografię oraz ikony ChatTheme; wyniki pokazują
  awatary.
- [x] Błąd wyszukiwania ma czytelny stan błędu i retry; czyszczenie pola usuwa
  również poprzedni stan/wyniki Cubita.
- [x] `flutter analyze`, test tworzenia/katalogu **17/17**, macOS Debug build i
  diff check PASS.
- [ ] Wizualny odbiór w działającej aplikacji pozostaje otwarty (Mac zablokowany).

### CHAT-R14 follow-up: wyścigi w wyszukiwaniu osób i wiadomości

- [x] Zmiana frazy czyści wyniki i unieważnia odpowiedzi zapytań w locie w
  `ChatDirectorySearchCubit` i `ChatSearchCubit`; spinner działa przez debounce,
  nie pokazujemy stanu pustego ani osób znalezionych dla poprzedniej frazy.
- [x] Testy regresji czyszczenia i odpowiedzi w trakcie debounce; dwa zestawy
  wyszukiwania/kreacji **33/33 PASS**. Analyze, macOS Debug build i diff check
  PASS.

### CHAT-R14 follow-up: spójność requestów wyszukiwania

- [x] Weryfikacja race condition poszerzona na wyszukiwanie wiadomości: nowa
  fraza natychmiast czyści wyniki, unieważnia requesty oraz zachowuje otwarty
  widok. Użytkownik widzi loading w debounce.
- [x] Test `ChatSearchCubit` potwierdza, że odpowiedź starej frazy nie wraca i
  nowa odpowiedź jest wyświetlana; zestawy search/creation **33/33 PASS**.
- [x] `flutter analyze`, macOS Debug build i diff check PASS.

### CHAT-R14 follow-up: stany listy dodawania osób

- [x] Lista w modalu członków pokazuje instrukcję przed wpisaniem frazy, podpowiedź
  dla krótkiej frazy, lokalizowany błąd z retry i stan pustych wyników.
- [x] Nie pokazuje technicznego kodu API jako głównego komunikatu użytkownika.
- [x] Testy search/creation **33/33**, `flutter analyze`, build macOS Debug oraz
  diff check PASS.

### CHAT-R14 follow-up: statusy osób w liście członków

- [x] Statusy członków pobierane są partiami do 8 równoległych requestów zamiast
  sekwencyjnie; po zmianie listy nowi członkowie dostają status, usunięci są
  czyszczeni, a odpowiedzi starego składu są ignorowane.
- [x] Testy search/creation/member **33/33 PASS**, analyze, macOS Debug build i
  diff check PASS. Widgetów/goldenów nie uruchamiano.

### CHAT-R14 follow-up: przypięte i zapisane listy

- [x] Listy w arkuszach przypiętych/zakładek używają wierszy ChatTheme zamiast
  domyślnego `ListTile`; nie pokazują technicznych UUID wiadomości jako treści.
- [x] Wiersz przypiętej wiadomości zamyka arkusz i przewija otwartą rozmowę do
  celu przez `ensureTargetLoaded`.
- [x] Lokalizacje PL/EN, `flutter gen-l10n`, analyze, macOS Debug build i diff
  check PASS. Bez testów widgetowych/goldenów.
### CHAT-R29 — realtime statusów uczestników

- [x] Front konsumuje `chat.user_status.changed` z Chat Hub; typowany mapper
  obsługuje zmianę statusu, jego wyczyszczenie/wygaśnięcie i odrzuca niezgodny
  `userId` lub niepoprawny payload.
- [x] Linia statusu rozmówcy w nagłówku aktualizuje się bez ponownego wejścia do
  rozmowy; event realtime ma pierwszeństwo nad równoległym/nieaktualnym REST.
- [x] Backendowy kontrakt potwierdzono w `ChatRealtimeConnectionManager` i
  `ChatUserStatusService`; zmiana backendu nie była potrzebna.
- [x] Test mappera/usługi SignalR **9/9** i test Cubita status/presence **3/3**;
  `flutter analyze`, build macOS Debug i `git diff --check` PASS.
- [ ] Widget/golden testy i odbiór runtime odłożone: nie uruchamiać widgetów bez
  akceptacji wyglądu; CUA nadal zgłasza zablokowany Mac.

### CHAT-R30 — kontrolki w rootowym dialogu zgodne z ChatTheme

- [x] Wspólny `ChatSurfaceDialog` aplikuje style przycisków, pól i progress
  z `DevPlannerChatTheme`, mimo że dialog jest montowany przez root navigator.
- [x] `flutter analyze`, macOS Debug build i `git diff --check` PASS.
- [ ] Runtime dialogu do wizualnego potwierdzenia po uzyskaniu dostępu do Maca.

### CHAT-R31 — dedykowana paleta komunikatora

- [x] ChatTheme ma własne jasne/ciemne powierzchnie, zielony akcent i kontrastowe
  dymki; typografia nadal korzysta z fontów projektu.
- [x] Testy palety i kontrolek **3/3 PASS**, `flutter analyze`, macOS Debug
  build i `git diff --check` PASS.
- [ ] Runtime palety do wizualnego odbioru po odblokowaniu Maca.

### CHAT-R32 — bezpieczne „Zostaw jako tekst” przy długim wklejeniu

- [x] Treść wraca do edytora dopiero po udanym usunięciu przygotowanego TXT;
  błąd sprzątania zostawia decyzję i tekst poza szkicem, blokując duplikację.
- [x] Testy koordynatora załączników i decyzji long-paste **16/16 PASS**;
  `flutter analyze`, macOS Debug build i `git diff --check` PASS.
- [ ] Runtime działania karty pozostaje do odbioru po odblokowaniu Maca.

### CHAT-R33 — limit uczestników zgodny z typem rozmowy

- [x] Licznik i blokada miejsc są widoczne tylko dla grup, których backendowy
  limit wynosi 50. Kanały i ogłoszenia nie dostają limitu wymyślonego przez UI.
- [x] Testy logiki wyszukiwania/członków **14/14 PASS**, `flutter analyze`,
  macOS Debug build i `git diff --check` PASS.
- [ ] Runtime listy członków czeka na wizualny odbiór po odblokowaniu Maca.

### CHAT-R34 — menu kontekstowe wiersza skrzynki

- [x] Menu rozmowy działa z prawego kliknięcia, długiego przytrzymania oraz
  klawisza Menu/Shift+F10; wiersz ma też widoczny przycisk opcji rozmowy do
  otwarcia menu jednym kliknięciem.
- [x] Błędy wyciszania i archiwizacji mają lokalizowany komunikat zamiast
  surowego `error.message`; `flutter gen-l10n`, analyze, build macOS Debug i
  `git diff --check` PASS.
- [ ] Interakcje menu w runtime do sprawdzenia po odblokowaniu Maca; bez testów
  widgetowych przed akceptacją wyglądu.

### CHAT-R35 — szerokość kontrolek karty statusu

- [x] Pole wygaśnięcia ma pełną szerokość popovera, a DND osobny pełnoszeroki
  wiersz; długi polski tekst nie ściska już selektora czasu.
- [x] Testy logiki presetów/statusów **5/5 PASS** i `flutter analyze` PASS.
- [x] `flutter analyze`, testy logiki **5/5**, macOS Debug build i
  `git diff --check` PASS.
- [ ] Wizualny runtime nadal OPEN, bo Mac jest zablokowany. Widgetów/goldenów
  nie uruchamiać przed akceptacją wyglądu.

### CHAT-R36 — wspólny przełącznik ChatTheme

- [x] Dodano `ChatToggle` oparty na tokenach ChatTheme; używają go DND i
  ustawienia powiadomień. Usunięto jedyny `Switch.adaptive` z UI Chatu.
- [x] Testy ustawień globalnych **3/3**, testy logiki statusów **5/5**,
  `flutter analyze`, macOS Debug build oraz `git diff --check` PASS.
- [ ] Wygląd i obsługę fokusu w runtime potwierdzić po odblokowaniu Maca;
  testów widgetowych/goldenów nie uruchamiać przed akceptacją UI.

### CHAT-R37 — motyw menu kontekstowego w root navigatorze

- [x] `AppContextMenu` zachowuje `ThemeData` miejsca wywołania po otwarciu
  rootowej trasy. `DevPlannerChatTheme.applyControls` podmienia tokeny menu
  na paletę, typografię i geometrię ChatTheme także w rootowych dialogach;
  ikony, kursor i zaznaczenie pól używają akcentów ChatTheme.
- [x] Test tokenów ChatTheme **4/4**, test geometrii menu **4/4**,
  `flutter analyze` i macOS Debug build PASS.
- [ ] Render menu przy wiadomości/rozmowie pozostaje do odbioru w runtime;
  CUA nie może wejść do zablokowanego Maca.

### CHAT-R38 — lokalizacja i typografia pełnoekranowej rozmowy

- [x] Używany przez podwidok dyskusji `ChatConversationPageView` nie ma już
  polskiego nagłówka wpisanego na stałe; korzysta z ARB i ChatTheme zamiast
  starego importu `core/theme`.
- [x] `flutter gen-l10n`, `flutter analyze`, macOS Debug build i diff check PASS.
- [ ] Rzeczywisty wygląd tego legacy widoku nadal do potwierdzenia w runtime;
  widgetów/goldenów nie uruchamiać przed akceptacją UI.

### CHAT-R39 — usunięcie importów core l10n/theme z presentation Chat

- [x] Lista załączników, panel dyskusji, akcje wiadomości, ustawienia
  powiadomień i pełnoekranowa rozmowa korzystają z `foundation/l10n` oraz
  `foundation/theme`.
- [x] `rg` nie znajduje importów `core/l10n` ani `core/theme` w
  `lib/workspaces/presentation/chat`; `flutter analyze`, macOS Debug build i
  `git diff --check` PASS.
- [ ] Rzeczywisty runtime legacy podwidoków nadal do sprawdzenia na odblokowanym
  Macu; widget/golden tests pozostają odłożone.

### CHAT-R40 — weryfikacja kontraktu Backend Chat

- [x] Aktualny zestaw backendowych testów Chat: **231 PASS, 3 SKIP, 0 FAIL**;
  backendowy kod nie wymagał zmiany w tym pakiecie.
- [ ] Testy Redis/dwu-hostowego SignalR pozostają niezweryfikowane bez Redis na
  `localhost:6380`; pełny runtime aplikacji nadal czeka na wizualny odbiór.


### CHAT-R41 — naprawa fixture’ów Redis i dwu-hostowego SignalR (2026-09-23)

- [x] Redis worker test rejestruje `WorkspaceDbContext` i `IHubContext<ChatEventsHub>`
  w scope, z tym samym recorderem używanym przez manager połączeń.
- [x] Test dwóch hostów tworzy i sprząta prawdziwe lokalne `DeviceSession` oraz
  `LocalUser`; nie omija serwerowego filtra aktywnej sesji i weryfikuje revoke.
- [x] Pełna suite `FullyQualifiedName~Chat` z Redisem: **234/234 PASS, 0 SKIP**;
  backend build **0 warning / 0 errors**, `dotnet format veloryn-workspaces.csproj
  --verify-no-changes` PASS, changed test file scoped-format PASS, skrypty EF
  idempotentne dla obu kontekstów PASS. Pełna weryfikacja formatu projektu testowego
  wykazuje wcześniejsze whitespace diagnostics w innych plikach testów.
- [x] Front `flutter analyze` i `flutter build macos --debug` PASS.
- [ ] Wizualny odbiór UI pozostaje otwarty: macOS jest zablokowany dla CUA.
  Bez zmian backendowego API, schematu lub kodu produkcyjnego; bez deployu.

### CHAT-R42 — toolbar Quill w wąskim panelu (2026-09-23)

- [x] Wprowadzić układ zależny od szerokości: podstawowe akcje pozostają
  widoczne, a listy, cytat, blok kodu i czyszczenie formatowania przechodzą do
  lokalizowanego menu w wąskim composerze; szeroki widok pokazuje pełny pasek.
- [x] `flutter analyze` PASS; `flutter build macos --debug` PASS. W runtime przy
  oknie 800×630 potwierdzono, że podstawowe ikony nie są obcięte, a menu pokazuje
  komplet pięciu opisanych akcji. Widget/golden testów nie dodano ani nie
  uruchomiono zgodnie z decyzją użytkownika.

### CHAT-R43 — odbiór modali rozmów i statusu (2026-09-23)

- [x] Przy 800×630 obejrzano modal uczestników, wyszukiwanie i wybór osoby,
  kreator nowej rozmowy/grupy oraz ustawienia statusu z gotowymi statusami,
  własnym opisem, wygaśnięciem i DND.
- [x] Kreator grupy pokazuje politykę publikowania dla wszystkich albo tylko
  właścicieli/moderatorów. Anulowano wszystkie formularze; nie dodano osoby,
  nie utworzono rozmowy i nie zapisano statusu.
- [x] Obejrzano też menu kontekstowe wiadomości: odpowiedź, kopiowanie, wątek,
  reakcja, przekazanie, edycja/usunięcie, przypięcie i zakładka.
- [x] `flutter test` dla `chat_format_commands_test.dart` i
  `chat_composer_height_policy_test.dart`: **16/16 PASS**.
- [ ] Nie wykonano testu widgetowego/golden ani mutującej operacji stagingowej.

### CHAT-R49 — przewijana lista popovera „Nowy czat” (2026-09-23)

- [x] Popover ma ograniczoną wysokość, a kontakty/wyniki przewijają się
  wewnętrznie; nagłówek, wyszukiwanie oraz akcje grupy/kanału/ogłoszenia są
  nieruchome.
- [x] Runtime macOS przy 800×630 potwierdził przypięte kontrolki i przewijanie
  kontaktów. Staging `/health/live`, `/health/ready`, inbox, unread count i
  workspaces odpowiadały HTTP 200.
- [x] `flutter analyze`, macOS Debug build i Front `git diff --check` PASS.
  Pojedyncza instancja testowa została zamknięta; nie otwierano rozmów i nie
  zmieniano danych.
- [ ] Widget/golden tests odroczone do akceptacji UI. Całościowy odbiór wizualny
  Chat pozostaje otwarty.

### CHAT-R50 — menu formatowania Quill w ChatTheme (2026-09-23)

- [x] Overflow formatowania w Quill korzysta ze wspólnego `AppContextMenu`,
  w tym samym stylu co inne menu chatu; zachowuje stan wybranego formatu i
  istniejące komendy.
- [x] Skan produkcyjnego `presentation/chat` nie znajduje stockowego
  `PopupMenuButton`, `PopupMenuItem`, `DropdownButton`, `showMenu`,
  `AlertDialog`, `SwitchListTile`, `MaterialBanner` ani bezpośrednich
  `SnackBar`. `MenuAnchor` pozostał wyłącznie jako kotwica custom karty statusu.
- [x] `flutter analyze`, macOS Debug build i Front `git diff --check` PASS.
- [ ] Runtime render menu Quill pozostaje do obejrzenia bez otwierania lub
  modyfikowania rozmowy; widget/golden tests odłożone do akceptacji wyglądu.

### CHAT-R51 — pierwsze kliknięcie globalnego Chat (2026-09-23)

- [x] Badge unread nachodził na hit target ikony Chat i blokował otwarcie panelu.
  Odtworzono na żywo przy 33 wiadomościach unread; po poprawce badge jest
  `IgnorePointer`, a dostępna semantyka liczby pozostaje.
- [x] Runtime: zamknięcie otwartego panelu i ponowne otwarcie jednym kliknięciem
  działa; nie otwierano rozmów.
- [x] `flutter analyze`, macOS Debug build i Front `git diff --check` PASS.
  Testową instancję zamknięto (CUA: `DevPlanner isRunning=false`).

### CHAT-R52 — zwarty układ popovera przy małej wysokości (2026-09-23)

- [x] Przy niskim viewportcie akcje tworzenia grupy/kanału/ogłoszenia przechodzą
  do zwartego rzędu poziomego; wyszukiwarka i lista zachowują swój układ.
- [x] `flutter analyze` i macOS Debug build PASS.
- [ ] Ręczny odbiór małego viewportu OPEN: zmiana okna przez CUA zostawiła
  pusty obszar pod wyrenderowaną treścią, więc smoke test nie jest wiarygodny.
  Przyczyna nierozstrzygnięta; nie otwierano rozmowy.
- [x] Instancja DevPlanner zamknięta po teście.

### CHAT-R53 — porządek instancji podczas ręcznego QA (2026-09-23)

- [x] `AGENTS.md` wymaga używania najwyżej jednej instancji desktopowej podczas
  ręcznej kontroli UI, ponownego użycia istniejącej sesji i zamknięcia procesu
  po kontroli.
- [x] Kontrola procesów po zgłoszeniu użytkownika potwierdziła brak działającej
  aplikacji DevPlanner i `flutter run`; nie uruchamiano nowej instancji.
- [ ] Nie uruchamiać runtime UI wyłącznie po to, by potwierdzić zamknięcie;
  przed następną kontrolą sprawdzić istniejący proces i po niej zamknąć go.

### CHAT-R55 — łączenie dymków w serię (2026-09-23)

- [x] Globalny Chat przekazuje pozycję wiadomości w serii do dymka. Narożniki
  na styku wiadomości tego samego autora są mniejsze, a układ dla wysłanych
  wiadomości jest lustrzany.
- [x] `flutter analyze`, macOS Debug build i `git diff --check` PASS.
- [ ] Nie uruchamiano aplikacji, widgetów ani goldenów; wizualny odbiór serii
  wymaga autoryzowanej sesji runtime.

### CHAT-R56 — audyt enumów przewodowych Chat (2026-09-23)

- [x] Test enumeruje wszystkie wartości Fluttera dla typów rozmowy, scope,
  preferencji powiadomień, statusu delivery, filtra inbox i ról członków.
- [x] Round-trip request/response oraz jawne `wireValue` i `fromWire` mają
  dokładne dopasowanie do pisowni backendu; `flutter test` **1/1 PASS**.
- [x] Backend sprawdza HTTP serializer/OpenAPI: **8/8 PASS**.
- [ ] Publiczny staging Swagger odpowiada HTTP 500; nie można porównać z jego
  aktualnym dokumentem. Nie wykonywano deployu.

### CHAT-R57 — zawijanie długich URL-i bez potwierdzenia linku (2026-09-23)

- [x] Długie URL-e w zwykłych segmentach treści dostają niewidoczne punkty
  łamania także bez metadanych linku z backendu; taki URL pozostaje nieklikalny.
- [x] Test `chat_message_display_policy_test.dart`: **8/8 PASS**; analiza trzech
  zmienionych plików i `git diff --check` PASS.
- [ ] Brak testu widgetowego/golden i brak przeglądu runtime zgodnie z decyzją
  użytkownika; potrzebny wizualny odbiór po zalogowaniu.

### CHAT-R58 — serwerowe wyszukiwanie skrzynki

- [x] Dodano opcjonalne `query` do `GET /api/v1/chat/inbox`; wyniki obejmują
  tytuły rozmów i aktywne profile uczestników, a ACL/filtrowanie/kursor
  pozostają po stronie serwera.
- [x] Front obsługuje query przez Retrofit, debounce 300 ms, reset kursora i
  frazę w kolejnych stronach.
- [x] Backend full suite **1304 PASS, 0 FAIL, 4 SKIP**; Front adapter/Cubit
  **22/22 PASS**; analiza źródeł Front i format Backend PASS.
- [x] macOS Debug build PASS; staging deploy nie wykonano (skrypt wymaga
  czystego checkoutu z zatwierdzonym commitem; nie było polecenia commit/push).

### CHAT-R60 — kompletność wyszukiwania kontaktów inboxu (2026-09-23)

- [x] Backend usuwa limit 50 dopasowanych profili i wyszukuje wyłącznie login/
  nazwę aktywnych członków rozmów widocznych dla użytkownika; bez dopasowań
  e-mail i bez poszerzania ACL.
- [x] Regresja PostgreSQL dla 51 pasujących kontaktów: `ChatInboxPostgresTests`
  **13/13 PASS**; format zmienionych plików i `git diff --check` PASS.
- [x] Zmiana nie modyfikuje kontraktu Flutter/OpenAPI, enumów ani schematu;
  Front nie wymaga generatora, migracji ani wdrożenia.
- [ ] Ręczny odbiór UI nadal oczekuje na autoryzowaną sesję. GUI oraz
  widget/golden testy nie były uruchamiane.

### CHAT-R61 — zakotwiczone menu emoji composera (2026-09-23)

- [x] Przycisk emoji composera otwiera picker zakotwiczony przy kontrolce,
  bez pełnoekranowego scrim/dialogu; wyszukiwanie, kategorie, ostatnie emoji
  i odcienie skóry pozostają dostępne.
- [x] Pickery statusu oraz reakcji pozostają modalne; zmiana ogranicza się do
  wyboru emoji do szkicu wiadomości.
- [x] `flutter analyze --no-pub` oraz macOS Debug build z adresem staging PASS.
  Jedna instancja potwierdziła geometrię menu, Escape oraz brak mutacji
  wiadomości; po kontroli proces zakończył działanie.
- [ ] Widget/golden testy odroczone zgodnie z instrukcją użytkownika. Bez
  zmian API, OpenAPI, enumów, schematu i Backend.

### CHAT-R62 — badge’e nieprzeczytanych zgodne z ChatTheme (2026-09-23)

- [x] Badge wiersza, suma w panelu i globalny badge ikony Chat używają
  `sendButtonSurface`/`sendButtonForeground`; zniknął niebieski kolor linku i
  czerwony kolor błędu.
- [x] `flutter analyze --no-pub` i macOS Debug build PASS.
- [x] W jednej instancji potwierdzono zielone badge globalne, panelu i wiersza
  rozmowy oraz zakotwiczone menu emoji; aplikację zamknięto i potwierdzono
  `isRunning=false`.
- [x] Bez zmian Backend/API/schematu; widget/golden testy odłożone zgodnie
  z dyspozycją użytkownika.

### CHAT-R63 — zbiorcza rewalidacja i QA runtime (2026-09-23)

- [x] Front `flutter analyze` i macOS Debug build PASS.
- [x] Ręcznie sprawdzono inbox/rozmowę, menu wiadomości, picker emoji,
  członków, wyszukiwanie osoby do dodania i kreator grupy; anulowano przed
  zapisem. Jedna instancja została zamknięta po kontroli.
- [ ] Pierwszy stan realtime wskazał chwilowe `offline`, znikające po
  załadowaniu rozmowy; nie wykonano dwu-sesyjnego E2E.
- [ ] Widget/golden testy pozostają odłożone; pełna akceptacja nowoczesnego UI
  przez użytkownika nadal otwarta.

## 2026-09-23 — CHAT-R64: poprawny stan początkowy realtime

- [x] `ChatRealtimeStatusCubit` ignoruje wyłącznie początkowy snapshot
  `disconnected`, który nie wynika z próby połączenia. Panel pozostaje w stanie
  „łączenie” do zdarzenia cyklu życia; późniejsze `disconnected` po connecting,
  connected lub reconnecting nadal od razu pokazuje stan offline.
- [x] Test Cubita sprawdza początkowy snapshot, reconnect, connected i rzeczywisty
  disconnect. Cubit + klient SignalR: **12/12 PASS**; `dart analyze` zmienionych
  plików PASS.
- [ ] Nie uruchamiano aplikacji ani testów widgetowych/golden. Runtime i
  dwu-sesyjne E2E SignalR pozostają otwarte; bez zmian Backend/API/schematu.

## 2026-09-23 — CHAT-R65: skok do starej rozmowy z zapisanych wiadomości

- [x] Otwieranie zapisanej wiadomości spoza załadowanej skrzynki pobiera
  rozmowę po ID przez `ChatConversationRepository.getConversation` (backend
  ponownie sprawdza ACL), zamiast skanować maksymalnie dziesięć stron inboxa.
- [x] Błąd/odmowa dostępu pokazuje lokalizowany komunikat zamiast cichego
  zignorowania kliknięcia.
- [x] `dart analyze` zmienionych plików oraz pełny `flutter analyze --no-pub`
  PASS; repozytorium i realtime **21/21 PASS**; macOS Debug build PASS
  (istniejące ostrzeżenie SPM dla dwóch `media_kit` pluginów);
  `git diff --check` PASS.
- [ ] Nie uruchamiano GUI/widget/golden; nie zmieniano API/backendu. Pełny
  odbiór UI i dwu-sesyjne realtime nadal otwarte.

## 2026-09-23 — CHAT-R66: smoke test globalnego panelu w świeżym buildzie

- [x] Jedna instancja macOS otworzyła globalny Chat jednym kliknięciem.
  Obejrzano listę, trzy kolumny w ciemnym wariancie ChatTheme oraz popover
  „Nowy czat” z akcjami grupa/kanał/ogłoszenie i kontaktami.
- [x] Popover zamknięto Escape; nie wybrano kontaktu ani rozmowy, nie zmieniono
  unread ani danych. Poprzedni jasny motyw przywrócono.
- [x] DevPlanner zakończono po smoke teście; CUA potwierdziło
  `isRunning=false`.
- [ ] Nie otwierano istniejącej rozmowy, by uniknąć zmiany jej stanu odczytu.
  Odbiór historii, composera, menu wiadomości oraz dwu-sesyjne realtime są
  nadal otwarte; bez testów widgetowych/goldenów.

## 2026-09-23 — CHAT-R67: zgodność komentarzy wyszukiwarki z kontraktem

- [x] Komentarze przy globalnym panelu i polu inboxa opisują teraz serwerowe
  wyszukiwanie nazw rozmów/aktywnych uczestników; osobno wskazują wyszukiwanie
  treści wiadomości. Usunięto nieaktualny opis filtrowania tylko załadowanych
  wierszy.
- [x] `git diff --check` PASS. Zmiana dokumentacyjna w kodzie; testów nie
  uruchamiano.

### CHAT-R70 — akcje dialogów zgodne z motywem Chat (2026-09-23)

- [x] Oddzielono `actionText` od `linkText`: przyciski tekstowe w dialogach
  używają kontrastowej zieleni ChatTheme, a linki w wiadomościach zachowują
  niebieski kolor treści.
- [x] Ręczny smoke test na macOS potwierdził zielone akcje w kreatorze grupy.
  W tym samym flow potwierdzono, że zaznaczenie uczestnika do grupy nie pokazuje
  komunikatu o otwieraniu istniejącego DM. Nie utworzono rozmowy ani nie
  zmieniono unread.
- [x] Theme, tworzenie rozmów i katalog/members: **38/38 PASS**;
  `flutter analyze --no-pub`, macOS Debug build i `git diff --check` PASS.
- [ ] Widget/golden tests nadal odłożone do akceptacji wyglądu. Dwu-sesyjne
  realtime pozostaje niepotwierdzone.
- [ ] Staging API readiness zwraca HTTP 200, ale strona `/` nadal zwraca HTTP
  500 przez Nginx. SSH read-only potwierdził, że `/srv/devplanner/frontend/current`
  nie istnieje; trzeba ustalić i wykonać właściwy proces publikacji Frontu.

### CHAT-R71 — zachowanie dolnej krawędzi tapety (2026-09-23)

- [x] `DecorationImage` shellu zachowuje `BoxFit.cover`, ale używa
  `Alignment.bottomCenter`; przy proporcjach wymagających pionowego cropu kadr
  pozostaje zakotwiczony przy dole.
- [x] `flutter analyze --no-pub`, macOS Debug build i `git diff --check` PASS.
- [ ] Nie udało się ręcznie ustawić wymiarów natywnego okna przez CUA, więc
  zgłoszony kadr ultra-wide/małego okna pozostaje bez wizualnej reprodukcji.
  Widget/golden testów nie uruchamiano.

### CHAT-R72 — kontrola przepływu załączników (2026-09-23)

- [x] Composition root dostarcza Chat session API, Storage tickets, izolowany
  presigned PUT oraz platformowy download/thumbnail. Brak autoryzowanego
  transportu pozostawia akcje załączników wyłączone (fail-closed).
- [x] Upload queue, upload owner, selection, coordinator, długi tekst TXT,
  drag/drop, upload/access adapters i Storage composition: **50/50 PASS**.
- [ ] Testów widgetowych/golden nie uruchomiono zgodnie z dyspozycją; rzeczywisty
  upload/download w zalogowanej rozmowie nadal wymaga runtime QA.

### CHAT-R73 — dopasowanie kreatora nowego czatu do wzorca (2026-09-23)

- [x] Inspekcja macOS pokazała, że menu „Nowy czat” było za szerokie i
  wyspecjalizowane flow grupy nadal miało ogólny tytuł „Nowa rozmowa”. Popover
  ma teraz limit 320 px; tytuł kreatora odzwierciedla typ rozmowy, a dialog ma
  limit 440 px.
- [x] `dart format`, `flutter analyze --no-pub` oraz
  `flutter build macos --debug --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl`
  PASS. Ostrzeżenia SPM dotyczą dwóch istniejących pluginów `media_kit`.
- [ ] Build uruchomił workspace, lecz CUA zgłosiło zmianę stanu aplikacji przez
  użytkownika przed ręcznym potwierdzeniem nowych wymiarów i tytułu. Nie
  uruchamiano testów widgetowych/golden; pełny odbiór UI pozostaje otwarty.
- [ ] Staging `/` nadal odpowiada HTTP 500; katalog `/srv/devplanner/frontend/current`
  nie istnieje. Frontu nie opublikowano.

### STORAGE-IMAGE-PREVIEW — autoryzowany podgląd obrazów (2026-09-23)

- [x] Podgląd bieżącego obrazu i wersji pobiera bajty przez istniejący
  uwierzytelniony Storage API z kontrolą ACL i renderuje je przez `Image.memory`.
  Wcześniejszy `Image.network` otwierał chroniony `/stream` bez nagłówka
  Authorization, co powodowało przekierowanie do logowania.
- [x] `dart format`, analiza zmienionych plików i `git diff --check`: PASS.
- [ ] Pełne `flutter analyze --no-pub` wskazuje jedno niezwiązane ostrzeżenie
  `unawaited_return_in_try_block` w module Chat. Ręczny odbiór podglądu PNG
  w uruchomionej aplikacji i na stagingu pozostaje do wykonania po publikacji
  Frontu. Testów nie dodawano ani nie uruchamiano.

### STORAGE-ONLYOFFICE-READY — odsłonięcie interakcji CSV/TXT (2026-09-23)

- [x] Po `onAppReady` host odsłania ramkę edytora, nie czekając na
  `onDocumentReady`. Dialog wyboru kodowania/separatora CSV/TXT nie jest
  zasłaniany loaderem.
- [x] `onUserActionRequired` usuwa licznik 30 s na czas wyboru użytkownika;
  timeout po `onAppReady` pozostawia ramkę widoczną i pokazuje komunikat
  bez blokowania edytora. Logi etapów nie zawierają tokenów ani URL pliku.
- [x] `dart format`, analiza zmienionych plików i `git diff --check`: PASS.
- [ ] Odbiór `metryki.csv` po wyborze kodowania/separatora oraz trwałości
  zapisu pozostaje otwarty. Testów nie dodawano ani nie uruchamiano.

### STORAGE-ONLYOFFICE-ACTIONS — jedna obsługa akcji edytora (2026-09-23)

- [x] Eksport PDF/druk, pobranie i zapis kopii nie mogą działać równolegle;
  spóźniony eksport po timeoutcie nie trafia do następnej akcji.
- [x] Usunięto pływający duplikat przycisku zamknięcia, a postęp operacji i
  status zapisu wyświetlają się w stałych paskach. Zamknięcie w trakcie
  eksportu jest zablokowane; niepotwierdzony zapis wymaga decyzji użytkownika.
- [x] Po potwierdzeniu nowszej wersji przez Backend pojawia się trwały pasek
  „Zapisano” i komunikat; po timeoutcie widoczny jest brak potwierdzenia.
- [x] Wbudowane `Save Copy as` nie jest zgłaszane przez host, a odnośniki
  opuszczające główną ramkę WebView są blokowane. Backend ukrywa wtyczki,
  wewnętrzny druk i krzyżyk w podpisanej konfiguracji.
- [ ] Odbiór na stagingu: zapis nowej wersji, kopia, natywne drukowanie i
  zachowanie menu `Pobierz jako`. Trwałości nie uznaje się za potwierdzoną
  bez odczytu nowej wersji przez Backend.
