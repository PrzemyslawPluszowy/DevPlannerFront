import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/models/chat_message_action_models.dart';
import 'package:devplanner/workspaces/presentation/chat/conversation_delivery/chat_client_message_id_factory.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Dialogi akcji wiadomości, montowane w rootowym hoście modali.
///
/// Każdy dialog ma realny skutek: potwierdzenie usunięcia, edycję z wersją
/// wiadomości i wybór rozmowy docelowej dla przekazania. Zamknięcie dialogu
/// nie wykonuje żadnej akcji.
abstract final class ChatMessageActionDialogs {
  /// Potwierdza i wykonuje logiczne usunięcie wiadomości.
  static Future<void> confirmDelete(
    BuildContext context, {
    required ChatMessage message,
  }) async {
    final confirmed = await DevPlannerModalHost.showDialog<bool>(
      context,
      builder: (dialogContext) => ChatSurfaceDialog(
        title: dialogContext.l10n.chatMessageDeleteConfirmTitle,
        content: Text(dialogContext.l10n.chatMessageDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.chatCreationCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: dialogContext.chatTheme.error,
              foregroundColor: Colors.white,
            ),
            child: Text(dialogContext.l10n.chatMessageDeleteConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<ChatMessageActionsCubit>().delete(message);
  }

  /// Otwiera edytor treści i zapisuje zmianę z wersją wiadomości.
  static Future<void> edit(
    BuildContext context, {
    required ChatMessage message,
  }) async {
    // Kontroler żyje tylko przez czas otwartego dialogu i jest zwalniany po
    // odczytaniu treści, również gdy użytkownik anuluje.
    final controller = TextEditingController(text: message.text);
    final text = await DevPlannerModalHost.showDialog<String>(
      context,
      builder: (dialogContext) => ChatSurfaceDialog(
        title: dialogContext.l10n.chatMessageEditTitle,
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          minLines: 1,
          style: dialogContext.chatTheme.contentStyle.copyWith(
            color: dialogContext.chatTheme.incomingText,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: dialogContext.chatTheme.composerSurface,
            contentPadding: const EdgeInsets.all(Sizes.p12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: dialogContext.chatTheme.separator),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: dialogContext.chatTheme.separator),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: dialogContext.chatTheme.focusRing,
                width: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(dialogContext.l10n.chatCreationCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: Text(dialogContext.l10n.chatMessageEditSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null || text.trim().isEmpty || !context.mounted) return;
    await context.read<ChatMessageActionsCubit>().edit(
      message: message,
      text: text,
    );
  }

  /// Wybiera rozmowę docelową i przekazuje wiadomość.
  static Future<void> forward(
    BuildContext context, {
    required ChatMessage message,
    required List<ChatInboxItem> conversations,
    ChatClientMessageIdFactory? idFactory,
  }) async {
    final targets = conversations
        .where((item) => item.conversation.id != message.conversationId)
        .toList(growable: false);
    if (targets.isEmpty) {
      await DevPlannerModalHost.showDialog<void>(
        context,
        builder: (dialogContext) => ChatSurfaceDialog(
          title: dialogContext.l10n.chatMessageForwardTitle,
          content: Text(dialogContext.l10n.chatMessageForwardEmpty),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(dialogContext.l10n.frameworkClose),
            ),
          ],
        ),
      );
      return;
    }
    final target = await DevPlannerModalHost.showDialog<ChatInboxItem>(
      context,
      builder: (dialogContext) => ChatSurfaceDialog(
        title: dialogContext.l10n.chatMessageForwardTitle,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in targets)
              Padding(
                padding: const EdgeInsets.only(bottom: Sizes.p8),
                child: Material(
                  color: dialogContext.chatTheme.panelSurface,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    onTap: () => Navigator.of(dialogContext).pop(item),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p10),
                      child: Row(
                        children: [
                          Icon(
                            Symbols.forum_rounded,
                            color: dialogContext.chatTheme.metadataText,
                            size: 20,
                          ),
                          const SizedBox(width: Sizes.p10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: dialogContext.chatTheme.contentStyle
                                      .copyWith(
                                        color: dialogContext
                                            .chatTheme
                                            .incomingText,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                if (item.lastMessage?.text case final preview?)
                                  Text(
                                    preview,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: dialogContext.chatTheme.metadataStyle
                                        .copyWith(
                                          color: dialogContext
                                              .chatTheme
                                              .metadataText,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    if (target == null || !context.mounted) return;
    // Nowy idempotency key dla przekazania; powtórzenie użyje tego samego.
    final clientMessageId = (idFactory ?? ChatClientMessageIdFactory())
        .create();
    await context.read<ChatMessageSecondaryActionsCubit>().forward(
      messageId: message.id,
      targetConversationId: target.conversation.id,
      clientMessageId: clientMessageId,
    );
  }
}

/// Pasek zagregowanych reakcji pod wiadomością.
class ChatMessageReactionsBar extends StatelessWidget {
  /// Tworzy pasek reakcji z agregatów backendu.
  const ChatMessageReactionsBar({
    required this.summaries,
    this.onToggle,
    super.key,
  });

  /// Zagregowane reakcje wiadomości; backend liczy je po stronie serwera.
  final List<ChatReactionSummary> summaries;

  /// Dodaje albo usuwa własną reakcję; `isOwn` pochodzi z agregatu.
  final void Function(String emoji, bool isOwn)? onToggle;

  @override
  Widget build(BuildContext context) {
    if (summaries.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: Sizes.p4,
      children: [
        for (final summary in summaries)
          _ChatReactionChip(
            emoji: summary.emoji,
            count: summary.count,
            isOwn: summary.reactedByCurrentUser,
            onToggle: onToggle,
          ),
      ],
    );
  }
}

class _ChatReactionChip extends StatelessWidget {
  const _ChatReactionChip({
    required this.emoji,
    required this.count,
    required this.isOwn,
    this.onToggle,
  });

  final String emoji;
  final int count;
  final bool isOwn;
  final void Function(String emoji, bool isOwn)? onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chat = context.chatTheme;
    return InkWell(
      onTap: onToggle == null ? null : () => onToggle!(emoji, isOwn),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: isOwn ? chat.selectedSurface : chat.listSurface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          '$emoji $count',
          style: chat.metadataStyle.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
