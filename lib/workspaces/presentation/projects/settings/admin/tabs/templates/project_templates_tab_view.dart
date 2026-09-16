import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart';

/// Zakładka szablonów projektów w Panelu Administratora Projektu.
class ProjectTemplatesTabView extends StatelessWidget {
  const ProjectTemplatesTabView({
    required this.project,
    this.canManage = true,
    super.key,
  });

  final ProjectListItem project;
  final bool canManage;

  String _successText(BuildContext context, ProjectTemplateActionType type) =>
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocBuilder<ProjectTemplatesCubit, ProjectTemplatesState>(
      builder: (context, state) {
        if (state is ProjectTemplatesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProjectTemplatesFailure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: colors.error,
                  size: Sizes.p36,
                ),
                Gaps.h12,
                Text(
                  state.message,
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.error,
                  ),
                ),
                Gaps.h16,
                FilledButton.tonal(
                  onPressed: () => context.read<ProjectTemplatesCubit>().load(),
                  child: Text(l10n.workspacesRetry),
                ),
              ],
            ),
          );
        }

        final readyState = state as ProjectTemplatesReady;
        final templates = readyState.templates;
        final isSaving = readyState.isSaving;

        return SingleChildScrollView(
          padding: const .all(Sizes.p24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Nagłówek i przycisk zapisu jako szablon
              Row(
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
                          : () => _openCreateTemplateDialog(context),
                      icon: const Icon(
                        Icons.bookmark_add_rounded,
                        size: Sizes.p18,
                      ),
                      label: Text(
                        l10n.projectSettingsCreateTemplateFromProject,
                      ),
                    ),
                ],
              ),
              Gaps.h20,

              // Komunikaty statusu
              if (readyState.actionSuccess != null) ...[
                Container(
                  padding: const .all(Sizes.p12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: .15),
                    borderRadius: .circular(Sizes.p8),
                    border: Border.all(color: const Color(0xFF10B981)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF10B981),
                        size: Sizes.p20,
                      ),
                      Gaps.w8,
                      Expanded(
                        child: Text(
                          _successText(context, readyState.actionSuccess!),
                          style: context.text.bodySmall?.copyWith(
                            color: const Color(0xFF10B981),
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.h16,
              ],

              if (readyState.error != null) ...[
                Container(
                  padding: const .all(Sizes.p12),
                  decoration: BoxDecoration(
                    color: colors.errorContainer.withValues(alpha: .2),
                    borderRadius: .circular(Sizes.p8),
                    border: Border.all(color: colors.error),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: colors.error,
                        size: Sizes.p20,
                      ),
                      Gaps.w8,
                      Expanded(
                        child: Text(
                          readyState.error!,
                          style: context.text.bodySmall?.copyWith(
                            color: colors.error,
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.h16,
              ],

              // Lista szablonów
              if (templates.isEmpty)
                Container(
                  padding: const .all(Sizes.p32),
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: .circular(Sizes.p12),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: .5),
                    ),
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
                        l10n.projectSettingsTemplatesEmpty,
                        style: context.text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: templates.length,
                  separatorBuilder: (_, _) => Gaps.h12,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return _ProjectTemplateCard(
                      template: template,
                      currentProject: project,
                      isSaving: isSaving,
                      canManage: canManage,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCreateTemplateDialog(BuildContext context) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final l10n = context.l10n;
    final controller = TextEditingController(text: '${project.name} - Szablon');

    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.projectSettingsCreateTemplateDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.projectSettingsTemplateCreateDialogDesc,
              style: ctx.text.bodySmall?.copyWith(
                color: ctx.colors.onSurfaceVariant,
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
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.workspacesCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
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

class _ProjectTemplateCard extends StatelessWidget {
  const _ProjectTemplateCard({
    required this.template,
    required this.currentProject,
    required this.isSaving,
    this.canManage = true,
  });

  final ProjectTemplateResponse template;
  final ProjectListItem currentProject;
  final bool isSaving;
  final bool canManage;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
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

          final headerInfo = Row(
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
                        Container(
                          padding: const .symmetric(
                            horizontal: Sizes.p6,
                            vertical: Sizes.p2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHigh,
                            borderRadius: .circular(Sizes.p4),
                          ),
                          child: Text(
                            'v${template.version}',
                            style: context.text.labelSmall?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
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

          final actions = Row(
            mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: isNarrow
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              // Akcja Podgląd szczegółów (GET /project-templates/{templateId})
              IconButton.outlined(
                tooltip: l10n.projectSettingsTemplateDetailsPreviewButton,
                onPressed: isSaving ? null : () => _openDetailsDialog(context),
                icon: const Icon(Icons.info_outline_rounded, size: Sizes.p18),
              ),
              if (canManage) ...[
                Gaps.w6,
                // Akcja Utwórz projekt z szablonu
                FilledButton.tonalIcon(
                  onPressed: isSaving ? null : () => _openApplyDialog(context),
                  icon: const Icon(Icons.add_task_rounded, size: Sizes.p16),
                  label: Text(l10n.projectSettingsTemplateApplyButton),
                ),
                Gaps.w6,
                // Akcja Odśwież z bieżącego projektu
                IconButton.outlined(
                  tooltip: l10n.projectSettingsTemplateRefreshButton,
                  onPressed: isSaving ? null : () => _confirmRefresh(context),
                  icon: const Icon(Icons.sync_rounded, size: Sizes.p18),
                ),
                Gaps.w6,
                // Akcja Usuń szablon
                IconButton.outlined(
                  tooltip: l10n.projectSettingsTemplateLeaveDeleteTitle,
                  onPressed: isSaving ? null : () => _confirmDelete(context),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: colors.error,
                    size: Sizes.p18,
                  ),
                ),
              ],
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: .start,
              children: [
                headerInfo,
                Gaps.h12,
                actions,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: headerInfo),
              Gaps.w16,
              actions,
            ],
          );
        },
      ),
    );
  }

  Future<void> _openDetailsDialog(BuildContext context) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final l10n = context.l10n;

    unawaited(
      showDialog<void>(
        context: context,
        builder: (ctx) => _ProjectTemplateDetailsDialog(
          templateId: template.id,
          templateName: template.name,
          cubit: cubit,
          l10n: l10n,
        ),
      ),
    );
  }

  Future<void> _openApplyDialog(BuildContext context) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final projectsCubit = context.read<WorkspaceProjectsCubit?>();
    final l10n = context.l10n;
    final controller = TextEditingController(
      text: '${template.name} - Projekt',
    );

    final applied = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.projectSettingsTemplateApplyDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.projectSettingsTemplateApplyDialogDesc,
              style: ctx.text.bodySmall?.copyWith(
                color: ctx.colors.onSurfaceVariant,
              ),
            ),
            Gaps.h16,
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: l10n.projectSettingsTemplateApplyNewProjectName,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.workspacesCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.workspacesCreateButton),
          ),
        ],
      ),
    );

    if (applied == true && controller.text.trim().isNotEmpty) {
      final response = await cubit.applyTemplate(
        templateId: template.id,
        newProjectName: controller.text.trim(),
      );
      if (response != null) {
        unawaited(projectsCubit?.load());
      }
    }
  }

  Future<void> _confirmRefresh(BuildContext context) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.projectSettingsTemplateRefreshButton),
        content: Text(l10n.projectSettingsTemplateRefreshConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.workspacesCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.projectSettingsTemplateRefreshButton),
          ),
        ],
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

  Future<void> _confirmDelete(BuildContext context) async {
    final cubit = context.read<ProjectTemplatesCubit>();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.projectSettingsTemplateLeaveDeleteTitle),
        content: Text(l10n.projectSettingsTemplateDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.workspacesCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: ctx.colors.error,
              foregroundColor: ctx.colors.onError,
            ),
            child: Text(l10n.projectSettingsTemplateLeaveDeleteAction),
          ),
        ],
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

