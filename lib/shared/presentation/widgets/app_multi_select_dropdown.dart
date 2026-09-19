import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:flutter/material.dart';

/// Opcja dla [AppMultiSelectDropdown].
class AppMultiSelectOption<T> {
  const AppMultiSelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;
}

/// Wspolny dropdown wielokrotnego wyboru w formie menu kontekstowego.
///
/// Zachowuje wyglad kontrolki formularzowej, ale rozwija sie jako zakotwiczone
/// okienko (jak menu kontekstowe), zamiast otwierac centralny dialog.
class AppMultiSelectDropdown<T> extends StatefulWidget {
  const AppMultiSelectDropdown({
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    super.key,
    this.labelText,
    this.hintText = 'Wybierz...',
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.size = AppControlSize.small,
    this.maxVisibleSummaryItems = 2,
    this.menuTitle = 'Wybierz opcje',
    this.inlineLabel,
  });

  final String? inlineLabel;
  final List<AppMultiSelectOption<T>> options;
  final List<T> selectedValues;
  final ValueChanged<List<T>> onChanged;
  final String? labelText;
  final String hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final AppControlSize size;
  final int maxVisibleSummaryItems;
  final String menuTitle;

  @override
  State<AppMultiSelectDropdown<T>> createState() =>
      _AppMultiSelectDropdownState<T>();
}

class _AppMultiSelectDropdownState<T> extends State<AppMultiSelectDropdown<T>> {
  final menuController = MenuController();
  final draftSelection = <T>{};

  @override
  void didUpdateWidget(covariant AppMultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!menuController.isOpen &&
        oldWidget.selectedValues != widget.selectedValues) {
      draftSelection
        ..clear()
        ..addAll(widget.selectedValues);
    }
  }

  void _openOrToggleMenu() {
    if (!widget.enabled) {
      return;
    }

    if (menuController.isOpen) {
      menuController.close();
      return;
    }

    draftSelection
      ..clear()
      ..addAll(widget.selectedValues);
    menuController.open();
    setState(() {});
  }

  void _toggleValue(T value) {
    setState(() {
      if (draftSelection.contains(value)) {
        draftSelection.remove(value);
      } else {
        draftSelection.add(value);
      }
    });
  }

  void _clearSelection() {
    setState(draftSelection.clear);
  }

  void _applySelection() {
    widget.onChanged(draftSelection.toList(growable: false));
    menuController.close();
  }

  String _buildSummary(List<String> labels) {
    if (labels.isEmpty) {
      return widget.hintText;
    }

    if (labels.length <= widget.maxVisibleSummaryItems) {
      return labels.join(', ');
    }

    final visible = labels.take(widget.maxVisibleSummaryItems).join(', ');
    final extra = labels.length - widget.maxVisibleSummaryItems;
    return '$visible +$extra';
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isEmpty = widget.selectedValues.isEmpty;
    final selectedLabels = widget.options
        .where((option) => widget.selectedValues.contains(option.value))
        .map((option) => option.label)
        .toList();
    final summary = _buildSummary(selectedLabels);
    final effectiveSize = widget.size;
    const borderRadius = BorderRadius.all(.circular(Sizes.p8));
    final minFieldHeight = effectiveSize.minHeight;
    final estimatedListHeight = (widget.options.length * 40.0).clamp(
      120.0,
      260.0,
    );

    return MenuAnchor(
      controller: menuController,
      onOpen: () => setState(() {}),
      onClose: () => setState(() {}),
      alignmentOffset: const Offset(0, Sizes.p4),
      style: MenuStyle(
        elevation: const WidgetStatePropertyAll(4),
        backgroundColor: WidgetStatePropertyAll(colors.surfaceContainerLowest),
        side: WidgetStatePropertyAll(BorderSide(color: colors.outlineVariant)),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(.circular(Sizes.p8)),
          ),
        ),
        padding: const WidgetStatePropertyAll(.all(Sizes.p8)),
      ),
      menuChildren: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 260,
            maxWidth: 360,
          ),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                widget.menuTitle,
                style: context.text.labelLarge?.copyWith(fontWeight: .w700),
              ),
              Gaps.h8,
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: estimatedListHeight),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: .min,
                    children: [
                      for (final option in widget.options)
                        CheckboxListTile(
                          dense: true,
                          visualDensity: .compact,
                          value: draftSelection.contains(option.value),
                          onChanged: option.enabled
                              ? (_) => _toggleValue(option.value)
                              : null,
                          contentPadding: const .symmetric(
                            horizontal: Sizes.p4,
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Row(
                            children: [
                              if (option.icon case final icon?) ...[
                                Icon(icon, size: Sizes.p16),
                                Gaps.w8,
                              ],
                              Expanded(
                                child: Text(
                                  option.label,
                                  overflow: .ellipsis,
                                  style: context.text.bodyMedium?.copyWith(
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
              Gaps.h8,
              Row(
                mainAxisAlignment: .end,
                children: [
                  TextButton(
                    onPressed: _clearSelection,
                    child: const Text('Wyczyść'),
                  ),
                  Gaps.w8,
                  FilledButton(
                    onPressed: _applySelection,
                    child: const Text('Zastosuj'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      builder: (context, controller, child) {
        final field = InkWell(
          borderRadius: borderRadius,
          onTap: _openOrToggleMenu,
          child: SizedBox(
            height: minFieldHeight,
            child: InputDecorator(
              isEmpty: isEmpty,
              isFocused: controller.isOpen,
              decoration: InputDecoration(
                isDense: false,
                isCollapsed: false,
                helperText: widget.helperText,
                errorText: widget.errorText,
                filled: true,
                fillColor: colors.surfaceContainerLowest,
                constraints: BoxConstraints.tightFor(height: minFieldHeight),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: effectiveSize.horizontalPadding,
                  vertical: effectiveSize.verticalPadding,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: colors.outline.withValues(alpha: .65),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: colors.primary, width: 1.4),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: colors.outlineVariant.withValues(alpha: .7),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (widget.inlineLabel case final label?) ...[
                    Text(
                      '$label: ',
                      style: context.text.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant.withValues(alpha: .7),
                        fontWeight: .w600,
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text(
                      summary,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        color: isEmpty
                            ? colors.onSurfaceVariant
                            : colors.onSurface,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                  Gaps.w8,
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: effectiveSize.iconSize,
                  ),
                ],
              ),
            ),
          ),
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
      },
    );
  }
}
