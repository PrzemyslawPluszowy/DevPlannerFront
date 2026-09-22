import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

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

/// Payload dodania członków rozmowy.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class AddChatMembersPayload with _$AddChatMembersPayload {
  /// Przekazuje UUID lokalnych użytkowników do dodania.
  const factory AddChatMembersPayload({
    List<String>? userIds,
  }) = _AddChatMembersPayload;

  /// Odtwarza payload z JSON.
  factory AddChatMembersPayload.fromJson(Map<String, dynamic> json) =>
      _$AddChatMembersPayloadFromJson(json);
}

/// Payload zmiany roli członka rozmowy.
@freezed
abstract class UpdateChatMemberRolePayload with _$UpdateChatMemberRolePayload {
  /// Ustawia rolę Member, Moderator, Observer albo Owner.
  const factory UpdateChatMemberRolePayload({required String role}) =
      _UpdateChatMemberRolePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatMemberRolePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateChatMemberRolePayloadFromJson(json);
}

/// Członek rozmowy Chat.
@freezed
abstract class ChatMemberResponse with _$ChatMemberResponse {
  /// Zawiera użytkownika, rolę, czas dołączenia i opcjonalny profil lokalny.
  const factory ChatMemberResponse({
    required String userId,
    required String role,
    required DateTime joinedAtUtc,
    String? login,
    String? displayName,
    String? avatarUrl,
  }) = _ChatMemberResponse;

  /// Odtwarza członka z JSON.
  factory ChatMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMemberResponseFromJson(json);
}

/// Sugestia użytkownika do wzmianki.
@freezed
abstract class ChatMentionSuggestionResponse
    with _$ChatMentionSuggestionResponse {
  /// Zawiera login, nazwę i avatar użytkownika.
  const factory ChatMentionSuggestionResponse({
    required String userId,
    required String login,
    required String displayName,
    String? avatarUrl,
  }) = _ChatMentionSuggestionResponse;

  /// Odtwarza sugestię z JSON.
  factory ChatMentionSuggestionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMentionSuggestionResponseFromJson(json);
}

/// Payload wysłania wiadomości Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class SendChatMessagePayload with _$SendChatMessagePayload {
  /// Przekazuje treść, idempotency key i opcjonalną odpowiedź.
  const factory SendChatMessagePayload({
    required String clientMessageId,
    required String text,
    String? deltaJson,
    String? replyToMessageId,
    List<String>? attachmentFileIds,
  }) = _SendChatMessagePayload;

  /// Odtwarza payload z JSON.
  factory SendChatMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$SendChatMessagePayloadFromJson(json);
}

/// Payload edycji wiadomości.
@freezed
abstract class UpdateChatMessagePayload with _$UpdateChatMessagePayload {
  /// Przekazuje nową treść i wersję wiadomości.
  const factory UpdateChatMessagePayload({
    required String text,
    String? deltaJson,
    required int version,
  }) = _UpdateChatMessagePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateChatMessagePayloadFromJson(json);
}

/// Payload przekazania wiadomości do innej rozmowy.
@freezed
abstract class ForwardChatMessagePayload with _$ForwardChatMessagePayload {
  /// Wskazuje rozmowę docelową i nowy idempotency key.
  const factory ForwardChatMessagePayload({
    required String targetConversationId,
    required String clientMessageId,
  }) = _ForwardChatMessagePayload;

  /// Odtwarza payload z JSON.
  factory ForwardChatMessagePayload.fromJson(Map<String, dynamic> json) =>
      _$ForwardChatMessagePayloadFromJson(json);
}

/// Rewizja poprzedniej treści wiadomości.
@freezed
abstract class ChatMessageRevisionResponse with _$ChatMessageRevisionResponse {
  /// Zawiera snapshot treści i wersję rewizji.
  const factory ChatMessageRevisionResponse({
    required String id,
    required String messageId,
    required String authorUserId,
    required String editedByUserId,
    required String text,
    String? deltaJson,
    required DateTime createdAtUtc,
    required int version,
    required int newVersion,
  }) = _ChatMessageRevisionResponse;

  /// Odtwarza rewizję z JSON.
  factory ChatMessageRevisionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageRevisionResponseFromJson(json);
}

/// Rozpoznany link URL w wiadomości.
@freezed
abstract class ChatLinkResponse with _$ChatLinkResponse {
  /// Zawiera URL i bezpieczne cechy linku.
  const factory ChatLinkResponse({
    required String url,
    String? host,
    required bool isHttps,
    required bool isInternal,
    required bool previewAllowed,
  }) = _ChatLinkResponse;

