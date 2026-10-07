import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_context.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/resource/cubit/resource_chat_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_file_details_metadata.dart';
import 'package:devplanner/workspaces/presentation/storage/cubit/storage_file_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/cubit/storage_file_details_state.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
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
    child: _StorageFileDetailsView(repository: repository),
  );
}

final class _StorageFileDetailsView extends StatelessWidget {
  const _StorageFileDetailsView({required this.repository});

  final StorageRepository repository;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageFileDetailsCubit, StorageFileDetailsState>(
        builder: (context, state) => switch (state) {
          StorageFileDetailsInitial() || StorageFileDetailsLoading() =>
            const Center(child: CircularProgressIndicator.adaptive()),
          StorageFileDetailsFailure(:final message) =>
            _StorageFileDetailsFailure(message: message),
          StorageFileDetailsLoaded(:final details) =>
            _StorageFileDetailsContent(
              details: details,
              repository: repository,
            ),
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
            Semantics(
              liveRegion: true,
              child: Text(message, textAlign: TextAlign.center),
            ),
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
  const _StorageFileDetailsContent({
    required this.details,
    required this.repository,
  });

  final StorageRepository repository;

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

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1040),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            StorageFileDetailsMetadata(details: details),
            if (details.permissions.canRead &&
                file.canEditOnline &&
                !file.isDeleted)
              _StorageFileOpenDocumentAction(
                file: file,
                repository: repository,
              ),
            if (canOpenResourceChat)
              _StorageFileResourceChatAction(
                file: file,
                repository: resourceRepository,
              ),
            const SizedBox(height: 24),
            StorageFileDetailsHistory(details: details),
          ],
        ),
      ),
    );
  }
}

/// Rozstrzyga czat tylko z aktualnego, zweryfikowanego snapshotu szczegółu.
final class _StorageFileResourceChatAction extends StatelessWidget {
  const _StorageFileResourceChatAction({
    required this.file,
    required this.repository,
  });

  final StorageFileResponse file;
  final ResourceChatRepository repository;

  void _resolve(BuildContext context) =>
      context.read<ResourceChatCubit>().resolveFile(
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
      );

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
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (state case ResourceChatFailure(:final error))
            StorageErrorBanner(
              message: error.message.isEmpty
                  ? context.l10n.storageActionFailed
                  : error.message,
              code: error.contractCode ?? error.apiCode,
              traceId: error.traceId,
              retryAfterUtc: error.retryAfterUtc,
              onRetry: () => _resolve(context),
              onRefresh: () => context.read<StorageFileDetailsCubit>().load(),
            ),
          ListTile(
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
                : () => _resolve(context),
          ),
        ],
      ),
    ),
  );
}

/// Opens the existing Office surface and refreshes the permission snapshot.
final class _StorageFileOpenDocumentAction extends StatefulWidget {
  const _StorageFileOpenDocumentAction({
    required this.file,
    required this.repository,
  });

  final StorageFileResponse file;
  final StorageRepository repository;

  @override
  State<_StorageFileOpenDocumentAction> createState() =>
      _StorageFileOpenDocumentActionState();
}

final class _StorageFileOpenDocumentActionState
    extends State<_StorageFileOpenDocumentAction> {
  final ValueNotifier<bool> _opening = ValueNotifier(false);

  @override
  void dispose() {
    _opening.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    if (_opening.value) return;
    _opening.value = true;
    final cubit = context.read<StorageFileDetailsCubit>();
    try {
      await StorageOfficeEditorDialog.show(
        context,
        file: widget.file,
        repository: widget.repository,
      );
      if (!mounted) return;
      await cubit.load();
    } finally {
      if (mounted) _opening.value = false;
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Align(
      alignment: Alignment.centerLeft,
      child: ValueListenableBuilder<bool>(
        valueListenable: _opening,
        builder: (context, opening, child) => FilledButton.tonalIcon(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                context.tasksTheme.controlRadius,
              ),
            ),
          ),
          onPressed: opening ? null : _open,
          icon: const Icon(Symbols.description_rounded, size: 18),
          label: Text(context.l10n.storageOpenOfficeAction),
        ),
      ),
    ),
  );
}
