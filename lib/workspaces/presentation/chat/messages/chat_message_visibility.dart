import 'dart:ui' show Rect;

/// Geometry rules for marking the latest chat message as visibly read.
abstract final class ChatMessageVisibility {
  /// A message must have at least half its area inside the conversation viewport.
  static const double minimumVisibleFraction = .5;

  /// Whether at least [minimumVisibleFraction] of a message is in the viewport.
  static bool isMajorityVisible(Rect message, Rect viewport) {
    if (message.isEmpty || viewport.isEmpty) return false;
    final intersection = message.intersect(viewport);
    if (intersection.isEmpty) return false;
    final messageArea = message.width * message.height;
    final visibleArea = intersection.width * intersection.height;
    return messageArea > 0 &&
        visibleArea / messageArea >= minimumVisibleFraction;
  }
}
