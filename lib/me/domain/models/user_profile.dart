import 'package:equatable/equatable.dart';

/// Domenowy model profilu zalogowanego użytkownika w DevPlanner.
class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    required this.login,
    required this.email,
    required this.displayName,
    this.avatarFileId,
    this.roles = const <String>{},
    this.permissions = const <String>{},
  });

  /// Unikalny identyfikator użytkownika w formacie UUID.
  final String userId;

  /// Unikalny login konta.
  final String login;

  /// Adres e-mail użytkownika.
  final String email;

  /// Nazwa wyświetlana użytkownika w interfejsie.
  final String displayName;

  /// Identyfikator pliku awatara w usłudze Storage (opcjonalny).
  final String? avatarFileId;

  /// Zbiór ról przypisanych do użytkownika.
  final Set<String> roles;

  /// Zbiór uprawnień posiadanych przez użytkownika.
  final Set<String> permissions;

  /// Tworzy kopię modelu z opcjonalnie zaktualizowanymi polami.
  UserProfile copyWith({
    String? userId,
    String? login,
    String? email,
    String? displayName,
    String? avatarFileId,
    bool clearAvatarFileId = false,
    Set<String>? roles,
    Set<String>? permissions,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      login: login ?? this.login,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarFileId:
          clearAvatarFileId ? null : (avatarFileId ?? this.avatarFileId),
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    login,
    email,
    displayName,
    avatarFileId,
    roles,
    permissions,
  ];
}
