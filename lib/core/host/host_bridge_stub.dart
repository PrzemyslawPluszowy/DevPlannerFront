import 'package:devplanner/bootstrap/host_launch_context.dart';
import 'package:devplanner/core/host/host_bridge.dart';

HostBridge createHostBridge() => const StubHostBridge();

/// Prosta implementacja zapasowa dla platform innych niz web.
///
/// Dzięki temu aplikacja moze sie uruchomic lokalnie bez hosta i bez
/// przegladarkowego mostu komunikacyjnego.
class StubHostBridge implements HostBridge {
  const StubHostBridge();

  @override
  Future<HostLaunchContext> getLaunchContext() async {
    return const HostLaunchContext(
      initialRoute: '/workspaces',
      userId: null,
      userDisplayName: null,
    );
  }

  @override
  Future<String?> refreshAccessToken() async => null;
}
