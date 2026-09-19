part of 'tasks_board_page.dart';

/// Szybkie tworzenie zadania z menu wyboru szablonu.
class _HeaderCreateActions extends StatelessWidget {
  const _HeaderCreateActions({
    required this.state,
    this.isCompact = false,
  });

  final TasksBoardReady state;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEnabled = state.board.columns.isNotEmpty;

    return Semantics(
      button: true,
      label: context.l10n.tasksQuickCreate,
      child: Material(
        color: isEnabled ? colors.primary : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Sizes.p8),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Główny przycisk szybkiego tworzenia zadania
              Tooltip(
                message: context.l10n.tasksQuickCreate,
                child: InkWell(
                  onTap: isEnabled
                      ? () => unawaited(
                          _HeaderCreateActions.showQuickCreate(context, state),
                        )
                      : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? Sizes.p10 : Sizes.p12,
                      vertical: Sizes.p8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Symbols.add_rounded,
                          size: Sizes.p18,
                          color: isEnabled
                              ? colors.onPrimary
                              : colors.onSurfaceVariant.withValues(alpha: .4),
                        ),
                        if (!isCompact) ...[
                          const SizedBox(width: Sizes.p6),
                          Text(
                            context.l10n.tasksQuickCreate,
                            style: context.text.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isEnabled
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant.withValues(
                                      alpha: .4,
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              // Subtelny separator 1 px
              VerticalDivider(
                width: 1,
                thickness: 1,
                indent: 6,
                endIndent: 6,
                color: isEnabled
                    ? colors.onPrimary.withValues(alpha: .25)
                    : colors.outlineVariant.withValues(alpha: .3),
              ),

              // Menu wyboru szablonów / dodatkowych akcji
              Builder(
                builder: (buttonContext) => Tooltip(
                  message: context.l10n.tasksTemplatesUse,
                  child: InkWell(
                    onTap: isEnabled
                        ? () async {
                            final action =
                                await TaskContextMenu.show<_HeaderCreateAction>(
                                  context,
                                  position: TaskContextMenu.positionFor(
                                    buttonContext,
                                  ),
                                  items: [
                                    TaskContextMenuItem<_HeaderCreateAction>(
                                      value: _HeaderCreateAction.fromTemplate,
                                      icon: Symbols.auto_awesome_mosaic_rounded,
                                      title: context.l10n.tasksTemplatesUse,
                                    ),
                                  ],
                                );
                            if (action == _HeaderCreateAction.fromTemplate &&
                                context.mounted) {
                              unawaited(
                                TaskTemplatePickerOverlay.show(context),
                              );
                            }
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.p6,
                        vertical: Sizes.p8,
                      ),
                      child: Icon(
                        Symbols.arrow_drop_down_rounded,
                        size: Sizes.p20,
                        color: isEnabled
                            ? colors.onPrimary
                            : colors.onSurfaceVariant.withValues(alpha: .4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showQuickCreate(
    BuildContext context,
    TasksBoardReady state,
  ) async {
    final availableColumns = state.board.columns.toList(growable: false);
    if (availableColumns.isEmpty) return;
    final pickerCubit = context.read<TaskTemplatePickerCubit>();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: pickerCubit,
        child: TaskQuickCreateDialog(
          columns: availableColumns,
          onCreate:
              ({
                required title,
                required column,
                taskTemplateId,
                useDefaultTemplate = true,
              }) => context.read<TasksBoardCubit>().createQuickTask(
                column: column,
                title: title,
                taskTemplateId: taskTemplateId,
                useDefaultTemplate: useDefaultTemplate,
              ),
        ),
      ),
    );
  }
}

enum _HeaderCreateAction { fromTemplate }
