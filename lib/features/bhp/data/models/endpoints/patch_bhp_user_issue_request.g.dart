// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_bhp_user_issue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchBhpUserIssueRequest _$PatchBhpUserIssueRequestFromJson(
  Map<String, dynamic> json,
) => PatchBhpUserIssueRequest(
  kartaWyposazeniaId: (json['karta_wyposazenia_id'] as num).toInt(),
  dataPrzydzialu: json['data_przydzialu'] as String,
  dataZakonczenia: json['data_zakonczenia'] as String?,
  ilosc: json['ilosc'] as String,
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$PatchBhpUserIssueRequestToJson(
  PatchBhpUserIssueRequest instance,
) => <String, dynamic>{
  'karta_wyposazenia_id': instance.kartaWyposazeniaId,
  'data_przydzialu': instance.dataPrzydzialu,
  'data_zakonczenia': instance.dataZakonczenia,
  'ilosc': instance.ilosc,
  'uwagi': instance.uwagi,
};
