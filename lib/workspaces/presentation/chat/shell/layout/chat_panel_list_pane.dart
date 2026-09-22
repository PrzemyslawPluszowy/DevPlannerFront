import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_context_conversations_pane.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_context_source.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_section.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_saved_messages_pane.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/cubit/chat_panel_section_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kolumna listy panelu: nagłówek sekcji, wyszukiwanie, filtry i wiersze.
///
/// Wiersze pochodzą z serwerowej skrzynki (`ChatInboxCubit`) dla sekcji
/// Czaty/Grupy/Kanały/Archiwum, z portu zakładek dla Zapisanych, a Pliki i
/// Zadania pokazują uczciwy stan niepodłączonej integracji. Fraza filtruje już
/// pobrane pozycje i nie udaje wyszukiwania po serwerze.
class ChatPanelListPane extends StatefulWidget {
  /// Tworzy kolumnę listy.
  const ChatPanelListPane({
    required this.onConversationSelected,
    required this.onConversationOpened,
    this.onCompose,
    this.onSearchMessages,
    this.onOpenSavedMessage,
    this.onClose,
    this.nowUtc,
    this.selectedConversationId,
    super.key,
  });

  final ValueChanged<ChatInboxItem> onConversationSelected;
  final ValueChanged<ChatInboxItem> onConversationOpened;

  /// Otwiera zakotwiczony popover „Nowy czat”; brak portu oznacza brak akcji.
  final ValueChanged<Offset>? onCompose;

  /// Otwiera wyszukiwanie w treści wiadomości (fraza po stronie serwera).
  final VoidCallback? onSearchMessages;

  /// Otwiera rozmowę w miejscu zapisanej wiadomości.
  final void Function(String conversationId, String messageId)?
  onOpenSavedMessage;

  /// Zamyka panel; brak akcji oznacza panel bez przycisku zamknięcia.
  final VoidCallback? onClose;

  /// Czas odniesienia dla etykiet względnych; wstrzykiwany przez testy.
  final DateTime Function()? nowUtc;

  /// Rozmowa aktualnie otwarta w panelu; wiersz jest wtedy wyróżniony.
  final String? selectedConversationId;

  @override
  State<ChatPanelListPane> createState() => _ChatPanelListPaneState();
}

