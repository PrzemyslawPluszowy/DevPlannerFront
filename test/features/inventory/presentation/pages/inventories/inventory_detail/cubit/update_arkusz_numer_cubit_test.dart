import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_numer_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_numer_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_numer_state.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

class _FakeUpdateArkuszNumerRequest extends Fake
    implements UpdateArkuszNumerRequest {}

void main() {
  late InventoriesRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeUpdateArkuszNumerRequest());
  });

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('UpdateArkuszNumerCubit', () {
    blocTest<UpdateArkuszNumerCubit, UpdateArkuszNumerState>(
      'submit: sukces emituje submitting i success',
      setUp: () {
        when(
          () => repository.updateArkuszNumer(
            arkuszId: any(named: 'arkuszId'),
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Right(
            UpdateArkuszNumerResponseData(id: 33),
          ),
        );
      },
      build: () => UpdateArkuszNumerCubit(repository: repository),
      act: (cubit) => cubit.submit(arkuszId: 33, numer: 'ARK/RENAMED/001'),
      expect: () => const <UpdateArkuszNumerState>[
        UpdateArkuszNumerSubmitting(),
        UpdateArkuszNumerSuccess(),
      ],
      verify: (_) {
        final captured =
            verify(
                  () => repository.updateArkuszNumer(
                    arkuszId: 33,
                    query: captureAny(named: 'query'),
                  ),
                ).captured.single
                as UpdateArkuszNumerRequest;
        expect(captured.numer, 'ARK/RENAMED/001');
      },
    );

    blocTest<UpdateArkuszNumerCubit, UpdateArkuszNumerState>(
      'submit: blad backendu emituje submitting i error',
      setUp: () {
        when(
          () => repository.updateArkuszNumer(
            arkuszId: any(named: 'arkuszId'),
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Arkusz o tym numerze juz istnieje w tej inwentaryzacji.',
            ),
          ),
        );
      },
      build: () => UpdateArkuszNumerCubit(repository: repository),
      act: (cubit) => cubit.submit(arkuszId: 33, numer: 'ARK/EXISTS/001'),
      expect: () => const <UpdateArkuszNumerState>[
        UpdateArkuszNumerSubmitting(),
        UpdateArkuszNumerError(
          message: 'Arkusz o tym numerze juz istnieje w tej inwentaryzacji.',
        ),
      ],
    );
  });
}
