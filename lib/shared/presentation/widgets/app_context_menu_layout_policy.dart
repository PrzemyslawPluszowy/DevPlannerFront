import 'dart:math' as math;

/// Czyste ograniczenia powierzchni menu względem widoku overlayu.
abstract final class AppContextMenuLayoutPolicy {
  /// Zwraca maksymalne i minimalne rozmiary dziecka z zachowaniem marginesu.
  static ({double minWidth, double maxWidth, double maxHeight}) constraints({
    required double availableWidth,
    required double availableHeight,
    required double requestedMaxWidth,
    required double? requestedMaxHeight,
    required double viewportMargin,
    required double preferredMinWidth,
  }) {
    final maxWidth = math
        .max(
          0,
          math.min(requestedMaxWidth, availableWidth - viewportMargin * 2),
        )
        .toDouble();
    final minWidth = math.min(
      maxWidth,
      math.min(availableWidth, preferredMinWidth),
    );
    final maxHeight = math
        .max(
          0,
          math.min(
            requestedMaxHeight ?? availableHeight,
            availableHeight - viewportMargin * 2,
          ),
        )
        .toDouble();
    return (minWidth: minWidth, maxWidth: maxWidth, maxHeight: maxHeight);
  }
}
