// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'put_komisja_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateKomisjaRequest _$UpdateKomisjaRequestFromJson(
  Map<String, dynamic> json,
) => UpdateKomisjaRequest(
  komisja: (json['komisja'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$UpdateKomisjaRequestToJson(
  UpdateKomisjaRequest instance,
) => <String, dynamic>{'komisja': instance.komisja};

KomisjaUpdateData _$KomisjaUpdateDataFromJson(Map<String, dynamic> json) =>
    KomisjaUpdateData(
      id: (json['id'] as num).toInt(),
      komisjaCount: (json['komisja_count'] as num).toInt(),
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$KomisjaUpdateDataToJson(KomisjaUpdateData instance) =>
    <String, dynamic>{
      'success': instance.success,
      'id': instance.id,
      'komisja_count': instance.komisjaCount,
    };
