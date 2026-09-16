import 'package:flutter/material.dart';
import 'package:ready_next/workspaces/presentation/sections/workspaces_section_placeholder.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/home_content/workspaces_home_content.dart';
import 'package:ready_next/workspaces/presentation/workspaces_section.dart';

/// Lista workspace’ów bieżącego użytkownika.
class WorkspacesOverviewPage extends StatelessWidget {
  /// Tworzy ekran przeglądu.
  const WorkspacesOverviewPage({super.key});

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    child: WorkspacesHomeContent(),
  );
}

/// Placeholder sekcji projektów.
class WorkspacesProjectsPage extends StatelessWidget {
  /// Tworzy ekran projektów.
  const WorkspacesProjectsPage({super.key});

  @override
  Widget build(BuildContext context) => const WorkspacesSectionPlaceholder(
    section: WorkspacesSection.projects,
  );
}

/// Placeholder sekcji zadań.
class WorkspacesTasksPage extends StatelessWidget {
  /// Tworzy ekran zadań.
  const WorkspacesTasksPage({super.key});

  @override
  Widget build(BuildContext context) => const WorkspacesSectionPlaceholder(
    section: WorkspacesSection.tasks,
  );
}

/// Ekran plików w module Workspaces.
class WorkspacesFilesPage extends StatelessWidget {
  /// Tworzy ekran plików.
  const WorkspacesFilesPage({super.key});

  @override
  Widget build(BuildContext context) => const StorageShellPage();
}

/// Placeholder sekcji czatu.
class WorkspacesChatPage extends StatelessWidget {
  /// Tworzy ekran czatu.
  const WorkspacesChatPage({super.key});

  @override
  Widget build(BuildContext context) => const WorkspacesSectionPlaceholder(
    section: WorkspacesSection.chat,
  );
}

/// Placeholder sekcji whiteboardów.
class WorkspacesWhiteboardsPage extends StatelessWidget {
  /// Tworzy ekran whiteboardów.
  const WorkspacesWhiteboardsPage({super.key});

  @override
  Widget build(BuildContext context) => const WorkspacesSectionPlaceholder(
    section: WorkspacesSection.whiteboards,
  );
}

/// Placeholder sekcji Wiki.
class WorkspacesWikiPage extends StatelessWidget {
  /// Tworzy ekran Wiki.
  const WorkspacesWikiPage({super.key});

  @override
  Widget build(BuildContext context) => const WorkspacesSectionPlaceholder(
    section: WorkspacesSection.wiki,
  );
}

/// Placeholder sekcji powiadomień.
class WorkspacesNotificationsPage extends StatelessWidget {
  /// Tworzy ekran powiadomień.
  const WorkspacesNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => const WorkspacesSectionPlaceholder(
    section: WorkspacesSection.notifications,
  );
}
