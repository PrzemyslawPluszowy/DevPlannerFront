import 'package:bloc/bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/issues/cubit/bhp_issue_statistics_issues_state.dart';

/// Cubit sekcji statystyk wydań BHP.
class BhpIssueStatisticsIssuesCubit
    extends Cubit<BhpIssueStatisticsIssuesState> {
  /// Tworzy cubit sekcji statystyk wydań.
  BhpIssueStatisticsIssuesCubit({
    required this._repository,
    required int initialYear,
  }) : super(BhpIssueStatisticsIssuesInitial(year: initialYear));

  final BhpDashboardRepository _repository;
  int _requestSequence = 0;

  /// Ładuje porównanie do poprzedniego roku.
  Future<void> load(int year) async {
    final requestId = ++_requestSequence;
    emit(BhpIssueStatisticsIssuesLoading(year: year));

    final currentYearResult = await _repository.getIssueOperations(year);
    if (!_isLatestRequest(requestId) || isClosed) {
      return;
    }

    currentYearResult.fold(
      (error) => emit(
        BhpIssueStatisticsIssuesError(
          year: year,
          message: error.message,
        ),
      ),
      (currentYearData) async {
        if (currentYearData.year != year) {
          emit(
            BhpIssueStatisticsIssuesError(
              year: year,
              message:
                  'Backend zwrócił dane dla roku ${currentYearData.year} '
                  'zamiast żądanego $year.',
            ),
          );
          return;
        }

        final previousYearResult = await _repository.getIssueOperations(
          year - 1,
        );
        if (!_isLatestRequest(requestId) || isClosed) {
          return;
        }

        previousYearResult.fold(
          (_) => emit(
            BhpIssueStatisticsIssuesSuccess(
              year: year,
              currentData: currentYearData,
            ),
          ),
          (previousYearData) {
            if (previousYearData.year != year - 1) {
              emit(
                BhpIssueStatisticsIssuesSuccess(
                  year: year,
                  currentData: currentYearData,
                ),
              );
              return;
            }

            emit(
              BhpIssueStatisticsIssuesSuccess(
                year: year,
                currentData: currentYearData,
                previousYearData: previousYearData,
              ),
            );
          },
        );
      },
    );
  }

  bool _isLatestRequest(int requestId) => requestId == _requestSequence;
}
