import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';
import 'package:ready_next/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_icon_picker_section.dart';
import 'package:ready_next/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Otwiera modal tworzenia nowego projektu w workspace.
Future<void> showCreateProjectDialog(
  BuildContext context, {
  required String workspaceId,
  ProjectsRepository? repository,
  FutureOr<void> Function()? onCreated,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final repo = repository ?? context.read<ProjectsRepository>();
      return _CreateProjectDialog(
        workspaceId: workspaceId,
        repository: repo,
        onCreated: onCreated,
      );
    },
  );
}

/// Otwiera modal tworzenia nowej tablicy Whiteboard w projekcie.
Future<void> showCreateWhiteboardDialog(
  BuildContext context, {
  required String workspaceId,
  required String projectId,
  ProjectResourcesRepository? repository,
  FutureOr<void> Function()? onCreated,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final repo = repository ?? context.read<ProjectResourcesRepository>();
      return _CreateWhiteboardDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repo,
        onCreated: onCreated,
      );
    },
  );
}

/// Otwiera modal tworzenia nowego zadania w projekcie.
Future<void> showCreateTaskDialog(
  BuildContext context, {
  required String workspaceId,
  required String projectId,
  ProjectResourcesRepository? repository,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final repo = repository ?? context.read<ProjectResourcesRepository>();
      return _CreateTaskDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repo,
      );
    },
  );
}

/// Otwiera modal tworzenia nowej strony Wiki w projekcie.
Future<void> showCreateWikiPageDialog(
  BuildContext context, {
  required String workspaceId,
  required String projectId,
  ProjectResourcesRepository? repository,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final repo = repository ?? context.read<ProjectResourcesRepository>();
      return _CreateWikiPageDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repo,
      );
    },
  );
}

/// Otwiera modal tworzenia notatki na tablicy korkowej (Corkboard).
Future<void> showCreateCorkboardCardDialog(
  BuildContext context, {
  required String workspaceId,
  required String projectId,
  ProjectResourcesRepository? repository,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final repo = repository ?? context.read<ProjectResourcesRepository>();
      return _CreateCorkboardCardDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repo,
      );
    },
  );
}

/// Otwiera modal tworzenia folderu w projekcie.
Future<void> showCreateFolderDialog(
  BuildContext context, {
  required String workspaceId,
  required String projectId,
  ProjectResourcesRepository? repository,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final repo = repository ?? context.read<ProjectResourcesRepository>();
      return _CreateFolderDialog(
        workspaceId: workspaceId,
        projectId: projectId,
        repository: repo,
      );
    },
  );
}

// ==========================================
// 1. DIALOG TWORZENIA PROJEKTU
// ==========================================

class _CreateProjectDialog extends StatefulWidget {
  const _CreateProjectDialog({
    required this.workspaceId,
    required this.repository,
    this.onCreated,
  });

  final String workspaceId;
  final ProjectsRepository repository;
  final FutureOr<void> Function()? onCreated;

  @override
  State<_CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends State<_CreateProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  String _selectedIconKey = 'workflow';
  Color _selectedColor = const Color(0xFF6366F1);
  ProjectVisibility _visibility = ProjectVisibility.shared;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final description = _descController.text.trim();
    final hexColor =
        '#${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

