import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_step_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Rama kreatora projektu: nagłówek z krokami, przewijana treść i stopka akcji.
///
/// Rama nie zna portów ani HTTP — czyta wyłącznie stan Cubita i wywołuje jego
/// komendy. Kroki dostają gotowe [ProjectSetupDraft] i zestaw callbacków, więc
/// nie mogą wysłać żadnego żądania samodzielnie.
class ProjectSetupWizardShell extends StatelessWidget {
  /// Tworzy ramę kreatora.
  const ProjectSetupWizardShell({required this.stepBody, super.key});

  /// Treść bieżącego kroku.
  final Widget Function(BuildContext context, ProjectSetupWizardState state)
  stepBody;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return BlocBuilder<ProjectSetupWizardCubit, ProjectSetupWizardState>(
      builder: (context, state) => Dialog(
        backgroundColor: colors.surfaceContainerLowest,
        elevation: 8,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: colors.outlineVariant),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720, maxHeight: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(state: state),
              Divider(height: 1, color: colors.outlineVariant),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: stepBody(context, state),
                ),
              ),
              Divider(height: 1, color: colors.outlineVariant),
              _Footer(state: state),
              if (state.isSubmitting)
                LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: colors.surfaceContainerHighest,
                  semanticsLabel: l10n.projectSetupCreatingButton,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.state});

  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final step = state.step;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.projectSetupWizardTitle,
                      style: context.text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      l10n.projectSetupWizardSubtitle,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!state.isSubmitting && !state.isSucceeded)
                IconButton(
                  tooltip: l10n.projectSetupCancelButton,
                  icon: const Icon(Symbols.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
            ],
          ),
          Gaps.h12,
          ProjectSetupStepTimeline(
            currentStep: step,
            enabled: !state.isSubmitting && !state.isSucceeded,
            onStepSelected: (target) =>
                context.read<ProjectSetupWizardCubit>().goToStep(target),
          ),
          Gaps.h8,
          Text(
            '${l10n.projectSetupStepCounter(step.ordinal, ProjectSetupStep.values.length)} · '
            '${ProjectSetupWizardL10n.stepTitle(l10n, step)}',
            style: context.text.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final isLastStep = state.step == ProjectSetupStep.summary;
    final isBusy = state.isSubmitting;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          if (!isLastStep)
            TextButton(
              onPressed: isBusy ? null : cubit.skipToSummary,
              child: Text(l10n.projectSetupSkipToSummaryButton),
            ),
          const Spacer(),
          TextButton(
            onPressed: state.step.index == 0 || isBusy ? null : cubit.back,
            child: Text(l10n.projectSetupBackButton),
          ),
          Gaps.w8,
          if (isLastStep)
            FilledButton.icon(
              onPressed: isBusy || state.isSucceeded
                  ? null
                  : () => unawaited(cubit.submit()),
              icon: isBusy
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Symbols.add_task, size: 18),
              label: Text(
                isBusy
                    ? l10n.projectSetupCreatingButton
                    : l10n.projectSetupCreateButton,
              ),
            )
          else
            FilledButton(
              onPressed: isBusy ? null : cubit.next,
              child: Text(l10n.projectSetupNextButton),
            ),
        ],
      ),
    );
  }
}
