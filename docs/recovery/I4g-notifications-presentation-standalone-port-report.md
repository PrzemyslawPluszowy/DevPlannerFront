# I4g — standalone port prezentacji powiadomień

## Zakres

Port objął wyłącznie istniejącą prezentację powiadomień. Nie dodaje ekranu
Chat, nie zmienia aktywnego routingu i nie integruje jeszcze globalnego
overlayu w shellu.

## Zmiany

- modale preferencji i odpowiedzi korzystają z
  `DevPlannerModalHost`, a nie z usuniętego `AppModalHost`;
- deeplinki elementów inboxa przechodzą przez typowane,
  standalone `DevPlannerNavigation`;
- lokalny tryb dialogu odpowiedzi używa prywatnego `ValueNotifier` i
  `ValueListenableBuilder`, zwalnianego w `dispose`;
- nie dodano `setState`, globalnych funkcji, aliasów Ready/Core ani logiki
  HTTP do widgetów.

## Granice

Chat i powiadomienia nie są jeszcze elementami globalnego prawego overlayu.
To osobny etap po domknięciu kompozycji shellu, lifecycle SignalR, focus
restoration oraz ręcznym desktopowym E2E. Nie wolno w międzyczasie podłączać
legacy strony Chat do routera jako substytutu overlayu.

## Walidacja

```text
flutter analyze lib/workspaces/presentation/notifications \
  lib/workspaces/data/notifications \
  lib/workspaces/domain/notifications
```

Wynik: `No issues found!`.

```text
flutter test test/workspaces/data/notifications/notification_settings_repositories_test.dart
```

Wynik: PASS, 7/7. Ten test weryfikuje mapowanie preferencji, digestu i
odpowiedzi oraz typowane błędy 401/403. Nie jest dowodem pełnego realtime ani
globalnego overlayu.

```text
flutter test test/workspaces/data/notifications \
  test/workspaces/domain/notifications \
  test/workspaces/presentation/notifications
```

Wynik: PASS, 46/46. Zakres obejmuje modele, repozytoria, Cubity, inbox
standalone, modal preferencji i modal odpowiedzi. Nie kontaktuje się z realnym
backendem, SignalR ani natywnym desktopowym UI.
