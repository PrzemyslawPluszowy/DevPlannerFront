import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/custom_fields/widgets/create_custom_field_dialog.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_type_visual.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/task_custom_fields_settings_cubit.dart';

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
          TaskCustomFieldsSettingsFailure(:final message) => Center(
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
                      context.read<TaskCustomFieldsSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
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
                              : () => _openCreateDialog(context),
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
                              Icons.data_object_rounded,
                              size: Sizes.p36,
                              color: colors.primary,
                            ),
                          ),
                          Gaps.h16,
                          Text(
                            l10n.projectSettingsCustomFieldsEmpty,
                            style: context.text.titleSmall?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Gaps.h6,
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Text(
                              'Dodaj własne pola tekstowe, liczbowe, daty lub listy wyboru do zadań w tym projekcie.',
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (isOwnerOrAdmin) ...[
                            Gaps.h20,
                            FilledButton.icon(
                              onPressed: isSaving
                                  ? null
                                  : () => _openCreateDialog(context),
                              icon: const Icon(
                                Icons.add_rounded,
                                size: Sizes.p18,
                              ),
                              label: Text(l10n.projectSettingsAddCustomField),
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
                        itemCount: fields.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        itemBuilder: (ctx, index) {
                          final field = fields[index];
                          final visual = customFieldTypeVisual(field.type);

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
                                        : () => _openEditDialog(context, field),
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
                                        : () => _confirmDelete(context, field),
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
    final cubit = context.read<TaskCustomFieldsSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            TaskCustomFieldType type,
            bool isRequired,
            List<String> options,
          })
        >(
          context: context,
          builder: (_) => const CreateCustomFieldDialog(),
        );

    if (result != null) {
      await cubit.save(
        name: result.name,
        type: result.type,
        isRequired: result.isRequired,
        options: result.options,
      );
    }
  }

  Future<void> _openEditDialog(
    BuildContext context,
    TaskCustomFieldResponse field,
  ) async {
    final cubit = context.read<TaskCustomFieldsSettingsCubit>();
    final result =
        await showDialog<
          ({
            String name,
            TaskCustomFieldType type,
            bool isRequired,
            List<String> options,
          })
        >(
          context: context,
          builder: (_) => CreateCustomFieldDialog(initialField: field),
        );

    if (result != null) {
      await cubit.save(
        existing: field,
        name: result.name,
        type: result.type,
        isRequired: result.isRequired,
        options: result.options,
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TaskCustomFieldResponse field,
  ) async {
    final cubit = context.read<TaskCustomFieldsSettingsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usuń pole niestandardowe'),
        content: Text(
          'Czy na pewno chcesz usunąć pole "${field.name}" z tego projektu?',
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
      await cubit.archive(field);
    }
  }
}
