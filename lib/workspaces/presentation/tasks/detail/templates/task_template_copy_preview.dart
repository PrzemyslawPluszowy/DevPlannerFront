import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_detail_models.dart';
import 'package:flutter/material.dart';

/// Podgląd konfiguracji kopiowanej przez serwerowy kontrakt from-task.
final class TaskTemplateCopyPreviewData {
  TaskTemplateCopyPreviewData.fromDetails(ProjectTaskDetailsResponse details)
    : key = details.task.key,
      assignees = details.task.assignees.length,
      checklist = details.task.checklistItems.length,
      criteria = details.acceptanceCriteria.length,
      labels = details.labels.length,
      customValues = details.customFields
          .where((field) => field.valueUpdatedAtUtc != null)
          .length;

  final String key;
  final int assignees;
  final int checklist;
  final int criteria;
  final int labels;
  final int customValues;
}

/// Wyjaśnia zakres snapshotu bez sugerowania kopiowania treści zadania.
final class TaskTemplateCopyPreview extends StatelessWidget {
  const TaskTemplateCopyPreview({this.data, super.key});

  final TaskTemplateCopyPreviewData? data;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final preview = data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.taskTemplateCopyHeading,
          style: tasks.controlText.copyWith(color: colors.onSurface),
        ),
        Gaps.h8,
        Text(l10n.taskTemplateCopyFields, style: tasks.dataText),
        if (preview != null) ...[
          Gaps.h8,
          Text(
            l10n.taskTemplateCopyCounts(
              preview.key,
              preview.assignees,
              preview.checklist,
              preview.criteria,
              preview.labels,
              preview.customValues,
            ),
            key: const ValueKey('task_template_copy_counts'),
            style: tasks.dataText,
          ),
        ],
        Gaps.h8,
        Text(
          l10n.taskTemplateCopyExcluded,
          style: tasks.dataText.copyWith(color: colors.onSurfaceVariant),
        ),
        Gaps.h8,
        Text(
          l10n.taskTemplateCopySavedVersion,
          style: tasks.controlText.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
