import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan globalnej historii operacji BHP.
sealed class BhpIssueOperationsState extends Equatable {
  /// Tworzy bazowy stan historii operacji BHP.
  const BhpIssueOperationsState({required this.year});

  /// Wybrany rok feedu.
  final int year;

  @override
  List<Object?> get props => [year];
}

/// Stan początkowy globalnej historii operacji BHP.
final class BhpIssueOperationsInitial extends BhpIssueOperationsState {
  /// Tworzy stan początkowy.
  const BhpIssueOperationsInitial({required super.year});
}

/// Stan ładowania globalnej historii operacji BHP.
final class BhpIssueOperationsLoading extends BhpIssueOperationsState {
  /// Tworzy stan ładowania.
  const BhpIssueOperationsLoading({required super.year});
}

/// Stan sukcesu globalnej historii operacji BHP.
final class BhpIssueOperationsSuccess extends BhpIssueOperationsState {
  /// Tworzy stan sukcesu.
  const BhpIssueOperationsSuccess({
    required super.year,
    required this.data,
  });

  /// Załadowane dane.
  final GetBhpIssueOperationsResponseData data;

  /// Lista operacji.
  List<GetBhpIssueOperationItem> get items => data.items;

  @override
  List<Object?> get props => [year, data];
}

/// Stan błędu globalnej historii operacji BHP.
final class BhpIssueOperationsError extends BhpIssueOperationsState {
  /// Tworzy stan błędu.
  const BhpIssueOperationsError({
    required super.year,
    required this.message,
  });

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [year, message];
}
