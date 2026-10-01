import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Web-styled confirmation used before dropping unsaved task editor drafts.
final class TaskDetailDraftDiscardConfirmation extends StatelessWidget {
  const TaskDetailDraftDiscardConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final l10n = context.l10n;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tasks.canvas,
            borderRadius: BorderRadius.circular(tasks.panelRadius),
            border: Border.all(color: tasks.canvasBorder),
            boxShadow: [
              BoxShadow(
                color: tasks.shadow.withValues(alpha: .18),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: tasks.canvas,
            borderRadius: BorderRadius.circular(tasks.panelRadius),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.taskDetailsUnsavedChangesTitle),
                  const SizedBox(height: 10),
                  Text(l10n.taskDetailsUnsavedChangesMessage),
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.end,
                    runAlignment: WrapAlignment.end,
                    spacing: 8,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(l10n.taskDetailsUnsavedStay),
                      ),
                      FilledButton.tonal(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(l10n.taskDetailsUnsavedDiscard),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
