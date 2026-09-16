import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Tryb operacji zmiany statusu karty wyposażenia.
enum BhpEquipmentActivationMode {
  /// Ustawienie karty jako nieaktywnej.
  setInactive,

  /// Ustawienie karty jako aktywnej.
  setActive,
}

/// Bazowy stan flow zmiany statusu karty wyposażenia.
sealed class BhpEquipmentActivationState extends Equatable {
  /// Tworzy bazowy stan flow zmiany statusu.
  const BhpEquipmentActivationState();

  @override
  List<Object?> get props => const [];
}

/// Stan ładowania preview wpływu zmiany statusu.
final class BhpEquipmentActivationLoading extends BhpEquipmentActivationState {
  /// Tworzy stan ładowania preview.
  const BhpEquipmentActivationLoading();
}

/// Stan błędu ładowania preview wpływu.
final class BhpEquipmentActivationError extends BhpEquipmentActivationState {
  /// Tworzy stan błędu preview wpływu.
  const BhpEquipmentActivationError({required this.message});

  /// Komunikat błędu dla UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowości flow zmiany statusu karty wyposażenia.
final class BhpEquipmentActivationReady extends BhpEquipmentActivationState {
  /// Tworzy stan gotowości flow zmiany statusu.
  const BhpEquipmentActivationReady({
    required this.mode,
    required this.impact,
    required this.selectedStandardIds,
    required this.isSubmitting,
  });

  /// Tryb bieżącej operacji.
  final BhpEquipmentActivationMode mode;

  /// Preview wpływu operacji na przypisania.
  final GetBhpEquipmentActivationImpact impact;

  /// Zaznaczone przypisania do przywrócenia.
  final Set<int> selectedStandardIds;

  /// Flaga trwającego zapisu.
  final bool isSubmitting;

  /// Aktywne przypisania standardów, które zostaną wyłączone.
  List<GetBhpEquipmentActivationImpactStandard> get affectedActiveStandards =>
      impact.standards.where((item) => item.aktywny).toList(growable: false);

  /// Nieaktywne przypisania standardów, które można opcjonalnie przywrócić.
  List<GetBhpEquipmentActivationImpactStandard> get restorableStandards =>
      impact.standards.where((item) => !item.aktywny).toList(growable: false);

  /// Tworzy kopię stanu z podmienionymi polami.
  BhpEquipmentActivationReady copyWith({
    BhpEquipmentActivationMode? mode,
    GetBhpEquipmentActivationImpact? impact,
    Set<int>? selectedStandardIds,
    bool? isSubmitting,
  }) {
    return BhpEquipmentActivationReady(
      mode: mode ?? this.mode,
      impact: impact ?? this.impact,
      selectedStandardIds: selectedStandardIds ?? this.selectedStandardIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [mode, impact, selectedStandardIds, isSubmitting];
}

/// Widok pojedynczego powiązania karty ze standardem stanowiska.
final class BhpEquipmentActivationEntry extends Equatable {
  /// Tworzy widok pojedynczego powiązania.
  const BhpEquipmentActivationEntry({required this.standard});

  /// Rekord powiązania zwrócony przez backend.
  final GetBhpEquipmentActivationImpactStandard standard;

  /// Tytuł pozycji na liście.
  String get label {
    final positionName = standard.positionName?.trim();
    if (positionName != null && positionName.isNotEmpty) {
      return positionName;
    }

    final positionId = standard.positionId;
    return positionId == null
        ? 'Nieznane stanowisko'
        : 'Stanowisko #$positionId';
  }

  /// Opis pomocniczy pozycji.
  String get subtitle {
    final parts = <String>[];

    if (standard.ilosc case final qty? when qty.trim().isNotEmpty) {
      parts.add('Ilość: ${qty.trim()}');
    }

    if (standard.okres case final period?) {
      parts.add('Okres: $period');
    }

    if (!standard.positionActive) {
      parts.add('Stanowisko nieaktywne');
    }

    if (standard.uwagi case final notes? when notes.trim().isNotEmpty) {
      parts.add(notes.trim());
    }

    return parts.join(' · ');
  }

  @override
  List<Object?> get props => [standard];
}
