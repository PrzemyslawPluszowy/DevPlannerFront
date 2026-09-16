import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:ready_next/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_scope.dart';
import 'package:ready_next/workspaces/domain/storage/ports/download_transport.dart';
import 'package:ready_next/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/grid/storage_file_grid.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/grid/storage_folder_grid.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/list/storage_file_rows.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/list/storage_folder_rows.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_state.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/selection/storage_keyboard_shortcuts.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/selection/storage_selection_toolbar.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/storage_browser_header.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/toolbar/storage_browser_toolbar.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_sidebar.dart';
import 'package:ready_next/workspaces/presentation/storage/shell/storage_status_views.dart';
import 'package:ready_next/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/upload/cubit/storage_upload_state.dart';
import 'package:ready_next/workspaces/presentation/storage/upload/widgets/storage_upload_queue_overlay.dart';

/// Główny shell widoku modułu Files (Universal Storage Engine).
///
/// Integruje drzewo odpowiedzialności:
/// - Sidebar nawigacyjny (Moje pliki, Udostępnione, Ostatnie, Ulubione, Kosz)
/// - Górny nagłówek (kontekst i akcje nadrzędne)
/// - Pasek narzędziowy (okruszki, szukaj, sortowanie, widok)
/// - Pasek zaznaczenia masowego (Bulk toolbar)
/// - Ciało eksploratora (siatka lub lista folderów i plików, stan pusty, ładowanie, błąd)
/// - Pływająca kolejka uploadu plików (Overlay)
class StorageShellPage extends StatelessWidget {
  /// Tworzy shell plików z opcjonalnym początkowym zakresem i wstrzykiwanymi portami.
  const StorageShellPage({
    this.initialScope = const StorageScope.personal(),
    this.storageRepository,
    this.downloadTransport,
    this.uploadTransport,
    super.key,
  });

  /// Początkowy zakres biznesowy.
  final StorageScope initialScope;

  /// Opcjonalne repozytorium (jeśli null, pobierane z context.read).
  final StorageRepository? storageRepository;

  /// Opcjonalny transport pobierania.
  final DownloadTransport? downloadTransport;

  /// Opcjonalny transport wysyłania.
  final UploadTransport? uploadTransport;

