import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_draft.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_atoms.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_header.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_mode_toggle.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/project_preview_models.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/template_contents_summary.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/template_kanban_preview.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/preview/template_list_preview.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_recipe_rule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Panel podglądu projektu: pokazuje, co naprawdę powstanie z bieżących ustawień.
///
/// Panel nie wysyła żądań — czyta stan Cubita i draft. Pobranie podglądu
/// szablonu należy do kroku startu, a plan podsumowania do serwera. Dzięki temu
/// zmiana kroku ani przełączenie widoku nie kosztuje żądania i nie miga.
class ProjectPreviewPanel extends StatefulWidget {
  /// Tworzy panel podglądu.
  const ProjectPreviewPanel({required this.state, super.key});

  /// Klucz panelu używany w testach.
  static const Key panelKey = ValueKey('project-preview-panel');

  /// Klucz wskaźnika odświeżania pokazywanego bez czyszczenia treści.
  static const Key refreshIndicatorKey = ValueKey(
    'project-preview-refresh-indicator',
  );

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  State<ProjectPreviewPanel> createState() => _ProjectPreviewPanelState();
}

class _ProjectPreviewPanelState extends State<ProjectPreviewPanel> {
  ProjectSetupTaskViewKind? _mode;
  bool _userSelectedMode = false;

  ProjectSetupTaskViewKind get _effectiveMode =>
      _mode ?? widget.state.draft.defaultView;

  /// Widok podglądu, który ma co pokazać.
  ///
  /// Domyślny widok projektu nadal decyduje, ale gdy nie ma w nim ani jednego
  /// wiersza (np. plan bez zadań), podgląd pokazuje tablicę z kolumnami zamiast
  /// pustej powierzchni. Wybór użytkownika jest zawsze ważniejszy.
  ProjectSetupTaskViewKind _resolvedMode(ProjectPreviewSnapshot snapshot) {
    if (_userSelectedMode) return _effectiveMode;
    if (snapshot.hasTasks || !snapshot.hasColumns) return _effectiveMode;
    return ProjectSetupTaskViewKind.board;
  }

  @override
  void didUpdateWidget(ProjectPreviewPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Domyślny widok ustawiony w kroku „Sposób pracy” przestawia podgląd tylko
    // wtedy, gdy użytkownik nie przełączył go sam — jego wybór jest ważniejszy
    // od wartości z formularza.
    if (!_userSelectedMode &&
        oldWidget.state.draft.defaultView != widget.state.draft.defaultView) {
      _mode = widget.state.draft.defaultView;
    }
  }

