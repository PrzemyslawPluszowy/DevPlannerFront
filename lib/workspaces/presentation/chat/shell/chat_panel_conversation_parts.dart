import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nieblokujący komunikat o stanie połączenia SignalR w panelu Chat.
final class ChatPanelConnectionBanner extends StatelessWidget {
  const ChatPanelConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<ChatRealtimeStatusCubit?>() == null) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<
      ChatRealtimeStatusCubit,
      WorkspaceSignalRConnectionState
    >(
      builder: (context, state) {
        final message = switch (state) {
          WorkspaceSignalRConnectionState.connected => null,
          WorkspaceSignalRConnectionState.connecting =>
            context.l10n.globalChatConnecting,
          WorkspaceSignalRConnectionState.reconnecting =>
            context.l10n.globalChatReconnecting,
          WorkspaceSignalRConnectionState.disconnected =>
            context.l10n.globalChatOffline,
        };
        if (message == null) return const SizedBox.shrink();
        return Semantics(
          liveRegion: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              border: Border(
                bottom: BorderSide(color: context.colors.outlineVariant),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p8,
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.info,
                    size: 18,
                    color: context.colors.onSurfaceVariant,
                  ),
                  Gaps.w8,
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Nagłówek panelu rozmowy oraz kontekst udostępnionego pliku.
final class ChatPanelConversationHeader extends StatelessWidget {
  const ChatPanelConversationHeader({
    required this.conversation,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
    super.key,
  });

  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, Sizes.p4),
    child: Column(
      children: [
        if (resourceContext case final current?)
          _ResourceChatHeader(context: current),
        Row(
          children: [
            IconButton(
              tooltip: context.l10n.globalChatBackToConversations,
              onPressed: onBack,
              icon: const Icon(Symbols.arrow_back_rounded, size: 19),
            ),
            Expanded(
              child: Text(
                conversation.name?.trim().isNotEmpty == true
                    ? conversation.name!
                    : conversation.scopeKey,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleSmall,
              ),
            ),
            IconButton(
              tooltip: context.l10n.chatConversationNotificationSettingsOpen,
              onPressed: () => ChatConversationNotificationSettingsModal.show(
                context,
                conversationId: conversation.id,
              ),
              icon: const Icon(Symbols.notifications_rounded, size: 18),
            ),
            if (onOpenFullView != null)
              IconButton(
                tooltip: context.l10n.globalChatOpenFullView,
                onPressed: onOpenFullView,
                icon: const Icon(Symbols.open_in_new_rounded, size: 18),
              ),
          ],
        ),
      ],
    ),
  );
}

/// Zwięzły, świeży kontekst pliku nad rozmową Resource Chat.
final class _ResourceChatHeader extends StatelessWidget {
  const _ResourceChatHeader({required this.context});

  final ResourceChatFileContext context;

  @override
  Widget build(BuildContext buildContext) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p8,
        Sizes.p4,
        Sizes.p8,
        Sizes.p8,
      ),
      child: Text(
        buildContext.l10n.resourceChatFileHeader(
          context.fileName,
          context.ownerUserId,
          context.accessLevel,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: buildContext.text.labelSmall?.copyWith(
          color: buildContext.colors.onSurfaceVariant,
        ),
      ),
    ),
  );
}

/// Zwarta lista wiadomości używana wyłącznie w prawym panelu Chat.
final class ChatPanelMessageList extends StatelessWidget {
  const ChatPanelMessageList({
    required this.messages,
    required this.isSending,
    required this.onReply,
    super.key,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final ValueChanged<ChatMessage> onReply;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.symmetric(
      horizontal: Sizes.p12,
      vertical: Sizes.p8,
    ),
    reverse: true,
    itemCount: messages.length + (isSending ? 1 : 0),
    separatorBuilder: (context, index) => const SizedBox(height: Sizes.p8),
    itemBuilder: (context, index) {
      if (isSending && index == 0) {
        return const Align(
          alignment: Alignment.centerLeft,
          child: SizedBox.square(
            dimension: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      }
      final message =
          messages[messages.length - 1 - (isSending ? index - 1 : index)];
      return DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message.isDeleted
                      ? context.l10n.globalChatDeletedMessage
                      : message.text,
                ),
              ),
              if (!message.isDeleted)
                IconButton(
                  tooltip: context.l10n.chatComposerReplyAction,
                  onPressed: () => onReply(message),
                  icon: const Icon(Symbols.reply_rounded, size: 18),
                ),
            ],
          ),
        ),
      );
    },
  );
}
