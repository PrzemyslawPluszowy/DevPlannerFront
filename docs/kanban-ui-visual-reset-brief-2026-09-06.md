# Kanban — visual reset brief dla kolejnego agenta

## Decyzja produktowa

Aktualna implementacja jest technicznie lepsza, ale wizualnie nadal nie osiąga celu. Nie należy jej dalej dopieszczać przez kolejne lokalne poprawki. Potrzebny jest **visual reset** karty i kolumny: spokojna powierzchnia, wyraźna hierarchia tekstu, bardzo lekka kropkowana struktura oraz podzadania wyglądające jak część zadania, a nie małe „karty w karcie”.

Inspiracją jest ergonomia narzędzi do pracy typu ClickUp/Asana/Monday: szybko skanuje się tytuł, właściciela, termin i postęp, a dopiero potem rozwija szczegóły. Nie kopiować wyglądu żadnego z tych produktów.

Zakres: `lib/workspaces/presentation/tasks/board/` oraz lokalne testy Kanbana. Nie zmieniać listy Tasks, szczegółów zadania, globalnego fontu, globalnego theme ani backendu. Zachować działające DnD, auto-scroll, menu kontekstowe, optimistic update i API podzadań.

## Co jest nieudane w aktualnej wersji

To są konkretne problemy widoczne w aktualnym kodzie, które agent ma traktować jako wymagania do usunięcia:

1. `DashedRRectPainter` i `DashedHorizontalLinePainter` rysują kreski 4 px z przerwą 3 px. To **nie jest dotted border** i optycznie dzieli kartę na ciężkie bloki. Komentarze mówią o „dotted”, implementacja jest dashed — usunąć tę niespójność.
2. Zewnętrzny obrys karty, separator i drzewo podzadań używają podobnego motywu kreskowania, więc karta wygląda jak element technicznego diagramu zamiast elementu roboczego.
3. Karta ma za dużo równorzędnych znaków: checkbox, kod, seria/cykl, priorytet, menu, label, podzadania i meta. Nawet po przeniesieniu części akcji do menu brakuje jednego wyraźnego punktu startu wzroku — tytułu.
4. Kropkowane prowadnice podzadań mają stałą kotwicę Y=16 px. Przy dwuliniowym tytule, błędzie, „Pokaż kolejne” albo formularzu nie odpowiada to środkowi elementu i wygląda przypadkowo.
5. Oddzielne mini-wiersze dzieci nadal są nadmiernie „skomponentowane”: prowadnica, ikona, avatar, status, dodatkowe interakcje i footer mieszają się na szerokości ok. 300 px.
6. `AnimatedSize` zostało dodane, ale chevron używa zamiennej ikony zamiast faktycznego obrotu kontrolera `_chevronController`; deklarowany efekt nie jest wykonywany.
7. Loading sekcji to spinner i tekst, mimo że plan wymagał trzech szkieletowych wierszy o docelowej geometrii.
8. Są wciąż twardo wpisane napisy („Podzadania”, „Pokaż kolejne 5”) zamiast lokalizacji. Nie dodawać kolejnych.
9. Karta jest `StatefulWidget` wyłącznie dla hoveru. To rozszerza zakres przebudowy. Hover powinien być lokalnym stanem małego wrappera albo `InkWell`/`FocusableActionDetector`; zawartość karty ma być możliwie prezentacyjna.

## Docelowy obraz

```text
╭ · · · · · · · · · · · · · · · · · · · · · · · ╮
· EX-124                                      •   ·
· Przygotować ofertę dla klienta                   ·
·                                                  ·
·  Termin jutro                  Anna Kowalska     ·
·                                                  ·
·  ▾  Podzadania                              3/7  ·
·     · · · · · · · · · · · · · · · · · · ·      ·
·     ┆  ○ Weryfikacja danych                  JK  ·
·     ┆  ✓ Wycena                              AN  ·
·     └  ○ Załączniki                               ·
·        Pokaż 4 kolejne                            ·
╰ · · · · · · · · · · · · · · · · · · · · · · · ╯
```

