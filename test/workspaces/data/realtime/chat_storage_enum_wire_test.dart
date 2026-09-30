import 'dart:convert';

import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all attachment scan and processing wire values round-trip generated decoders', () {
    const scans = {
      StorageScanStatus.pending: 'Pending',
      StorageScanStatus.clean: 'Clean',
      StorageScanStatus.infected: 'Infected',
      StorageScanStatus.skipped: 'Skipped',
    };
    const processing = {
      StorageProcessingStatus.none: 'None',
      StorageProcessingStatus.queued: 'Queued',
      StorageProcessingStatus.processing: 'Processing',
      StorageProcessingStatus.ready: 'Ready',
      StorageProcessingStatus.failed: 'Failed',
    };
    expect(scans.keys, unorderedEquals(StorageScanStatus.values));
    expect(processing.keys, unorderedEquals(StorageProcessingStatus.values));
    for (final scan in scans.entries) {
      for (final status in processing.entries) {
        final file = StorageFileResponse.fromJson({
          'id': 'file',
          'module': 'Workspaces',
          'resourceType': 'Comment',
          'originalFileName': 'test.txt',
          'extension': '.txt',
          'mimeType': 'text/plain',
          'fileSizeBytes': 1,
          'version': 1,
          'ownerUserId': 'user',
          'createdByUserId': 'user',
          'createdAtUtc': '2026-09-30T00:00:00Z',
          'updatedAtUtc': '2026-09-30T00:00:00Z',
          'isDeleted': false,
          'scanStatus': scan.value,
          'processingStatus': status.value,
          'aiStatus': 'None',
        });
        final normalized = ChatRealtimeEventMapper().normalizeLiveEnvelope({
          'PayloadJson': jsonEncode({
            'ScanStatus': scan.value,
            'ProcessingStatus': status.value,
          }),
        })!;
        expect(normalized['scanStatus'], scan.value);
        expect(normalized['processingStatus'], status.value);
        expect(file.scanStatus, scan.key);
        expect(file.processingStatus, status.key);
        final wire = jsonDecode(jsonEncode(file)) as Map<String, dynamic>;
        expect(wire['scanStatus'], scan.value);
        expect(wire['processingStatus'], status.value);
      }
      final snippet = ChatSnippetAttachmentResponse.fromJson({
        'attachment': {
          'id': 'a',
          'messageId': 'm',
          'storageFileId': 'f',
          'attachedByUserId': 'u',
          'position': 0,
          'createdAtUtc': '2026-09-30T00:00:00Z',
        },
        'fileName': 'test.txt',
        'fileSizeBytes': 1,
        'scanStatus': scan.value,
      });
      expect(snippet.scanStatus, scan.key);
      expect(snippet.toJson()['scanStatus'], scan.value);
    }
  });
}
