import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_desktop_sharing_dialog.dart';
import 'package:flutter/material.dart';

/// Kompatycyjny punkt wejścia dla menu Files.
///
/// UI składa standalone dialog, a porty pochodzą z composition rootu. Porty są
/// przekazywane jawnie, bo modal jest montowany na rootowym overlayu i nie ma
/// wśród przodków providerów modułu Pliki — odczyt z kontekstu dialogu
/// skończyłby się wyjątkiem, a nie brakiem funkcji.
final class StorageSharingDialog extends StatelessWidget {
  /// Tworzy dialog udostępniania pliku.
  const StorageSharingDialog({
    required this.file,
    required this.repository,
    this.userDirectory,
    super.key,
  });

  /// Plik, którego dotyczy ACL.
  final StorageFileResponse file;

  /// Repozytorium Storage z composition rootu.
  final StorageRepository repository;

  /// Lokalny katalog użytkowników; brak portu wyłącza tryb udostępniania osobie.
  final StorageUserDirectoryPort? userDirectory;

  /// Otwiera modal na rootowym Navigatorze także zagnieżdżonego browsera.
  static Future<void> show(
    BuildContext context, {
    required StorageFileResponse file,
    required StorageRepository repository,
    StorageUserDirectoryPort? userDirectory,
  }) => showDialog<void>(
    context: context,
    builder: (_) => StorageSharingDialog(
      file: file,
      repository: repository,
      userDirectory: userDirectory,
    ),
  );

  @override
  Widget build(BuildContext context) => StorageDesktopSharingDialog(
    file: file,
    repository: repository,
    userDirectory: userDirectory,
  );
}
