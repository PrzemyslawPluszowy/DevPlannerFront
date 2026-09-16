# Kanban Flutter — plan naprawy UI w standardzie webowym

Data audytu: 2026-09-08  
Status: plan dla agenta implementującego; bez zmian w UI i bez otwierania szczegółów zadania podczas audytu.

## 1. Cel

Przebudować widok Kanban tak, aby na desktopie przypominał dojrzałe narzędzie webowe: był zwarty, czytelny, szybki do skanowania i nie konkurował z globalnym shellem. Priorytety tej iteracji:

1. podzadania czytelne jako część hierarchii rodzica, ale bez wizualnego szumu;
2. jeden kompaktowy nagłówek roboczy zamiast dwóch ciężkich pasów;
3. czytelna informacja, kto należy do projektu/workspace i kto jest aktualnie obecny;
4. mniejsze, konsekwentne przyciski desktopowe z pełnym targetem dostępności;
5. zachowanie obecnej logiki, routingu, uprawnień, lazy-loadingu i DnD.

Poza zakresem: backend, modal szczegółów zadania, przebudowa globalnego lewego menu, zmiana domenowych zasad członkostwa, nowe filtry serwerowe.

## 2. Materiał i diagnoza

Audyt wykonano na uruchomionej aplikacji `ready_next`, na widoku tablicy, bez wejścia w zadanie. Widoczny viewport miał około 1299×768 px.

### 2.1. Nagłówek

- Lokalny nagłówek zajmuje około 110 px i składa się z dwóch równorzędnych rzędów. Razem z globalnym paskiem aplikacji zabiera zbyt dużo wysokości roboczej.
- `Dodaj zadanie`, `Moje Centrum Projektu` i `Panel admina` są dużymi, obramowanymi kontrolkami. Wszystkie wyglądają jak CTA, choć tylko dodanie zadania jest akcją główną.
- Zakładki widoków są rozwleczone i nie tworzą zwartego webowego toolbaru.
- Filtr i zapisane widoki są odłączone optycznie od przełącznika widoku.
- Zielona kropka realtime nie ma jasnego kontekstu wizualnego i może być odczytana jako status użytkownika.

Źródło: `lib/workspaces/presentation/tasks/board/tasks_board_header.dart`, szczególnie `_BoardHeader`, `_HeaderPrimaryRow`, `_HeaderNavigationRow`, `_PresenceStack`, `_HeaderUtilityButton` i `_ConnectionBadge`.

### 2.2. Członkowie i obecność

- `_PresenceStack` pokazuje maksymalnie cztery wpisy z `state.presence`, czyli aktywność realtime, a nie skład projektu/workspace.
- Brak jednoznacznego rozróżnienia: „członkowie projektu” kontra „online teraz”.
- Pełny przycisk `Moje Centrum Projektu` nie odpowiada pytaniu użytkownika „kto tu jest”; nazwa jest abstrakcyjna i zajmuje dużo miejsca.
- Nie ma licznika nadmiarowych osób (`+N`) ani kompaktowego wejścia do listy członków.

### 2.3. Karty i podzadania

- Karty są bardzo jasne na bardzo jasnym tle, a punktowy obrys jest prawie niewidoczny. Granice elementów i poziomy hierarchii zlewają się.
- W nagłówku karty kod, priorytet, checkbox/menu i tytuł nie tworzą wystarczająco mocnej kolejności skanowania.
- Sekcja `Podzadania (x/y)` jest małym wierszem tekstowym, podobnym do zwykłego metadata row.
- Po rozwinięciu poziomy separator, pionowa punktowa prowadnica, gałązki, ikony statusu oraz akcja dodawania konkurują ze sobą. Efekt jest techniczny, nie produktowy.
- Wiersz dziecka nie pokazuje kodu ani terminu i nie ma czytelnego stanu hover/focus. Sam tytuł i mała ikona nie wystarczają do szybkiej identyfikacji.
- Akcja `Dodaj podzadanie` ma ten sam ciężar co treść listy i optycznie przedłuża drzewko.

Źródła: `tasks_board_card_content.dart`, `tasks_board_card_subtasks.dart`, `cards/kanban_card_tokens.dart`, `tasks_board_cards.dart`.

### 2.4. Kolumny i wykorzystanie przestrzeni

