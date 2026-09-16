import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/labels/widgets/project_label_editor_dialog.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/task_labels_settings_cubit.dart';

/// Widok zakładki "Etykiety" w ustawieniach projektu.
class ProjectLabelsTabView extends StatelessWidget {
  const ProjectLabelsTabView({
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

    return BlocBuilder<TaskLabelsSettingsCubit, TaskLabelsSettingsState>(
      builder: (context, state) {
        return switch (state) {
          TaskLabelsSettingsInitial() || TaskLabelsSettingsLoading() =>
            const Center(child: CircularProgressIndicator()),
          TaskLabelsSettingsFailure(:final message) => Center(
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
                      context.read<TaskLabelsSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          TaskLabelsSettingsReady(
            :final labels,
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
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            l10n.projectSettingsLabelsHeader,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Gaps.h4,
                          Text(
                            'Liczba etykiet: ${labels.length}',
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Tooltip(
                        message: !isOwnerOrAdmin
                            ? 'Brak uprawnień do dodawania etykiet (wymagana rola Właściciel lub Administrator)'
                            : isSaving
                            ? 'Trwa zapisywanie...'
                            : 'Utwórz nową etykietę w projekcie',
                        child: FilledButton.icon(
                          onPressed: !isOwnerOrAdmin || isSaving
                              ? null
                              : () => _openCreateDialog(context),
                          icon: const Icon(Icons.add_rounded, size: Sizes.p18),
                          label: Text(l10n.projectSettingsAddLabel),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(Sizes.p8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.h16,
                  if (labels.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const .all(Sizes.p32),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLowest,
                        borderRadius: .circular(Sizes.p12),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          Icon(
                            Icons.label_outline_rounded,
                            size: Sizes.p44,
                            color: colors.outline,
                          ),
                          Gaps.h12,
                          Text(
                            l10n.projectSettingsLabelsEmpty,
                            style: context.text.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (isOwnerOrAdmin) ...[
                            Gaps.h16,
                            FilledButton.tonalIcon(
                              onPressed: isSaving
                                  ? null
                                  : () => _openCreateDialog(context),
                              icon: const Icon(
                                Icons.add_rounded,
                                size: Sizes.p18,
                              ),
                              label: Text(l10n.projectSettingsAddLabel),
                            ),
                          ],
                        ],
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLowest,
                        borderRadius: .circular(Sizes.p12),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: labels.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        itemBuilder: (ctx, index) {
                          final label = labels[index];
                          final labelColor = _parseHex(label.color);

                          return Padding(
                            padding: const .symmetric(
                              horizontal: Sizes.p16,
                              vertical: Sizes.p12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const .symmetric(
                                    horizontal: Sizes.p10,
                                    vertical: Sizes.p4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: labelColor.withValues(alpha: .15),
                                    borderRadius: .circular(Sizes.p6),
                                    border: Border.all(
                                      color: labelColor.withValues(alpha: .4),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: .min,
                                    children: [
                                      Container(
                                        width: Sizes.p8,
                                        height: Sizes.p8,
                                        decoration: BoxDecoration(
                                          color: labelColor,
                                          shape: .circle,
                                        ),
                                      ),
                                      Gaps.w6,
                                      Text(
                                        label.name,
                                        style: context.text.labelMedium
                                            ?.copyWith(
                                              fontWeight: .w700,
                                              color: labelColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                if (isOwnerOrAdmin) ...[
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: Sizes.p18,
                                      color: colors.onSurfaceVariant,
                                    ),
                                    tooltip: 'Edytuj etykietę',
                                    onPressed: isSaving
                                        ? null
                                        : () => _openEditDialog(context, label),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: Sizes.p18,
                                      color: colors.error,
                                    ),
                                    tooltip: 'Usuń etykietę',
                                    onPressed: isSaving
                                        ? null
                                        : () => _confirmDelete(context, label),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
        };
      },
    );
  }

  Future<void> _openCreateDialog(BuildContext context) async {
    final cubit = context.read<TaskLabelsSettingsCubit>();
    final result = await showDialog<({String name, String color})>(
      context: context,
      builder: (_) => const ProjectLabelEditorDialog(),
    );

    if (result != null) {
      await cubit.save(
        name: result.name,
        color: result.color,
      );
    }
  }

  Future<void> _openEditDialog(
    BuildContext context,
    TaskLabelResponse label,
  ) async {
    final cubit = context.read<TaskLabelsSettingsCubit>();
    final result = await showDialog<({String name, String color})>(
      context: context,
      builder: (_) => ProjectLabelEditorDialog(initialLabel: label),
    );

    if (result != null) {
      await cubit.save(
        existing: label,
        name: result.name,
        color: result.color,
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TaskLabelResponse label,
  ) async {
    final cubit = context.read<TaskLabelsSettingsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usuń etykietę'),
        content: Text(
          'Czy na pewno chcesz usunąć etykietę "${label.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: ctx.colors.error,
              foregroundColor: ctx.colors.onError,
            ),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.archive(label);
    }
  }
}
