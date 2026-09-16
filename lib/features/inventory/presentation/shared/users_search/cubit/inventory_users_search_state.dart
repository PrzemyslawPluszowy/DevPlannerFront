import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_ready_users_search_models.dart';

/// Bazowy stan wyszukiwarki uzytkownikow.
sealed class InventoryUsersSearchState extends Equatable {
  /// Tworzy bazowy stan wyszukiwarki uzytkownikow.
  const InventoryUsersSearchState({required this.query, required this.results});

  /// Aktualna fraza wyszukiwania.
  final String query;

  /// Aktualna lista wynikow.
  final List<GetReadyUsersSearchItem> results;

  @override
  List<Object?> get props => [query, results];
}

/// Stan poczatkowy wyszukiwarki.
final class InventoryUsersSearchInitial extends InventoryUsersSearchState {
  /// Tworzy stan poczatkowy wyszukiwarki.
  const InventoryUsersSearchInitial()
    : super(query: '', results: const <GetReadyUsersSearchItem>[]);
}

/// Stan ladowania wynikow wyszukiwarki.
final class InventoryUsersSearchLoading extends InventoryUsersSearchState {
  /// Tworzy stan ladowania wynikow wyszukiwarki.
  const InventoryUsersSearchLoading({
    required super.query,
    required super.results,
  });
}

/// Stan poprawnie zaladowanych wynikow wyszukiwarki.
final class InventoryUsersSearchLoaded extends InventoryUsersSearchState {
  /// Tworzy stan poprawnie zaladowanych wynikow wyszukiwarki.
  const InventoryUsersSearchLoaded({
    required super.query,
    required super.results,
  });
}

/// Stan bledu wyszukiwarki.
final class InventoryUsersSearchError extends InventoryUsersSearchState {
  /// Tworzy stan bledu wyszukiwarki.
  const InventoryUsersSearchError({
    required this.message,
    required super.query,
    required super.results,
  });

  /// Komunikat bledu.
  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}
