// Importy rozmowy zachowują grupowanie zgodne z istniejącym subfeaturem.
// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:ready_next/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:ready_next/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:ready_next/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:ready_next/workspaces/presentation/chat/discussion/chat_discussion_side_panel.dart';
import 'package:ready_next/workspaces/presentation/chat/message_actions/message_actions_export.dart';
import 'package:ready_next/workspaces/presentation/chat/message_actions/message_actions_widgets.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:ready_next/workspaces/presentation/chat/thread/chat_thread_side_panel.dart';

/// Pełny ekran rozmowy używany przez deep link oraz wejście z drawera.
class ChatConversationPageView extends StatelessWidget {
  const ChatConversationPageView({
    required this.conversationId,
    this.targetMessageId,
    super.key,
  });

  final String conversationId;
  final String? targetMessageId;

  @override
  Widget build(BuildContext context) {
    final realtime = context.read<WorkspaceChatRealtimeFactory>().create();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = ChatConversationCubit(
              repository: context.read<ChatConversationRepository>(),
              conversationId: conversationId,
              realtime: realtime,
              disposeRealtime: realtime.dispose,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => ChatMessageActionsCubit(
            repository: context.read<ChatMessageActionsRepository>(),
          ),
        ),
      ],
      child: _ChatConversationView(targetMessageId: targetMessageId),
    );
  }
}

class _ChatConversationView extends StatefulWidget {
  const _ChatConversationView({this.targetMessageId});

  final String? targetMessageId;

  @override
  State<_ChatConversationView> createState() => _ChatConversationViewState();
}

class _ChatConversationViewState extends State<_ChatConversationView> {
  ChatMessage? _replyTarget;
  ChatMessage? _threadRoot;
  ChatMessage? _discussionRoot;

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
  ) => MultiBlocListener(
    listeners: [
      BlocListener<ChatConversationCubit, ChatConversationState>(
        listenWhen: (_, state) =>
            state is! ChatConversationReady &&
            (_discussionRoot != null || _threadRoot != null),
        listener: (_, _) => setState(() {
          _discussionRoot = null;
          _threadRoot = null;
        }),
      ),
      BlocListener<ChatMessageActionsCubit, ChatMessageActionsState>(
        listener: (context, state) => switch (state) {
          ChatMessageActionsUpdated(:final message) ||
          ChatMessageActionsDeleted(
            :final message,
          ) => context.read<ChatConversationCubit>().applyMessageActionResult(
            message,
          ),
          ChatMessageActionsAccessRevoked(:final message) =>
            context.read<ChatConversationCubit>().detachForMessageAction(
              message,
            ),
          _ => null,
        },
      ),
    ],
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(WorkspaceIcons.chat, size: 22),
              Gaps.w8,
              Expanded(child: Text('Czat', style: context.text.headlineSmall)),
              IconButton(
                tooltip: context.l10n.chatConversationNotificationSettingsOpen,
                onPressed: () => ChatConversationNotificationSettingsModal.show(
                  context,
                  conversationId: context
                      .read<ChatConversationCubit>()
                      .conversationId,
                ),
                icon: const Icon(Symbols.notifications_rounded),
              ),
            ],
          ),
          Gaps.h16,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Row(
                children: [
                  Expanded(
                    child: switch ((_threadRoot, _discussionRoot)) {
                      (_, final root?) => _DiscussionPanelOrConversation(
                        rootMessage: root,
                        onClose: () => setState(() => _discussionRoot = null),
                        conversationBody: _conversationBody,
                      ),
                      (final root?, _) when constraints.maxWidth < 900 =>
                        ChatThreadSidePanel(
                          conversationId: context
                              .read<ChatConversationCubit>()
                              .conversationId,
                          rootMessage: root,
                          parentConversationStates: context
                              .read<ChatConversationCubit>()
                              .stream,
                          onClose: () => setState(() => _threadRoot = null),
                        ),
                      _ => _conversationBody(context),
                    },
                  ),
                  if (_threadRoot case final root?
                      when constraints.maxWidth >= 900)
                    SizedBox(
                      width: 340,
                      child: ChatThreadSidePanel(
                        conversationId: context
                            .read<ChatConversationCubit>()
                            .conversationId,
                        rootMessage: root,
                        parentConversationStates: context
                            .read<ChatConversationCubit>()
                            .stream,
                        onClose: () => setState(() => _threadRoot = null),
                      ),
                    ),
                  if (_discussionRoot case final root?
                      when constraints.maxWidth >= 900)
                    SizedBox(
                      width: 340,
                      child: _DiscussionPanelOrConversation(
                        rootMessage: root,
                        onClose: () => setState(() => _discussionRoot = null),
                        conversationBody: _conversationBody,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Gaps.h12,
          ChatMessageComposer(
            onSubmit: _send,
            draftRepository: context.read<ChatDraftRepository>(),
            userId:
                context.read<AuthRepository>().currentUser?.coreUserId ??
                context.read<AuthRepository>().currentUser?.userId.toString() ??
                '',
            conversationId: context
                .read<ChatConversationCubit>()
                .conversationId,
            conversationStates: context.read<ChatConversationCubit>().stream,
            deliveryConfirmations: context
                .read<ChatConversationCubit>()
                .deliveryConfirmations,
            attachmentUploadPort: context.read<ChatAttachmentUploadPort>(),
            filePickerPort: context.read<FilePickerPort>(),
            replyTarget: _replyTarget,
            onCancelReply: () => setState(() => _replyTarget = null),
          ),
        ],
      ),
    ),
  );

  Widget _conversationBody(BuildContext context) =>
      BlocBuilder<ChatConversationCubit, ChatConversationState>(
        builder: (context, state) => switch (state) {
          ChatConversationInitial() || ChatConversationLoading() =>
            const Center(child: CircularProgressIndicator()),
          ChatConversationFailure(:final message) ||
          ChatConversationDetached(:final message) => _ChatFailure(message),
          ChatConversationReady(
            :final messages,
            :final isSending,
            :final realtimeError,
          ) =>
            _MessageList(
              messages: messages,
              isSending: isSending,
              realtimeError: realtimeError,
              targetMessageId: widget.targetMessageId,
              onReply: (message) => setState(() => _replyTarget = message),
              onThread: (message) => setState(() => _threadRoot = message),
              onDiscussion: (message) =>
                  setState(() => _discussionRoot = message),
            ),
        },
      );
}

