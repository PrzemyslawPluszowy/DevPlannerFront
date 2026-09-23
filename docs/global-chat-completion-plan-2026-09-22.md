
## Bieżący status i otwarte bramki — 2026-09-23

Historyczne sekcje niżej dokumentują wcześniejsze stany i wyniki. Ich stare
checklisty nie są same w sobie aktualną listą braków. Obecny kod ma już
tworzenie rozmów, członków, akcje wiadomości, wyszukiwanie, rich composer,
emoji, linki oraz zintegrowany upload załączników. Ostatni pakiet CHAT-R68:
analiza Fluttera, testy załączników **20/20**, Web/Wasm build, macOS Debug build
i diff check PASS. Pakiety R70–R71 sprawdzają limity przed odczytem plików
przeciągniętych oraz wybranych w systemowym pickerze; odrzucone pliki nie są
ładowane do pamięci.

Otwarte pozostaje sprawdzenie w zalogowanym runtime: pełna historia i composer,
drop/upload/pobranie/clipboard, odmowy ACL/revoke i cleanup oraz realtime na
dwóch sesjach. Ostatni zrzut ekranu pokazywał Codex, nie DevPlanner, więc nie
potwierdził UI. Widgety i goldeny są odroczone do akceptacji UI przez użytkownika.

Kontrola composer pipeline wykryła i zamknęła cichy no-op: file picker bez
portu uploadu nie odblokowuje już akcji zdjęcia/pliku. Menu tłumaczy brak
integracji. Weryfikacja pakietu: **28/28** testów załączników/composera, pełna
analiza, macOS Debug build i diff check PASS (CHAT-R69).

## Aktualizacja wykonania — 2026-09-23: drop załączników w composerze

Poprawiono hit-target: strefa dropu obejmuje cały composer także przy pustej
liście załączników i pokazuje nakładkę podczas przeciągania. Testy koordynatora
i adaptera 13/13, pełny `flutter analyze --no-pub`, macOS Debug build i
`git diff --check` PASS. Błąd odczytu pliku jest obsłużony lokalizowanym
komunikatem. Ręczny drop w zalogowanej rozmowie pozostaje otwarty; testów
widgetowych/golden nie uruchamiano.

## Aktualizacja wykonania — 2026-09-23: pełna liczba uczestników grupy

Nagłówek używa pełnego `participantCount` z inboxa. Backend zwraca najwyżej
cztery rekordy `participants` jako profile podglądu, więc nie można wyliczać z
nich liczby członków. Runtime zmienił błędne 4 osoby na zgodne z panelem
członków 9. Test adaptera rozróżnia 2 rekordy podglądu od 9 osób łącznie
(**10/10 PASS**), `flutter analyze`, macOS Debug build i oba `git diff --check`
PASS. Widgetów/goldenów nie uruchamiano; odbiór UI pozostaje OPEN.

## Aktualizacja wykonania — 2026-09-23

`ChatConversationMessageList` w Front nadal używał starego układu wiadomości jako
pełnych wierszy z kilkoma ikonami. Widok przełączono na wspólny `ChatMessageBubble`,
wyrównanie własnych wiadomości i jedno menu akcji, zgodnie z obowiązującą
specyfikacją UI §4. Weryfikacja: `flutter analyze` i `flutter build macos --debug`
PASS. Odbiór wizualny nadal **OPEN**: CUA raportuje zablokowany Mac. Widgety i
goldeny pozostają **DEFERRED** do akceptacji wyglądu przez użytkownika.

## Aktualizacja wykonania — 2026-09-23: kontrolki Chat

Front zastąpił domyślny `SwitchListTile` w preferencjach powiadomień wierszem z
`ChatTheme`, toasty oparte na bezpośrednim `SnackBar` wspólnym `AppToast`, a
`MaterialBanner` starszego widoku komunikatem błędu dopasowanym do ChatTheme.
Skan produkcyjnej gałęzi `presentation/chat` nie znalazł już `PopupMenuButton`,
`DropdownButton`, `SwitchListTile`, `AlertDialog`, `MaterialBanner` ani
bezpośredniego `SnackBar`. Weryfikacja: `flutter gen-l10n`, `flutter analyze`,
`flutter build macos --debug` i `git diff --check` PASS. Goldeny/widgety DEFERRED;
render runtime OPEN z powodu zablokowanego Maca.

## Aktualizacja wykonania — 2026-09-23: błąd odczytu statusu

