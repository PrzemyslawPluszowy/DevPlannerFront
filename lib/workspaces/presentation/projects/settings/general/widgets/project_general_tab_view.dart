import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/general/cubit/project_general_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/general/widgets/project_details_form_section.dart';

/// Główny widok zakładki "Ogólne" w ustawieniach projektu.
class ProjectGeneralTabView extends StatelessWidget {
  const ProjectGeneralTabView({
    required this.project,
    required this.userRole,
    this.onProjectDeleted,
    super.key,
  });

  /// Początkowe dane projektu.
  final ProjectListItem project;

  /// Rola użytkownika w projekcie lub workspace.
  final ProjectRole? userRole;

  /// Callback po trwałym usunięciu projektu.
  final VoidCallback? onProjectDeleted;

  @override
  Widget build(BuildContext context) {
    final isOwnerOrAdmin =
        userRole == ProjectRole.owner || userRole == ProjectRole.admin;

    return BlocBuilder<
      ProjectGeneralSettingsCubit,
      ProjectGeneralSettingsState
    >(
      builder: (context, state) {
        return switch (state) {
          ProjectGeneralSettingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ProjectGeneralSettingsError(:final error) => Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: Sizes.p40,
                  color: context.colors.error,
                ),
                Gaps.h12,
                Text(
                  error.message,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.h16,
                OutlinedButton(
                  onPressed: () =>
                      context.read<ProjectGeneralSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          ProjectGeneralSettingsLoaded(
            :final project,
            :final isSaving,
            :final saveSuccess,
          ) =>
            ProjectDetailsFormSection(
              project: project,
              isOwnerOrAdmin: isOwnerOrAdmin,
              isSaving: isSaving,
              saveSuccess: saveSuccess,
              onProjectDeleted: onProjectDeleted,
              onSave:
                  ({
                    required name,
                    description,
                    icon,
                    primaryColor,
                    required visibility,
                    required status,
                  }) => context.read<ProjectGeneralSettingsCubit>().saveDetails(
                    name: name,
                    description: description,
                    icon: icon,
                    primaryColor: primaryColor,
                    visibility: visibility,
                    status: status,
                  ),
            ),
        };
      },
    );
  }
}
