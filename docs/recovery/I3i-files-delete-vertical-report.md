# I3i — usuwanie elementów Files (desktop)

## Status

Zamknięta pionowa funkcja dla usuwania pojedynczego folderu i pliku do kosza.
Implementacja nie dodaje nowego kontraktu backendowego: korzysta z istniejących
kontraktów `DELETE /api/v1/storage/folders/{folderId}` oraz
`DELETE /api/v1/storage/files/{fileId}` obecnych w `StorageApi` i
`StorageRepository`.

## Zakres implementacji

- `StorageFolderDeleteAction` i `StorageFileDeleteAction` wymagają jawnego
  potwierdzenia w dialogu.
- Akcja jest pokazywana wyłącznie, gdy jednocześnie:
  - kompozycja desktopowa ustawi `allowDeletion: true`,
  - rekord backendu ma `canDelete: true`.
- `StorageFolderMutationCubit.deleteFolder` i
  `StorageFileMutationCubit.deleteFile` wykonują operację przez repozytorium;
  widoki nie znają HTTP ani Dio.
- Odświeżenie listy następuje dokładnie raz i wyłącznie po potwierdzonym
  sukcesie backendu.
- BFF/read-only nie dostaje Cubitów mutacji ani kontrolek usuwania.
- Błędy `403`, `404`, `409`, `400/422` są mapowane na lokalizowane komunikaty;
  pozostałe błędy zachowują bezpieczny komunikat transportu.

## Pliki

- `lib/workspaces/presentation/storage/browser/standalone/storage_delete_actions.dart`
- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_file_tile.dart`
- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart`
- `lib/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart`
- `lib/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart`
- `lib/l10n/app_pl.arb`
- `lib/l10n/app_en.arb`
- `test/workspaces/presentation/storage/browser/storage_delete_vertical_test.dart`

## Walidacja

Wykonano w katalogu Front:

```text
flutter gen-l10n
flutter analyze lib/workspaces/presentation/storage/browser/standalone/storage_delete_actions.dart lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart lib/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart lib/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart test/workspaces/presentation/storage/browser/storage_delete_vertical_test.dart
flutter test test/workspaces/presentation/storage/browser/storage_delete_vertical_test.dart --reporter compact
rg -n "package:devplanner/core|package:ready_next|InvalidType" <zmienione-pliki-pionu>
git diff --check
```

Rezultat: analyzer bez problemów, `flutter gen-l10n` zakończone poprawnie,
8 testów pionu przechodzi, skan zależności legacy pusty, `git diff --check`
bez uwag.

## Świadome ograniczenia

To jest soft-delete zgodny z istniejącym API. Przywracanie, kosz, usuwanie
masowe, przenoszenie i wersjonowanie pozostają osobnymi pionami. Nie dodano
lokalnego/fikcyjnego usuwania ani mapowania `updateFileDescription` na zmianę
nazwy pliku.
