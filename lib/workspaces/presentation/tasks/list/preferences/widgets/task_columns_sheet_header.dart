import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_columns_sheet_tab.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nagłówek arkusza wraz z wyborem zakresu osobistego albo projektowego.
class TaskColumnsSheetHeader extends StatelessWidget {
  const TaskColumnsSheetHeader({
    required this.canManage,
    required this.selectedTab,
    required this.isSaving,
    required this.onTabChanged,
    super.key,
  });

  final bool canManage;
  final TaskColumnsSheetTab selectedTab;
  final bool isSaving;
  final ValueChanged<TaskColumnsSheetTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final l10n = context.l10n;
    if (!canManage) {
      return Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(Symbols.tune_rounded, size: 20, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                l10n.tasksListColumnsTitle,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              _ScopeBadge(label: l10n.tasksListColumnsScopeUser),
              if (isSaving) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.8),
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(
            'Ułóż kolejność kolumn w Twoim widoku lub dodaj nowe z listy poniżej.',
            style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(Symbols.tune_rounded, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              l10n.tasksListColumnsTitle,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (isSaving && selectedTab == TaskColumnsSheetTab.user) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 1.8),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const .all(3),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              _ScopeTabButton(
                label: l10n.tasksListColumnsScopeUser,
                icon: Symbols.tune_rounded,
                isSelected: selectedTab == TaskColumnsSheetTab.user,
                onTap: () => onTabChanged(TaskColumnsSheetTab.user),
              ),
              _ScopeTabButton(
                label: l10n.tasksListColumnsScopeProject,
                icon: Symbols.admin_panel_settings_rounded,
                isSelected: selectedTab == TaskColumnsSheetTab.project,
                onTap: () => onTabChanged(TaskColumnsSheetTab.project),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScopeBadge extends StatelessWidget {
  const _ScopeBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const .symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: context.colors.primaryContainer.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: context.text.labelSmall?.copyWith(
        color: context.colors.primary,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _ScopeTabButton extends StatelessWidget {
  const _ScopeTabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const .symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
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
              icon,
              size: 16,
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
