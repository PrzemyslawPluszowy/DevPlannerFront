import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:ready_next/workspaces/domain/storage/ports/file_picker_port.dart';

/// Implementacja [FilePickerPort] oparta o pakiet `file_selector`.
///
/// Działa spójnie na Flutter Web (Wasm) oraz desktopach (macOS, Windows, Linux).
final class FilePickerPortImpl implements FilePickerPort {
  /// Tworzy implementację pickera.
  const FilePickerPortImpl();

  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async {
    final typeGroup = allowedExtensions != null && allowedExtensions.isNotEmpty
        ? XTypeGroup(
            label: 'Dozwolone pliki',
            extensions: allowedExtensions,
          )
        : null;

    final typeGroups = typeGroup != null ? [typeGroup] : const <XTypeGroup>[];

    final List<XFile> xFiles;
    if (allowMultiple) {
      xFiles = await openFiles(acceptedTypeGroups: typeGroups);
    } else {
      final file = await openFile(acceptedTypeGroups: typeGroups);
      xFiles = file != null ? [file] : const [];
    }

    if (xFiles.isEmpty) return const [];

    final results = <StorageUploadInput>[];
    for (final file in xFiles) {
      final bytes = kIsWeb ? await file.readAsBytes() : null;
      final size = bytes?.length ?? await file.length();
      results.add(
        StorageUploadInput(
          name: file.name,
          bytes: bytes,
          size: size,
          mimeType: file.mimeType,
          path: file.path,
        ),
      );
    }

    return results;
  }
}
