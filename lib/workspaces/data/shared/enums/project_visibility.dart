import 'package:freezed_annotation/freezed_annotation.dart';

/// Określa widoczność projektu w obrębie workspace.
@JsonEnum()
enum ProjectVisibility {
  /// Projekt widoczny dla członków workspace.
  @JsonValue('Shared')
  shared,

  /// Projekt widoczny wyłącznie dla jawnych członków projektu.
  @JsonValue('Private')
  private,
}
