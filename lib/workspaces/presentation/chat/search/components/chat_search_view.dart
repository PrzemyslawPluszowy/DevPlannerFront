import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:flutter/material.dart';
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

  /// Rozmowy z bieżącej skrzynki; wynik bez rozmowy na liście nie ma celu skoku.
  final List<ChatInboxItem> conversations;

  /// Wybór wyniku: rozmowa oraz identyfikator wiadomości do pokazania.
  final void Function(ChatInboxItem conversation, String messageId)
  onResultSelected;

  @override
  State<ChatSearchView> createState() => _ChatSearchViewState();
}

class _ChatSearchViewState extends State<ChatSearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const minimumTermLength = 2;
    return Column(
      children: [
        TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: const Icon(Symbols.search, size: 18),
            hintText: context.l10n.chatSearchHint,
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
                  message: state.failureCode!,
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
                itemCount: hits.length + (state.page?.nextCursor != null ? 1 : 0),
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
                  return ListTile(
                    dense: true,
                    enabled: conversation != null,
                    title: Text(
                      conversation?.displayName ??
                          hit.conversationName ??
                          hit.conversationId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      hit.highlight ?? hit.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: conversation == null
                        ? null
                        : () => widget.onResultSelected(
                            conversation,
                            hit.messageId,
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

  ChatInboxItem? _conversationFor(String conversationId) => widget.conversations
      .where((item) => item.conversation.id == conversationId)
      .firstOrNull;
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
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: theme.colorScheme.onSurfaceVariant),
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
