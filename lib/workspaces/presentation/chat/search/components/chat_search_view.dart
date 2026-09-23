import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_user_avatar.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wyszukiwanie wiadomości w panelu: fraza, wyniki i skok do wiadomości.
///
/// Widok nie otwiera rozmów samodzielnie. Zwraca wybrany wynik jako parę
/// rozmowa + wiadomość, a panel decyduje o wyborze rozmowy i przewinięciu.
class ChatSearchView extends StatefulWidget {
  /// Tworzy widok wyszukiwania.
  const ChatSearchView({
    required this.conversations,
    required this.onResultSelected,
    super.key,
  });

  /// Lokalna kopia skrzynki wzbogacająca nazwę, awatar i autora w wynikach.
  /// Brak pozycji nie wyłącza wyniku: rodzic rozwiązuje rozmowę po ID przez ACL.
  final List<ChatInboxItem> conversations;

  /// Otwiera rozmowę z ACL po jej ID i przewija do wybranej wiadomości.
  final Future<void> Function(ChatSearchHit hit) onResultSelected;

  @override
  State<ChatSearchView> createState() => _ChatSearchViewState();
}

class _ChatSearchViewState extends State<ChatSearchView> {
  final TextEditingController _controller = TextEditingController();
  String? _openingMessageId;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectHit(ChatSearchHit hit) async {
    if (_openingMessageId != null) return;
    setState(() => _openingMessageId = hit.messageId);
    try {
      await widget.onResultSelected(hit);
    } finally {
      if (mounted) setState(() => _openingMessageId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    const minimumTermLength = 2;
    final chat = context.chatTheme;
    return Column(
      children: [
        TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
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
            hintText: context.l10n.chatSearchHint,
            hintStyle: chat.contentStyle.copyWith(color: chat.metadataText),
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
            suffixIcon: IconButton(
              tooltip: context.l10n.chatSearchClose,
              onPressed: () {
                _controller.clear();
                context.read<ChatSearchCubit>().clear();
              },
              icon: const Icon(Symbols.close, size: 16),
            ),
          ),
          onChanged: context.read<ChatSearchCubit>().updateTerm,
        ),
        const SizedBox(height: Sizes.p8),
        Expanded(
          child: BlocBuilder<ChatSearchCubit, ChatSearchState>(
            builder: (context, state) {
              if (state.term.trim().isEmpty) {
                return _SearchMessage(
                  icon: Symbols.search,
                  title: context.l10n.chatSearchPromptTitle,
                  message: context.l10n.chatSearchPromptMessage,
                );
              }
              if (state.isTermTooShort(minimumTermLength)) {
                return _SearchMessage(
                  icon: Symbols.search,
                  title: context.l10n.chatSearchTooShort(minimumTermLength),
                  message: context.l10n.chatSearchTooShortMessage(
                    minimumTermLength,
                  ),
                );
              }
              if (state.isSearching && state.page == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.failureCode != null) {
                return _SearchMessage(
                  icon: Symbols.error_outline,
                  title: state.isRateLimited
                      ? context.l10n.chatSearchRateLimitedTitle
                      : context.l10n.chatSearchFailureTitle,
                  message: context.l10n.chatActionFailureMessage,
                  onRetry: () => unawaited(
                    context.read<ChatSearchCubit>().retry(),
                  ),
                );
              }
              if (state.isEmpty) {
                return _SearchMessage(
                  icon: Symbols.search_off,
                  title: context.l10n.chatSearchEmptyTitle,
                  message: context.l10n.chatSearchEmptyMessage,
                );
              }
              final hits = state.page?.hits ?? const <ChatSearchHit>[];
              return ListView.builder(
                itemCount:
                    hits.length + (state.page?.nextCursor != null ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= hits.length) {
                    return Padding(
                      padding: const EdgeInsets.all(Sizes.p8),
                      child: Center(
                        child: TextButton(
                          onPressed: () => unawaited(
                            context.read<ChatSearchCubit>().loadMore(),
                          ),
                          child: Text(context.l10n.chatInboxLoadMore),
                        ),
                      ),
                    );
                  }
                  final hit = hits[index];
                  final conversation = _conversationFor(hit.conversationId);
                  return AppContextMenuRegion(
                    actionsBuilder: (menuContext) =>
                        _resultActions(menuContext, hit, conversation),
                    headerTitle:
                        conversation?.displayName ?? hit.conversationName,
                    child: _ChatSearchHitRow(
                      hit: hit,
                      conversation: conversation,
                      isOpening: _openingMessageId == hit.messageId,
                      onTap: () => unawaited(_selectHit(hit)),
                      onLongPress: () => unawaited(
                        _openResultMenu(context, hit, conversation),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Menu wyniku wyszukiwania: wspólny model akcji dla prawego kliku i
  /// długiego przytrzymania, z realnym skutkiem (skok albo schowek).
  List<AppContextMenuAction> _resultActions(
    BuildContext context,
    ChatSearchHit hit,
    ChatInboxItem? conversation,
  ) => <AppContextMenuAction>[
    AppContextMenuAction(
      label: context.l10n.chatSearchOpenResult,
      icon: Symbols.forum,
      onTap: (_) => _selectHit(hit),
    ),
    AppContextMenuAction(
      label: context.l10n.chatSearchCopySnippet,
      icon: Symbols.content_copy,
      onTap: (_) => unawaited(
        Clipboard.setData(ClipboardData(text: hit.text)),
      ),
    ),
  ];

  Future<void> _openResultMenu(
    BuildContext context,
    ChatSearchHit hit,
    ChatInboxItem? conversation,
  ) {
    final actions = _resultActions(context, hit, conversation);
    if (actions.isEmpty) return Future<void>.value();
    return AppContextMenu.show(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      actions: actions,
      headerTitle: conversation?.displayName ?? hit.conversationName,
    );
  }

  ChatInboxItem? _conversationFor(String conversationId) => widget.conversations
      .where((item) => item.conversation.id == conversationId)
      .firstOrNull;
}

class _ChatSearchHitRow extends StatelessWidget {
  const _ChatSearchHitRow({
    required this.hit,
    required this.conversation,
    required this.isOpening,
    required this.onTap,
    required this.onLongPress,
  });

  final ChatSearchHit hit;
  final ChatInboxItem? conversation;
  final bool isOpening;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    final currentConversation = conversation;
    final sender = currentConversation?.participants
        .where((participant) => participant.userId == hit.authorUserId)
        .firstOrNull;
    final other = currentConversation?.otherParticipants.firstOrNull;
    final isDirect = currentConversation?.conversation.type == 'direct';
    final localTime = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(hit.createdAtUtc.toLocal()),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p2,
      ),
      child: Material(
        color: chat.listSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDirect)
                  AppUserAvatar(
                    userId: other?.userId,
                    displayName:
                        other?.label ?? currentConversation?.displayName,
                    avatarUrl: other?.avatarUrl,
                    hasCustomAvatar:
                        other?.avatarUrl?.trim().isNotEmpty == true,
                    radius: 18,
                    singleInitial: true,
                  )
                else
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: chat.selectedSurface,
                    child: Icon(
                      currentConversation?.conversation.type == 'channel'
                          ? Symbols.campaign_rounded
                          : Symbols.group_rounded,
                      size: 18,
                      color: chat.linkText,
                    ),
                  ),
                const SizedBox(width: Sizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              currentConversation?.displayName ??
                                  hit.conversationName ??
                                  context.l10n.chatSearchOpenResult,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: chat.contentStyle.copyWith(
                                color: chat.incomingText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: Sizes.p8),
                          if (!isOpening)
                            Text(
                              localTime,
                              style: chat.metadataStyle.copyWith(
                                color: chat.metadataText,
                              ),
                            )
                          else
                            SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: chat.linkText,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: Sizes.p2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              sender?.label ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: chat.metadataStyle.copyWith(
                                color: chat.metadataText,
                              ),
                            ),
                          ),
                          if (hit.hasMention)
                            Icon(
                              Symbols.alternate_email,
                              size: 14,
                              color: chat.mentionText,
                            ),
                        ],
                      ),
                      const SizedBox(height: Sizes.p4),
                      Text(
                        hit.highlight ?? hit.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: chat.contentStyle.copyWith(
                          color: chat.metadataText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: chat.metadataText),
            const SizedBox(height: Sizes.p8),
            Text(
              title,
              style: chat.contentStyle.copyWith(
                fontWeight: FontWeight.w700,
                color: chat.incomingText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.p4),
            Text(
              message,
              style: chat.metadataStyle.copyWith(color: chat.metadataText),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Sizes.p8),
              TextButton(
                onPressed: onRetry,
                child: Text(context.l10n.chatInboxRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
