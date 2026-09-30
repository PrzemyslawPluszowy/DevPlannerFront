import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_code_syntax_highlighter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatCodeSyntaxHighlighter', () {
    test('preserves source and colors known Python tokens', () {
      const source = 'def greet(name):\n  return "hello"';
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: 'python',
        baseStyle: base,
      );
      final spans = result.children!.cast<TextSpan>();

      expect(result.toPlainText(), source);
      expect(spans.first.text, 'def');
      expect(spans.first.style?.color, const Color(0xffff7b72));
      expect(
        spans.singleWhere((span) => span.text == 'greet').style?.color,
        const Color(0xffd2a8ff),
      );
      expect(
        spans.singleWhere((span) => span.text == '"hello"').style?.color,
        const Color(0xffa5d6ff),
      );
    });

    test('keeps unknown language tokens readable in the base color', () {
      const source = 'customName(42)';
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: 'unknown-format',
        baseStyle: base,
      );
      final identifier = result.children!.cast<TextSpan>().singleWhere(
        (span) => span.text == 'customName',
      );

      expect(result.toPlainText(), source);
      expect(identifier.style?.color, base.color);
    });

    test('colors Dart types, calls, annotations, numbers, and comments', () {
      const source =
          '@override\nWidget build(BuildContext context) {\n'
          '  final int count = 42; // items\n'
          "  return Text('ready');\n}";
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: 'dart',
        baseStyle: base,
      );
      final spans = result.children!.cast<TextSpan>();
      Color? colorOf(String token) =>
          spans.firstWhere((span) => span.text == token).style?.color;

      expect(result.toPlainText(), source);
      expect(colorOf('override'), const Color(0xffffd580));
      expect(colorOf('final'), const Color(0xffff79c6));
      expect(colorOf('Widget'), const Color(0xff79d8ff));
      expect(colorOf('int'), const Color(0xff79d8ff));
      expect(colorOf('build'), const Color(0xffd2a8ff));
      expect(colorOf('Text'), const Color(0xff79d8ff));
      expect(colorOf('42'), const Color(0xffffb86c));
      expect(colorOf('='), const Color(0xffff79c6));
      expect(colorOf(';'), const Color(0xffa6b3c2));
      expect(colorOf('// items'), const Color(0xffa6b3c2));
      expect(colorOf("'ready'"), const Color(0xffa8e6a3));
    });

    test('colors modern Dart modifiers and common Flutter types', () {
      const source =
          'sealed class ChatView extends StatelessWidget {\n'
          '  FutureOr<Widget> buildView(BuildContext context) async => '
          'Scaffold(body: Padding(padding: EdgeInsets.zero));\n'
          '}';
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: 'dart',
        baseStyle: base,
      );
      final spans = result.children!.cast<TextSpan>();
      Color? colorOf(String token) =>
          spans.firstWhere((span) => span.text == token).style?.color;

      expect(result.toPlainText(), source);
      expect(colorOf('sealed'), const Color(0xffff79c6));
      expect(colorOf('async'), const Color(0xffff79c6));
      expect(colorOf('FutureOr'), const Color(0xff79d8ff));
      expect(colorOf('BuildContext'), const Color(0xff79d8ff));
      expect(colorOf('Scaffold'), const Color(0xff79d8ff));
      expect(colorOf('EdgeInsets'), const Color(0xff79d8ff));
      expect(colorOf('buildView'), const Color(0xffd2a8ff));
    });

    test('colors common Flutter members and reduces no source characters', () {
      const source =
          'Theme.of(context).textTheme.titleMedium;\n'
          'Container(color: Colors.blue, child: const SizedBox());';
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: 'dart',
        baseStyle: base,
      );
      final spans = result.children!.cast<TextSpan>();
      Color? colorOf(String token) =>
          spans.firstWhere((span) => span.text == token).style?.color;

      expect(result.toPlainText(), source);
      expect(colorOf('Theme'), const Color(0xff79d8ff));
      expect(colorOf('of'), const Color(0xffd2a8ff));
      expect(colorOf('textTheme'), const Color(0xff7ee0c3));
      expect(colorOf('titleMedium'), const Color(0xff7ee0c3));
      expect(colorOf('Container'), const Color(0xff79d8ff));
      expect(colorOf('Colors'), const Color(0xff79d8ff));
      expect(colorOf('blue'), const Color(0xff7ee0c3));
      expect(colorOf('SizedBox'), const Color(0xff79d8ff));
    });

    test('colors Dart local declarations and named arguments distinctly', () {
      const source =
          'final controller = TextEditingController();\n'
          'return TextField(controller: controller, enabled: true);';
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: 'dart',
        baseStyle: base,
      );
      final spans = result.children!.cast<TextSpan>();
      Color? colorOf(String token) =>
          spans.firstWhere((span) => span.text == token).style?.color;

      expect(result.toPlainText(), source);
      expect(
        spans
            .where((span) => span.text == 'controller')
            .map((span) => span.style?.color),
        <Color?>[
          const Color(0xff7ee0c3),
          const Color(0xffffb86c),
          const Color(0xffa5d6a7),
        ],
      );
      expect(colorOf('enabled'), const Color(0xffffb86c));
      expect(colorOf('true'), const Color(0xffff79c6));
    });

    test('distinguishes Dart control keywords from calls and declarations', () {
      const source =
          'class ChatScreen extends StatefulWidget {\n'
          '  Widget build(BuildContext context) {\n'
          '    if (context.mounted) return Text("ready");\n'
          '    return const SizedBox();\n'
          '  }\n'
          '}';
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: 'dart',
        baseStyle: base,
      );
      final spans = result.children!.cast<TextSpan>();
      Color? colorOf(String token) =>
          spans.firstWhere((span) => span.text == token).style?.color;

      expect(result.toPlainText(), source);
      expect(colorOf('ChatScreen'), const Color(0xff79d8ff));
      expect(colorOf('StatefulWidget'), const Color(0xff79d8ff));
      expect(colorOf('build'), const Color(0xffd2a8ff));
      expect(colorOf('if'), const Color(0xffff79c6));
      expect(colorOf('mounted'), const Color(0xff7ee0c3));
      expect(colorOf('Text'), const Color(0xff79d8ff));
    });

    test('infers Dart for an unlabelled pasted Flutter code block', () {
      const source =
          "import 'package:flutter/material.dart';\n"
          'class SamplePage extends StatelessWidget {\n'
          '  @override\n'
          '  Widget build(BuildContext context) => const Text("Hello");\n'
          '}';
      const base = TextStyle(color: Color(0xffe6edf3));

      final result = ChatCodeSyntaxHighlighter.highlight(
        source,
        language: null,
        baseStyle: base,
      );
      final spans = result.children!.cast<TextSpan>();
      Color? colorOf(String token) =>
          spans.firstWhere((span) => span.text == token).style?.color;

      expect(result.toPlainText(), source);
      expect(colorOf('import'), const Color(0xffff79c6));
      expect(colorOf('SamplePage'), const Color(0xff79d8ff));
      expect(colorOf('StatelessWidget'), const Color(0xff79d8ff));
      expect(colorOf('build'), const Color(0xffd2a8ff));
      expect(colorOf('Text'), const Color(0xff79d8ff));
    });

    test(
      'handles raw and multiline strings, nested comments, and operators',
      () {
        const source =
            "final raw = r'\${literal}';\n"
            '/* outer /* nested */ still comment */\n'
            'final value = count ??= 2;\n'
            "final text = '''line one\nline two''';";
        const base = TextStyle(color: Color(0xffe6edf3));

        final result = ChatCodeSyntaxHighlighter.highlight(
          source,
          language: 'dart',
          baseStyle: base,
        );
        final spans = result.children!.cast<TextSpan>();
        Color? colorOf(String token) =>
            spans.firstWhere((span) => span.text == token).style?.color;

        expect(result.toPlainText(), source);
        expect(colorOf("r'\${literal}'"), const Color(0xffa8e6a3));
        expect(
          colorOf('/* outer /* nested */ still comment */'),
          const Color(0xffa6b3c2),
        );
        expect(colorOf('??='), const Color(0xffff79c6));
        expect(
          colorOf("'''line one\nline two'''"),
          const Color(0xffa8e6a3),
        );
      },
    );
  });
}
