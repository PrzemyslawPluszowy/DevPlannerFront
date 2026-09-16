import 'package:ready_next/features/dashboard/presentation/widgets/bhp_dashboard/alerts/cubit/bhp_dashboard_alerts_cubit.dart';

/// Cubit alertów po terminie.
class BhpDashboardOverdueCubit extends BhpDashboardAlertsCubit {
  /// Tworzy cubit alertów po terminie.
  BhpDashboardOverdueCubit({required super.repository})
    : super(
        filter: (item) => item.daysToDue < 0,
        sortRows: sortBhpDashboardAlertsByUrgency,
      );
}
