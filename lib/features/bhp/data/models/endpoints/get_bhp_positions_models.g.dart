// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_bhp_positions_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBhpPositionListItem _$GetBhpPositionListItemFromJson(
  Map<String, dynamic> json,
) => GetBhpPositionListItem(
  id: (json['id'] as num).toInt(),
  nazwa: json['nazwa'] as String,
  aktywny: json['aktywny'] as bool,
  uwagi: json['uwagi'] as String?,
  pracownicyCount: (json['pracownicy_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$GetBhpPositionListItemToJson(
  GetBhpPositionListItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'nazwa': instance.nazwa,
  'uwagi': instance.uwagi,
  'aktywny': instance.aktywny,
  'pracownicy_count': instance.pracownicyCount,
};
