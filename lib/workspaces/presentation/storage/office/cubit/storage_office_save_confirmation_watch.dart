import 'dart:async';

/// Kontroluje wersję serwerową dla konkretnego cyklu zapisu dokumentu.
/// Zatrzymanie unieważnia także odpowiedzi zapytań już wysłanych.
final class StorageOfficeSaveConfirmationWatch {
  StorageOfficeSaveConfirmationWatch({
    required this.readVersion,
    required this.onConfirmed,
    required this.onUnconfirmed,
    required this.interval,
    required this.timeout,
  });

  final Future<int?> Function() readVersion;
  final void Function(int version) onConfirmed;
  final void Function() onUnconfirmed;
  final Duration interval;
  final Duration timeout;

  Timer? _timer;
  DateTime? _deadline;
  int _generation = 0;
  int? _inFlightGeneration;

  void start(int versionFloor) {
    stop();
    final generation = _generation;
    _deadline = DateTime.now().add(timeout);
    _timer = Timer.periodic(
      interval,
      (_) => unawaited(_poll(generation, versionFloor)),
    );
  }

  void stop() {
    _generation++;
    _timer?.cancel();
    _timer = null;
    _deadline = null;
  }

  void _markUnconfirmed(int generation, int versionFloor) {
    if (generation != _generation || _deadline == null) return;
    _deadline = null;
    _timer?.cancel();
    // Dalszy odczyt pozwala potwierdzić późny callback lub ręczny zapis.
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => unawaited(_poll(generation, versionFloor)),
    );
    onUnconfirmed();
  }

  Future<void> _poll(int generation, int versionFloor) async {
    if (generation != _generation) return;
    if (_deadline case final deadline? when DateTime.now().isAfter(deadline)) {
      _markUnconfirmed(generation, versionFloor);
    }
    if (_inFlightGeneration == generation) return;
    _inFlightGeneration = generation;
    try {
      final version = await readVersion();
      if (generation != _generation) return;
      if (version == null) {
        // Nieudany odczyt nie może udawać skutecznej weryfikacji.
        _markUnconfirmed(generation, versionFloor);
        return;
      }
      if (version <= versionFloor) return;
      stop();
      onConfirmed(version);
    } on Object {
      if (generation == _generation) {
        _markUnconfirmed(generation, versionFloor);
      }
    } finally {
      if (_inFlightGeneration == generation) _inFlightGeneration = null;
    }
  }
}
