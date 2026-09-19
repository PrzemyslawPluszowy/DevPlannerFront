# I5e — Workspaces Home: lokalny stan i struktura

Data: 2026-09-18  
Zakres: `lib/workspaces/presentation/workspaces_home/**` oraz bezpośredni test
`test/workspaces/presentation/workspaces_home_cubit_test.dart`.

## Cel

Pakiet usuwa odziedziczone `setState` z lokalnych interakcji katalogu
Workspace: filtrowania, rozwijania drzewa, hoveru, sekcji ukrytych przestrzeni
oraz formularzy tworzenia i edycji. Nie zmienia kontraktów API, modeli,
routingu, Tasks, Storage, Chat, Notifications ani backendu.

## Wprowadzone zmiany

- `WorkspaceDirectoryMenu` przechowuje filtr wyłącznie w prywatnym
  `ValueNotifier<String>` i zwalnia go w `dispose`.
- Rozbito 402-liniowy katalog na kompozycję stanu, zawartość załadowaną i
  osobny komponent listy sortowalnej. Każdy plik ma maksymalnie 366 linii.
- `WorkspaceDirectoryItem` używa prywatnego, niemutowalnego stanu UI w
  `ValueNotifier`; `ValueListenableBuilder` odświeża tylko interakcje hoveru i
  rozwinięcia. Automatyczne rozwinięcie aktywnej gałęzi zachowuje kontrolę
  lifecycle przez `mounted`.
- `HiddenWorkspacesSection` używa prywatnego `ValueNotifier<bool>` dla
  rozwinięcia i zwalnia go w `dispose`.
- Dialogi tworzenia i edycji używają prywatnych `ValueNotifier`ów dla ikony,
  koloru i wysyłania formularza. Kontrolery tekstu i notifiery są zwalniane w
  `dispose`; operacje zapisu nadal prowadzą przez `WorkspacesHomeCubit`.
- Usunięto top-level funkcje otwierania dialogów. Są teraz jawnymi metodami
  statycznymi `CreateWorkspaceDialog.show` i `EditWorkspaceDialog.show`.
- Bezpośredni test Cubitu przeniesiono z usuniętych importów `ready_next` na
  standalone `devplanner`, w tym `searchLocalUsers` i
  `LocalUserDirectoryResponse`.

## Dowody

Wykonane komendy:

```bash
dart format lib/workspaces/presentation/workspaces_home \
  test/workspaces/presentation/workspaces_home_cubit_test.dart
flutter analyze lib/workspaces/presentation/workspaces_home \
  test/workspaces/presentation/workspaces_home_cubit_test.dart \
  test/workspaces/presentation/workspaces_home
flutter test test/workspaces/presentation/workspaces_home_cubit_test.dart \
  --reporter compact
rg -n "setState|StatefulBuilder|setDialogState|package:ready_next" \
  lib/workspaces/presentation/workspaces_home \
  test/workspaces/presentation/workspaces_home_cubit_test.dart
find lib/workspaces/presentation/workspaces_home -type f -name '*.dart' \
  -exec wc -l {} +
git diff --check
```

Wyniki:

- scoped `flutter analyze`: **PASS** (`No issues found!`);
- `workspaces_home_cubit_test.dart`: **8/8 PASS**;
- skan `setState` / `StatefulBuilder` / `setDialogState` / `ready_next` w
  objętym kodzie i bezpośrednim teście: **0 wyników**;
- nie ma pliku produkcyjnego >400 linii;
- `git diff --check`: **PASS**.

## Otwarte ograniczenie testów widgetowych

W trakcie pierwszego uruchomienia pełne polecenie testów
`test/workspaces/presentation/workspaces_home` nie kompilowało z powodu dwóch
**zewnętrznych zależności poza zakresem I5e**:

- `lib/workspaces/shared/helpers/workspace_icon_helper.dart` nadal importuje
  `package:ready_next/core/theme/theme.dart` i
  `package:ready_next/shared/presentation/icons/app_icons.dart`;
- `lib/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart`
  nadal ma importy `package:ready_next` dla routera, motywu, repozytoriów i
  formularzy.

Pierwsza blokada dotyczyła testu pustego katalogu, druga testu drzewa
projektów. Kod I5e nie odtwarzał tych importów. Po ich równoległej migracji w
zewnętrznych pionach pełne widget testy zostały ponowione i zakończyły się
**4/4 PASS**.

## Korekta review — kod HTTP błędu drzewa projektów

Review wykrył regres istniejącego widget testu: `WorkspaceProjectsCubit`
poprawnie przekazuje `statusCode: 503`, ale menu renderowało kod wyłącznie z
`backendCode`. W `WorkspaceProjectMenu` wydzielono mały widget błędu, który
używa lokalnego `displayCode = backendCode ?? statusCode?.toString()`.
Własny kod backendu ma więc pierwszeństwo, a status HTTP jest bezpiecznym
fallbackiem. Nie dodano `setState`, globalnej funkcji ani logiki transportu.

Dowody po korekcie review:

```bash
flutter test test/workspaces/presentation/workspaces_home --reporter compact
```

Wynik: **4/4 PASS**.

## Następny krok

Root może dopisać I5e do wspólnego planu i handoffu Front/Backend po
niezależnym review.
