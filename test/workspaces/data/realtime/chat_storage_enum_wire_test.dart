import 'dart:convert';

import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'attachment status enums round-trip every response and realtime value',
    () {
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
      const aiStatuses = {
        StorageAiStatus.none: 'None',
        StorageAiStatus.queued: 'Queued',
        StorageAiStatus.processing: 'Processing',
        StorageAiStatus.completed: 'Completed',
        StorageAiStatus.failed: 'Failed',
      };
      expect(scans.keys, unorderedEquals(StorageScanStatus.values));
      expect(processing.keys, unorderedEquals(StorageProcessingStatus.values));
      expect(aiStatuses.keys, unorderedEquals(StorageAiStatus.values));

      for (final scan in scans.entries) {
        for (final status in processing.entries) {
          final file = StorageFileResponse.fromJson(
            _fileJson(scanStatus: scan.value, processingStatus: status.value),
          );
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
            'id': 'attachment-1',
            'messageId': 'message-1',
            'storageFileId': 'file-1',
            'attachedByUserId': 'user-1',
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

      for (final status in aiStatuses.entries) {
        final file = StorageFileResponse.fromJson(
          _fileJson(aiStatus: status.value),
        );
        expect(file.aiStatus, status.key);
        expect(file.toJson()['aiStatus'], status.value);
      }
    },
  );

  test(
    'storage module/resource/document/access enums round-trip all wire values',
    () {
      const modules = {
        StorageModule.workspaces: 'Workspaces',
        StorageModule.inventory: 'Inventory',
        StorageModule.bhp: 'Bhp',
        StorageModule.iqc: 'Iqc',
        StorageModule.fleet: 'Fleet',
        StorageModule.shared: 'Shared',
      };
      const resourceTypes = {
        StorageResourceType.task: 'Task',
        StorageResourceType.comment: 'Comment',
        StorageResourceType.project: 'Project',
        StorageResourceType.document: 'Document',
        StorageResourceType.sheet: 'Sheet',
        StorageResourceType.accidentProtocol: 'AccidentProtocol',
        StorageResourceType.userAvatar: 'UserAvatar',
        StorageResourceType.privateFile: 'Private',
        StorageResourceType.okrObjective: 'OkrObjective',
        StorageResourceType.portfolio: 'Portfolio',
      };
      const formats = {
        StorageDocumentFormat.txt: 'Txt',
        StorageDocumentFormat.odt: 'Odt',
        StorageDocumentFormat.ods: 'Ods',
        StorageDocumentFormat.odp: 'Odp',
        StorageDocumentFormat.docx: 'Docx',
        StorageDocumentFormat.xlsx: 'Xlsx',
        StorageDocumentFormat.pptx: 'Pptx',
      };
      const accessLevels = {
        StorageEffectiveAccessLevel.none: 'None',
        StorageEffectiveAccessLevel.reader: 'Reader',
        StorageEffectiveAccessLevel.commenter: 'Commenter',
        StorageEffectiveAccessLevel.editor: 'Editor',
        StorageEffectiveAccessLevel.owner: 'Owner',
      };
      const shareTypes = {
        StorageShareType.user: 'User',
        StorageShareType.publicLink: 'PublicLink',
        StorageShareType.workspace: 'Workspace',
        StorageShareType.project: 'Project',
      };
      const shareLevels = {
        StorageShareAccessLevel.read: 'Read',
        StorageShareAccessLevel.write: 'Write',
        StorageShareAccessLevel.owner: 'Owner',
        StorageShareAccessLevel.editor: 'Editor',
        StorageShareAccessLevel.commenter: 'Commenter',
        StorageShareAccessLevel.reader: 'Reader',
      };
      expect(modules.keys, unorderedEquals(StorageModule.values));
      expect(resourceTypes.keys, unorderedEquals(StorageResourceType.values));
      expect(formats.keys, unorderedEquals(StorageDocumentFormat.values));
      expect(
        accessLevels.keys,
        unorderedEquals(StorageEffectiveAccessLevel.values),
      );
      expect(shareTypes.keys, unorderedEquals(StorageShareType.values));
      expect(shareLevels.keys, unorderedEquals(StorageShareAccessLevel.values));

      for (final entry in modules.entries) {
        final file = StorageFileResponse.fromJson(
          _fileJson(module: entry.value),
        );
        expect(file.module, entry.key);
        expect(file.toJson()['module'], entry.value);
        final ticket = StorageUploadTicketPayload.fromJson(
          _ticketJson(module: entry.value),
        );
        expect(ticket.module, entry.key);
        expect(ticket.toJson()['module'], entry.value);
      }
      for (final entry in resourceTypes.entries) {
        final file = StorageFileResponse.fromJson(
          _fileJson(resourceType: entry.value),
        );
        expect(file.resourceType, entry.key);
        expect(file.toJson()['resourceType'], entry.value);
        final ticket = StorageUploadTicketPayload.fromJson(
          _ticketJson(resourceType: entry.value),
        );
        expect(ticket.resourceType, entry.key);
        expect(ticket.toJson()['resourceType'], entry.value);
      }
      for (final entry in formats.entries) {
        final payload = CreateStorageDocumentPayload.fromJson({
          'name': 'Plan',
          'format': entry.value,
          'module': 'Workspaces',
          'resourceType': 'Project',
        });
        expect(payload.format, entry.key);
        expect(payload.toJson()['format'], entry.value);
      }
      for (final entry in accessLevels.entries) {
        final file = StorageFileResponse.fromJson(
          _fileJson(accessLevel: entry.value),
        );
        expect(file.accessLevel, entry.key);
        expect(file.toJson()['accessLevel'], entry.value);
      }
      for (final entry in shareTypes.entries) {
        final share = StorageFileShareResponse.fromJson(
          _shareJson(shareType: entry.value),
        );
        expect(share.shareType, entry.key);
        expect(share.toJson()['shareType'], entry.value);
        final payload = CreateStorageFileSharePayload(
          shareType: entry.key,
          accessLevel: StorageShareAccessLevel.read,
          sharedWithUserId: 'user-2',
        );
        expect(payload.toJson()['shareType'], entry.value);
      }
      for (final entry in shareLevels.entries) {
        final share = StorageFileShareResponse.fromJson(
          _shareJson(accessLevel: entry.value),
        );
        expect(share.accessLevel, entry.key);
        expect(share.toJson()['accessLevel'], entry.value);
        final payload = CreateStorageFileSharePayload(
          shareType: StorageShareType.user,
          accessLevel: entry.key,
          sharedWithUserId: 'user-2',
        );
        expect(payload.toJson()['accessLevel'], entry.value);
      }
    },
  );

  test('share target display name is additive and absent legacy field remains null', () {
    final namedJson = _shareJson();
    namedJson['targetDisplayName'] = 'Anna Nowak';
    final named = StorageFileShareResponse.fromJson(namedJson);
    expect(named.targetDisplayName, 'Anna Nowak');
    expect(named.toJson()['targetDisplayName'], 'Anna Nowak');
    expect(
      StorageFileShareResponse.fromJson(_shareJson()).targetDisplayName,
      isNull,
    );
  });

  test('required storage enums reject unknown strings and nullable access defaults safely', () {
    expect(
      () => StorageFileResponse.fromJson(_fileJson(module: 'FutureModule')),
      throwsArgumentError,
    );
    expect(
      () => StorageUploadTicketPayload.fromJson(
        _ticketJson(resourceType: 'FutureResource'),
      ),
      throwsArgumentError,
    );
    expect(
      () => CreateStorageDocumentPayload.fromJson({
        'name': 'Plan',
        'format': 'FutureFormat',
        'module': 'Workspaces',
        'resourceType': 'Project',
      }),
      throwsArgumentError,
    );
    expect(
      StorageFileResponse.fromJson(_fileJson(accessLevel: null)).accessLevel,
      StorageEffectiveAccessLevel.none,
    );
  });
}