class _ChatPanelListPaneState extends State<ChatPanelListPane> {
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
      unawaited(context.read<ChatInboxCubit?>()?.loadMore());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ChatPanelSectionCubit, ChatPanelSectionState>(
      builder: (context, state) => SizedBox(
        width: ChatPanelSizeController.listMaxWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: .6),
              ),
            ),
          ),
          child: Column(
            children: [
              _header(context, state.section),
              if (state.section.hasConversationList)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Sizes.p12,
                    0,
                    Sizes.p12,
                    Sizes.p4,
                  ),
                  child: TextField(
                    key: const ValueKey('chat-panel-list-search'),
                    controller: _searchController,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Symbols.search, size: 18),
                      hintText: context.l10n.chatInboxSearchHint,
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: context.l10n.chatInboxSearchClear,
                              onPressed: () => setState(() {
                                _searchController.clear();
                                _query = '';
                              }),
                              icon: const Icon(Symbols.close, size: 16),
                            ),
                    ),
                    onChanged: (value) => setState(() => _query = value.trim()),
                  ),
                ),
              if (state.section.visibleFilters.isNotEmpty)
                _filterBar(context, state.section),
              Expanded(child: _body(context, state.section)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, ChatPanelSection section) {
    final theme = Theme.of(context);
    final unreadTotal = context.select<ChatInboxCubit?, int>(
      (cubit) => switch (cubit?.state) {
        ChatInboxReady(:final unreadTotal) => unreadTotal,
        _ => 0,
      },
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p12,
        Sizes.p8,
        Sizes.p4,
        Sizes.p4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    section.label(context),
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (unreadTotal > 0) ...[
                  Gaps.w8,
                  _UnreadTotalBadge(count: unreadTotal),
                ],
              ],
            ),
          ),
          if (widget.onSearchMessages != null)
            IconButton(
              key: const ValueKey('chat-panel-search'),
              tooltip: context.l10n.chatSearchOpen,
              onPressed: widget.onSearchMessages,
              icon: const Icon(Symbols.search, size: 19),
            ),
          if (widget.onCompose != null)
            IconButton(
              key: const ValueKey('chat-panel-new-conversation'),
              tooltip: context.l10n.chatComposeTitle,
              onPressed: () {
                final box = context.findRenderObject();
                final offset = box is RenderBox
                    ? box.localToGlobal(Offset(box.size.width, box.size.height))
                    : Offset.zero;
                widget.onCompose!(offset);
              },
              icon: const Icon(Symbols.add_comment_rounded, size: 19),
            ),
          if (widget.onClose != null)
            IconButton(
              tooltip: context.l10n.frameworkClose,
              onPressed: widget.onClose,
              icon: const Icon(Symbols.close, size: 19),
            ),
        ],
      ),
    );
  }

  Widget _filterBar(BuildContext context, ChatPanelSection section) {
    final cubit = context.read<ChatInboxCubit?>();
    final active = cubit?.filter ?? section.inboxFilter;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
      child: Wrap(
        spacing: Sizes.p6,
        children: [
          for (final filter in section.visibleFilters)
            FilterChip(
              key: ValueKey<String>('chat-panel-filter-${filter.name}'),
              label: Text(
                ChatPanelSectionPresentation.filterLabel(context, filter),
              ),
              selected: filter == active,
              onSelected: cubit == null
                  ? null
                  : (_) => unawaited(cubit.setFilter(filter)),
            ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, ChatPanelSection section) {
    switch (section) {
      case ChatPanelSection.files:
        return const ChatContextConversationsPane(
          kind: ChatContextSourceKind.file,
        );
      case ChatPanelSection.tasks:
        return const ChatContextConversationsPane(
          kind: ChatContextSourceKind.task,
        );
      case ChatPanelSection.saved:
        return ChatSavedMessagesPane(
          repository: context.read<ChatMessageActionsRepository?>(),
          onOpenMessage: widget.onOpenSavedMessage,
        );
      case ChatPanelSection.profile:
      case ChatPanelSection.settings:
      case ChatPanelSection.chats:
      case ChatPanelSection.groups:
      case ChatPanelSection.channels:
      case ChatPanelSection.archived:
        return _inboxBody(context);
    }
  }

  Widget _inboxBody(BuildContext context) {
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
        ChatInboxEmpty() => _ChatPanelListMessage(
          icon: Symbols.forum_rounded,
          message: context.l10n.globalChatEmptyMessage,
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
    final now = (widget.nowUtc ?? DateTime.now)();
    final query = _query.toLowerCase();
    final filtered = query.isEmpty
        ? items
        : items
              .where(
                (item) => item.displayName.toLowerCase().contains(query),
              )
              .toList(growable: false);
    if (filtered.isEmpty) {
      // Pusta strona nie oznacza końca rozmów: backend odfiltrowuje niedostępne
      // pozycje, a fraza filtruje już pobrane. Dopóki kursor istnieje, użytkownik
      // musi mieć drogę do dalszych stron.
      final state = cubit.state;
      final hasMore = state is ChatInboxReady && state.hasMore;
      return _ChatPanelListMessage(
        icon: query.isEmpty
            ? Symbols.forum_rounded
            : Symbols.search_off_rounded,
        message: query.isEmpty
            ? context.l10n.chatInboxEmptyPageMore
            : context.l10n.chatInboxNoResultsMessage,
        onRetry: hasMore ? () => unawaited(cubit.loadMore()) : null,
        actionLabel: hasMore ? context.l10n.chatInboxLoadMore : null,
        busy: state is ChatInboxReady && state.isLoadingMore,
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(Sizes.p8, 0, Sizes.p8, Sizes.p16),
      itemCount: filtered.length + 1,
      itemBuilder: (context, index) {
        if (index == filtered.length) return _footer(context, cubit);
        final item = filtered[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p2),
          child: ChatInboxRow(
            item: item,
            nowUtc: now,
            selected: item.conversation.id == widget.selectedConversationId,
            onTap: widget.onConversationSelected,
          ),
        );
      },
    );
  }

  /// Stopka listy: doładowanie, błąd doładowania albo koniec listy.
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

class _UnreadTotalBadge extends StatelessWidget {
  const _UnreadTotalBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: context.l10n.chatInboxUnreadSemantics(count),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p6, vertical: 1),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          count > 99 ? '99+' : '$count',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
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

  /// Etykieta akcji ratunkowej (np. doładowanie dalszych stron).
  final String? actionLabel;

  /// Czy akcja już trwa; wtedy przycisk zamienia się w wskaźnik.
  final bool busy;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(Sizes.p24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: context.colors.onSurfaceVariant),
          Gaps.h12,
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
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