  /// Odtwarza link z JSON.
  factory ChatLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatLinkResponseFromJson(json);
}

/// Bezpieczny podgląd linku zewnętrznego.
@freezed
abstract class ChatLinkPreviewResponse with _$ChatLinkPreviewResponse {
  /// Zawiera końcowy URL i sanitizowane metadane.
  const factory ChatLinkPreviewResponse({
    required String finalUrl,
    String? title,
    String? description,
    String? contentType,
    required DateTime fetchedAtUtc,
  }) = _ChatLinkPreviewResponse;

  /// Odtwarza preview z JSON.
  factory ChatLinkPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatLinkPreviewResponseFromJson(json);
}

/// Payload przygotowania tekstu jako snippet.
@freezed
abstract class ChatSnippetPayload with _$ChatSnippetPayload {
  /// Przekazuje tekst, format i wymuszenie.
  const factory ChatSnippetPayload({
    required String text,
    @Default('PlainText') String format,
    @Default(false) bool force,
  }) = _ChatSnippetPayload;

  /// Odtwarza payload z JSON.
  factory ChatSnippetPayload.fromJson(Map<String, dynamic> json) =>
      _$ChatSnippetPayloadFromJson(json);
}

/// Wynik przygotowania tekstu jako snippet.
@freezed
abstract class ChatSnippetResponse with _$ChatSnippetResponse {
  /// Zawiera sanitizowaną treść i metadane pliku.
  const factory ChatSnippetResponse({
    required bool isSnippet,
    required int originalLength,
    String? suggestedFileName,
    String? mimeType,
    String? content,
    required bool isTruncated,
  }) = _ChatSnippetResponse;

  /// Odtwarza wynik z JSON.
  factory ChatSnippetResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSnippetResponseFromJson(json);
}

/// Odpowiedź utworzenia załącznika snippetu.
@freezed
abstract class ChatSnippetAttachmentResponse
    with _$ChatSnippetAttachmentResponse {
  /// Zawiera relację załącznika i wynik AV.
  const factory ChatSnippetAttachmentResponse({
    required ChatAttachmentResponse attachment,
    required String fileName,
    required int fileSizeBytes,
    required StorageScanStatus scanStatus,
  }) = _ChatSnippetAttachmentResponse;

  /// Odtwarza odpowiedź z JSON.
  factory ChatSnippetAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatSnippetAttachmentResponseFromJson(json);
}

/// Reakcja emoji w agregacie wiadomości.
@freezed
abstract class ChatReactionSummaryResponse with _$ChatReactionSummaryResponse {
  /// Zawiera emoji, licznik i reakcję bieżącego użytkownika.
  const factory ChatReactionSummaryResponse({
    required String emoji,
    required int count,
    required bool reactedByCurrentUser,
  }) = _ChatReactionSummaryResponse;

  /// Odtwarza agregat z JSON.
  factory ChatReactionSummaryResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatReactionSummaryResponseFromJson(json);
}

/// Wiadomość Chat.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatMessageResponse with _$ChatMessageResponse {
  /// Zawiera treść, autora, wersję i opcjonalne linki/reakcje.
  const factory ChatMessageResponse({
    required String id,
    required String conversationId,
    required String authorUserId,
    required String clientMessageId,
    required String text,
    String? deltaJson,
    String? replyToMessageId,
    required String payloadHash,
    required int version,
    required DateTime createdAtUtc,
    required bool isDeleted,
    List<ChatLinkResponse>? links,
    List<ChatReactionSummaryResponse>? reactions,
    List<ChatAttachmentResponse>? attachments,
    String? threadRootMessageId,
    @Default(false) bool isEdited,
    DateTime? deletedAtUtc,
  }) = _ChatMessageResponse;

  /// Odtwarza wiadomość z JSON.
  factory ChatMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageResponseFromJson(json);
}

/// Krótko żyjąca, prywatna sesja uploadu załączników jednej rozmowy Chat.
@freezed
abstract class ChatTemporaryAttachmentSessionResponse
    with _$ChatTemporaryAttachmentSessionResponse {
  /// Zawiera identyfikator sesji, rozmowę i czas wygaśnięcia UTC.
  const factory ChatTemporaryAttachmentSessionResponse({
    required String id,
    required String conversationId,
    required DateTime expiresAtUtc,
  }) = _ChatTemporaryAttachmentSessionResponse;

  /// Odtwarza odpowiedź sesji z JSON.
  factory ChatTemporaryAttachmentSessionResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ChatTemporaryAttachmentSessionResponseFromJson(json);
}

