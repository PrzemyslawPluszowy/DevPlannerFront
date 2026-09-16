import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';

/// Kontroler do [AppSearchTextField].
///
/// Pozwala sterowac polem z zewnatrz:
/// - ustawic zapytanie,
/// - zresetowac zawartosc.
class AppSearchTextFieldController extends ChangeNotifier {
  String _query = '';

  String get query => _query;

  void setQuery(String value) {
    if (_query == value) {
      return;
    }
    _query = value;
    notifyListeners();
  }

  void reset() => setQuery('');
}

/// Kompaktowe pole wyszukiwania z debounce.
///
/// Zachowanie:
/// - posiada dedykowany [AppSearchTextFieldController],
/// - po wpisaniu uruchamia wewnetrzny debounce,
/// - po debounce wywoluje [onChanged],
/// - opcjonalnie wywoluje [onRawChanged] bez debounce.
class AppSearchTextField extends StatefulWidget {
  const AppSearchTextField({
    super.key,
    this.controller,
    this.hintText = 'Szukaj...',
    this.labelText,
    this.enabled = true,
    this.autofocus = false,
    this.size = AppControlSize.small,
    this.debounce = const Duration(milliseconds: 350),
    this.onChanged,
    this.onRawChanged,
    this.onSubmitted,
    this.width,
    this.inlineLabel,
  });

  final String? inlineLabel;
  final AppSearchTextFieldController? controller;
  final String hintText;
  final String? labelText;
  final bool enabled;
  final bool autofocus;
  final AppControlSize size;
  final Duration debounce;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onRawChanged;
  final ValueChanged<String>? onSubmitted;
  final double? width;

  @override
  State<AppSearchTextField> createState() => _AppSearchTextFieldState();
}

class _AppSearchTextFieldState extends State<AppSearchTextField> {
  final textController = TextEditingController();
  Timer? debounceTimer;

  AppSearchTextFieldController? get _externalController => widget.controller;

  @override
  void initState() {
    super.initState();
    _externalController?.addListener(_handleExternalControllerChange);
    if (_externalController case final external?) {
      textController.text = external.query;
    }
  }

  @override
  void didUpdateWidget(covariant AppSearchTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleExternalControllerChange);
      widget.controller?.addListener(_handleExternalControllerChange);
      _syncTextFromExternal(notify: false);
    }
  }

  @override
  void dispose() {
    debounceTimer?.cancel();
    _externalController?.removeListener(_handleExternalControllerChange);
    textController.dispose();
    super.dispose();
  }

  void _handleExternalControllerChange() {
    _syncTextFromExternal();
  }

  void _syncTextFromExternal({bool notify = true}) {
    final externalValue = _externalController?.query ?? '';
    if (textController.text == externalValue) {
      return;
    }

    textController.value = TextEditingValue(
      text: externalValue,
      selection: TextSelection.collapsed(offset: externalValue.length),
    );

    if (!notify) {
      return;
    }

    _notifyRaw(externalValue);
    _notifyDebounced(externalValue);
  }

  void _handleChanged(String value) {
    if (_externalController case final external?) {
      external.setQuery(value);
    }

    _notifyRaw(value);
    _notifyDebounced(value);
    setState(() {});
  }

  void _notifyRaw(String value) {
    widget.onRawChanged?.call(value);
  }

  void _notifyDebounced(String value) {
    debounceTimer?.cancel();
    debounceTimer = Timer(widget.debounce, () {
      widget.onChanged?.call(value);
    });
  }

  void _handleReset() {
    if (_externalController case final external?) {
      external.reset();
      return;
    }

    _handleChanged('');
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final effectiveSize = widget.size;
    final minFieldHeight = effectiveSize.minHeight;

    final fieldInput = TextField(
      controller: textController,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      onChanged: _handleChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        isDense: false,
        isCollapsed: false,
        hintText: widget.hintText,
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: effectiveSize.horizontalPadding,
            right: Sizes.p4,
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              Icon(Icons.search_rounded, size: effectiveSize.iconSize),
              if (widget.inlineLabel case final label?) ...[
                Gaps.w4,
                Text(
                  '$label: ',
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant.withValues(alpha: .7),
                    fontWeight: .w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: minFieldHeight,
          minHeight: minFieldHeight,
        ),
        suffixIcon: textController.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Wyczyść',
                onPressed: _handleReset,
                visualDensity: .compact,
                padding: .zero,
                icon: Icon(Icons.close_rounded, size: effectiveSize.iconSize),
              ),
        suffixIconConstraints: BoxConstraints(
          minWidth: minFieldHeight,
          minHeight: minFieldHeight,
        ),
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: effectiveSize.horizontalPadding,
          vertical: effectiveSize.verticalPadding,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(.circular(Sizes.p8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
          borderSide: BorderSide(color: colors.outline.withValues(alpha: .65)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
          borderSide: BorderSide(color: colors.primary, width: 1.4),
        ),
      ),
    );

    final field = Material(
      type: MaterialType.transparency,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minFieldHeight),
        child: fieldInput,
      ),
    );

    Widget finalField = field;
    if (widget.width case final width?) {
      finalField = SizedBox(width: width, child: field);
    }

    if (widget.labelText case final label?) {
      final baseStyle = context.text.labelSmall?.copyWith(
        color: colors.onSurfaceVariant,
        fontWeight: .w600,
        height: 1,
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: baseStyle),
          const SizedBox(height: 4),
          finalField,
        ],
      );
    }

    return finalField;
  }
}
