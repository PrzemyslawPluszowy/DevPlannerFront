# I0 — odzyskanie kontraktów danych Wiki, OKR i Corkboard

Data: 2026-09-18  
Repozytorium: `Front`  
Zakres: `lib/workspaces/data/wiki/**`, `lib/workspaces/data/okr/**`,
`lib/workspaces/data/corkboard/**` oraz bezpośredni kontrakt OKR i jego test
szczegółu celu.

## Zasady wykonania

- Zachowano istniejący, zabrudzony worktree; nie wykonywano resetu, clean,
  checkout ani commitów.
- Nie dotykano routera, shella, Tasks, Files, Chat, Notifications ani
  Backend.
- Źródłem prawdy pozostały lokalne kontrakty Dart i lokalne kontrakty C#;
  nie dodawano aliasów, sztucznych modeli ani wyciszeń analizatora.
- Pliki generowane Retrofit/Freezed zostały odświeżone wyłącznie przez
  `build_runner` po naprawie źródeł.

## Wiki — zakończone

Naprawiono importy modeli i API z `package:ready_next/...` na lokalne
`package:devplanner/...`. Po regeneracji Retrofit API używa teraz rzeczywistych
typów (`WikiPageResponse`, `WikiPageTreeNodeResponse`, payloadów i odpowiedzi
rewizji), a nie `InvalidType`.

Zweryfikowano:

```text
flutter analyze lib/workspaces/data/wiki ...
No issues found
```

Brak `ready_next`, `InvalidType` i starych nazw Core w zakresie Wiki.

## OKR — zakończone w zakresie kontraktów danych

Naprawiono importy lokalne API/modeli/repository oraz odświeżono generowane
pliki Retrofit/Freezed/JSON. Pole odpowiedzi celu zostało ujednolicone do
`createdByUserId`, zgodnie z aktualnym kontraktem backendu `ObjectiveResponse`;
usunięto pozostawioną nazwę `createdByCoreUserId`.

Zaktualizowano bezpośredni kontrakt repository, Cubit szczegółu celu i jego test
do lokalnych importów oraz nowej nazwy pola.

Zweryfikowano:

```text
flutter analyze lib/workspaces/data/okr \
  lib/workspaces/domain/repositories/okr_repository.dart \
  lib/workspaces/presentation/okr/cubit \
  test/workspaces/presentation/okr/okr_objective_details_cubit_test.dart
No issues found

flutter test test/workspaces/presentation/okr/okr_objective_details_cubit_test.dart
All tests passed (1 test)
```

## Corkboard — zakończone w zakresie kontraktów danych

Naprawiono importy modeli i API na lokalne `package:devplanner/...`. Po
regeneracji Retrofit API używa rzeczywistych typów sekcji, kart, załączników i
operacji AI oraz lokalnych payloadów Wiki i Tasks. W zakresie Corkboard nie ma
już `InvalidType` ani `ready_next`.

Zweryfikowano wspólnie z pozostałym zakresem:

```text
flutter analyze lib/workspaces/data/corkboard ...
No issues found
```

## Wspólna walidacja

- `dart run build_runner build --build-filter` dla rodzin Wiki, OKR i
  Corkboard: zakończone, wygenerowano poprawne kontrakty.
- `git diff --check`: bez błędów.
- Skan zakresu: zero `package:ready_next`, zero `InvalidType`, zero
  `createdByCoreUserId`.

## Poza zakresem / następne kroki

Ten batch naprawia warstwę danych i bezpośredni test OKR. Nie implementuje
jeszcze ekranów, Cubitów list/edycji ani routingu Wiki, OKR i Corkboardu. Nie
wolno uznawać tych modułów za gotowe funkcjonalnie tylko na podstawie zielonego
analizatora; następny osobny batch powinien dostarczyć pionowy przepływ desktop
read/list dla jednego modułu, z testem repository i UI, dopiero potem mutacje.

