import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_desktop_sharing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Kompatycyjny punkt wejścia dla istniejących menu Files.
///
/// UI jest składany przez standalone dialog, a repozytorium pochodzi z
/// composition root. Klasa nie zna Ready/Core ani transportu HTTP.
final class StorageSharingDialog extends StatelessWidget {
  /// Tworzy dialog udostępniania pliku.
  const StorageSharingDialog({required this.file, super.key});

  /// Plik, którego dotyczy ACL.
  final StorageFileResponse file;

  /// Otwiera modal na rootowym Navigatorze także zagnieżdżonego browsera.
  static Future<void> show(
    BuildContext context, {
    required StorageFileResponse file,
  }) => showDialog<void>(
    context: context,
    builder: (_) => StorageSharingDialog(file: file),
  );

  @override
  Widget build(BuildContext context) => StorageDesktopSharingDialog(
    file: file,
    repository: context.read<StorageRepository>(),
  );
}
