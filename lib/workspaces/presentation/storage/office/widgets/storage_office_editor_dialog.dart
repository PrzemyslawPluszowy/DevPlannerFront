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
final class StorageOfficeEditorDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final storageRepository = repository ?? context.read<StorageRepository>();
    final hostController = StorageOnlyOfficeHostController();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = StorageOfficeCubit(
              fileId: file.id,
              repository: storageRepository,
            );
            unawaited(cubit.initSession());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => StorageOfficeEditorActionsCubit(
            file,
            storageRepository,
            downloadTransport ?? const DownloadTransportImpl(),
            uploadTransport ?? PresignedUploadTransport(),
            hostController,
          ),
        ),
      ],
      child: StorageOfficeEditorView(
        file: file,
        hostController: hostController,
      ),
    );
  }
}
