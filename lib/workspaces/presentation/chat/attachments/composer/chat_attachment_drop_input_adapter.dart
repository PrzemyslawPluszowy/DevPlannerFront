import 'package:desktop_drop/desktop_drop.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

/// Cienka konwersja drop-platformy do neutralnego inputu composera.
final class ChatAttachmentDropInputAdapter {
  static Future<List<StorageUploadInput>> fromFiles(List<DropItem> files) =>
      Future.wait(
        files.map(
          (file) async => StorageUploadInput(
            name: file.name,
            size: await file.length(),
            bytes: await file.readAsBytes(),
            mimeType: file.mimeType,
            path: file.path,
          ),
        ),
      );
}
