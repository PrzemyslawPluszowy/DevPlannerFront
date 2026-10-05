import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_share_recipient_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_desktop_sharing_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

class _FakeUserDirectory implements StorageShareRecipientDirectoryPort {
  _FakeUserDirectory(this.users);

  final List<ChatDirectoryEntry> users;
  final List<String> queries = [];

  @override
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String query,
  }) async {
    queries.add(query);
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

  const member = ChatDirectoryEntry(
    userId: 'user-2',
    login: 'anna',
    displayName: 'Anna Nowak',
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
    StorageShareRecipientDirectoryPort? recipientDirectory,
    ThemeData? theme,
    TextScaler textScaler = TextScaler.noScaling,
    Size viewportSize = const Size(1280, 800),
  }) => MaterialApp(
    theme: theme ?? MaterialTheme.crm().light(),
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: MediaQuery(
        data: MediaQueryData(size: viewportSize, textScaler: textScaler),
        child: StorageDesktopSharingDialog(
          file: target,
          repository: repository,
          recipientDirectory: recipientDirectory,
        ),
      ),
    ),
  );

  testWidgets('tryb osoby szuka odbiorcow i udostępnia z poziomem', (
    tester,
  ) async {
    final directory = _FakeUserDirectory([member]);
    await tester.pumpWidget(
      harness(
        target: file(workspaceId: 'ws-1'),
        recipientDirectory: directory,
      ),
    );
    await tester.pumpAndSettle();

    // Odbiorcy nie wymagają administracyjnego kontekstu workspace.
    await tester.enterText(
      find.byKey(const ValueKey('storage_share_user_search')),
      'anna',
    );
    await tester.pumpAndSettle();

    expect(directory.queries, hasLength(1));
    expect(directory.queries.single, 'anna');

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
    'osobisty plik pozwala wyszukac osobe bez workspace i ukrywa pusta sekcje',
    (tester) async {
      final directory = _FakeUserDirectory([member]);
      await tester.pumpWidget(
        harness(target: file(), recipientDirectory: directory),
      );
      await tester.pumpAndSettle();
      expect(find.text('Workspace'), findsNothing);
      await tester.enterText(
        find.byKey(const ValueKey('storage_share_user_search')),
        'anna',
      );
      await tester.pumpAndSettle();
      expect(directory.queries, ['anna']);
      expect(find.text('Anna Nowak'), findsOneWidget);
    },
  );

  testWidgets(
    'public share displays human access and revoke explains access loss',
    (tester) async {
      when(() => repository.listFileShares(any())).thenAnswer(
        (_) async => Right([
          StorageFileShareResponse(
            id: 'public-share',
            fileId: 'file-1',
            shareType: StorageShareType.publicLink,
            accessLevel: StorageShareAccessLevel.reader,
            createdByUserId: 'user-1',
            createdAtUtc: now,
            effectiveAccessLevel: StorageEffectiveAccessLevel.reader,
            canRead: true,
            canComment: false,
            canEdit: false,
            canShare: false,
            canDelete: false,
          ),
        ]),
      );
      await tester.pumpWidget(harness(target: file()));
      await tester.pumpAndSettle();
      expect(find.text('Prawa: reader'), findsNothing);
      expect(find.text('Prawa: Podgląd'), findsOneWidget);
      await tester.ensureVisible(find.byTooltip('Odbierz dostęp'));
      await tester.tap(find.byTooltip('Odbierz dostęp'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Osoba lub link utraci dostęp do tego pliku. Plik pozostanie na swoim miejscu.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('do kosza'), findsNothing);
      // Revoke requires confirmation; merely opening the dialog does not mutate ACL.
      verifyNever(
        () => repository.deleteFileShare(
          fileId: any(named: 'fileId'),
          shareId: any(named: 'shareId'),
        ),
      );
    },
  );

  testWidgets(
    'existing grants show names and meaningful unavailable labels without UUID',
    (tester) async {
      StorageFileShareResponse grant(
        String id,
        StorageShareType type,
        String? name,
      ) => StorageFileShareResponse(
        id: id,
        fileId: 'file-1',
        shareType: type,
        accessLevel: StorageShareAccessLevel.reader,
        sharedWithUserId: type == StorageShareType.user
            ? 'private-user-id'
            : null,
        sharedWithWorkspaceId: type == StorageShareType.workspace
            ? 'private-workspace-id'
            : null,
        sharedWithProjectId: type == StorageShareType.project
            ? 'private-project-id'
            : null,
        targetDisplayName: name,
        createdByUserId: 'user-1',
        createdAtUtc: now,
        effectiveAccessLevel: StorageEffectiveAccessLevel.reader,
        canRead: true,
        canComment: false,
        canEdit: false,
        canShare: false,
        canDelete: false,
      );
      when(() => repository.listFileShares(any())).thenAnswer(
        (_) async => Right([
          grant('one', StorageShareType.user, 'Anna Nowak'),
          grant('two', StorageShareType.workspace, 'Zespół QA'),
          grant('three', StorageShareType.project, 'Projekt QA'),
          grant('four', StorageShareType.user, null),
        ]),
      );
      await tester.pumpWidget(harness(target: file()));
      await tester.pumpAndSettle();
      expect(find.text('Anna Nowak'), findsOneWidget);
      expect(find.textContaining('Zespół QA'), findsOneWidget);
      expect(find.textContaining('Projekt QA'), findsOneWidget);
      expect(find.text('Osoba niedostępna'), findsOneWidget);
      expect(find.textContaining('private-'), findsNothing);
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
        recipientDirectory: _FakeUserDirectory([member]),
      ),
    );
    await tester.pumpAndSettle();

    for (final section in ['Osoby', 'Workspace', 'Link publiczny']) {
      expect(find.text(section), findsWidgets, reason: 'sekcja $section');
    }
    expect(find.byKey(const ValueKey('share-workspace')), findsOneWidget);
  });

  testWidgets(
    'kontrolki dostępu mieszczą się przy 200% w jasnym i ciemnym motywie',
    (
      tester,
    ) async {
      tester.view.physicalSize = const Size(420, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      for (final theme in [
        MaterialTheme.crm().light(),
        MaterialTheme.crm().dark(),
      ]) {
        await tester.pumpWidget(
          harness(
            target: file(workspaceId: 'ws-1'),
            recipientDirectory: _FakeUserDirectory([member]),
            theme: theme,
            textScaler: const TextScaler.linear(2),
            viewportSize: const Size(420, 600),
          ),
        );
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('storage_share_user_search')),
          'anna',
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('storage_share_user-user-2')),
        );
        await tester.pumpAndSettle();

        expect(find.byType(ChoiceChip), findsNWidgets(3));
        expect(
          find.byKey(const ValueKey('storage_share_user_submit')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Komentarz').last);
        await tester.pumpAndSettle();
        final selected = tester.widget<ChoiceChip>(
          find.ancestor(
            of: find.text('Komentarz').last,
            matching: find.byType(ChoiceChip),
          ),
        );
        expect(selected.selected, isTrue);
      }
    },
  );
}
