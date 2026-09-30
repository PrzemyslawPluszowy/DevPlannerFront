// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_action_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ForwardChatMessagePayload _$ForwardChatMessagePayloadFromJson(
  Map<String, dynamic> json,
) => _ForwardChatMessagePayload(
  targetConversationId: json['targetConversationId'] as String,
  clientMessageId: json['clientMessageId'] as String,
);

Map<String, dynamic> _$ForwardChatMessagePayloadToJson(
  _ForwardChatMessagePayload instance,
) => <String, dynamic>{
  'targetConversationId': instance.targetConversationId,
  'clientMessageId': instance.clientMessageId,
};

_ChatMessageRevisionResponse _$ChatMessageRevisionResponseFromJson(
  Map<String, dynamic> json,
) => _ChatMessageRevisionResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  authorUserId: json['authorUserId'] as String,
  editedByUserId: json['editedByUserId'] as String,
  text: json['text'] as String,
  deltaJson: json['deltaJson'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
  version: (json['version'] as num).toInt(),
  newVersion: (json['newVersion'] as num).toInt(),
);

Map<String, dynamic> _$ChatMessageRevisionResponseToJson(
  _ChatMessageRevisionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'authorUserId': instance.authorUserId,
  'editedByUserId': instance.editedByUserId,
  'text': instance.text,
  'deltaJson': instance.deltaJson,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
  'version': instance.version,
  'newVersion': instance.newVersion,
};

_ChatReactionSummaryResponse _$ChatReactionSummaryResponseFromJson(
  Map<String, dynamic> json,
) => _ChatReactionSummaryResponse(
  emoji: json['emoji'] as String,
  count: (json['count'] as num).toInt(),
  reactedByCurrentUser: json['reactedByCurrentUser'] as bool,
);

Map<String, dynamic> _$ChatReactionSummaryResponseToJson(
  _ChatReactionSummaryResponse instance,
) => <String, dynamic>{
  'emoji': instance.emoji,
  'count': instance.count,
  'reactedByCurrentUser': instance.reactedByCurrentUser,
};

_AddChatReactionPayload _$AddChatReactionPayloadFromJson(
  Map<String, dynamic> json,
) => _AddChatReactionPayload(emoji: json['emoji'] as String);

Map<String, dynamic> _$AddChatReactionPayloadToJson(
  _AddChatReactionPayload instance,
) => <String, dynamic>{'emoji': instance.emoji};

_ChatReactionResponse _$ChatReactionResponseFromJson(
  Map<String, dynamic> json,
) => _ChatReactionResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  userId: json['userId'] as String,
  emoji: json['emoji'] as String,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatReactionResponseToJson(
  _ChatReactionResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'userId': instance.userId,
  'emoji': instance.emoji,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ChatMutePayload _$ChatMutePayloadFromJson(Map<String, dynamic> json) =>
    _ChatMutePayload(
      untilUtc: json['untilUtc'] == null
          ? null
          : DateTime.parse(json['untilUtc'] as String),
    );

Map<String, dynamic> _$ChatMutePayloadToJson(_ChatMutePayload instance) =>
    <String, dynamic>{'untilUtc': instance.untilUtc?.toIso8601String()};

_ChatThreadMutePayload _$ChatThreadMutePayloadFromJson(
  Map<String, dynamic> json,
) => _ChatThreadMutePayload(
  untilUtc: json['untilUtc'] == null
      ? null
      : DateTime.parse(json['untilUtc'] as String),
);

Map<String, dynamic> _$ChatThreadMutePayloadToJson(
  _ChatThreadMutePayload instance,
) => <String, dynamic>{'untilUtc': instance.untilUtc?.toIso8601String()};

_ChatBookmarkPayload _$ChatBookmarkPayloadFromJson(Map<String, dynamic> json) =>
    _ChatBookmarkPayload(note: json['note'] as String?);

Map<String, dynamic> _$ChatBookmarkPayloadToJson(
  _ChatBookmarkPayload instance,
) => <String, dynamic>{'note': instance.note};

_ChatBookmarkResponse _$ChatBookmarkResponseFromJson(
  Map<String, dynamic> json,
) => _ChatBookmarkResponse(
  id: json['id'] as String,
  messageId: json['messageId'] as String,
  conversationId: json['conversationId'] as String,
  userId: json['userId'] as String,
  note: json['note'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatBookmarkResponseToJson(
  _ChatBookmarkResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'messageId': instance.messageId,
  'conversationId': instance.conversationId,
  'userId': instance.userId,
  'note': instance.note,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ChatPinnedMessageResponse _$ChatPinnedMessageResponseFromJson(
  Map<String, dynamic> json,
) => _ChatPinnedMessageResponse(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  messageId: json['messageId'] as String,
  pinnedByUserId: json['pinnedByUserId'] as String,
  pinnedAtUtc: DateTime.parse(json['pinnedAtUtc'] as String),
);

Map<String, dynamic> _$ChatPinnedMessageResponseToJson(
  _ChatPinnedMessageResponse instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'messageId': instance.messageId,
  'pinnedByUserId': instance.pinnedByUserId,
  'pinnedAtUtc': instance.pinnedAtUtc.toIso8601String(),
};
