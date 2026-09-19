import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// Element prywatnej skrzynki powiadomień użytkownika.
@freezed
abstract class WorkspaceNotificationResponse
    with _$WorkspaceNotificationResponse {
  /// Tworzy pełny kontrakt powiadomienia.
  const factory WorkspaceNotificationResponse({
    required String id,
    required String sourceModule,
    required String eventType,
    required String entityType,
    required String entityId,
    String? workspaceId,
    required String title,
    required String body,
    String? deepLink,
    required String eventId,
    required int contractVersion,
    required DateTime createdAtUtc,
    DateTime? readAtUtc,
    required bool isPinned,
    DateTime? pinnedAtUtc,
    required NotificationCategory category,
    String? groupKey,
    String? metadataJson,
    required NotificationPriority priority,
    @Default(false) bool digestOnly,
  }) = _WorkspaceNotificationResponse;

  /// Odtwarza powiadomienie z JSON.
  factory WorkspaceNotificationResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceNotificationResponseFromJson(json);
}

/// Avatar lokalnego aktora powiadomienia.
@freezed
abstract class NotificationActorAvatarResponse
    with _$NotificationActorAvatarResponse {
  /// Tworzy referencję aktora.
  const factory NotificationActorAvatarResponse({
    required String userId,
    String? avatarUrl,
  }) = _NotificationActorAvatarResponse;

  /// Odtwarza odpowiedź z JSON.
  factory NotificationActorAvatarResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationActorAvatarResponseFromJson(json);
}

/// Grupa powiadomień prezentowana jako jeden wpis w UI.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class NotificationGroupResponse with _$NotificationGroupResponse {
  /// Tworzy grupę z najnowszym powiadomieniem i metadanymi.
  const factory NotificationGroupResponse({
    required String groupKey,
    required int count,
    required int unreadCount,
    required WorkspaceNotificationResponse latest,
    required List<String> notificationIds,
    String? notificationKind,
    String? scopeReference,
    List<NotificationActorAvatarResponse>? actorAvatars,
    String? preview,
    @Default(false) bool isArchived,
    int? realtimeSequence,
  }) = _NotificationGroupResponse;

  /// Odtwarza grupę z JSON.
  factory NotificationGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationGroupResponseFromJson(json);
}

/// Snapshot grup digest-only.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class NotificationDigestResponse with _$NotificationDigestResponse {
  /// Tworzy snapshot digestu.
  const factory NotificationDigestResponse({
    required DateTime generatedAtUtc,
    required List<NotificationGroupResponse> groups,
  }) = _NotificationDigestResponse;

  /// Odtwarza digest z JSON.
  factory NotificationDigestResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationDigestResponseFromJson(json);
}

/// Liczba nieprzeczytanych powiadomień.
@freezed
abstract class UnreadNotificationCountResponse
    with _$UnreadNotificationCountResponse {
  /// Tworzy odpowiedź licznika.
  const factory UnreadNotificationCountResponse({required int count}) =
      _UnreadNotificationCountResponse;

  /// Odtwarza licznik z JSON.
  factory UnreadNotificationCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadNotificationCountResponseFromJson(json);
}

/// Tryb e-mail dla jednej kategorii powiadomień.
@freezed
abstract class NotificationEmailCategoryPreference
    with _$NotificationEmailCategoryPreference {
  /// Tworzy preferencję kategorii.
  const factory NotificationEmailCategoryPreference({
    required NotificationEmailDeliveryMode emailMode,
  }) = _NotificationEmailCategoryPreference;

  /// Odtwarza preferencję z JSON.
  factory NotificationEmailCategoryPreference.fromJson(
    Map<String, dynamic> json,
  ) => _$NotificationEmailCategoryPreferenceFromJson(json);
}

/// Globalna macierz preferencji e-mail.
@freezed
abstract class NotificationDeliveryPreferenceResponse
    with _$NotificationDeliveryPreferenceResponse {
  /// Tworzy macierz preferencji wszystkich kategorii.
  const factory NotificationDeliveryPreferenceResponse({
    required String userId,
    required NotificationEmailCategoryPreference invitation,
    required NotificationEmailCategoryPreference membership,
    required NotificationEmailCategoryPreference workspace,
    required NotificationEmailCategoryPreference project,
    required NotificationEmailCategoryPreference task,
    required NotificationEmailCategoryPreference comment,
    required NotificationEmailCategoryPreference chat,
    required NotificationEmailCategoryPreference storage,
    required NotificationEmailCategoryPreference system,
    required DateTime updatedAtUtc,
  }) = _NotificationDeliveryPreferenceResponse;

  /// Odtwarza macierz z JSON.
  factory NotificationDeliveryPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$NotificationDeliveryPreferenceResponseFromJson(json);
}

