import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/task_time_entry_error_banner.dart';

class TaskTimeEntryReviewDialog extends StatefulWidget {
  const TaskTimeEntryReviewDialog({
    required this.entry,
    required this.approve,
    super.key,
  });

  final TaskTimeEntryResponse entry;
  final bool approve;

  @override
  State<TaskTimeEntryReviewDialog> createState() =>
      TaskTimeEntryReviewDialogState();
}

class TaskTimeEntryReviewDialogState extends State<TaskTimeEntryReviewDialog> {
  TaskDetailDraftRegistration? _draft;
  final _comment = TextEditingController();
  final ValueNotifier<bool> _saving = ValueNotifier(false);

  String get _title => widget.approve
      ? context.l10n.taskDetailsTimeApprove
      : context.l10n.taskDetailsTimeReject;

  @override
  void initState() {
    super.initState();
    _comment.addListener(_refreshDraft);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: _title,
    );
  }

  void _refreshDraft() {
    if (_comment.text.trim().isEmpty) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _comment.removeListener(_refreshDraft);
    _comment.dispose();
    _saving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskTimeTrackingCubit, TaskTimeTrackingState>(
        builder: (context, state) => AnimatedBuilder(
          animation: _saving,
          builder: (context, _) => WorkspaceCreationModalWrapper(
            title: _title,
            icon: widget.approve
                ? Symbols.check_circle_rounded
                : Symbols.cancel_rounded,
            accentColor: context.tasksTheme.selectionAccent,
            isSubmitting: _saving.value,
            submitLabel: _title,
            cancelLabel: context.l10n.cancel,
            onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
              context,
              _draft,
            ),
            onSubmit: state.isRetryBlocked || _saving.value ? null : _review,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.taskDetailsTimeReviewComment,
                  style: context.tasksTheme.controlText,
                ),
                Gaps.h8,
                TextField(
                  controller: _comment,
                  maxLines: 4,
                  minLines: 2,
                  enabled: !_saving.value,
                  decoration: InputDecoration(
                    hintText: context.l10n.taskDetailsTimeReviewCommentHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        context.tasksTheme.controlRadius,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(Sizes.p12),
                  ),
                ),
                const TaskTimeEntryErrorBanner(),
              ],
            ),
          ),
        ),
      );

  Future<void> _review() async {
    if (_saving.value) return;
    _saving.value = true;
    final sourceContext = context;
    final cubit = sourceContext.read<TaskTimeTrackingCubit>();
    final comment = _comment.text.trim();
    try {
      final saved = widget.approve
          ? await cubit.approve(
              widget.entry,
              comment: comment.isEmpty ? null : comment,
            )
          : await cubit.reject(
              widget.entry,
              comment: comment.isEmpty ? null : comment,
            );
      if (!mounted ||
          !sourceContext.mounted ||
          cubit.isClosed ||
          !identical(sourceContext.read<TaskTimeTrackingCubit>(), cubit) ||
          !saved) {
        return;
      }
      _draft?.clear();
      Navigator.of(context).pop();
    } finally {
      if (mounted) _saving.value = false;
    }
  }
}
