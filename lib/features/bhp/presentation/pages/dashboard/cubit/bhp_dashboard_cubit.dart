import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/dashboard/cubit/bhp_dashboard_state.dart';

/// Cubit sekcji dashboardu BHP.
class BhpDashboardCubit extends Cubit<BhpDashboardState> {
  /// Tworzy cubit sekcji dashboardu BHP.
  BhpDashboardCubit({required this._repository})
    : super(const BhpDashboardInitial());

  final BhpDashboardRepository _repository;
  int _requestSequence = 0;

  /// Ładuje dane dashboardu BHP.
  Future<void> load({int monthsAhead = 1}) async {
    final requestId = ++_requestSequence;
    final previousData = switch (state) {
      BhpDashboardSuccess(:final data) => data,
      BhpDashboardLoading(:final previousData) => previousData,
      BhpDashboardError(:final previousData) => previousData,
      _ => null,
    };

    emit(BhpDashboardLoading(previousData: previousData));

    final result = await _repository.getIssueAlerts(monthsAhead: monthsAhead);
    if (isClosed || requestId != _requestSequence) {
      return;
    }

    result.fold(
      (error) => emit(
        BhpDashboardError(
          message: error.message,
          previousData: previousData,
        ),
      ),
      (data) => emit(BhpDashboardSuccess(data: data)),
    );
  }
}
