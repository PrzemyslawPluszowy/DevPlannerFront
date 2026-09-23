import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/presence/chat_presence_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_empty_copy.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/components/chat_inbox_row_menu.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/members/chat_members_sheet.dart';
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
/// Zadania pokazują uczciwy stan niepodłączonej integracji. Fraza w inboxie jest
/// wysyłana do serwera i wyszukuje nazwy rozmów oraz aktywnych uczestników;
/// wyszukiwanie treści wiadomości działa w osobnym widoku.
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
  Timer? _searchDebounce;
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
    _searchDebounce?.cancel();
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
    final chat = context.chatTheme;
    return BlocBuilder<ChatPanelSectionCubit, ChatPanelSectionState>(
      builder: (context, state) => SizedBox(
        width: ChatPanelSizeController.listMaxWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: chat.listSurface,
            border: Border(
              right: BorderSide(
                color: chat.separator.withValues(alpha: .6),
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
                    style: chat.contentStyle.copyWith(color: chat.incomingText),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: chat.panelSurface,
                      prefixIcon: Icon(
                        Symbols.search,
                        size: 18,
                        color: chat.metadataText,
                      ),
                      hintText: context.l10n.chatInboxSearchHint,
                      hintStyle: chat.contentStyle.copyWith(
                        color: chat.metadataText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: chat.separator),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: chat.separator),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: chat.focusRing),
                      ),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              tooltip: context.l10n.chatInboxSearchClear,
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                              icon: const Icon(Symbols.close, size: 16),
                            ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
              if (state.section.visibleFilters.length > 1)
                _filterBar(context, state.section),
              Expanded(child: _body(context, state.section)),
            ],
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    final query = value.trim();
    setState(() => _query = query);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      unawaited(context.read<ChatInboxCubit?>()?.setQuery(query));
    });
  }

  Widget _header(BuildContext context, ChatPanelSection section) {
    final chat = context.chatTheme;
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
                    style: chat.contentStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: chat.incomingText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (section.showsGlobalUnreadBadge && unreadTotal > 0) ...[
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
    final chat = context.chatTheme;
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
                style: chat.metadataStyle.copyWith(
                  color: filter == active ? chat.focusRing : chat.metadataText,
                  fontWeight: filter == active
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
              selected: filter == active,
              showCheckmark: false,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: chat.panelSurface,
              selectedColor: chat.selectedSurface,
              side: BorderSide(
                color: filter == active ? chat.focusRing : chat.separator,
              ),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
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
    final now = (widget.nowUtc ?? DateTime.now)();
    final archived =
        context.read<ChatPanelSectionCubit>().state.section ==
        ChatPanelSection.archived;
    final query = _query.toLowerCase();
    final filtered = query.length >= 2
        ? items
        : query.isEmpty
        ? items
        : items
              .where(
                (item) => item.displayName.toLowerCase().contains(query),
              )
              .toList(growable: false);
    if (filtered.isEmpty) {
      // Pusta strona nie oznacza końca rozmów: backend odfiltrowuje niedostępne
      // pozycje. Dopóki kursor istnieje, użytkownik musi mieć drogę do dalszych stron.
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
        final actionsBuilder = _rowActions(context, item, archived: archived);
        return Padding(
          padding: const EdgeInsets.only(bottom: Sizes.p2),
          child: AppContextMenuRegion(
            actionsBuilder: actionsBuilder,
            headerTitle: item.displayName,
            child: ChatInboxRow(
              item: item,
              nowUtc: now,
              selected: item.conversation.id == widget.selectedConversationId,
              onTap: widget.onConversationSelected,
              actionsBuilder: actionsBuilder,
            ),
          ),
        );
      },
    );
  }

  /// Akcje menu wiersza: jedno menu dla prawego kliku i długiego przytrzymania.
  ///
  /// Sekcja skrzynki rozstrzyga, czy pokazać archiwizację, czy przywrócenie;
  /// informacje otwierają istniejący arkusz członków, więc nie tworzymy drugiego
  /// widoku tych samych danych.
  List<AppContextMenuAction> Function(BuildContext context) _rowActions(
    BuildContext context,
    ChatInboxItem item, {
    required bool archived,
  }) {
    return (menuContext) => ChatInboxRowMenu.actions(
      menuContext,
      item: item,
      archived: archived,
      onOpen: () => widget.onConversationSelected(item),
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
    final chat = context.chatTheme;
    return Semantics(
      label: context.l10n.chatInboxUnreadSemantics(count),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p6, vertical: 1),
        decoration: BoxDecoration(
          color: chat.sendButtonSurface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
          count > 99 ? '99+' : '$count',
          style: chat.metadataStyle.copyWith(
            color: chat.sendButtonForeground,
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
