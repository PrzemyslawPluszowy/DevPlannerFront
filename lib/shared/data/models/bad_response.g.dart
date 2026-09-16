// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bad_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BadResponse _$BadResponseFromJson(Map<String, dynamic> json) => BadResponse(
  error: json['error'] == null
      ? null
      : BadResponseError.fromJson(json['error'] as Map<String, dynamic>),
  detail: (json['detail'] as List<dynamic>?)
      ?.map(
        (e) => BadResponseValidationError.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$BadResponseToJson(BadResponse instance) =>
    <String, dynamic>{'error': instance.error, 'detail': instance.detail};

BadResponseError _$BadResponseErrorFromJson(Map<String, dynamic> json) =>
    BadResponseError(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$BadResponseErrorToJson(BadResponseError instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};

BadResponseValidationError _$BadResponseValidationErrorFromJson(
  Map<String, dynamic> json,
) => BadResponseValidationError(
  loc: json['loc'] as List<dynamic>,
  msg: json['msg'] as String,
  type: json['type'] as String,
  input: json['input'],
  ctx: json['ctx'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$BadResponseValidationErrorToJson(
  BadResponseValidationError instance,
) => <String, dynamic>{
  'loc': instance.loc,
  'msg': instance.msg,
  'type': instance.type,
  'input': instance.input,
  'ctx': instance.ctx,
};
