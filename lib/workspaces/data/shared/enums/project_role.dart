import 'package:freezed_annotation/freezed_annotation.dart';

/// Rola bieżącego użytkownika w projekcie.
@JsonEnum()
enum ProjectRole {
  /// Właściciel projektu.
  @JsonValue('Owner')
  owner,

  /// Administrator projektu.
  @JsonValue('Admin')
  admin,

  /// Zwykły członek projektu.
  @JsonValue('Member')
  member,

  /// Użytkownik z dostępem tylko do odczytu.
  @JsonValue('Observer')
  observer,
}
