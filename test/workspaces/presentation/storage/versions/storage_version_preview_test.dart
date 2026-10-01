import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_action_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _MockDownloadTransport extends Mock implements DownloadTransport {}

void main() {
  late _MockStorageRepository repository;
  late _MockDownloadTransport downloadTransport;
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

  StorageFileVersionResponse version(int number) => StorageFileVersionResponse(
    id: 'version-$number',
    version: number,
    fileSizeBytes: 2048,
    createdByUserId: 'user-1',
    createdAtUtc: now,
  );

  setUpAll(() {
    registerFallbackValue(
      StorageFileVersionResponse(
        id: 'version-1',
        version: 1,
        fileSizeBytes: 1,
        createdByUserId: 'user-1',
        createdAtUtc: now,
      ),
    );
  });

  setUp(() {
    repository = _MockStorageRepository();
    downloadTransport = _MockDownloadTransport();
    when(
      () => downloadTransport.downloadUrl(
        downloadUrl: any(named: 'downloadUrl'),
        fileName: any(named: 'fileName'),
      ),
    ).thenAnswer((_) async => const Right(unit));
    when(
      () => repository.listFileVersions(any()),
    ).thenAnswer((_) async => Right([version(3), version(2), version(1)]));
    when(
      () => repository.getFileVersionDownloadTicket(
        fileId: any(named: 'fileId'),
        version: any(named: 'version'),
      ),
    ).thenAnswer(
      (_) async => Right(
        StorageFileVersionDownloadTicketResponse(
          fileId: 'file-1',
          version: 2,
          originalFileName: 'raport.pdf',
          mimeType: 'application/pdf',
          fileSizeBytes: 2048,
          downloadUrl: 'https://files.example/preview/2',
          expiresAtUtc: now,
        ),
      ),
    );
  });

  group('podgląd wersji historycznej', () {
    test('pobiera bilet wersji i nie przywraca pliku', () async {
      final cubit = StoragePreviewCubit(repository: repository);

      await cubit.prepareVersionPreview(file: file, version: 2);

      final state = cubit.state;
      expect(state, isA<StoragePreviewReady>());
      final ready = state as StoragePreviewReady;
      expect(ready.version, 2);
      expect(ready.isHistoricalVersion, isTrue);
      expect(ready.previewUrl, 'https://files.example/preview/2');
      expect(ready.kind, StoragePreviewKind.pdf);

      // Oglądanie starej treści nie może zmienić bieżącego pliku.
      verifyNever(
        () => repository.restoreFileVersion(
          fileId: any(named: 'fileId'),
          version: any(named: 'version'),
          expectedVersion: any(named: 'expectedVersion'),
        ),
      );
      // Bilet bieżącej wersji nie jest przy tym używany.
      verifyNever(() => repository.getDownloadTicket(any()));

      await cubit.close();
    });

    test('błąd biletu wersji nie udaje pustego podglądu', () async {
      when(
        () => repository.getFileVersionDownloadTicket(
          fileId: any(named: 'fileId'),
          version: any(named: 'version'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          ApiError(type: ApiErrorType.badResponse, message: 'Wersja usunięta.'),
        ),
      );
      final cubit = StoragePreviewCubit(repository: repository);

      await cubit.prepareVersionPreview(file: file, version: 2);

      expect(cubit.state, isA<StoragePreviewFailure>());
      expect(
        (cubit.state as StoragePreviewFailure).message,
        'Wersja usunięta.',
      );

      await cubit.close();
    });
  });

  group('dialog wersji', () {
    Future<void> pumpDialog(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().light(),
          locale: const Locale('pl'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: StorageVersionsDialog(
              file: file,
              repository: repository,
              downloadTransport: downloadTransport,
              canRestore: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets(
      'history preview without callback cannot fall back to current download',
      (tester) async {
        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => StoragePreviewCubit(repository: repository),
              ),
              BlocProvider(
                create: (_) => StorageFileMutationCubit(
                  repository: repository,
                  downloadTransport: downloadTransport,
                ),
              ),
            ],
            child: MaterialApp(
              theme: MaterialTheme.crm().light(),
              locale: const Locale('pl'),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: StoragePreviewDialog(
                file: file,
                repository: repository,
                version: 2,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.byTooltip('Pobierz'), findsNothing);
        verifyNever(() => repository.getDownloadTicket(any()));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('każda wersja ma akcję podglądu obok pobrania', (tester) async {
      await pumpDialog(tester);

      expect(find.byKey(const ValueKey('preview-version-3')), findsOneWidget);
      expect(find.byKey(const ValueKey('preview-version-2')), findsOneWidget);
      expect(find.byKey(const ValueKey('preview-version-1')), findsOneWidget);
    });

    testWidgets('restore conflict remains visible above the version list', (
      tester,
    ) async {
      const error = ApiError(
        type: ApiErrorType.conflict,
        message: 'Restore conflict: refresh this history.',
        statusCode: 409,
        apiCode: 'storage.version_conflict',
        contractCode: 'storage.version_conflict',
        fields: {
          'expectedVersion': ['The file changed.'],
        },
        traceId: 'restore-version-trace',
      );
      when(
        () => repository.restoreFileVersion(
          fileId: 'file-1',
          version: 2,
          expectedVersion: 3,
        ),
      ).thenAnswer((_) async => const Left(error));
      await pumpDialog(tester);

      await tester.tap(
        find.byKey(const ValueKey('restore-version-2')),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Restore conflict: refresh this history.'),
        findsOneWidget,
      );
      expect(find.textContaining('restore-version-trace'), findsOneWidget);
      expect(find.textContaining('The file changed.'), findsOneWidget);
      expect(find.byType(StorageVersionsDialog), findsOneWidget);
      verify(
        () => repository.restoreFileVersion(
          fileId: 'file-1',
          version: 2,
          expectedVersion: 3,
        ),
      ).called(1);
    });

    testWidgets('delete failure keeps full conflict feedback in the dialog', (
      tester,
    ) async {
      const error = ApiError(
        type: ApiErrorType.conflict,
        message: 'Delete conflict: refresh this history.',
        statusCode: 409,
        apiCode: 'storage.version_delete_conflict',
        contractCode: 'storage.version_delete_conflict',
        fields: {
          'version': ['This version is still current.'],
        },
        traceId: 'delete-version-trace',
      );
      when(
        () => repository.deleteFileVersion(
          fileId: 'file-1',
          version: 2,
          expectedVersion: 3,
        ),
      ).thenAnswer((_) async => const Left(error));
      await pumpDialog(tester);

      await tester.tap(find.byKey(const ValueKey('delete-version-2')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Usuń poprzednią wersję').last);
      await tester.pumpAndSettle();

      expect(
        find.text('Delete conflict: refresh this history.'),
        findsOneWidget,
      );
      expect(
        find.textContaining('storage.version_delete_conflict'),
        findsNWidgets(2),
      );
      expect(find.textContaining('delete-version-trace'), findsOneWidget);
      expect(
        find.textContaining('This version is still current.'),
        findsOneWidget,
      );
      expect(find.byType(StorageVersionsDialog), findsOneWidget);
      verify(
        () => repository.deleteFileVersion(
          fileId: 'file-1',
          version: 2,
          expectedVersion: 3,
        ),
      ).called(1);
    });

    testWidgets('podgląd otwiera wersję historyczną bez akcji przywrócenia', (
      tester,
    ) async {
      await pumpDialog(tester);

      await tester.tap(find.byKey(const ValueKey('preview-version-2')));
      await tester.pumpAndSettle();

      // Podgląd jest oznaczony jako wersja historyczna…
      expect(find.textContaining('podgląd'), findsWidgets);
      // …i nie oferuje edytora, bo jego sesja dotyczy bieżącej wersji.
      expect(find.text('Otwórz dokument'), findsNothing);
      verifyNever(
        () => repository.restoreFileVersion(
          fileId: any(named: 'fileId'),
          version: any(named: 'version'),
          expectedVersion: any(named: 'expectedVersion'),
        ),
      );
    });
    testWidgets(
      'download from historical preview uses the selected version ticket',
      (tester) async {
        await pumpDialog(tester);
        await tester.tap(find.byKey(const ValueKey('preview-version-2')));
        await tester.pumpAndSettle();
        clearInteractions(repository);
        await tester.tap(
          find.descendant(
            of: find.byType(StoragePreviewDialog),
            matching: find.byTooltip('Pobierz'),
          ),
        );
        await tester.pumpAndSettle();
        verify(
          () => repository.getFileVersionDownloadTicket(
            fileId: 'file-1',
            version: 2,
          ),
        ).called(1);
        verifyNever(() => repository.getDownloadTicket(any()));
        verify(
          () => downloadTransport.downloadUrl(
            downloadUrl: 'https://files.example/preview/2',
            fileName: 'v2-raport.pdf',
          ),
        ).called(1);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('version download failure is shown over the active preview', (
      tester,
    ) async {
      await pumpDialog(tester);
      await tester.tap(find.byKey(const ValueKey('preview-version-2')));
      await tester.pumpAndSettle();
      const error = ApiError(
        type: ApiErrorType.conflict,
        message: 'Historical download is unavailable.',
        statusCode: 409,
        contractCode: 'storage_version_download_conflict',
        fields: {
          'version': ['Refresh the history and try again.'],
        },
        traceId: 'version-download-trace',
      );
      when(
        () => repository.getFileVersionDownloadTicket(
          fileId: 'file-1',
          version: 2,
        ),
      ).thenAnswer((_) async => const Left(error));

      await tester.tap(
        find.descendant(
          of: find.byType(StoragePreviewDialog),
          matching: find.byTooltip('Pobierz'),
        ),
      );
      await tester.pumpAndSettle();

      final preview = find.byType(StoragePreviewDialog);
      expect(preview, findsOneWidget);
      expect(
        find.descendant(
          of: preview,
          matching: find.byType(StoragePreviewActionErrorBanner),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: preview,
          matching: find.textContaining('storage_version_download_conflict'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: preview,
          matching: find.textContaining('version-download-trace'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: preview,
          matching: find.textContaining('Refresh the history and try again.'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
