/// Tokeny leksykalne Darta potrzebne do bezpiecznego kolorowania kodu.
enum ChatDartTokenKind {
  whitespace,
  identifier,
  string,
  comment,
  number,
  symbol,
}

/// Jeden niezmieniony fragment źródła oraz jego klasa leksykalna.
final class ChatDartToken {
  const ChatDartToken(this.text, this.kind);

  final String text;
  final ChatDartTokenKind kind;
}

/// Lekki lexer dla bloków kodu. Nie parsuje ani nie wykonuje źródła.
abstract final class ChatDartTokenizer {
  static final RegExp _identifier = RegExp(r'[A-Za-z_$][A-Za-z0-9_$]*');
  static final RegExp _number = RegExp(
    '(?:0[xX][0-9a-fA-F](?:[0-9a-fA-F_]*[0-9a-fA-F])?|'
    '0[bB][01](?:[01_]*[01])?|'
    r'\d(?:[\d_]*\d)?(?:\.\d(?:[\d_]*\d)?)?'
    r'(?:[eE][+-]?\d(?:[\d_]*\d)?)?)',
  );
  static const _operators = <String>[
    '>>>',
    '??=',
    '<<=',
    '>>=',
    '...',
    '?..',
    '=>',
    '==',
    '!=',
    '<=',
    '>=',
    '&&',
    '||',
    '??',
    '?.',
    '..',
    '++',
    '--',
    '+=',
    '-=',
    '*=',
    '/=',
    '%=',
    '&=',
    '|=',
    '^=',
    '<<',
    '>>',
    '~/=',
    '~/',
    '=',
    '!',
    '<',
    '>',
    '+',
    '-',
    '*',
    '/',
    '%',
    '&',
    '|',
    '^',
    '~',
    '?',
  ];

  static List<ChatDartToken> tokenize(String source) {
    final tokens = <ChatDartToken>[];
    var index = 0;
    while (index < source.length) {
      final start = index;
      final char = source[index];
      if (_isWhitespace(char)) {
        while (index < source.length && _isWhitespace(source[index])) {
          index++;
        }
        tokens.add(_token(source, start, index, ChatDartTokenKind.whitespace));
        continue;
      }
      if (source.startsWith('//', index)) {
        index = _lineEnd(source, index);
        tokens.add(_token(source, start, index, ChatDartTokenKind.comment));
        continue;
      }
      if (source.startsWith('/*', index)) {
        index = _blockCommentEnd(source, index);
        tokens.add(_token(source, start, index, ChatDartTokenKind.comment));
        continue;
      }
      final quoteIndex = _stringQuoteIndex(source, index);
      if (quoteIndex != null) {
        index = _stringEnd(source, index, quoteIndex);
        tokens.add(_token(source, start, index, ChatDartTokenKind.string));
        continue;
      }
      final number = _number.matchAsPrefix(source, index);
      if (number != null) {
        index = number.end;
        tokens.add(_token(source, start, index, ChatDartTokenKind.number));
        continue;
      }
      final identifier = _identifier.matchAsPrefix(source, index);
      if (identifier != null) {
        index = identifier.end;
        tokens.add(_token(source, start, index, ChatDartTokenKind.identifier));
        continue;
      }
      final operator = _operatorAt(source, index);
      index += operator?.length ?? 1;
      tokens.add(_token(source, start, index, ChatDartTokenKind.symbol));
    }
    return tokens;
  }

  static ChatDartToken _token(
    String source,
    int start,
    int end,
    ChatDartTokenKind kind,
  ) => ChatDartToken(source.substring(start, end), kind);

  static int _lineEnd(String source, int index) {
    final newline = source.indexOf('\n', index);
    return newline < 0 ? source.length : newline;
  }

  static int _blockCommentEnd(String source, int index) {
    var depth = 1;
    index += 2;
    while (index < source.length && depth > 0) {
      if (source.startsWith('/*', index)) {
        depth++;
        index += 2;
      } else if (source.startsWith('*/', index)) {
        depth--;
        index += 2;
      } else {
        index++;
      }
    }
    return index;
  }

  static int? _stringQuoteIndex(String source, int index) {
    final prefix = source[index] == 'r' || source[index] == 'R';
    final quoteIndex = prefix ? index + 1 : index;
    if (quoteIndex >= source.length) return null;
    final quote = source[quoteIndex];
    return quote == "'" || quote == '"' ? quoteIndex : null;
  }

  static int _stringEnd(String source, int start, int quoteIndex) {
    final quote = source[quoteIndex];
    final raw = quoteIndex != start;
    final triple = source.startsWith('$quote$quote$quote', quoteIndex);
    final delimiterLength = triple ? 3 : 1;
    final delimiter = triple ? '$quote$quote$quote' : quote;
    var index = quoteIndex + delimiterLength;
    while (index < source.length) {
      if (!raw && source[index] == r'\') {
        index += index + 1 < source.length ? 2 : 1;
        continue;
      }
      if (source.startsWith(delimiter, index)) {
        return index + delimiterLength;
      }
      if (!triple && source[index] == '\n') return index;
      index++;
    }
    return source.length;
  }

  static bool _isWhitespace(String char) =>
      char == ' ' || char == '\n' || char == '\r' || char == '\t';

  static String? _operatorAt(String source, int index) {
    for (final operator in _operators) {
      if (source.startsWith(operator, index)) return operator;
    }
    return null;
  }

  static bool isOperator(String token) => _operators.contains(token);
}
