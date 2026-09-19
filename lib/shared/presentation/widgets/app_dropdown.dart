import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:devplanner/shared/presentation/widgets/app_date_picker_field.dart'
    show AppDatePickerField;
import 'package:devplanner/shared/presentation/widgets/app_text_field.dart'
    show AppTextField;
import 'package:flutter/material.dart';

enum AppDropdownVariant { outlined, filled }

/// Pojedyncza opcja dla [AppDropdown].
class AppDropdownOption<T> {
  const AppDropdownOption({
    required this.value,
    required this.label,
    this.icon,
    this.foregroundColor,
    this.enabled = true,
  });

  final T value;
  final String label;
  final IconData? icon;
  final Color? foregroundColor;
  final bool enabled;
}

/// Wspólny dropdown dla całej aplikacji oparty o [MenuAnchor].
///
/// Używa [InputDecorator] + [InkWell] zamiast [DropdownButtonFormField],
/// dzięki czemu wysokość pola jest identyczna jak u wszystkich innych
/// komponentów formularzy ([AppTextField], [AppDatePickerField], itp.).
class AppDropdown<T> extends StatefulWidget {
  const AppDropdown({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.variant = AppDropdownVariant.outlined,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.size = AppControlSize.small,
    this.expanded = true,
    this.inlineLabel,
  });

  final List<AppDropdownOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final AppDropdownVariant variant;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final AppControlSize size;
  final bool expanded;
  final String? inlineLabel;

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final _menuController = MenuController();

  AppDropdownOption<T>? get _selected =>
      widget.options.where((o) => o.value == widget.value).firstOrNull;

  void _open() {
    if (!widget.enabled) return;
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const borderRadius = BorderRadius.all(.circular(Sizes.p8));
    final isFilled = widget.variant == AppDropdownVariant.filled;
    final minFieldHeight = widget.size.minHeight;
    final fillColor = context.formControlFillColor(isFilled: isFilled);
    final isOpen = _menuController.isOpen;

    final field = LayoutBuilder(
      builder: (context, constraints) {
        final menuWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 240.0;
        return MenuAnchor(
          controller: _menuController,
          onOpen: () => setState(() {}),
          onClose: () => setState(() {}),
          alignmentOffset: const Offset(0, Sizes.p4),
          style: MenuStyle(
            elevation: const WidgetStatePropertyAll(4),
            backgroundColor: WidgetStatePropertyAll(
              colors.surfaceContainerLowest,
            ),
            side: WidgetStatePropertyAll(
              BorderSide(color: colors.outlineVariant),
            ),
            minimumSize: WidgetStatePropertyAll(Size(menuWidth, 0)),
            maximumSize: WidgetStatePropertyAll(
              Size(menuWidth, double.infinity),
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(.circular(Sizes.p8)),
              ),
            ),
            padding: const WidgetStatePropertyAll(.zero),
          ),
          menuChildren: [
            for (final option in widget.options)
              _AppDropdownMenuItem<T>(
                option: option,
                isSelected: option.value == widget.value,
                size: widget.size,
                onSelected: (val) {
                  widget.onChanged?.call(val);
                  _menuController.close();
                },
              ),
          ],
          builder: (context, controller, child) {
            final selectedLabel = _selected?.label;
            final selectedIcon = _selected?.icon;
            final selectedColor = _selected?.foregroundColor;
            final displayText = selectedLabel ?? widget.hintText;
            final isHint = selectedLabel == null;

            return InkWell(
              borderRadius: borderRadius,
              onTap: _open,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: minFieldHeight),
                child: InputDecorator(
                  isEmpty: widget.value == null,
                  isFocused: isOpen,
                  decoration: InputDecoration(
                    isDense: false,
                    isCollapsed: false,
                    helperText: widget.helperText,
                    errorText: widget.errorText,
                    filled: true,
                    fillColor: fillColor,
                    constraints: BoxConstraints(minHeight: minFieldHeight),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.size.horizontalPadding,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: Sizes.p4),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: widget.size.iconSize,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    suffixIconConstraints: BoxConstraints(
                      minHeight: minFieldHeight,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: context.formControlEnabledBorderColor(
                          isFilled: isFilled,
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: colors.primary, width: 1.4),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: colors.error),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: colors.error, width: 1.2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: context.formControlDisabledBorderColor(
                          isFilled: isFilled,
                        ),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (widget.inlineLabel case final label?) ...[
                        Flexible(
                          child: Text(
                            '$label: ',
                            overflow: TextOverflow.ellipsis,
                            style: context.text.bodyMedium?.copyWith(
                              color: context.formControlInlineLabelColor,
                              fontWeight: .w600,
                            ),
                          ),
                        ),
                      ],
                      Expanded(
                        child: Row(
                          children: [
                            if (selectedIcon case final icon? when !isHint) ...[
                              Icon(
                                icon,
                                size: widget.size.iconSize,
                                color: selectedColor ?? colors.onSurfaceVariant,
                              ),
                              Gaps.w4,
                            ],
                            Expanded(
                              child: Text(
                                displayText ?? '',
                                overflow: .ellipsis,
                                style: context.text.bodyMedium?.copyWith(
                                  color: isHint
                                      ? context.formControlHintColor
                                      : selectedColor ?? colors.onSurface,
                                  fontWeight: .w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    final label = _buildLabel(context);
    if (label != null) {
      return Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [label, const SizedBox(height: 4), field],
      );
    }
    return field;
  }

  Widget? _buildLabel(BuildContext context) {
    if (widget.labelText case final label?) {
      final colors = context.colors;
      final baseStyle = context.text.labelSmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontWeight: .w600,
        height: 1,
      );
      if (!widget.isRequired) {
        return Text(label, style: baseStyle);
      }
      return Text.rich(
        TextSpan(
          text: label,
          style: baseStyle,
          children: [
            TextSpan(
              text: ' *',
              style: baseStyle?.copyWith(
                color: colors.error,
                fontWeight: .w700,
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }
}

/// Pojedynczy element menu dropdownu.
class _AppDropdownMenuItem<T> extends StatelessWidget {
  const _AppDropdownMenuItem({
    required this.option,
    required this.isSelected,
    required this.size,
    required this.onSelected,
  });

  final AppDropdownOption<T> option;
  final bool isSelected;
  final AppControlSize size;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: option.enabled ? () => onSelected(option.value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p12,
          vertical: Sizes.p10,
        ),
        child: Row(
          children: [
            if (option.icon case final icon?) ...[
              Icon(
                icon,
                size: size.iconSize,
                color: option.enabled
                    ? option.foregroundColor ?? colors.onSurfaceVariant
                    : colors.outline,
              ),
              Gaps.w8,
            ],
            Expanded(
              child: Text(
                option.label,
                overflow: .ellipsis,
                style: context.text.bodyMedium?.copyWith(
                  color: option.enabled
                      ? option.foregroundColor ?? colors.onSurface
                      : colors.onSurfaceVariant,
                  fontWeight: isSelected ? .w600 : .w400,
                ),
              ),
            ),
            if (isSelected) ...[
              Gaps.w8,
              Icon(
                Icons.check_rounded,
                size: size.iconSize,
                color: colors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