    final result = await widget.repository.createProject(
      workspaceId: widget.workspaceId,
      name: name,
      description: description.isEmpty ? null : description,
      icon: _selectedIconKey,
      primaryColor: hexColor,
      visibility: _visibility,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: context.colors.error,
          ),
        );
      },
      (project) {
        final onCreated = widget.onCreated;
        if (onCreated != null) unawaited(Future.sync(onCreated));
        Navigator.of(context).pop();
        unawaited(
          context.router.navigatePath(
            '/workspaces/${widget.workspaceId}/projects/${project.id}',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateProjectTitle,
      subtitle: l10n.workspacesCreateProjectSubtitle,
      icon: WorkspaceIconHelper.getIcon(_selectedIconKey),
      accentColor: _selectedColor,
      isSubmitting: _isSubmitting,
      onSubmit: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.workspacesProjectNameLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.workspacesProjectNameHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p10,
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? l10n.workspacesProjectNameRequired
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            Gaps.h12,
            Text(
              l10n.workspacesProjectDescriptionLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _descController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: l10n.workspacesProjectDescriptionHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .all(Sizes.p10),
              ),
            ),
            Gaps.h12,
            Text(
              l10n.workspacesProjectVisibilityLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            SegmentedButton<ProjectVisibility>(
              segments: [
                ButtonSegment(
                  value: ProjectVisibility.shared,
                  icon: const Icon(Symbols.public, size: 16),
                  label: Text(l10n.workspacesProjectVisibilityShared),
                ),
                ButtonSegment(
                  value: ProjectVisibility.private,
                  icon: const Icon(Symbols.lock_outline, size: 16),
                  label: Text(l10n.workspacesProjectVisibilityPrivate),
                ),
              ],
              selected: {_visibility},
              onSelectionChanged: (set) =>
                  setState(() => _visibility = set.first),
            ),
            Gaps.h16,
            WorkspaceIconPickerSection(
              selectedIconKey: _selectedIconKey,
              selectedColor: _selectedColor,
              onIconSelected: (key) => setState(() => _selectedIconKey = key),
            ),
            Gaps.h16,
            WorkspaceColorPickerSection(
              selectedColor: _selectedColor,
              onColorSelected: (color) =>
                  setState(() => _selectedColor = color),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. DIALOG TWORZENIA WHITEBOARDU
// ==========================================

class _CreateWhiteboardDialog extends StatefulWidget {
  const _CreateWhiteboardDialog({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
    this.onCreated,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;
  final FutureOr<void> Function()? onCreated;

  @override
  State<_CreateWhiteboardDialog> createState() =>
      _CreateWhiteboardDialogState();
}

class _CreateWhiteboardDialogState extends State<_CreateWhiteboardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  Color _selectedColor = const Color(0xFF6366F1);
  String _boardType = 'Canvas';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final description = _descController.text.trim();

    final result = await widget.repository.createWhiteboard(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      name: name,
      description: description.isEmpty ? null : description,
      type: _boardType,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: context.colors.error,
          ),
        );
      },
      (board) {
        final onCreated = widget.onCreated;
        if (onCreated != null) unawaited(Future.sync(onCreated));
        Navigator.of(context).pop();
        unawaited(
          context.router.navigatePath(
            '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/whiteboards/${board.id}',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateWhiteboardTitle,
      subtitle: l10n.workspacesCreateWhiteboardSubtitle,
      icon: WorkspaceIcons.whiteboard,
      accentColor: _selectedColor,
      isSubmitting: _isSubmitting,
      onSubmit: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.workspacesWhiteboardNameLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.workspacesWhiteboardNameHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p10,
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? l10n.workspacesWhiteboardNameRequired
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            Gaps.h12,
            Text(
              l10n.workspacesWhiteboardFormatLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'Canvas',
                  icon: const Icon(Symbols.crop_free_rounded, size: 16),
                  label: Text(l10n.workspacesWhiteboardFormatCanvas),
                ),
                ButtonSegment(
                  value: 'A4Document',
                  icon: const Icon(Symbols.description, size: 16),
                  label: Text(l10n.workspacesWhiteboardFormatA4),
                ),
              ],
              selected: {_boardType},
              onSelectionChanged: (set) =>
                  setState(() => _boardType = set.first),
            ),
            Gaps.h12,
            Text(
              l10n.workspacesProjectDescriptionLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _descController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: l10n.workspacesProjectDescriptionHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .all(Sizes.p10),
              ),
            ),
            Gaps.h16,
            WorkspaceColorPickerSection(
              selectedColor: _selectedColor,
              onColorSelected: (color) =>
                  setState(() => _selectedColor = color),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. DIALOG TWORZENIA ZADANIA
// ==========================================

class _CreateTaskDialog extends StatefulWidget {
  const _CreateTaskDialog({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;

  @override
  State<_CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<_CreateTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  String _priority = 'Normal';
  String _status = 'Todo';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final title = _titleController.text.trim();
    final description = _descController.text.trim();

    final result = await widget.repository.createTask(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      title: title,
      description: description.isEmpty ? null : description,
      priority: _priority,
      status: _status,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: context.colors.error,
          ),
        );
      },
      (task) {
        Navigator.of(context).pop();
        unawaited(
          context.router.navigatePath(
            '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/tasks',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateTaskTitle,
      subtitle: l10n.workspacesCreateTaskSubtitle,
      icon: WorkspaceIcons.tasks,
      accentColor: colors.primary,
      isSubmitting: _isSubmitting,
      onSubmit: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.workspacesTaskTitleLabel,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _titleController,
              autofocus: true,
              style: context.text.bodySmall?.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: l10n.workspacesTaskTitleHint,
                hintStyle: context.text.bodySmall?.copyWith(
                  fontSize: 12.5,
                  color: colors.onSurfaceVariant.withValues(alpha: .6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? l10n.workspacesTaskTitleRequired
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            Gaps.h12,
            Text(
              l10n.workspacesTaskDescriptionLabel,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _descController,
              maxLines: 3,
              style: context.text.bodySmall?.copyWith(fontSize: 13),
              decoration: InputDecoration(
                hintText: l10n.workspacesTaskDescriptionHint,
                hintStyle: context.text.bodySmall?.copyWith(
                  fontSize: 12.5,
                  color: colors.onSurfaceVariant.withValues(alpha: .6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            Gaps.h12,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        l10n.workspacesTaskPriorityLabel,
                        style: context.text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Gaps.h6,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.7),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _priority,
                            isExpanded: true,
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 13,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'Low',
                                child: Text(
                                  l10n.workspacesTaskPriorityLow,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Normal',
                                child: Text(
                                  l10n.workspacesTaskPriorityNormal,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'High',
                                child: Text(
                                  l10n.workspacesTaskPriorityHigh,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Critical',
                                child: Text(
                                  l10n.workspacesTaskPriorityCritical,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _priority = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        l10n.workspacesTaskStatusLabel,
                        style: context.text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Gaps.h6,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colors.outlineVariant.withValues(alpha: 0.7),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _status,
                            isExpanded: true,
                            style: context.text.bodySmall?.copyWith(
                              fontSize: 13,
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'Todo',
                                child: Text(
                                  l10n.workspacesTaskStatusTodo,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'InProgress',
                                child: Text(
                                  l10n.workspacesTaskStatusInProgress,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Backlog',
                                child: Text(
                                  l10n.workspacesTaskStatusBacklog,
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _status = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. DIALOG TWORZENIA WIKI
// ==========================================

class _CreateWikiPageDialog extends StatefulWidget {
  const _CreateWikiPageDialog({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;

  @override
  State<_CreateWikiPageDialog> createState() => _CreateWikiPageDialogState();
}

class _CreateWikiPageDialogState extends State<_CreateWikiPageDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final title = _titleController.text.trim();
    final result = await widget.repository.createWikiPage(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      title: title,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: context.colors.error,
          ),
        );
      },
      (page) {
        Navigator.of(context).pop();
        unawaited(
          context.router.navigatePath(
            '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/wiki/pages/${page.id}',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateWikiTitle,
      subtitle: l10n.workspacesCreateWikiSubtitle,
      icon: WorkspaceIcons.wiki,
      accentColor: const Color(0xFF0284C7),
      isSubmitting: _isSubmitting,
      onSubmit: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.workspacesWikiTitleLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.workspacesWikiTitleHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p10,
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? l10n.workspacesWikiTitleRequired
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 5. DIALOG TABLICY KORKOWEJ (CORKBOARD)
// ==========================================

class _CreateCorkboardCardDialog extends StatefulWidget {
  const _CreateCorkboardCardDialog({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;

  @override
  State<_CreateCorkboardCardDialog> createState() =>
      _CreateCorkboardCardDialogState();
}

class _CreateCorkboardCardDialogState
    extends State<_CreateCorkboardCardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  Color _noteColor = const Color(0xFFFEF08A);
  bool _isSubmitting = false;

  static const _noteColors = [
    Color(0xFFFEF08A), // Żółty
    Color(0xFFBAE6FD), // Błękitny
    Color(0xFFBBF7D0), // Zielony
    Color(0xFFFBCFE8), // Różowy
    Color(0xFFDDD6FE), // Fioletowy
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final hexColor =
        '#${_noteColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

    final result = await widget.repository.createCorkboardCard(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      title: title,
      content: content.isEmpty ? null : content,
      colorHex: hexColor,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: context.colors.error,
          ),
        );
      },
      (card) {
        Navigator.of(context).pop();
        unawaited(
          context.router.navigatePath(
            '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/corkboard',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateCorkboardTitle,
      subtitle: l10n.workspacesCreateCorkboardSubtitle,
      icon: WorkspaceIcons.corkboard,
      accentColor: const Color(0xFFF59E0B),
      isSubmitting: _isSubmitting,
      onSubmit: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.workspacesCorkboardTitleLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _titleController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.workspacesCorkboardTitleHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p10,
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? l10n.workspacesCorkboardTitleRequired
                  : null,
            ),
            Gaps.h12,
            Text(
              l10n.workspacesCorkboardContentLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _contentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: l10n.workspacesCorkboardContentHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .all(Sizes.p10),
              ),
            ),
            Gaps.h16,
            Text(
              l10n.workspacesCorkboardColorLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h8,
            Wrap(
              spacing: 8,
              children: _noteColors.map((color) {
                final isSel = _noteColor == color;
                return InkWell(
                  onTap: () => setState(() => _noteColor = color),
                  borderRadius: const .all(.circular(8)),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const .all(.circular(8)),
                      border: isSel
                          ? Border.all(color: Colors.black87, width: 2.2)
                          : Border.all(color: Colors.black12),
                    ),
                    child: isSel
                        ? const Icon(
                            Symbols.check,
                            size: 16,
                            color: Colors.black87,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 6. DIALOG FOLDERU
// ==========================================

class _CreateFolderDialog extends StatefulWidget {
  const _CreateFolderDialog({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;

  @override
  State<_CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<_CreateFolderDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final result = await widget.repository.createProjectFolder(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      name: name,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: context.colors.error,
          ),
        );
      },
      (folder) {
        Navigator.of(context).pop();
        unawaited(
          context.router.navigatePath(
            '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/files',
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateFolderTitle,
      subtitle: l10n.workspacesCreateFolderSubtitle,
      icon: WorkspaceIcons.folder,
      accentColor: const Color(0xFFEAB308),
      isSubmitting: _isSubmitting,
      onSubmit: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.workspacesFolderNameLabel,
              style: context.text.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h6,
            TextFormField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.workspacesFolderNameHint,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p10,
                ),
              ),
              validator: (val) => (val == null || val.trim().isEmpty)
                  ? l10n.workspacesFolderNameRequired
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}
