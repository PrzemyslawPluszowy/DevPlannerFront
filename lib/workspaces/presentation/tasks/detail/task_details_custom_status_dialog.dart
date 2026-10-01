import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_detail_editor_close_guard.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TaskCustomStatusDialog extends StatefulWidget {
  const TaskCustomStatusDialog({
    required this.details,
    this.initialError,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final ApiError? initialError;

  @override
  State<TaskCustomStatusDialog> createState() => _TaskCustomStatusDialogState();
}

final class _TaskCustomStatusDialogState extends State<TaskCustomStatusDialog> {
  TaskDetailsCubit? _detailsCubit;
  List<ProjectCustomStatusResponse> _statuses = const [];
  ApiError? _loadError;
  String? _selectedId;
  String? _initialSelectedId;
  TaskDetailDraftRegistration? _draft;
  bool _loading = true;
  bool _saving = false;
  bool _allowPop = false;
  bool _checkingClose = false;
  int _loadGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cubit = context.read<TaskDetailsCubit>();
    if (identical(_detailsCubit, cubit)) return;
    _detailsCubit = cubit;
    _selectedId = widget.details.customStatus?.id;
    _initialSelectedId = _selectedId;
    _draft?.dispose();
    _draft = TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsCustomStatusTitle,
    );
    if (widget.initialError case final error?) {
      _loadError = error;
      _loading = false;
    } else {
      unawaited(_loadStatuses());
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    super.dispose();
  }

  Future<void> _requestClose() async {
    if (_checkingClose) return;
    _checkingClose = true;
    final canClose = await TaskDetailEditorCloseGuard.canClose(
      context,
      _draft,
    );
    if (!mounted) return;
    _checkingClose = false;
    if (!canClose) return;
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  Future<void> _loadStatuses() async {
    final sourceCubit = _detailsCubit;
    if (sourceCubit == null || sourceCubit.isClosed) return;
    final taskId = widget.details.task.id;
    final generation = ++_loadGeneration;
    setState(() {
      _loading = true;
      _loadError = null;
    });
    final result = await sourceCubit.loadCustomStatuses();
    if (!mounted ||
        sourceCubit.isClosed ||
        !identical(_detailsCubit, sourceCubit) ||
        generation != _loadGeneration ||
        taskId != widget.details.task.id) {
      return;
    }
    result.fold(
      (error) => setState(() {
        _loadError = error;
        _loading = false;
      }),
      (statuses) {
        final sorted = List<ProjectCustomStatusResponse>.of(statuses)
          ..sort((a, b) => a.position.compareTo(b.position));
        final current = widget.details.customStatus;
        if (current != null && !sorted.any((item) => item.id == current.id)) {
          sorted.add(
            ProjectCustomStatusResponse(
              id: current.id,
              projectId: widget.details.task.projectId,
              name: current.name,
              colorHex: current.color,
              category: current.category,
              position: sorted.length,
              isDefault: false,
              taskCount: 0,
              version: 0,
            ),
          );
        }
        setState(() {
          _statuses = sorted;
          _loading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return PopScope<void>(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_requestClose());
      },
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540, maxHeight: 650),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.l10n.taskDetailsCustomStatusTitle,
                        style: tasks.dataStrongText,
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.taskDetailsClose,
                      onPressed: _saving ? null : _requestClose,
                      icon: const Icon(Symbols.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_loadError case final error?) ...[
                  TaskDetailsModalError(error: error),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _loading ? null : _loadStatuses,
                      icon: const Icon(Symbols.refresh_rounded),
                      label: Text(context.l10n.retry),
                    ),
                  ),
                ] else if (_loading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_statuses.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        context.l10n.taskDetailsCustomStatusEmpty,
                        textAlign: TextAlign.center,
                        style: tasks.metaText,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      itemCount: _statuses.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, index) => _CustomStatusOption(
                        status: _statuses[index],
                        selected: _statuses[index].id == _selectedId,
                        currentId: widget.details.task.customStatusId,
                        onSelected: _saving
                            ? null
                            : () => setState(
                                () => _selectStatus(_statuses[index].id),
                              ),
                      ),
                    ),
                  ),
                if (!_loading &&
                    _loadError == null &&
                    _statuses.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
                    builder: (context, state) => switch (state) {
                      TaskDetailsReady(mutationFailure: final error?) =>
                        TaskDetailsModalError(error: error),
                      _ => const SizedBox.shrink(),
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _saving ? null : _requestClose,
                        child: Text(context.l10n.cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _saving || _selectedId == null
                            ? null
                            : _save,
                        child: _saving
                            ? const SizedBox.square(
                                dimension: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(context.l10n.save),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_saving) return;
    final selectedId = _selectedId;
    if (selectedId == null) return;
    final sourceContext = context;
    final sourceCubit = _detailsCubit;
    if (sourceCubit == null || sourceCubit.isClosed) return;
    setState(() => _saving = true);
    final saved = await sourceCubit.moveCustomStatus(selectedId);
    if (!mounted ||
        !sourceContext.mounted ||
        sourceCubit.isClosed ||
        !identical(_detailsCubit, sourceCubit) ||
        !identical(sourceContext.read<TaskDetailsCubit>(), sourceCubit)) {
      return;
    }
    if (saved) {
      _draft?.clear();
      setState(() => _allowPop = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      setState(() => _saving = false);
    }
  }

  void _selectStatus(String statusId) {
    _selectedId = statusId;
    if (statusId == _initialSelectedId) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }
}

final class _CustomStatusOption extends StatelessWidget {
  const _CustomStatusOption({
    required this.status,
    required this.selected,
    required this.currentId,
    required this.onSelected,
  });

  final ProjectCustomStatusResponse status;
  final bool selected;
  final String? currentId;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final statusColor = TaskCustomStatusPresentation.parseColor(
      status.colorHex,
      colors.primary,
    );
    final projectedCount = status.taskCount + (currentId == status.id ? 0 : 1);
    final exceedsWip =
        status.wipLimit != null && projectedCount > status.wipLimit!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(tasks.controlRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? tasks.commandBarSurface : tasks.cardSurface,
            borderRadius: BorderRadius.circular(tasks.controlRadius),
            border: Border.all(
              color: selected ? colors.primary : tasks.canvasBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected ? Symbols.radio_button_checked : Symbols.circle,
                size: 17,
                color: statusColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(status.name, style: tasks.dataStrongText),
                    Text(
                      TaskCustomStatusPresentation.categoryLabel(
                        context,
                        status.category,
                      ),
                      style: tasks.metaText.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (exceedsWip)
                      Text(
                        context.l10n.taskDetailsCustomStatusWipWarning(
                          status.name,
                          projectedCount,
                          status.wipLimit!,
                        ),
                        style: tasks.metaText.copyWith(color: colors.error),
                      ),
                  ],
                ),
              ),
              Text(
                '${status.taskCount}',
                style: tasks.metaText.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class TaskCustomStatusPresentation {
  const TaskCustomStatusPresentation._();

  static String categoryLabel(
    BuildContext context,
    TaskStatusCategory category,
  ) => switch (category) {
    TaskStatusCategory.todo => context.l10n.taskDetailsStatusCategoryTodo,
    TaskStatusCategory.inProgress =>
      context.l10n.taskDetailsStatusCategoryInProgress,
    TaskStatusCategory.done => context.l10n.taskDetailsStatusCategoryDone,
    TaskStatusCategory.cancelled =>
      context.l10n.taskDetailsStatusCategoryCancelled,
  };

  static Color parseColor(String value, Color fallback) {
    final hex = value.replaceFirst('#', '');
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) return fallback;
    return Color(hex.length <= 6 ? 0xFF000000 | parsed : parsed);
  }
}
