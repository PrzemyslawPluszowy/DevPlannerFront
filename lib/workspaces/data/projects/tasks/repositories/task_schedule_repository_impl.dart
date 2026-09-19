import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_schedule_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';

/// Adapter API dla konfiguracji harmonogramu projektu.
final class TaskScheduleRepositoryImpl extends ApiRepository
    implements TaskScheduleRepository {
  /// Tworzy repozytorium oparte o uwierzytelniony klient Workspaces.
  TaskScheduleRepositoryImpl(this._api);

  final TaskScheduleApi _api;

  @override
  Future<Either<ApiError, ProjectScheduleSettingsResponse>> getSettings({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.getSettings(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać ustawień harmonogramu.',
    parsingMessage: 'Backend zwrócił nieprawidłowe ustawienia harmonogramu.',
  );

  @override
  Future<Either<ApiError, ScheduleCascadeResponse>> previewCascade({
    required String workspaceId,
    required String projectId,
    required PreviewScheduleCascadePayload payload,
  }) => guardApiCall(
    () => _api.previewCascade(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się przygotować podglądu kaskady terminów.',
    parsingMessage: 'Backend zwrócił nieprawidłowy podgląd kaskady terminów.',
  );

  @override
  Future<Either<ApiError, ScheduleCascadeResponse>> applyCascade({
    required String workspaceId,
    required String projectId,
    required ApplyScheduleCascadePayload payload,
  }) => guardApiCall(
    () => _api.applyCascade(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się zastosować kaskady terminów.',
    parsingMessage: 'Backend zwrócił nieprawidłowy wynik kaskady terminów.',
  );

  @override
  Future<Either<ApiError, Unit>> setMode({
    required String workspaceId,
    required String projectId,
    required AutoScheduleMode mode,
  }) => guardApiCall(
    () async {
      await _api.setScheduleMode(
        workspaceId,
        projectId,
        SetScheduleModePayload(mode: mode),
      );
      return unit;
    },
    fallbackMessage: 'Nie udało się zapisać trybu harmonogramu.',
    parsingMessage: 'Backend zwrócił nieprawidłową odpowiedź harmonogramu.',
  );

  @override
  Future<Either<ApiError, List<WorkspaceHolidayResponse>>> listHolidays({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listHolidays(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać dni wolnych.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę dni wolnych.',
  );

  @override
  Future<Either<ApiError, WorkspaceHolidayResponse>> addHoliday({
    required String workspaceId,
    required String projectId,
    required DateTime date,
    required String name,
  }) => guardApiCall(
    () => _api.addHoliday(
      workspaceId,
      projectId,
      CreateWorkspaceHolidayPayload(date: date, name: name),
    ),
    fallbackMessage: 'Nie udało się dodać dnia wolnego.',
    parsingMessage: 'Backend zwrócił nieprawidłowy dzień wolny.',
  );

  @override
  Future<Either<ApiError, Unit>> deleteHoliday({
    required String workspaceId,
    required String projectId,
    required String holidayId,
  }) => guardApiCall(
    () async {
      await _api.deleteHoliday(workspaceId, projectId, holidayId);
      return unit;
    },
    fallbackMessage: 'Nie udało się usunąć dnia wolnego.',
    parsingMessage:
        'Backend zwrócił nieprawidłową odpowiedź usuwania dnia wolnego.',
  );
}
