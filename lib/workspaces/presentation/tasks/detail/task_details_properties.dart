import 'package:devplanner/workspaces/presentation/tasks/detail/task_detail_person.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_collaboration.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_milestone.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_properties_planning.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class TaskProperties extends StatelessWidget {
  const TaskProperties({
    required this.details,
    required this.canEdit,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final task = details.task;
    final users = {
      for (final user in details.includedUsers) user.userId: user,
    };
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return Section(
      title: context.l10n.taskDetailsProperties,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: context.l10n.taskDetailsEditAssignees,
            onPressed: canEdit
                ? () => DevPlannerModalHost.showDialog<void>(
                    context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<TaskDetailsCubit>(),
                      child: EditAssigneesDialog(task: task),
                    ),
                  )
                : null,
            icon: const Icon(Symbols.group_add, size: 20),
          ),
          IconButton(
            tooltip: context.l10n.taskDetailsEditPlanning,
            onPressed: canEdit
                ? () => DevPlannerModalHost.showDialog<void>(
                    context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<TaskDetailsCubit>(),
                      child: EditPlanningDialog(task: task),
                    ),
                  )
                : null,
            icon: const Icon(Symbols.event_note, size: 20),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Column(
          children: [
            PropertyRow(
              icon: Symbols.people_outline_rounded,
              label: context.l10n.taskDetailsAssignees,
              value: context.l10n.taskDetailsNobody,
              valueWidget: task.assignees.isEmpty
                  ? null
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final item in task.assignees)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: TaskDetailPerson(
                              userId: item.userId,
                              user: users[item.userId],
                              showName: true,
                            ),
                          ),
                      ],
                    ),
            ),
            PropertyRow(
              icon: Symbols.play_circle_rounded,
              label: context.l10n.taskDetailsStartDate,
              value: task.startAtUtc == null
                  ? context.l10n.taskDetailsNoDate
                  : dateFormat.format(task.startAtUtc!.toLocal()),
            ),
            PropertyRow(
              icon: Symbols.calendar_today,
              label: context.l10n.taskDetailsDueDate,
              value: task.dueAtUtc == null
                  ? context.l10n.taskDetailsNoDueDate
                  : dateFormat.format(task.dueAtUtc!.toLocal()),
            ),
            TaskMilestoneProperty(taskId: task.id),
            PropertyRow(
              icon: Symbols.schedule,
              label: context.l10n.taskDetailsEstimate,
              value: task.estimatedMinutes == null
                  ? context.l10n.taskDetailsNoEstimate
                  : context.l10n.taskDetailsMinutes(task.estimatedMinutes!),
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
