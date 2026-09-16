import 'package:bloc/bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/operations/cubit/bhp_issue_operations_state.dart';

/// Cubit globalnej historii operacji BHP.
class BhpIssueOperationsCubit extends Cubit<BhpIssueOperationsState> {
  /// Tworzy cubit globalnej historii operacji.
  BhpIssueOperationsCubit({
    required this._repository,
  }) : super(BhpIssueOperationsInitial(year: DateTime.now().year));

  final BhpDashboardRepository _repository;
  int _requestSequence = 0;

  /// Ładuje globalną historię operacji dla wybranego roku.
  Future<void> load([int? year]) async {
    final selectedYear = year ?? state.year;
    final requestId = ++_requestSequence;
    emit(BhpIssueOperationsLoading(year: selectedYear));

    final result = await _repository.getIssueOperations(selectedYear);
    if (!_isLatestRequest(requestId) || isClosed) {
      return;
    }

    result.fold(
      (error) => emit(
        BhpIssueOperationsError(
          year: selectedYear,
          message: error.message,
        ),
      ),
      (data) {
        if (data.year != selectedYear) {
          emit(
            BhpIssueOperationsError(
              year: selectedYear,
              message:
                  'Backend zwrocil dane dla roku ${data.year} zamiast '
                  'zadanego $selectedYear.',
            ),
          );
          return;
        }

        emit(
          BhpIssueOperationsSuccess(
            year: selectedYear,
            data: data,
          ),
        );
      },
    );
  }

  bool _isLatestRequest(int requestId) => requestId == _requestSequence;
}
