import 'package:devplanner/l10n/app_localizations_en.dart';
import 'package:devplanner/l10n/app_localizations_pl.dart';
import 'package:devplanner/workspaces/presentation/chat/shared/chat_timestamp_formatter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatTimestampFormatter.relativeLabel', () {
    final now = DateTime.utc(2026, 9, 23, 12);

    test('używa krótkich, lokalizowanych etykiet względnych', () {
      expect(
        ChatTimestampFormatter.relativeLabel(
          l10n: AppLocalizationsPl(),
          atUtc: now.subtract(const Duration(minutes: 1)),
          nowUtc: now,
          locale: const Locale('pl'),
        ),
        '1 min',
      );
      expect(
        ChatTimestampFormatter.relativeLabel(
          l10n: AppLocalizationsEn(),
          atUtc: now.subtract(const Duration(hours: 2)),
          nowUtc: now,
          locale: const Locale('en'),
        ),
        '2 h',
      );
    });

    test('starsze pozycje pokazują lokalną datę bez sekund', () {
      final timestamp = DateTime.utc(2026, 9, 1, 8, 5, 42);
      final local = timestamp.toLocal();
      final day = local.day.toString().padLeft(2, '0');
      final month = local.month.toString().padLeft(2, '0');
      final year = local.year.toString();
      final hour = local.hour.toString().padLeft(2, '0');
      final minute = local.minute.toString().padLeft(2, '0');

      expect(
        ChatTimestampFormatter.relativeLabel(
          l10n: AppLocalizationsPl(),
          atUtc: timestamp,
          nowUtc: now,
          locale: const Locale('pl'),
        ),
        '$day.$month.$year',
      );
      expect(
        ChatTimestampFormatter.dateTimeLabel(timestamp, const Locale('pl')),
        '$day.$month.$year $hour:$minute',
      );
    });
  });
}
