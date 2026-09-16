import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';

void main() {
  group('DashboardDesktopLayoutEngine', () {
    test(
      'normalize keeps visible shortcuts fixed and moves widgets around them',
      () {
        final preferences = DashboardPreferences(
          readyUserId: 'user-1',
          selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
          builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
          customWallpaperPaths: const [],
          widgets: const [
            DashboardWidgetPreference(
              id: 'widget-1',
              widgetTypeId: 'quick_actions',
              gridColumn: 0,
              gridRow: 0,
              width: 1,
              height: 1,
            ),
          ],
          shortcuts: const [
            DashboardShortcutPreference(
              shortcutId: 'inventory',
              isVisible: true,
              position: 0,
              gridColumn: 0,
              gridRow: 0,
            ),
          ],
          startupModule: DashboardStartupModule.dashboard,
          desktopGridVersion: 2,
          updatedAt: DateTime(2026),
        );

        final result = DashboardDesktopLayoutEngine.normalize(
          preferences: preferences,
          desktopSize: const Size(300, 300),
        );

        expect(result.shortcuts.single.gridColumn, 0);
        expect(result.shortcuts.single.gridRow, 0);
        expect(result.widgets.single.gridColumn, 2);
        expect(result.widgets.single.gridRow, 0);
      },
    );

    test('placeWidget returns null when no free cell exists', () {
      final preferences = DashboardPreferences(
        readyUserId: 'user-1',
        selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
        builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
        customWallpaperPaths: const [],
        widgets: const [],
        shortcuts: const [
          DashboardShortcutPreference(
            shortcutId: 'inventory',
            isVisible: true,
            position: 0,
            gridColumn: 0,
            gridRow: 0,
          ),
        ],
        startupModule: DashboardStartupModule.dashboard,
        desktopGridVersion: 2,
        updatedAt: DateTime(2026),
      );

      final result = DashboardDesktopLayoutEngine.placeWidget(
        preferences: preferences,
        widget: const DashboardWidgetPreference(
          id: 'widget-1',
          widgetTypeId: 'quick_actions',
          gridColumn: 0,
          gridRow: 0,
          width: 1,
          height: 1,
        ),
        desktopSize: const Size(120, 150),
      );

      expect(result, isNull);
    });

    test('moveShortcut displaces a widget from the target cell', () {
      final preferences = DashboardPreferences(
        readyUserId: 'user-1',
        selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
        builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
        customWallpaperPaths: const [],
        widgets: const [
          DashboardWidgetPreference(
            id: 'widget-1',
            widgetTypeId: 'quick_actions',
            gridColumn: 0,
            gridRow: 0,
            width: 1,
            height: 1,
          ),
        ],
        shortcuts: const [
          DashboardShortcutPreference(
            shortcutId: 'inventory',
            isVisible: true,
            position: 0,
            gridColumn: 2,
            gridRow: 0,
          ),
        ],
        startupModule: DashboardStartupModule.dashboard,
        desktopGridVersion: 2,
        updatedAt: DateTime(2026),
      );

      final result = DashboardDesktopLayoutEngine.moveShortcut(
        preferences: preferences,
        shortcutId: 'inventory',
        gridColumn: 0,
        gridRow: 0,
        desktopSize: const Size(300, 300),
      );

      expect(result.shortcuts.single.gridColumn, 0);
      expect(result.shortcuts.single.gridRow, 0);
      expect(result.widgets.single.gridColumn, 2);
      expect(result.widgets.single.gridRow, 0);
    });

    test('moveWidget displaces a shortcut from the target cell', () {
      final preferences = DashboardPreferences(
        readyUserId: 'user-1',
        selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
        builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
        customWallpaperPaths: const [],
        widgets: const [
          DashboardWidgetPreference(
            id: 'widget-1',
            widgetTypeId: 'quick_actions',
            gridColumn: 1,
            gridRow: 0,
            width: 1,
            height: 1,
          ),
        ],
        shortcuts: const [
          DashboardShortcutPreference(
            shortcutId: 'inventory',
            isVisible: true,
            position: 0,
            gridColumn: 0,
            gridRow: 0,
          ),
        ],
        startupModule: DashboardStartupModule.dashboard,
        desktopGridVersion: 2,
        updatedAt: DateTime(2026),
      );

      final result = DashboardDesktopLayoutEngine.moveWidget(
        preferences: preferences,
        widgetId: 'widget-1',
        gridColumn: 0,
        gridRow: 0,
        desktopSize: const Size(300, 300),
      );

      expect(result.widgets.single.gridColumn, 0);
      expect(result.widgets.single.gridRow, 0);
      final shortcut = result.shortcuts.single;
      final maxShortcutColumn =
          DashboardDesktopGeometry.maxColumnsForDesktop(const Size(300, 300)) -
          DashboardDesktopGeometry.shortcutSpanWidth;
      final maxShortcutRow =
          DashboardDesktopGeometry.maxRowsForDesktop(const Size(300, 300)) -
          DashboardDesktopGeometry.shortcutSpanHeight;
      expect((shortcut.gridColumn, shortcut.gridRow), isNot((0, 0)));
      expect(
        shortcut.gridColumn.isEven || shortcut.gridColumn == maxShortcutColumn,
        isTrue,
      );
      expect(
        shortcut.gridRow.isEven || shortcut.gridRow == maxShortcutRow,
        isTrue,
      );
    });

    test('moveShortcut swaps positions with another shortcut', () {
      final preferences = DashboardPreferences(
        readyUserId: 'user-1',
        selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
        builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
        customWallpaperPaths: const [],
        widgets: const [],
        shortcuts: const [
          DashboardShortcutPreference(
            shortcutId: 'inventory',
            isVisible: true,
            position: 0,
            gridColumn: 0,
            gridRow: 0,
          ),
          DashboardShortcutPreference(
            shortcutId: 'bhp',
            isVisible: true,
            position: 1,
            gridColumn: 2,
            gridRow: 0,
          ),
        ],
        startupModule: DashboardStartupModule.dashboard,
        desktopGridVersion: 2,
        updatedAt: DateTime(2026),
      );

      final result = DashboardDesktopLayoutEngine.moveShortcut(
        preferences: preferences,
        shortcutId: 'inventory',
        gridColumn: 2,
        gridRow: 0,
        desktopSize: const Size(400, 300),
      );

      final inventory = result.shortcuts.singleWhere(
        (shortcut) => shortcut.shortcutId == 'inventory',
      );
      final bhp = result.shortcuts.singleWhere(
        (shortcut) => shortcut.shortcutId == 'bhp',
      );
      expect((inventory.gridColumn, inventory.gridRow), (2, 0));
      expect((bhp.gridColumn, bhp.gridRow), (0, 0));
    });

    test(
      'moveShortcut allows placing shortcut in the last fitting edge cell',
      () {
        final preferences = DashboardPreferences(
          readyUserId: 'user-1',
          selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
          builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
          customWallpaperPaths: const [],
          widgets: const [],
          shortcuts: const [
            DashboardShortcutPreference(
              shortcutId: 'inventory',
              isVisible: true,
              position: 0,
              gridColumn: 0,
              gridRow: 0,
            ),
          ],
          startupModule: DashboardStartupModule.dashboard,
          desktopGridVersion: 2,
          updatedAt: DateTime(2026),
        );

        final result = DashboardDesktopLayoutEngine.moveShortcut(
          preferences: preferences,
          shortcutId: 'inventory',
          gridColumn: 33,
          gridRow: 13,
          desktopSize: const Size(1920, 1080),
        );

        final inventory = result.shortcuts.singleWhere(
          (shortcut) => shortcut.shortcutId == 'inventory',
        );
        expect((inventory.gridColumn, inventory.gridRow), (32, 12));
      },
    );

    test(
      'moveShortcut snaps to the regular shortcut grid before edge slot',
      () {
        final preferences = DashboardPreferences(
          readyUserId: 'user-1',
          selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
          builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
          customWallpaperPaths: const [],
          widgets: const [],
          shortcuts: const [
            DashboardShortcutPreference(
              shortcutId: 'inventory',
              isVisible: true,
              position: 0,
              gridColumn: 0,
              gridRow: 0,
            ),
          ],
          startupModule: DashboardStartupModule.dashboard,
          desktopGridVersion: 2,
          updatedAt: DateTime(2026),
        );

        final result = DashboardDesktopLayoutEngine.moveShortcut(
          preferences: preferences,
          shortcutId: 'inventory',
          gridColumn: 1,
          gridRow: 1,
          desktopSize: const Size(1920, 1080),
        );

        final inventory = result.shortcuts.singleWhere(
          (shortcut) => shortcut.shortcutId == 'inventory',
        );
        expect((inventory.gridColumn, inventory.gridRow), (0, 0));
      },
    );

    test('moveWidget swaps positions with another widget', () {
      final preferences = DashboardPreferences(
        readyUserId: 'user-1',
        selectedWallpaperPath: 'assets/images/std_bg_1.jpg',
        builtInWallpaperPaths: const ['assets/images/std_bg_1.jpg'],
        customWallpaperPaths: const [],
        widgets: const [
          DashboardWidgetPreference(
            id: 'widget-1',
            widgetTypeId: 'quick_actions',
            gridColumn: 0,
            gridRow: 0,
            width: 1,
            height: 1,
          ),
          DashboardWidgetPreference(
            id: 'widget-2',
            widgetTypeId: 'quick_actions',
            gridColumn: 1,
            gridRow: 0,
            width: 1,
            height: 1,
          ),
        ],
        shortcuts: const [],
        startupModule: DashboardStartupModule.dashboard,
        desktopGridVersion: 2,
        updatedAt: DateTime(2026),
      );

      final result = DashboardDesktopLayoutEngine.moveWidget(
        preferences: preferences,
        widgetId: 'widget-1',
        gridColumn: 1,
        gridRow: 0,
        desktopSize: const Size(400, 300),
      );

      final first = result.widgets.singleWhere(
        (widget) => widget.id == 'widget-1',
      );
      final second = result.widgets.singleWhere(
        (widget) => widget.id == 'widget-2',
      );
      expect((first.gridColumn, first.gridRow), (1, 0));
      expect((second.gridColumn, second.gridRow), (0, 0));
    });
  });
}
