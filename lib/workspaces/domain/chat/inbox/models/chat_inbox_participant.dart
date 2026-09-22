import 'package:equatable/equatable.dart';

/// Uczestnik rozmowy prezentowany w wierszu skrzynki.
///
/// Profil może być częściowo niedostępny, gdy konto zostało wyłączone albo
/// przestało być widoczne w lokalnym katalogu; UI używa wtedy `userId` jako
/// identyfikatora, a nie zmyślonej nazwy.
final class ChatInboxParticipant extends Equatable {
  /// Tworzy uczestnika zwróconego przez backend Workspaces.
  const ChatInboxParticipant({
    required this.userId,
    required this.isCurrentUser,
    this.login,
    this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final String? login;
  final String? displayName;

  /// Bezpieczny URL avatara albo `null`, gdy profil nie ma pliku.
  final String? avatarUrl;
  final bool isCurrentUser;

  /// Etykieta do prezentacji: nazwa wyświetlana, login albo identyfikator.
  String get label => displayName?.trim().isNotEmpty == true
      ? displayName!.trim()
      : login?.trim().isNotEmpty == true
      ? login!.trim()
      : userId;

  @override
  List<Object?> get props => [
    userId,
    login,
    displayName,
    avatarUrl,
    isCurrentUser,
  ];
}
