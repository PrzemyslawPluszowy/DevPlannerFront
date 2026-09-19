// Wizualny harness celowo utrzymuje deklaratywną listę dzieci; część
// konstruktorów jest nieconst, bo test ma prezentować stany interaktywne.
// ignore_for_file: unnecessary_const

import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_collapsible_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wizualny smoke test shared menu.
///
/// Sprawdza brak wyjątków i overflow na reprezentatywnej hierarchii menu.
void main() {
  testWidgets('hierarchia menu renderuje się bez overflow', (tester) async {
    final controller = AppCollapsibleNavigationController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Row(
            children: [
              AppCollapsibleNavigationPanel(
                controller: controller,
                expandedWidth: 286,
                collapsedWidth: 58,
                expandedBuilder: (_) => const _MenuPreview(),
                collapsedBuilder: (_) => const _CollapsedPreview(),
              ),
              const Expanded(child: ColoredBox(color: Color(0xfff6f7fb))),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    controller.collapse();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 110));

    expect(tester.takeException(), isNull);
  });
}

class _MenuPreview extends StatelessWidget {
  const _MenuPreview();

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    key: const ValueKey('workspace-menu-preview'),
    child: Material(
      color: context.colors.surface,
      child: ListView(
        padding: const EdgeInsets.all(Sizes.p12),
        children: const [
          const _SectionLabel('PRYWATNE'),
          const _Link('Moje zadania', AppIcons.tasks),
          const _Link('Moje pliki', AppIcons.file),
          const SizedBox(height: 16),
          const _SectionLabel('ULUBIONE'),
          const _Link('Marketing workspace', AppIcons.pin, selected: true),
          const SizedBox(height: 16),
          const _SectionLabel('WORKSPACE’Y'),
          const AppExpansibleNavigationItem(
            label: 'Marketing workspace',
            icon: AppIcons.workspaces,
            hasChildren: true,
            initiallyExpanded: true,
            selected: true,
            body: Column(
              children: const [
                const _Link('Przegląd', AppIcons.dashboard, depth: 1),
                const _Link('Projekty', AppIcons.folders, depth: 1),
                const AppExpansibleNavigationItem(
                  label: 'Kampania Q4',
                  icon: AppIcons.workflow,
                  hasChildren: true,
                  initiallyExpanded: true,
                  depth: 1,
                  body: Column(
                    children: const [
                      const _Link('Zadania', AppIcons.tasks, depth: 2),
                      const _Link('Kanban', AppIcons.kanban, depth: 2),
                      const _Link('Whiteboardy', AppIcons.whiteboard, depth: 2),
                      const _Link('Wiki', AppIcons.wiki, depth: 2),
                    ],
                  ),
                ),
                const _Link('Pliki', AppIcons.file, depth: 1),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _CollapsedPreview extends StatelessWidget {
  const _CollapsedPreview();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.symmetric(vertical: 12),
    children: const [
      Tooltip(
        message: 'Moje zadania',
        child: IconButton(onPressed: null, icon: Icon(AppIcons.tasks)),
      ),
      Tooltip(
        message: 'Workspace’y',
        child: IconButton(onPressed: null, icon: Icon(AppIcons.workspaces)),
      ),
      Tooltip(
        message: 'Projekty',
        child: IconButton(onPressed: null, icon: Icon(AppIcons.workflow)),
      ),
    ],
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      label,
      style: context.text.labelSmall?.copyWith(
        letterSpacing: .5,
        fontWeight: FontWeight.w700,
        color: context.colors.onSurfaceVariant,
      ),
    ),
  );
}

class _Link extends StatelessWidget {
  const _Link(this.label, this.icon, {this.depth = 0, this.selected = false});
  final String label;
  final IconData icon;
  final int depth;
  final bool selected;

  @override
  Widget build(BuildContext context) => AppExpansibleNavigationItem(
    label: label,
    icon: icon,
    depth: depth,
    selected: selected,
  );
}
