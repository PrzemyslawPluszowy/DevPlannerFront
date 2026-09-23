import 'package:desktop_drop/desktop_drop.dart';
import 'package:devplanner/workspaces/domain/storage/models/file_picker_constraints.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

/// Cienka konwersja drop-platformy do neutralnego inputu composera.
final class ChatAttachmentDropInputAdapter {
  static Future<List<StorageUploadInput>> fromFiles(
    List<DropItem> files, {
    required FilePickerConstraints constraints,
  }) async {
    if (files.isEmpty) return const <StorageUploadInput>[];

    // Read only metadata first. Rejected files keep their size/name for the
    // selection cubit's existing validation, without loading their contents.
    final sizes = await Future.wait(files.map((file) => file.length()));
    final inputs = <Future<StorageUploadInput>>[];
    var acceptedFilesInBatch = 0;
    var acceptedBytesInBatch = 0;

    for (var index = 0; index < files.length; index++) {
      final file = files[index];
      final size = sizes[index];
      final canRead = constraints.canReadFile(
        size,
        acceptedFilesInBatch: acceptedFilesInBatch,
        acceptedBytesInBatch: acceptedBytesInBatch,
      );
      if (!canRead) {
        inputs.add(
          Future<StorageUploadInput>.value(
            StorageUploadInput(
              name: file.name,
              size: size,
              mimeType: file.mimeType,
              path: file.path,
            ),
          ),
        );
        continue;
      }

      acceptedFilesInBatch++;
      acceptedBytesInBatch += size;
      inputs.add(
        file.readAsBytes().then(
          (bytes) => StorageUploadInput(
            name: file.name,
            size: size,
            bytes: bytes,
            mimeType: file.mimeType,
            path: file.path,
          ),
        ),
      );
    }

    return Future.wait(inputs);
  }
}
