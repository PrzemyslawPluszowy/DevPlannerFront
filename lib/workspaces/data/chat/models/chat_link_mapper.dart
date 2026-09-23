import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';

/// Mapuje bezpieczne linki serwera do modelu wiadomości.
abstract final class ChatLinkMapper {
  /// Zwraca stabilną, niemutowalną listę; null odpowiedzi oznacza brak linków.
  static List<ChatMessageLink> toDomain(List<ChatLinkResponse>? response) =>
      response
          ?.map(
            (link) => ChatMessageLink(
              url: link.url,
              host: link.host,
              isHttps: link.isHttps,
              isInternal: link.isInternal,
              previewAllowed: link.previewAllowed,
            ),
          )
          .toList(growable: false) ??
      const <ChatMessageLink>[];
}
