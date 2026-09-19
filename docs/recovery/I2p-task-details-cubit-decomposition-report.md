# I2p — dekompozycja `TaskDetailsCubit`

Data: 2026-09-18  
Zakres: Front, wyłącznie pion szczegółów zadania.

## Cel i wynik

`TaskDetailsCubit` był godnym osobnego audytu blokiem o długości 1041 linii.
Pierwszy bezpieczny krok wydzielił logikę use-case’ów poza Cubit bez zmiany
kontraktu UI ani zachowania ekranu:

- `TaskDetailsBasicMutationService` przejął budowanie payloadów i endpointy
  podstawowej edycji, planowania, opisu, archiwizacji i podzadań;
- `TaskDetailsDependenciesService` przejął walidację oraz typed API relacji
  między zadaniami (wyszukiwanie, create, update, delete);
- istniejący `TaskAcceptanceCriteriaService` został utrzymany jako osobny
  use-case kryteriów akceptacji.

Główny Cubit ma teraz **965 linii**. UI nadal wywołuje te same metody Cubita,
więc ten batch nie zmienia nawigacji, widoków ani sposobu obsługi błędów.

## Mapa odpowiedzialności po batchu

`TaskDetailsCubit` nadal jest właścicielem:

- stanu `initial/loading/failure/ready` i snapshotu `ProjectTaskDetailsResponse`;
- kontroli `isSaving`, numeru mutacji i konfliktów wersji;
- scalania potwierdzonych odpowiedzi z bieżącym snapshotem;
- operacji checklisty, collaboration, labels/custom fields oraz obsługi
  zależności po otrzymaniu wyniku use-case.

`TaskDetailsBasicMutationService` posiada wyłącznie kontrakt data/use-case:

- tworzenie `UpdateProjectTaskPayload` z bieżącego taska;
- update podstawowy, planowanie i opis;
- archive/restore oraz quick-create subtask.

`TaskDetailsDependenciesService` posiada wyłącznie:

- normalizację wyszukiwania i query listy zadań;
- zakres lagów `-365..365`, blokadę relacji taska z samym sobą;
- payloady i wywołania typed repository relacji.

Żaden z serwisów nie zna Fluttera, `BuildContext`, widgetów, routingu ani
globalnego stanu.

## Pliki

- `lib/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart` —
  Cubit skrócony do orkiestracji stanu i scalania odpowiedzi.
- `lib/workspaces/presentation/tasks/detail/cubit/task_details_basic_mutation_service.dart` —
  use-case podstawowych mutacji.
- `lib/workspaces/presentation/tasks/detail/cubit/task_details_dependencies_service.dart` —
  use-case relacji zadań.
- `lib/workspaces/presentation/tasks/detail/cubit/task_acceptance_criteria_service.dart` —
  wcześniejszy wydzielony use-case kryteriów.
- `test/workspaces/presentation/tasks/detail/task_acceptance_criteria_service_test.dart` —
  test normalizacji, wersji i blokady pustej wartości.

## Walidacja

```text
flutter analyze lib/workspaces/presentation/tasks/detail/cubit lib/workspaces/presentation/tasks/detail test/workspaces/presentation/tasks/detail
flutter test test/workspaces/presentation/tasks/detail --reporter compact
git diff --check
```

Wynik: analyzer bez uwag, **21 testów** pionu szczegółów zaliczonych, diff bez
błędów formatowania.

## Następne bezpieczne batch’e

Nie przenosić kilku grup naraz. Kolejność do dalszego review:

1. `TaskDetailsCubit` — checklist use-case (add/update/delete) z zachowaniem
   kontroli wersji i lokalnego scalania listy;
2. collaboration (watch/pin/assignees) jako osobny use-case, ponieważ ma
   inny kontrakt osobistej preferencji i współdzielonej wersji;
3. metadata (labels/custom fields) jako osobny use-case;
4. dependencies — przeniesienie samego scalania relacji do typed state Cubita,
   dopiero po testach regresji UI;
5. końcowy podział stanu głównego na loader i mutation coordinator, jeśli po
   wcześniejszych batchach nadal przekracza limit uzgodniony dla Cubitów.

Każdy kolejny batch musi zachować istniejące publiczne metody do czasu migracji
odpowiednich widgetów, mieć własny raport po polsku i uruchamiać scoped analyze
oraz testy. Nie zmieniano `task_details_properties.dart`; jego refaktor jest
oddzielnym zadaniem.
