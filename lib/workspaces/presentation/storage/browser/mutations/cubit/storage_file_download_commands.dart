import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';

/// Executes ticketed file and ZIP downloads without coupling transport to UI.
final class StorageFileDownloadCommands {
  const StorageFileDownloadCommands({
    required this.repository,
    required this.downloadTransport,
  });

  final StorageRepository repository;
  final DownloadTransport downloadTransport;

  Future<Either<ApiError, Unit>> downloadFile(
    StorageFileResponse file, {
    required bool Function() isCurrent,
  }) async {
    final ticketResult = await repository.getDownloadTicket(file.id);
    if (!isCurrent()) return const Right(unit);
    return ticketResult.fold<Future<Either<ApiError, Unit>>>(
      (error) async => Left(error),
      (ticket) => downloadTransport.downloadUrl(
        downloadUrl: ticket.downloadUrl,
        fileName: file.originalFileName,
      ),
    );
  }

  Future<Either<ApiError, Unit>> downloadZip({
    required List<String> fileIds,
    required String zipName,
    required bool Function() isCurrent,
  }) async {
    final zipResult = await repository.bulkDownloadZip(
      BulkDownloadZipPayload(fileIds: fileIds),
    );
    if (!isCurrent()) return const Right(unit);
    return zipResult.fold<Future<Either<ApiError, Unit>>>(
      (error) async => Left(error),
      (bytes) => downloadTransport.saveBytes(bytes: bytes, fileName: zipName),
    );
  }
}
