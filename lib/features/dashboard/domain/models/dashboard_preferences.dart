import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_ids.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';

part 'dashboard_preferences.freezed.dart';
part 'dashboard_preferences.g.dart';

/// Dostepne moduły, do których dashboard może przekierować po zalogowaniu.
enum DashboardStartupModule {
  /// Pozostawia użytkownika na dashboardzie.
  dashboard,

  /// Otwiera moduł inwentaryzacji.
  inventory,

  /// Otwiera moduł BHP.
  bhp,

  /// Otwiera ustawienia aplikacji.
  settings,
}

/// Główny model ustawień dashboardu użytkownika.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class DashboardPreferences with _$DashboardPreferences {
  /// Tworzy model ustawień dashboardu użytkownika.
  const factory DashboardPreferences({
    required String readyUserId,
    required String selectedWallpaperPath,
    required List<String> builtInWallpaperPaths,
    required List<String> customWallpaperPaths,
    required List<DashboardWidgetPreference> widgets,
    required List<DashboardShortcutPreference> shortcuts,
    required DashboardStartupModule startupModule,
    @Default(true) bool snapToGrid,
    required int desktopGridVersion,
    required DateTime updatedAt,
  }) = _DashboardPreferences;

  /// Odtwarza ustawienia dashboardu z dokumentu JSON zapisanego w Core.
  factory DashboardPreferences.fromJson(Map<String, dynamic> json) =>
      _$DashboardPreferencesFromJson(json);

  /// Buduje domyślne ustawienia startowe dashboardu.
  factory DashboardPreferences.defaults({required String readyUserId}) {
    return DashboardPreferences(
      readyUserId: readyUserId,
      selectedWallpaperPath: dashboardDefaultWallpaperPaths[0],
      builtInWallpaperPaths: dashboardDefaultWallpaperPaths,
      customWallpaperPaths: const [],
      widgets: const [
        DashboardWidgetPreference(
          id: 'default_quick_actions',
          widgetTypeId: 'quick_actions',
          gridColumn: 2,
          gridRow: 0,
          width: 8,
          height: 4,
        ),
        DashboardWidgetPreference(
          id: 'default_bhp_dashboard_users',
          widgetTypeId: 'bhp_dashboard_users',
          gridColumn: 10,
          gridRow: 0,
          width: 8,
          height: 8,
        ),
        DashboardWidgetPreference(
          id: 'default_bhp_dashboard_positions',
          widgetTypeId: 'bhp_dashboard_positions',
          gridColumn: 18,
          gridRow: 0,
          width: 8,
          height: 8,
        ),
        DashboardWidgetPreference(
          id: 'default_bhp_dashboard_equipment',
          widgetTypeId: 'bhp_dashboard_equipment',
          gridColumn: 26,
          gridRow: 0,
          width: 8,
          height: 8,
        ),
        DashboardWidgetPreference(
          id: 'default_bhp_dashboard_overdue',
          widgetTypeId: 'bhp_dashboard_overdue',
          gridColumn: 10,
          gridRow: 8,
          width: 8,
          height: 8,
        ),
        DashboardWidgetPreference(
          id: 'default_bhp_dashboard_upcoming',
          widgetTypeId: 'bhp_dashboard_upcoming',
          gridColumn: 18,
          gridRow: 8,
          width: 8,
          height: 12,
        ),
        DashboardWidgetPreference(
          id: 'default_weather_7_day',
          widgetTypeId: 'weather_7_day',
          gridColumn: 0,
          gridRow: 20,
          width: 10,
          height: 4,
        ),
      ],
      shortcuts: const [
        DashboardShortcutPreference(
          shortcutId: DashboardShortcutIds.inventory,
          isVisible: true,
          position: 0,
          gridColumn: 0,
          gridRow: 0,
        ),
        DashboardShortcutPreference(
          shortcutId: DashboardShortcutIds.bhp,
          isVisible: true,
          position: 1,
          gridColumn: 0,
          gridRow: 2,
        ),
        DashboardShortcutPreference(
          shortcutId: DashboardShortcutIds.settings,
          isVisible: true,
          position: 2,
          gridColumn: 0,
          gridRow: 4,
        ),
      ],
      startupModule: DashboardStartupModule.dashboard,
      desktopGridVersion: 2,
      updatedAt: DateTime.now(),
    );
  }
}

const dashboardDefaultWallpaperPaths = [
  'assets/images/std_bg_2.jpg',
  'assets/images/std_bg_1.jpg',
  'assets/images/std_bg_3.jpg',
  'assets/images/std_bg_4.webp',
  'assets/images/std_bg_5.jpeg',
  'assets/images/std_bg_6.jpg',
];
