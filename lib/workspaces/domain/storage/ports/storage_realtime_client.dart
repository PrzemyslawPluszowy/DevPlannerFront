import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';

/// Typowany kanał zmian plików modułu Pliki.
///
/// Warstwa prezentacji zna wyłącznie ten kontrakt — nie importuje SignalR ani
/// klienta transportowego. Właścicielem cyklu życia jest ekran, który tworzy
/// klienta i wywołuje [dispose] razem z własnym zwolnieniem.
abstract interface class StorageRealtimeClient {
  /// Zdarzenia zmian w subskrybowanym zakresie, bez duplikatów.
  ///
  /// Zdarzenie jest sygnałem, nie danymi: po nim ekran odświeża widoczny zakres
  /// jednym żądaniem listy, zamiast łatać listę po identyfikatorach plików.
  Stream<StorageRealtimeEvent> get events;

  /// Podłącza kanał wskazanego zakresu.
  ///
  /// Powtórne wywołanie dla tego samego zakresu nie tworzy drugiej subskrypcji,
  /// a zmiana zakresu zamyka poprzednią. Po ponownym połączeniu transportu
  /// historia jest odtwarzana od ostatniego kursora.
  Future<void> start(StorageRealtimeTarget target);

  /// Zamyka subskrypcję bieżącego zakresu bez zamykania transportu.
  ///
  /// Widok bez własnego kanału (np. kosz) woła to zamiast [dispose], żeby nie
  /// zostawić aktywnej subskrypcji poprzedniego zakresu.
  Future<void> stop();

  /// Zamyka połączenie i zwalnia zasoby.
  Future<void> dispose();
}

/// Tworzy kanał dla jednego ekranu.
///
/// Ekran jest właścicielem cyklu życia: tworzy własnego klienta i zamyka go
/// razem ze sobą, więc zamknięcie jednego widoku nie zrywa kanału innego.
typedef StorageRealtimeClientFactory = StorageRealtimeClient Function();
