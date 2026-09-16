import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';

/// Desktop link builder using an explicit public Web application address.
final class StoragePublicShareLinkPlatform {
  const StoragePublicShareLinkPlatform._();

  static const _publicAppBaseUrl = String.fromEnvironment(
    'PUBLIC_APP_BASE_URL',
  );

  static Either<ApiError, String> build(String shareToken) {
    final base = Uri.tryParse(_publicAppBaseUrl.trim());
    if (base == null || !base.hasScheme || base.host.isEmpty) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Desktop wymaga konfiguracji PUBLIC_APP_BASE_URL do tworzenia linków publicznych.',
        ),
      );
    }
    return Right(
      base
          .replace(
            path: '/storage/public/${Uri.encodeComponent(shareToken)}',
          )
          .toString(),
    );
  }
}
