import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/widgets/project_template_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Zakładka szablonów projektów w Panelu Administratora Projektu.
class ProjectTemplatesTabView extends StatelessWidget {
  const ProjectTemplatesTabView({
    required this.project,
    this.canManage = true,
    super.key,
  });

  final ProjectListItem project;
  final bool canManage;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProjectTemplatesCubit, ProjectTemplatesState>(
        builder: (context, state) => switch (state) {
          ProjectTemplatesLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ProjectTemplatesFailure(:final message) => _ProjectTemplatesFailure(
            message: message,
          ),
          final ProjectTemplatesReady ready => _ProjectTemplatesContent(
            project: project,
            canManage: canManage,
            state: ready,
          ),
        },
      );
}

class _ProjectTemplatesFailure extends StatelessWidget {
  const _ProjectTemplatesFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: .min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: colors.error,
            size: Sizes.p36,
          ),
          Gaps.h12,
          Text(
            message,
            style: context.text.bodyMedium?.copyWith(color: colors.error),
          ),
          Gaps.h16,
          FilledButton.tonal(
            onPressed: () => context.read<ProjectTemplatesCubit>().load(),
            child: Text(context.l10n.workspacesRetry),
          ),
        ],
      ),
    );
  }
}

class _ProjectTemplatesContent extends StatelessWidget {
  const _ProjectTemplatesContent({
    required this.project,
    required this.canManage,
    required this.state,
  });

  final ProjectListItem project;
  final bool canManage;
  final ProjectTemplatesReady state;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const .all(Sizes.p24),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        _TemplatesHeader(
          project: project,
          canManage: canManage,
          isSaving: state.isSaving,
        ),
        Gaps.h20,
        _TemplatesFeedback(state: state),
        if (state.actionSuccess != null || state.error != null) Gaps.h16,
        if (state.templates.isEmpty)
          const _TemplatesEmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.templates.length,
            separatorBuilder: (_, _) => Gaps.h12,
            itemBuilder: (context, index) => ProjectTemplateCard(
              template: state.templates[index],
              currentProject: project,
              isSaving: state.isSaving,
              canManage: canManage,
            ),
          ),
      ],
    ),
  );
}

class _TemplatesHeader extends StatelessWidget {
  const _TemplatesHeader({
    required this.project,
    required this.canManage,
    required this.isSaving,
  });

  final ProjectListItem project;
  final bool canManage;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                l10n.projectSettingsTemplatesHeader,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: .w700,
                  color: colors.onSurface,
                ),
              ),
              Gaps.h4,
              Text(
                l10n.projectSettingsTemplateDesc,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (canManage)
          FilledButton.icon(
            onPressed: isSaving
                ? null
                : () => _CreateTemplateDialog.open(context, project),
            icon: const Icon(Icons.bookmark_add_rounded, size: Sizes.p18),
            label: Text(l10n.projectSettingsCreateTemplateFromProject),
          ),
      ],
    );
  }
}

class _TemplatesFeedback extends StatelessWidget {
  const _TemplatesFeedback({required this.state});

  final ProjectTemplatesReady state;

  @override
  Widget build(BuildContext context) {
    if (state.actionSuccess != null) {
      return _TemplateFeedbackBanner(
        text: _TemplateActionText.forType(context, state.actionSuccess!),
        color: const Color(0xFF10B981),
        icon: Icons.check_circle_outline_rounded,
      );
    }
    if (state.error != null) {
      return _TemplateFeedbackBanner(
        text: state.error!,
        color: context.colors.error,
        icon: Icons.error_outline_rounded,
      );
    }
    return const SizedBox.shrink();
  }
}

class _TemplateFeedbackBanner extends StatelessWidget {
  const _TemplateFeedbackBanner({
    required this.text,
    required this.color,
    required this.icon,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const .all(Sizes.p12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .15),
      borderRadius: .circular(Sizes.p8),
      border: Border.all(color: color),
    ),
    child: Row(
      children: [
        Icon(icon, color: color, size: Sizes.p20),
        Gaps.w8,
        Expanded(
          child: Text(
            text,
            style: context.text.bodySmall?.copyWith(
              color: color,
              fontWeight: .w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _TemplatesEmptyState extends StatelessWidget {
  const _TemplatesEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const .all(Sizes.p32),
      alignment: .center,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p12),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .5)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.dashboard_customize_outlined,
            size: Sizes.p40,
            color: colors.onSurfaceVariant,
          ),
          Gaps.h12,
          Text(
            context.l10n.projectSettingsTemplatesEmpty,
            style: context.text.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateTemplateDialog {
  static Future<void> open(
    BuildContext context,
    ProjectListItem project,
  ) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final l10n = context.l10n;
    final controller = TextEditingController(text: '${project.name} - Szablon');
    final created = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.projectSettingsCreateTemplateDialogTitle),
        content: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.projectSettingsTemplateCreateDialogDesc,
              style: dialogContext.text.bodySmall?.copyWith(
                color: dialogContext.colors.onSurfaceVariant,
              ),
            ),
            Gaps.h16,
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.projectSettingsTemplateNameLabel,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.workspacesCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.workspacesSaveButton),
          ),
        ],
      ),
    );
    if (created == true && controller.text.trim().isNotEmpty) {
      await cubit.createTemplateFromCurrentProject(controller.text.trim());
    }
  }
}

class _TemplateActionText {
  static String forType(BuildContext context, ProjectTemplateActionType type) =>
      switch (type) {
        ProjectTemplateActionType.created =>
          context.l10n.projectSettingsTemplateCreatedSuccess,
        ProjectTemplateActionType.refreshed =>
          context.l10n.projectSettingsTemplateRefreshedSuccess,
        ProjectTemplateActionType.deleted =>
          context.l10n.projectSettingsTemplateDeletedSuccess,
        ProjectTemplateActionType.applied =>
          context.l10n.projectSettingsTemplateApplySuccess,
      };
}
