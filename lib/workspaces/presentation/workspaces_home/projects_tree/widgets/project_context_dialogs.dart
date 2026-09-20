import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:flutter/material.dart';

/// Potwierdzenia i formularze akcji projektu z menu kontekstowego.
///
/// Dialog nie wykonuje żadnego żądania: zwraca decyzję użytkownika, a operację
/// wykonuje właściciel stanu (drzewo projektów), więc rollback i błąd trwały
/// pozostają w jednym miejscu.
abstract final class ProjectContextDialogs {
  /// Potwierdzenie archiwizacji wraz z opisem skutków.
  static Future<bool> confirmArchive({
    required BuildContext context,
    required ProjectListItem project,
  }) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.projectsArchiveConfirmTitle),
        content: Text(
          l10n.projectsArchiveConfirmBody(project.name),
          style: context.text.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.projectsDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.projectsArchiveConfirmAction),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Potwierdzenie trwałego usunięcia z ponownym wpisaniem nazwy projektu.
  static Future<bool> confirmDeletePermanently({
    required BuildContext context,
    required ProjectListItem project,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _DeleteProjectDialog(project: project),
    );
    return confirmed ?? false;
  }

  /// Potwierdzenie opuszczenia jawnego członkostwa projektu.
  ///
  /// Decyzja jest nieodwracalna z tego miejsca, więc menu nie wykonuje jej
  /// bez świadomego potwierdzenia użytkownika.
  static Future<bool> confirmLeave({
    required BuildContext context,
    required ProjectListItem project,
  }) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.projectsLeaveConfirmTitle),
        content: Text(
          l10n.projectsLeaveConfirmBody(project.name),
          style: context.text.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.projectsDialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.projectsLeaveConfirmAction),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  /// Nazwa nowego szablonu tworzonego z projektu.
  static Future<String?> askTemplateName({
    required BuildContext context,
    required ProjectListItem project,
  }) => showDialog<String>(
    context: context,
    builder: (context) => _CreateTemplateDialog(project: project),
  );
}

class _DeleteProjectDialog extends StatefulWidget {
  const _DeleteProjectDialog({required this.project});

  final ProjectListItem project;

  @override
  State<_DeleteProjectDialog> createState() => _DeleteProjectDialogState();
}

class _DeleteProjectDialogState extends State<_DeleteProjectDialog> {
  late final TextEditingController _controller = TextEditingController();
  bool _matches = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChanged);
  }

  void _handleChanged() {
    final matches = _controller.text.trim() == widget.project.name;
    if (matches == _matches) return;
    setState(() => _matches = matches);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.projectsDeleteConfirmTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.projectsDeleteConfirmBody(widget.project.name),
            style: context.text.bodyMedium,
          ),
          Gaps.h16,
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.projectsDeleteConfirmFieldLabel,
              errorText: _controller.text.isEmpty || _matches
                  ? null
                  : l10n.projectsDeleteConfirmMismatch,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.projectsDialogCancel),
        ),
        FilledButton(
          onPressed: _matches ? () => Navigator.of(context).pop(true) : null,
          child: Text(l10n.projectsDeleteConfirmAction),
        ),
      ],
    );
  }
}

class _CreateTemplateDialog extends StatefulWidget {
  const _CreateTemplateDialog({required this.project});

  final ProjectListItem project;

  @override
  State<_CreateTemplateDialog> createState() => _CreateTemplateDialogState();
}

class _CreateTemplateDialogState extends State<_CreateTemplateDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _showError = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.projectsTemplateDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.projectsTemplateDialogBody(widget.project.name),
            style: context.text.bodyMedium,
          ),
          Gaps.h16,
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.projectsTemplateNameLabel,
              errorText: _showError ? l10n.projectsTemplateNameRequired : null,
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.projectsDialogCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.projectsTemplateCreateAction),
        ),
      ],
    );
  }
}
