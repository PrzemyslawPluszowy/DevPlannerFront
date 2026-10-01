import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_action_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_action_state.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_action_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_body.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_failure_view.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Modalne okno podglądu pliku z trwałym feedbackiem pobierania.
final class StoragePreviewDialog extends StatefulWidget {
  const StoragePreviewDialog({
    required this.file,
    this.repository,
    this.version,
    this.onEditorClosed,
    this.onDownload,
    super.key,
  });

  final StorageFileResponse file;
  final StorageRepository? repository;
  final VoidCallback? onEditorClosed;
  final int? version;

  /// Pełny błąd wraca do aktywnego podglądu zamiast pod spodem historii.
  final Future<ApiError?> Function()? onDownload;

  @override
  State<StoragePreviewDialog> createState() => _StoragePreviewDialogState();
}

final class _StoragePreviewDialogState extends State<StoragePreviewDialog> {
  StorageFileMutationCubit? _mutationSource;
  StoragePreviewActionCubit? _actionCubit;
  int _generation = 0;

  bool get _canDownload =>
      widget.file.canDownload &&
      (widget.version == null || widget.onDownload != null) &&
      (widget.onDownload != null || _mutationSource != null);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final source = Provider.of<StorageFileMutationCubit?>(
      context,
    );
    if (!identical(source, _mutationSource) || _actionCubit == null) {
      _mutationSource = source;
      _replaceActionCubit();
    }
  }

  @override
  void didUpdateWidget(StoragePreviewDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.id != widget.file.id ||
        oldWidget.version != widget.version ||
        oldWidget.onDownload != widget.onDownload) {
      _replaceActionCubit();
    }
  }

  void _replaceActionCubit() {
    final previous = _actionCubit;
    _generation++;
    _actionCubit = StoragePreviewActionCubit(
      download: _download,
      fallbackErrorMessage: context.l10n.storageErrorTitle,
    );
    if (previous != null) unawaited(previous.close());
  }

  Future<ApiError?> _download() async {
    final generation = _generation;
    final callback = widget.onDownload;
    final source = _mutationSource;
    if (!mounted) return null;
    if (callback == null &&
        (widget.version != null || source == null || source.isClosed)) {
      return ApiError(
        type: ApiErrorType.canceled,
        message: context.l10n.storageErrorTitle,
      );
    }
    final error = callback != null
        ? await callback()
        : await source!.downloadFileWithFeedback(widget.file);
    if (!mounted ||
        generation != _generation ||
        !identical(source, _mutationSource) ||
        (source != null && source.isClosed)) {
      return null;
    }
    return error;
  }

  @override
  void dispose() {
    final actionCubit = _actionCubit;
    if (actionCubit != null) unawaited(actionCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _actionCubit!,
      child: _StoragePreviewDialogFrame(
        file: widget.file,
        repository: widget.repository,
        version: widget.version,
        canDownload: _canDownload,
        onEditorClosed: widget.onEditorClosed,
      ),
    );
  }
}

final class _StoragePreviewDialogFrame extends StatelessWidget {
  const _StoragePreviewDialogFrame({
    required this.file,
    required this.repository,
    required this.version,
    required this.canDownload,
    required this.onEditorClosed,
  });

  final StorageFileResponse file;
  final StorageRepository? repository;
  final int? version;
  final bool canDownload;
  final VoidCallback? onEditorClosed;

  Future<void> _openEditor(BuildContext context) async {
    if (!context.mounted || version != null || !file.canEditOnline) return;
    final repository = this.repository ?? context.read<StorageRepository>();
    final preview = context.read<StoragePreviewCubit>();
    await StorageOfficeEditorDialog.show(
      context,
      file: file,
      repository: repository,
    );
    if (!context.mounted ||
        preview.isClosed ||
        !identical(preview, context.read<StoragePreviewCubit>())) {
      return;
    }
    onEditorClosed?.call();
    await preview.preparePreview(file);
  }

  void _startDownload(BuildContext context) {
    if (!context.mounted || !canDownload) return;
    unawaited(context.read<StoragePreviewActionCubit>().download());
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StoragePreviewActionCubit, StoragePreviewActionState>(
        builder: (context, actionState) => Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          backgroundColor: context.tasksTheme.canvas,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.tasksTheme.panelRadius),
            side: BorderSide(color: context.tasksTheme.canvasBorder),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
            child: Column(
              children: [
                _StoragePreviewHeader(
                  file: file,
                  version: version,
                  canDownload: canDownload,
                  isDownloading: actionState is StoragePreviewActionDownloading,
                  onDownload: () => _startDownload(context),
                  onOpenEditor: () => unawaited(_openEditor(context)),
                ),
                const Divider(height: 1),
                if (actionState case StoragePreviewActionFailed(:final error))
                  StoragePreviewActionErrorBanner(
                    error: error,
                    onRetry: () => _startDownload(context),
                  ),
                Expanded(
                  child: BlocBuilder<StoragePreviewCubit, StoragePreviewState>(
                    builder: (context, state) => switch (state) {
                      StoragePreviewInitial() ||
                      StoragePreviewLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      final StoragePreviewFailure failure =>
                        StoragePreviewFailureView(
                          message: failure.message,
                          error: failure.error,
                          onRetry: context.read<StoragePreviewCubit>().retry,
                        ),
                      final StoragePreviewReady ready => StoragePreviewBody(
                        file: ready.file,
                        ready: ready,
                        onOpenEditor: () => unawaited(_openEditor(context)),
                        onDownload: canDownload
                            ? () => _startDownload(context)
                            : null,
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

final class _StoragePreviewHeader extends StatelessWidget {
  const _StoragePreviewHeader({
    required this.file,
    required this.version,
    required this.canDownload,
    required this.isDownloading,
    required this.onDownload,
    required this.onOpenEditor,
  });

  final StorageFileResponse file;
  final int? version;
  final bool canDownload;
  final bool isDownloading;
  final VoidCallback onDownload;
  final VoidCallback onOpenEditor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Icon(
          StorageFormatters.iconForFile(
            mimeType: file.mimeType,
            extension: file.extension,
          ),
          size: 20,
          color: context.colors.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.originalFileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                version == null
                    ? '${StorageFormatters.formatBytes(file.fileSizeBytes)} • ${context.l10n.storageVersionLabel(file.version)}'
                    : '${context.l10n.storageVersionPreviewBadge(version!)} • ${StorageFormatters.formatBytes(file.fileSizeBytes)}',
                style: context.text.labelSmall?.copyWith(
                  color: version == null
                      ? context.colors.onSurfaceVariant
                      : context.colors.tertiary,
                ),
              ),
            ],
          ),
        ),
        if (file.canEditOnline && version == null)
          TextButton.icon(
            icon: const Icon(AppIcons.documentText, size: 16),
            label: Text(context.l10n.storageOpenOfficeAction),
            onPressed: onOpenEditor,
          ),
        if (canDownload)
          if (isDownloading)
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(AppIcons.download, size: 18),
              tooltip: context.l10n.storageDownloadAction,
              onPressed: onDownload,
            ),
        IconButton(
          icon: const Icon(AppIcons.close, size: 18),
          tooltip: context.l10n.close,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
