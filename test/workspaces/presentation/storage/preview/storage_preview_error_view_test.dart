import 'dart:async';

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/text_preview_loader.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_failure_view.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_text_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements StorageRepository {}

class _TextLoader extends Mock implements TextPreviewLoader {}

void main() {
  final now = DateTime.utc(2026, 9, 20);

  final file = StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'raport.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 4096,
    version: 3,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
    canPreview: true,
    canDownload: true,
    canManageVersions: true,
  );

  Widget app(Widget child) => MaterialApp(
    theme: MaterialTheme.crm().light(),
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('preview retains diagnostics and retries the same read', (
    tester,
  ) async {
    final repository = _Repository();
    const error = ApiError(
      type: ApiErrorType.validation,
      message: 'ticket unavailable',
      statusCode: 400,
      apiCode: 'preview.invalid',
      traceId: 'trace-ui',
      fields: {
        'file': ['invalid input'],
      },
    );
    when(() => repository.getDownloadTicket('file-1'))
        .thenAnswer((_) async => const Left(error));
    final cubit = StoragePreviewCubit(repository: repository);
    addTearDown(cubit.close);
    await cubit.preparePreview(file);
    await tester.pumpWidget(
      app(
        BlocProvider.value(
          value: cubit,
          child: StoragePreviewDialog(file: file, repository: repository),
        ),
      ),
    );
    expect(find.textContaining('preview.invalid'), findsOneWidget);
    expect(find.textContaining('trace-ui'), findsOneWidget);
    expect(find.textContaining('invalid input'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    verify(() => repository.getDownloadTicket('file-1')).called(2);
  });

  testWidgets('historical Office preview offers no current editor', (
    tester,
  ) async {
    final repository = _Repository();
    final office = file.copyWith(
      extension: 'docx',
      mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      canEditOnline: true,
    );
    when(
      () =>
          repository.getFileVersionDownloadTicket(fileId: 'file-1', version: 2),
    ).thenAnswer(
      (_) async => Right(
        StorageFileVersionDownloadTicketResponse(
          fileId: 'file-1',
          version: 2,
          originalFileName: 'report.docx',
          mimeType: office.mimeType,
          fileSizeBytes: 10,
          downloadUrl: 'https://files.example/history',
          expiresAtUtc: now,
        ),
      ),
    );
    final cubit = StoragePreviewCubit(repository: repository);
    addTearDown(cubit.close);
    await cubit.prepareVersionPreview(file: office, version: 2);
    await tester.pumpWidget(
      app(
        BlocProvider.value(
          value: cubit,
          child: StoragePreviewDialog(
            file: office,
            repository: repository,
            version: 2,
          ),
        ),
      ),
    );
    expect(find.text('Open document'), findsNothing);
    expect(find.textContaining('historical'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Retry-After disables action and releases its timer on dispose', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      app(
        StoragePreviewFailureView(
          message: 'wait',
          error: ApiError(
            type: ApiErrorType.badResponse,
            message: 'wait',
            statusCode: 429,
            retryAfterUtc: DateTime.now().toUtc().add(
              const Duration(minutes: 1),
            ),
          ),
          onRetry: () async {
            calls++;
          },
        ),
      ),
    );
    final button = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    expect(button.onPressed, isNull);
    await tester.tap(find.text('Retry'));
    expect(calls, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(minutes: 2));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'text read preserves typed error and retries without losing source',
    (tester) async {
      final loader = _TextLoader();
      var count = 0;
      when(() => loader.load('https://files.example/text')).thenAnswer(
        (_) async => ++count == 1
            ? const Left(
                ApiError(
                  type: ApiErrorType.server,
                  message: 'text failed',
                  apiCode: 'text.read',
                  traceId: 'text-trace',
                ),
              )
            : const Right('loaded content'),
      );
      await tester.pumpWidget(
        app(
          StorageTextPreview(url: 'https://files.example/text', loader: loader),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('text.read'), findsOneWidget);
      expect(find.textContaining('text-trace'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('loaded content'), findsOneWidget);
      verify(() => loader.load('https://files.example/text')).called(2);
    },
  );

  testWidgets('text source replacement ignores the old pending response', (
    tester,
  ) async {
    final loader = _TextLoader();
    final old = Completer<Either<ApiError, String>>();
    when(() => loader.load('old')).thenAnswer((_) => old.future);
    when(() => loader.load('new'))
        .thenAnswer((_) async => const Right('new text'));
    await tester.pumpWidget(
      app(StorageTextPreview(url: 'old', loader: loader)),
    );
    await tester.pump();
    await tester.pumpWidget(
      app(StorageTextPreview(url: 'new', loader: loader)),
    );
    await tester.pumpAndSettle();
    old.complete(
      const Left(ApiError(type: ApiErrorType.server, message: 'old error')),
    );
    await tester.pumpAndSettle();
    expect(find.text('new text'), findsOneWidget);
    expect(find.textContaining('old error'), findsNothing);
  });
}
