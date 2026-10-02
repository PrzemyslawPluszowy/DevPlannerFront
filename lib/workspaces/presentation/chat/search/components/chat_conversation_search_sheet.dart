import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_action_side_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/search/components/chat_search_view.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Search owned by a resource conversation independently of the global drawer.
abstract final class ChatConversationSearchSheet {
  static Future<void> show(
    BuildContext context, {
    required ChatSearchRepository repository,
    required String conversationId,
  }) {
    final conversation = context.read<ChatConversationCubit>();
    return DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) => BlocProvider(
        create: (_) => ChatSearchCubit(
          repository: repository,
          conversationId: conversationId,
        ),
        child: ChatActionSideSheet(
          child: _ConversationSearchContent(
            onSelected: (hit) => _openHit(
              sheetContext,
              conversation,
              conversationId,
              hit,
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> _openHit(
    BuildContext context,
    ChatConversationCubit conversation,
    String conversationId,
    ChatSearchHit hit,
  ) async {
    if (conversation.isClosed || hit.conversationId != conversationId) return;
    await conversation.ensureTargetLoaded(hit.messageId);
    if (!context.mounted || conversation.isClosed) return;
    Navigator.of(context).pop();
  }
}

class _ConversationSearchContent extends StatelessWidget {
  const _ConversationSearchContent({required this.onSelected});
  final Future<void> Function(ChatSearchHit) onSelected;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.chatSearchOpen,
                  style: context.chatTheme.contentStyle.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: context.l10n.frameworkClose,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Symbols.close, size: 18),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ChatSearchView(
              conversations: const [],
              onResultSelected: onSelected,
            ),
          ),
        ],
      ),
    ),
  );
}
