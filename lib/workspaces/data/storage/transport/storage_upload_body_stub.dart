import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

/// Fallback źródła uploadu.
final class StorageUploadBodyPlatform {
  const StorageUploadBodyPlatform._();

  static Object create(StorageUploadInput input) {
    final bytes = input.bytes;
    if (bytes == null) throw StateError('Brak danych pliku do wysłania.');
    return Stream<List<int>>.value(bytes);
  }
}
