# R2r — jakość aktywnego pionu Tasks

Data: 2026-09-18  
Status: zakończony automatyczny odbiór; desktop/staging: **NIE URUCHAMIANO**.

## Zakres

Ten pakiet nie dodaje funkcji automatyzacji ani nie zmienia kontraktów API.
Naprawia dwa naruszenia zasad jakości w już odzyskanym pionie Tasks:

1. `TaskListWorkflowSegmentedSwitch` używał `setState` dla hover/focus.
2. `AutomationSettingsCubit` łączył stan, ładowanie danych oraz dry-run w
   jednej klasie przekraczającej limit 400 linii.

## Zmienione pliki

| Plik | Rola po zmianie |
|---|---|
| `lib/workspaces/presentation/tasks/widgets/task_list_workflow_segmented_switch.dart` | Lokalny hover/focus jest `ValueNotifier` z `ValueListenableBuilder`; brak `setState`. Migracja importów l10n/theme do `foundation`. |
| `lib/workspaces/presentation/tasks/settings/cubit/automation_settings_state.dart` | Niezmienny stan ekranu automatyzacji. |
| `lib/workspaces/presentation/tasks/settings/cubit/automation_settings_loader.dart` | Startowe odczyty reguł/katalogu/przepisów i pomocnicze dane kreatora; nie zna Fluttera ani Cubita. |
| `lib/workspaces/presentation/tasks/settings/cubit/automation_settings_dry_run_service.dart` | Odczyt tasków do selektora i symulacja reguły przez porty repository. |
| `lib/workspaces/presentation/tasks/settings/cubit/automation_settings_cubit.dart` | Koordynuje wyłącznie stany ekranu, mutacje reguł, historię i lifecycle. Publiczny eksport stanu zachowuje kompatybilność importerów. |
| `test/workspaces/presentation/tasks/widgets/task_list_workflow_segmented_switch_test.dart` | Test callbacku wyboru segmentu. |

## Niezmienione zachowanie

- `load()` nadal ładuje kolejno reguły, katalog i przepisy; dopiero sukces
  wszystkich trzech publikuje ekran gotowy.
- Błąd opcjonalnych profili lub etykiet nie blokuje listy reguł.
- Pusta, poprawna odpowiedź opcjonalnego katalogu nadal czyści poprzednią
  listę; tylko błąd/brak portu zachowuje stan poprzedni.
- Dry-run nie zapisuje taska ani reguły; Cubit tylko publikuje wynik portu.

## Odbiór

```text
flutter test test/workspaces/presentation/tasks/widgets/task_list_workflow_segmented_switch_test.dart
PASS 1/1

flutter test test/workspaces/presentation/tasks/settings/automation_settings_cubit_test.dart
PASS 9/9

flutter analyze lib/workspaces/presentation/tasks/settings/cubit
PASS — no issues found
```

Nie uruchamiano aplikacji Flutter, backendu, MinIO, OnlyOffice ani stagingu.
Automatyczny odbiór nie zastępuje późniejszego scenariusza desktopowego:
otwarcie ustawień projektu, utworzenie/edycja reguły, dry-run i konflikt ACL.

## Następny krok

Przy kolejnym pakiecie najpierw przejrzeć kolejne klasy ponad limitem 400
według odpowiedzialności, a nie według mechanicznej liczby linii. Priorytet
produktu pozostaje: Pliki, lista zadań, Kanban oraz częściowe overlaye Chat i
Powiadomienia; nie tworzyć nowych ekranów Whiteboard/Wiki/Corkboard/OKR.
