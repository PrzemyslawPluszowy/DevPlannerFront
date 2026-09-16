import 'package:ready_next/bootstrap/host_launch_context.dart';

/// Kontrakt komunikacji miedzy hostem a aplikacja Flutter.
///
/// Hostem moze byc stare Ready osadzajace Flutter Web albo inna powloka,
/// ktora przekazuje dane startowe i zarzadza sesja.
abstract class HostBridge {
  /// Zwraca komplet danych potrzebnych do uruchomienia modulu.
  Future<HostLaunchContext> getLaunchContext();

  /// Prosi hosta o odswiezenie access tokena.
  Future<String?> refreshAccessToken();
}
