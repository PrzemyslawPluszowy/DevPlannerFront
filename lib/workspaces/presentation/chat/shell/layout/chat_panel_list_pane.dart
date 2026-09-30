import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_context_conversations_pane.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_context_source.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_filter_pill.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_inbox_view.dart';
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
    final cubit = context.read<ChatInboxCubit?>();
    final active = cubit?.filter ?? section.inboxFilter;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p12),
      child: Wrap(
        spacing: Sizes.p6,
        children: [
          for (final filter in section.visibleFilters)
            ChatPanelFilterPill(
              key: ValueKey<String>('chat-panel-filter-${filter.name}'),
              label: ChatPanelSectionPresentation.filterLabel(context, filter),
              selected: filter == active,
              onTap: cubit == null
                  ? null
                  : () => unawaited(cubit.setFilter(filter)),
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
    return ChatPanelInboxView(
      scrollController: _scrollController,
      query: _query,
      selectedConversationId: widget.selectedConversationId,
      onConversationSelected: widget.onConversationSelected,
      nowUtc: widget.nowUtc,
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
