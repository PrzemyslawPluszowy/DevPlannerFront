import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/modules/app_modules_catalog.dart';

void main() {
  test('Workspaces jest widoczny dla zalogowanego użytkownika bez prawa modułowego', () {
    final modules = AppModulesCatalog.globalRailModulesFor(const {});

    expect(
      modules.any((module) => module.key == AppModuleKey.workspaces),
      isTrue,
    );
  });

  test('ścieżka podrzędna Workspaces rozpoznaje moduł nadrzędny', () {
    final module = AppModulesCatalog.findByPath('/workspaces/projects');

    expect(module?.key, AppModuleKey.workspaces);
  });
}
