import 'package:bloc/bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/structure/cubit/bhp_issue_statistics_structure_state.dart';

/// Cubit sekcji statystyk struktury BHP.
class BhpIssueStatisticsStructureCubit
    extends Cubit<BhpIssueStatisticsStructureState> {
  /// Tworzy cubit sekcji struktury.
  BhpIssueStatisticsStructureCubit({
    required this._repository,
    required int initialYear,
  }) : super(BhpIssueStatisticsStructureInitial(year: initialYear));

  final BhpDashboardRepository _repository;
  int _requestSequence = 0;

  /// Ładuje dane struktury dla wybranego roku.
  Future<void> load(int year) async {
    final requestId = ++_requestSequence;
    emit(BhpIssueStatisticsStructureLoading(year: year, data: state.data));

    final result = await _repository.getIssueOperations(year);
    if (!_isLatestRequest(requestId) || isClosed) {
      return;
    }

    result.fold(
      (error) => emit(
        BhpIssueStatisticsStructureError(
          year: year,
          message: error.message,
          data: state.data,
        ),
      ),
      (data) {
        if (data.year != year) {
          emit(
            BhpIssueStatisticsStructureError(
              year: year,
              message:
                  'Backend zwrócił dane dla roku ${data.year} '
                  'zamiast żądanego $year.',
              data: state.data,
            ),
          );
          return;
        }

        emit(BhpIssueStatisticsStructureSuccess(year: year, data: data));
      },
    );
  }

  bool _isLatestRequest(int requestId) => requestId == _requestSequence;
}
