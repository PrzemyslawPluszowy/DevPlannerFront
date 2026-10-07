import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_catalog.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/chat_emoji_picker.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_message_action_dialogs.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

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
    this.hasTextSelection = false,
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

  /// Czy region historii ma rzeczywisty, niepusty zaznaczony fragment.
  final bool hasTextSelection;

  final ValueChanged<ChatMessage>? onReply;

  /// Identyfikator root-a wątku, który UI otwiera po wybraniu akcji.
  final ValueChanged<ChatMessage>? onThread;

  /// Żądanie edycji; UI otwiera edytor, bo zmiana treści wymaga `Version`.
  final ValueChanged<ChatMessage>? onEdit;

  /// Żądanie usunięcia; UI potwierdza, a dopiero potem woła port.
  final ValueChanged<ChatMessage>? onDelete;

  /// Żądanie przekazania; UI wybiera rozmowę docelową.
  final void Function(ChatMessage, Offset)? onForward;

  /// Powiadamia o zmianie przypięcia, żeby odświeżyć listę przypięć.
  final ValueChanged<bool>? onPinnedChanged;

  bool get _canEdit => isOwnMessage || canModerate;

  /// Otwiera te same akcje z przycisku albo prawego kliknięcia dymka.
  Future<void> showAt(BuildContext context, Offset position) async {
    final cubit = context.read<ChatMessageSecondaryActionsCubit>();
    final state = cubit.state;
    if (state.isPending(message.id)) return;
    await AppContextMenu.show(
      context,
      globalPosition: position,
      actions: _actions(
        context,
        cubit,
        onPinnedChanged,
        position: position,
        isPinned: state.pinnedMessageIds.contains(message.id),
        isBookmarked: state.bookmarkedMessageIds.contains(message.id),
      ),
      headerTitle: context.l10n.chatMessageActionsTooltip,
      maxWidth: 300,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ChatMessageSecondaryActionsCubit,
      ChatMessageSecondaryActionsState
    >(
      builder: (context, state) {
        final busy = state.isPending(message.id);
        final failure = state.failureFor(message.id);
        return Builder(
          builder: (anchorContext) => IconButton(
            tooltip: context.l10n.chatMessageActionsTooltip,
            onPressed: busy
                ? null
                : () => unawaited(
                    showAt(
                      anchorContext,
                      AppContextMenu.positionFor(anchorContext),
                    ),
                  ),
            icon: busy
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    failure == null ? Symbols.more_vert : Symbols.error_outline,
                    size: 18,
                  ),
          ),
        );
      },
    );
  }

  List<AppContextMenuAction> _actions(
    BuildContext context,
    ChatMessageSecondaryActionsCubit cubit,
    ValueChanged<bool>? onPinnedChanged, {
    required Offset position,
    required bool isPinned,
    required bool isBookmarked,
  }) {
    AppContextMenuAction action(
      String key,
      String label,
      IconData icon, {
      bool destructive = false,
      bool separator = false,
    }) => AppContextMenuAction(
      label: label,
      icon: icon,
      isDestructive: destructive,
      separatorBefore: separator,
      // AppContextMenu jest prezentowane przez root navigator. Jego route nie
      // dziedziczy lokalnych providerów ani Actions z obszaru wiadomości,
      // dlatego akcje wymagające scope'u (reakcje, kopiowanie zaznaczenia)
      // muszą dostać kontekst przycisku, który otworzył menu.
      onTap: (_) => _handle(context, cubit, key, onPinnedChanged, position),
    );

    return <AppContextMenuAction>[
      if (onReply != null)
        action('reply', context.l10n.chatComposerReplyAction, Symbols.reply),
      action('copy', context.l10n.chatMessageCopy, Symbols.content_copy),
      if (hasTextSelection)
        action(
          'copySelection',
          context.l10n.chatMessageCopySelection,
          Symbols.copy_all,
        ),
      if (onThread != null)
        action('thread', context.l10n.chatThreadOpen, Symbols.forum),
      action('react', context.l10n.chatMessageReact, Symbols.add_reaction),
      if (onForward != null)
        action('forward', context.l10n.chatMessageForward, Symbols.forward),
      if (onEdit != null && _canEdit)
        action('edit', context.l10n.chatMessageEdit, Symbols.edit),
      if (onDelete != null && _canEdit)
        action(
          'delete',
          context.l10n.chatMessageDelete,
          Symbols.delete,
          destructive: true,
          separator: true,
        ),
      action(
        'pin',
        isPinned ? context.l10n.chatMessageUnpin : context.l10n.chatMessagePin,
        isPinned ? Symbols.push_pin : Symbols.keep,
        separator: true,
      ),
      action(
        'bookmark',
        isBookmarked
            ? context.l10n.chatMessageRemoveBookmark
            : context.l10n.chatMessageBookmark,
        isBookmarked ? Symbols.bookmark_remove : Symbols.bookmark_add,
      ),
    ];
  }

  Future<void> _handle(
    BuildContext context,
    ChatMessageSecondaryActionsCubit cubit,
    String action,
    ValueChanged<bool>? onPinnedChanged,
    Offset position,
  ) async {
    switch (action) {
      case 'copy':
        await copyChatMessage(context, message);
      case 'copySelection':
        await copyChatSelection(context);
      case 'reply':
        onReply?.call(message);
      case 'thread':
        onThread?.call(message);
      case 'edit':
        onEdit?.call(message);
      case 'delete':
        onDelete?.call(message);
      case 'forward':
        onForward?.call(message, position);
      case 'pin':
        final outcome = await cubit.togglePin(
          conversationId: message.conversationId,
          messageId: message.id,
          isPinned: isPinned,
        );
        if (outcome == ChatMessageSecondaryActionOutcome.succeeded) {
          onPinnedChanged?.call(!isPinned);
        } else if (outcome == ChatMessageSecondaryActionOutcome.failed) {
          if (!context.mounted) return;
          await ChatMessageActionDialogs.showSecondaryActionFailureForMessage(
            context,
            cubit,
            message.id,
          );
        }
      case 'bookmark':
        final outcome = await cubit.toggleBookmark(
          messageId: message.id,
          isBookmarked: isBookmarked,
        );
        if (outcome == ChatMessageSecondaryActionOutcome.failed) {
          if (!context.mounted) return;
          await ChatMessageActionDialogs.showSecondaryActionFailureForMessage(
            context,
            cubit,
            message.id,
          );
        }
      case 'react':
        if (!context.mounted) return;
        await showChatQuickReactionPicker(
          context,
          message: message,
          globalPosition: position,
        );
    }
  }
}

