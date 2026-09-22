import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Zakładki wiadomości w kolumnie listy panelu.
///
/// Widok czyta port zakładek i oddaje wybór do panelu, który otwiera rozmowę w
/// miejscu wiadomości. Przypięcia i zakładki nie są kopiowane lokalnie: stan
/// pochodzi z backendu, a usunięcie zakładki następuje po jego potwierdzeniu.
class ChatSavedMessagesPane extends StatefulWidget {
  /// Tworzy pane zakładek.
  const ChatSavedMessagesPane({
    required this.repository,
    this.onOpenMessage,
    super.key,
  });

  /// Port akcji wiadomości; brak portu oznacza kompozycję bez zakładek.
  final ChatMessageActionsRepository? repository;

  /// Otwiera rozmowę w miejscu zapisanej wiadomości.
  final void Function(String conversationId, String messageId)? onOpenMessage;

  @override
  State<ChatSavedMessagesPane> createState() => _ChatSavedMessagesPaneState();
}

class _ChatSavedMessagesPaneState extends State<ChatSavedMessagesPane> {
  List<ChatBookmark>? _bookmarks;
  String? _failureCode;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final repository = widget.repository;
    if (repository == null) return;
    setState(() => _isBusy = true);
    final result = await repository.listBookmarks();
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _failureCode = error.apiCode ?? error.message;
        _isBusy = false;
      }),
      (bookmarks) => setState(() {
        _bookmarks = bookmarks;
        _failureCode = null;
        _isBusy = false;
      }),
    );
  }

  Future<void> _remove(ChatBookmark bookmark) async {
    final repository = widget.repository;
    if (repository == null) return;
    setState(() => _isBusy = true);
    final result = await repository.removeBookmark(bookmark.messageId);
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _failureCode = error.apiCode ?? error.message;
        _isBusy = false;
      }),
      (_) => unawaited(_load()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.repository == null) {
      return _ChatSavedMessage(
        icon: Symbols.bookmark_rounded,
        message: context.l10n.chatSavedUnavailable,
      );
    }
    final failure = _failureCode;
    if (failure != null && _bookmarks == null) {
      return _ChatSavedMessage(
        icon: Symbols.error_outline,
        message: context.l10n.chatInboxLoadMoreFailed,
      );
    }
    final bookmarks = _bookmarks;
    if (bookmarks == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (bookmarks.isEmpty) {
      return _ChatSavedMessage(
        icon: Symbols.bookmark_rounded,
        message: context.l10n.chatBookmarksEmpty,
      );
    }
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        final note = bookmark.note?.trim();
        return ListTile(
          dense: true,
          leading: const Icon(Symbols.bookmark_rounded, size: 20),
          title: Text(
            note != null && note.isNotEmpty
                ? note
                : context.l10n.chatSavedMessageFallback,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            bookmark.createdAtUtc.toLocal().toString().split('.').first,
            style: theme.textTheme.labelSmall,
          ),
          onTap: widget.onOpenMessage == null
              ? null
              : () => widget.onOpenMessage!(
                  bookmark.conversationId,
                  bookmark.messageId,
                ),
          trailing: IconButton(
            tooltip: context.l10n.chatMessageRemoveBookmark,
            onPressed: _isBusy ? null : () => unawaited(_remove(bookmark)),
            icon: const Icon(Symbols.bookmark_remove_rounded, size: 18),
          ),
        );
      },
    );
  }
}

class _ChatSavedMessage extends StatelessWidget {
  const _ChatSavedMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

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
        ],
      ),
    ),
  );
}
