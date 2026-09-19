import 'package:devplanner/auth/data/adapters/web_bff_browser_launcher.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';

/// Builds the only production Web auth composition.
///
/// Keeping this seam in the bootstrap layer makes the browser boundary
/// explicit and prevents presentation code from constructing a transport or
/// inventing an authentication fallback.
final class DevPlannerWebBffBootstrap {
  const DevPlannerWebBffBootstrap();

  AuthComposition compose(DevPlannerHttpTransport transport) {
    if (!transport.isBffCookieTransport) {
      throw StateError(
        'Webowy BFF bootstrap wymaga transportu cookie bez Bearera.',
      );
    }
    return AuthComposition.webBff(
      httpTransport: transport,
      browserLauncher: const PlatformWebBffBrowserLauncher(),
    );
  }
}
