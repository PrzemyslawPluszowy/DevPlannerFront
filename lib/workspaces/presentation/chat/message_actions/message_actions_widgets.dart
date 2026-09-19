import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/message_actions_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Menu akcji wiadomości delegujące każdą intencję do lokalnego Cubita.
class ChatMessageActionMenu extends StatelessWidget {
  /// Tworzy menu dla potwierdzonej, nieusuniętej wiadomości.
  const ChatMessageActionMenu({required this.message, super.key});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) => PopupMenuButton<_ChatMessageMenuAction>(
    tooltip: context.l10n.chatMessageActionsOpen,
    icon: const Icon(Symbols.more_horiz_rounded, size: 18),
    onSelected: (action) => switch (action) {
      _ChatMessageMenuAction.edit => _ChatMessageEditDialog.show(
        context,
        message,
      ),
      _ChatMessageMenuAction.delete =>
        context.read<ChatMessageActionsCubit>().delete(message),
      _ChatMessageMenuAction.revisions => _ChatMessageRevisionsDialog.show(
        context,
        message.id,
      ),
    },
    itemBuilder: (context) => [
      if (message.deltaJson == null)
        PopupMenuItem(
          value: _ChatMessageMenuAction.edit,
          child: Text(context.l10n.chatMessageEdit),
        ),
      PopupMenuItem(
        value: _ChatMessageMenuAction.revisions,
        child: Text(context.l10n.chatMessageRevisions),
      ),
      PopupMenuItem(
        value: _ChatMessageMenuAction.delete,
        child: Text(context.l10n.chatMessageDelete),
      ),
    ],
  );
}

enum _ChatMessageMenuAction { edit, revisions, delete }

/// Rootowy dialog zwykłej edycji, zamykany po potwierdzeniu backendu.
abstract final class _ChatMessageEditDialog {
  static Future<void> show(BuildContext context, ChatMessage message) async {
    await DevPlannerModalHost.showDialog<void>(
      context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ChatMessageActionsCubit>(),
        child: _ChatMessageEditDialogBody(message: message),
      ),
    );
  }
}

class _ChatMessageEditDialogBody extends StatefulWidget {
  const _ChatMessageEditDialogBody({required this.message});

  final ChatMessage message;

  @override
  State<_ChatMessageEditDialogBody> createState() =>
      _ChatMessageEditDialogBodyState();
}

class _ChatMessageEditDialogBodyState
    extends State<_ChatMessageEditDialogBody> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.message.text,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<ChatMessageActionsCubit, ChatMessageActionsState>(
        listenWhen: (_, state) => switch (state) {
          ChatMessageActionsUpdated(:final message) =>
            message.id == widget.message.id,
          ChatMessageActionsAccessRevoked() => true,
          _ => false,
        },
        listener: (context, _) => Navigator.of(context).maybePop(),
        builder: (context, state) {
          final busy =
              state is ChatMessageActionsInProgress &&
              state.messageId == widget.message.id;
          final error = switch (state) {
            ChatMessageActionsConflict(:final message, :final messageId)
                when messageId == widget.message.id =>
              message,
            ChatMessageActionsFailure(:final message, :final messageId)
                when messageId == widget.message.id =>
              message,
            _ => null,
          };
          return AlertDialog(
            title: Text(context.l10n.chatMessageEditTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLength: 4000,
                  minLines: 2,
                  maxLines: 8,
                  enabled: !busy,
                  decoration: InputDecoration(
                    labelText: context.l10n.chatMessageEditLabel,
                  ),
                ),
                if (error case final value?)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(value),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: busy ? null : () => Navigator.of(context).maybePop(),
                child: Text(context.l10n.chatMessageCancel),
              ),
              FilledButton(
                onPressed: busy
                    ? null
                    : () => context.read<ChatMessageActionsCubit>().edit(
                        message: widget.message,
                        text: _controller.text,
                      ),
                child: Text(context.l10n.chatMessageSave),
              ),
            ],
          );
        },
      );
}

/// Rootowy, tylko-do-odczytu dialog rewizji wiadomości.
abstract final class _ChatMessageRevisionsDialog {
  static Future<void> show(BuildContext context, String messageId) async {
    final cubit = context.read<ChatMessageActionsCubit>();
    unawaited(cubit.loadRevisions(messageId));
    await DevPlannerModalHost.showDialog<void>(
      context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: _ChatMessageRevisionsDialogBody(messageId: messageId),
      ),
    );
  }
}

class _ChatMessageRevisionsDialogBody extends StatelessWidget {
  const _ChatMessageRevisionsDialogBody({required this.messageId});

  final String messageId;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.chatMessageRevisionsTitle),
    content: SizedBox(
      width: 480,
      child: BlocBuilder<ChatMessageActionsCubit, ChatMessageActionsState>(
        builder: (context, state) => switch (state) {
          ChatMessageActionsInProgress(:final messageId)
              when messageId == this.messageId =>
            const Center(child: CircularProgressIndicator()),
          ChatMessageActionsRevisions(:final messageId, :final revisions)
              when messageId == this.messageId =>
            revisions.isEmpty
                ? Text(context.l10n.chatMessageRevisionsEmpty)
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: revisions.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (_, index) => ListTile(
                      title: Text(revisions[index].text),
                      subtitle: Text(
                        context.l10n.chatMessageRevisionVersion(
                          revisions[index].version,
                          revisions[index].newVersion,
                        ),
                      ),
                    ),
                  ),
          ChatMessageActionsFailure(:final message) => Text(message),
          ChatMessageActionsAccessRevoked(:final message) => Text(message),
          _ => const SizedBox.shrink(),
        },
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).maybePop(),
        child: Text(context.l10n.chatMessageClose),
      ),
    ],
  );
}
