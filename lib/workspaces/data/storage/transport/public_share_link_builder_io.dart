import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/config/app_env.dart';
import 'package:devplanner/foundation/error/error.dart';

/// Desktop link builder using an explicit public Web application address.
final class StoragePublicShareLinkPlatform {
  const StoragePublicShareLinkPlatform._();

  static const _publicAppBaseUrl = String.fromEnvironment(
    'PUBLIC_APP_BASE_URL',
  );

  static Either<ApiError, String> build(String shareToken) {
    final configured = _publicAppBaseUrl.trim();
    final base = Uri.tryParse(
      configured.isEmpty ? AppEnv.apiBaseUrl : configured,
    );
    if (base == null || !base.hasScheme || base.host.isEmpty) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Nie udało się ustalić publicznego adresu aplikacji. Skonfiguruj PUBLIC_APP_BASE_URL.',
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
