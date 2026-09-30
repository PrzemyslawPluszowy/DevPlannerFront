import 'package:devplanner/workspaces/data/chat/models/chat_message_models.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_history_models.freezed.dart';
part 'chat_history_models.g.dart';

/// Skompaktowany kontekst rozmowy.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatContextResponse with _$ChatContextResponse {
  /// Zawiera podsumowanie oraz najnowsze wiadomości.
  const factory ChatContextResponse({
    required String conversationId,
    required String summary,
    required int compactedMessageCount,
    required int participantCount,
    DateTime? earliestMessageAtUtc,
    DateTime? latestMessageAtUtc,
    required List<ChatMessageResponse> recentMessages,
    required DateTime generatedAtUtc,
  }) = _ChatContextResponse;

  /// Odtwarza kontekst z JSON.
  factory ChatContextResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatContextResponseFromJson(json);
}

/// Okno wiadomości wokół wskazanego punktu zaczepienia.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatMessageWindowResponse with _$ChatMessageWindowResponse {
  /// Zawiera punkt zaczepienia, sąsiadów i kursor starszej historii.
  const factory ChatMessageWindowResponse({
    required String conversationId,
    required String anchorMessageId,
    required List<ChatMessageResponse> messages,
    required bool hasMoreBefore,
    required bool hasMoreAfter,
    String? beforeCursor,
  }) = _ChatMessageWindowResponse;

  /// Odtwarza okno z JSON.
  factory ChatMessageWindowResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageWindowResponseFromJson(json);
}
