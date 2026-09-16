import 'dart:io';

import 'package:hive_ce/hive.dart';
import 'package:ready_next/core/storage/hive_helper.dart';
import 'package:ready_next/core/storage/hive_registrar.g.dart';

Future<Directory> initTestHive({String prefix = 'ready_next_test_'}) async {
  final directory = await Directory.systemTemp.createTemp(prefix);
  Hive.init(directory.path);
  Hive.registerAdapters();
  return directory;
}

Future<void> disposeTestHive(Directory directory) async {
  await HiveHelper.closeAllBoxes();
  await Hive.close();
  if (directory.existsSync()) {
    await directory.delete(recursive: true);
  }
}
