import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_search_models.freezed.dart';
part 'chat_search_models.g.dart';

/// Pojedynczy wynik wyszukiwania wiadomości Chat.
@freezed
abstract class ChatSearchItemResponse with _$ChatSearchItemResponse {
  /// Zawiera wiadomość, trafienie i podstawowe dane zakresu.
  const factory ChatSearchItemResponse({
    required String messageId,
    required String conversationId,
    required String authorUserId,
    required ChatConversationType conversationType,
    String? workspaceId,
    String? projectId,
    String? conversationName,
    required String text,
    String? highlight,
    required double score,
    required DateTime createdAtUtc,
    required bool hasMention,
  }) = _ChatSearchItemResponse;

  /// Odtwarza wynik wyszukiwania z JSON.
  factory ChatSearchItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSearchItemResponseFromJson(json);
}

/// Kubełek facetu wyszukiwania.
@freezed
abstract class ChatSearchFacetBucketResponse
    with _$ChatSearchFacetBucketResponse {
  /// Zawiera identyfikator, etykietę i liczbę dopasowań.
  const factory ChatSearchFacetBucketResponse({
    required String id,
    String? label,
    required int count,
  }) = _ChatSearchFacetBucketResponse;

  /// Odtwarza kubełek z JSON.
  factory ChatSearchFacetBucketResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSearchFacetBucketResponseFromJson(json);
}

/// Wyniki wyszukiwania wiadomości Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatSearchResponse with _$ChatSearchResponse {
  /// Zawiera stronę wyników i kursor dalszego wyszukiwania.
  const factory ChatSearchResponse({
    required List<ChatSearchItemResponse> items,
    String? nextCursor,
    required int totalApproximate,
    required String indexVersion,
  }) = _ChatSearchResponse;

  /// Odtwarza wyniki z JSON.
  factory ChatSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSearchResponseFromJson(json);
}

/// Facety wyszukiwania wiadomości Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatSearchFacetsResponse with _$ChatSearchFacetsResponse {
  /// Zawiera agregaty rozmów, autorów, workspace'ów i projektów.
  const factory ChatSearchFacetsResponse({
    required int total,
    required List<ChatSearchFacetBucketResponse> conversations,
    required List<ChatSearchFacetBucketResponse> senders,
    required List<ChatSearchFacetBucketResponse> workspaces,
    required List<ChatSearchFacetBucketResponse> projects,
  }) = _ChatSearchFacetsResponse;

  /// Odtwarza facety z JSON.
  factory ChatSearchFacetsResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSearchFacetsResponseFromJson(json);
}
