import 'package:bloc/bloc.dart';
import 'package:ready_next/features/dashboard/data/weather/open_meteo_weather_repository.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/cubit/weather_widget_state.dart';

/// Cubit sterujący prognozą 7-dniową w widgetcie pogodowym.
class WeatherWidgetCubit extends Cubit<WeatherWidgetState> {
  /// Tworzy cubit widgetu pogodowego.
  WeatherWidgetCubit({required this._repository})
    : super(const WeatherWidgetInitial());

  final OpenMeteoWeatherRepository _repository;

  WeatherWidgetLocation? _currentLocation;

  /// Aktualnie wybrana lokalizacja.
  WeatherWidgetLocation? get currentLocation => _currentLocation;

  /// Ustawia lokalizację i pobiera prognozę.
  Future<void> setLocation(WeatherWidgetLocation location) async {
    _currentLocation = location;
    emit(WeatherWidgetLoading(location: location));
    await _loadForecast(location);
  }

  /// Czyści konfigurację lokalizacji.
  void clearLocation() {
    _currentLocation = null;
    emit(const WeatherWidgetInitial());
  }

  /// Odświeża prognozę dla bieżącej lokalizacji.
  Future<void> refresh() async {
    final location = _currentLocation;
    if (location == null) {
      return;
    }

    emit(WeatherWidgetLoading(location: location));
    await _loadForecast(location);
  }

  Future<void> _loadForecast(WeatherWidgetLocation location) async {
    try {
      final forecast = await _repository.fetchForecast(location: location);
      if (isClosed) {
        return;
      }

      emit(
        WeatherWidgetLoaded(
          location: location,
          forecast: forecast,
          loadedAt: DateTime.now(),
        ),
      );
    } on OpenMeteoWeatherException catch (error) {
      if (isClosed) {
        return;
      }

      emit(
        WeatherWidgetError(
          location: location,
          message: error.message,
        ),
      );
    } catch (_) {
      if (isClosed) {
        return;
      }

      emit(
        WeatherWidgetError(
          location: location,
          message: 'Nie udalo sie pobrac prognozy pogody.',
        ),
      );
    }
  }
}
