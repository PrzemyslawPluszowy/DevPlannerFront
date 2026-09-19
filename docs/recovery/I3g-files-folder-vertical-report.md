# I3g — tworzenie folderu w workspace Files

## Zakres

Dodano wyłącznie pion tworzenia folderu dla realnej trasy
`/workspaces/:workspaceId/files`:

- desktopowa kompozycja trasy przekazuje `allowFolderCreation` razem z
  istniejącym bezpiecznym pickerem i transportem uploadu;
- `StorageFolderMutationCubit` jest tworzony w page composition tylko przy
  jawnym zezwoleniu composition rootu;
- nowa akcja otwiera dialog nazwy, wywołuje istniejący typed
  `StorageRepository.createFolder`, pokazuje sukces i odświeża listę dopiero po
  stanie `StorageFolderMutationSuccess(created)`;
- błędy `403`, `409` oraz `400/422` są mapowane przez ARB na odpowiednio brak
  uprawnień, konflikt nazwy i błąd walidacji; stan Cubitu zachowuje status HTTP,
  kod backendu i komunikat;
- webowy BFF pozostaje read-only: nie dostaje Cubitu ani przycisku tworzenia
  folderu.

Nie dodano delete, rename ani move. Nie zmieniano Backend, Chat, Notifications
ani shell.

## Pliki

- `lib/workspaces/presentation/storage/browser/standalone/storage_folder_create_action.dart`
  — dialog, typed error mapping i listener sukcesu;
- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart`
  — jawna kompozycja Cubitu oraz akcja w bieżącym scope;
- `lib/app/router/devplanner_router.dart` — przekazanie flagi wyłącznie dla
  desktopowego standalone transportu;
- `lib/l10n/app_{en,pl}.arb` oraz wygenerowane `app_localizations*` — sukces,
  konflikt i walidacja;
- `test/workspaces/presentation/storage/browser/storage_folder_create_vertical_test.dart`
  — sukces/refresh oraz typed 403/409/422;
- `test/app/router/devplanner_root_router_compile_test.dart` — desktop action
  enabled i BFF fail-closed.

## Dowody

Analyzer zakresowy:

```text
flutter analyze [7 plików I3g]
No issues found! (ran in 10.0s)
```

Test pionu folderów:

```text
flutter test \
  test/workspaces/presentation/storage/browser/storage_folder_create_vertical_test.dart
```

Wynik: **4/4 PASS**.

Testy routera, uploadu, browsera i mutacji Storage:

```text
flutter test \
  test/app/router/devplanner_root_router_compile_test.dart \
  test/workspaces/presentation/storage/browser/storage_upload_vertical_test.dart \
  test/workspaces/presentation/storage/browser/storage_read_only_browser_page_test.dart \
  test/workspaces/presentation/storage/storage_mutations_and_upload_test.dart
```

Wynik: **25/25 PASS**. Dodatkowa ponowna walidacja routera po dopisaniu
assertions desktop/BFF: **9/9 PASS**.

Build:

```text
flutter build macos --debug
```

Wynik: **PASS**, `DevPlanner.app` zbudowana. Pozostało istniejące ostrzeżenie
pluginów `media_kit_*` o braku Swift Package Manager.

Direct graph I3g nie zawiera importów `package:ready_next` ani
`package:devplanner/core`; `git diff --check` jest czysty.

