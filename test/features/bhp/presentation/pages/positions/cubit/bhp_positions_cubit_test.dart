import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/cubit/bhp_positions_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/cubit/bhp_positions_state.dart';

class _MockBhpPositionsRepository extends Mock
    implements BhpPositionsRepository {}

void main() {
  late BhpPositionsRepository repository;

  const activePosition = GetBhpPositionListItem(
    id: 7,
    nazwa: 'Magazynier',
    aktywny: true,
    uwagi: 'Zmiana A',
  );

  setUp(() {
    repository = _MockBhpPositionsRepository();
  });

  group('BhpPositionsCubit', () {
    blocTest<BhpPositionsCubit, BhpPositionsState>(
      'load: emituje loading i success dla aktywnych stanowisk',
      setUp: () {
        when(
          () => repository.getPositions(active: true),
        ).thenAnswer((_) async => const Right([activePosition]));
      },
      build: () => BhpPositionsCubit(repository: repository),
      act: (cubit) => cubit.load(),
      expect: () => const <BhpPositionsState>[
        BhpPositionsLoading(),
        BhpPositionsSuccess(
          items: [activePosition],
          filter: BhpPositionsFilter.aktywne,
        ),
      ],
    );

    blocTest<BhpPositionsCubit, BhpPositionsState>(
      'unarchivePosition: przywraca stanowisko i odświeża listę dla bieżącego filtra',
      setUp: () {
        when(
          () => repository.unarchivePosition(activePosition.id),
        ).thenAnswer((_) async => const Right(activePosition));
        when(
          () => repository.getPositions(active: false),
        ).thenAnswer((_) async => const Right([]));
      },
      build: () => BhpPositionsCubit(repository: repository),
      seed: () => const BhpPositionsSuccess(
        items: [],
        filter: BhpPositionsFilter.nieaktywne,
      ),
      act: (cubit) => cubit.unarchivePosition(activePosition.id),
      expect: () => const <BhpPositionsState>[
        BhpPositionsLoading(),
        BhpPositionsSuccess(
          items: [],
          filter: BhpPositionsFilter.nieaktywne,
        ),
      ],
    );

    blocTest<BhpPositionsCubit, BhpPositionsState>(
      'unarchivePosition: zwraca błąd bez przeładowania listy gdy backend odrzuci operację',
      setUp: () {
        when(
          () => repository.unarchivePosition(activePosition.id),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Nie można przywrócić stanowiska.',
            ),
          ),
        );
      },
      build: () => BhpPositionsCubit(repository: repository),
      seed: () => const BhpPositionsSuccess(
        items: [],
        filter: BhpPositionsFilter.nieaktywne,
      ),
      act: (cubit) => cubit.unarchivePosition(activePosition.id),
      expect: () => const <BhpPositionsState>[],
    );
  });
}
