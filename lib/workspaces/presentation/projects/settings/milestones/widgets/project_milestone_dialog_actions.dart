import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/milestones/widgets/project_milestone_editor_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/milestone_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Akcje dialogów kamieni milowych poza widokiem listy.
class ProjectMilestoneDialogActions {
  const ProjectMilestoneDialogActions._();

  static Future<void> openCreate(BuildContext context) async {
    final cubit = context.read<MilestoneSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            String? description,
            DateTime? dueAtUtc,
            MilestoneStatus status,
          })
        >(
          context: context,
          builder: (_) => const ProjectMilestoneEditorDialog(),
        );
    if (result != null) {
      await cubit.save(
        name: result.name,
        description: result.description ?? '',
        dueAtUtc: result.dueAtUtc,
        status: result.status,
      );
    }
  }

  static Future<void> openEdit(
    BuildContext context,
    MilestoneResponse milestone,
  ) async {
    final cubit = context.read<MilestoneSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            String? description,
            DateTime? dueAtUtc,
            MilestoneStatus status,
          })
        >(
          context: context,
          builder: (_) =>
              ProjectMilestoneEditorDialog(initialMilestone: milestone),
        );
    if (result != null) {
      await cubit.save(
        existing: milestone,
        name: result.name,
        description: result.description ?? '',
        dueAtUtc: result.dueAtUtc,
        status: result.status,
      );
    }
  }

  static Future<void> confirmDelete(
    BuildContext context,
    MilestoneResponse milestone,
  ) async {
    final cubit = context.read<MilestoneSettingsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Usuń kamień milowy'),
        content: Text(
          'Czy na pewno chcesz usunąć kamień milowy "${milestone.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: dialogContext.colors.error,
              foregroundColor: dialogContext.colors.onError,
            ),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.delete(milestone);
    }
  }
}