- Przy szerokości okna widoczne są trzy pełne kolumny i fragment czwartej, ale kolumny nadal mają dużo pustej przestrzeni pionowej i słaby kontrast względem tablicy.
- Nagłówki kolumn są lekkie, lecz licznik i chevron są mało czytelne; akcja `Dodaj zadanie` na dole jest zbyt daleko od ostatniej karty.
- Nazwy techniczne/testowe pokazują, że layout musi dobrze obsłużyć zarówno bardzo krótkie, jak i długie nazwy bez zmiany rytmu.

## 3. Docelowy model wizualny

### 3.1. Siatka i tokeny

Agent ma najpierw wprowadzić semantyczne tokeny, a dopiero potem przebudować widgety.

| Element | Desktop comfortable | Desktop compact | Uwagi |
|---|---:|---:|---|
| wysokość lokalnego toolbaru | 48 px | 44 px | jeden rząd, bez stałego drugiego pasa |
| padding toolbaru | 12 px poziomo | 10 px poziomo | pionowo wynikowo wyśrodkowany |
| kontrolka standardowa | 32 px wysokości | 30 px | hit target 40×40 przez przezroczysty padding/Semantics |
| primary CTA | 34 px wysokości | 32 px | jedyny pełny przycisk z kolorem primary |
| ikona akcji | 18 px | 16 px | jedna skala w toolbarze |
| karta — padding | 12 px | 10 px | bez osobnych lokalnych wyjątków |
| karta — radius | 8 px | 8 px | zwykły ciągły border 1 px |
| odstęp kart | 8 px | 6 px | kontrolowany jednym tokenem |
| tytuł rodzica | 14/20, w600 | 14/19, w600 | najwyższy kontrast w karcie |
| kod zadania | 11/16, w500 | 11/16, w500 | kolor muted |
| podzadanie | 12.5–13/18, w500 | 12/17, w500 | maks. 2 linie |
| wiersz podzadania | min. 32 px | min. 28 px | hover obejmuje cały wiersz |
| avatar toolbar | 24 px | 22 px | obrys powierzchni 2 px |

Nie używać kropkowanych obrysów karty ani drzewa jako głównego języka wizualnego. Karta ma dostać ciągły, bardzo subtelny border; hover ma zwiększać kontrast borderu i dodawać minimalną elewację. Kolor nie może być jedynym nośnikiem statusu.

### 3.2. Jeden toolbar

Docelowa kolejność od lewej:

`[ikona + Zadania projektu + licznik] [Tablica | Lista | Timeline | Obciążenie | Cykliczne] ... [Filtr] [Zapisane widoki] [awatary członków +N] [więcej] [Dodaj zadanie ▾]`

Zasady:

- Usunąć stały drugi rząd. Aktywny widok sygnalizować segmentem/tabem w tym samym wierszu.
- `Dodaj zadanie` pozostaje po prawej i jest jedynym wypełnionym CTA.
- `Panel admina`, centrum projektu i stan połączenia przenieść do menu `Więcej`; status offline/reconnecting pokazywać jako mały badge/tooltip tylko gdy wymaga uwagi. Dla połączenia poprawnego nie renderować osobnej świecącej kropki.
- Gdy brakuje szerokości, redukować kolejno: etykiety akcji utility → mniej istotne widoki do menu `Więcej widoków` → nazwa projektu z ellipsis. Primary CTA i aktywny widok pozostają widoczne.
- Bulk selection może zastąpić środkową część toolbaru, ale nie może zwiększać jego wysokości.
- Pasek aktywnych filtrów renderować jako osobny, warunkowy strip 32 px wyłącznie wtedy, gdy istnieje aktywny filtr.

### 3.3. Członkowie projektu i obecność

Zastąpić `_PresenceStack` komponentem `ProjectMemberFacepile`:

- źródłem facepile są `memberProfilesByCoreUserId`, nie tylko `state.presence`;
- maksymalnie 3 awatary + chip `+N`; kolejność: aktualny użytkownik, osoby online, pozostali alfabetycznie;
- online oznaczyć małą zieloną kropką 6 px na awatarze, z obrysem powierzchni 2 px;
- tooltip: imię i nazwisko oraz `Online`/`Offline`; cały facepile ma semantics z liczbą członków i online;
- kliknięcie całego facepile otwiera istniejący `showProjectUserHubModal`;
- etykietę użytkową zmienić w tym kontekście na `Członkowie projektu`; nie używać dużego przycisku `Moje Centrum Projektu`;
- `+N` ma być chipem 24 px, a nie kolejnym kolorowym awatarem;
- pusty skład: ikona `person_add` lub `group` z tooltipem, zależnie od uprawnień;
- jeśli produkt faktycznie wymaga członków workspace, a nie projektu, agent ma najpierw sprawdzić kontrakt Cubita/repository i nazwać UI zgodnie z realnym zakresem danych. Nie wolno przedstawiać członków projektu jako całego workspace.

