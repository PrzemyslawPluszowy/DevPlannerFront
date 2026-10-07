import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MembersRepository repository;
  late _ManagementRepository management;
  late ChatMembersCubit cubit;

  setUp(() {
    repository = _MembersRepository();
    management = _ManagementRepository();
    cubit = ChatMembersCubit(
      membersRepository: repository,
      conversationManagement: management,
      conversationId: 'chat',
      currentUserId: 'me',
    );
  });
  tearDown(() async {
    if (!cubit.isClosed) await cubit.close();
  });

  test(
    'odebranie ACL usuwa listę i blokuje refresh po pending mutacji',
    () async {
      when(() => repository.listMembers('chat'))
          .thenAnswer((_) async => const Right([]));
      await cubit.load();
      final pending = Completer<Either<ApiError, void>>();
      when(
        () => repository.removeMember(
          conversationId: 'chat',
          targetUserId: 'peer',
        ),
      ).thenAnswer((_) => pending.future);
      final mutation = cubit.removeMember('peer');
      cubit.invalidateAccess(
        const ApiError(
          type: ApiErrorType.forbidden,
          message: 'Access revoked',
          statusCode: 403,
        ),
      );
      expect((cubit.state as ChatMembersFailure).accessRevoked, isTrue);
      pending.complete(const Right(null));
      await mutation;
      await cubit.load();
      await cubit.addMembers(['peer']);
      verify(() => repository.listMembers('chat')).called(1);
      verifyNever(
        () => repository.addMembers(conversationId: 'chat', userIds: ['peer']),
      );
      expect(cubit.state, isA<ChatMembersFailure>());
    },
  );

  test(
    'przed załadowaniem i po close żadne akcje nie uruchamiają I/O',
    () async {
      for (var pass = 0; pass < 2; pass++) {
        await cubit.removeMember('peer');
        await cubit.addMembers(['peer']);
        await cubit.changeRole(
          targetUserId: 'peer',
          role: ChatMemberRole.member,
        );
        await cubit.leave();
        verifyZeroInteractions(repository);
        verifyZeroInteractions(management);
        if (pass == 0) await cubit.close();
      }
    },
  );

  test('mutacja blokuje wszystkie konkurencyjne akcje przed I/O', () async {
    when(() => repository.listMembers('chat'))
        .thenAnswer((_) async => const Right([]));
    final response = Completer<Either<ApiError, void>>();
    when(
      () =>
          repository.removeMember(conversationId: 'chat', targetUserId: 'peer'),
    ).thenAnswer((_) => response.future);
    await cubit.load();
    final first = cubit.removeMember('peer');
    expect((cubit.state as ChatMembersReady).isMutating, isTrue);
    await cubit.removeMember('peer');
    await cubit.addMembers(['peer']);
    await cubit.changeRole(targetUserId: 'peer', role: ChatMemberRole.member);
    await cubit.leave();
    verify(
      () =>
          repository.removeMember(conversationId: 'chat', targetUserId: 'peer'),
    ).called(1);
    verifyNever(
      () => repository.addMembers(conversationId: 'chat', userIds: ['peer']),
    );
    verifyNever(
      () => repository.updateMemberRole(
        conversationId: 'chat',
        targetUserId: 'peer',
        role: ChatMemberRole.member,
      ),
    );
    verifyZeroInteractions(management);
    response.complete(const Right(null));
    await first;
    expect((cubit.state as ChatMembersReady).isMutating, isFalse);
  });

  test(
    'busy trwa do odpowiedzi odświeżenia po potwierdzonej mutacji',
    () async {
      final refresh = Completer<Either<ApiError, List<ChatMember>>>();
      final refreshing = Completer<void>();
      var reads = 0;
      when(() => repository.listMembers('chat')).thenAnswer((_) {
        reads++;
        if (reads == 1) return Future.value(const Right([]));
        refreshing.complete();
        return refresh.future;
      });
      when(
        () => repository.removeMember(
          conversationId: 'chat',
          targetUserId: 'peer',
        ),
      ).thenAnswer((_) async => const Right(null));
      await cubit.load();
      final operation = cubit.removeMember('peer');
      await refreshing.future;
      expect((cubit.state as ChatMembersReady).isMutating, isTrue);
      await cubit.load();
      await cubit.removeMember('peer');
      expect(reads, 2);
      verify(
        () => repository.removeMember(
          conversationId: 'chat',
          targetUserId: 'peer',
        ),
      ).called(1);
      refresh.complete(const Right([]));
      await operation;
      expect((cubit.state as ChatMembersReady).isMutating, isFalse);
    },
  );

  test('starsza odpowiedź listy nie zastępuje nowszego snapshotu', () async {
    final first = Completer<Either<ApiError, List<ChatMember>>>();
    final second = Completer<Either<ApiError, List<ChatMember>>>();
    var reads = 0;
    when(() => repository.listMembers('chat'))
        .thenAnswer((_) => ++reads == 1 ? first.future : second.future);
    final oldLoad = cubit.load();
    final newLoad = cubit.load();
    final member = ChatMember(
      userId: 'latest',
      role: ChatMemberRole.member,
      joinedAtUtc: DateTime.utc(2026),
    );
    second.complete(Right([member]));
    await newLoad;
    first.complete(const Right([]));
    await oldLoad;
    expect((cubit.state as ChatMembersReady).members, [member]);
  });
}

final class _MembersRepository extends Mock implements ChatMembersRepository {}

final class _ManagementRepository extends Mock
    implements ChatConversationManagementRepository {}
