import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';

/// Session-bound Storage dependencies shared by the app router and global Chat.
///
/// API ticket/finalize calls use the session transport. Binary PUTs use a
/// separate client with only the short-lived presigned URL; it never receives
/// the BFF cookie, CSRF token, or desktop access token.
final class DevPlannerStorageComposition {
  const DevPlannerStorageComposition._({
    required this.repository,
    required this.uploadTransport,
  });

  /// Resolves Storage only when the session transport can make authenticated
  /// standalone API calls (BFF cookie/CSRF on Web, PKCE token on desktop).
  factory DevPlannerStorageComposition.resolve({
    required DevPlannerHttpTransport? transport,
    StorageRepository? explicitRepository,
  }) {
    final canUseStorage = transport?.supportsStandaloneApiClients ?? false;
    final repository =
        explicitRepository ??
        (canUseStorage
            ? StorageRepositoryImpl(
                StorageApi(
                  transport!.apiDio,
                  baseUrl: transport.baseUrl,
                ),
              )
            : null);
    return DevPlannerStorageComposition._(
      repository: repository,
      uploadTransport: canUseStorage ? PresignedUploadTransport() : null,
    );
  }

  /// Authenticated API port for tickets, completion, downloads, and ACL.
  final StorageRepository? repository;

  /// Isolated binary transfer transport for presigned object URLs.
  final UploadTransport? uploadTransport;
}
