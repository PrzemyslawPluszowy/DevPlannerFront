import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/cubit/bhp_equipment_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/cubit/bhp_equipment_state.dart';

/// Mock repozytorium wyposażenia BHP.
class _MockBhpEquipmentRepository extends Mock
    implements BhpEquipmentRepository {}

void main() {
  late BhpEquipmentRepository repository;

  const activeEquipment = GetBhpEquipmentListItem(
    id: 15,
    symbol: '8.O-URZ',
    nazwa: 'Ubranie robocze zimowe',
    aktywny: true,
    procentPrzydatnosci: 100,
    okresUzywalnosci: '36',
    jm: 'm-c',
    iloscDomyslna: '1.00',
    ekwiwalent: '12.50',
    cena: '0.00',
  );

  setUp(() {
    repository = _MockBhpEquipmentRepository();
  });

  group('BhpEquipmentCubit', () {
    blocTest<BhpEquipmentCubit, BhpEquipmentState>(
      'load: ładuje aktywne karty dla domyślnego filtra',
      setUp: () {
        when(
          () =>
              repository.getEquipment(active: true, query: any(named: 'query')),
        ).thenAnswer((_) async => const Right([activeEquipment]));
      },
      build: () => BhpEquipmentCubit(repository: repository),
      act: (cubit) => cubit.load(),
      expect: () => const <BhpEquipmentState>[
        BhpEquipmentLoading(),
        BhpEquipmentSuccess(
          items: [activeEquipment],
          filter: BhpEquipmentFilter.aktywne,
        ),
      ],
    );

    blocTest<BhpEquipmentCubit, BhpEquipmentState>(
      'load: dla filtra wszystkie wysyła active=null',
      setUp: () {
        when(
          () => repository.getEquipment(query: any(named: 'query')),
        ).thenAnswer((_) async => const Right([activeEquipment]));
      },
      build: () => BhpEquipmentCubit(repository: repository),
      act: (cubit) => cubit.load(BhpEquipmentFilter.wszystkie),
      expect: () => const <BhpEquipmentState>[
        BhpEquipmentLoading(),
        BhpEquipmentSuccess(
          items: [activeEquipment],
          filter: BhpEquipmentFilter.wszystkie,
        ),
      ],
    );

    blocTest<BhpEquipmentCubit, BhpEquipmentState>(
      'load: zwraca błąd gdy backend odrzuci pobieranie listy',
      setUp: () {
        when(
          () => repository.getEquipment(
            active: false,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Nie udało się pobrać listy.',
            ),
          ),
        );
      },
      build: () => BhpEquipmentCubit(repository: repository),
      act: (cubit) => cubit.load(BhpEquipmentFilter.nieaktywne),
      expect: () => const <BhpEquipmentState>[
        BhpEquipmentLoading(),
        BhpEquipmentError(message: 'Nie udało się pobrać listy.'),
      ],
    );
  });
}
