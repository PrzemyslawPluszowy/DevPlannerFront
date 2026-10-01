import 'package:devplanner/foundation/error/api_error.dart';
import 'package:dio/dio.dart';

/// Converts adapter throws to safe, typed errors for task-detail Cubits.
final class TaskDetailOperationErrorNormalizer {
  const TaskDetailOperationErrorNormalizer._();

  static ApiError fromThrown(
    Object error, {
    required String fallbackMessage,
    String? unknownApiCode,
  }) {
    if (error is ApiError) return error;
    if (error is! DioException) {
      return ApiError(
        type: ApiErrorType.unknown,
        message: '',
        apiCode: unknownApiCode,
      );
    }
    final normalized = ApiError.fromDioException(
      error,
      fallbackMessage: fallbackMessage,
    );
    if (error.type != DioExceptionType.unknown || error.response != null) {
      return normalized;
    }
    return ApiError(
      type: normalized.type,
      message: '',
      statusCode: normalized.statusCode,
      backendCode: normalized.backendCode,
      apiCode: normalized.apiCode ?? unknownApiCode,
      contractCode: normalized.contractCode,
      fields: normalized.fields,
      traceId: normalized.traceId,
      retryAfterUtc: normalized.retryAfterUtc,
    );
  }
}
