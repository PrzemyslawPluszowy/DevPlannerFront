import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('jasny theme udostępnia tokeny gmailowej ramy DevPlanner', () {
    final theme = MaterialTheme(Typography.material2021().black).light();
    final shell = theme.extension<DevPlannerShellTheme>();

    expect(shell, isNotNull);
    expect(shell!.backdropStart, const Color(0xff063c46));
    expect(shell.backdropEnd, const Color(0xff168b9c));
    expect(shell.contentSurface, const Color(0xffffffff));
    expect(shell.sidebarText, const Color(0xfff1f6f7));
  });

  test('ciemny theme zachowuje osobne tokeny ramy i treści', () {
    final theme = MaterialTheme(Typography.material2021().white).dark();
    final shell = theme.extension<DevPlannerShellTheme>();

    expect(shell, isNotNull);
    expect(shell!.backdropStart, const Color(0xff082d35));
    expect(shell.contentSurface, const Color(0xff20252b));
    expect(shell.sidebarSelected.a, greaterThan(0));
  });
}
