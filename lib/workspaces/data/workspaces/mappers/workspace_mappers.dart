import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';

/// Mapuje transportowe odpowiedzi Workspaces na modele domenowe.
WorkspaceListItem mapWorkspaceListItem(WorkspaceListItemResponse response) =>
    WorkspaceListItem(
      id: response.id,
      name: response.name,
      description: response.description,
      icon: response.icon,
      primaryColor: response.primaryColor,
      isPinned: response.isPinned,
      isHidden: response.isHidden,
      sortPosition: response.sortPosition,
      createdByCoreUserId: response.createdByCoreUserId,
      isOwner: response.isOwner,
    );

/// Mapuje odpowiedź utworzenia lub szczegółów na element katalogu użytkownika.
WorkspaceListItem mapCreatedWorkspace(
  WorkspaceResponse response, {
  bool isPinned = false,
  bool isHidden = false,
  int? sortPosition,
  bool isOwner = true,
}) => WorkspaceListItem(
  id: response.id,
  name: response.name,
  description: response.description,
  icon: response.icon,
  primaryColor: response.primaryColor,
  isPinned: isPinned,
  isHidden: isHidden,
  sortPosition: sortPosition,
  createdByCoreUserId: response.createdByCoreUserId,
  isOwner: isOwner,
  archivedAtUtc: response.archivedAtUtc,
);