  void _selectMode(ProjectSetupTaskViewKind mode) {
    setState(() {
      _mode = mode;
      _userSelectedMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final draft = state.draft;
    final templateId = draft.templateId;
    final template = templateId == null
        ? null
        : state.templatePreviews[templateId];
    final isTemplateLoading =
        templateId != null && state.templateLoadingId == templateId;
    final snapshot = buildProjectPreviewSnapshot(
      l10n: context.l10n,
      draft: draft,
      template: template,
      plan: state.step == ProjectSetupStep.summary ? state.plan : null,
    );
    // Widok liczymy raz: przełącznik i renderer muszą pokazywać to samo,
    // inaczej zaznaczona opcja nie odpowiada treści pod kontrolką.
    final mode = _resolvedMode(snapshot);

    return Column(
      key: ProjectPreviewPanel.panelKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isTemplateLoading && template != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: LinearProgressIndicator(
              key: ProjectPreviewPanel.refreshIndicatorKey,
              minHeight: 2,
              semanticsLabel: context.l10n.projectSetupPreviewRefreshing,
            ),
          ),
        ProjectPreviewHeader(
          title: _title(context, state, template),
          description: _description(state, template),
          iconKey: draft.iconKey,
          colorHex: draft.colorHex.isEmpty
              ? template?.primaryColor
              : draft.colorHex,
          badges: _badges(context, state, snapshot),
        ),
        Gaps.h16,
        if (draft.usesTemplate && template == null)
          if (isTemplateLoading)
            const _PreviewSkeleton()
          else
            _TemplatePreviewFailure(
              message:
                  state.templateError?.message ??
                  context.l10n.projectSetupTemplatePreviewFailed,
              onRetry: templateId == null
                  ? null
                  : () => context
                        .read<ProjectSetupWizardCubit>()
                        .ensureTemplatePreview(templateId),
            )
        else ...[
          if (snapshot.hasColumns || snapshot.hasTasks) ...[
            ProjectPreviewModeToggle(mode: mode, onChanged: _selectMode),
            Gaps.h12,
            if (mode == ProjectSetupTaskViewKind.board)
              TemplateKanbanPreview(
                snapshot: snapshot,
                density: draft.boardDensity,
              )
            else
              TemplateListPreview(snapshot: snapshot),
          ] else
            ProjectPreviewNote(
              title: context.l10n.projectSetupPreviewEmptyBoardTitle,
              body: context.l10n.projectSetupPreviewEmptyBoardBody,
              icon: Symbols.space_dashboard,
            ),
          Gaps.h12,
          _StepFacts(state: state, snapshot: snapshot),
          if (snapshot.labels.isNotEmpty || snapshot.fields.isNotEmpty) ...[
            Gaps.h16,
            TemplateContentsSummary(
              snapshot: snapshot,
              version: template?.version,
            ),
          ],
        ],
      ],
    );
  }

  String _title(
    BuildContext context,
    ProjectSetupWizardState state,
    ProjectTemplateDetailsResponse? template,
  ) {
    final name = state.draft.name.trim();
    if (name.isNotEmpty) return name;
    if (template != null) return template.name;
    return context.l10n.projectSetupPreviewUntitledProject;
  }

  String? _description(
    ProjectSetupWizardState state,
    ProjectTemplateDetailsResponse? template,
  ) {
    final description = state.draft.description.trim();
    if (description.isNotEmpty) return description;
    final fallback = template?.description?.trim();
    return fallback == null || fallback.isEmpty ? null : fallback;
  }

  List<Widget> _badges(
    BuildContext context,
    ProjectSetupWizardState state,
    ProjectPreviewSnapshot snapshot,
  ) {
    final l10n = context.l10n;
    final draft = state.draft;
    final visibility = state.plan?.project.visibility ?? draft.visibility;
    final templateName = draft.templateName;
    return [
      ProjectPreviewBadge(
        label: ProjectSetupWizardL10n.visibility(l10n, visibility),
        icon: visibility == ProjectVisibility.private
            ? Symbols.lock
            : Symbols.public,
        tone: ProjectPreviewTone.accent,
      ),
      ProjectPreviewBadge(
        label: ProjectSetupWizardL10n.taskView(l10n, draft.defaultView),
        icon: draft.defaultView == ProjectSetupTaskViewKind.board
            ? Symbols.view_kanban
            : Symbols.view_list,
      ),
      if (draft.usesTemplate && templateName != null && templateName.isNotEmpty)
        ProjectPreviewBadge(
          label: l10n.projectSetupPreviewTemplateBadge(templateName),
          icon: Symbols.auto_awesome_motion,
          tone: ProjectPreviewTone.accent,
        ),
      if (snapshot.taskTotal > 0)
        ProjectPreviewBadge(
          label: l10n.projectSetupTemplateTasksCount(snapshot.taskTotal),
          icon: Symbols.task_alt,
        ),
    ];
  }
}

/// Fakty zależne od kroku: skąd pochodzą kolumny i co ustawiono dla widoków.
class _StepFacts extends StatelessWidget {
  const _StepFacts({required this.state, required this.snapshot});

