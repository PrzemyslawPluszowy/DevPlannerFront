import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';

/// Bazowy stan listy alertów dashboardu BHP.
sealed class BhpDashboardAlertsState extends Equatable {
  /// Tworzy bazowy stan listy alertów dashboardu BHP.
  const BhpDashboardAlertsState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy listy alertów dashboardu BHP.
final class BhpDashboardAlertsInitial extends BhpDashboardAlertsState {
  /// Tworzy stan początkowy listy alertów dashboardu BHP.
  const BhpDashboardAlertsInitial();
}

/// Stan ładowania listy alertów dashboardu BHP.
final class BhpDashboardAlertsLoading extends BhpDashboardAlertsState {
  /// Tworzy stan ładowania listy alertów dashboardu BHP.
  const BhpDashboardAlertsLoading();
}

/// Stan sukcesu listy alertów dashboardu BHP.
final class BhpDashboardAlertsSuccess extends BhpDashboardAlertsState {
  /// Tworzy stan sukcesu listy alertów dashboardu BHP.
  const BhpDashboardAlertsSuccess({required this.rows});

  /// Lista widocznych alertów.
  final List<GetBhpIssueAlertItem> rows;

  @override
  List<Object?> get props => [rows];
}

/// Stan błędu listy alertów dashboardu BHP.
final class BhpDashboardAlertsError extends BhpDashboardAlertsState {
  /// Tworzy stan błędu listy alertów dashboardu BHP.
  const BhpDashboardAlertsError({required this.message});

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Bazowy cubit listy alertów dashboardu BHP.
abstract class BhpDashboardAlertsCubit extends Cubit<BhpDashboardAlertsState> {
  /// Tworzy bazowy cubit listy alertów dashboardu BHP.
  BhpDashboardAlertsCubit({
    required this._repository,
    required this.filter,
    required this.sortRows,
  }) : super(const BhpDashboardAlertsInitial()) {
    load().ignore();
  }

  final BhpDashboardRepository _repository;

  /// Filtr wydobywający dane dla konkretnego widgetu.
  final bool Function(GetBhpIssueAlertItem item) filter;

  /// Sortowanie zastosowane do listy rekordów.
  final int Function(GetBhpIssueAlertItem left, GetBhpIssueAlertItem right)
  sortRows;

  /// Ładuje alerty dla konkretnego widgetu.
  Future<void> load({int monthsAhead = 1}) async {
    emit(const BhpDashboardAlertsLoading());

    final result = await _repository.getIssueAlerts(monthsAhead: monthsAhead);
    if (isClosed) {
      return;
    }

    result.fold(
      (error) => emit(BhpDashboardAlertsError(message: error.message)),
      (data) {
        final rows = [
          for (final item in [...data.overdue, ...data.upcoming])
            if (filter(item)) item,
        ]..sort(sortRows);

        emit(BhpDashboardAlertsSuccess(rows: rows));
      },
    );
  }
}

/// Sortuje alerty według pilności.
int sortBhpDashboardAlertsByUrgency(
  GetBhpIssueAlertItem left,
  GetBhpIssueAlertItem right,
) {
  return left.daysToDue.compareTo(right.daysToDue);
}
