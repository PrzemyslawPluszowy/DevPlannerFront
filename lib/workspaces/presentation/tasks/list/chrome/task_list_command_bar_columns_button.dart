import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_command_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/helpers/task_permission_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Opens the list column configuration from its command-bar control.
class TaskListCommandBarColumnsButton extends StatelessWidget {
  const TaskListCommandBarColumnsButton({
    required this.memberProfiles,
    this.compact = false,
    super.key,
  });

  final Map<String, ProjectMemberProfile> memberProfiles;
  final bool compact;

  @override
  Widget build(BuildContext context) => TasksCommandButton(
    icon: Symbols.view_column_rounded,
    label: context.l10n.tasksListColumnsTitle,
    compact: compact,
    onTap: () => _openColumns(context),
  );

  Future<void> _openColumns(BuildContext context) async {
    final cubit = context.read<TaskListPreferencesCubit>();
    final repository = context.read<TaskMetadataRepository>();
    final workspaceId = cubit.workspaceId;
    final projectId = cubit.projectId;
    final canManage = TaskPermissionHelper.canManageProject(
      context,
      memberProfiles: memberProfiles,
    );
    late final Either<ApiError, List<TaskCustomFieldResponse>> result;
    try {
      result = await repository.listCustomFields(
        workspaceId: workspaceId,
        projectId: projectId,
      );
    } catch (_) {
      if (!context.mounted) return;
      if (!_isCurrentRequest(
        context,
        cubit,
        repository,
        workspaceId,
        projectId,
      )) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.tasksListColumnsLoadFailed)),
      );
      return;
    }
    if (!context.mounted) return;
    if (!_isCurrentRequest(
      context,
      cubit,
      repository,
      workspaceId,
      projectId,
    )) {
      return;
    }
    final failure = result.fold<ApiError?>((error) => error, (_) => null);
    if (failure != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message)));
      return;
    }
    final fields = result.getOrElse(() => const <TaskCustomFieldResponse>[]);
    await TaskListColumnsSheet.show(
      context,
      cubit: cubit,
      customFields: fields,
      canManage: canManage,
    );
  }

  bool _isCurrentRequest(
    BuildContext context,
    TaskListPreferencesCubit cubit,
    TaskMetadataRepository repository,
    String workspaceId,
    String projectId,
  ) =>
      !cubit.isClosed &&
      identical(context.read<TaskListPreferencesCubit>(), cubit) &&
      identical(context.read<TaskMetadataRepository>(), repository) &&
      cubit.workspaceId == workspaceId &&
      cubit.projectId == projectId;
}
