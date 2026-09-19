# I3c — workspace-scoped route Files i composition

Data: 2026-09-17  
Zakres: wyłącznie Front (`/Users/przemyslawnowak/Desktop/dev/DevNote/Front`)  
Backend, Chat i Notifications: bez zmian.

## Wynik

Pion Files read-only został podłączony do nowego routera jako jedna chroniona
trasa:

```text
/workspaces/:workspaceId/files
```

Trasa nie istnieje jako osobna globalna/personalna ścieżka. Otrzymuje
`StorageScope.workspace(workspaceId)` i renderuje zaakceptowaną stronę
`StorageReadOnlyBrowserPage`. Repozytorium jest składane jawnie w
`DevPlannerRouter`: host może przekazać `StorageRepository`, a w produkcji
router buduje `StorageApi` + `StorageRepositoryImpl` z sesyjnego
`DevPlannerHttpTransport`. Nie ma service locatora ani globalnego stanu.

## Twierdzenia i dowody

| Twierdzenie | Status | Dowód | Dalsza decyzja |
|---|---|---|---|
| Route workspace Files jest realnie osiągalny | potwierdzone | `lib/app/router/devplanner_router.dart:102-105` rejestruje `/workspaces/:workspaceId/files`, a `:166-192` składa stronę z `StorageScope.workspace`; test routera sprawdza render `Moje pliki` | Upload/edycja/share/wersje pozostają poza route w kolejnych batchach. |
| Kompozycja Storage jest jawna i sesyjna | potwierdzone | `lib/app/router/devplanner_router.dart:34-43`, `:149-164`; parametr `StorageRepository?` ma pierwszeństwo, fallback wymaga `supportsStandaloneApiClients` i używa `transport.apiDio` | Nie dodawać globalnego singletonu ani `context.read<StorageRepository>()` jako ukrytego fallbacku. |
| Nieprawidłowy workspace ID kończy się typowanym unavailable | potwierdzone | `lib/app/router/devplanner_router.dart:166-173` oraz `DevPlannerRouteCatalog.isUuid` (`:357-361`) odrzucają pusty/niekanoniczny UUID; `storage_workspace_files_route_page.dart:5-13` przechowuje enum powodu | Backend nadal jest źródłem autoryzacji istnienia workspace. |
| Brak transportu nie tworzy anonimowych żądań | potwierdzone | `.../devplanner_router.dart:151-161` zwraca `repositoryUnavailable`, jeśli nie ma jawnego repozytorium ani bezpiecznego transportu | Utrzymać fail-closed dla desktop PKCE i Web BFF. |
| 403 z backendu pozostaje odróżniony od pustej listy | potwierdzone | `lib/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart:111-137` emituje `StorageBrowserForbidden`; strona read-only mapuje go na stan forbidden | Nie mapować 403 do `StorageBrowserEmpty`. |
| Węzeł Files w bocznym menu wskazuje wyłącznie istniejącą trasę | potwierdzone | `lib/workspaces/domain/navigation/workspace_navigation_tree.dart:78-83` dodaje workspace-scoped node; `lib/app/shell/devplanner_shell_navigation.dart:119-124` buduje jego ścieżkę; test klika `navigation-node-...:files` i dociera do route | Personal Files pozostaje nieklikalny, bo `/me/files` nie jest jeszcze wdrożoną trasą. |
| Chat/Notifications nie zostały ponownie dodane | potwierdzone | Zmiana obejmuje wyłącznie route Files, tree/menu i composition Storage; brak route/panelu Chat | Overlay Chat/Notifications dopiero w końcowej fazie. |

## L10n i unavailable

Dodano klucze ARB w `lib/l10n/app_en.arb` i `lib/l10n/app_pl.arb`:

- `storageRouteUnavailableTitle`,
- `storageRouteInvalidWorkspaceId`,
- `storageRouteNotConfigured`.

`flutter gen-l10n` wygenerował odpowiadające klasy lokalizacji. Teksty nie są
zaszyte w routerze ani w domain/data.

## Testy

Dodano do `test/app/router/devplanner_root_router_compile_test.dart`:

1. poprawny UUID + jawne repozytorium renderuje realny browser;
2. niepoprawny UUID renderuje typowany unavailable;
3. workspace node w sidebarze nawiguje do chronionej trasy.

Walidacja wykonana w katalogu Front:

```text
flutter gen-l10n                                      -> OK
dart format [route/app/shell/tree/test]               -> OK
flutter analyze [7 plików route/composition]         -> No issues found!
flutter test router + shell + read-only Files        -> All tests passed! (12 testów)
flutter build macos --debug                           -> Built DevPlanner.app
git diff --check                                      -> brak błędów
```

Build zgłaszał tylko istniejące ostrzeżenie o braku Swift Package Manager w
`media_kit_libs_macos_video` i `media_kit_video`; build zakończył się sukcesem.

## Ograniczenia

To nie jest pełna migracja Files. Wciąż odroczone są personal `/me/files`,
project files, upload/anulowanie, mutacje, download UI, wersje, ACL/share i
OnlyOffice. Stare pliki Storage zależne od Ready/Core nadal istnieją poza
zamkniętym grafem i nie zostały usunięte ani podłączone do nowego route.

Nie wykonywano commit ani push.
