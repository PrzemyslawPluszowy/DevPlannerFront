import 'package:devplanner/app/devplanner_app.dart';
import 'package:devplanner/auth/data/adapters/desktop_pkce_session_transport.dart';
import 'package:devplanner/auth/data/adapters/secure_refresh_token_vault.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/bootstrap/host_launch_context.dart';
import 'package:devplanner/bootstrap/web_bff_bootstrap.dart';
import 'package:devplanner/foundation/config/app_env.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Minimal standalone bootstrap.
Future<void> bootstrap({
  AuthComposition? auth,
  DevPlannerHttpTransport? httpTransport,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Launch state is intentionally local to DevPlanner. The old embedded-host
  // bridge and its token hand-off are not part of the standalone runtime.
  final resolvedTransport =
      httpTransport ??
      (kIsWeb
          ? DevPlannerHttpTransport(
              baseUrl: AppEnv.apiBaseUrl,
              isWeb: true,
            )
          : null);
  final desktopTransport = !kIsWeb
      // IO implementation owns Dio and cannot be const; web stub remains const.
      // ignore: prefer_const_constructors
      ? PlatformDesktopPkceSessionTransport(baseUrl: AppEnv.apiBaseUrl)
      : null;
  final desktopVault = desktopTransport == null
      ? null
      : PlatformSecureRefreshTokenVault();
  final resolvedAuth =
      auth ??
      (kIsWeb && resolvedTransport != null
          ? const DevPlannerWebBffBootstrap().compose(resolvedTransport)
          : desktopTransport != null
          ? AuthComposition.desktopPkce(
              transport: desktopTransport,
              vault: desktopVault,
            )
          : null);
  final nativeTransport = desktopTransport == null
      ? null
      : DevPlannerHttpTransport(
          baseUrl: AppEnv.apiBaseUrl,
          tokenProvider: resolvedAuth?.desktopAccessTokenProvider,
          unauthorizedRecovery: resolvedAuth?.desktopUnauthorizedRecovery,
          isWeb: false,
        );
  final effectiveTransport = resolvedTransport ?? nativeTransport;
  if (auth == null && resolvedAuth != null) {
    try {
      await resolvedAuth.useCases.restoreSession();
    } on Object catch (error, stackTrace) {
      // Startup must never leave a native window without a widget tree. The
      // session is intentionally fail-closed, while the original failure is
      // still reported for diagnostics instead of silently ignored.
      resolvedAuth.session.setSignedOut(
        message: 'Nie udało się przywrócić sesji. Zaloguj się ponownie.',
      );
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'DevPlanner bootstrap',
          context: ErrorDescription('podczas przywracania sesji desktopowej'),
        ),
      );
    }
  }
  runApp(
    DevPlannerApp(
      launchContext: const HostLaunchContext(
        initialRoute: '/workspaces',
        userId: null,
        userDisplayName: null,
      ),
      auth: resolvedAuth,
      httpTransport: effectiveTransport,
    ),
  );
}
