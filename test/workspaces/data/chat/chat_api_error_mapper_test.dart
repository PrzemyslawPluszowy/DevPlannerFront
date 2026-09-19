import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/errors/chat_api_error_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const mapper = ChatApiErrorMapper();

  test('maps transport failures to a machine code, not user-facing text', () {
    final error = mapper.fromDioException(
      DioException(
        requestOptions: RequestOptions(path: '/api/v1/chat/conversations'),
        type: DioExceptionType.connectionTimeout,
      ),
      code: ChatApiErrorCode.loadConversations,
    );

    expect(error.type, ApiErrorType.connectionTimeout);
    expect(error.apiCode, 'chat.conversations.load_failed');
    expect(error.message, error.apiCode);
  });

  test('maps parsing failures to a machine code', () {
    final error = mapper.fromParsing(
      code: ChatApiErrorCode.invalidResponse,
    );

    expect(error.type, ApiErrorType.parsing);
    expect(error.apiCode, 'chat.response.invalid');
    expect(error.message, error.apiCode);
  });
}
