# I2r — wydzielenie checklisty i współpracy z `TaskDetailsCubit`

## Zakres

Ten etap dotyczył wyłącznie pionu szczegółów zadania. Nie zmieniał Chat,
Powiadomień, Plików ani routingu. Zachowano publiczne metody
`TaskDetailsCubit`, więc istniejące widoki nie wymagają migracji w tym batchu.

## Wykonane zmiany

Przed zmianą główny Cubit miał 1041 linii. Po wcześniejszych, zaakceptowanych
wydzieleniach (kryteria akceptacji, zależności i podstawowe mutacje) oraz tym
batchu ma **950 linii**.

Dodano:

- `lib/workspaces/presentation/tasks/detail/cubit/task_details_checklist_service.dart`
  — waliduje tytuł, normalizuje dane i wywołuje typowane operacje add/update/delete
  repozytorium checklisty;
- `lib/workspaces/presentation/tasks/detail/cubit/task_details_collaboration_service.dart`
  — obsługuje wykonawców, obserwowanie i osobiste przypięcie zadania.

`TaskDetailsCubit` nadal odpowiada za blokadę zapisu, mapowanie odpowiedzi do
`TaskDetailsReady`, obsługę konfliktu wersji i odświeżenie agregatu. Serwisy nie
mają dostępu do stanu UI i nie wykonują HTTP bezpośrednio — korzystają z
istniejących kontraktów repository.

## Mapa odpowiedzialności

| Odpowiedzialność | Właściciel |
|---|---|
| Payloady i transport checklisty | `TaskDetailsChecklistService` |
| Payloady i transport współpracy | `TaskDetailsCollaborationService` |
| Stan `isSaving`, błędy i konflikt optimistic concurrency | `TaskDetailsCubit` |
| Scalenie checklisty/wersji z detailem | `TaskDetailsCubit` |
| Kontrakt backendu | `TaskChecklistRepository`, `TaskCollaborationRepository` |

## Walidacja

Wykonano:

```text
flutter analyze lib/workspaces/presentation/tasks/detail/cubit \
  lib/workspaces/presentation/tasks/detail \
  test/workspaces/presentation/tasks/detail
```

Wynik: `No issues found!`.

```text
flutter test test/workspaces/presentation/tasks/detail \
  test/workspaces/presentation/tasks/task_details_cubit_test.dart --reporter compact
```

Wynik: wszystkie 39 testów zakończone powodzeniem.

```text
flutter test test/workspaces/presentation/tasks/detail/task_details_checklist_collaboration_service_test.dart --reporter compact
git diff --check
```

Wynik: 3 testy serwisów zakończone powodzeniem, brak błędów whitespace.

## Pozostała dekompozycja Cubita

950 linii nadal przekracza limit projektu (`<400`). Nie należy sztucznie
przenosić kodu tylko po to, żeby zmniejszyć licznik. Bezpieczne kolejne batche
to:

1. wydzielenie `TaskDetailsMetadataService` dla etykiet i pól własnych;
2. wydzielenie adaptera scalania odpowiedzi checklisty, kryteriów i zależności
   (czyste funkcje domenowe jako metody typowanej klasy, bez globalnych funkcji);
3. wydzielenie `TaskDetailsMutationCoordinator` dla wspólnego lifecycle
   `isSaving`/konflikt/odświeżenie, z zachowaniem stanu w Cubicie;
4. osobne wydzielenie ładowania i mapowania błędów (`TaskDetailsLoadService`);
5. dopiero po migracji wszystkich konsumentów usunięcie kompatybilnych wrapperów
   z Cubita i zejście poniżej 400 linii.

Każdy kolejny batch powinien zachować istniejące metody publiczne albo wykonać
kontrolowaną migrację widoków z testami. Nie obejmuje to jeszcze brakujących
subfunkcji detalu ani overlayów Chat/Powiadomienia.
