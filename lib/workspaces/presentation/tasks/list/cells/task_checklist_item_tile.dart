import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Jeden wiersz checklisty z niezależnym stanem hovera akcji usuwania.
class TaskChecklistItemTile extends StatefulWidget {
  const TaskChecklistItemTile({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final TaskChecklistItemResponse item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  State<TaskChecklistItemTile> createState() => _TaskChecklistItemTileState();
}

class _TaskChecklistItemTileState extends State<TaskChecklistItemTile> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: InkWell(
        borderRadius: const BorderRadius.all(.circular(4)),
        onTap: widget.onToggle,
        child: Padding(
          padding: const .symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: item.isCompleted,
                  visualDensity: .compact,
                  onChanged: (_) => widget.onToggle(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    decoration: item.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: item.isCompleted
                        ? context.colors.onSurfaceVariant.withValues(alpha: .6)
                        : context.colors.onSurface,
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isHovered,
                builder: (context, isHovered, _) => isHovered
                    ? IconButton(
                        icon: Icon(
                          Symbols.delete_rounded,
                          size: 14,
                          color: context.colors.error,
                        ),
                        visualDensity: .compact,
                        constraints: const BoxConstraints.tightFor(
                          width: 24,
                          height: 24,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: widget.onDelete,
                      )
                    : const SizedBox(width: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
