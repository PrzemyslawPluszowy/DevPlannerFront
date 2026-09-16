// Importy są ułożone warstwowo: widok zależy od composera i kontraktów Chat.
// ignore_for_file: directives_ordering

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:ready_next/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/composer/chat_message_composer.dart';
import 'package:ready_next/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/thread/cubit/chat_thread_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/thread/cubit/chat_thread_state.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_conversation_state.dart';

/// Prawy, lokalny subpanel odpowiedzi jednego wątku bez zmiany trasy.
class ChatThreadSidePanel extends StatefulWidget {
  const ChatThreadSidePanel({
    required this.conversationId,
    required this.rootMessage,
    required this.onClose,
    this.parentConversationStates,
    super.key,
  });
  final String conversationId;
  final ChatMessage rootMessage;
  final VoidCallback onClose;
  final Stream<ChatConversationState>? parentConversationStates;

  @override
  State<ChatThreadSidePanel> createState() => _ChatThreadSidePanelState();
}

class _ChatThreadSidePanelState extends State<ChatThreadSidePanel> {
  final ValueNotifier<bool> _accessRevocation = ValueNotifier(false);

  @override
  void dispose() {
    _accessRevocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = ChatThreadCubit(
        context.read<ChatThreadRepository>(),
        deliveryRepository: context.read<ChatConversationRepository>(),
        conversationId: widget.conversationId,
        threadRootMessageId: widget.rootMessage.id,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: Builder(
      builder: (context) => BlocListener<ChatThreadCubit, ChatThreadState>(
        listenWhen: (_, state) => state is ChatThreadDetached,
        listener: (_, _) => _accessRevocation.value = true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: context.colors.outlineVariant),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.rootMessage.text,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Gaps.h8,
              Expanded(
                child: BlocBuilder<ChatThreadCubit, ChatThreadState>(
                  builder: (context, state) => switch (state) {
                    ChatThreadLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    ChatThreadFailure(:final message) ||
                    ChatThreadDetached(:final message) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p16),
                        child: Text(message, textAlign: TextAlign.center),
                      ),
                    ),
                    ChatThreadReady(
                      :final messages,
                      :final nextCursor,
                      :final isLoadingMore,
                    ) =>
                      ListView.separated(
                        padding: const EdgeInsets.all(Sizes.p12),
                        itemCount:
                            messages.length + (nextCursor == null ? 0 : 1),
                        separatorBuilder: (_, _) => Gaps.h8,
                        itemBuilder: (_, index) => index == messages.length
                            ? TextButton(
                                onPressed: isLoadingMore
                                    ? null
                                    : () => context
                                          .read<ChatThreadCubit>()
                                          .loadMore(),
                                child: Text(context.l10n.chatThreadLoadOlder),
                              )
                            : Text(messages[index].text),
                      ),
                  },
                ),
              ),
              ChatMessageComposer(
                compact: true,
                onSubmit: (draft) {
                  context.read<ChatThreadCubit>().sendDraft(draft);
                  return null;
                },
                draftRepository: context.read<ChatDraftRepository>(),
                userId:
                    context.read<AuthRepository>().currentUser?.coreUserId ??
                    '',
                conversationId: 'thread:${widget.rootMessage.id}',
                accessRevocation: _accessRevocation,
                conversationStates: widget.parentConversationStates,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
