import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan formularza edycji pracownika BHP.
sealed class EditBhpUserState extends Equatable {
  /// Tworzy bazowy stan formularza edycji pracownika.
  const EditBhpUserState();

  @override
  List<Object?> get props => const [];
}

/// Stan ładowania danych formularza edycji pracownika.
final class EditBhpUserLoading extends EditBhpUserState {
  /// Tworzy stan ładowania danych formularza.
  const EditBhpUserLoading();
}

/// Stan błędu inicjalizacji formularza edycji pracownika.
final class EditBhpUserLoadError extends EditBhpUserState {
  /// Tworzy stan błędu inicjalizacji.
  const EditBhpUserLoadError({required this.message});

  /// Komunikat błędu inicjalizacji.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowości formularza edycji pracownika.
final class EditBhpUserReady extends EditBhpUserState {
  /// Tworzy stan gotowości formularza.
  const EditBhpUserReady({
    required this.userDetail,
    required this.positions,
    this.submitError,
  });

  /// Załadowane szczegóły pracownika.
  final GetBhpUserDetail userDetail;

  /// Lista aktywnych stanowisk dostępnych w formularzu.
  final List<GetBhpPositionListItem> positions;

  /// Komunikat błędu zapisu formularza.
  final String? submitError;

  @override
  List<Object?> get props => [userDetail, positions, submitError];
}

/// Stan zapisu formularza edycji pracownika.
final class EditBhpUserSubmitting extends EditBhpUserState {
  /// Tworzy stan zapisu formularza.
  const EditBhpUserSubmitting({
    required this.userDetail,
    required this.positions,
  });

  /// Szczegóły pracownika utrzymywane podczas wysyłki.
  final GetBhpUserDetail userDetail;

  /// Lista stanowisk utrzymywana podczas wysyłki.
  final List<GetBhpPositionListItem> positions;

  @override
  List<Object?> get props => [userDetail, positions];
}

/// Stan poprawnego zapisu pracownika.
final class EditBhpUserSuccess extends EditBhpUserState {
  /// Tworzy stan poprawnego zapisu pracownika.
  const EditBhpUserSuccess({required this.user});

  /// Zaktualizowany pracownik.
  final GetBhpUserListItem user;

  @override
  List<Object?> get props => [user];
}
