import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_repository.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/discussion/chat_discussion_side_panel.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/chat_thread_side_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    Stream<ChatConversationState>? parentConversationStates,
    ChatMessageActionsRepository? messageActionsRepository,
    List<ChatInboxItem> forwardTargets = const <ChatInboxItem>[],
    bool canModerate = false,
  }) async {
    if (repository == null ||
        deliveryRepository == null ||
        draftRepository == null) {
      return;
    }
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ChatThreadRepository>.value(value: repository),
          RepositoryProvider<ChatConversationRepository>.value(
            value: deliveryRepository,
          ),
          RepositoryProvider<ChatDraftRepository>.value(value: draftRepository),
        ],
        child: ChatThreadSidePanel(
          conversationId: conversationId,
          rootMessage: rootMessage,
          parentConversationStates: parentConversationStates,
          messageActionsRepository: messageActionsRepository,
          forwardTargets: forwardTargets,
          canModerate: canModerate,
          onClose: () => Navigator.of(sheetContext).pop(),
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
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) =>
          RepositoryProvider<ChatDiscussionRepository>.value(
            value: repository,
            child: ChatDiscussionSidePanel(
              parentConversation: parentConversation,
              rootMessage: rootMessage,
              onClose: () => Navigator.of(sheetContext).pop(),
            ),
          ),
    );
  }
}
