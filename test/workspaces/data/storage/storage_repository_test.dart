import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorageApi extends Mock implements StorageApi {}

void main() {
  test('StorageFileResponse zachowuje capabilities zwrócone przez backend', () {
    final file = StorageFileResponse.fromJson({
      'id': 'file-1',
      'module': 'Workspaces',
      'resourceType': 'Private',
      'originalFileName': 'raport.odt',
      'extension': 'odt',
      'mimeType': 'application/vnd.oasis.opendocument.text',
      'fileSizeBytes': 128,
      'version': 1,
      'ownerUserId': 'owner-1',
      'createdByUserId': 'owner-1',
      'createdAtUtc': '2026-09-09T08:00:00Z',
      'updatedAtUtc': '2026-09-09T08:00:00Z',
      'isDeleted': false,
      'processingStatus': 'Ready',
      'scanStatus': 'Clean',
      'aiStatus': 'None',
      'canPreview': true,
      'canEditOnline': true,
      'canDownload': true,
      'canManageVersions': true,
      'canRestore': false,
      'canConvertToPdf': true,
    });

    expect(file.canPreview, isTrue);
    expect(file.canEditOnline, isTrue);
    expect(file.canDownload, isTrue);
    expect(file.canManageVersions, isTrue);
    expect(file.canRestore, isFalse);
    expect(file.canConvertToPdf, isTrue);
  });

  late _MockStorageApi api;
  late StorageRepositoryImpl repository;

  setUp(() {
    api = _MockStorageApi();
    repository = StorageRepositoryImpl(api);
  });

  setUpAll(() {
    registerFallbackValue(
      const CreateStorageFolderPayload(
        folderType: StorageFolderType.personal,
        name: 'test',
      ),
    );
    registerFallbackValue(
      const UpdateStorageFolderPayload(name: 'updated'),
    );
    registerFallbackValue(
      const SetStorageFileFavoritePayload(isFavorite: true),
    );
    registerFallbackValue(
      const RestoreStorageFileVersionPayload(expectedVersion: 1),
    );
    registerFallbackValue(
      const CreateStorageDocumentPayload(
        name: 'document',
        format: StorageDocumentFormat.docx,
        module: StorageModule.workspaces,
        resourceType: StorageResourceType.privateFile,
      ),
    );
    registerFallbackValue('storage-document-test-key');
  });

  final now = DateTime.utc(2026, 9, 9, 10);

  final sampleFile = StorageFileResponse(
    id: 'file-123',
    originalFileName: 'document.pdf',
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

  final sampleFolder = StorageFolderResponse(
    id: 'folder-1',
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

  group('StorageRepositoryImpl - listFiles', () {
    test('przekazuje parametry widoku personal i filtrów', () async {
      when(
        () => api.listFiles(
          module: any(named: 'module'),
          resourceType: any(named: 'resourceType'),
          resourceId: any(named: 'resourceId'),
          cursor: any(named: 'cursor'),
          limit: any(named: 'limit'),
          view: 'My',
          query: 'raport',
          mimeType: 'application/pdf',
          createdFromUtc: any(named: 'createdFromUtc'),
          createdToUtc: any(named: 'createdToUtc'),
          minSizeBytes: any(named: 'minSizeBytes'),
          maxSizeBytes: any(named: 'maxSizeBytes'),
          ownerUserId: any(named: 'ownerUserId'),
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
          folderId: 'folder-1',
        ),
      ).thenAnswer(
        (_) async => CursorPageResponse(
          items: [sampleFile],
          nextCursor: 'next-1',
        ),
      );

      final result = await repository.listFiles(
        scope: const StorageScope.personal(folderId: 'folder-1'),
        query: 'raport',
        filter: const StorageBrowserFilter(mimeType: 'application/pdf'),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Oczekiwano sukcesu'),
        (page) {
          expect(page.items.length, 1);
          expect(page.items.first.id, 'file-123');
          expect(page.nextCursor, 'next-1');
        },
      );
    });

    test(
      'dla trash scope ustawia includeDeleted: true i view: trash',
      () async {
        when(
          () => api.listFiles(
            module: any(named: 'module'),
            resourceType: any(named: 'resourceType'),
            resourceId: any(named: 'resourceId'),
            cursor: any(named: 'cursor'),
            limit: any(named: 'limit'),
            view: 'Trash',
            includeDeleted: true,
            query: any(named: 'query'),
            mimeType: any(named: 'mimeType'),
            extension: any(named: 'extension'),
            aiTag: any(named: 'aiTag'),
            aiStatus: any(named: 'aiStatus'),
            createdFromUtc: any(named: 'createdFromUtc'),
            createdToUtc: any(named: 'createdToUtc'),
            minSizeBytes: any(named: 'minSizeBytes'),
            maxSizeBytes: any(named: 'maxSizeBytes'),
            ownerUserId: any(named: 'ownerUserId'),
            workspaceId: any(named: 'workspaceId'),
            projectId: any(named: 'projectId'),
            folderId: any(named: 'folderId'),
          ),
        ).thenAnswer(
          (_) async => CursorPageResponse(
            items: [sampleFile],
          ),
        );

        final result = await repository.listFiles(
          scope: const StorageScope.trash(),
        );

        expect(result.isRight(), isTrue);
        verify(
          () => api.listFiles(
            view: 'Trash',
            includeDeleted: true,
          ),
        ).called(1);
      },
    );
  });

  group('StorageRepositoryImpl - foldery', () {
    test('listFolders zwraca wyłącznie dzieci wskazanego folderu', () async {
      final child = sampleFolder.copyWith(
        id: 'child',
        parentFolderId: 'parent',
      );
      final root = sampleFolder.copyWith(id: 'root');
      when(
        () => api.listFolders(
          folderType: 'Personal',
        ),
      ).thenAnswer((_) async => [root, child]);

      final result = await repository.listFolders(
        scope: const StorageScope.personal(),
        parentFolderId: 'parent',
      );

      result.fold(
        (error) => fail(error.message),
        (folders) => expect(folders.map((folder) => folder.id), ['child']),
      );
    });

    test('createFolder wywołuje api i zwraca nowo utworzony folder', () async {
      when(() => api.createFolder(any())).thenAnswer((_) async => sampleFolder);

      final result = await repository.createFolder(
        scope: const StorageScope.personal(),
        name: 'Dokumenty',
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Oczekiwano sukcesu'),
        (folder) => expect(folder.name, 'Dokumenty'),
      );
    });

    test('deleteFolder wywołuje api i zwraca Unit', () async {
      when(() => api.deleteFolder('folder-1')).thenAnswer((_) async {});

      final result = await repository.deleteFolder('folder-1');

      expect(result.isRight(), isTrue);
      verify(() => api.deleteFolder('folder-1')).called(1);
    });
  });

  group('StorageRepositoryImpl - tworzenie dokumentów', () {
    test('wysyła niepusty Idempotency-Key przy tworzeniu dokumentu', () async {
      when(
        () => api.createStorageDocument(any(), any()),
      ).thenAnswer((_) async => sampleFile);

      final result = await repository.createStorageDocument(
        scope: const StorageScope.personal(),
        name: 'Nowy dokument',
        format: StorageDocumentFormat.docx,
        idempotencyKey: 'storage-document-attempt-1',
      );

      expect(result.isRight(), isTrue);
      final captured = verify(
        () => api.createStorageDocument(captureAny(), captureAny()),
      ).captured;
      expect(captured[1] as String, 'storage-document-attempt-1');
    });
  });

  group('StorageRepositoryImpl - pliki i wersje', () {
    test('setFileFavorite aktualizuje stan ulubionego', () async {
      const userState = StorageFileUserStateResponse(
        fileId: 'file-123',
        isFavorite: true,
      );
      when(() => api.setFileFavorite('file-123', any()))
          .thenAnswer((_) async => userState);

      final result = await repository.setFileFavorite(
        fileId: 'file-123',
        isFavorite: true,
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (l) => fail('Oczekiwano sukcesu'),
        (state) => expect(state.isFavorite, isTrue),
      );
    });

    test('deleteFile usuwa plik do kosza', () async {
      when(() => api.deleteFile('file-123')).thenAnswer((_) async {});

      final result = await repository.deleteFile('file-123');

      expect(result.isRight(), isTrue);
      verify(() => api.deleteFile('file-123')).called(1);
    });

    test('restoreFileVersion przekazuje wersje i zwraca plik', () async {
      when(() => api.restoreFileVersion('file-123', 1, any()))
          .thenAnswer((_) async => sampleFile);

      final result = await repository.restoreFileVersion(
        fileId: 'file-123',
        version: 1,
        expectedVersion: 2,
        changeSummary: 'Cofnięcie zmian',
      );

      expect(result.isRight(), isTrue);
      verify(() => api.restoreFileVersion('file-123', 1, any())).called(1);
    });
  });

  group('StorageRepositoryImpl - obsługa błędów', () {
    test('mapuje DioException do ApiError', () async {
      when(() => api.deleteFile('file-err')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/files/file-err'),
          response: Response(
            requestOptions: RequestOptions(path: '/files/file-err'),
            statusCode: 403,
            data: {'message': 'Brak uprawnień do usunięcia pliku.'},
          ),
        ),
      );

      final result = await repository.deleteFile('file-err');

      expect(result.isLeft(), isTrue);
      result.fold(
        (error) => expect(error.message, contains('Brak uprawnień')),
        (r) => fail('Oczekiwano błędu'),
      );
    });
  });
}
