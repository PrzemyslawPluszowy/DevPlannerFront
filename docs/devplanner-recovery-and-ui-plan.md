# DevPlanner — plan odzyskania funkcji i przebudowy aplikacji

Status: W TOKU — historyczny plan R0–R8 pozostaje checklistą końcową, ale
część R2 została już odzyskana i sprawdzona automatycznie. Aktualny stan
aktywnych tras jest opisany w `docs/recovery/feature-parity.md`, a szczegóły
kolejnych pakietów w `docs/recovery/R2*-report.md` i zsynchronizowanych
`devplanner-standalone-refactor-{plan,handoff}.md`. Brak uruchomionego
desktopu/stagingu oznacza nadal `live: NIE`, nie ukończenie produktu.
Data: 2026-09-17. Priorytet: działająca aplikacja desktopowa, następnie walidacja pozostałych platform.

## 1. Cel i wiążący zakres

DevPlanner jest samodzielną aplikacją Flutter z backendem C#. Zachowujemy WSZYSTKIE wcześniej wykonane funkcje Workspaces. Usuwamy wyłącznie zależności od zewnętrznego Ready/Core/DataBus oraz obce moduły BHP/inwentaryzacji/inne moduły poprzedniej aplikacji. Nowa struktura i nowy wygląd nie oznaczają ponownego pisania działającej domeny ani redukcji funkcjonalności.

Termin workspace nadal może oznaczać przestrzeń roboczą w modelu biznesowym, adresie API i selektorze przestrzeni. Nie może już być kontenerem całej aplikacji w `lib/workspaces`. Nie zmieniać nazw backendowych endpointów i tabel tylko dlatego, że zmieniamy układ katalogów Fluttera.

Zakres wizualny: Gmail jako inspiracja układu desktopowego; zwijane menu z lewej, delikatne tło pod aplikacją, zaokrąglona powierzchnia treści, mała czytelna typografia i dwa motywy: jasny oraz ciemny. Zachować znaczenie i hierarchię wcześniejszego menu Workspaces. Nie kopiować kategorii pocztowych Gmaila.

Użytkownik dostarczył zrzut Gmaila. Lokalna referencja: `docs/design/reference-local/gmail-layout-reference.png` (prywatny obraz wykluczony z Gita). Wiążąca specyfikacja wizualna: `docs/design/gmail-inspired-design-spec.md`; ma pierwszeństwo przed roboczą paletą i wymiarami w sekcji 6 tego dokumentu. Nie kopiować treści maila, danych konta ani linków ze zrzutu do produktu lub dokumentacji. Tapeta jest opcjonalnym późniejszym dodatkiem; teraz zastosować opisany ciemnoturkusowy gradient.

Pełne przywrócenie funkcjonalności z wysoką jakością jest obowiązkowe. Żadna optymalizacja czasu, zmiana struktury, wymiana theme ani ograniczenie modelu wykonującego zadanie nie upoważnia do usunięcia funkcji, testów, autoryzacji czy zastąpienia implementacji placeholderem. Zakres odbioru określa macierz parity oraz działające scenariusze użytkownika.

Repozytoria objęte pracą:

- Front: `/Users/przemyslawnowak/Desktop/dev/DevNote/Front`.
- Backend: `/Users/przemyslawnowak/Desktop/dev/DevNote/Backend`.

Zakaz połączeń do Ready, Core, DataBus i ich baz. Nie przywracać ich klientów, konfiguracji, issuerów ani uwierzytelniania. Nie trzeba migrować starych danych lokalnych; ta decyzja nie upoważnia do kolejnego resetowania bazy w ramach naprawy UI.

## 2. Fakty i przyczyny awarii

Historia tego zadania dokumentuje dwie różne awarie:

