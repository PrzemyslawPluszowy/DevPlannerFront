import 'dart:async';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';

import '../../../../../../test_support/test_hive.dart';

class _MockStockRepository extends Mock implements StockRepository {}

class _FakeGetStanStQuery extends Fake implements GetStanStQuery {}

void main() {
  late Directory tempDir;
  late StockRepository repository;
  late StockFilterService filterService;

  const stockData = GetStanStResponseData(
    items: [GetStanStItem(id: 1, nazwa: 'Laptop', nrewid: 'ST-1')],
    meta: GetStanStMeta(total: 1, limit: 50, offset: 0),
  );

  setUpAll(() async {
    registerFallbackValue(_FakeGetStanStQuery());
    tempDir = await initTestHive(prefix: 'ready_next_stock_cubit_test_');
  });

  tearDownAll(() async {
    await disposeTestHive(tempDir);
  });

  setUp(() async {
    await StockFilterStorage().clear();
    await StockFilterStorage().init(forceReload: true);
    repository = _MockStockRepository();
    filterService = StockFilterService();

    when(
      () => repository.fetchStock(any()),
    ).thenAnswer((_) async => const Right(stockData));
    when(
      () => repository.fetchCompanies(forceRefresh: any(named: 'forceRefresh')),
    ).thenAnswer(
      (_) async =>
          const Right([GetFirmyItem(id: 15, idFirmy: 15, nazwa: 'Firma A')]),
    );
  });

  tearDown(() async {
    await filterService.close();
  });

  group('StockCubit', () {
    blocTest<StockCubit, StockState>(
      'load: emituje loading i success dla globalnego q i statusu (wykrywa brak mapowania params->query)',
      build: () =>
          StockCubit(repository: repository, filterService: filterService),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);
        await cubit.load(
          const StockQueryParams(
            firma: 15,
            status: SrodekTrwalyStatus.zlikwidowany,
            offset: 0,
            limit: 50,
            q: '  laptop  ',
          ),
        );
      },
      expect: () => const <StockState>[
        StockLoading(),
        StockSuccess(data: stockData),
        StockLoading(),
        StockSuccess(data: stockData),
      ],
      verify: (_) {
        final verification = verify(() => repository.fetchStock(captureAny()));
        verification.called(1);
        final query = verification.captured.single as GetStanStQuery;
        expect(query.firma, 15);
        expect(query.stan, '2');
        expect(query.q, 'laptop');
        expect(query.limit, 50);
        expect(query.offset, 0);
        expect(query.nazwa, isNull);
        expect(query.nrewid, isNull);
        expect(query.kodKreskowy, isNull);
      },
    );

    blocTest<StockCubit, StockState>(
      'load: emituje error gdy repository zwraca blad (wykrywa utrate komunikatu bledu listy ST)',
      setUp: () {
        when(() => repository.fetchStock(any())).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak polaczenia z ST.',
            ),
          ),
        );
      },
      build: () =>
          StockCubit(repository: repository, filterService: filterService),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);
        await cubit.load(StockQueryParams.defaults);
      },
      expect: () => const <StockState>[
        StockLoading(),
        StockError(message: 'Brak polaczenia z ST.'),
        StockLoading(),
        StockError(message: 'Brak polaczenia z ST.'),
      ],
    );

    test(
      'loadInitialData: po sukcesie wpisuje firmy do StockFilterService (wykrywa brak inicjalizacji filtra firmy)',
      () async {
        final cubit = StockCubit(
          repository: repository,
          filterService: filterService,
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));

        await cubit.loadInitialData();

        expect(filterService.lastCompanies, const [
          GetFirmyItem(id: 15, idFirmy: 15, nazwa: 'Firma A'),
        ]);
        await cubit.close();
      },
    );

    test(
      'zmiana statusu w filtrze zachowuje ostatni sukces do czasu nowego wyniku',
      () async {
        final cubit = StockCubit(
          repository: repository,
          filterService: filterService,
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));

        filterService.setStatus(SrodekTrwalyStatus.przeniesiony);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(cubit.state, isA<StockSuccess>());
        expect(filterService.currentStatus, SrodekTrwalyStatus.przeniesiony);
        await cubit.close();
      },
    );

    test(
      'odtwarza zapisane filtry z Hive po ponownym utworzeniu serwisu',
      () async {
        filterService
          ..setFirma(15)
          ..setStatus(SrodekTrwalyStatus.zlikwidowany)
          ..setLimit(100)
          ..setQuery(' laptop ');
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await filterService.close();
        await StockFilterStorage().init(forceReload: true);

        final restoredService = StockFilterService();

        expect(restoredService.currentFirma, 15);
        expect(restoredService.currentStatus, SrodekTrwalyStatus.zlikwidowany);
        expect(restoredService.currentLimit, 100);
        expect(restoredService.currentQuery, 'laptop');
        expect(restoredService.currentOffset, 0);

        await restoredService.close();
      },
    );

    test(
      'zmiana statusu po paginacji wysyla jeden request z wyzerowanym offsetem',
      () async {
        final cubit = StockCubit(
          repository: repository,
          filterService: filterService,
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);

        filterService.setOffset(50);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);

        filterService.setStatus(SrodekTrwalyStatus.zlikwidowany);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        final verification = verify(() => repository.fetchStock(captureAny()));
        verification.called(1);

        final query = verification.captured.single as GetStanStQuery;
        expect(query.stan, '2');
        expect(query.offset, 0);

        await cubit.close();
      },
    );

    test(
      'load: ignoruje spozniona odpowiedz starszego requestu i zostawia nowszy stan (wykrywa race condition filtrowania)',
      () async {
        final firstResponse =
            Completer<Either<ApiError, GetStanStResponseData>>();
        final secondResponse =
            Completer<Either<ApiError, GetStanStResponseData>>();
        const firstData = GetStanStResponseData(
          items: [GetStanStItem(id: 1, nazwa: 'Stary wynik')],
          meta: GetStanStMeta(total: 1, limit: 50, offset: 0),
        );
        const secondData = GetStanStResponseData(
          items: [GetStanStItem(id: 2, nazwa: 'Nowy wynik')],
          meta: GetStanStMeta(total: 1, limit: 50, offset: 0),
        );

        when(() => repository.fetchStock(any())).thenAnswer((invocation) {
          final query = invocation.positionalArguments.single as GetStanStQuery;
          if (query.q == 'stary') {
            return firstResponse.future;
          }
          if (query.q == 'nowy') {
            return secondResponse.future;
          }
          return Future.value(const Right(stockData));
        });

        final cubit = StockCubit(
          repository: repository,
          filterService: filterService,
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
        clearInteractions(repository);

        final emittedStates = <StockState>[];
        final subscription = cubit.stream.listen(emittedStates.add);

        unawaited(
          cubit.load(
            const StockQueryParams(
              firma: null,
              status: null,
              offset: 0,
              limit: 50,
              q: 'stary',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        unawaited(
          cubit.load(
            const StockQueryParams(
              firma: null,
              status: null,
              offset: 0,
              limit: 50,
              q: 'nowy',
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        secondResponse.complete(
          const Right<ApiError, GetStanStResponseData>(secondData),
        );
        await Future<void>.delayed(Duration.zero);
        firstResponse.complete(
          const Right<ApiError, GetStanStResponseData>(firstData),
        );
        await Future<void>.delayed(Duration.zero);

        expect(emittedStates, const <StockState>[
          StockLoading(),
          StockSuccess(data: secondData),
        ]);
        expect(cubit.state, const StockSuccess(data: secondData));

        await subscription.cancel();
        await cubit.close();
      },
    );
  });
}
