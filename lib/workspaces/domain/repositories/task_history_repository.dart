import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';

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
