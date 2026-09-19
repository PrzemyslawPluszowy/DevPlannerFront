# Handoff fragment — 7C dashboard/settings removal

- **Stan:** COMPLETE dla usuniętych legacy dashboard/settings-only components.
- **Usunięto:** `features/settings` presentation page and parts/export,
  `AppShellWallpaper` plus wallpaper background, and six `assets/images/std_bg_*`
  wallpaper files.
- **Zachowano:** local menu settings and current-user avatar Cubits/repository,
  because active Workspaces/Storage code still consumes them; no compatibility
  adapter or legacy dashboard API was restored.
- **Hive:** removed dormant dashboard preference adapter declarations from
  `lib/core/storage/hive_helper.g.yaml`; existing type IDs were not renumbered.
- **API contracts:** removed dashboard preference methods/models from
  `WorkspaceFeatureApi`/`WorkspaceFeaturesRepository`; retained search,
  activity and Wiki/Whiteboard task-sync contracts.
- **Validation:** targeted `rg` residual scan and `git diff --check` PASS;
  local-settings repository/Cubit tests PASS. The standalone Hive registrar
  removes the missing-registrar test errors without restoring dashboard
  adapters. Full analyze currently reports 656 total issues / 76 errors,
  limited to unrelated router/modal-shell migration errors.
- **Do not change:** app router migration task/shared plans/handoffs. Next agent
  should rerun analyzer and the affected settings/storage/workspaces tests, then
  complete the remaining 7C/7D l10n/generated-contract scan.
