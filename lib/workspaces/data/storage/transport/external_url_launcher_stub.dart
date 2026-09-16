import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';

/// Fallback dla nieobsługiwanej platformy.
final class StorageExternalUrlPlatform {
  const StorageExternalUrlPlatform._();

  static Future<Either<ApiError, Unit>> open(String url) async => const Left(
    ApiError(
      type: ApiErrorType.unknown,
      message: 'Otwieranie podglądu nie jest dostępne na tej platformie.',
    ),
  );
}
