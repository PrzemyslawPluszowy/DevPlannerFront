import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Przełącznik sposobu prezentacji podglądu: tablica albo lista.
///
/// Zmienia wyłącznie lokalny widok podglądu. Domyślnego widoku projektu nie
/// zmienia — ten wybór należy do kroku „Sposób pracy”.
class ProjectPreviewModeToggle extends StatelessWidget {
  /// Tworzy przełącznik podglądu.
  const ProjectPreviewModeToggle({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  /// Klucz przełącznika używany w testach.
  static const Key toggleKey = ValueKey('project-preview-mode-toggle');

  /// Aktualnie pokazywany widok podglądu.
  final ProjectSetupTaskViewKind mode;

  /// Zmiana widoku podglądu.
  final ValueChanged<ProjectSetupTaskViewKind> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedButton<ProjectSetupTaskViewKind>(
      key: toggleKey,
      segments: [
        ButtonSegment(
          value: ProjectSetupTaskViewKind.board,
          icon: const Icon(Symbols.view_kanban, size: 16),
          label: Text(l10n.projectSetupViewBoard),
        ),
        ButtonSegment(
          value: ProjectSetupTaskViewKind.list,
          icon: const Icon(Symbols.view_list, size: 16),
          label: Text(l10n.projectSetupViewList),
        ),
      ],
      selected: {mode},
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(context.text.labelSmall),
      ),
      onSelectionChanged: (values) => onChanged(values.first),
    );
  }

  /// Nazwa widoku podglądu w postaci tekstu.
  static String modeLabel(
    BuildContext context,
    ProjectSetupTaskViewKind mode,
  ) => ProjectSetupWizardL10n.taskView(context.l10n, mode);
}
