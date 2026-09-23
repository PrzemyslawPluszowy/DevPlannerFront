import 'package:devplanner/workspaces/domain/chat/link_policy/chat_link_policy.dart';
import 'package:devplanner/workspaces/presentation/chat/composer/chat_long_paste_decision.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = ChatLinkPolicy(
    snippetThresholdCharacters: 10,
    snippetMaxCharacters: 100,
    snippetInputMaxCharacters: 50,
    messageMaxCharacters: 20,
  );

  group('ChatLongPasteDecision', () {
    test('krótki tekst zostaje tekstem', () {
      final assessment = ChatLongPasteDecision.assess(
        text: 'krótko',
        policy: policy,
      );

      expect(assessment.kind, ChatLongPasteKind.text);
      expect(assessment.characters, 'krótko'.length);
    });

    test('próg snippet-u włącza propozycję pliku', () {
      final atThreshold = ChatLongPasteDecision.assess(
        text: '0123456789',
        policy: policy,
      );
      final aboveThreshold = ChatLongPasteDecision.assess(
        text: '01234567890',
        policy: policy,
      );

      expect(atThreshold.kind, ChatLongPasteKind.file);
      expect(aboveThreshold.kind, ChatLongPasteKind.file);
    });

    test('limit wejścia snippet-u daje jawny stan przekroczenia', () {
      final atLimit = ChatLongPasteDecision.assess(
        text: '0' * 50,
        policy: policy,
      );
      final aboveLimit = ChatLongPasteDecision.assess(
        text: '0' * 51,
        policy: policy,
      );

      expect(atLimit.kind, ChatLongPasteKind.file);
      expect(aboveLimit.kind, ChatLongPasteKind.overLimit);
    });

    test('limit zwykłej wiadomości wyprzedza wyższy próg snippet-u', () {
      const messageFirstPolicy = ChatLinkPolicy(
        snippetThresholdCharacters: 40,
        snippetMaxCharacters: 100,
        snippetInputMaxCharacters: 50,
        messageMaxCharacters: 20,
      );

      final assessment = ChatLongPasteDecision.assess(
        text: '0' * 25,
        policy: messageFirstPolicy,
      );

      expect(assessment.kind, ChatLongPasteKind.file);
    });

    test('brak polityki nie proponuje pliku i nie zgaduje progów', () {
      final assessment = ChatLongPasteDecision.assess(
        text: '0' * 10_000,
        policy: null,
      );

      expect(assessment.kind, ChatLongPasteKind.text);
    });

    test('rozmiar liczy bajty UTF-8, a znaki jak backend', () {
      final assessment = ChatLongPasteDecision.assess(
        text: 'żż',
        policy: policy,
      );

      expect(assessment.characters, 2);
      expect(assessment.byteLength, 4);
    });

    test('podgląd pokazuje maksymalnie trzy linie bez zmiany treści', () {
      final assessment = ChatLongPasteDecision.assess(
        text: 'a\nb\nc\nd\ne',
        policy: policy,
      );

      expect(assessment.previewLines, ['a', 'b', 'c']);
    });

    test('krótsza treść ma podgląd wszystkich linii', () {
      final assessment = ChatLongPasteDecision.assess(
        text: 'a\nb',
        policy: policy,
      );

      expect(assessment.previewLines, ['a', 'b']);
    });

    test('pusty tekst nie tworzy linii podglądu', () {
      final assessment = ChatLongPasteDecision.assess(
        text: '',
        policy: policy,
      );

      expect(assessment.previewLines, isEmpty);
      expect(assessment.kind, ChatLongPasteKind.text);
    });
  });
}
