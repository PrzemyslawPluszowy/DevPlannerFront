import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_detail_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/collaboration/cubit/task_member_profiles_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_fields_editor.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TaskDetailsCustomFieldsDialogBody extends StatelessWidget {
  const TaskDetailsCustomFieldsDialogBody({
    required this.fields,
    required this.values,
    required this.isSaving,
    required this.profilesUnavailable,
    required this.validationError,
    required this.onFieldChanged,
    this.profilesCubit,
    super.key,
  });

  final List<TaskCustomFieldDefinitionValueResponse> fields;
  final Map<String, dynamic> values;
  final bool isSaving;
  final bool profilesUnavailable;
  final String? validationError;
  final ValueChanged<({String fieldId, dynamic value})> onFieldChanged;
  final TaskMemberProfilesCubit? profilesCubit;

  @override
  Widget build(BuildContext context) {
    final cubit = profilesCubit;
    if (cubit == null) {
      return TaskDetailsCustomFieldsDialogBodyContent(
        fields: fields,
        values: values,
        isSaving: isSaving,
        profilesUnavailable: profilesUnavailable,
        validationError: validationError,
        onFieldChanged: onFieldChanged,
      );
    }
    return BlocBuilder<TaskMemberProfilesCubit, TaskMemberProfilesState>(
      bloc: cubit,
      builder: (context, state) => TaskDetailsCustomFieldsDialogBodyContent(
        fields: fields,
        values: values,
        isSaving: isSaving,
        profilesUnavailable: profilesUnavailable,
        validationError: validationError,
        onFieldChanged: onFieldChanged,
        profilesState: state,
        onRetryProfiles: () => unawaited(cubit.load()),
      ),
    );
  }
}

final class TaskDetailsCustomFieldsDialogBodyContent extends StatelessWidget {
  const TaskDetailsCustomFieldsDialogBodyContent({
    required this.fields,
    required this.values,
    required this.isSaving,
    required this.profilesUnavailable,
    required this.validationError,
    required this.onFieldChanged,
    this.profilesState,
    this.onRetryProfiles,
    super.key,
  });

  final List<TaskCustomFieldDefinitionValueResponse> fields;
  final Map<String, dynamic> values;
  final bool isSaving;
  final bool profilesUnavailable;
  final String? validationError;
  final ValueChanged<({String fieldId, dynamic value})> onFieldChanged;
  final TaskMemberProfilesState? profilesState;
  final VoidCallback? onRetryProfiles;

  bool get _hasUserFields =>
      fields.any((field) => field.type == TaskCustomFieldType.user);

  @override
  Widget build(BuildContext context) {
    final memberState = profilesState;
    final profiles = switch (memberState) {
      TaskMemberProfilesReady(:final profiles) => profiles,
      _ => const <ProjectMemberProfile>[],
    };
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TaskDetailsDialogMutationError(),
          if (profilesUnavailable)
            TaskDetailsModalError(
              error: ApiError(
                type: ApiErrorType.unknown,
                message: context.l10n.taskDetailsMemberProfilesUnavailable,
                contractCode: 'project_member_profiles_unavailable',
              ),
            ),
          if (memberState case TaskMemberProfilesFailure(:final error)) ...[
            TaskDetailsModalError(error: error),
            TextButton.icon(
              onPressed: onRetryProfiles,
              icon: const Icon(Symbols.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
          if (_hasUserFields && memberState is TaskMemberProfilesLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(),
            ),
          if (_hasUserFields &&
              memberState is TaskMemberProfilesReady &&
              memberState.profiles.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                context.l10n.taskDetailsNoProjectMembers,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          for (final field in fields) ...[
            CustomFieldEditor(
              field: field,
              value: values[field.id],
              enabled:
                  !isSaving &&
                  (field.type != TaskCustomFieldType.user ||
                      memberState is TaskMemberProfilesReady) &&
                  !(field.type == TaskCustomFieldType.user &&
                      profilesUnavailable),
              memberProfiles: profiles,
              onChanged: (value) => onFieldChanged(
                (fieldId: field.id, value: value),
              ),
            ),
            const SizedBox(height: 14),
          ],
          if (validationError case final message?)
            Text(
              message,
              style: TextStyle(color: context.colors.error),
            ),
        ],
      ),
    );
  }
}