Karta własnego statusu blokuje teraz edycję, jeśli `GET` statusu zakończy się
błędem; pokazuje lokalizowany komunikat i akcję retry. Chroni to przed zapisem na
podstawie nieznanego stanu, który mógł usunąć istniejący termin wygaśnięcia.
Weryfikacja: test logiki statusów 5/5, `flutter analyze` i macOS Debug build
PASS. Widget/manualny odbiór karty nadal OPEN; testów widgetowych nie uruchamiano.

## Aktualizacja wykonania — 2026-09-23: cleanup TXT

Odrzucenie karty długiego wklejenia po rozpoczęciu uploadu usuwa teraz
przygotowany plik z selekcji i odwołuje sesję; „Zostaw jako tekst” nie zostawia
już ukrytego załącznika, który można było przypadkiem wysłać. Wysyłka pozostaje
zablokowana w trakcie cleanupu. Test koordynatora Storage 7/7, `flutter analyze`
i macOS Debug build PASS; widgety/goldeny DEFERRED.

## Aktualizacja wykonania — 2026-09-23: fallback miniatur

Załącznik obrazu pokazuje podgląd wyłącznie po uzyskaniu niepustych bajtów przez
autoryzowany port. Brak/odmowa miniatury wraca do zwykłego otwarcia pliku zamiast
pustego preview. Karty są kluczowane identyfikatorem załącznika, co zapobiega
przenoszeniu stanu miniatur przy zmianie listy; etykiety używają `ChatTheme`.
`flutter analyze`, macOS Debug build i diff check PASS. Widget/manualny runtime
review pozostaje OPEN.


## Aktualizacja wykonania — 2026-09-23: błędy tworzenia rozmowy

Popover i kreator nie renderują już surowego kodu API; pokazują zwięzły
lokalizowany komunikat błędu. `flutter analyze`, `flutter build macos --debug`
i `git diff --check` PASS. Widgety/goldeny pozostają DEFERRED, runtime review
OPEN, ponieważ Mac jest zablokowany.


## Aktualizacja wykonania — 2026-09-23: awatary i obecność autorów

Dla autorów wiadomości w grupach/kanałach przekazujemy do historii avatar URL z
katalogu uczestników; awatar ma znacznik online wyłącznie przy potwierdzeniu w
snapshotcie SignalR. `flutter analyze`, macOS Debug build i diff check PASS.
Widgety/goldeny DEFERRED; ręczny runtime review OPEN (Mac zablokowany).


## Aktualizacja wykonania — 2026-09-23: modal członków

Profile członków i karta osoby pokazują awatary z katalogu; komunikaty błędów są
lokalizowane. Usuwanie wymaga potwierdzenia. Menu nie oferuje zwykłej zmiany roli
na Owner ani zarządzania istniejącym właścicielem. Test logiki członków 14/14,
`flutter gen-l10n`, analiza i build macOS PASS. Widgety/goldeny DEFERRED; ręczny
odbiór renderu OPEN (Mac zablokowany).


## Aktualizacja wykonania — 2026-09-23: role i usuwanie członków

Zarządzanie nie oferuje zwykłej zmiany roli na Owner ani edycji istniejącego
właściciela; usunięcie członka wymaga potwierdzenia. Błędy członkostwa są
lokalizowane, a profile pokazują zdjęcia. `flutter gen-l10n`, analiza, testy
członków 14/14 i macOS Debug build PASS. Widgety/goldeny DEFERRED; runtime UI
OPEN (Mac zablokowany).


## Aktualizacja wykonania — 2026-09-23: lokalizacja błędów Chat

Aktywne widoki Chat nie renderują już bezpośrednio `apiCode`/`error.message` w
przepływach wyszukiwania, wzmianek, statusu, przypiętych/zakładek, powiadomień,
skrzynki, rozmowy, wątków, dyskusji i edycji. Komunikaty są lokalizowane i
uwzględniają cofnięty dostęp/konflikt edycji. Testy cubitów 17/17,
`flutter gen-l10n`, analiza, macOS Debug build i diff check PASS. Widgety/goldeny
DEFERRED; ręczny runtime UI nadal OPEN.


## Aktualizacja wykonania — 2026-09-23: retry przypiętych i zakładek

Nieudany pierwszy odczyt listy przypiętych wiadomości lub zakładek nie pokazuje
już bezterminowego spinnera. Obie listy udostępniają stan błędu i ponowienie
żądania. `flutter analyze`, macOS Debug build i diff check PASS; bez testów
widgetowych/goldenów. Podgląd web kończy się na logowaniu BFF i nie zweryfikował
rozmów.

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

