import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_unread_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_peer_status_line.dart';
import 'package:devplanner/workspaces/presentation/chat/presence/widgets/chat_typing_indicator.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_connection_banner.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_header.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation_presentation.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_read_aware_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Hostuje lokalny wybór odpowiedzi i przekazuje operacje do Cubita rozmowy.
final class ChatPanelConversationContent extends StatefulWidget {
  const ChatPanelConversationContent({
    required this.conversation,
    required this.conversationRepository,
    this.onOpenThread,
    this.targetMessageId,
    this.messageActions,
    this.canModerateMessages = false,
    required this.onBack,
    this.onOpenFullView,
    this.resourceContext,
    this.onResourceAccessRevoked,
    super.key,
  });

  final ChatConversation conversation;
  final ChatConversationRepository conversationRepository;

  /// Otwiera wątek wskazanej wiadomości; brak oznacza panel bez wątków.
  final ValueChanged<ChatMessage>? onOpenThread;

  /// Wiadomość, do której widok ma przewinąć po otwarciu z wyszukiwania.
  final String? targetMessageId;

  /// Port akcji wiadomości używany przez nagłówek do list przypiętych i zakładek.
  final ChatMessageActionsRepository? messageActions;

  /// Czy rola pozwala moderować cudzą treść.
  final bool canModerateMessages;

  final VoidCallback onBack;
  final VoidCallback? onOpenFullView;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceAccessRevoked;

  @override
  State<ChatPanelConversationContent> createState() =>
      _ChatPanelConversationContentState();
}

