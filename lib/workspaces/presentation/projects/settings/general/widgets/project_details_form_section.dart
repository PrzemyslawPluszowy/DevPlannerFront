import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/general/cubit/project_general_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/general/widgets/project_danger_zone_section.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/general/widgets/project_icon_and_color_picker.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/general/widgets/project_visibility_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final ValueNotifier<_ProjectDetailsFormValue> _formValue;

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
    _formValue = ValueNotifier(_valueForProject(widget.project));
  }

  @override
  void didUpdateWidget(covariant ProjectDetailsFormSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.id != widget.project.id ||
        oldWidget.project.name != widget.project.name) {
      _nameController.text = widget.project.name;
      _descriptionController.text = widget.project.description ?? '';
      _formValue.value = _valueForProject(widget.project);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _formValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isReadOnly = !widget.isOwnerOrAdmin;

    return ValueListenableBuilder<_ProjectDetailsFormValue>(
      valueListenable: _formValue,
      builder: (context, formValue, _) => SingleChildScrollView(
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
            ProjectIconAndColorPicker(
              selectedColor: formValue.color,
              selectedIcon: formValue.icon,
              availableColors: _availableColors,
              availableIcons: _availableIcons,
              enabled: !isReadOnly && !widget.isSaving,
              onColorChanged: (color) => _formValue.value = formValue.copyWith(
                color: color,
              ),
              onIconChanged: (icon) => _formValue.value = formValue.copyWith(
                icon: icon,
              ),
            ),
            Gaps.h24,
            ProjectVisibilitySelector(
              currentVisibility: formValue.visibility,
              enabled: !isReadOnly && !widget.isSaving,
              onChanged: (visibility) => _formValue.value = formValue.copyWith(
                visibility: visibility,
              ),
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
      ),
    );
  }

  _ProjectDetailsFormValue _valueForProject(ProjectListItem project) =>
      _ProjectDetailsFormValue(
        visibility: project.visibility,
        color: project.primaryColor ?? _availableColors.first,
        icon: project.icon ?? _availableIcons.first,
      );

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await widget.onSave(
      name: name,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      icon: _formValue.value.icon,
      primaryColor: _formValue.value.color,
      visibility: _formValue.value.visibility,
      status: widget.project.status,
    );
  }
}

class _ProjectDetailsFormValue {
  const _ProjectDetailsFormValue({
    required this.visibility,
    required this.color,
    required this.icon,
  });

  final ProjectVisibility visibility;
  final String color;
  final String icon;

  _ProjectDetailsFormValue copyWith({
    ProjectVisibility? visibility,
    String? color,
    String? icon,
  }) => _ProjectDetailsFormValue(
    visibility: visibility ?? this.visibility,
    color: color ?? this.color,
    icon: icon ?? this.icon,
  );
}
