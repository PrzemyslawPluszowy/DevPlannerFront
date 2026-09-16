# Raport code review — Tasks: lista, ustawienia i menu
Data: 2026-09-06. Repozytorium ready_next, branch workspace.

## Wniosek

Największy zysk da naprawa spójności stanu widoku, sortowania i zapisu ustawień, następnie uporządkowanie tabeli oraz wspólne zachowanie popupów. Samo odświeżenie kolorów nie rozwiąże problemów przewidywalności.

Potwierdziłem w kodzie mechanizm, przez który „Workflow projektu” i „Według statusu” mogą pokazywać te same grupy. Są również jednoznaczne błędy mapowania rozmiaru, kolejności i pozycjonowania edytora czasu. Obecna baza ma wartościowe elementy: paginację grup, aktualizacje pojedynczych wierszy, wspólne menu i lazy loading ustawień. Nie rekomenduję przepisywania całej zakładki.

## Zakres i wiarygodność

- Review kodu listy, konfiguracji kolumn, zapisanych widoków, pickerów komórek, menu, ustawień projektu i używanych komponentów wspólnych.
- Podgląd działającego macOS Debug: lista, konfigurator kolumn, panel administratora, workflow, modal dodawania statusu. Bez zapisów i zmian danych.
- Pozostałe rodziny dialogów ocenione na podstawie implementacji; nie wszystkie zostały przeklikane. To nie jest pełna akceptacja wizualna wszystkich modali.
- Nie oceniałem modalu szczegółów zadania ani wyglądu Kanbana. Kod strony board analizowałem wyłącznie jako właściciela listy i ustawień.
- Nie wykonano profilowania Web/Wasm, pomiarów FPS, testów dark mode ani pełnego audytu dostępności. Ryzyka wydajnościowe poniżej wynikają z kodu, nie z pomiarów.
- 146 istniejących testów przeszło: tasks/list, tasks/settings oraz project_settings_and_user_hub_modals_test.dart.
- flutter analyze dla listy, ustawień zadań/projektu i widgets: No issues found.
- Pamięć Qdrant była dostępna. Starsze ustalenia ponownie zweryfikowano; część wcześniejszych problemów już naprawiono.
- Kod aplikacji pozostawiony bez zmian. Ten dokument jest raportem, nie wdrożeniem poprawek.

## Błędy i problemy według priorytetu

### P1 — Przełącznik workflow i lista mają różne źródła prawdy

Źródła: [tasks_board_page.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/board/tasks_board_page.dart:410), [project_tasks_list.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/project_tasks_list.dart:117).

Rodzic wylicza groupBy z zapisanego widoku / _manualGroupBy / domyślnego workflow. Przełącznik zmienia wyłącznie _manualGroupBy i przez ValueKey tworzy nową listę. Ta lista równolegle ładuje zadania i efektywną konfigurację. Listener preferencji nadpisuje grupowanie Cubita wartością z konfiguracji. Renderowanie tabeli również preferuje prefReady.groupBy, ale zaznaczenie przełącznika nadal pochodzi od rodzica.

Odtworzenie: projekt z własnym workflow, zapisane preferencje groupBy=Status; wybór Workflow projektu. Początkowe żądanie może być CustomStatus, następnie konfiguracja wymusi Status. Nagłówek nadal sugeruje Workflow. Przy odwrotnych preferencjach problem działa w drugą stronę.

Naprawa: jeden właściciel efektywnego widoku, jawny porządek pierwszeństwa zapisany widok → osobiste nadpisania → domyślne projektu. Przełącznik, query i tabela muszą odczytywać dokładnie tę samą wartość. Nie odtwarzać całego Cubita przy zmianie grupowania. Test integrujący rodzica, konfigurację i opóźnione odpowiedzi API.

To są różne pojęcia: workflow to konkretne etapy projektu (np. Development, Code Review, QA), status systemowy to wspólna klasyfikacja. W oglądanym projekcie własne etapy istnieją, więc identyczność obu widoków nie wynika z braku własnego workflow. Nie przeprowadzałem mutacji danych ani testu sieciowego tego scenariusza.

