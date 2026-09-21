import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_setups_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_corkboard_card_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_folder_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_project_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_task_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_whiteboard_dialog.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/create_wiki_page_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Zwraca port atomowego kreatora projektu dla formularza tworzenia projektu.
///
/// Kolejność jest istotna: jawnie wstrzyknięty port wygrywa z portem z drzewa,
/// a port projektów z kontekstu bywa implementacją, która realizuje również
/// kontrakt kreatora — wtedy nie trzeba drugiego połączenia HTTP ani drugiego
/// klienta w warstwie aplikacji. Gdy żaden nie jest dostępny, kreator pokazuje
/// jawny powód zamiast udawać, że zapis się powiódł.
///
/// Odczyt portu z kontekstu jest celowo nullable: brak portu w kompozycji to
/// konfiguracja transportu, a nie błąd użytkownika, więc nie może kończyć się
/// wyjątkiem `ProviderNotFoundException`.
ProjectSetupsRepository? resolveProjectSetupsRepository(
  BuildContext context, {
  required ProjectsRepository? projects,
  ProjectSetupsRepository? explicit,
}) {
  if (explicit != null) return explicit;
  final ambient = context.read<ProjectSetupsRepository?>();
  if (ambient != null) return ambient;
  // Port projektów z kontekstu bywa implementacją, która realizuje również
  // kontrakt kreatora; wtedy nie trzeba drugiego klienta HTTP.
  if (projects case final ProjectSetupsRepository port) return port;
  return null;
}

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
    ProjectTemplatesRepository? templatesRepository,
    WorkspacesRepository? membersRepository,
    FutureOr<void> Function(String projectId)? onProjectCreated,
    FutureOr<void> Function()? onCreated,
  }) {
    // Odczyt jest nullable, bo port projektów jest opcjonalnym wpięciem
    // kompozycji: sidebar przekazuje go jawnie, a drzewo projektów polega na
    // providerze. Gdy żadnego nie ma, kreator musi pokazać jawny powód
    // „niedostępne” — wyjątek `ProviderNotFoundException` z przycisku `+`
    // byłby awarią interfejsu, a nie informacją dla użytkownika.
    final projects = repository ?? context.read<ProjectsRepository?>();
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateProjectDialog(
        workspaceId: workspaceId,
        repository: resolveProjectSetupsRepository(context, projects: projects),
        templatesRepository:
            templatesRepository ?? context.read<ProjectTemplatesRepository?>(),
        membersRepository:
            membersRepository ?? context.read<WorkspacesRepository?>(),
        currentUserId: context.read<AuthSessionPort?>()?.snapshot.user?.userId,
        onProjectCreated: onProjectCreated,
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
    final resolved = repository ?? context.read<ProjectResourcesRepository?>();
    if (resolved == null) {
      return _showUnavailable(
        context,
        title: AppLocalizations.of(context)!.workspacesCreateWhiteboardTitle,
      );
    }
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateWhiteboardDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: resolved,
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
    final resolved = repository ?? context.read<ProjectResourcesRepository?>();
    if (resolved == null) {
      return _showUnavailable(
        context,
        title: AppLocalizations.of(context)!.workspacesCreateTaskTitle,
      );
    }
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateTaskDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: resolved,
      ),
    );
  }

  static Future<void> showCreateWikiPage(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
  }) {
    final resolved = repository ?? context.read<ProjectResourcesRepository?>();
    if (resolved == null) {
      return _showUnavailable(
        context,
        title: AppLocalizations.of(context)!.workspacesCreateWikiTitle,
      );
    }
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateWikiPageDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: resolved,
      ),
    );
  }

  static Future<void> showCreateCorkboardCard(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
  }) {
    final resolved = repository ?? context.read<ProjectResourcesRepository?>();
    if (resolved == null) {
      return _showUnavailable(
        context,
        title: AppLocalizations.of(context)!.workspacesCreateCorkboardTitle,
      );
    }
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateCorkboardCardDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: resolved,
      ),
    );
  }

  /// Pokazuje jawny stan, gdy sesja nie ma portu zasobów projektu.
  ///
  /// Brak portu jest wynikiem konfiguracji transportu, a nie błędem
  /// użytkownika, więc formularz nie udaje zapisu ani nie wywraca widoku.
  static Future<void> _showUnavailable(
    BuildContext context, {
    required String title,
  }) => showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      icon: const Icon(Icons.cloud_off_outlined),
      title: Text(title),
      content: Text(
        AppLocalizations.of(dialogContext)!.projectResourceUnavailableMessage,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(
            AppLocalizations.of(dialogContext)!.workspacesCancelButton,
          ),
        ),
      ],
    ),
  );

  static Future<void> showCreateFolder(
    BuildContext context, {
    required String workspaceId,
    required String projectId,
    ProjectResourcesRepository? repository,
  }) {
    final resolved = repository ?? context.read<ProjectResourcesRepository?>();
    if (resolved == null) {
      return _showUnavailable(
        context,
        title: AppLocalizations.of(context)!.workspacesCreateFolderTitle,
      );
    }
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => CreateFolderDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: resolved,
      ),
    );
  }
}
