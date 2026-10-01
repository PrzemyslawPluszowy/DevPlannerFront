import 'dart:async';

import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Otwiera ustawienia projektu z identyfikatorami wyłącznie z aktywnej trasy.
final class TaskListProjectSettingsLauncher {
  const TaskListProjectSettingsLauncher._();

  static void show(BuildContext context, ProjectSettingsTab tab) {
    final pathParameters = GoRouterState.of(context).pathParameters;
    final workspaceId = pathParameters['workspaceId'] ?? '';
    final projectId = pathParameters['projectId'] ?? '';
    if (workspaceId.isEmpty || projectId.isEmpty) return;

    final project = ProjectListItem(
      id: projectId,
      workspaceId: workspaceId,
      name: '',
      sortPosition: 0,
    );
    unawaited(
      ProjectSettingsDialogs.show(
        context: context,
        project: project,
        initialTab: tab,
      ),
    );
  }
}
