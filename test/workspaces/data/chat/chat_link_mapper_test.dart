import 'package:devplanner/workspaces/data/chat/models/chat_link_mapper.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mapuje flagi preview serwera do linku wiadomości', () {
    final links = ChatLinkMapper.toDomain([
      const ChatLinkResponse(
        url: 'https://example.com/',
        host: 'example.com',
        isHttps: true,
        isInternal: false,
        previewAllowed: true,
      ),
    ]);

    expect(links.single.url, 'https://example.com/');
    expect(links.single.host, 'example.com');
    expect(links.single.previewAllowed, isTrue);
    expect(ChatLinkMapper.toDomain(null), isEmpty);
  });
}