## Aktualizacja wykonania — 2026-09-23: theme kontrolek w rootowych dialogach

`ChatSurfaceDialog` aplikuje teraz `ChatTheme.applyControls` do całego poddrzewa,
aby przyciski, formularze i progress zachowały motyw Chat także poza lokalnym
panelem w root navigatorze. Weryfikacja: `flutter analyze`, macOS Debug build i
`git diff --check` PASS. Widget/golden tests nie uruchamiane; runtime UI nadal
OPEN, ponieważ CUA zgłasza zablokowany Mac.

## Aktualizacja wykonania — 2026-09-23: osobna paleta czatu

`DevPlannerChatTheme` używa teraz dedykowanych kolorów zamiast niebieskich
surface/accent Material: jasny wariant ma miętowy dymek wychodzący i kremową
historię, ciemny grafitowe powierzchnie i zielony dymek; akcje, fokus oraz odczyt
mają zielone akcenty. Typografia pozostaje z projektu DevPlanner. Testy tokenów
i kontrolek 3/3, `flutter analyze`, macOS Debug build i diff check PASS.
Widgetów/goldenów nie uruchamiano; wizualny runtime review OPEN.

## Aktualizacja wykonania — 2026-09-23: długie wklejenie bez duplikacji

Akcja „Zostaw jako tekst” czeka teraz na zakończenie cleanupu stagingowego TXT.
Przy błędzie nie wstawia tekstu do szkicu, a karta zachowuje możliwość ponowienia,
więc treść nie może zostać wysłana naraz jako wiadomość i plik. Testy
koordynatora załączników i polityki długiego wklejenia 16/16; analyze, build
macOS Debug i diff check PASS. Widget/golden tests nieuruchomione.

## Aktualizacja wykonania — 2026-09-23: limit dodawania członków

Backend ogranicza do 50 osób tylko typ `Group`. Usunięto błędny licznik i blokadę
dla kanałów/ogłoszeń; grupy zachowują rzeczywisty limit oraz liczbę wolnych miejsc.
Testy członków 14/14, `flutter analyze`, macOS Debug build i `git diff --check`
PASS. Widgetów/goldenów nie uruchamiano.

## Aktualizacja wykonania — 2026-09-23: kontekstowe menu listy rozmów

Wiersz ma widoczny przycisk opcji, a menu otwiera się też prawym kliknięciem,
długim przytrzymaniem oraz klawiszem Menu/Shift+F10. Wyciszanie i archiwizacja zwracają lokalizowany błąd zamiast
technicznego komunikatu API. `flutter gen-l10n`, `flutter analyze`, build macOS
Debug i diff check PASS. Widgetów/goldenów nie uruchamiano; runtime UI pozostaje
nieobejrzany.

## Aktualizacja wykonania — lokalizacja legacy widoku rozmowy (2026-09-23)

Pełnoekranowy `ChatConversationPageView`, nadal używany w podwidoku dyskusji,
zastąpił hardkodowane `Czat` lokalizowanym tytułem i stylami ChatTheme. `flutter
gen-l10n`, analiza i build macOS Debug PASS. Runtime UI pozostaje OPEN, bo Mac
jest zablokowany; nie uruchamiano testów widgetowych.

## Aktualizacja wykonania — importy UI Chat z foundation (2026-09-23)

Aktywne widoki załączników, dyskusji, akcji wiadomości i ustawień powiadomień
korzystają z `foundation/l10n` oraz `foundation/theme`; `presentation/chat` nie
importuje już legacy `core/l10n` ani `core/theme`. `flutter analyze`, build
macOS Debug i diff check PASS. Runtime UI pozostaje OPEN.

## Otwarty przypadek tła zgłoszony przez użytkownika (2026-09-23)

- [ ] Odtworzyć sytuację, w której mniejszy obraz powoduje zniknięcie elementu
  ekranu i przycięcie tapety od dołu. Zgłoszenie pozostaje nierozpoznane; nie
  zmieniać kadru ani skalowania bez ustalenia właściwego ekranu i reprodukcji.
- [x] Renderer tapety znajduje się w `lib/app/shell/devplanner_shell_layout.dart`:
  shell maluje `assets/images/bg.jpeg` przez `DecorationImage(fit: BoxFit.cover)`;
  przypięty panel jest nakładany na pełnowymiarową tapetę.
