import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_cubits.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_icon_picker_section.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Formularz tworzenia projektu z lokalnym stanem kontrolek i Cubitem zapisu.
final class CreateProjectDialog extends StatelessWidget {
  const CreateProjectDialog({
    required this.workspaceId,
    required this.repository,
    this.onCreated,
    super.key,
  });

  final String workspaceId;
  final ProjectsRepository repository;
  final FutureOr<void> Function()? onCreated;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateProjectCommandCubit(repository),
      child: _CreateProjectForm(workspaceId: workspaceId, onCreated: onCreated),
    );
  }
}

final class _CreateProjectForm extends StatefulWidget {
  const _CreateProjectForm({required this.workspaceId, this.onCreated});

  final String workspaceId;
  final FutureOr<void> Function()? onCreated;

  @override
  State<_CreateProjectForm> createState() => _CreateProjectFormState();
}

final class _CreateProjectFormState extends State<_CreateProjectForm> {
  final _formKey = GlobalKey<FormState>();
  final _selectedIconKey = ValueNotifier<String>('workflow');
  final _selectedColor = ValueNotifier<Color>(const Color(0xFF6366F1));
  final _visibility = ValueNotifier<ProjectVisibility>(
    ProjectVisibility.shared,
  );
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final Listenable _formFields;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _formFields = Listenable.merge([
      _selectedIconKey,
      _selectedColor,
      _visibility,
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _selectedIconKey.dispose();
    _selectedColor.dispose();
    _visibility.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final description = _descriptionController.text.trim();
    unawaited(
      context.read<CreateProjectCommandCubit>().submit(
        workspaceId: widget.workspaceId,
        name: _nameController.text.trim(),
        description: description.isEmpty ? null : description,
        icon: _selectedIconKey.value,
        primaryColorHex: ProjectDialogColorHexCodec.toRgbHex(
          _selectedColor.value,
        ),
        visibility: _visibility.value,
      ),
    );
  }

  void _handleCommand(
    BuildContext context,
    ProjectResourceCreationCommandState state,
  ) {
    final error = state.error;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }
    final projectId = state.createdResourceId;
    if (projectId == null) return;
    final onCreated = widget.onCreated;
    if (onCreated != null) unawaited(Future.sync(onCreated));
    Navigator.of(context).pop();
    unawaited(
      context.plannerNavigation.go(
        '/workspaces/${widget.workspaceId}/projects/$projectId',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      CreateProjectCommandCubit,
      ProjectResourceCreationCommandState
    >(
      listener: _handleCommand,
      builder: (context, commandState) {
        return AnimatedBuilder(
          animation: _formFields,
          builder: (context, _) => _CreateProjectDialogBody(
            formKey: _formKey,
            nameController: _nameController,
            descriptionController: _descriptionController,
            selectedIconKey: _selectedIconKey.value,
            selectedColor: _selectedColor.value,
            visibility: _visibility.value,
            isSubmitting: commandState.isSubmitting,
            onSubmit: _submit,
            onIconSelected: (value) => _selectedIconKey.value = value,
            onColorSelected: (value) => _selectedColor.value = value,
            onVisibilitySelected: (value) => _visibility.value = value,
          ),
        );
      },
    );
  }
}

final class _CreateProjectDialogBody extends StatelessWidget {
  const _CreateProjectDialogBody({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.selectedIconKey,
    required this.selectedColor,
    required this.visibility,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onIconSelected,
    required this.onColorSelected,
    required this.onVisibilitySelected,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final String selectedIconKey;
  final Color selectedColor;
  final ProjectVisibility visibility;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final ValueChanged<String> onIconSelected;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<ProjectVisibility> onVisibilitySelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateProjectTitle,
      subtitle: l10n.workspacesCreateProjectSubtitle,
      icon: WorkspaceIconHelper.getIcon(selectedIconKey),
      accentColor: selectedColor,
      isSubmitting: isSubmitting,
      onSubmit: onSubmit,
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProjectTextField(
              label: l10n.workspacesProjectNameLabel,
              controller: nameController,
              hintText: l10n.workspacesProjectNameHint,
              autofocus: true,
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.workspacesProjectNameRequired
                  : null,
              onSubmitted: (_) => onSubmit(),
            ),
            Gaps.h12,
            _ProjectTextField(
              label: l10n.workspacesProjectDescriptionLabel,
              controller: descriptionController,
              hintText: l10n.workspacesProjectDescriptionHint,
              maxLines: 2,
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
              selected: {visibility},
              onSelectionChanged: (values) =>
                  onVisibilitySelected(values.first),
            ),
            Gaps.h16,
            WorkspaceIconPickerSection(
              selectedIconKey: selectedIconKey,
              selectedColor: selectedColor,
              onIconSelected: onIconSelected,
            ),
            Gaps.h16,
            WorkspaceColorPickerSection(
              selectedColor: selectedColor,
              onColorSelected: onColorSelected,
            ),
          ],
        ),
      ),
    );
  }
}

final class _ProjectTextField extends StatelessWidget {
  const _ProjectTextField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.autofocus = false,
    this.maxLines = 1,
    this.validator,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;
  final int maxLines;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.h6,
        TextFormField(
          controller: controller,
          autofocus: autofocus,
          maxLines: maxLines,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p10,
            ),
          ),
        ),
      ],
    );
  }
}
