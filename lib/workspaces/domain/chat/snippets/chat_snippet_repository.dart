import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';

/// Wynik przygotowania długiego tekstu jako snippet.
///
/// `content` to treść, którą klient ma wysłać jako plik; `isTruncated` mówi
/// wprost, że serwer skrócił treść, więc UI nie może obiecywać „całego tekstu”.
final class ChatSnippetPreparation {
  /// Tworzy wynik przygotowania.
  const ChatSnippetPreparation({
    required this.isSnippet,
    required this.originalLength,
    required this.content,
    required this.isTruncated,
    this.suggestedFileName,
    this.mimeType,
  });

  /// Czy serwer uznał tekst za snippet.
  final bool isSnippet;

  /// Długość wejścia przed sanityzacją.
  final int originalLength;

  /// Przygotowana treść albo `null`, gdy tekst nie przekroczył progu.
  final String? content;

  /// Czy serwer skrócił treść do swojego limitu.
  final bool isTruncated;

  /// Sugerowana nazwa pliku.
  final String? suggestedFileName;

  /// Typ MIME przygotowanego pliku.
  final String? mimeType;
}

/// Port przygotowania snippet-u.
///
/// Preparation nie jest uploadem: port zwraca przygotowaną treść, a plik
/// powstaje dopiero wtedy, gdy użytkownik świadomie wybierze wysłanie TXT.
// ignore: one_member_abstracts
abstract interface class ChatSnippetRepository {
  /// Przygotowuje tekst jako snippet w kontekście rozmowy.
  Future<Either<ApiError, ChatSnippetPreparation>> prepare({
    required String conversationId,
    required String text,
    bool force = false,
  });
}
