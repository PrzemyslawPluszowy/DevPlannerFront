import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_timestamp_formatter.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista przypiętych wiadomości rozmowy.
///
/// Widok czyta port przypięć i nic nie zapisuje; odpina wiadomość tylko po
/// potwierdzeniu backendu, więc lista nie rozjeżdża się ze stanem serwera.
abstract final class ChatPinnedMessagesSheet {
  /// Otwiera listę przypiętych wiadomości.
  static Future<void> show(
    BuildContext context, {
    required ChatMessageActionsRepository? repository,
    required String conversationId,
    ValueChanged<String>? onOpenMessage,
  }) async {
    if (repository == null) return;
    await DevPlannerModalHost.showSideSheet<void>(
      context,
      builder: (sheetContext) => _ChatPinnedList(
        repository: repository,
        conversationId: conversationId,
        onOpenMessage: onOpenMessage,
        onClose: () => Navigator.of(sheetContext).pop(),
      ),
    );
  }
}

class _ChatPinnedList extends StatefulWidget {
  const _ChatPinnedList({
    required this.repository,
    required this.conversationId,
    this.onOpenMessage,
    required this.onClose,
  });

  final ChatMessageActionsRepository repository;
  final String conversationId;
  final ValueChanged<String>? onOpenMessage;
  final VoidCallback onClose;

  @override
  State<_ChatPinnedList> createState() => _ChatPinnedListState();
}

class _ChatPinnedListState extends State<_ChatPinnedList> {
  List<ChatPinnedMessage>? _pins;
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
    final result = await widget.repository.listPins(widget.conversationId);
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _failureCode = context.l10n.chatActionFailureMessage;
        _isBusy = false;
      }),
      (pins) => setState(() {
        _pins = pins;
        _failureCode = null;
        _isBusy = false;
      }),
    );
  }

  Future<void> _unpin(ChatPinnedMessage pin) async {
    setState(() => _isBusy = true);
    final result = await widget.repository.unpinMessage(
      conversationId: widget.conversationId,
      messageId: pin.messageId,
    );
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
                const Icon(Symbols.push_pin, size: 20),
                const SizedBox(width: Sizes.p8),
                Expanded(
                  child: Text(
                    context.l10n.chatPinnedTitle,
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
              child: switch ((_pins, _isBusy)) {
                (null, _) when _failureCode != null => _ChatActionLoadFailure(
                  onRetry: () => unawaited(_load()),
                ),
                (null, _) => const Center(child: CircularProgressIndicator()),
                (final pins?, _) when pins.isEmpty => Center(
                  child: Text(
                    context.l10n.chatPinnedEmpty,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                (final pins?, _) => ListView.builder(
                  itemCount: pins.length,
                  itemBuilder: (context, index) {
                    final pin = pins[index];
                    return _ChatActionListRow(
                      icon: Symbols.push_pin,
                      title: context.l10n.chatPinnedMessageFallback,
                      subtitle: context.l10n.chatPinnedAt(
                        ChatTimestampFormatter.dateTimeLabel(
                          pin.pinnedAtUtc,
                          Localizations.localeOf(context),
                        ),
                      ),
                      onTap: widget.onOpenMessage == null
                          ? null
                          : () {
                              widget.onClose();
                              widget.onOpenMessage!(pin.messageId);
                            },
                      trailing: IconButton(
                        tooltip: context.l10n.chatMessageUnpin,
                        onPressed: _isBusy
                            ? null
                            : () => unawaited(_unpin(pin)),
                        icon: const Icon(Symbols.keep_off, size: 18),
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
                (null, _) when _failureCode != null => _ChatActionLoadFailure(
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
                    return _ChatActionListRow(
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

class _ChatActionLoadFailure extends StatelessWidget {
  const _ChatActionLoadFailure({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.error_outline, size: 24, color: chat.error),
          const SizedBox(height: Sizes.p8),
          Text(
            context.l10n.chatActionFailureMessage,
            textAlign: TextAlign.center,
            style: chat.contentStyle.copyWith(color: chat.metadataText),
          ),
          const SizedBox(height: Sizes.p4),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.chatInboxRetry),
          ),
        ],
      ),
    );
  }
}

class _ChatActionListRow extends StatelessWidget {
  const _ChatActionListRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p6),
      child: Material(
        color: chat.listSurface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(
              left: Sizes.p12,
              top: Sizes.p6,
              bottom: Sizes.p6,
              right: Sizes.p4,
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: chat.linkText),
                const SizedBox(width: Sizes.p10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chat.contentStyle.copyWith(
                          color: chat.incomingText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: chat.metadataStyle.copyWith(
                          color: chat.metadataText,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
