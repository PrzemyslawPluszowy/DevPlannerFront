import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_placement_models.freezed.dart';
part 'chat_placement_models.g.dart';

/// Payload dodania placementu do rozmowy.
@freezed
abstract class AddChatPlacementPayload with _$AddChatPlacementPayload {
  /// Wskazuje provider, typ i zasób mount pointu.
  const factory AddChatPlacementPayload({
    required String provider,
    required String resourceType,
    required String resourceId,
    String? label,
    String? deepLink,
  }) = _AddChatPlacementPayload;

  /// Odtwarza payload z JSON.
  factory AddChatPlacementPayload.fromJson(Map<String, dynamic> json) =>
      _$AddChatPlacementPayloadFromJson(json);
}

/// Placement/mount point rozmowy.
@freezed
abstract class ChatPlacementResponse with _$ChatPlacementResponse {
  /// Zawiera provider, zasób i autora placementu.
  const factory ChatPlacementResponse({
    required String id,
    required String conversationId,
    required String provider,
    required String resourceType,
    required String resourceId,
    String? label,
    String? deepLink,
    required String createdByUserId,
    required DateTime createdAtUtc,
  }) = _ChatPlacementResponse;

  /// Odtwarza placement z JSON.
  factory ChatPlacementResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatPlacementResponseFromJson(json);
}
