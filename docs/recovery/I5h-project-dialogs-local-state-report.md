# I5h — dialogi tworzenia zasobów projektu

Data: 2026-09-18  
Status: gotowe do niezależnego review rootu.

## Cel i ścisły zakres

Pakiet porządkuje wyłącznie dialogi tworzenia zasobów projektu w
`lib/workspaces/presentation/projects/dialogs/**` oraz — za jednoznaczną zgodą
rootu — sześć wywołań w
`lib/workspaces/presentation/workspaces_home/projects_tree/workspace_project_menu.dart`.
Nie zmieniono routingu, kontraktów API, modeli, backendu, Tasks, Storage,
ustawień projektu, Chat ani Notifications.

## Zrealizowana struktura

Usunięto monolityczny plik
`project_resource_creation_dialogs.dart` (1288 linii). Zastąpiły go:

- `ProjectResourceCreationDialogs` — klasa-fasada z sześcioma statycznymi
  metodami otwierania modalów; nie ma już globalnych/top-level entrypointów;
- osobne widgety formularzy: projektu, Whiteboardu, zadania, Wiki, karty
  Corkboard i folderu;
- `ProjectResourceCreationCommandState` — niemutowalny lifecycle komendy;
- sześć wyspecjalizowanych Cubitów tworzenia zasobu w
  `cubit/project_resource_creation_command_cubits.dart`;
- `ProjectDialogColorHexCodec` — jawna, klasowa konwersja `Color` do kontraktu
  backendowego `#RRGGBB`.

Każdy Cubit ma jedną komendę i kontroluje własny lifecycle: po oczekiwaniu na
repozytorium sprawdza `isClosed` przed emisją. Widgety nie wywołują już metod
repozytorium; odpowiadają wyłącznie za walidację formularza, lokalne kontrolki,
reakcję na stan Cubitu i nawigację po sukcesie.

## Stan lokalny i zachowane funkcje

- Nie występuje `setState`, `StatefulBuilder` ani `setDialogState`.
- Wybór ikony, koloru, widoczności, typu Whiteboardu, priorytetu, statusu i
  koloru notatki korzysta z prywatnych `ValueNotifier`ów oraz
  `ValueListenableBuilder`/`AnimatedBuilder`.
- Wszystkie `TextEditingController` i `ValueNotifier`y są zwalniane w
  `dispose`.
- Zachowano tworzenie projektów, Whiteboardów, zadań, stron Wiki, kart
  Corkboard i folderów, komunikaty błędów, callback `onCreated` oraz istniejące
  docelowe nawigacje po sukcesie.
- Jedyny caller menu używa teraz wyłącznie
  `ProjectResourceCreationDialogs.showCreate…`; jego pozostała logika i UI nie
  zostały zmienione.

## Dowody wykonane w repo Front

```text
dart format lib/workspaces/presentation/projects/dialogs \
  lib/workspaces/presentation/workspaces_home/projects_tree/workspace_project_menu.dart
# PASS

flutter analyze lib/workspaces/presentation/projects/dialogs \
  lib/workspaces/presentation/workspaces_home/projects_tree/workspace_project_menu.dart
# PASS: No issues found!

flutter test test/workspaces/presentation/workspaces_home/widgets/workspace_project_menu_test.dart --reporter compact
# PASS: 3/3

flutter test test/workspaces/presentation/projects/dialogs/project_resource_creation_command_cubits_test.dart \\
  test/workspaces/presentation/workspaces_home/widgets/workspace_project_menu_test.dart --reporter compact
# PASS: 10/10 (7 nowych testów Cubitów komend + 3 testy menu)

rg -n "\\b(setState|StatefulBuilder|setDialogState)\\b" \
  lib/workspaces/presentation/projects/dialogs
# PASS: brak wyników

find lib/workspaces/presentation/projects/dialogs -type f -name '*.dart' -exec wc -l {} +
# PASS: największy plik create_task_dialog.dart ma 358 linii

git diff --check
# PASS
```

Nie było wcześniej odrębnego testu widgetowego samych dialogów. Dodano małą
suite Cubitów pokrywającą przekazanie pól dla wszystkich sześciu komend oraz
stan sukcesu. Test menu jest właściwym testem zmienionej granicy wywołania;
nie zastępuje desktopowego E2E z backendem, które pozostaje osobną bramką
produktu.

## Następny krok dla kontynuującego agenta

Przed akceptacją pakietu root powinien powtórzyć scoped analyzer, test menu,
skan zakazanych API i `git diff --check`, a następnie — jeśli wynik pozostanie
zielony — opisać zaakceptowany pakiet w identycznych planach i handoffach Front
i Backend zgodnie z `AGENTS.md`.
