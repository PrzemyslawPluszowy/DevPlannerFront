import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_accessibility_boundary.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/payloads/storage_payloads.dart';
import 'package:ready_next/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:ready_next/workspaces/data/storage/transport/onlyoffice_bridge.dart';
import 'package:ready_next/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:ready_next/workspaces/domain/storage/ports/download_transport.dart';
import 'package:ready_next/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:ready_next/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/office/cubit/storage_office_state.dart';
import 'package:ready_next/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';

/// Modalny dialog z osadzonym edytorem OnlyOffice lub podglądem konfiguracji sesji.
class StorageOfficeEditorDialog extends StatelessWidget {
  /// Tworzy dialog sesji dokumentu OnlyOffice.
  const StorageOfficeEditorDialog({
    required this.file,
    this.repository,
    this.downloadTransport,
    this.uploadTransport,
    super.key,
  });

  /// Otwierany plik biurowy.
  final StorageFileResponse file;

  /// Opcjonalne repozytorium.
  final StorageRepository? repository;

  /// Natywny transport pobierania, wstrzykiwany w testach.
  final DownloadTransport? downloadTransport;

  /// Transport przesyłania plików, wstrzykiwany w testach.
  final UploadTransport? uploadTransport;

  /// Wyświetla edytor dokumentu w modalnym oknie.
  static Future<void> show(
    BuildContext context, {
    required StorageFileResponse file,
    StorageRepository? repository,
    DownloadTransport? downloadTransport,
    UploadTransport? uploadTransport,
  }) {
    return AppModalHost.showDialog<void>(
      context,
      barrierDismissible: false,
      builder: (_) => StorageOfficeEditorDialog(
        file: file,
        repository: repository,
        downloadTransport: downloadTransport,
        uploadTransport: uploadTransport,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? context.read<StorageRepository>();
    final effectiveDownload =
        downloadTransport ?? const DownloadTransportImpl();
    final effectiveUpload = uploadTransport ?? PresignedUploadTransport();

    return BlocProvider(
      create: (_) {
        final cubit = StorageOfficeCubit(
          fileId: file.id,
          repository: repo,
        );
        unawaited(cubit.initSession());
        return cubit;
      },
      child: _StorageOfficeEditorView(
        file: file,
        downloadTransport: effectiveDownload,
        uploadTransport: effectiveUpload,
        repository: repo,
      ),
    );
  }
}

class _StorageOfficeEditorView extends StatefulWidget {
  const _StorageOfficeEditorView({
    required this.file,
    required this.downloadTransport,
    required this.uploadTransport,
    required this.repository,
  });

  final StorageFileResponse file;
  final DownloadTransport downloadTransport;
  final UploadTransport uploadTransport;
  final StorageRepository repository;

  @override
  State<_StorageOfficeEditorView> createState() =>
      _StorageOfficeEditorViewState();
}

class _StorageOfficeEditorViewState extends State<_StorageOfficeEditorView> {
  final StorageOnlyOfficeHostController _hostController =
      StorageOnlyOfficeHostController();
  bool _isClosing = false;
  bool _isDownloading = false;
  bool _isPrinting = false;
  bool _isSavingCopy = false;

  Future<void> _requestDownload() async {
    if (_isDownloading || _isClosing) return;
    setState(() => _isDownloading = true);
    try {
      final ext = widget.file.extension.replaceFirst('.', '');
      await _hostController
          .requestExport(format: ext.isNotEmpty ? ext : null)
          .timeout(const Duration(seconds: 30));
    } on Object {
      if (!mounted) return;
      setState(() => _isDownloading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.storageOfficeDownloadFailure)),
      );
    }
  }

