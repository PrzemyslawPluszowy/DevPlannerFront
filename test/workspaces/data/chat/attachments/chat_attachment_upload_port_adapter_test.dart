import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/workspaces/data/chat/attachments/chat_attachment_upload_port_adapter.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/domain/chat/attachments/models/chat_attachment_session.dart';
import 'package:ready_next/workspaces/domain/chat/attachments/ports/chat_attachment_session_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:ready_next/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';

final class _MockSessionRepository extends Mock
    implements ChatAttachmentSessionRepository {}

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _MockUploadTransport extends Mock implements UploadTransport {}

void main() {
  late _MockSessionRepository sessionRepository;
  late _MockStorageRepository storageRepository;
  late _MockUploadTransport uploadTransport;
  late ChatAttachmentUploadPortAdapter adapter;

  final input = StorageUploadInput(
    name: 'brief.pdf',
    size: 3,
    bytes: Uint8List.fromList([1, 2, 3]),
    mimeType: 'application/pdf',
  );
  final ticket = StorageUploadTicketResponse(
    fileId: 'file-1',
    storageObjectKey: 'workspaces/file-1',
    uploadUrl: 'https://storage.example/upload/file-1',
    expiresAtUtc: DateTime.utc(2026, 9, 14, 12),
    isAlreadyUploaded: false,
  );

  setUpAll(() {
    registerFallbackValue(
      const StorageUploadTicketPayload(
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.comment,
        resourceId: 'session-1',
        fileName: 'brief.pdf',
        fileSizeBytes: 3,
      ),
    );
    registerFallbackValue(
      const StorageUploadInput(name: 'fallback.txt', size: 1),
    );
    registerFallbackValue(ticket);
  });

  setUp(() {
    sessionRepository = _MockSessionRepository();
    storageRepository = _MockStorageRepository();
    uploadTransport = _MockUploadTransport();
    adapter = ChatAttachmentUploadPortAdapter(
      sessionRepository: sessionRepository,
      storageRepository: storageRepository,
      uploadTransport: uploadTransport,
    );
  });

  test('creates and cancels the Chat session through its repository', () async {
    when(() => sessionRepository.createAttachmentSession('conversation-1'))
        .thenAnswer(
          (_) async => Right(
            ChatAttachmentSession(
              id: 'session-1',
              conversationId: 'conversation-1',
              expiresAtUtc: DateTime.utc(2026, 9, 14, 12),
            ),
          ),
        );
    when(
      () => sessionRepository.cancelAttachmentSession(
        conversationId: 'conversation-1',
        sessionId: 'session-1',
      ),
    ).thenAnswer((_) async => const Right(null));

    final session = await adapter.createSession('conversation-1');
    await adapter.cancelSession('conversation-1', session.id);

    expect(session.id, 'session-1');
    verify(
      () => sessionRepository.cancelAttachmentSession(
        conversationId: 'conversation-1',
        sessionId: 'session-1',
      ),
    ).called(1);
  });

  test(
    'reserves, uploads and completes with the exact Storage request shape',
    () async {
      when(() => storageRepository.requestUploadTicket(any()))
          .thenAnswer((_) async => Right(ticket));
      when(
        () => uploadTransport.upload(ticket: ticket, input: input),
      ).thenAnswer((_) async => const Right(unit));
      when(
        () => storageRepository.completeUpload(
          fileId: 'file-1',
          fileSizeBytes: 3,
        ),
      ).thenAnswer((_) async => Right(_file()));

      final chatTicket = await adapter.createTicket(
        sessionId: 'session-1',
        input: input,
      );
      await adapter.upload(chatTicket, input);
      await adapter.complete(chatTicket.storageFileId);

      expect(chatTicket.storageFileId, 'file-1');
      final payload =
          verify(
                () => storageRepository.requestUploadTicket(captureAny()),
              ).captured.single
              as StorageUploadTicketPayload;
      expect(
        payload,
        const StorageUploadTicketPayload(
          module: StorageModule.workspaces,
          resourceType: StorageResourceType.comment,
          resourceId: 'session-1',
          fileName: 'brief.pdf',
          fileSizeBytes: 3,
          mimeType: 'application/pdf',
        ),
      );
      verify(() => uploadTransport.upload(ticket: ticket, input: input))
          .called(1);
      verify(
        () => storageRepository.completeUpload(
          fileId: 'file-1',
          fileSizeBytes: 3,
        ),
      ).called(1);
    },
  );

  for (final testCase
      in <
        (
          String,
          StorageScanStatus,
          StorageProcessingStatus,
          ChatAttachmentRemoteStatus,
        )
      >[
        (
          'pending scan',
          StorageScanStatus.pending,
          StorageProcessingStatus.none,
          ChatAttachmentRemoteStatus.pending,
        ),
        (
          'queued processing',
          StorageScanStatus.pending,
          StorageProcessingStatus.queued,
          ChatAttachmentRemoteStatus.processing,
        ),
        (
          'active processing',
          StorageScanStatus.clean,
          StorageProcessingStatus.processing,
          ChatAttachmentRemoteStatus.processing,
        ),
        (
          'clean ready',
          StorageScanStatus.clean,
          StorageProcessingStatus.ready,
          ChatAttachmentRemoteStatus.cleanReady,
        ),
        (
          'infected scan',
          StorageScanStatus.infected,
          StorageProcessingStatus.ready,
          ChatAttachmentRemoteStatus.infected,
        ),
        (
          'failed processing',
          StorageScanStatus.pending,
          StorageProcessingStatus.failed,
          ChatAttachmentRemoteStatus.failed,
        ),
        (
          'skipped scan fails closed',
          StorageScanStatus.skipped,
          StorageProcessingStatus.ready,
          ChatAttachmentRemoteStatus.failed,
        ),
      ]) {
    test('maps ${testCase.$1} to ${testCase.$4}', () async {
      when(() => storageRepository.getFileDetails('file-1')).thenAnswer(
        (_) async => Right(
          _details(scanStatus: testCase.$2, processingStatus: testCase.$3),
        ),
      );

      expect(await adapter.status('file-1'), testCase.$4);
    });
  }
}

StorageFileDetailsResponse _details({
  required StorageScanStatus scanStatus,
  required StorageProcessingStatus processingStatus,
}) => StorageFileDetailsResponse(
  file: _file(scanStatus: scanStatus, processingStatus: processingStatus),
  versions: const [],
  canEdit: false,
  canDelete: false,
  isOfficeDocument: false,
  permissions: const StorageFilePermissionsResponse(
    accessLevel: StorageEffectiveAccessLevel.reader,
    canRead: true,
    canComment: false,
    canEdit: false,
    canShare: false,
    canDelete: false,
  ),
);

StorageFileResponse _file({
  StorageScanStatus scanStatus = StorageScanStatus.clean,
  StorageProcessingStatus processingStatus = StorageProcessingStatus.ready,
}) => StorageFileResponse(
  id: 'file-1',
  module: StorageModule.workspaces,
  resourceType: StorageResourceType.comment,
  resourceId: 'session-1',
  originalFileName: 'brief.pdf',
  extension: 'pdf',
  mimeType: 'application/pdf',
  fileSizeBytes: 3,
  version: 1,
  ownerUserId: 'user-1',
  createdByUserId: 'user-1',
  createdAtUtc: DateTime.utc(2026, 9, 14, 12),
  updatedAtUtc: DateTime.utc(2026, 9, 14, 12),
  isDeleted: false,
  processingStatus: processingStatus,
  scanStatus: scanStatus,
  aiStatus: StorageAiStatus.none,
);