  final ProjectSetupWizardState state;
  final ProjectPreviewSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = state.draft;
    final warnings = state.plan?.warnings.length ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        switch (snapshot.columnSource) {
          ProjectPreviewColumnSource.explicitStatuses => ProjectPreviewNote(
            title: l10n.projectSetupPreviewColumnsExplicit,
            body: l10n.projectSetupPreviewColumnsExplicitBody,
            icon: Symbols.edit_note,
          ),
          ProjectPreviewColumnSource.plan => ProjectPreviewNote(
            title: l10n.projectSetupPreviewColumnsPlan,
            body: l10n.projectSetupPreviewColumnsPlanBody(
              snapshot.systemStatusCount,
            ),
            icon: Symbols.verified,
            tone: ProjectPreviewTone.accent,
          ),
          ProjectPreviewColumnSource.template when snapshot.planApproved =>
            ProjectPreviewNote(
              title: l10n.projectSetupPreviewColumnsApproved,
              body: l10n.projectSetupPreviewColumnsApprovedBody,
              icon: Symbols.verified,
              tone: ProjectPreviewTone.accent,
            ),
          ProjectPreviewColumnSource.template => ProjectPreviewNote(
            title: l10n.projectSetupPreviewColumnsFromTemplate,
            body: l10n.projectSetupPreviewColumnsFromTemplateBody,
            icon: Symbols.auto_awesome_motion,
            tone: ProjectPreviewTone.accent,
          ),
          ProjectPreviewColumnSource.systemDefaults => ProjectPreviewNote(
            title: l10n.projectSetupPreviewColumnsSystem,
            body: l10n.projectSetupPreviewColumnsSystemBody(
              snapshot.systemStatusCount,
            ),
            icon: Symbols.checklist,
          ),
          ProjectPreviewColumnSource.catalogTemplate => ProjectPreviewNote(
            title: l10n.projectSetupWorkflowCatalogLegend,
            body: l10n.projectSetupPreviewColumnsCatalogBody(
              snapshot.catalogTemplateName ?? '',
            ),
            icon: Symbols.category,
          ),
          ProjectPreviewColumnSource.none => const SizedBox.shrink(),
        },
        if (state.step == ProjectSetupStep.access) ...[
          Gaps.h12,
          _AccessFacts(state: state),
        ],
        if (state.step == ProjectSetupStep.workingStyle) ...[
          Gaps.h12,
          _WorkingStyleFacts(state: state),
        ],
        if (state.step == ProjectSetupStep.starterFeatures) ...[
          Gaps.h12,
          _RecipeFacts(keys: draft.recipeKeys),
        ],
        if (state.step == ProjectSetupStep.summary && warnings > 0) ...[
          Gaps.h12,
          ProjectPreviewNote(
            title: l10n.projectSetupSummaryWarningsLegend,
            body: l10n.projectSetupPreviewWarningsBody(warnings),
            icon: Symbols.info,
            tone: ProjectPreviewTone.warning,
          ),
        ],
      ],
    );
  }
}

class _AccessFacts extends StatelessWidget {
  const _AccessFacts({required this.state});

  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = state.draft;
    final isPrivate = draft.visibility == ProjectVisibility.private;
    final body = switch ((isPrivate, draft.members.isEmpty)) {
      (false, _) => l10n.projectSetupPreviewMembersShared,
      (true, true) => l10n.projectSetupPreviewMembersPrivateNone,
      (true, false) => l10n.projectSetupPreviewMembersPrivate(
        draft.members.length,
      ),
    };
    return ProjectPreviewNote(
      title: l10n.projectSetupPreviewMembersTitle,
      body: body,
      icon: isPrivate ? Symbols.lock : Symbols.people,
      tone: isPrivate ? ProjectPreviewTone.accent : ProjectPreviewTone.neutral,
    );
  }
}

class _WorkingStyleFacts extends StatelessWidget {
  const _WorkingStyleFacts({required this.state});

