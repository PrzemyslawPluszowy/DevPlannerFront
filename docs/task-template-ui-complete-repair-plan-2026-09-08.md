# Pełny plan naprawy UI szablonów zadań

Data: 2026-09-08  
Zakres: Flutter `ready_next`, biblioteka szablonów zadań otwierana z Kanbana  
Odbiorca: agent implementujący poprawkę  
Priorytet: wysoki — podstawowy scenariusz „Nowa formatka” jest obecnie zablokowany

## 1. Cel

Naprawić cały przepływ UI szablonów zadań tak, aby:

1. „Nowa formatka” natychmiast otwierała działający formularz.
2. Edycja istniejącej formatki poprawnie ładowała dane.
3. Żaden overlay ani dialog nie zależał od przypadkowego zasięgu `Provider`.
4. Błędy API były widoczne w aktualnie otwartym panelu i zawierały prawdziwy komunikat.
5. Walidacja wskazywała konkretne błędne pola.
6. Interfejs był nowoczesny, czytelny, responsywny i wygodny także dla większej liczby osób, etykiet oraz pól.
7. Obsługiwane były statusy systemowe i kolumny customowe Kanbana.
8. Podstawowe scenariusze były zabezpieczone testami widżetowymi, a nie tylko testami cubita.

## 2. Granice zadania

### Pliki w zakresie

- `lib/workspaces/presentation/tasks/board/tasks_board_template_picker.dart`
- `lib/workspaces/presentation/tasks/board/tasks_board_template_picker_actions.dart`
- `lib/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart`
- `lib/workspaces/data/projects/tasks/models/task_templates_models.dart`
- `lib/workspaces/domain/repositories/task_template_repository.dart`
- `lib/workspaces/data/projects/tasks/repositories/task_template_repository_impl.dart`
- testy dotyczące powyższej funkcjonalności
- pliki ARB tylko wtedy, gdy potrzebne są nowe komunikaty UI
- wygenerowane pliki Freezed/l10n wyłącznie jako konsekwencja zmian modeli lub ARB

### Pliki poza zakresem

- drag and drop Kanbana,
- menu statusów tasków i subtasków,
- realtime,
- wygląd kart Kanbana,
- lista zadań niezwiązana z pickerem szablonów,
- backend, o ile aktualny kontrakt rzeczywiście obsługuje wymagany payload.

Repozytorium jest modyfikowane równolegle. Przed każdą edycją wykonaj `git diff -- <plik>` i zachowaj wszystkie istniejące zmiany. Nie cofaj cudzych zmian i nie formatuj całych katalogów.

## 3. Potwierdzone błędy

### 3.1. Krytyczny błąd trybu tworzenia

W `_TaskTemplateEditorState.initState()` tryb tworzenia ustawia:

```dart
_status = ProjectTaskStatus.todo;
_priority = TaskPriority.normal;
_loading = false;
```

`_details` pozostaje poprawnie `null`, ponieważ nowy szablon nie ma jeszcze danych z backendu. Następnie `build()` wykonuje bezwarunkowo:

```dart
if (_details == null) {
  return retryButton;
}
```

Efekt: nowa formatka zawsze pokazuje „Ponów próbę”, mimo że nie wystąpił błąd i nie został wykonany request.

### 3.2. Utrata informacji o błędzie

`TaskTemplatePickerCubit.loadDetails()` zwraca `TaskTemplateDetailsResponse?` i mapuje każdy `ApiError` na `null`. Widok nie potrafi rozróżnić:

- 403,
- 404,
- 409,
- błędu sieci,
- błędu parsowania.

### 3.3. Błąd zasięgu providerów

Picker oraz edytor są otwierane w kolejnych overlayach. Kontekst overlayu nie może zakładać, że odziedziczy providery spod strony Kanbana. Instancje cubitów należy przechwycić przed otwarciem overlayu i przekazać przez `BlocProvider.value` albo jako jawne zależności konstruktora.

### 3.4. Błąd zapisu jest zasłonięty

Cubit zapisuje prawdziwy `error.message` w stanie nadrzędnego pickera. Edytor po `saved == false` pokazuje ogólne „Ponów próbę”. Panel nadrzędny znajduje się pod edytorem, więc użytkownik nie widzi właściwego błędu.

### 3.5. Nieprecyzyjna walidacja

Jeden warunek waliduje wszystkie pola, ale zawsze pokazuje komunikat dotyczący estymaty. To uniemożliwia szybkie poprawienie formularza.

