import 'package:flutter/material.dart';

import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Kontroler rozszerzanego side sheeta.
class AppExpandableSideSheetController extends ValueNotifier<bool> {
  /// Tworzy kontroler side sheeta.
  AppExpandableSideSheetController({bool expanded = false}) : super(expanded);

  /// Czy panel jest rozszerzony.
  bool get isExpanded => value;

  /// Rozszerza panel.
  void expand() => value = true;

  /// Zamyka rozszerzoną sekcję i wraca do szerokości bazowej.
  void collapse() => value = false;

  /// Przełącza stan rozszerzenia.
  void toggle() => value = !value;
}

/// Buduje body rozszerzanego side sheeta.
typedef AppExpandableSideSheetBodyBuilder = Widget Function(
  BuildContext context,
  AppExpandableSideSheetController controller,
);

/// Wspólny side sheet z animowaną zmianą szerokości.
class AppExpandableSideSheet {
  /// Otwiera side sheet z animowaną szerokością.
  static Future<T?> show<T>(
    BuildContext context, {
    required double collapsedWidth,
    required double expandedWidth,
    required AppExpandableSideSheetBodyBuilder bodyBuilder,
    String? title,
    String? subtitle,
    Widget? footer,
    Widget? leading,
    List<Widget>? headerActions,
    bool barrierDismissible = true,
    bool canClose = true,
    bool isBusy = false,
    bool showCloseButton = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(Sizes.p16),
    double minBodyHeight = 180,
    double maxBodyHeight = double.infinity,
    bool scrollBody = true,
    double? collapsedWidthFactor,
    double? expandedWidthFactor,
    double maxWidthFactor = .96,
    bool useRootNavigator = true,
  }) async {
    final controller = AppExpandableSideSheetController();

    try {
      return await AppModalHost.showSideSheet<T>(
        context,
        navigatorScope: AppModalHost.navigatorScopeFor(useRootNavigator),
        barrierDismissible: barrierDismissible,
        canClose: !(isBusy || !canClose),
        builder: (dialogContext) => SafeArea(
          child: Align(
            alignment: .centerRight,
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, isExpanded, _) {
                final viewportWidth = MediaQuery.sizeOf(context).width;
                final maxAllowedWidth = viewportWidth * maxWidthFactor;
                final preferredWidth = switch ((
                  isExpanded,
                  collapsedWidthFactor,
                  expandedWidthFactor,
                )) {
                  (false, final double factor?, _) => viewportWidth * factor,
                  (true, _, final double factor?) => viewportWidth * factor,
                  (false, _, _) => collapsedWidth,
                  (true, _, _) => expandedWidth,
                };
                // Web pozwala zawęzić okno znacznie poniżej desktopowego
                // minimum. Panel nie może wtedy wymuszać overflowu poza
                // viewport; jego szerokość nadal ma bezpieczny margines.
                final targetWidth = preferredWidth.clamp(
                  0.0,
                  maxAllowedWidth,
                );

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  width: targetWidth,
                  height: double.infinity,
                  child: _AppExpandableSideSheetPanel(
                    title: title,
                    subtitle: subtitle,
                    body: bodyBuilder(context, controller),
                    footer: footer,
                    leading: leading,
                    headerActions: headerActions,
                    padding: padding,
                    showCloseButton: showCloseButton,
                    isBusy: isBusy,
                    canClose: canClose,
                    onClose: () => Navigator.of(dialogContext).maybePop(),
                    minBodyHeight: minBodyHeight,
                    maxBodyHeight: maxBodyHeight,
                    scrollBody: scrollBody,
                  ),
                );
              },
            ),
          ),
        ),
      );
    } finally {
      controller.dispose();
    }
  }
}

/// Panel wizualny rozszerzanego side sheeta.
class _AppExpandableSideSheetPanel extends StatelessWidget {
  /// Tworzy panel rozszerzanego side sheeta.
  const _AppExpandableSideSheetPanel({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
    required this.leading,
    required this.headerActions,
    required this.padding,
    required this.showCloseButton,
    required this.isBusy,
    required this.canClose,
    required this.onClose,
    required this.minBodyHeight,
    required this.maxBodyHeight,
    required this.scrollBody,
  });

  final String? title;
  final String? subtitle;
  final Widget body;
  final Widget? footer;
  final Widget? leading;
  final List<Widget>? headerActions;
  final EdgeInsetsGeometry padding;
  final bool showCloseButton;
  final bool isBusy;
  final bool canClose;
  final VoidCallback? onClose;
  final double minBodyHeight;
  final double maxBodyHeight;
  final bool scrollBody;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockClose = isBusy || !canClose;
    final titleStyle = context.text.titleLarge?.copyWith(fontWeight: .w700);
    final subtitleStyle = context.text.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Material(
      color: colors.surfaceContainerLowest,
      elevation: 8,
      clipBehavior: .antiAlias,
      child: Column(
        mainAxisSize: maxBodyHeight == double.infinity ? .max : .min,
        children: [
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                if (leading != null) ...[leading!, Gaps.w12],
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (title != null) Text(title!, style: titleStyle),
                      if (subtitle != null) ...[
                        if (title != null) Gaps.h4,
                        Text(subtitle!, style: subtitleStyle),
                      ],
                    ],
                  ),
                ),
                if (headerActions != null)
                  Row(mainAxisSize: .min, children: headerActions!),
                if (showCloseButton)
                  IconButton(
                    onPressed: blockClose
                        ? null
                        : (onClose ?? () => Navigator.of(context).maybePop()),
                    tooltip: 'Zamknij',
                    icon: const Icon(Icons.close_rounded),
                  ),
              ],
            ),
          ),
          Flexible(
            fit: maxBodyHeight == double.infinity
                ? FlexFit.tight
                : FlexFit.loose,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minBodyHeight,
                maxHeight: maxBodyHeight,
              ),
              child: scrollBody
                  ? SingleChildScrollView(padding: padding, child: body)
                  : Padding(
                      padding: padding,
                      child: SizedBox.expand(child: body),
                    ),
            ),
          ),
          if (footer case final value)
            Container(
              width: double.infinity,
              padding: padding,
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                border: Border(top: BorderSide(color: colors.outlineVariant)),
              ),
              child: value,
            ),
        ],
      ),
    );
  }
}
