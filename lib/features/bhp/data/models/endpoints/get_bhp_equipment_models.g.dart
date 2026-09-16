// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_equipment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpEquipmentListItem _$GetBhpEquipmentListItemFromJson(
  Map<String, dynamic> json,
) => GetBhpEquipmentListItem(
  id: (json['id'] as num).toInt(),
  symbol: json['symbol'] as String,
  nazwa: json['nazwa'] as String,
  aktywny: json['aktywny'] as bool,
  procentPrzydatnosci: (json['procent_przydatnosci'] as num?)?.toInt(),
  okresUzywalnosci: json['okres_uzywalnosci'] as String?,
  jm: json['jm'] as String?,
  iloscDomyslna: json['ilosc_domyslna'] as String?,
  ekwiwalent: json['ekwiwalent'] as String?,
  cena: json['cena'] as String?,
);

Map<String, dynamic> _$GetBhpEquipmentListItemToJson(
  GetBhpEquipmentListItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'nazwa': instance.nazwa,
  'procent_przydatnosci': instance.procentPrzydatnosci,
  'okres_uzywalnosci': instance.okresUzywalnosci,
  'jm': instance.jm,
  'ilosc_domyslna': instance.iloscDomyslna,
  'ekwiwalent': instance.ekwiwalent,
  'cena': instance.cena,
  'aktywny': instance.aktywny,
};

GetBhpEquipmentDetails _$GetBhpEquipmentDetailsFromJson(
  Map<String, dynamic> json,
) => GetBhpEquipmentDetails(
  id: (json['id'] as num).toInt(),
  symbol: json['symbol'] as String,
  nazwa: json['nazwa'] as String,
  aktywny: json['aktywny'] as bool,
  procentPrzydatnosci: (json['procent_przydatnosci'] as num?)?.toInt(),
  okresUzywalnosci: json['okres_uzywalnosci'] as String?,
  jm: json['jm'] as String?,
  nrDowoduWydania: json['nr_dowodu_wydania'] as String?,
  iloscDomyslna: json['ilosc_domyslna'] as String?,
  ekwiwalent: json['ekwiwalent'] as String?,
  cena: json['cena'] as String?,
  legacyStatus: (json['legacy_status'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$GetBhpEquipmentDetailsToJson(
  GetBhpEquipmentDetails instance,
) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'nazwa': instance.nazwa,
  'procent_przydatnosci': instance.procentPrzydatnosci,
  'okres_uzywalnosci': instance.okresUzywalnosci,
  'jm': instance.jm,
  'nr_dowodu_wydania': instance.nrDowoduWydania,
  'ilosc_domyslna': instance.iloscDomyslna,
  'ekwiwalent': instance.ekwiwalent,
  'cena': instance.cena,
  'aktywny': instance.aktywny,
  'legacy_status': instance.legacyStatus,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

GetBhpEquipmentActivationImpact _$GetBhpEquipmentActivationImpactFromJson(
  Map<String, dynamic> json,
) => GetBhpEquipmentActivationImpact(
  equipment: GetBhpEquipmentActivationImpactEquipment.fromJson(
    json['equipment'] as Map<String, dynamic>,
  ),
  activeStandardsCount: (json['active_standards_count'] as num).toInt(),
  inactiveStandardsCount: (json['inactive_standards_count'] as num).toInt(),
  standards: (json['standards'] as List<dynamic>)
      .map(
        (e) => GetBhpEquipmentActivationImpactStandard.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$GetBhpEquipmentActivationImpactToJson(
  GetBhpEquipmentActivationImpact instance,
) => <String, dynamic>{
  'equipment': instance.equipment,
  'active_standards_count': instance.activeStandardsCount,
  'inactive_standards_count': instance.inactiveStandardsCount,
  'standards': instance.standards,
};

GetBhpEquipmentActivationImpactEquipment
_$GetBhpEquipmentActivationImpactEquipmentFromJson(Map<String, dynamic> json) =>
    GetBhpEquipmentActivationImpactEquipment(
      id: (json['id'] as num).toInt(),
      symbol: json['symbol'] as String,
      nazwa: json['nazwa'] as String,
      aktywny: json['aktywny'] as bool,
    );

Map<String, dynamic> _$GetBhpEquipmentActivationImpactEquipmentToJson(
  GetBhpEquipmentActivationImpactEquipment instance,
) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'nazwa': instance.nazwa,
  'aktywny': instance.aktywny,
};

GetBhpEquipmentActivationImpactStandard
_$GetBhpEquipmentActivationImpactStandardFromJson(Map<String, dynamic> json) =>
    GetBhpEquipmentActivationImpactStandard(
      id: (json['id'] as num).toInt(),
      aktywny: json['aktywny'] as bool,
      positionActive: json['position_active'] as bool,
      okres: (json['okres'] as num?)?.toInt(),
      ilosc: json['ilosc'] as String?,
      uwagi: json['uwagi'] as String?,
      positionId: (json['position_id'] as num?)?.toInt(),
      positionName: json['position_name'] as String?,
    );

Map<String, dynamic> _$GetBhpEquipmentActivationImpactStandardToJson(
  GetBhpEquipmentActivationImpactStandard instance,
) => <String, dynamic>{
  'id': instance.id,
  'aktywny': instance.aktywny,
  'okres': instance.okres,
  'ilosc': instance.ilosc,
  'uwagi': instance.uwagi,
  'position_id': instance.positionId,
  'position_name': instance.positionName,
  'position_active': instance.positionActive,
};
