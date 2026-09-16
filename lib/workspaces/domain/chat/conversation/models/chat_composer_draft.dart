import 'package:equatable/equatable.dart';

/// Tryb zapisu draftu; rich text zawsze zachowuje oryginalny Quill Delta.
enum ChatComposerMode { plainText, richText }

/// Lokalny draft jednej rozmowy, niezależny od kontrolera Fluttera i transportu.
final class ChatComposerDraft extends Equatable {
  /// Tworzy snapshot composera gotowy do przekazania do kolejki dostawy.
  const ChatComposerDraft({
    required this.text,
    this.deltaJson,
    this.replyToMessageId,
    this.attachmentIds = const <String>[],
  });

  /// Tekstowy fallback bogatej wiadomości, używany przez preview i backend.
  final String text;

  /// Oryginalny Quill Delta, obecny wyłącznie dla trybu rich text.
  final String? deltaJson;

  /// Id wiadomości, na którą użytkownik odpowiada.
  final String? replyToMessageId;

  /// Kolejność dołączonych plików zachowana dla przyszłego uploadu.
  final List<String> attachmentIds;

  /// Czy draft nie zawiera treści możliwej do wysłania.
  bool get isEmpty => text.trim().isEmpty;

  /// Zwraca kopię draftu bez zależności od widgetów composera.
  ChatComposerDraft copyWith({
    String? text,
    String? deltaJson,
    String? replyToMessageId,
    bool clearDeltaJson = false,
    bool clearReplyToMessageId = false,
    List<String>? attachmentIds,
  }) => ChatComposerDraft(
    text: text ?? this.text,
    deltaJson: clearDeltaJson ? null : deltaJson ?? this.deltaJson,
    replyToMessageId: clearReplyToMessageId
        ? null
        : replyToMessageId ?? this.replyToMessageId,
    attachmentIds: attachmentIds ?? this.attachmentIds,
  );

  @override
  List<Object?> get props => [text, deltaJson, replyToMessageId, attachmentIds];
}
