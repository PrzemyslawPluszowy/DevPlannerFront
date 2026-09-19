import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/general/cubit/workspace_general_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/general/widgets/workspace_danger_zone_section.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/general/widgets/workspace_general_form_options.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Główny widok zakładki "Ogólne" w ustawieniach przestrzeni roboczej.
class WorkspaceGeneralTabView extends StatefulWidget {
  const WorkspaceGeneralTabView({
    required this.workspace,
    required this.userRole,
    super.key,
  });

  /// Dane przestrzeni roboczej.
  final WorkspaceListItem workspace;

  /// Rola użytkownika w przestrzeni roboczej.
  final WorkspaceRole? userRole;

  @override
  State<WorkspaceGeneralTabView> createState() =>
      _WorkspaceGeneralTabViewState();
}

class _WorkspaceGeneralTabViewState extends State<WorkspaceGeneralTabView> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final ValueNotifier<String> _selectedIcon;
  late final ValueNotifier<String> _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workspace.name);
    _descriptionController = TextEditingController(
      text: widget.workspace.description ?? '',
    );
    _selectedIcon = ValueNotifier(
      widget.workspace.icon ?? WorkspaceGeneralFormOptions.icons.first,
    );
    _selectedColor = ValueNotifier(
      widget.workspace.primaryColor ?? WorkspaceGeneralFormOptions.colors.first,
    );
  }

  @override
  void didUpdateWidget(WorkspaceGeneralTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.workspace.id != oldWidget.workspace.id) {
      _nameController.text = widget.workspace.name;
      _descriptionController.text = widget.workspace.description ?? '';
      _selectedIcon.value =
          widget.workspace.icon ?? WorkspaceGeneralFormOptions.icons.first;
      _selectedColor.value =
          widget.workspace.primaryColor ??
          WorkspaceGeneralFormOptions.colors.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _selectedIcon.dispose();
    _selectedColor.dispose();
    super.dispose();
  }

  Color _parseHex(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isOwnerOrAdmin =
        widget.userRole == WorkspaceRole.owner ||
        widget.userRole == WorkspaceRole.admin;

    return BlocBuilder<
      WorkspaceGeneralSettingsCubit,
      WorkspaceGeneralSettingsState
    >(
      builder: (context, state) {
        return switch (state) {
          WorkspaceGeneralSettingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          WorkspaceGeneralSettingsError(:final error) => Center(
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
                  error.message,
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.h16,
                OutlinedButton(
                  onPressed: () =>
                      context.read<WorkspaceGeneralSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          WorkspaceGeneralSettingsLoaded(
            :final workspace,
            :final isSaving,
            :final saveSuccess,
            :final isArchiving,
            :final error,
          ) =>
            SingleChildScrollView(
              padding: const .all(Sizes.p24),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  if (!isOwnerOrAdmin) ...[
                    Container(
                      padding: const .all(Sizes.p12),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLow,
                        borderRadius: .circular(Sizes.p8),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: colors.onSurfaceVariant,
                            size: Sizes.p20,
                          ),
                          Gaps.w8,
                          Expanded(
                            child: Text(
                              l10n.workspaceSettingsReadOnlyNotice,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.h16,
                  ],
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
                              error.message,
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
                  Text(
                    l10n.workspaceSettingsNameLabel,
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: .w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Gaps.h6,
                  TextField(
                    controller: _nameController,
                    readOnly: !isOwnerOrAdmin || isSaving,
                    decoration: InputDecoration(
                      hintText: l10n.workspaceSettingsNameHint,
                      border: OutlineInputBorder(
                        borderRadius: .circular(Sizes.p8),
                      ),
                      contentPadding: const .symmetric(
                        horizontal: Sizes.p12,
                        vertical: Sizes.p10,
                      ),
                    ),
                  ),
                  Gaps.h16,
                  Text(
                    l10n.workspaceSettingsDescriptionLabel,
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: .w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Gaps.h6,
                  TextField(
                    controller: _descriptionController,
                    readOnly: !isOwnerOrAdmin || isSaving,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.workspaceSettingsDescriptionHint,
                      border: OutlineInputBorder(
                        borderRadius: .circular(Sizes.p8),
                      ),
                      contentPadding: const .all(Sizes.p12),
                    ),
                  ),
                  Gaps.h20,
                  Text(
                    'Ikona i kolor przestrzeni',
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: .w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Gaps.h8,
                  ValueListenableBuilder(
                    valueListenable: _selectedIcon,
                    builder: (context, selectedIcon, _) => Wrap(
                      spacing: Sizes.p8,
                      children: [
                        for (final iconKey in WorkspaceGeneralFormOptions.icons)
                          InkWell(
                            onTap: !isOwnerOrAdmin || isSaving
                                ? null
                                : () => _selectedIcon.value = iconKey,
                            borderRadius: .circular(Sizes.p8),
                            child: Container(
                              width: Sizes.p36,
                              height: Sizes.p36,
                              decoration: BoxDecoration(
                                color: selectedIcon == iconKey
                                    ? colors.primaryContainer
                                    : colors.surfaceContainerLow,
                                borderRadius: .circular(Sizes.p8),
                                border: Border.all(
                                  color: selectedIcon == iconKey
                                      ? colors.primary
                                      : colors.outlineVariant,
                                ),
                              ),
                              child: Icon(
                                WorkspaceIconHelper.getIcon(iconKey),
                                size: Sizes.p20,
                                color: selectedIcon == iconKey
                                    ? colors.onPrimaryContainer
                                    : colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Gaps.h12,
                  ValueListenableBuilder(
                    valueListenable: _selectedColor,
                    builder: (context, selectedColor, _) => Wrap(
                      spacing: Sizes.p8,
                      children: [
                        for (final hex in WorkspaceGeneralFormOptions.colors)
                          InkWell(
                            onTap: !isOwnerOrAdmin || isSaving
                                ? null
                                : () => _selectedColor.value = hex,
                            borderRadius: .circular(Sizes.p999),
                            child: Container(
                              width: Sizes.p28,
                              height: Sizes.p28,
                              decoration: BoxDecoration(
                                color: _parseHex(hex),
                                shape: .circle,
                                border: Border.all(
                                  color: selectedColor == hex
                                      ? colors.onSurface
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: selectedColor == hex
                                  ? const Icon(
                                      Icons.check,
                                      size: Sizes.p16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Gaps.h24,
                  if (isOwnerOrAdmin) ...[
                    Row(
                      mainAxisAlignment: .end,
                      children: [
                        if (saveSuccess) ...[
                          Icon(
                            Icons.check_circle_rounded,
                            color: colors.primary,
                            size: Sizes.p18,
                          ),
                          Gaps.w6,
                          Text(
                            l10n.workspaceSettingsSavedSuccess,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.primary,
                              fontWeight: .w600,
                            ),
                          ),
                          Gaps.w16,
                        ],
                        FilledButton(
                          onPressed: isSaving ? null : _handleSave,
                          child: isSaving
                              ? const SizedBox(
                                  width: Sizes.p16,
                                  height: Sizes.p16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.workspaceSettingsSaveGeneral),
                        ),
                      ],
                    ),
                    Gaps.h32,
                  ],
                  WorkspaceDangerZoneSection(
                    workspace: workspace,
                    enabled: isOwnerOrAdmin,
                    isArchiving: isArchiving,
                    onArchive: () => context
                        .read<WorkspaceGeneralSettingsCubit>()
                        .archiveWorkspace(),
                    onRestore: () => context
                        .read<WorkspaceGeneralSettingsCubit>()
                        .restoreWorkspace(),
                  ),
                ],
              ),
            ),
        };
      },
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await context.read<WorkspaceGeneralSettingsCubit>().saveDetails(
      name: name,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _selectedIcon.value,
      primaryColor: _selectedColor.value,
    );
  }
}
