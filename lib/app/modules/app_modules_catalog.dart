import 'package:flutter/material.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/core/auth/ready_permissions.dart';
import 'package:ready_next/core/config/app_api_module.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_ids.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';

/// Wewnętrzne identyfikatory modułów widocznych w shellu aplikacji.
enum AppModuleKey {
  dashboard,
  inventory,
  bhp,
  workspaces,
  orders,
  inne,
  settings,
}

/// Statyczna definicja modułu aplikacji.
class AppModuleDefinition {
  const AppModuleDefinition({
    required this.key,
    required this.routePath,
    required this.icon,
    this.apiModule,
    this.startupModule,
    this.shortcutId,
    this.requiredPermission,
    this.showInGlobalRail = false,
    this.showInStartupSelection = false,
  });

  final AppModuleKey key;
  final String routePath;
  final IconData icon;
  final AppApiModule? apiModule;
  final DashboardStartupModule? startupModule;
  final String? shortcutId;
  final String? requiredPermission;
  final bool showInGlobalRail;
  final bool showInStartupSelection;

  /// Określa, czy bieżąca sesja może korzystać z modułu.
  bool isAvailableTo(Set<String> permissions) {
    final permission = requiredPermission;
    return permission == null || permissions.contains(permission);
  }

  String label(AppLocalizations intl) {
    return switch (key) {
      AppModuleKey.dashboard => intl.globalModuleDashboard,
      AppModuleKey.inventory => intl.globalModuleInventory,
      AppModuleKey.bhp => intl.globalModuleBhp,
      AppModuleKey.workspaces => intl.globalModuleWorkspaces,
      AppModuleKey.orders => intl.globalModuleOrders,
      AppModuleKey.inne => intl.globalModuleOther,
      AppModuleKey.settings => intl.globalModuleSettings,
    };
  }

  String? startupSubtitle(AppLocalizations intl) {
    return switch (startupModule) {
      DashboardStartupModule.dashboard =>
        intl.settingsStartupModuleDashboardSubtitle,
      DashboardStartupModule.inventory =>
        intl.settingsStartupModuleInventorySubtitle,
      DashboardStartupModule.bhp => intl.settingsStartupModuleBhpSubtitle,
      DashboardStartupModule.settings =>
        intl.settingsStartupModuleSettingsSubtitle,
      null => null,
    };
  }
}

/// Jedno źródło prawdy o modułach aplikacji.
abstract final class AppModulesCatalog {
  static const modules = <AppModuleDefinition>[
    AppModuleDefinition(
      key: AppModuleKey.dashboard,
      routePath: AppRoutePaths.dashboard,
      icon: AppIcons.dashboard,
      startupModule: DashboardStartupModule.dashboard,
      showInGlobalRail: true,
      showInStartupSelection: true,
    ),
    AppModuleDefinition(
      key: AppModuleKey.inventory,
      routePath: AppRoutePaths.inventory,
      icon: AppIcons.inventory,
      apiModule: AppApiModule.inventory,
      startupModule: DashboardStartupModule.inventory,
      shortcutId: DashboardShortcutIds.inventory,
      requiredPermission: ReadyPermissions.inventory,
      showInGlobalRail: true,
      showInStartupSelection: true,
    ),
    AppModuleDefinition(
      key: AppModuleKey.bhp,
      routePath: AppRoutePaths.bhp,
      icon: AppIcons.health,
      apiModule: AppApiModule.bhp,
      startupModule: DashboardStartupModule.bhp,
      shortcutId: DashboardShortcutIds.bhp,
      requiredPermission: ReadyPermissions.bhp,
      showInGlobalRail: true,
      showInStartupSelection: true,
    ),
    AppModuleDefinition(
      key: AppModuleKey.workspaces,
      routePath: AppRoutePaths.workspaces,
      icon: AppIcons.workspaces,
      apiModule: AppApiModule.workspaces,
      showInGlobalRail: true,
    ),
    AppModuleDefinition(
      key: AppModuleKey.orders,
      routePath: AppRoutePaths.orders,
      icon: AppIcons.orders,
    ),
    AppModuleDefinition(
      key: AppModuleKey.inne,
      routePath: AppRoutePaths.inne,
      icon: AppIcons.folders,
    ),
    AppModuleDefinition(
      key: AppModuleKey.settings,
      routePath: AppRoutePaths.settings,
      icon: AppIcons.settings,
      startupModule: DashboardStartupModule.settings,
      shortcutId: DashboardShortcutIds.settings,
      showInStartupSelection: true,
    ),
  ];

  static List<AppModuleDefinition> globalRailModulesFor(
    Set<String> permissions,
  ) => [
    for (final module in modules)
      if (module.showInGlobalRail && module.isAvailableTo(permissions)) module,
  ];

  static List<AppModuleDefinition> startupModulesFor(
    Set<String> permissions,
  ) => [
    for (final module in modules)
      if (module.showInStartupSelection && module.isAvailableTo(permissions))
        module,
  ];

  static List<AppModuleDefinition> shortcutModulesFor(
    Set<String> permissions,
  ) => [
    for (final module in modules)
      if (module.shortcutId != null && module.isAvailableTo(permissions))
        module,
  ];

  static AppModuleDefinition? findByPath(String currentPath) {
    AppModuleDefinition? matched;
    for (final module in modules) {
      final route = module.routePath;
      final isMatch = currentPath == route || currentPath.startsWith('$route/');
      if (!isMatch) {
        continue;
      }
      if (matched == null || route.length > matched.routePath.length) {
        matched = module;
      }
    }
    return matched;
  }

  static AppModuleDefinition? findByStartupModule(
    DashboardStartupModule startupModule,
    Set<String> permissions,
  ) {
    for (final module in startupModulesFor(permissions)) {
      if (module.startupModule == startupModule) {
        return module;
      }
    }
    return null;
  }

  static AppModuleDefinition? findByShortcutId(
    String shortcutId,
    Set<String> permissions,
  ) {
    for (final module in shortcutModulesFor(permissions)) {
      if (module.shortcutId == shortcutId) {
        return module;
      }
    }
    return null;
  }

  static bool supportsStartupModule(
    DashboardStartupModule startupModule,
    Set<String> permissions,
  ) {
    return findByStartupModule(startupModule, permissions) != null;
  }
}