> **[WYKONANO]**
> - **Rozwiązanie:** Przeniesiono `TaskListWorkflowSegmentedSwitch` bezpośrednio do `_ProjectTasksListView` (w `lib/workspaces/presentation/tasks/list/project_tasks_list.dart`), dzięki czemu przełącznik współdzieli dokładnie to samo źródło prawdy z preferencjami (`effectiveGroupBy`). Wybór trybu wywołuje spójnie `preferencesCubit.setGroupBy(selected)` oraz `cubit.updateGroupBy(selected)`.
> - **Architektura:** W `tasks_board_page.dart` usunięto lokalny stan `_manualGroupBy`, a komponent `_TasksListContent` zredukowano do `StatelessWidget`. Usunięto parametr `groupBy` z `ValueKey`, eliminując destrukcję i niepotrzebną re-inicjalizację Cubitów przy przełączaniu widoku.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/project_tasks_list.dart`
>   - `lib/workspaces/presentation/tasks/board/tasks_board_page.dart`
> - **Weryfikacja:** Wszystkie testy integracyjne widoku i listy przechodzą pomyślnie (`flutter test test/workspaces/presentation/tasks/list/`).

### P1 — Sortowanie „pozycja” niszczy kolejność ręczną

Źródło: [task_list_table_builder.part.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/table/task_list_table_builder.part.dart:43).

Renderer ponownie sortuje group.items. Dla TaskSavedViewSortField.position używa a.number, a nie pozycji. Także końcowy fallback sortuje po numerze. Poprawna kolejność z backendu lub lokalnego moveTask zostaje zastąpiona numeracją.

Skutek: przeciągnięcie zadania może zostać zapisane, ale po przebudowie wiersz wygląda jakby wrócił na poprzednie miejsce. To narusza podstawową obietnicę D&D.

Naprawa: zachować kolejność kanonicznego snapshotu dla ręcznego sortowania; jeżeli potrzebna jest pozycja transportowa, zweryfikować kontrakt przed jej dodaniem. Zdefiniować osobno przypięcie oraz możliwość D&D przy aktywnym sortowaniu. Test: przenieść nowsze zadanie przed starsze, następnie zaznaczyć wiersz i odświeżyć.

> **[WYKONANO]**
> - **Rozwiązanie:** W `task_list_table_builder.part.dart` usunięto wtórne sortowanie po numerze (`number`) przy sortowaniu po pozycji (`TaskSavedViewSortField.position`). Lista zachowuje teraz kanoniczną kolejność z backendu oraz operacji D&D (przeciągania), z jednoczesnym prawidłowym wyniesieniem przypiętych zadań (`isPinned`) na samą górę.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/table/task_list_table_builder.part.dart`
> - **Weryfikacja:** Test `task_list_table_test.dart` potwierdza nienaruszoną kolejność pozycji przy przeciąganiu i renderowaniu.

### P1 — Zmiana sortowania przeładowuje dane przed zakończeniem zapisu

Źródła: [task_list_preferences_cubit.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart:147), [project_tasks_list.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/project_tasks_list.dart:130), [task_list_query.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/cubit/task_list_query.dart:69).

setSort/cycleSort emituje nowe sortowanie przed await zapisu. Listener od razu wywołuje load(). Query grup nie przekazuje sortField/sortDirection. Lokalny renderer sortuje tylko pobrane elementy.

W efekcie klient nie gwarantuje, że strony pobrano według nowego sortowania. Jeśli serwer odczytuje preferencje, istnieje wyścig odczytu i zapisu; jeżeli ich nie uwzględnia, pozostaje lokalne sortowanie części wyniku. Wymaga to również weryfikacji po stronie backendu.

Naprawa: jawny sort w kontrakcie zapytań albo przeładowanie dopiero po potwierdzonym zapisie właściwej rewizji. Cursor musi odpowiadać identycznym filtrom i sortowaniu. Test na minimum dwóch stronach, z opóźnionym zapisem i zadaniem o najwyższym priorytecie na dalszej stronie.

