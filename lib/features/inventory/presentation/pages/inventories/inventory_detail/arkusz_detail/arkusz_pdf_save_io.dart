import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

/// Otwiera natywne `Zapisz jako` i zapisuje wskazany PDF na desktopie.
Future<bool> savePdfBytes({
  required Uint8List bytes,
  required String filename,
}) async {
  debugPrint(
    '[ARKUSZ_PDF][download][save_dialog_open] suggestedName=$filename | bytes=${bytes.length}',
  );
  final location = await getSaveLocation(
    suggestedName: filename,
    acceptedTypeGroups: const [
      XTypeGroup(
        label: 'PDF',
        extensions: ['pdf'],
      ),
    ],
  );

  if (location == null) {
    debugPrint('[ARKUSZ_PDF][download][save_dialog_cancelled]');
    return false;
  }

  debugPrint(
    '[ARKUSZ_PDF][download][save_write_start] path=${location.path}',
  );
  final file = File(location.path);
  await file.writeAsBytes(bytes, flush: true);
  debugPrint(
    '[ARKUSZ_PDF][download][save_write_done] path=${location.path}',
  );
  return true;
}
