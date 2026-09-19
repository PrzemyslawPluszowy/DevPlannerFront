import 'dart:io';

import 'package:devplanner/core/storage/hive_helper.dart';
import 'package:devplanner/core/storage/hive_registrar.g.dart';
import 'package:hive_ce/hive.dart';

Future<Directory> initTestHive({String prefix = 'devplanner_test_'}) async {
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
