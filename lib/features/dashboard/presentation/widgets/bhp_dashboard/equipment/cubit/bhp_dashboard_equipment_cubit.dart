import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';

/// Bazowy stan widgetu podglądu wyposażenia BHP.
sealed class BhpDashboardEquipmentState extends Equatable {
  /// Tworzy bazowy stan widgetu podglądu wyposażenia BHP.
  const BhpDashboardEquipmentState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy widgetu podglądu wyposażenia BHP.
final class BhpDashboardEquipmentInitial extends BhpDashboardEquipmentState {
  /// Tworzy stan początkowy widgetu podglądu wyposażenia BHP.
  const BhpDashboardEquipmentInitial();
}

/// Stan ładowania widgetu podglądu wyposażenia BHP.
final class BhpDashboardEquipmentLoading extends BhpDashboardEquipmentState {
  /// Tworzy stan ładowania widgetu podglądu wyposażenia BHP.
  const BhpDashboardEquipmentLoading();
}

/// Stan sukcesu widgetu podglądu wyposażenia BHP.
final class BhpDashboardEquipmentSuccess extends BhpDashboardEquipmentState {
  /// Tworzy stan sukcesu widgetu podglądu wyposażenia BHP.
  const BhpDashboardEquipmentSuccess({required this.items});

  /// Lista wyposażenia BHP.
  final List<GetBhpEquipmentListItem> items;

  @override
  List<Object?> get props => [items];
}

/// Stan błędu widgetu podglądu wyposażenia BHP.
final class BhpDashboardEquipmentError extends BhpDashboardEquipmentState {
  /// Tworzy stan błędu widgetu podglądu wyposażenia BHP.
  const BhpDashboardEquipmentError({required this.message});

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Cubit podglądu wyposażenia BHP.
class BhpDashboardEquipmentCubit extends Cubit<BhpDashboardEquipmentState> {
  /// Tworzy cubit podglądu wyposażenia BHP.
  BhpDashboardEquipmentCubit({required this._repository})
    : super(const BhpDashboardEquipmentInitial()) {
    load().ignore();
  }

  final BhpEquipmentRepository _repository;

  /// Ładuje aktywne wyposażenie BHP.
  Future<void> load() async {
    emit(const BhpDashboardEquipmentLoading());
    final result = await _repository.getEquipment(active: true);
    if (isClosed) {
      return;
    }
    result.fold(
      (error) => emit(BhpDashboardEquipmentError(message: error.message)),
      (items) {
        final sorted = [...items]
          ..sort((left, right) {
            final leftKey = '${left.symbol} ${left.nazwa}'.toLowerCase();
            final rightKey = '${right.symbol} ${right.nazwa}'.toLowerCase();
            return leftKey.compareTo(rightKey);
          });
        emit(BhpDashboardEquipmentSuccess(items: sorted));
      },
    );
  }
}
