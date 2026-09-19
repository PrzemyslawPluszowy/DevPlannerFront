import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wybór formatki w inline quick-create; zwraca wyłącznie wybór użytkownika.
class TaskBoardTemplateChoiceButton extends StatelessWidget {
  const TaskBoardTemplateChoiceButton({
    required this.label,
    required this.templates,
    required this.defaultTemplateId,
    required this.effectiveTemplateId,
    required this.useDefaultTemplate,
    required this.disabled,
    required this.onSelected,
    required this.onManage,
    super.key,
  });

  final String label;
  final List<TaskTemplateResponse> templates;
  final String? defaultTemplateId;
  final String? effectiveTemplateId;
  final bool useDefaultTemplate;
  final bool disabled;
  final ValueChanged<String?> onSelected;
  final Future<void> Function() onManage;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Builder(
      builder: (buttonContext) => InkWell(
        onTap: disabled ? null : () => _showMenu(context, buttonContext),
        borderRadius: .circular(Sizes.p6),
        child: Container(
          padding: const .symmetric(horizontal: Sizes.p6, vertical: 2),
          margin: const .only(bottom: Sizes.p6),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: .08),
            borderRadius: .circular(Sizes.p6),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(
                Symbols.auto_awesome_mosaic_rounded,
                size: 13,
                color: context.colors.primary,
              ),
              const SizedBox(width: Sizes.p4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: Text(
                  label,
                  style: context.text.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: context.colors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Symbols.arrow_drop_down_rounded,
                size: 14,
                color: context.colors.primary,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _showMenu(
    BuildContext context,
    BuildContext buttonContext,
  ) async {
    final choice = await TaskContextMenu.show<String?>(
      context,
      position: TaskContextMenu.positionFor(buttonContext),
      items: [
        for (final template in templates)
          TaskContextMenuItem<String?>(
            value: template.id,
            title: template.name,
            icon: template.id == defaultTemplateId
                ? Symbols.star_rounded
                : Symbols.auto_awesome_mosaic_rounded,
            iconColor: template.id == defaultTemplateId
                ? context.colors.primary
                : null,
            isSelected: template.id == effectiveTemplateId,
          ),
        TaskContextMenuItem<String?>(
          value: 'none',
          title: context.l10n.tasksTemplateNoTemplate,
          icon: Symbols.block_rounded,
          isSelected: !useDefaultTemplate,
        ),
        TaskContextMenuItem<String?>(
          value: 'manage',
          title: context.l10n.tasksTemplatesManage,
          icon: Symbols.tune_rounded,
        ),
      ],
    );
    if (!context.mounted || choice == null) return;
    if (choice == 'manage') {
      await onManage();
    } else {
      onSelected(choice == 'none' ? null : choice);
    }
  }
}
