import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';

/// Smukły, webowy przełącznik segmentowy (pill switch) dla grupowania
/// widoku listy zadań (Workflow projektu vs Według statusu).
///
/// Zaprojektowany specjalnie pod aplikację webowo-desktopową o gęstym układzie
/// (wysokość 28px, delikatne zaokrąglenie, animowany wskaźnik i kursor kliknięcia)
/// z pełnym wsparciem nawigacji klawiaturą (Tab, Space, Enter) oraz Semantics.
class TaskListWorkflowSegmentedSwitch extends StatelessWidget {
  const TaskListWorkflowSegmentedSwitch({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  /// Aktualnie wybrana opcja grupowania.
  final TaskSavedViewGroupBy selected;

  /// Callback wywoływany po kliknięciu wybranej opcji.
  final ValueChanged<TaskSavedViewGroupBy> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final l10n = context.l10n;

    final options = [
      (
        TaskSavedViewGroupBy.customStatus,
        l10n.tasksListGroupProjectWorkflow,
        Symbols.schema_rounded,
      ),
      (
        TaskSavedViewGroupBy.status,
        l10n.tasksSavedViewsGroupStatus,
        Symbols.grid_view_rounded,
      ),
    ];

    return Container(
      height: 28,
      padding: const .all(2),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: 0.7),
        borderRadius: .circular(7),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          for (final (value, label, icon) in options)
            _SegmentItem(
              label: label,
              icon: icon,
              isSelected: selected == value,
              onTap: () => onChanged(value),
              colors: colors,
              text: text,
            ),
        ],
      ),
    );
  }
}

class _SegmentItem extends StatefulWidget {
  const _SegmentItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colors,
    required this.text,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colors;
  final TextTheme text;

  @override
  State<_SegmentItem> createState() => _SegmentItemState();
}

class _SegmentItemState extends State<_SegmentItem> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final colors = widget.colors;

    return Semantics(
      button: true,
      selected: isSelected,
      label: widget.label,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowHoverHighlight: (v) => setState(() => _isHovered = v),
        onShowFocusHighlight: (v) => setState(() => _isFocused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => widget.onTap(),
          ),
        },
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            padding: const .symmetric(horizontal: 9, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: .circular(5),
              border: _isFocused
                  ? Border.all(color: colors.primary, width: 1.2)
                  : null,
              color: isSelected
                  ? colors.surface
                  : _isHovered
                  ? colors.surface.withValues(alpha: 0.5)
                  : Colors.transparent,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colors.shadow.withValues(alpha: 0.08),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  widget.icon,
                  size: 14,
                  color: isSelected
                      ? colors.primary
                      : colors.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.label,
                  style: widget.text.labelSmall?.copyWith(
                    color: isSelected
                        ? colors.onSurface
                        : colors.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
