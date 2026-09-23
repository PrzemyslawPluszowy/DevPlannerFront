import 'package:devplanner/workspaces/presentation/chat/attachments/history/chat_message_attachments.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatChatFileSize', () {
    test('bajty bez jednostki dziesiętnej', () {
      expect(formatChatFileSize(0), '0 B');
      expect(formatChatFileSize(512), '512 B');
      expect(formatChatFileSize(1023), '1023 B');
    });

    test('kilobajty i megabajty z jedną cyfrą dla małych wartości', () {
      expect(formatChatFileSize(1024), '1.0 KB');
      expect(formatChatFileSize(2048), '2.0 KB');
      expect(formatChatFileSize(15 * 1024), '15 KB');
      expect(formatChatFileSize(1024 * 1024), '1.0 MB');
      expect(formatChatFileSize(5 * 1024 * 1024), '5.0 MB');
    });

    test('gigabajty i wartość ujemna', () {
      expect(formatChatFileSize(2 * 1024 * 1024 * 1024), '2.0 GB');
      expect(formatChatFileSize(-1), '—', reason: 'ujemny rozmiar to brak danych');
    });
  });
}
