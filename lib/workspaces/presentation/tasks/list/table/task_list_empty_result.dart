import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wynik filtrowania z prostą drogą powrotu do pełnej listy.
final class TaskListEmptyResult extends StatelessWidget {
  const TaskListEmptyResult({required this.hasActiveFilters, super.key});

  final bool hasActiveFilters;

  void _clearFilters(BuildContext context) =>
      unawaited(context.read<ProjectTasksListCubit>().clearFilters());

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hasActiveFilters
                ? context.l10n.tasksListEmpty
                : context.l10n.tasksListProjectEmpty,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: 12),
            TextButton(
              key: const ValueKey('task-list-empty-clear-filters'),
              onPressed: () => _clearFilters(context),
              child: Text(context.l10n.tasksListClearAllFilters),
            ),
          ],
        ],
      ),
    ),
  );
}
