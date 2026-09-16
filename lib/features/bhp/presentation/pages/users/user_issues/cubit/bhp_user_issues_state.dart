import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan wydań BHP konkretnego pracownika.
sealed class BhpUserIssuesState extends Equatable {
  /// Tworzy bazowy stan wydań BHP.
  const BhpUserIssuesState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy ładowania wydań BHP.
final class BhpUserIssuesInitial extends BhpUserIssuesState {
  /// Tworzy stan początkowy.
  const BhpUserIssuesInitial();
}

/// Stan ładowania wydań BHP.
final class BhpUserIssuesLoading extends BhpUserIssuesState {
  /// Tworzy stan ładowania.
  const BhpUserIssuesLoading();
}

/// Stan sukcesu - wydania BHP załadowane pomyślnie.
final class BhpUserIssuesSuccess extends BhpUserIssuesState {
  /// Tworzy stan sukcesu.
  const BhpUserIssuesSuccess({required this.detail});

  /// Pełny detal pracownika wraz ze standardem i historią wydań.
  final GetBhpUserDetail detail;

  /// Pełna historia wydań pracownika.
  List<GetBhpUserIssue> get items => detail.historiaWydan;

  /// Lista aktywnych wydań pracownika.
  List<GetBhpUserIssue> get activeItems => detail.wydaniaAktywne;

  /// Lista zakończonych wydań pracownika.
  List<GetBhpUserIssue> get historyItems => detail.historiaWydan
      .where((issue) => !issue.isActive)
      .toList(growable: false);

  /// Chronologiczna historia operacji pracownika.
  List<GetBhpUserOperation> get operations => detail.operacje;

  @override
  List<Object?> get props => [detail];
}

/// Stan błędu ładowania lub operacji na wydaniach BHP.
final class BhpUserIssuesError extends BhpUserIssuesState {
  /// Tworzy stan błędu.
  const BhpUserIssuesError({required this.message});

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [message];
}