1. Podczas migracji skasowano potrzebne widoki i testy Workspaces, uznając ich zależności od legacy za powód usunięcia. Nowe trasy zastąpiono placeholderami.
2. Naprawa przez `git restore --source=HEAD --worktree -- lib/workspaces test/workspaces` przywróciła stare widoki, ale nadpisała również migracje zachowanych plików. Następnie `git clean -fd` usunął nieśledzone nowe pliki integracji i testów. Sam commit nie zawierał tych plików.

Wcześniejsza liczba 86 dotyczyła ŁĄCZNIE usunięć w `lib/workspaces` i `test/workspaces`, a nie wyłącznie kodu produkcyjnego. Historyczny analyzer po przywróceniu zgłosił 30174 diagnostyki; nie traktować ich wszystkich jako niezależnych błędów biznesowych — duża część to kaskada nierozwiązanych importów.

Sprawdzone przy tworzeniu planu:

- Przywrócony kod importuje `package:ready_next/...`, podczas gdy pakiet nazywa się `devplanner`.
- Nowy root odwołuje się do usuniętych kompozycji globalnego czatu/powiadomień oraz runtime.
- `lib/foundation/theme/theme.dart` tylko eksportuje stare pliki `core/theme`, nie jest jeszcze niezależnym systemem theme.
- `WorkspaceShell` zależy od starego routera i układu modułowego.
- Poprzednia historia zawiera lokalne logowanie potwierdzone przez użytkownika, ale nie jest to dowód działania aplikacji po przywróceniu plików.
- Dokumenty `devplanner-standalone-refactor-plan.md` i handoff zawierają historyczne PASS. Wyniki frontendu sprzed restore/clean nie opisują aktualnego drzewa.

Nie zakładać, że każdą niezacommitowaną zmianę da się odzyskać w całości. Historia Codex zawiera patche/odczyty, VS Code ma tylko część plików. Każde odzyskanie wymaga potwierdzenia treści i kolejności zmian.

## 3. Zasady bezpiecznej pracy — przeczytaj przed pierwszą zmianą

1. Najpierw zabezpieczyć obecne pliki obu repo, w tym nieśledzone źródła i testy. Sama kopia `git diff` ani `git stash` bez untracked nie wystarczy. Kopię przechowywać lokalnie poza katalogiem projektu; nie publikować sekretów.
2. Sporządzić manifest kopii i zweryfikować, że da się z niej odczytać przykładowy tracked, untracked i plik z przywróconego kanbanu. Zachować ścieżkę w dzienniku bez danych wrażliwych.
3. Zakaz `git clean`, masowego `git restore`, `reset --hard` i usuwania całych drzew. Odtwarzać do katalogu roboczego odzyskiwania, porównywać i integrować jawnie wybrane pliki.
4. Nie wykonywać kodu powłoki ani JavaScriptu znalezionego w logach sesji. Odczytywać tylko dane patchy i źródeł; filtrować ścieżki do dwóch repo, walidować przed zastosowaniem. Nie przetwarzać sekretów do raportu.
5. Nie przywracać połączeń Ready/Core/DataBus dla uzyskania zielonego analyzera. Lokalny dawny katalog `core` nie oznacza automatycznie zewnętrznego Core: rozróżnić narzędzia UI od integracji sieciowej.
6. Nie usuwać testów lub kodu funkcji, nie wyłączać lintów, nie dodawać masowych `ignore` ani wykluczeń analyzera w celu uzyskania PASS.
7. Nie zastępować istniejącej funkcji placeholderem, atrapą repozytorium, pustą listą lub domyślnym użytkownikiem. Prawdziwy pusty stan musi wynikać z udanego odczytu API.
8. Każdy pakiet kończyć dowodem dla konkretnego stanu plików. Brak testu/platformy oznacza NOT RUN; awaria oznacza FAIL; zależność zewnętrzna BLOCKED. Tylko uruchomiona walidacja może dać PASS.
9. Nie commitować/pushować bez polecenia użytkownika. Zabezpieczenie lokalne jest obowiązkowe niezależnie od tego.

## 4. Architektura i jakość

