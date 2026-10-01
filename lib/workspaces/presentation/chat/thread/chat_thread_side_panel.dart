// Importy są ułożone warstwowo: widok zależy od composera i kontraktów Chat.
// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show SelectedContent;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_state.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_secondary_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/chat_thread_message_list.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_message_actions_cubit.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';

/// Prawy, lokalny subpanel odpowiedzi jednego wątku bez zmiany trasy.
class ChatThreadSidePanel extends StatefulWidget {
  const ChatThreadSidePanel({
    required this.conversationId,
    required this.rootMessage,
    required this.onClose,
    this.parentConversationStates,
    this.initialParentConversationState,
    this.conversationEvents,
    this.messageActionsRepository,
    this.forwardTargets = const <ChatInboxItem>[],
    this.canModerate = false,
    super.key,
  });
  final String conversationId;
  final ChatMessage rootMessage;
  final VoidCallback onClose;
  final Stream<ChatConversationState>? parentConversationStates;
  final ChatConversationState? initialParentConversationState;
  final Stream<ChatConversationRealtimeEvent>? conversationEvents;
  final ChatMessageActionsRepository? messageActionsRepository;
  final List<ChatInboxItem> forwardTargets;
  final bool canModerate;

  @override
  State<ChatThreadSidePanel> createState() => _ChatThreadSidePanelState();
}

class _ChatThreadSidePanelState extends State<ChatThreadSidePanel> {
  final ValueNotifier<bool> _accessRevocation = ValueNotifier(false);
  bool _hasTextSelection = false;
  ChatConversationState? _initialParentState;
  StreamSubscription<ChatConversationState>? _parentSubscription;

  @override
  void initState() {
    super.initState();
    _initialParentState =
        widget.initialParentConversationState ??
        context.read<ChatConversationCubit?>()?.state;
    _accessRevocation.value = _initialParentState is ChatConversationDetached;
    _parentSubscription = widget.parentConversationStates?.listen(
      _onParentState,
    );
  }

  void _onParentState(ChatConversationState state) {
    if (!mounted || state is! ChatConversationDetached) return;
    _accessRevocation.value = true;
    widget.onClose();
  }

  void _onSelectionChanged(SelectedContent? content) {
    final hasSelection = content?.plainText.isNotEmpty ?? false;
    if (hasSelection == _hasTextSelection || !mounted) return;
    setState(() => _hasTextSelection = hasSelection);
  }

  @override
  void dispose() {
    unawaited(_parentSubscription?.cancel());
    _accessRevocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = ChatThreadCubit(
        context.read<ChatThreadRepository>(),
        deliveryRepository: context.read<ChatConversationRepository>(),
        currentUserId:
            context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
        conversationId: widget.conversationId,
        threadRootMessageId: widget.rootMessage.id,
        conversationEvents: widget.conversationEvents,
        parentConversationStates: widget.parentConversationStates,
        initialParentConversationState: _initialParentState,
        rootMessage: widget.rootMessage,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: _ThreadActionProviders(
      repository: widget.messageActionsRepository,
      conversationId: widget.conversationId,
      events: widget.conversationEvents,
      child: Builder(
        builder: (context) {
          final chat = context.chatTheme;
          final currentUserId =
              context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '';
          return MultiBlocListener(
            listeners: [
              BlocListener<ChatThreadCubit, ChatThreadState>(
                listenWhen: (_, state) => state is ChatThreadDetached,
                listener: (_, _) => _accessRevocation.value = true,
              ),
              if (widget.messageActionsRepository != null)
                BlocListener<ChatMessageActionsCubit, ChatMessageActionsState>(
                  listener: (context, state) {
                    switch (state) {
                      case ChatMessageActionsUpdated(:final message):
                      case ChatMessageActionsDeleted(:final message):
                        context
                            .read<ChatThreadCubit>()
                            .applyMessageActionResult(message);
                      case ChatMessageActionsAccessRevoked():
                        context
                            .read<ChatThreadCubit>()
                            .detachForMessageAction();
                      case ChatMessageActionsConflict() ||
                          ChatMessageActionsFailure():
                        AppToast.show(
                          context,
                          message: context.l10n.chatActionFailureMessage,
                          tone: AppToastTone.error,
                        );
                      case ChatMessageActionsIdle() ||
                          ChatMessageActionsInProgress() ||
                          ChatMessageActionsRevisions():
                        break;
                    }
                  },
                ),
            ],
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: chat.separator),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.p12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.l10n.chatThreadTitle,
                            style: chat.contentStyle.copyWith(
                              color: chat.incomingText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: context.l10n.chatThreadClose,
                          onPressed: widget.onClose,
                          color: chat.metadataText,
                          icon: const Icon(Symbols.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BlocBuilder<ChatThreadCubit, ChatThreadState>(
                        builder: (context, _) {
                          final root =
                              context.read<ChatThreadCubit>().rootMessage ??
                              widget.rootMessage;
                          return Text(
                            root.isDeleted
                                ? context.l10n.globalChatDeletedMessage
                                : root.text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: chat.metadataStyle.copyWith(
                              color: chat.metadataText,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Gaps.h8,
                  Expanded(
                    child: BlocBuilder<ChatThreadCubit, ChatThreadState>(
                      builder: (context, state) => ChatThreadMessageList(
                        state: state,
                        rootMessage:
                            context.read<ChatThreadCubit>().rootMessage ??
                            widget.rootMessage,
                        currentUserId: currentUserId,
                        hasTextSelection: _hasTextSelection,
                        onSelectionChanged: _onSelectionChanged,
                        messageActionsRepository:
                            widget.messageActionsRepository,
                        forwardTargets: widget.forwardTargets,
                        canModerate: widget.canModerate,
                      ),
                    ),
                  ),
                  ChatMessageComposer(
                    compact: true,
                    onSubmit: (draft) =>
                        context.read<ChatThreadCubit>().sendDraft(draft),
                    draftRepository: context.read<ChatDraftRepository>(),
                    userId:
                        context
                            .read<AuthSessionPort?>()
                            ?.snapshot
                            .user
                            ?.userId ??
                        '',
                    conversationId: widget.conversationId,
                    draftConversationId: 'thread:${widget.rootMessage.id}',
                    attachmentUploadPort: context
                        .read<ChatAttachmentUploadPort?>(),
                    filePickerPort: context.read<FilePickerPort?>(),
                    deliveryConfirmations: context
                        .read<ChatThreadCubit>()
                        .deliveryConfirmations,
                    serverDraftEnabled: false,
                    accessRevocation: _accessRevocation,
                    conversationStates: widget.parentConversationStates,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _ThreadActionProviders extends StatelessWidget {
  const _ThreadActionProviders({
    required this.repository,
    required this.conversationId,
    required this.events,
    required this.child,
  });
  final ChatMessageActionsRepository? repository;
  final String conversationId;
  final Stream<ChatConversationRealtimeEvent>? events;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final actions = repository;
    if (actions == null) return child;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatMessageActionsCubit(repository: actions),
        ),
        BlocProvider(
          create: (_) {
            final cubit = ChatMessageSecondaryActionsCubit(repository: actions);
            unawaited(cubit.loadConversationPins(conversationId));
            final stream = events;
            if (stream != null) {
              cubit.watchConversationPins(
                conversationId: conversationId,
                events: stream,
              );
            }
            unawaited(cubit.loadBookmarks());
            return cubit;
          },
        ),
      ],
      child: child,
    );
  }
}
