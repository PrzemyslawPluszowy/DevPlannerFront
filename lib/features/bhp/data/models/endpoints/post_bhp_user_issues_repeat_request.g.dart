// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bhp_user_issues_repeat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostBhpUserIssuesRepeatRequest _$PostBhpUserIssuesRepeatRequestFromJson(
  Map<String, dynamic> json,
) => PostBhpUserIssuesRepeatRequest(
  selectedIssueIds: (json['selected_issue_ids'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  dataPrzydzialu: json['data_przydzialu'] as String,
);

Map<String, dynamic> _$PostBhpUserIssuesRepeatRequestToJson(
  PostBhpUserIssuesRepeatRequest instance,
) => <String, dynamic>{
  'selected_issue_ids': instance.selectedIssueIds,
  'data_przydzialu': instance.dataPrzydzialu,
};
