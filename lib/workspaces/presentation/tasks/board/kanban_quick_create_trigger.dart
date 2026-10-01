import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Uruchamia edytor szybkiego tworzenia w kolumnie tablicy.
class KanbanQuickCreateTrigger extends StatelessWidget {
  const KanbanQuickCreateTrigger({
    required this.onActivate,
    required this.onManageTemplates,
    super.key,
  });

  final VoidCallback onActivate;
  final VoidCallback onManageTemplates;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const .fromLTRB(8, 2, 8, 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: .circular(Sizes.p8),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 34),
          child: InkWell(
            onTap: onActivate,
            hoverColor: colors.primary.withValues(alpha: .08),
            child: Padding(
              padding: const .symmetric(
                horizontal: Sizes.p8,
                vertical: Sizes.p4,
              ),
              child: Row(
                children: [
                  // Akcja kolumny używa akcentu Tasks jak pozostałe CTA.
                  Icon(
                    Symbols.add_rounded,
                    size: Sizes.p18,
                    color: colors.primary.withValues(alpha: .9),
                  ),
                  const SizedBox(width: Sizes.p6),
                  Expanded(
                    child: Semantics(
                      button: true,
                      label: context.l10n.tasksQuickCreate,
                      onTap: onActivate,
                      child: Text(
                        context.l10n.tasksQuickCreate,
                        style: context.text.bodySmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.primary.withValues(alpha: .95),
                        ),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tasksTemplatesUse,
                    child: IconButton(
                      onPressed: onManageTemplates,
                      visualDensity: VisualDensity.compact,
                      padding: const .all(Sizes.p4),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      iconSize: Sizes.p16,
                      color: colors.onSurfaceVariant.withValues(alpha: .6),
                      icon: const Icon(Symbols.auto_awesome_mosaic_rounded),
                    ),
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
