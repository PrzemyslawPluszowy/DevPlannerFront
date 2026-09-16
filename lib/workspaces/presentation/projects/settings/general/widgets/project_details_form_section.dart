import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/general/cubit/project_general_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/general/widgets/project_danger_zone_section.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/general/widgets/project_visibility_selector.dart';

/// Sekcja formularza danych ogólnych projektu: nazwa, opis, ikona, kolor, widoczność i strefa niebezpieczna.
class ProjectDetailsFormSection extends StatefulWidget {
  const ProjectDetailsFormSection({
    required this.project,
    required this.isOwnerOrAdmin,
    required this.onSave,
    this.isSaving = false,
    this.saveSuccess = false,
    this.onProjectDeleted,
    super.key,
  });

  /// Dane projektu.
  final ProjectListItem project;

  /// Czy użytkownik posiada uprawnienia do edycji (Owner/Admin).
  final bool isOwnerOrAdmin;

  /// Czy trwa zapis.
  final bool isSaving;

  /// Czy ostatni zapis zakończył się sukcesem.
  final bool saveSuccess;

  /// Callback wywoływany po trwałym usunięciu projektu.
  final VoidCallback? onProjectDeleted;

  /// Callback zapisu danych.
  final Future<void> Function({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    required ProjectVisibility visibility,
    required ProjectStatus status,
  })
  onSave;

  @override
  State<ProjectDetailsFormSection> createState() =>
      _ProjectDetailsFormSectionState();
}

