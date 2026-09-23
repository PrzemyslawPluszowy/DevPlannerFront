import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_unread_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeInboxRepository implements ChatInboxRepository {
  Either<ApiError, ChatInboxUnreadCount> result = Right(
    ChatInboxUnreadCount(
      totalUnreadCount: 0,
      unreadConversationCount: 0,
      generatedAtUtc: DateTime.utc(2026),
    ),
  );
  int calls = 0;

  @override
  Future<Either<ApiError, ChatInboxUnreadCount>> loadUnreadCount() async {
    calls++;
    return result;
  }

  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int limit = 30,
    String? query,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> markRead({
    required String conversationId,
    required String messageId,
  }) => throw UnimplementedError();
}

void main() {
  late _FakeInboxRepository repository;
  late ChatUnreadCubit cubit;

  setUp(() {
    repository = _FakeInboxRepository();
    cubit = ChatUnreadCubit(
      repository: repository,
      coalesceWindow: Duration.zero,
    );
  });

  tearDown(() => cubit.close());

  Future<void> settle() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }

  test('brak nieprzeczytanych nie pokazuje badge', () {
    expect(cubit.state.hasUnread, isFalse);
    expect(cubit.state.unread, 0);
  });

  test('refresh publikuje serwerowy agregat', () async {
    repository.result = Right(
      ChatInboxUnreadCount(
        totalUnreadCount: 5,
        unreadConversationCount: 2,
        generatedAtUtc: DateTime.utc(2026),
      ),
    );

    await cubit.refresh();

    expect(cubit.state.unread, 5);
    expect(cubit.state.hasUnreadConversations, isTrue);
    expect(cubit.state.hasUnread, isTrue);
  });

  test('błąd nie zeruje ostatniego potwierdzonego stanu', () async {
    repository.result = Right(
      ChatInboxUnreadCount(
        totalUnreadCount: 3,
        unreadConversationCount: 1,
        generatedAtUtc: DateTime.utc(2026),
      ),
    );
    await cubit.refresh();

    repository.result = const Left(
      ApiError(type: ApiErrorType.connection, message: 'Offline.'),
    );
    await cubit.refresh();

    expect(
      cubit.state.unread,
      3,
      reason: 'badge nie może zniknąć po błędzie sieci',
    );
  });

  test('seria sygnałów realtime scala się w jedno odświeżenie', () async {
    repository.result = Right(
      ChatInboxUnreadCount(
        totalUnreadCount: 1,
        unreadConversationCount: 1,
        generatedAtUtc: DateTime.utc(2026),
      ),
    );

    cubit
      ..applySignal()
      ..applySignal()
      ..applySignal();
    await settle();
    await settle();

    expect(repository.calls, 1);
    expect(cubit.state.unread, 1);
  });

  test('reset czyści licznik po zakończeniu sesji', () async {
    repository.result = Right(
      ChatInboxUnreadCount(
        totalUnreadCount: 7,
        unreadConversationCount: 3,
        generatedAtUtc: DateTime.utc(2026),
      ),
    );
    await cubit.refresh();

    cubit.reset();

    expect(cubit.state.unread, 0);
    expect(cubit.state.hasUnreadConversations, isFalse);
  });
}