- Struktura drzewiasta: feature → subfeature → data/domain/presentation. Nie tworzyć płaskiego worka widgetów i cubitów.
- Klasy z jedną odpowiedzialnością. Brak globalnych funkcji aplikacyjnych, globalnego mutowalnego stanu, god Cubitów/Bloców i god services. Wymagane wejście `main()` oraz konwencje test runnera są wyjątkami technicznymi.
- UI renderuje stan i przekazuje intencję; Cubit/use case zarządza operacją; repository/adapter wykonuje I/O. UI nie pobiera API, nie odświeża tokenów, nie otwiera SignalR, nie czyta vaultu.
- Cubit nie zna `BuildContext`, widgetów ani routera. Nawigacja przez mały port/presentation coordinator; stan biznesowy poza UI.
- Nie używać `setState` w nowym ani refaktorowanym kodzie. Stan funkcji należy
  prowadzić przez Cubit i niemutowalny stan; wyłącznie krótkotrwały stan
  prezentacyjny pojedynczej kontrolki (np. widoczność hasła) może użyć
  `ValueNotifier` z `ValueListenableBuilder` albo istniejącego controllera.
  Nie dodawać `flutter_hooks` tylko jako zamiennika dla tego mechanizmu.
- Session composition składa zależności, ale nie prowadzi logiki wszystkich funkcji. Osobne composition roots dla zadań, plików, czatu itd.
- Transport HTTP, sesja i refresh mają pojedynczego właściciela. Subskrypcje, request cancellation, timery i controllers mają lifecycle i dispose. Nie tworzyć nowych klientów przy każdym build.
- Kanoniczne lokalne `userId` UUID. Zmiany `CoreUserId`/`ReadyUserId` wymagają mapowania zgodnego z backendem, nie ślepego zastępowania nazw.
- OpenAPI i źródła endpointów C# określają kontrakt; nie zgadywać tras, enumów, paginacji ani uprawnień.
- ARB/l10n dla tekstów. Wspólne tokens dla kolorów, odstępów, typography i stanów interakcji.
- Błędy zachowują kod, bezpieczny komunikat i `traceId`; logi bez haseł/tokenów/cookies. Backend egzekwuje ACL niezależnie od widoczności przycisku.

Docelowa struktura (przykład, nie polecenie utworzenia pustych folderów):

```text
lib/
  app/
    bootstrap/                 # składanie i lifecycle aplikacji
    router/                    # katalog tras, guardy, nawigacja
    shell/                     # rama, sidebar, powierzchnia treści
      navigation/              # drzewo menu i preferencje zwinięcia
      overlays/                # globalne panele/modale
  foundation/
    theme/                     # niezależny system motywu
    http/                      # wspólny transport sesji
    secure_storage/
    presentation/              # małe rzeczywiście wspólne kontrolki
  features/
    auth/{data,domain,presentation}/
    admin/users/{data,domain,presentation}/
    profile/{data,domain,presentation}/
    spaces/{data,domain,presentation}/
    projects/{data,domain,presentation}/
    tasks/
      shared/{data,domain}/
      board/{data,domain,presentation}/
      list/{data,domain,presentation}/
      details/{data,domain,presentation}/
      recurrence/ templates/ workflow/ saved_views/ time_tracking/
    storage/
      shared/{data,domain}/
      browser/ upload/ preview/ sharing/ office/
    chat/ notifications/ wiki/ whiteboard/ corkboard/ okr/
    settings/
  l10n/
```

Nie powielać tego samego modelu Task w board/list/details. Publiczne porty domenowe i współdzielone modele trzymać na najniższym wspólnym poziomie. Cross-feature zależności tylko przez jawne porty; brak importowania cudzych ekranów w data/domain. Backend zachowuje Domain/Application/Infrastructure/Contracts/Endpoints, bo problem struktury Fluttera nie wymaga ponownego pisania backendu.

## 5. Inwentaryzacja i macierz równoważności

