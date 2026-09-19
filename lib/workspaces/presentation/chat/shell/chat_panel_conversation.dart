import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_parts.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_realtime_status_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Treść jednej rozmowy wyświetlana wewnątrz globalnego panelu Chat.
///
/// Każde otwarcie tworzy mały `ChatConversationCubit` o lifecycle ograniczonym
/// do panelu. Wybór rozmowy nie dotyka routera; pełny widok jest jawną akcją.
final class ChatPanelConversation extends StatelessWidget {
  const ChatPanelConversation({
    required this.conversationRepository,
    required this.conversation,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
    this.onResourceAccessRevoked,
    this.createRealtime,
    super.key,
  });

  final ChatConversationRepository? conversationRepository;
  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
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
          BlocProvider(create: (context) => ChatRealtimeStatusCubit(realtime)),
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

/// Fallback hosta, który nie dostarczył kontraktu rozmów.
///
/// Nie udostępnia historii ani composera, więc nie wykonuje żądania z
/// niepełnym kontraktem.
final class _ChatPanelConversationUnavailable extends StatelessWidget {
  const _ChatPanelConversationUnavailable({
    required this.conversation,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
  });

  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ChatPanelConversationHeader(
        conversation: conversation,
        onBack: onBack,
        onOpenFullView: onOpenFullView,
        resourceContext: resourceContext,
      ),
      const Expanded(child: SizedBox.shrink()),
    ],
  );
}

/// Hostuje lokalny wybór odpowiedzi i przekazuje operacje do Cubita rozmowy.
final class _ChatPanelConversationContent extends StatefulWidget {
  const _ChatPanelConversationContent({
    required this.conversation,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
    this.onResourceAccessRevoked,
  });

  final ChatConversationResponse conversation;
  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceAccessRevoked;

  @override
  State<_ChatPanelConversationContent> createState() =>
      _ChatPanelConversationContentState();
}

final class _ChatPanelConversationContentState
    extends State<_ChatPanelConversationContent> {
  final ValueNotifier<ChatMessage?> _replyTarget = ValueNotifier(null);
  final ValueNotifier<bool> _accessRevocation = ValueNotifier(false);

  @override
  void dispose() {
    _replyTarget.dispose();
    _accessRevocation.dispose();
    super.dispose();
  }

  String? _send(ChatComposerDraft draft) {
    final clientMessageId = context.read<ChatConversationCubit>().sendDraft(
      draft,
    );
    _replyTarget.value = null;
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
        ChatPanelConversationHeader(
          conversation: widget.conversation,
          onBack: widget.onBack,
          onOpenFullView: widget.onOpenFullView,
          resourceContext: widget.resourceContext,
        ),
        const ChatPanelConnectionBanner(),
        Expanded(
          child: BlocBuilder<ChatConversationCubit, ChatConversationState>(
            builder: (context, state) => switch (state) {
              ChatConversationInitial() || ChatConversationLoading() =>
                const Center(child: CircularProgressIndicator()),
              ChatConversationFailure(:final message) ||
              ChatConversationDetached(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p16),
                  child: Text(message, textAlign: TextAlign.center),
                ),
              ),
              ChatConversationReady(:final messages, :final isSending) =>
                ChatPanelMessageList(
                  messages: messages,
                  isSending: isSending,
                  onReply: (message) => _replyTarget.value = message,
                ),
            },
          ),
        ),
        ValueListenableBuilder<ChatMessage?>(
          valueListenable: _replyTarget,
          builder: (context, replyTarget, _) => ChatMessageComposer(
            compact: true,
            onSubmit: _send,
            draftRepository: context.read<ChatDraftRepository>(),
            userId:
                context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
            conversationId: context
                .read<ChatConversationCubit>()
                .conversationId,
            conversationStates: context.read<ChatConversationCubit>().stream,
            deliveryConfirmations: context
                .read<ChatConversationCubit>()
                .deliveryConfirmations,
            attachmentUploadPort: context.read<ChatAttachmentUploadPort?>(),
            filePickerPort: context.read<FilePickerPort?>(),
            accessRevocation: _accessRevocation,
            replyTarget: replyTarget,
            onCancelReply: () => _replyTarget.value = null,
          ),
        ),
      ],
    ),
  );
}
