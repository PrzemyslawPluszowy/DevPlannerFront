import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:devplanner/admin/presentation/admin_users_page.dart';
import 'package:devplanner/app/devplanner_app.dart';
import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/data/auth_composition.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/bootstrap/host_launch_context.dart';
import 'package:devplanner/foundation/http/devplanner_http_transport.dart';
import 'package:devplanner/me/data/me_api_adapter.dart';
import 'package:devplanner/me/data/me_api_transport.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/public_share/storage_public_share_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _StorageRepositoryMock extends Mock implements StorageRepository {}

const _routerFileId = '550e8400-e29b-41d4-a716-446655440001';

StorageFileResponse _routerFile() {
  final now = DateTime.utc(2026, 9, 18);
  return StorageFileResponse(
    id: _routerFileId,
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: 'raport.pdf',
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 10,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    workspaceId: '550e8400-e29b-41d4-a716-446655440000',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.none,
    canRead: true,
    canDownload: true,
    canShare: true,
  );
}

StorageFileDetailsResponse _routerFileDetails() => StorageFileDetailsResponse(
  file: _routerFile(),
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

void _stubStorage(_StorageRepositoryMock repository) {
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
    (_) async => right(CursorPageResponse(items: [_routerFile()])),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });

  group('DevPlannerAuthGuard', () {
    test('public share deep link is anonymous', () {
      expect(
        DevPlannerAuthGuard(session: AuthSessionController()).redirectFor(
          Uri.parse('/storage/public/share-token'),
        ),
        isNull,
      );
      expect(
        DevPlannerRouteCatalog.isStandalonePath(
          '/storage/public/share-token',
        ),
        isTrue,
      );
      expect(
        DevPlannerRouteCatalog.isStandalonePath('/storage/public/'),
        isFalse,
      );
    });

    test('keeps a standalone intended route encoded for login', () {
      final redirect =
          DevPlannerAuthGuard(
            session: AuthSessionController(),
          ).redirectFor(
            Uri.parse('/workspaces/ws-1/projects/p-2?tab=tasks'),
          );

      expect(
        redirect,
        '/login?returnTo=%2Fworkspaces%2Fws-1%2Fprojects%2Fp-2%3Ftab%3Dtasks',
      );
    });

    test('does not guard auth lifecycle paths', () {
      expect(
        DevPlannerAuthGuard(session: AuthSessionController()).redirectFor(
          Uri.parse('/login'),
        ),
        isNull,
      );
      expect(
        DevPlannerAuthGuard(session: AuthSessionController()).redirectFor(
          Uri.parse('/auth/mfa'),
        ),
        isNull,
      );
    });

    test('accepts an authenticated standalone route', () {
      final session = AuthSessionController();
      session.setSignedIn(
        const AuthUser(userId: 'u-1', login: 'user', displayName: 'User'),
      );
      expect(
        DevPlannerAuthGuard(session: session).redirectFor(
          Uri.parse('/workspaces/ws-1'),
        ),
        isNull,
      );
    });
  });

  group('DevPlannerNavigation', () {
    test('builds canonical nested Workspaces paths', () {
      expect(
        DevPlannerRouteCatalog.task('workspace 1', 'project-2', 'task-3'),
        '/workspaces/workspace%201/projects/project-2/tasks/task-3',
      );
      expect(
        DevPlannerRouteCatalog.projectResourceItem(
          'workspace-1',
          'project-2',
          'whiteboards',
          'board-3',
        ),
        '/workspaces/workspace-1/projects/project-2/whiteboards/board-3',
      );
    });

    test(
      'keeps verified file details inside the standalone route boundary',
      () {
        const fileId = '550e8400-e29b-41d4-a716-446655440000';

        expect(
          DevPlannerRouteCatalog.storageFileDetails(fileId),
          '/storage/files/$fileId',
        );
        expect(
          DevPlannerRouteCatalog.isStandalonePath('/storage/files/$fileId'),
          isTrue,
        );
        expect(
          DevPlannerRouteCatalog.isStandalonePath('/storage/files/not-a-uuid'),
          isFalse,
        );
      },
    );

    test('rejects external deep links at the presentation boundary', () async {
      final router = DevPlannerRouter(
        auth: AuthComposition.unavailable(),
      );
      addTearDown(router.dispose);
      final navigation = DevPlannerNavigation(router.config);

      expect(
        await navigation.goDeepLink('https://example.com/workspaces'),
        isFalse,
      );
      expect(await navigation.goDeepLink('/dashboard'), isFalse);
    });
  });

  group('Workspace Files download composition', () {
    const workspaceId = '550e8400-e29b-41d4-a716-446655440000';

    testWidgets('desktop route exposes download for ACL-allowed file', (
      tester,
    ) async {
      final repository = _StorageRepositoryMock();
      _stubStorage(repository);
      final auth = AuthComposition.unavailable();
      auth.session.setSignedIn(
        const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
        clientKind: AuthClientKind.desktopPkce,
      );

      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/workspaces/$workspaceId/files',
            userId: 'user-1',
            userDisplayName: 'User',
          ),
          auth: auth,
          storageRepository: repository,
          httpTransport: DevPlannerHttpTransport(
            dio: Dio(),
            isWeb: false,
            tokenProvider: () async => 'desktop-token',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('download-file-$_routerFileId')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('share-file-$_routerFileId')),
        findsOneWidget,
      );
    });

    testWidgets('BFF route nie wystawia pobierania', (tester) async {
      final repository = _StorageRepositoryMock();
      _stubStorage(repository);
      final auth = AuthComposition.unavailable();
      auth.session.setSignedIn(
        const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
      );

      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/workspaces/$workspaceId/files',
            userId: 'user-1',
            userDisplayName: 'User',
          ),
          auth: auth,
          storageRepository: repository,
          httpTransport: DevPlannerHttpTransport(
            dio: Dio(),
            isWeb: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('download-file-$_routerFileId')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('share-file-$_routerFileId')),
        findsNothing,
      );
    });

    testWidgets('details action opens the verified standalone file route', (
      tester,
    ) async {
      final repository = _StorageRepositoryMock();
      _stubStorage(repository);
      when(
        () => repository.getFileDetails(_routerFileId),
      ).thenAnswer((_) async => right(_routerFileDetails()));
      final auth = AuthComposition.unavailable();
      auth.session.setSignedIn(
        const AuthUser(userId: 'user-1', login: 'user', displayName: 'User'),
        clientKind: AuthClientKind.desktopPkce,
      );

      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/workspaces/$workspaceId/files',
            userId: 'user-1',
            userDisplayName: 'User',
          ),
          auth: auth,
          storageRepository: repository,
          httpTransport: DevPlannerHttpTransport(
            dio: Dio(),
            isWeb: false,
            tokenProvider: () async => 'desktop-token',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('file-details-$_routerFileId')),
      );
      await tester.pumpAndSettle();

      expect(find.text('raport.pdf'), findsOneWidget);
      verify(() => repository.getFileDetails(_routerFileId)).called(1);
    });
  });

  testWidgets(
    'anonymous public share route renders outside authenticated shell',
    (
      tester,
    ) async {
      final repository = _StorageRepositoryMock();

      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/storage/public/share-token',
            userId: 'anonymous',
            userDisplayName: 'Anonymous',
          ),
          auth: AuthComposition.unavailable(),
          storageRepository: repository,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StoragePublicSharePage), findsOneWidget);
      expect(find.text('Workspaces'), findsNothing);
    },
  );

  testWidgets(
    'public share fallback is localized when storage is unavailable',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/storage/public/share-token',
            userId: 'anonymous',
            userDisplayName: 'Anonymous',
          ),
          auth: AuthComposition.unavailable(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Public sharing is temporarily unavailable.'),
        findsOneWidget,
      );
    },
  );

  group('Admin route composition', () {
    testWidgets('does not compose admin through a desktop bearer transport', (
      tester,
    ) async {
      final auth = AuthComposition.unavailable();
      auth.session.setSignedIn(
        const AuthUser(
          userId: 'spoofed-launch-user',
          login: 'admin',
          displayName: 'Admin',
          permissions: {'users.read'},
        ),
        clientKind: AuthClientKind.desktopPkce,
      );

      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/admin',
            userId: 'spoofed-launch-user',
            userDisplayName: 'Admin',
          ),
          auth: auth,
          httpTransport: DevPlannerHttpTransport(
            dio: Dio(),
            isWeb: false,
            tokenProvider: () async => 'desktop-access-token',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminUsersUnavailablePage), findsOneWidget);
      expect(find.byType(AdminUsersPage), findsNothing);
    });

    testWidgets('uses `/me` permissions instead of AuthUser or launch data', (
      tester,
    ) async {
      final auth = AuthComposition.unavailable();
      auth.session.setSignedIn(
        const AuthUser(
          userId: 'spoofed-auth-user',
          login: 'admin',
          displayName: 'Admin',
          permissions: {'users.read'},
        ),
      );
      final httpDio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      httpDio.httpClientAdapter = _JsonAdapter({
        'items': const <Object?>[],
        'nextCursor': null,
      });

      await tester.pumpWidget(
        DevPlannerApp(
          launchContext: const HostLaunchContext(
            initialRoute: '/admin',
            userId: 'spoofed-launch-user',
            userDisplayName: 'Admin',
          ),
          auth: auth,
          meGateway: MeApiAdapter(
            transport: const _MeResponseTransport(
              MeApiResponse(
                statusCode: 200,
                body: {
                  'userId': 'authoritative-me-user',
                  'login': 'admin',
                  'email': 'admin@example.test',
                  'displayName': 'Admin',
                  'roles': ['User'],
                  'permissions': <String>[],
                },
              ),
            ),
          ),
          httpTransport: DevPlannerHttpTransport(dio: httpDio, isWeb: true),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AdminUsersAccessDeniedPage), findsOneWidget);
      expect(find.byType(AdminUsersPage), findsOneWidget);
      expect(find.byType(AdminUsersUnavailablePage), findsNothing);
    });
  });
}

final class _MeResponseTransport implements MeApiTransport {
  const _MeResponseTransport(this.response);

  final MeApiResponse response;

  @override
  Future<MeApiResponse> send(MeApiRequest request) async => response;
}

final class _JsonAdapter implements HttpClientAdapter {
  _JsonAdapter(this.body);

  final Object body;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    jsonEncode(body),
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );

  @override
  void close({bool force = false}) {}
}
