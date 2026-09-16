import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/cubit/inventories_cubit.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

class _FakeGetInwentaryzacjeQuery extends Fake
    implements GetInwentaryzacjeQuery {}

void main() {
  late InventoriesRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeGetInwentaryzacjeQuery());
  });

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('InventoriesCubit', () {
    const responseData = GetInwentaryzacjeResponseData(
      items: [
        GetInwentaryzacjeItem(
          id: 1,
          firma: 1,
          numer: 'INV/1',
          status: InwentaryzacjaStatus.wToku,
          komisjaCount: 2,
          arkuszeCount: 3,
        ),
      ],
      meta: GetInwentaryzacjeMeta(
        total: 1,
        sortBy: 'id',
        sortDir: 'DESC',
      ),
    );

    blocTest<InventoriesCubit, LoadableState<GetInwentaryzacjeResponseData>>(
      'emituje loading i success gdy repository zwraca dane',
      setUp: () {
        when(
          () => repository.fetchInventories(any()),
        ).thenAnswer((_) async => const Right(responseData));
      },
      build: () => InventoriesCubit(repository: repository),
      act: (cubit) => cubit.load(),
      expect: () => <dynamic>[
        const LoadableLoading<GetInwentaryzacjeResponseData>(),
        isA<LoadableSuccess<GetInwentaryzacjeResponseData>>()
            .having(
              (state) => state.data.items.length,
              'items.length',
              1,
            )
            .having(
              (state) => state.data.items.single.numer,
              'items.single.numer',
              'INV/1',
            )
            .having(
              (state) => state.data.items.single.status,
              'items.single.status',
              InwentaryzacjaStatus.wToku,
            )
            .having(
              (state) => state.data.meta.total,
              'meta.total',
              1,
            ),
      ],
      verify: (_) {
        verify(() => repository.fetchInventories(any())).called(1);
      },
    );

    blocTest<InventoriesCubit, LoadableState<GetInwentaryzacjeResponseData>>(
      'emituje loading i error gdy repository zwraca blad',
      setUp: () {
        when(
          () => repository.fetchInventories(any()),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Nie mozna polaczyc sie z serwerem.',
            ),
          ),
        );
      },
      build: () => InventoriesCubit(repository: repository),
      act: (cubit) => cubit.load(),
      expect: () => [
        const LoadableLoading<GetInwentaryzacjeResponseData>(),
        const LoadableError<GetInwentaryzacjeResponseData>(
          message: 'Nie mozna polaczyc sie z serwerem.',
        ),
      ],
    );
  });
}
