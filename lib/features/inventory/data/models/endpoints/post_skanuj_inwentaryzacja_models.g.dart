// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_skanuj_inwentaryzacja_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkanujInwentaryzacjaRequest _$SkanujInwentaryzacjaRequestFromJson(
  Map<String, dynamic> json,
) => SkanujInwentaryzacjaRequest(
  kodKreskowy: (json['kod_kreskowy'] as num).toInt(),
  arkuszId: (json['arkusz_id'] as num).toInt(),
);

Map<String, dynamic> _$SkanujInwentaryzacjaRequestToJson(
  SkanujInwentaryzacjaRequest instance,
) => <String, dynamic>{
  'kod_kreskowy': instance.kodKreskowy,
  'arkusz_id': instance.arkuszId,
};

SkanujInwentaryzacjaResponseData _$SkanujInwentaryzacjaResponseDataFromJson(
  Map<String, dynamic> json,
) => SkanujInwentaryzacjaResponseData(
  status: json['status'] as String,
  element: json['element'] == null
      ? null
      : GetArkuszDetailsElementItem.fromJson(
          json['element'] as Map<String, dynamic>,
        ),
  arkuszId: (json['arkusz_id'] as num?)?.toInt(),
  kodKreskowy: (json['kod_kreskowy'] as num?)?.toInt(),
  nazwa: json['nazwa'] as String?,
  nrewid: json['nrewid'] as String?,
  miejsceEwidencja: json['miejsce_ewidencja'] as String?,
  firma: (json['firma'] as num?)?.toInt(),
  firmaNazwa: json['firma_nazwa'] as String?,
  requiresConfirmation: json['requires_confirmation'] as bool?,
);

Map<String, dynamic> _$SkanujInwentaryzacjaResponseDataToJson(
  SkanujInwentaryzacjaResponseData instance,
) => <String, dynamic>{
  'status': instance.status,
  'element': instance.element,
  'arkusz_id': instance.arkuszId,
  'kod_kreskowy': instance.kodKreskowy,
  'nazwa': instance.nazwa,
  'nrewid': instance.nrewid,
  'miejsce_ewidencja': instance.miejsceEwidencja,
  'firma': instance.firma,
  'firma_nazwa': instance.firmaNazwa,
  'requires_confirmation': instance.requiresConfirmation,
};
