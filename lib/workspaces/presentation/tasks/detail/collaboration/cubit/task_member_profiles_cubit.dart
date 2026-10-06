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
  TaskMemberProfilesReady(
    List<ProjectMemberProfile> profiles, {
    this.query = '',
    this.totalCount = 0,
  }) : profiles = List.unmodifiable(profiles),
       visibleUserIds = Set.unmodifiable(
         profiles.map((profile) => profile.userId),
       );

  final List<ProjectMemberProfile> profiles;
  final Set<String> visibleUserIds;
  final String query;
  final int totalCount;
}

final class TaskMemberProfilesFailure extends TaskMemberProfilesState {
  const TaskMemberProfilesFailure(this.error);

  final ApiError error;
}

/// Zarządza katalogiem i filtrem osób dla edytorów zadania.
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
  List<ProjectMemberProfile> _allProfiles = const [];
  String _query = '';
  void search(String query) {
    if (isClosed) return;
    _query = query;
    if (state is TaskMemberProfilesReady) _emitFiltered();
  }

  void _emitFiltered() {
    final needle = _query.trim().toLowerCase();
    final filtered = needle.isEmpty
        ? _allProfiles
        : _allProfiles
              .where(
                (profile) =>
                    (profile.displayName ?? '').toLowerCase().contains(needle),
              )
              .toList(growable: false);
    emit(
      TaskMemberProfilesReady(
        filtered,
        query: _query,
        totalCount: _allProfiles.length,
      ),
    );
  }

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
      (profiles) {
        _allProfiles = List.unmodifiable(profiles);
        _emitFiltered();
      },
    );
  }

  @override
  Future<void> close() {
    _generation++;
    return super.close();
  }
}
