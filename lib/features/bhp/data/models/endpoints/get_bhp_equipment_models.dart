import 'package:json_annotation/json_annotation.dart';

part 'get_bhp_equipment_models.g.dart';

/// Rekord katalogu wyposażenia BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpEquipmentListItem {
  /// Tworzy rekord wyposażenia BHP.
  const GetBhpEquipmentListItem({
    required this.id,
    required this.symbol,
    required this.nazwa,
    required this.aktywny,
    this.procentPrzydatnosci,
    this.okresUzywalnosci,
    this.jm,
    this.iloscDomyslna,
    this.ekwiwalent,
    this.cena,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpEquipmentListItem.fromJson(Map<String, dynamic> json) =>
      _$GetBhpEquipmentListItemFromJson(json);

  /// Id pozycji wyposażenia.
  final int id;

  /// Symbol pozycji.
  final String symbol;

  /// Nazwa pozycji.
  final String nazwa;

  /// Procent przydatności.
  final int? procentPrzydatnosci;

  /// Okres użytkowania.
  final String? okresUzywalnosci;

  /// Jednostka miary.
  final String? jm;

  /// Ilość domyślna.
  final String? iloscDomyslna;

  /// Wartość ekwiwalentu.
  final String? ekwiwalent;

  /// Cena.
  final String? cena;

  /// Flaga aktywności.
  final bool aktywny;

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpEquipmentListItemToJson(this);
}

/// Szczegóły karty wyposażenia BHP.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpEquipmentDetails {
  /// Tworzy szczegóły karty wyposażenia BHP.
  const GetBhpEquipmentDetails({
    required this.id,
    required this.symbol,
    required this.nazwa,
    required this.aktywny,
    this.procentPrzydatnosci,
    this.okresUzywalnosci,
    this.jm,
    this.nrDowoduWydania,
    this.iloscDomyslna,
    this.ekwiwalent,
    this.cena,
    this.legacyStatus,
    this.createdAt,
    this.updatedAt,
  });

  /// Tworzy rekord z JSON.
  factory GetBhpEquipmentDetails.fromJson(Map<String, dynamic> json) =>
      _$GetBhpEquipmentDetailsFromJson(json);

  /// Id pozycji wyposażenia.
  final int id;

  /// Symbol pozycji.
  final String symbol;

  /// Nazwa pozycji.
  final String nazwa;

  /// Procent przydatności.
  final int? procentPrzydatnosci;

  /// Okres użytkowania.
  final String? okresUzywalnosci;

  /// Jednostka miary.
  final String? jm;

  /// Numer dowodu wydania.
  final String? nrDowoduWydania;

  /// Ilość domyślna.
  final String? iloscDomyslna;

  /// Kwota ekwiwalentu dla karty.
  final String? ekwiwalent;

  /// Cena jednostkowa.
  final String? cena;

  /// Flaga aktywności.
  final bool aktywny;

  /// Legacy status z importu Access.
  final int? legacyStatus;

  /// Data utworzenia rekordu.
  final String? createdAt;

  /// Data ostatniej aktualizacji rekordu.
  final String? updatedAt;

  /// Serializuje rekord do JSON.
  Map<String, dynamic> toJson() => _$GetBhpEquipmentDetailsToJson(this);
}

/// Wpływ zmiany statusu karty wyposażenia na przypisania stanowisk.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpEquipmentActivationImpact {
  /// Tworzy model wpływu zmiany statusu karty wyposażenia.
  const GetBhpEquipmentActivationImpact({
    required this.equipment,
    required this.activeStandardsCount,
    required this.inactiveStandardsCount,
    required this.standards,
  });

  /// Tworzy model z JSON.
  factory GetBhpEquipmentActivationImpact.fromJson(
    Map<String, dynamic> json,
  ) => _$GetBhpEquipmentActivationImpactFromJson(json);

  /// Karta wyposażenia, której dotyczy operacja.
  final GetBhpEquipmentActivationImpactEquipment equipment;

  /// Liczba aktywnych przypisań standardów.
  final int activeStandardsCount;

  /// Liczba nieaktywnych przypisań standardów.
  final int inactiveStandardsCount;

  /// Lista przypisań standardów do stanowisk.
  final List<GetBhpEquipmentActivationImpactStandard> standards;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() =>
      _$GetBhpEquipmentActivationImpactToJson(this);
}

/// Skrócone dane karty wyposażenia dla preview wpływu.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpEquipmentActivationImpactEquipment {
  /// Tworzy dane karty wyposażenia dla preview wpływu.
  const GetBhpEquipmentActivationImpactEquipment({
    required this.id,
    required this.symbol,
    required this.nazwa,
    required this.aktywny,
  });

  /// Tworzy model z JSON.
  factory GetBhpEquipmentActivationImpactEquipment.fromJson(
    Map<String, dynamic> json,
  ) => _$GetBhpEquipmentActivationImpactEquipmentFromJson(json);

  /// Id karty wyposażenia.
  final int id;

  /// Symbol karty wyposażenia.
  final String symbol;

  /// Nazwa karty wyposażenia.
  final String nazwa;

  /// Flaga aktywności karty.
  final bool aktywny;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() =>
      _$GetBhpEquipmentActivationImpactEquipmentToJson(this);
}

/// Pojedyncze przypisanie standardu stanowiska dla preview wpływu.
@JsonSerializable(fieldRename: FieldRename.snake)
class GetBhpEquipmentActivationImpactStandard {
  /// Tworzy rekord przypisania standardu.
  const GetBhpEquipmentActivationImpactStandard({
    required this.id,
    required this.aktywny,
    required this.positionActive,
    this.okres,
    this.ilosc,
    this.uwagi,
    this.positionId,
    this.positionName,
  });

  /// Tworzy model z JSON.
  factory GetBhpEquipmentActivationImpactStandard.fromJson(
    Map<String, dynamic> json,
  ) => _$GetBhpEquipmentActivationImpactStandardFromJson(json);

  /// Id pozycji standardu stanowiska.
  final int id;

  /// Flaga aktywności przypisania standardu.
  final bool aktywny;

  /// Nadpisany okres wymiany na standardzie.
  final int? okres;

  /// Ilość przypisana w standardzie.
  final String? ilosc;

  /// Uwagi standardu.
  final String? uwagi;

  /// Id stanowiska.
  final int? positionId;

  /// Nazwa stanowiska.
  final String? positionName;

  /// Flaga aktywności stanowiska.
  final bool positionActive;

  /// Serializuje model do JSON.
  Map<String, dynamic> toJson() =>
      _$GetBhpEquipmentActivationImpactStandardToJson(this);
}
