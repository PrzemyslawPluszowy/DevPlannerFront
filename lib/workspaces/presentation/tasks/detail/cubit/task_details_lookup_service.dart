import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';

/// Lookup zachowuje błąd i nie uruchamia I/O po zamknięciu sesji.
final class TaskDetailsLookupService {
  const TaskDetailsLookupService({required this.isClosed});

  final bool Function() isClosed;

  Future<Either<ApiError, T>> run<T>(
    Future<Either<ApiError, T>> Function()? operation, {
    required String unavailableCode,
  }) async {
    if (isClosed()) return const Left(_canceled);
    if (operation == null) {
      return Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Ta funkcja zadania jest niedostępna.',
          apiCode: unavailableCode,
        ),
      );
    }
    final result = await operation();
    return isClosed() ? const Left(_canceled) : result;
  }

  static const _canceled = ApiError(
    type: ApiErrorType.canceled,
    message: 'Sesja zadania została zamknięta.',
  );
}
