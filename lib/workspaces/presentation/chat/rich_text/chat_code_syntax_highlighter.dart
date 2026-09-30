import 'package:devplanner/workspaces/presentation/chat/rich_text/chat_dart_syntax.dart';
import 'package:flutter/material.dart';

/// Deterministyczne kolorowanie składni popularnych języków.
///
/// Nieznane identyfikatory i języki pozostają czytelne w kolorze bazowym;
/// kod jest wyłącznie renderowany i nigdy nie jest wykonywany.
abstract final class ChatCodeSyntaxHighlighter {
  static final RegExp _whitespace = RegExp(r'\s');
  static final RegExp _numberToken = RegExp(r'^\d');
  static final RegExp _identifierToken = RegExp(r'^[A-Za-z_$]');
  static final RegExp _singleOperatorToken = RegExp(
    r'^(?:=|!|<|>|\+|-|\*|/|%|&|\||\^|~|\?)$',
  );
  static final List<RegExp> _dartSignals = List<RegExp>.unmodifiable(
    <RegExp>[
      RegExp(r'\bimport\s+["\x27](?:package:|dart:)', multiLine: true),
      RegExp(r'\b(?:void|Widget|Future(?:<[^>]+>)?)\s+main\s*\('),
      RegExp(r'\bclass\s+[A-Z]\w*\s+(?:extends|implements|with)\b'),
      RegExp(r'\b(?:@override|@immutable|@pragma)\b'),
    ],
  );