### 3.6. Brak testu prawdziwego przepływu UI

Testy cubita przechodzą, ale nie budują `_TaskTemplateEditor` w trybie tworzenia. Dlatego nie wykrywają krytycznego błędu renderowania.

## 4. Docelowa architektura stanu

Nie używaj `_details == null` jako informacji o trybie lub błędzie. Są to trzy różne pojęcia.

Dodaj prywatny enum widoku edytora:

```dart
enum _TaskTemplateEditorMode { create, edit }
```

Tryb powinien wynikać raz z `widget.template == null` i być dostępny przez getter:

```dart
bool get _isCreating => widget.template == null;
```

Dodaj jawny stan ładowania istniejącego szablonu:

```dart
bool _loading = false;
ApiError? _loadError;
```

Wymagane warianty renderowania:

| Tryb | `_loading` | `_loadError` | `_details` | Widok |
|---|---:|---|---|---|
| create | false | null | null | formularz |
| edit | true | null | null | skeleton/loading |
| edit | false | error | null | pełny error state + retry |
| edit | false | null | details | formularz |

Warunek w `build()` ma wyglądać semantycznie tak:

```dart
if (!_isCreating && _loading) return _buildLoading();
if (!_isCreating && _loadError != null) return _buildLoadError();
return _buildForm();
```

Nie wolno dodawać sztucznego `TaskTemplateDetailsResponse` dla trybu tworzenia.

## 5. Zmiana kontraktu błędów cubita

### Zalecane rozwiązanie

Zmień `loadDetails()` tak, aby nie tracił `ApiError`:

```dart
Future<Either<ApiError, TaskTemplateDetailsResponse>> loadDetails(
  String templateId,
) => repository.details(
  workspaceId: workspaceId,
  templateId: templateId,
);
```

Jeżeli nie chcesz ujawniać `dartz` w widżecie, utwórz mały wynik domenowy:

```dart
sealed class TaskTemplateDetailsLoadResult {}
final class TaskTemplateDetailsLoaded extends TaskTemplateDetailsLoadResult {
  const TaskTemplateDetailsLoaded(this.details);
  final TaskTemplateDetailsResponse details;
}
final class TaskTemplateDetailsLoadFailure extends TaskTemplateDetailsLoadResult {
  const TaskTemplateDetailsLoadFailure(this.error);
  final ApiError error;
}
```

Nie zwracaj `null` dla błędu.

### Wynik mutacji

Metody `createFromDefinition()` i `updateDetails()` nie powinny zwracać samego `bool`, ponieważ `false` nie mówi widokowi, co się stało. Wprowadź wynik:

```dart
sealed class TaskTemplateMutationResult {
  const TaskTemplateMutationResult();
}

final class TaskTemplateMutationSuccess extends TaskTemplateMutationResult {
  const TaskTemplateMutationSuccess();
}

final class TaskTemplateMutationFailure extends TaskTemplateMutationResult {
  const TaskTemplateMutationFailure(this.error);
  final ApiError error;
}
```

Minimalna akceptowalna alternatywa: cubit udostępnia `ApiError? lastMutationError`, a edytor odczytuje go bezpośrednio. Preferowany jest jednak jawny wynik operacji.

## 6. Dokładna implementacja edytora

### 6.1. `initState()`

Tryb tworzenia:

- `_loading = false`,
- ustaw domyślny status i priorytet,
- nie wykonuj requestu,
- nie ustawiaj `_details`,
- formularz ma być dostępny od pierwszej klatki.

Tryb edycji:

- `_loading = true`,
- uruchom `_loadExistingTemplate()`,
- po sukcesie wypełnij kontrolery,
- po błędzie zapisz pełny `ApiError`.

### 6.2. Ponowienie pobierania

Retry musi:

1. wyczyścić wcześniejszy błąd,
2. ustawić `_loading = true`,
3. zablokować wielokrotne kliknięcia,
4. wywołać pobranie szczegółów,
5. pokazać prawdziwy komunikat po kolejnej porażce.

### 6.3. Formularz

Podziel formularz na sekcje/karty:

1. **Podstawowe** — nazwa formatki, tytuł zadania, opis.
2. **Planowanie** — status, priorytet, daty, estymata.
3. **Odpowiedzialność** — wykonawcy.
4. **Zakres pracy** — checklista i kryteria akceptacji.
5. **Klasyfikacja** — typ, rozmiar, złożoność, ryzyko, wartość biznesowa.
6. **Metadane** — etykiety i pola customowe.

