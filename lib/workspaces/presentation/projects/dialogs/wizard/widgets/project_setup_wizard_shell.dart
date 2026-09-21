import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_panel.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_help_button.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_step_timeline.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_layout.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Rama kreatora projektu: nagłówek z krokami, treść kroku, podgląd i stopka akcji.
///
/// Rama nie zna portów ani HTTP — czyta wyłącznie stan Cubita i wywołuje jego
/// komendy. Kroki dostają gotowe [ProjectSetupDraft] i zestaw callbacków, więc
/// nie mogą wysłać żadnego żądania samodzielnie. Rozmiar modala wylicza
/// [ProjectSetupWizardMetrics] z viewportu: na szerokim ekranie kontrolki i
/// podgląd stoją obok siebie, w wąskim oknie podgląd jest zwijaną sekcją pod
/// kontrolkami.
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
      builder: (context, state) {
        final metrics = ProjectSetupWizardMetrics.forViewport(
          MediaQuery.sizeOf(context),
        );
        return Dialog(
          backgroundColor: colors.surfaceContainerLowest,
          elevation: 8,
          insetPadding: EdgeInsets.symmetric(
            horizontal: metrics.isTwoPanel ? Sizes.p24 : Sizes.p16,
            vertical: metrics.isTwoPanel ? Sizes.p24 : Sizes.p16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: metrics.width,
              maxHeight: metrics.height,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(state: state),
                Divider(height: 1, color: colors.outlineVariant),
                Flexible(
                  child: ProjectSetupWizardLayout(
                    controls: stepBody(context, state),
                    preview: ProjectPreviewPanel(state: state),
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
        );
      },
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
    final accent =
        ProjectDialogColorHexCodec.toColor(state.draft.colorHex) ??
        colors.primary;
    final isLocked = state.isSubmitting || state.isSucceeded;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p24,
        Sizes.p16,
        Sizes.p16,
        Sizes.p12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(Sizes.p12),
                  ),
                  border: Border.all(color: accent.withValues(alpha: 0.4)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  WorkspaceIconHelper.iconFor(state.draft.iconKey),
                  size: 20,
                  color: accent,
                ),
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.projectSetupWizardTitle,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          l10n.projectSetupStepCounter(
                            step.ordinal,
                            ProjectSetupStep.values.length,
                          ),
                          style: context.text.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Gaps.h2,
                    Text(
                      ProjectSetupWizardL10n.stepTitle(l10n, step),
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      ProjectSetupWizardL10n.stepSubtitle(l10n, step),
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.w8,
              ProjectSetupHelpButton(
                title: l10n.projectSetupHelpPreviewTitle,
                body: l10n.projectSetupHelpPreviewBody,
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
            enabled: !isLocked,
            onStepSelected: (target) =>
                context.read<ProjectSetupWizardCubit>().goToStep(target),
          ),
          Gaps.h8,
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(999)),
            child: LinearProgressIndicator(
              value: (step.index + 1) / ProjectSetupStep.values.length,
              minHeight: 3,
              backgroundColor: colors.surfaceContainerHighest,
              semanticsLabel: l10n.projectSetupStepCounter(
                step.ordinal,
                ProjectSetupStep.values.length,
              ),
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
    // Nieaktualny plan nie może zostać wysłany: przycisk tworzenia czeka na
    // odświeżenie, żeby projekt powstał dokładnie z tego, co pokazuje podgląd.
    final canCreate =
        !isBusy &&
        !state.isSucceeded &&
        state.plan != null &&
        !state.planIsStale;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p20,
        Sizes.p10,
        Sizes.p20,
        Sizes.p10,
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Sizes.p8,
        runSpacing: Sizes.p4,
        children: [
          if (!isLastStep)
            TextButton(
              onPressed: isBusy ? null : cubit.skipToSummary,
              child: Text(l10n.projectSetupSkipToSummaryButton),
            ),
          TextButton(
            onPressed: state.step.index == 0 || isBusy ? null : cubit.back,
            child: Text(l10n.projectSetupBackButton),
          ),
          if (isLastStep)
            FilledButton.icon(
              onPressed: canCreate ? () => unawaited(cubit.submit()) : null,
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
