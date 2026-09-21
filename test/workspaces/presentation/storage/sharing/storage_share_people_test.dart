import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_desktop_sharing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _FakeUserDirectory implements StorageUserDirectoryPort {
  _FakeUserDirectory(this.users);

  final List<LocalUserDirectoryResponse> users;
  final List<({String workspaceId, String query})> queries = [];

  @override
  Future<Either<ApiError, List<LocalUserDirectoryResponse>>> search({
    required String workspaceId,
    required String query,
  }) async {
    queries.add((workspaceId: workspaceId, query: query));
    return Right(users);
  }
}

void main() {
  late _MockStorageRepository repository;
  final now = DateTime.utc(2026, 9, 20);

  StorageFileResponse file({String? workspaceId}) => StorageFileResponse(
    id: 'file-1',
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'umowa.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 1024,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    workspaceId: workspaceId,
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
  );

  const member = LocalUserDirectoryResponse(
    userId: 'user-2',
    login: 'anna',
    displayName: 'Anna Nowak',
    emailVerified: true,
  );

  setUpAll(() {
    registerFallbackValue(
      const CreateStorageFileSharePayload(
        shareType: StorageShareType.user,
        accessLevel: StorageShareAccessLevel.reader,
      ),
    );
  });

  setUp(() {
    repository = _MockStorageRepository();
    when(() => repository.listFileShares(any())).thenAnswer(
      (_) async => const Right(<StorageFileShareResponse>[]),
    );
    when(
      () => repository.createFileShare(
        fileId: any(named: 'fileId'),
        payload: any(named: 'payload'),
      ),
    ).thenAnswer(
      (_) async => Right(
        StorageFileShareResponse(
          id: 'share-1',
          fileId: 'file-1',
          shareType: StorageShareType.user,
          accessLevel: StorageShareAccessLevel.reader,
          sharedWithUserId: 'user-2',
          createdByUserId: 'user-1',
          createdAtUtc: now,
          effectiveAccessLevel: StorageEffectiveAccessLevel.reader,
          canRead: true,
          canComment: false,
          canEdit: false,
          canShare: false,
          canDelete: false,
        ),
      ),
    );
  });

  Widget harness({
    required StorageFileResponse target,
    StorageUserDirectoryPort? userDirectory,
  }) => MaterialApp(
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
      body: StorageDesktopSharingDialog(
        file: target,
        repository: repository,
        userDirectory: userDirectory,
      ),
    ),
  );

  testWidgets('tryb osoby szuka w katalogu workspace i udostępnia z poziomem', (
    tester,
  ) async {
    final directory = _FakeUserDirectory([member]);
    await tester.pumpWidget(
      harness(
        target: file(workspaceId: 'ws-1'),
        userDirectory: directory,
      ),
    );
    await tester.pumpAndSettle();

    // Katalog pyta wyłącznie o workspace pliku.
    await tester.enterText(
      find.byKey(const ValueKey('storage_share_user_search')),
      'anna',
    );
    await tester.pumpAndSettle();

    expect(directory.queries, hasLength(1));
    expect(directory.queries.single.workspaceId, 'ws-1');
    expect(directory.queries.single.query, 'anna');

    await tester.tap(find.byKey(const ValueKey('storage_share_user-user-2')));
    await tester.pumpAndSettle();

    // Poziom edycji jest jawnym wyborem, nie domyślną wartością backendu.
    await tester.tap(find.text('Edycja'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('storage_share_user_submit')));
    await tester.pumpAndSettle();

    final payload =
        verify(
              () => repository.createFileShare(
                fileId: captureAny(named: 'fileId'),
                payload: captureAny(named: 'payload'),
              ),
            ).captured.last
            as CreateStorageFileSharePayload;
    expect(payload.shareType, StorageShareType.user);
    expect(payload.sharedWithUserId, 'user-2');
    expect(payload.accessLevel, StorageShareAccessLevel.editor);
  });

  testWidgets(
    'plik bez kontekstu workspace mówi, że katalog nie jest dostępny',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(
          target: file(),
          userDirectory: _FakeUserDirectory([member]),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('storage_share_user_search')),
        findsNothing,
      );
      expect(
        find.text(
          'Wyszukiwanie lokalnego katalogu jest dostępne dla plików workspace lub projektu.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('brak portu katalogu nie pokazuje pola bez wyników', (
    tester,
  ) async {
    await tester.pumpWidget(harness(target: file(workspaceId: 'ws-1')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('storage_share_user_search')),
      findsNothing,
    );
    verifyNever(
      () => repository.createFileShare(
        fileId: any(named: 'fileId'),
        payload: any(named: 'payload'),
      ),
    );
  });

  testWidgets('dialog pokazuje cztery tryby udostępniania', (tester) async {
    await tester.pumpWidget(
      harness(
        target: file(workspaceId: 'ws-1'),
        userDirectory: _FakeUserDirectory([member]),
      ),
    );
    await tester.pumpAndSettle();

    for (final section in ['Osoby', 'Workspace', 'Link publiczny']) {
      expect(find.text(section), findsWidgets, reason: 'sekcja $section');
    }
    expect(find.byKey(const ValueKey('share-workspace')), findsOneWidget);
  });
}