/// Stan doręczenia wiadomości.
@freezed
abstract class ChatMessageDeliveryResponse with _$ChatMessageDeliveryResponse {
  /// Zawiera odbiorcę, urządzenie i stan doręczenia.
  const factory ChatMessageDeliveryResponse({
    required String messageId,
    required String recipientUserId,
    String? deviceId,
    required ChatMessageDeliveryStatus status,
    required DateTime updatedAtUtc,
    String? lastError,
  }) = _ChatMessageDeliveryResponse;

  /// Odtwarza stan z JSON.
  factory ChatMessageDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDeliveryResponseFromJson(json);
}

/// Payload dodania reakcji emoji.
@freezed
abstract class AddChatReactionPayload with _$AddChatReactionPayload {
  /// Przekazuje emoji reakcji.
  const factory AddChatReactionPayload({required String emoji}) =
      _AddChatReactionPayload;

  /// Odtwarza payload z JSON.
  factory AddChatReactionPayload.fromJson(Map<String, dynamic> json) =>
      _$AddChatReactionPayloadFromJson(json);
}

/// Reakcja emoji użytkownika.
@freezed
abstract class ChatReactionResponse with _$ChatReactionResponse {
  /// Zawiera wiadomość, użytkownika, emoji i czas.
  const factory ChatReactionResponse({
    required String id,
    required String messageId,
    required String userId,
    required String emoji,
    required DateTime createdAtUtc,
  }) = _ChatReactionResponse;

  /// Odtwarza reakcję z JSON.
  factory ChatReactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatReactionResponseFromJson(json);
}

/// Payload wyciszenia rozmowy.
@freezed
abstract class ChatMutePayload with _$ChatMutePayload {
  /// Ustawia czas końca wyciszenia albo null dla wyciszenia bezterminowego.
  const factory ChatMutePayload({DateTime? untilUtc}) = _ChatMutePayload;

  /// Odtwarza payload z JSON.
  factory ChatMutePayload.fromJson(Map<String, dynamic> json) =>
      _$ChatMutePayloadFromJson(json);
}

/// Payload wyciszenia wątku rozmowy.
@freezed
abstract class ChatThreadMutePayload with _$ChatThreadMutePayload {
  /// Ustawia czas końca wyciszenia wątku.
  const factory ChatThreadMutePayload({DateTime? untilUtc}) =
      _ChatThreadMutePayload;

  /// Odtwarza payload z JSON.
  factory ChatThreadMutePayload.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadMutePayloadFromJson(json);
}

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

/// Payload ustawienia statusu użytkownika Chat.
@freezed
abstract class UpsertChatUserStatusPayload with _$UpsertChatUserStatusPayload {
  /// Przekazuje emoji, tekst, wygaśnięcie i tryb DND.
  const factory UpsertChatUserStatusPayload({
    String? emoji,
    String? text,
    DateTime? expiresAtUtc,
    @Default(false) bool isDnd,
  }) = _UpsertChatUserStatusPayload;

  /// Odtwarza payload z JSON.
  factory UpsertChatUserStatusPayload.fromJson(Map<String, dynamic> json) =>
      _$UpsertChatUserStatusPayloadFromJson(json);
}

/// Status użytkownika Chat.
@freezed
abstract class ChatUserStatusResponse with _$ChatUserStatusResponse {
  /// Zawiera status, DND i czas aktualizacji.
  const factory ChatUserStatusResponse({
    required String userId,
    String? emoji,
    String? text,
    DateTime? expiresAtUtc,
    required bool isDnd,
    required DateTime updatedAtUtc,
  }) = _ChatUserStatusResponse;

  /// Odtwarza status z JSON.
  factory ChatUserStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatUserStatusResponseFromJson(json);
}

/// Globalne preferencje powiadomień Chat.
@freezed
abstract class ChatUserNotificationPreferenceResponse
    with _$ChatUserNotificationPreferenceResponse {
  /// Zawiera preferencje kanałów in-app, e-mail, push i digest.
  const factory ChatUserNotificationPreferenceResponse({
    required String userId,
    required bool inAppEnabled,
    required bool emailEnabled,
    required bool pushEnabled,
    required bool digestEnabled,
  }) = _ChatUserNotificationPreferenceResponse;

  /// Odtwarza preferencje z JSON.
  factory ChatUserNotificationPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ChatUserNotificationPreferenceResponseFromJson(json);
}

