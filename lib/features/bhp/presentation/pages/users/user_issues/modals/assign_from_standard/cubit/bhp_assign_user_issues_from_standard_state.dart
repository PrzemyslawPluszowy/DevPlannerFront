import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan flow dopisywania wydań ze standardu stanowiska.
sealed class BhpAssignUserIssuesFromStandardState extends Equatable {
  /// Tworzy bazowy stan flow dopisywania wydań.
  const BhpAssignUserIssuesFromStandardState();

  @override
  List<Object?> get props => const [];
}

/// Stan ładowania danych standardu stanowiska.
final class BhpAssignUserIssuesFromStandardLoading
    extends BhpAssignUserIssuesFromStandardState {
  /// Tworzy stan ładowania danych standardu.
  const BhpAssignUserIssuesFromStandardLoading();
}

/// Stan błędu ładowania danych standardu stanowiska.
final class BhpAssignUserIssuesFromStandardError
    extends BhpAssignUserIssuesFromStandardState {
  /// Tworzy stan błędu.
  const BhpAssignUserIssuesFromStandardError({required this.message});

  /// Komunikat błędu dla UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowości flow dopisywania wydań ze standardu.
final class BhpAssignUserIssuesFromStandardReady
    extends BhpAssignUserIssuesFromStandardState {
  /// Tworzy stan gotowości dopisywania wydań.
  const BhpAssignUserIssuesFromStandardReady({
    required this.detail,
    required this.entries,
    required this.selectedStandardIds,
    required this.isSaving,
  });

  /// Szczegóły pracownika używane do weryfikacji możliwości dopisania.
  final GetBhpUserDetail detail;

  /// Pozycje standardu wraz z informacją o stanie.
  final List<BhpStandardIssueSelectionEntry> entries;

  /// Aktualnie zaznaczone identyfikatory standardów.
  final Set<int> selectedStandardIds;

  /// Czy trwa zapis dopisywania wydań.
  final bool isSaving;

  /// Czy pracownik może otrzymywać wydania.
  bool get canReceiveIssues => detail.canReceiveIssues;

  /// Zwraca pozycje możliwe do dopisania.
  List<BhpStandardIssueSelectionEntry> get selectableEntries =>
      entries.where((entry) => entry.isSelectable).toList(growable: false);

  /// Zwraca pozycje już aktywne.
  List<BhpStandardIssueSelectionEntry> get lockedEntries =>
      entries.where((entry) => entry.isAlreadyActive).toList(growable: false);

  /// Zwraca pozycje nieaktywne w standardzie.
  List<BhpStandardIssueSelectionEntry> get inactiveEntries => entries
      .where(
        (entry) =>
            (!entry.standard.aktywny || !entry.standard.kartaAktywna) &&
            !entry.isAlreadyActive,
      )
      .toList(growable: false);

  /// Tworzy kopię stanu z podmienionymi polami.
  BhpAssignUserIssuesFromStandardReady copyWith({
    GetBhpUserDetail? detail,
    List<BhpStandardIssueSelectionEntry>? entries,
    Set<int>? selectedStandardIds,
    bool? isSaving,
  }) {
    return BhpAssignUserIssuesFromStandardReady(
      detail: detail ?? this.detail,
      entries: entries ?? this.entries,
      selectedStandardIds: selectedStandardIds ?? this.selectedStandardIds,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [detail, entries, selectedStandardIds, isSaving];
}

/// Pojedyncza pozycja standardu z informacją o stanie wyboru.
class BhpStandardIssueSelectionEntry extends Equatable {
  /// Tworzy pozycję wyboru.
  const BhpStandardIssueSelectionEntry({
    required this.standard,
    required this.activeIssueCardIds,
  });

  /// Pozycja standardu stanowiska.
  final GetBhpUserStandardItem standard;

  /// Zestaw kart wyposażenia już aktywnych u pracownika.
  final Set<int> activeIssueCardIds;

  /// Informuje, czy pracownik ma już aktywne wydanie dla tej pozycji.
  bool get isAlreadyActive {
    final cardId = standard.kartaWyposazeniaId;
    return cardId != null && activeIssueCardIds.contains(cardId);
  }

  /// Informuje, czy pozycja może zostać dopisana.
  bool get isSelectable =>
      standard.aktywny && standard.kartaAktywna && !isAlreadyActive;

  /// Etykieta pozycji do pokazania na liście.
  String get label {
    final symbol = standard.kartaWyposazeniaSymbol?.trim();
    final name = standard.kartaWyposazeniaNazwa?.trim();

    if ((symbol ?? '').isNotEmpty && (name ?? '').isNotEmpty) {
      return '$symbol - $name';
    }

    if ((symbol ?? '').isNotEmpty) {
      return symbol!;
    }

    if ((name ?? '').isNotEmpty) {
      return name!;
    }

    final id = standard.kartaWyposazeniaId;
    return id == null ? 'Brak nazwy pozycji' : 'Pozycja #$id';
  }

  /// Dodatkowy opis pozycji standardu.
  String get subtitle {
    final parts = <String>[];

    if (standard.ilosc case final qty? when qty.trim().isNotEmpty) {
      parts.add('Ilość: ${qty.trim()}');
    }

    if (standard.kartaIloscDomyslna case final qty?
        when qty.trim().isNotEmpty) {
      parts.add('Domyślna: ${qty.trim()}');
    }

    if (!standard.aktywny) {
      parts.add('Standard nieaktywny');
    } else if (!standard.kartaAktywna) {
      parts.add('Karta wyposażenia nieaktywna');
    } else if (isAlreadyActive) {
      parts.add('Już aktywne wydanie');
    }

    return parts.join(' · ');
  }

  @override
  List<Object?> get props => [standard, activeIssueCardIds];
}
