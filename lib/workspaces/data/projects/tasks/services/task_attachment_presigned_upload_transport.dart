import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:dio/dio.dart';

/// Minimalny klient PUT dla presigned URL, bez tokenów aplikacji i bez logowania URL.
final class TaskAttachmentPresignedUploadTransport
    implements TaskAttachmentUploadTransport {
  TaskAttachmentPresignedUploadTransport({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(validateStatus: _isSuccessful));

  final Dio _dio;

  static bool _isSuccessful(int? status) =>
      status != null && status >= 200 && status < 300;

  @override
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required Uint8List bytes,
    String? mimeType,
    OnStorageUploadProgress? onProgress,
    UploadCancellationToken? cancelToken,
  }) async {
    if (ticket.isAlreadyUploaded) {
      onProgress?.call(bytes.length, bytes.length);
      return const Right(unit);
    }
    final dioCancelToken = CancelToken();
    void cancelDioRequest() => dioCancelToken.cancel();
    cancelToken?.addListener(cancelDioRequest);
    try {
      final response = await _dio.put<void>(
        ticket.uploadUrl,
        data: Stream.fromIterable([bytes]),
        cancelToken: dioCancelToken,
        onSendProgress: (sent, total) {
          onProgress?.call(sent, total > 0 ? total : bytes.length);
        },
        options: Options(
          contentType: mimeType ?? 'application/octet-stream',
          headers: {'content-length': bytes.length},
        ),
      );
      if (!_isSuccessful(response.statusCode)) {
        return const Left(
          ApiError(
            type: ApiErrorType.badResponse,
            message: 'Serwer plików odrzucił wysyłany załącznik.',
          ),
        );
      }
      onProgress?.call(bytes.length, bytes.length);
      return const Right(unit);
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        return const Left(
          ApiError(
            type: ApiErrorType.canceled,
            message: 'Wysyłanie załącznika zostało anulowane.',
          ),
        );
      }
      return Left(
        ApiError.fromDioException(
          error,
          fallbackMessage: 'Nie udało się wysłać załącznika.',
        ),
      );
    } on Object {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Nie udało się wysłać załącznika.',
        ),
      );
    } finally {
      cancelToken?.removeListener(cancelDioRequest);
    }
  }
}
