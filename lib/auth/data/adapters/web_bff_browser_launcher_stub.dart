import 'package:devplanner/auth/data/adapters/web_bff_auth_adapter.dart';

/// Platform seam used by the standalone bootstrap.
///
/// Non-web targets do not silently emulate a browser redirect. Desktop keeps
/// its separate PKCE composition and must not accidentally use the BFF path.
final class PlatformWebBffBrowserLauncher implements WebBffBrowserLauncher {
  const PlatformWebBffBrowserLauncher();

  @override
  bool get returnsAfterNavigation => false;

  @override
  Future<void> open(Uri authorizationUri) async {
    throw StateError(
      'Webowy launcher BFF nie jest dostępny poza środowiskiem Web.',
    );
  }
}
