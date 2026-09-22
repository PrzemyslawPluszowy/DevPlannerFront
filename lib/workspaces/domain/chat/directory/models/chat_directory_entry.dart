import 'package:equatable/equatable.dart';

/// Kandydat z lokalnego katalogu kont do rozpoczęcia rozmowy.
///
/// Katalog nie zawiera adresu e-mail; prezentacja dostaje login, nazwę i
/// opcjonalny awatar.
final class ChatDirectoryEntry extends Equatable {
  /// Tworzy kandydata zwróconego przez backend.
  const ChatDirectoryEntry({
    required this.userId,
    required this.login,
    required this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final String login;
  final String displayName;
  final String? avatarUrl;

  /// Etykieta do prezentacji: nazwa wyświetlana albo login.
  String get label =>
      displayName.trim().isNotEmpty ? displayName.trim() : login.trim();

  @override
  List<Object?> get props => [userId, login, displayName, avatarUrl];
}
