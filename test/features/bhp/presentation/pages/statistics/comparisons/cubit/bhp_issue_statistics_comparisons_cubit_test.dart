import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/cubit/bhp_issue_statistics_comparisons_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/cubit/bhp_issue_statistics_comparisons_state.dart';

/// Mock repozytorium dashboardu BHP.
class _MockBhpDashboardRepository extends Mock
    implements BhpDashboardRepository {}

void main() {
  late BhpDashboardRepository repository;

  const operation = GetBhpIssueOperationItem(
    id: '12-issued',
    issueId: 12,
    userId: 7,
    userFullName: 'Jan Kowalski',
    type: 'issued',
    typeLabel: 'Wydano',
    occurredAt: '2025-03-10T00:00:00.000Z',
    details: 'Wydano 2 szt. - BUT - Buty',
    stanowiskoId: 4,
    stanowiskoNazwa: 'Magazynier',
    kartaWyposazeniaId: 3,
    kartaWyposazeniaSymbol: 'BUT',
    kartaWyposazeniaNazwa: 'Buty',
    quantity: '2',
  );

  GetBhpIssueOperationsResponseData responseForYear(int year) {
    return GetBhpIssueOperationsResponseData(
      generatedAt: '2026-06-19T10:00:00.000Z',
      year: year,
      count: 1,
      items: [operation],
    );
  }

  setUp(() {
    repository = _MockBhpDashboardRepository();
  });

  group('BhpIssueStatisticsComparisonsCubit', () {
    blocTest<
      BhpIssueStatisticsComparisonsCubit,
      BhpIssueStatisticsComparisonsState
    >(
      'zwraca błąd zamiast zerowania danych, gdy poprzedni rok się nie załaduje',
      setUp: () {
        when(
          () => repository.getIssueOperations(2025),
        ).thenAnswer((_) async => Right(responseForYear(2025)));
        when(
          () => repository.getIssueOperations(2024),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak odpowiedzi backendu.',
            ),
          ),
        );
        when(
          () => repository.getIssueOperations(2023),
        ).thenAnswer((_) async => Right(responseForYear(2023)));
      },
      build: () => BhpIssueStatisticsComparisonsCubit(
        repository: repository,
        initialYear: 2025,
      ),
      act: (cubit) => cubit.load(2025),
      expect: () => const <BhpIssueStatisticsComparisonsState>[
        BhpIssueStatisticsComparisonsLoading(year: 2025),
        BhpIssueStatisticsComparisonsError(
          year: 2025,
          message:
              'Nie udało się pobrać danych porównawczych dla roku 2024: '
              'Brak odpowiedzi backendu.',
        ),
      ],
    );

    test('ignoruje spóźnioną odpowiedź starszego żądania', () async {
      final completers =
          <int, Completer<Either<ApiError, GetBhpIssueOperationsResponseData>>>{
            2025:
                Completer<
                  Either<ApiError, GetBhpIssueOperationsResponseData>
                >(),
            2024:
                Completer<
                  Either<ApiError, GetBhpIssueOperationsResponseData>
                >(),
            2023:
                Completer<
                  Either<ApiError, GetBhpIssueOperationsResponseData>
                >(),
            2022:
                Completer<
                  Either<ApiError, GetBhpIssueOperationsResponseData>
                >(),
          };

      when(
        () => repository.getIssueOperations(any()),
      ).thenAnswer((invocation) {
        final year = invocation.positionalArguments.first as int;
        return completers[year]!.future;
      });

      final cubit = BhpIssueStatisticsComparisonsCubit(
        repository: repository,
        initialYear: 2025,
      );

      unawaited(cubit.load(2025));
      unawaited(cubit.load(2024));

      completers[2024]!.complete(Right(responseForYear(2024)));
      completers[2023]!.complete(Right(responseForYear(2023)));
      completers[2022]!.complete(Right(responseForYear(2022)));
      await Future<void>.delayed(Duration.zero);

      completers[2025]!.complete(Right(responseForYear(2025)));
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        isA<BhpIssueStatisticsComparisonsSuccess>().having(
          (state) => state.year,
          'year',
          2024,
        ),
      );

      await cubit.close();
    });
  });
}