ASCII jest tylko opisem hierarchii. Zewnętrzna granica to pojedyncze, dyskretne punkty. Separator sekcji podzadań i drzewo mają mniejszy kontrast niż obrys karty. Nie rysować kreskowanych linii 4 px. Nie stosować cieni na zwykłych kartach.

## Jednoznaczne reguły wizualne

### Karta

| Element | Reguła |
|---|---|
| Tło | `surface` z minimalną różnicą względem tła kolumny; bez gradientu, bez cienia w spoczynku. |
| Obrys | Dotted, okrągły punkt 1 px, odstęp środek–środek 4 px, radius 10 px. Kolor `outlineVariant` z alpha około 0.55 w light i osobno sprawdzony w dark. |
| Hover | Tylko lekko jaśniejsza powierzchnia oraz alpha obrysu około 0.8. Bez podnoszenia, bez skalowania, bez zmiany wysokości. |
| Selected | Primary dotted border oraz powierzchnia `primaryContainer` z alpha maks. 0.14. |
| Focus | Jedyny ciągły ring 2 px poza layoutem; nie zastępuje dotted border. |
| Padding | 12 px comfortable/detailed, 10 px compact. Nie zmniejszać fontu, aby uzyskać gęstość. |
| Pionowy rytm | 4 px: identity → tytuł; 8 px: tytuł → następna rzeczywista sekcja; 6 px między małymi metadanymi. |

Nie używać `Border.all` na zwykłej karcie, a potem nakładać `CustomPaint`. Za granicę odpowiada jeden komponent `KanbanDottedCardFrame`, który klipuje ink i rysuje obrys po tle. Painter musi rysować **koła** przez `drawCircle`, a nie segmenty ścieżki ze `StrokeCap.round`.

### Typografia

| Rola | Parametry | Zasada |
|---|---|---|
| Tytuł rodzica | 15 px / 20 px, weight 500 | Najważniejszy tekst. 2 linie w compact i comfortable, 3 w detailed. |
| Tytuł dziecka | 13 px / 18 px, weight 400 lub 500 | Do 2 linii; bez ściśnięcia wraz z kodem w tym samym rzędzie. |
| Kod zadania | 11 px / 16 px, weight 500, `onSurfaceVariant` | Pomocniczy. Bez primary i bez bold 700. |
| Meta, label, licznik | 12 px / 16 px, weight 400–500 | Jeden, spokojny styl. |
| Nazwa kolumny | 14 px / 20 px, weight 600 | Header ma być cichy, ale czytelny. |

Nie wprowadzaj w treści wielkości 8–10 px. Dopuszczalny wyjątek: inicjały w awatarze 20 px, ale tylko jeśli nadal czytelne przy skali 125%. Nie używać samych ikon jako nośnika krytycznej informacji. Priorytet ma tooltip/semantics i nie konkuruje z tytułem.

### Górny wiersz

- Lewa strona: checkbox pojawia się przy hover, focus lub selection; w przeciwnym razie pozostawia stabilne miejsce tylko wtedy, gdy zapobiega skakaniu kodu. Nie używać stale dominującego checkboxa w każdej karcie.
- Kod zadania jest krótki i neutralny.
- Cykliczność, przypięcie i obserwowanie pokazują się tylko jako małe aktywne wskaźniki; ich zmiana jest w menu `…`.
- Prawa strona: mały znacznik priorytetu oraz menu. Żadnego szeregu 3–4 ikon.
- Tytuł musi zaczynać się na tej samej osi w każdej karcie, niezależnie od checkboxa i badge’a serii.

### Metadane

- Pokazywać maksymalnie trzy rzeczy w comfortable: termin, osoba, postęp checklisty **albo** licznik podzadań. Licznik podzadań nie może być równolegle w metadanych i w przełączniku sekcji.
- Szczegółowe pola, czas, blokady i okładka wyłącznie w detailed lub gdy stan jest wyjątkowy (np. blokada).
- Etykiety mają być płaskimi pillami z czytelnym tekstem i jednym kolorem tła; maks. 2 widoczne, reszta jako `+N`.
- Awatar osoby 24 px, bez ciężkiej ramki. Jeśli brak osoby, nie renderować pustego placeholdera.

