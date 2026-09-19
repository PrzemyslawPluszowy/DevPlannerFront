import 'package:dartz/dartz.dart';
import 'package:devplanner/core/data/api_repository.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/api/task_advanced_api.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/domain/repositories/task_history_repository.dart';

/// Implementacja odczytu historii z endpointów zaawansowanych Tasks.
final class TaskHistoryRepositoryImpl extends ApiRepository
    implements TaskHistoryRepository {
  TaskHistoryRepositoryImpl(this._api);
  final TaskAdvancedApi _api;

  @override
  Future<Either<ApiError, CursorPageResponse<TaskHistoryEventResponse>>>
  listHistory({
    required String workspaceId,
    required String projectId,
    required String taskId,
    String? cursor,
  }) => guardApiCall(
    () => _api.listHistory(workspaceId, projectId, taskId, cursor: cursor),
    fallbackMessage: 'Nie udało się pobrać historii zadania.',
  );
}
