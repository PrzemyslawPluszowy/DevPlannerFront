import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan sekcji dashboardu BHP.
sealed class BhpDashboardState extends Equatable {
  /// Tworzy bazowy stan sekcji dashboardu BHP.
  const BhpDashboardState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy sekcji dashboardu BHP.
final class BhpDashboardInitial extends BhpDashboardState {
  /// Tworzy stan początkowy sekcji dashboardu BHP.
  const BhpDashboardInitial();
}

/// Stan ładowania sekcji dashboardu BHP.
final class BhpDashboardLoading extends BhpDashboardState {
  /// Tworzy stan ładowania sekcji dashboardu BHP.
  const BhpDashboardLoading({this.previousData});

  /// Poprzednio załadowane dane, które można utrzymać podczas odświeżania.
  final GetBhpDashboardResponseData? previousData;

  @override
  List<Object?> get props => [previousData];
}

/// Stan sukcesu sekcji dashboardu BHP.
final class BhpDashboardSuccess extends BhpDashboardState {
  /// Tworzy stan sukcesu sekcji dashboardu BHP.
  const BhpDashboardSuccess({required this.data});

  /// Dane dashboardu BHP.
  final GetBhpDashboardResponseData data;

  @override
  List<Object?> get props => [data];
}

/// Stan błędu sekcji dashboardu BHP.
final class BhpDashboardError extends BhpDashboardState {
  /// Tworzy stan błędu sekcji dashboardu BHP.
  const BhpDashboardError({required this.message, this.previousData});

  /// Komunikat błędu do UI.
  final String message;

  /// Poprzednio załadowane dane, jeśli błąd wystąpił podczas odświeżania.
  final GetBhpDashboardResponseData? previousData;

  @override
  List<Object?> get props => [message, previousData];
}
