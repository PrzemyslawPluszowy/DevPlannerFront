// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_close_bhp_user_issue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCloseBhpUserIssueRequest _$PostCloseBhpUserIssueRequestFromJson(
  Map<String, dynamic> json,
) => PostCloseBhpUserIssueRequest(
  dataZakonczenia: json['data_zakonczenia'] as String,
  uwagi: json['uwagi'] as String?,
);

Map<String, dynamic> _$PostCloseBhpUserIssueRequestToJson(
  PostCloseBhpUserIssueRequest instance,
) => <String, dynamic>{
  'data_zakonczenia': instance.dataZakonczenia,
  'uwagi': instance.uwagi,
};