/// Payload aktualizacji wybranych preferencji e-mail.
@freezed
abstract class UpdateNotificationDeliveryPreferencePayload
    with _$UpdateNotificationDeliveryPreferencePayload {
  /// Null pozostawia istniejącą wartość kategorii.
  const factory UpdateNotificationDeliveryPreferencePayload({
    NotificationEmailDeliveryMode? invitation,
    NotificationEmailDeliveryMode? membership,
    NotificationEmailDeliveryMode? workspace,
    NotificationEmailDeliveryMode? project,
    NotificationEmailDeliveryMode? task,
    NotificationEmailDeliveryMode? comment,
    NotificationEmailDeliveryMode? chat,
    NotificationEmailDeliveryMode? storage,
    NotificationEmailDeliveryMode? system,
  }) = _UpdateNotificationDeliveryPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateNotificationDeliveryPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateNotificationDeliveryPreferencePayloadFromJson(json);
}

/// Preferencja powiadomień Storage.
@freezed
abstract class StorageNotificationPreferenceResponse
    with _$StorageNotificationPreferenceResponse {
  /// Tworzy skuteczną preferencję Storage.
  const factory StorageNotificationPreferenceResponse({
    required String userId,
    required StorageNotificationPreferenceMode mode,
    required bool isDefault,
    DateTime? updatedAtUtc,
  }) = _StorageNotificationPreferenceResponse;

  /// Odtwarza preferencję z JSON.
  factory StorageNotificationPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$StorageNotificationPreferenceResponseFromJson(json);
}

/// Payload zmiany preferencji powiadomień Storage.
@freezed
abstract class UpdateStorageNotificationPreferencePayload
    with _$UpdateStorageNotificationPreferencePayload {
  /// Ustawia tryb dostarczania powiadomień Storage.
  const factory UpdateStorageNotificationPreferencePayload({
    required StorageNotificationPreferenceMode mode,
  }) = _UpdateStorageNotificationPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateStorageNotificationPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateStorageNotificationPreferencePayloadFromJson(json);
}

/// Payload szybkiej akcji na powiadomieniu.
@freezed
abstract class NotificationQuickActionPayload
    with _$NotificationQuickActionPayload {
  /// Określa akcję do wykonania.
  const factory NotificationQuickActionPayload({
    required NotificationQuickActionKind action,
  }) = _NotificationQuickActionPayload;

  /// Odtwarza payload z JSON.
  factory NotificationQuickActionPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationQuickActionPayloadFromJson(json);
}

/// Wynik szybkiej akcji.
@freezed
abstract class NotificationQuickActionResponse
    with _$NotificationQuickActionResponse {
  /// Informuje, jaka akcja została wykonana i czy zmieniła stan.
  const factory NotificationQuickActionResponse({
    required String notificationId,
    required NotificationQuickActionKind action,
    required bool changed,
  }) = _NotificationQuickActionResponse;

  /// Odtwarza wynik z JSON.
  factory NotificationQuickActionResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationQuickActionResponseFromJson(json);
}

/// Payload ręcznej odpowiedzi wysyłanej z centrum powiadomień do Chat.
@freezed
abstract class NotificationReplyPayload with _$NotificationReplyPayload {
  /// Zawiera idempotency key, tekst i opcjonalny Quill Delta.
  const factory NotificationReplyPayload({
    required String clientMessageId,
    required String text,
    String? deltaJson,
  }) = _NotificationReplyPayload;

  /// Odtwarza payload z JSON.
  factory NotificationReplyPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationReplyPayloadFromJson(json);
}

/// Payload komunikatu administracyjnego.
@freezed
abstract class CreateAdminNotificationPayload
    with _$CreateAdminNotificationPayload {
  /// Tworzy komunikat dla lokalnego użytkownika.
  const factory CreateAdminNotificationPayload({
    required String recipientUserId,
    required String title,
    required String body,
    String? deepLink,
    String? workspaceId,
  }) = _CreateAdminNotificationPayload;

  /// Odtwarza payload z JSON.
  factory CreateAdminNotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateAdminNotificationPayloadFromJson(json);
}
