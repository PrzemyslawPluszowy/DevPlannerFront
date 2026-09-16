import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:ready_next/core/storage/hive_registrar.g.dart';
import 'package:ready_next/features/settings/data/repositories/local_settings_repository.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';

void main() {
  late Directory tempDirectory;
  late HiveLocalSettingsRepository repository;

  setUpAll(Hive.registerAdapters);

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'ready_next_local_settings_test_',
    );
    Hive.init(tempDirectory.path);
    repository = HiveLocalSettingsRepository();
  });

  tearDown(() async {
    await repository.close();
    await Hive.close();
    await tempDirectory.delete(recursive: true);
  });

  group('HiveLocalSettingsRepository', () {
    test(
      'getSettings zapisuje i zwraca domyslny stan przy pierwszym odczycie',
      () async {
        final settings = await repository.getSettings();

        expect(settings, const LocalSettingsModel.defaults());
      },
    );

    test('saveSettings normalizuje menu i usuwa puste wpisy', () async {
      final saved = await repository.saveSettings(
        const LocalSettingsModel(
          themeMode: ThemeMode.dark,
          themePalette: AppThemePalette.material,
          themeSeedColor: AppThemeSeedColor.indigo,
          language: AppLanguage.en,
          sideMenuOrders: {
            ' inventory ': ['stock', 'stock', '', 'reports'],
            '': ['ignored'],
          },
        ),
      );

      expect(
        saved,
        const LocalSettingsModel(
          themeMode: ThemeMode.dark,
          themePalette: AppThemePalette.material,
          themeSeedColor: AppThemeSeedColor.indigo,
          language: AppLanguage.en,
          sideMenuOrders: {
            'inventory': ['stock', 'reports'],
          },
        ),
      );
    });
  });
}
