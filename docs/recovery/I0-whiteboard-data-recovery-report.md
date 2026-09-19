# I0 — odzyskanie kontraktów danych Whiteboard

## Zakres

Batch obejmował wyłącznie dane Whiteboard we Froncie:

- `lib/workspaces/data/whiteboard/**`;
- bezpośredni test kontraktu `test/workspaces/data/whiteboard/**`.

Nie zmieniano routera, shella, Tasks, Files, Chat, Notifications ani Backendu.
Nie wykonywano `git restore`, `git clean`, `git reset`, `git checkout`, commitów
ani pushy.

## Wynik

Naprawiono importy `ready_next` w źródłowych modelach i kliencie Retrofit,
regenerując wyłącznie artefakty Whiteboard. Generator odtworzył wszystkie
typowane odpowiedzi `CursorPageResponse<T>` oraz payloady zamiast
`InvalidType`.

Podczas porównania z kontraktem C# wykryto również rozjazd nazwy pola:
backend przyjmuje `AssigneeUserIds`, a Flutter wysyłał historyczne
`assigneeCoreUserIds`. Pole zostało zmienione na `assigneeUserIds` w obu
payloadach konwersji Sticky Note → Tasks.

## Walidacja

Przed regeneracją, po przełączeniu importów źródłowych, zakres Whiteboard miał
8 problemów analyzera (6 błędów wynikających z brakującego importu
`TaskPriority` i 2 informacje o sortowaniu dyrektyw). Po przywróceniu
kanonicznego importu, regeneracji i formatowaniu:

```text
flutter analyze lib/workspaces/data/whiteboard test/workspaces/data/whiteboard
No issues found!
```

Test kontraktu:

```text
flutter test test/workspaces/data/whiteboard/whiteboard_models_contract_test.dart --reporter compact
2 tests passed
```

Kontrole dodatkowe:

```text
dart format lib/workspaces/data/whiteboard/models/whiteboard_models.dart
dart run build_runner build --build-filter='lib/workspaces/data/whiteboard/**'
rg "package:ready_next|package:devplanner/core|\bInvalidType\b" lib/workspaces/data/whiteboard test/workspaces/data/whiteboard
git diff --check -- lib/workspaces/data/whiteboard test/workspaces/data/whiteboard
```

Ostatnie dwa skany nie zwracają wyników, a `git diff --check` jest czysty.
Ostrzeżenia generatora dotyczą globalnych wersji SDK/analyzera i constraintu
`json_annotation`; nie są błędami tego batcha.

## Źródło kontraktu

Weryfikacja nazwy pola i typów została wykonana względem:

`Backend/Contracts/Whiteboard/WhiteboardContracts.cs`

Wygenerowane pliki pozostają zsynchronizowane ze źródłowym API i modelami:

- `lib/workspaces/data/whiteboard/api/whiteboard_api.g.dart`;
- `lib/workspaces/data/whiteboard/models/whiteboard_models.freezed.dart`;
- `lib/workspaces/data/whiteboard/models/whiteboard_models.g.dart`.

## Ograniczenia i następny krok

To jest wyłącznie odzyskanie warstwy kontraktów danych. Whiteboard nadal nie
ma przywróconego ekranu ani routingu produkcyjnego; nie należy dodawać go do
menu/shella w tym batchu. Kolejny agent może osobno zaplanować pionową
implementację Whiteboard UI, realtime, eksportu i konwersji Sticky Note,
korzystając z tych typowanych kontraktów.
