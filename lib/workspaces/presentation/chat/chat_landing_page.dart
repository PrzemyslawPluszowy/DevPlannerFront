import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';
import 'package:ready_next/workspaces/domain/repositories/chat_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_drawer_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/cubit/chat_drawer_state.dart';

/// Pełna lista rozmów używana wyłącznie jako trasa awaryjna/deep-link.
/// Główne wejście użytkownika pozostaje drawerem z topbara.
class ChatLandingPageView extends StatelessWidget {
  const ChatLandingPageView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = ChatDrawerCubit(context.read<ChatRepository>());
      unawaited(cubit.load());
      return cubit;
    },
    child: BlocBuilder<ChatDrawerCubit, ChatDrawerState>(
      builder: (context, state) => Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: switch (state) {
          ChatDrawerInitial() || ChatDrawerLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ChatDrawerEmpty() => const Center(child: Text('Brak rozmów.')),
          ChatDrawerFailure(:final message) => Center(child: Text(message)),
          ChatDrawerReady(:final conversations) => _ConversationList(
            conversations: conversations,
          ),
        },
      ),
    ),
  );
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({required this.conversations});

  final List<ChatConversationResponse> conversations;

  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: conversations.length,
    separatorBuilder: (context, index) => const SizedBox(height: Sizes.p8),
    itemBuilder: (context, index) {
      final conversation = conversations[index];
      return Card(
        elevation: 0,
        child: ListTile(
          leading: const Icon(WorkspaceIcons.chat),
          title: Text(conversation.name ?? conversation.scopeKey),
          subtitle: Text(conversation.scopeKey),
          onTap: () => unawaited(
            context.router.navigatePath(
              '/chat/conversations/${conversation.id}',
            ),
          ),
        ),
      );
    },
  );
}
