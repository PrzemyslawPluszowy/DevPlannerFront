import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_realtime_refresh.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_support/storage_realtime_fake_client.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

/// Czeka na dwie rzeczy naraz: dostarczenie zdarzenia (kontroler atrapy jest
/// asynchroniczny, jak produkcyjny) i okno zbierania, które jest timerem,
/// a nie mikrotaskiem.
Future<void> settle() =>
    Future<void>.delayed(const Duration(milliseconds: 20));

void main() {
  late _MockStorageRepository repository;
  late FakeStorageRealtimeClient client;

  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });

  setUp(() {
    repository = _MockStorageRepository();
    client = FakeStorageRealtimeClient();
  });

  final now = DateTime.utc(2026, 9, 20, 12);

  StorageFileResponse file(String id, {String name = 'raport.pdf'}) =>
      StorageFileResponse(
        id: id,
        originalFileName: name,
        extension: 'pdf',
        fileSizeBytes: 1024,
        mimeType: 'application/pdf',
        createdAtUtc: now,
        updatedAtUtc: now,
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.document,
        resourceId: 'res-1',
        ownerUserId: 'user-1',
        createdByUserId: 'user-1',
        scanStatus: StorageScanStatus.clean,
        processingStatus: StorageProcessingStatus.ready,
        aiStatus: StorageAiStatus.completed,
        accessLevel: StorageEffectiveAccessLevel.owner,
        canRead: true,
        canComment: true,
        canEdit: true,
        canShare: true,
        canDelete: true,
        version: 1,
        isDeleted: false,
      );

  StorageFolderResponse folder(String id, {String name = 'Dokumenty'}) =>
      StorageFolderResponse(
        id: id,
        name: name,
        folderType: StorageFolderType.personal,
        itemCount: 0,
        updatedAtUtc: now,
        accessLevel: StorageEffectiveAccessLevel.owner,
        canRead: true,
        canComment: true,
        canEdit: true,
        canShare: true,
        canDelete: true,
      );

  void stubListing({
    required List<StorageFolderResponse> folders,
    required List<StorageFileResponse> files,
  }) {
    when(
      () => repository.listFolders(
        scope: any(named: 'scope'),
        parentFolderId: any(named: 'parentFolderId'),
      ),
    ).thenAnswer((_) async => right(folders));
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
      (_) async => right(CursorPageResponse<StorageFileResponse>(items: files)),
    );
  }

  StorageRealtimeRefreshCoordinator coordinatorFor(
    StorageBrowserCubit browser,
    StorageSelectionCubit selection,
    List<StorageMutationError> failures, {
    Duration debounce = Duration.zero,
  }) => StorageRealtimeRefreshCoordinator(
    client: client,
    browser: browser,
    selection: selection,
    onFailure: failures.add,
    debounce: debounce,
  );

  group('StorageBrowserCubit.refreshFromRealtime', () {
    test('zachowuje folder i liczbę wczytanych pozycji', () async {
      final listing = folder('folder-1');
      stubListing(
        folders: [listing],
        files: [file('file-1'), file('file-2')],
      );

      final cubit = StorageBrowserCubit(
        repository: repository,
        initialScope: const StorageScope.personal(folderId: 'folder-1'),
      );
      await cubit.load();
      expect(cubit.currentScope.folderId, 'folder-1');

      final failure = await cubit.refreshFromRealtime();

      expect(failure, isNull);
      expect(cubit.currentScope.folderId, 'folder-1');
      final state = cubit.state;
      expect(state, isA<StorageBrowserReady>());
      expect((state as StorageBrowserReady).files, hasLength(2));
      // Odświeżenie prosi o tyle pozycji, ile już widać: lista nie zwija się do
      // pierwszej strony, więc widok nie przewija się na górę.
      final limits = verify(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          cursor: any(named: 'cursor'),
          limit: captureAny(named: 'limit'),
          query: any(named: 'query'),
          filter: any(named: 'filter'),
        ),
      ).captured;
      expect(limits, [null, 2]);
      await cubit.close();
    });

    test('nie emituje stanu ładowania i nie podmienia listy na błąd', () async {
      stubListing(
        folders: const [],
        files: [file('file-1'), file('file-2')],
      );
      final cubit = StorageBrowserCubit(repository: repository);
      await cubit.load();

      final states = <StorageBrowserState>[];
      final subscription = cubit.stream.listen(states.add);

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
        (_) async => left(
          const ApiError(
            type: ApiErrorType.badResponse,
            message: 'Plik nie istnieje.',
            statusCode: 404,
            apiCode: 'storage_file.not_found',
            traceId: 'trace-7',
          ),
        ),
      );

      final failure = await cubit.refreshFromRealtime();

      expect(failure, isNotNull);
      expect(failure!.apiCode, 'storage_file.not_found');
      expect(failure.traceId, 'trace-7');
      // Ekran zachowuje to, co użytkownik widzi: awaria odświeżenia nie jest
      // powodem, żeby pokazać mu pustą listę albo spinner.
      expect(states.whereType<StorageBrowserLoading>(), isEmpty);
      expect(states.whereType<StorageBrowserFailure>(), isEmpty);
      expect(cubit.state, isA<StorageBrowserReady>());
      expect((cubit.state as StorageBrowserReady).files, hasLength(2));

      await subscription.cancel();
      await cubit.close();
    });

    test('odświeżenie w trakcie ładowania czeka, zamiast zniknąć', () async {
      stubListing(folders: const [], files: [file('file-1')]);
      final cubit = StorageBrowserCubit(repository: repository);

      final pending = cubit.load();
      // Ładowanie jeszcze leci, więc odświeżenie nie może wejść mu w drogę…
      expect(await cubit.refreshFromRealtime(), isNull);
      await pending;
      // …ale nie może też zniknąć: po zakończeniu ładowania odświeżenie wraca.
      await settle();
      verify(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).called(2);
      await cubit.close();
    });
  });

  group('StorageRealtimeRefreshCoordinator', () {
    test('zdarzenie odświeża listę bez zmiany folderu i bez spinnera', () async {
      stubListing(folders: const [], files: [file('file-1')]);
      final cubit = StorageBrowserCubit(repository: repository);
      final selection = StorageSelectionCubit();
      final failures = <StorageMutationError>[];
      final coordinator = coordinatorFor(cubit, selection, failures);
      await cubit.setScope(
        const StorageScope.personal(folderId: 'folder-1'),
      );
      await cubit.load();
      selection.toggleFile(file('file-1'));
      final states = <StorageBrowserState>[];
      final subscription = cubit.stream.listen(states.add);

      stubListing(
        folders: const [],
        files: [file('file-1'), file('file-2')],
      );
      client.emit(
        const StorageRealtimeEvent(
          type: StorageRealtimeEventType.fileCreated,
          eventId: 'e-1',
        ),
      );
      await settle();

      expect(cubit.currentScope.folderId, 'folder-1');
      expect((cubit.state as StorageBrowserReady).files, hasLength(2));
      expect(states.whereType<StorageBrowserLoading>(), isEmpty);
      expect(failures, isEmpty);
      // Zaznaczenie zostaje: plik nadal jest na liście.
      expect(selection.state.selectedFileIds, {'file-1'});

      await subscription.cancel();
      await coordinator.dispose();
      await cubit.close();
    });

    test('zaznaczenie gubi tylko pliki, których już nie ma', () async {
      stubListing(
        folders: const [],
        files: [file('file-1'), file('file-2')],
      );
      final cubit = StorageBrowserCubit(repository: repository);
      final selection = StorageSelectionCubit();
      final failures = <StorageMutationError>[];
      final coordinator = coordinatorFor(cubit, selection, failures);
      await cubit.load();
      selection.toggleFile(file('file-1'));
      selection.toggleFile(file('file-2'));
      expect(selection.state.selectedFileIds, {'file-1', 'file-2'});

      // Kolega usunął plik-2, więc zaznaczenie nie może go dalej trzymać:
      // akcje zbiorcze działałyby na nieistniejącym pliku.
      stubListing(folders: const [], files: [file('file-1')]);
      client.emit(
        const StorageRealtimeEvent(
          type: StorageRealtimeEventType.fileDeleted,
          eventId: 'e-2',
        ),
      );
      await settle();

      expect(selection.state.selectedFileIds, {'file-1'});

      await coordinator.dispose();
      await cubit.close();
    });

    test('nieudane odświeżenie pokazuje trwały banner z kodem', () async {
      stubListing(folders: const [], files: [file('file-1')]);
      final cubit = StorageBrowserCubit(repository: repository);
      final selection = StorageSelectionCubit();
      final failures = <StorageMutationError>[];
      final coordinator = coordinatorFor(cubit, selection, failures);
      await cubit.load();

      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer(
        (_) async => left(
          const ApiError(
            type: ApiErrorType.unknown,
            message: 'Brak połączenia.',
            statusCode: 503,
            apiCode: 'storage.unavailable',
            traceId: 'trace-9',
          ),
        ),
      );
      client.emit(
        const StorageRealtimeEvent(
          type: StorageRealtimeEventType.fileMoved,
          eventId: 'e-3',
        ),
      );
      await settle();

      expect(failures, hasLength(1));
      expect(failures.single.code, 'storage.unavailable');
      expect(failures.single.traceId, 'trace-9');
      // Odświeżenie listy jest bezpieczne do powtórzenia, więc banner oferuje
      // ponowienie; to jedyna mutacja, dla której wolno to zrobić bez obaw.
      expect(failures.single.onRetry, isNotNull);
      expect(cubit.state, isA<StorageBrowserReady>());

      await coordinator.dispose();
      await cubit.close();
    });

    test('zakres bez kanału zamyka subskrypcję, a zmiana zakresu przestawia ją',
        () async {
      stubListing(folders: const [], files: [file('file-1')]);
      final cubit = StorageBrowserCubit(repository: repository);
      final selection = StorageSelectionCubit();
      final coordinator = coordinatorFor(cubit, selection, []);
      await cubit.load();

      await coordinator.start(
        const StorageScope.personal(),
        ownerUserId: 'user-1',
      );
      expect(client.started, [
        const StorageRealtimeTarget.personal('user-1'),
      ]);

      // Kosz nie ma własnego kanału, więc stara subskrypcja musi zniknąć.
      await coordinator.start(const StorageScope.trash());
      expect(client.stopCount, 1);

      await coordinator.start(const StorageScope.workspace('ws-1'));
      expect(client.started.last, const StorageRealtimeTarget.workspace('ws-1'));

      // Zakres prywatny bez znanego użytkownika nie ma jak zaadresować kanału.
      await coordinator.start(const StorageScope.personal());
      expect(client.stopCount, 2);

      await coordinator.dispose();
      await cubit.close();
    });

    test('nadrobiona historia odświeża listę po pierwszej subskrypcji',
        () async {
      stubListing(folders: const [], files: [file('file-1')]);
      final cubit = StorageBrowserCubit(repository: repository);
      final selection = StorageSelectionCubit();
      final coordinator = coordinatorFor(cubit, selection, []);
      await cubit.load();

      await coordinator.start(const StorageScope.workspace('ws-1'));
      // Kanał czyta historię już przy pierwszej subskrypcji: zmiana, która
      // wydarzyła się między odczytem listy a dołączeniem do grupy, przychodzi
      // jako zdarzenie z odtworzenia i musi odświeżyć widok.
      client.emit(
        const StorageRealtimeEvent(
          type: StorageRealtimeEventType.fileCreated,
          eventId: 'replay-1',
          isReplay: true,
        ),
      );
      await settle();

      // Jedno odświeżenie po nadrobieniu historii, bez czekania na kolejną zmianę.
      verify(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).called(2);

      await coordinator.dispose();
      await cubit.close();
    });

    test('luka historii odświeża od razu, bez okna zbierania', () async {
      stubListing(folders: const [], files: [file('file-1')]);
      final cubit = StorageBrowserCubit(repository: repository);
      final selection = StorageSelectionCubit();
      final coordinator = coordinatorFor(
        cubit,
        selection,
        [],
        debounce: const Duration(seconds: 30),
      );
      await cubit.load();

      client.emit(
        const StorageRealtimeEvent(
          type: StorageRealtimeEventType.resyncRequired,
          isReplay: true,
        ),
      );
      await settle();

      verify(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).called(2);

      await coordinator.dispose();
      await cubit.close();
    });
  });
}
