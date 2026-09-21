import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_support/storage_realtime_fake_client.dart';

/// Repozytorium bez mocka: zdarzenie realtime odświeża listę z wnętrza ramki
/// testu, a ścieżka asercji mocktail z Timerem zawieszała runner.
final class _FakeRepository extends Fake implements StorageRepository {
  _FakeRepository({this.files = const []});

  List<StorageFileResponse> files;

  /// Limity, o które prosiła lista; pierwszy odczyt idzie bez limitu, każde
  /// odświeżenie prosi o tyle pozycji, ile już widać.
  final List<int?> limits = [];
  int folderListCalls = 0;

  @override
  Future<Either<ApiError, List<StorageFolderResponse>>> listFolders({
    required StorageScope scope,
    String? parentFolderId,
  }) async {
    folderListCalls++;
    return right(const <StorageFolderResponse>[]);
  }

  @override
  Future<Either<ApiError, CursorPageResponse<StorageFileResponse>>> listFiles({
    required StorageScope scope,
    String? folderId,
    String? cursor,
    int? limit,
    String? query,
    StorageBrowserFilter? filter,
  }) async {
    limits.add(limit);
    return right(
      CursorPageResponse<StorageFileResponse>(items: files),
    );
  }
}

void main() {
  final now = DateTime.utc(2026, 9, 20, 12);

  StorageFileResponse file(String id, String name) => StorageFileResponse(
    id: id,
    module: StorageModule.workspaces,
    resourceType: StorageResourceType.document,
    originalFileName: name,
    extension: 'pdf',
    mimeType: 'application/pdf',
    fileSizeBytes: 1024,
    version: 1,
    ownerUserId: 'user-1',
    createdByUserId: 'user-1',
    createdAtUtc: now,
    updatedAtUtc: now,
    isDeleted: false,
    processingStatus: StorageProcessingStatus.ready,
    scanStatus: StorageScanStatus.clean,
    aiStatus: StorageAiStatus.completed,
    accessLevel: StorageEffectiveAccessLevel.owner,
    canRead: true,
    canComment: true,
    canEdit: true,
    canShare: true,
    canDelete: true,
  );

  Widget harness({
    required StorageRepository repository,
    required StorageScope scope,
    required StorageRealtimeFakeClientFactory clientFactory,
  }) => MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('pl'),
    home: Scaffold(
      body: StorageShellPage(
        initialScope: scope,
        storageRepository: repository,
        capabilities: StorageShellCapabilities.desktop,
        realtimeClientFactory: clientFactory,
      ),
    ),
  );

  testWidgets('shell podłącza kanał zakresu trasy i odświeża listę zdarzeniem', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final repository = _FakeRepository(files: [file('file-1', 'dokument.pdf')]);
    final client = FakeStorageRealtimeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      harness(
        repository: repository,
        scope: const StorageScope.workspace('w-1'),
        clientFactory: () => client,
      ),
    );
    await tester.pumpAndSettle();

    // Zakres trasy wybiera kanał: workspace, a nie pliki prywatne, bo to inny
    // zbiór zdarzeń i inna grupa po stronie serwera.
    expect(client.started, [const StorageRealtimeTarget.workspace('w-1')]);
    expect(repository.limits, [null]);
    expect(find.text('dokument.pdf'), findsOneWidget);

    repository.files = [
      file('file-1', 'dokument.pdf'),
      file('file-2', 'cudza-zmiana.pdf'),
    ];
    client.emit(
      const StorageRealtimeEvent(
        type: StorageRealtimeEventType.fileCreated,
        eventId: 'e-1',
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    // Odświeżenie pokazuje cudzą zmianę, nie zwija listy do pierwszej strony
    // i nie pokazuje spinnera: użytkownik zostaje w tym samym widoku.
    expect(repository.limits, [null, 1]);
    expect(find.text('cudza-zmiana.pdf'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('zakres bez kanału nie otwiera subskrypcji', (tester) async {
    final repository = _FakeRepository(files: [file('file-1', 'dokument.pdf')]);
    final client = FakeStorageRealtimeClient();
    addTearDown(client.dispose);

    await tester.pumpWidget(
      harness(
        repository: repository,
        scope: const StorageScope.trash(),
        clientFactory: () => client,
      ),
    );
    await tester.pumpAndSettle();

    // Kosz nie ma odpowiednika w hubie, więc ekran nie subskrybuje niczego
    // zamiast podszywać się pod pliki prywatne.
    expect(client.started, isEmpty);
    expect(find.text('dokument.pdf'), findsOneWidget);
  });

  testWidgets('zamknięcie ekranu zamyka kanał', (tester) async {
    final repository = _FakeRepository(files: [file('file-1', 'dokument.pdf')]);
    final client = FakeStorageRealtimeClient();

    await tester.pumpWidget(
      harness(
        repository: repository,
        scope: const StorageScope.workspace('w-1'),
        clientFactory: () => client,
      ),
    );
    await tester.pumpAndSettle();
    expect(client.disposed, isFalse);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pumpAndSettle();

    // Ekran jest właścicielem kanału, więc nie zostawia otwartego połączenia
    // po wyjściu z modułu.
    expect(client.disposed, isTrue);
  });
}

/// Fabryka kanału dla ekranu; typedef z portu wystarcza, ale własny alias
/// trzyma sygnaturę czytelną w asercjach.
typedef StorageRealtimeFakeClientFactory = FakeStorageRealtimeClient Function();
