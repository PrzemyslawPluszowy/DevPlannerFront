import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/companies/cubit/companies_state.dart';

/// Cubit obsługujący pobieranie i listowanie firm.
/// Korzysta z istniejącej metody fetchCompanies() w StockRepository.
class CompaniesCubit extends Cubit<CompaniesState> {
  /// Tworzy cubit z repozytorium.
  CompaniesCubit({required this._repository})
    : super(const CompaniesInitial());

  final StockRepository _repository;

  /// Pobiera listę firm.
  Future<void> load({bool forceRefresh = false}) async {
    emit(const CompaniesLoading());

    final result = await _repository.fetchCompanies(forceRefresh: forceRefresh);

    result.fold(
      (error) => emit(CompaniesError(message: error.message)),
      (data) => emit(CompaniesSuccess(companies: data)),
    );
  }
}
