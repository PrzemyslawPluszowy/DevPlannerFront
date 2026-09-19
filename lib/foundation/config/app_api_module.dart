/// Logical API surfaces exposed by the standalone DevPlanner backend.
enum AppApiModule {
  /// Local identity/auth surface (until the OIDC adapter lands).
  auth,

  /// Workspaces and the DevPlanner domain surface.
  workspaces,
}
