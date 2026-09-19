import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/create_custom_field_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/task_custom_fields_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Akcje dialogów pól niestandardowych, oddzielone od renderowania tabeli.
class ProjectCustomFieldDialogActions {
  const ProjectCustomFieldDialogActions._();

  static Future<void> openCreate(BuildContext context) async {
    final cubit = context.read<TaskCustomFieldsSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            TaskCustomFieldType type,
            bool isRequired,
            List<String> options,
          })
        >(
          context: context,
          builder: (_) => const CreateCustomFieldDialog(),
        );
    if (result != null) {
      await cubit.save(
        name: result.name,
        type: result.type,
        isRequired: result.isRequired,
        options: result.options,
      );
    }
  }

  static Future<void> openEdit(
    BuildContext context,
    TaskCustomFieldResponse field,
  ) async {
    final cubit = context.read<TaskCustomFieldsSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            TaskCustomFieldType type,
            bool isRequired,
            List<String> options,
          })
        >(
          context: context,
          builder: (_) => CreateCustomFieldDialog(initialField: field),
        );
    if (result != null) {
      await cubit.save(
        existing: field,
        name: result.name,
        type: result.type,
        isRequired: result.isRequired,
        options: result.options,
      );
    }
  }

  static Future<void> confirmDelete(
    BuildContext context,
    TaskCustomFieldResponse field,
  ) async {
    final cubit = context.read<TaskCustomFieldsSettingsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Usuń pole niestandardowe'),
        content: Text(
          'Czy na pewno chcesz usunąć pole "${field.name}" z tego projektu?',
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
      await cubit.archive(field);
    }
  }
}
