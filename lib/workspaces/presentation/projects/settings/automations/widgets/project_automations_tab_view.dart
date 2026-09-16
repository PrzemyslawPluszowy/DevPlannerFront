import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/automation_settings_cubit.dart';

/// Widok zakładki "Automatyzacje" w ustawieniach projektu z listą aktywnych reguł oraz szablonami (Recipes).
class ProjectAutomationsTabView extends StatelessWidget {
  const ProjectAutomationsTabView({
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

    return BlocBuilder<AutomationSettingsCubit, AutomationSettingsState>(
      builder: (context, state) {
        return switch (state) {
          AutomationSettingsInitial() || AutomationSettingsLoading() =>
            const Center(child: CircularProgressIndicator()),
          AutomationSettingsFailure(:final message) => Center(
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
                      context.read<AutomationSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          AutomationSettingsReady(
            :final rules,
            :final recipes,
            :final busyRuleId,
            :final isInstallingRecipe,
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
                            l10n.projectSettingsAutomationsHeader,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Gaps.h4,
                          Text(
                            'Aktywne reguły: ${rules.where((r) => r.isEnabled).length}',
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gaps.h16,
                  if (rules.isEmpty)
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
                            Icons.auto_fix_high_rounded,
                            size: Sizes.p44,
                            color: colors.outline,
                          ),
                          Gaps.h12,
                          Text(
                            l10n.projectSettingsAutomationsEmpty,
                            style: context.text.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                        itemCount: rules.length,
                        separatorBuilder: (_, _) => Divider(
                          height: 1,
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                        itemBuilder: (ctx, index) {
                          final rule = rules[index];
                          final isBusy = busyRuleId == rule.id;

                          return Padding(
                            padding: const .symmetric(
                              horizontal: Sizes.p16,
                              vertical: Sizes.p12,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  size: Sizes.p20,
                                  color: rule.isEnabled
                                      ? colors.primary
                                      : colors.outline,
                                ),
                                Gaps.w12,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        rule.name,
                                        style: context.text.bodyMedium
                                            ?.copyWith(
                                              fontWeight: .w600,
                                              color: rule.isEnabled
                                                  ? colors.onSurface
                                                  : colors.onSurfaceVariant,
                                            ),
                                      ),
                                      Gaps.h2,
                                      Text(
                                        'Wyzwalacz: ${rule.triggerType.name} | Wykonano: ${rule.executionCount} razy',
                                        style: context.text.labelSmall
                                            ?.copyWith(
                                              color: colors.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isOwnerOrAdmin) ...[
                                  Switch(
                                    value: rule.isEnabled,
                                    onChanged: isBusy
                                        ? null
                                        : (val) => context
                                              .read<AutomationSettingsCubit>()
                                              .setEnabled(rule, val),
                                  ),
                                  Gaps.w8,
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: Sizes.p18,
                                      color: colors.error,
                                    ),
                                    tooltip: 'Archiwizuj regułę',
                                    onPressed: isBusy
                                        ? null
                                        : () => context
                                              .read<AutomationSettingsCubit>()
                                              .archive(rule),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  Gaps.h32,
                  Text(
                    'Gotowe szablony automatyzacji (Recipes)',
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: .w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Gaps.h12,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          mainAxisExtent: 140,
                          crossAxisSpacing: Sizes.p12,
                          mainAxisSpacing: Sizes.p12,
                        ),
                    itemCount: recipes.length,
                    itemBuilder: (ctx, index) {
                      final recipe = recipes[index];

                      return Container(
                        padding: const .all(Sizes.p12),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: .circular(Sizes.p10),
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.auto_fix_high_rounded,
                                      size: Sizes.p16,
                                      color: colors.primary,
                                    ),
                                    Gaps.w6,
                                    Expanded(
                                      child: Text(
                                        recipe.name,
                                        style: context.text.bodyMedium
                                            ?.copyWith(
                                              fontWeight: .w700,
                                              color: colors.onSurface,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.h4,
                                Text(
                                  recipe.description,
                                  style: context.text.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: !isOwnerOrAdmin || isInstallingRecipe
                                    ? null
                                    : () => context
                                          .read<AutomationSettingsCubit>()
                                          .installRecipe(recipe),
                                icon: const Icon(
                                  Icons.add_circle_outline_rounded,
                                  size: Sizes.p16,
                                ),
                                label: const Text('Zainstaluj'),
                              ),
                            ),
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