> **[WYKONANO]**
> - **Rozwiązanie:** W `TaskListPreferencesCubit` (w `lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart`) wprowadzono dedykowaną metodę `_saveSortExplicitly(...)`. Nowy stan `sortField` i `sortDirection` jest emitowany do listenerów dopiero **po** potwierdzeniu zapisu w repozytorium backendu i zaktualizowaniu wersji (`saved.version`).
> - **Skutek:** Wyeliminowano race condition — `ProjectTasksListCubit.load()` wywołany przez listener preferencji odpytuje serwer dopiero w momencie, gdy backend posiada już zapisaną nową konfigurację sortowania.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart`
> - **Weryfikacja:** Testy jednostkowe `task_list_preferences_cubit_test.dart` przechodzą pomyślnie.

### P2 — „Bez grupowania” nadal znaczy grupowanie po statusie

Źródło: [project_tasks_list_cubit.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart:53).

updateGroupBy oraz inicjalizacja listy zamieniają none na status. Tymczasem model zapisanych widoków udostępnia none. Wybranie tej opcji nie realizuje jej znaczenia.

Naprawa: rzeczywista płaska lista bez nagłówków grup lub usunięcie nieobsługiwanej opcji do czasu implementacji. Test zapisanego widoku none oraz przejścia status → none.

> **[WYKONANO]**
> - **Rozwiązanie:** Usunięto wymuszone mapowanie `TaskListGroupBy.none` na `status` w `project_tasks_list_cubit.dart` i `project_tasks_list.dart`.
> - **Implementacja:** W `task_list_table_builder.part.dart` zaimplementowano pełną obsługę płaskiej tabeli (`isFlat` / `TaskListGroupBy.none`): nagłówek kolumn renderowany jest tylko raz na samej górze widoku, a wszystkie wiersze zadań wyświetlane są w jednej jednolitej liście bez sztucznych nagłówków grup statusowych.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart`
>   - `lib/workspaces/presentation/tasks/list/project_tasks_list.dart`
>   - `lib/workspaces/presentation/tasks/list/table/task_list_table_builder.part.dart`
> - **Weryfikacja:** Testy `task_list_table_test.dart` i `project_tasks_list_cubit_test.dart` weryfikują działanie płaskiej listy bez nagłówków grup.

### P2 — XL zapisuje się jako L

Źródło: [task_size_picker.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/menu/pickers/task_size_picker.dart:9).

Enum XL ma value=5, ale fromValue(5) zwraca L; XL rozpoznawany jest dopiero dla 21. Picker i komórka prezentują tę samą wartość inaczej.

Naprawa: jedna jednoznaczna skala zgodna z backendem. Historycznych skal 1–5 i Fibonacci nie mieszać heurystycznie. Test round-trip każdej opcji: decode(encode(size)) == size.

> **[WYKONANO]**
> - **Rozwiązanie:** W `TaskTShirtSize` w `task_size_picker.dart` poprawiono factory `fromValue`: wartość 5 jednoznacznie mapuje się na `TaskTShirtSize.xl` (`5 || 21 => xl`), natomiast `TaskTShirtSize.l` odpowiada `4 || 13`.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/menu/pickers/task_size_picker.dart`
> - **Weryfikacja:** Test round-trip `task_size_picker_test.dart` weryfikuje pełną odwracalność kodowania i dekodowania wszystkich rozmiarów (XS, S, M, L, XL).

### P2 — Edytor czasu może wyjść poza ekran

Źródło: [task_duration_picker.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/menu/pickers/task_duration_picker.dart:95).

Własny showDialog buduje Stack i Positioned(left: position.left, top: position.top) z panelem szerokości 270. Brakuje korekty przy prawej/dolnej krawędzi i dopasowania wysokości do viewportu.

Skutek: edycja estymaty w końcowej kolumnie lub ostatnim wierszu może ukryć pola i przyciski poza oknem. Jest to deterministyczne ryzyko geometrii z kodu; scenariusza granicznego nie odtworzono w działającej wersji.

Naprawa: użyć istniejącego mechanizmu zakotwiczania z obsługą granic, tak jak kalendarz i cykliczność. Test narożników, scrolla i zmiany rozmiaru okna.

> **[WYKONANO]**
> - **Rozwiązanie:** Zaimplementowano dynamiczną korektę pozycji względem granic ekranu w `TaskDurationPickerDialog.show`: odczytywany jest rozmiar viewportu (`MediaQuery.sizeOf`), a współrzędne `left` i `top` są automatycznie korygowane, jeśli okno (o szerokości 280 px i wysokości ok. 340 px) wychodziłoby poza prawą lub dolną krawędź ekranu. Dodano margines ochronny (8 px) oraz `SingleChildScrollView` zapobiegający overflow na małych ekranach.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/menu/pickers/task_duration_picker.dart`
> - **Weryfikacja:** Test jednostkowy `task_duration_picker_test.dart` weryfikuje poprawne pozycjonowanie w narożnikach i zapobieganie wyjściu poza viewport.

