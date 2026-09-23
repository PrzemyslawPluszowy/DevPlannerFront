import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_repository.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/members/cubit/chat_members_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/search/cubit/chat_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _SearchFake implements ChatSearchRepository {
  _SearchFake({this.page, this.failure});

  ChatSearchPage? page;
  ApiError? failure;
  final List<ChatSearchQuery> queries = <ChatSearchQuery>[];
  final List<String> facetTerms = <String>[];

  @override
  Future<Either<ApiError, ChatSearchPage>> searchMessages(
    ChatSearchQuery query,
  ) async {
    queries.add(query);
    final error = failure;
    if (error != null) return Left(error);
    return Right(page ?? const ChatSearchPage(hits: [], totalApproximate: 0));
  }

  @override
  Future<Either<ApiError, ChatSearchFacets>> loadFacets({
    required String term,
    String? conversationId,
  }) async {
    facetTerms.add(term);
    return const Right(ChatSearchFacets(total: 0));
  }

  @override
  Future<Either<ApiError, List<ChatMentionSuggestion>>> suggestMentions({
    required String conversationId,
    required String term,
  }) async => const Right(<ChatMentionSuggestion>[]);
}

final class _DeferredSearchFake implements ChatSearchRepository {
  final List<Completer<Either<ApiError, ChatSearchPage>>> requests =
      <Completer<Either<ApiError, ChatSearchPage>>>[];

  @override
  Future<Either<ApiError, ChatSearchPage>> searchMessages(
    ChatSearchQuery query,
  ) {
    final request = Completer<Either<ApiError, ChatSearchPage>>();
    requests.add(request);
    return request.future;
  }

  @override
  Future<Either<ApiError, ChatSearchFacets>> loadFacets({
    required String term,
    String? conversationId,
  }) async => const Right(ChatSearchFacets(total: 0));

  @override
  Future<Either<ApiError, List<ChatMentionSuggestion>>> suggestMentions({
    required String conversationId,
    required String term,
  }) async => const Right(<ChatMentionSuggestion>[]);
}

final class _MembersFake implements ChatMembersRepository {
  _MembersFake({this.members = const <ChatMember>[]});

  List<ChatMember> members;
  ApiError? failure;
  final List<String> calls = <String>[];

  @override
  Future<Either<ApiError, List<ChatMember>>> listMembers(
    String conversationId,
  ) async {
    final error = failure;
    if (error != null) return Left(error);
    return Right(members);
  }

  @override
  Future<Either<ApiError, List<ChatMember>>> addMembers({
    required String conversationId,
    required List<String> userIds,
  }) async {
    calls.add('add:${userIds.join(',')}');
    final error = failure;
    if (error != null) return Left(error);
    final added = userIds
        .map(
          (userId) => ChatMember(
            userId: userId,
            role: ChatMemberRole.member,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
        )
        .toList(growable: false);
    members = <ChatMember>[...members, ...added];
    return Right(added);
  }

  @override
  Future<Either<ApiError, ChatMember>> updateMemberRole({
    required String conversationId,
    required String targetUserId,
    required ChatMemberRole role,
  }) async {
    calls.add('role:$targetUserId:${role.wireValue}');
    final error = failure;
    if (error != null) return Left(error);
    return Right(
      ChatMember(
        userId: targetUserId,
        role: role,
        joinedAtUtc: DateTime.utc(2026, 9, 21),
      ),
    );
  }

  @override
  Future<Either<ApiError, void>> removeMember({
    required String conversationId,
    required String targetUserId,
  }) async {
    calls.add('remove:$targetUserId');
    final error = failure;
    if (error != null) return Left(error);
    members = members
        .where((member) => member.userId != targetUserId)
        .toList(growable: false);
    return const Right(null);
  }
}

final class _ManagementFake implements ChatConversationManagementRepository {
  ApiError? failure;
  int leaveCalls = 0;

  @override
  Future<Either<ApiError, void>> leaveConversation(
    String conversationId,
  ) async {
    leaveCalls++;
    final error = failure;
    if (error != null) return Left(error);
    return const Right(null);
  }

