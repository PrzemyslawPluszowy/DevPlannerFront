import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/ports/storage_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_mutation_listener.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_view_preference_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Obsługuje zmianę zakresu, mutacje folderów i dokumentów oraz preferencje.
final class StorageShellListeners extends StatelessWidget {
  const StorageShellListeners({
    required this.routedScope,
    required this.viewPreferenceStore,
    required this.onMutationError,
    required this.onScopeChanged,
    required this.child,
    super.key,
  });

  final StorageScope routedScope;
  final StorageViewPreferenceStore? viewPreferenceStore;
  final ValueChanged<StorageMutationError> onMutationError;
  final ValueChanged<StorageScope> onScopeChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) => _StorageDocumentMutationListener(
    routedScope: routedScope,
    onMutationError: onMutationError,
    child: MultiBlocListener(
      listeners: [
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) =>
              StorageShellStateScope.read(previous) !=
              StorageShellStateScope.read(current),
          listener: (context, state) {
            final currentUri = StorageScopeRouteCodec.routeUri(context);
            if (currentUri == null) return;
            final location = StorageScopeRouteCodec.contextualLocation(
              StorageShellStateScope.read(state),
              currentUri,
            );
            if (location != null && currentUri.toString() != location) {
              context.go(location);
            }
          },
        ),
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) =>
              StorageShellStateScope.read(previous) !=
              StorageShellStateScope.read(current),
          listener: (context, state) =>
              onScopeChanged(StorageShellStateScope.read(state)),
        ),
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) =>
              StorageShellStateScope.read(previous) !=
              StorageShellStateScope.read(current),
          listener: _restoreScopePreference,
        ),
        BlocListener<StorageBrowserCubit, StorageBrowserState>(
          listenWhen: (previous, current) {
            final next = StorageViewPreferenceProjection.read(current);
            return next != null &&
                next != StorageViewPreferenceProjection.read(previous);
          },
          listener: _persistUserPreference,
        ),
        BlocListener<StorageUploadCubit, StorageUploadState>(
          listenWhen: (previous, current) =>
              current.completedCount > previous.completedCount,
          listener: (context, state) => unawaited(
            context.read<StorageBrowserCubit>().load(showLoading: false),
          ),
        ),
      ],
      child: StorageFolderMutationListener(
        onError: onMutationError,
        child: child,
      ),
    ),
  );

  void _restoreScopePreference(
    BuildContext context,
    StorageBrowserState state,
  ) {
    final store = viewPreferenceStore;
    if (store == null) return;
    final stored =
        store.preferenceFor(
          scopeKey: StorageViewPreferenceScope.keyOf(
            StorageShellStateScope.read(state),
          ),
        ) ??
        StorageViewPreference.defaults;
    final cubit = context.read<StorageBrowserCubit>();
    cubit.setViewMode(stored.viewMode);
    cubit.setSort(stored.sort);
    cubit.setDensity(stored.density);
  }

  void _persistUserPreference(BuildContext context, StorageBrowserState state) {
    final store = viewPreferenceStore;
    final preference = StorageViewPreferenceProjection.read(state);
    if (store == null || preference == null) return;
    unawaited(
      store.write(
        scopeKey: StorageViewPreferenceScope.keyOf(routedScope),
        preference: preference,
      ),
    );
  }
}

final class _StorageDocumentMutationListener extends StatefulWidget {
  const _StorageDocumentMutationListener({
    required this.routedScope,
    required this.onMutationError,
    required this.child,
  });

  final StorageScope routedScope;
  final ValueChanged<StorageMutationError> onMutationError;
  final Widget child;

  @override
  State<_StorageDocumentMutationListener> createState() =>
      _StorageDocumentMutationListenerState();
}

