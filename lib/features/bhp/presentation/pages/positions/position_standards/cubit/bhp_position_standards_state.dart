import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Typ akcji wykonywanej na standardzie stanowiska BHP.
enum BhpPositionStandardAction {
  /// Dodawanie nowej pozycji standardu.
  creating,

  /// Edycja istniejącej pozycji standardu.
  updating,

  /// Archiwizacja pozycji standardu.
  archiving,

  /// Przywracanie zarchiwizowanej pozycji standardu.
  unarchiving,

  /// Usuwanie nieaktywnej pozycji standardu.
  deleting,
}

/// Filtr listy standardu stanowiska BHP.
enum BhpPositionStandardsFilter {
  /// Pokazuje wszystkie pozycje standardu.
  wszystkie,

  /// Pokazuje tylko aktywne pozycje standardu.
  aktywne,

  /// Pokazuje tylko nieaktywne pozycje standardu.
  nieaktywne,
}

/// Bazowy stan managera standardu stanowiska BHP.
sealed class BhpPositionStandardsState extends Equatable {
  /// Tworzy bazowy stan managera standardu stanowiska.
  const BhpPositionStandardsState();

  @override
  List<Object?> get props => const [];
}

/// Stan ładowania managera standardu stanowiska BHP.
final class BhpPositionStandardsLoading extends BhpPositionStandardsState {
  /// Tworzy stan ładowania managera standardu stanowiska.
  const BhpPositionStandardsLoading();
}

/// Stan błędu managera standardu stanowiska BHP.
final class BhpPositionStandardsError extends BhpPositionStandardsState {
  /// Tworzy stan błędu managera standardu stanowiska.
  const BhpPositionStandardsError({required this.message});

  /// Komunikat błędu widoczny w UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowości managera standardu stanowiska BHP.
final class BhpPositionStandardsReady extends BhpPositionStandardsState {
  /// Tworzy stan gotowości managera standardu stanowiska.
  const BhpPositionStandardsReady({
    required this.position,
    required this.standards,
    required this.equipment,
    this.filter = BhpPositionStandardsFilter.wszystkie,
    this.activeAction,
    this.activeStandardId,
    this.actionError,
  });

  /// Edytowane stanowisko.
  final GetBhpPositionListItem position;

  /// Lista pozycji standardu stanowiska.
  final List<GetBhpUserStandardItem> standards;

  /// Lista aktywnych kart wyposażenia do wyboru.
  final List<GetBhpEquipmentListItem> equipment;

  /// Aktualny filtr listy standardu.
  final BhpPositionStandardsFilter filter;

  /// Akcja wykonywana aktualnie na standardzie.
  final BhpPositionStandardAction? activeAction;

  /// Id pozycji standardu powiązane z akcją.
  final int? activeStandardId;

  /// Ostatni błąd akcji wykonywanej na standardzie.
  final String? actionError;

  /// Czy trwa dowolna akcja zapisu.
  bool get isSubmitting => activeAction != null;

  /// Lista pozycji standardu po przefiltrowaniu.
  List<GetBhpUserStandardItem> get filteredStandards => switch (filter) {
    BhpPositionStandardsFilter.wszystkie => standards,
    BhpPositionStandardsFilter.aktywne =>
      standards.where((item) => item.aktywny).toList(growable: false),
    BhpPositionStandardsFilter.nieaktywne =>
      standards.where((item) => !item.aktywny).toList(growable: false),
  };

  /// Kopiuje stan z możliwością nadpisania wskazanych pól.
  BhpPositionStandardsReady copyWith({
    GetBhpPositionListItem? position,
    List<GetBhpUserStandardItem>? standards,
    List<GetBhpEquipmentListItem>? equipment,
    BhpPositionStandardsFilter? filter,
    BhpPositionStandardAction? activeAction,
    int? activeStandardId,
    String? actionError,
    bool clearAction = false,
    bool clearActionError = false,
  }) {
    return BhpPositionStandardsReady(
      position: position ?? this.position,
      standards: standards ?? this.standards,
      equipment: equipment ?? this.equipment,
      filter: filter ?? this.filter,
      activeAction: clearAction ? null : activeAction ?? this.activeAction,
      activeStandardId: clearAction
          ? null
          : activeStandardId ?? this.activeStandardId,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [
    position,
    standards,
    equipment,
    filter,
    activeAction,
    activeStandardId,
    actionError,
  ];
}
