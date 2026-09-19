import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_cubits.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_state.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Formularz tworzenia Whiteboardu; zapis wykonuje dedykowany Cubit komendy.
final class CreateWhiteboardDialog extends StatelessWidget {
  const CreateWhiteboardDialog({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
    this.onCreated,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;
  final FutureOr<void> Function()? onCreated;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateWhiteboardCommandCubit(repository),
      child: _CreateWhiteboardForm(
        workspaceId: workspaceId,
        projectId: projectId,
        onCreated: onCreated,
      ),
    );
  }
}

final class _CreateWhiteboardForm extends StatefulWidget {
  const _CreateWhiteboardForm({
    required this.workspaceId,
    required this.projectId,
    this.onCreated,
  });

  final String workspaceId;
  final String projectId;
  final FutureOr<void> Function()? onCreated;

  @override
  State<_CreateWhiteboardForm> createState() => _CreateWhiteboardFormState();
}

final class _CreateWhiteboardFormState extends State<_CreateWhiteboardForm> {
  final _formKey = GlobalKey<FormState>();
  final _selectedColor = ValueNotifier<Color>(const Color(0xFF6366F1));
  final _boardType = ValueNotifier<String>('Canvas');
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final Listenable _formFields;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _formFields = Listenable.merge([_selectedColor, _boardType]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _selectedColor.dispose();
    _boardType.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final description = _descriptionController.text.trim();
    unawaited(
      context.read<CreateWhiteboardCommandCubit>().submit(
        workspaceId: widget.workspaceId,
        projectId: widget.projectId,
        name: _nameController.text.trim(),
        description: description.isEmpty ? null : description,
        type: _boardType.value,
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
    final boardId = state.createdResourceId;
    if (boardId == null) return;
    final onCreated = widget.onCreated;
    if (onCreated != null) unawaited(Future.sync(onCreated));
    Navigator.of(context).pop();
    unawaited(
      context.plannerNavigation.go(
        '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/whiteboards/$boardId',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      CreateWhiteboardCommandCubit,
      ProjectResourceCreationCommandState
    >(
      listener: _handleCommand,
      builder: (context, commandState) => AnimatedBuilder(
        animation: _formFields,
        builder: (context, _) => _CreateWhiteboardDialogBody(
          formKey: _formKey,
          nameController: _nameController,
          descriptionController: _descriptionController,
          selectedColor: _selectedColor.value,
          boardType: _boardType.value,
          isSubmitting: commandState.isSubmitting,
          onSubmit: _submit,
          onColorSelected: (value) => _selectedColor.value = value,
          onBoardTypeSelected: (value) => _boardType.value = value,
        ),
      ),
    );
  }
}

final class _CreateWhiteboardDialogBody extends StatelessWidget {
  const _CreateWhiteboardDialogBody({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.selectedColor,
    required this.boardType,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onColorSelected,
    required this.onBoardTypeSelected,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final Color selectedColor;
  final String boardType;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<String> onBoardTypeSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateWhiteboardTitle,
      subtitle: l10n.workspacesCreateWhiteboardSubtitle,
      icon: WorkspaceIcons.whiteboard,
      accentColor: selectedColor,
      isSubmitting: isSubmitting,
      onSubmit: onSubmit,
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WhiteboardTextField(
              label: l10n.workspacesWhiteboardNameLabel,
              controller: nameController,
              hintText: l10n.workspacesWhiteboardNameHint,
              autofocus: true,
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.workspacesWhiteboardNameRequired
                  : null,
              onSubmitted: (_) => onSubmit(),
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
              selected: {boardType},
              onSelectionChanged: (values) => onBoardTypeSelected(values.first),
            ),
            Gaps.h12,
            _WhiteboardTextField(
              label: l10n.workspacesProjectDescriptionLabel,
              controller: descriptionController,
              hintText: l10n.workspacesProjectDescriptionHint,
              maxLines: 2,
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

final class _WhiteboardTextField extends StatelessWidget {
  const _WhiteboardTextField({
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
