import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_element_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/cubit/change_item_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/cubit/change_item_state.dart';

class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

class _FakePatchArkuszElementQuery extends Fake
    implements PatchArkuszElementQuery {}

void main() {
  late InventoriesRepository repository;

  const query = PatchArkuszElementQuery(
    stanInwent: ArkuszElementInwentStatus.przeniesiony,
    uwagiLoc: 'Przeniesiony',
  );

  setUpAll(() {
    registerFallbackValue(_FakePatchArkuszElementQuery());
  });

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('ChangeItemCubit', () {
    blocTest<ChangeItemCubit, ChangeItemState>(
      'submit: emituje sending i saved dla poprawnej odpowiedzi (wykrywa brak finalizacji zapisu)',
      setUp: () {
        when(
          () => repository.updateArkuszElement(
            arkuszId: 10,
            elementId: 99,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Right(
            PatchArkuszElementResponseData(elementId: 99),
          ),
        );
      },
      build: () =>
          ChangeItemCubit(repository: repository, arkuszId: 10, elementId: 99),
      act: (cubit) => cubit.submit(query),
      expect: () => const <ChangeItemState>[
        ChangeItemSending(),
        ChangeItemSaved(
          response: PatchArkuszElementResponseData(elementId: 99),
        ),
      ],
      verify: (_) {
        verify(
          () => repository.updateArkuszElement(
            arkuszId: 10,
            elementId: 99,
            query: query,
          ),
        ).called(1);
      },
    );

    blocTest<ChangeItemCubit, ChangeItemState>(
      'submit: po bledzie wraca do ready z submitError (wykrywa brak informacji o odrzuconym zapisie)',
      setUp: () {
        when(
          () => repository.updateArkuszElement(
            arkuszId: 10,
            elementId: 99,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.validation,
              message: 'Bledna wartosc pola.',
            ),
          ),
        );
      },
      build: () =>
          ChangeItemCubit(repository: repository, arkuszId: 10, elementId: 99),
      act: (cubit) => cubit.submit(query),
      expect: () => const <ChangeItemState>[
        ChangeItemSending(),
        ChangeItemReady(submitError: 'Bledna wartosc pola.'),
      ],
    );

    blocTest<ChangeItemCubit, ChangeItemState>(
      'submit: gdy trwa wysylka, ignoruje kolejne submit (wykrywa podwojne PATCH przy szybkim kliku)',
      setUp: () {
        when(
          () => repository.updateArkuszElement(
            arkuszId: 10,
            elementId: 99,
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async {
            await Future<void>.delayed(const Duration(milliseconds: 40));
            return const Right(PatchArkuszElementResponseData(elementId: 99));
          },
        );
      },
      build: () =>
          ChangeItemCubit(repository: repository, arkuszId: 10, elementId: 99),
      act: (cubit) async {
        unawaited(cubit.submit(query));
        await Future<void>.delayed(const Duration(milliseconds: 5));
        await cubit.submit(query);
      },
      wait: const Duration(milliseconds: 60),
      expect: () => const <ChangeItemState>[
        ChangeItemSending(),
        ChangeItemSaved(
          response: PatchArkuszElementResponseData(elementId: 99),
        ),
      ],
      verify: (_) {
        verify(
          () => repository.updateArkuszElement(
            arkuszId: 10,
            elementId: 99,
            query: query,
          ),
        ).called(1);
      },
    );
  });
}
