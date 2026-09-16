import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_status_category.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/workflow/widgets/project_custom_status_editor_dialog.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/workflow/widgets/project_workflow_templates_dialog.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/custom_workflow_settings_cubit.dart';

/// Widok zakładki "Statusy i Workflow" w ustawieniach projektu.
class ProjectWorkflowTabView extends StatelessWidget {
  const ProjectWorkflowTabView({
    required this.userRole,
    super.key,
  });

  /// Rola użytkownika w projekcie.
  final ProjectRole? userRole;

  Color _parseHex(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isOwnerOrAdmin =
        userRole == ProjectRole.owner || userRole == ProjectRole.admin;

    return BlocBuilder<
      CustomWorkflowSettingsCubit,
      CustomWorkflowSettingsState
    >(
      builder: (context, state) {
        return switch (state) {
          CustomWorkflowSettingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          CustomWorkflowSettingsFailure(:final message) => Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: Sizes.p40,
                  color: colors.error,
                ),
                Gaps.h12,
                Text(
                  message,
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.h16,
                OutlinedButton(
                  onPressed: () =>
                      context.read<CustomWorkflowSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          CustomWorkflowSettingsReady(
            :final statuses,
            :final templates,
            :final isSaving,
            :final error,
          ) =>
            SingleChildScrollView(
              padding: const .all(Sizes.p24),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (error != null) ...[
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
                            Icons.error_outline,
                            color: colors.error,
                            size: Sizes.p20,
                          ),
                          Gaps.w8,
                          Expanded(
                            child: Text(
                              error,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.h16,
                  ],
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 600;
                      final headerTitle = Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            l10n.projectSettingsWorkflowColumnsHeader,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Gaps.h4,
                          Text(
                            'Liczba kolumn: ${statuses.length}',
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );

                      final actionButtons = Wrap(
                        spacing: Sizes.p8,
                        runSpacing: Sizes.p8,
                        children: [
                          Tooltip(
                            message: !isOwnerOrAdmin
                                ? 'Brak uprawnień do edycji workflow (wymagana rola Właściciel lub Administrator)'
                                : isSaving
                                ? 'Trwa zapisywanie zmian...'
                                : 'Wybierz gotowy szablon etapów workflow',
                            child: OutlinedButton.icon(
                              onPressed: !isOwnerOrAdmin || isSaving
                                  ? null
                                  : () => _openTemplates(context, templates),
                              icon: const Icon(
                                Icons.auto_awesome_rounded,
                                size: Sizes.p16,
                              ),
                              label: Text(
                                l10n.projectSettingsWorkflowTemplatesButton,
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(Sizes.p8),
                                ),
                              ),
                            ),
                          ),
                          Tooltip(
                            message: !isOwnerOrAdmin
                                ? 'Brak uprawnień do dodawania statusów (wymagana rola Właściciel lub Administrator)'
                                : isSaving
                                ? 'Trwa zapisywanie zmian...'
                                : 'Utwórz nowy status/kolumnę w projekcie',
                            child: FilledButton.icon(
                              onPressed: !isOwnerOrAdmin || isSaving
                                  ? null
                                  : () => _openCreateStatus(context),
                              icon: const Icon(
                                Icons.add_rounded,
                                size: Sizes.p18,
                              ),
                              label: Text(
                                l10n.projectSettingsWorkflowAddStatus,
                              ),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(Sizes.p8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: .start,
                          children: [
                            headerTitle,
                            if (isOwnerOrAdmin) ...[
                              Gaps.h12,
                              actionButtons,
                            ],
                          ],
                        );
                      }

                      return Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Expanded(child: headerTitle),
                          Gaps.w16,
                          actionButtons,
                        ],
                      );
                    },
                  ),
                  Gaps.h16,
                  if (statuses.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const .all(Sizes.p32),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLowest,
                        borderRadius: .circular(Sizes.p16),
                        border: Border.all(
                          color: colors.outlineVariant.withValues(alpha: .6),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const .all(Sizes.p16),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: .12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.view_column_outlined,
                              size: Sizes.p36,
                              color: colors.primary,
                            ),
                          ),
                          Gaps.h16,
                          Text(
                            l10n.projectSettingsWorkflowEmptyTitle,
                            style: context.text.titleSmall?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Gaps.h6,
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Text(
                              l10n.projectSettingsWorkflowEmptyDesc,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (isOwnerOrAdmin) ...[
                            Gaps.h20,
                            Wrap(
                              spacing: Sizes.p12,
                              runSpacing: Sizes.p12,
                              alignment: WrapAlignment.center,
                              children: [
                                FilledButton.icon(
                                  onPressed: isSaving
                                      ? null
                                      : () =>
                                            _openTemplates(context, templates),
                                  icon: const Icon(
                                    Icons.auto_awesome_rounded,
                                    size: Sizes.p18,
                                  ),
                                  label: Text(
                                    l10n.projectSettingsWorkflowTemplatesButton,
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: isSaving
                                      ? null
                                      : () => _openCreateStatus(context),
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    size: Sizes.p18,
                                  ),
                                  label: Text(
                                    l10n.projectSettingsWorkflowAddStatus,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: statuses.length,
                      onReorderItem: isOwnerOrAdmin
                          ? (oldIndex, newIndex) {
                              final list = [...statuses];
                              final item = list.removeAt(oldIndex);
                              list.insert(newIndex, item);
                              unawaited(
                                context
                                    .read<CustomWorkflowSettingsCubit>()
                                    .reorder(list),
                              );
                            }
                          : (_, _) {},
                      itemBuilder: (ctx, index) {
                        final status = statuses[index];
                        final statusColor = _parseHex(status.colorHex);

                        return Container(
                          key: ValueKey(status.id),
                          margin: const EdgeInsets.only(bottom: Sizes.p8),
                          padding: const .symmetric(
                            horizontal: Sizes.p16,
                            vertical: Sizes.p12,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerLowest,
                            borderRadius: .circular(Sizes.p8),
                            border: Border.all(color: colors.outlineVariant),
                          ),
                          child: Row(
                            children: [
                              if (isOwnerOrAdmin) ...[
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(
                                    Icons.drag_indicator_rounded,
                                    size: Sizes.p20,
                                    color: colors.outline,
                                  ),
                                ),
                                Gaps.w12,
                              ],
                              Container(
                                width: Sizes.p12,
                                height: Sizes.p12,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: .circle,
                                ),
                              ),
                              Gaps.w12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      status.name,
                                      style: context.text.bodyMedium?.copyWith(
                                        fontWeight: .w600,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                    Gaps.h2,
                                    Text(
                                      'Kategoria: ${status.category.name} | Zadania: ${status.taskCount}'
                                      '${status.wipLimit != null ? ' | Limit WIP: ${status.wipLimit}' : ''}',
                                      style: context.text.labelSmall?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isOwnerOrAdmin) ...[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    size: Sizes.p18,
                                    color: colors.onSurfaceVariant,
                                  ),
                                  tooltip:
                                      l10n.projectSettingsWorkflowEditStatus,
                                  onPressed: isSaving
                                      ? null
                                      : () => _openEditStatus(context, status),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline_rounded,
                                    size: Sizes.p18,
                                    color: colors.error,
                                  ),
                                  tooltip:
                                      l10n.projectSettingsWorkflowDeleteStatus,
                                  onPressed: isSaving || statuses.length <= 1
                                      ? null
                                      : () => _confirmDeleteStatus(
                                          context,
                                          status,
                                          statuses,
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
        };
      },
    );
  }

  Future<void> _openCreateStatus(BuildContext context) async {
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            String colorHex,
            TaskStatusCategory category,
            int? wipLimit,
          })
        >(
          context: context,
          builder: (_) => const ProjectCustomStatusEditorDialog(),
        );

    if (result != null) {
      await cubit.create(
        name: result.name,
        colorHex: result.colorHex,
        category: result.category,
        wipLimit: result.wipLimit,
      );
    }
  }

  Future<void> _openEditStatus(
    BuildContext context,
    ProjectCustomStatusResponse status,
  ) async {
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            String colorHex,
            TaskStatusCategory category,
            int? wipLimit,
          })
        >(
          context: context,
          builder: (_) =>
              ProjectCustomStatusEditorDialog(initialStatus: status),
        );

    if (result != null) {
      await cubit.update(
        status: status,
        name: result.name,
        colorHex: result.colorHex,
        category: result.category,
        wipLimit: result.wipLimit,
        isDefault: status.isDefault,
      );
    }
  }

  Future<void> _confirmDeleteStatus(
    BuildContext context,
    ProjectCustomStatusResponse status,
    List<ProjectCustomStatusResponse> allStatuses,
  ) async {
    final l10n = context.l10n;
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final fallbackCandidates = allStatuses
        .where((s) => s.id != status.id)
        .toList();

    var fallbackId = fallbackCandidates.first.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.projectSettingsWorkflowDeleteStatus),
          content: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                'Czy na pewno chcesz usunąć status "${status.name}"? Zadania zostaną przeniesione do wybranego statusu zastępczego.',
              ),
              Gaps.h16,
              Text(
                'Status zastępczy:',
                style: ctx.text.labelMedium?.copyWith(fontWeight: .w700),
              ),
              Gaps.h6,
              DropdownButtonFormField<String>(
                initialValue: fallbackId,
                isExpanded: true,
                items: [
                  for (final fallback in fallbackCandidates)
                    DropdownMenuItem(
                      value: fallback.id,
                      child: Text(fallback.name),
                    ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() => fallbackId = val);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.tasksListCancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: ctx.colors.error,
                foregroundColor: ctx.colors.onError,
              ),
              child: Text(l10n.projectSettingsWorkflowDeleteStatus),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await cubit.delete(
        status,
        fallbackId,
      );
    }
  }

  Future<void> _openTemplates(
    BuildContext context,
    List<WorkflowTemplateSummary> templates,
  ) async {
    final cubit = context.read<CustomWorkflowSettingsCubit>();
    final template = await showDialog<WorkflowTemplateSummary>(
      context: context,
      builder: (_) => ProjectWorkflowTemplatesDialog(templates: templates),
    );

    if (template != null) {
      await cubit.applyTemplate(template.key);
    }
  }
}
