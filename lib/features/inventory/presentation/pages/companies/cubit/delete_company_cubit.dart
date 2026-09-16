import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/delete_company_state.dart';

/// Cubit obsługujący usunięcie pojedynczej firmy.
class DeleteCompanyCubit extends Cubit<DeleteCompanyState> {
  /// Tworzy cubit modalu usuwania firmy.
  DeleteCompanyCubit({required this._repository})
    : super(const DeleteCompanyInitial());

  final StockRepository _repository;

  /// Usuwa firmę na podstawie identyfikatora rekordu słownika.
  Future<void> submit({required int companyId}) async {
    emit(const DeleteCompanySubmitting());

    final result = await _repository.deleteCompany(companyId);

    result.fold(
      (error) => emit(DeleteCompanyError(message: error.message)),
      (_) => emit(const DeleteCompanySuccess()),
    );
  }
}
