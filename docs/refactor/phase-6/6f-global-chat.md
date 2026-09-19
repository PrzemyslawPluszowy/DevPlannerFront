# Faza 6F — globalny Chat DevPlanner

**Status: COMPLETE dla panelu, routingu i bezpiecznego standalone runtime wiring (2026-09-17).**

Ten pakiet podłącza istniejący feature Chat do standalone shellu przez jawny
port kompozycji. Nie tworzy osobnego klienta HTTP, globalnego Cubita ani
adaptera Ready/Core. Pełny ekran `/chat` pozostaje kanonicznym fallbackiem i
deep linkiem.

## Wykonane

- Dodano `DevPlannerGlobalChatComposition` w
  `lib/workspaces/presentation/chat/global_chat_composition.dart`.
  Composition root przekazuje repozytorium Chat, lokalny `userId`, magazyn
  draftów, opcjonalny port uploadu plików, picker oraz fabrykę realtime.
  Panel nie używa `context.read` do ukrytego pobierania transportu, auth ani
  secure storage.
- `AppGlobalChatDrawer` otwiera prawdziwy istniejący Chat przez
  `DevPlannerModalHost.showSideSheet` na root navigatorze. Side sheet ma
  przewidywalny lifecycle, zamykanie przez barrier/Escape/close, grupę focusu,
  semantyczną nazwę trasy oraz `topInset` domyślnie równy 64 px, więc nie
  nachodzi na topbar.
- Panel zachowuje listę rozmów, wybór rozmowy, historię wiadomości, composer,
  drafty, wysyłkę idempotentną, załączniki i realtime z istniejących portów.
  Każdy `ChatConversationCubit` ma lifecycle ograniczony do otwartego panelu.
- `DevPlannerRouter` przyjmuje opcjonalną kompozycję Chat. Trasa `/chat`
  renderuje pełną listę rozmów, a `/chat/conversations/:conversationId`
  renderuje pełną rozmowę. Brak kompozycji daje jawny fail-closed ekran, a nie
  pozorną pustą listę lub żądania do zgadywanego endpointu.
- Akcja Chat w standalone topbarze otwiera rootowy panel, gdy kompozycja jest
  dostarczona. Bez niej zachowuje canonical navigation do `/chat`.
- Pełny ekran został przełączony na ten sam jawny port kompozycji; kompatybilne
  testy starszych hostów nadal mogą dostarczać lokalne repository providers.
- Dodano `DevPlannerStandaloneRuntime` w
  `lib/workspaces/data/standalone/devplanner_standalone_runtime.dart`. Runtime
  buduje `ChatApi`/`ChatRepositoryImpl` wyłącznie z sesyjnego
  `DevPlannerHttpTransport` i udostępnia kompozycję dopiero dla zalogowanego
  lokalnego `UserId` oraz bezpiecznego Web BFF cookie albo Desktop PKCE/vault.
- Web nie otrzymuje klienta SignalR ani access tokenu. Desktop tworzy fabrykę
  Chat realtime wyłącznie z providera access tokenu transportu, który czyta
  bieżący token z pamięci/vaultu; żaden token nie pochodzi z launch contextu.
- `bootstrap()` i `DevPlannerRouter` przyjmują opcjonalny runtime. Przy braku
  runtime, braku sesji lub niespełnieniu bramy router zachowuje istniejący
  ekran `DevPlannerChatUnavailablePage`; topbar nadal może nawigować do
  kanonicznego `/chat`.

## Granica wdrożeniowa

Domyślne wywołanie `bootstrap()` nadal nie tworzy runtime, bo nie ma jeszcze
konkretnego adaptera OIDC/BFF lub desktopowego system-browser PKCE, który
ustawia autorytatywny `AuthSessionController`. To jest świadoma granica
fail-closed. Integrator może przekazać `DevPlannerStandaloneRuntime` dopiero po
złożeniu takiej sesji i transportu; nie wolno zasilać go danymi z
`HostLaunchContext`, zgadywać tokenu ani włączać SignalR Web bez zatwierdzonego
kontraktu cookie/BFF.

Nie zmieniono wspólnego planu ani wspólnego handoffu zgodnie z instrukcją
pakietu. Nie dodano redirectów Ready/Core/DataBus ani żadnych legacy aliasów.

## Walidacja

- `dart format` — PASS dla zmienionych plików.
- `flutter analyze` — PASS, `No issues found!`.
- `flutter test test/workspaces/presentation/chat/global_chat_integration_test.dart test/app/router/devplanner_router_test.dart test/app/shell/devplanner_shell_test.dart` — PASS.
- `git diff --check` — PASS.

## Następny krok

Po stronie backendu opublikować rzeczywisty kontrakt auth/Chat i złożyć
`DevPlannerGlobalChatComposition` w bootstrapie przez warstwę data, bez zmiany
portu prezentacyjnego. Następnie wykonać test integracyjny root shellu z
rzeczywistym transportem oraz platformową bramkę focus/Escape na Web i desktop.