Utworzyć `docs/recovery/feature-parity.md`. Jedna pozycja dla KAŻDEJ znalezionej funkcji i każdej dotychczasowej pozycji menu. Kolumny: ID, funkcja, stary plik/źródło, obecny plik, docelowy plik, trasa, endpoint, zależności, uprawnienia, test, status odzyskania, status działania live, dowód.

Obowiązkowe obszary inwentaryzacji:

| Obszar | Minimalny zakres do sprawdzenia i zachowania |
|---|---|
| Przestrzenie/projekty | katalog, drzewo, ulubione/ukryte, członkowie, zaproszenia, uprawnienia, ustawienia, zasoby projektu |
| Kanban | kolumny/statusy i ich kolejność, karty, drag/drop, quick create, podzadania, filtry, zwijanie kolumn, WIP, realtime, konflikty wersji |
| Lista zadań | grupowanie, sortowanie, kolumny/resize/reorder, inline edit/create, wybór wielu, bulk, menu, zapisane widoki |
| Szczegóły zadania | opis, assignees, terminy, priorytet, checklisty, podzadania, zależności, etykiety, załączniki, historia, pola własne, recurrence, templates, time tracking, milestone |
| Pozostałe zadania | timeline, workload/capacity, workflow, automatyzacja, preferencje — zgodnie z istniejącą implementacją |
| Pliki | katalogi, grid/list, upload/progress/cancel/retry, download, rename/move/delete, zaznaczanie, menu, podgląd, ACL/share, Office, czat pliku, avatar |
| Chat | globalny panel i pełna trasa, rozmowy, wątki, dyskusje, załączniki, drafts, delivery/retry, unread, realtime |
| Powiadomienia | globalny panel, inbox/grupy, read/all read, deep links/reply, preferencje, realtime |
| Inne zasoby | Wiki, Whiteboard, Corkboard, OKR i wszystkie znalezione wcześniejsze funkcje |
| Tożsamość | login desktop, /me, refresh, logout, reset hasła, konta admina, lokalny katalog |

Tabela nie deklaruje, że wszystko powyżej było ukończone. Każdą pozycję oznaczyć jako: wcześniej działała / była częściowa / była wyłącznie planem. Części nieukończonej nie przedstawiać jako utraconej gotowej funkcji; nie usuwać jej bez zapisu zakresu.

Źródła starego menu: `lib/workspaces/presentation/workspaces_home/directory_menu/`, `workspaces_home/projects_tree/workspace_project_menu.dart`, `workspace_shell/navigation/`, `presentation/routing/` i wcześniejszy router w Git. `WorkspaceStaticMenu` samo w sobie jest statycznym szkieletem i nie wystarcza jako źródło pełnej hierarchii.

## 6. Wygląd i nowe pliki theme

Utworzyć prawdziwe implementacje w `lib/foundation/theme/`:

- `devplanner_theme.dart`: wyłącznie fabryki light/dark ThemeData i składanie komponentów.
- `tokens/devplanner_colors.dart`: semantyczne zestawy light/dark.
- `tokens/devplanner_typography.dart`: TextTheme; wykorzystać dostępny w repo Inter z poprawnymi font weights.
- `tokens/devplanner_spacing.dart`, `devplanner_radii.dart`, `devplanner_layout.dart`: spójna skala i layout.
- `extensions/devplanner_surface_theme.dart`: tło aplikacji, content surface, sidebar, overlay, selected/hover/focus; poprawne copyWith/lerp.
- `components/`: theme przycisków, pól, menu, tabel, tooltipów, scrollbarów, dialogów; dzielić według potrzeby.
- Osobny `ThemePreferenceCubit` i storage adapter w ustawieniach: tylko wybór jasny/ciemny, bez motywu systemowego i bez dodatkowych presetów. Domyślnie jasny, zapamiętać wybór. Zmiana bez utraty trasy/stanu.

Proponowane tokens początkowe:

