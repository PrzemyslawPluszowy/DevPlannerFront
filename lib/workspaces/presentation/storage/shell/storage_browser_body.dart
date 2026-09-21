import 'dart:async';

import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/grid/storage_file_grid.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/grid/storage_folder_grid.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/list/storage_file_rows.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/list/storage_folder_rows.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_status_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ciało eksploratora, które posiada wyłącznie lifecycle kontrolera przewijania.
final class StorageBrowserBody extends StatefulWidget {
  const StorageBrowserBody({
    this.capabilities = StorageShellCapabilities.readOnly,
    this.onOpenFileDetails,
    super.key,
  });

  /// Uprawnienia kompozycji przekazywane do wierszy i kafelków.
  final StorageShellCapabilities capabilities;

  /// Nawigacja do szczegółów pliku, jeśli trasa ją wystawia.
  final ValueChanged<String>? onOpenFileDetails;

  @override
  State<StorageBrowserBody> createState() => _StorageBrowserBodyState();
}

final class _StorageBrowserBodyState extends State<StorageBrowserBody> {
  final _scrollController = ScrollController();

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
  Widget build(BuildContext context) =>
      BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
        builder: (context, state) => switch (state) {
          StorageBrowserInitial() || StorageBrowserLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          StorageBrowserEmpty() => const StorageEmptyView(),
          // Błąd zakresu należy do trwałego bannera w chrome'ie: on pokazuje
          // komunikat, kod, traceId oraz Ponów i Odśwież. Ciało nie powtarza
          // tego samego komunikatu drugi raz.
          StorageBrowserFailure() => const SizedBox.shrink(),
          StorageBrowserForbidden(:final message) => StorageForbiddenView(
            message: message,
          ),
          StorageBrowserReady(
            :final folders,
            :final files,
            :final viewMode,
          ) =>
            _StorageBrowserContent(
              controller: _scrollController,
              folders: folders,
              files: files,
              viewMode: viewMode,
              capabilities: widget.capabilities,
              onOpenFileDetails: widget.onOpenFileDetails,
            ),
        },
      );
}

final class _StorageBrowserContent extends StatelessWidget {
  const _StorageBrowserContent({
    required this.controller,
    required this.folders,
    required this.files,
    required this.viewMode,
    required this.capabilities,
    required this.onOpenFileDetails,
  });

  final ScrollController controller;
  final List<StorageFolderResponse> folders;
  final List<StorageFileResponse> files;
  final StorageViewMode viewMode;
  final StorageShellCapabilities capabilities;
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: controller,
    padding: const EdgeInsets.all(20),
    child: viewMode == StorageViewMode.grid
        ? _StorageBrowserGridContent(
            folders: folders,
            files: files,
            capabilities: capabilities,
            onOpenFileDetails: onOpenFileDetails,
          )
        : _StorageBrowserListContent(
            folders: folders,
            files: files,
            capabilities: capabilities,
            onOpenFileDetails: onOpenFileDetails,
          ),
  );
}

final class _StorageBrowserGridContent extends StatelessWidget {
  const _StorageBrowserGridContent({
    required this.folders,
    required this.files,
    required this.capabilities,
    required this.onOpenFileDetails,
  });

  final List<StorageFolderResponse> folders;
  final List<StorageFileResponse> files;
  final StorageShellCapabilities capabilities;
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StorageFolderGrid(folders: folders, capabilities: capabilities),
      if (folders.isNotEmpty && files.isNotEmpty) const SizedBox(height: 20),
      StorageFileGrid(
        files: files,
        capabilities: capabilities,
        onOpenFileDetails: onOpenFileDetails,
      ),
    ],
  );
}

final class _StorageBrowserListContent extends StatelessWidget {
  const _StorageBrowserListContent({
    required this.folders,
    required this.files,
    required this.capabilities,
    required this.onOpenFileDetails,
  });

  final List<StorageFolderResponse> folders;
  final List<StorageFileResponse> files;
  final StorageShellCapabilities capabilities;
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StorageFolderRows(folders: folders, capabilities: capabilities),
      if (folders.isNotEmpty && files.isNotEmpty) const SizedBox(height: 12),
      StorageFileRows(
        files: files,
        capabilities: capabilities,
        onOpenFileDetails: onOpenFileDetails,
      ),
    ],
  );
}
