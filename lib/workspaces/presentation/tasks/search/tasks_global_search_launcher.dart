import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Opens workspace-wide task search from the shared Tasks header.
final class TasksGlobalSearchLauncher extends StatefulWidget {
  const TasksGlobalSearchLauncher({
    required this.repository,
    super.key,
  });

  final TaskViewRepository repository;

  @override
  State<TasksGlobalSearchLauncher> createState() =>
      _TasksGlobalSearchLauncherState();
}

final class _TasksGlobalSearchLauncherState
    extends State<TasksGlobalSearchLauncher> {
  late TasksGlobalSearchCubit _cubit;
  bool _searchOpen = false;
  bool _ownerDisposed = false;
  TasksGlobalSearchCubit? _dialogCubit;

  @override
  void initState() {
    super.initState();
    _cubit = _createCubit(widget);
  }

  @override
  void didUpdateWidget(covariant TasksGlobalSearchLauncher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (identical(oldWidget.repository, widget.repository)) return;
    final oldCubit = _cubit;
    _cubit = _createCubit(widget);
    if (!identical(oldCubit, _dialogCubit)) unawaited(oldCubit.close());
  }

  @override
  void dispose() {
    _ownerDisposed = true;
    if (!identical(_cubit, _dialogCubit)) unawaited(_cubit.close());
    super.dispose();
  }

  TasksGlobalSearchCubit _createCubit(TasksGlobalSearchLauncher widget) =>
      TasksGlobalSearchCubit(repository: widget.repository);

  Future<void> _openSearch() async {
    if (_searchOpen) return;
    _searchOpen = true;
    final searchCubit = _cubit;
    _dialogCubit = searchCubit;
    final navigation = DevPlannerNavigation.of(context);
    final currentLocation = Uri.tryParse(navigation.currentPath);
    try {
      await DevPlannerModalHost.showDialog<void>(
        context,
        builder: (dialogContext) => BlocProvider<TasksGlobalSearchCubit>.value(
          value: searchCubit,
          child: TasksGlobalSearchDialog(
            onOpenTask: (task) => _openTask(
              dialogContext,
              task,
              sourceCubit: searchCubit,
              navigation: navigation,
              currentLocation: currentLocation,
            ),
          ),
        ),
      );
    } finally {
      _searchOpen = false;
      _dialogCubit = null;
      if (_ownerDisposed || !identical(searchCubit, _cubit)) {
        unawaited(searchCubit.close());
      }
    }
  }

  void _openTask(
    BuildContext dialogContext,
    GlobalTaskSearchItemResponse task, {
    required TasksGlobalSearchCubit sourceCubit,
    required DevPlannerNavigation navigation,
    required Uri? currentLocation,
  }) {
    if (!dialogContext.mounted) return;
    Navigator.of(dialogContext).pop();
    if (!mounted ||
        _ownerDisposed ||
        sourceCubit.isClosed ||
        !identical(sourceCubit, _cubit)) {
      return;
    }
    unawaited(
      navigation.goToTask(
        workspaceId: task.workspaceId,
        projectId: task.projectId,
        taskId: task.id,
        currentLocation: currentLocation,
        source: TaskDetailOpenSource.search,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    return Tooltip(
      message: context.l10n.tasksGlobalSearchTooltip,
      child: IconButton(
        key: const ValueKey('tasks-global-search-launcher'),
        onPressed: () => unawaited(_openSearch()),
        icon: const Icon(Symbols.search_rounded, size: 18),
        style: IconButton.styleFrom(
          minimumSize: const Size(36, 36),
          maximumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          foregroundColor: colors.onSurfaceVariant,
          hoverColor: colors.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tasks.controlRadius),
            side: BorderSide(color: tasks.canvasBorder),
          ),
        ),
      ),
    );
  }
}
