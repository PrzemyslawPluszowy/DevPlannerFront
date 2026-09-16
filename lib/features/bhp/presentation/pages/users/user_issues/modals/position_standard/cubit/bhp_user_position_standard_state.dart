import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan flow stanowiska i standardu pracownika BHP.
sealed class BhpUserPositionStandardState extends Equatable {
  /// Tworzy bazowy stan flow stanowiska.
  const BhpUserPositionStandardState();

  @override
  List<Object?> get props => const [];
}

/// Stan ładowania danych stanowiska i standardu.
final class BhpUserPositionStandardLoading
    extends BhpUserPositionStandardState {
  /// Tworzy stan ładowania.
  const BhpUserPositionStandardLoading();
}

/// Stan błędu ładowania danych stanowiska i standardu.
final class BhpUserPositionStandardError extends BhpUserPositionStandardState {
  /// Tworzy stan błędu.
  const BhpUserPositionStandardError({required this.message});

  /// Komunikat błędu dla UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowości widoku stanowiska i standardu.
final class BhpUserPositionStandardReady extends BhpUserPositionStandardState {
  /// Tworzy stan gotowości.
  const BhpUserPositionStandardReady({
    required this.detail,
    required this.positions,
    required this.standards,
    required this.selectedPositionId,
    required this.isLoadingStandards,
    required this.isSaving,
    this.standardsError,
  });

  /// Szczegóły pracownika.
  final GetBhpUserDetail detail;

  /// Lista dostępnych stanowisk.
  final List<GetBhpPositionListItem> positions;

  /// Standard przypisany do aktualnie wybranego stanowiska.
  final List<GetBhpUserStandardItem> standards;

  /// Id aktualnie wybranego stanowiska.
  final int? selectedPositionId;

  /// Czy trwa przeładowanie standardu.
  final bool isLoadingStandards;

  /// Czy trwa zapis zmiany stanowiska.
  final bool isSaving;

  /// Komunikat błędu ładowania standardu dla wybranego stanowiska.
  final String? standardsError;

  /// Informuje, czy zapis jest możliwy.
  bool get canSave =>
      selectedPositionId != null && !isSaving && !isLoadingStandards;

  /// Zwraca aktualnie wybrane stanowisko lub placeholder techniczny.
  GetBhpPositionListItem get selectedPosition => positions.firstWhere(
    (item) => item.id == selectedPositionId,
    orElse: () => positions.isEmpty
        ? const GetBhpPositionListItem(
            id: 0,
            nazwa: 'Brak stanowisk',
            aktywny: false,
          )
        : positions.first,
  );

  /// Tworzy kopię stanu z podmienionymi polami.
  BhpUserPositionStandardReady copyWith({
    GetBhpUserDetail? detail,
    List<GetBhpPositionListItem>? positions,
    List<GetBhpUserStandardItem>? standards,
    int? selectedPositionId,
    bool clearSelectedPositionId = false,
    bool? isLoadingStandards,
    bool? isSaving,
    String? standardsError,
    bool clearStandardsError = false,
  }) {
    return BhpUserPositionStandardReady(
      detail: detail ?? this.detail,
      positions: positions ?? this.positions,
      standards: standards ?? this.standards,
      selectedPositionId: clearSelectedPositionId
          ? null
          : selectedPositionId ?? this.selectedPositionId,
      isLoadingStandards: isLoadingStandards ?? this.isLoadingStandards,
      isSaving: isSaving ?? this.isSaving,
      standardsError: clearStandardsError
          ? null
          : standardsError ?? this.standardsError,
    );
  }

  @override
  List<Object?> get props => [
    detail,
    positions,
    standards,
    selectedPositionId,
    isLoadingStandards,
    isSaving,
    standardsError,
  ];
}
