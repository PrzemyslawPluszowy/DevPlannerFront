import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/locations_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/locations_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';

import '../../../../../../test_support/test_hive.dart';

class _MockLocationsRepository extends Mock implements LocationsRepository {}

void main() {
  late Directory tempDir;
  late LocationsRepository repository;
  late StockFilterService filterService;

  const locations = GetMiejscaResponseData(
    items: [
      GetMiejscaItem(
        id: 1,
        idMiejsca: 101,
        idFirmy: 15,
        nazwa: 'Magazyn Główny',
      ),
    ],
    meta: GetMiejscaMeta(total: 1),
  );

  setUpAll(() async {
    tempDir = await initTestHive(prefix: 'ready_next_locations_cubit_test_');
  });

  tearDownAll(() async {
    await disposeTestHive(tempDir);
  });

  setUp(() async {
    await StockFilterStorage().clear();
    await StockFilterStorage().init(forceReload: true);
    repository = _MockLocationsRepository();
    filterService = StockFilterService();

    when(
      () => repository.fetchLocations(
        firma: any(named: 'firma'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Right(locations));
  });

  tearDown(() async {
    await filterService.close();
  });

  group('LocationsCubit', () {
    blocTest<LocationsCubit, LocationsState>(
      'load: emituje loading i success (wykrywa brak mapowania listy miejsc)',
      build: () =>
          LocationsCubit(repository: repository, filterService: filterService),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);
        await cubit.load(firma: 15);
      },
      expect: () => <LocationsState>[
        const LocationsLoading(),
        const LocationsSuccess(data: locations),
        const LocationsLoading(),
        const LocationsSuccess(data: locations),
      ],
      verify: (_) {
        verify(() => repository.fetchLocations(firma: 15)).called(1);
      },
    );

    blocTest<LocationsCubit, LocationsState>(
      'refresh: wymusza forceRefresh=true (wykrywa odswiezanie bez pomijania cache)',
      build: () =>
          LocationsCubit(repository: repository, filterService: filterService),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);
        await cubit.refresh();
      },
      expect: () => <LocationsState>[
        const LocationsLoading(),
        const LocationsSuccess(data: locations),
        const LocationsLoading(),
        const LocationsSuccess(data: locations),
      ],
      verify: (_) {
        verify(() => repository.fetchLocations(forceRefresh: true)).called(1);
      },
    );

    blocTest<LocationsCubit, LocationsState>(
      'load: emituje error przy bledzie repozytorium (wykrywa utrate bledu dla UI)',
      setUp: () {
        when(
          () => repository.fetchLocations(
            firma: any(named: 'firma'),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak danych miejsc.',
            ),
          ),
        );
      },
      build: () =>
          LocationsCubit(repository: repository, filterService: filterService),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);
        await cubit.load(firma: 15);
      },
      expect: () => const <LocationsState>[
        LocationsLoading(),
        LocationsError(message: 'Brak danych miejsc.'),
        LocationsLoading(),
        LocationsError(message: 'Brak danych miejsc.'),
      ],
    );

    test(
      'load: ignoruje spozniona odpowiedz starszego requestu i zostawia nowszy stan (wykrywa race condition zmiany firmy)',
      () async {
        final firstResponse =
            Completer<Either<ApiError, GetMiejscaResponseData>>();
        final secondResponse =
            Completer<Either<ApiError, GetMiejscaResponseData>>();
        const firstLocations = GetMiejscaResponseData(
          items: [
            GetMiejscaItem(
              id: 1,
              idMiejsca: 101,
              idFirmy: 15,
              nazwa: 'Stary magazyn',
            ),
          ],
          meta: GetMiejscaMeta(total: 1),
        );
        const secondLocations = GetMiejscaResponseData(
          items: [
            GetMiejscaItem(
              id: 2,
              idMiejsca: 202,
              idFirmy: 20,
              nazwa: 'Nowy magazyn',
            ),
          ],
          meta: GetMiejscaMeta(total: 1),
        );

        when(
          () => repository.fetchLocations(
            firma: any(named: 'firma'),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer((invocation) {
          final firma = invocation.namedArguments[#firma] as int?;
          if (firma == 15) {
            return firstResponse.future;
          }
          if (firma == 20) {
            return secondResponse.future;
          }
          return Future.value(const Right(locations));
        });

        final cubit = LocationsCubit(
          repository: repository,
          filterService: filterService,
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);

        final emittedStates = <LocationsState>[];
        final subscription = cubit.stream.listen(emittedStates.add);

        unawaited(cubit.load(firma: 15));
        await Future<void>.delayed(Duration.zero);

        unawaited(cubit.load(firma: 20));
        await Future<void>.delayed(Duration.zero);

        secondResponse.complete(
          const Right<ApiError, GetMiejscaResponseData>(secondLocations),
        );
        await Future<void>.delayed(Duration.zero);
        firstResponse.complete(
          const Right<ApiError, GetMiejscaResponseData>(firstLocations),
        );
        await Future<void>.delayed(Duration.zero);

        expect(emittedStates, const <LocationsState>[
          LocationsLoading(),
          LocationsSuccess(data: secondLocations),
        ]);
        expect(cubit.state, const LocationsSuccess(data: secondLocations));

        await subscription.cancel();
        await cubit.close();
      },
    );
  });
}
