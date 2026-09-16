// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_arkusz_element_nrewid_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateArkuszElementByNrewidRequest _$CreateArkuszElementByNrewidRequestFromJson(
  Map<String, dynamic> json,
) => CreateArkuszElementByNrewidRequest(nrewid: json['nrewid'] as String);

Map<String, dynamic> _$CreateArkuszElementByNrewidRequestToJson(
  CreateArkuszElementByNrewidRequest instance,
) => <String, dynamic>{'nrewid': instance.nrewid};

CreateArkuszElementByNrewidResponseData
_$CreateArkuszElementByNrewidResponseDataFromJson(Map<String, dynamic> json) =>
    CreateArkuszElementByNrewidResponseData(
      id: (json['id'] as num).toInt(),
      success: json['success'] as bool? ?? true,
    );

Map<String, dynamic> _$CreateArkuszElementByNrewidResponseDataToJson(
  CreateArkuszElementByNrewidResponseData instance,
) => <String, dynamic>{'id': instance.id, 'success': instance.success};
