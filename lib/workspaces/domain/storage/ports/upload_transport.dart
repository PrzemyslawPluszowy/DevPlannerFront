import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';

/// Callback raportujący postęp wysyłki pojedynczego pliku.
typedef OnStorageUploadProgress = void Function(int sentBytes, int totalBytes);

/// Abstrakcja transportu binarnych danych do S3/MinIO przez bilet presigned URL.
// ignore: one_member_abstracts
abstract interface class UploadTransport {
  /// Wysyła zawartość pliku do S3/MinIO z raportowaniem postępu i możliwością anulowania.
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required StorageUploadInput input,
    OnStorageUploadProgress? onProgress,
    CancelToken? cancelToken,
  });
}
