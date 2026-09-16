import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';

/// Port wyboru plików z systemu plików lub przeglądarki.
///
/// Ukrywa specyfikę platformy (Web/Desktop) przed warstwą prezentacji i Cubitami.
// ignore: one_member_abstracts
abstract interface class FilePickerPort {
  /// Wybiera pojedynczy lub wiele plików użytkownika.
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  });
}
