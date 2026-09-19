import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:flutter/material.dart';

/// Nowoczesny przełącznik typu toggle switch w standardzie web/desktop.
///
/// Zapewnia zwartą sylwetkę, płynną animację i spójność z motywem aplikacji,
/// eliminując ciężkie, niespójne przełączniki mobilne.
class AppToggleSwitch extends StatelessWidget {
  /// Tworzy nowoczesny przełącznik toggle.
  const AppToggleSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.description,
    this.size = AppControlSize.small,
    this.enabled = true,
  });

  /// Aktualny stan włączenia.
  final bool value;

  /// Callback wywoływany po zmianie stanu.
  final ValueChanged<bool>? onChanged;

  /// Opcjonalna etykieta tekstowa.
  final String? label;

  /// Opcjonalny opis pomocniczy.
  final String? description;

  /// Rozmiar kontrolki.
  final AppControlSize size;

  /// Czy kontrolka jest aktywna i klikalna.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final trackWidth = switch (size) {
      AppControlSize.small => 34.0,
      AppControlSize.large => 42.0,
    };
    final trackHeight = switch (size) {
      AppControlSize.small => 20.0,
      AppControlSize.large => 24.0,
    };
    final thumbSize = switch (size) {
      AppControlSize.small => 14.0,
      AppControlSize.large => 18.0,
    };
    final padding = (trackHeight - thumbSize) / 2;

    final isInteractive = enabled && onChanged != null;
    final activeColor = context.colors.primary;
    final inactiveColor = context.colors.surfaceContainerHighest;
    final disabledColor = context.colors.surfaceContainerLow;

    final toggle = MouseRegion(
      cursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: isInteractive ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          width: trackWidth,
          height: trackHeight,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
            color: !enabled
                ? disabledColor
                : value
                ? activeColor
                : inactiveColor,
            border: Border.all(
              color: value && enabled
                  ? activeColor
                  : context.colors.outlineVariant.withValues(alpha: .6),
            ),
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            alignment: value ? .centerRight : .centerLeft,
            child: Container(
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: !enabled
                    ? context.colors.onSurface.withValues(alpha: .3)
                    : value
                    ? context.colors.onPrimary
                    : context.colors.onSurfaceVariant,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .12),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (label == null && description == null) {
      return toggle;
    }

    return InkWell(
      onTap: isInteractive ? () => onChanged!(!value) : null,
      borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
      child: Padding(
        padding: const .symmetric(vertical: Sizes.p4, horizontal: Sizes.p4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                mainAxisSize: .min,
                children: [
                  if (label case final text?)
                    Text(
                      text,
                      style: context.text.labelMedium?.copyWith(
                        fontWeight: .w600,
                        color: enabled
                            ? context.colors.onSurface
                            : context.colors.onSurface.withValues(alpha: .4),
                      ),
                    ),
                  if (description case final desc?) ...[
                    Gaps.h2,
                    Text(
                      desc,
                      style: context.text.bodySmall?.copyWith(
                        color: enabled
                            ? context.colors.onSurfaceVariant
                            : context.colors.onSurfaceVariant.withValues(alpha: .4),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Gaps.w12,
            toggle,
          ],
        ),
      ),
    );
  }
}
