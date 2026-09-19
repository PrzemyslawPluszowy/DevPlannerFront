# I2d — Task Board standalone composition

Data: 2026-09-17

## Zakres

Naprawiono prezentacyjny graf istniejącego Boardu zadań bez zmian routera ani
shella. Board korzysta teraz z lokalnej nawigacji DevPlanner, lokalnej sesji
uwierzytelnienia i typowanej granicy modali. Zachowano otwieranie szczegółów,
menu karty, podzadania, zmianę widoku, wybór szablonu, facepile, bulk actions,
settings i wszystkie dotychczasowe operacje Kanbana.

Nie zmieniano Backend, routera, shella, Chat ani Notifications. Nie dodano
fallbacków Ready/Core ani placeholderów.

## Korekta po review — I2e

Pierwsza wersja tego raportu błędnie opisywała Board jako wolny od wszystkich
starych zależności, ponieważ skan nie obejmował wzorca
`package:devplanner/core`. Review wykrył bezpośrednie importy Core w
`tasks_board_page.dart`, `tasks_board_cubit.dart`, Cubicie podzadań i pickerze
szablonów. To był brak dowodu w raporcie, nie zamierzona kompatybilność.

Przeniesiono rzeczywiste implementacje wspólnych kontraktów do foundation:

- `lib/foundation/error/api_error.dart` — `ApiError` i `ApiErrorType`;
- `lib/foundation/l10n/l10n.dart` — lokalna extension `l10n`;
- `lib/foundation/theme/theme.dart`, `theme_extensions.dart`, `util.dart` —
  tokeny, rozszerzenia kontekstu i `MaterialTheme`.

Stare ścieżki `lib/core/error` i `lib/core/theme` są teraz cienkimi eksportami
kompatybilności dla niezależnych, niemigrowanych feature’ów. Board ich nie
importuje i nie używa ich jako implementacji ani fallbacku.

Uzupełniono również osiem testów Boardu, które nadal importowały
`core/error/api_error.dart` (interakcje, baseline, golden, screenshot, visual
reset, podzadania oraz testy pickera szablonów). Wszystkie używają teraz
`foundation/error/error.dart`.

SHA-256 artefaktów I2e:

```text
e5c00e312ab058c5a1360252d11b337f4718221fd3daf5e4dccc5e4de898dc18  lib/workspaces/presentation/tasks/board/tasks_board_page.dart
26af80447cbdd9568132931125146d9e76856527499314e74a0e1483f24de143  lib/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart
be4090984043d4cc9749e2f30afd3f1c1afe3c8fa9afe5ffea9544c8e4ebb54d  lib/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart
16e0c3d033ed00d7341e6cd9fca15538719802cd85799e0fb6e6863fcabdc529  lib/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart
5e1f1b80718b08a31328a494345ac42cd1bbe391bab64000480e9573f9523b0c  lib/foundation/error/api_error.dart
875e31940b8fdfb5ac4f6df71c115b1f1618f0e1740f987fbcf3f8967e662e09  lib/foundation/l10n/l10n.dart
8c57d64fa223a668fe3d457c5834a6e79fab6e597bc1a2c75b2de796efc10df9  lib/foundation/theme/theme.dart
3fc52ef0f54f3fe49634819c3066e047cdb5c8a144e8943ddcfbfe6b063ce810  lib/foundation/theme/theme_extensions.dart
e469925de082a7f17131336a5d1a5821bfa5a53b264f60c0f5838d60a978e126  lib/foundation/theme/util.dart
```

## Dowody i zmiany

| Ścieżka / obszar | Wcześniej | Teraz | Źródło kontraktu / dowód | Status | Zależności |
| --- | --- | --- | --- | --- | --- |
| `presentation/tasks/board` | importy usuniętych `AppRouter`, `AuthCubit`, `AppModalPickerHost` i `context.router` | `DevPlannerNavigation`, `AuthSessionPort`, `DevPlannerModalPickerHost`, bezpieczne `GoRouter.maybeOf` | lokalne porty: `lib/app/router/devplanner_navigation.dart`, `lib/auth/domain/ports/auth_session_port.dart`, `lib/foundation/presentation/devplanner_modal_host.dart` | exact | istniejący router/shell dostarcza `GoRouter` |
| `tasks_board_page.dart`, `tasks_board_card_*.dart`, `tasks_board_header.dart` | nawigacja i sesja były związane z usuniętym rootem | typowane wywołania nawigacji oraz sesja lokalna; testy bez routera nie rzucają wyjątku | nowe API DevPlanner, testy boardu | reconstructed | router integruje ścieżki poza tym pakietem |
| `data/projects/responses/project_member_response.dart` + wygenerowane artefakty | `coreUserId` / `readyUserId` | kanoniczne `userId` i JSON `userId` | `../Backend/Contracts/Projects/ProjectMemberResponse.cs` (`UserId`) | exact | Retrofit `ProjectsApi`, settings/facepile |
| `data/projects/responses/project_response.dart` + wygenerowane artefakty | `createdByCoreUserId` / `createdByCoreUserId` w JSON | kanoniczne `createdByUserId` / `createdByUserId` w JSON | `../Backend/Contracts/Projects/ProjectResponse.cs` (`CreatedByUserId`) | exact | Retrofit `ProjectsApi`, project templates/settings |
| `projects/settings` i test szablonów | importy `ready_next` oraz stara sesja użytkownika | importy `devplanner`, `AuthSessionPort`, lokalny `userId` | lokalny port sesji i kontrakt Backend | exact | repository/API pozostają poza UI |

