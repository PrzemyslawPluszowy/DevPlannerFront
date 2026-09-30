import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';
import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy_repository.dart';

/// Cache udanych odpowiedzi polityki dla pojedynczego composera.
///
/// Błąd transportu nie jest wynikiem cache: następne wklejenie ponawia odczyt.
final class ChatLinkPolicyCache {
  ChatLinkPolicy? _value;
  bool _isLoaded = false;

  /// Czy serwer zwrócił poprawną politykę.
  bool get isLoaded => _isLoaded;

  /// Ostatnia poprawna polityka, jeśli została pobrana.
  ChatLinkPolicy? get value => _value;

  /// Pobiera politykę lub zwraca poprzednio zapisaną poprawną odpowiedź.
  Future<ChatLinkPolicy?> load(ChatLinkPolicyRepository? repository) async {
    if (_isLoaded) return _value;
    if (repository == null) return null;

    Either<ApiError, ChatLinkPolicy> result;
    try {
      result = await repository.getPolicy();
    } on Object {
      return null;
    }

    return result.fold<ChatLinkPolicy?>(
      (_) => null,
      (policy) {
        _value = policy;
        _isLoaded = true;
        return policy;
      },
    );
  }
}
