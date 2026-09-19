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

/// Formularz tworzenia strony Wiki; repozytorium wywołuje Cubit komendy.
final class CreateWikiPageDialog extends StatelessWidget {
  const CreateWikiPageDialog({
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
      create: (_) => CreateWikiPageCommandCubit(repository),
      child: _CreateWikiPageForm(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    );
  }
}

final class _CreateWikiPageForm extends StatefulWidget {
  const _CreateWikiPageForm({
    required this.workspaceId,
    required this.projectId,
  });

  final String workspaceId;
  final String projectId;

  @override
  State<_CreateWikiPageForm> createState() => _CreateWikiPageFormState();
}

final class _CreateWikiPageFormState extends State<_CreateWikiPageForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    unawaited(
      context.read<CreateWikiPageCommandCubit>().submit(
        workspaceId: widget.workspaceId,
        projectId: widget.projectId,
        title: _titleController.text.trim(),
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
    final pageId = state.createdResourceId;
    if (pageId == null) return;
    Navigator.of(context).pop();
    unawaited(
      context.plannerNavigation.go(
        '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/wiki/pages/$pageId',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<
      CreateWikiPageCommandCubit,
      ProjectResourceCreationCommandState
    >(
      listener: _handleCommand,
      builder: (context, state) => WorkspaceCreationModalWrapper(
        title: l10n.workspacesCreateWikiTitle,
        subtitle: l10n.workspacesCreateWikiSubtitle,
        icon: WorkspaceIcons.wiki,
        accentColor: const Color(0xFF0284C7),
        isSubmitting: state.isSubmitting,
        onSubmit: _submit,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.workspacesWikiTitleLabel,
                style: context.text.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              Gaps.h6,
              TextFormField(
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.workspacesWikiTitleHint,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: Sizes.p12,
                    vertical: Sizes.p10,
                  ),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.workspacesWikiTitleRequired
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
