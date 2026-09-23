import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/mentions/chat_mention_codec.dart';
import 'package:devplanner/workspaces/domain/chat/search/chat_search_repository.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:devplanner/workspaces/presentation/chat/mentions/chat_mention_picker_controller.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeSearchRepository implements ChatSearchRepository {
  Either<ApiError, List<ChatMentionSuggestion>> result = const Right(
    <ChatMentionSuggestion>[],
  );
  final List<String> terms = <String>[];
  Completer<Either<ApiError, List<ChatMentionSuggestion>>>? pending;

  @override
  Future<Either<ApiError, List<ChatMentionSuggestion>>> suggestMentions({
    required String conversationId,
    required String term,
  }) {
    terms.add(term);
    final waiting = pending;
    if (waiting != null) return waiting.future;
    return Future<Either<ApiError, List<ChatMentionSuggestion>>>.value(result);
  }

  @override
  Future<Either<ApiError, ChatSearchPage>> searchMessages(
    ChatSearchQuery query,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatSearchFacets>> loadFacets({
    required String term,
    String? conversationId,
  }) => throw UnimplementedError();
}

ChatMentionSuggestion suggestion(String id, String label) =>
    ChatMentionSuggestion(
      userId: id,
      login: label.toLowerCase(),
      displayName: label,
    );

void main() {
  late _FakeSearchRepository repository;
  late ChatMentionPickerController controller;

  setUp(() {
    repository = _FakeSearchRepository();
    controller = ChatMentionPickerController(
      repository: repository,
      conversationId: 'conversation-1',
      debounce: Duration.zero,
    );
  });

  tearDown(() => controller.dispose());

  Future<void> settle() async {
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
  }

  test('brak aktywnego wywołania nie pyta backendu', () async {
    controller.updateQuery(null);

    expect(controller.isOpen, isFalse);
    expect(repository.terms, isEmpty);
  });

  test('fraza krótsza niż dwa znaki nie pyta backendu', () async {
    controller.updateQuery(const ChatMentionQuery(start: 0, end: 1, term: 'o'));

    expect(controller.isOpen, isTrue);
    expect(controller.isQueryTooShort, isTrue);
    expect(repository.terms, isEmpty);
  });

  test('fraza z debounce trafia do backendu i daje wyniki', () async {
    repository.result = Right([suggestion('user-1', 'Ola')]);

    controller.updateQuery(
      const ChatMentionQuery(start: 4, end: 6, term: 'ol'),
    );
    expect(controller.isLoading, isTrue);
    await settle();

    expect(repository.terms, ['ol']);
    expect(controller.isLoading, isFalse);
    expect(controller.suggestions.single.displayName, 'Ola');
    expect(controller.active?.userId, 'user-1');
  });

  test('spóźniona odpowiedź starszej frazy nie nadpisuje nowszej', () async {
    final first = Completer<Either<ApiError, List<ChatMentionSuggestion>>>();
    repository.pending = first;
    controller.updateQuery(
      const ChatMentionQuery(start: 4, end: 6, term: 'ol'),
    );
    await settle();

    repository.pending = null;
    repository.result = Right([suggestion('user-2', 'Jan')]);
    controller.updateQuery(
      const ChatMentionQuery(start: 4, end: 6, term: 'ja'),
    );
    await settle();

    // Wolna odpowiedź „ol” dociera jako ostatnia, ale dotyczy starszej frazy.
    first.complete(Right([suggestion('user-1', 'Ola')]));
    await settle();

    expect(controller.suggestions.single.displayName, 'Jan');
  });

  test('błąd podpowiedzi daje kod, a retry ponawia zapytanie', () async {
    repository.result = const Left(
      ApiError(
        type: ApiErrorType.forbidden,
        message: 'chat.mentions.denied',
        apiCode: 'chat.mentions.denied',
      ),
    );
    controller.updateQuery(
      const ChatMentionQuery(start: 0, end: 3, term: 'ola'),
    );
    await settle();

    expect(controller.failureCode, 'chat.mentions.denied');
    expect(controller.suggestions, isEmpty);

    repository.result = Right([suggestion('user-1', 'Ola')]);
    await controller.retry();

    expect(controller.failureCode, isNull);
    expect(controller.suggestions, hasLength(1));
  });

  test('strzałki przewijają podświetlenie z zawijaniem', () async {
    repository.result = Right([
      suggestion('user-1', 'Ola'),
      suggestion('user-2', 'Jan'),
    ]);
    controller.updateQuery(
      const ChatMentionQuery(start: 0, end: 2, term: 'ol'),
    );
    await settle();

    expect(controller.activeIndex, 0);
    controller.moveUp();
    expect(
      controller.activeIndex,
      1,
      reason: 'góra z pierwszego przechodzi na ostatni',
    );
    controller.moveDown();
    expect(controller.activeIndex, 0);
  });

  test('zamknięcie listy czyści stan', () async {
    repository.result = Right([suggestion('user-1', 'Ola')]);
    controller.updateQuery(
      const ChatMentionQuery(start: 0, end: 2, term: 'ol'),
    );
    await settle();

    controller.close();

    expect(controller.isOpen, isFalse);
    expect(controller.suggestions, isEmpty);
    expect(controller.confirmActive(), isNull);
  });

  group('wzmianka @all', () {
    test('bez uprawnień lista nie proponuje @all', () {
      controller.updateQuery(
        const ChatMentionQuery(start: 0, end: 0, term: ''),
      );

      expect(controller.allTokenEnabled, isFalse);
      expect(controller.suggestsAll, isFalse);
    });

    test('z uprawnieniami samo @ proponuje @all', () {
      controller.setAllTokenEnabled(true);

      controller.updateQuery(
        const ChatMentionQuery(start: 0, end: 0, term: ''),
      );

      expect(controller.suggestsAll, isTrue);
    });

    test('propozycja @all znika, gdy fraza nie pasuje do tokenu', () {
      controller.setAllTokenEnabled(true);

      controller.updateQuery(
        const ChatMentionQuery(start: 0, end: 2, term: 'ol'),
      );

      expect(controller.suggestsAll, isFalse);
    });

    test('wyłączenie uprawnień natychmiast chowa propozycję', () {
      controller.setAllTokenEnabled(true);
      controller.updateQuery(
        const ChatMentionQuery(start: 0, end: 2, term: 'al'),
      );
      expect(controller.suggestsAll, isTrue);

      controller.setAllTokenEnabled(false);

      expect(controller.suggestsAll, isFalse);
    });
  });
}
