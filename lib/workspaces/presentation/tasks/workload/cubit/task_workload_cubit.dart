import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_capacity_repository.dart';

sealed class TaskWorkloadState {
  const TaskWorkloadState();
}

final class TaskWorkloadLoading extends TaskWorkloadState {
  const TaskWorkloadLoading();
}

final class TaskWorkloadFailure extends TaskWorkloadState {
  const TaskWorkloadFailure(this.message);
  final String message;
}

final class TaskWorkloadReady extends TaskWorkloadState {
  const TaskWorkloadReady({
    required this.workload,
    required this.profilesByCoreUserId,
    required this.fromDate,
    required this.toDate,
  });

  final TaskWorkloadResponse workload;
  final Map<String, ProjectMemberProfile> profilesByCoreUserId;
  final DateTime fromDate;
  final DateTime toDate;
}

/// Ładuje obciążenie zespołu dla wybranego zakresu wraz z bezpiecznymi profilami.
final class TaskWorkloadCubit extends Cubit<TaskWorkloadState> {
  TaskWorkloadCubit({
    required this.repository,
    required this.memberProfilesRepository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskWorkloadLoading());

  final TaskCapacityRepository repository;
  final ProjectMemberProfilesRepository memberProfilesRepository;
  final String workspaceId;
  final String projectId;

  Future<void> load({DateTime? fromDate, DateTime? toDate}) async {
    final today = DateTime.now();
    final from = fromDate ?? DateTime(today.year, today.month);
    final to = toDate ?? DateTime(today.year, today.month + 1, 0);
    if (to.isBefore(from)) return;
    emit(const TaskWorkloadLoading());
    final workload = await repository.getWorkload(
      workspaceId: workspaceId,
      projectId: projectId,
      fromDate: from,
      toDate: to,
    );
    if (isClosed) return;
    workload.fold(
      (error) => emit(TaskWorkloadFailure(error.message)),
      (data) => _loadProfiles(data, from, to),
    );
  }

  Future<void> _loadProfiles(
    TaskWorkloadResponse workload,
    DateTime from,
    DateTime to,
  ) async {
    final profiles = await memberProfilesRepository.listProfiles(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    profiles.fold(
      (error) => emit(TaskWorkloadFailure(error.message)),
      (members) => emit(
        TaskWorkloadReady(
          workload: workload,
          profilesByCoreUserId: {
            for (final member in members) member.coreUserId: member,
          },
          fromDate: from,
          toDate: to,
        ),
      ),
    );
  }
}
