import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/cubit/bhp_position_standards_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/cubit/bhp_position_standards_state.dart';

class _MockBhpPositionsRepository extends Mock
    implements BhpPositionsRepository {}

class _MockBhpEquipmentRepository extends Mock
    implements BhpEquipmentRepository {}

void main() {
  late BhpPositionsRepository positionsRepository;
  late BhpEquipmentRepository equipmentRepository;

  const position = GetBhpPositionListItem(
    id: 7,
    nazwa: 'Magazynier',
    aktywny: true,
    uwagi: 'Zmiana A',
  );

  const equipment = <GetBhpEquipmentListItem>[
    GetBhpEquipmentListItem(
      id: 1,
      symbol: 'BHP-01',
      nazwa: 'Buty',
      aktywny: true,
      procentPrzydatnosci: 100,
      okresUzywalnosci: '12',
      jm: 'para',
      iloscDomyslna: '1',
      cena: '100',
    ),
  ];

  const activeStandard = GetBhpUserStandardItem(
    id: 10,
    stanowiskoId: 7,
    kartaWyposazeniaId: 1,
    kartaWyposazeniaSymbol: 'BHP-01',
    kartaWyposazeniaNazwa: 'Buty',
    kartaWyposazeniaJm: 'para',
    kartaAktywna: true,
    kartaOkresUzywalnosci: '12',
    kartaIloscDomyslna: '1',
    kartaEkwiwalent: '0',
    kartaCena: '100',
    okres: 12,
    ilosc: '1',
    uwagi: 'Zima',
    aktywny: true,
    legacyStatus: null,
  );

  const inactiveStandard = GetBhpUserStandardItem(
    id: 11,
    stanowiskoId: 7,
    kartaWyposazeniaId: 1,
    kartaWyposazeniaSymbol: 'BHP-01',
    kartaWyposazeniaNazwa: 'Buty',
    kartaWyposazeniaJm: 'para',
    kartaAktywna: true,
    kartaOkresUzywalnosci: '12',
    kartaIloscDomyslna: '1',
    kartaEkwiwalent: '0',
    kartaCena: '100',
    okres: 24,
    ilosc: '2',
    uwagi: 'Archiwum',
    aktywny: false,
    legacyStatus: null,
  );

  setUp(() {
    positionsRepository = _MockBhpPositionsRepository();
    equipmentRepository = _MockBhpEquipmentRepository();
  });

  group('BhpPositionStandardsCubit', () {
    blocTest<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      'load: emituje loading i ready z danymi standardu oraz katalogiem wyposażenia',
      setUp: () {
        when(
          () => positionsRepository.getPositionStandards(position.id),
        ).thenAnswer(
          (_) async => const Right([inactiveStandard, activeStandard]),
        );
        when(
          () => equipmentRepository.getEquipment(active: true),
        ).thenAnswer((_) async => const Right(equipment));
      },
      build: () => BhpPositionStandardsCubit(
        position: position,
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
      act: (cubit) => cubit.load(),
      expect: () => const <BhpPositionStandardsState>[
        BhpPositionStandardsLoading(),
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard, inactiveStandard],
          equipment: equipment,
        ),
      ],
    );

    blocTest<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      'createStandard: dopisuje nową pozycję i czyści flagę akcji',
      setUp: () {
        when(
          () => positionsRepository.getPositionStandards(position.id),
        ).thenAnswer((_) async => const Right([activeStandard]));
        when(
          () => equipmentRepository.getEquipment(active: true),
        ).thenAnswer((_) async => const Right(equipment));
      },
      build: () => BhpPositionStandardsCubit(
        position: position,
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
      seed: () => const BhpPositionStandardsReady(
        position: position,
        standards: [activeStandard],
        equipment: equipment,
      ),
      act: (cubit) {
        const request = PostBhpPositionStandardRequest(
          kartaWyposazeniaId: 1,
          okres: 24,
          ilosc: '2',
          uwagi: 'Nowa pozycja',
        );
        when(
          () =>
              positionsRepository.createPositionStandard(position.id, request),
        ).thenAnswer((_) async => const Right(inactiveStandard));
        return cubit.createStandard(request);
      },
      expect: () => const <BhpPositionStandardsState>[
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard],
          equipment: equipment,
          activeAction: BhpPositionStandardAction.creating,
        ),
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard, inactiveStandard],
          equipment: equipment,
        ),
      ],
    );

    blocTest<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      'updateStandard: aktualizuje pozycję standardu po odpowiedzi backendu',
      build: () => BhpPositionStandardsCubit(
        position: position,
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
      seed: () => const BhpPositionStandardsReady(
        position: position,
        standards: [activeStandard],
        equipment: equipment,
      ),
      act: (cubit) {
        const updated = GetBhpUserStandardItem(
          id: 10,
          stanowiskoId: 7,
          kartaWyposazeniaId: 1,
          kartaWyposazeniaSymbol: 'BHP-01',
          kartaWyposazeniaNazwa: 'Buty',
          kartaWyposazeniaJm: 'para',
          kartaAktywna: true,
          kartaOkresUzywalnosci: '12',
          kartaIloscDomyslna: '1',
          kartaEkwiwalent: '0',
          kartaCena: '100',
          okres: 36,
          ilosc: '3',
          uwagi: 'Po aktualizacji',
          aktywny: true,
          legacyStatus: null,
        );
        const request = PatchBhpPositionStandardRequest(
          okres: 36,
          ilosc: '3',
          uwagi: 'Po aktualizacji',
        );
        when(
          () => positionsRepository.updatePositionStandard(
            position.id,
            activeStandard.id,
            request,
          ),
        ).thenAnswer((_) async => const Right(updated));
        return cubit.updateStandard(activeStandard.id, request);
      },
      expect: () => const <BhpPositionStandardsState>[
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard],
          equipment: equipment,
          activeAction: BhpPositionStandardAction.updating,
          activeStandardId: 10,
        ),
        BhpPositionStandardsReady(
          position: position,
          standards: [
            GetBhpUserStandardItem(
              id: 10,
              stanowiskoId: 7,
              kartaWyposazeniaId: 1,
              kartaWyposazeniaSymbol: 'BHP-01',
              kartaWyposazeniaNazwa: 'Buty',
              kartaWyposazeniaJm: 'para',
              kartaAktywna: true,
              kartaOkresUzywalnosci: '12',
              kartaIloscDomyslna: '1',
              kartaEkwiwalent: '0',
              kartaCena: '100',
              okres: 36,
              ilosc: '3',
              uwagi: 'Po aktualizacji',
              aktywny: true,
              legacyStatus: null,
            ),
          ],
          equipment: equipment,
        ),
      ],
    );

    blocTest<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      'archiveStandard: zapisuje błąd akcji gdy backend odrzuci archiwizację',
      build: () => BhpPositionStandardsCubit(
        position: position,
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
      seed: () => const BhpPositionStandardsReady(
        position: position,
        standards: [activeStandard],
        equipment: equipment,
      ),
      act: (cubit) {
        when(
          () => positionsRepository.archivePositionStandard(
            position.id,
            activeStandard.id,
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Nie można zarchiwizować pozycji.',
            ),
          ),
        );
        return cubit.archiveStandard(activeStandard.id);
      },
      expect: () => const <BhpPositionStandardsState>[
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard],
          equipment: equipment,
          activeAction: BhpPositionStandardAction.archiving,
          activeStandardId: 10,
        ),
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard],
          equipment: equipment,
          actionError: 'Nie można zarchiwizować pozycji.',
        ),
      ],
    );

    blocTest<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      'unarchiveStandard: przywraca nieaktywną pozycję standardu',
      build: () => BhpPositionStandardsCubit(
        position: position,
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
      seed: () => const BhpPositionStandardsReady(
        position: position,
        standards: [inactiveStandard],
        equipment: equipment,
      ),
      act: (cubit) {
        const restored = GetBhpUserStandardItem(
          id: 11,
          stanowiskoId: 7,
          kartaWyposazeniaId: 1,
          kartaWyposazeniaSymbol: 'BHP-01',
          kartaWyposazeniaNazwa: 'Buty',
          kartaWyposazeniaJm: 'para',
          kartaAktywna: true,
          kartaOkresUzywalnosci: '12',
          kartaIloscDomyslna: '1',
          kartaEkwiwalent: '0',
          kartaCena: '100',
          okres: 24,
          ilosc: '2',
          uwagi: 'Archiwum',
          aktywny: true,
          legacyStatus: null,
        );
        when(
          () => positionsRepository.unarchivePositionStandard(
            position.id,
            inactiveStandard.id,
          ),
        ).thenAnswer((_) async => const Right(restored));
        return cubit.unarchiveStandard(inactiveStandard.id);
      },
      expect: () => const <BhpPositionStandardsState>[
        BhpPositionStandardsReady(
          position: position,
          standards: [inactiveStandard],
          equipment: equipment,
          activeAction: BhpPositionStandardAction.unarchiving,
          activeStandardId: 11,
        ),
        BhpPositionStandardsReady(
          position: position,
          standards: [
            GetBhpUserStandardItem(
              id: 11,
              stanowiskoId: 7,
              kartaWyposazeniaId: 1,
              kartaWyposazeniaSymbol: 'BHP-01',
              kartaWyposazeniaNazwa: 'Buty',
              kartaWyposazeniaJm: 'para',
              kartaAktywna: true,
              kartaOkresUzywalnosci: '12',
              kartaIloscDomyslna: '1',
              kartaEkwiwalent: '0',
              kartaCena: '100',
              okres: 24,
              ilosc: '2',
              uwagi: 'Archiwum',
              aktywny: true,
              legacyStatus: null,
            ),
          ],
          equipment: equipment,
        ),
      ],
    );

    blocTest<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      'deleteStandard: usuwa nieaktywną pozycję standardu z listy',
      build: () => BhpPositionStandardsCubit(
        position: position,
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
      seed: () => const BhpPositionStandardsReady(
        position: position,
        standards: [activeStandard, inactiveStandard],
        equipment: equipment,
      ),
      act: (cubit) {
        when(
          () => positionsRepository.deletePositionStandard(
            position.id,
            inactiveStandard.id,
          ),
        ).thenAnswer((_) async => const Right(unit));
        return cubit.deleteStandard(inactiveStandard.id);
      },
      expect: () => const <BhpPositionStandardsState>[
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard, inactiveStandard],
          equipment: equipment,
          activeAction: BhpPositionStandardAction.deleting,
          activeStandardId: 11,
        ),
        BhpPositionStandardsReady(
          position: position,
          standards: [activeStandard],
          equipment: equipment,
        ),
      ],
    );

    blocTest<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      'deleteStandard: odrzuca próbę usunięcia aktywnej pozycji bez wywołania API',
      build: () => BhpPositionStandardsCubit(
        position: position,
        positionsRepository: positionsRepository,
        equipmentRepository: equipmentRepository,
      ),
      seed: () => const BhpPositionStandardsReady(
        position: position,
        standards: [activeStandard, inactiveStandard],
        equipment: equipment,
      ),
      act: (cubit) async {
        final result = await cubit.deleteStandard(activeStandard.id);
        expect(
          result,
          const Left<ApiError, Unit>(
            ApiError(
              type: ApiErrorType.validation,
              message:
                  'Nie można usunąć aktywnej pozycji standardu. Najpierw ją zarchiwizuj.',
            ),
          ),
        );
      },
      expect: () => const <BhpPositionStandardsState>[],
      verify: (_) {
        verifyNever(
          () => positionsRepository.deletePositionStandard(
            any(),
            any(),
          ),
        );
      },
    );
  });
}
