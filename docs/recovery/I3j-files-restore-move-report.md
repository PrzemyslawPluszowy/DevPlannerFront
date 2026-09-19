# I3j — Files: restore i granica operacji move

## Status

I3j został zamknięty jako bounded vertical dla standalone Files. Przywracanie
usuniętego pliku jest dostępne wyłącznie w kompozycji desktopowej. Operacja
move nie została udawana ani dopisana bez bezpiecznego kontraktu wyboru celu.

## Potwierdzone kontrakty

- `StorageRepository.restoreFile(fileId)` wywołuje
  `POST /api/v1/storage/files/{fileId}/restore`.
- `StorageRepository.moveFolder(folderId, newParentFolderId)` wywołuje
  `POST /api/v1/storage/folders/{folderId}/move`.
- Dla pliku istnieje `createFilePlacement` i `deleteFilePlacement`, ale lista
  `StorageFileResponse` nie zwraca `placementId`, a szczegóły pliku nie
  zawierają listy placementów. Nie da się więc bezpiecznie zrealizować
  semantyki „przenieś plik” bez ryzyka pozostawienia starego placementu albo
  utworzenia duplikatu.

## Dostarczona implementacja

- Dodano `StorageFileRestoreAction` z potwierdzeniem i anulowaniem.
- Akcja jest widoczna tylko gdy composition root ją dopuści, plik ma
  `isDeleted == true` oraz backend zwróci `canRestore == true`.
- Wykonanie przechodzi przez istniejący `StorageFileMutationCubit` i
  `StorageRepository`; UI nie zna HTTP, Dio, tokenów ani storage.
- Po potwierdzonym sukcesie lista jest odświeżana dokładnie raz i pojawia się
  komunikat lokalizowany PL/EN.
- BFF/read-only nie dostaje `StorageFileMutationCubit`, więc restore nie jest
  dostępny bez desktopowego transportu.
- Błędy 403/404/409/400/422 pozostają mapowane przez istniejącą granicę
  feedbacku, bez komunikatu sukcesu przy odpowiedzi błędnej.

## Dlaczego move jest odłożone

Folder move wymaga bezpiecznego picker'a celu (lista dostępnych folderów,
wykluczenie bieżącego folderu i jego potomków, ACL `canEdit`, obsługa folderu
root oraz konfliktu). Plik move wymaga dodatkowo pobrania placementów i
atomowej zmiany placementu. Obecna strona standalone nie ma takiego kontraktu
UI ani modelu placementów. Następny batch powinien:

1. dodać endpoint read-only `GET .../files/{fileId}/placements` albo zwrócić
   placementy w szczegółach pliku;
2. dodać atomowy endpoint `POST .../files/{fileId}/move` (albo jasno
   zdefiniowany command z `sourcePlacementId` i `targetFolderId`);
3. dodać repozytoryjny `StorageMoveTargetRepository` z ACL i cyklem życia
   folderów;
4. zbudować modal picker'a celu z blokadą cyklicznego przeniesienia,
   potwierdzeniem, stanem loading oraz mapowaniem 403/404/409/400/422;
5. dopiero wtedy podłączyć akcję w desktop composition, pozostawiając BFF
   read-only.

## Walidacja

- `flutter gen-l10n` — OK.
- `flutter analyze lib/workspaces/presentation/storage/browser/standalone lib/workspaces/presentation/storage/browser/mutations/cubit lib/workspaces/presentation/storage/shared/storage_formatters.dart test/workspaces/presentation/storage/browser/storage_delete_vertical_test.dart` — 0 issues.
- `flutter test test/workspaces/presentation/storage/browser/storage_delete_vertical_test.dart --reporter compact` — 10 tests passed.
- `git diff --check` — OK.
- Skan zmienionych plików standalone/testów: brak `package:ready_next` i bezpośrednich importów `package:devplanner/core`.

## Ograniczenia

Nie zmieniano routera, shell'a, Tasks, Chat, Notifications ani Backend. W
routerze desktopowa kompozycja nadal przekazuje `allowDeletion`, dlatego ten
sam bezpieczny desktop gate umożliwia restore; BFF przekazuje brak transportu
i pozostaje read-only.
