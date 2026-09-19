# 6C — standalone DevPlanner shell

**Stan:** IN PROGRESS, 2026-09-16.

`DevPlannerShellRoute` is now the authenticated route shell. It reserves a
stable 64px top-bar region, uses a responsive `NavigationRail` on wide screens
and `NavigationBar` on compact screens, and keeps the current route content
independent from shell layout.

Chat and Notifications are exposed as narrow `VoidCallback` panel ports. The
default implementation opens a root-scoped `DevPlannerModalHost` side sheet;
the composition root can provide Workspaces-backed panel callbacks without
putting repositories or API clients in the shell widget. Legacy shell,
Ready/BHP/Inventory/Dashboard imports and adapters are not used.

Focused widget coverage verifies the reserved content region and that both
global actions remain callable without changing the route.

Validation: `dart analyze lib/app/shell/devplanner_shell.dart` PASS;
`flutter test test/app/shell/devplanner_shell_test.dart` pending full shared
router migration stabilization.
