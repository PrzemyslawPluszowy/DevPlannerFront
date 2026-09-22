import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/attachments/chat_attachment_session_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockChatApi extends Mock implements ChatApi {}

void main() {
  late _MockChatApi api;

  setUp(() => api = _MockChatApi());

  group('ChatAttachmentSessionRepositoryImpl', () {
    test('wydaje sesję bez ujawniania ticketów Storage', () async {
      when(() => api.createAttachmentSession(any())).thenAnswer(
        (_) async => ChatTemporaryAttachmentSessionResponse(
          id: 'session-1',
          conversationId: 'conversation-1',
          expiresAtUtc: DateTime.utc(2026, 9, 21, 12, 30),
        ),
      );

      final result = await ChatAttachmentSessionRepositoryImpl(
        api,
      ).createAttachmentSession('conversation-1');

      final session = result.getOrElse(
        () => throw StateError('oczekiwano sesji'),
      );
      expect(session.id, 'session-1');
      expect(session.conversationId, 'conversation-1');
      expect(
        session.props,
        hasLength(3),
        reason: 'sesja domenowa nie może nieść ticketu ani URL-a Storage',
      );
    });

    test('anulowanie sesji deleguje do kontraktu', () async {
      when(() => api.cancelAttachmentSession(any(), any())).thenAnswer(
        (_) async {},
      );

      final result =
          await ChatAttachmentSessionRepositoryImpl(
            api,
          ).cancelAttachmentSession(
            conversationId: 'conversation-1',
            sessionId: 'session-1',
          );

      expect(result.isRight(), isTrue);
      verify(
        () => api.cancelAttachmentSession('conversation-1', 'session-1'),
      ).called(1);
    });

    test('odmowa wydania sesji ma własny kod domenowy', () async {
      when(() => api.createAttachmentSession(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: '/api/v1/chat/conversations/x/attachment-sessions',
          ),
          response: Response<void>(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 403,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await ChatAttachmentSessionRepositoryImpl(
        api,
      ).createAttachmentSession('conversation-1');

      final error = result.swap().getOrElse(
        () => throw StateError('oczekiwano błędu'),
      );
      expect(error.apiCode, 'chat.attachments.session_failed');
      expect(error.statusCode, 403);
    });
  });
}
