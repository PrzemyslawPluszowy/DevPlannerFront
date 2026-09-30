import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_conversation_models.freezed.dart';
part 'chat_conversation_models.g.dart';

/// Payload rozwiązania albo utworzenia rozmowy Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ResolveChatConversationPayload
    with _$ResolveChatConversationPayload {
  /// Definiuje typ, zakres i uczestników rozmowy.
  const factory ResolveChatConversationPayload({
    required ChatConversationType type,
    required ChatScopeKind scopeKind,
    required String scopeKey,
    String? workspaceId,
    String? projectId,
    String? name,
    String? directConversationKey,
    List<String>? userIds,
    String? discussionRootMessageId,
    @Default('Everyone') String postingPermission,
    String? scopeProvider,
    String? scopeResourceType,
    String? scopeResourceId,
  }) = _ResolveChatConversationPayload;

  /// Odtwarza payload z JSON.
  factory ResolveChatConversationPayload.fromJson(Map<String, dynamic> json) =>
      _$ResolveChatConversationPayloadFromJson(json);
}

/// Payload aktualizacji rozmowy Chat.
@freezed
abstract class UpdateChatConversationPayload
    with _$UpdateChatConversationPayload {
  /// Przekazuje nazwę i politykę publikacji.
  const factory UpdateChatConversationPayload({
    String? name,
    @Default('Everyone') String postingPermission,
  }) = _UpdateChatConversationPayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatConversationPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateChatConversationPayloadFromJson(json);
}

/// Szczegóły rozmowy Chat.
@freezed
abstract class ChatConversationResponse with _$ChatConversationResponse {
  /// Zawiera typ, scope, wersję i stan archiwizacji.
  const factory ChatConversationResponse({
    required String id,
    required ChatConversationType type,
    required ChatScopeKind scopeKind,
    required String scopeKey,
    String? workspaceId,
    String? projectId,
    String? name,
    String? discussionRootMessageId,
    required int version,
    required DateTime createdAtUtc,
    @Default('Everyone') String postingPermission,
    @Default(false) bool isArchived,
  }) = _ChatConversationResponse;

  /// Odtwarza rozmowę z JSON.
  factory ChatConversationResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationResponseFromJson(json);
}
