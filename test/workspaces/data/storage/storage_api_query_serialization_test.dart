import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/data/storage/api/storage_api.dart';
import 'package:ready_next/workspaces/data/storage/repositories/storage_repository_impl.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_scope.dart';

class _RecordingAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final body = options.path.endsWith('/folders')
        ? <Object?>[]
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
