import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';

/// Port lokalnego katalogu kont dla nowej rozmowy Chat.
///
/// Katalog jest globalny: rozmowa 1:1 w Scope Global nie może wymagać
/// workspace ani projektu. Backend ogranicza liczbę wyników i wymaga frazy od
/// dwóch znaków, więc port nie służy do enumeracji kont.
// Jeden cel portu: katalog kandydatów do nowej rozmowy. Rozdzielenie na osobne
// operacje nie wnosi nic, a port pozostaje seams dla testów UI.
// ignore: one_member_abstracts
abstract interface class ChatDirectoryRepository {
  /// Szuka aktywnych, potwierdzonych kont lokalnych po loginu albo nazwie.
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String term,
    int limit,
  });
}
