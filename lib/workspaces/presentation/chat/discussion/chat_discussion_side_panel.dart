import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/chat_conversation_page.dart';
import 'package:ready_next/workspaces/presentation/chat/discussion/cubit/chat_discussion_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/discussion/cubit/chat_discussion_state.dart';

/// Prawy panel tworzenia albo odczytu nazwanej dyskusji wiadomości.
class ChatDiscussionSidePanel extends StatefulWidget {
  const ChatDiscussionSidePanel({
    required this.parentConversation,
    required this.rootMessage,
    required this.onClose,
    super.key,
  });

  final ChatConversation parentConversation;
  final ChatMessage rootMessage;
  final VoidCallback onClose;

  @override
  State<ChatDiscussionSidePanel> createState() =>
      _ChatDiscussionSidePanelState();
}

class _ChatDiscussionSidePanelState extends State<ChatDiscussionSidePanel> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => ChatDiscussionCubit(
      context.read<ChatDiscussionRepository>(),
    ),
    child: Builder(
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: context.colors.outlineVariant),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.chatDiscussionTitle,
                      style: context.text.titleSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.chatThreadClose,
                    onPressed: widget.onClose,
                    icon: const Icon(Symbols.close_rounded),
                  ),
                ],
              ),
              Gaps.h8,
              Text(
                widget.rootMessage.text,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Gaps.h12,
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: context.l10n.chatDiscussionNameLabel,
                ),
                onSubmitted: (_) => _open(context),
              ),
              Gaps.h8,
              BlocBuilder<ChatDiscussionCubit, ChatDiscussionState>(
                builder: (context, state) => switch (state) {
                  ChatDiscussionResolving() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ChatDiscussionReady(:final conversation) => Expanded(
                    child: ChatConversationPageView(
                      conversationId: conversation.id,
                    ),
                  ),
                  ChatDiscussionFailure(:final message) ||
                  ChatDiscussionDetached(:final message) => Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                  ChatDiscussionIdle() => FilledButton.icon(
                    onPressed: () => _open(context),
                    icon: const Icon(Symbols.forum_rounded),
                    label: Text(context.l10n.chatDiscussionOpen),
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _open(BuildContext context) => context.read<ChatDiscussionCubit>().open(
    parentConversation: widget.parentConversation,
    rootMessageId: widget.rootMessage.id,
    name: _nameController.text,
  );
}