- [ ] Oględziny na żywo 2026-09-23 potwierdziły shell/tapetę oraz panel Chat
  otwarty w sekcji Archiwum, ale próby przejścia do listy kończyły się błędem
  sterowania `noWindowsAvailable`; aktywnej rozmowy i zgłoszonego kadru nie
  udało się odtworzyć. Potrzebna stabilna sesja UI i wskazanie ekranu.

## Naprawa pustego stanu Archiwum (2026-09-23)

- [x] Widok pustej skrzynki dobiera teraz lokalizowany opis do filtra: Wszystkie,
  Nieprzeczytane, Bezpośrednie, Grupy, Kanały, Wzmianki i Archiwum.
- [x] Błąd potwierdzono na macOS screenshotem: filtr Archiwum pokazywał opis
  aktywnych rozmów. Mapper **2/2 testy jednostkowe PASS**; `flutter gen-l10n`,
  `flutter analyze` oraz świeży macOS Debug build PASS.
- [ ] Po restarcie logowanie nie powiodło się; przycisk uruchomił zewnętrzny
  provider. Nie wpisano danych, więc runtime weryfikacja poprawionego opisu
  pozostaje otwarta. Widget/golden wciąż odroczone do akceptacji.

## Weryfikacja backendu Chat (2026-09-23)

Testy backendowe filtrem `FullyQualifiedName~Chat`: **231 PASS, 3 SKIP, 0 FAIL**.
Pominięte testy integracyjne wymagają Redis na `localhost:6380`, w tym test
dwu-hostowego SignalR. Backend nie wymagał zmian w tej kontroli.

### CHAT-R47 — wyczyszczenie rozmowy przy zmianie sekcji (2026-09-23)

- [x] Runtime 800×630 odtworzył błąd: po kliknięciu Kanały lista była pusta, ale
  panel nadal wyświetlał poprzednio wybraną grupę „Wydanie i testy”.
- [x] Zmiana sekcji czyści lokalny wybór rozmowy; zachowane per-sekcja filtry
  skrzynki pozostają bez zmian. Zapobiega to prezentowaniu starej rozmowy pod
  nagłówkiem Pliki/Kanały/Zadania lub innej sekcji.
- [x] Poprzednia sekcja jest inicjalizowana z Cubita; pierwsze przejście po
  przywróceniu rozmowy/deep linku także czyści wybór.
- [x] `flutter analyze`, testy logiki panelu **10/10** oraz `flutter build macos --debug
  --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl` PASS.
- [x] Runtime po poprawce na świeżym buildzie: otwarcie panelu przez belkę, a
  następnie Kanały pokazało pustą listę oraz placeholder „Wybierz rozmowę” w
  prawym panelu zamiast starej grupy. Nie otwierano wiadomości ani nie
  zmieniano danych staging.
- [ ] Nie uruchamiano widget/golden testów zgodnie z instrukcją użytkownika.

### CHAT-R42 — responsywny pasek formatowania Quill (2026-09-23)

Usunięto obcinanie końcowych ikon w wąskim composerze: główne formaty zostają
na pasku, a listy, cytat, blok kodu i czyszczenie formatu są w menu „Więcej
opcji formatowania”. Pełny pasek pozostaje w szerokich panelach. Analiza i
macOS Debug build PASS. Runtime przy 800×630 potwierdził nieucięty pasek i
czytelne etykiety menu. Widget/golden tests odroczone do akceptacji użytkownika.

### CHAT-R43 — runtime modali, wyboru osób i statusu (2026-09-23)

Przy 800×630 obejrzano modal uczestników, wyszukiwanie/wybór osoby, kreator
grupy wraz z polityką publikowania oraz menu statusu. Wszystkie przepływy
anulowano bez zapisu ani utworzenia rozmowy. Wizualnie widać właściwe akcje,
role i stany; automatyczne testy widget/golden pozostają odłożone do odbioru.
Menu kontekstowe wiadomości również sprawdzono; dwa zestawy testów logiki
composera przechodzą **16/16**.

### CHAT-R48 — usunięcie redundantnego filtra kategorii (2026-09-23)

- [x] W sekcjach Grupy/Kanały/Archiwum ukryto pojedynczy chip powtarzający
  kategorię już widoczną w nagłówku; wielokrotne filtry Czaty pozostają.
- [x] Świeży build potwierdzony na żywo: Grupy pokazuje nagłówek, wyszukiwarkę
  i listę bez dodatkowego chipu „Grupy”. Nie otwierano wiadomości.
- [x] `flutter analyze`, macOS Debug build i Front `git diff --check` PASS.
- [ ] Widget/golden tests odroczone zgodnie z instrukcją użytkownika.

