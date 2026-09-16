import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/create_inventory/cubit/create_inventory_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/create_inventory/cubit/create_inventory_state.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

class _MockStockRepository extends Mock implements StockRepository {}

class _FakePostInwentaryzacjaQuery extends Fake
    implements PostInwentaryzacjaQuery {}

void main() {
  late InventoriesRepository inventoriesRepository;
  late StockRepository stockRepository;

  const firmaZ = GetFirmyItem(id: 10, idFirmy: 10, nazwa: 'ZZZ Profil');
  const firmaA = GetFirmyItem(id: 11, idFirmy: 11, nazwa: 'AAA Lakiery');

  const createQuery = PostInwentaryzacjaQuery(
    firmy: [11],
    numer: 'INV/TEST/1',
    komisja: [3759, 3812],
    dataOd: '2026-04-10',
  );

  const createResponse = PostInwentaryzacjaResponseData(id: 91);

  setUpAll(() {
    registerFallbackValue(_FakePostInwentaryzacjaQuery());
  });

  setUp(() {
    inventoriesRepository = _MockInventoriesRepository();
    stockRepository = _MockStockRepository();

    when(
      () => stockRepository.fetchCompanies(
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Right([firmaZ, firmaA]));

    when(
      () => inventoriesRepository.createInwentaryzacja(any()),
    ).thenAnswer((_) async => const Right(createResponse));
  });

  group('CreateInventoryCubit', () {
    blocTest<CreateInventoryCubit, CreateInventoryState>(
      'loadCompanies: sortuje firmy rosnaco i ustawia pierwsza jako domyslna (wykrywa regresje wyboru domyslnej firmy)',
      build: () => CreateInventoryCubit(
        inventoriesRepository: inventoriesRepository,
        stockRepository: stockRepository,
      ),
      wait: const Duration(milliseconds: 10),
      expect: () => <CreateInventoryState>[
        const CreateInventoryLoaded(
          companies: [firmaA, firmaZ],
          selectedFirmaId: 11,
          isSending: false,
        ),
      ],
      verify: (_) {
        verify(
          () => stockRepository.fetchCompanies(),
        ).called(1);
      },
    );

    blocTest<CreateInventoryCubit, CreateInventoryState>(
      'loadCompanies: emituje blad gdy slownik firm nie odpowiada (wykrywa brak obslugi bledu startowego)',
      setUp: () {
        when(
          () => stockRepository.fetchCompanies(
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Nie mozna pobrac firm.',
            ),
          ),
        );
      },
      build: () => CreateInventoryCubit(
        inventoriesRepository: inventoriesRepository,
        stockRepository: stockRepository,
      ),
      wait: const Duration(milliseconds: 10),
      expect: () => const <CreateInventoryState>[
        CreateInventoryError(message: 'Nie mozna pobrac firm.'),
      ],
    );

    blocTest<CreateInventoryCubit, CreateInventoryState>(
      'selectFirma: aktualizuje tylko selectedFirmaId i nie niszczy pozostalych pol (wykrywa przypadkowe nadpisanie stanu formularza)',
      build: () => CreateInventoryCubit(
        inventoriesRepository: inventoriesRepository,
        stockRepository: stockRepository,
      ),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        cubit.selectFirma(10);
      },
      expect: () => const <CreateInventoryState>[
        CreateInventoryLoaded(
          companies: [firmaA, firmaZ],
          selectedFirmaId: 11,
          isSending: false,
        ),
        CreateInventoryLoaded(
          companies: [firmaA, firmaZ],
          selectedFirmaId: 10,
          isSending: false,
        ),
      ],
    );

    blocTest<CreateInventoryCubit, CreateInventoryState>(
      'submit: sukces tworzenia emituje CreateInventorySended (wykrywa brak zamkniecia flow po zapisie)',
      build: () => CreateInventoryCubit(
        inventoriesRepository: inventoriesRepository,
        stockRepository: stockRepository,
      ),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await cubit.submit(createQuery);
      },
      expect: () => <dynamic>[
        const CreateInventoryLoaded(
          companies: [firmaA, firmaZ],
          selectedFirmaId: 11,
          isSending: false,
        ),
        isA<CreateInventoryLoaded>().having(
          (s) => s.isSending,
          'isSending',
          true,
        ),
        const CreateInventorySended(),
      ],
      verify: (_) {
        verify(
          () => inventoriesRepository.createInwentaryzacja(createQuery),
        ).called(1);
      },
    );

    blocTest<CreateInventoryCubit, CreateInventoryState>(
      'submit: blad backendu wraca do loaded z submitError (wykrywa brak informacji o bledzie zapisu)',
      setUp: () {
        when(
          () => inventoriesRepository.createInwentaryzacja(any()),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Niepoprawna komisja.',
            ),
          ),
        );
      },
      build: () => CreateInventoryCubit(
        inventoriesRepository: inventoriesRepository,
        stockRepository: stockRepository,
      ),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await cubit.submit(createQuery);
      },
      expect: () => <dynamic>[
        const CreateInventoryLoaded(
          companies: [firmaA, firmaZ],
          selectedFirmaId: 11,
          isSending: false,
        ),
        isA<CreateInventoryLoaded>().having(
          (s) => s.isSending,
          'isSending',
          true,
        ),
        isA<CreateInventoryLoaded>()
            .having((s) => s.isSending, 'isSending', false)
            .having(
              (s) => s.submitError,
              'submitError',
              'Niepoprawna komisja.',
            ),
      ],
    );

    blocTest<CreateInventoryCubit, CreateInventoryState>(
      'submit: gdy stan nie jest loaded, nic nie wysyla do backendu (wykrywa nieuprawniony zapis w blednym stanie)',
      setUp: () {
        when(
          () => stockRepository.fetchCompanies(
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak danych',
            ),
          ),
        );
      },
      build: () => CreateInventoryCubit(
        inventoriesRepository: inventoriesRepository,
        stockRepository: stockRepository,
      ),
      act: (cubit) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        await cubit.submit(createQuery);
      },
      expect: () => const <CreateInventoryState>[
        CreateInventoryError(message: 'Brak danych'),
      ],
      verify: (_) {
        verifyNever(() => inventoriesRepository.createInwentaryzacja(any()));
      },
    );
  });
}
