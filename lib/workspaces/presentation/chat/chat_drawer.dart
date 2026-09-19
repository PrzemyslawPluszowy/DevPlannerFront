import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_drawer_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_drawer_state.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/chat_panel_conversation.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/cubit/chat_panel_selection_cubit.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_theme_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wejście do istniejącego drawera Chat przez wspólny host modalny.
///
/// Nie rozwija funkcji Chat; zachowuje aktualny panel do czasu etapu 4.
abstract final class AppGlobalChatDrawer {
  /// Otwiera panel bez opuszczania bieżącego kontekstu aplikacji.
  static Future<void> show(
    BuildContext context, {
    required ChatRepository repository,
    ValueChanged<String>? onConversationSelected,
    String? initialConversationId,
    String? resourceConversationId,
    ResourceChatFileContext? resourceContext,
    VoidCallback? onResourceContextDismissed,
  }) async {
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (context) => Align(
        alignment: Alignment.centerRight,
        child: AppGlobalChatPanel(
          repository: repository,
          onConversationSelected: onConversationSelected,
          initialConversationId: initialConversationId,
          resourceConversationId: resourceConversationId,
          resourceContext: resourceContext,
          onResourceContextDismissed: onResourceContextDismissed,
        ),
      ),
    );
  }
}

/// Wielokrotnego użycia zawartość globalnego panelu Chat.
///
/// Shell używa jej jako przypiętego pane, a istniejący drawer jako modalnego
/// side sheeta. Nie zarządza stanem globalnego panelu.
class AppGlobalChatPanel extends StatelessWidget {
  const AppGlobalChatPanel({
    required this.repository,
    this.onClose,
    this.onConversationSelected,
    this.onOpenFullView,
    this.initialConversationId,
    this.resourceConversationId,
    this.resourceContext,
    this.onResourceContextDismissed,
    this.fillAvailableWidth = false,
    super.key,
  });

  final ChatRepository repository;
  final VoidCallback? onClose;
  final ValueChanged<String>? onConversationSelected;
  final ValueChanged<String>? onOpenFullView;
  final String? initialConversationId;
  final String? resourceConversationId;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceContextDismissed;
  final bool fillAvailableWidth;