final class _StorageDocumentMutationListenerState
    extends State<_StorageDocumentMutationListener> {
  StorageDocumentMutationCubit? _documentCubit;
  StorageBrowserCubit? _browserCubit;
  StoragePreviewCubit? _previewCubit;
  _DocumentOperationSnapshot? _operation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final document = context.watch<StorageDocumentMutationCubit>();
    final browser = context.watch<StorageBrowserCubit>();
    final preview = context.watch<StoragePreviewCubit>();
    if (identical(document, _documentCubit) &&
        identical(browser, _browserCubit) &&
        identical(preview, _previewCubit)) {
      return;
    }
    _documentCubit = document;
    _browserCubit = browser;
    _previewCubit = preview;
    _operation = null;
  }

  @override
  void didUpdateWidget(covariant _StorageDocumentMutationListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.routedScope != widget.routedScope) _operation = null;
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<StorageDocumentMutationCubit, StorageDocumentMutationState>(
        bloc: _documentCubit,
        listener: _handleMutation,
        child: widget.child,
      );

  void _handleMutation(
    BuildContext context,
    StorageDocumentMutationState state,
  ) {
    if (state is StorageDocumentMutationLoading) {
      _captureOperation(state);
      return;
    }
    final operation = _operation;
    _operation = null;
    if (operation == null ||
        state.operationId != operation.operationId ||
        state.scope != operation.scope ||
        !_isCurrent(operation)) {
      return;
    }
    if (state is StorageDocumentMutationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.storageCreateDocumentSuccess)),
      );
      unawaited(operation.browserCubit.load(showLoading: false));
      unawaited(operation.previewCubit.preparePreview(state.file));
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => BlocProvider.value(
            value: operation.previewCubit,
            child: StoragePreviewDialog(file: state.file),
          ),
        ),
      );
      return;
    }
    if (state is StorageDocumentMutationFailure) {
      widget.onMutationError(
        StorageMutationError(
          message: state.error.message,
          code: state.error.apiCode,
          traceId: state.error.traceId,
          apiError: state.error,
          onRetry: _retryFor(operation, state),
        ),
      );
    }
  }

  void _captureOperation(StorageDocumentMutationLoading state) {
    final document = _documentCubit;
    final browser = _browserCubit;
    final preview = _previewCubit;
    if (document == null ||
        browser == null ||
        preview == null ||
        state.scope != widget.routedScope ||
        state.scope != browser.currentScope ||
        state.operationId == 0) {
      _operation = null;
      return;
    }
    _operation = _DocumentOperationSnapshot(
      documentCubit: document,
      browserCubit: browser,
      previewCubit: preview,
      scope: state.scope,
      operationId: state.operationId,
    );
  }

  bool _isCurrent(_DocumentOperationSnapshot operation) {
    if (!mounted ||
        operation.documentCubit.isClosed ||
        operation.browserCubit.isClosed ||
        operation.previewCubit.isClosed ||
        operation.scope != widget.routedScope ||
        operation.scope != operation.browserCubit.currentScope) {
      return false;
    }
    return identical(
          context.read<StorageDocumentMutationCubit>(),
          operation.documentCubit,
        ) &&
        identical(
          context.read<StorageBrowserCubit>(),
          operation.browserCubit,
        ) &&
        identical(
          context.read<StoragePreviewCubit>(),
          operation.previewCubit,
        );
  }

  VoidCallback _retryFor(
    _DocumentOperationSnapshot operation,
    StorageDocumentMutationFailure failure,
  ) => () {
    if (!_isCurrent(operation) ||
        !identical(operation.documentCubit.state, failure) ||
        failure.operationId != operation.operationId ||
        _retryIsBlocked(failure.error.retryAfterUtc)) {
      return;
    }
    unawaited(
      operation.documentCubit.retry(operationId: operation.operationId),
    );
  };

  bool _retryIsBlocked(DateTime? retryAfterUtc) =>
      retryAfterUtc != null &&
      DateTime.now().toUtc().isBefore(retryAfterUtc.toUtc());
}

final class _DocumentOperationSnapshot {
  const _DocumentOperationSnapshot({
    required this.documentCubit,
    required this.browserCubit,
    required this.previewCubit,
    required this.scope,
    required this.operationId,
  });

  final StorageDocumentMutationCubit documentCubit;
  final StorageBrowserCubit browserCubit;
  final StoragePreviewCubit previewCubit;
  final StorageScope scope;
  final int operationId;
}

/// Scope fields shared by listeners and route synchronization.
final class StorageShellStateScope {
  const StorageShellStateScope._();

  static StorageScope read(StorageBrowserState state) => switch (state) {
    StorageBrowserInitial(:final scope) => scope,
    StorageBrowserLoading(:final scope) => scope,
    StorageBrowserReady(:final scope) => scope,
    StorageBrowserEmpty(:final scope) => scope,
    StorageBrowserFailure(:final scope) => scope,
    StorageBrowserForbidden(:final scope) => scope,
  };
}

/// View preference snapshot present only in states that retain browser data.
final class StorageViewPreferenceProjection {
  const StorageViewPreferenceProjection._();

  static StorageViewPreference? read(
    StorageBrowserState state,
  ) => switch (state) {
    StorageBrowserInitial(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserLoading(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserReady(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserEmpty(:final viewMode, :final sort, :final density) =>
      StorageViewPreference(viewMode: viewMode, sort: sort, density: density),
    StorageBrowserFailure() || StorageBrowserForbidden() => null,
  };
}
