# Kanban — szczegółowa specyfikacja refaktoryzacji UI dla agenta

Data: 2026-09-06. Status: do wdrożenia. Zakres: wyłącznie UI Kanbana i stan konieczny do poprawnego rozwijania kart. Ten dokument doprecyzowuje wygląd po pierwszej implementacji wcześniejszego [audytu](kanban-audit-and-rebuild-plan-2026-09-06.md). Nie zastępuje jego backlogu backendowego.

## 1. Zlecenie i granice

Najnowsza wytyczna użytkownika: UI ma być lżejsze, w szczególności przez dotted border zamiast ciężkich pełnych ramek. Czytelność uzyskujemy typografią i rytmem, nie zwiększaniem ciężaru obramowań.

Użytkownik odrzucił aktualny wygląd: granice kart są niewyraźne, brakuje czytelnych kropkowanych obramowań/prowadnic, typografia jest zbyt drobna i niespójna, rozwijanie podzadań wygląda źle. Celem jest gotowy produktowo Kanban, a nie samo dodanie widgetów realizujących funkcje.

Pracuj na branchu `workspace`. Zachowaj niezacommitowane zmiany innych agentów. Nie przebudowuj listy Tasks, szczegółów zadania, ich pickerów, globalnego motywu ani shella. Minimalna zmiana punktu montowania Kanbana w `tasks_board_page.dart` jest dopuszczalna. Nowe style są lokalnymi tokenami Kanbana korzystającymi z motywu aplikacji. Nie zmieniaj fontu całej aplikacji.

Zachowaj dodany auto-scroll (`viewport/kanban_auto_scroll_coordinator.dart`), pending mutacji i menu PPM. Najpierw przeczytaj ich aktualne API. Nie wracaj do poprzedniego snapshotu kodu. Nie oznaczaj interfejsu jako ukończonego na podstawie samego analyze/testów.

## 2. Aktualny stan — co dokładnie poprawić

Przegląd statyczny bieżących, zmodyfikowanych plików; nie wykonano oględzin działającego UI. Poniższe rozmiary pochodzą z kodu, nie pomiaru screenshotu.

| Miejsce | Obecny problem | Wymagana zmiana |
|---|---|---|
| `tasks_board_card_content.dart`, `_TaskCard` | Border `outlineVariant` z alpha .75; subtelny czarny cień; niezależne promienie/paddingi | Jedna lekka powierzchnia karty z subtelnym dotted border i stanami opisanymi poniżej; bez cienia w spoczynku. |
| Ten sam plik, `_CardIdentity` | Kod, checkbox, pin, watch, menu i znacznik priorytetu konkurują o szerokość | Kod ma mniejszy ciężar; akcje drugorzędne w „…”/hover. Tytuł jest pierwszym punktem skanowania. |
| Ten sam plik, `_CardMeta` i `KanbanCardSubtasksSection` | Podzadania mają osobny przełącznik i ponownie licznik w metadata | Jeden przełącznik `Podzadania 3/7`; usunąć drugą prezentację tego samego licznika. |
| `tasks_board_card_subtasks.dart`, `_ChildTaskMiniCard` | Kod 10 px bold, tytuł 11 px, inicjał 8 px; wszystko w jednej linii i wewnętrznej karcie | Wiersz dziecka 13 px, kod przeniesiony do tooltipu/menu, osoba na końcu. Dzieci tworzą jedną sekcję hierarchii. |
| `_SubtaskBranchPainter` | Segmenty 3/2.5 px są kreskami; odgałęzienie ma stałe Y=16 niezależne od rzeczywistego wiersza | Prawdziwe punkty, geometrycznie spójne prowadnice; środek pierwszej linii/statusu jest kotwicą. |
| `_isExpanded` w `build` | Natychmiastowe wstawienie całego poddrzewa `if`; brak kontrolowanej animacji | Animacja wysokości sekcji 180 ms, zachowanie położenia nagłówka karty, brak rozjeżdżania linii. |
| `_loadChildren` / „więcej” | Limit 5, kursor nie jest zachowany, „więcej” otwiera szczegóły | Paginacja dzieci wewnątrz karty; „Otwórz zadanie” pozostaje osobną akcją. |
| `_submitNewSubtask` | Odczyt i zapis przez repository w StatefulWidget; błąd dodawania ignorowany, ręczne składanie DTO | Osobny lokalny Cubit gałęzi; typowane błędy i aktualizacja licznika/gałęzi po powodzeniu. |
| `tasks_board_cards.dart`, feedback | Ponownie używa karty ze Stateful podzadaniami, stała szerokość 286 | Bezstanowy drag preview aktualnej karty; bez drugiego fetch/state; szerokość z pomiaru źródła. |

