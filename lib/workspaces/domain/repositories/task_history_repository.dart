import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';

/// Cursorowy odczyt historii biznesowej zadania.
// ignore: one_member_abstracts
abstract interface class TaskHistoryRepository {
  Future<Either<ApiError, CursorPageResponse<TaskHistoryEventResponse>>>
  listHistory({
    required String workspaceId,
    required String projectId,
    required String taskId,
    String? cursor,
  });
}
