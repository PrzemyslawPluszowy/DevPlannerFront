import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_timestamp_formatter.dart';
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
    setState(() {
      _isBusy = true;
      _failureCode = null;
    });
    final result = await repository.listBookmarks();
    if (!mounted) return;
    result.fold(
      (_) => setState(() {
        _failureCode = context.l10n.chatActionFailureMessage;
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
      (_) => setState(() {
        _failureCode = context.l10n.chatActionFailureMessage;
        _isBusy = false;
      }),
      (_) => unawaited(_load()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
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
        message: failure,
        onRetry: () => unawaited(_load()),
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
    return Column(
      children: [
        if (failure != null) _ChatSavedErrorBanner(message: failure),
        Expanded(
          child: ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              final note = bookmark.note?.trim();
              return Padding(
                padding: const EdgeInsets.only(bottom: Sizes.p6),
                child: Material(
                  color: chat.listSurface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: widget.onOpenMessage == null
                        ? null
                        : () => widget.onOpenMessage!(
                            bookmark.conversationId,
                            bookmark.messageId,
                          ),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Sizes.p12,
                        top: Sizes.p8,
                        bottom: Sizes.p8,
                        right: Sizes.p4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Symbols.bookmark_rounded,
                            size: 18,
                            color: chat.linkText,
                          ),
                          const SizedBox(width: Sizes.p8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note != null && note.isNotEmpty
                                      ? note
                                      : context.l10n.chatSavedMessageFallback,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: chat.contentStyle.copyWith(
                                    color: chat.incomingText,
                                  ),
                                ),
                                Text(
                                  ChatTimestampFormatter.relativeLabel(
                                    l10n: context.l10n,
                                    atUtc: bookmark.createdAtUtc,
                                    nowUtc: DateTime.now().toUtc(),
                                    locale: Localizations.localeOf(context),
                                  ),
                                  style: chat.metadataStyle.copyWith(
                                    color: chat.metadataText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: context.l10n.chatMessageRemoveBookmark,
                            onPressed: _isBusy
                                ? null
                                : () => unawaited(_remove(bookmark)),
                            color: chat.metadataText,
                            icon: const Icon(
                              Symbols.bookmark_remove_rounded,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ChatSavedMessage extends StatelessWidget {
  const _ChatSavedMessage({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 36,
              color: onRetry == null ? chat.metadataText : chat.error,
            ),
            Gaps.h12,
            Text(
              message,
              textAlign: TextAlign.center,
              style: chat.metadataStyle.copyWith(
                color: chat.metadataText,
              ),
            ),
            if (onRetry != null) ...[
              Gaps.h8,
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

class _ChatSavedErrorBanner extends StatelessWidget {
  const _ChatSavedErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p8),
      child: Row(
        children: [
          Icon(Symbols.error_outline, size: 16, color: chat.error),
          const SizedBox(width: Sizes.p6),
          Expanded(
            child: Text(
              message,
              style: chat.metadataStyle.copyWith(color: chat.error),
            ),
          ),
        ],
      ),
    );
  }
}
