import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_run_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_labelers.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence_form.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence_run_details.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class TaskRecurrenceSection extends StatelessWidget {
  const TaskRecurrenceSection({
    required this.task,
    required this.isEditable,
    super.key,
  });

  final ProjectTaskResponse task;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final recurrence = task.recurrence;
    final detailsCubit = context.read<TaskDetailsCubit>();
    final repository = context.read<TaskRecurrenceRepository>();
    return BlocProvider(
      key: ValueKey((
        task.workspaceId,
        task.projectId,
        task.id,
        recurrence?.id,
        repository,
      )),
      create: (_) {
        final cubit = TaskRecurrenceRunCubit(
          repository: repository,
          workspaceId: task.workspaceId,
          projectId: task.projectId,
          sourceTaskId: task.id,
          canEdit: () =>
              !detailsCubit.isClosed &&
              switch (detailsCubit.state) {
                TaskDetailsReady(:final canEdit) => canEdit,
                _ => false,
              },
          onAccessLost: (error) =>
              unawaited(detailsCubit.reportAccessLost(error)),
        );
        if (recurrence case final rule? when rule.isSourceTask) {
          unawaited(cubit.ensureLatestLoaded(rule.id));
        }
        return cubit;
      },
      child: _TaskRecurrenceSectionContent(
        task: task,
        recurrence: recurrence,
        isEditable: isEditable,
      ),
    );
  }
}

final class _TaskRecurrenceSectionContent extends StatelessWidget {
  const _TaskRecurrenceSectionContent({
    required this.task,
    required this.recurrence,
    required this.isEditable,
  });

  final ProjectTaskResponse task;
  final TaskRecurrenceSummaryResponse? recurrence;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final recurrence = this.recurrence;
    return Section(
      title: context.l10n.taskDetailsRecurrence,
      action: TextButton.icon(
        onPressed: isEditable
            ? () => unawaited(TaskRecurrenceDialogLauncher.show(context, task))
            : null,
        icon: const Icon(Symbols.repeat_rounded, size: 18),
        label: Text(context.l10n.taskDetailsConfigureRecurrence),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(
                context.tasksTheme.controlRadius,
              ),
              border: Border.all(color: context.colors.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: recurrence == null
                  ? Text(
                      context.l10n.taskDetailsRecurrenceNotConfigured,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    )
                  : Row(
                      children: [
                        Icon(
                          recurrence.isActive
                              ? Symbols.repeat_rounded
                              : Symbols.pause_circle_outline_rounded,
                          color: recurrence.isActive
                              ? context.colors.primary
                              : context.colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${TaskRecurrenceFrequencyLabeler.label(context, recurrence.frequency)} '
                            '· ${context.l10n.taskDetailsRecurrenceEvery(recurrence.interval)}',
                          ),
                        ),
                        Text(
                          recurrence.isActive
                              ? context.l10n.taskDetailsRecurrenceActive
                              : context.l10n.taskDetailsRecurrencePaused,
                          style: context.text.labelMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          TaskRecurrenceRunDetails(task: task, isEditable: isEditable),
        ],
      ),
    );
  }
}

/// Składa dialog cykliczności z zależnościami bieżącego szczegółu zadania.
///
/// Launcher nie przechowuje stanu i nie przenosi logiki zapisu poza Cubit.
final class TaskRecurrenceDialogLauncher {
  const TaskRecurrenceDialogLauncher._();

  static Future<void> show(BuildContext context, ProjectTaskResponse task) {
    final detailsCubit = context.read<TaskDetailsCubit>();
    final recurrenceRepository = context.read<TaskRecurrenceRepository>();
    final draft = TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsRecurrence,
    );
    return DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider<TaskDetailsCubit>.value(
        value: detailsCubit,
        child: BlocProvider(
          create: (_) {
            final cubit = TaskRecurrenceCubit(
              repository: recurrenceRepository,
              workspaceId: detailsCubit.workspaceId,
              projectId: detailsCubit.projectId,
              taskId: detailsCubit.taskId,
              canEdit: () =>
                  !detailsCubit.isClosed &&
                  switch (detailsCubit.state) {
                    TaskDetailsReady(:final canEdit) => canEdit,
                    _ => false,
                  },
              onAccessLost: (error) =>
                  unawaited(detailsCubit.reportAccessLost(error)),
            );
            unawaited(cubit.load(hasRecurrence: task.recurrence != null));
            return cubit;
          },
          child: TaskRecurrenceDialog(
            task: task,
            onChanged: detailsCubit.load,
            draft: draft,
          ),
        ),
      ),
    ).whenComplete(() => draft?.dispose());
  }
}

class TaskRecurrenceDialog extends StatefulWidget {
  const TaskRecurrenceDialog({
    required this.task,
    required this.onChanged,
    required this.draft,
    super.key,
  });

  final ProjectTaskResponse task;
  final Future<void> Function() onChanged;
  final TaskDetailDraftRegistration? draft;

  @override
  State<TaskRecurrenceDialog> createState() => TaskRecurrenceDialogState();
}

class TaskRecurrenceDialogState extends State<TaskRecurrenceDialog> {
  bool _allowPop = false;
  bool _checkingClose = false;

  Future<void> _requestClose() async {
    if (_checkingClose) return;
    _checkingClose = true;
    final canClose = await TaskDetailEditorCloseGuard.canClose(
      context,
      widget.draft,
    );
    if (!mounted) return;
    _checkingClose = false;
    if (!canClose) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) => PopScope<void>(
    canPop: _allowPop,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) unawaited(_requestClose());
    },
    child: Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 700),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 14, 18),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Symbols.repeat_rounded, color: context.colors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.l10n.taskDetailsRecurrence,
                      style: context.text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: context.l10n.close,
                    onPressed: _requestClose,
                    icon: const Icon(Symbols.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TaskRecurrenceForm(
                  task: widget.task,
                  onChanged: widget.onChanged,
                  draft: widget.draft,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
