import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';

final class StoragePublicShareLinkPlatform {
  const StoragePublicShareLinkPlatform._();

  static Either<ApiError, String> build(String shareToken) => const Left(
    ApiError(
      type: ApiErrorType.unknown,
      message: 'Ta platforma nie obsługuje linków publicznych.',
    ),
  );
}
