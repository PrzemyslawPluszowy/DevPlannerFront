import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';

/// Bazowy stan widgetu podglądu pracowników BHP.
sealed class BhpDashboardUsersState extends Equatable {
  /// Tworzy bazowy stan widgetu podglądu pracowników BHP.
  const BhpDashboardUsersState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy widgetu podglądu pracowników BHP.
final class BhpDashboardUsersInitial extends BhpDashboardUsersState {
  /// Tworzy stan początkowy widgetu podglądu pracowników BHP.
  const BhpDashboardUsersInitial();
}

/// Stan ładowania widgetu podglądu pracowników BHP.
final class BhpDashboardUsersLoading extends BhpDashboardUsersState {
  /// Tworzy stan ładowania widgetu podglądu pracowników BHP.
  const BhpDashboardUsersLoading();
}

/// Stan sukcesu widgetu podglądu pracowników BHP.
final class BhpDashboardUsersSuccess extends BhpDashboardUsersState {
  /// Tworzy stan sukcesu widgetu podglądu pracowników BHP.
  const BhpDashboardUsersSuccess({required this.items});

  /// Lista pracowników BHP.
  final List<GetBhpUserListItem> items;

  @override
  List<Object?> get props => [items];
}

/// Stan błędu widgetu podglądu pracowników BHP.
final class BhpDashboardUsersError extends BhpDashboardUsersState {
  /// Tworzy stan błędu widgetu podglądu pracowników BHP.
  const BhpDashboardUsersError({required this.message});

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Cubit podglądu pracowników BHP.
class BhpDashboardUsersCubit extends Cubit<BhpDashboardUsersState> {
  /// Tworzy cubit podglądu pracowników BHP.
  BhpDashboardUsersCubit({required this._repository})
    : super(const BhpDashboardUsersInitial()) {
    load().ignore();
  }

  final BhpUsersRepository _repository;

  /// Ładuje aktywnych pracowników BHP.
  Future<void> load() async {
    emit(const BhpDashboardUsersLoading());
    final result = await _repository.getUsers(active: true);
    if (isClosed) {
      return;
    }
    result.fold(
      (error) => emit(BhpDashboardUsersError(message: error.message)),
      (items) {
        final sorted = [...items]..sort(_compareUsersByPriority);
        emit(BhpDashboardUsersSuccess(items: sorted));
      },
    );
  }
}

int _compareUsersByPriority(
  GetBhpUserListItem left,
  GetBhpUserListItem right,
) {
  final leftOverdue = left.overdueCount;
  final rightOverdue = right.overdueCount;
  if (leftOverdue != rightOverdue) {
    return rightOverdue.compareTo(leftOverdue);
  }

  final leftUpcoming = left.upcomingCount;
  final rightUpcoming = right.upcomingCount;
  if (leftUpcoming != rightUpcoming) {
    return rightUpcoming.compareTo(leftUpcoming);
  }

  return left.fullName.compareTo(right.fullName);
}
