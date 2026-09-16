import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_detail_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_detail_state.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

void main() {
  late InventoriesRepository repository;

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  const details = GetInwentaryzacjaDetailsResponseData(
    inwentaryzacja: GetInwentaryzacjaDetailsHeader(
      id: 71,
      firma: 15,
      numer: 'INV/71',
      status: 1,
    ),
    komisja: [
      GetInwentaryzacjaDetailsKomisjaItem(
        id: 1,
        userId: 3759,
        displayName: 'Jan Nowak',
      ),
    ],
    arkusze: [GetInwentaryzacjaDetailsArkuszItem(id: 7001, idMiejsca: 101)],
  );

  group('InventoryDetailCubit', () {
    blocTest<InventoryDetailCubit, InventoryDetailState>(
      'load: emituje loading i loaded gdy backend zwraca dane (wykrywa brak odswiezenia szczegolow)',
      setUp: () {
        when(
          () => repository.fetchInventoryDetails(71),
        ).thenAnswer((_) async => const Right(details));
      },
      build: () => InventoryDetailCubit(repository: repository),
      act: (cubit) => cubit.load(71),
      expect: () => const <InventoryDetailState>[
        InventoryDetailLoading(),
        InventoryDetailLoaded(data: details),
      ],
      verify: (_) {
        verify(() => repository.fetchInventoryDetails(71)).called(1);
      },
    );

    blocTest<InventoryDetailCubit, InventoryDetailState>(
      'load: emituje loading i error gdy backend zwraca blad (wykrywa utrate komunikatu bledu)',
      setUp: () {
        when(
          () => repository.fetchInventoryDetails(71),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.notFound,
              message: 'Nie znaleziono inwentaryzacji.',
            ),
          ),
        );
      },
      build: () => InventoryDetailCubit(repository: repository),
      act: (cubit) => cubit.load(71),
      expect: () => const <InventoryDetailState>[
        InventoryDetailLoading(),
        InventoryDetailError(message: 'Nie znaleziono inwentaryzacji.'),
      ],
    );
  });
}
