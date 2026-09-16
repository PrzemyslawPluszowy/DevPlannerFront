import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_icon_picker_section.dart';
import 'package:ready_next/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Otwiera modal tworzenia nowej przestrzeni roboczej (Workspace).
Future<void> showCreateWorkspaceDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<WorkspacesHomeCubit>(),
      child: const CreateWorkspaceDialog(),
    ),
  );
}

/// Dialog formularza tworzenia nowego workspace’u z wyborem nazwy, ikony i koloru akcentu.
class CreateWorkspaceDialog extends StatefulWidget {
  const CreateWorkspaceDialog({super.key});

  @override
  State<CreateWorkspaceDialog> createState() => _CreateWorkspaceDialogState();
}

class _CreateWorkspaceDialogState extends State<CreateWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  String _selectedIconKey = 'folder';
  Color _selectedColor = const Color(0xff0b57d0);
  bool _isSubmitting = false;

  @override
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
    final hexColor =
        '#${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

    final cubit = context.read<WorkspacesHomeCubit>();
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    try {
      await cubit.createWorkspace(
        name: name,
        icon: _selectedIconKey,
        primaryColor: hexColor,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        scaffoldMessenger?.showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateWorkspaceTitle,
      subtitle: l10n.workspacesCreateWorkspaceSubtitle,
      icon: WorkspaceIconHelper.getIcon(_selectedIconKey),
      accentColor: _selectedColor,
      isSubmitting: _isSubmitting,
      submitLabel: l10n.workspacesCreateButton,
      cancelLabel: l10n.workspacesCancelButton,
      onSubmit: _submit,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            Text(
              l10n.workspacesNameFieldLabel,
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
                hintText: l10n.workspacesNameFieldPlaceholder,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p10,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.workspacesNameRequiredError;
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
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
