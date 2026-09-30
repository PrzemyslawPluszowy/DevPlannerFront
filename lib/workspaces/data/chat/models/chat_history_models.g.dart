// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatContextResponse _$ChatContextResponseFromJson(Map<String, dynamic> json) =>
    _ChatContextResponse(
      conversationId: json['conversationId'] as String,
      summary: json['summary'] as String,
      compactedMessageCount: (json['compactedMessageCount'] as num).toInt(),
      participantCount: (json['participantCount'] as num).toInt(),
      earliestMessageAtUtc: json['earliestMessageAtUtc'] == null
          ? null
          : DateTime.parse(json['earliestMessageAtUtc'] as String),
      latestMessageAtUtc: json['latestMessageAtUtc'] == null
          ? null
          : DateTime.parse(json['latestMessageAtUtc'] as String),
      recentMessages: (json['recentMessages'] as List<dynamic>)
          .map((e) => ChatMessageResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
    );

Map<String, dynamic> _$ChatContextResponseToJson(
  _ChatContextResponse instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'summary': instance.summary,
  'compactedMessageCount': instance.compactedMessageCount,
  'participantCount': instance.participantCount,
  'earliestMessageAtUtc': instance.earliestMessageAtUtc?.toIso8601String(),
  'latestMessageAtUtc': instance.latestMessageAtUtc?.toIso8601String(),
  'recentMessages': instance.recentMessages,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
};

_ChatMessageWindowResponse _$ChatMessageWindowResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMessageWindowResponse(
  conversationId: json['conversationId'] as String,
  anchorMessageId: json['anchorMessageId'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => ChatMessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasMoreBefore: json['hasMoreBefore'] as bool,
  hasMoreAfter: json['hasMoreAfter'] as bool,
  beforeCursor: json['beforeCursor'] as String?,
);

Map<String, dynamic> _$ChatMessageWindowResponseToJson(
  _ChatMessageWindowResponse instance,
) => <String, dynamic>{
  'conversationId': instance.conversationId,
  'anchorMessageId': instance.anchorMessageId,
  'messages': instance.messages,
  'hasMoreBefore': instance.hasMoreBefore,
  'hasMoreAfter': instance.hasMoreAfter,
  'beforeCursor': instance.beforeCursor,
};