/// Payload aktualizacji globalnych preferencji Chat.
@freezed
abstract class UpdateChatUserNotificationPreferencePayload
    with _$UpdateChatUserNotificationPreferencePayload {
  /// Null pozostawia bieżącą wartość kanału.
  const factory UpdateChatUserNotificationPreferencePayload({
    bool? inAppEnabled,
    bool? emailEnabled,
    bool? pushEnabled,
    bool? digestEnabled,
  }) = _UpdateChatUserNotificationPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatUserNotificationPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateChatUserNotificationPreferencePayloadFromJson(json);
}

/// Osobista preferencja powiadomień konkretnej rozmowy.
@freezed
abstract class ChatNotificationPreferenceResponse
    with _$ChatNotificationPreferenceResponse {
  /// Zawiera rozmowę, użytkownika i politykę powiadomień.
  const factory ChatNotificationPreferenceResponse({
    required String conversationId,
    required String userId,
    required ChatNotificationPreference preference,
  }) = _ChatNotificationPreferenceResponse;

  /// Odtwarza preferencję z JSON.
  factory ChatNotificationPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$ChatNotificationPreferenceResponseFromJson(json);
}

/// Payload zmiany osobistej polityki powiadomień rozmowy.
@freezed
abstract class UpdateChatNotificationPreferencePayload
    with _$UpdateChatNotificationPreferencePayload {
  /// Ustawia politykę All, MentionsOnly, HighOnly albo Muted.
  const factory UpdateChatNotificationPreferencePayload({
    required ChatNotificationPreference preference,
  }) = _UpdateChatNotificationPreferencePayload;

  /// Odtwarza payload z JSON.
  factory UpdateChatNotificationPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateChatNotificationPreferencePayloadFromJson(json);
}

/// Payload dołączenia pliku Storage do wiadomości.
@freezed
abstract class AttachChatFilePayload with _$AttachChatFilePayload {
  /// Wskazuje plik i jego pozycję.
  const factory AttachChatFilePayload({
    required String storageFileId,
    @Default(0) int position,
  }) = _AttachChatFilePayload;

  /// Odtwarza payload z JSON.
  factory AttachChatFilePayload.fromJson(Map<String, dynamic> json) =>
      _$AttachChatFilePayloadFromJson(json);
}

/// Relacja załącznika wiadomości Chat.
@freezed
abstract class ChatAttachmentResponse with _$ChatAttachmentResponse {
  /// Zawiera wiadomość, plik, autora i pozycję.
  const factory ChatAttachmentResponse({
    required String id,
    required String messageId,
    required String storageFileId,
    required String attachedByUserId,
    required int position,
    required DateTime createdAtUtc,
  }) = _ChatAttachmentResponse;

  /// Odtwarza załącznik z JSON.
  factory ChatAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatAttachmentResponseFromJson(json);
}

/// Zaproszenie e-mail do rozmowy.
@freezed
abstract class ChatInviteResponse with _$ChatInviteResponse {
  /// Zawiera status i czasy zaproszenia.
  const factory ChatInviteResponse({
    required String id,
    required String conversationId,
    required String email,
    required ChatInvitationStatus status,
    required DateTime createdAtUtc,
    required DateTime expiresAtUtc,
    DateTime? respondedAtUtc,
  }) = _ChatInviteResponse;

  /// Odtwarza zaproszenie z JSON.
  factory ChatInviteResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatInviteResponseFromJson(json);
}

/// Payload dodania zakładki do wiadomości.
@freezed
abstract class ChatBookmarkPayload with _$ChatBookmarkPayload {
  /// Ustawia prywatną notatkę zakładki.
  const factory ChatBookmarkPayload({String? note}) = _ChatBookmarkPayload;

  /// Odtwarza payload z JSON.
  factory ChatBookmarkPayload.fromJson(Map<String, dynamic> json) =>
      _$ChatBookmarkPayloadFromJson(json);
}

/// Prywatna zakładka wiadomości.
@freezed
abstract class ChatBookmarkResponse with _$ChatBookmarkResponse {
  /// Zawiera wiadomość, rozmowę, właściciela i notatkę.
  const factory ChatBookmarkResponse({
    required String id,
    required String messageId,
    required String conversationId,
    required String userId,
    String? note,
    required DateTime createdAtUtc,
  }) = _ChatBookmarkResponse;

