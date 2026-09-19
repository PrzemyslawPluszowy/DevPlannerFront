# I2a — fundament Kanban/Tasks

## Zakres i decyzja architektoniczna

Przeniesiono zamknięty fundament Kanbana bez zmian routera, menu, Chat ani
presentation. Publiczny kontrakt repository nadal ma operacje board/settings,
kolumn systemowych i własnych, move, bulk move, bulk update oraz preferencji
użytkownika. Nie dodano placeholderów i nie usunięto żadnej funkcji.

Zakres zmian:

- `data/kanban` — modele Freezed/JSON, klient Retrofit i implementacja
  repository;
- bezpośredni port `domain/repositories/kanban_repository.dart`;
- bezpośrednie modele zadań wymagane przez `TaskRecurrenceSummaryResponse`;
- lokalne enumy i test kontraktu modeli.

## Dowody kontraktu Backend

Źródłem prawdy były pliki Backend, których nie modyfikowano:

- `Backend/Endpoints/Kanban/KanbanEndpoints.cs:20-90` — board, kolumny,
  settings, bulk move/update i move;
- `Backend/Endpoints/Kanban/KanbanUserPreferenceEndpoints.cs:16-30` — GET/PUT
  osobistych preferencji;
- `Backend/Contracts/Kanban/KanbanContracts.cs:7-145` — pola kart, lokalny
  `PrimaryAssigneeUserId`, `AssigneeUserId`, wersje optymistyczne i payloady;
- `Backend/Contracts/Kanban/UserKanbanPreferenceContracts.cs:6-18` — lokalny
  `UserId` oraz `CollapsedCustomStatusIds`;
- `Backend/Contracts/Tasks/TaskTemplateContracts.cs:35-120` — `AssigneeUserIds`
  w payloadach i szczegółach szablonów;
- `Backend/Contracts/Tasks/TaskCapacityContracts.cs:16-70` — `UserId` w
  capacity override i workload.

Migracja I2a jest zakończona bez aliasów Core. Nazwy Dart i wire są teraz
kanoniczne: `primaryAssigneeUserId`, `assigneeUserId`, `assigneeUserIds` oraz
`userId`. Obejmuje to modele Freezed/JSON, Retrofit, repository, workload,
szablony zadań, bezpośrednie cubity boardu i testy. Nie dodano fallbacków ani
kompatybilności dla `coreUserId`.

## Przed / po

| Kontrola | Przed I2a | Po I2a |
| --- | ---: | ---: |
| `package:ready_next` w bezpośrednim grafie boardu | 29 | 0 |
| Kanban/Tasks: `coreUserId`, `coreUserIds`, `assigneeCoreUserId(s)`, `primaryAssigneeCoreUserId` | obecne | 0 |
| Query/pola zgodne z lokalnym Backend `UserId`/`AssigneeUserId` | 0 | pełny zakres I2a |
| Usunięte publiczne operacje Kanban | — | 0 |
| Placeholdery | — | 0 |
| Scoped analyzer issues | baseline nie był czysty | 0 nowych identity/import issues; pozostały blokery root/shell opisane niżej |
| Testy modelu kontraktu | baseline legacy import | 5/5 PASS |
| `TasksBoardCubit` | legacy imports | 24/24 PASS |
| `TaskDetailsCubit` | legacy imports | 18/18 PASS |
| `TaskTemplatePickerCubit` | legacy identity | 12/12 PASS |
| `TaskCapacitySettingsCubit` | legacy identity | 4/4 PASS |

Wygenerowane pliki `.freezed.dart`, `.g.dart` i Retrofit zostały odtworzone
kontrolowanym `build_runner`; nie były ręcznie edytowane.

## Walidacja

```text
dart run build_runner build --build-filter='lib/workspaces/data/kanban/models/kanban_models.*' --build-filter='lib/workspaces/data/kanban/api/kanban_api.g.dart'
dart format lib/workspaces/data/kanban lib/workspaces/data/projects/tasks lib/workspaces/domain/repositories/kanban_repository.dart lib/workspaces/presentation/tasks test/workspaces/presentation/tasks
flutter analyze lib/workspaces/data/kanban lib/workspaces/data/projects/tasks/models lib/workspaces/data/projects/tasks/api/tasks_api.dart lib/workspaces/presentation/tasks/board lib/workspaces/presentation/tasks/workload lib/workspaces/presentation/tasks/settings/cubit/task_capacity_settings_cubit.dart
flutter test test/workspaces/data/kanban/kanban_models_test.dart
flutter test test/workspaces/presentation/tasks/tasks_board_cubit_test.dart
flutter test test/workspaces/presentation/tasks/board/templates/task_template_picker_cubit_test.dart
flutter test test/workspaces/presentation/tasks/settings/task_capacity_settings_cubit_test.dart
git diff --check
```

