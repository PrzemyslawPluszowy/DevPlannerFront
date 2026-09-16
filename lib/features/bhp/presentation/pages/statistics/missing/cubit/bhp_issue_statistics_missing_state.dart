import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan sekcji statystyk braków BHP.
sealed class BhpIssueStatisticsMissingState extends Equatable {
  /// Tworzy bazowy stan sekcji braków.
  const BhpIssueStatisticsMissingState({this.data});

  /// Załadowane dane sekcji, jeśli są dostępne.
  final GetBhpMissingEquipmentResponseData? data;

  @override
  List<Object?> get props => [data];
}

/// Stan początkowy sekcji braków.
final class BhpIssueStatisticsMissingInitial
    extends BhpIssueStatisticsMissingState {
  /// Tworzy stan początkowy sekcji braków.
  const BhpIssueStatisticsMissingInitial();
}

/// Stan ładowania sekcji braków.
final class BhpIssueStatisticsMissingLoading
    extends BhpIssueStatisticsMissingState {
  /// Tworzy stan ładowania sekcji braków.
  const BhpIssueStatisticsMissingLoading({super.data});
}

/// Stan gotowości sekcji braków.
final class BhpIssueStatisticsMissingSuccess
    extends BhpIssueStatisticsMissingState {
  /// Tworzy stan sukcesu sekcji braków.
  const BhpIssueStatisticsMissingSuccess({required super.data});
}

/// Stan błędu ładowania sekcji braków.
final class BhpIssueStatisticsMissingError
    extends BhpIssueStatisticsMissingState {
  /// Tworzy stan błędu sekcji braków.
  const BhpIssueStatisticsMissingError({
    required this.message,
    super.data,
  });

  /// Komunikat błędu dla użytkownika.
  final String message;

  @override
  List<Object?> get props => [data, message];
}
