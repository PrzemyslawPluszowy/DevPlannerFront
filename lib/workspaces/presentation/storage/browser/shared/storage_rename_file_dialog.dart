import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_mutation_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Formularz zmiany nazwy pliku, który zachowuje i blokuje jego rozszerzenie.
abstract final class StorageRenameFileDialog {
  static Future<bool> show(
    BuildContext context,
    StorageFileResponse file, {
    VoidCallback? onDirty,
    Future<bool> Function()? onCloseAttempt,
  }) async {
    final mutation = context.read<StorageFileMutationCubit>();
    final browser = context.read<StorageBrowserCubit?>();
    final scope = browser?.currentScope;
    final ownerContext = context;
    bool isCurrent() {
      if (!ownerContext.mounted || mutation.isClosed) return false;
      if (!identical(
        ownerContext.read<StorageFileMutationCubit>(),
        mutation,
      )) {
        return false;
      }
      final currentBrowser = ownerContext.read<StorageBrowserCubit?>();
      if (browser == null) return currentBrowser == null;
      return identical(currentBrowser, browser) &&
          !browser.isClosed &&
          browser.currentScope == scope;
    }

    final suffix = _suffixFor(file);
    final stem = _stemFor(file.originalFileName, suffix);
    final dialogKey = GlobalKey<_StorageRenameFileDialogBodyState>();
    final result = await DevPlannerModalHost.showDialog<bool>(
      context,
      onDismissAttempt: () => unawaited(dialogKey.currentState?.requestClose()),
      builder: (_) => BlocProvider.value(
        value: mutation,
        child: _StorageRenameFileDialogBody(
          key: dialogKey,
          file: file,
          source: mutation,
          initialStem: stem,
          suffix: suffix,
          onDirty: onDirty,
          onCloseAttempt: onCloseAttempt,
          isCurrent: isCurrent,
        ),
      ),
    );
    if (!ownerContext.mounted || !isCurrent()) return false;
    return result == true;
  }

  static String _suffixFor(StorageFileResponse file) {
    final extension = file.extension;
    if (extension.isEmpty) return '';
    return extension.startsWith('.') ? extension : '.$extension';
  }

  static String _stemFor(String originalName, String suffix) =>
      suffix.isNotEmpty &&
          originalName.toLowerCase().endsWith(suffix.toLowerCase())
      ? originalName.substring(0, originalName.length - suffix.length)
      : originalName;
}

final class _StorageRenameFileDialogBody extends StatefulWidget {
  const _StorageRenameFileDialogBody({
    required this.file,
    required this.source,
    required this.initialStem,
    required this.suffix,
    required this.isCurrent,
    this.onDirty,
    this.onCloseAttempt,
    super.key,
  });

  final StorageFileResponse file;
  final StorageFileMutationCubit source;
  final String initialStem;
  final String suffix;
  final VoidCallback? onDirty;
  final Future<bool> Function()? onCloseAttempt;
  final bool Function() isCurrent;

  @override
  State<_StorageRenameFileDialogBody> createState() =>
      _StorageRenameFileDialogBodyState();
}

