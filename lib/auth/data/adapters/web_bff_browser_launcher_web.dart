import 'package:devplanner/auth/data/adapters/web_bff_auth_adapter.dart';
import 'package:web/web.dart' as web;

/// Top-level browser navigation for the local BFF authorization flow.
///
/// The browser leaves the Flutter document and returns through the BFF
/// callback. Consequently the future reports that it does not return to the
/// current document; the next application bootstrap restores the cookie
/// session instead of attempting a synchronous `/bff/session` read.
final class PlatformWebBffBrowserLauncher implements WebBffBrowserLauncher {
  const PlatformWebBffBrowserLauncher();

  @override
  bool get returnsAfterNavigation => false;

  @override
  Future<void> open(Uri authorizationUri) async {
    web.window.location.href = authorizationUri.toString();
  }
}
