/// Moduly frontendowe korzystajace z osobnych bazowych URL-i API.
enum AppApiModule {
  /// Glowny backend inwentaryzacji.
  inventory,

  /// Centralny backend logowania i odświeżania sesji Veloryn Core.
  auth,

  /// Backend dedykowany dla modulu BHP.
  bhp,

  /// Dedykowany backend Veloryn Workspaces.
  workspaces,
}
