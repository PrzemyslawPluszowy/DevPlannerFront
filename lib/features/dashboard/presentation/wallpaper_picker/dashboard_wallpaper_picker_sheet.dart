import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Pokazuje dolny picker tapet dashboardu.
Future<String?> showDashboardWallpaperPickerSheet(
  BuildContext context, {
  required DashboardPreferences preferences,
}) {
  final wallpapers = preferences.builtInWallpaperPaths;

  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    constraints: const BoxConstraints(),
    builder: (context) {
      return _DashboardWallpaperPickerSheet(
        wallpapers: wallpapers,
        selectedWallpaperPath: preferences.selectedWallpaperPath,
      );
    },
  );
}

/// Dolny picker tapet dashboardu.
class _DashboardWallpaperPickerSheet extends StatefulWidget {
  /// Tworzy dolny picker tapet dashboardu.
  const _DashboardWallpaperPickerSheet({
    required this.wallpapers,
    required this.selectedWallpaperPath,
  });

  /// Lista dostępnych ścieżek tapet.
  final List<String> wallpapers;

  /// Aktualnie zaznaczona tapeta.
  final String selectedWallpaperPath;

  @override
  State<_DashboardWallpaperPickerSheet> createState() =>
      _DashboardWallpaperPickerSheetState();
}

/// Stan dolnego pickera tapet dashboardu.
class _DashboardWallpaperPickerSheetState
    extends State<_DashboardWallpaperPickerSheet> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_scrollController.hasClients) {
      return;
    }

    final nextOffset =
        _scrollController.offset + event.scrollDelta.dy + event.scrollDelta.dx;
    final clampedOffset = nextOffset.clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );
    if (clampedOffset == _scrollController.offset) {
      return;
    }

    _scrollController.jumpTo(clampedOffset);
  }

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final sheetWidth = screenWidth - (Sizes.p16 * 2);
    const sheetHeight = 250.0;

    return Padding(
      padding: EdgeInsets.only(
        left: Sizes.p16,
        right: Sizes.p16,
        bottom: MediaQuery.paddingOf(context).bottom + Sizes.p16,
        top: Sizes.p16,
      ),
      child: SizedBox(
        width: sheetWidth,
        height: sheetHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLow,
            borderRadius: const BorderRadius.all(.circular(Sizes.p20)),
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: .6),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(.circular(Sizes.p20)),
            child: Padding(
              padding: const .fromLTRB(
                Sizes.p16,
                Sizes.p12,
                Sizes.p16,
                Sizes.p16,
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.colors.outlineVariant,
                        borderRadius: const BorderRadius.all(.circular(999)),
                      ),
                    ),
                  ),
                  Gaps.h12,
                  AppText(
                    intl.dashboardWallpaperPickerTitle,
                    style: context.text.titleMedium?.copyWith(
                      fontWeight: .w700,
                    ),
                  ),
                  Gaps.h4,
                  AppText(
                    intl.dashboardWallpaperPickerSubtitle,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                  Gaps.h12,
                  Expanded(
                    child: ClipRect(
                      child: Listener(
                        onPointerSignal: _handlePointerSignal,
                        child: ScrollConfiguration(
                          behavior: const MaterialScrollBehavior().copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.trackpad,
                              PointerDeviceKind.stylus,
                              PointerDeviceKind.invertedStylus,
                            },
                          ),
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView.separated(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              padding: const .fromLTRB(0, 0, 0, Sizes.p20),
                              itemCount: widget.wallpapers.length,
                              separatorBuilder: (_, _) => Gaps.w16,
                              itemBuilder: (context, index) {
                                final wallpaperPath = widget.wallpapers[index];
                                return _DashboardWallpaperTile(
                                  wallpaperPath: wallpaperPath,
                                  isSelected:
                                      wallpaperPath ==
                                      widget.selectedWallpaperPath,
                                  onTap: () =>
                                      Navigator.of(context).pop(wallpaperPath),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kafelek pojedynczej tapety w pickerze dashboardu.
class _DashboardWallpaperTile extends StatelessWidget {
  /// Tworzy kafelek pojedynczej tapety.
  const _DashboardWallpaperTile({
    required this.wallpaperPath,
    required this.isSelected,
    required this.onTap,
  });

  /// Ścieżka tapety.
  final String wallpaperPath;

  /// Czy tapeta jest aktualnie aktywna.
  final bool isSelected;

  /// Akcja wyboru tapety.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageProvider = _wallpaperProvider(wallpaperPath);
    const tileRadius = BorderRadius.all(.circular(Sizes.p16));

    return SizedBox(
      width: 340,
      child: ClipRRect(
        borderRadius: tileRadius,
        clipBehavior: Clip.hardEdge,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: tileRadius,
                border: Border.all(
                  color: isSelected
                      ? context.colors.primary
                      : context.colors.outlineVariant.withValues(alpha: .7),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.surfaceContainerHighest,
                      image: imageProvider == null
                          ? null
                          : DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: .08),
                          Colors.black.withValues(alpha: .38),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: Sizes.p12,
                    right: Sizes.p12,
                    bottom: Sizes.p12,
                    child: Row(
                      children: [
                        Expanded(
                          child: AppText(
                            _labelFromPath(wallpaperPath),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: .w700,
                            ),
                          ),
                        ),
                        if (isSelected) ...[
                          Gaps.w8,
                          Icon(
                            Icons.check_circle_rounded,
                            color: context.colors.primaryFixed,
                            size: Sizes.p20,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageProvider<Object>? _wallpaperProvider(String wallpaperPath) {
    if (wallpaperPath.startsWith('assets/')) {
      return AssetImage(wallpaperPath);
    }

    if (!kIsWeb) {
      return FileImage(File(wallpaperPath));
    }

    return null;
  }

  String _labelFromPath(String wallpaperPath) {
    final normalized = wallpaperPath.split('/').last;
    final name = normalized.split('.').first;
    return name.replaceAll('_', ' ').toUpperCase();
  }
}