Użyj spójnych odstępów z design systemu. Nie twórz jednego niepodzielonego formularza z kilkunastoma polami.

### 6.4. Pasek akcji

Dolny pasek powinien być sticky i zawierać:

- „Anuluj”,
- „Utwórz formatkę” w trybie create,
- „Zapisz zmiany” w trybie edit,
- spinner wewnątrz przycisku podczas zapisu.

Podczas zapisu zablokuj pola i przyciski modyfikujące listy.

### 6.5. Niezapisane zmiany

Dodaj `_isDirty`. Ustawiaj go przy zmianie dowolnego pola, statusu, daty, wykonawcy, etykiety lub wartości customowej.

Próba zamknięcia edytora z niezapisanymi zmianami powinna pokazać potwierdzenie:

- „Odrzuć zmiany”,
- „Wróć do edycji”.

Nie blokuj zamknięcia, jeśli zapis zakończył się sukcesem.

## 7. Walidacja formularza

Zastosuj `Form` i `GlobalKey<FormState>`. Nie używaj jednego ogólnego `if` dla wszystkich pól.

Minimalne reguły:

- nazwa formatki: wymagana, po trimie 1–160 znaków,
- tytuł zadania: wymagany, po trimie 1–240 znaków,
- opis: maksymalnie 20 000 znaków,
- data końcowa nie może być wcześniejsza niż początkowa,
- estymata: pusta albo dodatnia liczba całkowita,
- size/complexity/risk/businessValue: puste albo liczba całkowita 0–100,
- typ zadania: maksymalnie 80 znaków,
- element checklisty: maksymalnie 500 znaków,
- kryterium akceptacji: maksymalnie 1000 znaków,
- nazwa etykiety: 1–80 znaków,
- kolor etykiety: poprawny `#RRGGBB`,
- nazwa pola customowego: 1–120 znaków,
- brak duplikatów etykiet i pól bez uwzględniania wielkości liter.

Komunikat ma być pokazany przy konkretnym polu. Na górze formularza można dodatkowo wyświetlić krótkie podsumowanie „Popraw oznaczone pola”.

## 8. Statusy systemowe i customowe

Aktualny dropdown używa wyłącznie `ProjectTaskStatus.values`. To jest niespójne z Kanbanem posiadającym własne kolumny.

Przekaż do edytora listę `KanbanColumnResponse` z aktualnego `TasksBoardReady.board.columns`.

Przechowuj wybór jako obiekt kolumny albo strukturę:

```dart
record SelectedTemplateStatus(
  ProjectTaskStatus fallbackStatus,
  String? customStatusId,
  String displayName,
  String color,
);
```

Dla statusu systemowego payload powinien zawierać systemowy status i `customStatus: null`. Dla statusu customowego utwórz `TaskTemplateCustomStatusResponse` z nazwą oraz kategorią zgodną z kolumną. Zweryfikuj kontrakt backendu przed implementacją; nie wysyłaj jednocześnie dwóch sprzecznych reprezentacji.

Ikony i kolory mają używać tego samego helpera co menu kontekstowe Kanbana.

## 9. Wybór wykonawców

Nie renderuj wszystkich członków jako nieograniczony `Wrap` chipów.

Zastosuj:

- pole wyszukiwania,
- debounce 250–350 ms,
- wyniki ograniczone wysokością,
- zaznaczone osoby w osobnej sekcji u góry,
- avatar, imię i nazwisko,
- neutralny fallback bez UUID,
- stan „Nie udało się pobrać osób” zamiast ukrycia całej sekcji,
- pusty stan „Brak pasujących osób”.

Nie pokazuj `coreUserId`, `readyUserId` ani fragmentów UUID jako nazwy.

## 10. Błędy i diagnostyka

### Błąd ładowania katalogu

Pokaż pełny error state w głównym panelu:

- czytelny komunikat,
- przycisk „Spróbuj ponownie”,
- opcjonalnie kod błędu/traceId w rozwijanych szczegółach technicznych.

### Błąd ładowania edycji

Pokaż go wewnątrz edytora, nie pod nim. Retry nie może zamykać panelu.

### Błąd zapisu

Pokaż banner nad formularzem i pozostaw wszystkie wpisane dane. Przewiń do bannera lub pierwszego błędnego pola. Nie zastępuj komunikatu backendu tekstem „Ponów próbę”.

### Logowanie

