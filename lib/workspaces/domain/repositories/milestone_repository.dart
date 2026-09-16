import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/milestones/models/milestone_models.dart';

/// Operacje na kamieniach milowych projektu i przypisaniach zadań.
abstract interface class MilestoneRepository {
  /// Pobiera aktywne kamienie milowe wraz z postępem wyliczonym przez backend.
  Future<Either<ApiError, List<MilestoneResponse>>> listMilestones({
    required String workspaceId,
    required String projectId,
  });

  /// Pobiera szczegóły pojedynczego kamienia milowego.
  Future<Either<ApiError, MilestoneResponse>> getMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  });

  /// Tworzy kamień milowy projektu.
  Future<Either<ApiError, MilestoneResponse>> createMilestone({
    required String workspaceId,
    required String projectId,
    required CreateMilestonePayload payload,
  });

  /// Aktualizuje nazwę, opis, termin i status kamienia milowego.
  Future<Either<ApiError, MilestoneResponse>> updateMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required UpdateMilestonePayload payload,
  });

  /// Usuwa kamień milowy, jeśli backend dopuści tę operację.
  Future<Either<ApiError, Unit>> deleteMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  });

  /// Pobiera zadania aktualnie przypisane do kamienia milowego.
  Future<Either<ApiError, List<MilestoneTaskResponse>>> listTasks({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  });

  /// Przypisuje zadanie do kamienia milowego.
  Future<Either<ApiError, Unit>> assignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  });

  /// Usuwa przypisanie zadania z kamienia milowego.
  Future<Either<ApiError, Unit>> unassignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  });
}