  /// Odtwarza zakładkę z JSON.
  factory ChatBookmarkResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatBookmarkResponseFromJson(json);
}

/// Przypięta wiadomość rozmowy.
@freezed
abstract class ChatPinnedMessageResponse with _$ChatPinnedMessageResponse {
  /// Zawiera wiadomość, autora przypięcia i czas.
  const factory ChatPinnedMessageResponse({
    required String id,
    required String conversationId,
    required String messageId,
    required String pinnedByUserId,
    required DateTime pinnedAtUtc,
  }) = _ChatPinnedMessageResponse;

  /// Odtwarza przypięcie z JSON.
  factory ChatPinnedMessageResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatPinnedMessageResponseFromJson(json);
}

/// Payload utworzenia zaproszenia e-mail do rozmowy.
@freezed
abstract class CreateChatInvitePayload with _$CreateChatInvitePayload {
  /// Przekazuje adres e-mail i czas życia zaproszenia.
  const factory CreateChatInvitePayload({
    required String email,
    @Default(72) int ttlHours,
  }) = _CreateChatInvitePayload;

  /// Odtwarza payload z JSON.
  factory CreateChatInvitePayload.fromJson(Map<String, dynamic> json) =>
      _$CreateChatInvitePayloadFromJson(json);
}

/// Payload akceptacji zaproszenia do rozmowy.
@freezed
abstract class AcceptChatInvitePayload with _$AcceptChatInvitePayload {
  /// Przekazuje jednorazowy token z wiadomości e-mail.
  const factory AcceptChatInvitePayload({required String token}) =
      _AcceptChatInvitePayload;

  /// Odtwarza payload z JSON.
  factory AcceptChatInvitePayload.fromJson(Map<String, dynamic> json) =>
      _$AcceptChatInvitePayloadFromJson(json);
}

/// Payload zapisu albo aktualizacji szkicu wiadomości.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class UpsertChatDraftPayload with _$UpsertChatDraftPayload {
  /// Przekazuje treść, wersję i pliki szkicu.
  const factory UpsertChatDraftPayload({
    String? text,
    String? deltaJson,
    String? replyToMessageId,
    @Default(0) int version,
    List<String>? attachmentStorageFileIds,
  }) = _UpsertChatDraftPayload;

  /// Odtwarza payload z JSON.
  factory UpsertChatDraftPayload.fromJson(Map<String, dynamic> json) =>
      _$UpsertChatDraftPayloadFromJson(json);
}

/// Prywatny szkic wiadomości użytkownika.
@Freezed(makeCollectionsUnmodifiable: false)
abstract class ChatDraftResponse with _$ChatDraftResponse {
  /// Zawiera treść szkicu i jego załączniki.
  const factory ChatDraftResponse({
    required String id,
    required String conversationId,
    String? text,
    String? deltaJson,
    String? replyToMessageId,
    required int version,
    required DateTime updatedAtUtc,
    List<ChatDraftAttachmentResponse>? attachments,
  }) = _ChatDraftResponse;

  /// Odtwarza szkic z JSON.
  factory ChatDraftResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDraftResponseFromJson(json);
}

/// Załącznik zapisany w szkicu wiadomości.
@freezed
abstract class ChatDraftAttachmentResponse with _$ChatDraftAttachmentResponse {
  /// Zawiera plik i jego kolejność w szkicu.
  const factory ChatDraftAttachmentResponse({
    required String id,
    required String storageFileId,
    required int position,
    required DateTime createdAtUtc,
  }) = _ChatDraftAttachmentResponse;

  /// Odtwarza załącznik szkicu z JSON.
  factory ChatDraftAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDraftAttachmentResponseFromJson(json);
}

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

/// Kandydat z lokalnego katalogu kont do rozpoczęcia rozmowy Chat.
@freezed
abstract class ChatDirectoryUserResponse with _$ChatDirectoryUserResponse {
  /// Zawiera login, nazwę i awatar; katalog nigdy nie zwraca adresu e-mail.
  const factory ChatDirectoryUserResponse({
    required String userId,
    required String login,
    required String displayName,
    String? avatarUrl,
  }) = _ChatDirectoryUserResponse;

  /// Odtwarza kandydata z JSON.
  factory ChatDirectoryUserResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatDirectoryUserResponseFromJson(json);
}
