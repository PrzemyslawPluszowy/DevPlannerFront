# I3m — desktopowe udostępnianie plików

## Zakres

Ten batch przywraca bezpieczny, desktopowy pion zarządzania udostępnieniami
plików. Nie dodaje trasy ani osobnego ekranu. Kontrolka otwiera dialog nad
istniejącym browserem Files, zgodnie z zasadą, że operacje kontekstowe nie
tworzą kolejnej strony.

Obsługiwany zakres potwierdzony aktualnym kontraktem Storage:

- odczyt aktywnych grantów pliku,
- udostępnienie całemu workspace,
- udostępnienie projektowi, gdy odpowiedź pliku zawiera `projectId`,
- cofnięcie istniejącego grantu po potwierdzeniu,
- odświeżenie browsera dopiero po pozytywnej odpowiedzi mutacji.

## Kontrakt backendu

Frontend korzysta z istniejących metod `StorageRepository` i `StorageApi`:

- `GET /api/v1/storage/files/{fileId}/shares`,
- `POST /api/v1/storage/files/{fileId}/shares`,
- `DELETE /api/v1/storage/files/{fileId}/shares/{shareId}`.

Capability `StorageFileResponse.canShare` jest jedynym źródłem decyzji o
możliwości udostępnienia. Nie jest zastępowana lokalną heurystyką.

## Ważne ograniczenie

Nie przywrócono wyszukiwania użytkowników. Dotychczasowy selektor korzystał z
`WorkspacesRepository.searchReadyUsers`, typów `ReadyDirectoryUserResponse` i
pola `coreUserId`, czyli z katalogu Ready/Core. To narusza standalone DevPlanner
i nie ma jeszcze równoważnego kontraktu katalogu użytkowników w nowym backendzie.
Nie dodano więc atrap, ręcznego wpisywania niezweryfikowanego ID ani fałszywego
stanu udostępnienia. Po dostarczeniu nowego endpointu katalogu użytkowników
można dodać osobny pion user-share z tym samym repozytorium/Cubitem.

## Zmienione pliki

- `lib/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart`
  — migracja importów do `devplanner`, callback odświeżenia po potwierdzonej
  mutacji oraz zachowanie kodu HTTP jako fallbacku, gdy backend nie wysyła
  `backendCode`.
- `lib/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart`
  — migracja modelu do standalone `devplanner`.
- `lib/workspaces/presentation/storage/browser/standalone/storage_share_action.dart`
  — capability-gated akcja desktopowa.
- `lib/workspaces/presentation/storage/sharing/standalone/storage_desktop_sharing_dialog.dart`
  — dialog workspace/projekt/lista grantów/cofnięcie; bez HTTP w UI i bez Ready.
- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_file_tile.dart`
  — opcjonalna akcja sharingu składana tylko przez composition root.
- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart`
  — `allowSharing` (domyślnie `false`) i przekazanie repozytorium/callbacku.
- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_content.dart`
  — wydzielenie listy browsera z page; oba pliki są poniżej limitu 400 linii.
- `test/workspaces/presentation/storage/browser/storage_sharing_vertical_test.dart`
  — testy BFF/read-only, capability, potwierdzenia, payloadu workspace i
  typowanego błędu 403.

## Integracja composition root

Desktopowy route composition przekazuje już:

```dart
allowSharing: desktopStorageComposition,
```

W aktualnym routerze jest to ta sama, zweryfikowana bramka co upload/download:
`_desktopStorageUploadComposition`. Web/BFF pozostawia `allowSharing: false`.
Sam page ma bezpieczną wartość domyślną `false`, dlatego kontrolka nie może
pojawić się przypadkiem poza desktopowym standalone API.

Test routera sprawdza oba przypadki: desktop z bearer transportem renderuje
`share-file-file-router-1`, a BFF nie renderuje tej kontrolki.

## Walidacja

```text
flutter analyze lib/workspaces/presentation/storage/browser/standalone \
  lib/workspaces/presentation/storage/sharing/cubit \
  lib/workspaces/presentation/storage/sharing/standalone \
  test/workspaces/presentation/storage/browser/storage_sharing_vertical_test.dart
```

Wynik: `No issues found!`

```text
flutter test test/workspaces/presentation/storage/browser/storage_sharing_vertical_test.dart --reporter compact
```

Wynik: `3 tests passed`.

```text
flutter test test/app/router/devplanner_router_test.dart --reporter compact
```

Wynik: `9 tests passed`, w tym desktop/BFF sharing composition.

```text
wc -l lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart
wc -l lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_content.dart
```

Wynik: odpowiednio 266 i 219 linii.
