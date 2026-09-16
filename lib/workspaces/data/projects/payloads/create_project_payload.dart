import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';

part 'create_project_payload.freezed.dart';
part 'create_project_payload.g.dart';

/// Payload utworzenia projektu w aktywnym workspace.
@freezed
abstract class CreateProjectPayload with _$CreateProjectPayload {
  /// Tworzy dane nowego projektu zgodne z `CreateProjectRequest`.
  const factory CreateProjectPayload({
    /// Nazwa projektu od 1 do 160 znaków.
    required String name,

    /// Opcjonalny opis projektu do 4000 znaków.
    String? description,

    /// Opcjonalny identyfikator ikony prezentacyjnej projektu.
    String? icon,

    /// Opcjonalny kolor główny projektu w formacie CSS.
    String? primaryColor,

    /// Widoczność projektu: Shared albo Private.
    required ProjectVisibility visibility,

    /// Stan projektu: Planned, Active, OnHold albo Completed.
    required ProjectStatus status,
  }) = _CreateProjectPayload;

  /// Odtwarza payload projektu z JSON.
  factory CreateProjectPayload.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectPayloadFromJson(json);
}
