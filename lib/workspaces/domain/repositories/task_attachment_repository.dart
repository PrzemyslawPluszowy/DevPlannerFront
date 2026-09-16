import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';

/// Odczyt i zatwierdzanie załączników należących do pojedynczego zadania.
abstract interface class TaskAttachmentRepository {
  Future<Either<ApiError, List<StorageFileResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
  });

  Future<Either<ApiError, BulkStorageUploadTicketResponse>> requestTickets({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkTaskUploadTicketPayload payload,
  });

  Future<Either<ApiError, BulkCompleteUploadResponse>> complete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkCompleteUploadPayload payload,
  });
}
