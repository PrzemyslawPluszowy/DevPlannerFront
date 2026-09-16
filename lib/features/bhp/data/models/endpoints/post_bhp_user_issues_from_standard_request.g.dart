// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_bhp_user_issues_from_standard_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostBhpUserIssuesFromStandardRequest
_$PostBhpUserIssuesFromStandardRequestFromJson(Map<String, dynamic> json) =>
    PostBhpUserIssuesFromStandardRequest(
      selectedStandardIds: (json['selected_standard_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PostBhpUserIssuesFromStandardRequestToJson(
  PostBhpUserIssuesFromStandardRequest instance,
) => <String, dynamic>{'selected_standard_ids': ?instance.selectedStandardIds};
