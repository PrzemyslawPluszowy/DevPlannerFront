import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/shell/panels/app_global_panels_scope.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:ready_next/workspaces/domain/models/project_resource_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/chat/resource/cubit/resource_chat_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/workspace_project_resource_catalog_page.dart';
import 'package:ready_next/workspaces/presentation/projects/workspace_projects_page.dart';
import 'package:ready_next/workspaces/presentation/routing/workspace_resource_detail_pages.dart';
import 'package:ready_next/workspaces/presentation/routing/workspace_section_landing.dart';
import 'package:ready_next/workspaces/presentation/storage/cubit/storage_file_details_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/cubit/storage_file_details_state.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_feature_wrapper.dart';

// Eksport utrzymuje jeden publiczny import tras dla AppRouter i generatora.
export 'workspace_resource_detail_pages.dart';

/// Bezpieczny punkt wejścia z globalnych powiadomień do pliku Storage.
/// Szczegóły pliku są ładowane przez docelowy moduł Storage; routing nie
/// pokazuje już technicznego UnknownModulePage przy bezpośrednim deep linku.
class StorageFilePage extends StatelessWidget {
  const StorageFilePage({required this.fileId, super.key});

  final String fileId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = StorageFileDetailsCubit(
        repository: context.read<StorageRepository>(),
        fileId: fileId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: BlocBuilder<StorageFileDetailsCubit, StorageFileDetailsState>(
      builder: (context, state) => WorkspaceFeatureWrapper(
        title: switch (state) {
          StorageFileDetailsLoaded(:final details) =>
            details.file.originalFileName,
          _ => 'Szczegóły pliku',
        },
        icon: Symbols.insert_drive_file,
        subtitle: 'Przechowalnia plików Storage',
        isLoading:
            state is StorageFileDetailsInitial ||
            state is StorageFileDetailsLoading,
        errorMessage: switch (state) {
          StorageFileDetailsFailure(:final message, :final backendCode) =>
            backendCode == null ? message : '$message (kod: $backendCode)',
          _ => null,
        },
        onRetry: () =>
            unawaited(context.read<StorageFileDetailsCubit>().load()),
        // Szczegół pliku ma własny ListView; drugi scroll view dawałby mu
        // nieograniczoną wysokość i psuł renderowanie w shellu.
        scrollable: false,
        child: switch (state) {
          StorageFileDetailsLoaded(:final details) => _StorageFileDetails(
            details: details,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    ),
  );
}

class _StorageFileDetails extends StatelessWidget {
  const _StorageFileDetails({required this.details});

  final StorageFileDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<ResourceChatRepository?>();
    final canOfferResourceChat =
        repository != null &&
        details.permissions.canRead &&
        details.permissions.accessLevel != StorageEffectiveAccessLevel.none &&
        details.canOpenResourceChat;
    if (repository == null) {
      return _StorageFileDetailsBody(
        details: details,
        canOfferResourceChat: false,
      );
    }
    return BlocProvider(
      create: (context) => ResourceChatCubit(repository),
      child: _StorageFileDetailsBody(
        details: details,
        canOfferResourceChat: canOfferResourceChat,
      ),
    );
  }
}

class _StorageFileDetailsBody extends StatelessWidget {
  const _StorageFileDetailsBody({
    required this.details,
    required this.canOfferResourceChat,
  });

  final StorageFileDetailsResponse details;
  final bool canOfferResourceChat;

  @override
  Widget build(BuildContext context) {
    final file = details.file;
    final resourceChatRequest = ResourceChatFileRequest(
      fileId: file.id,
      workspaceId: file.workspaceId,
      projectId: file.projectId,
      fileContext: ResourceChatFileContext(
        fileId: file.id,
        fileName: file.originalFileName,
        ownerUserId: file.ownerUserId,
        accessLevel: details.permissions.accessLevel.name,
      ),
    );
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          file.originalFileName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(file.manualDescription ?? 'Brak opisu pliku.'),
        const SizedBox(height: 24),
        ListTile(title: const Text('Typ'), subtitle: Text(file.mimeType)),
        ListTile(
          title: const Text('Rozmiar'),
          subtitle: Text('${file.fileSizeBytes} B · wersja ${file.version}'),
        ),
        if (canOfferResourceChat)
          BlocConsumer<ResourceChatCubit, ResourceChatState>(
            listener: (context, state) {
              if (state case ResourceChatResolved(:final openRequest)) {
                AppGlobalPanelsScope.openResourceConversationOf(
                  context,
                )?.call(openRequest);
              }
              if (state is ResourceChatDenied) {
                // Szczegóły mogły zostać unieważnione między ich pobraniem a
                // resolve. Ponowny odczyt wymusza reautoryzację Storage i
                // natychmiast usuwa poprzedni, prywatny snapshot z widoku.
                unawaited(context.read<StorageFileDetailsCubit>().load());
              }
            },
            builder: (context, state) => ListTile(
              leading: const Icon(Symbols.chat),
              title: Text(context.l10n.resourceChatFileAction),
              subtitle: switch (state) {
                ResourceChatDenied(:final message) ||
                ResourceChatFailure(:final message) => Text(message),
                _ => Text(context.l10n.resourceChatFileDescription),
              },
              trailing: state is ResourceChatResolving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: state is ResourceChatResolving
                  ? null
                  : () => context.read<ResourceChatCubit>().resolveFile(
                      resourceChatRequest,
                    ),
            ),
          ),
        ListTile(
          title: const Text('Uprawnienia'),
          subtitle: Text(
            'Odczyt: ${file.canRead ? 'tak' : 'nie'} · '
            'Edycja: ${details.canEdit ? 'tak' : 'nie'} · '
            'Udostępnianie: ${file.canShare ? 'tak' : 'nie'}',
          ),
        ),
        if (details.versions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Historia wersji',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final version in details.versions)
            ListTile(
              dense: true,
              title: Text('Wersja ${version.version}'),
              subtitle: Text(version.changeSummary ?? 'Bez opisu zmiany'),
            ),
        ],
      ],
    );
  }
}