Nie dodawaj ręcznych `print()`. Obecny `ApiRepository.guardApiCall()` odpowiada za log Dio. W testach weryfikuj stan UI, nie tekst logów. Nigdy nie loguj Authorization header ani tokena.

## 11. Operacje na katalogu

Obecne `load()` przełącza cały picker na `TaskTemplatePickerLoading` również po zapisie, zmianie nazwy i usunięciu. Zmień to tak, aby:

- pierwsze pobranie używało pełnego loading state,
- odświeżenie po mutacji zachowywało bieżącą listę,
- aktualizowana pozycja miała lokalny spinner,
- sukces aktualizował listę lokalnie albo wykonywał ciche odświeżenie,
- błąd nie usuwał wcześniejszych danych.

Nie używaj `isSavingDefault` jako flagi tworzenia nowego szablonu. Dodaj osobne:

- `bool isCreating`,
- `String? updatingTemplateId`,
- `String? deletingTemplateId`,
- `bool isSavingDefault`.

## 12. UX katalogu szablonów

Każdy kafel powinien mieć:

- nazwę formatki,
- skrócony tytuł/zakres, jeśli dane są dostępne,
- badge „Domyślna”,
- jawny przycisk „Użyj”,
- menu `...` dla edycji, zmiany nazwy i usunięcia.

Nie uruchamiaj zastosowania formatki przez kliknięcie w dowolne miejsce kafla — łatwo zastosować ją przypadkiem podczas próby zaznaczenia tekstu lub otwarcia menu.

W pustym stanie pozostaw tylko jedno główne CTA „Utwórz pierwszą formatkę”. Nie pokazuj równocześnie dwóch przycisków „Nowa formatka”.

## 13. Testy obowiązkowe

### Testy widżetowe

Dodaj nowy plik, np.:

`test/workspaces/presentation/tasks/board/templates/task_template_picker_widget_test.dart`

Scenariusze:

1. Kliknięcie „Nowa formatka” pokazuje formularz, nie przycisk retry.
2. W trybie create nie jest wykonywany request `details`.
3. Wypełnienie wymaganych pól i zapis wywołuje `createFromDefinition` dokładnie raz.
4. Błąd create pozostawia formularz i wpisane wartości oraz pokazuje prawdziwy komunikat.
5. Edycja istniejącej formatki pokazuje loading, następnie wypełniony formularz.
6. Błąd details pokazuje komunikat i działający retry.
7. Zamknięcie brudnego formularza wymaga potwierdzenia.
8. Picker działa wewnątrz overlayu bez `ProviderNotFoundException`.
9. Zapis jest odporny na podwójne kliknięcie.
10. Wybór kolumny customowej trafia do właściwego payloadu.
11. Walidacja dat i wartości 0–100 wskazuje właściwe pola.
12. Lista wykonawców wyszukuje po imieniu i nazwisku i nie pokazuje UUID.

### Testy cubita

Uzupełnij istniejący plik o:

- zachowanie `ApiError` z `loadDetails`,
- osobny stan tworzenia,
- brak pełnego loadingu przy cichym refreshu,
- prawidłowe flagi operacji,
- zachowanie poprzedniej listy po błędzie mutacji,
- konflikt 409 podczas edycji,
- usunięcie domyślnego szablonu czyści preferencję w UI.

### Testy regresyjne providerów

Zbuduj picker pod testowym `Navigator`, otwórz boczny panel, następnie edytor. Po każdej interakcji wykonaj:

```dart
expect(tester.takeException(), isNull);
```

## 14. Kolejność implementacji

1. Najpierw dodaj failing widget test dla „Nowa formatka”.
2. Rozdziel tryb create/edit i napraw renderowanie formularza.
3. Zmień wynik `loadDetails`, aby zachowywał `ApiError`.
4. Zmień wynik create/update, aby edytor otrzymywał konkretny błąd.
5. Uporządkuj providery dla wszystkich overlayów.
6. Dodaj `Form` i walidację per-field.
7. Podziel formularz na sekcje i dodaj sticky action bar.
8. Dodaj dirty state oraz potwierdzenie zamknięcia.
9. Dodaj wybór statusów customowych.
10. Zastąp chip-wall wyszukiwanym pickerem osób.
11. Usuń pełnoekranowy loading po mutacjach katalogu.
12. Dodaj komplet testów widżetowych i cubita.
13. Uruchom generator tylko wtedy, gdy zmieniono Freezed lub ARB.
14. Uruchom analizę i testy.

