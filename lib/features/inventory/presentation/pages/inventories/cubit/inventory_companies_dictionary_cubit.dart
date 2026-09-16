import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

/// Cubit slownika firm uzywanego na liscie inwentaryzacji.
class InventoryCompaniesDictionaryCubit
    extends LoadableCubit<Map<int, String>> {
  /// Tworzy cubit slownika firm dla sekcji "Inwentaryzacje".
  InventoryCompaniesDictionaryCubit({required this._repository});

  final StockRepository _repository;

  /// Laduje slownik firm mapowany po `id_firmy`.
  Future<void> load() async {
    emitLoading();

    final result = await _repository.fetchCompanies();
    result.fold(
      (error) => emitError(error.message),
      (items) => emitSuccess({
        for (final item in items) item.idFirmy: item.nazwa.trim(),
      }),
    );
  }
}
