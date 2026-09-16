import 'package:flutter/foundation.dart';

/// Tryb tła widgetu pogodowego.
enum WeatherWidgetBackgroundMode {
  /// Standardowe szkło z delikatnym rozmyciem.
  standard,

  /// Przezroczysty overlay bez własnego tła.
  transparent,
}

/// Lokalizacja pogodowa wykorzystywana przez widget dashboardowy.
@immutable
class WeatherWidgetLocation {
  /// Tworzy lokalizację pogodową widgetu.
  const WeatherWidgetLocation({
    required this.label,
    required this.latitude,
    required this.longitude,
    this.timezone,
    this.country,
    this.admin1,
  });

  /// Etykieta prezentowana w UI.
  final String label;

  /// Szerokość geograficzna w stopniach WGS84.
  final double latitude;

  /// Długość geograficzna w stopniach WGS84.
  final double longitude;

  /// Strefa czasowa lokalizacji.
  final String? timezone;

  /// Nazwa kraju, jesli jest znana.
  final String? country;

  /// Nazwa regionu / wojewodztwa / stanu, jesli jest znana.
  final String? admin1;

  /// Zwraca opis lokalizacji bez pozycji GPS.
  String get locationSummary {
    final parts = <String>[
      if (admin1 case final value? when value.trim().isNotEmpty) value.trim(),
      if (country case final value? when value.trim().isNotEmpty) value.trim(),
    ];
    return parts.join(', ');
  }

  /// Zwraca opis wspierajacy podglad na wypadek braku nazw lokalizacji.
  String get compactSummary {
    final summary = locationSummary.trim();
    if (summary.isNotEmpty) {
      return summary;
    }

    return '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
  }

  /// Zwraca stabilny podpis służący do porównywania ustawień lokalizacji.
  String get settingsSignature =>
      '$label|$latitude|$longitude|${timezone ?? ''}|${country ?? ''}|${admin1 ?? ''}';

  /// Zamienia lokalizację na strukturę do zapisania w ustawieniach widgetu.
  Map<String, dynamic> toSettingsMap() {
    return {
      'label': label,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'country': country,
      'admin1': admin1,
    };
  }

  /// Odtwarza lokalizację z mapy zapisanej w ustawieniach widgetu.
  static WeatherWidgetLocation? fromSettingsMap(Object? value) {
    if (value is! Map) {
      return null;
    }

    final map = Map<String, dynamic>.from(value);
    final latitude = _asDouble(map['latitude']);
    final longitude = _asDouble(map['longitude']);
    if (latitude == null || longitude == null) {
      return null;
    }

    return WeatherWidgetLocation(
      label: _asString(map['label']) ?? 'Lokalizacja',
      latitude: latitude,
      longitude: longitude,
      timezone: _asString(map['timezone']),
      country: _asString(map['country']),
      admin1: _asString(map['admin1']),
    );
  }

  static String? _asString(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static double? _asDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }

    final parsed = double.tryParse(value?.toString().trim() ?? '');
    if (parsed == null || parsed.isNaN || parsed.isInfinite) {
      return null;
    }

    return parsed;
  }
}

/// Pojedynczy dzien prognozy 7-dniowej.
@immutable
class WeatherWidgetDailyForecast {
  /// Tworzy rekord prognozy dziennej.
  const WeatherWidgetDailyForecast({
    required this.date,
    required this.weatherCode,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.precipitationSum,
    required this.windSpeedMax,
  });

  /// Data obowiązywania prognozy.
  final DateTime date;

  /// Kod WMO opisujący stan pogody.
  final int weatherCode;

  /// Maksymalna temperatura dnia.
  final double temperatureMax;

  /// Minimalna temperatura dnia.
  final double temperatureMin;

  /// Suma opadów dla dnia.
  final double precipitationSum;

  /// Maksymalna prędkość wiatru dla dnia.
  final double windSpeedMax;
}

/// Zestaw danych pogodowych dla wybranej lokalizacji.
@immutable
class WeatherWidgetForecast {
  /// Tworzy zestaw danych pogodowych.
  const WeatherWidgetForecast({
    required this.location,
    required this.days,
    required this.generatedAt,
  });

  /// Lokalizacja, dla której pobrano prognozę.
  final WeatherWidgetLocation location;

  /// Prognoza dzienna na kolejne dni.
  final List<WeatherWidgetDailyForecast> days;

  /// Czas pobrania danych.
  final DateTime generatedAt;

  /// Zwraca prognozę dla pierwszego dnia, jeśli istnieje.
  WeatherWidgetDailyForecast? get today => days.isEmpty ? null : days.first;
}
