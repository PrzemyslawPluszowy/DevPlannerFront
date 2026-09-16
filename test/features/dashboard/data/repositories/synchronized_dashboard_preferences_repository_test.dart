import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/features/dashboard/data/api/dashboard_preferences_api.dart';
import 'package:ready_next/features/dashboard/data/repositories/dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/data/repositories/synchronized_dashboard_preferences_repository.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';

/// Atrapa API Core używana do testów synchronizacji pulpitu.
class _MockDashboardPreferencesApi extends Mock
    implements DashboardPreferencesApi {}

/// Proste repozytorium pamięciowe zastępujące Hive w testach jednostkowych.
class _MemoryDashboardPreferencesRepository
    implements DashboardPreferencesRepository, DashboardPreferencesLocalStore {
  final Map<String, DashboardPreferences> _preferences = {};

  @override
  Future<void> close() async {}

  @override
  Future<DashboardPreferences> getPreferences({
    required String readyUserId,
  }) async {
    return _preferences.putIfAbsent(
      readyUserId,
      () => DashboardPreferences.defaults(readyUserId: readyUserId),
    );
  }

  @override
  Future<bool> hasStoredPreferences({required String readyUserId}) async =>
      _preferences.containsKey(readyUserId);

  @override
  Future<DashboardPreferences> savePreferences(
    DashboardPreferences preferences,
  ) async {
    _preferences[preferences.readyUserId] = preferences;
    return preferences;
  }

  @override
  Future<DashboardPreferences> updatePreferences({
    required String readyUserId,
    required DashboardPreferences Function(DashboardPreferences current) update,
  }) async {
    return savePreferences(
      update(await getPreferences(readyUserId: readyUserId)),
    );
  }
}