  final ProjectSetupWizardState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final draft = state.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupPreviewListLegend(
          icon: Symbols.tune,
          label: l10n.projectSetupPreviewBoardSettingsTitle,
        ),
        Gaps.h6,
        Wrap(
          spacing: Sizes.p6,
          runSpacing: Sizes.p6,
          children: [
            ProjectPreviewBadge(
              label: ProjectSetupWizardL10n.cardDensity(
                l10n,
                draft.boardDensity,
              ),
              icon: Symbols.density_medium,
            ),
            ProjectPreviewBadge(
              label: ProjectSetupWizardL10n.swimlaneMode(
                l10n,
                draft.boardSwimlaneMode,
              ),
              icon: Symbols.view_stream,
            ),
            ProjectPreviewBadge(
              label: l10n.projectSetupPreviewVisibleFields(
                draft.boardVisibleFields.length,
              ),
              icon: Symbols.visibility,
            ),
          ],
        ),
        Gaps.h8,
        ProjectSetupPreviewListLegend(
          icon: Symbols.view_list,
          label: l10n.projectSetupPreviewListSettingsTitle,
        ),
        Gaps.h6,
        Wrap(
          spacing: Sizes.p6,
          runSpacing: Sizes.p6,
          children: [
            ProjectPreviewBadge(
              label: ProjectSetupWizardL10n.listSortField(
                l10n,
                draft.listSortField,
              ),
              icon: Symbols.sort,
            ),
            ProjectPreviewBadge(
              label: ProjectSetupWizardL10n.listSortDirection(
                l10n,
                draft.listSortDirection,
              ),
              icon: Symbols.swap_vert,
            ),
            ProjectPreviewBadge(
              label: ProjectSetupWizardL10n.listGroupBy(
                l10n,
                draft.listGroupBy,
              ),
              icon: Symbols.account_tree,
            ),
          ],
        ),
      ],
    );
  }
}

class _RecipeFacts extends StatelessWidget {
  const _RecipeFacts({required this.keys});

  final Set<String> keys;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (keys.isEmpty) {
      return ProjectPreviewNote(
        title: l10n.projectSetupPreviewRecipesTitle,
        body: l10n.projectSetupPreviewRecipesNone,
        icon: Symbols.bolt,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupPreviewListLegend(
          icon: Symbols.bolt,
          label: l10n.projectSetupPreviewRecipesTitle,
        ),
        Gaps.h6,
        for (final key in keys)
          Padding(
            padding: const EdgeInsets.only(bottom: Sizes.p8),
            child: Container(
              padding: const EdgeInsets.all(Sizes.p10),
              decoration: BoxDecoration(
                color: context.surfaceRoles.raisedBackground,
                borderRadius: const BorderRadius.all(
                  Radius.circular(Sizes.p10),
                ),
                border: Border.all(color: context.surfaceRoles.raisedBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ProjectSetupWizardL10n.recipeName(l10n, key),
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.h6,
                  ProjectSetupRecipeRule(
                    trigger: ProjectSetupWizardL10n.recipeTrigger(l10n, key),
                    action: ProjectSetupWizardL10n.recipeAction(l10n, key),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _PreviewSkeleton extends StatelessWidget {
  const _PreviewSkeleton();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        context.l10n.projectSetupPreviewLoading,
        style: context.text.bodySmall,
      ),
      Gaps.h8,
      const Row(
        children: [
          Expanded(child: AppShimmerBox(height: 132)),
          Gaps.w8,
          Expanded(child: AppShimmerBox(height: 132)),
        ],
      ),
    ],
  );
}

class _TemplatePreviewFailure extends StatelessWidget {
  const _TemplatePreviewFailure({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ProjectPreviewNote(
      title: message,
      body: l10n.projectSetupPreviewRetryHint,
      icon: Symbols.cloud_off,
      tone: ProjectPreviewTone.error,
      action: onRetry == null
          ? null
          : FilledButton.tonal(
              onPressed: onRetry,
              child: Text(l10n.projectSetupRetryButton),
            ),
    );
  }
}
