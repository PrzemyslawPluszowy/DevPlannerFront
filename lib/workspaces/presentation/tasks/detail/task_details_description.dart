part of 'task_details_page.dart';

/// Renderuje i edytuje opis zadania jako Quill Delta — nie redukuje go do
/// zwykłego tekstu, dzięki czemu istniejące formatowanie nie jest tracone.
class _TaskDescriptionSection extends StatelessWidget {
  const _TaskDescriptionSection({required this.task, required this.isSaving});

  final ProjectTaskResponse task;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.taskDetailsDescription,
    action: IconButton(
      tooltip: context.l10n.taskDetailsEditDescription,
      onPressed: isSaving
          ? null
          : () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: _EditTaskDescriptionDialog(task: task),
              ),
            ),
      icon: const Icon(Symbols.edit_note_rounded, size: 21),
    ),
    child: _TaskDescriptionPreview(task: task),
  );
}

class _TaskDescriptionPreview extends StatefulWidget {
  const _TaskDescriptionPreview({required this.task});

  final ProjectTaskResponse task;

  @override
  State<_TaskDescriptionPreview> createState() =>
      _TaskDescriptionPreviewState();
}

class _TaskDescriptionPreviewState extends State<_TaskDescriptionPreview> {
  late final quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _controllerForTask(widget.task);
    _controller.readOnly = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmptyDocument(_controller.document)) {
      return Text(
        context.l10n.taskDetailsNoDescription,
        style: context.text.bodyMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IgnorePointer(
          child: quill.QuillEditor.basic(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}

class _EditTaskDescriptionDialog extends StatefulWidget {
  const _EditTaskDescriptionDialog({required this.task});

  final ProjectTaskResponse task;

  @override
  State<_EditTaskDescriptionDialog> createState() =>
      _EditTaskDescriptionDialogState();
}

class _EditTaskDescriptionDialogState
    extends State<_EditTaskDescriptionDialog> {
  late final quill.QuillController _controller;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  var _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = _controllerForTask(widget.task);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => WorkspaceCreationModalWrapper(
    title: context.l10n.taskDetailsEditDescription,
    icon: Symbols.description_rounded,
    accentColor: context.colors.primary,
    isSubmitting: _saving,
    submitLabel: context.l10n.save,
    cancelLabel: context.l10n.cancel,
    maxWidth: 780,
    onSubmit: _saving ? null : _save,
    body: SizedBox(
      height: 480,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.colors.outlineVariant),
              ),
            ),
            child: quill.QuillSimpleToolbar(
              controller: _controller,
              config: const quill.QuillSimpleToolbarConfig(
                multiRowsDisplay: false,
                showFontFamily: false,
                showFontSize: false,
                showCodeBlock: false,
                showSearchButton: false,
                showInlineCode: false,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: quill.QuillEditor(
                controller: _controller,
                focusNode: _focusNode,
                scrollController: _scrollController,
                config: const quill.QuillEditorConfig(
                  padding: EdgeInsets.all(14),
                  autoFocus: true,
                  expands: true,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _save() async {
    setState(() => _saving = true);
    final document = _controller.document;
    final saved = await context.read<TaskDetailsCubit>().updateDescription(
      description: document.toPlainText(),
      descriptionDeltaJson: jsonEncode(document.toDelta().toJson()),
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }
}

quill.QuillController _controllerForTask(ProjectTaskResponse task) {
  final delta = task.descriptionDeltaJson;
  if (delta != null && delta.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(delta);
      if (decoded is List) {
        return quill.QuillController(
          document: quill.Document.fromJson(decoded),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } on FormatException {
      // Stary lub niepoprawny Delta nie może uniemożliwić odczytu zadania.
    }
  }
  return quill.QuillController(
    document: quill.Document()..insert(0, task.description ?? ''),
    selection: const TextSelection.collapsed(offset: 0),
  );
}

bool _isEmptyDocument(quill.Document document) =>
    document.toPlainText().trim().isEmpty;
