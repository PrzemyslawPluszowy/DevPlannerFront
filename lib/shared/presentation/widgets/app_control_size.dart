/// Wspólny rozmiar kontrolki UI dla formularzy i akcji.
///
/// Stosuj ten enum we wszystkich komponentach wejścia/akcji, aby trzymać
/// jedną, spójną skalę wysokości w całej aplikacji.
///
/// - [small] – kompaktowy toolbar/filtry CRM web (domyślny)
/// - [large] – standardowe formularze CRM web
enum AppControlSize { small, large }

extension AppControlSizeX on AppControlSize {
  /// Minimalna wysokość pola wejściowego (bez zewnętrznej etykiety).
  double get minHeight => switch (this) {
    AppControlSize.small => 36,
    AppControlSize.large => 44,
  };

  double get horizontalPadding => switch (this) {
    AppControlSize.small => 10,
    AppControlSize.large => 12,
  };

  double get verticalPadding => switch (this) {
    AppControlSize.small => 0,
    AppControlSize.large => 0,
  };

  double get iconSize => switch (this) {
    AppControlSize.small => 16,
    AppControlSize.large => 18,
  };
}
