import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/cubit/bhp_equipment_state.dart';

/// Cubit sekcji wyposażenia BHP.
class BhpEquipmentCubit extends Cubit<BhpEquipmentState> {
  /// Tworzy cubit sekcji wyposażenia BHP.
  BhpEquipmentCubit({required this._repository})
    : super(const BhpEquipmentInitial());

  final BhpEquipmentRepository _repository;
  BhpEquipmentFilter _filter = BhpEquipmentFilter.aktywne;

  /// Aktualnie wybrany filtr listy.
  BhpEquipmentFilter get filter => _filter;

  /// Ładuje katalog wyposażenia BHP.
  Future<void> load([BhpEquipmentFilter? nextFilter]) async {
    _filter = nextFilter ?? _filter;
    emit(const BhpEquipmentLoading());

    final result = await _repository.getEquipment(
      active: switch (_filter) {
        BhpEquipmentFilter.wszystkie => null,
        BhpEquipmentFilter.aktywne => true,
        BhpEquipmentFilter.nieaktywne => false,
      },
    );
    result.fold(
      (error) => emit(BhpEquipmentError(message: error.message)),
      (items) => emit(BhpEquipmentSuccess(items: items, filter: _filter)),
    );
  }
}
