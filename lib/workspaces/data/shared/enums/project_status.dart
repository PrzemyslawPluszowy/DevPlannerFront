import 'package:freezed_annotation/freezed_annotation.dart';

/// Biznesowy stan realizacji projektu, niezależny od jego archiwizacji.
@JsonEnum()
enum ProjectStatus {
  /// Projekt zaplanowany, ale jeszcze nierozpoczęty.
  @JsonValue('Planned')
  planned,

  /// Projekt aktywnie realizowany.
  @JsonValue('Active')
  active,

  /// Projekt chwilowo wstrzymany.
  @JsonValue('OnHold')
  onHold,

  /// Projekt zakończony.
  @JsonValue('Completed')
  completed,
}
