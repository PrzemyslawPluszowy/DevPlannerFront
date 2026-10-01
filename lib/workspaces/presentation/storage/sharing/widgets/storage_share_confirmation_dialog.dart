import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Potwierdzenie ACL używa wspólnej geometrii kontrolek modułu Files.
final class StorageShareConfirmationDialog extends StatelessWidget {
  const StorageShareConfirmationDialog({
    required this.title,
    required this.message,
    required this.action,
    super.key,
  });

  final String title;
  final String message;
  final String action;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(common.controlRadius),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: EdgeInsets.all(common.controlGap * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: common.projectTitleText),
              SizedBox(height: common.controlGap),
              Text(message, style: common.dataText),
              SizedBox(height: common.sectionGap),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: common.tightGap * 2,
                runSpacing: common.tightGap,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(context.l10n.cancel),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(action),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