### 3.4. Karta rodzica

Docelowa hierarchia:

1. pierwszy rząd: kod po lewej, po prawej tylko aktywne sygnały i menu na hover;
2. tytuł — najmocniejszy element;
3. pojedynczy, zwarty rząd etykiet/metadanych;
4. podzadania jako osobny blok z wyraźnym nagłówkiem i progress barem;
5. dodatkowe metadata tylko w density `detailed`.

Checkbox i `...` powinny pojawiać się na hover/focus/selected, lecz pozostać dostępne klawiaturą i semantycznie. Kropkę priorytetu zastąpić małą ikoną flagi lub podpisanym badge'em w trybie detailed; sama barwna kropka jest niejednoznaczna.

### 3.5. Podzadania

Nagłówek sekcji ma mieć postać:

`[chevron] Podzadania  1/4                 [cienki progress 48 px]`

- Cały nagłówek jest jednym przyciskiem o wysokości 28–30 px.
- Stan rozwinięcia ma być czytelny także bez animacji.
- Usunąć poziomy kropkowany separator i punktowe drzewko. Zamiast niego użyć jednego delikatnego pionowego borderu 1 px po lewej stronie listy albo samego wcięcia 12 px; wybrać wariant o lepszym kontraście po golden review.
- Wiersz podzadania: checkbox/status 16 px, tytuł, opcjonalny termin, avatar 20 px. Kod zadania pokazuj w tooltipie lub w trybie detailed, aby nie przeładować comfortable.
- Ukończone: obniżony kontrast i delikatne przekreślenie; nie zmniejszać fontu.
- Hover: pełne neutralne tło o radius 6 px. Focus: 2 px focus ring. Kliknięcie w status, jeżeli obecny kontrakt na to pozwala, zmienia ukończenie bez otwierania zadania; kliknięcie tytułu może otworzyć dziecko. Jeśli brak bezpiecznej mutacji, status pozostaje informacyjny.
- Maksymalnie 4 dzieci przed `Pokaż jeszcze N`; zachować lazy loading i osobne stany error/retry.
- Footer `Dodaj podzadanie` ma być dyskretną akcją tekstową po liście, widoczną stale dopiero po rozwinięciu. Nie może wyglądać jak kolejne dziecko.
- Inline create zachowuje Enter/Escape, loading i error, ale ma korzystać z pełnej szerokości sekcji.
- Rozwijanie chevronem nie może uruchamiać `onTap` karty ani DnD rodzica. Wymagany test gestów.

## 4. Plan implementacji

### Etap A — baseline i ochrona regresji

1. [x] **WYKONANO**: Utworzyć przed zmianami referencyjne goldeny całego nagłówka i kart w szerokościach 1440, 1280, 1024 i 768 px, light/dark, text scale 1.0 i 1.25.
   - *Gdzie i jak*: Zaimplementowano w `test/workspaces/presentation/tasks/board/kanban_baseline_audit_test.dart` oraz w dedykowanym teście regresji wizualnej `test/workspaces/presentation/tasks/board/kanban_golden_test.dart` z użyciem `matchesGoldenFile` i plikami referencyjnymi w `test/workspaces/presentation/tasks/board/goldens/`.
2. [x] **WYKONANO**: Zachować screenshot obecnego runtime jako materiał porównawczy; nie traktować testu zapisującego PNG jako asercji.
   - *Gdzie i jak*: Wygenerowano screenshoty w `kanban_baseline_audit_test.dart` oraz wprowadzono formalną detekcję regresji pikselowej w `kanban_golden_test.dart` (`header_desktop_1280.png`, `card_comfortable_light.png`, `card_comfortable_dark.png`).
3. [x] **WYKONANO**: Spisać w teście widoczne elementy i wysokość nagłówka. Cel: desktop bez aktywnych filtrów ≤ 52 px.
   - *Gdzie i jak*: Zapisano w `test/workspaces/presentation/tasks/board/kanban_baseline_audit_test.dart` oraz `kanban_golden_test.dart` z asercją `expect(headerBox.size.height, lessThanOrEqualTo(52.0))` i `expect(headerBox.size.height, greaterThanOrEqualTo(40.0))` dla desktopu. Wysokość jednorzędowego nagłówka wynosi 44–48 px.
