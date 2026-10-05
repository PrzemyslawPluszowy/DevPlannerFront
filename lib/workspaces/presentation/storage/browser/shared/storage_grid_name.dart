import 'package:flutter/material.dart';

/// Two-line grid label; the full name remains available to keyboard and AX.
final class StorageGridName extends StatefulWidget {
  const StorageGridName({required this.name, this.style, super.key});

  final String name;
  final TextStyle? style;

  @override
  State<StorageGridName> createState() => _StorageGridNameState();
}

final class _StorageGridNameState extends State<StorageGridName> {
  final _tooltipKey = GlobalKey<TooltipState>();
  bool _focused = false;

  void _onFocusChanged(bool focused) {
    if (focused) {
      _tooltipKey.currentState?.ensureTooltipVisible();
    } else {
      Tooltip.dismissAllToolTips();
    }
    if (_focused != focused) setState(() => _focused = focused);
  }

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
    onFocusChange: _onFocusChanged,
    child: Tooltip(
      key: _tooltipKey,
      message: widget.name,
      excludeFromSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: _focused
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          widget.name,
          semanticsLabel: widget.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        ),
      ),
    ),
  );
}
