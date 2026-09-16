import 'package:flutter/widgets.dart';

/// Wspolny helper walidatorow formularzy.
///
/// Walidatory operuja na wartosci po `trim()`, dlatego
/// spacje na poczatku/koncu nie przechodza przypadkowo.
abstract final class AppValidators {
  static final _emailRegex = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
  );

  static final _onlyDigits = RegExp(r'^\d+$');
  static final _onlyPhoneChars = RegExp(r'^[0-9+\-()\s]+$');

  static String normalize(String? value) => (value ?? '').trim();

  static FormFieldValidator<String> compose(
    Iterable<FormFieldValidator<String>> validators,
  ) {
    final list = validators.toList(growable: false);
    return (value) {
      for (final validator in list) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> required({
    String message = 'To pole jest wymagane.',
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> email({
    String message = 'Niepoprawny adres e-mail.',
    bool allowEmpty = true,
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return allowEmpty ? null : 'To pole jest wymagane.';
      }
      if (!_emailRegex.hasMatch(normalized)) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> phone({
    String message = 'Niepoprawny numer telefonu.',
    bool allowEmpty = true,
    int minDigits = 7,
    int maxDigits = 15,
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return allowEmpty ? null : 'To pole jest wymagane.';
      }
      if (!_onlyPhoneChars.hasMatch(normalized)) {
        return message;
      }
      final digits = normalized.replaceAll(RegExp(r'\D'), '');
      if (digits.length < minDigits || digits.length > maxDigits) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> pesel({
    String message = 'Niepoprawny numer PESEL.',
    bool allowEmpty = true,
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return allowEmpty ? null : 'To pole jest wymagane.';
      }
      if (normalized.length != 11 || !_onlyDigits.hasMatch(normalized)) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> positiveInteger({
    String message = 'Podaj poprawna liczbe calkowita > 0.',
    bool allowEmpty = true,
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return allowEmpty ? null : 'To pole jest wymagane.';
      }
      final parsed = int.tryParse(normalized);
      if (parsed == null || parsed <= 0) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> nonNegativeNumber({
    String message = 'Podaj liczbe >= 0.',
    bool allowEmpty = true,
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return allowEmpty ? null : 'To pole jest wymagane.';
      }
      final parsed = double.tryParse(normalized.replaceAll(',', '.'));
      if (parsed == null || parsed < 0) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> nonNegativeInteger({
    String message = 'Podaj liczbę całkowitą >= 0.',
    bool allowEmpty = true,
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return allowEmpty ? null : 'To pole jest wymagane.';
      }
      final parsed = int.tryParse(normalized);
      if (parsed == null || parsed < 0) {
        return message;
      }
      return null;
    };
  }

  static FormFieldValidator<String> positiveNumber({
    String message = 'Podaj liczbę większą od 0.',
    bool allowEmpty = true,
  }) {
    return (value) {
      final normalized = normalize(value);
      if (normalized.isEmpty) {
        return allowEmpty ? null : 'To pole jest wymagane.';
      }
      final parsed = double.tryParse(normalized.replaceAll(',', '.'));
      if (parsed == null || parsed <= 0) {
        return message;
      }
      return null;
    };
  }
}
