import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_action_list_components.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/chat_action_side_sheet.dart';
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
      builder: (sheetContext) => ChatActionSideSheet(
        child: _ChatPinnedList(
          repository: repository,
          conversationId: conversationId,
          onOpenMessage: onOpenMessage,
          onClose: () => Navigator.of(sheetContext).pop(),
        ),
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
                (null, _) when _failureCode != null => ChatActionLoadFailure(
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
                    return ChatActionListRow(
                      icon: Symbols.push_pin,
                      title: pin.messageText?.trim().isNotEmpty == true
                          ? pin.messageText!
                          : context.l10n.chatPinnedMessageFallback,
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
