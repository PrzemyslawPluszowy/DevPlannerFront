import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/delete_stan_st_state.dart';

/// Cubit obslugujacy usuwanie pojedynczego rekordu `stan_st`.
class DeleteStanStCubit extends Cubit<DeleteStanStState> {
  /// Tworzy cubit modalu usuwania rekordu `stan_st`.
  DeleteStanStCubit({required this._repository})
    : super(const DeleteStanStInitial());

  final StockRepository _repository;

  /// Usuwa rekord `stan_st` po potwierdzeniu numeru i nazwy.
  Future<void> submit({
    required int stockItemId,
    required String confirmNrewid,
    required String confirmNazwa,
  }) async {
    emit(const DeleteStanStSubmitting());

    final result = await _repository.deleteStockItem(
      stockItemId: stockItemId,
      confirmNrewid: confirmNrewid,
      confirmNazwa: confirmNazwa,
    );

    result.fold(
      (error) => emit(DeleteStanStError(message: error.message)),
      (_) => emit(const DeleteStanStSuccess()),
    );
  }
}
