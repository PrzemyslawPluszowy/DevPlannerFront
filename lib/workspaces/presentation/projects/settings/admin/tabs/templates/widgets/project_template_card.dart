import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/widgets/project_template_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Karta pojedynczego szablonu wraz z akcjami dozwolonymi dla roli użytkownika.
class ProjectTemplateCard extends StatelessWidget {
  const ProjectTemplateCard({
    required this.template,
    required this.currentProject,
    required this.isSaving,
    required this.canManage,
    super.key,
  });

  final ProjectTemplateResponse template;
  final ProjectListItem currentProject;
  final bool isSaving;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final formattedDate = DateFormat.yMMMd().add_Hm().format(
      template.updatedAtUtc.toLocal(),
    );

    return Container(
      padding: const .all(Sizes.p16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p12),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .6)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 580;
          final header = _TemplateCardHeader(
            template: template,
            formattedDate: formattedDate,
          );
          final actions = _TemplateCardActions(
            template: template,
            currentProject: currentProject,
            isSaving: isSaving,
            canManage: canManage,
          );

          return isNarrow
              ? Column(
                  crossAxisAlignment: .start,
                  children: [header, Gaps.h12, actions],
                )
              : Row(
                  children: [
                    Expanded(child: header),
                    Gaps.w16,
                    actions,
                  ],
                );
        },
      ),
    );
  }
}

class _TemplateCardHeader extends StatelessWidget {
  const _TemplateCardHeader({
    required this.template,
    required this.formattedDate,
  });

  final ProjectTemplateResponse template;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Row(
      children: [
        Container(
          padding: const .all(Sizes.p10),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: .12),
            borderRadius: .circular(Sizes.p10),
          ),
          child: Icon(
            Icons.dashboard_customize_rounded,
            color: colors.primary,
            size: Sizes.p24,
          ),
        ),
        Gaps.w16,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      template.name,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: .w700,
                        color: colors.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gaps.w8,
                  _TemplateVersionBadge(version: template.version),
                ],
              ),
              Gaps.h4,
              Text(
                l10n.projectSettingsTemplateUpdatedLabel(formattedDate),
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplateVersionBadge extends StatelessWidget {
  const _TemplateVersionBadge({required this.version});

  final int version;

  @override
  Widget build(BuildContext context) => Container(
    padding: const .symmetric(horizontal: Sizes.p6, vertical: Sizes.p2),
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerHigh,
      borderRadius: .circular(Sizes.p4),
    ),
    child: Text(
      'v$version',
      style: context.text.labelSmall?.copyWith(
        fontWeight: .w700,
        color: context.colors.onSurfaceVariant,
      ),
    ),
  );
}

class _TemplateCardActions extends StatelessWidget {
  const _TemplateCardActions({
    required this.template,
    required this.currentProject,
    required this.isSaving,
    required this.canManage,
  });

  final ProjectTemplateResponse template;
  final ProjectListItem currentProject;
  final bool isSaving;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          tooltip: l10n.projectSettingsTemplateDetailsPreviewButton,
          onPressed: isSaving
              ? null
              : () => _TemplateDialogActions.openDetails(context, template),
          icon: const Icon(Icons.info_outline_rounded, size: Sizes.p18),
        ),
        if (canManage) ...[
          Gaps.w6,
          FilledButton.tonalIcon(
            onPressed: isSaving
                ? null
                : () => _TemplateDialogActions.openApply(context, template),
            icon: const Icon(Icons.add_task_rounded, size: Sizes.p16),
            label: Text(l10n.projectSettingsTemplateApplyButton),
          ),
          Gaps.w6,
          IconButton.outlined(
            tooltip: l10n.projectSettingsTemplateRefreshButton,
            onPressed: isSaving
                ? null
                : () =>
                      _TemplateDialogActions.confirmRefresh(context, template),
            icon: const Icon(Icons.sync_rounded, size: Sizes.p18),
          ),
          Gaps.w6,
          IconButton.outlined(
            tooltip: l10n.projectSettingsTemplateLeaveDeleteTitle,
            onPressed: isSaving
                ? null
                : () => _TemplateDialogActions.confirmDelete(context, template),
            icon: Icon(
              Icons.delete_outline_rounded,
              color: context.colors.error,
              size: Sizes.p18,
            ),
          ),
        ],
      ],
    );
  }
}

class _TemplateDialogActions {
  static Future<void> openDetails(
    BuildContext context,
    ProjectTemplateResponse template,
  ) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => ProjectTemplateDetailsDialog(
          templateId: template.id,
          templateName: template.name,
          cubit: cubit,
        ),
      ),
    );
  }

  static Future<void> openApply(
    BuildContext context,
    ProjectTemplateResponse template,
  ) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final projectsCubit = context.read<WorkspaceProjectsCubit?>();
    final l10n = context.l10n;
    final controller = TextEditingController(
      text: '${template.name} - Projekt',
    );
    final applied = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.projectSettingsTemplateApplyDialogTitle),
        content: _TemplateNameForm(
          description: l10n.projectSettingsTemplateApplyDialogDesc,
          label: l10n.projectSettingsTemplateApplyNewProjectName,
          controller: controller,
        ),
        actions: _TemplateDialogButtons(
          confirmLabel: l10n.workspacesCreateButton,
        ).build(dialogContext),
      ),
    );
    if (applied == true && controller.text.trim().isNotEmpty) {
      final response = await cubit.applyTemplate(
        templateId: template.id,
        newProjectName: controller.text.trim(),
      );
      if (response != null) unawaited(projectsCubit?.load());
    }
  }

  static Future<void> confirmRefresh(
    BuildContext context,
    ProjectTemplateResponse template,
  ) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.projectSettingsTemplateRefreshButton),
        content: Text(l10n.projectSettingsTemplateRefreshConfirm),
        actions: _TemplateDialogButtons(
          confirmLabel: l10n.projectSettingsTemplateRefreshButton,
        ).build(dialogContext),
      ),
    );
    if (confirmed == true) {
      await cubit.refreshTemplate(
        templateId: template.id,
        name: template.name,
        expectedVersion: template.version,
      );
    }
  }

  static Future<void> confirmDelete(
    BuildContext context,
    ProjectTemplateResponse template,
  ) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.projectSettingsTemplateLeaveDeleteTitle),
        content: Text(l10n.projectSettingsTemplateDeleteConfirm),
        actions: _TemplateDialogButtons(
          confirmLabel: l10n.projectSettingsTemplateLeaveDeleteAction,
          destructive: true,
        ).build(dialogContext),
      ),
    );
    if (confirmed == true) {
      await cubit.deleteTemplate(
        templateId: template.id,
        expectedVersion: template.version,
      );
    }
  }
}

class _TemplateNameForm extends StatelessWidget {
  const _TemplateNameForm({
    required this.description,
    required this.label,
    required this.controller,
  });

  final String description;
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: .start,
    children: [
      Text(
        description,
        style: context.text.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      Gaps.h16,
      TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
    ],
  );
}

class _TemplateDialogButtons {
  const _TemplateDialogButtons({
    required this.confirmLabel,
    this.destructive = false,
  });

  final String confirmLabel;
  final bool destructive;

  List<Widget> build(BuildContext context) {
    final l10n = context.l10n;
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(l10n.workspacesCancelButton),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: destructive
            ? FilledButton.styleFrom(
                backgroundColor: context.colors.error,
                foregroundColor: context.colors.onError,
              )
            : null,
        child: Text(confirmLabel),
      ),
    ];
  }
}