## 15. Komendy walidacyjne

Uruchom co najmniej:

```bash
dart format \
  lib/workspaces/presentation/tasks/board/tasks_board_template_picker.dart \
  lib/workspaces/presentation/tasks/board/tasks_board_template_picker_actions.dart \
  lib/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart \
  test/workspaces/presentation/tasks/board/templates/

flutter analyze \
  lib/workspaces/presentation/tasks/board/tasks_board_template_picker.dart \
  lib/workspaces/presentation/tasks/board/tasks_board_template_picker_actions.dart \
  lib/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart

flutter test test/workspaces/presentation/tasks/board/templates/
flutter test test/workspaces/presentation/tasks/tasks_board_cubit_test.dart
git diff --check
```

Jeżeli zmieniono modele Freezed:

```bash
dart run build_runner build
```

Jeżeli zmieniono ARB:

```bash
flutter gen-l10n
```

## 16. Kryteria akceptacji

Funkcjonalność jest ukończona dopiero, gdy wszystkie punkty są spełnione:

- [ ] „Nowa formatka” pokazuje formularz w pierwszej klatce.
- [ ] Tryb create nie wywołuje endpointu details.
- [ ] Formularz pozwala utworzyć szablon.
- [ ] Edycja pobiera i pokazuje istniejące dane.
- [ ] Nie występuje `ProviderNotFoundException` w żadnym overlayu.
- [ ] Nie występuje `Looking up a deactivated widget's ancestor is unsafe`.
- [ ] Błąd API jest widoczny w aktualnym panelu.
- [ ] Dane formularza nie giną po błędzie zapisu.
- [ ] Walidacja wskazuje konkretne pole.
- [ ] Podwójne kliknięcie nie tworzy dwóch szablonów.
- [ ] Status customowy można zapisać i ponownie odczytać.
- [ ] Wykonawcy są wyszukiwani po imieniu i nazwisku.
- [ ] UI nie pokazuje UUID jako nazwy osoby.
- [ ] Pusty katalog ma jedno wyraźne CTA.
- [ ] Kafel ma jawny przycisk „Użyj”.
- [ ] Zamykanie brudnego formularza wymaga potwierdzenia.
- [ ] Wszystkie nowe testy przechodzą.
- [ ] `flutter analyze` nie zgłasza problemów w zmienionych plikach.
- [ ] `git diff --check` przechodzi.
- [ ] Agent przed oddaniem wykonuje ręczny smoke test po pełnym hot restartcie.

## 17. Ręczny smoke test

Po pełnym hot restartcie:

1. Otwórz Kanban.
2. Otwórz bibliotekę formatek.
3. Kliknij „Nowa formatka”.
4. Sprawdź, że formularz jest widoczny bez requestu details.
5. Spróbuj zapisać pusty formularz — pola powinny pokazać lokalne błędy.
6. Wypełnij nazwę i tytuł.
7. Wybierz status systemowy, zapisz i sprawdź nowy kafel.
8. Edytuj utworzoną formatkę.
9. Zmień nazwę oraz priorytet i zapisz.
10. Utwórz formatkę ze statusem customowym.
11. Ustaw formatkę jako domyślną.
12. Użyj jej do utworzenia zadania w systemowej i customowej kolumnie.
13. Wywołaj kontrolowany błąd backendu i sprawdź treść komunikatu oraz zachowanie danych formularza.
14. Zamknij formularz z niezapisanymi zmianami i sprawdź potwierdzenie.
15. Obserwuj konsolę: brak wyjątków providerów, lifecycle i setState-after-dispose.

## 18. Zakazy dla implementującego agenta

- Nie naprawiaj problemu przez dodanie kolejnego ogólnego „Ponów próbę”.
- Nie twórz fikcyjnych details dla nowego szablonu.
- Nie łykaj `ApiError` i nie zamieniaj go na `null`.
- Nie używaj `BuildContext` po `await` bez sprawdzenia `mounted/context.mounted`.
- Nie odczytuj cubita z kontekstu overlayu, jeśli można przechwycić instancję przed jego otwarciem.
- Nie pokazuj użytkownikowi UUID, `readyUserId` ani enum `.name` jako docelowej etykiety.
- Nie uruchamiaj formatowania całego repozytorium.
- Nie cofaj ani nie nadpisuj zmian innych agentów.
- Nie uznawaj zadania za skończone na podstawie samych testów cubita — wymagane są testy widżetowe i ręczny smoke test.
