import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_list_item_response.freezed.dart';
part 'project_list_item_response.g.dart';

/// Element listy projektów zwracany przez Workspaces.
///
/// Kontrakt C#: `ProjectListItemResponse`.
@freezed
abstract class ProjectListItemResponse with _$ProjectListItemResponse {
  /// Tworzy element listy projektów.
  const factory ProjectListItemResponse({
    /// UUID projektu.
    required String id,

    /// UUID workspace zawierającego projekt.
    required String workspaceId,

    /// Nazwa projektu.
    required String name,

    /// Opcjonalny opis projektu.
    String? description,

    /// Opcjonalny identyfikator ikony projektu.
    String? icon,

    /// Opcjonalny główny kolor projektu w formacie CSS.
    String? primaryColor,

    /// Widoczność projektu.
    required ProjectVisibility visibility,

    /// Biznesowy status projektu.
    required ProjectStatus status,

    /// Rola bieżącego użytkownika albo null.
    ProjectRole? myRole,

    /// Czy projekt jest przypięty przez bieżącego użytkownika.
    required bool isPinned,

    /// Osobista pozycja sortowania projektu albo null.
    int? sortPosition,
  }) = _ProjectListItemResponse;

  /// Odtwarza element listy projektu z odpowiedzi JSON Workspaces.
  factory ProjectListItemResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectListItemResponseFromJson(json);
}
