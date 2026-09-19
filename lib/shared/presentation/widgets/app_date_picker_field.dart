import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum AppDateFieldVariant { outlined, filled }

class AppDateRangeValue {
  const AppDateRangeValue({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class AppDatePickerField extends StatefulWidget {
  const AppDatePickerField({
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.labelText,
    this.hintText = 'Wybierz datę',
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.allowClear = true,
    this.size = AppControlSize.small,
    this.variant = AppDateFieldVariant.outlined,
    this.formatPattern = 'yyyy-MM-dd',
    this.locale,
    this.menuWidth = 320,
    this.inlineLabel,
  });

  final String? inlineLabel;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? labelText;
  final String hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final bool allowClear;
  final AppControlSize size;
  final AppDateFieldVariant variant;
  final String formatPattern;
  final String? locale;
  final double menuWidth;

  @override
  State<AppDatePickerField> createState() => _AppDatePickerFieldState();
}

class _AppDatePickerFieldState extends State<AppDatePickerField> {
  final menuController = MenuController();
  late DateTime draftDate;

  DateTime _clamp(DateTime date) {
    if (date.isBefore(widget.firstDate)) {
      return widget.firstDate;
    }
    if (date.isAfter(widget.lastDate)) {
      return widget.lastDate;
    }
    return date;
  }

  void _syncDraftDate() {
    draftDate = _clamp(widget.value ?? DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _syncDraftDate();
  }

  @override
  void didUpdateWidget(covariant AppDatePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncDraftDate();
  }

  void _openMenu() {
    if (!widget.enabled) {
      return;
    }
    _syncDraftDate();
    menuController.open();
    setState(() {});
  }

  void _closeMenu() {
    menuController.close();
    setState(() {});
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
    const borderRadius = BorderRadius.all(.circular(Sizes.p8));
    final isFilled = widget.variant == AppDateFieldVariant.filled;
    final formatted = widget.value == null
        ? null
        : DateFormat(widget.formatPattern, widget.locale).format(widget.value!);

    return MenuAnchor(
      controller: menuController,
      alignmentOffset: const Offset(0, Sizes.p4),
      onOpen: () => setState(() {}),
      onClose: () => setState(() {}),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(colors.surfaceContainerLowest),
        side: WidgetStatePropertyAll(BorderSide(color: colors.outlineVariant)),
        elevation: const WidgetStatePropertyAll(4),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(.circular(Sizes.p8)),
          ),
        ),
        padding: const WidgetStatePropertyAll(.all(Sizes.p8)),
      ),
      menuChildren: [
        SizedBox(
          width: widget.menuWidth,
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Text(
                widget.labelText ?? 'Wybierz datę',
                style: context.text.labelLarge?.copyWith(fontWeight: .w700),
              ),
              Gaps.h8,
              SizedBox(
                width: double.infinity,
                height: 320,
                child: CalendarDatePicker(
                  initialDate: draftDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  onDateChanged: (date) => setState(() => draftDate = date),
                ),
              ),
              Gaps.h8,
              Row(
                mainAxisAlignment: .end,
                children: [
                  if (widget.allowClear && widget.value != null)
                    TextButton(
                      onPressed: () {
                        widget.onChanged(null);
                        _closeMenu();
                      },
                      child: const Text('Wyczyść'),
                    ),
                  Gaps.w8,
                  TextButton(
                    onPressed: _closeMenu,
                    child: const Text('Anuluj'),
                  ),
                  Gaps.w8,
                  FilledButton(
                    onPressed: () {
                      widget.onChanged(draftDate);
                      _closeMenu();
                    },
                    child: const Text('Zastosuj'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      builder: (context, controller, child) {
        final input = ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.size.minHeight),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: controller.isOpen ? _closeMenu : _openMenu,
            child: InputDecorator(
              isEmpty: widget.value == null,
              isFocused: controller.isOpen,
              decoration: InputDecoration(
                isDense: true,
                helperText: widget.helperText,
                errorText: widget.errorText,
                filled: true,
                fillColor: isFilled
                    ? colors.surfaceContainerLow
                    : colors.surfaceContainerLowest,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.size.horizontalPadding,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: isFilled
                        ? colors.outlineVariant.withValues(alpha: .9)
                        : colors.outline.withValues(alpha: .65),
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
                prefixIcon: Icon(
                  Icons.event_outlined,
                  size: widget.size.iconSize,
                  color: colors.onSurfaceVariant,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: widget.size.minHeight,
                  minHeight: widget.size.minHeight,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.allowClear && widget.value != null)
                      IconButton(
                        tooltip: 'Wyczyść',
                        visualDensity: .compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: Sizes.p20,
                          minHeight: Sizes.p20,
                        ),
                        onPressed: widget.enabled
                            ? () => widget.onChanged(null)
                            : null,
                        icon: Icon(
                          Icons.close_rounded,
                          size: widget.size.iconSize,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: widget.size.iconSize,
                      color: colors.onSurfaceVariant,
                    ),
                    Gaps.w8,
                  ],
                ),
                suffixIconConstraints: BoxConstraints(
                  minHeight: widget.size.minHeight,
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
                      formatted ?? widget.hintText,
                      overflow: .ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        color: formatted == null
                            ? colors.onSurfaceVariant.withValues(alpha: .88)
                            : colors.onSurface,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        final label = _buildLabel(context);
        if (label != null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label,
              const SizedBox(height: 4),
              input,
            ],
          );
        }

        return input;
      },
    );
  }
}

class AppDateRangePickerField extends StatefulWidget {
  const AppDateRangePickerField({
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.labelText,
    this.hintText = 'Wybierz zakres dat',
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
    this.allowClear = true,
    this.size = AppControlSize.small,
    this.variant = AppDateFieldVariant.outlined,
    this.formatPattern = 'yyyy-MM-dd',
    this.locale,
    this.menuWidth = 760,
    this.inlineLabel,
  });

  final String? inlineLabel;
  final AppDateRangeValue? value;
  final ValueChanged<AppDateRangeValue?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? labelText;
  final String hintText;
  final String? helperText;
  final String? errorText;
  final bool isRequired;
  final bool enabled;
  final bool allowClear;
  final AppControlSize size;
  final AppDateFieldVariant variant;
  final String formatPattern;
  final String? locale;
  final double menuWidth;

  @override
  State<AppDateRangePickerField> createState() =>
      _AppDateRangePickerFieldState();
}

class _AppDateRangePickerFieldState extends State<AppDateRangePickerField> {
  final menuController = MenuController();
  late DateTime draftStart;
  late DateTime draftEnd;

  DateTime _clamp(DateTime date) {
    if (date.isBefore(widget.firstDate)) {
      return widget.firstDate;
    }
    if (date.isAfter(widget.lastDate)) {
      return widget.lastDate;
    }
    return date;
  }

  void _syncDraftRange() {
    final now = DateTime.now();
    draftStart = _clamp(widget.value?.start ?? now);
    draftEnd = _clamp(widget.value?.end ?? draftStart);
    if (draftEnd.isBefore(draftStart)) {
      draftEnd = draftStart;
    }
  }

  @override
  void initState() {
    super.initState();
    _syncDraftRange();
  }

  @override
  void didUpdateWidget(covariant AppDateRangePickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncDraftRange();
  }

  void _openMenu() {
    if (!widget.enabled) {
      return;
    }
    _syncDraftRange();
    menuController.open();
    setState(() {});
  }

  void _closeMenu() {
    menuController.close();
    setState(() {});
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
    const borderRadius = BorderRadius.all(.circular(Sizes.p8));
    final isFilled = widget.variant == AppDateFieldVariant.filled;
    final format = DateFormat(widget.formatPattern, widget.locale);
    final formatted = widget.value == null
        ? null
        : '${format.format(widget.value!.start)} - ${format.format(widget.value!.end)}';

    return MenuAnchor(
      controller: menuController,
      alignmentOffset: const Offset(0, Sizes.p4),
      onOpen: () => setState(() {}),
      onClose: () => setState(() {}),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(colors.surfaceContainerLowest),
        side: WidgetStatePropertyAll(BorderSide(color: colors.outlineVariant)),
        elevation: const WidgetStatePropertyAll(4),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(.circular(Sizes.p8)),
          ),
        ),
        padding: const WidgetStatePropertyAll(.all(Sizes.p8)),
      ),
      menuChildren: [
        SizedBox(
          width: widget.menuWidth,
          child: Builder(
            builder: (context) {
              final isCompact = widget.menuWidth < 640;
              final calendarWidth = (widget.menuWidth - Sizes.p12) / 2;

              Widget calendar({
                required String title,
                required DateTime selected,
                required ValueChanged<DateTime> onDateChanged,
                double? width,
              }) {
                return SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: [
                      Text(
                        title,
                        style: context.text.labelLarge?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                      Gaps.h8,
                      SizedBox(
                        width: double.infinity,
                        height: 320,
                        child: CalendarDatePicker(
                          initialDate: selected,
                          firstDate: widget.firstDate,
                          lastDate: widget.lastDate,
                          onDateChanged: onDateChanged,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final content = isCompact
                  ? Column(
                      mainAxisSize: .min,
                      children: [
                        calendar(
                          title: 'Od',
                          selected: draftStart,
                          width: widget.menuWidth,
                          onDateChanged: (date) {
                            setState(() {
                              draftStart = date;
                              if (draftEnd.isBefore(draftStart)) {
                                draftEnd = draftStart;
                              }
                            });
                          },
                        ),
                        Gaps.h8,
                        calendar(
                          title: 'Do',
                          selected: draftEnd,
                          width: widget.menuWidth,
                          onDateChanged: (date) {
                            setState(() {
                              draftEnd = date;
                              if (draftEnd.isBefore(draftStart)) {
                                draftStart = draftEnd;
                              }
                            });
                          },
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: .start,
                      children: [
                        calendar(
                          title: 'Od',
                          selected: draftStart,
                          width: calendarWidth,
                          onDateChanged: (date) {
                            setState(() {
                              draftStart = date;
                              if (draftEnd.isBefore(draftStart)) {
                                draftEnd = draftStart;
                              }
                            });
                          },
                        ),
                        Gaps.w12,
                        calendar(
                          title: 'Do',
                          selected: draftEnd,
                          width: calendarWidth,
                          onDateChanged: (date) {
                            setState(() {
                              draftEnd = date;
                              if (draftEnd.isBefore(draftStart)) {
                                draftStart = draftEnd;
                              }
                            });
                          },
                        ),
                      ],
                    );

              return Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    widget.labelText ?? 'Wybierz zakres dat',
                    style: context.text.labelLarge?.copyWith(fontWeight: .w700),
                  ),
                  Gaps.h8,
                  content,
                  Gaps.h8,
                  Row(
                    mainAxisAlignment: .end,
                    children: [
                      if (widget.allowClear && widget.value != null)
                        TextButton(
                          onPressed: () {
                            widget.onChanged(null);
                            _closeMenu();
                          },
                          child: const Text('Wyczyść'),
                        ),
                      Gaps.w8,
                      TextButton(
                        onPressed: _closeMenu,
                        child: const Text('Anuluj'),
                      ),
                      Gaps.w8,
                      FilledButton(
                        onPressed: () {
                          widget.onChanged(
                            AppDateRangeValue(start: draftStart, end: draftEnd),
                          );
                          _closeMenu();
                        },
                        child: const Text('Zastosuj'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
      builder: (context, controller, child) {
        final input = ConstrainedBox(
          constraints: BoxConstraints(minHeight: widget.size.minHeight),
          child: InkWell(
            borderRadius: borderRadius,
            onTap: controller.isOpen ? _closeMenu : _openMenu,
            child: InputDecorator(
              isEmpty: widget.value == null,
              isFocused: controller.isOpen,
              decoration: InputDecoration(
                isDense: true,
                helperText: widget.helperText,
                errorText: widget.errorText,
                filled: true,
                fillColor: isFilled
                    ? colors.surfaceContainerLow
                    : colors.surfaceContainerLowest,
                contentPadding: EdgeInsets.only(
                  left: widget.size.horizontalPadding,
                  right: widget.size.horizontalPadding,
                  top: widget.size.verticalPadding,
                  bottom: widget.size.verticalPadding,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: isFilled
                        ? colors.outlineVariant.withValues(alpha: .9)
                        : colors.outline.withValues(alpha: .65),
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
                prefixIcon: Icon(
                  Icons.date_range_outlined,
                  size: widget.size.iconSize,
                  color: colors.onSurfaceVariant,
                ),
                prefixIconConstraints: BoxConstraints(
                  minWidth: widget.size.minHeight,
                  minHeight: widget.size.minHeight,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.allowClear && widget.value != null)
                      IconButton(
                        tooltip: 'Wyczyść',
                        visualDensity: .compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: Sizes.p20,
                          minHeight: Sizes.p20,
                        ),
                        onPressed: widget.enabled
                            ? () => widget.onChanged(null)
                            : null,
                        icon: Icon(
                          Icons.close_rounded,
                          size: widget.size.iconSize,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: widget.size.iconSize,
                      color: colors.onSurfaceVariant,
                    ),
                    Gaps.w8,
                  ],
                ),
                suffixIconConstraints: BoxConstraints(
                  minHeight: widget.size.minHeight,
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
                      formatted ?? widget.hintText,
                      overflow: .ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        color: formatted == null
                            ? colors.onSurfaceVariant.withValues(alpha: .88)
                            : colors.onSurface,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        final label = _buildLabel(context);
        if (label != null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label,
              const SizedBox(height: 4),
              input,
            ],
          );
        }

        return input;
      },
    );
  }
}
