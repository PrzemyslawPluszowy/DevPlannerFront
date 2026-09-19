import 'package:devplanner/bootstrap/host_launch_context.dart';

/// Optional platform boundary retained for future native integrations.
///
/// The standalone web application does not use an embedded host or accept
/// session/token hand-off from another application.
abstract class HostBridge {
  /// Returns local launch data for a platform integration.
  Future<HostLaunchContext> getLaunchContext();

  /// Refresh is intentionally unavailable until a standalone auth contract
  /// is introduced.
  Future<String?> refreshAccessToken();
}
