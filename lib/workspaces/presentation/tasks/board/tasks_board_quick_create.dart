part of 'tasks_board_page.dart';

/// Inline tworzenie zadania w systemowej kolumnie Kanbana.
///
/// Zapewnia elegancki, zwarty widok dodawania zadania w stylu ClickUp/Linear/Asana:
/// - W spoczynku: subtelny wiersz pełnej szerokości kolumny z ikoną i etykietą oraz dostępem do szablonów.
/// - W trakcie edycji: karta wprowadzania w stylistyce kolumny z obsługą klawiatury (`Enter` / `Escape`).
class _QuickCreateTask extends StatefulWidget {
  const _QuickCreateTask({required this.column});

  final KanbanColumnResponse column;

  @override
  State<_QuickCreateTask> createState() => _QuickCreateTaskState();
}

class _QuickCreateTaskState extends State<_QuickCreateTask> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  var _editing = false;
  var _submitting = false;
  String? _selectedTemplateId;
  bool _useDefaultTemplate = true;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    if (!_editing) {
      return Padding(
        padding: const .fromLTRB(8, 2, 8, 8),
        child: Material(
          color: Colors.transparent,
          borderRadius: .circular(Sizes.p8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              setState(() {
                _editing = true;
                _selectedTemplateId = null;
                _useDefaultTemplate = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _focusNode.requestFocus();
              });
            },
            hoverColor: colors.surfaceContainerHighest.withValues(alpha: .45),
            child: Container(
              height: 34,
              padding: const .symmetric(horizontal: Sizes.p8),
              decoration: BoxDecoration(
                borderRadius: .circular(Sizes.p8),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.add_rounded,
                    size: Sizes.p18,
                    color: colors.onSurfaceVariant.withValues(alpha: .75),
                  ),
                  const SizedBox(width: Sizes.p6),
                  Expanded(
                    child: Text(
                      context.l10n.tasksQuickCreate,
                      style: context.text.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.onSurfaceVariant.withValues(alpha: .85),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tasksTemplatesUse,
                    child: InkWell(
                      onTap: _showTemplates,
                      borderRadius: .circular(Sizes.p6),
                      hoverColor: colors.primary.withValues(alpha: .12),
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
      );
    }

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
        _selectedTemplateId ?? (_useDefaultTemplate ? defaultTemplateId : null);
    final activeTemplate = effectiveTemplateId != null
        ? templates.where((t) => t.id == effectiveTemplateId).firstOrNull
        : null;

    final templateLabel = activeTemplate != null
        ? l10n.tasksTemplateDefaultChip(activeTemplate.name)
        : (!_useDefaultTemplate
              ? l10n.tasksTemplateNoTemplate
              : (defaultTemplateId != null
                    ? l10n.tasksTemplateUsingDefault
                    : null));

    return Padding(
      padding: const .fromLTRB(8, 2, 8, 8),
      child: Focus(
        onKeyEvent: (_, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape && !_submitting) {
              setState(() => _editing = false);
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.enter &&
                !HardwareKeyboard.instance.isShiftPressed &&
                !_submitting) {
              unawaited(_submit());
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: .circular(KanbanCardTokens.cardRadius),
            border: .all(
              color: colors.primary.withValues(alpha: .5),
              width: 1.0,
            ),
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
              if (templateLabel != null || templates.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Builder(
                    builder: (buttonContext) => InkWell(
                      onTap: _submitting
                          ? null
                          : () async {
                              final choice = await TaskContextMenu.show<String?>(
                                context,
                                position: TaskContextMenu.positionFor(
                                  buttonContext,
                                ),
                                items: [
                                  for (final t in templates)
                                    TaskContextMenuItem<String?>(
                                      value: t.id,
                                      title: t.name,
                                      icon: t.id == defaultTemplateId
                                          ? Symbols.star_rounded
                                          : Symbols.auto_awesome_mosaic_rounded,
                                      iconColor: t.id == defaultTemplateId
                                          ? colors.primary
                                          : null,
                                      isSelected: t.id == effectiveTemplateId,
                                    ),
                                  TaskContextMenuItem<String?>(
                                    value: 'none',
                                    title: l10n.tasksTemplateNoTemplate,
                                    icon: Symbols.block_rounded,
                                    isSelected: !_useDefaultTemplate,
                                  ),
                                  TaskContextMenuItem<String?>(
                                    value: 'manage',
                                    title: l10n.tasksTemplatesManage,
                                    icon: Symbols.tune_rounded,
                                  ),
                                ],
                              );
                              if (!mounted || choice == null) return;
                              if (choice == 'manage') {
                                unawaited(_showTemplates());
                              } else if (choice == 'none') {
                                setState(() {
                                  _selectedTemplateId = null;
                                  _useDefaultTemplate = false;
                                });
                              } else {
                                setState(() {
                                  _selectedTemplateId = choice;
                                  _useDefaultTemplate = false;
                                });
                              }
                            },
                      borderRadius: .circular(Sizes.p6),
                      child: Container(
                        padding: const .symmetric(
                          horizontal: Sizes.p6,
                          vertical: 2,
                        ),
                        margin: const .only(bottom: Sizes.p6),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: .08),
                          borderRadius: .circular(Sizes.p6),
                        ),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Icon(
                              Symbols.auto_awesome_mosaic_rounded,
                              size: 13,
                              color: colors.primary,
                            ),
                            const SizedBox(width: Sizes.p4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 160),
                              child: Text(
                                templateLabel ?? l10n.tasksTemplatesUse,
                                style: context.text.labelSmall?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Symbols.arrow_drop_down_rounded,
                              size: 14,
                              color: colors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                enabled: !_submitting,
                maxLines: 3,
                minLines: 1,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: colors.onSurface,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!_submitting) unawaited(_submit());
                },
                decoration: InputDecoration(
                  hintText: context.l10n.tasksQuickCreateHint,
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
                    onPressed: _submitting
                        ? null
                        : () => setState(() => _editing = false),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const .symmetric(horizontal: Sizes.p8),
                      minimumSize: const Size(0, 28),
                    ),
                    child: Text(
                      context.l10n.cancel,
                      style: context.text.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.p6),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const .symmetric(horizontal: Sizes.p12),
                      minimumSize: const Size(0, 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(Sizes.p6),
                      ),
                    ),
                    child: _submitting
                        ? SizedBox.square(
                            dimension: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.onPrimary,
                            ),
                          )
                        : Text(
                            context.l10n.create,
                            style: context.text.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.onPrimary,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (_submitting || text.isEmpty) return;
    setState(() => _submitting = true);
    final created = await context.read<TasksBoardCubit>().createQuickTask(
      column: widget.column,
      title: text,
      taskTemplateId: _selectedTemplateId,
      useDefaultTemplate: _useDefaultTemplate,
    );
    if (!mounted) return;
    if (created) {
      setState(() {
        _submitting = false;
        _editing = false;
        _selectedTemplateId = null;
        _useDefaultTemplate = true;
        _controller.clear();
      });
    } else {
      setState(() => _submitting = false);
    }
  }

  Future<void> _showTemplates() => _showTaskTemplatePicker(context);
}
