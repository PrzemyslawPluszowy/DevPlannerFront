import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';

/// Udostępnia konfigurację i bezpieczne operacje harmonogramu projektu.
abstract interface class TaskScheduleRepository {
  /// Pobiera bieżący tryb automatycznego harmonogramu.
  Future<Either<ApiError, ProjectScheduleSettingsResponse>> getSettings({
    required String workspaceId,
    required String projectId,
  });

  /// Symuluje kaskadowe przesunięcie terminów bez zapisu zmian.
  Future<Either<ApiError, ScheduleCascadeResponse>> previewCascade({
    required String workspaceId,
    required String projectId,
    required PreviewScheduleCascadePayload payload,
  });

  /// Zapisuje zaakceptowaną kaskadę z wersjami wszystkich modyfikowanych zadań.
  Future<Either<ApiError, ScheduleCascadeResponse>> applyCascade({
    required String workspaceId,
    required String projectId,
    required ApplyScheduleCascadePayload payload,
  });

  /// Zapisuje tryb automatycznego harmonogramu.
  Future<Either<ApiError, Unit>> setMode({
    required String workspaceId,
    required String projectId,
    required AutoScheduleMode mode,
  });

  /// Pobiera dni wolne wykorzystywane przez harmonogram projektu.
  Future<Either<ApiError, List<WorkspaceHolidayResponse>>> listHolidays({
    required String workspaceId,
    required String projectId,
  });

  /// Dodaje dzień wolny do kalendarza workspace'u.
  Future<Either<ApiError, WorkspaceHolidayResponse>> addHoliday({
    required String workspaceId,
    required String projectId,
    required DateTime date,
    required String name,
  });

  /// Usuwa dzień wolny z kalendarza workspace'u.
  Future<Either<ApiError, Unit>> deleteHoliday({
    required String workspaceId,
    required String projectId,
    required String holidayId,
  });
}
