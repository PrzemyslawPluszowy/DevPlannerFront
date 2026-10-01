import 'dart:async';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_attachment_repository.dart';
import 'package:devplanner/workspaces/domain/services/task_attachment_upload_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/attachments/cubit/task_attachments_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_attachments.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

final class _AttachmentRepository implements TaskAttachmentRepository {
  final ticketRequest = Completer<void>();
  final ticketResult =
      Completer<Either<ApiError, BulkStorageUploadTicketResponse>>();
  int ticketRequestCount = 0;
  final requestedDeletedModes = <bool>[];
  ApiError? nextListError;

  @override
  Future<Either<ApiError, List<StorageFileResponse>>> list({
    required String workspaceId,
    required String projectId,
    required String taskId,
    bool includeDeleted = false,
  }) async {
    requestedDeletedModes.add(includeDeleted);
    final error = nextListError;
    nextListError = null;
    if (error != null) return Left(error);
    return const Right([]);
  }

  @override
  Future<Either<ApiError, BulkStorageUploadTicketResponse>> requestTickets({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String idempotencyKey,
    required BulkTaskUploadTicketPayload payload,
  }) {
    ticketRequestCount++;
    if (!ticketRequest.isCompleted) ticketRequest.complete();
    return ticketResult.future;
  }

  @override
  Future<Either<ApiError, BulkCompleteUploadResponse>> complete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required BulkCompleteUploadPayload payload,
  }) async => throw StateError('Unexpected complete call');
}