  Future<void> _requestPrint() async {
    if (_isPrinting || _isClosing) return;
    setState(() => _isPrinting = true);
    try {
      final download = await _hostController
          .requestExport(format: 'pdf')
          .timeout(const Duration(seconds: 30));
      if (!mounted) return;

      final sessionState = context.read<StorageOfficeCubit>().state;
      final token = sessionState is StorageOfficeReady
          ? sessionState.session.token
          : null;
      final headers = token != null ? {'X-OnlyOffice-JWT': token} : null;

      final bytesResult = await widget.downloadTransport.fetchBytes(
        downloadUrl: download.url,
        headers: headers,
      );

      if (!mounted) return;

      await bytesResult.fold(
        (error) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.storageOfficePrintFailure)),
          );
        },
        (bytes) async {
          final originalName = widget.file.originalFileName;
          final dot = originalName.lastIndexOf('.');
          final stem = dot > 0 ? originalName.substring(0, dot) : originalName;
          await Printing.layoutPdf(
            name: '$stem.pdf',
            onLayout: (_) async => bytes,
          );
        },
      );
    } on Object catch (e) {
      debugPrint('[storage.onlyoffice] Błąd drukowania: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.storageOfficePrintFailure)),
      );
    } finally {
      if (mounted) {
        setState(() => _isPrinting = false);
      }
    }
  }

  Future<void> _downloadGeneratedFile(OnlyOfficeDownload download) async {
    if (!mounted) return;
    setState(() => _isDownloading = true);
    final originalName = widget.file.originalFileName;
    final dot = originalName.lastIndexOf('.');
    final stem = dot > 0 ? originalName.substring(0, dot) : originalName;
    final sessionState = context.read<StorageOfficeCubit>().state;
    final token = sessionState is StorageOfficeReady
        ? sessionState.session.token
        : null;
    final headers = token != null ? {'X-OnlyOffice-JWT': token} : null;

    final targetFileName = '$stem.${download.fileType}';
    final result = await widget.downloadTransport.downloadUrl(
      downloadUrl: download.url,
      fileName: targetFileName,
      headers: headers,
    );
    if (!mounted) return;
    setState(() => _isDownloading = false);
    result.fold(
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      ),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.l10n.storageOfficeDownloadSuccess(targetFileName),
            ),
          ),
        );
      },
    );
  }

  String _guessMimeType(String fileName) {
    final lower = fileName.toLowerCase();
    if (lower.endsWith('.docx')) {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
    if (lower.endsWith('.xlsx')) {
      return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
    if (lower.endsWith('.pptx')) {
      return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    }
    if (lower.endsWith('.pdf')) {
      return 'application/pdf';
    }
    if (lower.endsWith('.txt')) {
      return 'text/plain';
    }
    return 'application/octet-stream';
  }

  Future<void> _saveCopyInStorage({
    String? format,
    String? suggestedTitle,
    String? downloadUrl,
  }) async {
    if (_isSavingCopy || _isClosing) return;
    setState(() => _isSavingCopy = true);
    try {
      final OnlyOfficeDownload download;
      if (downloadUrl != null && format != null) {
        download = (url: downloadUrl, fileType: format);
      } else {
        final originalExt = widget.file.extension.isNotEmpty
            ? widget.file.extension
            : widget.file.originalFileName.split('.').last;
        final cleanExt = originalExt.replaceFirst('.', '');
        final targetFormat = format ?? cleanExt;
        download = await _hostController
            .requestExport(
              format: targetFormat.isNotEmpty ? targetFormat : null,
            )
            .timeout(const Duration(seconds: 30));
      }

      if (!mounted) return;

      final sessionState = context.read<StorageOfficeCubit>().state;
      final token = sessionState is StorageOfficeReady
          ? sessionState.session.token
          : null;
      final headers = token != null ? {'X-OnlyOffice-JWT': token} : null;

      final bytesResult = await widget.downloadTransport.fetchBytes(
        downloadUrl: download.url,
        headers: headers,
      );

      if (!mounted) return;

      await bytesResult.fold(
        (error) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.storageOfficeSaveCopyFailure)),
          );
        },
        (bytes) async {
          final originalName = widget.file.originalFileName;
          final dot = originalName.lastIndexOf('.');
          final stem = dot > 0 ? originalName.substring(0, dot) : originalName;
          final cleanExt = download.fileType.isNotEmpty
              ? download.fileType
              : (dot > 0 ? originalName.substring(dot + 1) : '');

          var targetFileName =
              (suggestedTitle != null && suggestedTitle.trim().isNotEmpty)
              ? suggestedTitle.trim()
              : '$stem (kopia).$cleanExt';
          if (!targetFileName.endsWith('.$cleanExt')) {
            targetFileName = '$targetFileName.$cleanExt';
          }

          final payload = StorageUploadTicketPayload(
            fileName: targetFileName,
            fileSizeBytes: bytes.length,
            mimeType: _guessMimeType(targetFileName),
            module: widget.file.module,
            resourceType: widget.file.resourceType,
            resourceId: widget.file.resourceId,
            workspaceId: widget.file.workspaceId,
            projectId: widget.file.projectId,
          );

          final ticketResult = await widget.repository.requestUploadTicket(
            payload,
          );
          if (!mounted) return;

          await ticketResult.fold(
            (err) async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(err.message)),
              );
            },
            (ticket) async {
              final uploadInput = StorageUploadInput(
                name: targetFileName,
                size: bytes.length,
                bytes: bytes,
                mimeType: payload.mimeType,
              );

              final uploadResult = await widget.uploadTransport.upload(
                ticket: ticket,
                input: uploadInput,
              );
              if (!mounted) return;

              await uploadResult.fold(
                (uploadErr) async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(uploadErr.message)),
                  );
                },
                (_) async {
                  final completeResult = await widget.repository.completeUpload(
                    fileId: ticket.fileId,
                    fileSizeBytes: bytes.length,
                  );
                  if (!mounted) return;

                  completeResult.fold(
                    (completeErr) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(completeErr.message)),
                    ),
                    (createdFile) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.l10n.storageOfficeSaveCopySuccess(
                              createdFile.originalFileName,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    } on Object catch (e) {
      debugPrint('[storage.onlyoffice] Błąd zapisu kopii w Storage: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.storageOfficeSaveCopyFailure)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingCopy = false);
      }
    }
  }

  Future<void> _close() async {
    if (_isClosing) return;
    setState(() => _isClosing = true);
    try {
      await _hostController.closeEditor().timeout(const Duration(seconds: 30));
    } on Object {
      if (!mounted) return;
      final forceClose = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.storageCloseOffice),
          content: Text(context.l10n.storageOfficeCloseUnconfirmed),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(context.l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(context.l10n.close),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (forceClose != true) {
        setState(() => _isClosing = false);
        return;
      }
      try {
        await _hostController.destroyEditor().timeout(
          const Duration(seconds: 3),
        );
      } on Object {
        debugPrint(
          '[storage.onlyoffice] Wymuszone zamknięcie nieodpowiadającego edytora.',
        );
      }
    }
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppModalAccessibilityBoundary(
      onDismiss: () => unawaited(_close()),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) unawaited(_close());
        },
        child: Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Icon(
                    AppIcons.documentText,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.file.originalFileName,
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              leading: IconButton(
                icon: const Icon(AppIcons.close),
                tooltip: context.l10n.close,
                onPressed: _isClosing ? null : () => unawaited(_close()),
              ),
              actions: [
                IconButton(
                  icon: _isSavingCopy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(AppIcons.saveCopy),
                  tooltip: context.l10n.storageOfficeSaveCopyAction,
                  onPressed:
                      _isSavingCopy ||
                          _isPrinting ||
                          _isDownloading ||
                          _isClosing
                      ? null
                      : () => unawaited(_saveCopyInStorage()),
                ),
                IconButton(
                  icon: _isPrinting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(AppIcons.print),
                  tooltip: context.l10n.storageOfficePrintAction,
                  onPressed: _isPrinting || _isClosing
                      ? null
                      : () => unawaited(_requestPrint()),
                ),
                IconButton(
                  icon: _isDownloading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(AppIcons.download),
                  tooltip: context.l10n.storageDownloadAction,
                  onPressed: _isDownloading || _isClosing
                      ? null
                      : () => unawaited(_requestDownload()),
                ),
                BlocBuilder<StorageOfficeCubit, StorageOfficeState>(
                  builder: (context, state) {
                    if (state is StorageOfficeReady) {
                      return Padding(
                        padding: const .only(right: 16),
                        child: Chip(
                          label: Text(
                            state.session.canEdit
                                ? context.l10n.storageOfficeEditMode
                                : context.l10n.storageOfficeViewMode,
                            style: context.text.bodySmall?.copyWith(
                              color: state.session.canEdit
                                  ? context.colors.primary
                                  : context.colors.onSurfaceVariant,
                            ),
                          ),
                          avatar: Icon(
                            state.session.canEdit
                                ? AppIcons.code
                                : AppIcons.lock,
                            size: 14,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            body: BlocBuilder<StorageOfficeCubit, StorageOfficeState>(
              builder: (context, state) {
                return switch (state) {
                  StorageOfficeInitial() ||
                  StorageOfficeLoading() => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  StorageOfficeFailure(:final message) => Center(
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          AppIcons.alertCircle,
                          size: 48,
                          color: context.colors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          context.l10n.storageOfficeSessionFailure,
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          icon: const Icon(AppIcons.refresh, size: 16),
                          label: Text(context.l10n.retry),
                          onPressed: () {
                            unawaited(
                              context.read<StorageOfficeCubit>().initSession(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  StorageOfficeReady(:final session) => StorageOnlyOfficeHost(
                    session: session,
                    hostController: _hostController,
                    onCloseRequested: () => unawaited(_close()),
                    onPrintRequested: () => unawaited(_requestPrint()),
                    onSaveAsRequested: (saveAs) {
                      if (_isPrinting || _isDownloading) return;
                      unawaited(
                        _saveCopyInStorage(
                          downloadUrl: saveAs.url,
                          format: saveAs.fileType,
                          suggestedTitle: saveAs.title,
                        ),
                      );
                    },
                    onDownloadRequested: (url) {
                      if (_isPrinting) return;
                      unawaited(_downloadGeneratedFile(url));
                    },
                  ),
                };
              },
            ),
            floatingActionButton: FloatingActionButton.small(
              tooltip: context.l10n.close,
              onPressed: _isClosing ? null : () => unawaited(_close()),
              child: const Icon(AppIcons.close),
            ),
          ),
        ),
      ),
    );
  }
}
