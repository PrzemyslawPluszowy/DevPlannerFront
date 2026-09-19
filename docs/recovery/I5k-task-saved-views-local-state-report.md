# I5k — zapisane widoki zadań: stan lokalny i podział UI

## Zakres

Zmiana obejmuje wyłącznie
`lib/workspaces/presentation/tasks/views/**` oraz istniejące bezpośrednie testy
zapisanych widoków.

- Dialog nazwy widoku korzysta z prywatnego `ValueNotifier<String?>` dla
  komunikatu walidacyjnego; notifier jest zwalniany w `dispose`.
- Dialog konfiguratora korzysta z prywatnego, niemutowalnego
  `_TaskSavedViewEditorUiState` w `ValueNotifier`. Zmiany filtrów,
  sortowania, grupowania, kolumn i błędów walidacji odświeżają wyłącznie
  odpowiedni fragment przez `ValueListenableBuilder`.
- Zachowano pełny przepływ: zapis bieżącego snapshotu, opcjonalną
  konfigurację przed zapisem, zmianę nazwy, edycję, wybór, nadpisanie
  aktywnego widoku oraz usunięcie.
- Z `TaskSavedViewsMenu` wydzielono `TaskSavedViewsFeedbackListener`, aby
  listener SnackBarów miał pojedynczą odpowiedzialność, a produktowy plik
  menu mieścił się w limicie 400 linii.
- Operacje I/O pozostają w `TaskSavedViewsCubit` i repozytoriach; UI wywołuje
  wyłącznie ich istniejące intencje.

## Bramy jakości

```text
flutter analyze lib/workspaces/presentation/tasks/views
No issues found!

flutter test test/workspaces/presentation/tasks/views --reporter compact
12/12 PASS

rg setState|StatefulBuilder|setDialogState views
brak wyników

najdłuższy plik produktowy Dart: 383 linii
git diff --check (scoped): PASS
```

Nie dodano zależności `ready_next`, `DataBus`, `http` ani `dio`. Istniejące
importy `devplanner/core` służą wyłącznie lokalizacji, motywowi i błędom
domenowym, bez I/O. W pionie produkcyjnym nie ma top-level application
helperów; dialogi otwierają metody klas widgetów.

## Status

Gotowe do review rootu. Nie wykonano commita, push, resetu ani czyszczenia
worktree.
