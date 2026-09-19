import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';

/// Domena projektu używana przez katalog Workspace.
///
/// Model nie przecieka do UI typów Retrofit/Freezed. Dzięki temu menu może
/// zostać przetestowane na danych domenowych, a zmiana transportu nie wymaga
/// przebudowy widgetów.
final class ProjectListItem {
  const ProjectListItem({
    required this.id,
    required this.workspaceId,
    required this.name,
    this.description,
    this.icon,
    this.primaryColor,
    this.visibility = ProjectVisibility.shared,
    this.status = ProjectStatus.active,
    this.myRole,
    this.isPinned = false,
    this.sortPosition,
    this.isHidden = false,
    this.archivedAtUtc,
  });

  final String id;
  final String workspaceId;
  final String name;
  final String? description;
  final String? icon;
  final String? primaryColor;
  final ProjectVisibility visibility;
  final ProjectStatus status;
  final ProjectRole? myRole;
  final bool isPinned;
  final int? sortPosition;
  final bool isHidden;
  final DateTime? archivedAtUtc;

  /// Czy projekt jest zarchiwizowany.
  bool get isArchived => archivedAtUtc != null;

  ProjectListItem copyWith({
    String? id,
    String? workspaceId,
    String? name,
    String? description,
    bool clearDescription = false,
    String? icon,
    bool clearIcon = false,
    String? primaryColor,
    bool clearPrimaryColor = false,
    ProjectVisibility? visibility,
    ProjectStatus? status,
    ProjectRole? myRole,
    bool clearMyRole = false,
    bool? isPinned,
    int? sortPosition,
    bool clearSortPosition = false,
    bool? isHidden,
    DateTime? archivedAtUtc,
    bool clearArchivedAtUtc = false,
  }) => ProjectListItem(
    id: id ?? this.id,
    workspaceId: workspaceId ?? this.workspaceId,
    name: name ?? this.name,
    description: clearDescription ? null : (description ?? this.description),
    icon: clearIcon ? null : (icon ?? this.icon),
    primaryColor: clearPrimaryColor
        ? null
        : (primaryColor ?? this.primaryColor),
    visibility: visibility ?? this.visibility,
    status: status ?? this.status,
    myRole: clearMyRole ? null : (myRole ?? this.myRole),
    isPinned: isPinned ?? this.isPinned,
    sortPosition: clearSortPosition
        ? null
        : (sortPosition ?? this.sortPosition),
    isHidden: isHidden ?? this.isHidden,
    archivedAtUtc: clearArchivedAtUtc
        ? null
        : (archivedAtUtc ?? this.archivedAtUtc),
  );
}
