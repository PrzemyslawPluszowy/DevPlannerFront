import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Strażnik kontraktu menu: jeden komponent, tokeny theme, zero starych klas.
///
/// Test czyta źródła, bo te reguły dotyczą całego zakresu menu, a nie jednego
/// widgetu. Każdy wyjątek musi być świadomą decyzją, więc lista plików jest
/// jawna.
void main() {
  const sharedMenuFiles = [
    'lib/shared/presentation/widgets/app_context_menu.dart',
    'lib/shared/presentation/widgets/app_context_menu_button.dart',
  ];

  const tasksMenuDir = 'lib/workspaces/presentation/tasks/list/menu';

  test('zakres menu nie importuje historycznego core/theme', () {
    final offenders = <String>[];
    for (final path in sharedMenuFiles) {
      if (File(path).readAsStringSync().contains('devplanner/core/theme')) {
        offenders.add(path);
      }
    }
    final menuFiles = Directory(tasksMenuDir)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    for (final file in menuFiles) {
      if (file.readAsStringSync().contains('devplanner/core/theme')) {
        offenders.add(file.path);
      }
    }
    expect(offenders, isEmpty);
  });

  test('zakres menu nie zawiera lokalnych kolorów powierzchni', () {
    final offenders = <String>[];
    for (final path in sharedMenuFiles) {
      final source = File(path).readAsStringSync();
      if (source.contains('Colors.white') || source.contains('Colors.black')) {
        offenders.add(path);
      }
    }
    expect(offenders, isEmpty);
  });

  test('wariant glass i stare klasy menu nie istnieją', () {
    expect(
      File('lib/shared/presentation/widgets/workspace_context_menu.dart')
          .existsSync(),
      isFalse,
      reason: 'WorkspaceContextMenu zostało zastąpione wspólnym menu.',
    );
    expect(
      File(
        'lib/workspaces/presentation/tasks/list/menu/task_context_menu.dart',
      ).existsSync(),
      isFalse,
      reason: 'TaskContextMenu zostało zastąpione wspólnym menu.',
    );
    final menuSource = File(
      'lib/shared/presentation/widgets/app_context_menu.dart',
    ).readAsStringSync();
    expect(menuSource.contains('AppContextMenuStyle'), isFalse);
    expect(menuSource.contains('glass'), isFalse);
  });

  test('picker tabeli korzysta ze wspólnego kontraktu menu', () {
    final pickerDir = Directory('$tasksMenuDir/pickers');
    final offenders = <String>[];
    for (final file in pickerDir
        .listSync()
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))) {
      final source = file.readAsStringSync();
      final usesSharedContract =
          source.contains('AppContextMenu.select') ||
          source.contains('AppContextMenu.showCustom') ||
          source.contains('AppContextMenu.show(');
      final declaresMenu =
          source.contains('showDialog') ||
          source.contains('showMenu') ||
          source.contains('PopupMenuButton');
      if (declaresMenu && !usesSharedContract) {
        offenders.add(file.path);
      }
    }
    expect(offenders, isEmpty);
  });
}
