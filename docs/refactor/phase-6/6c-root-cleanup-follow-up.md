# 6C follow-up — root shell and legacy utility cleanup

**Stan:** COMPLETE dla tego follow-upu, 2026-09-16.

## Zakres

- Root shell ma teraz rzeczywistą, cienką belkę DevPlanner: branding, kontekst
  bieżącej trasy oraz akcje Chat i Notifications. Zarezerwowane 64 px nie jest
  pustą przestrzenią, a akcje nie są już umieszczone w pływającym FAB-ie.
- Porty `onChatRequested` i `onNotificationsRequested` pozostają w shellu jako
  jawne callbacki kompozycji. Gdy kompozycja nie dostarczy adaptera panelu,
  akcja nawiguje do kanonicznej trasy `/chat` albo `/notifications`; shell nie
  tworzy fałszywego side-sheeta ani pustego placeholdera udającego gotową
  funkcję.
- Usunięto nieosiągalne legacy utility surfaces:
  `app_global_module_rail*`, `app_global_utility_bar*` oraz
  `app_global_utility_pages.dart`. Usunięto także nieużywane
  `ReadyPermissions`, `ModulePlaceholderPage` oraz nazwy rozszerzeń
  `ReadyNext*`. Żaden z tych entry pointów nie był importowany przez aktywny
  graf `lib/` ani testów.

## Walidacja

- `dart format lib/app/shell/devplanner_shell.dart`
- `flutter test test/app/shell/devplanner_shell_test.dart`
- `flutter analyze`
- `git diff --check`

Wszystkie powyższe komendy zakończyły się powodzeniem. Shell test: 1 test,
`flutter analyze`: `No issues found!`.

Nie zmieniono backendu, wspólnego planu ani wspólnego handoffu. Nie dodano
redirectów ani aliasów legacy.
