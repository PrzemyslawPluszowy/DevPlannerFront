import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/painting.dart';

/// Lokalny provider: używa ścieżki pickera desktopowego bez kopiowania pełnego
/// zdjęcia do pamięci. Jeśli adapter podał już bajty (np. drag/drop), korzysta
/// z nich jako źródła.
ImageProvider<Object>? createLocalImageProvider({
  required Uint8List? bytes,
  required String? path,
  required int cacheWidth,
}) {
  if (bytes != null && bytes.isNotEmpty) {
    return ResizeImage(MemoryImage(bytes), width: cacheWidth);
  }
  final localPath = path?.trim();
  if (localPath == null || localPath.isEmpty) return null;
  return ResizeImage(FileImage(File(localPath)), width: cacheWidth);
}
