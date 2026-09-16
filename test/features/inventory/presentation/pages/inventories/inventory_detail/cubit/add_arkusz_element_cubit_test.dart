import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_element_nrewid_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_elementy_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/add_arkusz_element_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/add_arkusz_element_state.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

class _FakePostArkuszElementyQuery extends Fake
    implements PostArkuszElementyQuery {}

class _FakeCreateArkuszElementByNrewidRequest extends Fake
    implements CreateArkuszElementByNrewidRequest {}

void main() {
  late InventoriesRepository repository;

  setUpAll(() {
    registerFallbackValue(_FakePostArkuszElementyQuery());
    registerFallbackValue(_FakeCreateArkuszElementByNrewidRequest());
  });

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('AddArkuszElementCubit', () {
    blocTest<AddArkuszElementCubit, AddArkuszElementState>(
      'addManual: emituje sending i saved przy sukcesie',
      setUp: () {
        when(
          () => repository.addArkuszNadwyzka(
            arkuszId: 77,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Right(
            PostArkuszElementyResponseData(
              id: 501,
              success: true,
              nadwyzka: true,
            ),
          ),
        );
      },
      build: () => AddArkuszElementCubit(repository: repository),
      act: (cubit) => cubit.addManual(
        arkuszId: 77,
        query: const PostArkuszElementyQuery(
          kodKreskowy: 0,
          nrewid: 'MANUAL/001',
          nazwa: 'Test',
          osoba: 'Jan',
        ),
      ),
      expect: () => const <AddArkuszElementState>[
        AddArkuszElementSending(),
        AddArkuszElementSaved(itemId: 501),
      ],
    );

    blocTest<AddArkuszElementCubit, AddArkuszElementState>(
      'addByNrewid: po bledzie wraca do ready z submitError',
      setUp: () {
        when(
          () => repository.createArkuszElementByNrewid(
            arkuszId: 77,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Element juz istnieje w tej inwentaryzacji.',
            ),
          ),
        );
      },
      build: () => AddArkuszElementCubit(repository: repository),
      act: (cubit) => cubit.addByNrewid(
        arkuszId: 77,
        query: const CreateArkuszElementByNrewidRequest(nrewid: 'ARK/ST/001'),
      ),
      expect: () => const <AddArkuszElementState>[
        AddArkuszElementSending(),
        AddArkuszElementReady(
          submitError: 'Element juz istnieje w tej inwentaryzacji.',
        ),
      ],
    );

    blocTest<AddArkuszElementCubit, AddArkuszElementState>(
      'addManual: podczas wysylki ignoruje kolejny submit',
      setUp: () {
        when(
          () => repository.addArkuszNadwyzka(
            arkuszId: 77,
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 40));
          return const Right(
            PostArkuszElementyResponseData(
              id: 501,
              success: true,
              nadwyzka: true,
            ),
          );
        });
      },
      build: () => AddArkuszElementCubit(repository: repository),
      act: (cubit) async {
        unawaited(
          cubit.addManual(
            arkuszId: 77,
            query: const PostArkuszElementyQuery(kodKreskowy: 0, nazwa: 'Test'),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await cubit.addManual(
          arkuszId: 77,
          query: const PostArkuszElementyQuery(kodKreskowy: 0, nazwa: 'Test'),
        );
      },
      wait: const Duration(milliseconds: 60),
      expect: () => const <AddArkuszElementState>[
        AddArkuszElementSending(),
        AddArkuszElementSaved(itemId: 501),
      ],
      verify: (_) {
        verify(
          () => repository.addArkuszNadwyzka(
            arkuszId: 77,
            query: any(named: 'query'),
          ),
        ).called(1);
      },
    );
  });
}
