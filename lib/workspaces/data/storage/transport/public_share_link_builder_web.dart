import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';

/// Web/Wasm link builder based on the current application origin.
final class StoragePublicShareLinkPlatform {
  const StoragePublicShareLinkPlatform._();

  static Either<ApiError, String> build(String shareToken) {
    final url = Uri.base.replace(
      path: '/storage/public/${Uri.encodeComponent(shareToken)}',
    );
    return Right(url.toString());
  }
}
