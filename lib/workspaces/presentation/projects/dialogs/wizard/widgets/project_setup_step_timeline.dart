import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pasek kroków kreatora projektu.
///
/// Kroki opcjonalne są oznaczone, żeby użytkownik wiedział, że można je pominąć
/// i że podsumowanie pokaże wybrane wartości domyślne.
class ProjectSetupStepTimeline extends StatelessWidget {
  /// Tworzy pasek kroków.
  const ProjectSetupStepTimeline({
    required this.currentStep,
    required this.enabled,
    required this.onStepSelected,
    super.key,
  });

  /// Krok aktualnie pokazywany.
  final ProjectSetupStep currentStep;

  /// Czy kliknięcie kroku może zmienić stan kreatora.
  final bool enabled;

  /// Wybór kroku przez użytkownika.
  final ValueChanged<ProjectSetupStep> onStepSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: context.l10n.projectSetupStepCounter(
        currentStep.ordinal,
        ProjectSetupStep.values.length,
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final step in ProjectSetupStep.values)
            _StepChip(
              step: step,
              isCurrent: step == currentStep,
              isDone: step.index < currentStep.index,
              enabled: enabled,
              onSelected: () => onStepSelected(step),
              outlineColor: colors.outlineVariant,
            ),
        ],
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({
    required this.step,
    required this.isCurrent,
    required this.isDone,
    required this.enabled,
    required this.onSelected,
    required this.outlineColor,
  });

  final ProjectSetupStep step;
  final bool isCurrent;
  final bool isDone;
  final bool enabled;
  final VoidCallback onSelected;
  final Color outlineColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final label =
        '${step.ordinal}. ${ProjectSetupWizardL10n.stepTitle(l10n, step)}';
    final background = isCurrent
        ? colors.primaryContainer
        : colors.surfaceContainerHighest;
    final foreground = isCurrent
        ? colors.onPrimaryContainer
        : colors.onSurfaceVariant;
    return Tooltip(
      message: step.isOptional
          ? '$label · ${l10n.projectSetupSkipToSummaryButton}'
          : label,
      child: InkWell(
        onTap: enabled ? onSelected : null,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: background,
            borderRadius: const BorderRadius.all(Radius.circular(999)),
            border: Border.all(
              color: isCurrent ? colors.primary : outlineColor,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDone) ...[
                Icon(Symbols.check, size: 14, color: foreground),
                Gaps.w4,
              ],
              Text(
                label,
                style: context.text.labelSmall?.copyWith(
                  color: foreground,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (step.isOptional) ...[
                Gaps.w4,
                Icon(
                  Symbols.skip_next,
                  size: 13,
                  color: foreground.withValues(alpha: 0.7),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
