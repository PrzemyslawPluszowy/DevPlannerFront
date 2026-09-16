import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_reply_target.dart';
import 'package:ready_next/workspaces/domain/notifications/notification_reply_repository.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/reply/cubit/notification_reply_cubit.dart';

/// Rootowy modal odpowiedzi Chat, uruchamiany tylko dla replyable notification.
abstract final class AppNotificationReplyModal {
  /// Otwiera krótką odpowiedź bez zmiany URI bieżącej strony lub panelu.
  static Future<void> show(
    BuildContext context, {
    required WorkspaceNotificationResponse notification,
  }) async {
    final repository = context.read<NotificationReplyRepository?>();
    if (repository == null ||
        NotificationReplyTarget.tryFromNotification(
              entityType: notification.entityType,
              metadataJson: notification.metadataJson,
            ) ==
            null) {
      return;
    }
    final inbox = context.read<NotificationsCubit?>();
    await AppModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider(
        create: (_) => NotificationReplyCubit(
          repository: repository,
          notificationId: notification.id,
        ),
        child: _NotificationReplyDialog(
          onSucceeded: () async => inbox?.refresh(),
        ),
      ),
    );
  }
}

/// Widoczna akcja tylko wtedy, gdy aktualny kontrakt backendu pozwala na reply.
class NotificationReplyAction extends StatelessWidget {
  const NotificationReplyAction({required this.notification, super.key});

  final WorkspaceNotificationResponse notification;

  @override
  Widget build(BuildContext context) {
    if (NotificationReplyTarget.tryFromNotification(
              entityType: notification.entityType,
              metadataJson: notification.metadataJson,
            ) ==
            null ||
        context.read<NotificationReplyRepository?>() == null) {
      return const SizedBox.shrink();
    }
    return IconButton(
      tooltip: context.l10n.globalNotificationsReply,
      onPressed: () => unawaited(
        AppNotificationReplyModal.show(context, notification: notification),
      ),
      icon: const Icon(Symbols.reply_rounded, size: 19),
    );
  }
}

enum _NotificationReplyMode { plain, rich }

class _NotificationReplyDialog extends StatefulWidget {
  const _NotificationReplyDialog({required this.onSucceeded});

  final Future<void> Function() onSucceeded;

  @override
  State<_NotificationReplyDialog> createState() =>
      _NotificationReplyDialogState();
}

class _NotificationReplyDialogState extends State<_NotificationReplyDialog> {
  final TextEditingController _plainController = TextEditingController();
  final FocusNode _plainFocusNode = FocusNode();
  final FocusNode _richFocusNode = FocusNode();
  final ScrollController _richScrollController = ScrollController();
  late final quill.QuillController _richController =
      quill.QuillController.basic();
  _NotificationReplyMode _mode = _NotificationReplyMode.plain;

  @override
  void initState() {
    super.initState();
    _richController.addListener(_onRichTextChanged);
  }

  @override
  void dispose() {
    _plainController.dispose();
    _plainFocusNode.dispose();
    _richFocusNode.dispose();
    _richScrollController.dispose();
    _richController
      ..removeListener(_onRichTextChanged)
      ..dispose();
    super.dispose();
  }

  void _selectMode(_NotificationReplyMode mode) {
    if (_mode == mode) return;
    final cubit = context.read<NotificationReplyCubit>();
    if (mode == _NotificationReplyMode.rich) {
      _replaceRichDocument(_plainController.text);
      _updateRich(cubit);
    } else {
      _plainController.text = _richController.document
          .toPlainText()
          .trimRight();
      cubit.updatePlainText(_plainController.text);
    }
    setState(() => _mode = mode);
  }

  void _replaceRichDocument(String text) {
    final delta = <Object>[
      {'insert': text.isEmpty ? '\n' : '$text\n'},
    ];
    final document = quill.Document.fromJson(delta);
    _richController.replaceText(
      0,
      _richController.document.length - 1,
      document.toDelta(),
      TextSelection.collapsed(
        offset: document.toPlainText().trimRight().length,
      ),
    );
  }

  void _updateRich(NotificationReplyCubit cubit) {
    cubit.updateRichText(
      text: _richController.document.toPlainText().trimRight(),
      deltaJson: jsonEncode(_richController.document.toDelta().toJson()),
    );
  }

