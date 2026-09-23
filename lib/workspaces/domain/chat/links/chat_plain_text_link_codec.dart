import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';

/// Rozdziela plain text tylko po URL-ach potwierdzonych przez backend.
abstract final class ChatPlainTextLinkCodec {
  static final RegExp _externalUrl = RegExp(
    r"""https?://[^\s<>"']+""",
    caseSensitive: false,
  );
  static const String _trailingPunctuation = """.,;:!?"']}""";

  /// Zachowuje treść bajt w bajt; `url` jest wyłącznie metadanymi klikalnego
  /// fragmentu i nigdy nie jest dopisywany do tekstu.
  static List<({String text, String? url})> split(
    String text,
    List<ChatMessageLink> links,
  ) {
    if (text.isEmpty || links.isEmpty) {
      return <({String text, String? url})>[(text: text, url: null)];
    }
    final allowed = links
        .where((link) => !link.isInternal && link.url.isNotEmpty)
        .toList(growable: false);
    if (allowed.isEmpty) {
      return <({String text, String? url})>[(text: text, url: null)];
    }

    final segments = <({String text, String? url})>[];
    var cursor = 0;
    for (final match in _externalUrl.allMatches(text)) {
      final candidate = match.group(0)!;
      var end = candidate.length;
      while (end > 0 && _trailingPunctuation.contains(candidate[end - 1])) {
        end--;
      }
      if (end == 0) continue;
      final visibleUrl = candidate.substring(0, end);
      final link = _matchingLink(visibleUrl, allowed);
      final urlEnd = match.start + end;
      if (link == null || match.start < cursor) continue;
      if (match.start > cursor) {
        segments.add((text: text.substring(cursor, match.start), url: null));
      }
      segments.add((text: visibleUrl, url: link.url));
      cursor = urlEnd;
    }
    if (cursor < text.length) {
      segments.add((text: text.substring(cursor), url: null));
    }
    if (segments.isEmpty) {
      return <({String text, String? url})>[(text: text, url: null)];
    }
    return List<({String text, String? url})>.unmodifiable(segments);
  }

  static ChatMessageLink? _matchingLink(
    String candidate,
    List<ChatMessageLink> links,
  ) {
    final candidateUri = Uri.tryParse(candidate);
    for (final link in links) {
      if (candidate == link.url) return link;
      final linkUri = Uri.tryParse(link.url);
      if (candidateUri == null || linkUri == null) continue;
      final sameAuthority =
          candidateUri.scheme.toLowerCase() == linkUri.scheme.toLowerCase() &&
          candidateUri.host.toLowerCase() == linkUri.host.toLowerCase() &&
          candidateUri.port == linkUri.port;
      final candidatePath = candidateUri.path.isEmpty ? '/' : candidateUri.path;
      final linkPath = linkUri.path.isEmpty ? '/' : linkUri.path;
      if (sameAuthority &&
          candidatePath == linkPath &&
          candidateUri.query == linkUri.query &&
          candidateUri.fragment == linkUri.fragment) {
        return link;
      }
    }
    return null;
  }
}
