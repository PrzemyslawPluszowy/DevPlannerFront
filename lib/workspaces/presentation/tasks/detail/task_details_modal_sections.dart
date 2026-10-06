import 'package:devplanner/workspaces/presentation/tasks/detail/task_attachments_section.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_detail_people_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_acceptance.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_checklist.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_collaboration.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_fields.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dependencies.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_description.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_history.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_labels.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_properties.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_subtasks.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_time_tracking.dart';

class TaskDetailsWorkTab extends StatelessWidget {
  const TaskDetailsWorkTab({
    required this.details,
    required this.isSaving,
    required this.canEdit,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;
  final bool canEdit;

  @override
  Widget build(BuildContext context) => ListView(
    key: const PageStorageKey<String>('task-details-work'),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
    children: [
      TaskDescriptionSection(
        task: details.task,
        isSaving: isSaving || !canEdit,
      ),
      const SizedBox(height: 18),
      ChecklistSection(task: details.task, isSaving: isSaving || !canEdit),
      const SizedBox(height: 18),
      AcceptanceCriteriaSection(
        criteria: details.acceptanceCriteria,
        isSaving: isSaving || !canEdit,
      ),
      const SizedBox(height: 18),
      SubtasksSection(
        subtasks: details.subtasks,
        isSaving: isSaving || !canEdit,
      ),
      const SizedBox(height: 18),
      DependenciesSection(
        dependencies: details.dependencies,
        isSaving: isSaving || !canEdit,
      ),
    ],
  );
}

class TaskDetailsFilesTab extends StatelessWidget {
  const TaskDetailsFilesTab({
    required this.taskId,
    required this.isEditable,
    super.key,
  });

  final String taskId;
  final bool isEditable;

  @override
  Widget build(BuildContext context) => ListView(
    key: const PageStorageKey<String>('task-details-files'),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
    children: [
      TaskAttachmentsSection(taskId: taskId, isEditable: isEditable),
    ],
  );
}

class TaskDetailsPlanTab extends StatelessWidget {
  const TaskDetailsPlanTab({
    required this.task,
    required this.isEditable,
    super.key,
  });

  final ProjectTaskResponse task;
  final bool isEditable;

  @override
  Widget build(BuildContext context) => ListView(
    key: const PageStorageKey<String>('task-details-plan'),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
    children: [
      TaskRecurrenceSection(task: task, isEditable: isEditable),
      const SizedBox(height: 18),
      TaskTimeTrackingSection(taskId: task.id, isEditable: isEditable),
    ],
  );
}

class TaskDetailsPropertyRail extends StatelessWidget {
  const TaskDetailsPropertyRail({
    required this.details,
    required this.isSaving,
    required this.canEdit,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool isSaving;
  final bool canEdit;

  @override
  Widget build(BuildContext context) => TaskDetailPeopleScope(
    child: ListView(
      key: const PageStorageKey<String>('task-details-properties'),
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        TaskProperties(details: details, canEdit: canEdit),
        const SizedBox(height: 20),
        TaskWatchersSection(details: details, isSaving: isSaving),
        const SizedBox(height: 20),
        TaskLabelsSection(details: details, isSaving: isSaving || !canEdit),
        const SizedBox(height: 20),
        TaskCustomFieldsSection(
          fields: details.customFields,
          isSaving: isSaving || !canEdit,
        ),
      ],
    ),
  );
}

class TaskDetailsHistoryTab extends StatelessWidget {
  const TaskDetailsHistoryTab({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final detailsCubit = context.read<TaskDetailsCubit>();
      final cubit = TaskHistoryCubit(
        repository: context.read<TaskHistoryRepository>(),
        memberProfilesRepository: context
            .read<ProjectMemberProfilesRepository?>(),
        workspaceId: detailsCubit.workspaceId,
        projectId: detailsCubit.projectId,
        taskId: detailsCubit.taskId,
        onAccessLost: (error) =>
            unawaited(detailsCubit.reportAccessLost(error)),
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: const TaskHistoryBody(),
  );
}

class TaskDetailsPendingHeader extends StatelessWidget {
  const TaskDetailsPendingHeader({this.onClose, super.key});

  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56,
    child: Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        tooltip: context.l10n.taskDetailsClose,
        onPressed: onClose ?? () => Navigator.of(context).maybePop(),
        icon: const Icon(Symbols.close_rounded),
      ),
    ),
  );
}
