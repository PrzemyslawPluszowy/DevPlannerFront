import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_conversation_realtime_event.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/snippets/chat_snippet_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/discussion/chat_discussion_side_panel.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/chat_thread_side_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Otwiera wątek i dyskusję w bocznym arkuszu rootowego hosta modali.
///
/// Panele są montowane nad shellem, więc porty dostają jawnie przez
/// `RepositoryProvider` — dokładnie tak, jak wymaga tego reguła rootowych
/// modali w tym repo. Zamknięcie arkusza nie zmienia trasy ani stanu panelu.
abstract final class ChatThreadSheet {
  /// Otwiera wątek wskazanej wiadomości.
  static Future<void> showThread(
    BuildContext context, {
    required ChatThreadRepository? repository,
    required ChatConversationRepository? deliveryRepository,
    required ChatDraftRepository? draftRepository,
    required String conversationId,
    required ChatMessage rootMessage,
    Stream<ChatConversationRealtimeEvent>? conversationEvents,
    Stream<ChatConversationState>? parentConversationStates,
    ChatMessageActionsRepository? messageActionsRepository,
    List<ChatInboxItem> forwardTargets = const <ChatInboxItem>[],
    bool canModerate = false,
  }) async {
    if (repository == null ||
        deliveryRepository == null ||
        draftRepository == null) {
      AppToast.show(
        context,
        message: context.l10n.chatThreadUnavailableMessage,
        tone: AppToastTone.error,
      );
      return;
    }
    final authSession = context.read<AuthSessionPort?>();
    final parent = context.read<ChatConversationCubit?>();
    final initialParentState = parent?.state;
    final parentStates = parentConversationStates ?? parent?.stream;
    final uploads = context.read<ChatAttachmentUploadPort?>();
    final picker = context.read<FilePickerPort?>();
    final access = context.read<ChatAttachmentAccessPort?>();
    final storage = context.read<StorageRepository?>();
    final search = context.read<ChatSearchRepository?>();
    final linkPolicy = context.read<ChatLinkPolicyRepository?>();
    final snippets = context.read<ChatSnippetRepository?>();
    final emoji = context.read<ChatEmojiRecentCubit?>();
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) => MultiRepositoryProvider(
        providers: [
          if (authSession != null)
            ListenableProvider<AuthSessionPort>.value(value: authSession),
          RepositoryProvider<ChatThreadRepository>.value(value: repository),
          RepositoryProvider<ChatConversationRepository>.value(
            value: deliveryRepository,
          ),
          RepositoryProvider<ChatDraftRepository>.value(value: draftRepository),
          if (uploads != null)
            RepositoryProvider<ChatAttachmentUploadPort>.value(value: uploads),
          if (picker != null)
            RepositoryProvider<FilePickerPort>.value(value: picker),
          if (access != null)
            RepositoryProvider<ChatAttachmentAccessPort>.value(value: access),
          if (storage != null)
            RepositoryProvider<StorageRepository>.value(value: storage),
          if (search != null)
            RepositoryProvider<ChatSearchRepository>.value(value: search),
          if (linkPolicy != null)
            RepositoryProvider<ChatLinkPolicyRepository>.value(
              value: linkPolicy,
            ),
          if (snippets != null)
            RepositoryProvider<ChatSnippetRepository>.value(value: snippets),
          if (emoji != null)
            BlocProvider<ChatEmojiRecentCubit>.value(value: emoji),
        ],
        child: _ChatSheetFrame(
          child: ChatThreadSidePanel(
            conversationId: conversationId,
            rootMessage: rootMessage,
            parentConversationStates: parentStates,
            initialParentConversationState: initialParentState,
            conversationEvents: conversationEvents,
            messageActionsRepository: messageActionsRepository,
            forwardTargets: forwardTargets,
            canModerate: canModerate,
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      ),
    );
  }

  /// Otwiera nazwaną dyskusję przypiętą do wiadomości źródłowej.
  static Future<void> showDiscussion(
    BuildContext context, {
    required ChatDiscussionRepository? repository,
    required ChatConversation parentConversation,
    required ChatMessage rootMessage,
  }) async {
    if (repository == null) return;
    final parent = context.read<ChatConversationCubit?>();
    if (parent?.state is ChatConversationDetached) return;
    final auth = context.read<AuthSessionPort?>();
    final conversations = context.read<ChatConversationRepository?>();
    final drafts = context.read<ChatDraftRepository?>();
    final actions = context.read<ChatMessageActionsRepository?>();
    final thread = context.read<ChatThreadRepository?>();
    final uploads = context.read<ChatAttachmentUploadPort?>();
    final picker = context.read<FilePickerPort?>();
    final realtime = context.read<WorkspaceChatRealtimeFactory?>();
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ChatDiscussionRepository>.value(value: repository),
          if (auth != null)
            ListenableProvider<AuthSessionPort>.value(value: auth),
          if (conversations != null)
            RepositoryProvider<ChatConversationRepository>.value(
              value: conversations,
            ),
          if (drafts != null)
            RepositoryProvider<ChatDraftRepository>.value(value: drafts),
          if (actions != null)
            RepositoryProvider<ChatMessageActionsRepository>.value(
              value: actions,
            ),
          if (thread != null)
            RepositoryProvider<ChatThreadRepository>.value(value: thread),
          if (uploads != null)
            RepositoryProvider<ChatAttachmentUploadPort>.value(value: uploads),
          if (picker != null)
            RepositoryProvider<FilePickerPort>.value(value: picker),
          if (realtime != null)
            RepositoryProvider<WorkspaceChatRealtimeFactory>.value(
              value: realtime,
            ),
        ],
        child: _ChatSheetFrame(
          parent: parent,
          child: ChatDiscussionSidePanel(
            parentConversation: parentConversation,
            rootMessage: rootMessage,
            onClose: () => Navigator.of(sheetContext).pop(),
          ),
        ),
      ),
    );
  }
}

class _ChatSheetFrame extends StatelessWidget {
  const _ChatSheetFrame({required this.child, this.parent});
  final Widget child;
  final ChatConversationCubit? parent;

  @override
  Widget build(BuildContext context) {
    final frame = Material(
      child: SizedBox(
        width: 420,
        height: MediaQuery.sizeOf(context).height,
        child: child,
      ),
    );
    final owner = parent;
    if (owner == null) return frame;
    return BlocListener<ChatConversationCubit, ChatConversationState>(
      bloc: owner,
      listenWhen: (_, state) => state is ChatConversationDetached,
      listener: (context, _) => Navigator.of(context).pop(),
      child: frame,
    );
  }
}
