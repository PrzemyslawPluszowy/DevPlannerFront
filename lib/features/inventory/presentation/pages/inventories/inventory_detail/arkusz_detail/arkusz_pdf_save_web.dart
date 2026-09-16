import 'dart:typed_data';

import 'package:printing/printing.dart';

/// Uruchamia pobranie PDF w przeglądarce.
Future<bool> savePdfBytes({
  required Uint8List bytes,
  required String filename,
}) async {
  await Printing.sharePdf(bytes: bytes, filename: filename);
  return true;
}
