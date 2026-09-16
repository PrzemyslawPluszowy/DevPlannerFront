import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_icon_picker_section.dart';
import 'package:ready_next/workspaces/shared/helpers/workspace_icon_helper.dart';

/// Otwiera modal edycji istniejącej przestrzeni roboczej.
Future<void> showEditWorkspaceDialog(
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

/// Dialog formularza edycji przestrzeni roboczej.
class EditWorkspaceDialog extends StatefulWidget {
  const EditWorkspaceDialog({
    required this.item,
    super.key,
  });

  /// Edytowany element przestrzeni.
  final WorkspaceListItem item;

  @override
  State<EditWorkspaceDialog> createState() => _EditWorkspaceDialogState();
}

class _EditWorkspaceDialogState extends State<EditWorkspaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  late String _selectedIconKey;
  late Color _selectedColor;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _selectedIconKey = widget.item.iconKey ?? 'folder';
    _selectedColor = WorkspaceIconHelper.parseColor(widget.item.accentColorHex);
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
      await cubit.updateWorkspace(
        workspaceId: widget.item.id,
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

    return Dialog(
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
                        color: _selectedColor.withValues(alpha: .14),
                        borderRadius: const .all(.circular(10)),
                      ),
                      alignment: .center,
                      child: Icon(
                        WorkspaceIconHelper.getIcon(_selectedIconKey),
                        size: 22,
                        color: _selectedColor,
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
                  selectedIconKey: _selectedIconKey,
                  selectedColor: _selectedColor,
                  onIconSelected: (key) =>
                      setState(() => _selectedIconKey = key),
                ),
                Gaps.h16,
                WorkspaceColorPickerSection(
                  selectedColor: _selectedColor,
                  onColorSelected: (color) =>
                      setState(() => _selectedColor = color),
                ),
                Gaps.h24,
                Row(
                  mainAxisAlignment: .end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(l10n.workspacesCancelButton),
                    ),
                    Gaps.w8,
                    FilledButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: _selectedColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: .all(.circular(8)),
                        ),
                      ),
                      child: _isSubmitting
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
    );
  }
}
