import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan sekcji pracowników BHP.
sealed class BhpUsersState extends Equatable {
  /// Tworzy bazowy stan sekcji pracowników BHP.
  const BhpUsersState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy sekcji pracowników BHP.
final class BhpUsersInitial extends BhpUsersState {
  /// Tworzy stan początkowy sekcji pracowników BHP.
  const BhpUsersInitial();
}

/// Stan ładowania sekcji pracowników BHP.
final class BhpUsersLoading extends BhpUsersState {
  /// Tworzy stan ładowania sekcji pracowników BHP.
  const BhpUsersLoading();
}

/// Stan sukcesu sekcji pracowników BHP.
final class BhpUsersSuccess extends BhpUsersState {
  /// Tworzy stan sukcesu sekcji pracowników BHP.
  const BhpUsersSuccess({required this.items});

  /// Lista pracowników BHP.
  final List<GetBhpUserListItem> items;

  @override
  List<Object?> get props => [items];
}

/// Stan błędu sekcji pracowników BHP.
final class BhpUsersError extends BhpUsersState {
  /// Tworzy stan błędu sekcji pracowników BHP.
  const BhpUsersError({required this.message});

  /// Komunikat błędu do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
