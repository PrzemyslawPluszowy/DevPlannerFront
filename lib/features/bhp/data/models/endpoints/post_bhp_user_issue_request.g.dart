// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bhp_user_issue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostBhpUserIssueRequest _$PostBhpUserIssueRequestFromJson(
  Map<String, dynamic> json,
) => PostBhpUserIssueRequest(
  kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num).toInt(),
  dataPrzydzialu: json['data_przydzialu'] as String,
  ilosc: json['ilosc'] as String,
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$PostBhpUserIssueRequestToJson(
  PostBhpUserIssueRequest instance,
) => <String, dynamic>{
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'data_przydzialu': instance.dataPrzydzialu,
  'ilosc': instance.ilosc,
  'uwagi': instance.uwagi,
};