### CHAT-R49 — przewijana lista popovera „Nowy czat” (2026-09-23)

- [x] Lista ostatnich kontaktów i wyników ma własny obszar przewijania w ramach
  ograniczonej wysokości popovera. Tytuł, wyszukiwarka oraz akcje utworzenia
  grupy, kanału i ogłoszenia pozostają widoczne podczas scrollowania.
- [x] Ręcznie sprawdzono macOS przy 800×630 na stagingu. Scroll zmienił widoczną
  część kontaktów; nagłówek, pole wyszukiwania i trzy akcje pozostały na miejscu.
  Nie otwierano rozmowy ani nie wykonano mutacji.
- [x] `flutter analyze` PASS; `flutter build macos --debug` PASS. Endpointy
  `/health/live` i `/health/ready` zwróciły `200 Healthy`; pobranie inboxa,
  unread count i workspace zwróciło HTTP 200.
- [x] Po teście zamknięto pojedynczą instancję `flutter run`; CUA potwierdziło
  `DevPlanner isRunning=false`.
- [ ] Widget/golden testy pozostają odłożone do akceptacji wyglądu.
- [ ] Pełny odbiór nowoczesnego UI Chat, wszystkich sekcji i zachowania tapety
  nadal jest otwarty; ten smoke test potwierdza tylko popover i ładowanie inboxa.

### CHAT-R50 — menu formatowania Quill w ChatTheme (2026-09-23)

- [x] Zastąpiono domyślny `PopupMenuButton` w overflow formatowania przez
  `AppContextMenu`, z etykietami, ikonami oraz stanem zaznaczenia z istniejącego
  modelu. Akcje listy, cytatu, bloku kodu i czyszczenia formatu zachowują swoje
  dotychczasowe komendy.
- [x] Skan `presentation/chat` nie znalazł już `PopupMenuButton`,
  `PopupMenuItem`, `DropdownButton`, `showMenu`, `AlertDialog`, `SwitchListTile`,
  `MaterialBanner` ani bezpośrednich `SnackBar`. Pozostaje `MenuAnchor` w karcie
  własnego statusu, która jest custom UI, a nie domyślnym menu wierszy.
- [x] `flutter analyze` PASS; `flutter build macos --debug` PASS.
- [ ] Nie otwierano rozmowy w celu runtime preview kompozytora; menu czeka na
  ręczny odbiór UI. Widget/golden tests pozostają odłożone do akceptacji.

### CHAT-R51 — pierwsze kliknięcie globalnego Chat (2026-09-23)

- [x] Odtworzono na żywo: przy 33 nieprzeczytanych wiadomościach badge
  nachodził na środek przycisku i przejmował hit-test, więc Chat nie otwierał
  się po kliknięciu ikony. Po otwarciu Powiadomień przełączenie już działało.
- [x] Badge przeniesiono na nieinteraktywną warstwę (`IgnorePointer`) nad
  przyciskiem; etykieta dostępności nadal podaje liczbę nieprzeczytanych.
- [x] Na żywo, przy aktywnej sesji staging: zamknięcie panelu i jego ponowne
  otwarcie jednym kliknięciem Chat zadziałało. Nie otwierano rozmowy ani nie
  zmieniano danych.
- [x] `flutter analyze`, macOS Debug build i `git diff --check` PASS.
- [x] Instancja testowa została zamknięta; CUA potwierdziło
  `DevPlanner isRunning=false`.

### CHAT-R52 — zwarty układ popovera w niskim oknie (2026-09-23)

- [x] Dla małej dostępnej wysokości trzy akcje utworzenia układają się poziomo
  w niższych wierszach, a padding i odstęp separatora maleją; wyszukiwarka oraz
  wewnętrznie przewijana lista pozostają w strukturze popovera.
- [x] `flutter analyze` i macOS Debug build PASS.
- [ ] Runtime małego viewportu niezaliczony: po próbie zmniejszenia okna przez
  CUA treść aplikacji była widoczna tylko w górnej części, a dół okna pozostał
  pusty. Nie rozstrzygnięto, czy przyczyną jest resize, renderer czy kod; nie
  otwierano rozmowy. Potrzebna reprodukcja z prawidłowym viewportem.
- [x] Instancja testowa została zamknięta; CUA potwierdziło
  `DevPlanner isRunning=false`.

### CHAT-R54 — sprawdzenie usługi i kompozycji załączników (2026-09-23)

- [x] `https://devnote.flutter-dev.pl/health/live` oraz `/health/ready`
  zwróciły HTTP 200.