class _ProjectDetailsFormSectionState extends State<ProjectDetailsFormSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late ProjectVisibility _visibility;
  late String? _selectedColor;
  late String? _selectedIcon;

  static const _availableColors = [
    '#3B82F6', // Blue
    '#6366F1', // Indigo
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#EF4444', // Red
    '#F59E0B', // Amber
    '#10B981', // Emerald
    '#06B6D4', // Cyan
    '#64748B', // Slate
  ];

  static const _availableIcons = [
    'folder',
    'rocket_launch',
    'task_alt',
    'code',
    'shopping_bag',
    'campaign',
    'group',
    'analytics',
    'build',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(
      text: widget.project.description ?? '',
    );
    _visibility = widget.project.visibility;
    _selectedColor = widget.project.primaryColor ?? _availableColors.first;
    _selectedIcon = widget.project.icon ?? _availableIcons.first;
  }

  @override
  void didUpdateWidget(covariant ProjectDetailsFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.id != widget.project.id ||
        oldWidget.project.name != widget.project.name) {
      _nameController.text = widget.project.name;
      _descriptionController.text = widget.project.description ?? '';
      _visibility = widget.project.visibility;
      _selectedColor = widget.project.primaryColor ?? _availableColors.first;
      _selectedIcon = widget.project.icon ?? _availableIcons.first;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isReadOnly = !widget.isOwnerOrAdmin;

    return SingleChildScrollView(
      padding: const .all(Sizes.p24),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (isReadOnly) ...[
            Container(
              padding: const .all(Sizes.p12),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: .circular(Sizes.p8),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: Sizes.p20,
                    color: colors.onSurfaceVariant,
                  ),
                  Gaps.w12,
                  Expanded(
                    child: Text(
                      l10n.projectSettingsReadOnlyNotice,
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
          Text(
            l10n.projectSettingsNameLabel,
            style: context.text.labelLarge?.copyWith(
              fontWeight: .w700,
              color: colors.onSurface,
            ),
          ),
          Gaps.h6,
          TextField(
            controller: _nameController,
            enabled: !isReadOnly && !widget.isSaving,
            decoration: InputDecoration(
              hintText: l10n.projectSettingsNameHint,
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
            l10n.projectSettingsDescriptionLabel,
            style: context.text.labelLarge?.copyWith(
              fontWeight: .w700,
              color: colors.onSurface,
            ),
          ),
          Gaps.h6,
          TextField(
            controller: _descriptionController,
            enabled: !isReadOnly && !widget.isSaving,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: l10n.projectSettingsDescriptionHint,
              border: OutlineInputBorder(
                borderRadius: .circular(Sizes.p8),
              ),
              contentPadding: const .all(Sizes.p12),
            ),
          ),
          Gaps.h20,
          Text(
            l10n.projectSettingsIconAndColorLabel,
            style: context.text.labelLarge?.copyWith(
              fontWeight: .w700,
              color: colors.onSurface,
            ),
          ),
          Gaps.h8,
          _IconAndColorPicker(
            selectedColor: _selectedColor,
            selectedIcon: _selectedIcon,
            availableColors: _availableColors,
            availableIcons: _availableIcons,
            enabled: !isReadOnly && !widget.isSaving,
            onColorChanged: (c) => setState(() => _selectedColor = c),
            onIconChanged: (i) => setState(() => _selectedIcon = i),
          ),
          Gaps.h24,
          ProjectVisibilitySelector(
            currentVisibility: _visibility,
            enabled: !isReadOnly && !widget.isSaving,
            onChanged: (v) => setState(() => _visibility = v),
          ),
          Gaps.h24,
          if (!isReadOnly) ...[
            Row(
              mainAxisAlignment: .end,
              children: [
                if (widget.saveSuccess) ...[
                  Icon(
                    Icons.check_circle_rounded,
                    color: colors.primary,
                    size: Sizes.p18,
                  ),
                  Gaps.w6,
                  Text(
                    l10n.projectSettingsGeneralSavedSuccess,
                    style: context.text.bodySmall?.copyWith(
                      color: colors.primary,
                      fontWeight: .w600,
                    ),
                  ),
                  Gaps.w16,
                ],
                FilledButton(
                  onPressed: widget.isSaving ? null : _handleSave,
                  style: FilledButton.styleFrom(
                    padding: const .symmetric(
                      horizontal: Sizes.p20,
                      vertical: Sizes.p12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: .circular(Sizes.p8),
                    ),
                  ),
                  child: widget.isSaving
                      ? SizedBox(
                          width: Sizes.p16,
                          height: Sizes.p16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        )
                      : Text(l10n.projectSettingsSaveGeneral),
                ),
              ],
            ),
            Gaps.h32,
          ],
          ProjectDangerZoneSection(
            project: widget.project,
            enabled: widget.isOwnerOrAdmin,
            isArchiving: false,
            isDeleting: false,
            onArchive: () =>
                context.read<ProjectGeneralSettingsCubit>().archiveProject(),
            onRestore: () =>
                context.read<ProjectGeneralSettingsCubit>().restoreProject(),
            onDelete: () async {
              final ok = await context
                  .read<ProjectGeneralSettingsCubit>()
                  .deleteProject();
              if (ok) widget.onProjectDeleted?.call();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await widget.onSave(
      name: name,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _selectedIcon,
      primaryColor: _selectedColor,
      visibility: _visibility,
      status: widget.project.status,
    );
  }
}

class _IconAndColorPicker extends StatelessWidget {
  const _IconAndColorPicker({
    required this.selectedColor,
    required this.selectedIcon,
    required this.availableColors,
    required this.availableIcons,
    required this.enabled,
    required this.onColorChanged,
    required this.onIconChanged,
  });

  final String? selectedColor;
  final String? selectedIcon;
  final List<String> availableColors;
  final List<String> availableIcons;
  final bool enabled;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<String> onIconChanged;

  Color _parseHex(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xff3b82f6);
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  IconData _mapIcon(String? name) {
    return switch (name) {
      'rocket_launch' => Icons.rocket_launch_rounded,
      'task_alt' => Icons.task_alt_rounded,
      'code' => Icons.code_rounded,
      'shopping_bag' => Icons.shopping_bag_rounded,
      'campaign' => Icons.campaign_rounded,
      'group' => Icons.group_rounded,
      'analytics' => Icons.analytics_rounded,
      'build' => Icons.build_rounded,
      _ => Icons.folder_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: Sizes.p12,
      runSpacing: Sizes.p12,
      crossAxisAlignment: .center,
      children: [
        // Color swatches
        Wrap(
          spacing: Sizes.p8,
          children: [
            for (final hex in availableColors)
              InkWell(
                onTap: enabled ? () => onColorChanged(hex) : null,
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
        Gaps.w8,
        // Icon selectors
        Wrap(
          spacing: Sizes.p8,
          children: [
            for (final iconName in availableIcons)
              InkWell(
                onTap: enabled ? () => onIconChanged(iconName) : null,
                borderRadius: .circular(Sizes.p8),
                child: Container(
                  width: Sizes.p32,
                  height: Sizes.p32,
                  decoration: BoxDecoration(
                    color: selectedIcon == iconName
                        ? colors.primaryContainer
                        : colors.surfaceContainerLow,
                    borderRadius: .circular(Sizes.p8),
                    border: Border.all(
                      color: selectedIcon == iconName
                          ? colors.primary
                          : colors.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    _mapIcon(iconName),
                    size: Sizes.p18,
                    color: selectedIcon == iconName
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
