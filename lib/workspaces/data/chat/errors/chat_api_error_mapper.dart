import 'package:devplanner/core/error/api_error.dart';
import 'package:dio/dio.dart';

/// Typowane kody błędów bazowego pionu Chat.
enum ChatApiErrorCode {
  loadConversations,
  loadMessages,
  sendMessage,
  invalidResponse,
}

/// Mapuje błędy transportu Chat na kod domenowy bez tekstu dla użytkownika.
///
/// Warstwa presentation może później zmapować [ApiError.apiCode] przez ARB.
final class ChatApiErrorMapper {
  /// Tworzy mapper bez stanu i bez zależności od UI/l10n.
  const ChatApiErrorMapper();

  /// Mapuje błąd Dio, zachowując typ/status/kod backendu.
  ApiError fromDioException(
    DioException error, {
    required ChatApiErrorCode code,
  }) {
    final mapped = ApiError.fromDioException(
      error,
      fallbackMessage: _codeValue(code),
    );
    return ApiError(
      type: mapped.type,
      message: _codeValue(code),
      statusCode: mapped.statusCode,
      backendCode: mapped.backendCode,
      apiCode: _codeValue(code),
      traceId: mapped.traceId,
    );
  }

  /// Tworzy błąd parsowania z kodem maszynowym.
  ApiError fromParsing({required ChatApiErrorCode code}) => ApiError(
    type: ApiErrorType.parsing,
    message: _codeValue(code),
    apiCode: _codeValue(code),
  );

  String _codeValue(ChatApiErrorCode code) => switch (code) {
    ChatApiErrorCode.loadConversations => 'chat.conversations.load_failed',
    ChatApiErrorCode.loadMessages => 'chat.messages.load_failed',
    ChatApiErrorCode.sendMessage => 'chat.messages.send_failed',
    ChatApiErrorCode.invalidResponse => 'chat.response.invalid',
  };
}
