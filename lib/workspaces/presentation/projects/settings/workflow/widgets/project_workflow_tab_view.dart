import 'dart:async';

import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/workflow/widgets/project_workflow_dialog_actions.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/workflow/widgets/project_workflow_header.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/custom_workflow_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  ProjectWorkflowHeader(
                    statusesCount: statuses.length,
                    canManage: isOwnerOrAdmin,
                    isSaving: isSaving,
                    onOpenTemplates: () =>
                        ProjectWorkflowDialogActions.openTemplates(
                          context,
                          templates,
                        ),
                    onCreateStatus: () =>
                        ProjectWorkflowDialogActions.openCreateStatus(context),
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
                                            ProjectWorkflowDialogActions.openTemplates(
                                              context,
                                              templates,
                                            ),
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
                                      : () =>
                                            ProjectWorkflowDialogActions.openCreateStatus(
                                              context,
                                            ),
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
                                      : () =>
                                            ProjectWorkflowDialogActions.openEditStatus(
                                              context,
                                              status,
                                            ),
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
                                      : () =>
                                            ProjectWorkflowDialogActions.confirmDeleteStatus(
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
}
