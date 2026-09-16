import 'package:geolocator/geolocator.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';

/// Serwis pobierający bieżącą lokalizację urządzenia.
class WeatherLocationService {
  /// Tworzy serwis geolokalizacji.
  const WeatherLocationService();

  /// Próbuje odczytać aktualne położenie urządzenia.
  Future<WeatherWidgetLocation?> detectCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 8),
        ),
      );

      return WeatherWidgetLocation(
        label: 'Wykryta lokalizacja',
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on PermissionRequestInProgressException {
      return null;
    } on LocationServiceDisabledException {
      return null;
    } on Exception {
      return null;
    }
  }
}