| Token | Jasny | Ciemny |
|---|---|---|
| appBackground | #EAF0F8 | #171B23 |
| contentSurface | #FFFFFF | #222630 |
| elevatedSurface | #F5F7FB | #2B303B |
| textPrimary | #202124 | #E8EAED |
| textSecondary | #5F6368 | #B4BAC5 |
| selectedBackground | #D3E3FD | #354969 |
| accent | #0B57D0 | #A8C7FA |

Sprawdzić kontrast par tekst/tło, hover, disabled, focus i walidacji; nie zakładać zgodności wyłącznie po kolorach. Typografia: główna treść 13–14 px, menu 14 px, pomocnicze 12 px, nagłówki 18–22 px, normalne wagi 400/500, oszczędnie 600. Nie wymuszać drobnego tekstu przy ustawionym skalowaniu systemowym; test 100%, 125%, 150%. Ikony 18–20 px, czytelne hit area 36–40 px na desktop.

Układ:

1. Systemowy pasek macOS pozostaje osobno. Belka aplikacji około 56–64 px, zawsze ma zarezerwowane miejsce w layoucie.
2. Pod belką Row: sidebar około 256 px rozwinięty / 64–72 px zwinięty oraz Expanded content. Sidebar i content mają niezależny scroll.
3. Treść to jedna duża powierzchnia z promieniem 20–24 px i marginesem zewnętrznym 12–16 px. Kanban i tabela wykorzystują dostępne miejsce; nie ograniczać ich do wąskiej kolumny artykułu.
4. Sidebar leży na tle aplikacji. Aktywna pozycja ma miękkie zaokrąglone zaznaczenie; zwarte odstępy i hierarchię przestrzeń → projekt → zasoby.
5. Po zwinięciu zostają ikony i tooltipy. Dostęp do zagnieżdżonych projektów przez popover/flyout, bez utraty funkcji i bez resetu zaznaczonej trasy. Zapamiętać stan osobno od danych domenowych.
6. Menu zachowuje stary porządek funkcjonalny, uprawnienia i akcje kontekstowe. Najpierw mapowanie wszystkich wpisów starego menu, potem zmiana wyglądu.
7. Globalny Chat/Notifications otwierają panel po prawej pod belką, nad content, bez zmiany trasy i utraty scrolla/edycji. Jeden host overlay, focus, Escape, barrier, powrót fokusu. Rozmiar panelu ograniczyć do szerokości okna.
8. Dialogi centrować w obszarze aplikacji pod belką; dropdown/popover kotwiczyć i dopasować do viewportu. Żadne menu ani modal nie przykrywa przypadkowo topbara.
9. Poniżej około 1100 px sidebar domyślnie zwinięty, przy bardzo wąskim oknie drawer. Breakpointy trzymać w tokens i przetestować zamiast mnożyć warunki w ekranach.
10. Tapeta w przyszłości jest wyłącznie warstwą tła. Treść zachowuje nieprzezroczystą powierzchnię i kontrast; nie wprowadzać zależności funkcjonalnych od obrazu.

## 7. Pakiety wykonawcze i kolejność

Każdy pakiet: konkretny zakres plików, wymagane wejście, zmiana, walidacja i wpis w dzienniku. Nie zaczynać masowego przenoszenia plików przed R2. Nie kończyć na samym analyzerze.

### R0 — zabezpieczenie i stan początkowy

- Wykonać kopię opisaną w sekcji 3; odnotować branch/commit i status obu repo.
- Zapisać aktualny analyzer do lokalnego raportu, zliczyć errors/warnings/info osobno. Grupować przyczyny: imports, brak plików, rozbieżne typy/kontrakty, wygenerowane pliki, lifecycle.
- Utworzyć macierz parity i `docs/recovery/file-recovery-manifest.md`.
- Odbiór: sprawdzona kopia + lista brakujących/nadpisanych plików + aktualny baseline, bez zmian aplikacyjnych.

### R1 — odzyskanie zmian standalone i funkcji

