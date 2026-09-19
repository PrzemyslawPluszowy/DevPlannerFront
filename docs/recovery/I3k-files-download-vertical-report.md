# I3k — desktopowe pobieranie pojedynczego pliku

## Zakres

Dodano zamknięty pion pobierania pojedynczego pliku w standalone Files. Kontrakt
już istniał i został wykorzystany bez zmian backendu:

- `StorageRepository.getDownloadTicket(fileId)` wydaje krótkotrwały bilet;
- `DownloadTransport.downloadUrl(...)` zapisuje plik przez istniejący adapter
  platformowy;
- desktopowy adapter zapisuje do systemowego katalogu `Downloads`, z nazwą
  kolizyjną rozszerzaną o licznik;
- `StorageFileMutationCubit.downloadFile` pozostaje właścicielem logiki biletu,
  transportu i typowanego błędu.

Nie dodano ręcznego URL-a, browserowego zapisu ani ścieżki wymyślonej w UI.

## Zmiany

- `StorageReadOnlyBrowserPage` dostał niezależną flagę `allowDownload`.
- `StorageReadOnlyFileTile` pokazuje akcję tylko wtedy, gdy jednocześnie:
  composition ją włączyła i odpowiedź backendu ma `file.canDownload == true`.
- BFF/read-only może nadal dostarczać listę i preview, ale bez providera mutacji
  i bez przycisku pobierania.
- Feedback po sukcesie pokazuje nazwę pliku i nie odświeża listy; błąd zachowuje
  kod HTTP i korzysta z istniejącego mapowania komunikatów.
- Dodano komunikat `storageDownloadSuccess` w polskim i angielskim ARB.

## Integracja composition root

Router przekazuje `allowDownload: desktopUpload` razem z istniejącym
`DownloadTransportImpl`. `desktopUpload` jest prawdziwą bramką: wymaga
desktopowego transportu z providerem Bearer i wyklucza BFF cookie transport.
Test routingu potwierdza obecność akcji na desktopie oraz jej brak w BFF.

## Walidacja

```text
flutter gen-l10n
flutter analyze lib/workspaces/presentation/storage/browser/standalone \
  lib/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart \
  lib/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart
No issues found

flutter test test/workspaces/presentation/storage/browser/storage_download_vertical_test.dart
3 tests passed

flutter test test/app/router/devplanner_router_test.dart
12 tests passed

git diff --check
PASS
```

Testy obejmują: wydanie biletu i wywołanie transportu, brak akcji w trybie
BFF/read-only oraz typowany błąd 403 bez wywołania transportu.