## 3. Docelowa anatomia karty

Karta jest jedną czytelną powierzchnią. Podzadania rozwijają się pod metadanymi w ramach tego samego zewnętrznego obrysu. Nie tworzyć stosu małych kart z cieniami w środku dużej karty.

```text
┌───────────────────────────────────┐
│ TASK-124             [priorytet] ⋯ │
│ Przygotować ofertę dla klienta     │
│                                   │
│ [Sprzedaż]     termin       [Anna] │
│ ▾ Podzadania                 3/7  │
│ ································· │
│  ┊                                │
│  ├·· ○ Weryfikacja danych     [JK] │
│  ├·· ✓ Wycena                [AN] │
│  └·· ○ Sprawdzenie załączników    │
│       Pokaż kolejne 5              │
│       + Dodaj podzadanie           │
└───────────────────────────────────┘
```

Schemat określa hierarchię, nie styl kreski obrysu: zewnętrzny obrys implementujemy jako dotted, zgodnie z sekcją 3.3, mimo ciągłych znaków ASCII. Nie określa też liczby pustych wierszy. W kodzie odstępy wynikają z tabeli tokenów. Zakończenie prowadnicy musi uwzględniać również wiersz „Pokaż kolejne”/dodawania; nie rysować pionowego ogona po ostatniej pozycji.

### 3.1. Tokeny geometrii

Wartości dotyczą logicznych pikseli Fluttera przy text scale 1.0. To specyfikacja startowa; dopuszczalne odstępstwa opisać w raporcie wraz ze screenshotem.

| Element | Compact | Comfortable / Detailed |
|---|---:|---:|
| Zewnętrzny radius karty | 8 | 8 |
| Dotted border zwykłej karty (średnica punktu) | 1 | 1 |
| Padding treści | 10 | 12 |
| Odstęp identity → title | 4 | 4 |
| Odstęp title → metadata | 6 | 8 |
| Odstęp między niepustymi sekcjami | 6 | 8 |
| Przerwa pomiędzy kartami | 8 | 8 |
| Wysokość wiersza przełącznika dzieci | min. 28 | min. 32 |
| Wiersz dziecka, jeden wiersz tekstu | min. 32 | min. 36 |
| Wcięcie hierarchii | 16 | 16 |
| Ikona metadanych / akcji | 16 / 18 | 16 / 18 |
| Awatar rodzica / dziecka | 24 / 20 | 24 / 20 |
| Pole trafienia akcji myszą/klawiaturą | min. 28×28 | min. 28×28 |

Nie uzyskuj gęstości przez font 8–11 px. Usuń zbędne wiersze, zdublowane informacje i nadmiar akcji. Szerokość kolumny startowo 300–320 px, z minimum 280 px; gap 12 px i zewnętrzny gutter 12 px. Węższe okno przewija tablicę, zamiast zmniejszać tekst. Nagłówek kolumny 40 px, bez wielkiej kolorowej belki. Jeżeli shell ogranicza przestrzeń, napraw jedynie wewnętrzny layout Kanbana.

### 3.2. Typografia — obowiązkowa hierarchia

Użyj istniejącej rodziny fontu z `TextTheme`, jeden lokalny zestaw stylów Kanbana. Bez stałych rozmiarów porozrzucanych po widgetach, bez wymuszania textScale=1.

