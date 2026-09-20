import 'dart:async';
import 'dart:convert';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_time_tracking_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cascade/cubit/task_schedule_cascade_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/history/cubit/task_history_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/milestone/cubit/task_milestone_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/templates/cubit/task_template_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/cubit/task_time_tracking_cubit.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

part 'task_details_acceptance.dart';
part 'task_details_attachments.dart';
part 'task_details_checklist.dart';
part 'task_details_collaboration.dart';
part 'task_details_custom_fields.dart';
part 'task_details_custom_fields_editor.dart';
part 'task_details_dependencies.dart';
part 'task_details_dependency_fields.dart';
part 'task_details_description.dart';
part 'task_details_header.dart';
part 'task_details_history.dart';
part 'task_details_labels.dart';
part 'task_details_milestone.dart';
part 'task_details_properties.dart';
part 'task_details_properties_planning.dart';
part 'task_details_recurrence.dart';
part 'task_details_recurrence_fields.dart';
part 'task_details_recurrence_form.dart';
part 'task_details_shared.dart';
part 'task_details_subtasks.dart';
part 'task_details_templates.dart';
part 'task_details_time_tracking.dart';

class WorkspaceTaskDetailsPage extends StatelessWidget {
  const WorkspaceTaskDetailsPage({
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String taskId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = TaskDetailsCubit(
        repository: context.read<TasksRepository>(),
        acceptanceCriteriaRepository: context
            .read<TaskAcceptanceCriteriaRepository>(),
        checklistRepository: context.read<TaskChecklistRepository>(),
        collaborationRepository: context.read<TaskCollaborationRepository>(),
        metadataRepository: context.read<TaskMetadataRepository>(),
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: const _TaskDetailsOverlay(),
  );
}

class _TaskDetailsOverlay extends StatelessWidget {
  const _TaskDetailsOverlay();

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 760;
      return Stack(
        children: [
          if (!compact)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: ColoredBox(
                  color: context.tasksTheme.scrim.withValues(alpha: .22),
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: context.colors.surface,
              elevation: compact ? 0 : 18,
              child: SizedBox(
                width: compact ? constraints.maxWidth : 600,
                height: constraints.maxHeight,
                child: BlocConsumer<TaskDetailsCubit, TaskDetailsState>(
                  listenWhen: (previous, current) =>
                      previous is TaskDetailsReady &&
                      current is TaskDetailsReady &&
                      previous.mutationSerial != current.mutationSerial,
                  listener: (context, state) {
                    if (state case TaskDetailsReady(:final mutationError?)) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(mutationError)));
                    }
                  },
                  builder: (context, state) => switch (state) {
                    TaskDetailsInitial() ||
                    TaskDetailsLoading() => const _TaskDetailsLoading(),
                    TaskDetailsFailure() => _TaskDetailsFailureView(
                      failure: state,
                    ),
                    TaskDetailsReady() => _TaskDetailsContent(
                      state: state,
                    ),
                  },
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

class _TaskDetailsContent extends StatelessWidget {
  const _TaskDetailsContent({required this.state});

  final TaskDetailsReady state;

  @override
  Widget build(BuildContext context) {
    final details = state.details;
    final task = details.task;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _DetailHeader(
            details: details,
            isSaving: state.isSaving,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          sliver: SliverList.list(
            children: [
              _TaskProperties(details: details),
              const SizedBox(height: 24),
              _TaskWatchersSection(
                details: details,
                isSaving: state.isSaving,
              ),
              const SizedBox(height: 24),
              _TaskLabelsSection(details: details, isSaving: state.isSaving),
              const SizedBox(height: 24),
              _TaskCustomFieldsSection(
                fields: details.customFields,
                isSaving: state.isSaving,
              ),
              const SizedBox(height: 24),
              _TaskDescriptionSection(task: task, isSaving: state.isSaving),
              const SizedBox(height: 24),
              _ChecklistSection(task: task, isSaving: state.isSaving),
              const SizedBox(height: 24),
              _AcceptanceCriteriaSection(
                criteria: details.acceptanceCriteria,
                isSaving: state.isSaving,
              ),
              const SizedBox(height: 24),
              _SubtasksSection(
                subtasks: details.subtasks,
                isSaving: state.isSaving,
              ),
              const SizedBox(height: 24),
              _DependenciesSection(
                dependencies: details.dependencies,
                isSaving: state.isSaving,
              ),
              const SizedBox(height: 24),
              _TaskRecurrenceSection(task: task),
              const SizedBox(height: 24),
              _TaskAttachmentsSection(taskId: task.id),
              const SizedBox(height: 24),
              _TaskTimeTrackingSection(taskId: task.id),
            ],
          ),
        ),
      ],
    );
  }
}
