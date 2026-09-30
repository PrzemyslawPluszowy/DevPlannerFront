import 'package:flutter/material.dart';

/// Zamienia znaczniki podglądu wyszukiwania na formatowanie tekstu.
///
/// Backend poprzedza ukośniki odwrotne i dosłowne delimitery sekwencją `\\`.
/// Parser je odtwarza, aby tekst użytkownika nie był mylony z wyróżnieniem.
abstract final class ChatSearchSnippetSpans {
  static const _startMarker = '⟦';
  static const _endMarker = '⟧';

  /// Zwraca snippet bez technicznych znaczników, z dopasowaniem wyróżnionym.
  static TextSpan build(
    String snippet, {
    required TextStyle baseStyle,
    required TextStyle matchStyle,
  }) {
    final children = <TextSpan>[];
    var offset = 0;

    while (offset < snippet.length) {
      final start = _indexOfUnescaped(snippet, _startMarker, offset);
      if (start < 0) {
        children.add(TextSpan(text: _unescape(snippet.substring(offset))));
        break;
      }

      final end = _indexOfUnescaped(
        snippet,
        _endMarker,
        start + _startMarker.length,
      );
      if (end < 0) {
        children.add(TextSpan(text: _unescape(snippet.substring(offset))));
        break;
      }

      if (start > offset) {
        children.add(
          TextSpan(text: _unescape(snippet.substring(offset, start))),
        );
      }
      children.add(
        TextSpan(
          text: _unescape(
            snippet.substring(start + _startMarker.length, end),
          ),
          style: matchStyle,
        ),
      );
      offset = end + _endMarker.length;
    }

    if (children.isEmpty && snippet.isEmpty) {
      children.add(const TextSpan(text: ''));
    }
    return TextSpan(style: baseStyle, children: children);
  }

  static int _indexOfUnescaped(String source, String marker, int from) {
    var index = from;
    while (index < source.length) {
      if (source[index] == '\\' && index + 1 < source.length) {
        final escaped = source[index + 1];
        if (escaped == '\\' ||
            escaped == _startMarker ||
            escaped == _endMarker) {
          index += 2;
          continue;
        }
      }
      if (source.startsWith(marker, index)) return index;
      index++;
    }
    return -1;
  }

  static String _unescape(String value) {
    final result = StringBuffer();
    var index = 0;
    while (index < value.length) {
      if (value[index] == '\\' && index + 1 < value.length) {
        final escaped = value[index + 1];
        if (escaped == '\\' ||
            escaped == _startMarker ||
            escaped == _endMarker) {
          result.write(escaped);
          index += 2;
          continue;
        }
      }
      result.write(value[index]);
      index++;
    }
    return result.toString();
  }
}
