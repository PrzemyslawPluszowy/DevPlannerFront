import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';

/// Abstrakcyjny stan pobierania inwentaryzacji w toku.
sealed class ActiveInventoriesState extends Equatable {
  /// Tworzy abstrakcyjny stan pobierania inwentaryzacji w toku.
  const ActiveInventoriesState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy przed załadowaniem danych.
final class ActiveInventoriesInitial extends ActiveInventoriesState {
  /// Tworzy stan początkowy przed załadowaniem danych.
  const ActiveInventoriesInitial();
}

/// Stan ładowania danych z endpointu.
final class ActiveInventoriesLoading extends ActiveInventoriesState {
  /// Tworzy stan ładowania danych z endpointu.
  const ActiveInventoriesLoading();
}

/// Stan udanego załadowania danych z listą elementów.
final class ActiveInventoriesLoaded extends ActiveInventoriesState {
  /// Tworzy stan załadowanych danych.
  const ActiveInventoriesLoaded(this.items);

  /// Lista aktywnych inwentaryzacji.
  final List<GetInwentaryzacjeItem> items;

  @override
  List<Object?> get props => [items];
}

/// Stan błędu pobierania danych.
final class ActiveInventoriesError extends ActiveInventoriesState {
  /// Tworzy stan błędu.
  const ActiveInventoriesError(this.message);

  /// Komunikat błędu z repozytorium.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Cubit odpowiedzialny za komunikację z API i pobieranie inwentaryzacji w toku.
class ActiveInventoriesCubit extends Cubit<ActiveInventoriesState> {
  /// Tworzy cubit aktywnych inwentaryzacji.
  ActiveInventoriesCubit({required this._repository})
    : super(const ActiveInventoriesInitial()) {
    load().ignore();
  }

  final InventoriesRepository _repository;

  /// Pobiera listę inwentaryzacji w toku (status: 1).
  Future<void> load() async {
    emit(const ActiveInventoriesLoading());
    final result = await _repository.fetchInventories(
      const GetInwentaryzacjeQuery(
        status: 1, // InwentaryzacjaStatus.wToku (1)
        sortBy: GetInwentaryzacjeSortBy.dataOd,
        sortDir: GetInwentaryzacjeSortDirection.desc,
      ),
    );
    if (isClosed) {
      return;
    }
    result.fold(
      (error) => emit(ActiveInventoriesError(error.message)),
      (data) => emit(ActiveInventoriesLoaded(data.items)),
    );
  }
}