- Źródła: commit `d1cc273` dla oryginalnych widoków; historia lokalnych patchy Codex i VS Code dla nadpisanych migracji. Inne repo wyłącznie read-only materiał porównawczy.
- Odzyskać usunięte untracked: `data/standalone/devplanner_standalone_runtime.dart`, `presentation/chat/global_chat_composition.dart`, `presentation/notifications/global_notifications_composition.dart`, trzy `data/realtime/signalr/web_bff_signalr_http_client*.dart`, testy standalone/directory/global chat. Sprawdzić pełny zakres na podstawie logu clean.
- Runtime obecny częściowo po próbie odzyskania może być starą wersją; nie traktować samej obecności pliku jako sukcesu.
- Odzyskać zmiany identity/DTO/realtime i testów w nadpisanych tracked plikach. Patche stosować chronologicznie, z odnotowanymi konfliktami; nie wykonywać poleceń historycznych.
- Zachować odzyskane widoki board/list/details/storage. Zależności od auth/router/modal/theme zastąpić małymi lokalnymi portami.
- Ujednolicić import pakietu do `devplanner`, ale osobno naprawić kontrakty i wygenerowane typy. Sama zamiana prefiksu nie zamyka R1.
- Każdy odzyskany plik: ścieżka, źródło/czas, stan poprzedni, wynik porównania, ewentualna rekonstrukcja i test. Nie deklarować bitowej zgodności bez dowodu.
- Odbiór: kompletna lista odzyskanych oraz jawnie nierozstrzygniętych plików; żadna potrzebna funkcja nie została celowo wycięta dla kompilacji.

### R2 — kompilowalny standalone i rzeczywiste połączenie ekranów

- Zostawić aktualny `lib/auth`, lokalny issuer, PKCE/vault i BFF. Nie odtwarzać `core/auth` Ready.
- Naprawić composition roots, providers i router tak, aby `/workspaces`, projekt, tasks/kanban, szczegóły i pliki otwierały rzeczywiste ekrany z lokalnym transportem.
- W routerze istniejące adresy zachować jako stabilne lub jawne redirecty, z uwzględnieniem `/kanban` w starych linkach. Zweryfikować historyczne ścieżki; nie kierować wszystkich zasobów na home.
- Jeden współdzielony snapshot/repository kontrakt zadań dla board/list/details; backend local UserId jako źródło tożsamości.
- Naprawiać przyczyny błędów według grafu zależności, nie pojedyncze kaskadowe komunikaty.
- Odbiór: `flutter analyze` bez błędów, wygenerowane źródła aktualne, build macOS, login → przestrzeń → projekt → lista/kanban → szczegóły → pliki działa na lokalnym backendzie. Puste dane nie zastępują testu operacji create/read/update.

### R3 — inwentaryzacja funkcjonalna i naprawa pionów

Wykonywać pionami, każdy z własnym raportem i działającą trasą:

- R3A: przestrzenie/projekty/katalog użytkowników/członkostwo/ustawienia.
- R3B: kanban/lista/szczegóły i wszystkie funkcje z macierzy tasks.
- R3C: pliki/upload/download/preview/sharing/Office/czat zasobu.
- R3D: globalny chat/powiadomienia/realtime/reconnect/odwołanie dostępu.
- R3E: Wiki/Whiteboard/Corkboard/OKR i pozostałe pozycje starego menu.

Nie skracać zakresu do happy path. Co najmniej success, empty, loading, forbidden, failed, retry i konflikt wersji tam, gdzie dotyczy. MinIO/OnlyOffice/inne lokalne usługi sprawdzić przed oceną ich funkcji; brak usługi jawnie BLOCKED, nigdy pozorny PASS.

### R4 — przenoszenie do struktury pełnej aplikacji

