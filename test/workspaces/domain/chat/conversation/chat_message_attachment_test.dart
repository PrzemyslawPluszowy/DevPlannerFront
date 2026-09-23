import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message_attachment.dart';
import 'package:flutter_test/flutter_test.dart';

ChatMessageAttachment _attachment({String? contentType}) =>
    ChatMessageAttachment(
      id: 'attachment-1',
      messageId: 'message-1',
      storageFileId: 'file-1',
      attachedByUserId: 'user-1',
      position: 0,
      createdAtUtc: DateTime.utc(2026, 9, 22, 12),
      fileName: 'plik',
      contentType: contentType,
      isAvailable: true,
    );

void main() {
  group('ChatMessageAttachment.isImage', () {
    test('rozpoznaje obraz po typie MIME z serwera', () {
      expect(_attachment(contentType: 'image/png').isImage, isTrue);
      expect(_attachment(contentType: 'IMAGE/JPEG').isImage, isTrue);
      expect(_attachment(contentType: ' image/webp ').isImage, isTrue);
    });

    test('nie zgaduje obrazu bez typu MIME albo z inną kategorią', () {
      expect(_attachment().isImage, isFalse);
      expect(_attachment(contentType: '').isImage, isFalse);
      expect(_attachment(contentType: 'application/pdf').isImage, isFalse);
    });

    test('nazwa pliku nie rozstrzyga o typie', () {
      final masquerade = ChatMessageAttachment(
        id: 'attachment-2',
        messageId: 'message-1',
        storageFileId: 'file-2',
        attachedByUserId: 'user-1',
        position: 0,
        createdAtUtc: DateTime.utc(2026, 9, 22, 12),
        fileName: 'zdjecie.png',
        contentType: 'application/octet-stream',
        isAvailable: true,
      );
      expect(masquerade.isImage, isFalse);
    });
  });
}
