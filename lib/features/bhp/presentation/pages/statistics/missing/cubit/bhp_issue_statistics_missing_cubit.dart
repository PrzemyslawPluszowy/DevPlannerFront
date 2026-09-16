import 'package:bloc/bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/missing/cubit/bhp_issue_statistics_missing_state.dart';

/// Cubit sekcji statystyk braków BHP.
class BhpIssueStatisticsMissingCubit
    extends Cubit<BhpIssueStatisticsMissingState> {
  /// Tworzy cubit sekcji braków.
  BhpIssueStatisticsMissingCubit({
    required this._repository,
  }) : super(const BhpIssueStatisticsMissingInitial());

  final BhpDashboardRepository _repository;
  int _requestSequence = 0;

  /// Ładuje globalne braki wyposażenia.
  Future<void> load() async {
    final requestId = ++_requestSequence;
    emit(BhpIssueStatisticsMissingLoading(data: state.data));

    final result = await _repository.getMissingEquipment();
    if (!_isLatestRequest(requestId) || isClosed) {
      return;
    }
    result.fold(
      (error) => emit(
        BhpIssueStatisticsMissingError(
          message: error.message,
          data: state.data,
        ),
      ),
      (data) => emit(BhpIssueStatisticsMissingSuccess(data: data)),
    );
  }

  bool _isLatestRequest(int requestId) => requestId == _requestSequence;
}
