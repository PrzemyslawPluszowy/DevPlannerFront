import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_cubits.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Formularz tworzenia karty Corkboard z lokalnym wyborem koloru.
final class CreateCorkboardCardDialog extends StatelessWidget {
  const CreateCorkboardCardDialog({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateCorkboardCardCommandCubit(repository),
      child: _CreateCorkboardCardForm(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    );
  }
}

final class _CreateCorkboardCardForm extends StatefulWidget {
  const _CreateCorkboardCardForm({
    required this.workspaceId,
    required this.projectId,
  });

  final String workspaceId;
  final String projectId;

  @override
  State<_CreateCorkboardCardForm> createState() =>
      _CreateCorkboardCardFormState();
}

final class _CreateCorkboardCardFormState
    extends State<_CreateCorkboardCardForm> {
  final _formKey = GlobalKey<FormState>();
  final _noteColor = ValueNotifier<Color>(const Color(0xFFFEF08A));
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

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
    _noteColor.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final content = _contentController.text.trim();
    unawaited(
      context.read<CreateCorkboardCardCommandCubit>().submit(
        workspaceId: widget.workspaceId,
        projectId: widget.projectId,
        title: _titleController.text.trim(),
        content: content.isEmpty ? null : content,
        colorHex: ProjectDialogColorHexCodec.toRgbHex(_noteColor.value),
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
    if (state.createdResourceId == null) return;
    Navigator.of(context).pop();
    unawaited(
      context.plannerNavigation.go(
        '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/corkboard',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<
      CreateCorkboardCardCommandCubit,
      ProjectResourceCreationCommandState
    >(
      listener: _handleCommand,
      builder: (context, state) => ValueListenableBuilder<Color>(
        valueListenable: _noteColor,
        builder: (context, noteColor, _) => WorkspaceCreationModalWrapper(
          title: l10n.workspacesCreateCorkboardTitle,
          subtitle: l10n.workspacesCreateCorkboardSubtitle,
          icon: WorkspaceIcons.corkboard,
          accentColor: const Color(0xFFF59E0B),
          isSubmitting: state.isSubmitting,
          onSubmit: _submit,
          body: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CorkboardTextField(
                  label: l10n.workspacesCorkboardTitleLabel,
                  controller: _titleController,
                  hintText: l10n.workspacesCorkboardTitleHint,
                  autofocus: true,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.workspacesCorkboardTitleRequired
                      : null,
                ),
                Gaps.h12,
                _CorkboardTextField(
                  label: l10n.workspacesCorkboardContentLabel,
                  controller: _contentController,
                  hintText: l10n.workspacesCorkboardContentHint,
                  maxLines: 3,
                ),
                Gaps.h16,
                Text(
                  l10n.workspacesCorkboardColorLabel,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Gaps.h8,
                _CorkboardColorPicker(
                  selectedColor: noteColor,
                  onSelected: (value) => _noteColor.value = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _CorkboardTextField extends StatelessWidget {
  const _CorkboardTextField({
    required this.label,
    required this.controller,
    required this.hintText,
    this.autofocus = false,
    this.maxLines = 1,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool autofocus;
  final int maxLines;
  final FormFieldValidator<String>? validator;

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
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: const EdgeInsets.all(Sizes.p10),
          ),
        ),
      ],
    );
  }
}

final class _CorkboardColorPicker extends StatelessWidget {
  const _CorkboardColorPicker({
    required this.selectedColor,
    required this.onSelected,
  });

  static const _colors = [
    Color(0xFFFEF08A),
    Color(0xFFBAE6FD),
    Color(0xFFBBF7D0),
    Color(0xFFFBCFE8),
    Color(0xFFDDD6FE),
  ];

  final Color selectedColor;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: _colors.map((color) {
        final isSelected = color == selectedColor;
        return InkWell(
          onTap: () => onSelected(color),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: isSelected
                  ? Border.all(color: Colors.black87, width: 2.2)
                  : Border.all(color: Colors.black12),
            ),
            child: isSelected
                ? const Icon(Symbols.check, size: 16, color: Colors.black87)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
