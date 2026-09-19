# R2y — granice helperów aktywnego pionu Tasks

Data: 2026-09-18  
Status: **część wykonana i zweryfikowana statycznie**

## Wykonana zmiana

Usunięto globalne helpery z dwóch aktywnych fragmentów Tasks, bez zmiany
kontraktów Backend, tras, Cubitów ani danych:

- `TaskListGrouping` przejął klucze, kolejność i walidację grup listy.
- `TaskRecurrenceSummaryLabeler` formatuje opis cykliczności.
- `TaskRowContextMenu` jest jedynym właścicielem kompozycji menu wiersza.
- `TaskHistoryDialogLauncher` i `TaskHistoryPresentation` rozdzielają otwarcie
  modalu historii od czystego formatowania.
- `TaskAttachmentPresentation`, `TaskCollaboratorAvatarPalette`,
  `TaskCustomFieldPresentation` oraz `TaskLabelColorParser` zamknęły proste
  mapowania widoku szczegółów.
- `TaskTypePicker`, `TaskAssigneePicker`, `TaskListProjectSettingsLauncher`
  oraz `TaskArchiveConfirmation` są właścicielami odpowiednio pickerów typu i
  osób oraz lokalnych launcherów ustawień/archiwizacji.
- `AnchoredTextEditor` i `TaskDatePicker` zamknęły zakotwiczoną edycję tekstu
  oraz wybór/normalizację daty UTC. Wszystkie komórki, menu i template actions
  korzystają z metod tych klas.
- `TaskComplexityPicker`, `TaskSizePicker` i `TaskRiskPicker` zastąpiły trzy
  globalne launchery metryk; każda metryka zachowuje własną, małą klasę.
- `TaskDurationEditor` oraz `TaskBusinessValuePicker` przeniosły do klas
  zakotwiczone edycje czasu i wartości biznesowej.
- `TaskDetailsLabeler` oraz `TaskListGrid.visibleColumns` zastąpiły globalne
  mapowania etykiet szczegółu i walidację widocznych kolumn tabeli.
- `TaskDependencyLabeler`, `TaskRecurrenceModeLabeler` i
  `TaskDetailsDescriptionControllerFactory` zamknęły lokalizację formularzy
  oraz tworzenie/odczyt Quill Delta z fallbackiem tekstowym.
- `TaskTimeTrackingPresentation` jest właścicielem obliczenia czasu aktywnego
  wpisu oraz etykiet czasu i statusu akceptacji. Nie odczytuje danych ani nie
  zmienia stanu wpisu — wyłącznie formatuje model dostarczony przez Cubit.
- `TaskRecurrenceDialogLauncher` składa dialog cykliczności z istniejącym
  repository i Cubitem, a `TaskRecurrenceFrequencyLabeler` lokalizuje tylko
  etykietę częstotliwości. Zapis nadal należy do `TaskRecurrenceCubit`.
- `TaskMilestonePickerLauncher` otwiera dolny picker z istniejącym
  `TaskMilestoneCubit`; przypisanie i odpięcie milestone pozostają w Cubicie.
- `TaskTemplateDialogLauncher` otwiera modal template z nowym
  `TaskTemplateCubit`; utworzenie template nadal jest komendą Cubita.
- `TaskDetailsTextEditor` jest właścicielem interakcji edycji krótkiego tekstu
  checkliście i kryterium akceptacji; mutacje pozostają w `TaskDetailsCubit`.
  `TaskDependencyTypeLabeler` lokalizuje jedynie typ relacji.

Każda z tych klas jest mała, bez stanu globalnego i I/O. I/O pozostaje w
istniejących Cubitach/repository; klasy prezentacyjne przyjmują jedynie dane
lub `BuildContext` niezbędny do lokalizacji/wyświetlenia modalu.

## Walidacja

```text
flutter analyze lib/workspaces/presentation/tasks/list \
  test/workspaces/presentation/tasks/list/task_list_grouping_test.dart
flutter test test/workspaces/presentation/tasks/list/task_list_grouping_test.dart
flutter analyze lib/workspaces/presentation/tasks/detail
```

Wynik: analiza listy i szczegółów **PASS**, `task_list_grouping_test` **4/4
PASS**.

## Następny bezpieczny krok

Skan aktywnego katalogu szczegółów Tasks nie znajduje już funkcji globalnych.
Przy kolejnych zmianach zachować ten warunek: nowe launchery i formatery muszą
trafiać do małych klas jednej odpowiedzialności, bez wspólnego „utility” lub God
class; logika domenowa i I/O nadal należą do Cubitów/repository.