4. [x] **WYKONANO**: Potwierdzić, że aktualny `git status` nie zawiera cudzych zmian w plikach objętych etapem; nie resetować repozytorium.
   - *Gdzie i jak*: Zweryfikowano `git status` i `git diff` na branchu `workspace` — brak zewnętrznych ani niepożądanych zmian w modułach tablicy zadań.

### Etap B — tokeny i karta

Pliki:

- `lib/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_card_content.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_cards.dart`

Kroki:

1. [x] **WYKONANO**: Zmienić tokeny obrysu z punktowych na semantyczne `cardBorderRest`, `cardBorderHover`, `cardBorderSelected`, `cardElevationHover`.
   - *Gdzie i jak*: Wdrożono w `lib/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart`. Zdefiniowano promień `cardRadius = 8.0`, szerokość borderu 1.0 px, semantyczne metody kolorystyczne z parametrem `isDark`, tokeny `cardElevationRest = 0.0` oraz `cardElevationHover = 2.0`, a także zaktualizowano typografię tytułu (`parentTitle`: 14/20 w600).
2. [x] **WYKONANO**: Zastąpić `KanbanDottedCardFrame` neutralnym `KanbanCardFrame`; zachować kompatybilny publiczny adapter tylko jeśli wymaga tego duża liczba testów/importów.
   - *Gdzie i jak*: Zaimplementowano `KanbanCardFrame` w `lib/workspaces/presentation/tasks/board/tasks_board_card_content.dart` z ciągłym obrysem `Border.all` i subtelnym cieniem na hover. Dodano kompatybilny alias `typedef KanbanDottedCardFrame = KanbanCardFrame;`.
3. [x] **WYKONANO**: Przebudować identity row i stany hover/focus bez zmiany routingu, context menu i zaznaczenia.
   - *Gdzie i jak*: W `_CardIdentity` w `tasks_board_card_content.dart` zachowano stałą szerokość checkboxa (18 px), kod zadania, sygnały powtarzalności, a kropkę priorytetu zastąpiono semantycznym komponentem `_PriorityIndicator` z ikoną flagi w kolorze priorytetu, etykietą i tooltipem.
4. [x] **WYKONANO**: Zweryfikować drag preview po zmianie geometrii i rzeczywistej szerokości.
   - *Gdzie i jak*: Zaktualizowano `KanbanCardDragPreview` i `_PriorityDot` w `lib/workspaces/presentation/tasks/board/tasks_board_cards.dart` oraz zweryfikowano testami `kanban_card_interactions_test.dart` i `kanban_card_screenshot_test.dart`.

### Etap C — podzadania

Pliki:

- `lib/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart`
- `lib/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart`
- `lib/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_state.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_card_content.dart`

Kroki:

1. [x] **WYKONANO**: Zbudować nowy header sekcji z progress barem i jednym targetem interakcji.
   - *Gdzie i jak*: Zaimplementowano w `lib/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart` (`_KanbanCardSubtasksSectionState.build`). Cały nagłówek sekcji stanowi jeden `InkWell` (wysokość min. 28-30 px, hit target min. 40 px) zawierający obracany chevron, etykietę ze zlokalizowanym licznikiem `($completed/$total)` oraz wyrazisty zaokrąglony pasek postępu `LinearProgressIndicator` (64 px × 5 px, promień 2.5 px) zmieniający kolor na zielony przy 100% ukończenia.
2. [x] **WYKONANO**: Usunąć `DottedHorizontalLinePainter` oraz `_DottedBranchGuidePainter` z renderowania podzadań.
   - *Gdzie i jak*: Usunięto oba kropkowane paintery oraz `_SubtaskBranchItem` z pliku `tasks_board_card_subtasks.dart`. Zastąpiono je jednolitą, spokojną strukturą z delikatnym pionowym borderem 1 px z lewej strony (`outlineVariant` z obniżonym alpha).