  @override
  Widget build(BuildContext context) {
    final effectiveRepository =
        storageRepository ?? context.read<StorageRepository>();
    final effectiveDownload =
        downloadTransport ?? const DownloadTransportImpl();
    final effectiveUpload = uploadTransport ?? PresignedUploadTransport();
    final routedScope = StorageScopeRouteCodec.contextualScope(
      initialScope,
      StorageScopeRouteCodec.routeUri(context),
    );

    return MultiBlocProvider(
      key: ValueKey(routedScope),
      providers: [
        BlocProvider<StorageBrowserCubit>(
          create: (_) {
            final cubit = StorageBrowserCubit(
              repository: effectiveRepository,
              initialScope: routedScope,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider<StorageSelectionCubit>(
          create: (_) => StorageSelectionCubit(),
        ),
        BlocProvider<StorageFolderMutationCubit>(
          create: (_) => StorageFolderMutationCubit(
            repository: effectiveRepository,
          ),
        ),
        BlocProvider<StorageDocumentMutationCubit>(
          create: (_) => StorageDocumentMutationCubit(
            repository: effectiveRepository,
          ),
        ),
        BlocProvider<StorageFileMutationCubit>(
          create: (_) => StorageFileMutationCubit(
            repository: effectiveRepository,
            downloadTransport: effectiveDownload,
          ),
        ),
        BlocProvider<StorageUploadCubit>(
          create: (_) => StorageUploadCubit(
            repository: effectiveRepository,
            uploadTransport: effectiveUpload,
          ),
        ),
        BlocProvider<StoragePreviewCubit>(
          create: (_) => StoragePreviewCubit(
            repository: effectiveRepository,
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],
      child: const _StorageShellView(),
    );
  }
}

class _StorageShellView extends StatelessWidget {
  const _StorageShellView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) =>
              _StorageStateScope.read(previous) !=
              _StorageStateScope.read(current),
          listener: (context, state) {
            final currentUri = StorageScopeRouteCodec.routeUri(context);
            if (currentUri == null) return;
            final location = StorageScopeRouteCodec.contextualLocation(
              _StorageStateScope.read(state),
              currentUri,
            );
            if (location != null && currentUri.toString() != location) {
              context.go(location);
            }
          },
        ),
        BlocListener<StorageFileMutationCubit, StorageFileMutationState>(
          listener: (context, state) {
            if (state is StorageFileMutationSuccess ||
                state is StorageFileMutationPartialSuccess) {
              context.read<StorageSelectionCubit>().clearSelection();
              unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              );
            }
            if (state is StorageFileMutationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(switch (state.messageCode) {
                    StorageFileMutationMessage.deleteFailed =>
                      context.l10n.storageDeleteSelectedFailed,
                    _ => state.message,
                  }),
                ),
              );
            } else if (state is StorageFileMutationPartialSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(switch (state.messageCode) {
                    StorageFileMutationMessage.partialDelete =>
                      context.l10n.storagePartialDeleteFailed,
                    _ => state.errorMessage,
                  }),
                ),
              );
            }
          },
        ),
        BlocListener<StorageFolderMutationCubit, StorageFolderMutationState>(
          listener: (context, state) {
            if (state is StorageFolderMutationSuccess) {
              unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              );
            } else if (state is StorageFolderMutationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<
          StorageDocumentMutationCubit,
          StorageDocumentMutationState
        >(
          listener: (context, state) {
            if (state is StorageDocumentMutationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.storageCreateDocumentSuccess),
                ),
              );
              unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              );
              unawaited(
                context.read<StoragePreviewCubit>().preparePreview(state.file),
              );
              unawaited(
                showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<StoragePreviewCubit>(),
                    child: StoragePreviewDialog(file: state.file),
                  ),
                ),
              );
            } else if (state is StorageDocumentMutationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<StorageUploadCubit, StorageUploadState>(
          listenWhen: (previous, current) =>
              current.completedCount > previous.completedCount,
          listener: (context, state) => unawaited(
            context.read<StorageBrowserCubit>().load(showLoading: false),
          ),
        ),
      ],
      child: BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
        buildWhen: (previous, current) =>
            _StorageStateScope.read(previous).folderId !=
            _StorageStateScope.read(current).folderId,
        builder: (context, state) {
          final scope = _StorageStateScope.read(state);
          final returnTo = StorageScopeRouteCodec.returnLocation(
            StorageScopeRouteCodec.routeUri(context),
          );
          return PopScope(
            canPop: scope.folderId == null && returnTo == null,
            onPopInvokedWithResult: (didPop, _) {
              if (didPop) return;
              if (scope.folderId != null) {
                unawaited(context.read<StorageBrowserCubit>().navigateUp());
              } else if (returnTo != null) {
                context.go(returnTo);
              }
            },
            child: StorageKeyboardShortcuts(
              child: Scaffold(
                backgroundColor: context.colors.surface,
                body: const Stack(
                  children: [
                    _StorageResponsiveContent(),
                    StorageUploadQueueOverlay(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StorageResponsiveContent extends StatelessWidget {
  const _StorageResponsiveContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactSidebar = constraints.maxWidth < 900;
        return Row(
          children: [
            StorageSidebar(compact: compactSidebar),
            const Expanded(
              child: Column(
                children: [
                  StorageBrowserHeader(),
                  StorageBrowserToolbar(),
                  StorageSelectionToolbar(),
                  Expanded(child: _StorageBrowserBody()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

final class _StorageStateScope {
  const _StorageStateScope._();

  static StorageScope read(StorageBrowserState state) => switch (state) {
    StorageBrowserInitial(:final scope) => scope,
    StorageBrowserLoading(:final scope) => scope,
    StorageBrowserReady(:final scope) => scope,
    StorageBrowserEmpty(:final scope) => scope,
    StorageBrowserFailure(:final scope) => scope,
    StorageBrowserForbidden(:final scope) => scope,
  };
}

class _StorageBrowserBody extends StatefulWidget {
  const _StorageBrowserBody();

  @override
  State<_StorageBrowserBody> createState() => _StorageBrowserBodyState();
}

class _StorageBrowserBodyState extends State<_StorageBrowserBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreNearEnd);
  }

  void _loadMoreNearEnd() {
    if (_scrollController.position.extentAfter < 480) {
      unawaited(context.read<StorageBrowserCubit>().loadNextPage());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMoreNearEnd)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
      builder: (context, state) => switch (state) {
        StorageBrowserInitial() || StorageBrowserLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        StorageBrowserEmpty() => const StorageEmptyView(),
        StorageBrowserFailure(:final message) => StorageErrorView(
          message: message,
        ),
        StorageBrowserForbidden(:final message) => StorageForbiddenView(
          message: message,
        ),
        StorageBrowserReady(
          :final folders,
          :final files,
          :final viewMode,
        ) =>
          _buildContent(context, folders, files, viewMode),
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<StorageFolderResponse> folders,
    List<StorageFileResponse> files,
    StorageViewMode viewMode,
  ) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      child: viewMode == StorageViewMode.grid
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StorageFolderGrid(folders: folders),
                if (folders.isNotEmpty && files.isNotEmpty)
                  const SizedBox(height: 20),
                StorageFileGrid(files: files),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StorageFolderRows(folders: folders),
                if (folders.isNotEmpty && files.isNotEmpty)
                  const SizedBox(height: 12),
                StorageFileRows(files: files),
              ],
            ),
    );
  }
}
