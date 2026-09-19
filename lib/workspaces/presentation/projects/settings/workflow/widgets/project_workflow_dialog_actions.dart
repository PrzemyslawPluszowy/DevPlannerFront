import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/workflow/widgets/project_custom_status_editor_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/workflow/widgets/project_workflow_delete_status_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/workflow/widgets/project_workflow_templates_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/custom_workflow_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Akcje modalne workflow, odseparowane od renderowania statusów.
class ProjectWorkflowDialogActions {
  const ProjectWorkflowDialogActions._();

  static Future<void> openCreateStatus(BuildContext context) async {
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            String colorHex,
            TaskStatusCategory category,
            int? wipLimit,
          })
        >(
          context: context,
          builder: (_) => const ProjectCustomStatusEditorDialog(),
        );
    if (result != null) {
      await cubit.create(
        name: result.name,
        colorHex: result.colorHex,
        category: result.category,
        wipLimit: result.wipLimit,
      );
    }
  }

  static Future<void> openEditStatus(
    BuildContext context,
    ProjectCustomStatusResponse status,
  ) async {
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            String colorHex,
            TaskStatusCategory category,
            int? wipLimit,
          })
        >(
          context: context,
          builder: (_) =>
              ProjectCustomStatusEditorDialog(initialStatus: status),
        );
    if (result != null) {
      await cubit.update(
        status: status,
        name: result.name,
        colorHex: result.colorHex,
        category: result.category,
        wipLimit: result.wipLimit,
        isDefault: status.isDefault,
      );
    }
  }

  static Future<void> confirmDeleteStatus(
    BuildContext context,
    ProjectCustomStatusResponse status,
    List<ProjectCustomStatusResponse> statuses,
  ) async {
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final fallbackId = await showDialog<String>(
      context: context,
      builder: (_) => ProjectWorkflowDeleteStatusDialog(
        status: status,
        fallbackCandidates: statuses
            .where((candidate) => candidate.id != status.id)
            .toList(),
      ),
    );
    if (fallbackId != null) {
      await cubit.delete(status, fallbackId);
    }
  }

  static Future<void> openTemplates(
    BuildContext context,
    List<WorkflowTemplateSummary> templates,
  ) async {
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final template = await showDialog<WorkflowTemplateSummary>(
      context: context,
      builder: (_) => ProjectWorkflowTemplatesDialog(templates: templates),
    );
    if (template != null) {
      await cubit.applyTemplate(template.key);
    }
  }
}
