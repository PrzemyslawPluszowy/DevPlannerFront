import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Presentation-only navigation port for the standalone router.
///
/// Widgets depend on this small contract instead of the router composition
/// root. Route construction remains owned by [DevPlannerRouteCatalog].
class DevPlannerNavigation {
  const DevPlannerNavigation(this.router);

  factory DevPlannerNavigation.of(BuildContext context) =>
      DevPlannerNavigation(GoRouter.of(context));

  final GoRouter router;

  String get currentPath =>
      router.routerDelegate.currentConfiguration.uri.toString();

  Future<void> go(String path) async {
    router.go(path);
  }

  /// Navigates only to a relative route owned by the standalone app.
  /// External URLs and malformed paths are ignored at the presentation edge.
  Future<bool> goDeepLink(String? rawValue) async {
    final value = rawValue?.trim() ?? '';
    final uri = Uri.tryParse(value);
    if (uri == null ||
        uri.hasScheme ||
        uri.hasAuthority ||
        !value.startsWith('/')) {
      return false;
    }
    if (!DevPlannerRouteCatalog.isStandalonePath(uri.path)) return false;
    await go(uri.toString());
    return true;
  }

  Future<T?> push<T extends Object?>(String path, {Object? extra}) =>
      router.push<T>(path, extra: extra);

  Future<bool> maybePop<T extends Object?>([T? result]) async {
    if (!router.canPop()) return false;
    router.pop(result);
    return true;
  }

  void pop<T extends Object?>([T? result]) => router.pop(result);
}

extension DevPlannerNavigationBuildContext on BuildContext {
  DevPlannerNavigation get plannerNavigation => DevPlannerNavigation.of(this);
}
