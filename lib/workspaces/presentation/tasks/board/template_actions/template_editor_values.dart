part of '../tasks_board_page.dart';

class _TemplateDateField extends StatelessWidget {
  const _TemplateDateField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onPick,
    required this.onClear,
    this.hasError = false,
    this.errorText,
  });

  final String label;
  final DateTime? value;
  final bool enabled;
  final bool hasError;
  final String? errorText;
  final Future<void> Function(BuildContext anchorContext) onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _TemplateDomainPickerField(
        label: label,
        value: value == null
            ? null
            : MaterialLocalizations.of(
                context,
              ).formatMediumDate(value!.toLocal()),
        icon: Symbols.calendar_today_rounded,
        enabled: enabled,
        onTap: onPick,
        onClear: value == null ? null : onClear,
      ),
      if (hasError && errorText != null) ...[
        const SizedBox(height: 4),
        Text(
          errorText!,
          style: context.text.bodySmall?.copyWith(color: context.colors.error),
        ),
      ],
    ],
  );
}

class _TemplateValueBadge extends StatelessWidget {
  const _TemplateValueBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: .14),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      border: Border.all(color: color.withValues(alpha: .4), width: .8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: context.text.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _TemplateCustomOptionValue extends StatelessWidget {
  const _TemplateCustomOptionValue({required this.raw});

  final String raw;

  @override
  Widget build(BuildContext context) {
    final option = CustomFieldOption.fromRaw(raw);
    return _TemplateValueBadge(
      label: option.label,
      icon: option.icon ?? Symbols.circle,
      color: option.color ?? context.colors.primary,
    );
  }
}

class _TemplateMultiOptionValue extends StatelessWidget {
  const _TemplateMultiOptionValue({required this.values});

  final List<dynamic> values;

  @override
  Widget build(BuildContext context) {
    final options = values
        .map((value) => CustomFieldOption.fromRaw(value.toString()))
        .toList(growable: false);
    final first = options.first;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TemplateValueBadge(
          label: first.label,
          icon: first.icon ?? Symbols.circle,
          color: first.color ?? context.colors.primary,
        ),
        if (options.length > 1) ...[
          const SizedBox(width: 4),
          Text(
            '+${options.length - 1}',
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _TemplateComplexityValue extends StatelessWidget {
  const _TemplateComplexityValue({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(1, 5);
    final color =
        TaskComplexityLevel.fromValue(normalized)?.color ??
        context.colors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 1; index <= 5; index++)
          Container(
            width: 3.5,
            height: 10,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(1)),
              color: index <= normalized
                  ? color
                  : context.colors.outlineVariant.withValues(alpha: .35),
            ),
          ),
        const SizedBox(width: 3),
        Text(
          '$normalized',
          style: context.text.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Pole formularza otwierające ten sam zakotwiczony picker co komórka listy.
class _TemplateDomainPickerField extends StatelessWidget {
  const _TemplateDomainPickerField({
    required this.enabled,
    required this.label,
    required this.icon,
    required this.onTap,
    this.value,
    this.valueWidget,
    this.color,
    this.onClear,
  });

  final bool enabled;
  final String label;
  final String? value;
  final Widget? valueWidget;
  final IconData icon;
  final Color? color;
  final VoidCallback? onClear;
  final Future<void> Function(BuildContext anchorContext) onTap;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (anchorContext) => Material(
      color: context.colors.surfaceContainerLow.withValues(alpha: .65),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: enabled ? () => unawaited(onTap(anchorContext)) : null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 42),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: color ?? context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Flexible(
                  child:
                      valueWidget ??
                      Text(
                        value ?? context.l10n.myTasksAny,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: context.text.labelMedium?.copyWith(
                          color: value == null
                              ? context.colors.onSurfaceVariant
                              : context.colors.onSurface,
                          fontWeight: value == null ? null : FontWeight.w600,
                        ),
                      ),
                ),
                const SizedBox(width: 4),
                if (onClear != null && enabled)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints.tightFor(
                      width: 28,
                      height: 28,
                    ),
                    padding: EdgeInsets.zero,
                    tooltip: context.l10n.myTasksClear,
                    onPressed: onClear,
                    icon: const Icon(Symbols.close_rounded, size: 16),
                  )
                else
                  const Icon(Symbols.chevron_right_rounded, size: 17),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
