import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/features/settings/data/repositories/local_settings_repository.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';

/// Proste repozytorium testowe dla lokalnych ustawien aplikacji.
class _FakeLocalSettingsRepository implements LocalSettingsRepository {
  /// Tworzy repozytorium testowe z opcjonalnym stanem poczatkowym.
  _FakeLocalSettingsRepository([LocalSettingsModel? initial])
    : _settings = initial ?? const LocalSettingsModel.defaults();

  LocalSettingsModel _settings;

  @override
  Future<void> close() async {}

  @override
  Future<LocalSettingsModel> getSettings() async => _settings;

  @override
  Future<LocalSettingsModel> saveSettings(LocalSettingsModel settings) async =>
      _settings = settings;

  @override
  Future<LocalSettingsModel> updateSettings(
    LocalSettingsModel Function(LocalSettingsModel current) update,
  ) async => _settings = update(_settings);
}

void main() {
  group('LocalSettingsCubit', () {
    blocTest<LocalSettingsCubit, LocalSettingsModel>(
      'load emituje stan zapisany w repozytorium',
      build: () => LocalSettingsCubit(
        repository: _FakeLocalSettingsRepository(
          const LocalSettingsModel(
            themeMode: ThemeMode.dark,
            themePalette: AppThemePalette.material,
            themeSeedColor: AppThemeSeedColor.teal,
            language: AppLanguage.en,
            sideMenuOrders: {
              'inventory': ['companies', 'stock'],
            },
          ),
        ),
      ),
      act: (cubit) => cubit.load(),
      expect: () => [
        const LocalSettingsModel(
          themeMode: ThemeMode.dark,
          themePalette: AppThemePalette.material,
          themeSeedColor: AppThemeSeedColor.teal,
          language: AppLanguage.en,
          sideMenuOrders: {
            'inventory': ['companies', 'stock'],
          },
        ),
      ],
    );

    blocTest<LocalSettingsCubit, LocalSettingsModel>(
      'setMenuOrder usuwa duplikaty i puste identyfikatory przed zapisem',
      build: () => LocalSettingsCubit(
        repository: _FakeLocalSettingsRepository(),
      ),
      act: (cubit) => cubit.setMenuOrder(
        menuId: 'inventory',
        orderedIds: ['stock', '', 'companies', 'stock'],
      ),
      expect: () => [
        const LocalSettingsModel(
          themeMode: ThemeMode.light,
          themePalette: AppThemePalette.classic,
          themeSeedColor: AppThemeSeedColor.blue,
          language: AppLanguage.pl,
          sideMenuOrders: {
            'inventory': ['stock', 'companies'],
          },
        ),
      ],
    );

    test(
      'orderedMenuIds scala zapis lokalny z nowa kolejnoscia domyslna',
      () async {
        final cubit = LocalSettingsCubit(
          repository: _FakeLocalSettingsRepository(
            const LocalSettingsModel(
              themeMode: ThemeMode.light,
              themePalette: AppThemePalette.classic,
              themeSeedColor: AppThemeSeedColor.blue,
              language: AppLanguage.pl,
              sideMenuOrders: {
                'inventory': ['stock', 'legacy', 'companies'],
              },
            ),
          ),
        );
        await cubit.load();

        final result = cubit.orderedMenuIds(
          menuId: 'inventory',
          defaultOrder: ['companies', 'stock', 'reports'],
        );

        expect(result, ['stock', 'companies', 'reports']);
      },
    );

    test(
      'zapisuje stan zwinięcia panelu niezależnie dla klucza konta',
      () async {
        final cubit = LocalSettingsCubit(
          repository: _FakeLocalSettingsRepository(),
        );

        expect(
          cubit.isNavigationPanelExpanded('workspaces.home:user-a'),
          isTrue,
        );
        await cubit.setNavigationPanelExpanded(
          preferenceKey: 'workspaces.home:user-a',
          expanded: false,
        );

        expect(
          cubit.isNavigationPanelExpanded('workspaces.home:user-a'),
          isFalse,
        );
        expect(
          cubit.isNavigationPanelExpanded('workspaces.home:user-b'),
          isTrue,
        );
      },
    );
  });
}