void main() {
  late _MockDashboardPreferencesApi api;
  late _MemoryDashboardPreferencesRepository localRepository;
  late SynchronizedDashboardPreferencesRepository repository;
  late Directory tempDirectory;

  setUpAll(() {
    registerFallbackValue(
      PutDashboardPreferencesRequest(
        schemaVersion: 1,
        revision: 0,
        preferences: DashboardPreferences.defaults(readyUserId: 'fallback'),
      ),
    );
  });

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'ready_next_dashboard_sync_test_',
    );
    Hive.init(tempDirectory.path);
    api = _MockDashboardPreferencesApi();
    localRepository = _MemoryDashboardPreferencesRepository();
    repository = SynchronizedDashboardPreferencesRepository(
      api: api,
      localRepository: localRepository,
    );
  });

  tearDown(() async {
    await repository.close();
    await Hive.close();
    await tempDirectory.delete(recursive: true);
  });

  test('odczytuje pulpit z Core i aktualizuje lokalny cache', () async {
    final remotePreferences = DashboardPreferences.defaults(
      readyUserId: 'other-device',
    ).copyWith(snapToGrid: false);
    when(api.getPreferences).thenAnswer(
      (_) async => RemoteDashboardPreferences(
        schemaVersion: 1,
        revision: 4,
        preferences: remotePreferences,
        updatedAtUtc: DateTime.utc(2026, 8, 10),
      ),
    );

    final preferences = await repository.getPreferences(readyUserId: '15');

    expect(preferences.readyUserId, '15');
    expect(preferences.snapToGrid, isFalse);
    expect(
      (await localRepository.getPreferences(readyUserId: '15')).snapToGrid,
      isFalse,
    );
  });

  test('migruje istniejący lokalny pulpit, gdy Core zwraca 404', () async {
    final local = DashboardPreferences.defaults(
      readyUserId: '15',
    ).copyWith(snapToGrid: false);
    await localRepository.savePreferences(local);
    when(api.getPreferences).thenThrow(_dioError(404));
    when(() => api.putPreferences(any())).thenAnswer(
      (invocation) async {
        final request =
            invocation.positionalArguments.single
                as PutDashboardPreferencesRequest;
        return RemoteDashboardPreferences(
          schemaVersion: request.schemaVersion,
          revision: 1,
          preferences: request.preferences,
          updatedAtUtc: DateTime.utc(2026, 8, 10),
        );
      },
    );

    final preferences = await repository.getPreferences(readyUserId: '15');

    expect(preferences.snapToGrid, isFalse);
    verify(
      () => api.putPreferences(
        any(
          that: isA<PutDashboardPreferencesRequest>().having(
            (request) => request.revision,
            'revision',
            0,
          ),
        ),
      ),
    ).called(1);
  });

  test('zachowuje lokalny zapis, gdy Core jest niedostępne', () async {
    when(api.getPreferences).thenThrow(_dioError(null));
    final local = DashboardPreferences.defaults(
      readyUserId: '15',
    ).copyWith(snapToGrid: false);

    final saved = await repository.savePreferences(local);

    expect(saved.snapToGrid, isFalse);
    expect(
      (await localRepository.getPreferences(readyUserId: '15')).snapToGrid,
      isFalse,
    );
    verifyNever(() => api.putPreferences(any()));
  });

  test(
    'przy pierwszym uruchomieniu zachowuje nowszy lokalny pulpit względem Core',
    () async {
      final local =
          DashboardPreferences.defaults(
            readyUserId: '15',
          ).copyWith(
            snapToGrid: false,
            updatedAt: DateTime.utc(2026, 8, 11),
          );
      await localRepository.savePreferences(local);
      when(api.getPreferences).thenAnswer(
        (_) async => RemoteDashboardPreferences(
          schemaVersion: 1,
          revision: 2,
          preferences: DashboardPreferences.defaults(readyUserId: '15'),
          updatedAtUtc: DateTime.utc(2026, 8, 10),
        ),
      );
      when(() => api.putPreferences(any())).thenAnswer(
        (invocation) async {
          final request =
              invocation.positionalArguments.single
                  as PutDashboardPreferencesRequest;
          return RemoteDashboardPreferences(
            schemaVersion: request.schemaVersion,
            revision: 3,
            preferences: request.preferences,
            updatedAtUtc: DateTime.utc(2026, 8, 11),
          );
        },
      );

      final preferences = await repository.getPreferences(readyUserId: '15');

      expect(preferences.snapToGrid, isFalse);
      verify(
        () => api.putPreferences(
          any(
            that: isA<PutDashboardPreferencesRequest>().having(
              (request) => request.revision,
              'revision',
              2,
            ),
          ),
        ),
      ).called(1);
    },
  );

  test('wysyła później lokalną zmianę zapisaną offline', () async {
    when(api.getPreferences).thenThrow(_dioError(null));
    final local = DashboardPreferences.defaults(
      readyUserId: '15',
    ).copyWith(snapToGrid: false);
    await repository.savePreferences(local);

    when(api.getPreferences).thenAnswer(
      (_) async => RemoteDashboardPreferences(
        schemaVersion: 1,
        revision: 5,
        preferences: DashboardPreferences.defaults(readyUserId: '15'),
        updatedAtUtc: DateTime.utc(2026, 8, 10),
      ),
    );
    when(() => api.putPreferences(any())).thenAnswer(
      (invocation) async {
        final request =
            invocation.positionalArguments.single
                as PutDashboardPreferencesRequest;
        return RemoteDashboardPreferences(
          schemaVersion: request.schemaVersion,
          revision: 6,
          preferences: request.preferences,
          updatedAtUtc: DateTime.utc(2026, 8, 10),
        );
      },
    );

    final synchronized = await repository.getPreferences(readyUserId: '15');

    expect(synchronized.snapToGrid, isFalse);
    verify(
      () => api.putPreferences(
        any(
          that: isA<PutDashboardPreferencesRequest>().having(
            (request) => request.revision,
            'revision',
            5,
          ),
        ),
      ),
    ).called(1);
  });

  test('wykrywa zmianę Hive wykonaną później przez starą aplikację', () async {
    final remotePreferences = DashboardPreferences.defaults(
      readyUserId: '15',
    );
    when(api.getPreferences).thenAnswer(
      (_) async => RemoteDashboardPreferences(
        schemaVersion: 1,
        revision: 7,
        preferences: remotePreferences,
        updatedAtUtc: DateTime.utc(2026, 8, 10),
      ),
    );
    when(() => api.putPreferences(any())).thenAnswer(
      (invocation) async {
        final request =
            invocation.positionalArguments.single
                as PutDashboardPreferencesRequest;
        return RemoteDashboardPreferences(
          schemaVersion: request.schemaVersion,
          revision: 8,
          preferences: request.preferences,
          updatedAtUtc: DateTime.utc(2026, 8, 10),
        );
      },
    );

    await repository.getPreferences(readyUserId: '15');
    await localRepository.savePreferences(
      remotePreferences.copyWith(snapToGrid: false),
    );

    final preferences = await repository.getPreferences(readyUserId: '15');

    expect(preferences.snapToGrid, isFalse);
    verify(
      () => api.putPreferences(
        any(
          that: isA<PutDashboardPreferencesRequest>().having(
            (request) => request.revision,
            'revision',
            7,
          ),
        ),
      ),
    ).called(1);
  });

  test(
    'przy konflikcie rewizji zachowuje najnowszy stan z Core',
    () async {
      final local = DashboardPreferences.defaults(
        readyUserId: '15',
      ).copyWith(snapToGrid: false);
      var readCount = 0;
      when(api.getPreferences).thenAnswer((_) async {
        readCount++;
        return RemoteDashboardPreferences(
          schemaVersion: 1,
          revision: readCount == 1 ? 2 : 3,
          preferences: DashboardPreferences.defaults(readyUserId: '15'),
          updatedAtUtc: DateTime.utc(2026, 8, 10),
        );
      });
      when(() => api.putPreferences(any())).thenAnswer((invocation) async {
        throw _dioError(409);
      });

      final saved = await repository.savePreferences(local);

      expect(saved.snapToGrid, isTrue);
      verify(() => api.putPreferences(any())).called(1);
      verify(() => api.getPreferences()).called(2);
    },
  );
}

DioException _dioError(int? statusCode) {
  final requestOptions = RequestOptions(path: '/me/dashboard');
  return DioException(
    requestOptions: requestOptions,
    response: statusCode == null
        ? null
        : Response(requestOptions: requestOptions, statusCode: statusCode),
  );
}