/// Dialog podglądu szczegółów szablonu (GET /api/v1/workspaces/{workspaceId}/project-templates/{templateId}).
class _ProjectTemplateDetailsDialog extends StatefulWidget {
  const _ProjectTemplateDetailsDialog({
    required this.templateId,
    required this.templateName,
    required this.cubit,
    required this.l10n,
  });

  final String templateId;
  final String templateName;
  final ProjectTemplatesCubit cubit;
  final dynamic l10n;

  @override
  State<_ProjectTemplateDetailsDialog> createState() =>
      _ProjectTemplateDetailsDialogState();
}

class _ProjectTemplateDetailsDialogState
    extends State<_ProjectTemplateDetailsDialog> {
  ProjectTemplateDetailsResponse? _details;
  bool _loading = true;

  Color _parseHexColor(String value, Color fallback) {
    final hex = value.replaceFirst('#', '');
    if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(hex)) return fallback;
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    unawaited(_fetchDetails());
  }

  Future<void> _fetchDetails() async {
    final details = await widget.cubit.getTemplateDetails(widget.templateId);
    if (mounted) {
      setState(() {
        _details = details;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final size = MediaQuery.sizeOf(context);
    final contentWidth = (size.width * 0.85).clamp(280.0, 640.0);
    final contentHeight = (size.height * 0.65).clamp(300.0, 480.0);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.dashboard_customize_rounded,
            color: colors.primary,
            size: Sizes.p20,
          ),
          Gaps.w8,
          Expanded(
            child: Text(
              '${l10n.projectSettingsTemplateDetailsTitle}: ${widget.templateName}',
              style: context.text.titleMedium?.copyWith(fontWeight: .w700),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: contentWidth,
        height: contentHeight,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _details == null
            ? Center(
                child: Text(
                  l10n.workspacesErrorTitle,
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.error,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // Statusy workflow
                    Text(
                      l10n.projectSettingsTemplateDetailsWorkflow,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    Wrap(
                      spacing: Sizes.p8,
                      runSpacing: Sizes.p6,
                      children: _details!.workflow.map((w) {
                        return Chip(
                          label: Text(w.name),
                          backgroundColor: colors.surfaceContainerHighest,
                        );
                      }).toList(),
                    ),
                    Gaps.h16,

                    // Własne kolumny Kanbanu
                    if (_details!.customStatuses?.isNotEmpty ?? false) ...[
                      Text(
                        l10n.projectSettingsWorkflowColumnsHeader,
                        style: context.text.titleSmall?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      Gaps.h8,
                      Wrap(
                        spacing: Sizes.p8,
                        runSpacing: Sizes.p6,
                        children: _details!.customStatuses!.map((status) {
                          return Chip(
                            avatar: CircleAvatar(
                              radius: Sizes.p8,
                              backgroundColor: _parseHexColor(
                                status.color,
                                colors.primary,
                              ),
                            ),
                            label: Text(status.name),
                          );
                        }).toList(),
                      ),
                      Gaps.h16,
                    ],

                    // Pola customowe
                    Text(
                      l10n.projectSettingsTemplateDetailsCustomFields,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    if (_details!.customFields.isEmpty)
                      Text(
                        l10n.projectSettingsTemplateDetailsNoFields,
                        style: context.text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      )
                    else
                      Wrap(
                        spacing: Sizes.p8,
                        runSpacing: Sizes.p6,
                        children: _details!.customFields.map((f) {
                          return Chip(
                            avatar: const Icon(
                              Icons.tune_rounded,
                              size: Sizes.p16,
                            ),
                            label: Text('${f.name} (${f.type})'),
                          );
                        }).toList(),
                      ),
                    Gaps.h16,

                    // Etykiety
                    Text(
                      l10n.projectSettingsTemplateDetailsLabels,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    if (_details!.labels.isEmpty)
                      Text(
                        l10n.projectSettingsTemplateDetailsNoLabels,
                        style: context.text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      )
                    else
                      Wrap(
                        spacing: Sizes.p8,
                        runSpacing: Sizes.p6,
                        children: _details!.labels.map((lbl) {
                          return Chip(
                            avatar: const Icon(
                              Icons.label_outline_rounded,
                              size: Sizes.p16,
                            ),
                            label: Text(lbl.name),
                          );
                        }).toList(),
                      ),
                    Gaps.h16,

                    // Zadania startowe
                    Text(
                      l10n.projectSettingsTemplateDetailsTasks(
                        _details!.tasks.length,
                      ),
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h8,
                    if (_details!.tasks.isEmpty)
                      Text(
                        l10n.projectSettingsTemplateDetailsNoTasks,
                        style: context.text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _details!.tasks.length,
                        separatorBuilder: (_, _) => Gaps.h6,
                        itemBuilder: (context, idx) {
                          final task = _details!.tasks[idx];
                          return Container(
                            padding: const .symmetric(
                              horizontal: Sizes.p12,
                              vertical: Sizes.p8,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerLowest,
                              borderRadius: .circular(Sizes.p8),
                              border: Border.all(
                                color: colors.outlineVariant.withValues(
                                  alpha: .4,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_box_outline_blank_rounded,
                                  size: Sizes.p16,
                                  color: colors.primary,
                                ),
                                Gaps.w8,
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: context.text.bodySmall?.copyWith(
                                      fontWeight: .w600,
                                    ),
                                  ),
                                ),
                                if (task.checklist.isNotEmpty) ...[
                                  Gaps.w8,
                                  Text(
                                    '✓ ${task.checklist.length}',
                                    style: context.text.labelSmall?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.workspacesCancelButton),
        ),
      ],
    );
  }
}
