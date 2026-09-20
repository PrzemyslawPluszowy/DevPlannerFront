import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_user_preference_response.freezed.dart';
part 'project_user_preference_response.g.dart';

/// Osobiste ustawienia bieżącego użytkownika dla projektu.
@freezed
abstract class ProjectUserPreferenceResponse
    with _$ProjectUserPreferenceResponse {
  /// Tworzy odpowiedź zgodną z `ProjectUserPreferenceResponse`.
  const factory ProjectUserPreferenceResponse({
    /// UUID projektu.
    required String projectId,

    /// Czy projekt jest ukryty na liście użytkownika.
    required bool isHidden,

    /// Czy projekt jest przypięty na liście użytkownika.
    required bool isPinned,

    /// Osobista pozycja sortowania albo null.
    int? sortPosition,

    /// Czas aktualizacji preferencji.
    required DateTime updatedAtUtc,

    /// Wersja preferencji (`xmin`) albo null w starszym kontrakcie.
    ///
    /// Wartość służy jako `expectedVersion` następnego zapisu preferencji;
    /// niezgodność zwraca 409 z kodem `project.preference_version_conflict`.
    int? version,
  }) = _ProjectUserPreferenceResponse;

  /// Odtwarza preferencje projektu z odpowiedzi JSON.
  factory ProjectUserPreferenceResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectUserPreferenceResponseFromJson(json);
}
