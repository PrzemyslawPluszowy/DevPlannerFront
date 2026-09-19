import 'dart:io';

import 'package:devplanner/core/storage/hive_helper.dart';
import 'package:devplanner/foundation/cache/devplanner_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';

void main() {
  late Directory directory;
  late HiveDevPlannerCacheStore store;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp(
      'devplanner_cache_test_',
    );
    Hive.init(directory.path);
    store = await HiveDevPlannerCacheStore.open();
  });

  tearDown(() async {
    await store.close();
    await Hive.close();
    if (directory.existsSync()) await directory.delete(recursive: true);
  });

  test('round-trips an owned, non-secret cache document', () async {
    final key = DevPlannerCacheKey(
      userId: 'user-1',
      scope: DevPlannerCacheScope.workspaceSummary,
      entryId: 'workspace-1',
    );
    await store.write(key, <String, Object?>{
      'name': 'DevPlanner',
      'memberCount': 3,
    });

    final document = await store.read(key);
    expect(document?.schemaVersion, DevPlannerCacheKey.schemaVersion);
    expect(document?.data['name'], 'DevPlanner');
    expect(document?.data['memberCount'], 3);
  });

  test('rejects secret-like fields', () async {
    final key = DevPlannerCacheKey(
      userId: 'user-1',
      scope: DevPlannerCacheScope.profile,
      entryId: 'me',
    );

    expect(
      () => store.write(key, <String, Object?>{'refreshToken': 'nope'}),
      throwsArgumentError,
    );
  });

  test('clears only the selected user namespace', () async {
    final first = DevPlannerCacheKey(
      userId: 'user-1',
      scope: DevPlannerCacheScope.profile,
      entryId: 'me',
    );
    final second = DevPlannerCacheKey(
      userId: 'user-2',
      scope: DevPlannerCacheScope.profile,
      entryId: 'me',
    );
    await store.write(first, <String, Object?>{'name': 'Anna'});
    await store.write(second, <String, Object?>{'name': 'Ola'});

    await store.clearUser('user-1');

    expect(await store.read(first), isNull);
    expect(await store.read(second), isNotNull);
  });

  test('invalid persisted data is discarded instead of returned', () async {
    final key = DevPlannerCacheKey(
      userId: 'user-1',
      scope: DevPlannerCacheScope.uiPreferences,
      entryId: 'shell',
    );
    final box = await HiveHelper.openBox<String>(
      HiveDevPlannerCacheStore.boxName,
    );
    await box.put(key.storageKey, '{"schemaVersion":1,"data":{}}');

    expect(await store.read(key), isNull);
  });
}
