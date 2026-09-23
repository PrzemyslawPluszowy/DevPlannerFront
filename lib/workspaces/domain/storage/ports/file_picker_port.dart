import 'package:devplanner/workspaces/domain/storage/models/file_picker_constraints.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

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

/// Picker rozszerzony o preflight rozmiaru przed materializacją bajtów.
///
/// Używają go ścieżki z limitami wejścia. Bazowy [FilePickerPort] pozostaje
/// zgodny z istniejącymi adapterami pozostałych feature'ów.
abstract interface class ConstrainedFilePickerPort implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
    FilePickerConstraints? constraints,
  });
}
