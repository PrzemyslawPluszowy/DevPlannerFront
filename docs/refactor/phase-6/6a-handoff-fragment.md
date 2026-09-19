# Handoff fragment — 6A standalone foundation

- **Stan:** IN PROGRESS — standalone root, branding and one-origin runtime
  boundary are in place; auth and the full Workspaces composition remain.
- **Canonical entry:** `lib/main.dart` → `lib/app/bootstrap/app_bootstrap.dart`
  → `lib/bootstrap/app_bootstrap.dart` → `DevPlannerApp`.
- **Canonical router:** `lib/app/router/devplanner_router.dart`. It has no
  legacy paths, redirects, parent shell or compatibility adapter. Guard logic
  and intended-route handling live in `DevPlannerAuthGuard`; nested
  workspace/project/task/resource/file/wiki/whiteboard paths are explicit
  placeholders for the next Workspaces slice.
- **Runtime boundary:** `foundation/config/app_env.dart` exposes only
  `DEVPLANNER_API_BASE_URL`; bootstrap does not instantiate host bridges or
  communicate with Ready/Core/DataBus.
- **Removed from active workspace:** old composition root/router/shell,
  embedded web host protocol, host route parser and separate-backend legacy
  modules (BHP, Inventory, Dashboard, Orders, framework, inne). Their active
  imports/tests were detached and moved out of the workspace for review.
- **Remaining import graph:** exactly 25 dormant Workspaces/shared/settings
  presentation files still reference the former router/settings/dashboard
  widget APIs. They are not reachable from the new root; migrate or remove
  them in the next safe Workspaces slice before claiming 6A complete.
- **Validation:** targeted analyzer and router/foundation/API tests pass; full suite
  and platform builds were not run.
- **Do not change:** mirrored shared plan/handoff documents; do not restore
  compatibility aliases, legacy redirects, host token hand-off or module API
  endpoints.
