import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';

/// Neutralne źródło plików dla przyszłych pickerów, drag-and-drop i wklejania.
///
/// Adaptery platformowe przekazują wyłącznie gotowe dane wejściowe; nie znają
/// Cubita, widgetów ani kontraktów HTTP.
abstract interface class ChatAttachmentSelectionSource {
  /// Kolejne grupy plików wybranych przez użytkownika.
  Stream<List<StorageUploadInput>> get selections;
}