| Rola | Font size / line height | Weight | Kolor |
|---|---|---|---|
| Nazwa kolumny | 13 / 18 | 600 | onSurface |
| Tytuł rodzica | 14 / 20 | 500 | onSurface |
| Tytuł podzadania | 13 / 18 | 400–500 | onSurface |
| Kod zadania | 12 / 16 | 400 | onSurfaceVariant |
| Termin, liczniki, etykiety | 12 / 16 | 400–500 | onSurfaceVariant |
| Nagłówek „Podzadania” | 12 / 16 | 500 | onSurfaceVariant |
| Inicjały awatara dziecka | 10 / 12 | 500 | onPrimaryContainer |

Tytuł rodzica: do 2 linii w Compact/Comfortable, do 3 w Detailed. Dziecko: do 2 linii, wysokość rośnie naturalnie. Nie wciskaj kodu i długiego tytułu w jeden wiersz. Pełna nazwa przez tooltip i semantics. Brak bold 700/800 dla kodów lub metadanych. Ukończenie wskazuje status; opcjonalne przekreślenie tytułu bez obniżania całego wiersza do nieczytelnej opacity. Liczby mogą używać tabular figures wspieranych przez obecny font.

### 3.3. Borders i linie dotted

Potwierdzona wytyczna użytkownika: lekki wygląd i dotted border. Nie zastępować tego ciężką ciągłą ramką. Wprowadź następujące rozróżnienie:

- **Zewnętrzna granica rzeczywistej karty:** dotted, okrągłe punkty średnicy 1 px co 3–4 px, radius 8 px. Kolor lokalnego tokenu `cardBorder` z `ColorScheme.outlineVariant`, dostrojony osobno w light/dark. Ma subtelnie oddzielać karty, nie tworzyć dominującej ramki. Tło karty bliskie powierzchni tablicy, bez cienia i bez kolorowej poświaty.
- **Rozwinięta sekcja dzieci:** pojedynczy kropkowany separator poziomy ponad dziećmi, odsunięty od obrysu karty o padding. Dodatkowo kropkowana prowadnica drzewa; nie otaczaj każdego dziecka czterema liniami.
- **Dotted oznacza punkty**, nie kreski: średnica około 1.5 px, odstęp między środkami 4 px. Kolor `hierarchyBorder`, minimum tak czytelny jak zwykły separator. Rasteryzację sprawdzić przy DPR 1 i 2; nie używać tekstu „...” do rysowania.
- **Placeholder dodawania/drop:** zaokrąglony kropkowany obrys 1 px. Przy aktywnym drop kolor primary i lekkie tło primaryContainer. Odróżniaj pusty cel od rzeczywistej karty etykietą/ikoną i stanem aktywnym, nie grubszą ramką.
- **Hover:** zachowaj dotted border, delikatnie zwiększ kontrast i zmień powierzchnię; brak zmiany wymiarów i unoszenia karty. **Selected:** dotted border w primary i bardzo delikatne primaryContainer. **Keyboard focus:** dodatkowy ring 2 px poza layoutem, nie tylko zmiana tła. **Dragging:** jedyny stan z cieniem; źródło ma czytelny placeholder.
- Dotted border i clip należą do jednego właściciela powierzchni. Nie nakładaj trzech niezależnych `Material`/`Container` z rozbieżnymi radiusami. Ink/hover nie mogą przykryć prowadnic ani obrysu.

## 4. Rozwijanie podzadań — specyfikacja zachowania