/// Chroni panel dyskusji przed użyciem rozmowy nadrzędnej po jej odłączeniu.
class _DiscussionPanelOrConversation extends StatelessWidget {
  const _DiscussionPanelOrConversation({
    required this.rootMessage,
    required this.onClose,
    required this.conversationBody,
  });

  final ChatMessage rootMessage;
  final VoidCallback onClose;
  final Widget Function(BuildContext context) conversationBody;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatConversationCubit, ChatConversationState>(
        builder: (context, state) => switch (state) {
          ChatConversationReady(:final conversation) => ChatDiscussionSidePanel(
            parentConversation: conversation,
            rootMessage: rootMessage,
            onClose: onClose,
          ),
          _ => conversationBody(context),
        },
      );
}

class _MessageList extends StatefulWidget {
  const _MessageList({
    required this.messages,
    required this.isSending,
    this.realtimeError,
    this.targetMessageId,
    required this.onReply,
    required this.onThread,
    required this.onDiscussion,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final String? realtimeError;
  final String? targetMessageId;
  final ValueChanged<ChatMessage> onReply;
  final ValueChanged<ChatMessage> onThread;
  final ValueChanged<ChatMessage> onDiscussion;

  @override
  State<_MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<_MessageList> {
  final GlobalKey _targetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollToTarget();
  }

  @override
  void didUpdateWidget(covariant _MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetMessageId != oldWidget.targetMessageId ||
        widget.messages != oldWidget.messages) {
      _scrollToTarget();
    }
  }

  void _scrollToTarget() {
    if (widget.targetMessageId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = _targetKey.currentContext;
      if (targetContext != null && mounted) {
        Scrollable.ensureVisible(
          targetContext,
          alignment: .45,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (widget.realtimeError case final error?)
        MaterialBanner(
          content: Text('Realtime Chat: $error'),
          actions: const <Widget>[SizedBox.shrink()],
        ),
      Expanded(
        child: ListView.separated(
          reverse: true,
          itemCount: widget.messages.length + (widget.isSending ? 1 : 0),
          separatorBuilder: (context, index) =>
              const SizedBox(height: Sizes.p8),
          itemBuilder: (context, index) {
            if (widget.isSending && index == 0) {
              return const Align(
                alignment: Alignment.centerLeft,
                child: SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            }
            final message =
                widget.messages[widget.messages.length -
                    1 -
                    (widget.isSending ? index - 1 : index)];
            final isTarget = message.id == widget.targetMessageId;
            return Align(
              key: isTarget ? _targetKey : null,
              alignment: Alignment.centerLeft,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isTarget
                      ? context.colors.primaryContainer
                      : context.colors.surfaceContainerHighest,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: isTarget
                      ? Border.all(color: context.colors.primary, width: 1.2)
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p12),
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
                          onPressed: () => widget.onReply(message),
                          icon: const Icon(Symbols.reply_rounded, size: 18),
                        ),
                      if (!message.isDeleted)
                        IconButton(
                          tooltip: context.l10n.chatThreadOpen,
                          onPressed: () => widget.onThread(message),
                          icon: const Icon(Symbols.forum_rounded, size: 18),
                        ),
                      if (!message.isDeleted)
                        IconButton(
                          tooltip: context.l10n.chatDiscussionOpen,
                          onPressed: () => widget.onDiscussion(message),
                          icon: const Icon(Symbols.topic_rounded, size: 18),
                        ),
                      if (!message.isDeleted)
                        ChatMessageActionMenu(message: message),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

class _ChatFailure extends StatelessWidget {
  const _ChatFailure(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}