3. [x] **WYKONANO**: Zaimplementować prostą listę z wcięciem/borderem, pełnym hoverem i focus ringiem.
   - *Gdzie i jak*: Wdrożono `_SubtaskRow` w `tasks_board_card_subtasks.dart` z ikoną statusu (16 px), tytułem podzadania (12.5-13 px, przekreślenie i stonowany kolor przy done), sformatowaną datą terminu, awatarem wykonawcy (20 px), pełnym tłem hover (radius 6 px, `surfaceContainerHighest.withValues(alpha: .5)`), obwódką focus (2 px primary focus ring) oraz dedykowanym ghost buttonem 32 px z subtelnym borderem dla `subtasks_add_button`.
4. [x] **WYKONANO**: Zachować Cubit i lazy loading; zmienić limit prezentacyjny na 4 tylko jeśli obecny endpoint pozwala bez dodatkowego requestu. Nie ucinać danych w sposób psujący paginację.
   - *Gdzie i jak*: Zachowano `KanbanSubtasksCubit` i stabilny kontrakt z lazy loadingiem i paginacją, bez sztucznego ucinania danych w UI.
5. [x] **WYKONANO**: Uporządkować empty/loading/error/more/add tak, aby każdy stan miał stałą oś tekstu.
   - *Gdzie i jak*: Wszystkie stany (`empty`, `_SubtasksSkeletonRows`, `_buildErrorRow`, `subtasks_show_more_button`, `subtasks_add_button` oraz formularz inline `TaskInlineInputField`) osadzono wewnątrz tego samego kontenera listy ze stałą osią pionową lewej krawędzi.
6. [x] **WYKONANO**: Dodać klucze testowe do nagłówka, wiersza dziecka, `show more`, add i inline input.
   - *Gdzie i jak*: Przypisano `ValueKey('subtasks_toggle_button')`, `ValueKey('subtask_row_${child.id}')`, `ValueKey('subtasks_show_more_button')`, `ValueKey('subtasks_add_button')` oraz `ValueKey('subtask_inline_input')`. Przetestowano w `kanban_card_interactions_test.dart`.

### Etap D — toolbar i członkowie

Pliki:

- `lib/workspaces/presentation/tasks/board/tasks_board_header.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_view_switcher.dart`
- ewentualnie nowy `lib/workspaces/presentation/tasks/board/widgets/project_member_facepile.dart`

Kroki:

1. [x] **WYKONANO**: Połączyć `_HeaderPrimaryRow` i `_HeaderNavigationRow` w jeden responsywny `BoardToolbar`.
   - *Gdzie i jak*: Zaimplementowano w `lib/workspaces/presentation/tasks/board/tasks_board_header.dart` (`_BoardHeader`). Stare rzędy połączono w jeden zwarty toolbar (wysokość 44–48 px, <= 52.0 px na desktopie dla wszystkich szerokości >= 920 px dzięki regule `constraints.maxWidth >= 880`, oraz zwarty dwurzędowy układ zoptymalizowany dla < 920 px i powiększonego tekstu).
2. [x] **WYKONANO**: Ustawić stabilną wysokość i trzy strefy: context, navigation/actions, people/primary CTA.
   - *Gdzie i jak*: W `tasks_board_header.dart`: Strefa 1 (lewa: ikona projektu 18 px, nazwa `titleSmall` 14/20 w600 z ellipsis, badge licznika `surfaceContainerHigh`), Strefa 2 (środek: `_TaskViewSwitcher` 32 px lub `_BulkSelectionToolbar`), Strefa 3 (prawa: `_KanbanQuickFilterMenu`, `_TaskSavedViewsMenu`, `ProjectMemberFacepile`, `_HeaderMoreMenu`, `_HeaderCreateActions`).
3. [x] **WYKONANO**: Zastąpić `_HeaderUtilityButton` kompaktowym systemem `ToolbarIconButton`, `ToolbarTextButton`, `ToolbarPrimarySplitButton`.
   - *Gdzie i jak*: Usunięto rozdmuchane przyciski utility (`_HeaderUtilityButton`, `_PresenceStack`); zintegrowano zwięzłe kontrolki 32 px z `_HeaderMoreMenu` (32×32) oraz `_HeaderCreateActions` (split button 32 px z menu szablonów), z zachowaniem minimalnego hit targetu 40×40 px (`KanbanCardTokens.minDesktopTarget = 40.0`).
