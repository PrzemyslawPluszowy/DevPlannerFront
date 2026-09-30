// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_inbox_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatInboxPageResponse _$ChatInboxPageResponseFromJson(
  Map<String, dynamic> json,
) => _ChatInboxPageResponse(
  items:
      (json['items'] as List<dynamic>?)
          ?.map(
            (e) => ChatInboxItemResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ChatInboxItemResponse>[],
  nextCursor: json['nextCursor'] as String?,
  hasMore: json['hasMore'] as bool? ?? false,
);

Map<String, dynamic> _$ChatInboxPageResponseToJson(
  _ChatInboxPageResponse instance,
) => <String, dynamic>{
  'items': instance.items,
  'nextCursor': instance.nextCursor,
  'hasMore': instance.hasMore,
};

_ChatInboxItemResponse _$ChatInboxItemResponseFromJson(
  Map<String, dynamic> json,
) => _ChatInboxItemResponse(
  conversation: ChatConversationResponse.fromJson(
    json['conversation'] as Map<String, dynamic>,
  ),
  lastMessage: json['lastMessage'] == null
      ? null
      : ChatInboxMessagePreviewResponse.fromJson(
          json['lastMessage'] as Map<String, dynamic>,
        ),
  lastActivityAtUtc: DateTime.parse(json['lastActivityAtUtc'] as String),
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  lastReadMessageId: json['lastReadMessageId'] as String?,
  isMuted: json['isMuted'] as bool? ?? false,
  isDraft: json['isDraft'] as bool? ?? false,
  draftText: json['draftText'] as String?,
  role: json['role'] as String?,
  participants:
      (json['participants'] as List<dynamic>?)
          ?.map(
            (e) => ChatInboxParticipantResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <ChatInboxParticipantResponse>[],
  participantCount: (json['participantCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChatInboxItemResponseToJson(
  _ChatInboxItemResponse instance,
) => <String, dynamic>{
  'conversation': instance.conversation,
  'lastMessage': instance.lastMessage,
  'lastActivityAtUtc': instance.lastActivityAtUtc.toIso8601String(),
  'unreadCount': instance.unreadCount,
  'lastReadMessageId': instance.lastReadMessageId,
  'isMuted': instance.isMuted,
  'isDraft': instance.isDraft,
  'draftText': instance.draftText,
  'role': instance.role,
  'participants': instance.participants,
  'participantCount': instance.participantCount,
};

_ChatInboxMessagePreviewResponse _$ChatInboxMessagePreviewResponseFromJson(
  Map<String, dynamic> json,
) => _ChatInboxMessagePreviewResponse(
  messageId: json['messageId'] as String,
  authorUserId: json['authorUserId'] as String,
  text: json['text'] as String?,
  isDeleted: json['isDeleted'] as bool? ?? false,
  hasAttachments: json['hasAttachments'] as bool? ?? false,
  threadRootMessageId: json['threadRootMessageId'] as String?,
  createdAtUtc: DateTime.parse(json['createdAtUtc'] as String),
);

Map<String, dynamic> _$ChatInboxMessagePreviewResponseToJson(
  _ChatInboxMessagePreviewResponse instance,
) => <String, dynamic>{
  'messageId': instance.messageId,
  'authorUserId': instance.authorUserId,
  'text': instance.text,
  'isDeleted': instance.isDeleted,
  'hasAttachments': instance.hasAttachments,
  'threadRootMessageId': instance.threadRootMessageId,
  'createdAtUtc': instance.createdAtUtc.toIso8601String(),
};

_ChatInboxParticipantResponse _$ChatInboxParticipantResponseFromJson(
  Map<String, dynamic> json,
) => _ChatInboxParticipantResponse(
  userId: json['userId'] as String,
  login: json['login'] as String?,
  displayName: json['displayName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  isCurrentUser: json['isCurrentUser'] as bool? ?? false,
);

Map<String, dynamic> _$ChatInboxParticipantResponseToJson(
  _ChatInboxParticipantResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'login': instance.login,
  'displayName': instance.displayName,
  'avatarUrl': instance.avatarUrl,
  'isCurrentUser': instance.isCurrentUser,
};

_ChatInboxUnreadCountResponse _$ChatInboxUnreadCountResponseFromJson(
  Map<String, dynamic> json,
) => _ChatInboxUnreadCountResponse(
  totalUnreadCount: (json['totalUnreadCount'] as num?)?.toInt() ?? 0,
  unreadConversationCount:
      (json['unreadConversationCount'] as num?)?.toInt() ?? 0,
  generatedAtUtc: DateTime.parse(json['generatedAtUtc'] as String),
);

Map<String, dynamic> _$ChatInboxUnreadCountResponseToJson(
  _ChatInboxUnreadCountResponse instance,
) => <String, dynamic>{
  'totalUnreadCount': instance.totalUnreadCount,
  'unreadConversationCount': instance.unreadConversationCount,
  'generatedAtUtc': instance.generatedAtUtc.toIso8601String(),
};
