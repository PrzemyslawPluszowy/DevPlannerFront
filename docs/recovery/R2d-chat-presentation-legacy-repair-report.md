# R2d — naprawa legacy zależności presentation Chat

**Status:** gotowe do review rootu jako pilna naprawa kompilacji.

## Zrealizowane naprawy

- Warstwa presentation Chat nie używa już `AuthRepository`. Autor composera
  jest odczytywany z `AuthSessionPort.snapshot.user.userId`.
- Zastąpiono usunięty `AppRouter` przez `DevPlannerNavigation` i jego metodę
  `go`, bez zmiany tras rozmów.
- Zastąpiono usunięty `AppModalHost` przez `DevPlannerModalHost` dla drawera,
  akcji wiadomości i ustawień rozmowy.
- Ujednolicono konstrukcję wiadomości na autorytatywnym `authorUserId`.
- Bezpośrednie testy Chat korzystają z `package:devplanner` oraz
  `ListenableProvider<AuthSessionPort>`; test UI dyskusji wykonuje się w
  rozdzielczości desktopowej.

## Dowody walidacji

- `flutter analyze lib/workspaces/presentation/chat`: **brak problemów**.
- Zestaw 20 testów `test/workspaces/presentation/chat/**` (bez starego testu
  `resource_chat_file_action_test.dart`): **wszystkie przeszły**.
- Skan produkcyjnego scope dla `ready_next`, `AuthRepository`, `AppRouter`,
  `AppModalHost` i `authorCoreUserId`: **0 wyników**.

## Świadomie poza tą naprawą

`resource_chat_file_action_test.dart` wciąż dotyczy usuniętego globalnego
hosta `AppGlobalPanels`. Jego migracja wymaga decyzji oraz implementacji
nowego kontraktu globalnego panelu, a R2d wyraźnie wyklucza budowę overlayu.
Nie odtworzono ani nie zastąpiono go placeholderem.

Trzy istniejące pliki produkcyjne są nadal dłuższe niż 400 linii:
`chat_conversation_page.dart` (424), `chat_panel_conversation.dart` (446)
i `chat_message_composer.dart` (497). Nie zostały sztucznie dzielone w
pilnej naprawie importów; wymagają osobnego pakietu rozbicia odpowiedzialności.
