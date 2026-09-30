// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_search_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatSearchItemResponse _$ChatSearchItemResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSearchItemResponse(
  messageId: json['messageId'] as String,
  conversationId: json['conversationId'] as String,
  authorUserId: json['authorUserId'] as String,
  conversationType: $enumDecode(
    _$ChatConversationTypeEnumMap,
    json['conversationType'],
  ),
  workspaceId: json['workspaceId'] as String?,
  projectId: json['projectId'] as String?,
  conversationName: json['conversationName'] as String?,
  text: json['text'] as String,
  highlight: json['highlight'] as String?,
  score: (json['score'] as num).toDouble(),
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  hasMention: json['hasMention'] as bool,
);

Map<String, dynamic> _$ChatSearchItemResponseToJson(
  _ChatSearchItemResponse instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'conversationId': instance.conversationId,
  'authorUserId': instance.authorUserId,
  'conversationType': _$ChatConversationTypeEnumMap[instance.conversationType]!,
  'workspaceId': instance.workspaceId,
  'projectId': instance.projectId,
  'conversationName': instance.conversationName,
  'text': instance.text,
  'highlight': instance.highlight,
  'score': instance.score,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'hasMention': instance.hasMention,
};

const _$ChatConversationTypeEnumMap = {
  ChatConversationType.direct: 'Direct',
  ChatConversationType.group: 'Group',
  ChatConversationType.channel: 'Channel',
  ChatConversationType.broadcast: 'Broadcast',
  ChatConversationType.discussion: 'Discussion',
};

_ChatSearchFacetBucketResponse _$ChatSearchFacetBucketResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSearchFacetBucketResponse(
  id: json['id'] as String,
  label: json['label'] as String?,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$ChatSearchFacetBucketResponseToJson(
  _ChatSearchFacetBucketResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'count': instance.count,
};

_ChatSearchResponse _$ChatSearchResponseFromJson(Map<String, dynamic> json) =>
    _ChatSearchResponse(
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => ChatSearchItemResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      totalApproximate: (json['totalApproximate'] as num).toInt(),
      indexVersion: json['indexVersion'] as String,
    );

Map<String, dynamic> _$ChatSearchResponseToJson(_ChatSearchResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'nextCursor': instance.nextCursor,
      'totalApproximate': instance.totalApproximate,
      'indexVersion': instance.indexVersion,
    };

_ChatSearchFacetsResponse _$ChatSearchFacetsResponseFromJson(
  Map<String, dynamic> json,
) => _ChatSearchFacetsResponse(
  total: (json['total'] as num).toInt(),
  conversations: (json['conversations'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  senders: (json['senders'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  workspaces: (json['workspaces'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  projects: (json['projects'] as List<dynamic>)
      .map(
        (e) =>
            ChatSearchFacetBucketResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$ChatSearchFacetsResponseToJson(
  _ChatSearchFacetsResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'conversations': instance.conversations,
  'senders': instance.senders,
  'workspaces': instance.workspaces,
  'projects': instance.projects,
};
