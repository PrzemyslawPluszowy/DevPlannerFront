import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_icon_picker_section.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dialog formularza edycji przestrzeni roboczej.
class EditWorkspaceDialog extends StatefulWidget {
  const EditWorkspaceDialog({
    required this.item,
    super.key,
  });

  /// Edytowany element przestrzeni.
  final WorkspaceListItem item;

  /// Otwiera dialog z Cubitem katalogu należącym do bieżącego shella.
  static Future<void> show(
    BuildContext context, {
    required WorkspaceListItem item,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<WorkspacesHomeCubit>(),
        child: EditWorkspaceDialog(item: item),
      ),
    );
  }

  @override
  State<EditWorkspaceDialog> createState() => _EditWorkspaceDialogState();
}

class _EditWorkspaceDialogState extends State<EditWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  late final ValueNotifier<_EditWorkspaceDialogUiState> _uiState;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _uiState = ValueNotifier(
      _EditWorkspaceDialogUiState(
        selectedIconKey: widget.item.iconKey ?? 'folder',
        selectedColor: WorkspaceIconHelper.parseColor(
          widget.item.accentColorHex,
        ),
      ),
    );
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
      await cubit.updateWorkspace(
        workspaceId: widget.item.id,
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

    return ValueListenableBuilder<_EditWorkspaceDialogUiState>(
      valueListenable: _uiState,
      builder: (context, uiState, _) => Dialog(
        backgroundColor: colors.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: .all(.circular(16)),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const .all(Sizes.p24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: uiState.selectedColor.withValues(alpha: .14),
                          borderRadius: const .all(.circular(10)),
                        ),
                        alignment: .center,
                        child: Icon(
                          WorkspaceIconHelper.getIcon(uiState.selectedIconKey),
                          size: 22,
                          color: uiState.selectedColor,
                        ),
                      ),
                      Gaps.w12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              l10n.workspacesEditWorkspaceTitle,
                              style: context.text.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              l10n.workspacesEditWorkspaceSubtitle,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gaps.h20,
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
                    onColorSelected: (color) =>
                        _uiState.value = uiState.copyWith(
                          selectedColor: color,
                        ),
                  ),
                  Gaps.h24,
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      TextButton(
                        onPressed: uiState.isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: Text(l10n.workspacesCancelButton),
                      ),
                      Gaps.w8,
                      FilledButton(
                        onPressed: uiState.isSubmitting ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: uiState.selectedColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: .all(.circular(8)),
                          ),
                        ),
                        child: uiState.isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(l10n.workspacesSaveButton),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditWorkspaceDialogUiState {
  const _EditWorkspaceDialogUiState({
    required this.selectedIconKey,
    required this.selectedColor,
    this.isSubmitting = false,
  });

  final String selectedIconKey;
  final Color selectedColor;
  final bool isSubmitting;

  _EditWorkspaceDialogUiState copyWith({
    String? selectedIconKey,
    Color? selectedColor,
    bool? isSubmitting,
  }) {
    return _EditWorkspaceDialogUiState(
      selectedIconKey: selectedIconKey ?? this.selectedIconKey,
      selectedColor: selectedColor ?? this.selectedColor,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
