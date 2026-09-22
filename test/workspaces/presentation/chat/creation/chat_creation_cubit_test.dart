import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/directory/chat_directory_repository.dart';
import 'package:devplanner/workspaces/domain/chat/directory/models/chat_directory_entry.dart';
import 'package:devplanner/workspaces/domain/chat/management/chat_conversation_management_repository.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/cubit/chat_creation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/creation/participants/cubit/chat_directory_search_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _ManagementFake implements ChatConversationManagementRepository {
  final List<ChatConversationCreateCommand> commands =
      <ChatConversationCreateCommand>[];
  ApiError? failure;

  @override
  Future<Either<ApiError, ChatConversation>> createConversation(
    ChatConversationCreateCommand command,
  ) async {
    commands.add(command);
    final error = failure;
    if (error != null) return Left(error);
    return Right(
      ChatConversation(
        id: 'created-1',
        type: command.kind.wireValue.toLowerCase(),
        scopeKind: command.scope.wireValue.toLowerCase(),
        scopeKey: command.scopeKey,
        version: 1,
        createdAtUtc: DateTime.utc(2026, 9, 21),
        postingPermission: 'Everyone',
        isArchived: false,
        name: command.name,
      ),
    );
  }

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
  Future<Either<ApiError, void>> leaveConversation(
    String conversationId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatConversation>>>
  listArchivedConversations() async => throw UnimplementedError();
}

final class _DirectoryFake implements ChatDirectoryRepository {
  _DirectoryFake({this.entries = const <ChatDirectoryEntry>[], this.failure});

  List<ChatDirectoryEntry> entries;
  ApiError? failure;
  final List<String> terms = <String>[];

  @override
  Future<Either<ApiError, List<ChatDirectoryEntry>>> search({
    required String term,
    int? limit,
  }) async {
    terms.add(term);
    final error = failure;
    if (error != null) return Left(error);
    return Right(entries);
  }
}

ChatDirectoryEntry person(String id, String label) => ChatDirectoryEntry(
  userId: id,
  login: 'login-$id',
  displayName: label,
);

