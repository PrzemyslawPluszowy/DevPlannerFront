import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_metadata.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Stopka dymka: godzina, znacznik edycji i status dostawy.
///
/// Status pochodzi wyłącznie z potwierdzenia serwera albo kolejki wysyłki;
/// brak potwierdzenia nie jest przedstawiany jako dostarczenie.
class ChatMessageFooter extends StatelessWidget {
  const ChatMessageFooter({
    required this.message,
    required this.isOwn,
    this.onRetry,
    super.key,
  });

  final ChatMessage message;
  final bool isOwn;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final muted = chat.metadataStyle.copyWith(color: chat.metadataText);
    final status = ChatMessageMetadata.statusFor(
      message: message,
      isOwn: isOwn,
    );
    return Padding(
      padding: const EdgeInsets.only(top: Sizes.p4),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Sizes.p4,
        children: [
          Text(
            ChatMessageMetadata.timeLabel(message.createdAtUtc),
            style: muted,
          ),
          if (message.isEdited)
            Text(context.l10n.chatMessageEdited, style: muted),
          if (status != null)
            _ChatMessageStatusGlyph(
              kind: status.kind,
              count: status.count,
              style: muted,
            ),
          if (status != null && status.canRetry && onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(context.l10n.chatMessageRetry),
            ),
        ],
      ),
    );
  }
}

/// Ikona i etykieta statusu wysyłki.
class _ChatMessageStatusGlyph extends StatelessWidget {
  const _ChatMessageStatusGlyph({
    required this.kind,
    this.count = 0,
    this.style,
  });

  final ChatMessageStatusKind kind;

  /// Liczba potwierdzonych odbiorców dla statusów dostawy i odczytu.
  final int count;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final (icon, label) = switch (kind) {
      ChatMessageStatusKind.sending => (
        Symbols.schedule,
        context.l10n.chatMessageStatusSending,
      ),
      ChatMessageStatusKind.sent => (
        Symbols.check,
        context.l10n.chatMessageStatusSent,
      ),
      ChatMessageStatusKind.delivered => (
        Symbols.done_all,
        context.l10n.chatMessageStatusDelivered(count),
      ),
      ChatMessageStatusKind.read => (
        Symbols.done_all,
        context.l10n.chatMessageStatusRead(count),
      ),
      ChatMessageStatusKind.failed => (
        Symbols.error_outline,
        context.l10n.chatMessageStatusFailed,
      ),
    };
    final color = switch (kind) {
      ChatMessageStatusKind.failed => chat.error,
      ChatMessageStatusKind.read => chat.deliveryRead,
      _ => chat.metadataText,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: Sizes.p4),
        Text(label, style: style?.copyWith(color: color)),
      ],
    );
  }
}
