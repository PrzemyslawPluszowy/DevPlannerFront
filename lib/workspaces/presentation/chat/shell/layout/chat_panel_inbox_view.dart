import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_empty_copy.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_presence_failure.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista rozmów, ładowanie kolejnych stron i menu kontekstowe wiersza.
class ChatPanelInboxView extends StatelessWidget {
  const ChatPanelInboxView({
    required this.scrollController,
    required this.query,
    required this.selectedConversationId,
    required this.onConversationSelected,
    this.nowUtc,
    super.key,
  });

  final ScrollController scrollController;
  final String query;
  final String? selectedConversationId;
  final ValueChanged<ChatInboxItem> onConversationSelected;
  final DateTime Function()? nowUtc;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatInboxCubit?>();
    if (cubit == null) {
      return _ChatPanelListMessage(
        icon: Symbols.forum_rounded,
        message: context.l10n.chatPanelListUnavailable,
      );
    }
    return BlocBuilder<ChatInboxCubit, ChatInboxState>(
      bloc: cubit,
      builder: (context, state) => switch (state) {
        ChatInboxLoading() => const Center(child: CircularProgressIndicator()),
        ChatInboxFailure() => _ChatPanelListMessage(
          icon: Symbols.error_outline,
          message: context.l10n.chatInboxLoadMoreFailed,
          onRetry: () => unawaited(cubit.retry()),
        ),
        ChatInboxEmpty(:final filter) => _ChatPanelListMessage(
          icon: Symbols.forum_rounded,
          message: ChatInboxEmptyCopy.forFilter(context.l10n, filter),
        ),
        ChatInboxReady(:final items) => _rows(context, cubit, items),
      },
    );
  }

  Widget _rows(
    BuildContext context,
    ChatInboxCubit cubit,
    List<ChatInboxItem> items,
  ) {
    final presenceError = context.select<ChatInboxPresenceCubit?, ApiError?>(
      (cubit) => cubit?.state.error,
    );
    final retryCountdownSeconds = context.select<ChatInboxPresenceCubit?, int>(
      (cubit) => cubit?.state.retryCountdownSeconds ?? 0,
    );
    final now = (nowUtc ?? DateTime.now)();
    final archived =
        context.read<ChatPanelSectionCubit>().state.section ==
        ChatPanelSection.archived;
    final normalizedQuery = query.toLowerCase();
    final filtered = normalizedQuery.length >= 2
        ? items
        : normalizedQuery.isEmpty
        ? items
        : items
              .where(
                (item) => item.displayName.toLowerCase().contains(
                  normalizedQuery,
                ),
              )
              .toList(growable: false);
    if (filtered.isEmpty) {
      // Pusta strona nie oznacza końca rozmów: backend może odfiltrować
      // niedostępne pozycje. Kursor nadal daje drogę do kolejnych stron.
      final state = cubit.state;
      final hasMore = state is ChatInboxReady && state.hasMore;
      return _ChatPanelListMessage(
        icon: normalizedQuery.isEmpty
            ? Symbols.forum_rounded
            : Symbols.search_off_rounded,
        message: normalizedQuery.isEmpty
            ? context.l10n.chatInboxEmptyPageMore
            : context.l10n.chatInboxNoResultsMessage,
        onRetry: hasMore ? () => unawaited(cubit.loadMore()) : null,
        actionLabel: hasMore ? context.l10n.chatInboxLoadMore : null,
        busy: state is ChatInboxReady && state.isLoadingMore,
      );
    }
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p16),
      itemCount: filtered.length + 1 + (presenceError == null ? 0 : 1),
      itemBuilder: (context, index) {
        if (presenceError != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p4),
            child: ChatInboxPresenceFailure(
              error: presenceError,
              retryCountdownSeconds: retryCountdownSeconds,
              onRetry: () => unawaited(
                context.read<ChatInboxPresenceCubit?>()?.retry(),
              ),
            ),
          );
        }
        final rowIndex = index - (presenceError == null ? 0 : 1);
        if (rowIndex == filtered.length) return _footer(context, cubit);
        final item = filtered[rowIndex];
        final actionsBuilder = _rowActions(context, item, archived: archived);
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p2),
          child: AppContextMenuRegion(
            actionsBuilder: actionsBuilder,
            headerTitle: item.displayName,
            child: ChatInboxRow(
              item: item,
              nowUtc: now,
              selected: item.conversation.id == selectedConversationId,
              onTap: onConversationSelected,
              actionsBuilder: actionsBuilder,
            ),
          ),
        );
      },
    );
  }

  /// Udostępnia te same akcje pod prawym klikiem i długim przytrzymaniem.
  List<AppContextMenuAction> Function(BuildContext context) _rowActions(
    BuildContext context,
    ChatInboxItem item, {
    required bool archived,
  }) {
    return (menuContext) => ChatInboxRowMenu.actions(
      menuContext,
      item: item,
      archived: archived,
      onOpen: () => onConversationSelected(item),
      onInfo: context.read<ChatMembersRepository?>() == null
          ? null
          : () => unawaited(
              ChatMembersSheet.show(
                context,
                membersRepository: context.read<ChatMembersRepository?>(),
                conversation: item.conversation,
                currentUserId:
                    context.read<AuthSessionPort?>()?.snapshot.user?.userId ??
                    '',
                conversationManagement: context
                    .read<ChatConversationManagementRepository?>(),
                presenceRepository: context.read<ChatPresenceRepository?>(),
                directoryRepository: context.read<ChatDirectoryRepository?>(),
              ),
            ),
    );
  }

  Widget _footer(BuildContext context, ChatInboxCubit cubit) {
    final state = cubit.state;
    if (state is! ChatInboxReady) return Gaps.h8;
    if (state.loadMoreFailed) {
      return Padding(
        padding: const EdgeInsets.all(Sizes.p8),
        child: TextButton(
          onPressed: () => unawaited(cubit.loadMore()),
          child: Text(context.l10n.chatInboxRetry),
        ),
      );
    }
    if (!state.hasMore) return Gaps.h8;
    return const Padding(
      padding: EdgeInsets.all(Sizes.p8),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ChatPanelListMessage extends StatelessWidget {
  const _ChatPanelListMessage({
    required this.icon,
    required this.message,
    this.onRetry,
    this.actionLabel,
    this.busy = false,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;
  final String? actionLabel;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: chat.metadataText),
            Gaps.h12,
            Text(
              message,
              textAlign: TextAlign.center,
              style: chat.metadataStyle.copyWith(color: chat.metadataText),
            ),
            if (onRetry != null) ...[
              Gaps.h8,
              if (busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                TextButton(
                  onPressed: onRetry,
                  child: Text(actionLabel ?? context.l10n.chatInboxRetry),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
