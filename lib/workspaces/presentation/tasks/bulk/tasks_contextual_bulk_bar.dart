import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Jedna kontekstowa powierzchnia akcji masowych dla Listy i Kanbanu.
///
/// Miejsce paska to drugi wiersz wspólnego nagłówka, więc po zaznaczeniu zadań
/// nad treścią nie pojawia się drugi pasek. Kontrolki przewijają się poziomo i
/// korzystają z tokenów gęstości oraz wspólnego menu kontekstowego; zestaw akcji
/// zależy od widoku i ACL, ale wygląd oraz obsługa pozostają identyczne.
class TasksContextualBulkBar extends StatefulWidget {
  const TasksContextualBulkBar({
    required this.selectedCount,
    required this.controls,
    required this.onClearSelection,
    this.isSaving = false,
    this.errorMessage,
    this.onRetry,
    super.key,
  });

  /// Liczba zaznaczonych zadań.
  final int selectedCount;

  /// Kontrolki akcji zależne od widoku.
  final List<Widget> controls;

  /// Czyści zaznaczenie i zamyka pasek.
  final VoidCallback onClearSelection;
  final bool isSaving;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  State<TasksContextualBulkBar> createState() => _TasksContextualBulkBarState();
}

class _TasksContextualBulkBarState extends State<TasksContextualBulkBar> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showError(BuildContext context) async {
    final message = widget.errorMessage;
    if (message == null || widget.isSaving) return;
    await DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => TasksBulkErrorDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksTheme = context.tasksTheme;
    final colors = context.colors;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: tasksTheme.controlGap,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: tasksTheme.rowSelected,
            borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
          ),
          child: Text(
            context.l10n.tasksBulkSelected(widget.selectedCount),
            style: tasksTheme.controlText.copyWith(color: colors.primary),
          ),
        ),
        SizedBox(width: tasksTheme.controlGap),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 3,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context)
                  .copyWith(scrollbars: false),
              child: SingleChildScrollView(
                controller: _scrollController,
                key: const ValueKey('contextual_bulk_bar'),
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final control in widget.controls) ...[
                      SizedBox(width: tasksTheme.controlGap),
                      control,
                    ],
                    SizedBox(width: tasksTheme.controlGap),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: tasksTheme.controlGap),
        _TasksBulkFeedback(
          isSaving: widget.isSaving,
          errorMessage: widget.errorMessage,
          onShowError: () => _showError(context),
          onRetry: widget.onRetry,
        ),
        IconButton(
          key: const ValueKey('bulk_clear_selection'),
          tooltip: context.l10n.tasksBulkClearSelection,
          visualDensity: VisualDensity.compact,
          iconSize: 16,
          onPressed: widget.isSaving ? null : widget.onClearSelection,
          icon: const Icon(Symbols.close_rounded),
        ),
      ],
    );
  }
}

/// Stałe, kompaktowe miejsce na stan i odzyskanie pracy poza suwakiem akcji.
class _TasksBulkFeedback extends StatelessWidget {
  const _TasksBulkFeedback({
    required this.isSaving,
    required this.errorMessage,
    required this.onShowError,
    required this.onRetry,
  });

  final bool isSaving;
  final String? errorMessage;
  final VoidCallback onShowError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    label: isSaving ? context.l10n.tasksBulkSaving : errorMessage,
    child: SizedBox(
      key: const ValueKey('bulk_feedback'),
      width: 64,
      height: 36,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 32,
            child: isSaving
                ? Tooltip(
                    message: context.l10n.tasksBulkSaving,
                    child: const Center(
                      child: SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : errorMessage == null
                ? const SizedBox.shrink()
                : IconButton(
                    key: const ValueKey('bulk_error_details'),
                    tooltip: errorMessage,
                    padding: EdgeInsets.zero,
                    iconSize: 16,
                    color: context.colors.error,
                    onPressed: onShowError,
                    icon: const Icon(Symbols.error_outline_rounded),
                  ),
          ),
          SizedBox.square(
            dimension: 32,
            child: errorMessage != null && onRetry != null
                ? IconButton(
                    key: const ValueKey('bulk_retry'),
                    tooltip: context.l10n.retry,
                    padding: EdgeInsets.zero,
                    iconSize: 16,
                    onPressed: isSaving ? null : onRetry,
                    icon: const Icon(Symbols.refresh_rounded),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    ),
  );
}

/// Klawisz akcji masowej w kontekstowym pasku.
class TasksBulkButton extends StatefulWidget {
  const TasksBulkButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  State<TasksBulkButton> createState() => _TasksBulkButtonState();
}

class _TasksBulkButtonState extends State<TasksBulkButton> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(skipTraversal: widget.onTap == null);
  }

  @override
  void didUpdateWidget(covariant TasksBulkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _focusNode.skipTraversal = widget.onTap == null;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    final onTap = widget.onTap;
    if (onTap == null) return;
    _focusNode.requestFocus();
    // Menu snapshots primaryFocus synchronously, before pushing its route.
    FocusManager.instance.applyFocusChangesIfNeeded();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final tasksTheme = context.tasksTheme;
    final colors = context.colors;
    final foreground = widget.onTap == null
        ? colors.onSurface.withValues(alpha: .38)
        : widget.isDestructive
        ? colors.error
        : colors.onSurface;

    return Tooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        enabled: widget.onTap != null,
        onTap: widget.onTap == null ? null : _handleTap,
        child: Material(
          color: colors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: .6),
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(tasksTheme.controlRadius),
            focusNode: _focusNode,
            // Keep the current focus during pending preparation. The handler
            // guards disabled activation; traversal and semantics stay disabled.
            excludeFromSemantics: true,
            onTap: _handleTap,
            mouseCursor: widget.onTap == null ? SystemMouseCursors.basic : null,
            hoverColor: widget.onTap == null ? Colors.transparent : null,
            child: Container(
              height: 28,
              padding: EdgeInsets.symmetric(horizontal: tasksTheme.controlGap),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 16, color: foreground),
                  const SizedBox(width: 6),
                  Text(
                    widget.label,
                    style: tasksTheme.controlText.copyWith(color: foreground),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Menu akcji masowej otwierane wspólnym komponentem menu.
class TasksBulkMenu<T> extends StatelessWidget {
  const TasksBulkMenu({
    required this.icon,
    required this.label,
    required this.options,
    required this.onSelected,
    this.isLoading = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final List<AppContextMenuOption<T>> options;
  final ValueChanged<T> onSelected;

  /// Blokuje kontrolkę w trakcie zapisu akcji masowej.
  final bool isLoading;

  Future<void> _openMenu(BuildContext context) async {
    final selected = await AppContextMenu.select<T>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      options: options,
      headerTitle: label,
    );
    if (!context.mounted || selected == null) return;
    onSelected(selected);
  }

  @override
  Widget build(BuildContext context) => TasksBulkButton(
    icon: icon,
    label: label,
    onTap: isLoading ? null : () => _openMenu(context),
  );
}

/// Czytelny pełny komunikat bez zwiększania wysokości nagłówka.
class TasksBulkErrorDialog extends StatelessWidget {
  const TasksBulkErrorDialog({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
      side: BorderSide(color: context.colors.outlineVariant),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.tasksBulkErrorTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Semantics(
                container: true,
                label: message,
                excludeSemantics: true,
                child: SelectableText(
                  message,
                  style: context.tasksTheme.controlText,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.close),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
