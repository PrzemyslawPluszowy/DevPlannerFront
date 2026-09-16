import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_duplicates_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_duplicates_cubit.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

class _MockStockRepository extends Mock implements StockRepository {}

void main() {
  late StockRepository repository;

  const duplicatesData = GetStanStDuplicatesResponseData(
    items: [
      GetStanStDuplicateGroup(
        nrewid: 'ST-1',
        normalizedNrewid: 'ST-1',
        nrewidVariants: ['ST-1'],
        firmy: [2, 4],
        duplicatesCount: 2,
        entries: [
          GetStanStDuplicateEntry(id: 1, firma: 2, nrewid: 'ST-1'),
          GetStanStDuplicateEntry(id: 2, firma: 4, nrewid: 'ST-1'),
        ],
      ),
    ],
    meta: GetStanStDuplicatesMeta(totalGroups: 1, totalEntries: 2),
  );

  setUp(() {
    repository = _MockStockRepository();
  });

  blocTest<
    StockDuplicatesCubit,
    LoadableState<GetStanStDuplicatesResponseData>
  >(
    'load emituje loading i success dla duplikatow stan_st',
    setUp: () {
      when(
        () => repository.fetchStockDuplicates(),
      ).thenAnswer((_) async => const Right(duplicatesData));
    },
    build: () => StockDuplicatesCubit(repository: repository),
    act: (cubit) => cubit.load(),
    expect: () => const [
      LoadableLoading<GetStanStDuplicatesResponseData>(),
      LoadableSuccess<GetStanStDuplicatesResponseData>(data: duplicatesData),
    ],
  );

  blocTest<
    StockDuplicatesCubit,
    LoadableState<GetStanStDuplicatesResponseData>
  >(
    'refresh emituje loading z poprzednimi danymi i potem error',
    setUp: () {
      when(
        () => repository.fetchStockDuplicates(),
      ).thenAnswer((_) async => const Right(duplicatesData));
    },
    build: () => StockDuplicatesCubit(repository: repository),
    act: (cubit) async {
      await cubit.load();
      when(
        () => repository.fetchStockDuplicates(),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.connection,
            message: 'Brak polaczenia z duplikatami stan_st.',
          ),
        ),
      );
      await cubit.refresh();
    },
    expect: () => const [
      LoadableLoading<GetStanStDuplicatesResponseData>(),
      LoadableSuccess<GetStanStDuplicatesResponseData>(data: duplicatesData),
      LoadableLoading<GetStanStDuplicatesResponseData>(
        previousData: duplicatesData,
      ),
      LoadableError<GetStanStDuplicatesResponseData>(
        message: 'Brak polaczenia z duplikatami stan_st.',
        previousData: duplicatesData,
      ),
    ],
  );
}