final class _UploadTransport implements TaskAttachmentUploadTransport {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _StorageRepository implements StorageRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _DownloadTransport implements DownloadTransport {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('failed byte read is localized and never starts an upload', (
    tester,
  ) async {
    final repository = _AttachmentRepository();
    final attachments = _attachments(repository);
    final registry = TaskDetailDraftRegistry();
    await attachments.load();
    await _pumpBody(
      tester,
      attachments: attachments,
      registry: registry,
      selectFiles: () async => [_pickedFile()],
      readFileBytes: (_) async => throw StateError('private file path omitted'),
    );

    await tester.tap(find.text('Add files'));
    await tester.pumpAndSettle();

    final ready = attachments.state as TaskAttachmentsReady;
    expect(ready.apiError?.apiCode, 'task_upload_read_failed');
    expect(ready.error, 'Could not read the selected file.');
    expect(repository.ticketRequestCount, 0);
    expect(registry.hasUnsavedDrafts, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await attachments.close();
    registry.dispose();
  });

  testWidgets('pending upload is a guarded draft and disables new selection', (
    tester,
  ) async {
    final repository = _AttachmentRepository();
    final attachments = _attachments(repository);
    final registry = TaskDetailDraftRegistry();
    var pickerCalls = 0;
    var readerCalls = 0;
    await attachments.load();
    await _pumpBody(
      tester,
      attachments: attachments,
      registry: registry,
      selectFiles: () async {
        pickerCalls++;
        return [_pickedFile()];
      },
      readFileBytes: (_) async {
        readerCalls++;
        return Uint8List.fromList([1]);
      },
    );

    expect(attachments.state, isA<TaskAttachmentsReady>());
    final addFiles = find.widgetWithText(TextButton, 'Add files');
    expect(addFiles, findsOneWidget);
    expect(tester.widget<TextButton>(addFiles).onPressed, isNotNull);
    await tester.tap(addFiles);
    await tester.pump(const Duration(milliseconds: 100));

    expect(pickerCalls, 1);
    expect(readerCalls, 1);
    expect(registry.hasUnsavedDrafts, isTrue);
    expect(
      (attachments.state as TaskAttachmentsReady).error,
      isNull,
      reason: 'Upload preparation unexpectedly reported an error',
    );
    expect(repository.ticketRequestCount, 1);
    expect((attachments.state as TaskAttachmentsReady).isUploading, isTrue);
    expect(registry.hasUnsavedDrafts, isTrue);
    await tester.tap(find.byTooltip('Cancel'));
    await tester.pump();
    expect((attachments.state as TaskAttachmentsReady).isUploading, isFalse);
    expect(registry.hasUnsavedDrafts, isFalse);
    expect(find.byTooltip('Preparing files…'), findsOneWidget);
    expect(
      tester.widget<TextButton>(addFiles).onPressed,
      isNull,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    registry.dispose();
    repository.ticketResult.complete(
      const Left(
        ApiError(type: ApiErrorType.canceled, message: 'Canceled for test'),
      ),
    );
    await tester.pump();
    await attachments.close();
  });

  testWidgets('deleted mode keeps its selection when refresh fails', (
    tester,
  ) async {
    final repository = _AttachmentRepository();
    final attachments = _attachments(repository);
    final registry = TaskDetailDraftRegistry();
    await attachments.load();
    await _pumpBody(
      tester,
      attachments: attachments,
      registry: registry,
      selectFiles: () async => const [],
      readFileBytes: (_) async => Uint8List(0),
    );
    repository.nextListError = const ApiError(
      type: ApiErrorType.connection,
      message: 'Network error',
      apiCode: 'network_unavailable',
    );

    await tester.tap(find.text('Show deleted'));
    await tester.pumpAndSettle();

    final ready = attachments.state as TaskAttachmentsReady;
    expect(repository.requestedDeletedModes, [false, true]);
    expect(ready.includeDeleted, isTrue);
    expect(ready.isRefreshing, isFalse);
    expect(ready.apiError?.apiCode, 'network_unavailable');
    expect(find.text('Hide deleted'), findsOneWidget);
    expect(registry.hasUnsavedDrafts, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await attachments.close();
    registry.dispose();
  });

  testWidgets('provider replacement discards a pending read without upload', (
    tester,
  ) async {
    final oldRepository = _AttachmentRepository();
    final newRepository = _AttachmentRepository();
    final oldCubit = _attachments(oldRepository);
    final newCubit = _attachments(newRepository);
    final registry = TaskDetailDraftRegistry();
    final pickerCompleted = Completer<void>();
    final readBytes = Completer<Uint8List>();
    await oldCubit.load();
    await newCubit.load();
    await _pumpBody(
      tester,
      attachments: oldCubit,
      registry: registry,
      selectFiles: () async {
        if (!pickerCompleted.isCompleted) pickerCompleted.complete();
        return [_pickedFile()];
      },
      readFileBytes: (_) => readBytes.future,
    );

    await tester.tap(find.text('Add files'));
    await pickerCompleted.future;
    await tester.pump();
    expect(registry.hasUnsavedDrafts, isTrue);

    await _pumpBody(
      tester,
      attachments: newCubit,
      registry: registry,
      selectFiles: () async => const [],
      readFileBytes: (_) async => Uint8List(0),
    );
    expect(registry.hasUnsavedDrafts, isFalse);
    readBytes.complete(Uint8List.fromList([1]));
    await tester.pump(const Duration(milliseconds: 100));

    expect(oldRepository.ticketRequestCount, 0);
    expect(newRepository.ticketRequestCount, 0);
    expect((oldCubit.state as TaskAttachmentsReady).error, isNull);
    expect((newCubit.state as TaskAttachmentsReady).error, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    registry.dispose();
    await oldCubit.close();
    await newCubit.close();
  });
}

TaskAttachmentsCubit _attachments(_AttachmentRepository repository) =>
    TaskAttachmentsCubit(
      repository: repository,
      uploadTransport: _UploadTransport(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

XFile _pickedFile() => XFile('/fixture/brief.pdf');

Future<void> _pumpBody(
  WidgetTester tester, {
  required TaskAttachmentsCubit attachments,
  required TaskDetailDraftRegistry registry,
  required Future<List<XFile>?> Function() selectFiles,
  required Future<Uint8List> Function(XFile file) readFileBytes,
}) async {
  final mutation = StorageFileMutationCubit(
    repository: _StorageRepository(),
    downloadTransport: _DownloadTransport(),
  );
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      theme: MaterialTheme.crm().light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: TaskDetailDraftScope(
        registry: registry,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TaskAttachmentsCubit>.value(value: attachments),
            BlocProvider<StorageFileMutationCubit>.value(value: mutation),
          ],
          child: Scaffold(
            body: TaskAttachmentsBody(
              isEditable: true,
              selectFiles: selectFiles,
              readFileBytes: readFileBytes,
            ),
          ),
        ),
      ),
    ),
  );
}
