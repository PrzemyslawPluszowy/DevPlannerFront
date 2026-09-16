import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/cubit/arkusz_preview_cubit.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

void main() {
  late InventoriesRepository repository;

  const details = GetArkuszDetailsResponseData(
    arkusz: GetArkuszDetailsHeader(id: 12, idInwentaryzacja: 70),
    komisja: [
      GetArkuszDetailsKomisjaItem(userId: 3759, displayName: 'Jan Nowak'),
    ],
    elementy: [GetArkuszDetailsElementItem(id: 1, nazwa: 'Laptop')],
  );

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('ArkuszPreviewCubit', () {
    blocTest<ArkuszPreviewCubit, LoadableState<GetArkuszDetailsResponseData>>(
      'load: emituje loading i success (wykrywa brak podgladu arkusza po wyborze)',
      setUp: () {
        when(
          () => repository.fetchArkuszDetails(12),
        ).thenAnswer((_) async => const Right(details));
      },
      build: () => ArkuszPreviewCubit(repository: repository),
      act: (cubit) => cubit.load(12),
      expect: () => const <LoadableState<GetArkuszDetailsResponseData>>[
        LoadableLoading<GetArkuszDetailsResponseData>(),
        LoadableSuccess<GetArkuszDetailsResponseData>(data: details),
      ],
    );

    blocTest<ArkuszPreviewCubit, LoadableState<GetArkuszDetailsResponseData>>(
      'load: emituje loading i error przy bledzie backendu (wykrywa ciche niepowodzenie modalu)',
      setUp: () {
        when(
          () => repository.fetchArkuszDetails(12),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak danych arkusza.',
            ),
          ),
        );
      },
      build: () => ArkuszPreviewCubit(repository: repository),
      act: (cubit) => cubit.load(12),
      expect: () => const <LoadableState<GetArkuszDetailsResponseData>>[
        LoadableLoading<GetArkuszDetailsResponseData>(),
        LoadableError<GetArkuszDetailsResponseData>(
          message: 'Brak danych arkusza.',
        ),
      ],
    );
  });
}
