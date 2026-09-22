import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Zestaw emoji dostępny w szybkiej reakcji pod wiadomością.
///
/// Lista jest stała i mała, więc nie wymaga zewnętrznego pickera ani
/// dodatkowego zapytania; każda pozycja ma realny skutek w backendzie.
const List<String> chatQuickReactions = <String>[
  '👍',
  '✅',
  '❤️',
  '😄',
  '🎉',
  '👀',
];

/// Menu akcji jednej wiadomości w panelu rozmowy.
///
/// Menu pokazuje wyłącznie akcje, które mają realny skutek: każda pozycja jest
/// wywołaniem portu, a błąd wraca jako kod domenowy przy wiadomości. Autor i
/// rola decydują o widoczności edycji oraz usunięcia; backend i tak ponownie
/// egzekwuje uprawnienia.
class ChatMessageActionMenu extends StatelessWidget {
  /// Tworzy menu akcji wiadomości.
  const ChatMessageActionMenu({
    required this.message,
    required this.isOwnMessage,
    required this.canModerate,
    required this.isPinned,
    required this.isBookmarked,
    required this.currentUserId,
    this.onReply,
    this.onThread,
    this.onEdit,
    this.onDelete,
    this.onForward,
    this.onPinnedChanged,
    super.key,
  });

  final ChatMessage message;
  final bool isOwnMessage;
  final bool canModerate;
  final bool isPinned;
  final bool isBookmarked;

  /// Local UserId bieżącej sesji, potrzebny do rozpoznania własnej reakcji.
  final String currentUserId;

  final ValueChanged<ChatMessage>? onReply;

  /// Identyfikator root-a wątku, który UI otwiera po wybraniu akcji.
  final ValueChanged<ChatMessage>? onThread;

  /// Żądanie edycji; UI otwiera edytor, bo zmiana treści wymaga `Version`.
  final ValueChanged<ChatMessage>? onEdit;

  /// Żądanie usunięcia; UI potwierdza, a dopiero potem woła port.
  final ValueChanged<ChatMessage>? onDelete;

  /// Żądanie przekazania; UI wybiera rozmowę docelową.
  final ValueChanged<ChatMessage>? onForward;

  /// Powiadamia o zmianie przypięcia, żeby odświeżyć listę przypięć.
  final ValueChanged<bool>? onPinnedChanged;

  bool get _canEdit => isOwnMessage || canModerate;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatMessageSecondaryActionsCubit>();
    return BlocBuilder<
      ChatMessageSecondaryActionsCubit,
      ChatMessageSecondaryActionsState
    >(
      builder: (context, state) {
        final busy = state.isPending(message.id);
        final failure = state.failureFor(message.id);
        return PopupMenuButton<String>(
          tooltip: context.l10n.chatMessageActionsTooltip,
          enabled: !busy,
          itemBuilder: (context) => <PopupMenuEntry<String>>[
            if (onReply != null)
              _item(context, 'reply', Symbols.reply_rounded, context.l10n.chatComposerReplyAction),
            if (onThread != null)
              _item(context, 'thread', Symbols.forum, context.l10n.chatThreadOpen),
            _item(
              context,
              'react',
              Symbols.add_reaction,
              context.l10n.chatMessageReact,
            ),
            if (onForward != null)
              _item(
                context,
                'forward',
                Symbols.forward,
                context.l10n.chatMessageForward,
              ),
            if (onEdit != null && _canEdit)
              _item(context, 'edit', Symbols.edit, context.l10n.chatMessageEdit),
            if (onDelete != null && _canEdit)
              _item(
                context,
                'delete',
                Symbols.delete,
                context.l10n.chatMessageDelete,
              ),
            _item(
              context,
              'pin',
              isPinned ? Symbols.push_pin : Symbols.keep,
              isPinned
                  ? context.l10n.chatMessageUnpin
                  : context.l10n.chatMessagePin,
            ),
            _item(
              context,
              'bookmark',
              isBookmarked ? Symbols.bookmark_remove : Symbols.bookmark_add,
              isBookmarked
                  ? context.l10n.chatMessageRemoveBookmark
                  : context.l10n.chatMessageBookmark,
            ),
          ],
          onSelected: (value) => unawaited(
            _handle(context, cubit, value, onPinnedChanged),
          ),
          icon: busy
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  failure == null
                      ? Symbols.more_vert
                      : Symbols.error_outline,
                  size: 18,
                ),
        );
      },
    );
  }

  static PopupMenuItem<String> _item(
    BuildContext context,
    String value,
    IconData icon,
    String label,
  ) => PopupMenuItem<String>(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: Sizes.p8),
        Text(label),
      ],
    ),
  );

  Future<void> _handle(
    BuildContext context,
    ChatMessageSecondaryActionsCubit cubit,
    String action,
    ValueChanged<bool>? onPinnedChanged,
  ) async {
    switch (action) {
      case 'reply':
        onReply?.call(message);
      case 'thread':
        onThread?.call(message);
      case 'edit':
        onEdit?.call(message);
      case 'delete':
        onDelete?.call(message);
      case 'forward':
        onForward?.call(message);
      case 'pin':
        await cubit.togglePin(
          conversationId: message.conversationId,
          messageId: message.id,
          isPinned: isPinned,
        );
        onPinnedChanged?.call(!isPinned);
      case 'bookmark':
        await cubit.toggleBookmark(
          messageId: message.id,
          isBookmarked: isBookmarked,
        );
      case 'react':
        if (!context.mounted) return;
        await showChatQuickReactionPicker(context, message: message);
    }
  }
}

/// Pokazuje pasek szybkich reakcji dla wiadomości.
Future<void> showChatQuickReactionPicker(
  BuildContext context, {
  required ChatMessage message,
}) async {
  final cubit = context.read<ChatMessageSecondaryActionsCubit>();
  final selected = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.all(Sizes.p12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final emoji in chatQuickReactions)
            IconButton(
              tooltip: emoji,
              onPressed: () => Navigator.of(sheetContext).pop(emoji),
              icon: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
        ],
      ),
    ),
  );
  if (selected == null) return;
  await cubit.react(messageId: message.id, emoji: selected);
}