final class _ChatPanelConversationContentState
    extends State<ChatPanelConversationContent> {
  final ValueNotifier<ChatMessage?> _replyTarget = ValueNotifier(null);
  final ValueNotifier<bool> _accessRevocation = ValueNotifier(false);

  @override
  void dispose() {
    _replyTarget.dispose();
    _accessRevocation.dispose();
    super.dispose();
  }

  /// Wpis rozmowy w katalogu skrzynki; brak oznacza brak potwierdzonych danych.
  ChatInboxItem? _inboxItem(BuildContext context) {
    final state = context.watch<ChatInboxCubit?>()?.state;
    if (state is! ChatInboxReady) return null;
    for (final item in state.items) {
      if (item.conversation.id == widget.conversation.id) return item;
    }
    return null;
  }

  ChatPanelConversationPresentation _presentation(BuildContext context) =>
      ChatPanelConversationPresentation(
        conversation: widget.conversation,
        inboxItem: _inboxItem(context),
      );

  /// Otwiera listę grupy i dodawanie osób bez szukania akcji w menu `…`.
  void _openMembers() {
    final members = context.read<ChatMembersRepository?>();
    if (members == null) return;
    unawaited(_showMembersAndHandleLeave(members));
  }

  Future<void> _showMembersAndHandleLeave(
    ChatMembersRepository members,
  ) async {
    final inbox = context.read<ChatInboxCubit?>();
    final unread = context.read<ChatUnreadCubit?>();
    final didLeave = await ChatMembersSheet.show(
      context,
      membersRepository: members,
      conversation: widget.conversation,
      currentUserId:
          context.read<AuthSessionPort?>()?.snapshot.user?.userId ?? '',
      conversationManagement: context
          .read<ChatConversationManagementRepository?>(),
      presenceRepository: context.read<ChatPresenceRepository?>(),
      directoryRepository: context.read<ChatDirectoryRepository?>(),
    );
    if (!mounted || didLeave != true) return;
    unawaited(inbox?.refresh());
    unawaited(unread?.refresh());
    // Returning to the inbox disposes this conversation's realtime lease and
    // clears its selection after the server has confirmed the leave.
    widget.onBack();
  }

  String? _send(ChatComposerDraft draft) {
    final clientMessageId = context.read<ChatConversationCubit>().sendDraft(
      draft,
    );
    if (clientMessageId != null) _replyTarget.value = null;
    return clientMessageId;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final presentation = _presentation(context);
    return BlocListener<ChatConversationCubit, ChatConversationState>(
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
            conversationRepository: widget.conversationRepository,
            messageActions: widget.messageActions,
            title: presentation.title,
            avatarUserId: presentation.headerAvatarUserId,
            avatarUrl: presentation.headerAvatarUrl,
            avatarLabel: presentation.title ?? widget.conversation.name,
            subtitle: presentation.participantCount > 0
                ? context.l10n.chatHeaderParticipantCount(
                    presentation.participantCount,
                  )
                : null,
            subtitleWidget: switch (presentation.headerAvatarUserId) {
              final userId? when userId.isNotEmpty => ChatPeerStatusLine(
                userId: userId,
              ),
              _ => null,
            },
            onOpenMembers:
                widget.conversation.type != 'direct' &&
                    context.read<ChatMembersRepository?>() != null
                ? _openMembers
                : null,
            onBack: widget.onBack,
            onOpenFullView: widget.onOpenFullView,
            resourceContext: widget.resourceContext,
            canManageConversation: widget.canModerateMessages,
          ),
          const ChatPanelConnectionBanner(),
          // Skok do starej wiadomości ma jawny stan: ładowanie albo komunikat
          // odmowy/braku z ponowieniem, nigdy cichej pustej historii.
          BlocBuilder<ChatConversationCubit, ChatConversationState>(
            buildWhen: (previous, current) =>
                current is ChatConversationReady &&
                (previous is! ChatConversationReady ||
                    previous.isJumpingToMessage != current.isJumpingToMessage ||
                    previous.jumpFailureCode != current.jumpFailureCode ||
                    previous.isWindowedHistory != current.isWindowedHistory),
            builder: (context, state) {
              if (state is! ChatConversationReady) {
                return const SizedBox.shrink();
              }
              if (state.isJumpingToMessage) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.p12),
                  child: LinearProgressIndicator(minHeight: 2),
                );
              }
              // Tryb okna jest jawny: użytkownik wie, że patrzy na fragment
              // historii, i ma jedną akcję powrotu do najnowszych wiadomości.
              if (state.isWindowedHistory) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                  child: Row(
                    children: [
                      const Icon(Symbols.history, size: 16),
                      const SizedBox(width: Sizes.p8),
                      Expanded(
                        child: Text(
                          context.l10n.chatWindowHistoryBanner,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton(
                        onPressed: () => unawaited(
                          context
                              .read<ChatConversationCubit>()
                              .exitWindowHistory(),
                        ),
                        child: Text(context.l10n.chatWindowHistoryLatest),
                      ),
                    ],
                  ),
                );
              }
              final failure = state.jumpFailureCode;
              if (failure == null) return const SizedBox.shrink();
              final target = widget.targetMessageId ?? '';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        failure,
                        style: context.chatTheme.metadataStyle.copyWith(
                          color: context.chatTheme.error,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: target.isEmpty
                          ? null
                          : () => unawaited(
                              context
                                  .read<ChatConversationCubit>()
                                  .ensureTargetLoaded(target),
                            ),
                      child: Text(context.l10n.chatInboxRetry),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ChatConversationCubit, ChatConversationState>(
              builder: (context, state) => switch (state) {
                ChatConversationInitial() || ChatConversationLoading() =>
                  const Center(child: CircularProgressIndicator()),
                ChatConversationFailure() ||
                ChatConversationDetached() => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p16),
                    child: Text(
                      state is ChatConversationDetached
                          ? context.l10n.chatConversationAccessRevokedMessage
                          : context.l10n.chatConversationLoadFailureMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ChatConversationReady(
                  :final messages,
                  :final isSending,
                  :final nextCursor,
                  :final isLoadingMore,
                  :final loadError,
                ) =>
                  ChatPanelReadAwareMessages(
                    messages: messages,
                    isSending: isSending,
                    nextCursor: nextCursor,
                    isLoadingMore: isLoadingMore,
                    loadMoreFailed: loadError != null,
                    onLoadMore: () =>
                        context.read<ChatConversationCubit>().loadMore(),
                    onReply: (message) => _replyTarget.value = message,
                    onThread: widget.onOpenThread,
                    targetMessageId: widget.targetMessageId,
                    canModerate: widget.canModerateMessages,
                    participantLabels: presentation.participantLabels,
                    participantAvatarUrls: presentation.participantAvatarUrls,
                  ),
              },
            ),
          ),
          ChatTypingIndicator(labels: presentation.typingParticipantLabels),
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
              mentionAllEnabled: presentation.mentionAllEnabled,
              accessRevocation: _accessRevocation,
              replyTarget: replyTarget,
              onCancelReply: () => _replyTarget.value = null,
            ),
          ),
        ],
      ),
    );
  }
}
