import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Zamienia atrybuty zaznaczenia Quilla na surowe wartości kontraktu formatów.
abstract final class ChatQuillSelectionAttributes {
  /// Zwraca wartości (`true`, tekst, itp.) zamiast obiektów `Attribute`.
  static Map<String, Object?> fromController(
    quill.QuillController controller,
  ) => fromAttributes(controller.getSelectionStyle().attributes);

  /// Normalizuje mapę atrybutów Quilla bez potrzeby tworzenia kontrolera.
  static Map<String, Object?> fromAttributes(
    Map<String, quill.Attribute<dynamic>> attributes,
  ) => <String, Object?>{
    for (final entry in attributes.entries) entry.key: entry.value.value,
  };
}
