# I5d — lokalny stan oraz kompozycja Storage

Data: 2026-09-18

## Cel i granice

Pakiet obejmuje wyłącznie `lib/workspaces/presentation/storage/**` oraz jego
bezpośrednie testy. Usuwa lokalne `setState`, `StatefulBuilder` i
`setDialogState`, rozdziela pliki ponad 400 linii i naprawia wyłącznie importy
testów Storage po zmianie nazwy pakietu na `devplanner`. Nie zmienia kontraktów
API, modeli domenowych, routingu, Chat, Notifications ani Backendu.

## Zmiany

- Publiczny widok linku, formularz tworzenia linku, host OnlyOffice i dialog
  tworzenia dokumentu używają prywatnych `ValueNotifier`ów wraz z
  `ValueListenableBuilder` i jawnym `dispose`.
- Operacje OnlyOffice (pobranie, druk i zapis kopii) zostały wyniesione z
  widgetu do małego, niemutowalnego `StorageOfficeEditorActionsCubit`.
  Cubit nie zna `BuildContext`; publikuje typowane komunikaty, a widget tłumaczy
  je przez ARB i wyświetla jako `SnackBar`.
- Zachowano specjalne ścieżki: druk nie inicjuje dodatkowego pobrania, zapis
  kopii używa `Uint8List` zgodnie z kontraktem `StorageUploadInput`, a retry,
  timeout i wymuszone zamknięcie OnlyOffice pozostają fail-closed.
- Dialog edytora został rozdzielony na kompozycję providera oraz widok. Ciało
  eksploratora wydzielono z `StorageShellPage` do
  `storage_browser_body.dart`; żaden plik Dart w katalogu Storage nie ma ponad
  400 linii.
- W presentation Storage i bezpośrednich testach `package:ready_next` zostało
  mechanicznie zastąpione `package:devplanner`. Usunięto nieistniejącą już
  zależność testowego shella od starego `AuthRepository`; podgląd Storage nie
  wymaga go obecnie w konstruktorze.

## Walidacja

Wykonano w katalogu `Front`:

```bash
dart format lib/workspaces/presentation/storage test/workspaces/presentation/storage
flutter analyze lib/workspaces/presentation/storage
flutter test test/workspaces/presentation/storage --reporter compact
rg -n 'setState|StatefulBuilder|setDialogState' lib/workspaces/presentation/storage
find lib/workspaces/presentation/storage -type f -name '*.dart' -print0 | xargs -0 wc -l | awk '$1 > 400 { print }'
git diff --check
```

Wyniki:

- scoped analyzer: `No issues found!`;
- suite Storage: **96/96 PASS**;
- brak wyników dla `setState`, `StatefulBuilder` oraz `setDialogState`;
- brak plików Dart dłuższych niż 400 linii;
- `git diff --check`: PASS.

## Następny krok

Pakiet nie jest dowodem pełnego desktopowego E2E z backendem. Kolejny etap
powinien uruchomić ręczny scenariusz desktopowy Files (lista, Kanbanowe
załączniki, upload, preview, OnlyOffice i współdzielenie) z uruchomionym
backendem, bez przywracania legacy importów, `setState` lub globalnych Cubitów.
