import 'package:devplanner/workspaces/data/chat/models/chat_conversation_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_inbox_models.freezed.dart';
part 'chat_inbox_models.g.dart';

/// Strona serwerowej skrzynki rozmów Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatInboxPageResponse with _$ChatInboxPageResponse {
  /// Zawiera pozycje strony oraz kursor dalszego pobierania.
  const factory ChatInboxPageResponse({
    @Default(<ChatInboxItemResponse>[]) List<ChatInboxItemResponse> items,
    String? nextCursor,
    @Default(false) bool hasMore,
  }) = _ChatInboxPageResponse;

  /// Odtwarza stronę skrzynki z JSON.
  factory ChatInboxPageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxPageResponseFromJson(json);
}

/// Pojedyncza pozycja serwerowej skrzynki rozmów Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatInboxItemResponse with _$ChatInboxItemResponse {
  /// Zawiera rozmowę, bezpieczny podgląd, serwerowy licznik i uczestników.
  const factory ChatInboxItemResponse({
    required ChatConversationResponse conversation,
    ChatInboxMessagePreviewResponse? lastMessage,
    required DateTime lastActivityAtUtc,
    @Default(0) int unreadCount,
    String? lastReadMessageId,
    @Default(false) bool isMuted,
    @Default(false) bool isDraft,
    String? draftText,
    String? role,
    @Default(<ChatInboxParticipantResponse>[])
    List<ChatInboxParticipantResponse> participants,
    @Default(0) int participantCount,
  }) = _ChatInboxItemResponse;

  /// Odtwarza pozycję skrzynki z JSON.
  factory ChatInboxItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxItemResponseFromJson(json);
}

/// Bezpieczny podgląd ostatniej wiadomości rozmowy.
@freezed
abstract class ChatInboxMessagePreviewResponse
    with _$ChatInboxMessagePreviewResponse {
  /// Zawiera treść bez sekretów albo informację o usunięciu.
  const factory ChatInboxMessagePreviewResponse({
    required String messageId,
    required String authorUserId,
    String? text,
    @Default(false) bool isDeleted,
    @Default(false) bool hasAttachments,
    String? threadRootMessageId,
    required DateTime createdAtUtc,
  }) = _ChatInboxMessagePreviewResponse;

  /// Odtwarza podgląd z JSON.
  factory ChatInboxMessagePreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxMessagePreviewResponseFromJson(json);
}

/// Uczestnik rozmowy prezentowany w wierszu skrzynki.
@freezed
abstract class ChatInboxParticipantResponse
    with _$ChatInboxParticipantResponse {
  /// Zawiera profil albo wyłącznie identyfikator, gdy profil nie jest widoczny.
  const factory ChatInboxParticipantResponse({
    required String userId,
    String? login,
    String? displayName,
    String? avatarUrl,
    @Default(false) bool isCurrentUser,
  }) = _ChatInboxParticipantResponse;

  /// Odtwarza uczestnika z JSON.
  factory ChatInboxParticipantResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxParticipantResponseFromJson(json);
}

/// Agregat nieprzeczytanych wiadomości Chat.
@freezed
abstract class ChatInboxUnreadCountResponse
    with _$ChatInboxUnreadCountResponse {
  /// Zawiera łączny licznik, liczbę rozmów i czas wygenerowania.
  const factory ChatInboxUnreadCountResponse({
    @Default(0) int totalUnreadCount,
    @Default(0) int unreadConversationCount,
    required DateTime generatedAtUtc,
  }) = _ChatInboxUnreadCountResponse;

  /// Odtwarza agregat z JSON.
  factory ChatInboxUnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInboxUnreadCountResponseFromJson(json);
}
