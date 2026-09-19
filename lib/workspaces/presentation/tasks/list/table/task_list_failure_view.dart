import 'dart:async';

import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Widok błędu ładowania listy zadań z przyciskiem ponowienia.
class TaskListFailureView extends StatelessWidget {
  const TaskListFailureView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: OutlinedButton.icon(
      onPressed: () => unawaited(context.read<ProjectTasksListCubit>().load()),
      icon: const Icon(Symbols.refresh_rounded),
      label: Text(message),
    ),
  );
}