### P2 — Ustawienia osobiste i domyślne projektu współdzielą edytowany stan

Źródła: [task_list_columns_sheet.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart:329), [task_list_preferences_cubit.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart:70).

Obie zakładki korzystają z effectiveVisibleColumns tego samego Cubita. Dodawanie/reorder nadal uruchamia osobisty autosave także w zakładce projektu. Dopiero osobny przycisk kopiuje konfigurację do polityki projektu.

Skutek: administrator pracujący nad domyślnym projektem zmienia jednocześnie swój widok, nawet jeśli nie zapisze zmian dla projektu. Etykieta zakresu nie odpowiada rzeczywistej semantyce.

Naprawa: osobny draft polityki z Zapisz/Anuluj i podglądem wpływu; osobisty układ może pozostać autosave. Test anulowania zmian projektu i braku updateUserPreference w tej zakładce.

> **[WYKONANO]**
> - **Rozwiązanie:** W `TaskListPreferencesState` oraz `TaskListPreferencesCubit` wprowadzono całkowicie odizolowany bufor `projectDefaultColumnsDraft` oraz metody operujące na drafcie: `initProjectDefaultColumnsDraft`, `addDraftProjectColumn`, `removeDraftProjectColumn`, `reorderDraftProjectColumns` i `saveDraftProjectDefaults`.
> - **Izolacja:** W `TaskListColumnsSheet` zakładka projektu edytuje wyłącznie draft i nie wywołuje osobistego autosave (`updateUserPreference`). Administrator może swobodnie konfigurować kolumny projektu, a zmiany wchodzą w życie dopiero po jawnym kliknięciu „Zapisz jako domyślne dla projektu”.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_state.dart`
>   - `lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart`
>   - `lib/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart`
> - **Weryfikacja:** Test `task_list_preferences_cubit_test.dart` potwierdza brak zmian w preferencjach osobistych podczas modyfikacji draftu projektu.

### P2 — Błąd preferencji udaje niekończące się ładowanie

Źródło: [task_list_columns_sheet.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart:122).

Każdy stan inny niż Ready renderuje spinner, także TaskListPreferencesError. saveError i isSaving z osobistego autosave nie mają tutaj osobnej prezentacji. Cubit dodatkowo po konflikcie 409 wykonuje load(), co może zastąpić lokalną zmianę bez wyjaśnienia.

Naprawa: wyczerpujący switch stanów; błąd z Ponów; przy stopce „Zapisywanie / Zapisano / Nie zapisano”. Po konflikcie zachować draft lub jawnie poinformować o odświeżeniu wersji.

> **[WYKONANO]**
> - **Rozwiązanie:** W `TaskListColumnsSheet` wprowadzono wyczerpujący pattern matching `switch (state)` dla wszystkich stanów `TaskListPreferencesState`.
> - **Obsługa błędów i wskaźniki zapisu:** W stanie `TaskListPreferencesError` prezentowany jest czytelny banner z komunikatem błędu oraz przyciskiem akcji „Spróbuj ponownie” (`cubit.load()`). Dodatkowo w stopce prezentowany jest wskaźnik stanu zapisu: spinner i etykieta „Zapisywanie...” podczas trwającego requestu, informacja o błędzie zapisu lub komunikacie konfliktu wersji (HTTP 409) z zachowaniem integralności draftu.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart`
>   - `lib/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart`
> - **Weryfikacja:** Test `task_list_columns_sheet_test.dart` weryfikuje poprawne wyświetlanie błędu i przycisku ponowienia.

### P2 — Zwykłe zamknięcie ustawień resetuje listę

Źródła: [tasks_board_header.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/board/tasks_board_header.dart:333), [tasks_board_page.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/board/tasks_board_page.dart:420).

Po każdym zamknięciu ustawień, także Escape bez zmian, wykonywane jest ładowanie projektów i boarda oraz zwiększenie settingsRevision. Rewizja w kluczu listy usuwa jej Cubity i stan tabeli.

Skutek: niepotrzebne żądania, utrata zaznaczeń, rozwinięć, pozycji scrolla i lokalnych filtrów. To szczególnie kosztowne dla dużej listy.

Naprawa: typowany wynik dialogu określający zmienione domeny. Bez zmian = zero reloadów. Etykiety odświeżają etykiety, workflow grupy; nie resetować całej listy dla wszystkich zmian.

