import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_shortcut_preference.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';

/// Proste repozytorium testowe ustawień dashboardu.
class _FakeDashboardPreferencesRepository
    implements DashboardPreferencesRepository {
  /// Tworzy repozytorium testowe z początkowym stanem preferencji.
  _FakeDashboardPreferencesRepository(this._preferences);

  DashboardPreferences _preferences;

  @override
  Future<void> close() async {}

  @override
  Future<DashboardPreferences> getPreferences({
    required String readyUserId,
  }) async {
    return _preferences;
  }

  @override
  Future<DashboardPreferences> savePreferences(
    DashboardPreferences preferences,
  ) async {
    return _preferences = preferences;
  }

  @override
  Future<DashboardPreferences> updatePreferences({
    required String readyUserId,
    required DashboardPreferences Function(DashboardPreferences current) update,
  }) async {
    return _preferences = update(_preferences);
  }
}

void main() {
  group('DashboardPreferencesCubit', () {
    blocTest<DashboardPreferencesCubit, DashboardPreferences>(
      'normalizeLayoutForDesktopSize przelicza układ po zmniejszeniu okna',
      build: () => DashboardPreferencesCubit(
        repository: _FakeDashboardPreferencesRepository(
          DashboardPreferences.defaults(
            readyUserId: 'user-1',
          ).copyWith(
            widgets: const [],
            shortcuts: const [
              DashboardShortcutPreference(
                shortcutId: 'inventory',
                isVisible: true,
                position: 0,
                gridColumn: 33,
                gridRow: 12,
              ),
            ],
          ),
        ),
        readyUserId: 'user-1',
      ),
      act: (cubit) async {
        await cubit.load();
        await cubit.normalizeLayoutForDesktopSize(const Size(300, 300));
      },
      expect: () => [
        isA<DashboardPreferences>(),
        isA<DashboardPreferences>().having(
          (state) => (
            state.shortcuts.single.gridColumn,
            state.shortcuts.single.gridRow,
          ),
          'shortcutPosition',
          (3, 3),
        ),
      ],
    );

    blocTest<DashboardPreferencesCubit, DashboardPreferences>(
      'normalizeLayoutForDesktopSize korzysta z najnowszych skrótów z repozytorium',
      build: () => DashboardPreferencesCubit(
        repository: _FakeDashboardPreferencesRepository(
          DashboardPreferences.defaults(
            readyUserId: 'user-1',
          ).copyWith(
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
          ),
        ),
        readyUserId: 'user-1',
      ),
      seed: () =>
          DashboardPreferences.defaults(
            readyUserId: 'user-1',
          ).copyWith(
            widgets: const [],
            shortcuts: const [
              DashboardShortcutPreference(
                shortcutId: 'inventory',
                isVisible: false,
                position: 0,
                gridColumn: 0,
                gridRow: 0,
              ),
            ],
          ),
      act: (cubit) async {
        await cubit.normalizeLayoutForDesktopSize(const Size(400, 300));
      },
      expect: () => [
        isA<DashboardPreferences>().having(
          (state) => state.shortcuts.single.isVisible,
          'shortcutVisible',
          isTrue,
        ),
      ],
    );

    test(
      'removeWidget usuwa widget schowany w zasobniku z repozytorium i activeLayout',
      () async {
        final repository = _FakeDashboardPreferencesRepository(
          DashboardPreferences.defaults(
            readyUserId: 'user-1',
          ).copyWith(
            widgets: const [
              DashboardWidgetPreference(
                id: 'visible-widget',
                widgetTypeId: 'quick_actions',
                gridColumn: 0,
                gridRow: 0,
                width: 8,
                height: 4,
              ),
              DashboardWidgetPreference(
                id: 'overflowed-widget',
                widgetTypeId: 'weather_7_day',
                gridColumn: 0,
                gridRow: 0,
                width: 10,
                height: 4,
              ),
            ],
            shortcuts: const [],
          ),
        );
        final cubit = DashboardPreferencesCubit(
          repository: repository,
          readyUserId: 'user-1',
        );

        await cubit.load();
        await cubit.normalizeLayoutForDesktopSize(const Size(564, 380));

        expect(cubit.activeLayout?.overflowedWidgets, hasLength(1));
        expect(
          cubit.activeLayout?.overflowedWidgets.single.id,
          'overflowed-widget',
        );

        await cubit.removeWidget('overflowed-widget');

        expect(
          repository._preferences.widgets.map((widget) => widget.id),
          ['visible-widget'],
        );
        expect(cubit.activeLayout?.overflowedWidgets, isEmpty);
      },
    );

    test(
      'removeWidget usuwa widget z pulpitu i nie pozostawia go w stanie',
      () async {
        final repository = _FakeDashboardPreferencesRepository(
          DashboardPreferences.defaults(
            readyUserId: 'user-1',
          ).copyWith(
            widgets: const [
              DashboardWidgetPreference(
                id: 'visible-widget',
                widgetTypeId: 'quick_actions',
                gridColumn: 0,
                gridRow: 0,
                width: 8,
                height: 4,
              ),
              DashboardWidgetPreference(
                id: 'overflowed-widget',
                widgetTypeId: 'weather_7_day',
                gridColumn: 0,
                gridRow: 0,
                width: 10,
                height: 4,
              ),
            ],
            shortcuts: const [],
          ),
        );
        final cubit = DashboardPreferencesCubit(
          repository: repository,
          readyUserId: 'user-1',
        );

        await cubit.load();
        await cubit.normalizeLayoutForDesktopSize(const Size(500, 380));

        expect(cubit.state.widgets.map((widget) => widget.id), [
          'visible-widget',
        ]);
        expect(
          cubit.activeLayout?.overflowedWidgets.map((widget) => widget.id),
          [
            'overflowed-widget',
          ],
        );

        await cubit.removeWidget('visible-widget');

        expect(
          repository._preferences.widgets.map((widget) => widget.id),
          ['overflowed-widget'],
        );
        expect(
          cubit.state.widgets.any((widget) => widget.id == 'visible-widget'),
          isFalse,
        );
      },
    );
  });
}
