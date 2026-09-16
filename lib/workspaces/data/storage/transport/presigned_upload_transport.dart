import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/transport/storage_upload_body.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:ready_next/workspaces/domain/storage/ports/upload_transport.dart';

/// Implementacja [UploadTransport] realizująca binarny transfer PUT na presigned URL.
final class PresignedUploadTransport implements UploadTransport {
  /// Tworzy transport uploadu z opcjonalnym, dedykowanym klientem Dio.
  PresignedUploadTransport({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(validateStatus: _isSuccessful));

  final Dio _dio;

  static bool _isSuccessful(int? status) =>
      status != null && status >= 200 && status < 300;

  @override
  Future<Either<ApiError, Unit>> upload({
    required StorageUploadTicketResponse ticket,
    required StorageUploadInput input,
    OnStorageUploadProgress? onProgress,
    CancelToken? cancelToken,
  }) async {
    if (ticket.isAlreadyUploaded) {
      onProgress?.call(input.size, input.size);
      return const Right(unit);
    }

    try {
      final response = await _dio.put<void>(
        ticket.uploadUrl,
        data: StorageUploadBody.create(input),
        cancelToken: cancelToken,
        onSendProgress: (sent, total) {
          final effectiveTotal = total > 0 ? total : input.size;
          onProgress?.call(sent, effectiveTotal);
        },
        options: Options(
          contentType: input.mimeType ?? 'application/octet-stream',
          headers: {'content-length': input.size},
        ),
      );

      if (!_isSuccessful(response.statusCode)) {
        return const Left(
          ApiError(
            type: ApiErrorType.badResponse,
            message: 'Serwer magazynu odrzucił przesyłany plik.',
          ),
        );
      }

      onProgress?.call(input.size, input.size);
      return const Right(unit);
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        return const Left(
          ApiError(
            type: ApiErrorType.canceled,
            message: 'Wysyłanie pliku zostało anulowane.',
          ),
        );
      }
      return Left(
        ApiError.fromDioException(
          error,
          fallbackMessage: 'Nie udało się przesłać pliku do magazynu.',
        ),
      );
    } on Object {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Wystąpił nieoczekiwany błąd podczas wysyłki pliku.',
        ),
      );
    }
  }
}