> **[WYKONANO]**
> - **Rozwiązanie:** Wprowadzono typowany obiekt wyniku dialogu `ProjectSettingsResult` z zestawem zmodyfikowanych zakładek `Set<ProjectSettingsTab> mutatedTabs`. Modal nasłuchuje zdarzeń mutacji ze wszystkich pod-cubitów (Workflow, Etykiety, Pola własne, Kamienie milowe, Automatyzacje, Członkowie, Szablony).
> - **Optymalizacja przeładowań:** Zarówno zamknięcie krzyżykiem, jak i klawiszem Escape przekazuje `ProjectSettingsResult`. W `tasks_board_header.dart` reload projektu, odświeżenie boarda oraz wywołanie `onSettingsClosed` są wykonywane **wyłącznie wtedy**, gdy `result != null && result.hasChanges == true`. Zwykłe zamknięcie bez modyfikacji nie wysyła żadnych zapytań sieciowych ani nie resetuje stanu listy zadań.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/projects/settings/project_settings_modal.dart`
>   - `lib/workspaces/presentation/tasks/board/tasks_board_header.dart`
> - **Weryfikacja:** Testy `project_settings_and_user_hub_modals_test.dart` przechodzą pomyślnie.

### P2 — Błędy metadanych znikają jako puste dane

Źródło: [task_list_table.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/list/table/task_list_table.dart:128).

Błędy pól własnych i kamieni milowych są foldowane do pustych list. FutureBuilder także domyślnie pokazuje puste dane. Użytkownik nie odróżni braku definicji od awarii API.

Naprawa: osobny stan metadanych z błędem i możliwością ponowienia; zachować ostatnie poprawne definicje z jawną informacją o nieaktualności.

> **[WYKONANO]**
> - **Rozwiązanie:** Wprowadzono model `TaskListMetadataResult` w `lib/workspaces/presentation/tasks/list/table/task_list_table.dart`, który rejestruje stan pobierania oraz ewentualne komunikaty błędów z repozytorium pól własnych i kamieni milowych.
> - **UI:** W `task_list_table_view.part.dart` dodano widoczny banner informacyjny renderowany ponad tabelą w przypadku wystąpienia błędu metadanych, informujący użytkownika o problemie wraz z przyciskiem „Ponów próbę”, który odświeża `Future<TaskListMetadataResult>` bez utraty dotychczas załadowanych zadań.
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/list/table/task_list_table.dart`
>   - `lib/workspaces/presentation/tasks/list/table/task_list_table_view.part.dart`
> - **Weryfikacja:** Test `task_list_table_test.dart` potwierdza prawidłowe propagowanie i prezentację błędów metadanych.

### P2 — Przełącznik workflow nie ma pełnej obsługi klawiatury

Źródło: [task_list_workflow_segmented_switch.dart](/Users/przemyslawnowak/Desktop/dev/Excellent dev/Excellent/ready_next/lib/workspaces/presentation/tasks/widgets/task_list_workflow_segmented_switch.dart:104).

MouseRegion + GestureDetector + AnimatedContainer nie zapewniają natywnego focusa, aktywacji Enter/Space ani jawnej semantyki selected. Kontrolka ma wysokość 28, tekst 11. W odczycie dostępności etykiety występują jako tekst.

Naprawa: standardowy segment lub wspólna kontrolka z Focus, Actions i Semantics. Gęstość wizualna może pozostać kompaktowa, ale nie kosztem klawiatury.

> **[WYKONANO]**
> - **Rozwiązanie:** Zastąpiono surowy `GestureDetector` komponentem `FocusableActionDetector` z obsługą skrótów klawiaturowych (klawisze `Enter` i `Space` dla `ActivateIntent`), widocznym obrysem skupienia (focus ring z motywu) oraz pełną dostępnością semantyczną (`Semantics` w roli przycisku z flagą `selected: isSelected`).
> - **Zmodyfikowane pliki:**
>   - `lib/workspaces/presentation/tasks/widgets/task_list_workflow_segmented_switch.dart`
> - **Weryfikacja:** Test `task_list_workflow_segmented_switch_test.dart` weryfikuje interakcję za pomocą klawiatury (Enter/Space), zachowanie focusa oraz semantykę accessibility.

## Wydajność i architektura

