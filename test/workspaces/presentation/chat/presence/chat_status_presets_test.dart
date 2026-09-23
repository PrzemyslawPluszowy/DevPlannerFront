import 'package:devplanner/workspaces/presentation/chat/presence/chat_status_presets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatStatusDurations', () {
    test('godzina dodaje dokładnie godzinę', () {
      final now = DateTime(2026, 9, 22, 10, 15);
      expect(
        ChatStatusDurations.expiresAtLocal(
          ChatStatusDurationOption.oneHour,
          now,
        ),
        DateTime(2026, 9, 22, 11, 15),
      );
    });

    test('dzisiaj oznacza koniec lokalnego dnia, nie +24 godziny', () {
      final morning = DateTime(2026, 9, 22, 6);
      final evening = DateTime(2026, 9, 22, 23, 59);
      expect(
        ChatStatusDurations.expiresAtLocal(
          ChatStatusDurationOption.today,
          morning,
        ),
        DateTime(2026, 9, 23),
      );
      expect(
        ChatStatusDurations.expiresAtLocal(
          ChatStatusDurationOption.today,
          evening,
        ),
        DateTime(2026, 9, 23),
      );
    });

    test('koniec miesiąca przechodzi na pierwszy dzień następnego', () {
      expect(
        ChatStatusDurations.expiresAtLocal(
          ChatStatusDurationOption.today,
          DateTime(2026, 9, 30, 12),
        ),
        DateTime(2026, 10),
      );
      expect(
        ChatStatusDurations.expiresAtLocal(
          ChatStatusDurationOption.today,
          DateTime(2026, 12, 31, 23),
        ),
        DateTime(2027),
      );
    });

    test('brak terminu nie tworzy daty', () {
      expect(
        ChatStatusDurations.expiresAtLocal(
          ChatStatusDurationOption.none,
          DateTime(2026, 9, 22),
        ),
        isNull,
      );
    });
  });

  group('ChatStatusPreset', () {
    test('każdy preset niesie emoji i nie powtarza go', () {
      final emoji = <String>{
        for (final preset in ChatStatusPreset.values) preset.emoji,
      };
      expect(emoji, hasLength(ChatStatusPreset.values.length));
      for (final preset in ChatStatusPreset.values) {
        expect(preset.emoji.trim(), isNotEmpty);
      }
    });
  });
}
