import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/issues/cubit/bhp_issue_statistics_issues_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/issues/cubit/bhp_issue_statistics_issues_state.dart';

/// Mock repozytorium dashboardu BHP.
class _MockBhpDashboardRepository extends Mock
    implements BhpDashboardRepository {}

void main() {
  late BhpDashboardRepository repository;

  setUp(() {
    repository = _MockBhpDashboardRepository();
  });

  group('BhpIssueStatisticsIssuesCubit', () {
    blocTest<BhpIssueStatisticsIssuesCubit, BhpIssueStatisticsIssuesState>(
      'zgłasza błąd, gdy backend zwróci dane dla innego roku niż żądany',
      setUp: () {
        when(
          () => repository.getIssueOperations(2025),
        ).thenAnswer(
          (_) async => const Right(
            GetBhpIssueOperationsResponseData(
              generatedAt: '2026-06-19T10:00:00.000Z',
              year: 2024,
              count: 0,
              items: [],
            ),
          ),
        );
      },
      build: () => BhpIssueStatisticsIssuesCubit(
        repository: repository,
        initialYear: 2025,
      ),
      act: (cubit) => cubit.load(2025),
      expect: () => const <BhpIssueStatisticsIssuesState>[
        BhpIssueStatisticsIssuesLoading(year: 2025),
        BhpIssueStatisticsIssuesError(
          year: 2025,
          message: 'Backend zwrócił dane dla roku 2024 zamiast żądanego 2025.',
        ),
      ],
    );
  });
}
