import 'package:equatable/equatable.dart';

/// Rola członka rozmowy Chat; decyduje o widoczności akcji w UI.
///
/// Backend zawsze ponownie egzekwuje uprawnienia, więc rola służy wyłącznie do
/// ukrycia akcji, których użytkownik nie może wykonać.
enum ChatMemberRole {
  /// Zwykły członek rozmowy.
  member('Member'),

  /// Właściciel rozmowy; jako jedyny przekazuje własność.
  owner('Owner'),

  /// Moderator: członkowie, role i publikacja w kanałach.
  moderator('Moderator'),

  /// Dostęp tylko do odczytu.
  observer('Observer');

  const ChatMemberRole(this.wireValue);

  /// Wartość kontraktu używana w transporcie.
  final String wireValue;

  /// Czy rola może zarządzać członkami rozmowy.
  bool get canManageMembers => this == owner || this == moderator;

  /// Czy rola może publikować w kanale lub w trybie tylko dla administratorów.
  bool get canPublish => this != observer;

  /// Zwraca rolę z wartości kontraktu; nieznana wartość degraduje do read-only.
  static ChatMemberRole fromWire(String? value) => values.firstWhere(
    (role) => role.wireValue == value,
    orElse: () => ChatMemberRole.observer,
  );
}

/// Członek rozmowy w modelu domenowym.
final class ChatMember extends Equatable {
  /// Tworzy członka zwróconego przez backend.
  const ChatMember({
    required this.userId,
    required this.role,
    required this.joinedAtUtc,
    this.login,
    this.displayName,
    this.avatarUrl,
  });

  final String userId;
  final ChatMemberRole role;
  final DateTime joinedAtUtc;

  /// Login z lokalnego katalogu albo null, gdy konto nie jest już aktywne.
  final String? login;

  /// Nazwa wyświetlana z lokalnego katalogu albo null.
  final String? displayName;

  /// Bezpieczny URL avatara z lokalnego profilu albo null.
  final String? avatarUrl;

  /// Etykieta do prezentacji: nazwa, login, a dopiero na końcu UUID.
  String get label {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final normalizedLogin = login?.trim();
    if (normalizedLogin != null && normalizedLogin.isNotEmpty) {
      return normalizedLogin;
    }
    return userId;
  }

  @override
  List<Object?> get props => [
    userId,
    role,
    joinedAtUtc,
    login,
    displayName,
    avatarUrl,
  ];
}
