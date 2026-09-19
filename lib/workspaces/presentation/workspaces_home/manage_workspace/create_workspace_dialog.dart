import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_icon_picker_section.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dialog formularza tworzenia nowego workspace’u z wyborem nazwy, ikony i koloru akcentu.
class CreateWorkspaceDialog extends StatefulWidget {
  const CreateWorkspaceDialog({super.key});

  /// Otwiera dialog z Cubitem katalogu należącym do bieżącego shella.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<WorkspacesHomeCubit>(),
        child: const CreateWorkspaceDialog(),
      ),
    );
  }

  @override
  State<CreateWorkspaceDialog> createState() => _CreateWorkspaceDialogState();
}

class _CreateWorkspaceDialogState extends State<CreateWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  final ValueNotifier<_CreateWorkspaceDialogUiState> _uiState = ValueNotifier(
    const _CreateWorkspaceDialogUiState(
      selectedIconKey: 'folder',
      selectedColor: Color(0xff0b57d0),
    ),
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _uiState.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final currentState = _uiState.value;
    if (currentState.isSubmitting) return;

    _uiState.value = currentState.copyWith(isSubmitting: true);

    final name = _nameController.text.trim();
    final hexColor =
        '#${currentState.selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';

    final cubit = context.read<WorkspacesHomeCubit>();
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    try {
      await cubit.createWorkspace(
        name: name,
        icon: currentState.selectedIconKey,
        primaryColor: hexColor,
      );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        _uiState.value = _uiState.value.copyWith(isSubmitting: false);
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

    return ValueListenableBuilder<_CreateWorkspaceDialogUiState>(
      valueListenable: _uiState,
      builder: (context, uiState, _) => WorkspaceCreationModalWrapper(
        title: l10n.workspacesCreateWorkspaceTitle,
        subtitle: l10n.workspacesCreateWorkspaceSubtitle,
        icon: WorkspaceIconHelper.getIcon(uiState.selectedIconKey),
        accentColor: uiState.selectedColor,
        isSubmitting: uiState.isSubmitting,
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
                selectedIconKey: uiState.selectedIconKey,
                selectedColor: uiState.selectedColor,
                onIconSelected: (key) => _uiState.value = uiState.copyWith(
                  selectedIconKey: key,
                ),
              ),
              Gaps.h16,
              WorkspaceColorPickerSection(
                selectedColor: uiState.selectedColor,
                onColorSelected: (color) => _uiState.value = uiState.copyWith(
                  selectedColor: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateWorkspaceDialogUiState {
  const _CreateWorkspaceDialogUiState({
    required this.selectedIconKey,
    required this.selectedColor,
    this.isSubmitting = false,
  });

  final String selectedIconKey;
  final Color selectedColor;
  final bool isSubmitting;

  _CreateWorkspaceDialogUiState copyWith({
    String? selectedIconKey,
    Color? selectedColor,
    bool? isSubmitting,
  }) {
    return _CreateWorkspaceDialogUiState(
      selectedIconKey: selectedIconKey ?? this.selectedIconKey,
      selectedColor: selectedColor ?? this.selectedColor,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
