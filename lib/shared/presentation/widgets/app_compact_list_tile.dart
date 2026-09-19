import 'dart:async';

import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Kompaktowy tile pod web desktop do gestych list danych.
class AppCompactListTile extends StatefulWidget {
  /// Tworzy kompaktowy tile listy danych.
  const AppCompactListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.meta,
    this.footer,
    this.onTap,
    this.selected = false,
    this.enabled = true,
    this.hoverable = true,
    this.titleSelectable = false,
    this.subtitleSelectable = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Sizes.p12,
      vertical: Sizes.p10,
    ),
    this.borderRadius = const BorderRadius.all(.circular(Sizes.p10)),
  });

  /// Glowny tytul rekordu.
  final String title;

  /// Dodatkowy opis rekordu.
  final String? subtitle;

  /// Leading rekordu.
  final Widget? leading;

  /// Trailing rekordu.
  final Widget? trailing;

  /// Zwarta linia meta-informacji lub dowolny widget pod tytulem.
  final Widget? meta;

  /// Opcjonalna trzecia linia, np. uwagi.
  final Widget? footer;

  /// Akcja klikniecia rekordu.
  final VoidCallback? onTap;

  /// Flaga zaznaczenia rekordu.
  final bool selected;

  /// Flaga aktywnosci rekordu.
  final bool enabled;

  /// Czy rekord ma reagowac hoverem.
  final bool hoverable;

  /// Czy tytul ma byc zaznaczalny.
  final bool titleSelectable;

  /// Czy subtitle ma byc zaznaczalny.
  final bool subtitleSelectable;

  /// Padding rekordu.
  final EdgeInsetsGeometry padding;

  /// Border radius rekordu.
  final BorderRadius borderRadius;

  @override
  State<AppCompactListTile> createState() => _AppCompactListTileState();
}

class _AppCompactListTileState extends State<AppCompactListTile> {
  static const _hoverExitDelay = Duration(milliseconds: 40);

  var _isHovered = false;
  Timer? _hoverExitTimer;

  void _cancelPendingHoverExit() {
    _hoverExitTimer?.cancel();
    _hoverExitTimer = null;
  }

  void _handleHoverEnter() {
    if (!widget.enabled || !widget.hoverable) {
      return;
    }
    _cancelPendingHoverExit();
    if (!_isHovered) {
      setState(() => _isHovered = true);
    }
  }

  void _handleHoverExit() {
    if (!_isHovered) {
      return;
    }
    _cancelPendingHoverExit();
    _hoverExitTimer = Timer(_hoverExitDelay, () {
      if (!mounted || !_isHovered) {
        return;
      }
      setState(() => _isHovered = false);
    });
  }

  @override
  void dispose() {
    _cancelPendingHoverExit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;

    final background = switch ((widget.selected, _isHovered)) {
      (true, _) => surfaceRoles.tintedBackground,
      (false, true) => Color.alphaBlend(
        surfaceRoles.hoverOverlay,
        surfaceRoles.baseBackground,
      ),
      _ => Colors.transparent,
    };

    final borderColor = switch ((widget.selected, _isHovered)) {
      (true, _) => surfaceRoles.tintedBorder,
      (false, true) => surfaceRoles.baseBorder,
      _ => Colors.transparent,
    };

    final titleStyle = context.text.bodyMedium?.copyWith(
      color: widget.enabled
          ? colors.onSurface
          : colors.onSurfaceVariant.withValues(alpha: .6),
      fontWeight: widget.selected ? .w700 : .w600,
    );

    final subtitleStyle = context.text.bodySmall?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return MouseRegion(
      cursor: widget.onTap == null ? .defer : SystemMouseCursors.click,
      onEnter: (_) => _handleHoverEnter(),
      onExit: (_) => _handleHoverExit(),
      child: InkWell(
        onTap: widget.enabled ? widget.onTap : null,
        borderRadius: widget.borderRadius,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: background,
            borderRadius: widget.borderRadius,
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: widget.padding,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    if (widget.leading != null) ...[widget.leading!, Gaps.w8],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          AppText(
                            widget.title,
                            selectable: widget.titleSelectable,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle,
                          ),
                          if (widget.subtitle case final value?) ...[
                            Gaps.h2,
                            AppText(
                              value,
                              selectable: widget.subtitleSelectable,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: subtitleStyle,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.trailing != null) ...[Gaps.w8, widget.trailing!],
                  ],
                ),
                if (widget.meta != null) ...[
                  const SizedBox(height: 6),
                  widget.meta!,
                ],
                if (widget.footer != null) ...[
                  Gaps.h8,
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: surfaceRoles.baseBorder.withValues(alpha: .72),
                  ),
                  Gaps.h8,
                  widget.footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
