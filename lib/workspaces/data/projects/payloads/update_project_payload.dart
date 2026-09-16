import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';

part 'update_project_payload.freezed.dart';
part 'update_project_payload.g.dart';

/// Payload pełnej aktualizacji danych projektu.
@freezed
abstract class UpdateProjectPayload with _$UpdateProjectPayload {
  /// Tworzy dane zgodne z `UpdateProjectRequest`.
  const factory UpdateProjectPayload({
    /// Nowa nazwa projektu.
    required String name,

    /// Nowy opis projektu albo null.
    String? description,

    /// Nowy identyfikator ikony albo null.
    String? icon,

    /// Nowy kolor główny projektu albo null.
    String? primaryColor,

    /// Nowa widoczność projektu.
    required ProjectVisibility visibility,

    /// Nowy status projektu.
    required ProjectStatus status,
  }) = _UpdateProjectPayload;

  /// Odtwarza payload aktualizacji z JSON.
  factory UpdateProjectPayload.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectPayloadFromJson(json);
}
