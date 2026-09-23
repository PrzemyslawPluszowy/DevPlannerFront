import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/message_actions_export.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Menu akcji wiadomości delegujące każdą intencję do lokalnego Cubita.
class ChatMessageActionMenu extends StatelessWidget {
  /// Tworzy menu dla potwierdzonej, nieusuniętej wiadomości.
  const ChatMessageActionMenu({
    required this.message,
    this.onReply,
    this.onThread,
    this.onDiscussion,
    super.key,
  });

  final ChatMessage message;
  final ValueChanged<ChatMessage>? onReply;
  final ValueChanged<ChatMessage>? onThread;
  final ValueChanged<ChatMessage>? onDiscussion;

  Future<void> showAt(BuildContext context, Offset position) =>
      AppContextMenu.show(
        context,
        globalPosition: position,
        actions: _actions(context),
      );

  List<AppContextMenuAction> _actions(BuildContext context) => [
    if (onReply != null)
      AppContextMenuAction(
        label: context.l10n.chatComposerReplyAction,
        icon: Symbols.reply_rounded,
        onTap: (_) => onReply?.call(message),
      ),
    if (onThread != null)
      AppContextMenuAction(
        label: context.l10n.chatThreadOpen,
        icon: Symbols.forum_rounded,
        onTap: (_) => onThread?.call(message),
      ),
    if (onDiscussion != null)
      AppContextMenuAction(
        label: context.l10n.chatDiscussionOpen,
        icon: Symbols.topic_rounded,
        onTap: (_) => onDiscussion?.call(message),
      ),
    if (message.deltaJson == null)
      AppContextMenuAction(
        label: context.l10n.chatMessageEdit,
        icon: Symbols.edit_rounded,
        separatorBefore:
            onReply != null || onThread != null || onDiscussion != null,
        onTap: (_) => _ChatMessageEditDialog.show(context, message),
      ),
    AppContextMenuAction(
      label: context.l10n.chatMessageRevisions,
      icon: Symbols.history_rounded,
      onTap: (_) => _ChatMessageRevisionsDialog.show(context, message.id),
    ),
    AppContextMenuAction(
      label: context.l10n.chatMessageDelete,
      icon: Symbols.delete_rounded,
      isDestructive: true,
      onTap: (_) => context.read<ChatMessageActionsCubit>().delete(message),
    ),
  ];

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchorContext) => IconButton(
      tooltip: context.l10n.chatMessageActionsOpen,
      icon: const Icon(Symbols.more_horiz_rounded, size: 18),
      onPressed: () => unawaited(
        showAt(
          anchorContext,
          AppContextMenu.positionFor(anchorContext),
        ),
      ),
    ),
  );
}

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
            ChatMessageActionsConflict(:final messageId)
                when messageId == widget.message.id =>
              context.l10n.chatMessageEditConflictMessage,
            ChatMessageActionsFailure(:final messageId)
                when messageId == widget.message.id =>
              context.l10n.chatActionFailureMessage,
            _ => null,
          };
          return ChatSurfaceDialog(
            title: context.l10n.chatMessageEditTitle,
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
                  style: context.chatTheme.contentStyle.copyWith(
                    color: context.chatTheme.incomingText,
                  ),
                  decoration: InputDecoration(
                    labelText: context.l10n.chatMessageEditLabel,
                    labelStyle: context.chatTheme.metadataStyle.copyWith(
                      color: context.chatTheme.metadataText,
                    ),
                    filled: true,
                    fillColor: context.chatTheme.composerSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: context.chatTheme.separator,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: context.chatTheme.focusRing,
                      ),
                    ),
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
  Widget build(BuildContext context) => ChatSurfaceDialog(
    title: context.l10n.chatMessageRevisionsTitle,
    content: BlocBuilder<ChatMessageActionsCubit, ChatMessageActionsState>(
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
                  separatorBuilder: (_, _) => const SizedBox(height: Sizes.p8),
                  itemBuilder: (_, index) {
                    final chat = context.chatTheme;
                    final revision = revisions[index];
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: chat.panelSurface,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(
                          color: chat.separator.withValues(alpha: .7),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.p10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              revision.text,
                              style: chat.contentStyle.copyWith(
                                color: chat.incomingText,
                              ),
                            ),
                            const SizedBox(height: Sizes.p4),
                            Text(
                              context.l10n.chatMessageRevisionVersion(
                                revision.version,
                                revision.newVersion,
                              ),
                              style: chat.metadataStyle.copyWith(
                                color: chat.metadataText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ChatMessageActionsFailure() => Text(
          context.l10n.chatActionFailureMessage,
        ),
        ChatMessageActionsAccessRevoked() => Text(
          context.l10n.chatConversationAccessRevokedMessage,
        ),
        _ => const SizedBox.shrink(),
      },
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).maybePop(),
        child: Text(context.l10n.chatMessageClose),
      ),
    ],
  );
}
