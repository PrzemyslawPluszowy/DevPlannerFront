import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_members_presence_response.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_presence_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_presence_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements ChatMembersPresenceRepository {}

void main() {
  test(
    'wire snapshot preserves explicit offline and rejects duplicate users',
    () {
      final snapshot = ChatMembersPresenceResponse.fromJson({
        'snapshotAtUtc': '2026-10-07T10:00:00Z',
        'users': [
          {'userId': 'a', 'isOnline': true},
          {'userId': 'b', 'isOnline': false},
        ],
      });
      expect(snapshot.users, {'a': true, 'b': false});
      expect(snapshot.snapshotAtUtc.isUtc, isTrue);
      expect(() => snapshot.users['c'] = true, throwsUnsupportedError);
      expect(
        () => ChatMembersPresenceResponse.fromJson({
          'snapshotAtUtc': '2026-10-07T10:00:00Z',
          'users': [
            {'userId': 'a', 'isOnline': true},
            {'userId': 'a', 'isOnline': false},
          ],
        }),
        throwsFormatException,
      );
    },
  );

  test('stary snapshot nie otrzymuje nowego TTL po opóźnieniu HTTP', () async {
    final repository = _Repository();
    final now = DateTime.utc(2026, 10, 7, 12);
    when(() => repository.loadMembersPresence('conversation')).thenAnswer(
      (_) async => Right(
        ChatMembersPresenceSnapshot(
          users: {'person': true},
          snapshotAtUtc: now.subtract(const Duration(seconds: 31)),
        ),
      ),
    );
    final cubit = ChatMembersPresenceCubit(
      repository: repository,
      conversationId: 'conversation',
      now: () => now,
    );
    await cubit.refresh();
    expect(cubit.state.users, isEmpty);
    await cubit.close();
  });

  test('429 blokuje ręczne Retry do terminu serwera', () async {
    final repository = _Repository();
    var now = DateTime.utc(2026, 10, 7, 12);
    final deadline = now.add(const Duration(seconds: 60));
    when(() => repository.loadMembersPresence('conversation')).thenAnswer(
      (_) async => Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Rate limited',
          statusCode: 429,
          retryAfterUtc: deadline,
        ),
      ),
    );
    final cubit = ChatMembersPresenceCubit(
      repository: repository,
      conversationId: 'conversation',
      now: () => now,
    );
    await cubit.refresh();
    await cubit.refresh();
    verify(() => repository.loadMembersPresence('conversation')).called(1);
    now = deadline;
    when(() => repository.loadMembersPresence('conversation')).thenAnswer(
      (_) async => Right(
        ChatMembersPresenceSnapshot(
          users: {'person': false},
          snapshotAtUtc: now,
        ),
      ),
    );
    await cubit.refresh();
    expect(cubit.state.users['person'], isFalse);
    verify(() => repository.loadMembersPresence('conversation')).called(1);
    await cubit.close();
  });

  test(
    'pending request singleflight; hidden session discards old response',
    () async {
      final repository = _Repository();
      final pending =
          Completer<Either<ApiError, ChatMembersPresenceSnapshot>>();
      when(() => repository.loadMembersPresence('conversation'))
          .thenAnswer((_) => pending.future);
      final cubit = ChatMembersPresenceCubit(
        repository: repository,
        conversationId: 'conversation',
      );
      final first = cubit.refresh();
      await cubit.refresh();
      verify(() => repository.loadMembersPresence('conversation')).called(1);
      cubit.setActive(false);
      pending.complete(
        Right(
          ChatMembersPresenceSnapshot(
            users: {'person': true},
            snapshotAtUtc: DateTime.now().toUtc(),
          ),
        ),
      );
      await first;
      expect(cubit.state.users, isEmpty);
      expect(cubit.state.isLoading, isFalse);
      await cubit.close();
    },
  );

  test('failure clears online; close discards delayed response', () async {
    final repository = _Repository();
    when(() => repository.loadMembersPresence('conversation')).thenAnswer(
      (_) async => Right(
        ChatMembersPresenceSnapshot(
          users: {'person': true},
          snapshotAtUtc: DateTime.now().toUtc(),
        ),
      ),
    );
    final cubit = ChatMembersPresenceCubit(
      repository: repository,
      conversationId: 'conversation',
    );
    await cubit.refresh();
    expect(cubit.state.users['person'], isTrue);
    const error = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Denied',
      statusCode: 403,
    );
    when(() => repository.loadMembersPresence('conversation'))
        .thenAnswer((_) async => const Left(error));
    await cubit.refresh();
    expect(cubit.state.users, isEmpty);
    expect(cubit.state.failure, error);
    final pending = Completer<Either<ApiError, ChatMembersPresenceSnapshot>>();
    when(() => repository.loadMembersPresence('conversation'))
        .thenAnswer((_) => pending.future);
    final refresh = cubit.refresh();
    await cubit.close();
    pending.complete(
      Right(
        ChatMembersPresenceSnapshot(
          users: {'person': true},
          snapshotAtUtc: DateTime.now().toUtc(),
        ),
      ),
    );
    await refresh;
    expect(cubit.state.users, isEmpty);
  });

  testWidgets('snapshot expires while a subsequent request is still pending', (
    tester,
  ) async {
    final repository = _Repository();
    when(() => repository.loadMembersPresence('conversation')).thenAnswer(
      (_) async => Right(
        ChatMembersPresenceSnapshot(
          users: {'person': true},
          snapshotAtUtc: DateTime.now().toUtc(),
        ),
      ),
    );
    final cubit = ChatMembersPresenceCubit(
      repository: repository,
      conversationId: 'conversation',
      pollInterval: const Duration(seconds: 1),
      maxAge: const Duration(seconds: 2),
    );
    await cubit.refresh();
    final pending = Completer<Either<ApiError, ChatMembersPresenceSnapshot>>();
    when(() => repository.loadMembersPresence('conversation'))
        .thenAnswer((_) => pending.future);
    await tester.pump(const Duration(seconds: 1));
    expect(cubit.state.users['person'], isTrue);
    await tester.pump(const Duration(seconds: 1));
    expect(cubit.state.users, isEmpty);
    await cubit.close();
    pending.complete(
      Right(
        ChatMembersPresenceSnapshot(
          users: {'person': true},
          snapshotAtUtc: DateTime.now().toUtc(),
        ),
      ),
    );
    await tester.pump();
  });
}
