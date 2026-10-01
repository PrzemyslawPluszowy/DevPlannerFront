import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class TaskMilestoneProperty extends StatelessWidget {
  const TaskMilestoneProperty({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final details = context
        .select<TaskDetailsCubit, ProjectTaskDetailsResponse?>(
          (cubit) => switch (cubit.state) {
            TaskDetailsReady(:final details) => details,
            _ => null,
          },
        );
    if (details == null) return const SizedBox.shrink();
    final detailsCubit = context.read<TaskDetailsCubit>();
    final repository = context.read<MilestoneRepository>();
    return BlocProvider(
      key: ValueKey((
        taskId,
        details.task.workspaceId,
        details.task.projectId,
        details.task.milestoneId,
        repository,
        detailsCubit,
      )),
      create: (context) {
        final cubit = TaskMilestoneCubit(
          repository: repository,
          workspaceId: details.task.workspaceId,
          projectId: details.task.projectId,
          taskId: taskId,
          assignedMilestoneId: details.task.milestoneId,
          canEdit: () =>
              !detailsCubit.isClosed &&
              switch (detailsCubit.state) {
                TaskDetailsReady(:final canEdit) => canEdit,
                _ => false,
              },
          onAccessLost: (error) =>
              unawaited(detailsCubit.reportAccessLost(error)),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: TaskMilestoneValue(
        canEdit: details.capabilities?.canEdit ?? true,
      ),
    );
  }
}

class TaskMilestoneValue extends StatelessWidget {
  const TaskMilestoneValue({required this.canEdit, super.key});

  final bool canEdit;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskMilestoneCubit, TaskMilestoneState>(
        builder: (context, state) => switch (state) {
          TaskMilestoneLoading() => PropertyRow(
            icon: Symbols.flag,
            label: context.l10n.taskDetailsMilestone,
            value: context.l10n.taskDetailsLoading,
          ),
          TaskMilestoneFailure(:final error) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PropertyRow(
                icon: Symbols.flag,
                label: context.l10n.taskDetailsMilestone,
                value: context.l10n.taskDetailsMilestoneUnavailable,
                onTap: context.read<TaskMilestoneCubit>().canRetry
                    ? () => unawaited(context.read<TaskMilestoneCubit>().load())
                    : null,
              ),
              if (error != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: SingleChildScrollView(
                    child: TaskDetailsModalError(
                      error: error,
                      fallbackMessage:
                          context.l10n.tasksMilestoneOperationFailed,
                    ),
                  ),
                ),
            ],
          ),
          TaskMilestoneReady() => TaskMilestoneReadyValue(
            state: state,
            canEdit: canEdit,
          ),
        },
      );
}

class TaskMilestoneReadyValue extends StatelessWidget {
  const TaskMilestoneReadyValue({
    required this.state,
    required this.canEdit,
    super.key,
  });

  final TaskMilestoneReady state;
  final bool canEdit;

  @override
  Widget build(BuildContext context) => PropertyRow(
    icon: Symbols.flag,
    label: context.l10n.taskDetailsMilestone,
    value: state.assigned?.name ?? context.l10n.taskDetailsNoMilestone,
    onTap: !context.read<TaskMilestoneCubit>().canMutate || !canEdit
        ? null
        : () => TaskMilestonePickerLauncher.show(context, state),
  );
}

/// Otwiera wybór milestone z Cubitem już utworzonym dla szczegółu zadania.
final class TaskMilestonePickerLauncher {
  const TaskMilestonePickerLauncher._();

  static Future<void> show(BuildContext context, TaskMilestoneReady state) {
    final cubit = context.read<TaskMilestoneCubit>();
    if (cubit.isClosed) return Future.value();
    return DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const TaskMilestonePicker(),
      ),
    );
  }
}

class TaskMilestonePicker extends StatelessWidget {
  const TaskMilestonePicker({super.key});

  void _close(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return Dialog(
      backgroundColor: tasks.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.controlRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 560),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.taskDetailsMilestone,
                      style: tasks.controlText.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.close,
                    onPressed: () => _close(context),
                    icon: const Icon(Symbols.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<TaskMilestoneCubit, TaskMilestoneState>(
                builder: (context, state) => switch (state) {
                  TaskMilestoneLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  TaskMilestoneFailure(:final error) => SingleChildScrollView(
                    child: Column(
                      children: [
                        if (error != null)
                          TaskDetailsModalError(
                            error: error,
                            fallbackMessage:
                                context.l10n.tasksMilestoneOperationFailed,
                          ),
                        TextButton.icon(
                          onPressed: context.read<TaskMilestoneCubit>().canRetry
                              ? () => unawaited(
                                  context.read<TaskMilestoneCubit>().load(),
                                )
                              : null,
                          icon: const Icon(Symbols.refresh_rounded),
                          label: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                  TaskMilestoneReady() => ListView(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                    children: [
                      if (state.apiError case final error?)
                        TaskDetailsModalError(
                          error: error,
                          fallbackMessage:
                              context.l10n.tasksMilestoneOperationFailed,
                        ),
                      if (state.assigned != null)
                        const TaskMilestoneChoice()
                      else
                        for (final milestone in state.milestones)
                          TaskMilestoneChoice(milestone: milestone),
                    ],
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pojedyncza akcja z własnym handlerem i ochroną właściciela po await.
final class TaskMilestoneChoice extends StatelessWidget {
  const TaskMilestoneChoice({this.milestone, super.key});

  final MilestoneResponse? milestone;

  Future<void> _activate(BuildContext context) async {
    final cubit = context.read<TaskMilestoneCubit>();
    final route = ModalRoute.of(context);
    final target = milestone;
    final saved = target == null
        ? await cubit.unassign()
        : await cubit.assign(target);
    if (!context.mounted ||
        cubit.isClosed ||
        !saved ||
        !identical(cubit, context.read<TaskMilestoneCubit>()) ||
        route?.isCurrent != true) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(milestone == null ? Symbols.link_off_rounded : Symbols.flag),
    title: Text(
      milestone?.name ?? context.l10n.taskDetailsRemoveMilestone,
      style: context.tasksTheme.dataText,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
    ),
    onTap: context.read<TaskMilestoneCubit>().canMutate
        ? () => unawaited(_activate(context))
        : null,
  );
}
