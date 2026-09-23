import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_plain_text_link_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const link = ChatMessageLink(
    url: 'https://example.com/path',
    host: 'example.com',
    isHttps: true,
    isInternal: false,
    previewAllowed: true,
  );

  test('linkuje tylko URL potwierdzony przez backend i zachowuje tekst', () {
    const text =
        'Zobacz https://example.com/path, a potem https://unknown.test';
    final segments = ChatPlainTextLinkCodec.split(text, const [link]);

    expect(segments.map((segment) => segment.text).join(), text);
    expect(
      segments.where((segment) => segment.url != null).toList(),
      [(text: 'https://example.com/path', url: link.url)],
    );
    expect(segments.last.text, ', a potem https://unknown.test');
  });

  test('dopasowuje kanoniczny URL i nie dodaje znaków do clipboardu', () {
    const canonical = ChatMessageLink(
      url: 'https://example.com/',
      host: 'example.com',
      isHttps: true,
      isInternal: false,
      previewAllowed: false,
    );
    final segments = ChatPlainTextLinkCodec.split(
      'https://EXAMPLE.com',
      const [canonical],
    );

    expect(segments.single.text, 'https://EXAMPLE.com');
    expect(segments.single.url, 'https://example.com/');
  });

  test('nie czyni linku wewnętrznego linkiem zewnętrznym', () {
    const internal = ChatMessageLink(
      url: '/workspaces/one',
      isHttps: false,
      isInternal: true,
      previewAllowed: true,
    );
    final segments = ChatPlainTextLinkCodec.split('/workspaces/one', const [
      internal,
    ]);

    expect(segments.single.url, isNull);
  });
}