- [x] Jednorazowy podgląd działającej kompilacji pokazał ekran `Zaloguj`.
  Przepływu zewnętrznego dostawcy nie uruchomiono, nie użyto danych logowania.
  Aplikację zamknięto przez menu `Quit DevPlanner`; CUA potwierdziło
  `isRunning=false`.
- [x] Bieżący kod wiąże Storage, izolowany presigned upload transport, picker
  i porty załączników z globalnym Chat w `DevPlannerApp` i
  `DevPlannerStandaloneRuntime`; poprzedni wpis o brakującej kompozycji jest
  nieaktualny.
- [x] `flutter test test/workspaces/data/standalone/devplanner_storage_composition_test.dart`
  **2/2 PASS**; `flutter analyze` bez problemów; `flutter build macos --debug`
  PASS.
- [ ] Rzeczywisty upload/pobranie załącznika pozostaje do sprawdzenia po
  zalogowaniu. Nie zmieniano danych stagingowych.

### CHAT-R55 — grupowanie kształtu dymków wiadomości (2026-09-23)

- [x] `ChatMessageSeriesView` przekazuje pozycję dymka: samodzielny, pierwszy,
  środkowy lub ostatni. W seriach styczne narożniki po stronie autora są
  ciaśniejsze, a narożniki zewnętrzne pozostają pełne; wiadomości własne są
  lustrzane względem przychodzących.
- [x] `flutter analyze` bez problemów; `flutter build macos --debug` PASS;
  `git diff --check` czysty.
- [ ] Nie uruchamiano widget/golden testów ani aplikacji. Odbiór kształtu na
  zalogowanym runtime pozostaje otwarty.

## Aktualizacja wykonania — 2026-09-23: kontrola wartości enumów Chat

Nowy test Front weryfikuje komplet wartości i round-trip JSON dla enumów
transportowych oraz dokładne stringi filtra inbox i ról członków. Flutter test
1/1 PASS. Backend weryfikuje rzeczywisty HTTP serializer, OpenAPI i wszystkie
wartości filtra: 8/8 PASS. Uzupełniono opis statusu delivery o `Sending`;
status zaproszenia pozostaje wewnętrzny, bo nie wystawia go obecny endpoint.
OpenAPI staging zwraca HTTP 500, dlatego porównanie produkcyjnego dokumentu
pozostaje otwarte. Bez zmian UI/runtime i bez deployu.

## Aktualizacja wykonania — 2026-09-23: łamanie długich URL-i

Długie adresy w zwykłych segmentach tekstu otrzymują teraz niewidoczne punkty
łamania nawet wtedy, gdy backend nie zwróci metadanych bezpiecznego linku.
Renderowana treść nie dodaje przez to klikalności, a model wiadomości pozostaje
bez zmian. Test polityki wyświetlania 8/8 PASS, analiza zmienionych plików oraz
`git diff --check` PASS. Widget/golden i runtime review nie były uruchamiane.

## Aktualizacja wykonania — 2026-09-23: serwerowe wyszukiwanie skrzynki

Inbox wyszukuje teraz serwerowo po nazwie rozmowy i aktywnych uczestnikach.
Nowy query jest filtrowany z ACL przed kursorem, a Front resetuje paginację przy
zmianie frazy i zachowuje ją przy pobieraniu kolejnych stron.

- [x] Backend full suite **1304 PASS, 0 FAIL, 4 SKIP**; inbox/OpenAPI **20/20**.
- [x] Front adapter/Cubit **22/22 PASS**; analiza źródeł i `git diff --check`
  PASS.
- [x] Backend `dotnet format` dla zmienionych plików PASS; skrypt EF
  `WorkspaceDbContext` wygenerowany; bez migracji.
- [x] macOS Debug build PASS; aplikacji nie uruchamiano. Dwa media-kit pluginy
  wypisały ostrzeżenie o braku obsługi Swift Package Manager.
- [ ] Nie wykonano widget/golden testów ani deployu staging.

## Aktualizacja wykonania — 2026-09-23: naprawa snapshotu presence

Logi stagingu ujawniły błąd translacji zapytania EF dla
`ChatPresenceStore.ListActiveAsync`; naprawiono kolejność grupowania/projekcji
oraz dodano test PostgreSQL dla liczby połączeń i kolejności użytkowników.

