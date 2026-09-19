# I2o — odzyskanie trasy szczegółów zadania

Data: 2026-09-18  
Zakres: wyłącznie Front; bez zmian w repozytorium Backend.

## Wynik

Podłączono realny desktopowy pion:

`/workspaces/:workspaceId/projects/:projectId/tasks/:taskId`

Trasa wymaga trzech poprawnych UUID. Dla niepoprawnych identyfikatorów albo
braku bezpiecznej kompozycji transportu działa fail-closed. Nie ma danych
zastępczych ani placeholdera udającego szczegóły.

## Kontrakt backendu

Źródłem agregatu jest istniejący endpoint Retrofit `TasksApi.getTask`:

`GET /api/v1/workspaces/{workspaceId}/projects/{projectId}/tasks/{taskId}`

Istniejący ekran korzysta z typed repositories: `TasksRepository`, checklisty,
kryteriów akceptacji, collaboration, metadata, historii, harmonogramu,
recurrence, template, time tracking, milestone, attachment i storage.
Załączniki używają istniejących bulk-ticketów oraz presigned uploadu.

`TasksDetailsComposition.fromTransport` buduje adaptery z jednego
uwierzytelnionego desktopowego transportu. Wymaga
`supportsStandaloneApiClients` i dostawcy tokenu realtime. BFF/cookie nie może
utworzyć tej kompozycji, więc nie udostępnia szczegółów z fałszywymi danymi.

## Zmienione pliki

- `lib/workspaces/data/projects/tasks/tasks_details_composition.dart` — osobna
  kompozycja data dla szczegółów; UI nie zna Dio ani tokenów.
- `lib/workspaces/presentation/tasks/detail/tasks_details_route_page.dart` —
  granica presentation przekazująca typed repositories do istniejącego UI.
- `lib/app/router/devplanner_router.dart` — chroniona trasa, UUID guard i
  fail-closed dla BFF/braku kompozycji.
- `lib/workspaces/presentation/tasks/detail/**` — naprawione importy starego
  routera/core, zamykanie dialogów przez aktualny Flutter host oraz usunięta
  nieistniejąca zależność `AuthRepository` z preview załączników.
- `lib/workspaces/presentation/storage/preview/**` i `office/**` — usunięte
  importy `ready_next`, podpięte aktualne foundation i zachowane OnlyOffice oraz
  preview.
- `lib/workspaces/presentation/storage/browser/standalone/**` — uzupełnione
  jawne importy typów wymagane po regeneracji grafu.
- `test/workspaces/presentation/tasks/detail/tasks_details_route_page_test.dart`
  — testy kompozycji, loading, UUID guard i odrzucenia BFF.

Widget route page ma poniżej 400 linii. Logika API pozostaje w data/repository,
bez globalnego stanu i bez żądań HTTP w UI.

## Walidacja

Wykonano regenerację kodu Retrofit/Freezed oraz:

```text
flutter analyze lib/app/router/devplanner_router.dart lib/workspaces/data/projects/tasks/tasks_details_composition.dart lib/workspaces/presentation/tasks/detail lib/workspaces/presentation/storage/preview lib/workspaces/presentation/storage/office test/workspaces/presentation/tasks/detail/tasks_details_route_page_test.dart
flutter test test/workspaces/presentation/tasks/detail/tasks_details_route_page_test.dart test/app/router/devplanner_router_test.dart --reporter compact
git diff --check
```

Wynik: analyzer bez uwag, wszystkie testy w obu plikach zielone. Regeneracja
usunęła `InvalidType` z używanych przez szczegóły API schedule i time-tracking.

## Pozostały odbiór

Trasa przywraca istniejący pełny ekran szczegółów, ale przed wydaniem trzeba
wykonać manualny desktop flow z działającym backendem: odczyt, zapis, konflikt
wersji, ACL, upload załącznika, preview i historia. Ten batch nie uruchamiał
backendu ani MinIO.

Przepięcie wszystkich kart/wierszy listy na `DevPlannerRouteCatalog.task`,
dalsze usuwanie historycznych importów `core` oraz Chat/Notifications jako
overlaye pozostają osobnymi batchami.
