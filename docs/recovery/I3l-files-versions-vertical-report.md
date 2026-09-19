# I3l — historia wersji plików (desktop)

## Cel

Przywrócono bezpieczny pion historii wersji pliku w nowej, samodzielnej aplikacji
DevPlanner. Funkcja korzysta wyłącznie z potwierdzonych kontraktów Storage i jest
składana z poziomu desktopowego composition root. Nie dodano atrap odpowiedzi ani
wywołań HTTP w widokach.

## Potwierdzony kontrakt backendu

Istniejące `StorageApi` oraz `StorageRepository` mają komplet wymaganych operacji:

- `GET /api/v1/storage/files/{fileId}/versions` — lista wersji;
- `GET /api/v1/storage/files/{fileId}/versions/{version}/download-ticket` — bilet
  pobrania wersji;
- `POST /api/v1/storage/files/{fileId}/versions/{version}/restore` — przywrócenie
  wersji z `expectedVersion` i opcjonalnym opisem zmiany.

Repozytorium mapuje odpowiedzi i błędy przez `ApiRepository.guardApiCall`. Nie
zmieniano Backend ani kontraktu API.

## Zmiany

- Usunięto zależności `package:ready_next` z pionu `presentation/storage/versions`.
- Dialog `StorageVersionsDialog` przyjmuje jawnie `StorageRepository` i
  `DownloadTransport`; nie pobiera zależności z globalnego providera i nie tworzy
  transportu w warstwie UI.
- `StorageVersionsCubit` realizuje listowanie, pobranie biletu i przywrócenie
  przez repozytorium, z blokadą równoległej operacji i typowanym stanem błędu.
- `StorageReadOnlyFileTile` dostał capability gate `canManageVersions` oraz
  przycisk historii widoczny tylko, gdy jednocześnie composition i backend ACL
  (`file.canManageVersions`) na to pozwalają.
- Po potwierdzonym restore lista Files odświeża się dokładnie przez właściciela
  przeglądarki. Błąd nie powoduje fałszywego odświeżenia.
- `DevPlannerRouter` włącza zarządzanie wersjami wyłącznie dla desktopowego
  standalone transportu. BFF/web nie przekazuje capability ani transportu
  pobierania, więc nie renderuje akcji.

## Testy

Dodano `storage_versions_vertical_test.dart`, obejmujący:

- brak akcji w wariancie BFF/read-only i przy braku ACL;
- wywołanie prawdziwego kontraktu repozytorium przez Cubit dla listy, pobrania i
  restore;
- przekazanie biletu do `DownloadTransport`;
- błąd 403 jako typowany stan bez użycia transportu.

Weryfikacja:

```text
flutter analyze lib/workspaces/presentation/storage/versions \
  lib/workspaces/presentation/storage/browser/standalone
No issues found!

flutter test test/workspaces/presentation/storage/browser/storage_versions_vertical_test.dart
All tests passed! (3 tests)

flutter test test/workspaces/presentation/storage/browser/storage_read_only_browser_page_test.dart \
  test/workspaces/presentation/storage/browser/storage_download_vertical_test.dart \
  test/workspaces/presentation/storage/browser/storage_folder_create_vertical_test.dart \
  test/workspaces/presentation/storage/browser/storage_folder_rename_vertical_test.dart \
  test/workspaces/presentation/storage/browser/storage_delete_vertical_test.dart
All tests passed! (27 tests)

git diff --check
passed
```

Po review usunięto cztery redundantne argumenty domyślne w teście pionowym;
ponowny analyzer obejmujący produkcyjny pion, standalone Files i test zwrócił
`No issues found!`.

Skan zmienionego pionu nie wykazał importów `ready_next` ani bezpośrednich
importów `core`.

## Pozostałe ograniczenia

Nie wykonano jeszcze ręcznego E2E z uruchomionym backendem i MinIO. To jest
osobny etap walidacji środowiskowej. Nie dodano obsługi historii wersji do
BFF/web, zgodnie z zasadą, że BFF pozostaje read-only bez standalone download
transportu.