Map<String, dynamic> _fileJson({
  String module = 'Workspaces',
  String resourceType = 'Task',
  String processingStatus = 'None',
  String scanStatus = 'Pending',
  String aiStatus = 'None',
  Object? accessLevel = 'None',
}) => {
  'id': 'file-1',
  'module': module,
  'resourceType': resourceType,
  'originalFileName': 'task.txt',
  'extension': '.txt',
  'mimeType': 'text/plain',
  'fileSizeBytes': 1,
  'version': 1,
  'ownerUserId': 'user-1',
  'createdByUserId': 'user-1',
  'createdAtUtc': '2026-09-30T00:00:00Z',
  'updatedAtUtc': '2026-09-30T00:00:00Z',
  'isDeleted': false,
  'processingStatus': processingStatus,
  'scanStatus': scanStatus,
  'aiStatus': aiStatus,
  'accessLevel': accessLevel,
};

Map<String, dynamic> _ticketJson({
  String module = 'Workspaces',
  String resourceType = 'Task',
}) => {
  'module': module,
  'resourceType': resourceType,
  'fileName': 'task.txt',
  'fileSizeBytes': 1,
};

Map<String, dynamic> _shareJson({
  String shareType = 'User',
  String accessLevel = 'Reader',
}) => {
  'id': 'share-1',
  'fileId': 'file-1',
  'shareType': shareType,
  'accessLevel': accessLevel,
  'createdByUserId': 'user-1',
  'createdAtUtc': '2026-09-30T00:00:00Z',
  'effectiveAccessLevel': 'Reader',
  'canRead': true,
  'canComment': false,
  'canEdit': false,
  'canShare': false,
  'canDelete': false,
};
