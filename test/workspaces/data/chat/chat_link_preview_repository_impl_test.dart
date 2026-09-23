import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_link_preview_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _ChatApiMock extends Mock implements ChatApi {}

void main() {
  test('pobiera preview przez endpoint backendu dla rozmowy i URL-a', () async {
    final api = _ChatApiMock();
    final fetchedAt = DateTime.utc(2026, 9, 22);
    when(
      () => api.previewLink('conversation-1', 'https://example.com'),
    ).thenAnswer(
      (_) async => ChatLinkPreviewResponse(
        finalUrl: 'https://example.com/',
        title: 'Example',
        description: 'Podgląd z serwera',
        contentType: 'text/html',
        fetchedAtUtc: fetchedAt,
      ),
    );

    final result = await ChatLinkPreviewRepositoryImpl(api).loadPreview(
      conversationId: 'conversation-1',
      url: 'https://example.com',
    );

    final preview = result.getOrElse(
      () => throw StateError('Oczekiwano podglądu.'),
    );
    expect(preview.finalUrl, 'https://example.com/');
    expect(preview.title, 'Example');
    expect(preview.description, 'Podgląd z serwera');
    expect(preview.fetchedAtUtc, fetchedAt);
    verify(
      () => api.previewLink('conversation-1', 'https://example.com'),
    ).called(1);
  });
}
