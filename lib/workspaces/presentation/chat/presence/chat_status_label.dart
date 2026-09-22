import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:flutter/material.dart';

/// Etykieta statusu użytkownika: emoji oraz tekst albo DND.
///
/// Status jest danymi serwera; etykieta nic nie zapisuje i nie zgaduje stanu
/// obecności z istnienia konta.
class ChatStatusLabel extends StatelessWidget {
  /// Tworzy etykietę statusu.
  const ChatStatusLabel({required this.status, this.style, super.key});

  final ChatUserStatus? status;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final current = status;
    if (current == null) return const SizedBox.shrink();
    final label = <String>[
      if (current.emoji?.trim().isNotEmpty == true) current.emoji!.trim(),
      if (current.text?.trim().isNotEmpty == true) current.text!.trim(),
      if (current.isDnd) context.l10n.chatStatusDnd,
    ].join(' ');
    if (label.isEmpty) return const SizedBox.shrink();
    return Text(
      label,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
