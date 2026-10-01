import 'dart:async';

import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:devplanner/workspaces/data/storage/transport/presigned_upload_transport.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_office_editor_view.dart';
import 'package:devplanner/workspaces/presentation/storage/office/widgets/storage_onlyoffice_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Modalny dialog z osadzonym edytorem OnlyOffice lub podglądem konfiguracji sesji.
final class StorageOfficeEditorDialog extends StatefulWidget {
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
  }) => DevPlannerModalHost.showDialog<void>(
    context,
    barrierDismissible: false,
    builder: (_) => StorageOfficeEditorDialog(
      file: file,
      repository: repository,
      downloadTransport: downloadTransport,
      uploadTransport: uploadTransport,
    ),
  );

  @override
  State<StorageOfficeEditorDialog> createState() =>
      _StorageOfficeEditorDialogState();
}

final class _StorageOfficeEditorDialogState
    extends State<StorageOfficeEditorDialog> {
  late StorageOnlyOfficeHostController _hostController;
  late Object _scopeKey;
  StorageRepository? _repository;

  @override
  void initState() {
    super.initState();
    _resetScope();
  }

  @override
  void didUpdateWidget(StorageOfficeEditorDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file.id != widget.file.id ||
        !identical(oldWidget.repository, widget.repository) ||
        !identical(oldWidget.downloadTransport, widget.downloadTransport) ||
        !identical(oldWidget.uploadTransport, widget.uploadTransport)) {
      _resetScope();
    }
    _resolveRepository();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveRepository();
  }

  void _resolveRepository() {
    final repository =
        widget.repository ??
        RepositoryProvider.of<StorageRepository>(context, listen: true);
    if (identical(repository, _repository)) return;
    if (_repository != null) _resetScope();
    _repository = repository;
  }

  void _resetScope() {
    _scopeKey = Object();
    _hostController = StorageOnlyOfficeHostController();
  }

  @override
  Widget build(BuildContext context) {
    final storageRepository = _repository!;
    return MultiBlocProvider(
      key: ValueKey(_scopeKey),
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = StorageOfficeCubit(
              fileId: widget.file.id,
              repository: storageRepository,
            );
            unawaited(cubit.initSession());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => StorageOfficeEditorActionsCubit(
            widget.file,
            storageRepository,
            widget.downloadTransport ?? const DownloadTransportImpl(),
            widget.uploadTransport ?? PresignedUploadTransport(),
            _hostController,
          ),
        ),
      ],
      child: StorageOfficeEditorView(
        file: widget.file,
        hostController: _hostController,
      ),
    );
  }
}
