import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Dane wejściowe pojedynczego pliku przygotowanego do uploadu.
class StorageUploadInput extends Equatable {
  /// Tworzy obiekt wejściowy uploadu.
  const StorageUploadInput({
    required this.name,
    required this.size,
    this.bytes,
    this.mimeType,
    this.path,
  });

  /// Oryginalna nazwa pliku z rozszerzeniem.
  final String name;

  /// Zawartość binarna pliku.
  final Uint8List? bytes;

  /// Rozmiar w bajtach.
  final int size;

  /// Wykryty lub podany MIME type.
  final String? mimeType;

  /// Opcjonalna ścieżka systemowa (na desktopie).
  final String? path;

  /// Rozszerzenie pliku wyodrębnione z nazwy.
  String get extension {
    final dotIndex = name.lastIndexOf('.');
    if (dotIndex != -1 && dotIndex < name.length - 1) {
      return name.substring(dotIndex + 1).toLowerCase();
    }
    return '';
  }

  @override
  List<Object?> get props => [name, size, mimeType, path];
}
