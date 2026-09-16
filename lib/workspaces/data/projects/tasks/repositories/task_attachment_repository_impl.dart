import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_attachment_repository.dart';

/// Adapter endpointów listy i bulk-complete załączników zadania.
final class TaskAttachmentRepositoryImpl extends ApiRepository
    implements TaskAttachmentRepository {
  TaskAttachmentRepositoryImpl(this._api);

  final TaskOperationsApi _api;

  @override
  Future<Either<ApiError, List<StorageFileResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => guardApiCall(
    () => _api.listTaskAttachments(workspaceId, projectId, taskId),
    fallbackMessage: 'Nie udało się pobrać załączników zadania.',
  );

  @override
  Future<Either<ApiError, BulkStorageUploadTicketResponse>> requestTickets({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkTaskUploadTicketPayload payload,
  }) => guardApiCall(
    () => _api.requestBulkAttachmentTickets(
      workspaceId,
      projectId,
      taskId,
      payload,
    ),
    fallbackMessage: 'Nie udało się przygotować uploadu załączników.',
  );

  @override
  Future<Either<ApiError, BulkCompleteUploadResponse>> complete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkCompleteUploadPayload payload,
  }) => guardApiCall(
    () => _api.completeBulkAttachments(
      workspaceId,
      projectId,
      taskId,
      payload,
    ),
    fallbackMessage: 'Nie udało się zatwierdzić załączników zadania.',
  );
}
