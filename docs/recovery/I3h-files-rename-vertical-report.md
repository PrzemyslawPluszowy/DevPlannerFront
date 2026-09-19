# I3h — rename w workspace Files

## Zakres wykonany

Zrealizowano desktopowy rename istniejącego folderu w realnej trasie
`/workspaces/:workspaceId/files`:

- `StorageFolderRenameAction` używa istniejącego
  `StorageFolderMutationCubit.renameFolder`;
- wywołanie trafia do typowanego `StorageRepository.updateFolder`;
- po potwierdzonym `StorageFolderMutationSuccess(updated)` lista odświeża się
  dokładnie raz;
- błędy `403`, `404`, `409` i `400/422` są mapowane przez ARB;
- stan błędu zachowuje status HTTP, backend code i komunikat, a UI nie udaje
  sukcesu;
- BFF/read-only nie dostaje kontroli rename;
- nie dodano delete, move, share, version ani OnlyOffice.

## Plik — jawna blokada kontraktu

Rename pliku nie został udawany ani zaimplementowany przez
`updateFileDescription`. Aktualny lokalny kontrakt `StorageRepository`/`StorageApi`
udostępnia dla pliku opis, favorite, delete i restore, ale nie operację zmiany
`originalFileName`/nazwy pliku. Backend `StorageEndpoints` również ma tylko
`PUT /api/v1/storage/files/{fileId}/description` dla tej części kontraktu.

Ponieważ zadanie zabrania zmian Backend i nie wolno mapować zmiany nazwy na
zmianę opisu, file rename pozostaje jawnie odroczony do momentu dostarczenia
autorytatywnego endpointu i typowanego portu. Nie ma przycisku, który dawałby
fałszywy sukces.

## Zmienione miejsca

- `lib/workspaces/presentation/storage/browser/standalone/storage_folder_create_action.dart`
  — feedback mutacji, create oraz rename folderu;
- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart`
  — desktop-only provider/flag i akcja rename przy folderach z `canEdit`;
- `lib/app/router/devplanner_router.dart` — przekazanie
  `allowFolderRename` wyłącznie dla bezpiecznego desktop transportu;
- `lib/l10n/app_{en,pl}.arb` oraz wygenerowane `app_localizations*` — sukces,
  not-found, konflikt i walidacja rename;
- `test/workspaces/presentation/storage/browser/storage_folder_rename_vertical_test.dart`
  — success/refresh exactly once, read-only gate i 403/404/409/422.

## Walidacja

Analyzer zakresowy:

```text
flutter analyze [7 plików I3h]
No issues found! (ran in 6.9s)
```

Testy I3h/I3g/router/upload:

```text
flutter test \
  test/workspaces/presentation/storage/browser/storage_folder_create_vertical_test.dart \
  test/workspaces/presentation/storage/browser/storage_folder_rename_vertical_test.dart \
  test/app/router/devplanner_root_router_compile_test.dart \
  test/workspaces/presentation/storage/browser/storage_upload_vertical_test.dart
```

Wynik: **25/25 PASS**. Sam test rename: **6/6 PASS**.

```text
flutter build macos --debug
```

Wynik: **PASS**, `DevPlanner.app` zbudowana. Pozostaje istniejące ostrzeżenie
pluginów `media_kit_*` o braku Swift Package Manager.

Direct graph I3h nie zawiera importów `package:ready_next` ani
`package:devplanner/core`; `git diff --check` jest czysty.

