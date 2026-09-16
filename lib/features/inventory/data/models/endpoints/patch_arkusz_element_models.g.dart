// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_arkusz_element_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchArkuszElementQuery _$PatchArkuszElementQueryFromJson(
  Map<String, dynamic> json,
) => PatchArkuszElementQuery(
  stanInwent: _arkuszElementInwentStatusFromJson(json['stan_inwent']),
  statusSpisu: const ArkuszElementStatusSpisuConverter().fromJson(
    json['status_spisu'] as String?,
  ),
  likwidacja: _boolFromJson(json['likwidacja']),
  nadwyzka: _boolFromJson(json['nadwyzka']),
  nrewid: json['nrewid'] as String?,
  nowyKodKreskowy: json['nowy_kod_kreskowy'] as String?,
  nowaOsoba: json['nowa_osoba'] as String?,
  nowaNazwa: json['nowa_nazwa'] as String?,
  uwagiLoc: json['uwagi_loc'] as String?,
  kkWczytany: _boolFromJson(json['kk_wczytany']),
  nadwIdmiejsce: (json['nadw_idmiejsce'] as num?)?.toInt(),
  nadwIdFirmy: (json['nadw_id_firmy'] as num?)?.toInt(),
);

Map<String, dynamic> _$PatchArkuszElementQueryToJson(
  PatchArkuszElementQuery instance,
) => <String, dynamic>{
  'stan_inwent': _arkuszElementInwentStatusToJson(instance.stanInwent),
  'status_spisu': const ArkuszElementStatusSpisuConverter().toJson(
    instance.statusSpisu,
  ),
  'likwidacja': _boolToJson(instance.likwidacja),
  'nadwyzka': _boolToJson(instance.nadwyzka),
  'nrewid': instance.nrewid,
  'nowy_kod_kreskowy': instance.nowyKodKreskowy,
  'nowa_osoba': instance.nowaOsoba,
  'nowa_nazwa': instance.nowaNazwa,
  'uwagi_loc': instance.uwagiLoc,
  'kk_wczytany': _boolToJson(instance.kkWczytany),
  'nadw_idmiejsce': instance.nadwIdmiejsce,
  'nadw_id_firmy': instance.nadwIdFirmy,
};

PatchArkuszElementResponseData _$PatchArkuszElementResponseDataFromJson(
  Map<String, dynamic> json,
) => PatchArkuszElementResponseData(
  elementId: (json['element_id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$PatchArkuszElementResponseDataToJson(
  PatchArkuszElementResponseData instance,
) => <String, dynamic>{
  'success': instance.success,
  'element_id': instance.elementId,
};
