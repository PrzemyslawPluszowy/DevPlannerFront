import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_desktop_sharing_dialog.dart';
import 'package:flutter/material.dart';

/// Otwiera zarządzanie udostępnieniami pliku w desktopowym Files.
///
/// Kontrolka jest składana wyłącznie przez desktopowy composition root. Samo
/// `canShare` pochodzi z odpowiedzi backendu i nie jest zastępowane lokalną
/// heurystyką.
final class StorageFileShareAction extends StatelessWidget {
  /// Tworzy akcję udostępniania dla pliku.
  const StorageFileShareAction({
    required this.file,
    required this.repository,
    this.onMutationConfirmed,
    this.buttonKey,
    super.key,
  });

  /// Plik oraz jego capability ACL.
  final StorageFileResponse file;

  /// Repozytorium wstrzyknięte przez composition root.
  final StorageRepository repository;

  /// Odświeżenie listy po potwierdzonej mutacji.
  final Future<void> Function()? onMutationConfirmed;

  /// Stabilny klucz testowy.
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) => IconButton(
    key: buttonKey,
    tooltip: context.l10n.storageShareAction,
    icon: const Icon(AppIcons.share),
    onPressed: file.canShare
        ? () => unawaited(
            StorageDesktopSharingDialog.show(
              context,
              file: file,
              repository: repository,
              onMutationConfirmed: onMutationConfirmed,
            ),
          )
        : null,
  );
}
