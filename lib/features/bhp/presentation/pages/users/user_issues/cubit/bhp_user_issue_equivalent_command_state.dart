import 'package:equatable/equatable.dart';

/// Bazowy stan lokalnych komend ekwiwalentu dla wydania BHP.
sealed class BhpUserIssueEquivalentCommandState extends Equatable {
  /// Tworzy bazowy stan komend ekwiwalentu.
  const BhpUserIssueEquivalentCommandState();

  /// Informuje, czy trwa zapis lub usuwanie ekwiwalentu.
  bool get isSubmitting;

  @override
  List<Object?> get props => [isSubmitting];
}

/// Stan gotowości lokalnych komend ekwiwalentu.
final class BhpUserIssueEquivalentCommandIdle
    extends BhpUserIssueEquivalentCommandState {
  /// Tworzy stan gotowości komend ekwiwalentu.
  const BhpUserIssueEquivalentCommandIdle();

  @override
  bool get isSubmitting => false;
}

/// Stan wykonywania lokalnej komendy ekwiwalentu.
final class BhpUserIssueEquivalentCommandSubmitting
    extends BhpUserIssueEquivalentCommandState {
  /// Tworzy stan wykonywania komendy ekwiwalentu.
  const BhpUserIssueEquivalentCommandSubmitting();

  @override
  bool get isSubmitting => true;
}
