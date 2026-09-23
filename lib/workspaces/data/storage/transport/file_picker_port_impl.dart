import 'package:devplanner/workspaces/domain/storage/models/file_picker_constraints.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

/// Implementacja [FilePickerPort] oparta o pakiet `file_selector`.
///
/// Działa spójnie na Flutter Web (Wasm) oraz desktopach (macOS, Windows, Linux).
final class FilePickerPortImpl implements ConstrainedFilePickerPort {
  /// Tworzy implementację pickera.
  const FilePickerPortImpl();

  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
    FilePickerConstraints? constraints,
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
    var acceptedFilesInBatch = 0;
    var acceptedBytesInBatch = 0;
    for (final file in xFiles) {
      final size = await file.length();
      final canRead =
          constraints == null ||
          constraints.canReadFile(
            size,
            acceptedFilesInBatch: acceptedFilesInBatch,
            acceptedBytesInBatch: acceptedBytesInBatch,
          );
      final bytes = kIsWeb && canRead ? await file.readAsBytes() : null;
      results.add(
        StorageUploadInput(
          name: file.name,
          bytes: bytes,
          size: bytes?.length ?? size,
          mimeType: file.mimeType,
          path: file.path,
        ),
      );
      if (canRead) {
        acceptedFilesInBatch++;
        acceptedBytesInBatch += size;
      }
    }

    return results;
  }
}