- [x] `ChatPresenceStorePostgresTests`: **1/1 PASS**.
- [x] Format zmienionych plików i `git diff --check` PASS.
- [x] Testy łączone realtime/inbox/OpenAPI: **28/28 PASS**.
- [ ] Staging nadal uruchamia stary obraz; poprawka nie jest wdrożona.
- [ ] Brak migracji; bez widget/golden testów.

## Aktualizacja wykonania — 2026-09-23: kompletność wyszukiwania kontaktów

Inbox nie ogranicza już dopasowania do pierwszych 50 aktywnych profili z całego
katalogu. Backend wyszukuje login/nazwę wśród aktywnych członków rozmów
widocznych dla użytkownika; e-mail nie bierze udziału w wyszukiwaniu. Test
PostgreSQL z 51 pasującymi kontaktami dowodzi, że wynik nie jest obcinany.

- [x] `ChatInboxPostgresTests`: **13/13 PASS**.
- [x] `dotnet format --verify-no-changes` wskazanych plików i
  `git diff --check` PASS.
- [x] Bez zmian kontraktu, enumów, schematu, generatora Flutter ani deployu.
- [ ] Zalogowany odbiór runtime i ocena pełnego UI czatu pozostają otwarte;
  aplikacji nie uruchamiano, testów widgetowych/golden nie wykonano.

## Aktualizacja wykonania — 2026-09-23: picker emoji w composerze

Przycisk emoji w polu wiadomości otwiera teraz zakotwiczone menu kontekstowe.
Picker nie przyciemnia ani nie blokuje całej rozmowy. Zachowuje wyszukiwanie,
kategorie, ostatnio użyte emoji i odcienie skóry. Pickery statusu oraz reakcji
pozostają modalne, bo są odrębnymi przepływami poza wstawianiem tekstu.

- [x] `flutter analyze --no-pub` PASS.
- [x] `flutter build macos --debug --dart-define=DEVPLANNER_API_BASE_URL=https://devnote.flutter-dev.pl` PASS (ostrzeżenia SPM dla dwóch media-kit pluginów).
- [x] Jedna instancja macOS potwierdziła pozycję menu nad ikoną, brak scrim,
  zamknięcie Escape i brak zmiany szkicu. Potwierdzono późniejsze zamknięcie
  procesu.
- [ ] Widget/golden tests nieuruchomione zgodnie z dyspozycją użytkownika;
  brak zmian Backend/API.

## Aktualizacja wykonania — 2026-09-23: kolor badge’y nieprzeczytanych

Wszystkie badge’e nieprzeczytanych (wiersz rozmowy, suma w panelu i globalna
ikona Chat) używają teraz powierzchni i koloru tekstu przycisku wysyłki
z `ChatTheme`, zamiast niebieskiego koloru linku lub czerwonego koloru błędu.

- [x] Analyze, macOS Debug build i `git diff --check` połączonego pakietu PASS.
- [x] Zalogowany runtime potwierdził zielony badge w wierszu, sumę panelu i
  globalny licznik oraz zakotwiczone menu emoji bez scrim.
- [x] DevPlanner zamknięto po odbiorze; potwierdzono `isRunning=false`.
- [ ] Widget/golden tests pozostają odłożone do akceptacji wyglądu przez
  użytkownika.

## Rewalidacja runtime i macOS — 2026-09-23

Front `flutter analyze` i macOS Debug build PASS. W jednej instancji ręcznie
sprawdzono widok rozmowy, menu kontekstowe wiadomości, picker emoji, okno
uczestników wraz z wyszukiwaniem oraz początek kreatora grupy; żadne dane nie
zostały zmienione. Instancję zamknięto po kontroli. Pierwszy odczyt po otwarciu
rozmowy zgłosił krótkotrwałe `offline`, które zniknęło po załadowaniu; nadal
brakuje dwu-sesyjnego potwierdzenia realtime. Widget/golden testy odłożone.

## Rewalidacja — 2026-09-23: początkowy stan realtime

Początkowy snapshot `disconnected` z `BehaviorSubject` nie jest już pokazywany
jako awaria, zanim transport rozpocznie próbę połączenia. Późniejsze
`disconnected` nadal natychmiast pokazuje offline.

- Test Cubita i klienta SignalR: **12/12 PASS**; `dart analyze` zmienionych
  plików PASS.
- Nie uruchamiano aplikacji ani widget/golden testów. Runtime i dwu-sesyjne
  E2E pozostają otwarte; brak zmian Backend/API.

## Rewalidacja — 2026-09-23: zapisane wiadomości spoza inboxa

