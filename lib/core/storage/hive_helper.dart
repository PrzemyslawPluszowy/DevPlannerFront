import 'package:hive_ce_flutter/hive_flutter.dart';

/// Small local-storage boundary used by standalone auth and Workspaces code.
///
/// Domain adapters are registered by the owning feature when that feature is
/// introduced. The foundation must not know about removed dashboard or host
/// contracts.
class HiveHelper {
  factory HiveHelper() => _instance;

  HiveHelper._internal();

  static final HiveHelper _instance = HiveHelper._internal();
  static final Map<String, Future<Box<dynamic>>> _openBoxes = {};

  static Future<void> init() => Hive.initFlutter('devplanner');

  static Future<Box<T>> openBox<T>(String name) async {
    final existing = _openBoxes[name];
    if (existing != null) {
      return (await existing) as Box<T>;
    }

    final future = Hive.openBox<T>(name);
    _openBoxes[name] = future;
    return future;
  }

  static Future<void> closeBox(String name) async {
    final future = _openBoxes.remove(name);
    if (future == null) {
      return;
    }

    final box = await future;
    if (box.isOpen) {
      await box.close();
    }
  }

  static Future<void> closeAllBoxes() async {
    final names = _openBoxes.keys.toList(growable: false);
    for (final name in names) {
      await closeBox(name);
    }
  }
}
