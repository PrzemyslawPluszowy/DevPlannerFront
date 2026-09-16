import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/dashboard/cubit/bhp_dashboard_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/dashboard/cubit/bhp_dashboard_state.dart';

/// Mock repozytorium dashboardu BHP.
class _MockBhpDashboardRepository extends Mock
    implements BhpDashboardRepository {}

void main() {
  late BhpDashboardRepository repository;

  const alert = GetBhpIssueAlertItem(
    issueId: 12,
    userId: 7,
    userFullName: 'Jan Kowalski',
    stanowiskoId: 4,
    stanowiskoNazwa: 'Magazynier',
    kartaWyposazeniaId: 3,
    kartaWyposazeniaSymbol: 'BUT',
    kartaWyposazeniaNazwa: 'Buty',
    dataPrzydzialu: '2025-02-10',
    okresMiesiace: 12,
    okresSource: 'manual',
    dueDate: '2025-03-10',
    daysToDue: 3,
  );

  GetBhpDashboardResponseData dashboardData({
    required String generatedAt,
    required int overdueCount,
    required int upcomingCount,
  }) {
    return GetBhpDashboardResponseData(
      generatedAt: generatedAt,
      monthsAhead: 1,
      overdueCount: overdueCount,
      upcomingCount: upcomingCount,
      overdue: overdueCount == 0 ? const [] : [alert],
      upcoming: upcomingCount == 0 ? const [] : [alert],
    );
  }

  setUp(() {
    repository = _MockBhpDashboardRepository();
  });

  group('BhpDashboardCubit', () {
    blocTest<BhpDashboardCubit, BhpDashboardState>(
      'emituje loading z poprzednimi danymi i zachowuje je po błędzie',
      setUp: () {
        when(
          () =>
              repository.getIssueAlerts(monthsAhead: any(named: 'monthsAhead')),
        ).thenAnswer(
          (_) async => Right(
            dashboardData(
              generatedAt: '2026-06-30T08:00:00.000Z',
              overdueCount: 1,
              upcomingCount: 2,
            ),
          ),
        );
      },
      build: () => BhpDashboardCubit(repository: repository),
      act: (cubit) async {
        await cubit.load();
        when(
          () =>
              repository.getIssueAlerts(monthsAhead: any(named: 'monthsAhead')),
        ).thenAnswer(
          (_) async => const Left(
            ApiError(
              type: ApiErrorType.connection,
              message: 'Brak odpowiedzi backendu.',
            ),
          ),
        );
        await cubit.load();
      },
      expect: () => [
        isA<BhpDashboardLoading>(),
        isA<BhpDashboardSuccess>().having(
          (state) => state.data.generatedAt,
          'generatedAt',
          '2026-06-30T08:00:00.000Z',
        ),
        isA<BhpDashboardLoading>().having(
          (state) => state.previousData?.generatedAt,
          'previousData.generatedAt',
          '2026-06-30T08:00:00.000Z',
        ),
        isA<BhpDashboardError>().having(
          (state) => state.previousData?.generatedAt,
          'previousData.generatedAt',
          '2026-06-30T08:00:00.000Z',
        ),
      ],
    );

    test('ignoruje spóźnioną odpowiedź starszego odświeżenia', () async {
      final firstRequest =
          Completer<Either<ApiError, GetBhpDashboardResponseData>>();
      final secondRequest =
          Completer<Either<ApiError, GetBhpDashboardResponseData>>();
      var callCount = 0;

      when(
        () => repository.getIssueAlerts(monthsAhead: any(named: 'monthsAhead')),
      ).thenAnswer((_) {
        callCount++;
        return callCount == 1 ? firstRequest.future : secondRequest.future;
      });

      final cubit = BhpDashboardCubit(repository: repository);

      unawaited(cubit.load());
      unawaited(cubit.load());

      secondRequest.complete(
        Right(
          dashboardData(
            generatedAt: '2026-06-30T09:00:00.000Z',
            overdueCount: 0,
            upcomingCount: 1,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        isA<BhpDashboardSuccess>().having(
          (state) => state.data.generatedAt,
          'generatedAt',
          '2026-06-30T09:00:00.000Z',
        ),
      );

      firstRequest.complete(
        Right(
          dashboardData(
            generatedAt: '2026-06-30T07:00:00.000Z',
            overdueCount: 3,
            upcomingCount: 0,
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        isA<BhpDashboardSuccess>().having(
          (state) => state.data.generatedAt,
          'generatedAt',
          '2026-06-30T09:00:00.000Z',
        ),
      );

      await cubit.close();
    });
  });
}