  @override
  Future<Either<ApiError, ChatConversation>> createConversation(
    ChatConversationCreateCommand command,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatConversation>> updateDetails({
    required String conversationId,
    required String? name,
    required String postingPermission,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> archiveConversation(
    String conversationId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> restoreConversation(
    String conversationId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatConversation>>>
  listArchivedConversations() async => throw UnimplementedError();
}

ChatSearchHit hit(String id) => ChatSearchHit(
  messageId: id,
  conversationId: 'conversation-1',
  authorUserId: 'peer',
  text: 'Treść $id',
  createdAtUtc: DateTime.utc(2026, 9, 21),
  hasMention: false,
);

void main() {
  group('ChatSearchCubit', () {
    test('nie pyta backendu o frazę krótszą niż minimum', () async {
      final repository = _SearchFake();
      final cubit = ChatSearchCubit(
        repository: repository,
        debounce: Duration.zero,
      );

      cubit.updateTerm('a');
      await Future<void>.delayed(const Duration(milliseconds: 5));

      expect(repository.queries, isEmpty);
      expect(cubit.state.page, isNull);
      await cubit.close();
    });

    test('debounce ogranicza zapytania i mapuje wyniki', () async {
      final repository = _SearchFake(
        page: ChatSearchPage(
          hits: <ChatSearchHit>[hit('m1')],
          totalApproximate: 1,
        ),
      );
      final cubit = ChatSearchCubit(
        repository: repository,
        debounce: const Duration(milliseconds: 20),
      );

      cubit.updateTerm('an');
      cubit.updateTerm('anna');
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(repository.queries.single.term, 'anna');
      expect(cubit.state.page?.hits.single.messageId, 'm1');
      expect(repository.facetTerms, <String>['anna']);
      await cubit.close();
    });

    test('zmiana frazy czyści stare wyniki w trakcie debounce', () async {
      final repository = _SearchFake(
        page: ChatSearchPage(
          hits: <ChatSearchHit>[hit('old')],
          totalApproximate: 1,
        ),
      );
      final cubit = ChatSearchCubit(
        repository: repository,
        debounce: Duration.zero,
      );
      cubit.open();
      cubit.updateTerm('stara');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(cubit.state.page?.hits.single.messageId, 'old');

      cubit.updateTerm('nowa');

      expect(cubit.state.term, 'nowa');
      expect(cubit.state.page, isNull);
      expect(cubit.state.isSearching, isTrue);
      expect(cubit.state.isOpen, isTrue);
      await cubit.close();
    });

    test('stara odpowiedź nie wraca w trakcie debounce nowej frazy', () async {
      final repository = _DeferredSearchFake();
      final cubit = ChatSearchCubit(
        repository: repository,
        debounce: const Duration(milliseconds: 30),
      );

      cubit.updateTerm('stara');
      await Future<void>.delayed(const Duration(milliseconds: 40));
      expect(repository.requests, hasLength(1));

      cubit.updateTerm('nowa');
      repository.requests.single.complete(
        Right(
          ChatSearchPage(
            hits: <ChatSearchHit>[hit('old')],
            totalApproximate: 1,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 5));

      expect(cubit.state.term, 'nowa');
      expect(cubit.state.page, isNull);
      expect(cubit.state.isSearching, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 35));
      expect(repository.requests, hasLength(2));
      repository.requests.last.complete(
        Right(
          ChatSearchPage(
            hits: <ChatSearchHit>[hit('new')],
            totalApproximate: 1,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(cubit.state.page?.hits.single.messageId, 'new');
      await cubit.close();
    });

    test('kolejna strona wyników dokłada się po kursorze', () async {
      final repository = _SearchFake(
        page: ChatSearchPage(
          hits: <ChatSearchHit>[hit('m1')],
          nextCursor: 'next',
          totalApproximate: 2,
        ),
      );
      final cubit = ChatSearchCubit(
        repository: repository,
        debounce: Duration.zero,
      );
      cubit.updateTerm('anna');
      await Future<void>.delayed(const Duration(milliseconds: 5));

      repository.page = ChatSearchPage(
        hits: <ChatSearchHit>[hit('m2')],
        totalApproximate: 2,
      );
      await cubit.loadMore();

      expect(repository.queries.last.cursor, 'next');
      expect(
        cubit.state.page?.hits.map((entry) => entry.messageId),
        <String>['m1', 'm2'],
      );
      await cubit.close();
    });

    test('stawka 429 jest rozróżniona od zwykłego błędu', () async {
      final repository = _SearchFake(
        failure: const ApiError(
          type: ApiErrorType.badResponse,
          message: 'chat.rate_limit_exceeded',
          apiCode: 'chat.rate_limit_exceeded',
          statusCode: 429,
        ),
      );
      final cubit = ChatSearchCubit(
        repository: repository,
        debounce: Duration.zero,
      );

      cubit.updateTerm('anna');
      await Future<void>.delayed(const Duration(milliseconds: 5));

      expect(cubit.state.isRateLimited, isTrue);
      expect(cubit.state.page, isNull);
      await cubit.close();
    });

    test('zamknięcie widoku czyści frazę i wyniki', () async {
      final repository = _SearchFake(
        page: ChatSearchPage(
          hits: <ChatSearchHit>[hit('m1')],
          totalApproximate: 1,
        ),
      );
      final cubit = ChatSearchCubit(
        repository: repository,
        debounce: Duration.zero,
      );
      cubit.updateTerm('anna');
      await Future<void>.delayed(const Duration(milliseconds: 5));

      cubit.closeView();

      expect(cubit.state.isOpen, isFalse);
      expect(cubit.state.term, isEmpty);
      expect(cubit.state.page, isNull);
      await cubit.close();
    });
  });

  group('ChatMembersCubit', () {
    test('pokazuje role i pozwala zarządzać tylko właścicielowi', () async {
      final repository = _MembersFake(
        members: <ChatMember>[
          ChatMember(
            userId: 'me',
            role: ChatMemberRole.owner,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
          ChatMember(
            userId: 'peer',
            role: ChatMemberRole.member,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
        ],
      );
      final cubit = ChatMembersCubit(
        membersRepository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'me',
      );

      await cubit.load();

      final state = cubit.state as ChatMembersReady;
      expect(state.members, hasLength(2));
      expect(state.currentRole, ChatMemberRole.owner);
      expect(state.canManageMembers, isTrue);
      await cubit.close();
    });

    test('zmiana roli odświeża listę realnym skutkiem', () async {
      final repository = _MembersFake(
        members: <ChatMember>[
          ChatMember(
            userId: 'me',
            role: ChatMemberRole.owner,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
          ChatMember(
            userId: 'peer',
            role: ChatMemberRole.member,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
        ],
      );
      final cubit = ChatMembersCubit(
        membersRepository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'me',
      );
      await cubit.load();

      repository.members = <ChatMember>[
        ChatMember(
          userId: 'me',
          role: ChatMemberRole.owner,
          joinedAtUtc: DateTime.utc(2026, 9, 21),
        ),
        ChatMember(
          userId: 'peer',
          role: ChatMemberRole.moderator,
          joinedAtUtc: DateTime.utc(2026, 9, 21),
        ),
      ];
      await cubit.changeRole(
        targetUserId: 'peer',
        role: ChatMemberRole.moderator,
      );

      expect(repository.calls, <String>['role:peer:Moderator']);
      expect(
        (cubit.state as ChatMembersReady).members.last.role,
        ChatMemberRole.moderator,
      );
      await cubit.close();
    });

    test('błąd zmiany roli jest kodem, nie cichym brakiem skutku', () async {
      final repository = _MembersFake(
        members: <ChatMember>[
          ChatMember(
            userId: 'me',
            role: ChatMemberRole.owner,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
          ChatMember(
            userId: 'peer',
            role: ChatMemberRole.member,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
        ],
      );
      final cubit = ChatMembersCubit(
        membersRepository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'me',
      );
      await cubit.load();
      repository.failure = const ApiError(
        type: ApiErrorType.forbidden,
        message: 'chat.members.change_failed',
        apiCode: 'chat.members.change_failed',
        statusCode: 403,
      );

      await cubit.removeMember('peer');

      final state = cubit.state as ChatMembersReady;
      expect(state.failureCode, 'chat.members.change_failed');
      expect(state.isMutating, isFalse);
      await cubit.close();
    });

    test('dodanie osób wysyła identyfikatory i odświeża listę', () async {
      final repository = _MembersFake(
        members: <ChatMember>[
          ChatMember(
            userId: 'me',
            role: ChatMemberRole.owner,
            joinedAtUtc: DateTime.utc(2026, 9, 21),
          ),
        ],
      );
      final cubit = ChatMembersCubit(
        membersRepository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'me',
      );
      await cubit.load();

      await cubit.addMembers(<String>['new-1', 'new-2']);

      expect(repository.calls, contains('add:new-1,new-2'));
      final state = cubit.state as ChatMembersReady;
      expect(
        state.members.map((member) => member.userId),
        containsAll(<String>['new-1', 'new-2']),
      );
      expect(state.isMutating, isFalse);
      await cubit.close();
    });

    test('pusty wybór nie pyta backendu o dodanie osób', () async {
      final repository = _MembersFake();
      final cubit = ChatMembersCubit(
        membersRepository: repository,
        conversationId: 'conversation-1',
        currentUserId: 'me',
      );
      await cubit.load();

      await cubit.addMembers(const <String>[]);

      expect(repository.calls, isEmpty);
      await cubit.close();
    });

    test('opuszczenie rozmowy emituje stan zamknięcia', () async {
      final management = _ManagementFake();
      final cubit = ChatMembersCubit(
        membersRepository: _MembersFake(
          members: <ChatMember>[
            ChatMember(
              userId: 'me',
              role: ChatMemberRole.member,
              joinedAtUtc: DateTime.utc(2026, 9, 21),
            ),
          ],
        ),
        conversationId: 'conversation-1',
        currentUserId: 'me',
        conversationManagement: management,
      );
      await cubit.load();

      await cubit.leave();

      expect(management.leaveCalls, 1);
      expect(cubit.state, isA<ChatMembersLeft>());
      await cubit.close();
    });

    test('błąd pobrania listy nie udaje pustej listy', () async {
      // Porażkę ustawiamy na polu, bo fabryka nie przyjmuje jej w konstruktorze.
      final members = _MembersFake()
        ..failure = const ApiError(
          type: ApiErrorType.forbidden,
          message: 'chat.members.load_failed',
        );
      final cubit = ChatMembersCubit(
        membersRepository: members,
        conversationId: 'conversation-1',
        currentUserId: 'me',
      );

      await cubit.load();

      expect(cubit.state, isA<ChatMembersFailure>());
      await cubit.close();
    });
  });
}
