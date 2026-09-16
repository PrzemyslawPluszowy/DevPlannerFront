import 'package:intl/intl.dart';

final _appMoneyFormatterPl = NumberFormat.currency(
  locale: 'pl_PL',
  symbol: '',
  decimalDigits: 2,
);

final _appNumberSeparatorsPattern = RegExp(r"[ '\u00A0\u202F]");

/// Rozszerzenia formatujące liczby dziesiętne do widoku użytkownika.
extension AppStringNumberExtension on String? {
  /// Formatuje wartość do zapisu z separatorem tysięcy i przecinkiem,
  /// np. `2000.23` -> `2 000,23`.
  String toAppMoney({String placeholder = '-'}) {
    final normalized = this?.trim();
    if (normalized == null || normalized.isEmpty) {
      return placeholder;
    }

    final canonical = normalized
        .replaceAll(_appNumberSeparatorsPattern, '')
        .replaceAll(',', '.');
    final parsed = double.tryParse(canonical);

    if (parsed == null) {
      return normalized;
    }

    return _appMoneyFormatterPl.format(parsed).trim();
  }
}
