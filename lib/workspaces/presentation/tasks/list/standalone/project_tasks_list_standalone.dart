import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Samodzielna, odczytowa kompozycja listy zadań projektu.
///
/// Ten pion obsługuje wyłącznie pierwszy snapshot listy: loading, dane puste,
/// dane pogrupowane oraz typed failure (w tym 403). Mutacje, preferencje,
/// realtime i tabelę edycyjną pozostają poza tą granicą.
final class StandaloneProjectTasksList extends StatefulWidget {
  const StandaloneProjectTasksList({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    this.groupBy,
    super.key,
  });

  final TasksRepository repository;
  final String workspaceId;
  final String projectId;
  final TaskSavedViewGroupBy? groupBy;

  @override
  State<StandaloneProjectTasksList> createState() =>
      _StandaloneProjectTasksListState();
}

final class _StandaloneProjectTasksListState
    extends State<StandaloneProjectTasksList> {
  late ProjectTasksListCubit _cubit;
  late final TextEditingController _titleController;
  final ValueNotifier<_TaskCreationUiState> _creationUi = ValueNotifier(
    const _TaskCreationUiState(),
  );

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _cubit = _createCubit();
    unawaited(_cubit.load());
  }

  @override
  void didUpdateWidget(covariant StandaloneProjectTasksList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.repository == widget.repository &&
        oldWidget.workspaceId == widget.workspaceId &&
        oldWidget.projectId == widget.projectId &&
        oldWidget.groupBy == widget.groupBy) {
      return;
    }
    final previous = _cubit;
    _cubit = _createCubit();
    unawaited(previous.close());
    unawaited(_cubit.load());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _creationUi.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  ProjectTasksListCubit _createCubit() => ProjectTasksListCubit(
    repository: widget.repository,
    workspaceId: widget.workspaceId,
    projectId: widget.projectId,
    groupBy: widget.groupBy,
  );

  Future<void> _createTask() async {
    final normalized = _titleController.text.trim();
    if (_creationUi.value.isCreating) return;
    if (normalized.isEmpty) {
      _creationUi.value = _creationUi.value.copyWith(
        errorMessage: context.l10n.tasksListCreateTitleRequired,
      );
      return;
    }

    _creationUi.value = const _TaskCreationUiState(isCreating: true);
    final result = await _cubit.createRootTaskWithResult(
      title: normalized,
      status: ProjectTaskStatus.todo,
    );
    if (!mounted) return;
    if (result is ProjectTaskCreationSuccess) {
      _titleController.clear();
      _creationUi.value = const _TaskCreationUiState();
      return;
    }
    _creationUi.value = _TaskCreationUiState(
      errorMessage: _creationErrorFor(result as ProjectTaskCreationFailure),
    );
  }

  String _creationErrorFor(ProjectTaskCreationFailure result) {
    final l10n = context.l10n;
    return switch (result.reason) {
      ProjectTaskCreationFailureReason.invalidTitle =>
        l10n.tasksListCreateTitleRequired,
      ProjectTaskCreationFailureReason.duplicateSubmission =>
        l10n.tasksListCreateDuplicate,
      ProjectTaskCreationFailureReason.listNotReady =>
        l10n.tasksListCreateUnavailable,
      ProjectTaskCreationFailureReason.api => _localizedApiError(result.error),
    };
  }

  String _localizedApiError(ApiError? error) {
    final l10n = context.l10n;
    if (error == null) return l10n.tasksListCreateUnavailable;
    if (error.type == ApiErrorType.forbidden || error.statusCode == 403) {
      return l10n.tasksListCreateForbidden;
    }
    if (error.type == ApiErrorType.conflict || error.statusCode == 409) {
      return l10n.tasksListCreateConflict;
    }
    if (error.type == ApiErrorType.validation || error.statusCode == 422) {
      return l10n.tasksListCreateValidation;
    }
    return error.message;
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _cubit,
    child: BlocBuilder<ProjectTasksListCubit, ProjectTasksListState>(
      builder: (context, state) => ValueListenableBuilder<_TaskCreationUiState>(
        valueListenable: _creationUi,
        builder: (context, creationUi, _) => Column(
          children: [
            _StandaloneTaskCreationBar(
              controller: _titleController,
              enabled: state is ProjectTasksListReady,
              isSubmitting: creationUi.isCreating,
              errorMessage: creationUi.errorMessage,
              onSubmit: _createTask,
            ),
            Expanded(
              child: switch (state) {
                ProjectTasksListLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                ProjectTasksListFailure() => _StandaloneTaskListFailure(
                  state: state,
                ),
                ProjectTasksListReady() => _StandaloneTaskListReady(
                  state: state,
                ),
              },
            ),
          ],
        ),
      ),
    ),
  );
}

final class _TaskCreationUiState {
  const _TaskCreationUiState({this.isCreating = false, this.errorMessage});

  final bool isCreating;
  final String? errorMessage;

  _TaskCreationUiState copyWith({String? errorMessage}) => _TaskCreationUiState(
    isCreating: isCreating,
    errorMessage: errorMessage,
  );
}

final class _StandaloneTaskCreationBar extends StatelessWidget {
  const _StandaloneTaskCreationBar({
    required this.controller,
    required this.enabled,
    required this.isSubmitting,
    required this.errorMessage,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool enabled;
  final bool isSubmitting;
  final String? errorMessage;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled && !isSubmitting,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  labelText: context.l10n.tasksListQuickCreateTitle,
                  hintText: context.l10n.tasksListQuickCreateHint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: enabled && !isSubmitting ? onSubmit : null,
              icon: isSubmitting
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_rounded),
              label: Text(context.l10n.tasksListQuickCreateButton),
            ),
          ],
        ),
        if (errorMessage case final message?) ...[
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    ),
  );
}

final class _StandaloneTaskListFailure extends StatelessWidget {
  const _StandaloneTaskListFailure({required this.state});

  final ProjectTasksListFailure state;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              state.isForbidden
                  ? Icons.lock_outline_rounded
                  : Icons.error_outline_rounded,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => unawaited(
                context.read<ProjectTasksListCubit>().load(),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.workspacesRetry),
            ),
          ],
        ),
      ),
    ),
  );
}

final class _StandaloneTaskListReady extends StatelessWidget {
  const _StandaloneTaskListReady({required this.state});

  final ProjectTasksListReady state;

  @override
  Widget build(BuildContext context) {
    if (state.tasks.isEmpty) {
      return Center(child: Text(context.l10n.tasksListEmpty));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final group in state.groups) _StandaloneTaskGroup(group: group),
      ],
    );
  }
}

final class _StandaloneTaskGroup extends StatelessWidget {
  const _StandaloneTaskGroup({required this.group});

  final ProjectTaskListGroupResponse group;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          '${group.displayName} (${group.totalCount})',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      for (final task in group.items) _StandaloneTaskRow(task: task),
      const SizedBox(height: 16),
    ],
  );
}

final class _StandaloneTaskRow extends StatelessWidget {
  const _StandaloneTaskRow({required this.task});

  final ProjectTaskListItemResponse task;

  @override
  Widget build(BuildContext context) => Card(
    key: ValueKey<String>(task.id),
    child: ListTile(
      leading: Text(task.key),
      title: Text(task.title),
      subtitle: Text(task.status.name),
    ),
  );
}
