import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:equatable/equatable.dart';

/// Lokalna intencja wysłania oczekująca na ponowienie.
///
/// Zawiera wyłącznie dane potrzebne do ponowienia: stabilny `clientMessageId`,
/// treść i identyfikatory załączników. Nie przechowuje tokenów ani identyfikatora
/// użytkownika, więc rekord nie może stać się nośnikiem sekretów.
final class PendingChatSend extends Equatable {
  /// Tworzy intencję wysłania.
  const PendingChatSend({
    required this.clientMessageId,
    required this.conversationId,
    required this.draft,
    required this.attempts,
  });

  final String clientMessageId;
  final String conversationId;
  final ChatComposerDraft draft;

  /// Liczba podjętych prób; pozwala pokazać stan bez zgadywania.
  final int attempts;

  /// Tworzy kopię z licznikiem prób.
  PendingChatSend withAttempts(int value) => PendingChatSend(
    clientMessageId: clientMessageId,
    conversationId: conversationId,
    draft: draft,
    attempts: value,
  );

  /// Serializuje intencję do magazynu lokalnego.
  Map<String, Object?> toJson() => <String, Object?>{
    'clientMessageId': clientMessageId,
    'conversationId': conversationId,
    'attempts': attempts,
    'text': draft.text,
    'deltaJson': draft.deltaJson,
    'replyToMessageId': draft.replyToMessageId,
    'attachmentIds': draft.attachmentIds,
  };

  /// Odtwarza intencję z magazynu; niekompletny rekord jest odrzucany.
  static PendingChatSend? fromJson(Map<String, Object?> json) {
    final clientMessageId = json['clientMessageId'];
    final conversationId = json['conversationId'];
    if (clientMessageId is! String || conversationId is! String) return null;
    if (clientMessageId.isEmpty || conversationId.isEmpty) return null;
    final attachments = json['attachmentIds'];
    return PendingChatSend(
      clientMessageId: clientMessageId,
      conversationId: conversationId,
      attempts: json['attempts'] is int ? json['attempts']! as int : 0,
      draft: ChatComposerDraft(
        text: json['text'] as String? ?? '',
        deltaJson: json['deltaJson'] as String?,
        replyToMessageId: json['replyToMessageId'] as String?,
        attachmentIds: attachments is List
            ? attachments.whereType<String>().toList(growable: false)
            : const <String>[],
      ),
    );
  }

  @override
  List<Object?> get props => [clientMessageId, conversationId, draft, attempts];
}

/// Magazyn intencji wysłania przypisany do użytkownika i rozmowy.
///
/// Port jest asynchroniczny, bo desktop korzysta z systemowego secure storage,
/// a Web celowo nie utrwala treści w nieszyfrowanym magazynie przeglądarki.
abstract interface class ChatPendingSendStore {
  /// Zwraca oczekujące intencje użytkownika, opcjonalnie jednej rozmowy.
  Future<List<PendingChatSend>> read({
    required String userId,
    String? conversationId,
  });

  /// Zapisuje albo nadpisuje intencję; brak szyfrowanego magazynu jest ignorowany.
  Future<void> save({required String userId, required PendingChatSend pending});

  /// Usuwa intencję po potwierdzeniu przez backend.
  Future<void> remove({
    required String userId,
    required String clientMessageId,
  });

  /// Usuwa wszystkie intencje użytkownika; wywoływane przy zmianie konta
  /// i wylogowaniu, żeby kolejna sesja nie ponowiła cudzej wysyłki.
  Future<void> clearForUser({required String userId});
}
