// Importy rozmowy zachowują grupowanie zgodne z istniejącym subfeaturem.
// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_conversation_message_list.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/discussion/chat_discussion_side_panel.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/chat_thread_side_panel.dart';

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
    final realtime = context.read<WorkspaceChatRealtimeFactory>().open(
      conversationId,
    );
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
  final ValueNotifier<_ChatConversationPanels> _panels = ValueNotifier(
    const _ChatConversationPanels(),
  );

  @override
  void dispose() {
    _panels.dispose();
    super.dispose();
  }

  String? _send(ChatComposerDraft draft) {
    final clientMessageId = context.read<ChatConversationCubit>().sendDraft(
      draft,
    );
    _updatePanels(_panels.value.clearReply());
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
            (_panels.value.discussionRoot != null ||
                _panels.value.threadRoot != null),
        listener: (_, _) => _updatePanels(_panels.value.clearPanels()),
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
    child: ValueListenableBuilder<_ChatConversationPanels>(
      valueListenable: _panels,
      builder: (context, panels, _) => Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(WorkspaceIcons.chat, size: 22),
                Gaps.w8,
                Expanded(
                  child: Text('Czat', style: context.text.headlineSmall),
                ),
                IconButton(
                  tooltip:
                      context.l10n.chatConversationNotificationSettingsOpen,
                  onPressed: () =>
                      ChatConversationNotificationSettingsModal.show(
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
                      child: switch ((
                        panels.threadRoot,
                        panels.discussionRoot,
                      )) {
                        (_, final root?) => _DiscussionPanelOrConversation(
                          rootMessage: root,
                          onClose: () => _updatePanels(
                            panels.copyWith(clearDiscussionRoot: true),
                          ),
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
                            onClose: () => _updatePanels(
                              panels.copyWith(clearThreadRoot: true),
                            ),
                          ),
                        _ => _conversationBody(context),
                      },
                    ),
                    if (panels.threadRoot case final root?
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
                          onClose: () => _updatePanels(
                            panels.copyWith(clearThreadRoot: true),
                          ),
                        ),
                      ),
                    if (panels.discussionRoot case final root?
                        when constraints.maxWidth >= 900)
                      SizedBox(
                        width: 340,
                        child: _DiscussionPanelOrConversation(
                          rootMessage: root,
                          onClose: () => _updatePanels(
                            panels.copyWith(clearDiscussionRoot: true),
                          ),
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
                  context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
              conversationId: context
                  .read<ChatConversationCubit>()
                  .conversationId,
              conversationStates: context.read<ChatConversationCubit>().stream,
              deliveryConfirmations: context
                  .read<ChatConversationCubit>()
                  .deliveryConfirmations,
              attachmentUploadPort: context.read<ChatAttachmentUploadPort>(),
              filePickerPort: context.read<FilePickerPort>(),
              replyTarget: panels.replyTarget,
              onCancelReply: () => _updatePanels(
                panels.copyWith(clearReplyTarget: true),
              ),
            ),
          ],
        ),
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
            ChatConversationMessageList(
              messages: messages,
              isSending: isSending,
              realtimeError: realtimeError,
              targetMessageId: widget.targetMessageId,
              onReply: (message) => _updatePanels(
                _panels.value.copyWith(replyTarget: message),
              ),
              onThread: (message) => _updatePanels(
                _panels.value.copyWith(threadRoot: message),
              ),
              onDiscussion: (message) => _updatePanels(
                _panels.value.copyWith(discussionRoot: message),
              ),
            ),
        },
      );

  void _updatePanels(_ChatConversationPanels next) {
    if (_panels.value == next) return;
    _panels.value = next;
  }
}

/// Lokalny, niemutowalny wybór paneli rozmowy; nie należy do logiki Cubita.
@immutable
final class _ChatConversationPanels {
  const _ChatConversationPanels({
    this.replyTarget,
    this.threadRoot,
    this.discussionRoot,
  });

  final ChatMessage? replyTarget;
  final ChatMessage? threadRoot;
  final ChatMessage? discussionRoot;

  _ChatConversationPanels clearReply() => copyWith(clearReplyTarget: true);

  _ChatConversationPanels clearPanels() =>
      copyWith(clearThreadRoot: true, clearDiscussionRoot: true);

  _ChatConversationPanels copyWith({
    ChatMessage? replyTarget,
    ChatMessage? threadRoot,
    ChatMessage? discussionRoot,
    bool clearReplyTarget = false,
    bool clearThreadRoot = false,
    bool clearDiscussionRoot = false,
  }) => _ChatConversationPanels(
    replyTarget: clearReplyTarget ? null : replyTarget ?? this.replyTarget,
    threadRoot: clearThreadRoot ? null : threadRoot ?? this.threadRoot,
    discussionRoot: clearDiscussionRoot
        ? null
        : discussionRoot ?? this.discussionRoot,
  );

  @override
  bool operator ==(Object other) =>
      other is _ChatConversationPanels &&
      other.replyTarget == replyTarget &&
      other.threadRoot == threadRoot &&
      other.discussionRoot == discussionRoot;

  @override
  int get hashCode => Object.hash(replyTarget, threadRoot, discussionRoot);
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
