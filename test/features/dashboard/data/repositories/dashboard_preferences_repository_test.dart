import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:ready_next/core/storage/hive_registrar.g.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';

void main() {
  late Directory tempDirectory;
  late HiveDashboardPreferencesRepository repository;

  setUpAll(Hive.registerAdapters);

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'ready_next_dashboard_preferences_test_',
    );
    Hive.init(tempDirectory.path);
    repository = HiveDashboardPreferencesRepository();
  });

  tearDown(() async {
    await repository.close();
    await Hive.close();
    await tempDirectory.delete(recursive: true);
  });

  group('HiveDashboardPreferencesRepository', () {
    test(
      'getPreferences tworzy domyslne ustawienia z dashboardem jako startupem',
      () async {
        final preferences = await repository.getPreferences(readyUserId: '15');

        expect(preferences.readyUserId, '15');
        expect(preferences.startupModule, DashboardStartupModule.dashboard);
        expect(preferences.widgets, isNotEmpty);
        expect(preferences.shortcuts, isNotEmpty);
        expect(
          preferences.shortcuts.every((shortcut) => shortcut.isVisible),
          isTrue,
        );
      },
    );

    test(
      'getPreferences normalizuje pusty identyfikator uzytkownika do anonymous',
      () async {
        final preferences = await repository.getPreferences(readyUserId: '   ');

        expect(preferences.readyUserId, 'anonymous');
      },
    );

    test(
      'getPreferences zwraca znormalizowane dane po zapisaniu niepoprawnego modelu',
      () async {
        final saved = await repository.savePreferences(
          DashboardPreferences(
            readyUserId: ' 42 ',
            selectedWallpaperPath: 'invalid-path',
            builtInWallpaperPaths: const [],
            customWallpaperPaths: const [' custom.jpg ', ''],
            widgets: const [
              DashboardWidgetPreference(
                id: 'legacy_summary',
                widgetTypeId: 'bhp_summary',
                gridColumn: 0,
                gridRow: 0,
                width: 4,
                height: 4,
              ),
            ],
            shortcuts: const [
              DashboardShortcutPreference(
                shortcutId: ' inventory ',
                isVisible: true,
                position: 10,
                gridColumn: -4,
                gridRow: -3,
              ),
              DashboardShortcutPreference(
                shortcutId: 'invalid',
                isVisible: true,
                position: 11,
                gridColumn: 3,
                gridRow: 3,
              ),
            ],
            startupModule: DashboardStartupModule.inventory,
            desktopGridVersion: 1,
            updatedAt: DateTime(2024),
          ),
        );
        final normalized = await repository.getPreferences(readyUserId: '42');

        expect(saved.readyUserId, '42');
        expect(saved.startupModule, DashboardStartupModule.inventory);
        expect(
          normalized.selectedWallpaperPath,
          dashboardDefaultWallpaperPaths.first,
        );
        expect(normalized.customWallpaperPaths, ['custom.jpg']);
        expect(
          normalized.widgets.map((widget) => widget.widgetTypeId),
          isNot(contains('bhp_summary')),
        );
        expect(
          normalized.widgets.map((widget) => widget.widgetTypeId),
          containsAll([
            'bhp_dashboard_users',
            'bhp_dashboard_positions',
            'bhp_dashboard_equipment',
            'bhp_dashboard_overdue',
          ]),
        );
        expect(normalized.desktopGridVersion, 2);
        final users = normalized.widgets.firstWhere(
          (widget) => widget.widgetTypeId == 'bhp_dashboard_users',
        );
        expect(
          (users.gridColumn, users.gridRow, users.width, users.height),
          (
            0,
            0,
            8,
            8,
          ),
        );
        expect(normalized.startupModule, DashboardStartupModule.inventory);
        expect(normalized.shortcuts.first.shortcutId, 'inventory');
        expect(normalized.shortcuts.first.gridColumn, 0);
        expect(normalized.shortcuts.first.gridRow, 0);
        expect(normalized.shortcuts, hasLength(3));
      },
    );

    test(
      'getPreferences zachowuje kolejność skrotow zapisana przez uzytkownika',
      () async {
        await repository.savePreferences(
          DashboardPreferences(
            readyUserId: '15',
            selectedWallpaperPath: dashboardDefaultWallpaperPaths.first,
            builtInWallpaperPaths: dashboardDefaultWallpaperPaths,
            customWallpaperPaths: const [],
            widgets: const [],
            shortcuts: const [
              DashboardShortcutPreference(
                shortcutId: 'settings',
                isVisible: true,
                position: 0,
                gridColumn: 0,
                gridRow: 2,
              ),
              DashboardShortcutPreference(
                shortcutId: 'inventory',
                isVisible: true,
                position: 1,
                gridColumn: 0,
                gridRow: 0,
              ),
            ],
            startupModule: DashboardStartupModule.dashboard,
            desktopGridVersion: 2,
            updatedAt: DateTime(2024),
          ),
        );

        final normalized = await repository.getPreferences(readyUserId: '15');

        expect(
          normalized.shortcuts.map((shortcut) => shortcut.shortcutId),
          ['settings', 'inventory', 'bhp'],
        );
        expect(
          normalized.shortcuts.map((shortcut) => shortcut.position),
          [0, 1, 2],
        );
      },
    );

    test(
      'getPreferences nie przelicza ponownie zapisanych pozycji do fallbacku full hd',
      () async {
        await repository.savePreferences(
          DashboardPreferences(
            readyUserId: '15',
            selectedWallpaperPath: dashboardDefaultWallpaperPaths.first,
            builtInWallpaperPaths: dashboardDefaultWallpaperPaths,
            customWallpaperPaths: const [],
            widgets: const [
              DashboardWidgetPreference(
                id: 'widget-1',
                widgetTypeId: 'quick_actions',
                gridColumn: 4,
                gridRow: 11,
                width: 8,
                height: 4,
              ),
            ],
            shortcuts: const [
              DashboardShortcutPreference(
                shortcutId: 'inventory',
                isVisible: true,
                position: 0,
                gridColumn: 4,
                gridRow: 11,
              ),
            ],
            startupModule: DashboardStartupModule.dashboard,
            desktopGridVersion: 2,
            updatedAt: DateTime(2024),
          ),
        );

        final restored = await repository.getPreferences(readyUserId: '15');

        expect(
          (
            restored.widgets.single.gridColumn,
            restored.widgets.single.gridRow,
          ),
          (4, 11),
        );
        expect(
          (
            restored.shortcuts.first.gridColumn,
            restored.shortcuts.first.gridRow,
          ),
          (4, 11),
        );
      },
    );
  });
}
