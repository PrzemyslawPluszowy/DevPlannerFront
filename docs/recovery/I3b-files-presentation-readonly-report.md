# I3b — Files: zamknięty pion prezentacji read-only

Data: 2026-09-17  
Zakres: Front (`/Users/przemyslawnowak/Desktop/dev/DevNote/Front`)  
Backend, router, shell, Chat i Notifications: bez zmian.

## Wynik

Utworzono mały, rzeczywisty pion desktopowego Files: pobranie listy folderów i
plików, nawigacja po folderach/okruszkach oraz bezpieczny podgląd pliku. Widok
nie wykonuje operacji HTTP, nie czyta tokenów i nie używa Dio, Retrofit,
Ready/Core ani DataBus. Otrzymuje `StorageRepository` z composition root, a
operacje wykonują lokalne Cubity i istniejące porty domenowe.

## Twierdzenia i dowody

| Twierdzenie | Status | Dowód | Dalsza poprawka / decyzja |
|---|---|---|---|
| Lista folderów i plików korzysta z lokalnego kontraktu Storage | potwierdzone | `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart:25-58`, `:102-163`; repozytorium jest przekazane w konstruktorze i używane przez `StorageBrowserCubit` | Przy migracji do `lib/features/files` przenieść ten zamknięty pion razem z portem, bez zmiany kontraktu. |
| Foldery i pliki mają realną nawigację | potwierdzone | `.../storage_read_only_browser_page.dart:127-144`, `:166-202`; `.../storage_browser_cubit.dart:74-145` | Integrację z nowym shellem wykonać dopiero w jego bramce routingu. |
| Błąd ACL/403 folderów nie jest udawany jako pusta lista | potwierdzone | `.../storage_browser_cubit.dart:111-137` emituje `StorageBrowserForbidden` przed wywołaniem `listFiles`; test `test/workspaces/presentation/storage/browser/storage_read_only_browser_page_test.dart:110-141` | Zachować mapowanie kodu 403 na stan domenowy/presentation w kolejnych pionach. |
| Podgląd używa biletu backendu i zachowuje błąd repozytorium | potwierdzone | `.../storage_preview_cubit.dart:16-51`; strona przekazuje Cubit do dialogu przez `BlocProvider.value` w `.../storage_read_only_browser_page.dart:150-163`; test `...storage_read_only_browser_page_test.dart:143-164` | Preview URL powinien nadal pochodzić z backendowego `download-ticket`; nie dodawać wywołań API do widgetów. |
| Podgląd biurowy został przywrócony jako edycja | nie dotyczy / odroczone | `.../storage_read_only_browser_page.dart:316-328` renderuje dla Office wyłącznie lokalny opis read-only | Upload, edit, share, wersje, public share i OnlyOffice pozostają osobnymi przyszłymi pionami. |
| Kontrakt backendu pokrywa użyty pion | potwierdzone | `../Backend/Endpoints/Storage/StorageEndpoints.cs:176-194` (download ticket/list files), `:291-297` (foldery i children); `../Backend/Contracts/Storage/StorageContracts.cs:204-240` (ticket/file), `:325-398` (folder/children) | Nie zmieniać backendu w tym batchu; przed upload/share wykonać osobny review kontraktu. |
| Wybrany graf prezentacji nie zależy od Ready/Core | potwierdzone | Skan `rg -n 'package:ready_next|package:devplanner/core'` po 12 plikach pionu nie zwrócił wyników. `foundation/error/error.dart` jest jedyną lokalną fasadą błędu w testach. | Cały stary katalog `lib/workspaces/presentation/storage` nadal zawiera poza tym grafem pliki Ready-zależne; nie usuwać ich w I3b. |

## Zmienione pliki

Pion i jego bezpośrednie testy:

- `lib/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart`
- `lib/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart`
- `lib/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart`
- `lib/workspaces/presentation/storage/browser/cubit/storage_breadcrumb_resolver.dart`
- `lib/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart` (naprawiona ścieżka importu, aby test Cubita kompilował lokalny model)
- `lib/workspaces/presentation/storage/shared/storage_formatters.dart`
- `lib/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart`
- `lib/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart`
- `lib/workspaces/presentation/storage/preview/widgets/storage_text_preview.dart`
- `test/workspaces/presentation/storage/browser/storage_read_only_browser_page_test.dart`
- `test/workspaces/presentation/storage/storage_browser_cubit_test.dart`
- `test/workspaces/presentation/storage/storage_preview_cubit_test.dart`

W plikach objętych grafem liczba bezpośrednich importów `ready_next`/`devplanner/core`
spadła z 51 (stan HEAD w 10 istniejących plikach) do 0. Nowa strona i jej test
nie mają
odpowiednika w HEAD. Pozostałe stare widgety selekcji, mutacji i powiązane
ekrany nie są częścią tego grafu i wymagają osobnych migracji.

## Walidacja

Wykonano w katalogu Front:

```text
dart format [12 plików pionu]              -> Formatted 12 files (0 changed)
flutter analyze [12 plików pionu i testów] -> No issues found!
flutter test [3 testy pionu]               -> All tests passed! (15 testów)
flutter build macos --debug                -> Built build/macos/Build/Products/Debug/DevPlanner.app
git diff --check                           -> brak błędów
```

Build zgłosił wyłącznie istniejące ostrzeżenie, że `media_kit_libs_macos_video`
i `media_kit_video` nie wspierają jeszcze Swift Package Manager; artefakt
macOS został zbudowany poprawnie.

## Granice i następny krok

Ten raport nie oznacza pełnej migracji Files. Brakuje jeszcze zamkniętych
pionów uploadu/anulowania, downloadu plików i wersji, ACL/share, mutacji,
OnlyOffice oraz podłączenia do nowego shellu. Najpierw powinien powstać test
composition root dla przekazania `StorageRepository`, a dopiero potem
integracja z trasą Files i powłoką Gmail-inspired. Nie wykonywano commit ani
push.
