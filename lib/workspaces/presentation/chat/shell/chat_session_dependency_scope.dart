import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_server_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/delivery/chat_pending_send_store.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_link_preview_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/snippets/chat_snippet_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_share_recipient_directory_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/links/chat_external_link_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Rebinds session-scoped Chat ports below a root modal navigator.
final class ChatSessionDependencyScope extends StatelessWidget {
  const ChatSessionDependencyScope({
    required this.composition,
    required this.authSession,
    required this.storageRepository,
    required this.emojiRecentCubit,
    required this.child,
    super.key,
  });

  final DevPlannerGlobalChatComposition? composition;
  final AuthSessionPort? authSession;
  final StorageRepository? storageRepository;
  final ChatEmojiRecentCubit? emojiRecentCubit;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final chat = composition;
    final providers = <RepositoryProvider<dynamic>>[
      RepositoryProvider<StorageShareRecipientDirectoryPort?>.value(
        value: chat?.storageShareRecipientDirectory,
      ),
      if (chat != null)
        RepositoryProvider<DevPlannerGlobalChatComposition>.value(value: chat),
      if (chat != null)
        RepositoryProvider<ChatDraftRepository>.value(
          value: chat.draftRepository,
        ),
      if (chat?.inboxRepository case final repository?)
        RepositoryProvider<ChatInboxRepository>.value(value: repository),
      if (chat?.conversationManagementRepository case final repository?)
        RepositoryProvider<ChatConversationManagementRepository>.value(
          value: repository,
        ),
      if (chat?.directoryRepository case final repository?)
        RepositoryProvider<ChatDirectoryRepository>.value(value: repository),
      if (chat?.pendingSendStore case final repository?)
        RepositoryProvider<ChatPendingSendStore>.value(value: repository),
      if (chat?.serverDraftRepository case final repository?)
        RepositoryProvider<ChatServerDraftRepository>.value(value: repository),
      if (chat?.threadRepository case final repository?)
        RepositoryProvider<ChatThreadRepository>.value(value: repository),
      if (chat?.discussionRepository case final repository?)
        RepositoryProvider<ChatDiscussionRepository>.value(value: repository),
      if (chat?.membersRepository case final repository?)
        RepositoryProvider<ChatMembersRepository>.value(value: repository),
      if (chat?.searchRepository case final repository?)
        RepositoryProvider<ChatSearchRepository>.value(value: repository),
      if (chat?.presenceRepository case final repository?)
        RepositoryProvider<ChatPresenceRepository>.value(value: repository),
      if (chat?.messageActionsRepository case final repository?)
        RepositoryProvider<ChatMessageActionsRepository>.value(
          value: repository,
        ),
      if (chat?.notificationSettingsRepository case final repository?)
        RepositoryProvider<ChatNotificationSettingsRepository>.value(
          value: repository,
        ),
      if (chat?.attachmentUploadPort case final repository?)
        RepositoryProvider<ChatAttachmentUploadPort>.value(
          value: repository,
        ),
      if (chat?.attachmentAccessPort case final repository?)
        RepositoryProvider<ChatAttachmentAccessPort>.value(
          value: repository,
        ),
      if (chat?.linkPort case final repository?)
        RepositoryProvider<ChatExternalLinkPort>.value(value: repository),
      if (chat?.filePickerPort case final repository?)
        RepositoryProvider<FilePickerPort>.value(value: repository),
      if (chat?.linkPolicyRepository case final repository?)
        RepositoryProvider<ChatLinkPolicyRepository>.value(value: repository),
      if (chat?.linkPreviewRepository case final repository?)
        RepositoryProvider<ChatLinkPreviewRepository>.value(value: repository),
      if (chat?.snippetRepository case final repository?)
        RepositoryProvider<ChatSnippetRepository>.value(value: repository),
      if (chat?.realtimeFactory case final repository?)
        RepositoryProvider<WorkspaceChatRealtimeFactory>.value(
          value: repository,
        ),
      if (chat?.repository case final ResourceChatRepository repository)
        RepositoryProvider<ResourceChatRepository>.value(value: repository),
      if (chat?.conversationRepository case final repository?)
        RepositoryProvider<ChatConversationRepository>.value(
          value: repository,
        ),
      if (storageRepository case final repository?)
        RepositoryProvider<StorageRepository>.value(value: repository),
    ];

    var result = providers.isEmpty
        ? child
        : MultiRepositoryProvider(providers: providers, child: child);
    final presenceRepository = chat?.inboxPresenceRepository;
    if (presenceRepository != null && chat?.inboxRepository != null) {
      final chatComposition = chat!;
      result = BlocProvider<ChatInboxPresenceCubit>(
        key: ValueKey<String>(
          'chat-inbox-presence-${chatComposition.userId}-${identityHashCode(chatComposition.inboxRepository)}-${identityHashCode(presenceRepository)}-${identityHashCode(authSession)}',
        ),
        create: (context) => ChatInboxPresenceCubit(
          inbox: context.read<ChatInboxCubit>(),
          repository: presenceRepository,
          currentUserId: chatComposition.userId,
          authSession: authSession,
          presenceAvailability: DevPlannerPanelsScope.maybeOf(
            context,
          )?.presenceAvailability,
        ),
        child: result,
      );
    }
    if (chat?.inboxRepository case final repository?) {
      result = BlocProvider(
        key: ValueKey<String>('chat-inbox-${identityHashCode(repository)}'),
        create: (_) {
          final cubit = ChatInboxCubit(repository: repository);
          unawaited(cubit.load());
          return cubit;
        },
        child: result,
      );
    }
    if (authSession case final session?) {
      result = ListenableProvider<AuthSessionPort>.value(
        value: session,
        child: result,
      );
    }
    if (emojiRecentCubit case final cubit?) {
      result = BlocProvider<ChatEmojiRecentCubit>.value(
        value: cubit,
        child: result,
      );
    }
    return result;
  }
}
