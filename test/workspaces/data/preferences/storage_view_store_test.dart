import 'dart:convert';

import 'package:devplanner/workspaces/data/preferences/shared_preferences_storage_view_store.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const gridCompact = StorageViewPreference(
    viewMode: StorageViewMode.grid,
    sort: StorageSortCriteria(
      field: StorageSortField.name,
      direction: StorageSortDirection.ascending,
    ),
    density: StorageDensity.compact,
  );

  test('preferencja zakresu przetrwa restart klienta', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final store = SharedPreferencesStorageViewStore(
      currentUserId: () => 'user-1',
    );
    await store.load();

    expect(store.preferenceFor(scopeKey: 'personal'), isNull);

    await store.write(scopeKey: 'personal', preference: gridCompact);
    expect(store.preferenceFor(scopeKey: 'personal'), equals(gridCompact));

    // Nowa instancja = nowy start aplikacji na tych samych danych.
    final restarted = SharedPreferencesStorageViewStore(
      currentUserId: () => 'user-1',
    );
    await restarted.load();

    expect(restarted.preferenceFor(scopeKey: 'personal'), equals(gridCompact));
  });

  test('zakresy nie dziedziczą po sobie widoku ani gęstości', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final store = SharedPreferencesStorageViewStore(
      currentUserId: () => 'user-1',
    );
    await store.load();

    await store.write(scopeKey: 'personal', preference: gridCompact);

    expect(store.preferenceFor(scopeKey: 'personal'), equals(gridCompact));
    expect(store.preferenceFor(scopeKey: 'trash'), isNull);
    expect(store.preferenceFor(scopeKey: 'workspace:w-1'), isNull);
  });

  test(
    'wybór jednego konta nie przecieka do innego na tym urządzeniu',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});

      var userId = 'user-1';
      final store = SharedPreferencesStorageViewStore(
        currentUserId: () => userId,
      );
      await store.load();
      await store.write(scopeKey: 'personal', preference: gridCompact);
      expect(store.preferenceFor(scopeKey: 'personal'), equals(gridCompact));

      // To samo urządzenie, inne konto: cache poprzedniego użytkownika nie może
      // być źródłem widoku, dopóki właściciel sesji nie wczyta nowego zestawu.
      userId = 'user-2';
      expect(store.preferenceFor(scopeKey: 'personal'), isNull);

      await store.load();
      expect(store.preferenceFor(scopeKey: 'personal'), isNull);

      await store.write(scopeKey: 'personal', preference: gridCompact);
      expect(store.preferenceFor(scopeKey: 'personal'), equals(gridCompact));
    },
  );

  test('bez zalogowanego użytkownika nic nie czyta i nie zapisuje', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final store = SharedPreferencesStorageViewStore(currentUserId: () => null);

    await store.load();
    await store.write(scopeKey: 'personal', preference: gridCompact);

    expect(store.preferenceFor(scopeKey: 'personal'), isNull);
  });

  test(
    'uszkodzony wpis wraca do wartości domyślnych zamiast wywracać moduł',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'devplanner.files-view.user-1.personal': '{not json',
        'devplanner.files-view.user-1.trash': jsonEncode({
          'viewMode': 'nieznany',
          'sortField': 'nieznane',
          'density': 'nieznana',
        }),
      });
      final store = SharedPreferencesStorageViewStore(
        currentUserId: () => 'user-1',
      );

      await store.load();

      // Wpis nieparsowalny jest pomijany, a wpis z nieznanymi wartościami wraca
      // do wartości domyślnych zamiast wywracać moduł błędem.
      expect(store.preferenceFor(scopeKey: 'personal'), isNull);
      expect(
        store.preferenceFor(scopeKey: 'trash'),
        equals(StorageViewPreference.defaults),
      );
    },
  );

  test('kolejne zapisy nie gubią najnowszej wartości', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final store = SharedPreferencesStorageViewStore(
      currentUserId: () => 'user-1',
    );
    await store.load();

    // Dwie szybkie zmiany: kolejka zapisów musi zostawić w magazynie ostatnią.
    final first = store.write(
      scopeKey: 'personal',
      preference: const StorageViewPreference(density: StorageDensity.compact),
    );
    final second = store.write(
      scopeKey: 'personal',
      preference: gridCompact,
    );
    await Future.wait([first, second]);

    final restarted = SharedPreferencesStorageViewStore(
      currentUserId: () => 'user-1',
    );
    await restarted.load();
    expect(restarted.preferenceFor(scopeKey: 'personal'), equals(gridCompact));
  });
}
