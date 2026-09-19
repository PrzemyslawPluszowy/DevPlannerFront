import 'dart:io';

import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

/// Strumieniuje plik z dysku na Windows/macOS/Linux.
final class StorageUploadBodyPlatform {
  const StorageUploadBodyPlatform._();

  static Object create(StorageUploadInput input) {
    final path = input.path;
    if (path != null && path.isNotEmpty) return File(path).openRead();
    final bytes = input.bytes;
    if (bytes == null) throw StateError('Brak danych pliku do wysłania.');
    return Stream<List<int>>.value(bytes);
  }
}
