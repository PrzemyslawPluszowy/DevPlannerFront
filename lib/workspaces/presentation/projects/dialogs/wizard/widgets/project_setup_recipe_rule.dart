import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Reguła automatyzacji pokazana jako „Gdy… → wtedy…”.
///
/// Ten sam zapis obowiązuje w kroku funkcji startowych i w panelu podglądu,
/// dlatego reguła jest jednym widgetem: użytkownik uczy się jednego wzoru,
/// a nie dwóch opisów tej samej automatyzacji.
class ProjectSetupRecipeRule extends StatelessWidget {
  /// Tworzy regułę automatyzacji.
  const ProjectSetupRecipeRule({
    required this.trigger,
    required this.action,
    this.dense = false,
    super.key,
  });

  /// Zdarzenie, po którym reguła działa.
  final String trigger;

  /// Akcja wykonywana przez regułę.
  final String action;

  /// Czy reguła ma być ciaśniejsza, np. na karcie wyboru.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RuleLine(
          icon: Symbols.play_circle,
          label: l10n.projectSetupPreviewRecipeWhen,
          value: trigger,
        ),
        Gaps.h4,
        _RuleLine(
          icon: Symbols.arrow_forward,
          label: l10n.projectSetupPreviewRecipeThen,
          value: action,
        ),
      ],
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: colors.onSurfaceVariant),
        Gaps.w6,
        Text(
          '$label: ',
          style: context.text.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurfaceVariant,
          ),
        ),
        Expanded(child: Text(value, style: context.text.labelSmall)),
      ],
    );
  }
}
