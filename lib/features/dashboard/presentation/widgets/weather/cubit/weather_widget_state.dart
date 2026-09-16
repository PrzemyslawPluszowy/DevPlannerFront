import 'package:equatable/equatable.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';

/// Bazowy stan widgetu pogodowego.
sealed class WeatherWidgetState extends Equatable {
  /// Tworzy bazowy stan widgetu pogodowego.
  const WeatherWidgetState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy bez skonfigurowanej lokalizacji.
class WeatherWidgetInitial extends WeatherWidgetState {
  /// Tworzy stan początkowy.
  const WeatherWidgetInitial();
}

/// Stan pobierania danych pogodowych.
class WeatherWidgetLoading extends WeatherWidgetState {
  /// Tworzy stan ładowania.
  const WeatherWidgetLoading({this.location});

  /// Lokalizacja, dla której pobieramy prognozę.
  final WeatherWidgetLocation? location;

  @override
  List<Object?> get props => [location];
}

/// Stan poprawnie pobranych danych pogodowych.
class WeatherWidgetLoaded extends WeatherWidgetState {
  /// Tworzy stan załadowanej prognozy.
  const WeatherWidgetLoaded({
    required this.location,
    required this.forecast,
    required this.loadedAt,
  });

  /// Wybrana lokalizacja.
  final WeatherWidgetLocation location;

  /// Prognoza 7-dniowa.
  final WeatherWidgetForecast forecast;

  /// Czas pobrania danych.
  final DateTime loadedAt;

  @override
  List<Object?> get props => [location, forecast, loadedAt];
}

/// Stan błędu pobierania danych pogodowych.
class WeatherWidgetError extends WeatherWidgetState {
  /// Tworzy stan błędu.
  const WeatherWidgetError({
    required this.message,
    this.location,
  });

  /// Komunikat prezentowany użytkownikowi.
  final String message;

  /// Lokalizacja, dla której próbowano pobrać prognozę.
  final WeatherWidgetLocation? location;

  @override
  List<Object?> get props => [message, location];
}
