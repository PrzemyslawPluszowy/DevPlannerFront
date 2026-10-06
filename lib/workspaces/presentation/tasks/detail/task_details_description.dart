import 'package:devplanner/workspaces/presentation/tasks/detail/task_description_toolbar.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;

/// Renderuje i edytuje opis zadania jako Quill Delta — nie redukuje go do
/// zwykłego tekstu, dzięki czemu istniejące formatowanie nie jest tracone.
class TaskDescriptionSection extends StatelessWidget {
  const TaskDescriptionSection({
    required this.task,
    required this.isSaving,
    super.key,
  });

  final ProjectTaskResponse task;
  final bool isSaving;

  @override
  Widget build(BuildContext context) => Section(
    title: context.l10n.taskDetailsDescription,
    action: IconButton(
      tooltip: context.l10n.taskDetailsEditDescription,
      onPressed: isSaving
          ? null
          : () => DevPlannerModalHost.showDialog<void>(
              context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: EditTaskDescriptionDialog(task: task),
              ),
            ),
      icon: const Icon(Symbols.edit_note_rounded, size: 21),
    ),
    child: TaskDescriptionPreview(task: task),
  );
}

class TaskDescriptionPreview extends StatefulWidget {
  const TaskDescriptionPreview({required this.task, super.key});

  final ProjectTaskResponse task;

  @override
  State<TaskDescriptionPreview> createState() => TaskDescriptionPreviewState();
}

class TaskDescriptionPreviewState extends State<TaskDescriptionPreview> {
  late final quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TaskDetailsDescriptionControllerFactory.create(widget.task);
    _controller.readOnly = true;
  }

  @override
  void didUpdateWidget(covariant TaskDescriptionPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.id != widget.task.id ||
        oldWidget.task.description != widget.task.description ||
        oldWidget.task.descriptionDeltaJson !=
            widget.task.descriptionDeltaJson) {
      final previousDocument = _controller.document;
      _controller.document = TaskDetailsDescriptionControllerFactory.document(
        widget.task,
      );
      previousDocument.close();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (TaskDetailsDescriptionControllerFactory.isEmpty(_controller.document)) {
      return Text(
        context.l10n.taskDetailsNoDescription,
        style: context.tasksTheme.dataText.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IgnorePointer(
          child: quill.QuillEditor.basic(
            controller: _controller,
            config: quill.QuillEditorConfig(
              customStyles: quill.DefaultStyles(
                paragraph: quill.DefaultTextBlockStyle(
                  context.tasksTheme.dataText.copyWith(
                    color: context.colors.onSurface,
                  ),
                  quill.HorizontalSpacing.zero,
                  quill.VerticalSpacing.zero,
                  quill.VerticalSpacing.zero,
                  null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditTaskDescriptionDialog extends StatefulWidget {
  const EditTaskDescriptionDialog({required this.task, super.key});

  final ProjectTaskResponse task;

  @override
  State<EditTaskDescriptionDialog> createState() =>
      EditTaskDescriptionDialogState();
}

class EditTaskDescriptionDialogState extends State<EditTaskDescriptionDialog> {
  TaskDetailDraftRegistration? _draft;
  late final quill.QuillController _controller;
  late final String _initialDocument;
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  final ValueNotifier<bool> _saving = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = TaskDetailsDescriptionControllerFactory.create(widget.task);
    _initialDocument = jsonEncode(_controller.document.toDelta().toJson());
    _controller.addListener(_markDraftDirty);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsEditDescription,
    );
  }

  void _markDraftDirty() {
    final current = jsonEncode(_controller.document.toDelta().toJson());
    if (current == _initialDocument) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _controller.removeListener(_markDraftDirty);
    _controller.dispose();
    _saving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _saving,
    builder: (context, isSaving, _) => WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditDescription,
      icon: Symbols.description_rounded,
      accentColor: context.colors.primary,
      isSubmitting: isSaving,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      maxWidth: 780,
      onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
        context,
        _draft,
      ),
      onSubmit: isSaving ? null : _save,
      body: SizedBox(
        height: 480,
        child: ExcludeFocus(
          excluding: isSaving,
          child: AbsorbPointer(
            absorbing: isSaving,
            child: Column(
              children: [
                const TaskDetailsDialogMutationError(),
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: context.colors.outlineVariant),
                    ),
                  ),
                  child: TaskDescriptionToolbar(
                    controller: _controller,
                    editorFocusNode: _focusNode,
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
        ),
      ),
    ),
  );

  Future<void> _save() async {
    if (_saving.value) return;
    _saving.value = true;
    _controller.readOnly = true;
    _focusNode.unfocus();
    final document = _controller.document;
    final source = context.read<TaskDetailsCubit>();
    final saved = await source.updateDescription(
      description: document.toPlainText(),
      descriptionDeltaJson: jsonEncode(document.toDelta().toJson()),
    );
    if (!mounted) return;
    if (source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _controller.readOnly = false;
      _saving.value = false;
      return;
    }
    if (saved) {
      _draft?.clear();
      Navigator.of(context).pop();
    } else {
      _controller.readOnly = false;
      _saving.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_saving.value) _focusNode.requestFocus();
      });
    }
  }
}

/// Tworzy kontroler Quill z Delta albo bezpiecznym tekstowym fallbackiem.
final class TaskDetailsDescriptionControllerFactory {
  const TaskDetailsDescriptionControllerFactory._();

  static quill.QuillController create(ProjectTaskResponse task) =>
      quill.QuillController(
        document: document(task),
        selection: const TextSelection.collapsed(offset: 0),
      );

  static quill.Document document(ProjectTaskResponse task) {
    final delta = task.descriptionDeltaJson;
    if (delta != null && delta.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(delta);
        if (decoded is List) {
          return quill.Document.fromJson(decoded);
        }
      } on FormatException {
        // Stary lub niepoprawny Delta nie może uniemożliwić odczytu zadania.
      }
    }
    return quill.Document()..insert(0, task.description ?? '');
  }

  static bool isEmpty(quill.Document document) =>
      document.toPlainText().trim().isEmpty;
}
