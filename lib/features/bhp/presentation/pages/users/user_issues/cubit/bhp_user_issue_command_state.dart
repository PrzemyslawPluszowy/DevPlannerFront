import 'package:equatable/equatable.dart';

/// Bazowy stan lokalnych komend modyfikujących wydania BHP.
sealed class BhpUserIssueCommandState extends Equatable {
  /// Tworzy bazowy stan komend wydań BHP.
  const BhpUserIssueCommandState();

  /// Informuje, czy trwa zapis operacji.
  bool get isSubmitting;

  @override
  List<Object?> get props => [isSubmitting];
}

/// Stan gotowości lokalnych komend wydania BHP.
final class BhpUserIssueCommandIdle extends BhpUserIssueCommandState {
  /// Tworzy stan gotowości komend.
  const BhpUserIssueCommandIdle();

  @override
  bool get isSubmitting => false;
}

/// Stan wykonywania lokalnej komendy wydania BHP.
final class BhpUserIssueCommandSubmitting extends BhpUserIssueCommandState {
  /// Tworzy stan zapisu komendy.
  const BhpUserIssueCommandSubmitting();

  @override
  bool get isSubmitting => true;
}