### Kolumna

- Tło kolumny tylko o ton inne od tła tablicy. Bez dużych, nasyconych, pełnych belek statusu.
- Kolor statusu jako pasek 3 px po lewej stronie headera lub mała kropka obok nazwy.
- Header ma: nazwę, licznik, WIP, menu, zwijanie. Wszystko mieści się w 40 px wysokości.
- Karty: gap 8 px. Kolumna: 300–320 px; minimum 280 px. Board padding 12 px, gap kolumn 12 px.

## Podzadania: docelowa ergonomia

1. Gdy sekcja jest zwinięta, pokazuj jeden wiersz: chevron, „Podzadania” i `3/7`. Nie pokazuj ikony drzewa, dodatkowego licznika ani tekstu „Ukryj”.
2. Kliknięcie wiersza nie otwiera rodzica. Enter i Spacja działają, `Semantics` wystawia `expanded`.
3. Chevron naprawdę obraca się przez `RotationTransition`; nie przełączaj go na inną ikonę. Animacja 140 ms, rozwinięcie 180 ms, `easeOutCubic`. Dla reduced motion bez animacji.
4. Separator jest pojedynczą linią małych punktów 1 px co 4 px, 6 px nad pierwszym dzieckiem. Jest lżejszy niż obrys karty.
5. Wiersz dziecka ma układ: status 16 px → 6 px → elastyczny tytuł → opcjonalny avatar 20 px. Kod dziecka nie należy do stałego wiersza; pełny kod w tooltipie i menu.
6. Nie rysuj ramki ani cienia każdego dziecka. Na hover tylko tło `surfaceContainerHighest` z alpha około 0.35 i radius 6 px.
7. Drzewo: pionowa prowadnica 1 px z pojedynczych kropek, od środka pierwszego statusu do środka ostatniego statusu. Krótkie odgałęzienie do statusu. Geometria zależna od faktycznej wysokości wiersza; nie stałe `branchEndY = 16`.
8. Footer („Pokaż 4 kolejne”, „Dodaj podzadanie”, loading, błąd) nie udaje dziecka: jest wcięty do osi tytułów, bez pionowej prowadnicy po ostatnim dziecku.
9. Loading to trzy skeleton rows o wysokości 36 px. Nie spinner z tekstem w środku karty.
10. Błąd pierwszego/końcowego pobrania zachowuje dane już widoczne. Błąd create trzyma wpisany tekst i pokazuje backendowy komunikat pod inputem.
11. Tytuł dziecka otwiera dziecko. Ikona statusu jest interaktywna tylko gdy istnieje autoryzowana mutacja i rollback; w przeciwnym razie statyczna.
12. Rozwinięcie nie może uruchamiać fetch w feedbacku DnD. Preview pokazuje wyłącznie tytuł, kod i opcjonalne `3/7`.

## Konkretne poprawki w plikach

1. `cards/kanban_card_tokens.dart`
   - Usuń `cardBorderDashWidth`, `cardBorderDashSpace`, `hierarchyDashWidth`, `hierarchyDashSpace` i klasy/komentarze `Dashed*`.
   - Dodaj jeden spójny zestaw tokenów dot pattern oraz factory/painter dla punktowego RRect, separatora i prowadnicy. Nazwy muszą mówić `Dotted`, nie `Dashed`.
   - Nie deklaruj tokenów, których painter nie używa.

2. `tasks_board_card_content.dart`
   - Wydziel `KanbanDottedCardFrame`. Zawartość karty wraca do stateless prezentacji; stan hover/focus pozostaje w małym wrapperze.
   - Użyj lokalizacji dla wszystkich tekstów i tooltipów. Usuń komentarze twierdzące, że istnieje efekt, którego kod nie robi.
   - Uporządkuj kolejność: identity → title → labels → primary meta → subtasks → detailed meta. Jeśli podzadania są widoczne, nie renderuj ich licznika w `_CardMeta`.