  static TextSpan highlight(
    String source, {
    required String? language,
    required TextStyle baseStyle,
  }) {
    const keywords = <String, Set<String>>{
      'python': {
        'and',
        'as',
        'assert',
        'async',
        'await',
        'break',
        'class',
        'continue',
        'def',
        'del',
        'elif',
        'else',
        'except',
        'False',
        'finally',
        'for',
        'from',
        'global',
        'if',
        'import',
        'in',
        'is',
        'lambda',
        'nonlocal',
        'not',
        'or',
        'pass',
        'raise',
        'return',
        'True',
        'try',
        'while',
        'with',
        'yield',
        'None',
      },
      'javascript': {
        'async',
        'await',
        'break',
        'case',
        'catch',
        'class',
        'const',
        'continue',
        'debugger',
        'default',
        'delete',
        'do',
        'else',
        'export',
        'extends',
        'false',
        'finally',
        'for',
        'from',
        'function',
        'if',
        'import',
        'in',
        'instanceof',
        'let',
        'new',
        'null',
        'of',
        'return',
        'static',
        'super',
        'switch',
        'this',
        'throw',
        'true',
        'try',
        'typeof',
        'var',
        'void',
        'while',
        'yield',
      },
      'typescript': {
        'as',
        'async',
        'await',
        'break',
        'case',
        'catch',
        'class',
        'const',
        'continue',
        'default',
        'delete',
        'do',
        'else',
        'enum',
        'export',
        'extends',
        'false',
        'finally',
        'for',
        'from',
        'function',
        'if',
        'implements',
        'import',
        'in',
        'instanceof',
        'interface',
        'keyof',
        'let',
        'new',
        'null',
        'of',
        'private',
        'protected',
        'public',
        'readonly',
        'return',
        'static',
        'super',
        'switch',
        'this',
        'throw',
        'true',
        'try',
        'type',
        'typeof',
        'var',
        'void',
        'while',
        'yield',
      },
      'csharp': {
        'abstract',
        'as',
        'async',
        'await',
        'base',
        'bool',
        'break',
        'byte',
        'case',
        'catch',
        'char',
        'checked',
        'class',
        'const',
        'continue',
        'decimal',
        'default',
        'delegate',
        'do',
        'double',
        'else',
        'enum',
        'event',
        'explicit',
        'extern',
        'false',
        'finally',
        'float',
        'for',
        'foreach',
        'if',
        'implicit',
        'in',
        'int',
        'interface',
        'internal',
        'is',
        'lock',
        'long',
        'namespace',
        'new',
        'null',
        'object',
        'operator',
        'out',
        'override',
        'params',
        'private',
        'protected',
        'public',
        'readonly',
        'ref',
        'return',
        'sealed',
        'short',
        'sizeof',
        'static',
        'string',
        'struct',
        'switch',
        'this',
        'throw',
        'true',
        'try',
        'typeof',
        'using',
        'var',
        'virtual',
        'void',
        'while',
      },
      'sql': {
        'all',
        'alter',
        'and',
        'as',
        'asc',
        'begin',
        'between',
        'by',
        'case',
        'commit',
        'create',
        'delete',
        'desc',
        'distinct',
        'drop',
        'else',
        'end',
        'from',
        'group',
        'having',
        'in',
        'insert',
        'into',
        'is',
        'join',
        'left',
        'like',
        'limit',
        'not',
        'null',
        'on',
        'or',
        'order',
        'right',
        'rollback',
        'select',
        'set',
        'table',
        'then',
        'union',
        'update',
        'values',
        'when',
        'where',
      },
    };
    final normalized = switch (language?.toLowerCase().replaceAll(' ', '')) {
      'py' || 'python3' => 'python',
      'js' || 'jsx' || 'mjs' => 'javascript',
      'ts' || 'tsx' => 'typescript',
      'cs' || 'c#' => 'csharp',
      'sh' || 'bash' || 'zsh' || 'shell' => 'shell',
      final value => value ?? '',
    };
    // Bloki wklejane bez informacji o języku nadal powinny kolorować
    // typowy kod Dart/Flutter. Wymagamy charakterystycznych deklaracji,
    // żeby nie klasyfikować zwykłego tekstu ani innych języków.
    if (normalized == 'dart' || _looksLikeDart(source)) {
      return ChatDartSyntax.highlight(source, baseStyle);
    }
    final languageKeywords = normalized == 'dart'
        ? ChatDartSyntax.keywords
        : keywords[normalized] ?? const <String>{};
    final pattern = RegExp(
      r'''(?:"{3}[\s\S]*?"{3}|'{3}[\s\S]*?'{3}|//[^\n]*|#[^\n]*|--[^\n]*|/\*[\s\S]*?\*/|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`|\b0[xX][0-9a-fA-F_]+\b|\b\d[\d_]*(?:\.[\d_]+)?(?:[eE][+-]?[\d_]+)?\b|[A-Za-z_$][A-Za-z0-9_$]*|[^\s])''',
    );
    final spans = <TextSpan>[];
    var cursor = 0;
    String? previousToken;
    for (final match in pattern.allMatches(source)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: source.substring(cursor, match.start)));
      }
      final token = match.group(0)!;
      final isComment =
          token.startsWith('//') ||
          token.startsWith('#') ||
          token.startsWith('--') ||
          token.startsWith('/*');
      final isString =
          token.startsWith('"') ||
          token.startsWith("'") ||
          token.startsWith('`');
      final isNumber = _numberToken.hasMatch(token);
      final isIdentifier = _identifierToken.hasMatch(token);
      final isType =
          normalized == 'dart' && ChatDartSyntax.types.contains(token);
      final isAnnotation = isIdentifier && previousToken == '@';
      final isFunctionCall =
          (keywords.containsKey(normalized) || normalized == 'dart') &&
          isIdentifier &&
          source.startsWith('(', _nextNonWhitespaceIndex(source, match.end));
      final isOperator = _singleOperatorToken.hasMatch(token);
      final color = isComment
          ? const Color(0xff8b949e)
          : isString
          ? const Color(0xffa5d6ff)
          : isNumber
          ? const Color(0xff79c0ff)
          : isAnnotation
          ? const Color(0xffffa657)
          : isType
          ? const Color(0xffffc66d)
          : isIdentifier && languageKeywords.contains(token)
          ? const Color(0xffff7b72)
          : isFunctionCall
          ? const Color(0xffd2a8ff)
          : isIdentifier &&
                token.isNotEmpty &&
                token.codeUnitAt(0) >= 65 &&
                token.codeUnitAt(0) <= 90
          ? const Color(0xffd2a8ff)
          : isOperator
          ? const Color(0xffff7b72)
          : isIdentifier
          ? baseStyle.color
          : const Color(0xff8b949e);
      spans.add(
        TextSpan(
          text: token,
          style: TextStyle(color: color),
        ),
      );
      cursor = match.end;
      previousToken = token;
    }
    if (cursor < source.length) {
      spans.add(TextSpan(text: source.substring(cursor)));
    }
    return TextSpan(style: baseStyle, children: spans);
  }

  static int _nextNonWhitespaceIndex(String source, int index) {
    while (index < source.length) {
      if (_whitespace.matchAsPrefix(source, index) == null) return index;
      index++;
    }
    return index;
  }

  static bool _looksLikeDart(String source) {
    return _dartSignals.any((signal) => signal.hasMatch(source));
  }
}
