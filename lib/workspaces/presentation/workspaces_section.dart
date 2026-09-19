import 'package:devplanner/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Sekcje nawigacyjne modułu Workspaces.
enum WorkspacesSection {
  /// Lista workspace’ów użytkownika.
  overview(Symbols.space_dashboard_rounded),

  /// Projekty dostępne w aktywnym workspace.
  projects(Symbols.folder_rounded),

  /// Zadania i tablice Kanban.
  tasks(Symbols.task_alt_rounded),

  /// Pliki i dokumenty workspace.
  files(Symbols.folder_copy_rounded),

  /// Komunikacja i konwersacje.
  chat(Symbols.chat_bubble_rounded),

  /// Współdzielone whiteboardy.
  whiteboards(Symbols.dashboard_customize_rounded),

  /// Dokumentacja Wiki.
  wiki(Symbols.menu_book_rounded),

  /// Skrzynka powiadomień.
  notifications(Symbols.notifications_rounded);

  const WorkspacesSection(this.icon);

  /// Ikona sekcji.
  final IconData icon;

  /// Zlokalizowana etykieta sekcji.
  String label(AppLocalizations l10n) => switch (this) {
    WorkspacesSection.overview => l10n.workspacesSectionOverview,
    WorkspacesSection.projects => l10n.workspacesSectionProjects,
    WorkspacesSection.tasks => l10n.workspacesSectionTasks,
    WorkspacesSection.files => l10n.workspacesSectionFiles,
    WorkspacesSection.chat => l10n.workspacesSectionChat,
    WorkspacesSection.whiteboards => l10n.workspacesSectionWhiteboards,
    WorkspacesSection.wiki => l10n.workspacesSectionWiki,
    WorkspacesSection.notifications => l10n.workspacesSectionNotifications,
  };
}
