import 'package:intl/intl.dart';

/// Rozszerzenia dla typow zwiazanych z datami w projekcie.
extension AppDateTimeExtension on DateTime {
  /// Formatuje date do standardu wyswietlania w aplikacji: DD.MM.RRRR.
  String toAppDate() => DateFormat('dd.MM.yyyy').format(this);

  /// Formatuje date i czas do standardu wyswietlania w aplikacji: DD.MM.RRRR HH:mm.
  String toAppDateTime() => DateFormat('dd.MM.yyyy HH:mm').format(this);

  /// Formatuje date do kontraktu API `yyyy-MM-dd`.
  String toApiDate() => DateFormat('yyyy-MM-dd').format(this);
}

extension AppIntDateExtension on int {
  /// Formatuje timestamp (w milisekundach) do standardu wyswietlania w aplikacji: DD.MM.RRRR.
  String toAppDate() => DateTime.fromMillisecondsSinceEpoch(this).toAppDate();

  /// Formatuje timestamp (w milisekundach) do standardu wyswietlania w aplikacji: DD.MM.RRRR HH:mm.
  String toAppDateTime() =>
      DateTime.fromMillisecondsSinceEpoch(this).toAppDateTime();
}

extension AppStringDateExtension on String? {
  /// Próbuje sparsować string do daty i sformatować go do standardu aplikacji.
  /// Jeśli parsowanie się nie uda lub string jest pusty/null, zwraca [placeholder] lub oryginał.
  String toAppDate({String placeholder = ''}) {
    final text = this?.trim();
    if (text == null || text.isEmpty) {
      return placeholder;
    }

    try {
      // Obsługa formatu ISO (YYYY-MM-DD)
      final dt = DateTime.parse(text);
      return dt.toAppDate();
    } catch (_) {
      // Jeśli to nie ISO, zwracamy oryginał (może już jest dobrze sformatowany)
      return text;
    }
  }

  /// Próbuje sparsować string do daty i czasu i sformatować go do standardu
  /// aplikacji: DD.MM.RRRR HH:mm.
  /// Jeśli parsowanie się nie uda lub string jest pusty/null, zwraca
  /// [placeholder] lub oryginał.
  String toAppDateTime({String placeholder = ''}) {
    final text = this?.trim();
    if (text == null || text.isEmpty) {
      return placeholder;
    }

    try {
      final dt = DateTime.parse(text);
      return dt.toAppDateTime();
    } catch (_) {
      return text;
    }
  }
}
