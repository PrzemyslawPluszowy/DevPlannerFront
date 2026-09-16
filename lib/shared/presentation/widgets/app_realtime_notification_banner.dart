import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';

/// Nowoczesny baner powiadomień realtime wzorowany na pasku ClickUp.
///
/// Informuje użytkownika o możliwości włączenia powiadomień w czasie
/// rzeczywistym lub o statusie synchronizacji. Pozwala szybko włączyć
/// powiadomienia albo odłożyć komunikat.
class AppRealtimeNotificationBanner extends StatefulWidget {
  /// Tworzy baner powiadomień realtime.
  const AppRealtimeNotificationBanner({
    super.key,
    this.message = 'Nie przegap ważnych aktualizacji. Włącz powiadomienia w czasie rzeczywistym.',
    this.onEnable,
    this.onSnooze,
    this.onDismiss,
    this.initiallyVisible = true,
  });

  /// Treść komunikatu.
  final String message;

  /// Akcja włączenia powiadomień.
  final VoidCallback? onEnable;

  /// Akcja odłożenia przypomnienia.
  final VoidCallback? onSnooze;

  /// Akcja trwałego zamknięcia banera.
  final VoidCallback? onDismiss;

  /// Czy baner jest początkowo widoczny.
  final bool initiallyVisible;

  @override
  State<AppRealtimeNotificationBanner> createState() =>
      _AppRealtimeNotificationBannerState();
}

class _AppRealtimeNotificationBannerState
    extends State<AppRealtimeNotificationBanner> {
  late bool _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = widget.initiallyVisible;
  }

  void _dismiss() {
    setState(() => _isVisible = false);
    widget.onDismiss?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bannerBg = isDark
        ? Color.alphaBlend(
            colors.primary.withValues(alpha: .28),
            colors.surfaceContainerHigh,
          )
        : Color.alphaBlend(
            colors.primary.withValues(alpha: .92),
            const Color(0xFF5B3CC4),
          );

    const textColor = Colors.white;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p4,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .30 : .12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(Sizes.p4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              AppIcons.notifications,
              size: 14,
              color: Colors.white,
            ),
          ),
          Gaps.w12,
          Expanded(
            child: Text(
              widget.message,
              style: context.text.labelMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                letterSpacing: .1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gaps.w12,
          FilledButton(
            onPressed: () {
              widget.onEnable?.call();
              _dismiss();
            },
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? colors.primary : Colors.white,
              foregroundColor: isDark
                  ? colors.onPrimary
                  : const Color(0xFF5B3CC4),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p4,
              ),
              minimumSize: const Size(0, 28),
              visualDensity: VisualDensity.compact,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              textStyle: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            child: const Text('Włącz'),
          ),
          Gaps.w8,
          OutlinedButton(
            onPressed: () {
              widget.onSnooze?.call();
              _dismiss();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.white.withValues(alpha: .5),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p10,
                vertical: Sizes.p4,
              ),
              minimumSize: const Size(0, 28),
              visualDensity: VisualDensity.compact,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              textStyle: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Później'),
          ),
          Gaps.w4,
          IconButton(
            tooltip: Overlay.maybeOf(context) == null ? null : 'Zamknij baner',
            visualDensity: VisualDensity.compact,
            iconSize: 16,
            color: Colors.white.withValues(alpha: .85),
            onPressed: _dismiss,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}
