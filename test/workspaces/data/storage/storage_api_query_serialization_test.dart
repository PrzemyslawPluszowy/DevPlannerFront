import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  List<Object?> folders = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = options.path.endsWith('/folders')
        ? folders
        : <String, Object?>{'items': <Object?>[], 'nextCursor': null};
    return ResponseBody.fromString(
      jsonEncode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'folder enum retains complete response wire values in both directions',
    () {
      final values = <StorageFolderType, String>{
        StorageFolderType.personal: 'Personal',
        StorageFolderType.workspace: 'Workspace',
        StorageFolderType.project: 'Project',
        StorageFolderType.shared: 'Shared',
      };
      expect(values.keys, unorderedEquals(StorageFolderType.values));
      for (final entry in values.entries) {
        final json = <String, dynamic>{
          'id': 'folder',
          'name': 'Folder',
          'folderType': entry.value,
          'canRead': true,
          'canComment': false,
          'canEdit': false,
          'canShare': false,
          'canDelete': false,
          'itemCount': 0,
          'updatedAtUtc': '2026-10-05T12:00:00Z',
          'accessLevel': 'Reader',
        };
        final folder = StorageFolderResponse.fromJson(json);
        expect(folder.folderType, entry.key);
        expect(folder.toJson()['folderType'], entry.value);
        expect(entry.key.apiValue, entry.value);
      }
    },
  );

  test(
    'folder query preserves parentFolderId and decodes nested results',
    () async {
      final adapter = _RecordingAdapter()
        ..folders = [
          {
            'id': 'child',
            'name': 'Nested',
            'folderType': 'Personal',
            'parentFolderId': 'parent',
            'itemCount': 0,
            'updatedAtUtc': '2026-10-05T12:00:00Z',
            'accessLevel': 'Owner',
            'canRead': true,
            'canComment': true,
            'canEdit': true,
            'canShare': true,
            'canDelete': true,
          },
        ];
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
        ..httpClientAdapter = adapter;
      final repository = StorageRepositoryImpl(StorageApi(dio));
      final result = await repository.listFolders(
        scope: const StorageScope.personal(folderId: 'parent'),
        parentFolderId: 'parent',
      );
      expect(result.isRight(), isTrue);
      result.fold(
        (error) => fail(error.message),
        (folders) => expect(folders.single.id, 'child'),
      );
      expect(
        adapter.requests.single.queryParameters['parentFolderId'],
        'parent',
      );
      expect(adapter.requests.single.queryParameters['folderType'], 'Personal');
      await repository.listFolders(scope: const StorageScope.personal());
      expect(
        adapter.requests.last.queryParameters.containsKey('parentFolderId'),
        isFalse,
      );
    },
  );

  test(
    'repozytorium wysyła wartości kontraktu enumów zamiast nazw Dart',
    () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
      final adapter = _RecordingAdapter();
      dio.httpClientAdapter = adapter;
      final repository = StorageRepositoryImpl(StorageApi(dio));

      final expectedViews = <StorageScope, String>{
        const StorageScope.personal(): 'My',
        const StorageScope.shared(): 'Shared',
        const StorageScope.recent(): 'Recent',
        const StorageScope.favorites(): 'Favorites',
        const StorageScope.trash(): 'Trash',
      };

      for (final entry in expectedViews.entries) {
        await repository.listFiles(scope: entry.key);
        expect(adapter.requests.last.queryParameters['view'], entry.value);
        expect(
          adapter.requests.last.uri.toString(),
          isNot(contains('StorageListView.')),
        );
      }

      await repository.listFolders(scope: const StorageScope.personal());
      expect(adapter.requests.last.queryParameters['folderType'], 'Personal');
      expect(
        adapter.requests.last.uri.toString(),
        isNot(contains('StorageFolderType.')),
      );
    },
  );
}
