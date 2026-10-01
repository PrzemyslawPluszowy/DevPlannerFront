import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskMemberProfilesState {
  const TaskMemberProfilesState();
}

final class TaskMemberProfilesLoading extends TaskMemberProfilesState {
  const TaskMemberProfilesLoading();
}

final class TaskMemberProfilesReady extends TaskMemberProfilesState {
  TaskMemberProfilesReady(List<ProjectMemberProfile> profiles)
    : profiles = List.unmodifiable(profiles);

  final List<ProjectMemberProfile> profiles;
}

final class TaskMemberProfilesFailure extends TaskMemberProfilesState {
  const TaskMemberProfilesFailure(this.error);

  final ApiError error;
}

/// Owns the project member lookup used by nested task editor dialogs.
final class TaskMemberProfilesCubit extends Cubit<TaskMemberProfilesState> {
  TaskMemberProfilesCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskMemberProfilesLoading());

  final ProjectMemberProfilesRepository repository;
  final String workspaceId;
  final String projectId;
  int _generation = 0;

  Future<void> load() async {
    if (isClosed) return;
    final generation = ++_generation;
    emit(const TaskMemberProfilesLoading());
    final result = await repository.listProfiles(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed || generation != _generation) return;
    result.fold(
      (error) => emit(TaskMemberProfilesFailure(error)),
      (profiles) => emit(TaskMemberProfilesReady(profiles)),
    );
  }

  @override
  Future<void> close() {
    _generation++;
    return super.close();
  }
}