- Najpierw mapping stara → nowa ścieżka w `docs/recovery/file-moves.md`.
- Przenosić jedną gałąź z jej testami i composition, aktualizować imports/exports/part/generated oraz router.
- Kolejność: wspólne foundation → spaces/projects → tasks → storage → chat/notifications → pozostałe zasoby → auth/admin/profile/settings.
- Dopuszczalne krótkotrwałe lokalne eksporty przejściowe, zapisane w mapie z terminem usunięcia. Nie są zgodą na przywrócenie sieciowego legacy.
- Po każdej gałęzi targeted tests + analyze. Usunąć stare ścieżki dopiero po sprawdzeniu wszystkich konsumentów. Końcowo brak `lib/workspaces` jako kontenera produktu i brak równoległych implementations.

### R5 — motywy i wspólne komponenty

- Implementować pliki z sekcji 6 bez zależności do `core/theme`.
- Przenieść istniejące używane tokens lub jawnie je zmapować; nie zmieniać hurtowo wyglądu wszystkich ekranów jednym niesprawdzonym regexem.
- Ustawić dokładnie dwa motywy, trwały wybór i poprawne component themes.
- Odbiór: reprezentatywna tabela, karta kanban, formularz i dialog w obu motywach, focus/hover/selected/error czytelne, brak hardcoded kolorów w objętych komponentach.

### R6 — shell i menu inspirowane Gmailem

- Rama, reserved topbar, zwijany sidebar, powierzchnia z zaokrąglonymi rogami, niezależny scroll.
- Podłączyć rzeczywiste menu z macierzy, drzewo projektów i uprawnienia. Brak martwych pozycji i placeholderów zastępujących gotowe funkcje.
- Zintegrować root modal host oraz globalne panele. Zmiana menu lub motywu nie inicjalizuje ponownie sesji ani nie czyści danych formularza.
- Odbiór desktop: okna 1280×800, 1440×900, 1920×1080, zwinięte/rozwinięte menu, dwa motywy, scaled text; brak overflow, zakrywania belki i podwójnych pasków przewijania.

### R7 — ujednolicenie ekranów

- Adaptować odzyskane działające widoki do nowego theme: spacing, gęstość tabel, nagłówki, formularze, menu kontekstowe, scrollbars.
- Nie wymieniać logiki Cubit/repository w pakiecie czysto wizualnym.
- Porównać funkcję po funkcji z macierzą parity po każdej zmianie ekranu. Zachować resize, drag/drop, shortcuts, inline edit i zapisane widoki.

### R8 — końcowa walidacja i dokumentacja uruchomienia

- Pełny frontend analyzer i testy; backend build oraz adekwatne testy kontraktów, jeśli zmieniono backend.
- Build i manualny smoke macOS jako pierwsza bramka. Windows/Linux/Web osobno, z rzeczywistymi wynikami albo NOT RUN. Nie zatrzymywać priorytetowej naprawy desktopu z powodu odroczonego Playwrighta.
- README: dokładne uruchomienie backendu, lokalnych usług i VS Code Flutter; konfiguracja bez sekretów, wymagane porty/HTTPS, diagnostyka błędów.
- Historyczne PASS oznaczyć zakresem/revision i zastąpić aktualnymi dowodami. Zamknięcie tylko gdy macierz parity nie ma niewyjaśnionych regresji.

## 8. Ręczny scenariusz odbioru na desktopie

