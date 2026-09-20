import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_error_banner.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Krok 7 kreatora: plan, liczby, ostrzeżenia i jedyne miejsce z `Utwórz`.
class ProjectSetupSummaryStep extends StatelessWidget {
  /// Tworzy krok podsumowania.
  const ProjectSetupSummaryStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    final plan = state.plan;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.globalError case final error?) ...[
          ProjectSetupErrorBanner(
            error: error,
            contextMessage: projectSetupErrorContext(context, error),
            onRetry: cubit.submit,
          ),
          Gaps.h16,
        ],
        if (state.isPreviewing) ...[
          Row(
            children: [
              const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              Gaps.w8,
              Text(
                l10n.projectSetupSummaryPlanLoading,
                style: context.text.bodySmall,
              ),
            ],
          ),
          Gaps.h16,
        ] else if (plan == null) ...[
          _PlanUnavailable(state: state),
          Gaps.h16,
        ],
        if (plan != null) ...[
          _PlanCard(plan: plan),
          if (state.planIsStale) ...[
            Gaps.h8,
            Row(
              children: [
                Icon(
                  Symbols.update,
                  size: 16,
                  color: context.colors.tertiary,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    l10n.projectSetupSummaryPlanStale,
                    style: context.text.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: cubit.refreshPlan,
                  child: Text(l10n.projectSetupRefreshPlanButton),
                ),
              ],
            ),
          ],
          if (plan.warnings.isNotEmpty) ...[
            Gaps.h16,
            ProjectSetupSectionLabel(l10n.projectSetupSummaryWarningsLegend),
            Gaps.h6,
            for (final warning in plan.warnings) _WarningRow(warning: warning),
          ],
        ],
      ],
    );
  }
}

class _PlanUnavailable extends StatelessWidget {
  const _PlanUnavailable({required this.state});

  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProjectSetupWizardCubit>();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.projectSetupSummaryPlanUnavailable,
            style: context.text.bodySmall,
          ),
          Gaps.h8,
          FilledButton.tonal(
            onPressed: cubit.refreshPlan,
            child: Text(l10n.projectSetupRefreshPlanButton),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final ProjectSetupPreviewResponse plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final template = plan.template;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Sizes.p12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProjectSetupSectionLabel(l10n.projectSetupSummaryLegend),
          Gaps.h8,
          _Row(
            label: l10n.projectSetupSummarySource,
            value: template == null
                ? l10n.projectSetupSummarySourceBlank
                : l10n.projectSetupSummarySourceTemplate(template.name),
          ),
          _Row(
            label: l10n.projectSetupSummaryName,
            value: plan.project.name,
          ),
          _Row(
            label: l10n.projectSetupSummaryVisibility,
            value: ProjectSetupWizardL10n.visibility(
              l10n,
              plan.project.visibility,
            ),
          ),
          _Row(
            label: l10n.projectSetupSummaryStatus,
            value: ProjectSetupWizardL10n.projectStatus(
              l10n,
              plan.project.status,
            ),
          ),
          _Row(
            label: l10n.projectSetupSummaryMembers,
            value: plan.project.inheritsWorkspaceMembers
                ? l10n.projectSetupSummaryMembersShared
                : l10n.projectSetupSummaryMembersCount(
                    plan.project.memberCount,
                  ),
          ),
          _Row(
            label: l10n.projectSetupSummaryWorkflow,
            value: _workflowLabel(l10n, plan.workflow),
          ),
          _Row(
            label: l10n.projectSetupSummaryView,
            value: ProjectSetupWizardL10n.taskView(
              l10n,
              plan.taskView.defaultView,
            ),
          ),
          _Row(
            label: l10n.projectSetupSummaryBoard,
            value: [
              ProjectSetupWizardL10n.cardDensity(
                l10n,
                plan.taskView.boardCardDensity,
              ),
              ProjectSetupWizardL10n.swimlaneMode(
                l10n,
                plan.taskView.boardSwimlaneMode,
              ),
            ].join(' · '),
          ),
          _Row(
            label: l10n.projectSetupSummarySchedule,
            value: _scheduleLabel(l10n, plan.scheduleMode),
          ),
          if (plan.defaultDailyCapacityMinutes case final minutes?)
            _Row(
              label: l10n.projectSetupSummaryCapacity,
              value: l10n.projectSetupSummaryCapacityValue(minutes),
            ),
          _Row(
            label: l10n.projectSetupSummaryRecipes,
            value: plan.automationRecipes.isEmpty
                ? l10n.projectSetupSummaryRecipesNone
                : [
                    for (final recipe in plan.automationRecipes)
                      ProjectSetupWizardL10n.recipeName(l10n, recipe.key),
                  ].join(', '),
          ),
          if (template != null) ...[
            Gaps.h8,
            Text(
              l10n.projectSetupSummaryTemplateCounts,
              style: context.text.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            Gaps.h4,
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  l10n.projectSetupTemplateTasksCount(template.taskCount),
                  style: context.text.labelSmall,
                ),
                Text(
                  l10n.projectSetupTemplateLabelsCount(template.labelCount),
                  style: context.text.labelSmall,
                ),
                Text(
                  l10n.projectSetupTemplateFieldsCount(
                    template.customFieldCount,
                  ),
                  style: context.text.labelSmall,
                ),
                Text(
                  l10n.projectSetupTemplateStatusesCount(
                    template.customStatusCount,
                  ),
                  style: context.text.labelSmall,
                ),
                Text(
                  l10n.projectSetupTemplateVersionLabel(template.version),
                  style: context.text.labelSmall,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _workflowLabel(
    AppLocalizations l10n,
    ProjectSetupWorkflowPreviewResponse workflow,
  ) => switch (workflow.kind) {
    ProjectSetupWorkflowKind.systemDefault =>
      l10n.projectSetupSummaryWorkflowDefault,
    ProjectSetupWorkflowKind.catalogTemplate =>
      l10n.projectSetupSummaryWorkflowCatalog(
        ProjectSetupWizardL10n.workflowTemplateName(
          l10n,
          workflow.templateName ?? workflow.templateKey ?? '',
        ),
      ),
    ProjectSetupWorkflowKind.explicitStatuses =>
      l10n.projectSetupSummaryWorkflowExplicit(workflow.customStatuses.length),
  };

  static String _scheduleLabel(AppLocalizations l10n, String mode) =>
      switch (mode) {
        'PushSuccessorsOnly' => l10n.projectSetupSchedulePushSuccessors,
        'StrictCascade' => l10n.projectSetupScheduleStrictCascade,
        _ => l10n.projectSetupScheduleManual,
      };
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Sizes.p4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 190,
          child: Text(
            label,
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: context.text.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _WarningRow extends StatelessWidget {
  const _WarningRow({required this.warning});

  final ProjectSetupWarningResponse warning;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.p4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Symbols.info, size: 15, color: colors.tertiary),
          Gaps.w8,
          Expanded(
            child: Text(
              ProjectSetupWizardL10n.warning(
                context.l10n,
                code: warning.code,
                backendMessage: warning.message,
              ),
              style: context.text.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
