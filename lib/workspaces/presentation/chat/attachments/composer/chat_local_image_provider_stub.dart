import 'dart:typed_data';

import 'package:flutter/painting.dart';

/// Lokalny provider obrazu: implementacja bez `dart:io` dla Web/Wasm.
ImageProvider<Object>? createLocalImageProvider({
  required Uint8List? bytes,
  required String? path,
  required int cacheWidth,
}) {
  if (bytes == null || bytes.isEmpty) return null;
  return ResizeImage(MemoryImage(bytes), width: cacheWidth);
}