Skok z zapisanej wiadomości nie jest ograniczony do pierwszych dziesięciu stron
inboxa. Rozmowa jest odczytywana po ID przez ACL-owany endpoint szczegółów, a
błąd ładowania jest widoczny użytkownikowi.

- Pełny `flutter analyze --no-pub` PASS; repozytorium Chat + testy realtime
  **21/21 PASS**; macOS Debug build PASS (ostrzeżenie SPM dla dwóch istniejących
  pluginów `media_kit`); `git diff --check` PASS.
- Bez zmian Backend/API. Nie uruchamiano GUI ani testów widgetowych/golden.

## Smoke test — 2026-09-23

Świeży build macOS otworzył globalny Chat jednym kliknięciem. Obejrzano rail,
inbox, pustą kolumnę rozmowy oraz popover „Nowy czat” w dark ChatTheme. Menu
Escape zamknięto bez tworzenia rozmowy; przywrócono poprzedni motyw. Instancję
zamknięto i potwierdzono `isRunning=false`. Nie otwierano istniejącej rozmowy,
żeby nie zmieniać jej unread; pełny odbiór rozmowy i realtime nadal otwarty.

## Utrzymanie kontraktu wyszukiwania — 2026-09-23

Komentarze Frontu dopasowano do aktualnego serwerowego query inboxa (nazwy
rozmów i aktywni uczestnicy); wyszukiwanie treści wiadomości pozostaje osobnym
przepływem. `git diff --check` PASS; brak zmian logiki i testów.

## Rewalidacja motywu i tworzenia grup — 2026-09-23

Ręczny odbiór na świeżym buildzie potwierdził, że dialog tworzenia grupy
zaznacza uczestników bez fałszywej informacji o istniejącym DM. Tekstowe akcje
dialogu są teraz zielone z osobnym tokenem ChatTheme, a linki w treści pozostają
niebieskie. Testy motywu, tworzenia rozmów oraz wyszukiwania i members **38/38
PASS**, `flutter analyze --no-pub`, macOS Debug build i `git diff --check` PASS.
Instancję zamknięto i sprawdzono brak procesu. Widget/golden tests nie
uruchamiano zgodnie z dyspozycją użytkownika.

Nadal otwarte: dwu-sesyjne sprawdzenie SignalR oraz HTTP 500 pod stagingowym `/`
(readiness API odpowiada 200). Read-only SSH potwierdził, że konfiguracja Nginx
celuje w nieistniejący katalog `/srv/devplanner/frontend/current`; lokalny
Flutter WebAssembly build przeszedł. Wdrożenie Frontu nadal wymaga właściwej
procedury/zgody.

## Poprawka kadru tapety — 2026-09-23

`DecorationImage` shella zachowuje `BoxFit.cover`, z `Alignment.bottomCenter`,
aby pionowy crop przy bardzo szerokim widoku nie ucinał dolnej części tapety.
Analiza i macOS Debug build PASS. Nie udało się zmienić wymiarów natywnego
okna przez CUA, więc ręczny odbiór przy małych/ultra-wide wymiarach pozostaje
otwarty; widgetów/goldenów nie uruchamiano.

## Przegląd lifecycle załączników — 2026-09-23

Potwierdzono kompozycję session API → Storage ticket/ACL → izolowany presigned
upload/download. Binarny PUT nie dziedziczy cookie ani Bearera; bez potrzebnych
portów UI ukrywa akcję. Testy queue/upload owner/selection/coordinator,
długi tekst/drag-drop, upload/access adapters i Storage composition **50/50
PASS**. Widget/golden testy oraz rzeczywisty stagingowy upload/download
pozostają otwarte.

## Dopasowanie „Nowy czat” do wzorca WhatsApp — 2026-09-23

Na macOS popover kontaktów zajmował za dużo miejsca względem panelu, a dialog
tworzenia grupy nadal nazywał się „Nowa rozmowa”. Ograniczono popover do 320 px,
dialog do 440 px, a tytuł dialogu zależy teraz od typu rozmowy. `dart format`,
`flutter analyze --no-pub` i świeży build macOS z prawidłowym
`--dart-define=DEVPLANNER_API_BASE_URL=...` przeszły. Po buildzie otworzył się
workspace stagingowy; CUA przerwało dalszą kontrolę po wykryciu zmiany stanu
aplikacji przez użytkownika, więc nowe proporcje nie są jeszcze ręcznie
potwierdzone. Widget/golden tests odroczone. `/health/ready` działa, `/` nadal
zwraca 500 z powodu brakującego katalogu Frontu na serwerze.
