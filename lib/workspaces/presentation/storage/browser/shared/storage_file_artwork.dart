import 'dart:typed_data';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_file_icon/material_file_icon.dart';

/// Kolorowa ikona typu pliku lub jego miniatura pobrana przez ACL Storage.
final class StorageFileArtwork extends StatefulWidget {
  const StorageFileArtwork({
    required this.file,
    required this.size,
    this.onTap,
    this.actionLabel,
    super.key,
  });

  final StorageFileResponse file;
  final double size;
  final VoidCallback? onTap;
  final String? actionLabel;

  @override
  State<StorageFileArtwork> createState() => _StorageFileArtworkState();
}

final class _StorageFileArtworkState extends State<StorageFileArtwork> {
  Future<Uint8List?>? _imageFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadImageIfNeeded();
  }

  @override
  void didUpdateWidget(covariant StorageFileArtwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.id != widget.file.id ||
        oldWidget.file.version != widget.file.version) {
      _imageFuture = null;
      _loadImageIfNeeded();
    }
  }

  void _loadImageIfNeeded() {
    if (_imageFuture != null || !_isPreviewableImage(widget.file)) return;
    _imageFuture = context
        .read<StorageRepository>()
        .readPreviewImageBytes(fileId: widget.file.id)
        .then(
          (result) => result.fold<Uint8List?>((_) => null, (bytes) => bytes),
        );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.file.originalFileName;
    final glyphSize = widget.size * 0.6;
    final fileGlyph = SizedBox.square(
      dimension: widget.size,
      child: Center(
        child: MFIcon(
          name,
          size: glyphSize,
          placeholder: Icon(
            Icons.insert_drive_file_outlined,
            size: glyphSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
    final icon = ClipRRect(
      borderRadius: BorderRadius.circular(widget.size * 0.16),
      child: _imageFuture == null
          ? fileGlyph
          : FutureBuilder<Uint8List?>(
              future: _imageFuture,
              builder: (context, snapshot) {
                final bytes = snapshot.data;
                if (bytes == null || bytes.isEmpty) return fileGlyph;
                return Image.memory(
                  bytes,
                  width: widget.size,
                  height: widget.size,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => fileGlyph,
                );
              },
            ),
    );
    if (widget.onTap == null) return icon;
    return Tooltip(
      message:
          widget.actionLabel ??
          (widget.file.canEditOnline
              ? context.l10n.storageOpenOfficeAction
              : context.l10n.storagePreviewTitle),
      child: InkResponse(
        onTap: widget.onTap,
        radius: widget.size,
        child: Padding(padding: const EdgeInsets.all(4), child: icon),
      ),
    );
  }

  bool _isPreviewableImage(StorageFileResponse file) {
    if (!file.canPreview || file.fileSizeBytes > 20 * 1024 * 1024) return false;
    final mime = file.mimeType.split(';').first.trim().toLowerCase();
    final extension = file.extension.toLowerCase().replaceFirst('.', '');
    return mime.startsWith('image/') ||
        const {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'}.contains(extension);
  }
}
