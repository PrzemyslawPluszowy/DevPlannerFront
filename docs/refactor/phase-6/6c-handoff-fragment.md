# Handoff fragment — 6C standalone shell

- Added responsive `DevPlannerShellRoute` with reserved top-bar space,
  wide-screen rail and compact bottom navigation.
- Global Chat and Notifications actions are available from every shell route;
  panel opening is root-scoped through `DevPlannerModalHost` and injectable via
  narrow callbacks for Workspaces ports.
- Added focused test: `test/app/shell/devplanner_shell_test.dart`.
- No legacy shell, Ready, BHP, Inventory or Dashboard dependencies were added.
- The parent router agent should wire real Workspaces chat/notifications panel
  ports once repository providers are composed at the standalone root.