final class _StorageRenameFileDialogBodyState
    extends State<_StorageRenameFileDialogBody> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initialStem,
  );
  late final ValueNotifier<int> _viewRevision;
  late final Listenable _viewChanges;
  bool _saving = false;
  bool _attempted = false;
  bool _closePending = false;
  bool _routeClosing = false;
  Timer? _retryRefreshTimer;

  bool get _hasEmptyStem => _nameController.text.trim().isEmpty;

  bool get _nameUnchanged =>
      _nameController.text.trim() == widget.initialStem.trim();

  bool get _canSave =>
      !_saving &&
      !_closePending &&
      !widget.source.isClosed &&
      widget.source.canMutate &&
      !_hasEmptyStem &&
      !_nameUnchanged;

  @override
  void initState() {
    super.initState();
    _viewRevision = ValueNotifier(0);
    _viewChanges = Listenable.merge([_nameController, _viewRevision]);
    _scheduleRetryRefresh(widget.source.state);
  }

  @override
  void dispose() {
    _retryRefreshTimer?.cancel();
    _viewRevision.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _scheduleRetryRefresh(StorageFileMutationState state) {
    _retryRefreshTimer?.cancel();
    final retryAfter = switch (state) {
      StorageFileMutationFailure(:final apiError) => apiError?.retryAfterUtc,
      _ => null,
    };
    if (retryAfter == null) return;
    final wait = retryAfter.difference(DateTime.now().toUtc());
    if (wait <= Duration.zero) return;
    _retryRefreshTimer = Timer(wait, _refreshAfterCooldown);
  }

  void _refreshAfterCooldown() {
    if (!mounted || !widget.isCurrent() || widget.source.isClosed) return;
    _refreshView();
  }

  void _refreshView() => _viewRevision.value++;

  void _onNameChanged(String _) {
    widget.onDirty?.call();
  }

  Future<void> requestClose() async {
    if (!mounted || _saving || _closePending) return;
    final route = ModalRoute.of(context);
    if (!_isRouteActive(route)) return;
    if (!widget.isCurrent()) {
      _routeClosing = true;
      Navigator.of(context).pop(false);
      return;
    }
    _closePending = true;
    _refreshView();
    final allowed = await widget.onCloseAttempt?.call() ?? true;
    if (!mounted) return;
    if (!_isRouteActive(route)) return;
    if (allowed || !widget.isCurrent()) {
      _routeClosing = true;
      Navigator.of(context).pop(false);
      return;
    }
    _closePending = false;
    _refreshView();
  }

  Future<void> _save() async {
    if (_saving || _closePending) return;
    if (_hasEmptyStem) {
      _attempted = true;
      _refreshView();
      return;
    }
    if (_nameUnchanged || !widget.source.canMutate) return;
    final route = ModalRoute.of(context);
    if (!_isRouteActive(route)) return;
    if (!widget.isCurrent() || widget.source.isClosed) {
      _routeClosing = true;
      Navigator.of(context).pop(false);
      return;
    }
    final fileName = '${_nameController.text.trim()}${widget.suffix}';
    _saving = true;
    _attempted = true;
    _refreshView();
    final renamed = await widget.source.renameFile(
      file: widget.file,
      fileName: fileName,
    );
    if (!mounted) return;
    if (!_isRouteActive(route) || _routeClosing) return;
    if (!widget.isCurrent() || widget.source.isClosed) {
      _routeClosing = true;
      Navigator.of(context).pop(false);
      return;
    }
    if (renamed) {
      _routeClosing = true;
      Navigator.of(context).pop(true);
      return;
    }
    _saving = false;
    _refreshView();
  }

  bool _isRouteActive(ModalRoute<dynamic>? route) =>
      route != null &&
      identical(ModalRoute.of(context), route) &&
      route.isCurrent &&
      route.animation?.status != AnimationStatus.reverse;

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<StorageFileMutationCubit, StorageFileMutationState>(
        listener: (context, state) => _scheduleRetryRefresh(state),
        builder: (context, state) => AnimatedBuilder(
          animation: _viewChanges,
          builder: (context, _) {
            final common = context.filesTheme.common;
            final error = _attempted && state is StorageFileMutationFailure
                ? state.apiError
                : null;
            final canSave = _canSave;
            return AlertDialog(
              backgroundColor: context.tasksTheme.canvas,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrollable: true,
              insetPadding: EdgeInsets.all(common.sectionGap),
              constraints: const BoxConstraints(maxWidth: 480),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(common.panelRadius),
                side: BorderSide(color: common.canvasBorder),
              ),
              titlePadding: EdgeInsets.all(common.sectionGap),
              contentPadding: EdgeInsets.fromLTRB(
                common.sectionGap,
                0,
                common.sectionGap,
                common.tightGap,
              ),
              actionsPadding: EdgeInsets.fromLTRB(
                common.sectionGap,
                0,
                common.sectionGap,
                common.sectionGap,
              ),
              titleTextStyle: common.projectTitleText.copyWith(
                color: context.colors.onSurface,
              ),
              contentTextStyle: common.dataText.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              title: Text(context.l10n.storageRenameFileDialogTitle),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      key: const ValueKey('storage_rename_file_name'),
                      controller: _nameController,
                      autofocus: true,
                      maxLength: widget.suffix.length >= 255
                          ? 0
                          : 255 - widget.suffix.length,
                      enabled: !_saving && !widget.source.isClosed,
                      style: common.dataText.copyWith(
                        color: context.colors.onSurface,
                      ),
                      decoration: InputDecoration(
                        labelText: context.l10n.storageRenameFileHint,
                        helperText: context.l10n.storageRenameFileExtensionHint,
                        errorText: _attempted && _hasEmptyStem
                            ? context.l10n.workspacesNameRequiredError
                            : null,
                        suffixText: widget.suffix.isEmpty
                            ? null
                            : widget.suffix,
                        labelStyle: common.controlText.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        helperStyle: common.metaText.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        filled: true,
                        fillColor: context.tasksTheme.canvas,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            common.controlRadius,
                          ),
                          borderSide: BorderSide(color: common.canvasBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            common.controlRadius,
                          ),
                          borderSide: BorderSide(color: common.canvasBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            common.controlRadius,
                          ),
                          borderSide: BorderSide(color: context.colors.primary),
                        ),
                      ),
                      onChanged: _onNameChanged,
                      onSubmitted: (_) => unawaited(_save()),
                    ),
                    if (error != null) ...[
                      SizedBox(height: common.controlGap),
                      StorageFolderMutationErrorView(error: error),
                    ],
                    if (_attempted &&
                        state is StorageFileMutationFailure &&
                        error == null)
                      Padding(
                        padding: EdgeInsets.only(top: common.controlGap),
                        child: Text(
                          state.message,
                          style: common.dataStrongText.copyWith(
                            color: context.colors.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _saving || _closePending
                      ? null
                      : () => unawaited(requestClose()),
                  style: TextButton.styleFrom(
                    foregroundColor: context.colors.onSurface,
                    textStyle: common.controlText,
                    minimumSize: Size(0, common.commandRowHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(common.controlRadius),
                    ),
                  ),
                  child: Text(context.l10n.close),
                ),
                FilledButton(
                  key: const ValueKey('storage_rename_file_save'),
                  onPressed: canSave ? () => unawaited(_save()) : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: context.colors.onSurface,
                    foregroundColor: context.colors.surface,
                    textStyle: common.controlText,
                    minimumSize: Size(0, common.commandRowHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(common.controlRadius),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(context.l10n.storageRenameFolderButton),
                ),
              ],
            );
          },
        ),
      );
}
