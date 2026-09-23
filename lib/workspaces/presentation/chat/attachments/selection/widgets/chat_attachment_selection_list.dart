import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

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
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.p4),
      padding: const EdgeInsets.fromLTRB(
        Sizes.p10,
        Sizes.p6,
        Sizes.p4,
        Sizes.p6,
      ),
      decoration: BoxDecoration(
        color: chat.composerSurface,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: chat.separator.withValues(alpha: .7)),
      ),
      child: Row(
        children: [
          Icon(Symbols.attach_file_rounded, color: chat.metadataText, size: 19),
          const SizedBox(width: Sizes.p8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  attachment.input.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: chat.contentStyle.copyWith(color: chat.incomingText),
                ),
                Text(
                  statusLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: chat.metadataStyle.copyWith(color: chat.metadataText),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: context.l10n.chatAttachmentRemove,
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            icon: Icon(Symbols.close_rounded, color: chat.metadataText),
          ),
        ],
      ),
    );
  }
}
