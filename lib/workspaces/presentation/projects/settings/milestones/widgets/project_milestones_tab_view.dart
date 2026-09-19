import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/milestones/widgets/project_milestone_dialog_actions.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/milestone_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Widok zakładki "Kamienie milowe" w ustawieniach projektu.
class ProjectMilestonesTabView extends StatelessWidget {
  const ProjectMilestonesTabView({
    required this.userRole,
    super.key,
  });

  /// Rola użytkownika w projekcie.
  final ProjectRole? userRole;

  Color _statusColor(BuildContext context, MilestoneStatus status) {
    final colors = context.colors;
    return switch (status) {
      MilestoneStatus.active => colors.primary,
      MilestoneStatus.completed => colors.tertiary,
      MilestoneStatus.cancelled => colors.error,
    };
  }

  String _statusLabel(MilestoneStatus status) {
    return switch (status) {
      MilestoneStatus.active => 'Aktywny / W toku',
      MilestoneStatus.completed => 'Zakończony',
      MilestoneStatus.cancelled => 'Anulowany',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isOwnerOrAdmin =
        userRole == ProjectRole.owner || userRole == ProjectRole.admin;

    return BlocBuilder<MilestoneSettingsCubit, MilestoneSettingsState>(
      builder: (context, state) {
        return switch (state) {
          MilestoneSettingsInitial() || MilestoneSettingsLoading() =>
            const Center(child: CircularProgressIndicator()),
          MilestoneSettingsFailure(:final message) => Center(
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
                      context.read<MilestoneSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          MilestoneSettingsReady(
            :final milestones,
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
                            l10n.projectSettingsMilestonesHeader,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Gaps.h4,
                          Text(
                            'Liczba kamieni milowych: ${milestones.length}',
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Tooltip(
                        message: !isOwnerOrAdmin
                            ? 'Brak uprawnień do dodawania kamieni milowych (wymagana rola Właściciel lub Administrator)'
                            : isSaving
                            ? 'Trwa zapisywanie...'
                            : 'Utwórz nowy kamień milowy w projekcie',
                        child: FilledButton.icon(
                          onPressed: !isOwnerOrAdmin || isSaving
                              ? null
                              : () => ProjectMilestoneDialogActions.openCreate(
                                  context,
                                ),
                          icon: const Icon(Icons.add_rounded, size: Sizes.p18),
                          label: Text(l10n.projectSettingsAddMilestone),
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
                  if (milestones.isEmpty)
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
                            Icons.flag_outlined,
                            size: Sizes.p44,
                            color: colors.outline,
                          ),
                          Gaps.h12,
                          Text(
                            l10n.projectSettingsMilestonesEmpty,
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
                                  : () =>
                                        ProjectMilestoneDialogActions.openCreate(
                                          context,
                                        ),
                              icon: const Icon(
                                Icons.add_rounded,
                                size: Sizes.p18,
                              ),
                              label: Text(l10n.projectSettingsAddMilestone),
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
                        itemCount: milestones.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        itemBuilder: (ctx, index) {
                          final milestone = milestones[index];
                          final badgeColor = _statusColor(
                            context,
                            milestone.status,
                          );

                          return Padding(
                            padding: const .symmetric(
                              horizontal: Sizes.p16,
                              vertical: Sizes.p12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  size: Sizes.p20,
                                  color: badgeColor,
                                ),
                                Gaps.w12,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            milestone.name,
                                            style: context.text.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: .w600,
                                                  color: colors.onSurface,
                                                ),
                                          ),
                                          Gaps.w8,
                                          Container(
                                            padding: const .symmetric(
                                              horizontal: Sizes.p8,
                                              vertical: Sizes.p2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: badgeColor.withValues(
                                                alpha: .15,
                                              ),
                                              borderRadius: .circular(Sizes.p6),
                                              border: Border.all(
                                                color: badgeColor.withValues(
                                                  alpha: .4,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              _statusLabel(milestone.status),
                                              style: context.text.labelSmall
                                                  ?.copyWith(
                                                    fontWeight: .w700,
                                                    color: badgeColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Gaps.h4,
                                      Row(
                                        children: [
                                          if (milestone.dueAtUtc != null) ...[
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              size: Sizes.p12,
                                              color: colors.onSurfaceVariant,
                                            ),
                                            Gaps.w4,
                                            Text(
                                              'Termin: ${DateFormat("dd.MM.yyyy").format(milestone.dueAtUtc!)}',
                                              style: context.text.labelSmall
                                                  ?.copyWith(
                                                    color:
                                                        colors.onSurfaceVariant,
                                                  ),
                                            ),
                                            Gaps.w12,
                                          ],
                                          Text(
                                            'Postęp: ${(milestone.progress * 100).toInt()}%',
                                            style: context.text.labelSmall
                                                ?.copyWith(
                                                  color:
                                                      colors.onSurfaceVariant,
                                                  fontWeight: .w600,
                                                ),
                                          ),
                                        ],
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
                                    tooltip: 'Edytuj etap',
                                    onPressed: isSaving
                                        ? null
                                        : () =>
                                              ProjectMilestoneDialogActions.openEdit(
                                                context,
                                                milestone,
                                              ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: Sizes.p18,
                                      color: colors.error,
                                    ),
                                    tooltip: 'Usuń etap',
                                    onPressed: isSaving
                                        ? null
                                        : () =>
                                              ProjectMilestoneDialogActions.confirmDelete(
                                                context,
                                                milestone,
                                              ),
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
}
