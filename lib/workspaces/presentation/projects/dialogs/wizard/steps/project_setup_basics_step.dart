import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_dialog_color_hex_codec.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/cubit/project_setup_wizard_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/l10n/project_setup_wizard_l10n.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/wizard/widgets/project_setup_wizard_controls.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_color_picker_section.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/widgets/workspace_icon_picker_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Krok 2 kreatora: nazwa, opis, ikona, kolor i status początkowy projektu.
class ProjectSetupBasicsStep extends StatefulWidget {
  /// Tworzy krok podstaw projektu.
  const ProjectSetupBasicsStep({required this.state, super.key});

  /// Bieżący stan kreatora.
  final ProjectSetupWizardState state;

  @override
  State<ProjectSetupBasicsStep> createState() => _ProjectSetupBasicsStepState();
}

class _ProjectSetupBasicsStepState extends State<ProjectSetupBasicsStep> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.state.draft.name);
    _descriptionController = TextEditingController(
      text: widget.state.draft.description,
    );
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
    final cubit = context.read<ProjectSetupWizardCubit>();
    final draft = widget.state.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProjectSetupSectionLabel(l10n.workspacesProjectNameLabel),
        Gaps.h6,
        TextField(
          controller: _nameController,
          autofocus: true,
          textInputAction: TextInputAction.next,
          onChanged: cubit.setName,
          decoration: InputDecoration(
            hintText: l10n.workspacesProjectNameHint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        ProjectSetupFieldError(
          error: widget.state.fieldErrors[ProjectSetupField.name],
        ),
        Gaps.h16,
        ProjectSetupSectionLabel(l10n.workspacesProjectDescriptionLabel),
        Gaps.h6,
        TextField(
          controller: _descriptionController,
          minLines: 2,
          maxLines: 4,
          onChanged: cubit.setDescription,
          decoration: InputDecoration(
            hintText: l10n.workspacesProjectDescriptionHint,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
        Gaps.h16,
        ProjectSetupSectionLabel(l10n.projectSetupProjectStatusLabel),
        Gaps.h6,
        SegmentedButton<ProjectStatus>(
          segments: [
            for (final status in ProjectStatus.values)
              ButtonSegment(
                value: status,
                label: Text(
                  ProjectSetupWizardL10n.projectStatus(l10n, status),
                ),
              ),
          ],
          selected: {draft.status},
          showSelectedIcon: false,
          onSelectionChanged: (values) => cubit.setStatus(values.first),
        ),
        Gaps.h20,
        WorkspaceIconPickerSection(
          selectedIconKey: draft.iconKey,
          selectedColor: _colorOf(draft.colorHex, colors.primary),
          onIconSelected: cubit.setIconKey,
        ),
        Gaps.h16,
        WorkspaceColorPickerSection(
          selectedColor: _colorOf(draft.colorHex, colors.primary),
          onColorSelected: (color) =>
              cubit.setColorHex(ProjectDialogColorHexCodec.toRgbHex(color)),
        ),
      ],
    );
  }

  static Color _colorOf(String hex, Color fallback) =>
      ProjectDialogColorHexCodec.toColor(hex) ?? fallback;
}
