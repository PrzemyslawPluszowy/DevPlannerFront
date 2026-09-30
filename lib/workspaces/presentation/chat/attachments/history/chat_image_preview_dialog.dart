import 'dart:typed_data';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_toast.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_attachment_access_port.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_surface_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Podgląd obrazu z autoryzowanych bajtów Storage; pobranie jest jawne.
final class ChatImagePreviewDialog extends StatefulWidget {
  const ChatImagePreviewDialog({
    required this.attachment,
    required this.bytes,
    required this.fullResolutionBytes,
    required this.port,
    super.key,
  });

  final ChatMessageAttachment attachment;
  final Future<Uint8List?> bytes;
  final Future<Uint8List?> fullResolutionBytes;
  final ChatAttachmentAccessPort port;

  @override
  State<ChatImagePreviewDialog> createState() => _ChatImagePreviewDialogState();
}

final class _ChatImagePreviewDialogState extends State<ChatImagePreviewDialog> {
  bool _downloading = false;

  Future<void> _download() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      final failure = await widget.port.open(widget.attachment.storageFileId);
      if (!mounted || failure == null) return;
      AppToast.show(
        context,
        message: failure.code == 'chat.attachment.open_failed'
            ? context.l10n.chatAttachmentOpenFailed
            : failure.message,
        tone: AppToastTone.error,
      );
    } on Object {
      if (!mounted) return;
      AppToast.show(
        context,
        message: context.l10n.chatAttachmentOpenFailed,
        tone: AppToastTone.error,
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) => ChatSurfaceDialog(
    title: widget.attachment.label,
    maxWidth: 720,
    content: SizedBox(
      height: 440,
      child: FutureBuilder<Uint8List?>(
        future: widget.fullResolutionBytes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final fullBytes = snapshot.data;
          if (fullBytes != null && fullBytes.isNotEmpty) {
            return InteractiveViewer(
              child: Image.memory(fullBytes, fit: BoxFit.contain),
            );
          }
          return FutureBuilder<Uint8List?>(
            future: widget.bytes,
            builder: (context, fallbackSnapshot) {
              if (fallbackSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final bytes = fallbackSnapshot.data;
              if (bytes == null || bytes.isEmpty) {
                return Center(
                  child: Text(
                    context.l10n.chatAttachmentUnavailable,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return InteractiveViewer(
                child: Image.memory(bytes, fit: BoxFit.contain),
              );
            },
          );
        },
      ),
    ),
    actions: [
      if (_downloading)
        const Padding(
          padding: EdgeInsets.all(Sizes.p8),
          child: SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        )
      else
        TextButton.icon(
          onPressed: _download,
          icon: const Icon(Symbols.download),
          label: Text(context.l10n.chatAttachmentOpen),
        ),
    ],
  );
}
