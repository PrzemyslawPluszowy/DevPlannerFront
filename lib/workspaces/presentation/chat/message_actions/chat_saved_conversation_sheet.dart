import 'dart:math' as math;

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_global_panel.dart';
import 'package:devplanner/workspaces/presentation/chat/emoji/cubit/chat_emoji_recent_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_session_dependency_scope.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Opens a saved message in another conversation without losing task drafts.
abstract final class ChatSavedConversationSheet {
  static Future<void> show(
    BuildContext context, {
    required DevPlannerGlobalChatComposition composition,
    required ChatConversation conversation,
    required String messageId,
    String? role,
  }) {
    final auth = context.read<AuthSessionPort?>();
    final storage = context.read<StorageRepository?>();
    final emoji = context.read<ChatEmojiRecentCubit?>();
    return DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) => ChatSessionDependencyScope(
        composition: composition,
        authSession: auth,
        storageRepository: storage,
        emojiRecentCubit: emoji,
        child: _SavedConversationContent(
          composition: composition,
          selection: ChatPanelSelection(
            conversation: conversation,
            targetMessageId: messageId,
            role: role,
          ),
          onClose: () => Navigator.of(sheetContext).pop(),
        ),
      ),
    );
  }
}

class _SavedConversationContent extends StatelessWidget {
  const _SavedConversationContent({
    required this.composition,
    required this.selection,
    required this.onClose,
  });

  final DevPlannerGlobalChatComposition composition;
  final ChatPanelSelection selection;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SizedBox(
      width: math.min(960, constraints.maxWidth),
      height: constraints.maxHeight,
      child: AppGlobalChatPanel(
        repository: composition.repository,
        initialSelection: selection,
        inboxCubit: context.read<ChatInboxCubit?>(),
        onClose: onClose,
        fillAvailableWidth: true,
        canPin: false,
      ),
    ),
  );
}
