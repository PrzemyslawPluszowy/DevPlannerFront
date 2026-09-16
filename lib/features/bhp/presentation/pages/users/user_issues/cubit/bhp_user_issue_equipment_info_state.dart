import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan modala szczegółów karty wyposażenia.
sealed class BhpUserIssueEquipmentInfoState extends Equatable {
  /// Tworzy bazowy stan modala szczegółów karty wyposażenia.
  const BhpUserIssueEquipmentInfoState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy modala szczegółów karty wyposażenia.
final class BhpUserIssueEquipmentInfoInitial
    extends BhpUserIssueEquipmentInfoState {
  /// Tworzy stan początkowy modala szczegółów karty wyposażenia.
  const BhpUserIssueEquipmentInfoInitial();
}

/// Stan ładowania szczegółów karty wyposażenia.
final class BhpUserIssueEquipmentInfoLoading
    extends BhpUserIssueEquipmentInfoState {
  /// Tworzy stan ładowania szczegółów karty wyposażenia.
  const BhpUserIssueEquipmentInfoLoading();
}

/// Stan sukcesu szczegółów karty wyposażenia.
final class BhpUserIssueEquipmentInfoSuccess
    extends BhpUserIssueEquipmentInfoState {
  /// Tworzy stan sukcesu szczegółów karty wyposażenia.
  const BhpUserIssueEquipmentInfoSuccess({required this.item});

  /// Szczegóły karty wyposażenia.
  final GetBhpEquipmentDetails item;

  @override
  List<Object?> get props => [item];
}

/// Stan błędu szczegółów karty wyposażenia.
final class BhpUserIssueEquipmentInfoError
    extends BhpUserIssueEquipmentInfoState {
  /// Tworzy stan błędu szczegółów karty wyposażenia.
  const BhpUserIssueEquipmentInfoError({required this.message});

  /// Komunikat błędu do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
