// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_bhp_position_standard_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchBhpPositionStandardRequest _$PatchBhpPositionStandardRequestFromJson(
  Map<String, dynamic> json,
) => PatchBhpPositionStandardRequest(
  okres: (json['okres'] as num?)?.toInt(),
  ilosc: json['ilosc'] as String?,
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$PatchBhpPositionStandardRequestToJson(
  PatchBhpPositionStandardRequest instance,
) => <String, dynamic>{
  'okres': instance.okres,
  'ilosc': instance.ilosc,
  'uwagi': instance.uwagi,
};
