import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_cubits.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_state.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Formularz tworzenia zadania projektu z lokalnymi selektorami formularza.
final class CreateTaskDialog extends StatelessWidget {
  const CreateTaskDialog({
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
      create: (_) => CreateProjectTaskCommandCubit(repository),
      child: _CreateTaskForm(workspaceId: workspaceId, projectId: projectId),
    );
  }
}

final class _CreateTaskForm extends StatefulWidget {
  const _CreateTaskForm({required this.workspaceId, required this.projectId});

  final String workspaceId;
  final String projectId;

  @override
  State<_CreateTaskForm> createState() => _CreateTaskFormState();
}

final class _CreateTaskFormState extends State<_CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _priority = ValueNotifier<String>('Normal');
  final _status = ValueNotifier<String>('Todo');
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final Listenable _selectors;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectors = Listenable.merge([_priority, _status]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priority.dispose();
    _status.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final description = _descriptionController.text.trim();
    unawaited(
      context.read<CreateProjectTaskCommandCubit>().submit(
        workspaceId: widget.workspaceId,
        projectId: widget.projectId,
        title: _titleController.text.trim(),
        description: description.isEmpty ? null : description,
        priority: _priority.value,
        status: _status.value,
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
        '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/tasks',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      CreateProjectTaskCommandCubit,
      ProjectResourceCreationCommandState
    >(
      listener: _handleCommand,
      builder: (context, commandState) => AnimatedBuilder(
        animation: _selectors,
        builder: (context, _) => _CreateTaskDialogBody(
          formKey: _formKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          priority: _priority.value,
          status: _status.value,
          isSubmitting: commandState.isSubmitting,
          onSubmit: _submit,
          onPrioritySelected: (value) => _priority.value = value,
          onStatusSelected: (value) => _status.value = value,
        ),
      ),
    );
  }
}

final class _CreateTaskDialogBody extends StatelessWidget {
  const _CreateTaskDialogBody({
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.priority,
    required this.status,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onPrioritySelected,
    required this.onStatusSelected,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String priority;
  final String status;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final ValueChanged<String> onPrioritySelected;
  final ValueChanged<String> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WorkspaceCreationModalWrapper(
      title: l10n.workspacesCreateTaskTitle,
      subtitle: l10n.workspacesCreateTaskSubtitle,
      icon: WorkspaceIcons.tasks,
      accentColor: context.colors.primary,
      isSubmitting: isSubmitting,
      onSubmit: onSubmit,
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TaskTextField(
              label: l10n.workspacesTaskTitleLabel,
              controller: titleController,
              hintText: l10n.workspacesTaskTitleHint,
              autofocus: true,
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.workspacesTaskTitleRequired
                  : null,
              onSubmitted: (_) => onSubmit(),
            ),
            Gaps.h12,
            _TaskTextField(
              label: l10n.workspacesTaskDescriptionLabel,
              controller: descriptionController,
              hintText: l10n.workspacesTaskDescriptionHint,
              maxLines: 3,
            ),
            Gaps.h12,
            Row(
              children: [
                Expanded(
                  child: _TaskDropdown(
                    label: l10n.workspacesTaskPriorityLabel,
                    value: priority,
                    values: const ['Low', 'Normal', 'High', 'Critical'],
                    labels: [
                      l10n.workspacesTaskPriorityLow,
                      l10n.workspacesTaskPriorityNormal,
                      l10n.workspacesTaskPriorityHigh,
                      l10n.workspacesTaskPriorityCritical,
                    ],
                    onChanged: onPrioritySelected,
                  ),
                ),
                Gaps.w12,
                Expanded(
                  child: _TaskDropdown(
                    label: l10n.workspacesTaskStatusLabel,
                    value: status,
                    values: const ['Todo', 'InProgress', 'Backlog'],
                    labels: [
                      l10n.workspacesTaskStatusTodo,
                      l10n.workspacesTaskStatusInProgress,
                      l10n.workspacesTaskStatusBacklog,
                    ],
                    onChanged: onStatusSelected,
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

final class _TaskTextField extends StatelessWidget {
  const _TaskTextField({
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
        Text(label, style: _TaskDialogTextStyles.label(context)),
        Gaps.h6,
        TextFormField(
          controller: controller,
          autofocus: autofocus,
          maxLines: maxLines,
          validator: validator,
          onFieldSubmitted: onSubmitted,
          style: context.text.bodySmall?.copyWith(fontSize: 13),
          decoration: _TaskDialogTextStyles.inputDecoration(context, hintText),
        ),
      ],
    );
  }
}

final class _TaskDropdown extends StatelessWidget {
  const _TaskDropdown({
    required this.label,
    required this.value,
    required this.values,
    required this.labels,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> values;
  final List<String> labels;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _TaskDialogTextStyles.label(context)),
        Gaps.h6,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: .7),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: context.text.bodySmall?.copyWith(fontSize: 13),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              items: List.generate(
                values.length,
                (index) => DropdownMenuItem(
                  value: values[index],
                  child: Text(
                    labels[index],
                    style: const TextStyle(fontSize: 12.5),
                  ),
                ),
              ),
              onChanged: (next) {
                if (next != null) onChanged(next);
              },
            ),
          ),
        ),
      ],
    );
  }
}

final class _TaskDialogTextStyles {
  const _TaskDialogTextStyles._();

  static TextStyle? label(BuildContext context) {
    return context.text.labelSmall?.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 12,
      color: context.colors.onSurfaceVariant,
    );
  }

  static InputDecoration inputDecoration(
    BuildContext context,
    String hintText,
  ) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: context.text.bodySmall?.copyWith(
        fontSize: 12.5,
        color: context.colors.onSurfaceVariant.withValues(alpha: .6),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: context.colors.outlineVariant.withValues(alpha: .7),
        ),
      ),
      contentPadding: const EdgeInsets.all(12),
    );
  }
}
