# I5l — prywatne zadania i lokalny stan filtrów

Status: **gotowe do niezależnego review rootu**.

## Zakres

Zmiana obejmuje wyłącznie `lib/workspaces/presentation/private/**` oraz
bezpośredni test `personal_section_cubit_test.dart`. Nie zmieniano routingu,
backendu, list ani kanbanu poza istniejącym wywołaniem nawigacji z widoku
prywatnego, którego import przełączono na lokalny port aplikacji.

## Decyzje

- Wszystkie importy pionu korzystają bezpośrednio z `package:devplanner/...`.
- `PersonalSectionCubit.myTasks` przejął asynchroniczny odczyt prywatnych
  zadań i mapowanie wyniku repository. Widok tylko tworzy Cubit i przekazuje
  niemutowalne kryteria.
- `MyTasksFilters` jest niemutowalnym modelem z `copyWith`; przejściowy stan
  filtrów w stronie i dialogu przechowują małe `ValueNotifier`y z `dispose`.
- Usunięto `setState`, `StatefulBuilder`, `setDialogState` oraz top-level
  funkcje pomocnicze aplikacji. Etykiety i serializacja filtrów należą do
  modelu, a logika asynchroniczna do Cubita.
- Zachowano filtry statusu, priorytetu, udziału i zakresu dat, walidację
  odwrotnego zakresu dat oraz stronicowanie z deduplikacją zadań.

## Walidacja

- `dart format lib/workspaces/presentation/private
  test/workspaces/presentation/private`: powodzenie, 0 zmian.
- `flutter analyze lib/workspaces/presentation/private
  test/workspaces/presentation/private`: **0 problemów**.
- `flutter test
  test/workspaces/presentation/private/personal_section_cubit_test.dart`:
  **5 testów przeszło**.
- Skan `setState|StatefulBuilder|setDialogState`: 0 trafień.
- Skan `package:ready_next|package:http|package:dio|dart:io`: 0 trafień.
- Najdłuższy plik produkcyjny: 346 linii
  (`my_tasks_filters_dialog.dart`).
- `git diff --check`: powodzenie.
