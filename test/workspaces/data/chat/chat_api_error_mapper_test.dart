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

  test('preserves Retry-After from Dio response', () {
    final before = DateTime.now().toUtc();
    final error = mapper.fromDioException(
      DioException.badResponse(
        statusCode: 429,
        requestOptions: RequestOptions(path: '/api/v1/chat/search'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/chat/search'),
          statusCode: 429,
          data: {
            'code': 'chat.rate_limited',
            'message': 'Poczekaj.',
            'fields': {
              'query': ['Za dużo zapytań.'],
            },
            'traceId': 'chat-trace',
          },
          headers: Headers.fromMap({
            'retry-after': ['60'],
          }),
        ),
      ),
      code: ChatApiErrorCode.searchMessages,
    );

    expect(error.statusCode, 429);
    expect(error.apiCode, 'chat.search.failed');
    expect(error.contractCode, 'chat.rate_limited');
    expect(error.fields, {
      'query': ['Za dużo zapytań.'],
    });
    expect(error.traceId, 'chat-trace');
    expect(error.retryAfterUtc, isNotNull);
    expect(error.retryAfterUtc!.isAfter(before), isTrue);
  });
}
