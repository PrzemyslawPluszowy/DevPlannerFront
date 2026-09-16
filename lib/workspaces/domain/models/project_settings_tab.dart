/// Dostępne zakładki w centrum ustawień projektu.
///
/// Definiuje logiczne sekcje konfiguracji projektu używane przez model uprawnień
/// `ProjectCapabilities` oraz interfejs użytkownika modalu ustawień.
enum ProjectSettingsTab {
  /// Podstawowe dane projektu, widoczność i akcje niebezpieczne.
  general,

  /// Lista członków projektu i zarządzanie ich rolami.
  members,

  /// Konfiguracja etapów projektu i przejść między statusami.
  workflow,

  /// Definicje niestandardowych atrybutów zadań.
  customFields,

  /// Etykiety używane do kategoryzacji zadań.
  labels,

  /// Kamienie milowe i powiązane cele czasowe.
  milestones,

  /// Reguły i wyzwalacze automatyzacji.
  automations,

  /// Szablony zadań i projektu.
  templates,
}
