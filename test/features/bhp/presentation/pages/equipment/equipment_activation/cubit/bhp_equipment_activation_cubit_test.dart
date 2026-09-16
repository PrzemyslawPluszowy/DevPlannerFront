import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_activation/cubit/bhp_equipment_activation_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_activation/cubit/bhp_equipment_activation_state.dart';

/// Mock repozytorium wyposażenia dla flow aktywacji.
class _MockBhpEquipmentRepository extends Mock
    implements BhpEquipmentRepository {}

/// Testowa wersja cubita z możliwością ustawienia stanu początkowego.
class _TestBhpEquipmentActivationCubit extends BhpEquipmentActivationCubit {
  _TestBhpEquipmentActivationCubit({
    required super.repository,
    required super.equipment,
    required super.mode,
  });

  void seedState(BhpEquipmentActivationState state) => emit(state);
}

void main() {
  late BhpEquipmentRepository repository;

  const equipment = GetBhpEquipmentListItem(
    id: 16,
    symbol: 'KASK',
    nazwa: 'Kask ochronny',
    aktywny: false,
    jm: 'szt.',
  );

  const impact = GetBhpEquipmentActivationImpact(
    equipment: GetBhpEquipmentActivationImpactEquipment(
      id: 16,
      symbol: 'KASK',
      nazwa: 'Kask ochronny',
      aktywny: false,
    ),
    activeStandardsCount: 1,
    inactiveStandardsCount: 2,
    standards: [
      GetBhpEquipmentActivationImpactStandard(
        id: 14,
        aktywny: true,
        ilosc: '1.00',
        okres: 12,
        positionId: 1,
        positionName: 'Magazynier',
        positionActive: true,
      ),
      GetBhpEquipmentActivationImpactStandard(
        id: 15,
        aktywny: false,
        ilosc: '1.00',
        okres: 24,
        positionId: 2,
        positionName: 'Spawacz',
        positionActive: true,
      ),
      GetBhpEquipmentActivationImpactStandard(
        id: 19,
        aktywny: false,
        positionId: 3,
        positionName: 'Operator',
        positionActive: false,
      ),
    ],
  );

  const activatedEquipment = GetBhpEquipmentDetails(
    id: 16,
    symbol: 'KASK',
    nazwa: 'Kask ochronny',
    aktywny: true,
  );

  setUp(() {
    repository = _MockBhpEquipmentRepository();
  });

  group('BhpEquipmentActivationCubit', () {
    blocTest<BhpEquipmentActivationCubit, BhpEquipmentActivationState>(
      'load: pobiera preview wpływu operacji',
      setUp: () {
        when(
          () => repository.getEquipmentActivationImpact(equipment.id),
        ).thenAnswer((_) async => const Right(impact));
      },
      build: () => BhpEquipmentActivationCubit(
        repository: repository,
        equipment: equipment,
        mode: BhpEquipmentActivationMode.setActive,
      ),
      act: (cubit) => cubit.load(),
      expect: () => const <BhpEquipmentActivationState>[
        BhpEquipmentActivationLoading(),
        BhpEquipmentActivationReady(
          mode: BhpEquipmentActivationMode.setActive,
          impact: impact,
          selectedStandardIds: {},
          isSubmitting: false,
        ),
      ],
    );

    blocTest<BhpEquipmentActivationCubit, BhpEquipmentActivationState>(
      'toggleSelection: zaznacza i odznacza przypisanie do przywrócenia',
      build: () => BhpEquipmentActivationCubit(
        repository: repository,
        equipment: equipment,
        mode: BhpEquipmentActivationMode.setActive,
      ),
      seed: () => const BhpEquipmentActivationReady(
        mode: BhpEquipmentActivationMode.setActive,
        impact: impact,
        selectedStandardIds: {},
        isSubmitting: false,
      ),
      act: (cubit) {
        cubit.toggleSelection(15);
        cubit.toggleSelection(15);
      },
      expect: () => const <BhpEquipmentActivationState>[
        BhpEquipmentActivationReady(
          mode: BhpEquipmentActivationMode.setActive,
          impact: impact,
          selectedStandardIds: {15},
          isSubmitting: false,
        ),
        BhpEquipmentActivationReady(
          mode: BhpEquipmentActivationMode.setActive,
          impact: impact,
          selectedStandardIds: {},
          isSubmitting: false,
        ),
      ],
    );

    blocTest<BhpEquipmentActivationCubit, BhpEquipmentActivationState>(
      'submit: przy aktywacji wysyła wybrane przypisania do przywrócenia',
      setUp: () {
        when(
          () => repository.unarchiveEquipment(
            equipment.id,
            selectedStandardIds: [15, 19],
          ),
        ).thenAnswer((_) async => const Right(activatedEquipment));
      },
      build: () => BhpEquipmentActivationCubit(
        repository: repository,
        equipment: equipment,
        mode: BhpEquipmentActivationMode.setActive,
      ),
      seed: () => const BhpEquipmentActivationReady(
        mode: BhpEquipmentActivationMode.setActive,
        impact: impact,
        selectedStandardIds: {15, 19},
        isSubmitting: false,
      ),
      act: (cubit) => cubit.submit(),
      expect: () => const <BhpEquipmentActivationState>[
        BhpEquipmentActivationReady(
          mode: BhpEquipmentActivationMode.setActive,
          impact: impact,
          selectedStandardIds: {15, 19},
          isSubmitting: true,
        ),
        BhpEquipmentActivationReady(
          mode: BhpEquipmentActivationMode.setActive,
          impact: impact,
          selectedStandardIds: {15, 19},
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(
          () => repository.unarchiveEquipment(
            equipment.id,
            selectedStandardIds: [15, 19],
          ),
        ).called(1);
      },
    );

    test('load: ignoruje spóźnioną odpowiedź po zamknięciu cubita', () async {
      final completer =
          Completer<Either<ApiError, GetBhpEquipmentActivationImpact>>();
      when(
        () => repository.getEquipmentActivationImpact(equipment.id),
      ).thenAnswer((_) => completer.future);

      final cubit = _TestBhpEquipmentActivationCubit(
        repository: repository,
        equipment: equipment,
        mode: BhpEquipmentActivationMode.setActive,
      );
      final emittedStates = <BhpEquipmentActivationState>[];
      final subscription = cubit.stream.listen(emittedStates.add);

      final loadFuture = cubit.load();
      await cubit.close();
      completer.complete(const Right(impact));
      await loadFuture;

      expect(
        emittedStates,
        const <BhpEquipmentActivationState>[BhpEquipmentActivationLoading()],
      );

      await subscription.cancel();
    });

    test('submit: nie emituje stanu końcowego po zamknięciu cubita', () async {
      final completer = Completer<Either<ApiError, GetBhpEquipmentDetails>>();
      when(
        () => repository.unarchiveEquipment(
          equipment.id,
          selectedStandardIds: [15],
        ),
      ).thenAnswer((_) => completer.future);

      final cubit = _TestBhpEquipmentActivationCubit(
        repository: repository,
        equipment: equipment,
        mode: BhpEquipmentActivationMode.setActive,
      );
      const readyState = BhpEquipmentActivationReady(
        mode: BhpEquipmentActivationMode.setActive,
        impact: impact,
        selectedStandardIds: {15},
        isSubmitting: false,
      );
      cubit.seedState(readyState);

      final emittedStates = <BhpEquipmentActivationState>[];
      final subscription = cubit.stream.listen(emittedStates.add);

      final submitFuture = cubit.submit();
      await cubit.close();
      completer.complete(const Right(activatedEquipment));
      await submitFuture;

      expect(
        emittedStates,
        const <BhpEquipmentActivationState>[
          BhpEquipmentActivationReady(
            mode: BhpEquipmentActivationMode.setActive,
            impact: impact,
            selectedStandardIds: {15},
            isSubmitting: true,
          ),
        ],
      );

      await subscription.cancel();
    });
  });
}
