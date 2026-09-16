import 'package:json_annotation/json_annotation.dart';

/// Cykl życia zaproszenia do workspace.
@JsonEnum()
enum WorkspaceInvitationStatus {
  /// Zaproszenie oczekuje na odpowiedź.
  @JsonValue('Pending')
  pending,

  /// Zaproszenie zostało zaakceptowane.
  @JsonValue('Accepted')
  accepted,

  /// Zaproszenie zostało odrzucone.
  @JsonValue('Declined')
  declined,

  /// Zaproszenie zostało anulowane.
  @JsonValue('Cancelled')
  cancelled,

  /// Zaproszenie wygasło.
  @JsonValue('Expired')
  expired,
}
