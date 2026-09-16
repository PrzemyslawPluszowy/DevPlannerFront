import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';

/// Bazowy stan widgetu podglądu stanowisk BHP.
sealed class BhpDashboardPositionsState extends Equatable {
  /// Tworzy bazowy stan widgetu podglądu stanowisk BHP.
  const BhpDashboardPositionsState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy widgetu podglądu stanowisk BHP.
final class BhpDashboardPositionsInitial extends BhpDashboardPositionsState {
  /// Tworzy stan początkowy widgetu podglądu stanowisk BHP.
  const BhpDashboardPositionsInitial();
}

/// Stan ładowania widgetu podglądu stanowisk BHP.
final class BhpDashboardPositionsLoading extends BhpDashboardPositionsState {
  /// Tworzy stan ładowania widgetu podglądu stanowisk BHP.
  const BhpDashboardPositionsLoading();
}

/// Stan sukcesu widgetu podglądu stanowisk BHP.
final class BhpDashboardPositionsSuccess extends BhpDashboardPositionsState {
  /// Tworzy stan sukcesu widgetu podglądu stanowisk BHP.
  const BhpDashboardPositionsSuccess({required this.items});

  /// Lista stanowisk BHP.
  final List<GetBhpPositionListItem> items;

  @override
  List<Object?> get props => [items];
}

/// Stan błędu widgetu podglądu stanowisk BHP.
final class BhpDashboardPositionsError extends BhpDashboardPositionsState {
  /// Tworzy stan błędu widgetu podglądu stanowisk BHP.
  const BhpDashboardPositionsError({required this.message});

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Cubit podglądu stanowisk BHP.
class BhpDashboardPositionsCubit extends Cubit<BhpDashboardPositionsState> {
  /// Tworzy cubit podglądu stanowisk BHP.
  BhpDashboardPositionsCubit({required this._repository})
    : super(const BhpDashboardPositionsInitial()) {
    load().ignore();
  }

  final BhpPositionsRepository _repository;

  /// Ładuje aktywne stanowiska BHP.
  Future<void> load() async {
    emit(const BhpDashboardPositionsLoading());
    final result = await _repository.getPositions(active: true);
    if (isClosed) {
      return;
    }
    result.fold(
      (error) => emit(BhpDashboardPositionsError(message: error.message)),
      (items) => emit(
        BhpDashboardPositionsSuccess(
          items: [...items]
            ..sort((left, right) => left.nazwa.compareTo(right.nazwa)),
        ),
      ),
    );
  }
}
