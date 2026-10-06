import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Obsługuje wyniki mutacji, bieżące zaznaczenie i trwałą informację zwrotną.
final class StorageFileMutationListener extends StatefulWidget {
  const StorageFileMutationListener({
    required this.onError,
    required this.child,
    super.key,
  });

  final ValueChanged<StorageMutationError> onError;
  final Widget child;

  @override
  State<StorageFileMutationListener> createState() =>
      _StorageFileMutationListenerState();
}

final class _StorageFileMutationListenerState
    extends State<StorageFileMutationListener> {
  late StorageFileMutationCubit _source;
  _MutationSelectionSnapshot? _selectionAtStart;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final source = context.watch<StorageFileMutationCubit>();
    if (identical(source, _sourceOrNull)) return;
    _source = source;
    _sourceInitialized = true;
    _selectionAtStart = null;
  }

  StorageFileMutationCubit? get _sourceOrNull =>
      _sourceInitialized ? _source : null;

  bool _sourceInitialized = false;

  @override
  void initState() {
    super.initState();
    _sourceInitialized = false;
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<StorageFileMutationCubit, StorageFileMutationState>(
        listener: _handleMutation,
        child: widget.child,
      );

  void _handleMutation(BuildContext context, StorageFileMutationState state) {
    if (_source.isClosed ||
        !identical(context.read<StorageFileMutationCubit>(), _source)) {
      _selectionAtStart = null;
      return;
    }
    final selection = context.read<StorageSelectionCubit>();
    final browser = context.read<StorageBrowserCubit>();
    if (state is StorageFileMutationLoading) {
      _selectionAtStart ??= _MutationSelectionSnapshot.capture(
        selection,
        browser,
      );
      return;
    }
    final snapshot = _takeSelectionSnapshot(selection, browser);
    // Wynik poprzedniego zakresu nie zmienia bieżącej listy ani komunikatów.
    if (snapshot == null) return;
    if (state is StorageFileMutationSuccess) {
      final affectedIds = switch (state.type) {
        StorageFileMutationType.bulkDeleted ||
        StorageFileMutationType.bulkRestored => {
          ...snapshot.fileIds,
          ...snapshot.folderIds,
        },
        StorageFileMutationType.deleted ||
        StorageFileMutationType.sharedFileDismissed => {
          ..._singleRemovedIds(state, snapshot),
        },
        _ => <String>{},
      };
      selection.removeSelectedIds(affectedIds);
      unawaited(browser.load(showLoading: false));
      if (state.type == StorageFileMutationType.sharedFileDismissed) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.l10n.storageDismissFromSharedSuccess),
            ),
          );
      }
      return;
    }

    if (state is StorageFileMutationPartialSuccess) {
      final itemLabels = snapshot.itemLabels;
      selection.removeSelectedIds(
        state.succeededIds.where(snapshot.contains).toSet(),
      );
      unawaited(browser.load(showLoading: false));
      widget.onError(
        StorageMutationError(
          message: switch (state.messageCode) {
            StorageFileMutationMessage.partialDelete =>
              context.l10n.storagePartialDeleteFailed,
            StorageFileMutationMessage.partialRestore =>
              context.l10n.storagePartialRestoreFailed,
            StorageFileMutationMessage.partialMove =>
              context.l10n.storagePartialMoveFailed,
            _ => state.errorMessage,
          },
          code: state.apiError?.apiCode,
          traceId: state.apiError?.traceId,
          apiErrorsById: state.apiErrorsById,
          notAttemptedIds: state.notAttemptedIds,
          itemLabels: itemLabels,
        ),
      );
      return;
    }

    if (state case StorageFileMutationFailure(
      :final apiErrorsById,
      :final notAttemptedIds,
      :final apiError,
    )) {
      final itemLabels = snapshot.itemLabels;
      widget.onError(
        StorageMutationError(
          message: _failureMessage(context, state),
          code: apiError?.apiCode ?? state.apiCode,
          traceId: apiError?.traceId ?? state.traceId,
          apiErrorsById: apiErrorsById,
          notAttemptedIds: notAttemptedIds,
          itemLabels: itemLabels,
          onRetry: _retryFor(context, state, snapshot),
        ),
      );
    }
  }

  _MutationSelectionSnapshot? _takeSelectionSnapshot(
    StorageSelectionCubit selection,
    StorageBrowserCubit browser,
  ) {
    final snapshot = _selectionAtStart;
    _selectionAtStart = null;
    if (snapshot == null ||
        snapshot.selection.isClosed ||
        snapshot.browser.isClosed ||
        !identical(snapshot.selection, selection) ||
        !identical(snapshot.browser, browser) ||
        snapshot.scope != browser.currentScope) {
      return null;
    }
    return snapshot;
  }

  Set<String> _singleRemovedIds(
    StorageFileMutationSuccess state,
    _MutationSelectionSnapshot? snapshot,
  ) {
    if (snapshot == null) return const {};
    final ids = <String>{};
    final fileId = state.fileId;
    final returnedId = state.file?.id;
    if (fileId != null && snapshot.contains(fileId)) {
      ids.add(fileId);
    }
    if (returnedId != null && snapshot.contains(returnedId)) {
      ids.add(returnedId);
    }
    return ids;
  }

  String _failureMessage(
    BuildContext context,
    StorageFileMutationFailure state,
  ) => switch (state.messageCode) {
    StorageFileMutationMessage.deleteFailed =>
      context.l10n.storageDeleteSelectedFailed,
    _ => switch (state.apiCode) {
      'storage.action_busy' => context.l10n.storageActionBusy,
      'storage.action_canceled' => context.l10n.storageActionCanceled,
      'storage.action_failed' => context.l10n.storageActionFailed,
      _ => state.message,
    },
  };

  VoidCallback? _retryFor(
    BuildContext context,
    StorageFileMutationFailure state,
    _MutationSelectionSnapshot snapshot,
  ) {
    if (state.messageCode != StorageFileMutationMessage.placementConflict) {
      return null;
    }
    final cubit = context.read<StorageFileMutationCubit>();
    return () {
      if (!context.mounted ||
          cubit.isClosed ||
          !identical(context.read<StorageFileMutationCubit>(), cubit) ||
          !identical(cubit.state, state) ||
          snapshot.selection.isClosed ||
          snapshot.browser.isClosed ||
          !identical(
            context.read<StorageSelectionCubit>(),
            snapshot.selection,
          ) ||
          !identical(context.read<StorageBrowserCubit>(), snapshot.browser) ||
          snapshot.browser.currentScope != snapshot.scope) {
        return;
      }
      unawaited(cubit.retryPlacementMove());
    };
  }
}

final class _MutationSelectionSnapshot {
  const _MutationSelectionSnapshot({
    required this.selection,
    required this.browser,
    required this.fileIds,
    required this.folderIds,
    required this.itemLabels,
    required this.scope,
  });

  factory _MutationSelectionSnapshot.capture(
    StorageSelectionCubit selection,
    StorageBrowserCubit browser,
  ) => _MutationSelectionSnapshot(
    selection: selection,
    browser: browser,
    fileIds: Set.unmodifiable(selection.state.selectedFileIds),
    folderIds: Set.unmodifiable(selection.state.selectedFolderIds),
    itemLabels: selection.selectedItemLabels,
    scope: browser.currentScope,
  );

  final StorageSelectionCubit selection;
  final StorageBrowserCubit browser;
  final Set<String> fileIds;
  final Set<String> folderIds;
  final Map<String, String> itemLabels;

  final StorageScope scope;

  bool contains(String id) => fileIds.contains(id) || folderIds.contains(id);
}
