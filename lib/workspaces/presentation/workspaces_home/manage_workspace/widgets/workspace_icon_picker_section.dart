import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/shared/helpers/workspace_icon_helper.dart';

/// Sekcja wyboru ikony workspace’u w formularzach tworzenia i edycji przestrzeni.
class WorkspaceIconPickerSection extends StatelessWidget {
  const WorkspaceIconPickerSection({
    required this.selectedIconKey,
    required this.selectedColor,
    required this.onIconSelected,
    super.key,
  });

  /// Aktualnie wybrany klucz ikony.
  final String selectedIconKey;

  /// Kolor akcentu używany do wyróżnienia zaznaczenia.
  final Color selectedColor;

  /// Callback wywoływany po wybraniu nowej ikony.
  final ValueChanged<String> onIconSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          context.l10n.workspacesPickIconLabel,
          style: context.text.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
          ),
        ),
        Gaps.h8,
        Wrap(
          spacing: Sizes.p8,
          runSpacing: Sizes.p8,
          children: WorkspaceIconHelper.allIcons.map((option) {
            final isSelected = option.id == selectedIconKey;
            return Tooltip(
              message: option.label,
              child: Material(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: const .all(.circular(8)),
                  side: BorderSide(
                    color: isSelected ? selectedColor : colors.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () => onIconSelected(option.id),
                  borderRadius: const .all(.circular(8)),
                  hoverColor: selectedColor.withValues(alpha: .12),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? selectedColor.withValues(alpha: .15)
                          : colors.surfaceContainerLow,
                      borderRadius: const .all(.circular(8)),
                    ),
                    alignment: .center,
                    child: Icon(
                      option.icon,
                      size: 20,
                      color: isSelected
                          ? selectedColor
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
