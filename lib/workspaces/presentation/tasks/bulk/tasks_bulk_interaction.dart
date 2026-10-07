/// Jedna interakcja od otwarcia pickera do zakończenia komendy.
/// Właścicielem jest State paska, więc przebudowa nie zwalnia blokady.
final class TasksBulkInteraction {
  bool _active = false;

  Future<void> run(Future<void> Function() operation) async {
    if (_active) return;
    _active = true;
    try {
      await operation();
    } finally {
      _active = false;
    }
  }
}
