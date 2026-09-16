import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/put_komisja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/cubit/edit_commission_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/cubit/edit_commission_state.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

class _FakeUpdateKomisjaRequest extends Fake implements UpdateKomisjaRequest {}

void main() {
  late InventoriesRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakeUpdateKomisjaRequest());
  });

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('EditCommissionCubit', () {
    blocTest<EditCommissionCubit, EditCommissionState>(
      'submit(inventory): emituje sending i saved przy sukcesie (wykrywa brak zapisu komisji inwentaryzacji)',
      setUp: () {
        when(
          () => repository.updateInventoryCommittee(
            inventoryId: 10,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Right(KomisjaUpdateData(id: 10, komisjaCount: 2)),
        );
      },
      build: () => EditCommissionCubit(
        repository: repository,
        targetType: EditCommissionTargetType.inventory,
        targetId: 10,
      ),
      act: (cubit) => cubit.submit(const [3759, 3812]),
      expect: () => const <EditCommissionState>[
        EditCommissionSending(),
        EditCommissionSaved(),
      ],
      verify: (_) {
        final verification = verify(
          () => repository.updateInventoryCommittee(
            inventoryId: 10,
            query: captureAny(named: 'query'),
          ),
        );
        verification.called(1);
        final captured = verification.captured.single as UpdateKomisjaRequest;
        expect(captured.komisja, const [3759, 3812]);
        verifyNever(
          () => repository.updateArkuszCommittee(
            arkuszId: any(named: 'arkuszId'),
            query: any(named: 'query'),
          ),
        );
      },
    );

    blocTest<EditCommissionCubit, EditCommissionState>(
      'submit(arkusz): emituje sending i saved przy sukcesie (wykrywa pomylony endpoint targetu)',
      setUp: () {
        when(
          () => repository.updateArkuszCommittee(
            arkuszId: 77,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Right(KomisjaUpdateData(id: 77, komisjaCount: 2)),
        );
      },
      build: () => EditCommissionCubit(
        repository: repository,
        targetType: EditCommissionTargetType.arkusz,
        targetId: 77,
      ),
      act: (cubit) => cubit.submit(const [3759, 3812]),
      expect: () => const <EditCommissionState>[
        EditCommissionSending(),
        EditCommissionSaved(),
      ],
      verify: (_) {
        final verification = verify(
          () => repository.updateArkuszCommittee(
            arkuszId: 77,
            query: captureAny(named: 'query'),
          ),
        );
        verification.called(1);
        final captured = verification.captured.single as UpdateKomisjaRequest;
        expect(captured.komisja, const [3759, 3812]);
      },
    );

    blocTest<EditCommissionCubit, EditCommissionState>(
      'submit: po bledzie wraca do ready z submitError (wykrywa utrate komunikatu walidacji)',
      setUp: () {
        when(
          () => repository.updateInventoryCommittee(
            inventoryId: 10,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Komisja musi miec minimum 2 osoby.',
            ),
          ),
        );
      },
      build: () => EditCommissionCubit(
        repository: repository,
        targetType: EditCommissionTargetType.inventory,
        targetId: 10,
      ),
      act: (cubit) => cubit.submit(const [3759]),
      expect: () => const <EditCommissionState>[
        EditCommissionSending(),
        EditCommissionReady(submitError: 'Komisja musi miec minimum 2 osoby.'),
      ],
    );

    blocTest<EditCommissionCubit, EditCommissionState>(
      'submit: gdy trwa wysylka, ignoruje kolejny submit (wykrywa podwojny PUT komisji)',
      setUp: () {
        when(
          () => repository.updateInventoryCommittee(
            inventoryId: 10,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async {
            await Future<void>.delayed(const Duration(milliseconds: 40));
            return const Right(KomisjaUpdateData(id: 10, komisjaCount: 2));
          },
        );
      },
      build: () => EditCommissionCubit(
        repository: repository,
        targetType: EditCommissionTargetType.inventory,
        targetId: 10,
      ),
      act: (cubit) async {
        unawaited(cubit.submit(const [3759, 3812]));
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await cubit.submit(const [3759, 3812]);
      },
      wait: const Duration(milliseconds: 60),
      expect: () => const <EditCommissionState>[
        EditCommissionSending(),
        EditCommissionSaved(),
      ],
      verify: (_) {
        final verification = verify(
          () => repository.updateInventoryCommittee(
            inventoryId: 10,
            query: captureAny(named: 'query'),
          ),
        );
        verification.called(1);
        final captured = verification.captured.single as UpdateKomisjaRequest;
        expect(captured.komisja, const [3759, 3812]);
      },
    );
  });
}
