import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_models.dart';

/// Bazowy stan procesu tworzenia arkusza.
sealed class CreateArkuszState extends Equatable {
  /// Tworzy bazowy stan procesu tworzenia arkusza.
  const CreateArkuszState();

  @override
  List<Object?> get props => const [];
}

/// Stan ladowania danych slownikowych do formularza.
final class CreateArkuszLoading extends CreateArkuszState {
  /// Tworzy stan ladowania danych slownikowych.
  const CreateArkuszLoading();
}

/// Stan bledu ladowania danych do formularza.
final class CreateArkuszLoadError extends CreateArkuszState {
  /// Tworzy stan bledu ladowania danych do formularza.
  const CreateArkuszLoadError({required this.message});

  /// Komunikat bledu przekazywany do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowego formularza tworzenia arkusza.
final class CreateArkuszReady extends CreateArkuszState {
  /// Tworzy stan gotowego formularza tworzenia arkusza.
  const CreateArkuszReady({
    required this.locations,
    required this.selectedLocationId,
    required this.numerRaw,
    required this.komisjaRaw,
    required this.submitError,
    required this.isSubmitting,
  });

  /// Lista miejsc dostepnych do wyboru.
  final List<GetMiejscaItem> locations;

  /// Aktualnie wybrane techniczne `id` rekordu miejsca.
  final int? selectedLocationId;

  /// Surowa wartosc wpisana w pole numeru arkusza.
  final String numerRaw;

  /// Surowa wartosc wpisana w pole komisji.
  final String komisjaRaw;

  /// Komunikat bledu walidacji lub zapisu.
  final String? submitError;

  /// Flaga trwajacej wysylki formularza.
  final bool isSubmitting;

  @override
  List<Object?> get props => [
    locations,
    selectedLocationId,
    numerRaw,
    komisjaRaw,
    submitError,
    isSubmitting,
  ];

  /// Tworzy kopie stanu formularza z nadpisanymi wartosciami.
  CreateArkuszReady copyWith({
    List<GetMiejscaItem>? locations,
    int? selectedLocationId,
    bool selectedLocationIdSet = false,
    String? numerRaw,
    String? komisjaRaw,
    String? submitError,
    bool submitErrorSet = false,
    bool? isSubmitting,
  }) {
    return CreateArkuszReady(
      locations: locations ?? this.locations,
      selectedLocationId: selectedLocationIdSet
          ? selectedLocationId
          : this.selectedLocationId,
      numerRaw: numerRaw ?? this.numerRaw,
      komisjaRaw: komisjaRaw ?? this.komisjaRaw,
      submitError: submitErrorSet ? submitError : this.submitError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

/// Stan poprawnego utworzenia arkusza.
final class CreateArkuszSuccess extends CreateArkuszState {
  /// Tworzy stan sukcesu tworzenia arkusza.
  const CreateArkuszSuccess({required this.response});

  /// Dane nowo utworzonego arkusza.
  final PostArkuszResponseData response;

  @override
  List<Object?> get props => [response];
}
