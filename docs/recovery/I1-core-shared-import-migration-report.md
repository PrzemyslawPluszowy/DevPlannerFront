# I1 — migracja importu core/shared/l10n

Data: 2026-09-17  
Repozytorium: `Front`  
Zakres: wyłącznie `lib/core/**`, `lib/shared/**`, `lib/l10n/**` oraz testy
`test/core/**`, `test/shared/**`.

## Podbatch I1.1 — ApiRepository

Przed zmianą skan zakresu wykazał dokładnie jeden import `ready_next`:

```text
rg -o "package:ready_next" lib/core lib/shared lib/l10n test/core test/shared test/l10n
=> 1
lib/core/data/api_repository.dart
```

`lib/core/error/api_error.dart` istnieje i udostępnia zgodny typ `ApiError`,
`ApiError.fromDioException` oraz `ApiError.parsing`, więc zamiana była
kontraktowo bezpieczna. Zmieniono wyłącznie:

- `lib/core/data/api_repository.dart`
  `package:ready_next/core/error/api_error.dart` →
  `package:devplanner/core/error/api_error.dart`.

Po zmianie:

```text
rg -n "package:ready_next" lib/core lib/shared lib/l10n test/core test/shared
=> 0
```

Nie utworzono aliasu ani zależności `ready_next`.

## Walidacja

- `flutter analyze lib/core lib/shared lib/l10n test/core test/shared` — PASS,
  `No issues found!`.
- `flutter test test/core test/shared` — PASS, 16/16.
- `dart format --output=none` dla zmienionego pliku — PASS.
- `git diff --check` — PASS.

## Blokady i granica

W tym zakresie nie ma dalszych realnych importów `ready_next` do migracji.
Pozostałe problemy analyzera pochodzą z katalogów poza I1 (app/router,
auth/workspaces/feature UI) i nie były dotykane zgodnie z priorytetem.
Nie modyfikowano Backend ani wspólnego planu/handoff.

Następny podbatch powinien przejść do kolejnego zamkniętego drzewa poza I1,
po uzgodnieniu z rootem; nie należy rozszerzać I1 na UI ani router.
