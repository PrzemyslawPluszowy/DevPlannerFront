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

/// Formularz tworzenia folderu; zapis pozostaje w Cubicie komendy Storage.
final class CreateFolderDialog extends StatelessWidget {
  const CreateFolderDialog({
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
      create: (_) => CreateProjectFolderCommandCubit(repository),
      child: _CreateFolderForm(workspaceId: workspaceId, projectId: projectId),
    );
  }
}

final class _CreateFolderForm extends StatefulWidget {
  const _CreateFolderForm({required this.workspaceId, required this.projectId});

  final String workspaceId;
  final String projectId;

  @override
  State<_CreateFolderForm> createState() => _CreateFolderFormState();
}

final class _CreateFolderFormState extends State<_CreateFolderForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

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

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    unawaited(
      context.read<CreateProjectFolderCommandCubit>().submit(
        workspaceId: widget.workspaceId,
        projectId: widget.projectId,
        name: _nameController.text.trim(),
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
        '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/files',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<
      CreateProjectFolderCommandCubit,
      ProjectResourceCreationCommandState
    >(
      listener: _handleCommand,
      builder: (context, state) => WorkspaceCreationModalWrapper(
        title: l10n.workspacesCreateFolderTitle,
        subtitle: l10n.workspacesCreateFolderSubtitle,
        icon: WorkspaceIcons.folder,
        accentColor: const Color(0xFFEAB308),
        isSubmitting: state.isSubmitting,
        onSubmit: _submit,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.workspacesFolderNameLabel,
                style: context.text.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              Gaps.h6,
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.workspacesFolderNameHint,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p12,
                    vertical: Sizes.p10,
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.workspacesFolderNameRequired
                    : null,
                onFieldSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
