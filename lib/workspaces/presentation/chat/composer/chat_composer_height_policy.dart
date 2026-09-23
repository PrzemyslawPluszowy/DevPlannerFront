/// Ograniczenia wysokości edytora względem widocznej historii rozmowy.
abstract final class ChatComposerHeightPolicy {
  /// Maksymalna część wysokości rozmowy zajmowana przez samo pole edytora.
  static const double availableHeightFraction = .3;

  /// Minimalna wysokość pola jednej linii wraz z pionowym paddingiem.
  static const double minimumEditorHeight = 40;

  /// Wysokość edytora, ograniczona tokenem motywu i rozmiarem rozmowy.
  ///
  /// Przy bardzo niskim oknie zachowuje jedną linię, żeby przycisk wysyłania
  /// i możliwość wpisania krótkiej wiadomości pozostały dostępne.
  static double maxEditorHeight({
    required double availableConversationHeight,
    required double themeMaxHeight,
  }) {
    final responsiveLimit = availableConversationHeight.isFinite
        ? availableConversationHeight * availableHeightFraction
        : themeMaxHeight;
    return responsiveLimit.clamp(minimumEditorHeight, themeMaxHeight);
  }
}