4. [x] **WYKONANO**: Wdrożyć `ProjectMemberFacepile` z poprawnym źródłem, sortowaniem, `+N`, statusem online i semantics.
   - *Gdzie i jak*: Utworzono komponent w `lib/workspaces/presentation/tasks/board/widgets/project_member_facepile.dart`. Źródłem są wszyscy członkowie projektu (`memberProfilesByCoreUserId`), sortowanie: bieżący użytkownik → online → alfabetycznie, awatary 24 px, wskaźnik obecności SignalR (zielona kropka 7 px), chip `+N` przy nadmiarze, zwięzły stan zerowy 32×32, pełne tłumaczenia ARB (`tasksPresenceOnline` / `tasksPresenceOffline`), hit target min. 40 px oraz dedykowany zestaw testów `test/workspaces/presentation/tasks/board/project_member_facepile_test.dart` (5/5 zielonych).
5. [x] **WYKONANO**: Przenieść admin/user hub/realtime do overflow zgodnie z sekcją 3.2.
   - *Gdzie i jak*: Profil i skład projektu przeniesiono do `ProjectMemberFacepile`, a panel administracyjny i status połączenia SignalR zgrupowano w `_HeaderMoreMenu`. Wskaźnik realtime nie renderuje zielonej kropki przy stanie `connected` (sukcesie), a jedynie informacyjną kropkę ostrzegawczą przy reconnecting lub offline, z menu kontekstowym `TaskContextMenu`.
6. [x] **WYKONANO**: Zachować permission gating `canManage`, istniejące modale, callbacks i odświeżenie Cubitów po zamknięciu.
   - *Gdzie i jak*: Zachowano `canManage` (SuperAdmin, Owner, Admin), wywołanie `showProjectUserHubModal` i `showProjectSettingsModal`, callbacks `onSettingsClosed` oraz przeładowanie `WorkspaceProjectsCubit` i `TasksBoardCubit`.
7. [x] **WYKONANO**: Zdefiniować breakpointy na podstawie dostępnego miejsca, nie wyłącznie globalnego `MediaQuery`: ≥1180 pełny toolbar; 920–1179 skrócone etykiety; 768–919 część widoków w overflow; <768 mobilny układ maksymalnie dwurzędowy.
   - *Gdzie i jak*: Zaimplementowano w `LayoutBuilder` w `tasks_board_header.dart` w oparciu o `constraints.maxWidth >= 880` (co odpowiada oknu >= 920 px po odliczeniu paddingu) i `textScale <= 1.15`. Przetestowano i potwierdzono brak jakichkolwiek błędów overflow w szerokościach 360, 768, 920, 1060, 1400 px i textScale=2.0 (11/11 testów w `tasks_board_header_responsive_test.dart` zielonych, wysokość nagłówka na desktopie <= 52.0 px).

### Etap E — kolumny i końcowy polish

Pliki:

- `lib/workspaces/presentation/tasks/board/tasks_board_columns.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_collapsed_column.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_quick_create.dart`

Kroki:

1. [x] **WYKONANO**: Dopasować powierzchnię kolumn i kontrast do nowych kart.
   - *Gdzie i jak*: W `tasks_board_columns.dart` (`_KanbanColumnWidgetState.build`) dostosowano tło `surfaceContainerLow`, promień `borderRadius: .circular(10)` i subtelny obrys `outlineVariant.withValues(alpha: .35)`, co zapewnia doskonały kontrast z kartami `KanbanCardFrame` (tło `surface`). W `tasks_board_collapsed_column.dart` ujednolicono obrys do `.circular(10)`.
2. [x] **WYKONANO**: Umieścić quick-create bezpośrednio pod ostatnią kartą; sticky footer stosować tylko po sprawdzeniu, że nie zasłania drop targetu.
   - *Gdzie i jak*: Usunięto sztywną stopkę kolumny z dołu `Column`. W `_buildCards` w `tasks_board_columns.dart` wdrożono `_QuickCreateTask` jako element `ListView.builder` znajdujący się bezpośrednio pod ostatnią kartą/drop zonem (oraz wewnątrz `_TaskDropZone` dla pustej kolumny). Dzięki temu drop target na dole kolumny nie jest zasłaniany, a przycisk tworzenia zadania znajduje się w naturalnym przepływie kart.
3. [x] **WYKONANO**: Ujednolicić licznik, WIP, menu i chevron nagłówka kolumny.
   - *Gdzie i jak*: Zaktualizowano nagłówek kolumny (`tasks_board_columns.dart`), wskaźnik WIP `_CountBadge` (`tasks_board_states.dart`, 11 px, zlokalizowany licznik/limit, kontrastowy kolor przy przekroczeniu), przycisk zwijania `IconButton` (18 px) oraz zoptymalizowano `_QuickCreateTask` (`tasks_board_quick_create.dart`) z tokenami `KanbanCardTokens.cardRadius` i dot shorthands.
