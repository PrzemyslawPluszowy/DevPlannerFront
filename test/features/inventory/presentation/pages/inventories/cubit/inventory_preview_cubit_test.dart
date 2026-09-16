import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/cubit/inventory_preview_cubit.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

void main() {
  late InventoriesRepository repository;

  const details = GetInwentaryzacjaDetailsResponseData(
    inwentaryzacja: GetInwentaryzacjaDetailsHeader(
      id: 70,
      firma: 15,
      numer: 'INV/70',
      status: 1,
    ),
    komisja: [
      GetInwentaryzacjaDetailsKomisjaItem(
        id: 1,
        userId: 3759,
        displayName: 'Jan Nowak',
      ),
    ],
    arkusze: [GetInwentaryzacjaDetailsArkuszItem(id: 701, idMiejsca: 101)],
  );

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('InventoryPreviewCubit', () {
    blocTest<
      InventoryPreviewCubit,
      LoadableState<GetInwentaryzacjaDetailsResponseData>
    >(
      'load: emituje loading i success (wykrywa brak danych podgladu inwentaryzacji)',
      setUp: () {
        when(
          () => repository.fetchInventoryDetails(70),
        ).thenAnswer((_) async => const Right(details));
      },
      build: () => InventoryPreviewCubit(repository: repository),
      act: (cubit) => cubit.load(70),
      expect: () => const <LoadableState<GetInwentaryzacjaDetailsResponseData>>[
        LoadableLoading<GetInwentaryzacjaDetailsResponseData>(),
        LoadableSuccess<GetInwentaryzacjaDetailsResponseData>(data: details),
      ],
    );

    blocTest<
      InventoryPreviewCubit,
      LoadableState<GetInwentaryzacjaDetailsResponseData>
    >(
      'load: emituje loading i error przy bledzie backendu (wykrywa brak stanu bledu podgladu)',
      setUp: () {
        when(
          () => repository.fetchInventoryDetails(70),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.notFound,
              message: 'Nie znaleziono inwentaryzacji.',
            ),
          ),
        );
      },
      build: () => InventoryPreviewCubit(repository: repository),
      act: (cubit) => cubit.load(70),
      expect: () => const <LoadableState<GetInwentaryzacjaDetailsResponseData>>[
        LoadableLoading<GetInwentaryzacjaDetailsResponseData>(),
        LoadableError<GetInwentaryzacjaDetailsResponseData>(
          message: 'Nie znaleziono inwentaryzacji.',
        ),
      ],
    );
  });
}
