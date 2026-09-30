import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_dart_tokenizer.dart';
import 'package:flutter/material.dart';

/// Reguły tokenów charakterystyczne dla języka Dart.
abstract final class ChatDartSyntax {
  static const keywords = <String>{
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'base',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'get',
    'hide',
    'if',
    'implements',
    'interface',
    'import',
    'in',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'of',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'type',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
  };

  static const types = <String>{
    'bool',
    'ByteBuffer',
    'BigInt',
    'ByteData',
    'Comparable',
    'Enum',
    'JsonCodec',
    'MapEntry',
    'StackTrace',
    'StringBuffer',
    'TextSpan',
    'TextDirection',
    'TextEditingValue',
    'TextInputType',
    'TextOverflow',
    'TextTheme',
    'IconData',
    'IconThemeData',
    'Locale',
    'Pattern',
    'Provider',
    'StateProvider',
    'AsyncValue',
    'AsyncSnapshot',
    'WidgetRef',
    'Alignment',
    'AlignmentDirectional',
    'Animation',
    'AnimationController',
    'Axis',
    'Border',
    'BorderRadius',
    'BoxConstraints',
    'BoxDecoration',
    'BoxFit',
    'ButtonStyle',
    'Center',
    'ChangeNotifier',
    'Clip',
    'Column',
    'Container',
    'BuildContext',
    'Color',
    'ColorScheme',
    'CrossAxisAlignment',
    'DateTime',
    'double',
    'Duration',
    'dynamic',
    'EdgeInsets',
    'Error',
    'Exception',
    'Expanded',
    'Flexible',
    'Function',
    'Future',
    'FutureOr',
    'HttpClient',
    'GestureDetector',
    'GlobalKey',
    'GridView',
    'LayoutBuilder',
    'Icon',
    'Key',
    'ListView',
    'MainAxisAlignment',
    'MediaQuery',
    'Navigator',
    'Offset',
    'Opacity',
    'Paint',
    'Positioned',
    'Row',
    'SizedBox',
    'TextEditingController',
    'TextField',
    'ValueChanged',
    'ValueNotifier',
    'VisualDensity',
    'Wrap',
    'int',
    'Iterable',
    'Iterator',
    'List',
    'Listenable',
    'Map',
    'MapView',
    'MaterialApp',
    'Never',
    'Null',
    'num',
    'Object',
    'Padding',
    'RegExp',
    'Scaffold',
    'Set',
    'Sink',
    'State',
    'StatefulWidget',
    'StatelessWidget',
    'Stream',
    'StreamController',
    'StreamSubscription',
    'String',
    'Symbol',
    'TextAlign',
    'TextButton',
    'TextStyle',
    'Text',
    'TextAlignVertical',
    'TextDecoration',
    'TextHeightBehavior',
    'TextWidthBasis',
    'Type',
    'Uri',
    'Uint8List',
    'Widget',
    'WidgetBuilder',
    'VoidCallback',
  };

  static TextSpan highlight(String source, TextStyle baseStyle) {
    final tokens = ChatDartTokenizer.tokenize(source);
    final declaredIdentifiers = _declaredIdentifiers(tokens);
    final spans = <TextSpan>[];
    for (var index = 0; index < tokens.length; index++) {
      final token = tokens[index];
      final text = token.text;
      Color? color;
      FontStyle? fontStyle;
      switch (token.kind) {
        case ChatDartTokenKind.whitespace:
          break;
        case ChatDartTokenKind.comment:
          color = const Color(0xffa6b3c2);
          fontStyle = FontStyle.italic;
        case ChatDartTokenKind.string:
          color = const Color(0xffa8e6a3);
        case ChatDartTokenKind.number:
          color = const Color(0xffffb86c);
        case ChatDartTokenKind.identifier:
          final next = _nextSignificant(tokens, index + 1);
          final previous = _previousSignificant(tokens, index - 1);
          final isAnnotation = previous?.text == '@';
          final isDeclaration =
              previous != null &&
              (const <String>{'final', 'const', 'var', 'late'}.contains(
                    previous.text,
                  ) ||
                  types.contains(previous.text) && next?.text != '(' ||
                  const <String>{
                    'class',
                    'enum',
                    'extension',
                    'mixin',
                    'typedef',
                  }.contains(previous.text));
          final isNamedArgument = next?.text == ':';
          final isMember = previous?.text == '.';
          final isCall = next?.text == '(';
          final isTypeDeclarationName =
              previous != null &&
              const <String>{'class', 'enum', 'mixin', 'typedef'}.contains(
                previous.text,
              );
          color = isAnnotation
              ? const Color(0xffffd580)
              : types.contains(text) || isTypeDeclarationName
              ? const Color(0xff79d8ff)
              : const <String>{
                  'break',
                  'case',
                  'catch',
                  'continue',
                  'do',
                  'else',
                  'for',
                  'if',
                  'return',
                  'switch',
                  'throw',
                  'try',
                  'while',
                }.contains(text)
              ? const Color(0xffff79c6)
              : isCall
              ? const Color(0xffd2a8ff)
              : isMember
              ? const Color(0xff7ee0c3)
              : keywords.contains(text)
              ? const Color(0xffff79c6)
              : isNamedArgument
              ? const Color(0xffffb86c)
              : isDeclaration
              ? const Color(0xff7ee0c3)
              : declaredIdentifiers.contains(text)
              ? const Color(0xffa5d6a7)
              : _startsWithUppercase(text)
              ? const Color(0xff79d8ff)
              : baseStyle.color;
        case ChatDartTokenKind.symbol:
          color = ChatDartTokenizer.isOperator(text)
              ? const Color(0xffff79c6)
              : const Color(0xffa6b3c2);
      }
      spans.add(
        TextSpan(
          text: text,
          style: color == null
              ? null
              : TextStyle(color: color, fontStyle: fontStyle),
        ),
      );
    }
    return TextSpan(style: baseStyle, children: spans);
  }

  static Set<String> _declaredIdentifiers(List<ChatDartToken> tokens) {
    final result = <String>{};
    for (var index = 0; index < tokens.length; index++) {
      final token = tokens[index];
      if (token.kind != ChatDartTokenKind.identifier) continue;
      final previous = _previousSignificant(tokens, index - 1);
      final next = _nextSignificant(tokens, index + 1);
      if (previous == null || next?.text == '(') continue;
      if (const <String>{'final', 'const', 'var', 'late'}.contains(
            previous.text,
          ) ||
          types.contains(previous.text) ||
          const <String>{'class', 'enum', 'mixin', 'typedef'}.contains(
            previous.text,
          )) {
        result.add(token.text);
      }
    }
    return result;
  }

  static ChatDartToken? _nextSignificant(
    List<ChatDartToken> tokens,
    int start,
  ) {
    for (var index = start; index < tokens.length; index++) {
      if (tokens[index].kind != ChatDartTokenKind.whitespace) {
        return tokens[index];
      }
    }
    return null;
  }

  static ChatDartToken? _previousSignificant(
    List<ChatDartToken> tokens,
    int start,
  ) {
    for (var index = start; index >= 0; index--) {
      if (tokens[index].kind != ChatDartTokenKind.whitespace) {
        return tokens[index];
      }
    }
    return null;
  }

  static bool _startsWithUppercase(String token) =>
      token.isNotEmpty &&
      token.codeUnitAt(0) >= 65 &&
      token.codeUnitAt(0) <= 90;
}
