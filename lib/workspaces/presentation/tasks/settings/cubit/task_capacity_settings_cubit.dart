import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskCapacitySettingsState {
  const TaskCapacitySettingsState();
}

final class TaskCapacitySettingsInitial extends TaskCapacitySettingsState {
  const TaskCapacitySettingsInitial();
}

final class TaskCapacitySettingsLoading extends TaskCapacitySettingsState {
  const TaskCapacitySettingsLoading();
}

final class TaskCapacitySettingsFailure extends TaskCapacitySettingsState {
  const TaskCapacitySettingsFailure(this.message);

  final String message;
}

final class TaskCapacitySettingsReady extends TaskCapacitySettingsState {
  const TaskCapacitySettingsReady({
    required this.capacity,
    required this.overrides,
    this.memberProfilesByUserId = const {},
    this.isSaving = false,
    this.error,
  });

  final WorkspaceCapacityResponse capacity;
  final List<UserCapacityOverrideResponse> overrides;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final bool isSaving;
  final String? error;

  TaskCapacitySettingsReady copyWith({
    WorkspaceCapacityResponse? capacity,
    List<UserCapacityOverrideResponse>? overrides,
    Map<String, ProjectMemberProfile>? memberProfilesByUserId,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => TaskCapacitySettingsReady(
    capacity: capacity ?? this.capacity,
    overrides: overrides ?? this.overrides,
    memberProfilesByUserId:
        memberProfilesByUserId ?? this.memberProfilesByUserId,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Stan capacity workspace i wyjątków dostępności bieżącego projektu.
final class TaskCapacitySettingsCubit extends Cubit<TaskCapacitySettingsState> {
  TaskCapacitySettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    this.fromDate,
    this.toDate,
    this.memberProfilesRepository,
  }) : super(const TaskCapacitySettingsInitial());

  final TaskCapacityRepository repository;
  final String workspaceId;
  final String projectId;
  final DateTime? fromDate;
  final DateTime? toDate;
  final ProjectMemberProfilesRepository? memberProfilesRepository;

  Future<void> load() async {
    emit(const TaskCapacitySettingsLoading());
    final capacity = await repository.getWorkspaceCapacity(
      workspaceId: workspaceId,
    );
    if (isClosed) return;
    await capacity.fold(
      (error) async => emit(TaskCapacitySettingsFailure(error.message)),
      (value) async {
        final overrides = await repository.listOverrides(
          workspaceId: workspaceId,
          projectId: projectId,
          fromDate: fromDate,
          toDate: toDate,
        );
        if (isClosed) return;
        final profiles = memberProfilesRepository == null
            ? const Right<ApiError, List<ProjectMemberProfile>>([])
            : await memberProfilesRepository!.listProfiles(
                workspaceId: workspaceId,
                projectId: projectId,
              );
        if (isClosed) return;
        overrides.fold(
          (error) => emit(TaskCapacitySettingsFailure(error.message)),
          (items) => profiles.fold(
            (error) => emit(TaskCapacitySettingsFailure(error.message)),
            (members) => emit(
              TaskCapacitySettingsReady(
                capacity: value,
                overrides: _sorted(items),
                memberProfilesByUserId: {
                  for (final member in members) member.userId: member,
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> saveDefaultDailyCapacity(int minutes) async {
    final current = state;
    if (current is! TaskCapacitySettingsReady ||
        current.isSaving ||
        minutes <= 0) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.updateWorkspaceCapacity(
      workspaceId: workspaceId,
      payload: UpdateWorkspaceCapacityPayload(
        defaultDailyCapacityMinutes: minutes,
        expectedVersion: current.capacity.version,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (capacity) {
        emit(current.copyWith(capacity: capacity, isSaving: false));
        return true;
      },
    );
  }

  Future<bool> deleteOverride(UserCapacityOverrideResponse override) async {
    final current = state;
    if (current is! TaskCapacitySettingsReady || current.isSaving) return false;
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.deleteOverride(
      workspaceId: workspaceId,
      projectId: projectId,
      overrideId: override.id,
      expectedVersion: override.version,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        emit(
          current.copyWith(
            overrides: current.overrides
                .where((item) => item.id != override.id)
                .toList(),
            isSaving: false,
          ),
        );
        return true;
      },
    );
  }

  /// Dodaje okresową dostępność osoby dla bieżącego projektu.
  Future<bool> createOverride(CreateUserCapacityOverridePayload payload) async {
    final current = state;
    if (current is! TaskCapacitySettingsReady ||
        current.isSaving ||
        payload.endDate.isBefore(payload.startDate) ||
        payload.availableMinutesPerDay < 0) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.createOverride(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: payload,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (override) {
        emit(
          current.copyWith(
            overrides: _sorted([...current.overrides, override]),
            isSaving: false,
          ),
        );
        return true;
      },
    );
  }

  /// Aktualizuje okresową dostępność z ochroną wersji po stronie backendu.
  Future<bool> updateOverride(
    UserCapacityOverrideResponse override,
    UpdateUserCapacityOverridePayload payload,
  ) async {
    final current = state;
    if (current is! TaskCapacitySettingsReady ||
        current.isSaving ||
        payload.endDate.isBefore(payload.startDate) ||
        payload.availableMinutesPerDay < 0) {
      return false;
    }
    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.updateOverride(
      workspaceId: workspaceId,
      projectId: projectId,
      overrideId: override.id,
      payload: payload,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (updated) {
        emit(
          current.copyWith(
            overrides: _sorted([
              for (final item in current.overrides)
                if (item.id == updated.id) updated else item,
            ]),
            isSaving: false,
          ),
        );
        return true;
      },
    );
  }

  static List<UserCapacityOverrideResponse> _sorted(
    List<UserCapacityOverrideResponse> values,
  ) =>
      [...values]
        ..sort((left, right) => left.startDate.compareTo(right.startDate));
}
