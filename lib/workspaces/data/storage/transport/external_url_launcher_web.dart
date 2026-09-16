import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:web/web.dart' as web;

/// Otwieranie podglądu w nowej karcie Web/Wasm.
final class StorageExternalUrlPlatform {
  const StorageExternalUrlPlatform._();

  static Future<Either<ApiError, Unit>> open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Nieprawidłowy adres podglądu.',
        ),
      );
    }
    if (web.window.open(uri.toString(), '_blank') == null) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Przeglądarka zablokowała okno podglądu.',
        ),
      );
    }
    return const Right(unit);
  }
}
