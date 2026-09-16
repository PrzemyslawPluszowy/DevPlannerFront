import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/bhp_issue_statistics_comparisons_models.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/cubit/bhp_issue_statistics_comparisons_state.dart';

/// Cubit do obsługi sekcji porównań statystyk BHP.
class BhpIssueStatisticsComparisonsCubit
    extends Cubit<BhpIssueStatisticsComparisonsState> {
  /// Tworzy cubit sekcji porównań.
  BhpIssueStatisticsComparisonsCubit({
    required this._repository,
    required int initialYear,
  }) : super(BhpIssueStatisticsComparisonsInitial(year: initialYear));

  final BhpDashboardRepository _repository;
  int _requestSequence = 0;

  /// Pobiera dane dla 3 lat: [year], [year - 1], [year - 2].
  Future<void> load(int year) async {
    final requestId = ++_requestSequence;
    emit(BhpIssueStatisticsComparisonsLoading(year: year));

    final results = await Future.wait([
      _repository.getIssueOperations(year),
      _repository.getIssueOperations(year - 1),
      _repository.getIssueOperations(year - 2),
    ]);
    if (!_isLatestRequest(requestId) || isClosed) {
      return;
    }

    final baseResult = results[0];
    final prevResult = results[1];
    final twoBackResult = results[2];

    final baseData = baseResult.fold<GetBhpIssueOperationsResponseData?>(
      (error) {
        emit(
          BhpIssueStatisticsComparisonsError(
            year: year,
            message: error.message,
          ),
        );
        return null;
      },
      (data) => data,
    );
    if (baseData == null || !_isLatestRequest(requestId) || isClosed) {
      return;
    }

    final previousYear = year - 1;
    final previousData = prevResult.fold<GetBhpIssueOperationsResponseData?>(
      (error) {
        emit(
          BhpIssueStatisticsComparisonsError(
            year: year,
            message:
                'Nie udało się pobrać danych porównawczych dla roku '
                '$previousYear: ${error.message}',
          ),
        );
        return null;
      },
      (data) => data,
    );
    if (previousData == null || !_isLatestRequest(requestId) || isClosed) {
      return;
    }

    final twoYearsBack = year - 2;
    final twoBackData = twoBackResult.fold<GetBhpIssueOperationsResponseData?>(
      (error) {
        emit(
          BhpIssueStatisticsComparisonsError(
            year: year,
            message:
                'Nie udało się pobrać danych porównawczych dla roku '
                '$twoYearsBack: ${error.message}',
          ),
        );
        return null;
      },
      (data) => data,
    );
    if (twoBackData == null || !_isLatestRequest(requestId) || isClosed) {
      return;
    }

    final validatedBaseData = _validateResponseYear(
      requestedYear: year,
      data: baseData,
    );
    final validatedPreviousData = _validateResponseYear(
      requestedYear: previousYear,
      data: previousData,
    );
    final validatedTwoBackData = _validateResponseYear(
      requestedYear: twoYearsBack,
      data: twoBackData,
    );
    if (validatedBaseData == null ||
        validatedPreviousData == null ||
        validatedTwoBackData == null ||
        !_isLatestRequest(requestId) ||
        isClosed) {
      return;
    }

    final baseStats = BhpIssueStatsYearly(year, validatedBaseData.items);
    final prevStats = BhpIssueStatsYearly(
      previousYear,
      validatedPreviousData.items,
    );
    final twoBackStats = BhpIssueStatsYearly(
      twoYearsBack,
      validatedTwoBackData.items,
    );

    final snapshot = BhpIssueStatisticsComparisonsSnapshot(
      selectedYearStats: baseStats.toComparisonStats(),
      previousYearStats: prevStats.toComparisonStats(),
      twoYearsBackStats: twoBackStats.toComparisonStats(),
    );

    emit(BhpIssueStatisticsComparisonsSuccess(year: year, snapshot: snapshot));
  }

  GetBhpIssueOperationsResponseData? _validateResponseYear({
    required int requestedYear,
    required GetBhpIssueOperationsResponseData data,
  }) {
    if (data.year == requestedYear) {
      return data;
    }

    emit(
      BhpIssueStatisticsComparisonsError(
        year: state.year,
        message:
            'Backend zwrócił dane dla roku ${data.year} zamiast '
            'żądanego $requestedYear.',
      ),
    );
    return null;
  }

  bool _isLatestRequest(int requestId) => requestId == _requestSequence;
}

/// Pomocnicza klasa do agregowania danych wydań rocznych.
class BhpIssueStatsYearly {
  BhpIssueStatsYearly(this.year, this.items);

  final int year;
  final List<GetBhpIssueOperationItem> items;

  /// Konwertuje do modelu danych porównawczych.
  BhpIssueYearlyComparisonStats toComparisonStats() {
    return BhpIssueYearlyComparisonStats.fromOperations(year, items);
  }
}
