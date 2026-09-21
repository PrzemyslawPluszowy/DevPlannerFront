import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _MockDownloadTransport extends Mock implements DownloadTransport {}

void main() {
  late _MockStorageRepository repository;
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
              downloadTransport: _MockDownloadTransport(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('każda wersja ma akcję podglądu obok pobrania', (tester) async {
      await pumpDialog(tester);

      expect(find.byKey(const ValueKey('preview-version-3')), findsOneWidget);
      expect(find.byKey(const ValueKey('preview-version-2')), findsOneWidget);
      expect(find.byKey(const ValueKey('preview-version-1')), findsOneWidget);
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
  });
}
