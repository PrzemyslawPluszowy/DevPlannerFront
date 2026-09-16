import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/models/task_list_view_snapshot.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Wynik działania dialogu tworzenia/edycji nazwy widoku.
@immutable
final class TaskSavedViewNameDialogResult {
  const TaskSavedViewNameDialogResult.save(this.name)
    : openConfigurator = false;
  const TaskSavedViewNameDialogResult.configure(this.name)
    : openConfigurator = true;

  final String name;
  final bool openConfigurator;
}

/// Dialog zapisu bieżącego widoku z podsumowaniem snapshotu i opcjonalnym przejściem do edytora.
class TaskSavedViewNameDialog extends StatefulWidget {
  const TaskSavedViewNameDialog({
    this.initialName,
    this.snapshot,
    this.title,
    this.submitLabel,
    this.allowConfigure = true,
    super.key,
  });

  final String? initialName;
  final TaskListViewSnapshot? snapshot;
  final String? title;
  final String? submitLabel;
  final bool allowConfigure;

  static Future<TaskSavedViewNameDialogResult?> show(
    BuildContext context, {
    String? initialName,
    TaskListViewSnapshot? snapshot,
    String? title,
    String? submitLabel,
    bool allowConfigure = true,
  }) => showDialog<TaskSavedViewNameDialogResult>(
    context: context,
    builder: (context) => TaskSavedViewNameDialog(
      initialName: initialName,
      snapshot: snapshot,
      title: title,
      submitLabel: submitLabel,
      allowConfigure: allowConfigure,
    ),
  );

  @override
  State<TaskSavedViewNameDialog> createState() =>
      _TaskSavedViewNameDialogState();
}

class _TaskSavedViewNameDialogState extends State<TaskSavedViewNameDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAndSubmit({required bool openConfigurator}) {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _errorText = 'Nazwa widoku nie może być pusta');
      return;
    }
    if (text.length > 120) {
      setState(() => _errorText = 'Maksymalnie 120 znaków');
      return;
    }
    Navigator.of(context).pop(
      openConfigurator
          ? TaskSavedViewNameDialogResult.configure(text)
          : TaskSavedViewNameDialogResult.save(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final snapshot = widget.snapshot;

    return WorkspaceCreationModalWrapper(
      title:
          widget.title ??
          (widget.initialName == null
              ? 'Zapisz bieżący widok'
              : l10n.tasksSavedViewsRename),
      subtitle: l10n.tasksSavedViewsName,
      icon: Symbols.bookmark_rounded,
      accentColor: colors.primary,
      submitLabel: widget.submitLabel ?? l10n.save,
      cancelLabel: l10n.cancel,
      maxWidth: 440,
      onSubmit: () => _validateAndSubmit(openConfigurator: false),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            maxLength: 120,
            decoration: InputDecoration(
              hintText: l10n.tasksSavedViewsName,
              errorText: _errorText,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p12,
              ),
            ),
            onChanged: (_) {
              if (_errorText != null) setState(() => _errorText = null);
            },
            onSubmitted: (_) => _validateAndSubmit(openConfigurator: false),
          ),
          if (snapshot != null) ...[
            const SizedBox(height: Sizes.p8),
            Container(
              padding: const EdgeInsets.all(Sizes.p12),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Konfiguracja do zapisania:',
                    style: context.text.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _SnapshotSummaryRow(
                    icon: Symbols.filter_alt_rounded,
                    label: snapshot.activeFiltersCount == 0
                        ? 'Brak aktywnych filtrów'
                        : 'Aktywne filtry: ${snapshot.activeFiltersCount}',
                  ),
                  _SnapshotSummaryRow(
                    icon: Symbols.view_column_rounded,
                    label:
                        'Kolumny: ${snapshot.columns.length + snapshot.customFieldIds.length}',
                  ),
                  _SnapshotSummaryRow(
                    icon: Symbols.sort_rounded,
                    label:
                        'Sortowanie: ${snapshot.sortField.name} (${snapshot.sortDirection.name})',
                  ),
                  _SnapshotSummaryRow(
                    icon: Symbols.grid_view_rounded,
                    label: 'Grupowanie: ${snapshot.groupBy.name}',
                  ),
                ],
              ),
            ),
          ],
          if (widget.allowConfigure && snapshot != null) ...[
            const SizedBox(height: Sizes.p12),
            OutlinedButton.icon(
              icon: const Icon(Symbols.tune_rounded, size: 18),
              label: const Text('Skonfiguruj przed zapisem'),
              onPressed: () => _validateAndSubmit(openConfigurator: true),
            ),
          ],
        ],
      ),
    );
  }
}

class _SnapshotSummaryRow extends StatelessWidget {
  const _SnapshotSummaryRow({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: colors.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: context.text.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
