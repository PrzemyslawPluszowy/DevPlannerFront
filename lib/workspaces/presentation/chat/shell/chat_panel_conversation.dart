// Importy panelu zachowują grupowanie zależności istniejącego shellu.
// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:ready_next/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:ready_next/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:ready_next/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';

/// Treść jednej rozmowy wyświetlana wewnątrz globalnego panelu Chat.
///
/// Każde otwarcie tworzy mały `ChatConversationCubit` o lifecycle ograniczonym
/// do panelu. Wybór rozmowy nie dotyka routera; pełny widok jest jawną akcją.
class ChatPanelConversation extends StatelessWidget {
  const ChatPanelConversation({
    required this.conversationRepository,
    required this.conversation,
    required this.onBack,
    required this.onOpenFullView,
    this.resourceContext,
    this.onResourceAccessRevoked,
    this.createRealtime,
    super.key,
  });

  final ChatConversationRepository? conversationRepository;
  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback onOpenFullView;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceAccessRevoked;
  final WorkspaceChatRealtimeService Function()? createRealtime;

  @override
  Widget build(BuildContext context) {
    final repository = conversationRepository;
    if (repository == null) {
      return _ChatPanelConversationUnavailable(
        conversation: conversation,
        onBack: onBack,
        onOpenFullView: onOpenFullView,
        resourceContext: resourceContext,
      );
    }
    final realtime = createRealtime?.call();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = ChatConversationCubit(
              repository: repository,
              conversationId: conversation.id,
              realtime: realtime,
              disposeRealtime: realtime?.dispose,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
        if (realtime != null)
          BlocProvider(
            create: (context) => ChatRealtimeStatusCubit(realtime),
          ),
      ],
      child: _ChatPanelConversationContent(
        conversation: conversation,
        onBack: onBack,
        onOpenFullView: onOpenFullView,
        resourceContext: resourceContext,
        onResourceAccessRevoked: onResourceAccessRevoked,
      ),
    );
  }
}

/// Minimalny fallback dla hostów listy, które nie dostarczyły jeszcze 5A.
///
/// Nie udostępnia danych historii ani composera: dzięki temu testowy albo
/// starszy host nie wykonuje przypadkowego żądania z niepełnym kontraktem.
class _ChatPanelConversationUnavailable extends StatelessWidget {
  const _ChatPanelConversationUnavailable({
    required this.conversation,
    required this.onBack,
    required this.onOpenFullView,
    this.resourceContext,
  });

  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _ConversationHeader(
        conversation: conversation,
        onBack: onBack,
        onOpenFullView: onOpenFullView,
        resourceContext: resourceContext,
      ),
      const Expanded(child: SizedBox.shrink()),
    ],
  );
}

class _ChatPanelConversationContent extends StatefulWidget {
  const _ChatPanelConversationContent({
    required this.conversation,
    required this.onBack,
    required this.onOpenFullView,
    this.resourceContext,
    this.onResourceAccessRevoked,
  });

  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback onOpenFullView;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceAccessRevoked;

  @override
  State<_ChatPanelConversationContent> createState() =>
      _ChatPanelConversationContentState();
}

class _ChatPanelConversationContentState
    extends State<_ChatPanelConversationContent> {
  ChatMessage? _replyTarget;
  final ValueNotifier<bool> _accessRevocation = ValueNotifier(false);

  @override
  void dispose() {
    _accessRevocation.dispose();
    super.dispose();
  }

  String? _send(ChatComposerDraft draft) {
    final clientMessageId = context.read<ChatConversationCubit>().sendDraft(
      draft,
    );
    setState(() => _replyTarget = null);
    return clientMessageId;
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<ChatConversationCubit, ChatConversationState>(
    listenWhen: (_, state) => state is ChatConversationDetached,
    listener: (context, state) {
      _accessRevocation.value = true;
      if (widget.resourceContext != null) {
        widget.onResourceAccessRevoked?.call();
      }
      widget.onBack();
    },
    child: Column(
      children: [
        _ConversationHeader(
          conversation: widget.conversation,
          onBack: widget.onBack,
          onOpenFullView: widget.onOpenFullView,
          resourceContext: widget.resourceContext,
        ),
        const _ChatConnectionBanner(),
        Expanded(
          child: BlocBuilder<ChatConversationCubit, ChatConversationState>(
            builder: (context, state) => switch (state) {
              ChatConversationInitial() || ChatConversationLoading() =>
                const Center(child: CircularProgressIndicator()),
              ChatConversationFailure(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Text(message, textAlign: TextAlign.center),
                ),
              ),
              ChatConversationDetached(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Text(message, textAlign: TextAlign.center),
                ),
              ),
              ChatConversationReady(:final messages, :final isSending) =>
                _PanelMessageList(
                  messages: messages,
                  isSending: isSending,
                  onReply: (message) => setState(() => _replyTarget = message),
                ),
            },
          ),
        ),
        ChatMessageComposer(
          compact: true,
          onSubmit: _send,
          draftRepository: context.read<ChatDraftRepository>(),
          userId:
              context.read<AuthRepository>().currentUser?.coreUserId ??
              context.read<AuthRepository>().currentUser?.userId.toString() ??
              '',
          conversationId: context.read<ChatConversationCubit>().conversationId,
          conversationStates: context.read<ChatConversationCubit>().stream,
          deliveryConfirmations: context
              .read<ChatConversationCubit>()
              .deliveryConfirmations,
          attachmentUploadPort: context.read<ChatAttachmentUploadPort>(),
          filePickerPort: context.read<FilePickerPort>(),
          accessRevocation: _accessRevocation,
          replyTarget: _replyTarget,
          onCancelReply: () => setState(() => _replyTarget = null),
        ),
      ],
    ),
  );
}

/// Niewielki, nieblokujący komunikat o stanie istniejącego połączenia Chat.
class _ChatConnectionBanner extends StatelessWidget {
  const _ChatConnectionBanner();

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

class _ConversationHeader extends StatelessWidget {
  const _ConversationHeader({
    required this.conversation,
    required this.onBack,
    required this.onOpenFullView,
    this.resourceContext,
  });

  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Sizes.p8, Sizes.p8, Sizes.p8, Sizes.p4),
    child: Column(
      children: [
        if (resourceContext case final context?)
          _ResourceChatHeader(context: context),
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
class _ResourceChatHeader extends StatelessWidget {
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

class _PanelMessageList extends StatelessWidget {
  const _PanelMessageList({
    required this.messages,
    required this.isSending,
    required this.onReply,
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