/// Kontekst wybranego workspace'u.
///
/// Parametr pochodzi bezpośrednio z URL, dlatego wejście z powiadomienia,
/// odświeżenie przeglądarki i otwarcie nowej karty zachowują ten sam kontekst.
class WorkspaceContextPage extends StatelessWidget {
  const WorkspaceContextPage({
    required this.workspaceId,
    super.key,
  });

  final String workspaceId;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Kontekst wybranego projektu w workspace.
class WorkspaceProjectContextPage extends StatelessWidget {
  const WorkspaceProjectContextPage({
    required this.workspaceId,
    required this.projectId,
    super.key,
  });

  final String workspaceId;
  final String projectId;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// Ekran sekcji workspace'u; docelową zawartość dostarczy moduł sekcji.
class WorkspaceSectionPage extends StatelessWidget {
  const WorkspaceSectionPage({
    required this.workspaceId,
    required this.section,
    super.key,
  });

  final String workspaceId;
  final String section;

  @override
  Widget build(BuildContext context) => section == 'projects'
      ? WorkspaceProjectsPageView(workspaceId: workspaceId)
      : WorkspaceSectionLanding(workspaceId: workspaceId, section: section);
}

/// Parametryczna sekcja workspace'u dla ścieżek innych niż strona główna.
class WorkspaceDynamicSectionPage extends StatelessWidget {
  const WorkspaceDynamicSectionPage({
    required this.workspaceId,
    required this.section,
    super.key,
  });

  final String workspaceId;
  final String section;

  @override
  Widget build(BuildContext context) => _workspaceSections.contains(section)
      ? WorkspaceSectionLanding(workspaceId: workspaceId, section: section)
      : const WorkspaceRouteNotFoundPage();
}

/// Sekcja projektu, np. zadania, Kanban, pliki albo wiki.
class WorkspaceProjectSectionPage extends StatelessWidget {
  const WorkspaceProjectSectionPage({
    required this.workspaceId,
    required this.projectId,
    required this.resourceKind,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String resourceKind;

  @override
  Widget build(BuildContext context) {
    if (!_projectSections.contains(resourceKind)) {
      return const WorkspaceRouteNotFoundPage();
    }
    if (resourceKind == 'tasks' || resourceKind == 'kanban') {
      return TasksBoardPage(workspaceId: workspaceId, projectId: projectId);
    }
    final kind = switch (resourceKind) {
      'whiteboards' => ProjectResourceKind.whiteboards,
      'wiki' => ProjectResourceKind.wiki,
      'files' => ProjectResourceKind.files,
      'automations' => ProjectResourceKind.automations,
      _ => null,
    };
    return kind == null
        ? const WorkspaceRouteNotFoundPage()
        : WorkspaceProjectResourceCatalogPage(
            workspaceId: workspaceId,
            projectId: projectId,
            kind: kind,
          );
  }
}

const _workspaceSections = <String>{
  'projects',
  'files',
  'wiki',
  'activity',
  'members',
  'settings',
  'invitations',
  'okr',
};

const _projectSections = <String>{
  'overview',
  'tasks',
  'kanban',
  'whiteboards',
  'files',
  'wiki',
  'members',
  'settings',
  'automations',
  'corkboard',
  'dashboard',
};
