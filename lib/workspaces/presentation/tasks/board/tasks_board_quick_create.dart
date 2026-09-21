part of 'tasks_board_page.dart';

/// Inline tworzenie zadania w systemowej kolumnie Kanbana.
class _QuickCreateTask extends StatefulWidget {
  const _QuickCreateTask({required this.column});

  final KanbanColumnResponse column;

  @override
  State<_QuickCreateTask> createState() => _QuickCreateTaskState();
}

class _QuickCreateTaskState extends State<_QuickCreateTask> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<_QuickCreateTaskViewState> _viewState = ValueNotifier(
    const _QuickCreateTaskViewState(),
  );

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _viewState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_QuickCreateTaskViewState>(
        valueListenable: _viewState,
        builder: (context, viewState, _) =>
            _buildQuickCreate(context, viewState),
      );

  Widget _buildQuickCreate(
    BuildContext context,
    _QuickCreateTaskViewState viewState,
  ) {
    final colors = context.colors;
    final l10n = context.l10n;
    if (!viewState.editing) return _buildTrigger(context, colors);

    final pickerState = context.watch<TaskTemplatePickerCubit?>()?.state;
    final templates = switch (pickerState) {
      TaskTemplatePickerReady(:final templates) => templates,
      _ => const <TaskTemplateResponse>[],
    };
    final defaultTemplateId = switch (pickerState) {
      TaskTemplatePickerReady(:final defaultTemplateId) => defaultTemplateId,
      _ => null,
    };
    final effectiveTemplateId =
        viewState.selectedTemplateId ??
        (viewState.useDefaultTemplate ? defaultTemplateId : null);
    final activeTemplate = effectiveTemplateId == null
        ? null
        : templates
              .where((template) => template.id == effectiveTemplateId)
              .firstOrNull;
    final templateLabel = activeTemplate != null
        ? l10n.tasksTemplateDefaultChip(activeTemplate.name)
        : !viewState.useDefaultTemplate
        ? l10n.tasksTemplateNoTemplate
        : defaultTemplateId == null
        ? null
        : l10n.tasksTemplateUsingDefault;

    return Padding(
      padding: const .fromLTRB(8, 2, 8, 8),
      child: Focus(
        onKeyEvent: (_, event) => _handleKey(event, viewState),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(KanbanCardTokens.cardRadius),
            border: .all(color: colors.primary.withValues(alpha: .5)),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: .04),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const .fromLTRB(10, 8, 8, 8),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (templateLabel != null || templates.isNotEmpty)
                TaskBoardTemplateChoiceButton(
                  label: templateLabel ?? l10n.tasksTemplatesUse,
                  templates: templates,
                  defaultTemplateId: defaultTemplateId,
                  effectiveTemplateId: effectiveTemplateId,
                  useDefaultTemplate: viewState.useDefaultTemplate,
                  disabled: viewState.submitting,
                  onSelected: _selectTemplate,
                  onManage: _showTemplates,
                ),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                enabled: !viewState.submitting,
                maxLines: 3,
                minLines: 1,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: colors.onSurface,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!viewState.submitting) unawaited(_submit());
                },
                decoration: InputDecoration(
                  hintText: l10n.tasksQuickCreateHint,
                  hintStyle: context.text.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant.withValues(alpha: .5),
                    fontSize: 14,
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: Sizes.p8),
              Row(
                children: [
                  Text(
                    'Esc, ↵',
                    style: context.text.labelSmall?.copyWith(
                      fontSize: 11,
                      color: colors.onSurfaceVariant.withValues(alpha: .5),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: viewState.submitting ? null : _closeEditor,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const .symmetric(horizontal: Sizes.p8),
                      minimumSize: const Size(0, 28),
                    ),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: Sizes.p6),
                  FilledButton(
                    onPressed: viewState.submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const .symmetric(horizontal: Sizes.p12),
                      minimumSize: const Size(0, 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(Sizes.p6),
                      ),
                    ),
                    child: viewState.submitting
                        ? SizedBox.square(
                            dimension: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.onPrimary,
                            ),
                          )
                        : Text(l10n.create),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrigger(BuildContext context, ColorScheme colors) => Padding(
    padding: const .fromLTRB(8, 2, 8, 8),
    child: Material(
      color: Colors.transparent,
      borderRadius: .circular(Sizes.p8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _viewState.value = const _QuickCreateTaskViewState(editing: true);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _focusNode.requestFocus();
          });
        },
        hoverColor: colors.primary.withValues(alpha: .08),
        child: SizedBox(
          height: 34,
          child: Padding(
            padding: const .symmetric(horizontal: Sizes.p8),
            child: Row(
              children: [
                // Wiersz dodawania jest akcją kolumny, więc nosi kolor akcentu
                // motywu, a nie wyłącznie szarość metadanych.
                Icon(
                  Symbols.add_rounded,
                  size: Sizes.p18,
                  color: colors.primary.withValues(alpha: .9),
                ),
                const SizedBox(width: Sizes.p6),
                Expanded(
                  child: Text(
                    context.l10n.tasksQuickCreate,
                    style: context.text.bodySmall?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.primary.withValues(alpha: .95),
                    ),
                  ),
                ),
                Tooltip(
                  message: context.l10n.tasksTemplatesUse,
                  child: InkWell(
                    onTap: _showTemplates,
                    borderRadius: .circular(Sizes.p6),
                    child: Padding(
                      padding: const .all(Sizes.p4),
                      child: Icon(
                        Symbols.auto_awesome_mosaic_rounded,
                        size: Sizes.p16,
                        color: colors.onSurfaceVariant.withValues(alpha: .6),
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

  KeyEventResult _handleKey(
    KeyEvent event,
    _QuickCreateTaskViewState state,
  ) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.escape && !state.submitting) {
      _closeEditor();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter &&
        !HardwareKeyboard.instance.isShiftPressed &&
        !state.submitting) {
      unawaited(_submit());
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _selectTemplate(String? templateId) {
    _viewState.value = _viewState.value.copyWith(
      selectedTemplateId: templateId,
      clearSelectedTemplateId: templateId == null,
      useDefaultTemplate: false,
    );
  }

  void _closeEditor() {
    _viewState.value = _viewState.value.copyWith(editing: false);
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    final viewState = _viewState.value;
    if (viewState.submitting || title.isEmpty) return;
    _viewState.value = viewState.copyWith(submitting: true);
    final created = await context.read<TasksBoardCubit>().createQuickTask(
      column: widget.column,
      title: title,
      taskTemplateId: viewState.selectedTemplateId,
      useDefaultTemplate: viewState.useDefaultTemplate,
    );
    if (!mounted) return;
    if (created) {
      _viewState.value = const _QuickCreateTaskViewState();
      _controller.clear();
    } else {
      _viewState.value = _viewState.value.copyWith(submitting: false);
    }
  }

  Future<void> _showTemplates() => TaskTemplatePickerOverlay.show(context);
}

class _QuickCreateTaskViewState {
  const _QuickCreateTaskViewState({
    this.editing = false,
    this.submitting = false,
    this.selectedTemplateId,
    this.useDefaultTemplate = true,
  });

  final bool editing;
  final bool submitting;
  final String? selectedTemplateId;
  final bool useDefaultTemplate;

  _QuickCreateTaskViewState copyWith({
    bool? editing,
    bool? submitting,
    String? selectedTemplateId,
    bool clearSelectedTemplateId = false,
    bool? useDefaultTemplate,
  }) => _QuickCreateTaskViewState(
    editing: editing ?? this.editing,
    submitting: submitting ?? this.submitting,
    selectedTemplateId: clearSelectedTemplateId
        ? null
        : selectedTemplateId ?? this.selectedTemplateId,
    useDefaultTemplate: useDefaultTemplate ?? this.useDefaultTemplate,
  );
}
