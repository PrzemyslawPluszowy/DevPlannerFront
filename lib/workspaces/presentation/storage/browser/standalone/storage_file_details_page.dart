import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/resource/cubit/resource_chat_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/cubit/storage_file_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/cubit/storage_file_details_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Aktywny szczegół pliku w standalone Files.
///
/// Każde wejście odczytuje świeży snapshot uprawnień przez Cubit. Dzięki temu
/// Resource Chat nie bazuje na danych listy ani na uprzednio zapisanym dostępie.
final class StorageFileDetailsPage extends StatelessWidget {
  const StorageFileDetailsPage({
    required this.repository,
    required this.fileId,
    super.key,
  });

  final StorageRepository repository;
  final String fileId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final cubit = StorageFileDetailsCubit(
        repository: repository,
        fileId: fileId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: const _StorageFileDetailsView(),
  );
}

final class _StorageFileDetailsView extends StatelessWidget {
  const _StorageFileDetailsView();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageFileDetailsCubit, StorageFileDetailsState>(
        builder: (context, state) => switch (state) {
          StorageFileDetailsInitial() || StorageFileDetailsLoading() =>
            const Center(child: CircularProgressIndicator.adaptive()),
          StorageFileDetailsFailure(:final message, :final backendCode) =>
            _StorageFileDetailsFailure(
              message: backendCode == null
                  ? message
                  : '$message ($backendCode)',
            ),
          StorageFileDetailsLoaded(:final details) =>
            _StorageFileDetailsContent(details: details),
        },
      );
}

final class _StorageFileDetailsFailure extends StatelessWidget {
  const _StorageFileDetailsFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.error_outline_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () =>
                  unawaited(context.read<StorageFileDetailsCubit>().load()),
              child: Text(context.l10n.workspacesRetry),
            ),
          ],
        ),
      ),
    ),
  );
}

final class _StorageFileDetailsContent extends StatelessWidget {
  const _StorageFileDetailsContent({required this.details});

  final StorageFileDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    final file = details.file;
    final resourceRepository = context.read<ResourceChatRepository?>();
    final canOpenResourceChat =
        resourceRepository != null &&
        details.canOpenResourceChat &&
        details.permissions.canRead &&
        file.accessLevel != StorageEffectiveAccessLevel.none;

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
        _StorageFileDetailsProperty(label: 'Typ', value: file.mimeType),
        _StorageFileDetailsProperty(
          label: 'Rozmiar',
          value: '${file.fileSizeBytes} B · wersja ${file.version}',
        ),
        if (canOpenResourceChat)
          _StorageFileResourceChatAction(
            file: file,
            repository: resourceRepository,
          ),
        _StorageFileDetailsProperty(
          label: 'Uprawnienia',
          value:
              'Odczyt: ${file.canRead ? 'tak' : 'nie'} · '
              'Edycja: ${details.canEdit ? 'tak' : 'nie'} · '
              'Udostępnianie: ${file.canShare ? 'tak' : 'nie'}',
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

final class _StorageFileDetailsProperty extends StatelessWidget {
  const _StorageFileDetailsProperty({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label),
    subtitle: Text(value),
  );
}

/// Rozstrzyga czat tylko z aktualnego, zweryfikowanego snapshotu szczegółu.
final class _StorageFileResourceChatAction extends StatelessWidget {
  const _StorageFileResourceChatAction({
    required this.file,
    required this.repository,
  });

  final StorageFileResponse file;
  final ResourceChatRepository repository;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => ResourceChatCubit(repository),
    child: BlocConsumer<ResourceChatCubit, ResourceChatState>(
      listener: (context, state) {
        if (state case ResourceChatResolved(:final openRequest)) {
          DevPlannerPanelsScope.openResourceConversationOf(context)?.call(
            openRequest,
          );
        }
        if (state is ResourceChatDenied) {
          unawaited(context.read<StorageFileDetailsCubit>().load());
        }
      },
      builder: (context, state) => ListTile(
        leading: const Icon(Symbols.chat_bubble_outline_rounded),
        title: Text(context.l10n.resourceChatFileAction),
        subtitle: Text(context.l10n.resourceChatFileDescription),
        trailing: state is ResourceChatResolving
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : null,
        onTap: state is ResourceChatResolving
            ? null
            : () => context.read<ResourceChatCubit>().resolveFile(
                ResourceChatFileRequest(
                  fileId: file.id,
                  workspaceId: file.workspaceId,
                  projectId: file.projectId,
                  fileContext: ResourceChatFileContext(
                    fileId: file.id,
                    fileName: file.originalFileName,
                    ownerUserId: file.ownerUserId,
                    accessLevel: file.accessLevel.name,
                  ),
                ),
              ),
      ),
    ),
  );
}
