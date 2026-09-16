// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_zamknij_inwentaryzacje_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZamknijInwentaryzacjeRequest _$ZamknijInwentaryzacjeRequestFromJson(
  Map<String, dynamic> json,
) => ZamknijInwentaryzacjeRequest(dataDo: json['data_do'] as String);

Map<String, dynamic> _$ZamknijInwentaryzacjeRequestToJson(
  ZamknijInwentaryzacjeRequest instance,
) => <String, dynamic>{'data_do': instance.dataDo};

ZamknijInwentaryzacjeResponseData _$ZamknijInwentaryzacjeResponseDataFromJson(
  Map<String, dynamic> json,
) => ZamknijInwentaryzacjeResponseData(
  id: (json['id'] as num).toInt(),
  success: json['success'] as bool? ?? true,
);

Map<String, dynamic> _$ZamknijInwentaryzacjeResponseDataToJson(
  ZamknijInwentaryzacjeResponseData instance,
) => <String, dynamic>{'id': instance.id, 'success': instance.success};