/// Kopiuje całą treść wiadomości do schowka.
///
/// Kopiujemy dokładnie zapisany tekst, bez dopisywania zerowych spacji ani
/// skracania, więc wklejony adres jest tym samym adresem.
Future<void> copyChatMessage(BuildContext context, ChatMessage message) async {
  final copied = context.l10n.chatMessageCopied;
  final failed = context.l10n.chatMessageCopyFailed;
  try {
    await Clipboard.setData(ClipboardData(text: message.text));
    if (context.mounted) AppToast.show(context, message: copied);
  } on Object {
    if (context.mounted) {
      AppToast.show(context, message: failed, tone: AppToastTone.error);
    }
  }
}

/// Kopiuje wyłącznie zaznaczony fragment historii.
///
/// Używamy tego samego intentu co Ctrl+C w regionie zaznaczania, więc akcja z
/// menu robi dokładnie to, co skrót klawiaturowy: przy braku zaznaczenia nic nie
/// kopiuje i nie zgłasza pozornego sukcesu.
Future<void> copyChatSelection(BuildContext context) => Future<void>.sync(
  () => Actions.maybeInvoke(context, CopySelectionTextIntent.copy),
);

/// Pokazuje pasek szybkich reakcji z wejściem do pełnego pickera.
///
/// Szybkie reakcje pochodzą ze wspólnego katalogu, więc composer, reakcje i
/// status proponują te same znaki; `+` otwiera pełny picker z wyszukiwaniem
/// i kategoriami zamiast zamykać użytkownika w sześciu pozycjach.
Future<void> showChatQuickReactionPicker(
  BuildContext context, {
  required ChatMessage message,
  required Offset globalPosition,
}) async {
  final cubit = context.read<ChatMessageSecondaryActionsCubit>();
  final chat = context.chatTheme;
  String? selected;
  await AppContextMenu.showCustom(
    context,
    globalPosition: globalPosition,
    maxWidth: 304,
    maxHeight: 76,
    contentBuilder: (_, dismiss) => Theme(
      data: chat.applyControls(Theme.of(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final emoji in ChatEmojiCatalog.quickReactions)
            IconButton(
              key: ValueKey<String>('chat-reaction-$emoji'),
              tooltip: emoji,
              onPressed: () {
                selected = emoji;
                dismiss();
              },
              icon: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          IconButton(
            key: const ValueKey('chat-reaction-more'),
            tooltip: context.l10n.chatComposerEmoji,
            onPressed: () {
              selected = _moreReactionsToken;
              dismiss();
            },
            icon: const Icon(Symbols.add_reaction, size: 22),
          ),
        ],
      ),
    ),
  );
  final selectedReaction = selected;
  if (selectedReaction == null) return;
  if (selectedReaction == _moreReactionsToken) {
    if (!context.mounted) return;
    final emoji = await showChatEmojiPicker(
      context,
      recent: context.read<ChatEmojiRecentCubit?>(),
      anchorPosition: globalPosition,
    );
    if (emoji == null) return;
    final outcome = await cubit.react(messageId: message.id, emoji: emoji);
    if (outcome == ChatMessageSecondaryActionOutcome.failed &&
        context.mounted) {
      await ChatMessageActionDialogs.showSecondaryActionFailureForMessage(
        context,
        cubit,
        message.id,
      );
    }
    return;
  }
  final outcome = await cubit.react(
    messageId: message.id,
    emoji: selectedReaction,
  );
  if (outcome == ChatMessageSecondaryActionOutcome.failed && context.mounted) {
    await ChatMessageActionDialogs.showSecondaryActionFailureForMessage(
      context,
      cubit,
      message.id,
    );
  }
}

/// Znacznik pozycji `+` w pasku szybkich reakcji.
const String _moreReactionsToken = '\u0000more-reactions';
