import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockStorageRepository extends Mock implements StorageRepository {}

final class _MockFilePickerPort extends Mock implements FilePickerPort {}

final class _MockUploadTransport extends Mock implements UploadTransport {}

final class _PickerAnswer {
  const _PickerAnswer(this.input);

  final StorageUploadInput input;

  Future<List<StorageUploadInput>> call(Invocation _) =>
      Future<List<StorageUploadInput>>.value([input]);
}

void main() {
  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
    registerFallbackValue(UploadCancellationToken());
    registerFallbackValue(
      const StorageUploadInput(name: 'fallback.txt', size: 1),
    );
    registerFallbackValue(
      const StorageUploadTicketPayload(
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.document,
        fileName: 'fallback.txt',
        fileSizeBytes: 1,
      ),
    );
    registerFallbackValue(
      StorageUploadTicketResponse(
        fileId: 'fallback-file',
        storageObjectKey: 'fallback',
        uploadUrl: 'https://storage.invalid/fallback',
        expiresAtUtc: DateTime.utc(2026, 9, 18),
        isAlreadyUploaded: false,
      ),
    );
  });

  final input = StorageUploadInput(
    name: 'raport.txt',
    size: 4,
    bytes: Uint8List.fromList([1, 2, 3, 4]),
    mimeType: 'text/plain',
  );

  final ticket = StorageUploadTicketResponse(
    fileId: 'file-new',
    storageObjectKey: 'workspace/file-new',
    uploadUrl: 'https://storage.invalid/upload/file-new',
    expiresAtUtc: DateTime.utc(2026, 9, 18, 13),
    isAlreadyUploaded: false,
  );

  final uploadedFile = StorageFileResponse(
    id: 'file-new',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: input.name,
    extension: 'txt',
    mimeType: 'text/plain',
    fileSizeBytes: input.size,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: DateTime.utc(2026, 9, 18),
    updatedAtUtc: DateTime.utc(2026, 9, 18),
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    canRead: true,
    canPreview: true,
  );

  test('raportuje postęp i kończy upload dopiero po completeUpload', () async {
    final repository = _MockStorageRepository();
    final transport = _MockUploadTransport();
    when(() => repository.requestUploadTicket(any()))
        .thenAnswer((_) async => right(ticket));
    when(
      () => transport.upload(
        ticket: any(named: 'ticket'),
        input: any(named: 'input'),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((invocation) async {
      final progress =
          invocation.namedArguments[#onProgress] as OnStorageUploadProgress;
      progress(2, 4);
      progress(4, 4);
      return right(unit);
    });
    when(
      () => repository.completeUpload(fileId: ticket.fileId, fileSizeBytes: 4),
    ).thenAnswer((_) async => right(uploadedFile));

    final cubit = StorageUploadCubit(
      repository: repository,
      uploadTransport: transport,
      maxParallelUploads: 1,
    );
    cubit.enqueue([input], const StorageScope.workspace('workspace-1'));
    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(cubit.state.items.single.progress, 1);
    expect(cubit.state.items.single.status, StorageUploadItemStatus.done);
    verify(
      () => repository.completeUpload(fileId: ticket.fileId, fileSizeBytes: 4),
    ).called(1);
    await cubit.close();
  });

  test(
    'anulowanie używa neutralnego portu i emituje typed cancelled',
    () async {
      final repository = _MockStorageRepository();
      final transport = _MockUploadTransport();
      final uploadStarted = Completer<void>();
      final releaseUpload = Completer<Either<ApiError, Unit>>();
      var completionCount = 0;
      when(() => repository.requestUploadTicket(any()))
          .thenAnswer((_) async => right(ticket));
      when(
        () => transport.upload(
          ticket: any(named: 'ticket'),
          input: any(named: 'input'),
          cancelToken: any(named: 'cancelToken'),
          onProgress: any(named: 'onProgress'),
        ),
      ).thenAnswer((_) async {
        uploadStarted.complete();
        return releaseUpload.future;
      });

      final cubit = StorageUploadCubit(
        repository: repository,
        uploadTransport: transport,
        maxParallelUploads: 1,
        onUploadCompleted: () async => completionCount++,
      );
      cubit.enqueue([input], const StorageScope.workspace('workspace-1'));
      await uploadStarted.future;
      cubit.cancel(cubit.state.items.single.id);
      releaseUpload.complete(
        const Left(
          ApiError(type: ApiErrorType.canceled, message: 'cancelled'),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(
        cubit.state.items.single.status,
        StorageUploadItemStatus.cancelled,
      );
      expect(
        cubit.state.items.single.errorCode,
        StorageUploadMessage.uploadCancelled,
      );
      expect(completionCount, 0);
      verifyNever(
        () => repository.completeUpload(
          fileId: ticket.fileId,
          fileSizeBytes: input.size,
        ),
      );
      await cubit.close();
    },
  );

  test(
    'reservation failure remains typed and does not start transfer',
    () async {
      final repository = _MockStorageRepository();
      final transport = _MockUploadTransport();
      when(() => repository.requestUploadTicket(any())).thenAnswer(
        (_) async => const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'reservation denied',
          ),
        ),
      );

      final cubit = StorageUploadCubit(
        repository: repository,
        uploadTransport: transport,
        maxParallelUploads: 1,
      );
      cubit.enqueue([input], const StorageScope.workspace('workspace-1'));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(cubit.state.items.single.status, StorageUploadItemStatus.failed);
      expect(
        cubit.state.items.single.errorCode,
        StorageUploadMessage.ticketReservationFailed,
      );
      verifyNever(
        () => transport.upload(
          ticket: any(named: 'ticket'),
          input: any(named: 'input'),
          cancelToken: any(named: 'cancelToken'),
          onProgress: any(named: 'onProgress'),
        ),
      );
      await cubit.close();
    },
  );

  test('transfer failure remains typed and does not confirm upload', () async {
    final repository = _MockStorageRepository();
    final transport = _MockUploadTransport();
    when(() => repository.requestUploadTicket(any()))
        .thenAnswer((_) async => right(ticket));
    when(
      () => transport.upload(
        ticket: any(named: 'ticket'),
        input: any(named: 'input'),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.connection, message: 'transfer failed'),
      ),
    );

    final cubit = StorageUploadCubit(
      repository: repository,
      uploadTransport: transport,
      maxParallelUploads: 1,
    );
    cubit.enqueue([input], const StorageScope.workspace('workspace-1'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(cubit.state.items.single.status, StorageUploadItemStatus.failed);
    expect(
      cubit.state.items.single.errorCode,
      StorageUploadMessage.transferFailed,
    );
    verifyNever(
      () => repository.completeUpload(
        fileId: ticket.fileId,
        fileSizeBytes: input.size,
      ),
    );
    await cubit.close();
  });

  test('completion failure remains typed after confirmed transfer', () async {
    final repository = _MockStorageRepository();
    final transport = _MockUploadTransport();
    when(() => repository.requestUploadTicket(any()))
        .thenAnswer((_) async => right(ticket));
    when(
      () => transport.upload(
        ticket: any(named: 'ticket'),
        input: any(named: 'input'),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) async => right(unit));
    when(
      () => repository.completeUpload(fileId: ticket.fileId, fileSizeBytes: 4),
    ).thenAnswer(
      (_) async => const Left(
        ApiError(type: ApiErrorType.server, message: 'completion failed'),
      ),
    );

    final cubit = StorageUploadCubit(
      repository: repository,
      uploadTransport: transport,
      maxParallelUploads: 1,
    );
    cubit.enqueue([input], const StorageScope.workspace('workspace-1'));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(cubit.state.items.single.status, StorageUploadItemStatus.failed);
    expect(
      cubit.state.items.single.errorCode,
      StorageUploadMessage.completionFailed,
    );
    await cubit.close();
  });

  testWidgets('po potwierdzonym sukcesie odświeża listę Files', (tester) async {
    final repository = _MockStorageRepository();
    final picker = _MockFilePickerPort();
    final transport = _MockUploadTransport();
    var folderCalls = 0;
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async {
      folderCalls++;
      return right(const <StorageFolderResponse>[]);
    });
    when(
      () => repository.listFiles(
        scope: any(named: 'scope'),
        folderId: any(named: 'folderId'),
        cursor: any(named: 'cursor'),
        limit: any(named: 'limit'),
        query: any(named: 'query'),
        filter: any(named: 'filter'),
      ),
    ).thenAnswer(
      (_) async => right(
        const CursorPageResponse<StorageFileResponse>(items: []),
      ),
    );
    when(picker.pickFiles).thenAnswer(_PickerAnswer(input).call);
    when(() => repository.requestUploadTicket(any()))
        .thenAnswer((_) async => right(ticket));
    when(
      () => transport.upload(
        ticket: any(named: 'ticket'),
        input: any(named: 'input'),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) async => right(unit));
    when(
      () => repository.completeUpload(fileId: ticket.fileId, fileSizeBytes: 4),
    ).thenAnswer((_) async => right(uploadedFile));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: StorageReadOnlyBrowserPage(
          repository: repository,
          filePicker: picker,
          uploadTransport: transport,
          initialScope: const StorageScope.workspace('workspace-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final initialFolderCalls = folderCalls;

    await tester.tap(find.text('Prześlij pliki'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    for (var index = 0; index < 5; index++) {
      await tester.pump(const Duration(milliseconds: 20));
    }

    verify(
      () => repository.completeUpload(fileId: ticket.fileId, fileSizeBytes: 4),
    ).called(1);
    expect(folderCalls, initialFolderCalls + 1);
  });
}
