import 'dart:async';

import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_corkboard_card_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_folder_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_project_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_task_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_whiteboard_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_wiki_page_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Jedyna granica otwierania formularzy tworzenia zasobów projektu.
///
/// Call-site nie zna implementacji formularza ani Cubitów jego komend. Każdy
/// dialog pozostaje niezależnym widgetem o własnym lifecycle.
final class ProjectResourceCreationDialogs {
  const ProjectResourceCreationDialogs._();

  static Future<void> showCreateProject(
    BuildContext context, {
    required String workspaceId,
    ProjectsRepository? repository,
    FutureOr<void> Function()? onCreated,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateProjectDialog(
        workspaceId: workspaceId,
        repository: repository ?? context.read<ProjectsRepository>(),
        onCreated: onCreated,
      ),
    );
  }

  static Future<void> showCreateWhiteboard(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
    FutureOr<void> Function()? onCreated,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateWhiteboardDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repository ?? context.read<ProjectResourcesRepository>(),
        onCreated: onCreated,
      ),
    );
  }

  static Future<void> showCreateTask(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateTaskDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repository ?? context.read<ProjectResourcesRepository>(),
      ),
    );
  }

  static Future<void> showCreateWikiPage(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateWikiPageDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repository ?? context.read<ProjectResourcesRepository>(),
      ),
    );
  }

  static Future<void> showCreateCorkboardCard(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateCorkboardCardDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repository ?? context.read<ProjectResourcesRepository>(),
      ),
    );
  }

  static Future<void> showCreateFolder(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateFolderDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repository ?? context.read<ProjectResourcesRepository>(),
      ),
    );
  }
}
