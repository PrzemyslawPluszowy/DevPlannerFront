import 'package:flutter/material.dart';

import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet_panel.dart';

enum AppModalSheetSize { small, medium, large, fullscreen }

/// Wspolny modal/sheet do formularzy i ekranow CRUD.
///
/// Komponent jest tylko kontenerem UI:
/// - naglowek (tytul + podtytul + akcje),
/// - scrollowalne body,
/// - opcjonalny sticky footer.
///
/// Stan (np. BLoC initial/loading/loaded/error) trzymamy poza nim.
class AppModalSheet extends StatelessWidget {
  const AppModalSheet({
    required this.body,
    super.key,
    this.title,
    this.subtitle,
    this.footer,
    this.leading,
    this.headerActions,
    this.size = AppModalSheetSize.medium,
    this.padding = const EdgeInsets.all(Sizes.p16),
    this.showCloseButton = true,
    this.isBusy = false,
    this.canClose = true,
    this.onClose,
    this.minBodyHeight = 180,
    this.maxBodyHeight = 560,
    this.scrollBody = true,
  });

  final String? title;
  final String? subtitle;
  final Widget body;
  final Widget? footer;
  final Widget? leading;
  final List<Widget>? headerActions;
  final AppModalSheetSize size;
  final EdgeInsetsGeometry padding;
  final bool showCloseButton;
  final bool isBusy;
  final bool canClose;
  final VoidCallback? onClose;
  final double minBodyHeight;
  final double maxBodyHeight;
  final bool scrollBody;

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget body,
    String? title,
    String? subtitle,
    Widget? footer,
    Widget? leading,
    List<Widget>? headerActions,
    AppModalSheetSize size = AppModalSheetSize.medium,
    bool barrierDismissible = true,
    bool canClose = true,
    bool isBusy = false,
    bool showCloseButton = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(Sizes.p16),
    double minBodyHeight = 180,
    double maxBodyHeight = 560,
    bool scrollBody = true,
    bool useRootNavigator = true,
  }) {
    return AppModalHost.showDialog<T>(
      context,
      navigatorScope: AppModalHost.navigatorScopeFor(useRootNavigator),
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        return AppModalSheet(
          title: title,
          subtitle: subtitle,
          body: body,
          footer: footer,
          leading: leading,
          headerActions: headerActions,
          size: size,
          canClose: canClose,
          isBusy: isBusy,
          showCloseButton: showCloseButton,
          padding: padding,
          minBodyHeight: minBodyHeight,
          maxBodyHeight: maxBodyHeight,
          scrollBody: scrollBody,
          onClose: () => Navigator.of(dialogContext).maybePop(),
        );
      },
    );
  }

  static Future<T?> showSideSheet<T>(
    BuildContext context, {
    required Widget body,
    String? title,
    String? subtitle,
    Widget? footer,
    Widget? leading,
    List<Widget>? headerActions,
    AppModalSheetSize size = AppModalSheetSize.medium,
    bool barrierDismissible = true,
    bool canClose = true,
    bool isBusy = false,
    bool showCloseButton = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(Sizes.p16),
    double minBodyHeight = 180,
    double maxBodyHeight = double.infinity,
    double? width,
    bool scrollBody = true,
    bool useRootNavigator = true,
  }) {
    final effectiveWidth = width ?? _maxWidthForStatic(size) ?? 760;

    return AppModalHost.showSideSheet<T>(
      context,
      navigatorScope: AppModalHost.navigatorScopeFor(useRootNavigator),
      barrierDismissible: barrierDismissible,
      canClose: !(isBusy || !canClose),
      builder: (dialogContext) => SafeArea(
        child: Align(
          alignment: .centerRight,
          child: LayoutBuilder(
            builder: (context, constraints) => SizedBox(
              width: effectiveWidth.clamp(0.0, constraints.maxWidth),
              height: double.infinity,
              child: AppModalSheetPanel(
                title: title,
                subtitle: subtitle,
                body: body,
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
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
      ),
    );
  }

  double? _maxWidthFor(AppModalSheetSize modalSize) {
    return _maxWidthForStatic(modalSize);
  }

  static double? _maxWidthForStatic(AppModalSheetSize modalSize) {
    return switch (modalSize) {
      AppModalSheetSize.small => 520,
      AppModalSheetSize.medium => 760,
      AppModalSheetSize.large => 1080,
      AppModalSheetSize.fullscreen => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = _maxWidthFor(size);
    final blockClose = isBusy || !canClose;
    final panel = AppModalSheetPanel(
      title: title,
      subtitle: subtitle,
      body: body,
      footer: footer,
      leading: leading,
      headerActions: headerActions,
      padding: padding,
      showCloseButton: showCloseButton,
      isBusy: isBusy,
      canClose: canClose,
      onClose: onClose,
      minBodyHeight: minBodyHeight,
      maxBodyHeight: size == AppModalSheetSize.fullscreen
          ? double.infinity
          : maxBodyHeight,
      scrollBody: scrollBody,
      borderRadius: size == AppModalSheetSize.fullscreen
          ? BorderRadius.zero
          : const BorderRadius.all(.circular(Sizes.p16)),
    );

    return PopScope(
      canPop: !blockClose,
      child: Dialog(
        insetPadding: size == AppModalSheetSize.fullscreen
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
                horizontal: Sizes.p24,
                vertical: Sizes.p24,
              ),
        backgroundColor: Colors.transparent,
        child: size == AppModalSheetSize.fullscreen
            ? SizedBox.expand(child: panel)
            : ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth ?? double.infinity,
                ),
                child: panel,
              ),
      ),
    );
  }
}
