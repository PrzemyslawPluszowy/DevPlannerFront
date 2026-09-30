import 'package:devplanner/workspaces/data/chat/models/chat_attachment_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_content_models.freezed.dart';
part 'chat_content_models.g.dart';

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
