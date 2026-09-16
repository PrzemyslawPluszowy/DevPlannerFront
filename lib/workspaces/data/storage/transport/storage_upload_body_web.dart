import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';

/// Źródło uploadu Web/Wasm oparte o bajty wybrane przez przeglądarkę.
final class StorageUploadBodyPlatform {
  const StorageUploadBodyPlatform._();

  static Object create(StorageUploadInput input) {
    final bytes = input.bytes;
    if (bytes == null) {
      throw StateError('Przeglądarka nie zwróciła danych pliku.');
    }
    return Stream<List<int>>.value(bytes);
  }
}
