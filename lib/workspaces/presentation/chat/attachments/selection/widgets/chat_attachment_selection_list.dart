import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';

/// Prezentuje wyłącznie lokalny lifecycle wyboru; nie inicjuje uploadu ani pickera.
final class ChatAttachmentSelectionList extends StatelessWidget {
  /// Tworzy listę bieżących załączników jednego composera.
  const ChatAttachmentSelectionList({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatAttachmentSelectionCubit, ChatAttachmentSelectionState>(
        builder: (context, state) {
          final ready = state as ChatAttachmentSelectionReady;
          if (ready.attachments.isEmpty) {
            return Text(context.l10n.chatAttachmentsEmpty);
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: ready.attachments.length,
            itemBuilder: (context, index) => _ChatAttachmentRow(
              attachment: ready.attachments[index],
              statusLabel: _statusLabel(
                context,
                ready.attachments[index].status,
              ),
              onRemove: () =>
                  context.read<ChatAttachmentSelectionCubit>().remove(
                    ready.attachments[index].localId,
                  ),
            ),
          );
        },
      );

  String _statusLabel(
    BuildContext context,
    ChatAttachmentStatus status,
  ) => switch (status) {
    ChatAttachmentStatus.processing =>
      context.l10n.chatAttachmentStatusProcessing,
    ChatAttachmentStatus.scanning => context.l10n.chatAttachmentStatusScanning,
    ChatAttachmentStatus.clean => context.l10n.chatAttachmentStatusClean,
    ChatAttachmentStatus.infected => context.l10n.chatAttachmentStatusInfected,
    ChatAttachmentStatus.failed => context.l10n.chatAttachmentStatusFailed,
  };
}

final class _ChatAttachmentRow extends StatelessWidget {
  const _ChatAttachmentRow({
    required this.attachment,
    required this.statusLabel,
    required this.onRemove,
  });

  final ChatAttachment attachment;
  final String statusLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(Symbols.attach_file_rounded),
    title: Text(attachment.input.name),
    subtitle: Text(statusLabel),
    trailing: IconButton(
      tooltip: context.l10n.chatAttachmentRemove,
      onPressed: onRemove,
      icon: const Icon(Symbols.close_rounded),
    ),
  );
}
