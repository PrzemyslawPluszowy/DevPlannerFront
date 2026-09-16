import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';

/// Wyjatek techniczny dla operacji Open-Meteo.
class OpenMeteoWeatherException implements Exception {
  /// Tworzy wyjatek Open-Meteo.
  const OpenMeteoWeatherException(this.message);

  /// Komunikat wyjatku.
  final String message;

  @override
  String toString() => 'OpenMeteoWeatherException: $message';
}

/// Klient danych pogodowych oparty o publiczne API Open-Meteo.
class OpenMeteoWeatherRepository {
  /// Tworzy repozytorium pogodowe.
  OpenMeteoWeatherRepository({Dio? dio})
    : _dio = dio ?? _createPublicDio(),
      _ownsDio = dio == null;

  final Dio _dio;
  final bool _ownsDio;

  static Dio _createPublicDio() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: const {'Accept': 'application/json'},
      ),
    );
  }

  /// Zamyka klienta HTTP utworzonego przez repozytorium.
  void dispose() {
    if (_ownsDio) {
      _dio.close(force: true);
    }
  }

  /// Szuka lokalizacji po nazwie lub kodzie pocztowym.
  Future<List<WeatherWidgetLocation>> searchLocations({
    required String query,
    String language = 'pl',
    int count = 8,
  }) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) {
      return const [];
    }

    try {
      final response = await _dio.getUri<dynamic>(
        Uri.https(
          'geocoding-api.open-meteo.com',
          '/v1/search',
          {
            'name': normalizedQuery,
            'count': count.toString(),
            'format': 'json',
            'language': language.trim().isEmpty ? 'en' : language.trim(),
          },
        ),
      );

      final data = _asMap(response.data);
      final results = data?['results'];
      if (results is! List) {
        return const [];
      }

      return [
        for (final item in results)
          if (item is Map) _locationFromJson(Map<String, dynamic>.from(item)),
      ];
    } on DioException catch (error) {
      throw OpenMeteoWeatherException(_messageFromError(error));
    }
  }

  /// Pobiera 7-dniową prognozę dla wybranej lokalizacji.
  Future<WeatherWidgetForecast> fetchForecast({
    required WeatherWidgetLocation location,
  }) async {
    try {
      final response = await _dio.getUri<dynamic>(
        Uri.https(
          'api.open-meteo.com',
          '/v1/forecast',
          {
            'latitude': location.latitude.toString(),
            'longitude': location.longitude.toString(),
            'daily':
                'weather_code,temperature_2m_max,temperature_2m_min,'
                'precipitation_sum,wind_speed_10m_max',
            'forecast_days': '7',
            'timezone': (location.timezone?.trim().isNotEmpty ?? false)
                ? location.timezone!.trim()
                : 'auto',
            'temperature_unit': 'celsius',
            'wind_speed_unit': 'kmh',
            'precipitation_unit': 'mm',
            'format': 'json',
          },
        ),
      );

      final data = _asMap(response.data);
      final daily = _asMap(data?['daily']);
      if (daily == null) {
        throw const OpenMeteoWeatherException(
          'Brak danych dziennych w odpowiedzi Open-Meteo.',
        );
      }

      final timeValues = _asStringList(daily['time']);
      final weatherCodes = _asIntList(daily['weather_code']);
      final maxTemps = _asDoubleList(daily['temperature_2m_max']);
      final minTemps = _asDoubleList(daily['temperature_2m_min']);
      final precipitation = _asDoubleList(daily['precipitation_sum']);
      final windMax = _asDoubleList(daily['wind_speed_10m_max']);

      final length = <int>[
        timeValues.length,
        weatherCodes.length,
        maxTemps.length,
        minTemps.length,
        precipitation.length,
        windMax.length,
      ].reduce(math.min);

      if (length == 0) {
        throw const OpenMeteoWeatherException(
          'Open-Meteo zwrócił pustą prognozę.',
        );
      }

      return WeatherWidgetForecast(
        location: location,
        generatedAt: DateTime.now(),
        days: [
          for (var index = 0; index < length; index++)
            WeatherWidgetDailyForecast(
              date: DateTime.parse(timeValues[index]),
              weatherCode: weatherCodes[index],
              temperatureMax: maxTemps[index],
              temperatureMin: minTemps[index],
              precipitationSum: precipitation[index],
              windSpeedMax: windMax[index],
            ),
        ],
      );
    } on DioException catch (error) {
      throw OpenMeteoWeatherException(_messageFromError(error));
    }
  }

  Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }

  List<String> _asStringList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return [
      for (final item in value)
        if (item != null) item.toString(),
    ];
  }

  List<int> _asIntList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return [
      for (final item in value)
        if (item is num) item.toInt() else int.tryParse(item.toString()) ?? 0,
    ];
  }

  List<double> _asDoubleList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return [
      for (final item in value)
        if (item is num)
          item.toDouble()
        else
          double.tryParse(item.toString()) ?? 0,
    ];
  }

  WeatherWidgetLocation _locationFromJson(Map<String, dynamic> json) {
    final labelParts = <String>[
      if (json['name'] case final String value when value.trim().isNotEmpty)
        value.trim(),
      if (json['admin1'] case final String value when value.trim().isNotEmpty)
        value.trim(),
      if (json['country'] case final String value when value.trim().isNotEmpty)
        value.trim(),
    ];

    final latitude = (json['latitude'] as num?)?.toDouble() ?? 0;
    final longitude = (json['longitude'] as num?)?.toDouble() ?? 0;

    return WeatherWidgetLocation(
      label: labelParts.isEmpty ? 'Lokalizacja' : labelParts.join(', '),
      latitude: latitude,
      longitude: longitude,
      timezone: json['timezone']?.toString(),
      country: json['country']?.toString(),
      admin1: json['admin1']?.toString(),
    );
  }

  String _messageFromError(DioException error) {
    final backendMessage = _extractBackendMessage(error.response?.data);
    if (backendMessage != null && backendMessage.trim().isNotEmpty) {
      return backendMessage.trim();
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        'Przekroczono czas oczekiwania na odpowiedz Open-Meteo.',
      DioExceptionType.connectionError =>
        'Brak polaczenia z usluga Open-Meteo.',
      _ => 'Nie udalo sie pobrac danych pogodowych.',
    };
  }

  String? _extractBackendMessage(Object? data) {
    if (data is Map) {
      final reason = data['reason']?.toString().trim() ?? '';
      if (reason.isNotEmpty) {
        return reason;
      }
      final message = data['message']?.toString().trim() ?? '';
      if (message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }
}