  @override
  Widget build(BuildContext context) {
    final realtimeFactory = context.read<WorkspaceChatRealtimeFactory?>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = ChatDrawerCubit(repository);
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) => ChatPanelSelectionCubit(
            initialConversationId: initialConversationId,
          ),
        ),
      ],
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: fillAvailableWidth ? double.infinity : 384,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p12),
            child: Container(
              decoration: BoxDecoration(
                gradient: context.workspaceGlassGradient,
                border: context.workspaceGlassBorder,
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                boxShadow: context.workspaceGlassShadow,
              ),
              clipBehavior: Clip.antiAlias,
              child: _ChatDrawerContent(
                repository: repository,
                onClose: onClose,
                onConversationSelected: onConversationSelected,
                onOpenFullView: onOpenFullView,
                resourceConversationId: resourceConversationId,
                resourceContext: resourceContext,
                onResourceContextDismissed: onResourceContextDismissed,
                createRealtime: realtimeFactory?.create,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatDrawerContent extends StatelessWidget {
  const _ChatDrawerContent({
    required this.repository,
    this.onClose,
    this.onConversationSelected,
    this.onOpenFullView,
    this.resourceConversationId,
    this.resourceContext,
    this.onResourceContextDismissed,
    this.createRealtime,
  });

  final ChatRepository repository;
  final VoidCallback? onClose;
  final ValueChanged<String>? onConversationSelected;
  final ValueChanged<String>? onOpenFullView;
  final String? resourceConversationId;
  final ResourceChatFileContext? resourceContext;
  final VoidCallback? onResourceContextDismissed;
  final WorkspaceChatRealtimeService Function()? createRealtime;

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<ChatPanelSelectionCubit, ChatConversationResponse?>(
    builder: (context, conversation) {
      if (conversation != null) {
        return ChatPanelConversation(
          conversationRepository: repository is ChatConversationRepository
              ? repository as ChatConversationRepository
              : null,
          conversation: conversation,
          resourceContext: conversation.id == resourceConversationId
              ? resourceContext
              : null,
          onBack: () {
            onResourceContextDismissed?.call();
            context.read<ChatPanelSelectionCubit>().clear();
          },
          onResourceAccessRevoked: onResourceContextDismissed,
          createRealtime: createRealtime,
          onOpenFullView: onOpenFullView == null
              ? null
              : () => onOpenFullView!(conversation.id),
        );
      }
      return Column(
        children: [
          _ChatDrawerHeader(
            onClose: onClose ?? () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: BlocListener<ChatDrawerCubit, ChatDrawerState>(
              listener: (context, state) {
                if (state case ChatDrawerReady(:final conversations)) {
                  context.read<ChatPanelSelectionCubit>().restoreFrom(
                    conversations,
                  );
                }
              },
              child: BlocBuilder<ChatDrawerCubit, ChatDrawerState>(
                builder: (context, state) => switch (state) {
                  ChatDrawerInitial() || ChatDrawerLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  ChatDrawerEmpty() => _ChatMessage(
                    icon: WorkspaceIcons.chat,
                    title: context.l10n.globalChatEmptyTitle,
                    message: context.l10n.globalChatEmptyMessage,
                  ),
                  ChatDrawerFailure(:final message) => _ChatMessage(
                    icon: Symbols.error_outline,
                    title: context.l10n.globalChatLoadFailureTitle,
                    message: message,
                  ),
                  ChatDrawerReady(:final conversations) => _ConversationList(
                    conversations: conversations,
                    onTap: (conversation) {
                      onConversationSelected?.call(conversation.id);
                      context.read<ChatPanelSelectionCubit>().select(
                        conversation,
                      );
                    },
                  ),
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _ChatDrawerHeader extends StatelessWidget {
  const _ChatDrawerHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(
      Sizes.p16,
      Sizes.p12,
      Sizes.p8,
      Sizes.p8,
    ),
    child: Row(
      children: [
        const Icon(WorkspaceIcons.chat, size: 20),
        Gaps.w8,
        Expanded(
          child: Text(
            context.l10n.workspacesSectionChat,
            style: context.text.titleMedium,
          ),
        ),
        IconButton(
          tooltip: context.l10n.frameworkClose,
          onPressed: onClose,
          icon: const Icon(Symbols.close, size: 19),
        ),
      ],
    ),
  );
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({required this.conversations, required this.onTap});

  final List<ChatConversationResponse> conversations;
  final ValueChanged<ChatConversationResponse> onTap;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<ChatConversationResponse>>{};
    for (final conversation in conversations) {
      grouped
          .putIfAbsent(_groupLabel(context, conversation), () => [])
          .add(conversation);
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(Sizes.p12, 0, Sizes.p12, Sizes.p16),
      children: [
        for (final entry in grouped.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p4,
              Sizes.p8,
              Sizes.p4,
              Sizes.p4,
            ),
            child: Text(
              entry.key.toUpperCase(),
              style: context.text.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                letterSpacing: .5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final conversation in entry.value)
            _ConversationTile(conversation: conversation, onTap: onTap),
        ],
      ],
    );
  }

  String _groupLabel(
    BuildContext context,
    ChatConversationResponse conversation,
  ) {
    if (conversation.workspaceId != null && conversation.projectId != null) {
      return context.l10n.globalChatGroupProject;
    }
    if (conversation.workspaceId != null) {
      return context.l10n.globalChatGroupWorkspace;
    }
    return context.l10n.globalChatGroupPrivate;
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation, required this.onTap});

  final ChatConversationResponse conversation;
  final ValueChanged<ChatConversationResponse> onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(9)),
    ),
    leading: Icon(
      conversation.projectId == null
          ? WorkspaceIcons.chat
          : WorkspaceIcons.workflow,
      size: 19,
      color: context.colors.primary,
    ),
    title: Text(
      conversation.name?.trim().isNotEmpty == true
          ? conversation.name!
          : context.l10n.globalChatConversationFallback(
              conversation.id.substring(0, 8),
            ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    subtitle: Text(
      conversation.scopeKey,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
    onTap: () => onTap(conversation),
  );
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42),
          Gaps.h12,
          Text(
            title,
            style: context.text.titleMedium,
            textAlign: TextAlign.center,
          ),
          Gaps.h8,
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
