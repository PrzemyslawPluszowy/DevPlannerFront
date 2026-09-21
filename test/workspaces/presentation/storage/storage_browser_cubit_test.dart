import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  late _MockStorageRepository repository;

  setUpAll(() {
    registerFallbackValue(const StorageScope.personal());
    registerFallbackValue(const StorageBrowserFilter());
  });

  setUp(() {
    repository = _MockStorageRepository();
  });

  final now = DateTime.utc(2026, 9, 9, 12);

  final sampleFolder = StorageFolderResponse(
    id: 'f-1',
    name: 'Dokumenty',
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

  final sampleFile = StorageFileResponse(
    id: 'file-1',
    originalFileName: 'raport.pdf',
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

  group('StorageBrowserCubit', () {
    test('początkowy stan to StorageBrowserInitial', () async {
      final cubit = StorageBrowserCubit(repository: repository);
      expect(cubit.state, isA<StorageBrowserInitial>());
      expect(cubit.currentScope, equals(const StorageScope.personal()));
      // Domyślny widok modułu to lista, zgodnie z kształtem ekranu plików.
      expect(cubit.currentViewMode, equals(StorageViewMode.list));
      expect(cubit.currentDensity, equals(StorageDensity.comfortable));
      await cubit.close();
    });

    test(
      'konstruktor przyjmuje widok, sortowanie i gęstość z preferencji',
      () async {
        final cubit = StorageBrowserCubit(
          repository: repository,
          initialViewMode: StorageViewMode.grid,
          initialSort: const StorageSortCriteria(
            field: StorageSortField.name,
            direction: StorageSortDirection.ascending,
          ),
          initialDensity: StorageDensity.compact,
        );
        expect(cubit.currentViewMode, equals(StorageViewMode.grid));
        expect(
          cubit.currentSort,
          equals(
            const StorageSortCriteria(
              field: StorageSortField.name,
              direction: StorageSortDirection.ascending,
            ),
          ),
        );
        expect(cubit.currentDensity, equals(StorageDensity.compact));
        await cubit.close();
      },
    );

    test('zmiana zakresu zachowuje sortowanie i gęstość użytkownika', () async {
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
          const CursorPageResponse<StorageFileResponse>(items: []),
        ),
      );

      final cubit = StorageBrowserCubit(
        repository: repository,
        initialSort: const StorageSortCriteria(field: StorageSortField.size),
        initialDensity: StorageDensity.compact,
      );
      await cubit.setScope(const StorageScope.recent());
      expect(cubit.currentSort.field, equals(StorageSortField.size));
      expect(cubit.currentDensity, equals(StorageDensity.compact));
      await cubit.close();
    });

    test('load emituje Ready gdy są elementy', () async {
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) async => right([sampleFolder]));

      when(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          filter: any(named: 'filter'),
        ),
      ).thenAnswer(
        (_) async => right(CursorPageResponse(items: [sampleFile])),
      );

      final cubit = StorageBrowserCubit(repository: repository);

      await cubit.load();

      expect(cubit.state, isA<StorageBrowserReady>());
      final state = cubit.state as StorageBrowserReady;
      expect(state.folders.length, equals(1));
      expect(state.files.length, equals(1));
      expect(state.folders.first.name, equals('Dokumenty'));
      expect(state.files.first.originalFileName, equals('raport.pdf'));

      await cubit.close();
    });

    test('load emituje Empty gdy brak elementów', () async {
      when(
        () => repository.listFolders(
          scope: any(named: 'scope'),
          parentFolderId: any(named: 'parentFolderId'),
        ),
      ).thenAnswer((_) async => right([]));

      when(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          filter: any(named: 'filter'),
        ),
      ).thenAnswer(
        (_) async => right(const CursorPageResponse(items: [])),
      );

      final cubit = StorageBrowserCubit(repository: repository);

      await cubit.load();

      expect(cubit.state, isA<StorageBrowserEmpty>());

      await cubit.close();
    });

    test(
      'po błędzie w folderze navigateUp wraca do katalogu nadrzędnego',
      () async {
        when(
          () => repository.listFolders(
            scope: any(named: 'scope'),
            parentFolderId: any(named: 'parentFolderId'),
          ),
        ).thenAnswer((_) async => right([sampleFolder]));
        when(() => repository.getFolder(any())).thenAnswer(
          (_) async => right(sampleFolder),
        );
        var filesCall = 0;
        when(
          () => repository.listFiles(
            scope: any(named: 'scope'),
            folderId: any(named: 'folderId'),
            filter: any(named: 'filter'),
          ),
        ).thenAnswer((_) async {
          filesCall++;
          if (filesCall == 2) {
            return left(
              const ApiError(
                type: ApiErrorType.badResponse,
                message: 'Nieprawidłowe żądanie.',
                statusCode: 400,
              ),
            );
          }
          return right(
            const CursorPageResponse<StorageFileResponse>(items: []),
          );
        });

        final cubit = StorageBrowserCubit(repository: repository);
        await cubit.load();
        await cubit.openFolder(sampleFolder);

        expect(cubit.state, isA<StorageBrowserFailure>());
        expect(cubit.currentScope.folderId, sampleFolder.id);

        await cubit.navigateUp();

        expect(cubit.currentScope.folderId, isNull);
        expect(cubit.state, isA<StorageBrowserReady>());
        await cubit.close();
      },
    );

    test('toggleViewMode przełącza tryb widoku', () async {
      final cubit = StorageBrowserCubit(repository: repository);
      expect(cubit.currentViewMode, equals(StorageViewMode.list));
      cubit.toggleViewMode();
      expect(cubit.currentViewMode, equals(StorageViewMode.grid));
      cubit.toggleViewMode();
      expect(cubit.currentViewMode, equals(StorageViewMode.list));
      cubit.setViewMode(StorageViewMode.list);
      expect(cubit.currentViewMode, equals(StorageViewMode.list));
      await cubit.close();
    });

    test('search debouncuje tekst i nie wysyła starszego żądania', () async {
      when(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          filter: any(named: 'filter'),
          query: 'drugi',
        ),
      ).thenAnswer(
        (_) async => right(CursorPageResponse(items: [sampleFile])),
      );
      final cubit = StorageBrowserCubit(repository: repository);

      final first = cubit.search('pierwszy');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final second = cubit.search('drugi');
      await Future.wait([first, second]);

      verify(
        () => repository.listFiles(
          scope: any(named: 'scope'),
          folderId: any(named: 'folderId'),
          filter: any(named: 'filter'),
          query: 'drugi',
        ),
      ).called(1);
      expect((cubit.state as StorageBrowserReady).searchQuery, 'drugi');
      await cubit.close();
    });
  });

  group('StorageSelectionCubit', () {
    test('zaznaczanie i odznaczanie plików oraz folderów', () async {
      final cubit = StorageSelectionCubit();
      expect(cubit.state.hasSelection, isFalse);

      cubit.toggleFile(sampleFile);
      expect(cubit.state.hasSelection, isTrue);
      expect(cubit.state.selectedFileIds.length, equals(1));
      expect(cubit.state.isFileSelected('file-1'), isTrue);

      cubit.toggleFolder(sampleFolder);
      expect(cubit.state.selectedFolderIds.length, equals(1));
      expect(cubit.state.count, equals(2));

      cubit.clearSelection();
      expect(cubit.state.hasSelection, isFalse);
      expect(cubit.state.count, equals(0));

      await cubit.close();
    });

    test('nie przyznaje akcji, których plik nie udostępnia', () async {
      final cubit = StorageSelectionCubit();
      cubit.toggleFile(
        sampleFile.copyWith(
          canRead: false,
          canShare: false,
          canDelete: false,
        ),
      );

      expect(cubit.state.canDelete, isFalse);
      expect(cubit.state.canDownloadZip, isFalse);
      expect(cubit.state.canShare, isFalse);
      expect(cubit.state.canFavorite, isFalse);
      await cubit.close();
    });
  });
}
