import 'dart:async';

import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';

/// Kanał zmian sterowany z testu.
///
/// Kontroler jest asynchroniczny, tak jak produkcyjny: synchronizowany
/// broadcast nie domyka `cancel()` w strefie testów widgetowych, więc sprzątanie
/// po ekranie nigdy by się nie kończyło. Testy po `emit` przepuszczają mikrotask.
final class FakeStorageRealtimeClient implements StorageRealtimeClient {
  final StreamController<StorageRealtimeEvent> controller =
      StreamController<StorageRealtimeEvent>.broadcast();

  /// Zakresy, o które poprosił ekran, w kolejności wywołań.
  final List<StorageRealtimeTarget> started = [];

  /// Liczba zamknięć subskrypcji (zakres bez kanału albo zmiana zakresu).
  int stopCount = 0;

  /// Czy klient został zwolniony razem z ekranem.
  bool disposed = false;

  @override
  Stream<StorageRealtimeEvent> get events => controller.stream;

  @override
  Future<void> start(StorageRealtimeTarget target) async => started.add(target);

  @override
  Future<void> stop() async => stopCount++;

  @override
  Future<void> dispose() async {
    disposed = true;
    // Zamknięcie kontrolera nie jest wyczekiwane: jego przyszłość domyka się
    // poza strefą testu widgetowego, więc czekanie na nią zawiesiłoby sprzątanie.
    unawaited(controller.close());
  }

  /// Wysyła zdarzenie do ekranu.
  void emit(StorageRealtimeEvent event) => controller.add(event);
}
