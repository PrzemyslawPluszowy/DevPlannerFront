import 'dart:async';

import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_move_action.dart';
import 'package:flutter/material.dart';

/// Źródło przeciągania pliku w eksploratorze.
///
/// Przeciąganie jest włączane tylko wtedy, gdy kompozycja pozwala przenosić
/// pliki: bez tego upuszczenie byłoby akcją, której moduł nie ma prawa wykonać.
final class StorageFileDragSource extends StatelessWidget {
  /// Tworzy źródło przeciągania dla pliku.
  const StorageFileDragSource({
    required this.fileId,
    required this.label,
    required this.enabled,
    required this.child,
    super.key,
  });

  /// Identyfikator przenoszonego pliku.
  final String fileId;

  /// Nazwa pokazywana w podglądzie przeciągania.
  final String label;

  /// Czy przeciąganie jest dozwolone w tej kompozycji.
  final bool enabled;

  /// Zawartość wiersza lub kafelka.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Draggable<String>(
      data: fileId,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: _DragPreview(label: label),
      childWhenDragging: Opacity(opacity: 0.4, child: child),
      child: child,
    );
  }
}

/// Cel upuszczenia pliku na folder.
///
/// Upuszczenie używa tego samego przypadku użycia co picker, więc gest i dialog
/// nie mogą się rozjechać w walidacji ani w obsłudze konfliktu wersji.
final class StorageFolderDropTarget extends StatefulWidget {
  /// Tworzy cel upuszczenia dla folderu.
  const StorageFolderDropTarget({
    required this.folder,
    required this.enabled,
    required this.child,
    super.key,
  });

  /// Folder przyjmujący upuszczenie.
  final StorageFolderResponse folder;

  /// Czy przenoszenie jest dozwolone w tej kompozycji.
  final bool enabled;

  /// Zawartość wiersza lub kafelka folderu.
  final Widget child;

  @override
  State<StorageFolderDropTarget> createState() =>
      _StorageFolderDropTargetState();
}

class _StorageFolderDropTargetState extends State<StorageFolderDropTarget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    final colors = context.colors;

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => details.data.isNotEmpty,
      onMove: (_) {
        if (_isHovered) return;
        setState(() => _isHovered = true);
      },
      onLeave: (_) {
        if (!_isHovered) return;
        setState(() => _isHovered = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => _isHovered = false);
        unawaited(
          runStorageMoveToFolder(
            context,
            fileIds: [details.data],
            target: widget.folder,
          ),
        );
      },
      builder: (context, candidates, rejected) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            context.filesTheme.common.controlRadius,
          ),
          border: Border.all(
            color: _isHovered ? colors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

/// Podgląd przeciąganego pliku pod kursorem.
class _DragPreview extends StatelessWidget {
  const _DragPreview({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    return Material(
      color: colors.surfaceContainerHigh,
      elevation: 2,
      borderRadius: BorderRadius.circular(common.controlRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: common.controlGap,
          vertical: common.tightGap,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AppIcons.file, size: 16),
            SizedBox(width: common.controlGap),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: common.controlText.copyWith(color: colors.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
