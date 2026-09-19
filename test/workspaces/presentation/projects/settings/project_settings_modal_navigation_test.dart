import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../test_support/project_settings_fixture.dart';

/// Szerokość panelu nawigacji modala ustawień projektu.
const _navigationWidth = 230.0;

void main() {
  const project = ProjectListItem(
    id: 'proj-1',
    workspaceId: 'ws-1',
    name: 'Marketing Q3',
    description: 'Kampania Q3',
    myRole: ProjectRole.admin,
  );

  late ProjectSettingsFixture ports;

  setUp(() {
    ports = ProjectSettingsFixture(project: project);
  });

  Widget buildTestApp() => MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('pl'),
    home: MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProjectsRepository>.value(value: ports.projects),
        RepositoryProvider<ProjectSettingsComposition>.value(
          value: ports.composition,
        ),
      ],
      child: Scaffold(
        body: Builder(
          builder: (ctx) => ElevatedButton(
            onPressed: () => ProjectSettingsDialogs.show(
              context: ctx,
              project: project,
              userRole: ProjectRole.admin,
            ),
            child: const Text('Open Settings'),
          ),
        ),
      ),
    ),
  );

  Future<void> openSettings(WidgetTester tester, {required Size size}) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp());
    await tester.tap(find.text('Open Settings'));
    await tester.pumpAndSettle();
  }

  /// Panel nawigacji modala, czyli kolumna o stałej szerokości.
  Finder navigationPanel() => find.byWidgetPredicate(
    (widget) => widget is SizedBox && widget.width == _navigationWidth,
  );

  /// Kompaktowa nawigacja to pozioma lista pozycji.
  ///
  /// Test sprawdza wyłącznie pasek nawigacji — treść zakładek przy 700 px ma
  /// własne defekty układu, śledzone osobno w planie naprawy.
  Finder compactNavigation() => find.byWidgetPredicate(
    (widget) => widget is ListView && widget.scrollDirection == Axis.horizontal,
  );

  /// Wiersze nawigacji w kolejności renderowania.
  Finder navigationRows() => find.descendant(
    of: navigationPanel(),
    matching: find.byType(TextButton),
  );

  Rect rowRect(WidgetTester tester, int index) =>
      tester.getRect(navigationRows().at(index));

  /// Pozycja etykiety wiersza — pod nią stoi ikona i wcięcie, więc to ona
  /// pokazuje, czy treść jest dosunięta do lewej krawędzi panelu.
  double labelLeft(WidgetTester tester, int index) => tester
      .getTopLeft(
        find.descendant(
          of: navigationRows().at(index),
          matching: find.byType(Text),
        ),
      )
      .dx;

  TextButton rowButton(WidgetTester tester, int index) =>
      tester.widget<TextButton>(navigationRows().at(index));

  testWidgets('pozycje nawigacji stoją przy lewej krawędzi panelu', (
    tester,
  ) async {
    await openSettings(tester, size: const Size(1400, 900));

    final rows = navigationRows().evaluate().length;
    expect(rows, greaterThanOrEqualTo(4), reason: 'panel renderuje pozycje');

    final panel = tester.getRect(navigationPanel());
    final labelLefts = [for (var i = 0; i < rows; i++) labelLeft(tester, i)];

    for (final left in labelLefts) {
      expect(
        left,
        closeTo(labelLefts.first, .5),
        reason: 'wszystkie pozycje mają wspólną linię tekstu',
      );
    }
    expect(
      labelLefts.first,
      lessThan(panel.center.dx),
      reason: 'treść pozycji nie jest wyśrodkowana w panelu',
    );
    expect(
      labelLefts.first - panel.left,
      lessThan(48),
      reason: 'treść pozycji jest dosunięta do lewej krawędzi panelu',
    );
  });

  testWidgets('wiersze nawigacji mają stałą wysokość wiersza', (tester) async {
    await openSettings(tester, size: const Size(1400, 900));

    final rows = navigationRows().evaluate().length;
    final heights = [for (var i = 0; i < rows; i++) rowRect(tester, i).height];

    for (final height in heights) {
      expect(height, closeTo(heights.first, .5));
      expect(height, closeTo(Sizes.p36, .5));
    }
  });

  testWidgets('zaznaczona pozycja ma tło i obramowanie z tokenów', (
    tester,
  ) async {
    await openSettings(tester, size: const Size(1400, 900));

    final rows = navigationRows().evaluate().length;
    final roles = tester.element(navigationPanel()).surfaceRoles;
    final selected = <int>[];

    for (var index = 0; index < rows; index++) {
      final button = rowButton(tester, index);
      final background = button.style?.backgroundColor?.resolve(
        <WidgetState>{},
      );
      final side = button.style?.side?.resolve(<WidgetState>{});

      if (background != null) {
        selected.add(index);
        expect(
          background,
          roles.tintedBackground,
          reason: 'zaznaczenie używa wspólnej roli powierzchni',
        );
        expect(side?.color, roles.tintedBorder);
      } else {
        expect(side, isNull, reason: 'niezaznaczony wiersz nie ma obramowania');
      }
    }

    expect(
      selected,
      hasLength(1),
      reason: 'dokładnie jeden wiersz jest aktywny',
    );
  });

  testWidgets('kliknięcie pozycji przenosi zaznaczenie i przełącza zakładkę', (
    tester,
  ) async {
    await openSettings(tester, size: const Size(1400, 900));

    final rows = navigationRows().evaluate().length;
    final initiallySelected = [
      for (var index = 0; index < rows; index++)
        if (rowButton(tester, index).style?.backgroundColor != null) index,
    ];
    final targetIndex = initiallySelected.single == 0 ? 1 : 0;
    final targetLabel = tester
        .widget<Text>(
          find.descendant(
            of: navigationRows().at(targetIndex),
            matching: find.byType(Text),
          ),
        )
        .data!;

    await tester.tap(
      find.descendant(
        of: navigationRows().at(targetIndex),
        matching: find.byType(Text),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      rowButton(tester, targetIndex).style?.backgroundColor,
      isNotNull,
      reason: '$targetLabel jest teraz zaznaczony',
    );
    expect(
      rowButton(tester, initiallySelected.single).style?.backgroundColor,
      isNull,
      reason: 'poprzednia pozycja traci tło',
    );
  });

  testWidgets('wąskie okno używa kompaktowej nawigacji bez błędów układu', (
    tester,
  ) async {
    await openSettings(tester, size: const Size(700, 800));

    expect(tester.takeException(), isNull);
    expect(navigationPanel(), findsNothing);
    expect(compactNavigation(), findsOneWidget);

    final chips = find.descendant(
      of: compactNavigation(),
      matching: find.byType(TextButton),
    );
    expect(chips, findsWidgets);

    final target = find.ancestor(
      of: find.text('Członkowie i dostęp'),
      matching: find.byType(TextButton),
    );
    expect(target, findsOneWidget);
    await tester.tap(target);
    await tester.pumpAndSettle();

    final selected = [
      for (var i = 0; i < chips.evaluate().length; i++)
        if (tester
                .widget<TextButton>(chips.at(i))
                .style
                ?.backgroundColor
                ?.resolve(<WidgetState>{}) !=
            null)
          i,
    ];
    expect(
      selected,
      hasLength(1),
      reason: 'dokładnie jedna pozycja paska jest aktywna',
    );
    expect(
      tester.widget<TextButton>(chips.at(selected.single)),
      same(tester.widget<TextButton>(target)),
    );
  });
}
