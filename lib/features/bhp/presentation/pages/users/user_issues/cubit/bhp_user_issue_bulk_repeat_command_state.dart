import 'package:equatable/equatable.dart';

/// Bazowy stan lokalnych komend zbiorczego ponownego wydania BHP.
sealed class BhpUserIssueBulkRepeatCommandState extends Equatable {
  /// Tworzy bazowy stan komend zbiorczego ponownego wydania.
  const BhpUserIssueBulkRepeatCommandState();

  /// Informuje, czy trwa operacja zbiorczego wydania.
  bool get isSubmitting;

  @override
  List<Object?> get props => [isSubmitting];
}

/// Stan gotowości komendy zbiorczego ponownego wydania.
final class BhpUserIssueBulkRepeatCommandIdle
    extends BhpUserIssueBulkRepeatCommandState {
  /// Tworzy stan gotowości komendy.
  const BhpUserIssueBulkRepeatCommandIdle();

  @override
  bool get isSubmitting => false;
}

/// Stan wykonywania komendy zbiorczego ponownego wydania.
final class BhpUserIssueBulkRepeatCommandSubmitting
    extends BhpUserIssueBulkRepeatCommandState {
  /// Tworzy stan wykonywania komendy.
  const BhpUserIssueBulkRepeatCommandSubmitting();

  @override
  bool get isSubmitting => true;
}
