import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:flutter/material.dart';

/// Pozycja pozioma sheeta.
///
/// Sheet zawsze wyjezdza z dolu (`showModalBottomSheet`),
/// a ten enum steruje tylko ustawieniem: lewo/srodek/prawo.
enum AppSheetAnchor { middleLeft, middleCenter, middleRight }

/// Prosty wrapper na materialowy `DraggableScrollableSheet`.
///
/// Zachowanie:
/// - zawsze wyjazd z dolu,
/// - drag + scroll w jednym kontrolerze,
/// - mozliwosc ustawienia szerokosci i pozycji poziomej.
abstract final class AppDraggableSheet {
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget Function(
      BuildContext context,
      ScrollController scrollController,
    )
    builder,
    String? title,
    AppSheetAnchor anchor = AppSheetAnchor.middleCenter,
    bool barrierDismissible = true,
    EdgeInsets margin = const EdgeInsets.fromLTRB(
      Sizes.p16,
      Sizes.p16,
      Sizes.p16,
      0,
    ),
    double width = 720,
    double minHeight = 280,
    double initialHeight = 320,
    double maxHeight = 760,
    bool showDragHandle = true,
    bool showCloseButton = true,
    BorderRadius borderRadius = const BorderRadius.vertical(
      top: Radius.circular(Sizes.p16),
    ),
    bool useRootNavigator = true,
  }) {
    final viewportWidth = MediaQuery.sizeOf(context).width;

    return DevPlannerModalHost.showBottomSheet<T>(
      context,
      navigatorScope: DevPlannerModalHost.navigatorScopeFor(useRootNavigator),
      barrierDismissible: barrierDismissible,
      constraints: BoxConstraints(maxWidth: viewportWidth),
      builder: (sheetContext) {
        final media = MediaQuery.sizeOf(sheetContext);
        final safeWidth = (media.width - margin.horizontal).clamp(
          0.0,
          media.width,
        );
        final resolvedWidth = width > safeWidth ? safeWidth : width;
        final availableHeight = (media.height - margin.vertical).clamp(
          minHeight,
          maxHeight,
        );
        final safeInitialHeight = initialHeight.clamp(
          minHeight,
          availableHeight,
        );

        final minChildSize = (minHeight / availableHeight).clamp(0.1, 1.0);
        final initialChildSize = (safeInitialHeight / availableHeight).clamp(
          minChildSize,
          1.0,
        );

        return SafeArea(
          top: false,
          child: Stack(
            children: [
              if (barrierDismissible)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: .opaque,
                    onTap: () => Navigator.of(sheetContext).maybePop(),
                    child: const SizedBox.expand(),
                  ),
                ),
              Padding(
                padding: margin,
                child: DraggableScrollableSheet(
                  expand: false,
                  minChildSize: minChildSize,
                  initialChildSize: initialChildSize,
                  builder: (context, scrollController) {
                    return Align(
                      alignment: _alignmentFor(anchor),
                      child: SizedBox(
                        width: resolvedWidth,
                        child: Material(
                          color: context.colors.surfaceContainerLowest,
                          elevation: 10,
                          borderRadius: borderRadius,
                          clipBehavior: .antiAlias,
                          child: Column(
                            crossAxisAlignment: .stretch,
                            children: [
                              _SheetHeader(
                                title: title,
                                showDragHandle: showDragHandle,
                                showCloseButton: showCloseButton,
                                onClose: () =>
                                    Navigator.of(sheetContext).maybePop(),
                              ),
                              Expanded(
                                child: builder(context, scrollController),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Alignment _alignmentFor(AppSheetAnchor anchor) {
    return switch (anchor) {
      AppSheetAnchor.middleLeft => .bottomLeft,
      AppSheetAnchor.middleCenter => .bottomCenter,
      AppSheetAnchor.middleRight => .bottomRight,
    };
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.showDragHandle,
    required this.showCloseButton,
    required this.onClose,
  });

  final String? title;
  final bool showDragHandle;
  final bool showCloseButton;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        Sizes.p12,
        Sizes.p8,
        Sizes.p12,
        Sizes.p8,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: context.colors.outlineVariant),
        ),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          SizedBox(
            height: Sizes.p24,
            child: Stack(
              alignment: .center,
              children: [
                if (showDragHandle)
                  Container(
                    width: Sizes.p32,
                    height: Sizes.p4,
                    decoration: BoxDecoration(
                      color: context.colors.outline,
                      borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                    ),
                  ),
                if (showCloseButton)
                  Align(
                    alignment: .topRight,
                    child: IconButton(
                      onPressed: onClose,
                      tooltip: 'Zamknij',
                      visualDensity: .compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: Sizes.p24,
                        minHeight: Sizes.p24,
                      ),
                      icon: const Icon(Icons.close_rounded, size: Sizes.p20),
                    ),
                  ),
              ],
            ),
          ),
          if (title != null) ...[
            Gaps.h4,
            Align(
              alignment: .centerLeft,
              child: Text(
                title!,
                style: context.text.titleSmall?.copyWith(fontWeight: .w700),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
