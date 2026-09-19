# I3f — desktopowa kompozycja uploadu Files

## Zakres i decyzja platformowa

Podłączono istniejący, zwalidowany pion uploadu do realnej trasy
`/workspaces/:workspaceId/files`. Kompozycja uploadu jest tworzona tylko, gdy
root posiada transport desktopowy z bezpiecznym źródłem Bearera:

```text
httpTransport != null
&& !httpTransport.isBffCookieTransport
&& httpTransport.supportsStandaloneApiClients
```

W tej gałęzi root składa prawdziwe `FilePickerPortImpl` i
`PresignedUploadTransport`, a strona dostaje je przez typowane zależności
`FilePickerPort?` i `UploadTransport?`. Dzięki temu kolejka i odświeżenie po
potwierdzonym `completeUpload` używają zaakceptowanej ścieżki I3d/I3e.

Web BFF nadal może wyświetlić read-only Files przez cookie/CSRF, ale nie dostaje
pickera, transportu presigned ani przycisku uploadu. Nie ma fałszywej kontroli
uploadu ani próby bezpośredniego PUT z BFF.

## Zmienione miejsca

- `lib/app/router/devplanner_router.dart` — warunkowa kompozycja desktopowego
  pickera i transportu w workspace Files route;
- `test/app/router/devplanner_root_router_compile_test.dart` — test trasy
  desktopowej z przyciskiem `Prześlij pliki` oraz test BFF fail-closed;
- istniejące pliki I3d/I3e pozostają źródłem kolejki, typed błędów, anulowania,
  progresu i refreshu; nie zmieniano Backend, Chat, Notifications ani shell.

Direct graph I3f nie zawiera importów `package:ready_next` ani
`package:devplanner/core`.

## Walidacja

Analyzer zakresowy zakończył się wynikiem:

```text
No issues found! (ran in 5.9s)
```

Testy routera i uploadu:

```text
flutter test \
  test/app/router/devplanner_root_router_compile_test.dart \
  test/workspaces/presentation/storage/browser/storage_upload_vertical_test.dart
```

Wynik: `All tests passed!` — 16 testów.

Testy Files/transport:

```text
flutter test \
  test/workspaces/presentation/storage/browser/storage_upload_vertical_test.dart \
  test/workspaces/presentation/storage/browser/storage_read_only_browser_page_test.dart \
  test/workspaces/data/storage/transport_test.dart
```

Wynik: `All tests passed!` — 11 testów.

Build desktopowy:

```text
flutter build macos --debug
```

Wynik: `Built build/macos/Build/Products/Debug/DevPlanner.app`.
Flutter wypisał istniejące ostrzeżenie, że `media_kit_libs_macos_video` i
`media_kit_video` nie wspierają jeszcze Swift Package Manager; nie blokowało to
builda.

`git diff --check`: bez błędów.

## Granice dowodu

Testy potwierdzają kompozycję desktop vs BFF i renderowanie kontroli, ale nie
wykonują prawdziwego uploadu do backendu/MinIO. Nie deklaruje się tutaj
produkcyjnego E2E ani uploadu webowego. Folder/delete/rename/move pozostają
poza I3f.

