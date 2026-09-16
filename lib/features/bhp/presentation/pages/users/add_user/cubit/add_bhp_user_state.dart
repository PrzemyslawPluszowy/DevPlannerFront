import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan formularza dodawania pracownika BHP.
sealed class AddBhpUserState extends Equatable {
  /// Tworzy bazowy stan formularza dodawania pracownika.
  const AddBhpUserState();

  @override
  List<Object?> get props => const [];
}

/// Stan ładowania danych formularza dodawania pracownika.
final class AddBhpUserLoading extends AddBhpUserState {
  /// Tworzy stan ładowania danych formularza.
  const AddBhpUserLoading();
}

/// Stan błędu inicjalizacji formularza dodawania pracownika.
final class AddBhpUserLoadError extends AddBhpUserState {
  /// Tworzy stan błędu inicjalizacji.
  const AddBhpUserLoadError({required this.message});

  /// Komunikat błędu inicjalizacji.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowości formularza dodawania pracownika.
final class AddBhpUserReady extends AddBhpUserState {
  /// Tworzy stan gotowości formularza.
  const AddBhpUserReady({
    required this.positions,
    this.submitError,
  });

  /// Lista aktywnych stanowisk dostępnych w formularzu.
  final List<GetBhpPositionListItem> positions;

  /// Komunikat błędu zapisu formularza.
  final String? submitError;

  @override
  List<Object?> get props => [positions, submitError];
}

/// Stan zapisu formularza dodawania pracownika.
final class AddBhpUserSubmitting extends AddBhpUserState {
  /// Tworzy stan zapisu formularza.
  const AddBhpUserSubmitting({required this.positions});

  /// Lista stanowisk utrzymywana podczas wysyłki.
  final List<GetBhpPositionListItem> positions;

  @override
  List<Object?> get props => [positions];
}

/// Stan poprawnego utworzenia pracownika.
final class AddBhpUserSuccess extends AddBhpUserState {
  /// Tworzy stan poprawnego utworzenia pracownika.
  const AddBhpUserSuccess({required this.user});

  /// Utworzony pracownik.
  final GetBhpUserListItem user;

  @override
  List<Object?> get props => [user];
}
