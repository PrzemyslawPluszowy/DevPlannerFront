import 'package:json_annotation/json_annotation.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/bhp_employee_name.dart';

part 'get_bhp_missing_equipment_models.g.dart';

/// Dane odpowiedzi dla `GET /api/v1/bhp/dashboard/missing-equipment`.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpMissingEquipmentResponseData {
  /// Tworzy odpowiedź listy braków wyposażenia BHP.
  const GetBhpMissingEquipmentResponseData({
    required this.generatedAt,
    required this.usersCount,
    required this.missingItemsCount,
    required this.distinctCardsCount,
    required this.topMissingCardLabel,
    required this.topMissingCardCount,
    required this.items,
  });

  /// Tworzy odpowiedź z JSON.
  factory GetBhpMissingEquipmentResponseData.fromJson(
    Map<String, dynamic> json,
  ) => _$GetBhpMissingEquipmentResponseDataFromJson(json);

  /// Czas wygenerowania danych.
  final String generatedAt;

  /// Liczba pracowników z co najmniej jednym brakiem.
  final int usersCount;

  /// Łączna liczba brakujących pozycji standardu.
  final int missingItemsCount;

  /// Liczba różnych kart, które występują w brakach.
  final int distinctCardsCount;

  /// Najczęściej brakujący element.
  final String? topMissingCardLabel;

  /// Ile razy najczęstszy brak wystąpił w zestawieniu.
  final int topMissingCardCount;

  /// Szczegółowe rekordy braków.
  final List<GetBhpMissingEquipmentItem> items;

  /// Serializuje odpowiedź do JSON.
  Map<String, dynamic> toJson() =>
      _$GetBhpMissingEquipmentResponseDataToJson(this);
}

/// Pojedynczy rekord brakującej pozycji standardu.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpMissingEquipmentItem {
  /// Tworzy rekord brakującego wyposażenia.
  const GetBhpMissingEquipmentItem({
    required this.id,
    required this.userId,
    required this.userFullName,
    required this.standardId,
    required this.kartaWyposazeniaId,
    required this.details,
    this.stanowiskoId,
    this.stanowiskoNazwa,
    this.kartaWyposazeniaSymbol,
    this.kartaWyposazeniaNazwa,
    this.standardQuantity,
    this.latestIssueClosedAt,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpMissingEquipmentItem.fromJson(Map<String, dynamic> json) =>
      _$GetBhpMissingEquipmentItemFromJson(json);

  /// Stabilny identyfikator rekordu.
  final String id;

  /// Id pracownika.
  final int userId;

  /// Imię i nazwisko pracownika.
  final String userFullName;

  /// Nazwisko i imię pracownika do wyświetlenia w UI.
  String get formattedUserFullName =>
      formatBhpEmployeeNameLastFirst(userFullName);

  /// Id stanowiska.
  final int? stanowiskoId;

  /// Nazwa stanowiska.
  final String? stanowiskoNazwa;

  /// Id pozycji standardu.
  final int standardId;

  /// Id karty wyposażenia.
  final int kartaWyposazeniaId;

  /// Symbol karty wyposażenia.
  final String? kartaWyposazeniaSymbol;

  /// Nazwa karty wyposażenia.
  final String? kartaWyposazeniaNazwa;

  /// Ilość wpisana na pozycji standardu.
  final String? standardQuantity;

  /// Data ostatniego zamkniętego wydania dla tej karty, jeśli istniało.
  final String? latestIssueClosedAt;

  /// Czytelny opis rekordu.
  final String details;

  /// Buduje czytelną etykietę wyposażenia.
  String get equipmentLabel {
    final symbol = kartaWyposazeniaSymbol?.trim();
    final name = kartaWyposazeniaNazwa?.trim();

    if ((symbol ?? '').isNotEmpty && (name ?? '').isNotEmpty) {
      return '$symbol - $name';
    }

    return symbol?.isNotEmpty == true ? symbol! : (name ?? '—');
  }

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpMissingEquipmentItemToJson(this);
}
