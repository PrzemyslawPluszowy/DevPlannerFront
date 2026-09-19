# I5i — recurrence bez `setState` i globalnych helperów

Data: 2026-09-18  
Status: **gotowe do niezależnego review rootu**.

## Ścisły zakres

Pakiet obejmuje wyłącznie
`lib/workspaces/presentation/tasks/recurrence/**` i bezpośrednie testy w
`test/workspaces/presentation/tasks/recurrence/**`.

Za wyraźną zgodą rootu wykonano wyłącznie trzy mechaniczne call-site’y poza
tym katalogiem:

- `tasks/list/table/task_list_table_builder.part.dart` — używa klasowego
  launchera edytora zamiast funkcji top-level;
- `tasks/list/cubit/task_list_mutation_mixin.dart` — używa klasowego mappera
  podsumowania recurrence;
- `tasks/board/cubit/tasks_board_card_commands.dart` — używa tego samego
  mappera.

Nie zmieniono routingu, backendu, API, modeli, kontraktów, pozostałej logiki
List/Kanban ani innych pionów.

## Zrealizowana struktura i zachowanie

- Zastąpiono lokalny `_selectedTab` przez prywatny `ValueNotifier<int>` oraz
  `ValueListenableBuilder`; notifier jest zwalniany w `dispose`.
- Hover reguł i historii wykonań korzysta z prywatnych `ValueNotifier<bool>` i
  `ValueListenableBuilder`, również z jawnym `dispose`.
- Usunięto wszystkie dyrektywy `part`; komponenty arkusza i edytora są zwykłymi
  małymi widgetami w `widgets/`, bez ukrywania klas w jednym pliku.
- Zastąpiono globalne API klasami:
  `TaskRecurrenceContextEditorLauncher`, `TaskRecurrenceTextFormatter` i
  `TaskRecurrenceSummaryMapper`.
- `TaskRecurrenceEditorCubit` i jego stan nie znają Flutterowego typu czasu:
  używają niemutowalnego `TaskRecurrenceScheduledTime` (`hour`, `minute`).
  Konwersja do/z typu pickera pozostaje wyłącznie w
  `TaskRecurrenceContextEditor`; zapis nadal buduje ten sam czas UTC.
- Usunięto controller tworzony w `build` customowego presetu; pole interwału
  używa `TextFormField.initialValue`, a zmiany dalej trafiają do dedykowanego
  `TaskRecurrenceEditorCubit`.
- Wszystkie operacje odczytu/zapisu pozostały w `ProjectRecurrencesCubit` i
  `TaskRecurrenceEditorCubit`; UI nie importuje HTTP ani nie wykonuje logiki
  repozytorium. Cubity już sprawdzają lifecycle po `await` przez `isClosed`.
- Zachowano edycję, tworzenie, zapis, pauzę/wznowienie, usunięcie,
  natychmiastowe wykonanie, realtime refresh, nawigację menu kontekstowego i
  mapowanie mutacji do List/Kanban.

## Wykonane dowody

```text
dart format lib/workspaces/presentation/tasks/recurrence \
  lib/workspaces/presentation/tasks/list/cubit/task_list_mutation_mixin.dart \
  lib/workspaces/presentation/tasks/board/cubit/tasks_board_card_commands.dart \
  lib/workspaces/presentation/tasks/list/table/task_list_table_builder.part.dart
# PASS

flutter analyze lib/workspaces/presentation/tasks/recurrence \
  test/workspaces/presentation/tasks/recurrence \
  lib/workspaces/presentation/tasks/list/cubit/task_list_mutation_mixin.dart \
  lib/workspaces/presentation/tasks/board/cubit/tasks_board_card_commands.dart \
  lib/workspaces/presentation/tasks/list/table/task_list_table_builder.part.dart
# PASS: No issues found!

flutter test test/workspaces/presentation/tasks/recurrence --reporter compact
# PASS: 11/11 (w tym regresja UTC dla TaskRecurrenceScheduledTime)

rg -n "package:flutter/material\\.dart|TimeOfDay" \
  lib/workspaces/presentation/tasks/recurrence/cubit
# PASS: brak wyników; Cubit i stan nie importują material.dart ani nie używają
# typu widgetu czasu.

rg -n "\\b(setState|StatefulBuilder|setDialogState)\\b" \
  lib/workspaces/presentation/tasks/recurrence
# PASS: brak wyników

rg -n "\\bpart\\b|\\.part\\.dart|showTaskRecurrenceContextEditor|recurrenceIntervalLabel|recurrenceModeLabel" \
  lib/workspaces/presentation/tasks/recurrence
# PASS: brak wyników

find lib/workspaces/presentation/tasks/recurrence -type f -name '*.dart' -exec wc -l {} +
# PASS: największy plik task_recurrence_editor_cubit.dart ma 359 linii

git diff --check
# PASS
```

Targeted testy potwierdzają stan początkowy, pobranie list i historii, pauzę,
wznowienie, trigger run, realtime refresh, presety, create i toggle edytora.
Nie są dowodem desktopowego E2E z backendem; ten odbiór pozostaje osobną bramką
produktu.

## Następny krok

Root powinien niezależnie powtórzyć analyzer, testy, skany i `git diff --check`.
Po akceptacji tylko root dopisuje ten pakiet do identycznych planów i handoffów
Front/Backend.