3. `tasks_board_card_subtasks.dart`
   - Zamień `AnimatedSize` + warunkową ikonę na dostępny toggle z `RotationTransition` i faktycznym reduced-motion fallbackiem.
   - Zamień spinner loading na skeleton rows.
   - Painter dostaje wysokość i środek statusu wiersza z layoutu; footer nie używa `_SubtaskBranchItem` jako fałszywego dziecka.
   - Teksty „Podzadania” i „Pokaż kolejne 5” przenieś do ARB. Liczba pozostałych elementów ma być dynamiczna: `Pokaż kolejne {count}`.

4. `tasks_board_cards.dart`
   - Preview używa tego samego lekkiego dotted frame, ale może mieć subtelny cień wyłącznie jako feedback DnD. Nie stosować ciągłej primary ramki innej niż reszta systemu bez powodu.
   - Nie zmieniaj koordynatora auto-scroll przy tej pracy poza konieczną kompatybilnością.

5. `tasks_board_columns.dart`
   - Ujednolić aktualne twarde `padding 20/16/20/24` i `separator 14` z tokenami boardu: gutter 12, gap 12, card gap 8.
   - Zredukować ciężar nagłówka statusu zgodnie z sekcją „Kolumna”.

## Zakaz obejść

- Nie „naprawiaj” odbioru przez osłabienie testów lub usunięcie goldenów.
- Nie dodawaj kolejnej biblioteki UI/fontu.
- Nie rozsiewaj wartości koloru/rozmiaru w widgetach.
- Nie używaj `debugPrint`, twardo wpisanych polskich tekstów ani pełnych payloadów w logach.
- Nie zamieniaj kropkowania na kreski z zaokrąglonymi końcówkami i nie nazywaj tego dotted.
- Nie dokładaj dalej funkcji filtrów, zmian backendu, nowych pickersów ani przebudowy listy Tasks. Najpierw dowieźć piękną kartę referencyjną.

## Sposób pracy i odbiór

1. Zrób screenshot aktualnego stanu jako baseline.
2. Najpierw ukończ jedną kartę referencyjną w stanach: zwykły, hover, selected, focus, zwinięte dzieci, rozwinięte dzieci, loading, błąd i drag preview.
3. Obejrzyj ją ręcznie przy 280 i 320 px oraz light/dark, zanim przeniesiesz komponent na całą tablicę.
4. Dopiero potem dostosuj kolumny i pozostałe density.
5. Uruchom formatter, analyze oraz testy interakcji i auto-scrolla. Testy nie zastępują screenshotów.

Odbiór następuje wyłącznie, gdy agent dostarczy screenshoty przed/po w Web 1280×800 i Desktop/macOS, dla light/dark oraz skali tekstu 100% i 125%, plus krótki zapis rozwijania i DnD. Sprawdzić ręcznie:

- [ ] obrys jest rzeczywiście punktowy, lekki i nie przypomina diagramu technicznego;
- [ ] tytuł czyta się jako pierwszy, bez ścisku ikon;
- [ ] rozwinięte podzadania są spokojną hierarchią, nie zbiorem mini-kart;
- [ ] prowadnice nie urywają się i nie mijają środka wiersza przy długich tytułach;
- [ ] brak overflow oraz mikrofontów w 125%;
- [ ] kliknięcie/toggle dziecka nie otwiera rodzica;
- [ ] żadna akcja DnD, scroll ani paginacja nie regresuje;
- [ ] nie zmieniono widoku listy Tasks.

W raporcie końcowym agent ma wskazać: zmienione pliki, testy, screenshoty, nierozwiązane kwestie oraz odnośnik do tego briefu. Stwierdzenie „dotted border jest gotowy” bez oglądu ekranu nie jest wystarczające.
