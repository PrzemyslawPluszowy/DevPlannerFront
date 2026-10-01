import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Carries the board-owned member-profile port through root-navigator dialogs.
final class TaskDetailMemberProfilesScope extends InheritedTheme {
  const TaskDetailMemberProfilesScope({
    required this.repository,
    required super.child,
    super.key,
  });

  final ProjectMemberProfilesRepository? repository;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final value = repository;
    if (value == null) return child;
    return TaskDetailMemberProfilesScope(
      repository: value,
      child: RepositoryProvider<ProjectMemberProfilesRepository>.value(
        value: value,
        child: child,
      ),
    );
  }

  @override
  bool updateShouldNotify(TaskDetailMemberProfilesScope oldWidget) =>
      !identical(repository, oldWidget.repository);
}
