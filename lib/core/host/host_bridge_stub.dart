import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/bootstrap/host_launch_context.dart';
import 'package:ready_next/core/host/host_bridge.dart';

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
      initialRoute: AppRoutePaths.dashboard,
      userId: null,
      userDisplayName: null,
    );
  }

  @override
  Future<String?> refreshAccessToken() async => null;
}