void main() {
  group('ChatCreationCubit', () {
    test(
      'rozmowa 1:1 wymaga dokładnie jednej osoby i tworzy scope global',
      () async {
        final management = _ManagementFake();
        final cubit = ChatCreationCubit(repository: management);

        cubit.selectKind(ChatConversationKind.direct);
        expect(cubit.state.step, ChatCreationStep.participants);

        cubit.continueToDetails();
        expect(
          cubit.state.validationErrors,
          contains(ChatCreationValidation.directRequiresOneParticipant),
          reason: 'bez wybranej osoby nie wolno przejść dalej',
        );

        cubit.toggleParticipant(person('peer', 'Ola'));
        cubit.continueToDetails();
        expect(cubit.state.step, ChatCreationStep.details);

        await cubit.submit();

        final command = management.commands.single;
        expect(command.kind, ChatConversationKind.direct);
        expect(command.scope, ChatConversationScope.global);
        expect(command.userIds, <String>['peer']);
        expect(command.scopeKey, 'direct');
        expect(cubit.state.created?.id, 'created-1');
        expect(cubit.state.isSubmitting, isFalse);
      },
    );

    test('klik osoby w 1:1 od razu tworzy albo otwiera rozmowę', () async {
      final management = _ManagementFake();
      final cubit = ChatCreationCubit(repository: management);

      cubit.selectKind(ChatConversationKind.direct);
      await cubit.startDirectWith(person('peer', 'Ola'));

      final command = management.commands.single;
      expect(command.kind, ChatConversationKind.direct);
      expect(command.userIds, <String>['peer']);
      expect(command.scopeKey, 'direct');
      expect(
        cubit.state.step,
        ChatCreationStep.participants,
        reason: '1:1 nie przechodzi do kroku szczegółów',
      );
      expect(cubit.state.created?.id, 'created-1');
      await cubit.close();
    });

    test(
      'klik osoby działa bez wcześniejszego wyboru typu (popover „Nowy czat”)',
      () async {
        // Popover startuje bez `selectKind`, więc `startDirectWith` musi sam
        // ustawić rodzaj rozmowy: inaczej `submit()` czyta `state.kind!` i kończy
        // się wyjątkiem zamiast rozmowy.
        final management = _ManagementFake();
        final cubit = ChatCreationCubit(repository: management);

        await cubit.startDirectWith(person('peer', 'Ola'));

        expect(management.commands, hasLength(1));
        expect(management.commands.single.kind, ChatConversationKind.direct);
        expect(cubit.state.created?.id, 'created-1');
        await cubit.close();
      },
    );

    test('podwójny klik nie wysyła drugiego żądania', () async {
      final management = _ManagementFake();
      final cubit = ChatCreationCubit(repository: management);
      cubit.selectKind(ChatConversationKind.direct);

      await Future.wait(<Future<void>>[
        cubit.startDirectWith(person('peer', 'Ola')),
        cubit.startDirectWith(person('peer', 'Ola')),
      ]);

      expect(management.commands, hasLength(1));
      await cubit.close();
    });

    test(
      'rozmowa 1:1 nie pozwala wybrać dwóch osób bez błędu backendu',
      () async {
        final management = _ManagementFake();
        final cubit = ChatCreationCubit(repository: management);

        cubit.selectKind(ChatConversationKind.direct);
        cubit.toggleParticipant(person('peer-1', 'Ola'));
        cubit.toggleParticipant(person('peer-2', 'Ala'));
        cubit.continueToDetails();

        expect(
          cubit.state.validationErrors,
          contains(ChatCreationValidation.directRequiresOneParticipant),
        );
        expect(management.commands, isEmpty);
      },
    );

    test('grupa wymaga osoby i respektuje limit backendu', () async {
      final management = _ManagementFake();
      final cubit = ChatCreationCubit(repository: management);

      cubit.selectKind(ChatConversationKind.group);
      cubit.continueToDetails();
      expect(
        cubit.state.validationErrors,
        contains(ChatCreationValidation.groupRequiresParticipant),
      );

      for (
        var index = 0;
        index < ChatCreationCubit.maxGroupParticipants;
        index++
      ) {
        cubit.toggleParticipant(person('peer-$index', 'Osoba $index'));
      }
      cubit.continueToDetails();
      expect(
        cubit.state.validationErrors,
        contains(ChatCreationValidation.groupTooManyParticipants),
      );
      expect(management.commands, isEmpty);
    });

    test('kanał pomija uczestników i wymaga nazwy', () async {
      final management = _ManagementFake();
      final cubit = ChatCreationCubit(repository: management);

      cubit.selectKind(ChatConversationKind.channel);
      expect(cubit.state.step, ChatCreationStep.details);

      await cubit.submit();
      expect(
        cubit.state.validationErrors,
        contains(ChatCreationValidation.nameRequired),
      );
      expect(management.commands, isEmpty);

      cubit.setName('  Kanał zespołu  ');
      await cubit.submit();

      final command = management.commands.single;
      expect(
        command.name,
        'Kanał zespołu',
        reason: 'nazwa jest trymowana przed wysłaniem',
      );
      expect(command.userIds, isEmpty);
      expect(
        command.scopeKey,
        startsWith('channel-'),
        reason: 'globalny kanał nie ma zakresu poza rozmową, więc dostaje klucz nadany raz',
      );
    });

    test('kolejne kanały dostają różne klucze zakresu', () async {
      final management = _ManagementFake();
      final first = ChatCreationCubit(repository: management);
      final second = ChatCreationCubit(repository: management);

      for (final cubit in <ChatCreationCubit>[first, second]) {
        cubit.selectKind(ChatConversationKind.channel);
        cubit.setName('Kanał');
        await cubit.submit();
      }

      expect(management.commands, hasLength(2));
      expect(
        management.commands[0].scopeKey == management.commands[1].scopeKey,
        isFalse,
        reason: 'wspólny klucz nadpisałby istniejący kanał',
      );
    });

    test('ogłoszenia blokują wybór publikacji dla wszystkich', () {
      final cubit = ChatCreationCubit(repository: _ManagementFake());

      cubit.selectKind(ChatConversationKind.broadcast);

      expect(cubit.state.postingPermission, 'AdminsOnly');
      expect(cubit.state.postingPermissionLocked, isTrue);
      cubit.setPostingPermission('Everyone');
      expect(cubit.state.postingPermission, 'AdminsOnly');
    });

    test('wybór AdminsOnly w kanale trafia do polecenia utworzenia', () async {
      final management = _ManagementFake();
      final cubit = ChatCreationCubit(repository: management);

      cubit.selectKind(ChatConversationKind.channel);
      cubit.setName('Kanał zespołu');
      cubit.setPostingPermission('AdminsOnly');
      await cubit.submit();

      expect(
        management.commands.single.postingPermission,
        'AdminsOnly',
        reason: 'kreator nie może zgubić wybranej polityki publikacji',
      );
    });

    test('błąd backendu nie kasuje szkicu i zwraca kod', () async {
      final management = _ManagementFake()
        ..failure = const ApiError(
          type: ApiErrorType.server,
          message: 'chat.conversations.manage_failed',
          apiCode: 'chat.conversations.manage_failed',
          statusCode: 403,
        );
      final cubit = ChatCreationCubit(repository: management);

      cubit.selectKind(ChatConversationKind.group);
      cubit.toggleParticipant(person('peer', 'Ola'));
      cubit.continueToDetails();
      cubit.setName('Temat grupy');
      await cubit.submit();

      expect(cubit.state.failureCode, 'chat.conversations.manage_failed');
      expect(cubit.state.created, isNull);
      expect(cubit.state.isSubmitting, isFalse);
      expect(cubit.state.participants, hasLength(1), reason: 'szkic zostaje');
      expect(cubit.state.name, 'Temat grupy');
    });

    test('ponowne wybranie tej samej osoby usuwa ją z listy', () {
      final cubit = ChatCreationCubit(repository: _ManagementFake());
      cubit.selectKind(ChatConversationKind.group);

      cubit.toggleParticipant(person('peer', 'Ola'));
      cubit.toggleParticipant(person('peer', 'Ola'));

      expect(cubit.state.participants, isEmpty);
    });
  });

  group('ChatDirectorySearchCubit', () {
    test('nie pyta backendu o frazę krótszą niż dwa znaki', () async {
      final directory = _DirectoryFake();
      final cubit = ChatDirectorySearchCubit(
        repository: directory,
        debounce: Duration.zero,
      );

      cubit.updateQuery('a');
      await Future<void>.delayed(const Duration(milliseconds: 5));

      expect(cubit.state.isQueryTooShort, isTrue);
      expect(directory.terms, isEmpty);
    });

    test('debounce ogranicza liczbę zapytań do ostatniej frazy', () async {
      final directory = _DirectoryFake(
        entries: <ChatDirectoryEntry>[person('user-1', 'Anna Kowalska')],
      );
      final cubit = ChatDirectorySearchCubit(
        repository: directory,
        debounce: const Duration(milliseconds: 20),
      );

      cubit.updateQuery('an');
      cubit.updateQuery('ann');
      cubit.updateQuery('anna');
      await Future<void>.delayed(const Duration(milliseconds: 60));

      expect(directory.terms, <String>['anna']);
      expect(cubit.state.results.single.userId, 'user-1');
      expect(cubit.state.isSearching, isFalse);
    });

    test('starsza odpowiedź nie nadpisuje nowszej frazy', () async {
      final slow = _DirectoryFake(
        entries: <ChatDirectoryEntry>[person('old', 'Stara')],
      );
      final cubit = ChatDirectorySearchCubit(
        repository: slow,
        debounce: Duration.zero,
      );

      cubit.updateQuery('an');
      // Zmiana frazy unieważnia poprzednie zapytanie jeszcze przed odpowiedzią.
      cubit.clear();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(cubit.state.results, isEmpty);
      expect(cubit.state.query, isEmpty);
    });

    test('błąd katalogu jest raportowany kodem, nie pustą listą', () async {
      final directory = _DirectoryFake(
        failure: const ApiError(
          type: ApiErrorType.server,
          message: 'chat.directory.load_failed',
          apiCode: 'chat.directory.load_failed',
        ),
      );
      final cubit = ChatDirectorySearchCubit(
        repository: directory,
        debounce: Duration.zero,
      );

      cubit.updateQuery('anna');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(cubit.state.failureCode, 'chat.directory.load_failed');
      expect(cubit.state.isEmpty, isFalse);
    });

    test('pusta odpowiedź daje stan pusty dopiero po zakończeniu', () async {
      final cubit = ChatDirectorySearchCubit(
        repository: _DirectoryFake(),
        debounce: Duration.zero,
      );

      cubit.updateQuery('anna');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(cubit.state.isEmpty, isTrue);
      expect(cubit.state.isSearching, isFalse);
    });
  });
}
