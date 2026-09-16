import 'package:json_annotation/json_annotation.dart';

/// Rola użytkownika w konkretnym workspace.
@JsonEnum()
enum WorkspaceRole {
  /// Pełny właściciel workspace.
  @JsonValue('Owner')
  owner,

  /// Administrator workspace.
  @JsonValue('Admin')
  admin,

  /// Zwykły członek workspace.
  @JsonValue('Member')
  member,

  /// Użytkownik tylko do odczytu.
  @JsonValue('Observer')
  observer,
}