1. Uruchomić lokalny backend i wymagane usługi. Wykonać login w systemowej przeglądarce, callback i /me; restart aplikacji, refresh sesji i logout. Nie zapisywać tokenów w raporcie.
2. Utworzyć testową przestrzeń/projekt albo użyć jawnie oznaczonych lokalnych fixtures. Otworzyć drzewo i ustawienia, sprawdzić dostęp użytkownika bez uprawnień.
3. Utworzyć zadanie w kanbanie, przenieść kartę, edytować w liście, otworzyć szczegóły, dodać podzadanie i załącznik, odświeżyć i sprawdzić persistence. Sprawdzić zapamiętanie widoku i kolumn.
4. Wgrać plik, anulować drugi upload, pobrać pierwszy i porównać zawartość, otworzyć preview, foldery i ACL/share. Office sprawdzić przy działającej lokalnej usłudze.
5. Otworzyć chat na ekranie zadania i pliku; wysłać wiadomość między dwoma autoryzowanymi lokalnymi użytkownikami, zobaczyć live update i powiadomienie. Zamknąć panel: ta sama trasa i stan edycji.
6. Sprawdzić pozostałe zasoby z macierzy. Nie zaliczać kliknięcia na pusty ekran jako testu działania zasobu.
7. Powtórzyć istotne widoki w dark/light i po zwinięciu menu. Zrzuty dowodowe bez sekretów i danych osobowych, pliki lokalne.
8. Sprawdzić offline/API error/403/konflikt i retry. Aplikacja nie może pokazywać sukcesu, jeśli backend odrzucił zapis.

## 9. Kontrakt przekazania zadania kolejnemu czatowi

Wklej poniższy szablon i uzupełnij pola. Nie zlecaj „napraw całe workspace” bez ograniczonego zakresu.

```text
Projekt: DevPlanner standalone Flutter + C#.
Czytaj AGENTS.md i docs/devplanner-recovery-and-ui-plan.md w całości.
Pakiet: [R...], cel: [konkretne działanie użytkownika].
Stan wejściowy i zależności: [...].
Pliki, których jesteś właścicielem: [...].
Pliki wspólne/router/theme: zgłoś potrzebną zmianę koordynatorowi.
Wymagane zachowane funkcje i kontrakt backendu: [...].
Zakaz kasowania funkcji/testów, git clean/masowego restore,
placeholderów zamiast funkcji i połączeń Ready/Core/DataBus.
UI bez I/O; drzewiasta struktura; małe Cubity; lokalny UserId.
Nie uznawaj historycznych PASS za aktualne wyniki.
Odbiór: [komendy] + [scenariusz użytkownika] + parity IDs [...].
Raport: dokładne pliki, wynik każdej komendy, nierozwiązane problemy,
źródło odzyskanego kodu, następny krok. Bez commit/push bez polecenia.
```

Jeśli użytkownik zleci pracę równoległą: R0/R1, router i wspólna struktura mają jednego właściciela; po stabilizacji kontraktów można rozdzielić tasks, storage, pozostałe zasoby i backend. Nie uruchamiać jednocześnie generatora z przenoszeniem jego źródeł. Liczba agentów nie zastępuje review i smoke działającego ekranu.

## 10. Dziennik i kryterium zakończenia

Po każdym pakiecie utworzyć `docs/recovery/Rxx-report.md` oraz zaktualizować parity i handoff. Raport zawiera: zakres, pliki, źródła odzyskania, komendy/wyniki, regresje, pozostałe zależności, następny pakiet. Aktualizacje wspólnych planów/handoffów utrzymać identyczne w dwóch repo według ich AGENTS.md.

Checklist:

- [ ] R0 zweryfikowana kopia i baseline.
- [ ] R1 odzyskane migracje standalone i wszystkie utracone funkcje/testy.
- [ ] R2 standalone kompiluje się i prowadzi do rzeczywistych ekranów.
- [ ] R3A–E każdy pion ma aktualne dowody działania.
- [ ] R4 funkcje przeniesione do struktury pełnej aplikacji.
- [ ] R5 nowe theme light/dark bez eksportu starego theme.
- [ ] R6 zwijane menu i zaokrąglony content działają na desktopie.
- [ ] R7 wszystkie wcześniejsze funkcje zachowane po zmianach wizualnych.
- [ ] R8 aktualna walidacja, README i uczciwy raport platform.

Produkt jest naprawiony dopiero wtedy, gdy zalogowany użytkownik może rzeczywiście korzystać z odzyskanych zadań/kanbanu/plików i reszty wcześniejszych funkcji w samodzielnym DevPlannerze. Samo przywrócenie plików, zielony analyzer, nowy shell lub działające logowanie nie spełniają tego kryterium.
