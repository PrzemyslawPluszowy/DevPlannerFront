// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiErrorResponse _$ApiErrorResponseFromJson(Map<String, dynamic> json) =>
    _ApiErrorResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      fields: (json['fields'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
      traceId: json['traceId'] as String,
    );

Map<String, dynamic> _$ApiErrorResponseToJson(_ApiErrorResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'fields': instance.fields,
      'traceId': instance.traceId,
    };
