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
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_page.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  const workspaceId = '550e8400-e29b-41d4-a716-446655440000';
  const fileId = 'file-1';
  final now = DateTime.utc(2026, 9, 18);

  final file = StorageFileResponse(
    id: fileId,
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'specyfikacja.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 1024,
    version: 1,
    workspaceId: workspaceId,
    ownerUserId: 'owner-1',
    createdByUserId: 'owner-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canShare: true,
    canPreview: true,
  );

  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
    registerFallbackValue(
      const CreateStorageFileSharePayload(
        shareType: StorageShareType.workspace,
        accessLevel: StorageShareAccessLevel.reader,
      ),
    );
  });

  void stubListing(_MockStorageRepository repository) {
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(const <StorageFolderResponse>[]));
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
        CursorPageResponse(items: [file]),
      ),
    );
    when(() => repository.listFileShares(fileId)).thenAnswer(
      (_) async => right(const <StorageFileShareResponse>[]),
    );
  }

  Widget harness(
    _MockStorageRepository repository, {
    required bool allowSharing,
  }) => MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(useMaterial3: true),
    home: StorageReadOnlyBrowserPage(
      repository: repository,
      initialScope: const StorageScope.workspace(workspaceId),
      allowSharing: allowSharing,
    ),
  );

  testWidgets('BFF/read-only composition nie pokazuje udostępniania', (
    tester,
  ) async {
    final repository = _MockStorageRepository();
    stubListing(repository);

    await tester.pumpWidget(harness(repository, allowSharing: false));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('share-file-$fileId')), findsNothing);
    verifyNever(() => repository.listFileShares(fileId));
  });

  testWidgets('desktop potwierdza i wywołuje grant workspace', (tester) async {
    final repository = _MockStorageRepository();
    stubListing(repository);
    var refreshCalls = 0;
    final createdShare = StorageFileShareResponse(
      id: 'share-1',
      fileId: fileId,
      shareType: StorageShareType.workspace,
      accessLevel: StorageShareAccessLevel.reader,
      sharedWithWorkspaceId: workspaceId,
      createdByUserId: 'owner-1',
      createdAtUtc: now,
      effectiveAccessLevel: StorageEffectiveAccessLevel.reader,
      canRead: true,
      canComment: false,
      canEdit: false,
      canShare: true,
      canDelete: true,
    );
    when(
      () => repository.createFileShare(
        fileId: fileId,
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => right(createdShare));

    await tester.pumpWidget(harness(repository, allowSharing: true));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const ValueKey('share-file-$fileId')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Workspace: $workspaceId'),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.widgetWithText(FilledButton, 'Udostępnij'));
    await tester.pump(const Duration(milliseconds: 500));

    final payload =
        verify(
              () => repository.createFileShare(
                fileId: fileId,
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as CreateStorageFileSharePayload;
    expect(payload.shareType, StorageShareType.workspace);
    expect(payload.sharedWithWorkspaceId, workspaceId);
    verify(() => repository.listFileShares(fileId)).called(1);

    // Direct construction verifies the callback is only called after Right.
    final cubit = StorageSharingCubit(
      fileId: fileId,
      repository: repository,
      onMutationConfirmed: () async => refreshCalls++,
    );
    when(() => repository.listFileShares(fileId)).thenAnswer(
      (_) async => right([createdShare]),
    );
    await cubit.loadShares();
    await cubit.shareWithWorkspace(
      workspaceId: workspaceId,
      accessLevel: StorageShareAccessLevel.reader,
    );
    await tester.pump();
    expect(refreshCalls, 1);
    await cubit.close();
  });

  test('mapuje backendowy 403 i nie odświeża po nieudanej mutacji', () async {
    final repository = _MockStorageRepository();
    var refreshCalls = 0;
    when(
      () => repository.createFileShare(
        fileId: fileId,
        payload: any(named: 'payload'),
      ),
    ).thenAnswer(
      (_) async => left(
        const ApiError(
          type: ApiErrorType.forbidden,
          statusCode: 403,
          message: 'Brak uprawnień do udostępnienia.',
        ),
      ),
    );
    final cubit = StorageSharingCubit(
      fileId: fileId,
      repository: repository,
      onMutationConfirmed: () async => refreshCalls++,
    );

    final success = await cubit.shareWithWorkspace(
      workspaceId: workspaceId,
      accessLevel: StorageShareAccessLevel.reader,
    );

    expect(success, isFalse);
    expect(cubit.state, isA<StorageSharingFailure>());
    expect((cubit.state as StorageSharingFailure).code, '403');
    expect(refreshCalls, 0);
    await cubit.close();
  });

  test('public link wysyła potwierdzony payload z hasłem i expiry', () async {
    final repository = _MockStorageRepository();
    final expiresAt = DateTime.utc(2026, 12, 31, 23, 59, 59);
    final share = StorageFileShareResponse(
      id: 'public-share-1',
      fileId: fileId,
      shareType: StorageShareType.publicLink,
      accessLevel: StorageShareAccessLevel.reader,
      shareToken: 'opaque-token',
      expiresAtUtc: expiresAt,
      createdByUserId: 'owner-1',
      createdAtUtc: now,
      effectiveAccessLevel: StorageEffectiveAccessLevel.reader,
      canRead: true,
      canComment: false,
      canEdit: false,
      canShare: true,
      canDelete: true,
    );
    when(
      () => repository.createFileShare(
        fileId: fileId,
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) async => right(share));
    final cubit = StorageSharingCubit(fileId: fileId, repository: repository);

    final token = await cubit.createPublicLink(
      accessLevel: StorageShareAccessLevel.reader,
      password: 'tajne-haslo',
      expiresAtUtc: expiresAt,
    );

    final payload =
        verify(
              () => repository.createFileShare(
                fileId: fileId,
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as CreateStorageFileSharePayload;
    expect(token, 'opaque-token');
    expect(payload.shareType, StorageShareType.publicLink);
    expect(payload.accessLevel, StorageShareAccessLevel.reader);
    expect(payload.password, 'tajne-haslo');
    expect(payload.expiresAtUtc, expiresAt);
    await cubit.close();
  });
}
