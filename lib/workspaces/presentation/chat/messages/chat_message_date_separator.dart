import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Separator dnia nad serią dymków.
///
/// Jest osobnym elementem historii, a nie autorem wiadomości, więc nie udaje
/// dymka i nie miesza się z grupowaniem serii.
class ChatMessageDateSeparator extends StatelessWidget {
  /// Tworzy separator dla lokalnego początku dnia.
  const ChatMessageDateSeparator({required this.day, super.key});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: chat.hoverSurface,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p8,
              vertical: Sizes.p4,
            ),
            child: Text(
              MaterialLocalizations.of(context).formatFullDate(day),
              style: chat.metadataStyle.copyWith(color: chat.metadataText),
            ),
          ),
        ),
      ),
    );
  }
}
