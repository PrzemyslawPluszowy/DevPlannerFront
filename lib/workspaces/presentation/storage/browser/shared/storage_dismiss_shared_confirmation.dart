import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Potwierdzenie ukrycia udostępnionego pliku, zgodne z powierzchniami Tasks i Files.
final class StorageDismissSharedConfirmation extends StatelessWidget {
  const StorageDismissSharedConfirmation({super.key});

  static Future<bool?> show(BuildContext context) =>
      DevPlannerModalHost.showDialog<bool>(
        context,
        builder: (_) => const StorageDismissSharedConfirmation(),
      );

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tasks.controlRadius),
    );
    return AlertDialog(
      backgroundColor: tasks.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrollable: true,
      insetPadding: EdgeInsets.all(tasks.sectionGap),
      constraints: const BoxConstraints(maxWidth: 480),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.panelRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      titlePadding: EdgeInsets.all(tasks.sectionGap),
      contentPadding: EdgeInsets.fromLTRB(
        tasks.sectionGap,
        0,
        tasks.sectionGap,
        tasks.sectionGap,
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        tasks.sectionGap,
        0,
        tasks.sectionGap,
        tasks.sectionGap,
      ),
      titleTextStyle: tasks.projectTitleText.copyWith(color: colors.onSurface),
      contentTextStyle: tasks.dataText.copyWith(color: colors.onSurfaceVariant),
      title: Text(context.l10n.storageDismissFromSharedTitle),
      content: Text(context.l10n.storageDismissFromSharedConfirm),
      actions: [
        TextButton(
          key: const ValueKey('storage_dismiss_cancel'),
          autofocus: true,
          style: TextButton.styleFrom(
            foregroundColor: colors.onSurface,
            textStyle: tasks.controlText,
            shape: buttonShape,
            minimumSize: Size(0, tasks.commandRowHeight),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('storage_dismiss_confirm'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.onSurface,
            foregroundColor: colors.surface,
            textStyle: tasks.controlText,
            shape: buttonShape,
            minimumSize: Size(0, tasks.commandRowHeight),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.l10n.storageDismissFromSharedAction),
        ),
      ],
    );
  }
}