SHA-256 kluczowych plików po zmianie:

```text
4c569862fb6a4d91df5fbc95936d7cda75ceaffe5ed33f83dba29ad92572101a  lib/workspaces/presentation/tasks/board/tasks_board_page.dart
a696ccd5af82c41540fbef8ef09f7627e39e6d6adb4e51a7a439d35d17262568  lib/workspaces/presentation/tasks/board/tasks_board_card_content.dart
97c16f18239f0fd386fd98ed0550e70116512d892be8821b9e654f619a24d52b  lib/workspaces/presentation/tasks/board/tasks_board_card_menu.dart
f3edba543d417e8671725cbfee02ae6b99abc979ed1ded836715fa3e7c383057  lib/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart
45142727e7cc31b6d26caa646648d958ff1822847fd9d85f2f52aa772438b554  lib/workspaces/presentation/tasks/board/tasks_board_header.dart
8ccfc002576c92ff206b6ff30ae44bdca36cec8a2a45274f868974e28b0ec873  lib/workspaces/presentation/tasks/board/tasks_board_template_picker.dart
e3035c5247f40f788536b761b4c72d19efe7c85fff94d514b61b639ff599fe2d  lib/workspaces/data/projects/responses/project_member_response.dart
6c89317a389f9cd0be946b58e4b84647a93611b326285f4cbc8d119d11025216  lib/workspaces/data/projects/responses/project_response.dart
af4c064988ad7b65cae143f7e4cba5ee29f82bd49e2885467e5c855c1628525a  test/workspaces/presentation/projects/templates/project_templates_cubit_test.dart
```

## Kontrola aliasów

Wynik `rg` (0 dopasowań) dla bezpośredniego grafu Boardu, projektowych
response używanych przez Board, settings oraz odpowiadających testów:

```bash
rg -n -i "package:devplanner/core|package:ready_next|AppRouter|AuthCubit|AuthAuthenticated|AppModalPickerHost|context\.router|coreUserId|readyUserId|CoreUserId|ReadyUserId" \
  lib/workspaces/presentation/tasks/board \
  lib/workspaces/data/projects/responses \
  lib/workspaces/presentation/projects/settings \
  test/workspaces/presentation/tasks/board \
  test/workspaces/presentation/projects/templates
```

Poza grafem pozostają starsze pola w portfolio/workspace response; nie są
importowane przez Board i nie zostały zmienione w tym pakiecie. Ich migracja
jest osobnym zadaniem, aby nie wykonywać globalnej zamiany.

## Walidacja

- `dart run build_runner build` dla `project_response` — **3 outputs written**;
- `flutter analyze lib/workspaces/presentation/tasks/board --no-pub` — **No issues found**;
- `flutter analyze lib/foundation lib/core/error lib/core/l10n lib/core/theme --no-pub` — **No issues found**;
- `flutter analyze lib/workspaces/data/projects/responses/project_response.dart test/workspaces/presentation/projects/templates/project_templates_cubit_test.dart --no-pub` — **No issues found**;
- `flutter test test/workspaces/presentation/tasks/board --reporter compact` — **81/81 PASS**;
- `flutter test test/workspaces/presentation/projects/templates/project_templates_cubit_test.dart --reporter compact` — **6/6 PASS**;
- `git diff --check` — **PASS**.

Pierwsze uruchomienie testów boardu zatrzymało się na przejściowym błędzie
podpisywania lokalnego `libpdfium.dylib`; ponowienie tej samej komendy zakończyło
się pełnym PASS. Nie wykonano `clean`, `restore`, `reset`, `checkout`, commit
ani push.

## Następny krok

Pakiet I2d/I2e jest gotowy do review. Rejestracja ścieżek w nowym routerze i
podłączenie do shella pozostają granicą właściciela root/shell; po ich integracji
należy wykonać desktopowy smoke test Boardu z realnym Backendem.
