import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_panel.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'project_setup_wizard_fixture.dart';

/// Geometria modala jest czystą funkcją viewportu, więc kontrakt szerokości
/// i wysokości sprawdzamy bez uruchamiania widgetów.
void main() {
  group('ProjectSetupWizardMetrics', () {
    test('szeroki ekran dostaje docelową szerokość i wysokość', () {
      final metrics = ProjectSetupWizardMetrics.forViewport(
        const Size(1440, 900),
      );

      expect(metrics.isTwoPanel, isTrue);
      expect(metrics.width, 1120);
      expect(metrics.height, 780);
      expect(metrics.controlsWidth, inInclusiveRange(340, 400));
    });

    test('modal nie wychodzi poza viewport na granicy breakpointu', () {
      final wide = ProjectSetupWizardMetrics.forViewport(const Size(1088, 900));
      final edge = ProjectSetupWizardMetrics.forViewport(const Size(960, 900));

      expect(wide.isTwoPanel, isTrue);
      expect(wide.width, 1040);
      expect(edge.isTwoPanel, isTrue);
      // 960 px nadal pokazuje dwa panele, ale szerokość wynika z viewportu.
      expect(edge.width, 912);
      expect(edge.controlsWidth, inInclusiveRange(340, 400));
    });

    test(
      'wąskie okno przechodzi w jedną kolumnę i nie przekracza viewportu',
      () {
        final narrow = ProjectSetupWizardMetrics.forViewport(
          const Size(959, 800),
        );
        final smallest = ProjectSetupWizardMetrics.forViewport(
          const Size(720, 640),
        );

        expect(narrow.isTwoPanel, isFalse);
        expect(narrow.width, 927);
        expect(smallest.isTwoPanel, isFalse);
        expect(smallest.width, 688);
        expect(smallest.height, 608);
      },
    );

    test('minimalny obsługiwany viewport nie daje ujemnej wysokości', () {
      final metrics = ProjectSetupWizardMetrics.forViewport(
        const Size(320, 240),
      );

      expect(metrics.width, greaterThan(0));
      expect(metrics.height, greaterThan(0));
    });
  });

  group('ProjectSetupWizardLayout', () {
    Future<void> openWizard(
      WidgetTester tester, {
      required Size viewport,
      double textScale = 1,
    }) async {
      await pumpProjectSetupApp(
        tester,
        viewport: viewport,
        textScale: textScale,
        open: (context) => ProjectResourceCreationDialogs.showCreateProject(
          context,
          workspaceId: kProjectSetupWorkspaceId,
          repository: FakeSessionProjectsRepository(
            FakeProjectSetupsRepository(),
          ),
          onCreated: () {},
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('szeroki ekran pokazuje kontrolki i podgląd obok siebie', (
      tester,
    ) async {
      await openWizard(tester, viewport: const Size(1440, 900));

      expect(tester.takeException(), isNull);
      expect(find.byKey(ProjectSetupWizardLayout.controlsKey), findsOneWidget);
      expect(
        find.byKey(ProjectSetupWizardLayout.widePreviewKey),
        findsOneWidget,
      );
      expect(
        find.byKey(ProjectSetupWizardLayout.narrowPreviewKey),
        findsNothing,
      );
      expect(find.byKey(ProjectPreviewPanel.panelKey), findsOneWidget);

      // Kontrakt planu: modal ma co najmniej 960 px szerokości na ekranie 1440.
      final dialog = tester.getSize(find.byType(ProjectSetupWizardLayout));
      expect(dialog.width, greaterThanOrEqualTo(960));
    });

    testWidgets('wąskie okno chowa podgląd pod kontrolki', (tester) async {
      await openWizard(tester, viewport: const Size(720, 640));

      expect(tester.takeException(), isNull);
      expect(find.byKey(ProjectSetupWizardLayout.controlsKey), findsOneWidget);
      expect(
        find.byKey(ProjectSetupWizardLayout.widePreviewKey),
        findsNothing,
      );
      expect(
        find.byKey(ProjectSetupWizardLayout.narrowPreviewKey),
        findsOneWidget,
      );
      // Podgląd jest w tym samym drzewie, ale pod kontrolkami.
      final controls = tester.getTopLeft(
        find.byKey(ProjectSetupWizardLayout.controlsKey),
      );
      final preview = tester.getTopLeft(
        find.byKey(ProjectPreviewPanel.panelKey),
      );
      expect(preview.dy, greaterThan(controls.dy));
    });

    testWidgets('wąskie okno i powiększony tekst nie przepełniają modala', (
      tester,
    ) async {
      await openWizard(
        tester,
        viewport: const Size(720, 640),
        textScale: 1.3,
      );

      expect(tester.takeException(), isNull);
      expect(
        find.byKey(ProjectSetupWizardLayout.narrowPreviewKey),
        findsOneWidget,
      );
    });

    testWidgets('wąska sekcja podglądu daje się zwinąć', (tester) async {
      await openWizard(tester, viewport: const Size(720, 640));

      expect(find.byKey(ProjectPreviewPanel.panelKey), findsOneWidget);
      await tester.tap(find.text('Podgląd projektu').first);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byKey(ProjectPreviewPanel.panelKey), findsNothing);
    });
  });
}
