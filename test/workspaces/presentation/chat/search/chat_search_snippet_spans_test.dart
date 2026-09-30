import 'package:devplanner/workspaces/presentation/chat/search/chat_search_snippet_spans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatSearchSnippetSpans', () {
    const baseStyle = TextStyle(color: Color(0xff667788));
    const matchStyle = TextStyle(
      color: Color(0xff112233),
      fontWeight: FontWeight.w700,
    );

    test('renders match markers as styled text without exposing markers', () {
      final result = ChatSearchSnippetSpans.build(
        'przed ⟦fraza⟧ po i ⟦druga⟧',
        baseStyle: baseStyle,
        matchStyle: matchStyle,
      );
      final children = result.children!.cast<TextSpan>();

      expect(result.toPlainText(), 'przed fraza po i druga');
      expect(children[0].text, 'przed ');
      expect(children[1].text, 'fraza');
      expect(children[1].style, matchStyle);
      expect(children[2].text, ' po i ');
      expect(children[3].text, 'druga');
      expect(children[3].style, matchStyle);
    });

    test('keeps malformed or marker-free snippets readable', () {
      final malformed = ChatSearchSnippetSpans.build(
        'literal ⟦ znak',
        baseStyle: baseStyle,
        matchStyle: matchStyle,
      );
      final plain = ChatSearchSnippetSpans.build(
        'bez trafienia',
        baseStyle: baseStyle,
        matchStyle: matchStyle,
      );

      expect(malformed.toPlainText(), 'literal ⟦ znak');
      expect(plain.toPlainText(), 'bez trafienia');
    });

    test('preserves escaped literal markers and backslashes', () {
      final result = ChatSearchSnippetSpans.build(
        r'literal \⟦⟦needle⟧\⟧ and C:\\temp',
        baseStyle: baseStyle,
        matchStyle: matchStyle,
      );
      final children = result.children!.cast<TextSpan>();

      expect(result.toPlainText(), r'literal ⟦needle⟧ and C:\temp');
      expect(children[1].text, 'needle');
      expect(children[1].style, matchStyle);
    });

    test('highlights a match that itself contains both marker characters', () {
      final result = ChatSearchSnippetSpans.build(
        r'⟦\⟦whole match\⟧⟧',
        baseStyle: baseStyle,
        matchStyle: matchStyle,
      );
      final children = result.children!.cast<TextSpan>();

      expect(result.toPlainText(), '⟦whole match⟧');
      expect(children, hasLength(1));
      expect(children.single.text, '⟦whole match⟧');
      expect(children.single.style, matchStyle);
    });
  });
}