| Obszar | Obecnie | Zalecenie |
|---|---|---|
| Wiersze główne | ListView.builder — prawidłowa baza | Zachować; mierzyć liczbę przebudowanych wierszy przy pojedynczej mutacji |
| Podzadania | Zagnieżdżony ListView, shrinkWrap, bez własnego scrolla | Spłaszczyć rozwinięte drzewo do jednej wirtualizowanej listy; duża rozwinięta gałąź nie powinna budować wszystkich dzieci |
| Kolumny | Cała szeroka tabela w poziomowym SingleChildScrollView | Najpierw zamrozić tytuł/zaznaczenie; wirtualizację poziomą uzależnić od profilu dla wielu kolumn |
| Grupowanie i sort | Cache zależy od całego stanu; selection/error też go unieważniają | Osobna rewizja danych i struktury; zaznaczenie lokalnie przez selector |
| Preferencje | Odczyt w rodzicu i kolejny BlocBuilder wewnątrz tabeli | Ograniczyć obserwowane pola; zapis wersji nie powinien przebudowywać całej tabeli |
| Ukryty board | IndexedStack utrzymuje oba widoki | Zmierzyć koszty budowania/realtime niewidocznego widoku; nie usuwać cache bez potrzeby |
| Etykiety | Pobieranie definicji przy otwarciu menu | Cache per projekt z unieważnianiem po zmianie; nie pobierać dla każdego wiersza z góry |
| Checklista | Popover pobiera getTask i prowadzi mutacje w State | Lokalny Cubit i węższy kontrakt checklisty, jeśli backend go oferuje; nie jest to ocena modalu zadania |
| Struktura | Settings modal 987 linii, list Cubit 1629, saved views 682, custom field dialog 730 | Podział według odpowiedzialności: konfiguracja, zapytanie, zaznaczenie, mutacje, metadane, edytor opcji |
| Warstwy | ProjectCapabilities w domain importuje presentation/project_settings_modal.dart | Enum zakładek/politykę widoczności przenieść tak, aby domain nie zależało od Flutter UI |

Nie optymalizować przez masowe const, RepaintBoundary na każdej komórce ani pobranie wszystkich zadań do pamięci. Najpierw usunąć nadmiarowe requesty, resetowanie stanu i sortowanie całego snapshotu po kliknięciu checkboxa.

## Ocena wizualna

Obserwacja działającego macOS: lista jest zwarta, lecz statusy o pełnym nasyceniu przyciągają uwagę bardziej niż tytuły. Nagłówki tabel powtarzają się nawet w pustych grupach. Wybrany układ zawierał 21 kolumn; konfigurator pokazuje ich kolejność na wąskim poziomowym pasku, pozostawiając dużą pustą powierzchnię poniżej.

Proponowany kierunek:

1. Jeden czytelny pasek: wyszukiwanie zadań, grupowanie, sortowanie, filtry, kolumny. Aktywne warunki poniżej jako usuwalne etykiety.
2. Domyślnie tytuł, status, wykonawcy, priorytet, termin. Pozostałe dane dostępne przez zapisane widoki; istniejących preferencji użytkownika nie nadpisywać.
3. Tytuł i checkbox pozostają widoczne przy przewijaniu poziomym. Nagłówek kolumn przyklejony do górnej krawędzi listy.
4. Puste grupy kompaktowe: nazwa, licznik i dodanie; bez pustego nagłówka wszystkich kolumn.
5. Mniej pełnych kolorowych prostokątów. Mocny kolor dla istotnego stanu, delikatniejsze tło dla zwykłej klasyfikacji. Nazwa zadania ma dominować.
6. Dwie gęstości: kompaktowa i wygodna. Tekst oraz cele kliknięcia muszą pozostać użyteczne po powiększeniu.
7. Konfigurator kolumn jako pionowa lista widocznych pól z reorderem i katalog dostępnych pól obok; pozwala wykorzystać obecną pustą przestrzeń.
8. „Workflow projektu” wyjaśnić jako „Etapy projektu”, a drugą opcję jako „Status systemowy”. Nazwy należy dopasować do rzeczywistej domeny — kategoria analityczna i systemowy enum nie muszą być tożsame.
9. Ustawienia administracyjne pod nazwą „Ustawienia projektu”; preferencje osobiste obok zapisanych widoków. Podgląd roli ukryć pod dodatkową akcją.
10. Nie dokładać kolejnych ramek, cieni i gradientów. Ujednolicić odstępy, hierarchię tekstu oraz zachowanie focus/hover.

