import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_attachment_models.freezed.dart';
part 'chat_attachment_models.g.dart';

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

/// Gotowa kopia prywatnego Storage w tymczasowej sesji Chat.
@freezed
abstract class CopyPrivateFileToChatAttachmentResponse
    with _$CopyPrivateFileToChatAttachmentResponse {
  const factory CopyPrivateFileToChatAttachmentResponse({
    required String storageFileId,
    required String sessionId,
    required String fileName,
    required String mimeType,
    required int fileSizeBytes,
  }) = _CopyPrivateFileToChatAttachmentResponse;

  factory CopyPrivateFileToChatAttachmentResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CopyPrivateFileToChatAttachmentResponseFromJson(json);
}

/// Żądanie serwerowego skopiowania pliku prywatnego do Chat.
@freezed
abstract class CopyPrivateFileToChatAttachmentPayload
    with _$CopyPrivateFileToChatAttachmentPayload {
  const factory CopyPrivateFileToChatAttachmentPayload({
    required String storageFileId,
  }) = _CopyPrivateFileToChatAttachmentPayload;

  factory CopyPrivateFileToChatAttachmentPayload.fromJson(
    Map<String, dynamic> json,
  ) => _$CopyPrivateFileToChatAttachmentPayloadFromJson(json);
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
  /// Zawiera wiadomość, plik, autora, pozycję i metadane Storage.
  const factory ChatAttachmentResponse({
    required String id,
    required String messageId,
    required String storageFileId,
    required String attachedByUserId,
    required int position,
    required DateTime createdAtUtc,
    String? fileName,
    int? fileSizeBytes,
    String? contentType,
    @Default(false) bool isAvailable,
    @Default(false) bool isOfficeDocument,
  }) = _ChatAttachmentResponse;

  /// Odtwarza załącznik z JSON.
  factory ChatAttachmentResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatAttachmentResponseFromJson(json);
}

/// Wynik serwerowego zapisu załącznika do prywatnego Storage.
@freezed
abstract class SaveChatAttachmentToStorageResponse
    with _$SaveChatAttachmentToStorageResponse {
  /// Zawiera prywatną kopię i jej możliwości edycji.
  const factory SaveChatAttachmentToStorageResponse({
    required String storageFileId,
    required String fileName,
    required String mimeType,
    required int fileSizeBytes,
    required bool canEditOnline,
  }) = _SaveChatAttachmentToStorageResponse;

  /// Odtwarza odpowiedź serwera.
  factory SaveChatAttachmentToStorageResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SaveChatAttachmentToStorageResponseFromJson(json);
}
