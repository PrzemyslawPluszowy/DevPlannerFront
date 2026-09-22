import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista serwerowej skrzynki rozmów z filtrem, wyszukiwaniem i stronicowaniem.
///
/// Widget nie pobiera danych samodzielnie: stan i strony prowadzi
/// [ChatInboxCubit], a fraza filtruje już pobrane pozycje, więc wyszukiwanie
/// lokalne nie udaje wyszukiwania po serwerze.
class ChatInboxList extends StatefulWidget {
  /// Tworzy listę skrzynki.
  const ChatInboxList({
    required this.onConversationSelected,
    this.onConversationOpened,
    this.nowUtc,
    super.key,
  });

  final ValueChanged<ChatInboxItem> onConversationSelected;

  /// Wywoływane, gdy użytkownik faktycznie widzi rozmowę (np. do oznaczenia odczytu).
  final ValueChanged<ChatInboxItem>? onConversationOpened;

  /// Czas odniesienia dla etykiet względnych; wstrzykiwany przez testy.
  final DateTime Function()? nowUtc;

  @override
  State<ChatInboxList> createState() => _ChatInboxListState();
}

class _ChatInboxListState extends State<ChatInboxList> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreIfNeeded);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMoreIfNeeded)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadMoreIfNeeded() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      unawaited(context.read<ChatInboxCubit>().loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChatInboxSearchField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value.trim()),
          onClear: () => setState(() {
            _searchController.clear();
            _query = '';
          }),
        ),
        const SizedBox(height: Sizes.p8),
        const _ChatInboxFilterBar(),
        const SizedBox(height: Sizes.p4),
        Expanded(
          child: BlocBuilder<ChatInboxCubit, ChatInboxState>(
            builder: (context, state) => switch (state) {
              ChatInboxLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              ChatInboxFailure(:final message) => _ChatInboxMessage(
                icon: Symbols.error_outline,
                title: context.l10n.globalChatLoadFailureTitle,
                message: message,
                actionLabel: context.l10n.chatInboxRetry,
                onAction: () => context.read<ChatInboxCubit>().retry(),
              ),
              ChatInboxEmpty() => _ChatInboxMessage(
                icon: WorkspaceIcons.chat,
                title: context.l10n.globalChatEmptyTitle,
                message: context.l10n.globalChatEmptyMessage,
              ),
              ChatInboxReady(:final items) => _buildList(context, items),
            },
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, List<ChatInboxItem> items) {
    final visible = _query.isEmpty
        ? items
        : items.where((item) => _matches(item, _query)).toList(growable: false);
    if (visible.isEmpty) {
      return _ChatInboxMessage(
        icon: Symbols.search_off,
        title: context.l10n.chatInboxNoResultsTitle,
        message: context.l10n.chatInboxNoResultsMessage,
      );
    }
    final state = context.read<ChatInboxCubit>().state;
    final hasMore = state is ChatInboxReady && state.hasMore;
    final loadMoreFailed = state is ChatInboxReady && state.loadMoreFailed;
    final nowUtc = widget.nowUtc?.call() ?? DateTime.now().toUtc();

    return RefreshIndicator(
      onRefresh: () => context.read<ChatInboxCubit>().refresh(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: Sizes.p8),
        itemCount: visible.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= visible.length) {
            return _ChatInboxLoadMoreTile(
              failed: loadMoreFailed,
              onRetry: () => unawaited(
                context.read<ChatInboxCubit>().loadMore(),
              ),
            );
          }
          final item = visible[index];
          return ChatInboxRow(
            item: item,
            nowUtc: nowUtc,
            onTap: (selected) {
              widget.onConversationSelected(selected);
              widget.onConversationOpened?.call(selected);
            },
          );
        },
      ),
    );
  }

  static bool _matches(ChatInboxItem item, String query) {
    final needle = query.toLowerCase();
    if (item.displayName.toLowerCase().contains(needle)) return true;
    final preview = item.lastMessage?.text?.toLowerCase() ?? '';
    if (preview.contains(needle)) return true;
    return item.participants.any(
      (participant) =>
          participant.label.toLowerCase().contains(needle) ||
          (participant.login ?? '').toLowerCase().contains(needle),
    );
  }
}

class _ChatInboxSearchField extends StatelessWidget {
  const _ChatInboxSearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    onChanged: onChanged,
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      isDense: true,
      prefixIcon: const Icon(Symbols.search, size: 18),
      hintText: context.l10n.chatInboxSearchHint,
      suffixIcon: controller.text.isEmpty
          ? null
          : IconButton(
              onPressed: onClear,
              tooltip: context.l10n.chatInboxSearchClear,
              icon: const Icon(Symbols.close, size: 16),
            ),
    ),
  );
}

class _ChatInboxFilterBar extends StatelessWidget {
  const _ChatInboxFilterBar();

  static const _filters = <ChatInboxFilter>[
    ChatInboxFilter.all,
    ChatInboxFilter.unread,
    ChatInboxFilter.direct,
    ChatInboxFilter.groups,
    ChatInboxFilter.channels,
    ChatInboxFilter.archived,
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatInboxCubit>();
    return BlocBuilder<ChatInboxCubit, ChatInboxState>(
      builder: (context, state) {
        final active = cubit.filter;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final filter in _filters) ...[
                ChoiceChip(
                  label: Text(_label(context, filter)),
                  selected: active == filter,
                  onSelected: (_) => unawaited(cubit.setFilter(filter)),
                ),
                const SizedBox(width: Sizes.p6),
              ],
            ],
          ),
        );
      },
    );
  }

  static String _label(BuildContext context, ChatInboxFilter filter) =>
      switch (filter) {
        ChatInboxFilter.all => context.l10n.chatInboxFilterAll,
        ChatInboxFilter.unread => context.l10n.chatInboxFilterUnread,
        ChatInboxFilter.direct => context.l10n.chatInboxFilterDirect,
        ChatInboxFilter.groups => context.l10n.chatInboxFilterGroups,
        ChatInboxFilter.channels => context.l10n.chatInboxFilterChannels,
        ChatInboxFilter.archived => context.l10n.chatInboxFilterArchived,
      };
}

class _ChatInboxLoadMoreTile extends StatelessWidget {
  const _ChatInboxLoadMoreTile({required this.failed, required this.onRetry});

  final bool failed;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Sizes.p8),
    child: failed
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  context.l10n.chatInboxLoadMoreFailed,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: Text(context.l10n.chatInboxRetry),
              ),
            ],
          )
        : const Center(
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
  );
}

class _ChatInboxMessage extends StatelessWidget {
  const _ChatInboxMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: Sizes.p8),
            Text(title, style: theme.textTheme.titleSmall, textAlign: TextAlign.center),
            const SizedBox(height: Sizes.p4),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: Sizes.p8),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
