import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/app/shell/panels/app_global_panels_controller.dart';
import 'package:ready_next/app/shell/panels/app_global_panels_scope.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:ready_next/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:ready_next/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/routing/workspace_resource_pages.dart';
import 'package:ready_next/workspaces/presentation/storage/public_share/storage_public_share_page.dart';

void main() {
  testWidgets(
    'prywatny szczegół pliku deleguje autoryzowaną rozmowę do shella na desktopie i compact bez nawigacji',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final storageRepository = _StorageRepository();
      when(
        () => storageRepository.getFileDetails('file-1'),
      ).thenAnswer((_) async => Right(ResourceChatFixture.fileDetails()));
      final openedConversationIds = <String>[];
      final navigatorObserver = _CountingNavigatorObserver();

      for (final size in const <Size>[Size(1280, 800), Size(800, 600)]) {
        tester.view.physicalSize = size;
        await tester.pumpWidget(
          _ResourceChatFileHarness(
            storageRepository: storageRepository,
            resourceChatRepository: const _ResourceChatRepository(),
            navigatorObserver: navigatorObserver,
            onOpenConversation: openedConversationIds.add,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Czat pliku'));
        await tester.pumpAndSettle();

        expect(openedConversationIds.last, 'conversation-file-1');
        expect(navigatorObserver.pushCount, 1);
      }
    },
  );

  testWidgets(
    'brak canRead nie ujawnia akcji przed rozstrzygnięciem backendu',
    (tester) async {
      final storageRepository = _StorageRepository();
      when(() => storageRepository.getFileDetails('file-1')).thenAnswer(
        (_) async => Right(ResourceChatFixture.fileDetails(canRead: false)),
      );

      await tester.pumpWidget(
        _ResourceChatFileHarness(
          storageRepository: storageRepository,
          resourceChatRepository: const _ResourceChatRepository(),
          navigatorObserver: _CountingNavigatorObserver(),
          onOpenConversation: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Czat pliku'), findsNothing);
    },
  );

  testWidgets(
    'osobisty plik ownera bez placementu workspace nie ujawnia akcji',
    (
      tester,
    ) async {
      final storageRepository = _StorageRepository();
      when(() => storageRepository.getFileDetails('file-1')).thenAnswer(
        (_) async => Right(
          ResourceChatFixture.fileDetails(
            workspaceId: null,
            canOpenResourceChat: false,
          ),
        ),
      );

      await tester.pumpWidget(
        _ResourceChatFileHarness(
          storageRepository: storageRepository,
          resourceChatRepository: const _ResourceChatRepository(),
          navigatorObserver: _CountingNavigatorObserver(),
          onOpenConversation: (_) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Czat pliku'), findsNothing);
    },
  );

  testWidgets(
    '403 resolve ponownie autoryzuje Storage i usuwa prywatny snapshot',
    (tester) async {
      final storageRepository = _StorageRepository();
      var detailsCallCount = 0;
      when(() => storageRepository.getFileDetails('file-1')).thenAnswer((_) {
        detailsCallCount += 1;
        return Future.value(
          detailsCallCount == 1
              ? Right<ApiError, StorageFileDetailsResponse>(
                  ResourceChatFixture.fileDetails(),
                )
              : const Left<ApiError, StorageFileDetailsResponse>(
                  ResourceChatFixture.forbiddenError,
                ),
        );
      });

      await tester.pumpWidget(
        _ResourceChatFileHarness(
          storageRepository: storageRepository,
          resourceChatRepository: const _ResourceChatRepository(
            error: ResourceChatFixture.forbiddenError,
          ),
          navigatorObserver: _CountingNavigatorObserver(),
          onOpenConversation: (_) {},
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Czat pliku'));
      await tester.pumpAndSettle();

      verify(() => storageRepository.getFileDetails('file-1')).called(2);
      expect(find.text('Dokument współdzielony.pdf'), findsNothing);
      expect(find.text('Czat pliku'), findsNothing);
    },
  );

  testWidgets(
    'osobisty plik z capability aktywnego share otwiera Resource Chat',
    (tester) async {
      final storageRepository = _StorageRepository();
      when(() => storageRepository.getFileDetails('file-1')).thenAnswer(
        (_) async => Right(
          ResourceChatFixture.fileDetails(
            workspaceId: null,
          ),
        ),
      );
      final openedConversationIds = <String>[];

      await tester.pumpWidget(
        _ResourceChatFileHarness(
          storageRepository: storageRepository,
          resourceChatRepository: const _ResourceChatRepository(),
          navigatorObserver: _CountingNavigatorObserver(),
          onOpenConversation: openedConversationIds.add,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Czat pliku'));
      await tester.pumpAndSettle();

      expect(openedConversationIds, ['conversation-file-1']);
    },
  );

  testWidgets('publiczny share nie renderuje akcji Resource Chat', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RepositoryProvider<StorageRepository>.value(
          value: _StorageRepository(),
          child: const StoragePublicSharePage(shareToken: 'public-share'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Czat pliku'), findsNothing);
  });
}

/// Udostępnia rzeczywisty widok szczegółu z UI-scoped mostem globalnego Chat.
final class _ResourceChatFileHarness extends StatelessWidget {
  const _ResourceChatFileHarness({
    required this.storageRepository,
    required this.resourceChatRepository,
    required this.navigatorObserver,
    required this.onOpenConversation,
  });

  final StorageRepository storageRepository;
  final ResourceChatRepository resourceChatRepository;
  final NavigatorObserver navigatorObserver;
  final ValueChanged<String> onOpenConversation;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<StorageRepository>.value(value: storageRepository),
      RepositoryProvider<ResourceChatRepository>.value(
        value: resourceChatRepository,
      ),
    ],
    child: MaterialApp(
      locale: const Locale('pl'),
      navigatorObservers: [navigatorObserver],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: AppGlobalPanelsScope(
          controller: AppGlobalPanelsController(),
          openConversation: onOpenConversation,
          openResourceConversation: (request) => onOpenConversation(
            request.conversationId,
          ),
          child: const StorageFilePage(fileId: 'file-1'),
        ),
      ),
    ),
  );
}

/// Mock jest wystarczający, bo widok wywołuje wyłącznie świeże details Storage.
final class _StorageRepository extends Mock implements StorageRepository {}

/// Repozytorium resolve kontroluje wynik reautoryzacji w każdym teście.
final class _ResourceChatRepository implements ResourceChatRepository {
  const _ResourceChatRepository({this.error});

  final ApiError? error;

  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) async => error == null
      ? Right(ResourceChatFixture.conversation(request.fileId))
      : Left(error!);
}

/// Obserwator wykrywa nieautoryzowany push trasy podczas otwierania panelu.
final class _CountingNavigatorObserver extends NavigatorObserver {
  int pushCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushCount += 1;
    super.didPush(route, previousRoute);
  }
}

/// Wspólne, jawne fixture kontraktów Storage i Chat dla testów Resource Chat.
abstract final class ResourceChatFixture {
  static const forbiddenError = ApiError(
    type: ApiErrorType.forbidden,
    message: 'Dostęp cofnięty.',
    backendCode: 403,
  );

  static ChatConversation conversation(String fileId) => ChatConversation(
    id: 'conversation-$fileId',
    type: 'Discussion',
    scopeKind: 'Resource',
    scopeKey: 'files:$fileId',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    postingPermission: 'Everyone',
    isArchived: false,
  );

  static StorageFileDetailsResponse fileDetails({
    bool canRead = true,
    bool canOpenResourceChat = true,
    String? workspaceId = '22222222-2222-4222-8222-222222222222',
    String? projectId,
  }) => StorageFileDetailsResponse(
    file: StorageFileResponse(
      id: 'file-1',
      module: StorageModule.workspaces,
      resourceType: StorageResourceType.privateFile,
      originalFileName: 'Dokument współdzielony.pdf',
      extension: 'pdf',
      mimeType: 'application/pdf',
      fileSizeBytes: 42,
      version: 1,
      ownerUserId: 'owner-1',
      createdByUserId: 'owner-1',
      workspaceId: workspaceId,
      projectId: projectId,
      createdAtUtc: DateTime.utc(2026),
      updatedAtUtc: DateTime.utc(2026),
      isDeleted: false,
      processingStatus: StorageProcessingStatus.ready,
      scanStatus: StorageScanStatus.clean,
      aiStatus: StorageAiStatus.none,
      accessLevel: canRead
          ? StorageEffectiveAccessLevel.reader
          : StorageEffectiveAccessLevel.none,
      canRead: canRead,
    ),
    versions: const [],
    canEdit: false,
    canDelete: false,
    isOfficeDocument: false,
    permissions: StorageFilePermissionsResponse(
      accessLevel: canRead
          ? StorageEffectiveAccessLevel.reader
          : StorageEffectiveAccessLevel.none,
      canRead: canRead,
      canComment: false,
      canEdit: false,
      canShare: false,
      canDelete: false,
    ),
    canOpenResourceChat: canOpenResourceChat,
  );
}