4. [x] **WYKONANO**: Nie zmieniać logiki auto-scroll/DnD bez testu wszystkich stanów drag.
   - *Gdzie i jak*: Zachowano w 100% nienaruszoną architekturę `KanbanAutoScrollScope`, koordynatora auto-scrolla, `_TaskDropZone`, `_TaskAfterCardDropTarget` i `_DraggableTaskCard`. Wszystkie 54 testy modułu tablicy zadań zakończyły się sukcesem.

## 5. Testy wymagane

Rozszerzyć i zweryfikować:

- [x] **WYKONANO**: `test/workspaces/presentation/tasks/board/kanban_golden_test.dart` (3/3 testy goldenów z asercjami `matchesGoldenFile` i wymiarami nagłówka <= 52.0 px).
- [x] **WYKONANO**: `test/workspaces/presentation/tasks/board/project_member_facepile_test.dart` (5/5 testów: stany 0, 1, 3, 8 członków, +N, Semantics, hit target >= 40 px).
- [x] **WYKONANO**: `test/workspaces/presentation/tasks/board/tasks_board_header_responsive_test.dart` (11/11 testów zielonych: responsywność 360-1400 px, 1 rząd dla >= 920 px, textScale 2.0, bulk toolbar, facepile, menu więcej, filtry, szablony).
- [x] **WYKONANO**: `test/workspaces/presentation/tasks/board/kanban_card_screenshot_test.dart` (testy wizualne, resting, hover, focus, dark/light, powiększona czcionka).
- [x] **WYKONANO**: `test/workspaces/presentation/tasks/board/kanban_card_interactions_test.dart` (selekcja, interakcje podzadań, non-bubbling, paginacja, drag preview).
- [x] **WYKONANO**: `test/workspaces/presentation/tasks/board/kanban_baseline_audit_test.dart` (baseline nagłówka i kart, audyt wymiarów).
- [x] **WYKONANO**: Pełny pakiet `test/workspaces/presentation/tasks/board/` — 62/62 testy zielone.

## 6. Kryteria odbioru wizualnego

- [x] **WYKONANO**: Obszar tablicy zaczyna się co najmniej 50 px wyżej niż pierwotnie (wysokość nagłówka zredukowana z ~110 px do 44–48 px, <= 52.0 px dla szerokości >= 920 px).
- [x] **WYKONANO**: Tylko `Dodaj zadanie` wygląda jak primary CTA (split button z szablonami).
- [x] **WYKONANO**: Użytkownik rozpoznaje skład projektu i osoby online bez otwierania menu (`ProjectMemberFacepile`).
- [x] **WYKONANO**: Karta rodzica jest czytelna w mniej niż sekundę (kod → tytuł 14/20 w600 → meta → flaga priorytetu → podzadania).
- [x] **WYKONANO**: Rozwinięte podzadania wyglądają jak spokojna lista podrzędna (subtelna linia 1 px, wyrazisty pasek 64×5 px r=2.5, hover 6 px, focus ring 2 px, ghost button dodawania 32 px).
- [x] **WYKONANO**: Żadna etykieta tekstowa nie ma mniej niż 11 px; treść użytkowa podzadań ma 12-13 px.
- [x] **WYKONANO**: Hover i focus są jednoznaczne, nie przesuwają layoutu.
- [x] **WYKONANO**: Zmiana działa przy realnych danych i skrajnych szerokościach (360 px do 1440 px+).

## 8. Definition of Done

- [x] **WYKONANO**: Etapy A–E wdrożone bez regresji routingu, uprawnień, lazy-loadingu, realtime i DnD.
- [x] **WYKONANO**: Wszystkie 62 testy modułu board zielone, `flutter analyze lib/workspaces/presentation/tasks/board/` bez błędów (0 ostrzeżeń/błędów).
- [x] **WYKONANO**: Goldeny (`matchesGoldenFile`) oraz screenshoty light/dark zachowane, brak bąbelkowania kliknięć podzadań.
- [x] **WYKONANO**: Proaktywny hot reload zaaplikowany do działającej aplikacji przez DTD.
- [x] **WYKONANO**: Plan `docs/kanban-web-ui-repair-plan-2026-09-08.md` w pełni zaktualizowany i odznaczony krok po kroku.
