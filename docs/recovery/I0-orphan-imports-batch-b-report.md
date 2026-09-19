# I0 — orphan imports, batch B

## Zakres

Batch obejmował wyłącznie warstwę `lib/workspaces/data/workspaces/**` oraz
bezpośrednie testy kontraktów tej warstwy. Nie zmieniano routera, shella,
listy zadań, plików, czatu, powiadomień ani backendu.

## Problem wejściowy

W zawężonym targetcie analizatora było 239 błędów kompilacji. Ich wspólną
przyczyną były osierocone importy `package:ready_next` w klientach Retrofit,
mapperach, modelach i repozytoriach Workspaces oraz w dwóch bezpośrednich
testach. Generowane klienty Retrofit zawierały przez to `InvalidType`.

## Wykonane zmiany

- zamieniono importy `package:ready_next/...` na potwierdzone ścieżki
  `package:devplanner/...` w API, modelach, mapperach i repozytoriach Workspaces;
- zamieniono te same importy w `workspace_mappers_test.dart` i
  `automation_models_contract_test.dart`;
- uruchomiono `build_runner` z filtrami wyłącznie dla artefaktów Workspaces
  (Retrofit, Freezed i JSON Serializable), bez przebudowy całego repozytorium;
- nie dodano zależności `ready_next`, aliasów typów ani suppressions.

## Walidacja

Polecenie analizy:

```text
dart analyze --format machine lib/workspaces/data/workspaces \
  lib/workspaces/domain/models \
  lib/workspaces/domain/repositories/workspaces_repository.dart \
  lib/workspaces/domain/repositories/automation_repository.dart \
  lib/workspaces/domain/repositories/workspace_features_repository.dart \
  test/workspaces/data/workspaces \
  test/workspaces/data/workspace_mappers_test.dart
```

Wynik: `RC=0`, 0 błędów i 0 ostrzeżeń analizatora.

Testy:

```text
flutter test test/workspaces/data/workspaces \
  test/workspaces/data/workspace_mappers_test.dart --reporter compact
```

Wynik: 7/7 testów zaliczonych.

Kontrole dodatkowe:

- `rg 'InvalidType' lib/workspaces/data/workspaces` — 0 wyników;
- `rg 'package:ready_next' lib/workspaces/data/workspaces test/workspaces/data/workspaces test/workspaces/data/workspace_mappers_test.dart` — 0 wyników;
- `git diff --check` — poprawny.

## Uwaga dla kolejnego agenta

Zmiany w artefaktach wygenerowanych powstały wyłącznie przez filtrowane
uruchomienie generatora i są ograniczone do wskazanych plików Workspaces.
Pełny analizator repozytorium nadal może raportować błędy w innych, jeszcze
niemigrowanych gałęziach; ten batch nie maskuje tych problemów.
