import 'package:devplanner/foundation/error/api_error.dart';
import 'package:dio/dio.dart';

/// Normalizuje odpowiedzi wyrzucone przez adaptery w task-board commands.
final class TasksBoardApiErrorNormalizer {
  const TasksBoardApiErrorNormalizer._();

  static const columnPageFallbackMessage = 'Tasks could not be loaded.';

  static ApiError fromThrown(
    Object error, {
    required String fallbackMessage,
  }) => switch (error) {
    final ApiError apiError => apiError,
    final DioException dioError => ApiError.fromDioException(
      dioError,
      fallbackMessage: fallbackMessage,
    ),
    _ => ApiError(type: ApiErrorType.unknown, message: fallbackMessage),
  };
}
