import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/navigation/cubit/workspace_shell_navigation_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/navigation/workspace_static_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({required bool expanded, required VoidCallback onFiles}) {
  final cubit = WorkspaceShellNavigationCubit(
    initiallyExpanded: expanded,
    onPanelChanged: (_) async {},
  );
  return MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: BlocProvider.value(
      value: cubit,
      child: WorkspaceStaticMenu(
        outerPadding: 0,
        onBack: () {},
        onFiles: onFiles,
      ),
    ),
  );
}

void main() {
  testWidgets('expanded workspace menu exposes clickable Files', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(_harness(expanded: true, onFiles: () => taps++));

    final files = find.text('Pliki i dokumenty');
    expect(files, findsOneWidget);
    await tester.tap(files);
    expect(taps, 1);
  });

  testWidgets('collapsed workspace menu keeps Files reachable by tooltip', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(_harness(expanded: false, onFiles: () => taps++));

    final files = find.byTooltip('Pliki i dokumenty');
    expect(files, findsOneWidget);
    await tester.tap(files);
    expect(taps, 1);
  });
}
