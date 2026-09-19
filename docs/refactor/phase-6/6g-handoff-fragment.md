# Handoff fragment — 6G globalne Notifications

- **Status:** COMPLETE dla panelu, trasy i granicy composition root.
- **Composition:** `DevPlannerGlobalNotificationsComposition` zawiera
  `NotificationsRepository` i opcjonalny `WorkspaceNotificationsRealtimeService`.
- **Root entry:** `AppGlobalNotificationsDrawer.show` korzysta z
  `DevPlannerModalHost.showSideSheet`, root navigatora i `topInset: 64`.
- **A11y/lifecycle:** panel ma `FocusTraversalGroup`, Semantics z nazwą trasy,
  Escape, barrier i close button; Cubit żyje tylko przez panel/pełną trasę.
- **Routes:** `/notifications` renderuje pełną skrzynkę, a brak kompozycji daje
  `DevPlannerNotificationsUnavailablePage` (fail closed).
- **Transport:** widgety nie znają Dio/SignalR/auth/secure storage. Bootstrap
  nie ma jeszcze rzeczywistego standalone transportu — to świadoma granica.
- **Weryfikacja:** `flutter analyze`, testy scoped Notifications/router/shell i
  `git diff --check`.
- **Nie wykonano:** commit/push oraz aktualizacja wspólnego planu/handoffu;
  koordynator powinien zsynchronizować je po review pakietu.