  void _onRichTextChanged() {
    if (!mounted || _mode != _NotificationReplyMode.rich) return;
    _updateRich(context.read<NotificationReplyCubit>());
  }

  void _clearPrivateControllers() {
    _plainController.clear();
    _replaceRichDocument('');
  }

  void _onStateChanged(BuildContext context, NotificationReplyState state) {
    if (state is NotificationReplySucceeded) {
      unawaited(widget.onSucceeded());
      Navigator.of(context).maybePop();
      return;
    }
    if (state is NotificationReplyAccessRevoked) _clearPrivateControllers();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<NotificationReplyCubit, NotificationReplyState>(
    listener: _onStateChanged,
    child: AlertDialog(
      title: Row(
        children: [
          const Icon(Symbols.reply_rounded),
          Gaps.w8,
          Expanded(child: Text(context.l10n.globalNotificationsReplyTitle)),
        ],
      ),
      content: SizedBox(
        width: 560,
        child: BlocBuilder<NotificationReplyCubit, NotificationReplyState>(
          builder: (context, state) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state is NotificationReplyAccessRevoked)
                _ReplyError(
                  message: context.l10n.globalNotificationsReplyAccessRevoked,
                )
              else if (state case NotificationReplyEditing(:final error?))
                _ReplyError(
                  message:
                      '${context.l10n.globalNotificationsReplyFailed}: ${error.message}',
                ),
              SegmentedButton<_NotificationReplyMode>(
                segments: [
                  ButtonSegment(
                    value: _NotificationReplyMode.plain,
                    icon: const Icon(Symbols.notes_rounded, size: 18),
                    label: Text(
                      context.l10n.globalNotificationsReplyPlainMode,
                    ),
                  ),
                  ButtonSegment(
                    value: _NotificationReplyMode.rich,
                    icon: const Icon(Symbols.format_size_rounded, size: 18),
                    label: Text(
                      context.l10n.globalNotificationsReplyRichMode,
                    ),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: state is NotificationReplyEditing
                    ? (modes) => _selectMode(modes.single)
                    : null,
                showSelectedIcon: false,
              ),
              Gaps.h12,
              if (_mode == _NotificationReplyMode.plain)
                TextField(
                  controller: _plainController,
                  focusNode: _plainFocusNode,
                  autofocus: true,
                  enabled: state is NotificationReplyEditing,
                  minLines: 3,
                  maxLines: 6,
                  onChanged: context
                      .read<NotificationReplyCubit>()
                      .updatePlainText,
                  decoration: InputDecoration(
                    hintText: context.l10n.globalNotificationsReplyHint,
                    border: const OutlineInputBorder(),
                  ),
                )
              else
                SizedBox(
                  height: 180,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colors.outline),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IgnorePointer(
                      ignoring: state is! NotificationReplyEditing,
                      child: quill.QuillEditor(
                        controller: _richController,
                        focusNode: _richFocusNode,
                        scrollController: _richScrollController,
                        config: const quill.QuillEditorConfig(
                          padding: EdgeInsets.all(Sizes.p12),
                          expands: true,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: const [
        _NotificationReplyDialogActions(),
      ],
    ),
  );
}

class _NotificationReplyDialogActions extends StatelessWidget {
  const _NotificationReplyDialogActions();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<NotificationReplyCubit, NotificationReplyState>(
        builder: (context, state) {
          final isEditing = state is NotificationReplyEditing;
          final canSend = isEditing && state.canSend;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: state is NotificationReplySending
                    ? null
                    : () => Navigator.of(context).maybePop(),
                child: Text(context.l10n.frameworkClose),
              ),
              Gaps.w8,
              FilledButton.icon(
                onPressed: canSend
                    ? () => unawaited(
                        context.read<NotificationReplyCubit>().send(),
                      )
                    : null,
                icon: state is NotificationReplySending
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Symbols.send_rounded),
                label: Text(context.l10n.globalNotificationsReplySend),
              ),
            ],
          );
        },
      );
}

class _ReplyError extends StatelessWidget {
  const _ReplyError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p12),
      child: Text(
        message,
        style: context.text.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    ),
  );
}