1. Cały wiersz `chevron + Podzadania + completed/total` jest jednym przyciskiem. Nie dublować ikonki drzewa obok chevronu. Nie zmieniać etykiety na długie „Ukryj podzadania”: stała nazwa i obrót chevronu wystarczają.
2. Toggle przez klik/Enter/Spację; semantics opisuje expanded i liczbę dzieci. Klik nie otwiera rodzica i nie zaczyna drag. Rodzic nie obejmuje dzieci jednym przechwytującym wszystkie kliknięcia obszarem nawigacji.
3. `AnimatedSize` lub równoważny kontrolowany layout, 180 ms easeOutCubic, alignment topCenter, clip podczas animacji. Chevron obraca się w 120–160 ms. Przy reduced motion zmiana natychmiastowa. Bez scale/bounce i bez animowania każdej litery/wiersza.
4. Top karty zostaje w tej samej pozycji. Naturalnie przesuwają się kolejne karty poniżej. Nie wywołuj bezwarunkowo `ensureVisible` dla całej rozwiniętej karty. Przy dodawaniu przewiń minimalnie tylko input do widocznego obszaru kolumny.
5. Pierwszy odczyt: 3 skeleton rows o docelowej geometrii, bez pełnego loadera zasłaniającego kartę. Zachowaj nagłówek, tekst i metadata rodzica. Dane pokazują do 5 dzieci; kolejne strony przez mały footer.
6. „Pokaż kolejne 5” pobiera następną stronę **w tej samej karcie**, nie otwiera szczegółów. Nie dokładać zagnieżdżonego pionowego scrolla: przewija się kolumna. Jeżeli liczba wierszy znacząco rośnie, pozostaje łatwo dostępne zwinięcie sekcji.
7. Każde dziecko: status 16 px, gap 6, elastyczny tytuł, avatar 20 px. Kod/pełny status/termin w tooltipie lub dodatkowych metadanych Detailed. Brak cienia i pełnej ramki każdego dziecka; hover jako jednolite tło wiersza.
8. Status jest kontrolką tylko jeśli istnieje podłączona, dozwolona akcja i obsługa błędu. W przeciwnym razie statyczna ikona z semantyką, nie pozornie klikalny checkbox. Otwarcie dziecka przez tytuł nie otwiera rodzica.
9. Błąd fetch: mały wiersz z komunikatem i „Ponów”; błąd kolejnej strony nie usuwa wcześniejszych dzieci. Błąd create pozostawia input i wpisany tekst oraz pokazuje komunikat backendu. Żadnych pustych catch lub cichego zamknięcia formularza.
10. Zwinięcie zachowuje cache i scroll kolumny. Ponowne rozwinięcie nie robi zbędnego fetch. Zmiana rodzica/wersji dzieci unieważnia właściwą gałąź; widget ma stabilny klucz taskId. Odmontowanie anuluje/ignoruje wynik żądania.
11. Nowe dziecko pojawia się jednokrotnie po potwierdzeniu; licznik rodzica i lista są spójne. Realtime nie dubluje wyniku create. Pokazanie dodawania zależy od uprawnień. Przy zerze dzieci możliwość dodania przez menu rodzica pozostaje dostępna.
12. Drag preview to bezstanowa reprezentacja rodzica z licznikiem dzieci, nie druga instancja komponentu pobierającego dane. Rozwinięcie źródła po drop/cancel pozostaje takie jak przed drag. Podczas drag dzieci nie stają się osobnymi celami zmiany rodzica.

## 5. Podział implementacji — konkretne zadania

Ścieżki względem `lib/workspaces/presentation/tasks/board/`. Nie rozdrabniać prostych fragmentów na sztuczne feature’y.

| Kolejność | Plik/gałąź | Zadanie |
|---|---|---|
| 1 | `cards/kanban_card_tokens.dart` (propozycja) | Jedno źródło wymiarów, kolorów stanów i typografii, oparte na motywie. Wykorzystać istniejący adapter ikon. |
| 2 | `tasks_board_card_content.dart` → `cards/` | Wyodrębnić powierzchnię i prezentację rodzica; usunąć nadmiar akcji, powtórny licznik, lokalne style. Zachować obecne callbacki i kontrakt danych. |
| 3 | `cards/subtasks/cubit/` | Cubit ze stanem danych, paginacji, błędu i create; repository przez konstruktor. Toggle/hover mogą pozostać lokalnym stanem UI. Nie trzymać sieci i mapowania DTO w `setState`. |
| 4 | `cards/subtasks/` | Sekcja, wiersz dziecka, prowadnice, mały footer i input; jeden właściciel expanded i animacji. Painter tylko od geometrii, testowalny bez API. |
| 5 | `tasks_board_cards.dart` | Stateless drag preview i rzeczywista szerokość źródła; nie ingerować w działający koordynator auto-scroll poza koniecznym adapterem. |
| 6 | `tasks_board_columns.dart` | Ujednolicić gap, padding, powierzchnie i header; po zmianie wysokości wierszy zweryfikować prefetch/DnD. Nie refaktorować całego hosta Tasks. |
| 7 | lokalizacje / testy | Wszystkie etykiety przez ARB; aktualizacja goldenów dopiero po wizualnym obejrzeniu nowego wyniku. |

