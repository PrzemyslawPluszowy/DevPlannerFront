import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_conversation_page.dart';
import 'package:devplanner/workspaces/presentation/chat/discussion/cubit/chat_discussion_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/discussion/cubit/chat_discussion_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

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
            left: BorderSide(color: context.chatTheme.separator),
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
                      style: context.chatTheme.contentStyle.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
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
                style: context.chatTheme.contentStyle.copyWith(
                  color: context.chatTheme.metadataText,
                ),
              ),
              Gaps.h12,
              TextField(
                controller: _nameController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: context.l10n.chatDiscussionNameLabel,
                  labelStyle: context.chatTheme.metadataStyle.copyWith(
                    color: context.chatTheme.metadataText,
                  ),
                  filled: true,
                  fillColor: context.chatTheme.composerSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.chatTheme.separator),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.chatTheme.separator),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: context.chatTheme.focusRing,
                      width: 1.5,
                    ),
                  ),
                ),
                style: context.chatTheme.contentStyle.copyWith(
                  color: context.chatTheme.incomingText,
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
                  ChatDiscussionFailure() || ChatDiscussionDetached() => Text(
                    context.l10n.chatDiscussionLoadFailureMessage,
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
