import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_project_user_preference_payload.freezed.dart';
part 'update_project_user_preference_payload.g.dart';

/// Payload zmiany osobistych ustawień prezentacji projektu.
@freezed
abstract class UpdateProjectUserPreferencePayload
    with _$UpdateProjectUserPreferencePayload {
  /// Tworzy dane zgodne z `UpdateProjectUserPreferenceRequest`.
  const factory UpdateProjectUserPreferencePayload({
    /// Czy projekt ma być ukryty na liście bieżącego użytkownika.
    required bool isHidden,

    /// Czy projekt ma być przypięty na liście bieżącego użytkownika.
    required bool isPinned,

    /// Oczekiwana wersja preferencji z poprzedniego odczytu lub zapisu
    /// (a nie wersja projektu) albo null, gdy klient jej nie zna.
    int? expectedVersion,
  }) = _UpdateProjectUserPreferencePayload;

  /// Odtwarza payload preferencji z JSON.
  factory UpdateProjectUserPreferencePayload.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateProjectUserPreferencePayloadFromJson(json);
}