## Inwentaryzacja modali i kontekstów

Ocena rodzin komponentów na podstawie kodu; oznaczenie „UI” oznacza dodatkowy podgląd działającej wersji. Nie oznacza testu wszystkich wariantów, błędów i rozmiarów.

| Rodzina | Stan / zalecenie |
|---|---|
| Ustawienia projektu — UI | Jest wspólny shell, nawigacja i lazy loading. Podzielić plik i zwracać zakres zmian; ujednolicić teksty przez l10n |
| Status — UI | WorkspaceCreationModalWrapper; spójna struktura nagłówek–treść–stopka. Kolor statusu wpływa na przycisk Zapisz: akcja powinna zachować stały kolor semantyczny |
| Szablony workflow | Wspólny wrapper; przy zastosowaniu pokazać wpływ na aktualne etapy i zadania |
| Pola własne / edycja opcji | Wrapper jak status; największy edytor. Wydzielić opcje, ikonę i kolor; zapewnić reorder z klawiatury obok D&D |
| Etykieta | Wspólny wrapper 420; paleta i walidacja powinny być zgodne ze statusem i polami |
| Kamień milowy | Wspólny wrapper 460; wspólne reguły dat i prezentacji błędów |
| Dodanie członka / rola | Wrapper 440 oraz selektor roli; spójny picker osób i jawna informacja o dostępie |
| Szablony projektu: utworzenie, zastosowanie, odświeżenie, usunięcie, szczegóły | AlertDialog i osobny rozbudowany podgląd; ujednolicić formularze i potwierdzenia, nie mieszać ich z pickerami szablonów zadań |
| Ogólne / archiwizacja / usuwanie projektu | Niebezpieczne akcje wizualnie oddzielone; potwierdzenia powinny nazywać projekt i skutek |
| Automatyzacje | Głównie konfiguracja w zakładce; zachować wspólne stany save/error i role, bez tworzenia kolejnych zagnieżdżonych modali |
| Moje Centrum Projektu | Osobny shell profilu/preferencji; zachować jasno osobisty zakres i spójny header/close |
| Kolumny — UI | Osobny Dialog; poprawić podział osobiste/projekt, obsługę błędów i wykorzystanie przestrzeni |
| Zapisane widoki: definicja, nazwa, usunięcie | AlertDialog, rozbudowany StatefulBuilder; wspólny edytor z sekcjami „Dane / Układ / Widoczność” i draftem |
| Status i priorytet komórki | TaskContextMenu/WorkspaceContextMenu; dobra baza dla małych list. Sprawdzić wybór własnego statusu we wszystkich wywołaniach |
| Typ zadania | Standardowe menu, własny typ przechodzi do AlertDialog; zmiana zachowania względem innych pickerów |
| Rozmiar / złożoność / ryzyko | Wspólne menu, lecz powielone mapowania i lokalne kolory/etykiety; naprawić XL i wyodrębnić opisy opcji |
| Estymata / czas | Osobny ręcznie pozycjonowany dialog; najpilniejsza unifikacja powierzchni popup |
| Daty | AppContextMenu.showCustom; wspólny kalendarz, sprawdzić timezone/date-only i focus |
| Tekst / pola własne boolean, single i multi | Wspólna baza częściowa. MultiSelect zamyka menu po jednym wyborze: dla kilku wartości trzeba otwierać je ponownie |
| Osoby / wykonawcy / obserwujący | Ujednolicić wyszukiwanie, wybór wielu osób, clear i stan niedostępnego profilu; bez technicznych identyfikatorów jako nazwy |
| Etykiety komórki | Własny popover i pobranie metadanych; cache, jeden wzorzec wielu wyborów i informacji o zapisie |
| Kamień milowy komórki | Wspólne menu; dodać wyszukiwanie dla dużej liczby pozycji i jawny pusty/błędny stan |
| Checklista komórki | Własny stan i request pełnych szczegółów; lokalny Cubit, zachowanie draftu i błędów |
| Cykliczność z menu | AppContextMenu + lokalny Cubit — dobry wzorzec lifecycle; wspólne rozmiary i zachowanie z pozostałymi edytorami |
| Menu wiersza i bulk | Utrzymać te same nazwy/statusy/pickery; rozróżnienie zaznaczone vs cały wynik jest wartościowe. „Duplikuj” obecnie tworzy root z tytułem/status/priority: nazwać ograniczony zakres albo wdrożyć pełną kopię |

