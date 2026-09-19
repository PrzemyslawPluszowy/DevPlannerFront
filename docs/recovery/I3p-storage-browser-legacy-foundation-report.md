# I3p — migracja fundamentu przeglądarki Files do DevPlanner

## Zakres

Usunięto zależność od pakietu `ready_next` z aktywnego fundamentu przeglądarki
plików: siatki, listy, zaznaczania, menu wspólnych, toolbaru oraz nagłówka
przeglądarki. Zakres nie obejmuje routingu, czatu, powiadomień ani migracji
funkcji publicznego udostępniania.

## Wykonane zmiany

| Stary kontrakt | Nowy kontrakt | Cel |
|---|---|---|
| `ready_next/core/l10n/l10n_extensions.dart` | `devplanner/foundation/l10n/l10n.dart` | Lokalny kontrakt `context.l10n` |
| `ready_next/core/theme/theme.dart` | `devplanner/foundation/theme/theme.dart` | Motyw i tokeny `context.text`/`context.colors` |
| `ready_next/shared/presentation/icons/app_icons.dart` | `devplanner/shared/presentation/icons/app_icons.dart` | Ikony produktu |
| `ready_next/shared/presentation/widgets/*` | `devplanner/shared/presentation/widgets/*` | Menu kontekstowe i wspólne widżety |
| `ready_next/workspaces/*` | `devplanner/workspaces/*` | Modele, Cubity i komponenty Files |
| `ready_next/app/shell/overlay/app_modal_host.dart` | `devplanner/foundation/presentation/devplanner_modal_host.dart` | Dialogi i dolne arkusze w nowej powłoce |

`AppModalHost` został zastąpiony przez `DevPlannerModalHost`, ale zachowano
semantykę dialogu podglądu oraz dolnego menu akcji pliku. Po zmianie kontraktu
historii wersji do wywołań menu dodano jawne `StorageRepository` i
`DownloadTransport`, dzięki czemu przywracanie i pobieranie wersji nadal używa
tego samego repozytorium backendu.

Zachowane zachowania użytkowe:

- widok kafelkowy i listowy plików oraz folderów;
- zaznaczanie pojedyncze/wielokrotne, skróty klawiaturowe i pasek akcji;
- menu kontekstowe pliku/folderu, podgląd i akcje ulubionych;
- pobieranie, kosz, przywracanie i historia wersji;
- udostępnianie pliku przez istniejący dialog;
- breadcrumbs, filtr, wyszukiwanie, odświeżanie i akcje toolbaru;
- tworzenie i zmiana nazwy folderu oraz obsługa uploadu przez istniejące Cubity.

Migracja companion Cubitów w `browser/cubit` i `browser/mutations` była
import-only i wynikała z konieczności zapewnienia, aby aktywny fundament nie
przenosił zależności `ready_next` przez bezpośrednie zależności komponentów.
Nie zmieniono ich logiki domenowej.

## Kontrola jakości

- `flutter analyze lib/workspaces/presentation/storage/browser
  lib/workspaces/presentation/storage/browser/storage_browser_header.dart`
  — **No issues found**.
- Po review rozszerzono kontrolę do całego zachowanego testowego zakresu:
  `flutter analyze lib/workspaces/presentation/storage/browser
  test/workspaces/presentation/storage/browser` — **No issues found**.
- Skan zakresu:
  `rg -n 'package:ready_next|package:devplanner/core'
  lib/workspaces/presentation/storage/browser
  test/workspaces/presentation/storage/browser` — brak wyników.
- Testy:
  `flutter test test/workspaces/presentation/storage/storage_browser_cubit_test.dart
  test/workspaces/presentation/storage/browser/storage_read_only_browser_page_test.dart
  test/workspaces/presentation/storage/browser/grid/storage_file_grid_modal_host_test.dart
  test/workspaces/presentation/storage/browser/storage_delete_vertical_test.dart
  test/workspaces/presentation/storage/browser/storage_download_vertical_test.dart
  test/workspaces/presentation/storage/browser/storage_folder_create_vertical_test.dart
  test/workspaces/presentation/storage/browser/storage_folder_rename_vertical_test.dart
  test/workspaces/presentation/storage/browser/storage_upload_vertical_test.dart
  test/workspaces/presentation/storage/browser/storage_versions_vertical_test.dart
  test/workspaces/presentation/storage/browser/storage_sharing_vertical_test.dart`
  — **49 testów, wszystkie zaliczone**.
- `dart fix --apply --code directives_ordering` uporządkował importy w 11
  plikach produkcyjnych oraz w migrowanym teście.
- Test `storage_file_grid_modal_host_test.dart` został zmigrowany z
  `ready_next` do lokalnych kontraktów DevPlanner; nie usunięto żadnego
  scenariusza rootowego dialogu/bottom sheeta.
- `StorageBrowserCubit` został rozdzielony według odpowiedzialności:
  odczyt `currentScope`, `currentViewMode`, `currentFilter` i `currentSort`
  znajduje się w `storage_browser_cubit_view_state.dart`. Główny Cubit ma
  teraz **385 linii**, a wydzielony plik 44 linie. Wszystkie produkcyjne pliki
  w zakresie mają mniej niż 400 linii.

## Następny krok

Połączony review z migracją wersji i udostępniania powinien jeszcze sprawdzić
composition root, ponieważ sam fundament przeglądarki nie decyduje o gate'ach
desktop/BFF. Ten raport nie uznaje routingu ani globalnego czatu za zakończone.
