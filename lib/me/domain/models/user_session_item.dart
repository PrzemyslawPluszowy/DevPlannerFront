import 'package:equatable/equatable.dart';

/// Informacja o aktywnej sesji urządzenia zalogowanego użytkownika.
class UserSessionItem extends Equatable {
  const UserSessionItem({
    required this.id,
    this.deviceName,
    this.platform,
    required this.createdAtUtc,
    required this.lastSeenAtUtc,
    required this.isCurrent,
  });

  /// Unikalny identyfikator sesji urządzenia (UUID).
  final String id;

  /// Nazwa urządzenia lub przeglądarki (np. "Chrome 120 (macOS)", "MacBook Pro").
  final String? deviceName;

  /// Platforma systemowa urządzenia (np. "macOS", "Windows", "Linux", "Web").
  final String? platform;

  /// Data i czas utworzenia sesji w UTC.
  final DateTime createdAtUtc;

  /// Data i czas ostatniej zarejestrowanej aktywności w UTC.
  final DateTime lastSeenAtUtc;

  /// Czy ta sesja reprezentuje urządzenie, z którego aktualnie korzysta użytkownik.
  final bool isCurrent;

  @override
  List<Object?> get props => [
    id,
    deviceName,
    platform,
    createdAtUtc,
    lastSeenAtUtc,
    isCurrent,
  ];
}
