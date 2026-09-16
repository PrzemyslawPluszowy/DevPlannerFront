import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_inventory_dates_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_inventory_dates_state.dart';

/// Mock repozytorium inwentaryzacji dla testów cubita dat.
class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

/// Wartość zastępcza requestu aktualizacji inwentaryzacji.
class _FakePatchInwentaryzacjaRequest extends Fake
    implements PatchInwentaryzacjaRequest {}

void main() {
  late InventoriesRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakePatchInwentaryzacjaRequest());
  });

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  const request = PatchInwentaryzacjaRequest(
    dataOd: '2026-01-01',
    dataDo: '2026-12-31',
    numer: 'INV/2026',
  );

  blocTest<UpdateInventoryDatesCubit, UpdateInventoryDatesState>(
    'submit: przekazuje request 1:1 i emituje sukces',
    setUp: () {
      when(
        () => repository.updateInventory(
          inventoryId: any(named: 'inventoryId'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => const Right(
          PatchInwentaryzacjaResponseData(id: 71),
        ),
      );
    },
    build: () => UpdateInventoryDatesCubit(repository: repository),
    act: (cubit) => cubit.submit(inventoryId: 71, query: request),
    expect: () => const <UpdateInventoryDatesState>[
      UpdateInventoryDatesSubmitting(),
      UpdateInventoryDatesSuccess(),
    ],
    verify: (_) {
      verify(
        () => repository.updateInventory(
          inventoryId: 71,
          query: request,
        ),
      ).called(1);
    },
  );

  blocTest<UpdateInventoryDatesCubit, UpdateInventoryDatesState>(
    'submit: przekazuje komunikat błędu backendu',
    setUp: () {
      when(
        () => repository.updateInventory(
          inventoryId: any(named: 'inventoryId'),
          query: any(named: 'query'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Nieprawidłowy zakres dat.',
          ),
        ),
      );
    },
    build: () => UpdateInventoryDatesCubit(repository: repository),
    act: (cubit) => cubit.submit(inventoryId: 71, query: request),
    expect: () => const <UpdateInventoryDatesState>[
      UpdateInventoryDatesSubmitting(),
      UpdateInventoryDatesError(message: 'Nieprawidłowy zakres dat.'),
    ],
  );
}
