import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Pojedynczy wiersz szybkiego tworzenia zadania (inline creation).
class TaskListInlineCreateRow extends StatelessWidget {
  const TaskListInlineCreateRow({
    required this.controller,
    required this.hintText,
    required this.onCancel,
    required this.onSubmit,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onCancel;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) => Container(
    height: 38,
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLow,
      border: Border(
        bottom: BorderSide(color: context.colors.outlineVariant),
      ),
    ),
    child: Row(
      children: [
        const SizedBox(
          width: TaskListGrid.selection,
          child: Center(
            child: Icon(Symbols.add_rounded, size: 16, color: Colors.grey),
          ),
        ),
        SizedBox(
          width: TaskListGrid.task,
          child: Padding(
            padding: const .symmetric(horizontal: 8, vertical: 2),
            child: Focus(
              onKeyEvent: (_, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  onCancel();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: controller,
                autofocus: true,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => unawaited(onSubmit()),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hintText,
                  hintStyle: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant.withValues(
                      alpha: .6,
                    ),
                  ),
                  filled: false,
                  contentPadding: const .symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
        Text(
          context.l10n.tasksListInlineCreateKeyboardHint,
          style: context.text.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant.withValues(alpha: .6),
          ),
        ),
      ],
    ),
  );
}

/// Wiersz szybkiego tworzenia zadania na końcu grupy.
class TaskListGroupInlineCreateRow extends StatelessWidget {
  const TaskListGroupInlineCreateRow({
    required this.isEditing,
    required this.controller,
    required this.onBegin,
    required this.onCancel,
    required this.onSubmit,
    super.key,
  });

  final bool isEditing;
  final TextEditingController controller;
  final VoidCallback onBegin;
  final VoidCallback onCancel;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) => isEditing
      ? TaskListInlineCreateRow(
          controller: controller,
          hintText: context.l10n.tasksListInlineCreateHint,
          onCancel: onCancel,
          onSubmit: onSubmit,
        )
      : SizedBox(
          height: 38,
          child: Align(
            alignment: .centerLeft,
            child: Padding(
              padding: const .only(left: TaskListGrid.selection),
              child: TextButton.icon(
                onPressed: onBegin,
                icon: const Icon(Symbols.add_rounded, size: 17),
                label: Text(context.l10n.tasksListInlineCreateButton),
              ),
            ),
          ),
        );
}
