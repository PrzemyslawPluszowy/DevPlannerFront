import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/modules/app_modules_catalog.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/features/settings/domain/local_settings_model.dart';

/// Lista modułów raila z trwałym, lokalnym sortowaniem użytkownika.
class AppGlobalRailModuleList extends StatelessWidget {
  const AppGlobalRailModuleList({
    required this.isExpanded,
    required this.router,
    required this.defaultModuleOrder,
    required this.moduleLabels,
    required this.moduleIcons,
    required this.background,
    required this.activeBackground,
    required this.hover,
    required this.foreground,
    required this.onCollapse,
    super.key,
  });

  static const storageId = 'global_main_modules_order';
  final bool isExpanded;
  final AppRouter router;
  final List<String> defaultModuleOrder;
  final Map<String, String> moduleLabels;
  final Map<String, IconData> moduleIcons;
  final Color background;
  final Color activeBackground;
  final Color hover;
  final Color foreground;
  final VoidCallback onCollapse;

  bool _isActive(String route) {
    final path = router.currentPath.trim().isNotEmpty
        ? router.currentPath.trim()
        : Uri.base.path.trim();
    final activeModule = AppModulesCatalog.findByPath(path);
    if (activeModule != null) {
      return activeModule.routePath == route;
    }
    return path == route || (route != '/' && path.startsWith('$route/'));
  }

  Widget _tile(
    BuildContext context,
    String route,
    int index, {
    required bool reorderable,
  }) {
    final label = moduleLabels[route]!;
    final active = _isActive(route);

    final iconWidget = Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: active
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              )
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: active
            ? [
                BoxShadow(
                  color: const Color(0xFF6366F1).withValues(alpha: .45),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          moduleIcons[route],
          color: active ? Colors.white : foreground,
          size: 20,
        ),
      ),
    );

    final tile = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isExpanded ? Sizes.p8 : Sizes.p4,
        vertical: 3,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  unawaited(router.navigatePath(route));
                  if (isExpanded) onCollapse();
                },
                hoverColor: Colors.white.withValues(alpha: .08),
                borderRadius: const BorderRadius.all(Radius.circular(Sizes.p8)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isExpanded ? Sizes.p8 : 0,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: isExpanded
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      iconWidget,
                      if (isExpanded) ...[
                        const SizedBox(width: Sizes.p10),
                        Expanded(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.labelMedium?.copyWith(
                              color: active ? Colors.white : foreground,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              letterSpacing: .1,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (isExpanded) ...[
              Gaps.w4,
              if (reorderable)
                MouseRegion(
                  cursor: SystemMouseCursors.grab,
                  child: ReorderableDragStartListener(
                    index: index,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Icon(
                        Icons.drag_indicator_rounded,
                        size: 18,
                        color: foreground.withValues(alpha: .8),
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    size: 18,
                    color: foreground.withValues(alpha: .8),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
    return isExpanded || Overlay.maybeOf(context) == null
        ? tile
        : Tooltip(
            message: label,
            waitDuration: const Duration(milliseconds: 350),
            child: tile,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: router,
      builder: (context, _) =>
          BlocBuilder<LocalSettingsCubit, LocalSettingsModel>(
            builder: (context, state) {
              final ordered = context.read<LocalSettingsCubit>().orderedMenuIds(
                menuId: storageId,
                defaultOrder: defaultModuleOrder,
              );

              Widget itemBuilder(
                BuildContext itemContext,
                int index, {
                required bool reorderable,
              }) {
                final route = ordered[index];
                final tileWidget = _tile(
                  itemContext,
                  route,
                  index,
                  reorderable: reorderable,
                );
                final content = (!isExpanded && reorderable)
                    ? ReorderableDragStartListener(
                        index: index,
                        child: tileWidget,
                      )
                    : tileWidget;

                return Padding(
                  key: ValueKey(route),
                  padding: EdgeInsets.only(
                    bottom: index == ordered.length - 1 ? 0 : Sizes.p8,
                  ),
                  child: content,
                );
              }

              return Overlay.wrap(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  physics: const ClampingScrollPhysics(),
                  proxyDecorator: (child, index, animation) => Material(
                    color: Colors.transparent,
                    elevation: 8,
                    shadowColor: Colors.black.withValues(alpha: .5),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: child,
                  ),
                  itemCount: ordered.length,
                  onReorderItem: (oldIndex, newIndex) {
                    if (oldIndex == newIndex ||
                        oldIndex < 0 ||
                        oldIndex >= ordered.length ||
                        newIndex < 0 ||
                        newIndex >= ordered.length) {
                      return;
                    }
                    final next = List<String>.of(ordered);
                    final moved = next.removeAt(oldIndex);
                    next.insert(newIndex, moved);
                    unawaited(
                      context.read<LocalSettingsCubit>().setMenuOrder(
                        menuId: storageId,
                        orderedIds: next,
                      ),
                    );
                  },
                  itemBuilder: (itemContext, index) =>
                      itemBuilder(itemContext, index, reorderable: true),
                ),
              );
            },
          ),
    );
  }
}