Nowe klasy dokumentować po polsku; publiczne API przez `*_export.dart`. Osobnego globalnego design systemu ani nowej biblioteki UI/fontów nie potrzeba. Dla samej poprawy obramowań/typografii/animacji nie potrzeba zmian backendu. Paginację dzieci najpierw podłączyć do istniejącego repository; ewentualną lukę kontraktu opisać oddzielnie, bez zgadywania endpointu.

## 6. Odbiór — agent ma dostarczyć dowody

Przed zmianą wykonaj screenshot baseline. Następnie zbuduj lokalny scenariusz z tym samym zestawem danych, który można oglądać bez danych produkcyjnych. Nie twórz publicznego deploymentu ani nie zmieniaj produkcyjnych zadań.

Obowiązkowe przypadki:

- Rodzic z krótkim i dwuliniowym tytułem, 0/1/5/12 dzieci, brak/pełne metadata, wiele etykiet, długa polska nazwa i długi kod.
- Ta sama karta zwinięta, rozwinięta, loading, błąd, load-more, create, selected, hover, focus, drag preview.
- Light/dark; szerokość kolumny 280 i 320 px; viewport 1280×800 i 1920×1080; skala tekstu 1/1.25/1.5. Przy zwiększonym tekście wysokość rośnie, nie klipuje.
- Screenshoty przed/po w tej samej skali oraz krótki zapis rozwijania i przewijania podczas drag. Minimum Web i macOS; Windows/Linux zachowują te same zachowania, brak możliwości uruchomienia zgłosić jawnie.

Checklista akceptacji:

- [x] Karty mają subtelny dotted border i brak cienia; obrys nie dominuje nad tekstem w obu motywach. Ciągła mocna ramka jest zarezerwowana dla keyboard focus, nie zwykłych kart.
- [x] Separator i prowadnice są kropkowane, a nie przerywanymi kreskami; brak urwanych/zdublowanych odcinków przy długim wierszu.
- [x] Tytuły dzieci mają 13 px; w treści nie ma mikrofontów 8–11 px. Inicjał awatara jest jedynym dopuszczonym tutaj wyjątkiem 10 px.
- [x] Rodzic, dziecko i metadata mają trzy czytelne poziomy hierarchii; tytuł dominuje nad kodem i ikonami.
- [x] Licznik dzieci występuje raz; rozwinięcie nie przestawia metadata rodzica.
- [x] Animacja nie skacze, nie ucina wierszy po zakończeniu i nie zmienia pozycji topu karty.
- [x] „Pokaż kolejne” pozostaje na tablicy i faktycznie stronicuje; błąd nie kasuje danych/inputu.
- [x] Dziecko, checkbox/toggle/menu i tytuł rodzica nie przechwytują sobie kliknięć.
- [x] Drag preview nie inicjuje dodatkowego pobierania; auto-scroll obu osi działa po refaktorze.
- [x] Zmiana dotyczy wyłącznie Kanbana i jego lokalnych komponentów; lista Tasks nie została przebudowana.

Uruchom formatter/analyze zmienionego zakresu, istniejące `kanban_card_interactions_test.dart`, `kanban_auto_scroll_coordinator_test.dart` i właściwe testy Cubita. Dopisz znaczące testy: klik dziecka nie otwiera rodzica, toggle zachowuje pozycję i stan, 2 strony bez duplikatów, retry/create error oraz brak fetch w drag preview. Golden fixtures mają obejmować light/dark i rozwinięcie; nie zastępują ręcznego oglądu.

## 7. Format końcowego przekazania

Agent raportuje: pliki zmienione, screenshoty przed/po, wyniki testów, które punkty powyższej checklisty sprawdził, a które pozostały nieweryfikowane. Nie kończy raportem „dodano animację i border” bez obejrzenia rezultatu. Najpierw dopracowuje jedną referencyjną kartę zwiniętą i rozwiniętą, potem przenosi te reguły na pozostałe stany. Nie dokłada w tym zadaniu nowych filtrów i funkcji domenowych kosztem jakości karty.
