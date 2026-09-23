import 'package:devplanner/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Wspólny format czasu dla list, zakładek i akcji wiadomości.
abstract final class ChatTimestampFormatter {
  /// Krótki czas względny taki sam w wierszu skrzynki i zakładkach.
  static String relativeLabel({
    required AppLocalizations l10n,
    required DateTime atUtc,
    required DateTime nowUtc,
    required Locale locale,
  }) {
    final difference = nowUtc.toUtc().difference(atUtc.toUtc());
    if (difference.inMinutes < 1) return l10n.chatInboxTimeNow;
    if (difference.inHours < 1) {
      return l10n.chatInboxTimeMinutes(difference.inMinutes);
    }
    if (difference.inDays < 1) {
      return l10n.chatInboxTimeHours(difference.inHours);
    }
    if (difference.inDays < 7) {
      return l10n.chatInboxTimeDays(difference.inDays);
    }
    return dateLabel(atUtc, locale);
  }

  /// Lokalna data bez sekund; angielski używa M/D, polski D.M.
  static String dateLabel(DateTime atUtc, Locale locale) {
    final local = atUtc.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    return locale.languageCode == 'en'
        ? '$month/$day/$year'
        : '$day.$month.$year';
  }

  /// Data i godzina używane przy przypięciu wiadomości.
  static String dateTimeLabel(DateTime atUtc, Locale locale) {
    final local = atUtc.toLocal();
    final date = dateLabel(atUtc, locale);
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$date $hour:$minute';
  }
}
