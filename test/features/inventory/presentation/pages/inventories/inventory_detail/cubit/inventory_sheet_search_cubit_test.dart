import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_sheet_search_cubit.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_sheet_search_state.dart';

/// Mock repozytorium wyszukiwarki arkuszy.
class _MockInventoriesRepository extends Mock
    implements InventoriesRepository {}

void main() {
  late InventoriesRepository repository;

  setUpAll(() {
    registerFallbackValue(const GetInwentaryzacjaSearchArkuszeQuery(q: 'x'));
  });

  const response = GetInwentaryzacjaSearchArkuszeResponseData(
    meta: GetInwentaryzacjaSearchArkuszeMeta(
      scope: 'inventory',
      scopeId: 14,
      generatedAt: '2026-06-15T10:00:00',
      inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta(id: 14),
      filters: GetInwentaryzacjaSearchArkuszeFilters(
        q: 'krzeslo',
        sortBy: 'nrewid',
        sortDir: 'asc',
      ),
      totals: GetInwentaryzacjaSearchArkuszeTotals(
        groupsCount: 1,
        matchesCount: 2,
      ),
    ),
    items: [
      GetInwentaryzacjaSearchArkuszeGroup(
        identityKey: 'group-1',
        matchesCount: 2,
        hasMultipleMatches: true,
        hasMixedStatuses: false,
        uiStatuses: [SearchArkuszeUiStatus.potwierdzony],
        matches: [
          GetInwentaryzacjaSearchArkuszeMatch(
            elementId: 99,
            arkuszId: 5,
            arkuszNumer: 'A/5',
            uiStatus: SearchArkuszeUiStatus.potwierdzony,
          ),
        ],
      ),
    ],
  );
  const staleResponse = GetInwentaryzacjaSearchArkuszeResponseData(
    meta: GetInwentaryzacjaSearchArkuszeMeta(
      scope: 'inventory',
      scopeId: 14,
      generatedAt: '2026-06-15T10:01:00',
      inwentaryzacja: GetInwentaryzacjaSearchArkuszeInventoryMeta(id: 14),
      filters: GetInwentaryzacjaSearchArkuszeFilters(
        q: 'stol',
        sortBy: 'nrewid',
        sortDir: 'asc',
      ),
      totals: GetInwentaryzacjaSearchArkuszeTotals(
        groupsCount: 1,
        matchesCount: 1,
      ),
    ),
    items: [
      GetInwentaryzacjaSearchArkuszeGroup(
        identityKey: 'group-stale',
        matchesCount: 1,
        hasMultipleMatches: false,
        hasMixedStatuses: false,
        uiStatuses: [SearchArkuszeUiStatus.potwierdzony],
        matches: [
          GetInwentaryzacjaSearchArkuszeMatch(
            elementId: 7,
            arkuszId: 9,
            arkuszNumer: 'A/9',
            uiStatus: SearchArkuszeUiStatus.potwierdzony,
          ),
        ],
      ),
    ],
  );

  setUp(() {
    repository = _MockInventoriesRepository();
  });

  group('InventorySheetSearchCubit', () {
    blocTest<InventorySheetSearchCubit, InventorySheetSearchState>(
      'dla frazy krótszej niż 2 znaki resetuje wynik bez requestu',
      build: () => InventorySheetSearchCubit(repository: repository),
      act: (cubit) => cubit.updateQuery(14, 'a'),
      expect: () => const <InventorySheetSearchState>[
        InventorySheetSearchState(query: 'a'),
      ],
      verify: (_) {
        verifyNever(
          () => repository.searchInventorySheets(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        );
      },
    );

    blocTest<InventorySheetSearchCubit, InventorySheetSearchState>(
      'wysyła request i emituje loading oraz success dla poprawnej frazy',
      setUp: () {
        when(
          () => repository.searchInventorySheets(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => const Right(response));
      },
      build: () => InventorySheetSearchCubit(repository: repository),
      act: (cubit) => cubit.updateQuery(14, 'krzeslo'),
      expect: () => <dynamic>[
        const InventorySheetSearchState(query: 'krzeslo'),
        isA<InventorySheetSearchState>()
            .having((s) => s.query, 'query', 'krzeslo')
            .having((s) => s.result.isLoading, 'loading', true),
        isA<InventorySheetSearchState>()
            .having((s) => s.query, 'query', 'krzeslo')
            .having((s) => s.result.isSuccess, 'success', true)
            .having((s) => s.result.data?.items.length, 'items', 1),
      ],
      verify: (_) {
        final capturedQuery =
            verify(
                  () => repository.searchInventorySheets(
                    inventoryId: 14,
                    query: captureAny(named: 'query'),
                  ),
                ).captured.single
                as GetInwentaryzacjaSearchArkuszeQuery;
        expect(capturedQuery.q, 'krzeslo');
        expect(
          capturedQuery.sortBy,
          GetInwentaryzacjaSearchArkuszeSortBy.nrewid,
        );
        expect(
          capturedQuery.sortDir,
          GetInwentaryzacjaSearchArkuszeSortDirection.asc,
        );
      },
    );

    blocTest<InventorySheetSearchCubit, InventorySheetSearchState>(
      'zmiana sortowania przeładowuje wyniki z nowymi parametrami',
      setUp: () {
        when(
          () => repository.searchInventorySheets(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) async => const Right(response));
      },
      build: () => InventorySheetSearchCubit(repository: repository),
      act: (cubit) async {
        await cubit.updateQuery(14, 'krzeslo');
        await cubit.updateSortBy(
          14,
          GetInwentaryzacjaSearchArkuszeSortBy.matchesCount,
        );
      },
      verify: (_) {
        final capturedQueries = verify(
          () => repository.searchInventorySheets(
            inventoryId: 14,
            query: captureAny(named: 'query'),
          ),
        ).captured.cast<GetInwentaryzacjaSearchArkuszeQuery>();
        expect(capturedQueries, hasLength(2));

        final firstQuery = capturedQueries.first;
        expect(firstQuery.q, 'krzeslo');
        expect(firstQuery.sortBy, GetInwentaryzacjaSearchArkuszeSortBy.nrewid);

        final secondQuery = capturedQueries.last;
        expect(secondQuery.q, 'krzeslo');
        expect(
          secondQuery.sortBy,
          GetInwentaryzacjaSearchArkuszeSortBy.matchesCount,
        );
      },
    );

    test(
      'ignoruje spóźnioną odpowiedź starszego requestu wyszukiwania',
      () async {
        final firstResponseCompleter =
            Completer<Either<ApiError, GetInwentaryzacjaSearchArkuszeResponseData>>();
        var callCount = 0;

        when(
          () => repository.searchInventorySheets(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        ).thenAnswer((_) {
          callCount += 1;
          if (callCount == 1) {
            return firstResponseCompleter.future;
          }
          return Future.value(const Right(staleResponse));
        });

        final cubit = InventorySheetSearchCubit(repository: repository);

        final first = cubit.updateQuery(14, 'krzeslo');
        final second = cubit.updateQuery(14, 'stolik');

        await Future<void>.delayed(Duration.zero);
        firstResponseCompleter.complete(const Right(response));

        await Future.wait([first, second]);

        expect(cubit.state.query, 'stolik');
        expect(cubit.state.result.isSuccess, isTrue);
        expect(cubit.state.result.data?.items.single.matches.single.elementId, 7);
      },
    );

    blocTest<InventorySheetSearchCubit, InventorySheetSearchState>(
      'emituje błąd gdy repozytorium nie zwróci danych',
      setUp: () {
        when(
          () => repository.searchInventorySheets(
            inventoryId: any(named: 'inventoryId'),
            query: any(named: 'query'),
          ),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak połączenia',
            ),
          ),
        );
      },
      build: () => InventorySheetSearchCubit(repository: repository),
      act: (cubit) => cubit.updateQuery(14, 'krzeslo'),
      expect: () => <dynamic>[
        const InventorySheetSearchState(query: 'krzeslo'),
        isA<InventorySheetSearchState>().having(
          (s) => s.result.isLoading,
          'loading',
          true,
        ),
        isA<InventorySheetSearchState>()
            .having((s) => s.result.isError, 'error', true)
            .having(
              (s) => s.result.errorMessage,
              'message',
              'Brak połączenia',
            ),
      ],
    );
  });
}
