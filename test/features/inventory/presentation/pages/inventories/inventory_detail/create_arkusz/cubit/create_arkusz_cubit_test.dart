import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/cubit/create_arkusz_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/create_arkusz/cubit/create_arkusz_state.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

class _MockLocationsRepository extends Mock implements LocationsRepository {}

class _FakePostArkuszQuery extends Fake implements PostArkuszQuery {}

void main() {
  late InventoriesRepository inventoriesRepository;
  late LocationsRepository locationsRepository;

  const miejsceA = GetMiejscaItem(
    id: 1,
    idMiejsca: 10,
    idFirmy: 2,
    baza: 'SZKLO',
    nazwa: 'Zeta',
  );

  const miejsceB = GetMiejscaItem(
    id: 2,
    idMiejsca: 11,
    idFirmy: 2,
    baza: 'SZKLO',
    nazwa: 'Alfa',
  );

  const locationsResponse = GetMiejscaResponseData(
    items: [miejsceA, miejsceB],
    meta: GetMiejscaMeta(total: 2),
  );

  const createdArkusz = PostArkuszResponseData(
    id: 555,
    scope: 'node',
    elementyCount: 7,
    komisjaCount: 2,
  );

  setUpAll(() {
    registerFallbackValue(_FakePostArkuszQuery());
  });

  setUp(() {
    inventoriesRepository = _MockInventoriesRepository();
    locationsRepository = _MockLocationsRepository();

    when(
      () => locationsRepository.fetchLocations(
        firma: any(named: 'firma'),
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer((_) async => const Right(locationsResponse));

    when(
      () => inventoriesRepository.createArkusz(
        inventoryId: any(named: 'inventoryId'),
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) async => const Right(createdArkusz));
  });

  group('CreateArkuszCubit', () {
    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'initialize: laduje miejsca i sortuje je po nazwie rosnaco (wykrywa regresje kolejnosci w pickerze)',
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      act: (cubit) => cubit.initialize(firmaId: 2),
      expect: () => <CreateArkuszState>[
        const CreateArkuszLoading(),
        const CreateArkuszReady(
          locations: [miejsceB, miejsceA],
          selectedLocationId: null,
          numerRaw: '',
          komisjaRaw: '',
          submitError: null,
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(
          () => locationsRepository.fetchLocations(
            firma: 2,
          ),
        ).called(1);
      },
    );

    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'initialize: gdy firma nie ma miejsc, nie robi fallbacku globalnego i zwraca pusta liste',
      setUp: () {
        when(
          () => locationsRepository.fetchLocations(
            firma: 2,
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => const Right(
            GetMiejscaResponseData(
              items: [],
              meta: GetMiejscaMeta(total: 0),
            ),
          ),
        );
      },
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      act: (cubit) => cubit.initialize(firmaId: 2),
      expect: () => <CreateArkuszState>[
        const CreateArkuszLoading(),
        const CreateArkuszReady(
          locations: [],
          selectedLocationId: null,
          numerRaw: '',
          komisjaRaw: '',
          submitError: null,
          isSubmitting: false,
        ),
      ],
      verify: (_) {
        verify(
          () => locationsRepository.fetchLocations(
            firma: 2,
          ),
        ).called(1);
        verifyNever(
          () => locationsRepository.fetchLocations(),
        );
      },
    );

    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'initialize: emituje blad ladowania gdy repository zwroci ApiError (wykrywa brak obslugi bledu slownika)',
      setUp: () {
        when(
          () => locationsRepository.fetchLocations(
            firma: any(named: 'firma'),
            forceRefresh: any(named: 'forceRefresh'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak polaczenia z backendem miejsc.',
            ),
          ),
        );
      },
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      act: (cubit) => cubit.initialize(firmaId: 2),
      expect: () => <CreateArkuszState>[
        const CreateArkuszLoading(),
        const CreateArkuszLoadError(
          message: 'Brak polaczenia z backendem miejsc.',
        ),
      ],
    );

    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'submit: sukces tworzenia arkusza emituje stan sukcesu i wysyla poprawny payload (wykrywa bledne mapowanie id_miejsca/scope/komisja)',
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      seed: () => const CreateArkuszReady(
        locations: [miejsceA, miejsceB],
        selectedLocationId: 2,
        numerRaw: 'ARK/CUSTOM/001',
        komisjaRaw: '3759,3812',
        submitError: null,
        isSubmitting: false,
      ),
      act: (cubit) => cubit.submit(
        inventoryId: 123,
        scope: 'subtree',
        komisja: const [3759, 3812],
      ),
      expect: () => <dynamic>[
        isA<CreateArkuszReady>().having(
          (s) => s.isSubmitting,
          'isSubmitting',
          true,
        ),
        const CreateArkuszSuccess(response: createdArkusz),
      ],
      verify: (_) {
        final captured =
            verify(
                  () => inventoriesRepository.createArkusz(
                    inventoryId: 123,
                    query: captureAny(named: 'query'),
                  ),
                ).captured.single
                as PostArkuszQuery;

        expect(captured.idMiejsca, 11);
        expect(captured.idFirmy, 2);
        expect(captured.baza, 'SZKLO');
        expect(captured.scope, 'node');
        expect(captured.numer, 'ARK/CUSTOM/001');
        expect(captured.komisja, const [3759, 3812]);
      },
    );

    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'submit: wybiera rekord po technicznym id gdy id_miejsca powtarza sie miedzy bazami',
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      seed: () => const CreateArkuszReady(
        locations: [
          GetMiejscaItem(
            id: 25384,
            idMiejsca: 5,
            idFirmy: 2,
            baza: 'PROFILE',
            nazwa: 'Biura',
          ),
          GetMiejscaItem(
            id: 25429,
            idMiejsca: 5,
            idFirmy: 2,
            baza: 'WYPOSAZENIE',
            nazwa: 'Biura',
          ),
        ],
        selectedLocationId: 25384,
        numerRaw: '',
        komisjaRaw: '',
        submitError: null,
        isSubmitting: false,
      ),
      act: (cubit) => cubit.submit(
        inventoryId: 123,
        scope: 'node',
        komisja: null,
      ),
      verify: (_) {
        final captured =
            verify(
                  () => inventoriesRepository.createArkusz(
                    inventoryId: 123,
                    query: captureAny(named: 'query'),
                  ),
                ).captured.single
                as PostArkuszQuery;

        expect(captured.idMiejsca, 5);
        expect(captured.idFirmy, 2);
        expect(captured.baza, 'PROFILE');
      },
    );

    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'submit: blad backendu wraca do ready i pokazuje submitError (wykrywa brak informacji zwrotnej dla uzytkownika)',
      setUp: () {
        when(
          () => inventoriesRepository.createArkusz(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Niepoprawny zakres scope.',
            ),
          ),
        );
      },
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      seed: () => const CreateArkuszReady(
        locations: [miejsceA, miejsceB],
        selectedLocationId: 2,
        numerRaw: '',
        komisjaRaw: '3759,3812',
        submitError: null,
        isSubmitting: false,
      ),
      act: (cubit) => cubit.submit(
        inventoryId: 123,
        scope: 'node',
        komisja: const [3759, 3812],
      ),
      expect: () => <dynamic>[
        isA<CreateArkuszReady>().having(
          (s) => s.isSubmitting,
          'isSubmitting',
          true,
        ),
        isA<CreateArkuszReady>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having(
              (s) => s.submitError,
              'submitError',
              'Niepoprawny zakres scope.',
            ),
      ],
    );

    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'submit: przy selectedLocationId == null wraca do ready z bledem walidacji i nie wysyla requestu',
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      seed: () => const CreateArkuszReady(
        locations: [miejsceA, miejsceB],
        selectedLocationId: null,
        numerRaw: '',
        komisjaRaw: '3759,3812',
        submitError: null,
        isSubmitting: false,
      ),
      act: (cubit) => cubit.submit(
        inventoryId: 123,
        scope: 'node',
        komisja: const [3759, 3812],
      ),
      expect: () => <dynamic>[
        isA<CreateArkuszReady>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having(
              (s) => s.submitError,
              'submitError',
              'Wybierz miejsce w drzewie przed utworzeniem arkusza.',
            ),
      ],
      verify: (_) {
        verifyNever(
          () => inventoriesRepository.createArkusz(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        );
      },
    );

    blocTest<CreateArkuszCubit, CreateArkuszState>(
      'submit: gdy wybrane miejsce nie ma idFirmy/baza nie wysyla requestu i zwraca blad',
      build: () => CreateArkuszCubit(
        inventoriesRepository: inventoriesRepository,
        locationsRepository: locationsRepository,
      ),
      seed: () => const CreateArkuszReady(
        locations: [
          GetMiejscaItem(
            id: 99,
            idMiejsca: 19,
            idFirmy: 0,
            nazwa: 'Niepelne miejsce',
          ),
        ],
        selectedLocationId: 99,
        numerRaw: '',
        komisjaRaw: '',
        submitError: null,
        isSubmitting: false,
      ),
      act: (cubit) => cubit.submit(
        inventoryId: 123,
        scope: 'node',
        komisja: const [3759, 3812],
      ),
      expect: () => <dynamic>[
        isA<CreateArkuszReady>().having(
          (s) => s.isSubmitting,
          'isSubmitting',
          true,
        ),
        isA<CreateArkuszReady>()
            .having((s) => s.isSubmitting, 'isSubmitting', false)
            .having(
              (s) => s.submitError,
              'submitError',
              'Wybrane miejsce ma niepelne dane firmy/bazy. Odswiez liste miejsc i sprobuj ponownie.',
            ),
      ],
      verify: (_) {
        verifyNever(
          () => inventoriesRepository.createArkusz(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        );
      },
    );
  });
}