Docelowo wystarczą trzy wzorce: małe menu akcji, zakotwiczony edytor wartości oraz modal formularza. Dialogi potwierdzeń mogą używać standardowego AlertDialog, jeśli mają wspólne tokeny i semantykę. Jedna klasa dla wszystkich okien byłaby nadmiernym uproszczeniem.

Wspólny kontrakt: Escape anuluje draft, Enter zatwierdza tam gdzie jednoznaczne, focus wraca do komórki, widoczny stan zapisu i błędu, popup mieści się w viewport, destrukcyjne akcje są oddzielone. Formularz z wieloma zmianami zamyka się po sukcesie; szybka pojedyncza zmiana może zamknąć picker od razu, ale musi pokazać błąd przy wierszu.

## Jak konkurować z ClickUp i monday

To kierunek produktu, nie stwierdzenie przewagi bez testów użytkowników. ClickUp dokumentuje sortowanie w obrębie grup i całych kolumn oraz ręczną kolejność. Własna lista musi przede wszystkim zachowywać tę kolejność przewidywalnie. [ClickUp: Sort tasks in List view](https://help.clickup.com/hc/en-us/articles/6310352825751-Sort-tasks-in-List-view).

monday dokumentuje przypinanie kolumn podczas przewijania, zmianę szerokości i sortowanie. Przy obecnej szerokości tabeli zamrożony tytuł ma większą wartość niż kolejne ozdobniki. [monday: The basics of columns](https://support.monday.com/hc/en-us/articles/115005466609-The-basics-of-columns).

Proponowana przewaga Veloryn: bardzo szybka obsługa codziennych operacji, mniejsza liczba decyzji w pasku narzędzi, brak resetowania kontekstu, czytelne osobiste i projektowe ustawienia oraz konsekwentna klawiatura. Mierzyć czas „znajdź zadanie → zmień osobę/termin → wróć do pracy”, liczbę kliknięć i błędów. Nie oceniać przewagi liczbą funkcji.

## Kolejność wdrażania i odbiór

| Etap | Zakres | Warunek zakończenia |
|---|---|---|
| 1. Poprawność | Jedno groupBy, none, kolejność, sort/paginacja, XL | Testy round-trip i integracji konfiguracji z listą; D&D pozostaje po odświeżeniu |
| 2. Zapis i lifecycle | Draft projektu, błędy preferencji, wynik ustawień | Escape bez zmian: brak reloadów. Błąd API: brak cichej utraty zmian |
| 3. Ergonomia | Header, zamrożony tytuł, puste grupy, kolumny | Użytkownik identyfikuje zadanie przy scrollu i rozumie aktywny zakres konfiguracji |
| 4. Modale i menu | Wspólne powierzchnie, klawiatura, multi-select, popup czasu | Narożniki okna, Escape/Tab/Enter, focus restoration, error/retry |
| 5. Profilowanie web | Spłaszczone podzadania, ograniczone rebuildy, metadane | Profile/release na Web/Wasm, minimum 1280 px oraz desktop, jasny/ciemny motyw |

Macierz wydajności: 100 / 1000 / 10000 zadań w projekcie, nadal stronicowanych; 6 / 20 / 40 kolumn; 0 / 1 / wiele rozwiniętych gałęzi; opóźniona sieć i burst realtime. Mierzyć requests, czas pierwszego użytecznego widoku, frame build/raster, pamięć i utrzymanie scrolla. Cel projektowy: po checkboxie zero REST i brak ponownego sortowania danych; po zamknięciu niezmienionych ustawień zero REST. Są to cele, nie wyniki obecnego benchmarku.

## Co już działa i warto zachować

Lazy loading ustawień i ograniczenie akcji szablonów są objęte przechodzącymi testami. Metadane tabeli nie przeładowują się już przy każdej zmianie całego stanu. Preferencje mają serializację autosave; nadal należy obsłużyć reset, konflikty i semantykę zakresu. Główna lista jest budowana lazy, istnieją modele snapshotu/selection i aktualizacje pojedynczych wierszy. Te elementy warto rozwijać zamiast wymieniać całą architekturę.

