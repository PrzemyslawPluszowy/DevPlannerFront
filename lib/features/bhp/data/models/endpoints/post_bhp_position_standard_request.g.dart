// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bhp_position_standard_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostBhpPositionStandardRequest _$PostBhpPositionStandardRequestFromJson(
  Map<String, dynamic> json,
) => PostBhpPositionStandardRequest(
  kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num).toInt(),
  okres: (json['okres'] as num?)?.toInt(),
  ilosc: json['ilosc'] as String?,
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$PostBhpPositionStandardRequestToJson(
  PostBhpPositionStandardRequest instance,
) => <String, dynamic>{
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'okres': instance.okres,
  'ilosc': instance.ilosc,
  'uwagi': instance.uwagi,
};
