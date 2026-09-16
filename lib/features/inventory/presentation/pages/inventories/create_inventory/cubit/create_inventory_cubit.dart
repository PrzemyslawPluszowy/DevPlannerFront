import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/create_inventory/cubit/create_inventory_state.dart';

/// Cubit obslugujacy tworzenie nowej inwentaryzacji.
class CreateInventoryCubit extends Cubit<CreateInventoryState> {
  /// Tworzy cubit procesu tworzenia inwentaryzacji.
  CreateInventoryCubit({
    required this._inventoriesRepository,
    required this._stockRepository,
  }) : super(const CreateInventoryLoading()) {
    loadCompanies().ignore();
  }

  final InventoriesRepository _inventoriesRepository;
  final StockRepository _stockRepository;

  /// Laduje liste firm do dropdowna formularza.
  Future<void> loadCompanies() async {
    emit(const CreateInventoryLoading());

    final result = await _stockRepository.fetchCompanies();

    result.fold(
      (error) => emit(CreateInventoryError(message: error.message)),
      (items) {
        final sorted = [...items]
          ..sort(
            (a, b) => a.nazwa.toLowerCase().compareTo(b.nazwa.toLowerCase()),
          );

        emit(
          CreateInventoryLoaded(
            companies: sorted,
            selectedFirmaId: sorted.firstOrNull?.idFirmy,
            isSending: false,
          ),
        );
      },
    );
  }

  /// Ustawia wybrana firme w formularzu.
  void selectFirma(int? firmaId) {
    switch (state) {
      case CreateInventoryLoaded(
        :final companies,
        :final isSending,
        :final companiesError,
        :final submitError,
      ):
        emit(
          CreateInventoryLoaded(
            companies: companies,
            selectedFirmaId: firmaId,
            isSending: isSending,
            companiesError: companiesError,
            submitError: submitError,
          ),
        );
      case CreateInventoryLoading() ||
          CreateInventoryError() ||
          CreateInventorySended():
        break;
    }
  }

  /// Wysyla zadanie utworzenia inwentaryzacji.
  Future<void> submit(PostInwentaryzacjaQuery query) async {
    final current = state;
    if (current is CreateInventoryLoaded) {
      emit(current.copyWith(isSending: true, submitErrorSet: true));

      final result = await _inventoriesRepository.createInwentaryzacja(query);

      result.fold(
        (error) => emit(
          CreateInventoryLoaded(
            companies: current.companies,
            selectedFirmaId: current.selectedFirmaId,
            isSending: false,
            companiesError: current.companiesError,
            submitError: error.message,
          ),
        ),
        (_) => emit(const CreateInventorySended()),
      );
    }
  }
}
