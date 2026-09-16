// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_arkusz_elementy_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostArkuszElementyQuery _$PostArkuszElementyQueryFromJson(
  Map<String, dynamic> json,
) => PostArkuszElementyQuery(
  kodKreskowy: (json['kod_kreskowy'] as num).toInt(),
  dataZakupu: json['data_zakupu'] as String?,
  nazwa: json['nazwa'] as String?,
  nrewid: json['nrewid'] as String?,
  osoba: json['osoba'] as String?,
);

Map<String, dynamic> _$PostArkuszElementyQueryToJson(
  PostArkuszElementyQuery instance,
) => <String, dynamic>{
  'kod_kreskowy': instance.kodKreskowy,
  'data_zakupu': instance.dataZakupu,
  'nazwa': instance.nazwa,
  'nrewid': instance.nrewid,
  'osoba': instance.osoba,
};

PostArkuszElementyResponseData _$PostArkuszElementyResponseDataFromJson(
  Map<String, dynamic> json,
) => PostArkuszElementyResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool?,
  nadwyzka: _boolFromJson(json['nadwyzka']),
);

Map<String, dynamic> _$PostArkuszElementyResponseDataToJson(
  PostArkuszElementyResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'success': instance.success,
  'nadwyzka': _boolToJson(instance.nadwyzka),
};
