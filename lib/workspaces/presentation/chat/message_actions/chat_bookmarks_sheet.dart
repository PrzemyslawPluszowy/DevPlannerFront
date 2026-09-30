import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_action_list_components.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_timestamp_formatter.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista prywatnych zakładek użytkownika.
abstract final class ChatBookmarksSheet {
  /// Otwiera listę zakładek.
  static Future<void> show(
    BuildContext context, {
    required ChatMessageActionsRepository? repository,
    void Function(String conversationId, String messageId)? onOpenMessage,
  }) async {
    if (repository == null) return;
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) => _ChatBookmarkList(
        repository: repository,
        onOpenMessage: onOpenMessage,
        onClose: () => Navigator.of(sheetContext).pop(),
      ),
    );
  }
}

class _ChatBookmarkList extends StatefulWidget {
  const _ChatBookmarkList({
    required this.repository,
    required this.onClose,
    this.onOpenMessage,
  });

  final ChatMessageActionsRepository repository;
  final VoidCallback onClose;
  final void Function(String conversationId, String messageId)? onOpenMessage;

  @override
  State<_ChatBookmarkList> createState() => _ChatBookmarkListState();
}

class _ChatBookmarkListState extends State<_ChatBookmarkList> {
  List<ChatBookmark>? _bookmarks;
  String? _failureCode;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _isBusy = true;
      _failureCode = null;
    });
    final result = await widget.repository.listBookmarks();
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
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
    setState(() => _isBusy = true);
    final result = await widget.repository.removeBookmark(bookmark.messageId);
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _failureCode = context.l10n.chatActionFailureMessage;
        _isBusy = false;
      }),
      (_) => unawaited(_load()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chat = context.chatTheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Symbols.bookmarks, size: 20),
                const SizedBox(width: Sizes.p8),
                Expanded(
                  child: Text(
                    context.l10n.chatBookmarksTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.frameworkClose,
                  onPressed: widget.onClose,
                  icon: const Icon(Symbols.close, size: 18),
                ),
              ],
            ),
            const Divider(height: Sizes.p16),
            if (_failureCode != null)
              Text(
                _failureCode!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: chat.error,
                ),
              ),
            Expanded(
              child: switch ((_bookmarks, _isBusy)) {
                (null, _) when _failureCode != null => ChatActionLoadFailure(
                  onRetry: () => unawaited(_load()),
                ),
                (null, _) => const Center(child: CircularProgressIndicator()),
                (final items?, _) when items.isEmpty => Center(
                  child: Text(
                    context.l10n.chatBookmarksEmpty,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                (final items?, _) => ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final bookmark = items[index];
                    return ChatActionListRow(
                      icon: Symbols.bookmark_rounded,
                      title: bookmark.note?.trim().isNotEmpty == true
                          ? bookmark.note!
                          : context.l10n.chatSavedMessageFallback,
                      subtitle: ChatTimestampFormatter.dateTimeLabel(
                        bookmark.createdAtUtc,
                        Localizations.localeOf(context),
                      ),
                      onTap: widget.onOpenMessage == null
                          ? null
                          : () {
                              widget.onClose();
                              widget.onOpenMessage!(
                                bookmark.conversationId,
                                bookmark.messageId,
                              );
                            },
                      trailing: IconButton(
                        tooltip: context.l10n.chatMessageRemoveBookmark,
                        onPressed: _isBusy
                            ? null
                            : () => unawaited(_remove(bookmark)),
                        icon: const Icon(Symbols.bookmark_remove, size: 18),
                      ),
                    );
                  },
                ),
              },
            ),
          ],
        ),
      ),
    );
  }
}
