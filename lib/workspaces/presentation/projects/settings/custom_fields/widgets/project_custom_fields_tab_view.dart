import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_type_visual.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/project_custom_field_dialog_actions.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/project_custom_fields_empty_state.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/project_custom_fields_failure_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/task_custom_fields_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widok zakładki "Pola niestandardowe" w ustawieniach projektu.
class ProjectCustomFieldsTabView extends StatelessWidget {
  const ProjectCustomFieldsTabView({
    required this.userRole,
    super.key,
  });

  /// Rola użytkownika w projekcie.
  final ProjectRole? userRole;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isOwnerOrAdmin =
        userRole == ProjectRole.owner || userRole == ProjectRole.admin;

    return BlocBuilder<
      TaskCustomFieldsSettingsCubit,
      TaskCustomFieldsSettingsState
    >(
      builder: (context, state) {
        return switch (state) {
          TaskCustomFieldsSettingsInitial() ||
          TaskCustomFieldsSettingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          TaskCustomFieldsSettingsFailure(:final message) =>
            ProjectCustomFieldsFailureState(
              message: message,
              onRetry: () =>
                  context.read<TaskCustomFieldsSettingsCubit>().load(),
            ),
          TaskCustomFieldsSettingsReady(
            :final fields,
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
                            l10n.projectSettingsCustomFieldsHeader,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Gaps.h4,
                          Text(
                            'Liczba zdefiniowanych pól: ${fields.length}',
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Tooltip(
                        message: !isOwnerOrAdmin
                            ? 'Brak uprawnień do dodawania pól własnych (wymagana rola Właściciel lub Administrator)'
                            : isSaving
                            ? 'Trwa zapisywanie...'
                            : 'Utwórz nowe pole własne w projekcie',
                        child: FilledButton.icon(
                          onPressed: !isOwnerOrAdmin || isSaving
                              ? null
                              : () =>
                                    ProjectCustomFieldDialogActions.openCreate(
                                      context,
                                    ),
                          icon: const Icon(Icons.add_rounded, size: Sizes.p18),
                          label: Text(l10n.projectSettingsAddCustomField),
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
                  if (fields.isEmpty)
                    ProjectCustomFieldsEmptyState(
                      canCreate: isOwnerOrAdmin,
                      isSaving: isSaving,
                      onCreate: () =>
                          ProjectCustomFieldDialogActions.openCreate(context),
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
                        itemCount: fields.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        itemBuilder: (ctx, index) {
                          final field = fields[index];
                          final visual = CustomFieldTypeVisualCatalog.forType(
                            field.type,
                          );

                          return Padding(
                            padding: const .symmetric(
                              horizontal: Sizes.p16,
                              vertical: Sizes.p12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: visual.color.withValues(alpha: .14),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    visual.icon,
                                    size: 18,
                                    color: visual.color,
                                  ),
                                ),
                                Gaps.w12,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    mainAxisSize: .min,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            field.name,
                                            style: context.text.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: .w600,
                                                  color: colors.onSurface,
                                                ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: visual.color.withValues(
                                                alpha: .12,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: visual.color.withValues(
                                                  alpha: .25,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              visual.label,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: visual.color,
                                              ),
                                            ),
                                          ),
                                          if (field.isRequired) ...[
                                            const SizedBox(width: 6),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: Sizes.p6,
                                                    vertical: Sizes.p2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: colors.errorContainer
                                                    .withValues(alpha: .3),
                                                borderRadius: .circular(
                                                  Sizes.p4,
                                                ),
                                              ),
                                              child: Text(
                                                'Wymagane',
                                                style: context.text.labelSmall
                                                    ?.copyWith(
                                                      color: colors.error,
                                                      fontWeight: .w700,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      if (field.options != null &&
                                          field.options!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: [
                                            for (final opt
                                                in field.options!.take(6))
                                              CustomFieldOptionChip(
                                                option:
                                                    CustomFieldOption.fromRaw(
                                                      opt,
                                                    ),
                                                compact: true,
                                              ),
                                            if (field.options!.length > 6)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: colors
                                                      .surfaceContainerHigh,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '+${field.options!.length - 6}',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        colors.onSurfaceVariant,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ] else ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          visual.description,
                                          style: context.text.labelSmall
                                              ?.copyWith(
                                                color: colors.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                if (isOwnerOrAdmin) ...[
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_upward_rounded,
                                      size: Sizes.p18,
                                      color: index > 0 && !isSaving
                                          ? colors.onSurfaceVariant
                                          : colors.outlineVariant.withValues(
                                              alpha: .4,
                                            ),
                                    ),
                                    tooltip: 'Przesuń pole w górę',
                                    onPressed: index > 0 && !isSaving
                                        ? () => context
                                              .read<
                                                TaskCustomFieldsSettingsCubit
                                              >()
                                              .moveField(index, index - 1)
                                        : null,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_downward_rounded,
                                      size: Sizes.p18,
                                      color:
                                          index < fields.length - 1 && !isSaving
                                          ? colors.onSurfaceVariant
                                          : colors.outlineVariant.withValues(
                                              alpha: .4,
                                            ),
                                    ),
                                    tooltip: 'Przesuń pole w dół',
                                    onPressed:
                                        index < fields.length - 1 && !isSaving
                                        ? () => context
                                              .read<
                                                TaskCustomFieldsSettingsCubit
                                              >()
                                              .moveField(index, index + 1)
                                        : null,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      size: Sizes.p18,
                                      color: colors.onSurfaceVariant,
                                    ),
                                    tooltip: 'Edytuj pole',
                                    onPressed: isSaving
                                        ? null
                                        : () =>
                                              ProjectCustomFieldDialogActions.openEdit(
                                                context,
                                                field,
                                              ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: Sizes.p18,
                                      color: colors.error,
                                    ),
                                    tooltip: 'Usuń pole',
                                    onPressed: isSaving
                                        ? null
                                        : () =>
                                              ProjectCustomFieldDialogActions.confirmDelete(
                                                context,
                                                field,
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
