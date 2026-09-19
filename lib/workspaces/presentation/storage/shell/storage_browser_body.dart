import 'dart:async';

import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/grid/storage_file_grid.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/grid/storage_folder_grid.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/list/storage_file_rows.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/list/storage_folder_rows.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_status_views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Ciało eksploratora, które posiada wyłącznie lifecycle kontrolera przewijania.
final class StorageBrowserBody extends StatefulWidget {
  const StorageBrowserBody({super.key});

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
            _StorageBrowserContent(
              controller: _scrollController,
              folders: folders,
              files: files,
              viewMode: viewMode,
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
  });

  final ScrollController controller;
  final List<StorageFolderResponse> folders;
  final List<StorageFileResponse> files;
  final StorageViewMode viewMode;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    controller: controller,
    padding: const EdgeInsets.all(20),
    child: viewMode == StorageViewMode.grid
        ? _StorageBrowserGridContent(folders: folders, files: files)
        : _StorageBrowserListContent(folders: folders, files: files),
  );
}

final class _StorageBrowserGridContent extends StatelessWidget {
  const _StorageBrowserGridContent({
    required this.folders,
    required this.files,
  });

  final List<StorageFolderResponse> folders;
  final List<StorageFileResponse> files;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StorageFolderGrid(folders: folders),
      if (folders.isNotEmpty && files.isNotEmpty) const SizedBox(height: 20),
      StorageFileGrid(files: files),
    ],
  );
}

final class _StorageBrowserListContent extends StatelessWidget {
  const _StorageBrowserListContent({
    required this.folders,
    required this.files,
  });

  final List<StorageFolderResponse> folders;
  final List<StorageFileResponse> files;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StorageFolderRows(folders: folders),
      if (folders.isNotEmpty && files.isNotEmpty) const SizedBox(height: 12),
      StorageFileRows(files: files),
    ],
  );
}
