// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_inbox_presence_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatInboxPresenceRequest _$ChatInboxPresenceRequestFromJson(
  Map<String, dynamic> json,
) => _ChatInboxPresenceRequest(
  userIds:
      (json['userIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$ChatInboxPresenceRequestToJson(
  _ChatInboxPresenceRequest instance,
) => <String, dynamic>{'userIds': instance.userIds};

_ChatInboxPresenceResponse _$ChatInboxPresenceResponseFromJson(
  Map<String, dynamic> json,
) => _ChatInboxPresenceResponse(
  users:
      (json['users'] as List<dynamic>?)
          ?.map(
            (e) => ChatInboxPresenceUserResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <ChatInboxPresenceUserResponse>[],
);

Map<String, dynamic> _$ChatInboxPresenceResponseToJson(
_ChatInboxPresenceResponse instance,
) => <String, dynamic>{
  'users': instance.users
      .map((e) => e.toJson())
      .toList(growable: false),
};

_ChatInboxPresenceUserResponse _$ChatInboxPresenceUserResponseFromJson(
  Map<String, dynamic> json,
) => _ChatInboxPresenceUserResponse(
  userId: json['userId'] as String,
  isOnline: json['isOnline'] as bool,
);

Map<String, dynamic> _$ChatInboxPresenceUserResponseToJson(
  _ChatInboxPresenceUserResponse instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'isOnline': instance.isOnline,
};
