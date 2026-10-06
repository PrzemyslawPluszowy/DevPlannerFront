import 'dart:convert';
import 'dart:typed_data';

import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/api/storage_api.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_support/storage_shell_harness.dart';

class _Transport implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final folder = storageTestFolder().copyWith(
      isDeleted: true,
      canRestore: true,
      deletedAtUtc: DateTime.utc(2026, 10, 6),
    );
    return ResponseBody.fromString(
      jsonEncode(
        options.method == 'GET'
            ? [folder.toJson()]
            : folder.copyWith(isDeleted: false, canRestore: false).toJson(),
      ),
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
  test('all folder and access wire values decode and encode with additive trash fields', () {
    const types = ['Personal', 'Workspace', 'Project', 'Shared'];
    const access = ['None', 'Reader', 'Commenter', 'Editor', 'Owner'];
    expect(types.length, StorageFolderType.values.length);
    expect(access.length, StorageEffectiveAccessLevel.values.length);
    for (var i = 0; i < types.length; i++) {
      for (var j = 0; j < access.length; j++) {
        final json = storageTestFolder().toJson()
          ..['folderType'] = types[i]
          ..['accessLevel'] = access[j]
          ..['isDeleted'] = true
          ..['canRestore'] = true
          ..['deletedAtUtc'] = '2026-10-06T10:00:00Z';
        final result = StorageFolderResponse.fromJson(json);
        expect(result.folderType, StorageFolderType.values[i]);
        expect(result.accessLevel, StorageEffectiveAccessLevel.values[j]);
        expect(result.toJson()['folderType'], types[i]);
        expect(result.toJson()['accessLevel'], access[j]);
        expect(result.isDeleted && result.canRestore, isTrue);
        expect(result.deletedAtUtc!.isUtc, isTrue);
      }
    }
    final legacy = storageTestFolder().toJson()
      ..remove('isDeleted')
      ..remove('canRestore')
      ..remove('deletedAtUtc');
    expect(StorageFolderResponse.fromJson(legacy).canRestore, isFalse);
    expect(StorageFolderResponse.fromJson(legacy).isDeleted, isFalse);
  });

  test(
    'generated API uses dedicated trash route and explicit restore JSON',
    () async {
      final transport = _Transport();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'))
        ..httpClientAdapter = transport;
      addTearDown(dio.close);
      final api = StorageApi(dio);
      final trash = await api.listTrashFolders();
      expect(trash.single.isDeleted, isTrue);
      expect(transport.requests.single.path, '/api/v1/storage/folders/trash');
      final restored = await api.restoreFolder(
        'folder-1',
        const RestoreStorageFolderPayload(),
      );
      expect(restored.isDeleted, isFalse);
      expect(
        transport.requests.last.path,
        '/api/v1/storage/folders/folder-1/restore',
      );
      expect(transport.requests.last.data, {
        'name': null,
        'parentFolderId': null,
        'restoreToRoot': false,
      });
      await api.restoreFolder(
        'folder-1',
        const RestoreStorageFolderPayload(name: 'New', restoreToRoot: true),
      );
      expect(transport.requests.last.data, {
        'name': 'New',
        'parentFolderId': null,
        'restoreToRoot': true,
      });
    },
  );
}
