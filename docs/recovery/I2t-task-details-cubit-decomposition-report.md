# I2t — pełna dekompozycja `TaskDetailsCubit`

## Wynik

`TaskDetailsCubit` został zmniejszony z 950 do **394 linii** i spełnia limit
projektu `<400`. Cubit zachowuje istniejące publiczne metody, ale pełni już
rolę adaptera stanu: odczytuje bieżący stan, deleguje komendę i emituje typed
state. Nie zawiera HTTP, BFF, routingu ani `BuildContext`.

## Nowe klasy i odpowiedzialności

| Plik | Odpowiedzialność | Linie |
|---|---|---:|
| `task_details_loader_service.dart` | pobranie agregatu i mapowanie błędu ładowania | 49 |
| `task_details_metadata_service.dart` | typed transport etykiet i pól własnych | 52 |
| `task_details_response_assembler.dart` | czyste składanie odpowiedzi mutacji w detail state | 142 |
| `task_details_mutation_coordinator.dart` | lifecycle zapisu, conflict reload i błędy | 146 |
| `task_details_checklist_commands.dart` | komendy checklisty | 97 |
| `task_details_acceptance_commands.dart` | komendy kryteriów akceptacji | 87 |
| `task_details_dependency_commands.dart` | komendy zależności | 89 |
| `task_details_metadata_commands.dart` | komendy etykiet i pól własnych | 55 |
| `task_details_collaboration_commands.dart` | wykonawcy, obserwowanie i przypięcie | 60 |
| `task_details_cubit.dart` | cienki publiczny adapter Cubit | **394** |

Wszystkie klasy są lokalne dla feature detail i mają mniej niż 400 linii.
Każda zależy wyłącznie od typed repository/service/modelów. Nie dodano
globalnych funkcji, singletonów ani zależności do Ready/Core w nowych plikach.

## Zachowane kontrakty

- publiczne metody Cubita pozostały kompatybilne z istniejącymi widgetami;
- optimistic concurrency nadal przekazuje `expectedVersion`;
- konflikt odświeża pełny agregat i zachowuje komunikat błędu;
- po mutacjach sekcji odpowiedź aktualizuje wersję i timestamp zadania;
- obserwowanie i tworzenie zależności nadal wykonuje pełny refresh agregatu;
- przypięcie pozostaje lokalną zmianą preferencji użytkownika;
- walidacja tytułów, zakresu dat i lagów pozostała w warstwie komend/serwisów.

## Walidacja

Zielone:

```text
flutter analyze lib/workspaces/presentation/tasks/detail/cubit \
  lib/workspaces/presentation/tasks/detail
flutter test test/workspaces/presentation/tasks/task_details_cubit_test.dart --reporter compact
git diff --check
```

Test Cubita: **18/18 passed**. Analyzer: `No issues found!`.

Pełny katalog testów `test/workspaces/presentation/tasks/detail` nadal
napotyka istniejący, niezwiązany z I2t błąd kompilacji w legacy template board:
`tasks_board_page.dart` odwołuje się do przeniesionych `part` z błędnym
`part of` oraz brakującym `tasks_board_template_actions.dart`. I2t nie zmienia
tego obszaru. Ten blocker wymaga osobnego batchu naprawy Board/template.

## Uwagi do dalszego review

Następny review powinien sprawdzić widgety szczegółów pod kątem limitu 400
linii oraz wykonać pełny test workspace po naprawie niezależnego legacy Board
template. Chat, Notifications i Files nie były dotykane.