Wynik testów: wszystkie wymienione testy PASS. Scoped scan legacy identity
(`rg` po `lib/workspaces/data/kanban`, `lib/workspaces/presentation/tasks`,
bezpośrednich modelach/API/repository i testach Tasks) zwraca 0 wyników.
`flutter analyze` nadal raportuje wcześniejsze problemy root/shell
(`AppRouter`, `AuthCubit`, `AppModalPickerHost`) oraz kilka istniejących
problemów poza identity; nie zostały zamaskowane w tym pakiecie.

## Blokery i następny krok

I2a nie integruje jeszcze panelu zadań ani nie zmienia routing/menu zgodnie z
design spec — to celowa granica zadania. Pozostałe błędy analyzer dotyczą
nieodtworzonego root/shell i są osobnym zadaniem. W tym pakiecie nie zmieniano
Backend, routera ani shella.

## I2a-identity — uzupełnienie po review (2026-09-17)

Review wykrył, że pierwsza wersja raportu nie obejmowała wszystkich złożonych
aktorów zadań. Uzupełniono cały uzgodniony graf Tasks/Kanban, w tym modele
Freezed/JSON, bezpośrednie repository/API, Cubity listy/boardu/details,
szablony, capacity/workload oraz test fixtures. Zmienione zostały również
`createdByCoreUserId`, `completedByCoreUserId`, `acceptedByCoreUserId` i
`reviewedByCoreUserId` na odpowiednio `createdByUserId`, `completedByUserId`,
`acceptedByUserId` i `reviewedByUserId`. Nie pozostawiono pól aliasowych,
dual-read/write ani fallbacków.

Źródłem kontraktu były niezmieniane pliki Backend:

- `Contracts/Tasks/ProjectTaskResponse.cs` — `CreatedByUserId`;
- `Contracts/Tasks/TaskAcceptanceCriteriaContracts.cs` — `AcceptedByUserId`;
- `Contracts/Tasks/TaskTimeEntryContracts.cs` — `ReviewedByUserId`;
- kontrakty zadań i Kanbana — `CompletedByUserId`, `AssigneeUserId(s)` oraz
  `UserId`.

Wygenerowane artefakty `task_models.g.dart`, `task_models.freezed.dart`,
`task_advanced_models.g.dart` i `task_advanced_models.freezed.dart` zostały
odtworzone przez `build_runner`. Sprawdzono, że wire keys są dokładnie
camelCase Backendu, m.in. `createdByUserId`, `completedByUserId`,
`acceptedByUserId` i `reviewedByUserId`.

### Dowód zamknięcia aliasów

Polecenie:

```bash
rg -n -i "coreuser|readyuser|core_user|ready_user" \
  lib/workspaces/data/kanban \
  lib/workspaces/data/projects/tasks \
  lib/workspaces/domain/models/project_member_profile.dart \
  lib/workspaces/domain/models/task_project_realtime_update.dart \
  lib/workspaces/domain/repositories \
  lib/workspaces/presentation/tasks \
  test/workspaces/data/kanban \
  test/workspaces/data/projects/tasks \
  test/workspaces/presentation/tasks
```

Wynik: **0 dopasowań**. Jedyny pozostały import `package:ready_next` w
`lib/workspaces/domain/models/project_capabilities.dart` leży poza grafem
Tasks/Kanban i nie jest przez niego importowany; nie został przeniesiony w tym
pakiecie, aby nie rozszerzać zakresu na niezależny feature.

### Walidacja uzupełnienia

- `flutter test test/workspaces/presentation/tasks/tasks_board_cubit_test.dart`:
  **24/24 PASS**;
- `flutter test test/workspaces/presentation/tasks/task_details_cubit_test.dart`:
  **18/18 PASS**;
- `flutter test test/workspaces/data/projects/tasks/task_models_contract_test.dart`:
  **5/5 PASS**;
- wspólne uruchomienie powyższych testów: **47/47 PASS**;
- scoped `flutter analyze` dla modeli, API, repository i cubitów:
  zakończone kodem 0; pozostały wyłącznie informacje `directives_ordering`,
  bez błędów kompilacji/analitycznych;
- `git diff --check`: **PASS**.

Status I2a-identity: **complete** w uzgodnionym grafie. Integracja z nowym
routerem/shellem oraz Chat/Notifications pozostaje poza zakresem i nie jest
warunkiem tego pakietu.
