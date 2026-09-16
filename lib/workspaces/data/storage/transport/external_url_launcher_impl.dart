import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/storage/transport/external_url_launcher_stub.dart'
    if (dart.library.js_interop) 'package:ready_next/workspaces/data/storage/transport/external_url_launcher_web.dart'
    if (dart.library.io) 'package:ready_next/workspaces/data/storage/transport/external_url_launcher_io.dart'
    as platform;
import 'package:ready_next/workspaces/domain/storage/ports/external_url_launcher.dart';

/// Wieloplatformowa implementacja otwierania bezpiecznych URL-i.
final class ExternalUrlLauncherImpl implements ExternalUrlLauncher {
  /// Tworzy bezstanowy launcher.
  const ExternalUrlLauncherImpl();

  @override
  Future<Either<ApiError, Unit>> open(String url) =>
      platform.StorageExternalUrlPlatform.open(url);
}
