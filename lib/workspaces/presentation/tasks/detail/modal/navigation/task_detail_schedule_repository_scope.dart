import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Carries the schedule port through root-navigator dialogs in task details.
final class TaskDetailScheduleRepositoryScope extends InheritedTheme {
  const TaskDetailScheduleRepositoryScope({
    required this.repository,
    required super.child,
    super.key,
  });

  final TaskScheduleRepository? repository;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final value = repository;
    if (value == null) return child;
    return TaskDetailScheduleRepositoryScope(
      repository: value,
      child: RepositoryProvider<TaskScheduleRepository>.value(
        value: value,
        child: child,
      ),
    );
  }

  @override
  bool updateShouldNotify(TaskDetailScheduleRepositoryScope oldWidget) =>
      !identical(repository, oldWidget.repository);
}
