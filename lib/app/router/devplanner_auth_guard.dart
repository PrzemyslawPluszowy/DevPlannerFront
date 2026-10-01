import 'package:devplanner/app/router/devplanner_route_catalog.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';

/// Central auth boundary for paths owned by the standalone application.
final class DevPlannerAuthGuard {
  const DevPlannerAuthGuard({required this.session});

  final AuthSessionPort session;

  String? redirectFor(Uri location) {
    if (DevPlannerRouteCatalog.isPublicSharePath(location.path)) return null;
    final isAuthRoute = DevPlannerRouteCatalog.authPaths.contains(
      location.path,
    );
    if (location.path == '/') return null;
    if (isAuthRoute && !session.snapshot.isAuthenticated) return null;
    if (isAuthRoute && location.path == '/login') {
      return AuthReturnTo.sanitize(location.queryParameters['returnTo']) ??
          '/workspaces';
    }
    if (session.snapshot.isAuthenticated &&
        DevPlannerRouteCatalog.isStandalonePath(location.path)) {
      return null;
    }

    final returnTo = Uri(
      path: location.path,
      query: location.query.isEmpty ? null : location.query,
      fragment: location.fragment.isEmpty ? null : location.fragment,
    ).toString();
    return '/login?returnTo=${Uri.encodeComponent(returnTo)}';
  }
}
