import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/user_hub/cubit/project_user_hub_cubit.dart';

/// Zakładka osobistych preferencji projektu użytkownika (przypinanie, ukrywanie, widok startowy).
class ProjectUserPreferencesTabView extends StatelessWidget {
  const ProjectUserPreferencesTabView({
    required this.project,
    super.key,
  });

  final ProjectListItem project;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return BlocBuilder<ProjectUserHubCubit, ProjectUserHubState>(
      builder: (context, state) {
        if (state is! ProjectUserHubReady) {
          return const Center(child: CircularProgressIndicator());
        }

        final cubit = context.read<ProjectUserHubCubit>();
        final isSaving = state.isSaving;

        return SingleChildScrollView(
          padding: const .all(Sizes.p24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                l10n.projectUserHubPreferencesHeader,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: .w700,
                  color: colors.onSurface,
                ),
              ),
              Gaps.h4,
              Text(
                l10n.projectUserHubPreferencesDesc,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h20,

              if (state.successMessage != null) ...[
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
                          _localizedSuccess(context, state.successMessage!),
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

              // Przypinanie do ulubionych
              Container(
                padding: const .all(Sizes.p16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: .circular(Sizes.p12),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const .all(Sizes.p10),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: .12),
                        borderRadius: .circular(Sizes.p10),
                      ),
                      child: Icon(
                        state.isPinned
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: colors.primary,
                        size: Sizes.p24,
                      ),
                    ),
                    Gaps.w16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            l10n.projectUserHubPinLabel,
                            style: context.text.bodyMedium?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Gaps.h2,
                          Text(
                            l10n.projectUserHubPinDesc,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: state.isPinned,
                      onChanged: isSaving ? null : cubit.togglePin,
                    ),
                  ],
                ),
              ),

              Gaps.h12,

              // Ukrywanie projektu
              Container(
                padding: const .all(Sizes.p16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: .circular(Sizes.p12),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const .all(Sizes.p10),
                      decoration: BoxDecoration(
                        color: colors.onSurfaceVariant.withValues(alpha: .12),
                        borderRadius: .circular(Sizes.p10),
                      ),
                      child: Icon(
                        state.isHidden
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_outlined,
                        color: colors.onSurfaceVariant,
                        size: Sizes.p24,
                      ),
                    ),
                    Gaps.w16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            l10n.projectUserHubHideLabel,
                            style: context.text.bodyMedium?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          Gaps.h2,
                          Text(
                            l10n.projectUserHubHideDesc,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: state.isHidden,
                      onChanged: isSaving ? null : cubit.toggleHide,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _localizedSuccess(BuildContext context, String message) {
    final l10n = context.l10n;
    return switch (message) {
      'pin_success' ||
      'Projekt przypięty do ulubionych.' => l10n.projectUserHubPinnedSuccess,
      'unpin_success' ||
      'Projekt odpięty z ulubionych.' => l10n.projectUserHubUnpinnedSuccess,
      'hide_success' ||
      'Projekt ukryty z bocznego menu.' => l10n.projectUserHubHiddenSuccess,
      'unhide_success' || 'Projekt przywrócony do bocznego menu.' =>
        l10n.projectUserHubUnhiddenSuccess,
      _ => message,
    };
  }
}
