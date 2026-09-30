import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_link_policy_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = ChatLinkPolicy(
    snippetThresholdCharacters: 100,
    snippetMaxCharacters: 500,
    snippetInputMaxCharacters: 1000,
    messageMaxCharacters: 2000,
  );

  test(
    'błąd nie jest cacheowany, a sukces obsługuje kolejne wklejenia',
    () async {
      final repository = _FakeChatLinkPolicyRepository(
        <Either<ApiError, ChatLinkPolicy>>[
          const Left<ApiError, ChatLinkPolicy>(
            ApiError(type: ApiErrorType.connection, message: 'offline'),
          ),
          const Right<ApiError, ChatLinkPolicy>(policy),
        ],
      );
      final cache = ChatLinkPolicyCache();

      expect(await cache.load(repository), isNull);
      expect(cache.isLoaded, isFalse);

      expect(await cache.load(repository), policy);
      expect(cache.isLoaded, isTrue);
      expect(cache.value, policy);

      expect(await cache.load(repository), policy);
      expect(repository.calls, 2);
    },
  );

  test('brak providera nie zapisuje pustego wyniku jako cache', () async {
    final cache = ChatLinkPolicyCache();

    expect(await cache.load(null), isNull);
    expect(cache.isLoaded, isFalse);
  });
}

final class _FakeChatLinkPolicyRepository implements ChatLinkPolicyRepository {
  _FakeChatLinkPolicyRepository(this.results);

  final List<Either<ApiError, ChatLinkPolicy>> results;
  int calls = 0;

  @override
  Future<Either<ApiError, ChatLinkPolicy>> getPolicy() async =>
      results[calls++];
}
