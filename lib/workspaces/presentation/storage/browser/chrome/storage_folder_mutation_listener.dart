import 'dart:async';

import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wynik mutacji aktualizuje tylko właściciela i zakres, w którym wystartowała.
final class StorageFolderMutationListener extends StatefulWidget {
  const StorageFolderMutationListener({
    required this.onError,
    required this.child,
    super.key,
  });
  final ValueChanged<StorageMutationError> onError;
  final Widget child;
  @override
  State<StorageFolderMutationListener> createState() =>
      _StorageFolderMutationListenerState();
}

final class _StorageFolderMutationListenerState
    extends State<StorageFolderMutationListener> {
  StorageFolderMutationCubit? _source;
  StorageBrowserCubit? _browser;
  StorageSelectionCubit? _selection;
  StorageScope? _scope;

  @override
  Widget build(BuildContext context) =>
      BlocListener<StorageFolderMutationCubit, StorageFolderMutationState>(
        listener: _handle,
        child: widget.child,
      );

  void _handle(BuildContext context, StorageFolderMutationState state) {
    final source = context.read<StorageFolderMutationCubit>();
    final browser = context.read<StorageBrowserCubit>();
    final selection = context.read<StorageSelectionCubit>();
    if (state is StorageFolderMutationLoading) {
      _source = source;
      _browser = browser;
      _selection = selection;
      _scope = browser.currentScope;
      return;
    }
    final current =
        identical(_source, source) &&
        identical(_browser, browser) &&
        identical(_selection, selection) &&
        !source.isClosed &&
        !browser.isClosed &&
        !selection.isClosed &&
        _scope == browser.currentScope;
    _source = null;
    _browser = null;
    _selection = null;
    _scope = null;
    if (!current) return;
    if (state is StorageFolderMutationSuccess) {
      if (state.type == StorageFolderMutationType.restored ||
          state.type == StorageFolderMutationType.deleted) {
        final id = state.folderId;
        if (id != null) selection.removeSelectedIds({id});
      }
      unawaited(browser.load(showLoading: false));
    } else if (state is StorageFolderMutationFailure &&
        !state.presentedLocally) {
      widget.onError(
        StorageMutationError(
          message: state.message,
          code: state.apiCode,
          traceId: state.traceId,
          apiError: state.error,
        ),
      );
    }
  }
}
