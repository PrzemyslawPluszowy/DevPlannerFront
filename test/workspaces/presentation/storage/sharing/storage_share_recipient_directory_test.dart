import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/storage/transport/storage_share_recipient_directory_adapter.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_share_recipient_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_share_directory_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_share_directory_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _Directory implements StorageShareRecipientDirectoryPort {
  final requests =
      <String, Completer<Either<ApiError, List<ChatDirectoryEntry>>>>{};

  @override
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String query,
  }) {
    final request = Completer<Either<ApiError, List<ChatDirectoryEntry>>>();
    requests[query] = request;
    return request.future;
  }
}

class _ChatDirectory implements ChatDirectoryRepository {
  _ChatDirectory(this.result);
  String? term;
  int? limit;
  final Either<ApiError, List<ChatDirectoryEntry>> result;
  @override
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String term,
    int? limit,
  }) async {
    this.term = term;
    this.limit = limit;
    return result;
  }
}

void main() {
  const person = ChatDirectoryEntry(
    userId: 'person',
    login: 'anna',
    displayName: 'Anna',
  );
  test(
    'adapter uses authenticated bounded directory without workspace or email',
    () async {
      final directory = _ChatDirectory(const Right([person]));
      final result = await StorageShareRecipientDirectoryAdapter(directory)
          .search(query: 'anna');
      expect(directory.term, 'anna');
      expect(directory.limit, 20);
      expect(result, const Right<ApiError, List<ChatDirectoryEntry>>([person]));
    },
  );
  testWidgets(
    'short query does not send request and rejects prior in-flight response',
    (tester) async {
      final directory = _Directory();
      final cubit = StorageShareDirectoryCubit(directory: directory);
      cubit.search('anna');
      await tester.pump(const Duration(milliseconds: 260));
      cubit.search('a');
      directory.requests['anna']!.complete(const Right([person]));
      await tester.pump();
      expect(directory.requests.keys, ['anna']);
      expect(cubit.state, const StorageShareDirectoryIdle());
      await cubit.close();
    },
  );
  testWidgets('older query cannot overwrite latest selection results', (
    tester,
  ) async {
    final directory = _Directory();
    final cubit = StorageShareDirectoryCubit(directory: directory);
    cubit.search('anna');
    await tester.pump(const Duration(milliseconds: 260));
    cubit.search('piotr');
    await tester.pump(const Duration(milliseconds: 260));
    directory.requests['piotr']!.complete(const Right([]));
    await tester.pump();
    directory.requests['anna']!.complete(const Right([person]));
    await tester.pump();
    final state = cubit.state as StorageShareDirectoryReady;
    expect(state.query, 'piotr');
    expect(state.users, isEmpty);
    await cubit.close();
  });
  testWidgets('closed owner ignores pending result', (tester) async {
    final directory = _Directory();
    final cubit = StorageShareDirectoryCubit(directory: directory);
    cubit.search('anna');
    await tester.pump(const Duration(milliseconds: 260));
    await cubit.close();
    directory.requests['anna']!.complete(const Right([person]));
    await tester.pump();
    expect(cubit.isClosed, isTrue);
    expect(tester.takeException(), isNull);
  });
}
