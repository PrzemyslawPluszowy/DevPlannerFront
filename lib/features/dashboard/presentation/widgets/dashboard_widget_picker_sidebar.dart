import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_preferences.dart';
import 'package:ready_next/features/dashboard/domain/models/dashboard_widget_preference.dart';
import 'package:ready_next/features/dashboard/domain/services/dashboard_desktop_layout_engine.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_wrapper.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widgets_catalog.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Panel boczny (Sidebar) dodawania widgetów pulpitu w stylu macOS.
///
/// Umożliwia filtrowanie według kategorii, wybór rozmiaru oraz dodawanie widgetu na pulpit.
class DashboardWidgetPickerSidebar extends StatefulWidget {
  /// Tworzy panel boczny dodawania widgetów.
  const DashboardWidgetPickerSidebar({
    required this.desktopSize,
    required this.onClose,
    super.key,
  });

  /// Rozmiar dostępnego pulpitu.
  final Size desktopSize;

  /// Akcja wywoływana przy zamknięciu panelu.
  final VoidCallback onClose;

  @override
  State<DashboardWidgetPickerSidebar> createState() =>
      _DashboardWidgetPickerSidebarState();
}

class _DashboardWidgetPickerSidebarState
    extends State<DashboardWidgetPickerSidebar> {
  String _selectedCategory = '';

  /// Przechowuje aktualnie zaznaczony rozmiar dla każdego typu widgetu (typeId -> selectedSize).
  final Map<String, DashboardWidgetSize> _selectedSizes = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardPreferencesCubit, DashboardPreferences>(
      builder: (context, preferences) {
        final permissions = context.select<AuthCubit, Set<String>>(
          (cubit) => switch (cubit.state) {
            AuthAuthenticated(:final user) => user?.permissions ?? const {},
            _ => const {},
          },
        );
        final definitions = DashboardWidgetsCatalog.definitionsFor(permissions);
        final intl = context.l10n;

        // Pobieramy unikalne kategorie
        final categories = [
          intl.dashboardWidgetCategoryAll,
          ...definitions.map((d) => d.category(context)).toSet(),
        ];

        // Filtrujemy widgety
        final filteredDefinitions =
            _selectedCategory.isEmpty ||
                _selectedCategory == intl.dashboardWidgetCategoryAll
            ? definitions
            : definitions
                  .where((d) => d.category(context) == _selectedCategory)
                  .toList();

        final wallpaperPath = preferences.selectedWallpaperPath;

        return Container(
          width: 760,
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerLowest.withValues(alpha: .95),
            borderRadius: const BorderRadius.all(.circular(Sizes.p24)),
            border: Border.all(
              color: context.colors.outlineVariant.withValues(alpha: .5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .24),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              // 1. Lewy panel - Kategorie
              Container(
                width: 160,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: context.colors.outlineVariant.withValues(
                        alpha: .5,
                      ),
                      width: 0.5,
                    ),
                  ),
                ),
                child: ListView.builder(
                  padding: const .symmetric(vertical: Sizes.p16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = cat == _selectedCategory;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        },
                        child: Container(
                          padding: const .symmetric(
                            horizontal: Sizes.p12,
                            vertical: Sizes.p10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.colors.primary.withValues(alpha: 0.08)
                                : Colors.transparent,
                            border: Border(
                              left: BorderSide(
                                color: isSelected
                                    ? context.colors.primary
                                    : Colors.transparent,
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: AppText(
                            cat,
                            style: context.text.labelLarge?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? context.colors.primary
                                  : context.colors.onSurface,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // 2. Prawy panel - Lista widgetów
              Expanded(
                child: Padding(
                  padding: const .all(Sizes.p16),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            intl.dashboardWidgetPickerTitle,
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: .w800,
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close_rounded),
                            tooltip: intl.dashboardWidgetPickerCloseTooltip,
                          ),
                        ],
                      ),
                      Gaps.h12,
                      Expanded(
                        child: ListView.separated(
                          itemCount: filteredDefinitions.length,
                          separatorBuilder: (context, index) => Gaps.h16,
                          itemBuilder: (context, index) {
                            final def = filteredDefinitions[index];
                            final currentSelectedSize =
                                _selectedSizes[def.typeId] ?? def.defaultSize;

                            return _WidgetCatalogItem(
                              definition: def,
                              selectedSize: currentSelectedSize,
                              wallpaperPath: wallpaperPath,
                              onSizeSelected: (size) {
                                setState(() {
                                  _selectedSizes[def.typeId] = size;
                                });
                              },
                              onAddPressed: () async {
                                final cubit = context
                                    .read<DashboardPreferencesCubit>();
                                Map<String, dynamic>? settings;
                                if (def.typeId == 'weather_7_day') {
                                  // Najpierw szukamy lokalizacji w istniejących widgetach pogodowych na pulpicie
                                  final existingWeatherWidgets = preferences
                                      .widgets
                                      .where(
                                        (w) =>
                                            w.widgetTypeId == 'weather_7_day',
                                      );
                                  if (existingWeatherWidgets.isNotEmpty) {
                                    for (final w
                                        in existingWeatherWidgets
                                            .toList()
                                            .reversed) {
                                      final loc = w.settings?['location'];
                                      if (loc != null) {
                                        settings = {'location': loc};
                                        break;
                                      }
                                    }
                                  }

                                  // Jeśli nie znaleziono, szukamy w SharedPreferences
                                  if (settings == null) {
                                    try {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final lastLocationJson = prefs.getString(
                                        'last_weather_location',
                                      );
                                      if (lastLocationJson != null) {
                                        final decoded = jsonDecode(
                                          lastLocationJson,
                                        );
                                        if (decoded is Map<String, dynamic>) {
                                          settings = {'location': decoded};
                                        }
                                      }
                                    } catch (_) {}
                                  }
                                }

                                final newWidget = DashboardWidgetPreference(
                                  id: 'widget_${def.typeId}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}',
                                  widgetTypeId: def.typeId,
                                  gridColumn: 0,
                                  gridRow: 0,
                                  width: currentSelectedSize.width,
                                  height: currentSelectedSize.height,
                                  settings: settings,
                                );

                                final added = await cubit.addWidget(
                                  newWidget,
                                  desktopSize: widget.desktopSize,
                                );
                                if (!added && mounted) {
                                  if (context.mounted) {
                                    AppToast.show(
                                      context,
                                      message: intl
                                          .dashboardWidgetPickerNoSpaceMessage,
                                      tone: AppToastTone.warning,
                                    );
                                  }
                                }
                              },
                              intl: intl,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WidgetCatalogItem extends StatelessWidget {
  const _WidgetCatalogItem({
    required this.definition,
    required this.selectedSize,
    required this.wallpaperPath,
    required this.onSizeSelected,
    required this.onAddPressed,
    required this.intl,
  });

  final DashboardWidgetDefinition definition;
  final DashboardWidgetSize selectedSize;
  final String wallpaperPath;
  final ValueChanged<DashboardWidgetSize> onSizeSelected;
  final VoidCallback onAddPressed;
  final AppLocalizations intl;

  @override
  Widget build(BuildContext context) {
    final widthPx = DashboardDesktopGeometry.widgetWidthPx(selectedSize.width);
    final heightPx = DashboardDesktopGeometry.widgetHeightPx(
      selectedSize.height,
    );

    return Container(
      padding: const .all(Sizes.p16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          // 1. Lewa kolumna: Informacje o widgecie, wybór rozmiaru i guzik dodaj
          Expanded(
            child: SizedBox(
              height: 164,
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: context.colors.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: const BorderRadius.all(
                                .circular(Sizes.p8),
                              ),
                            ),
                            child: Icon(
                              definition.icon,
                              color: context.colors.primary,
                              size: 18,
                            ),
                          ),
                          Gaps.w8,
                          Expanded(
                            child: AppText(
                              definition.name(context),
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: .w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Gaps.h8,
                      AppText(
                        definition.description(context),
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      // Wybór rozmiaru (kapsułki)
                      Wrap(
                        spacing: Sizes.p8,
                        runSpacing: Sizes.p8,
                        children: definition.supportedSizes.map((size) {
                          final isSelected = size == selectedSize;
                          return InkWell(
                            onTap: () => onSizeSelected(size),
                            borderRadius: const BorderRadius.all(
                              .circular(Sizes.p24),
                            ),
                            child: Container(
                              padding: const .symmetric(
                                horizontal: Sizes.p8,
                                vertical: Sizes.p4,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.colors.primary
                                    : context.colors.surfaceContainerHighest
                                          .withValues(alpha: 0.5),
                                borderRadius: const BorderRadius.all(
                                  .circular(Sizes.p24),
                                ),
                              ),
                              child: Text(
                                size.label,
                                style: context.text.labelSmall?.copyWith(
                                  color: isSelected
                                      ? context.colors.onPrimary
                                      : context.colors.onSurfaceVariant,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Gaps.h8,
                      FilledButton.icon(
                        onPressed: onAddPressed,
                        icon: const Icon(Icons.add, size: 16),
                        label: Text(intl.dashboardWidgetPickerAddButton),
                        style: FilledButton.styleFrom(
                          padding: const .symmetric(
                            horizontal: Sizes.p12,
                            vertical: 0,
                          ),
                          minimumSize: const Size(double.infinity, 32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Gaps.w20,
          // 2. Prawa kolumna: Podgląd widgetu
          Column(
            children: [
              AppText(
                intl.dashboardWidgetPickerPreviewTitle,
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: .w800,
                  fontSize: 9,
                  letterSpacing: 0.5,
                ),
              ),
              Gaps.h8,
              Container(
                width: 220,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
                  border: Border.all(
                    color: context.colors.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _DashboardBackgroundPreview(
                        wallpaperPath: wallpaperPath,
                      ),
                    ),
                    Center(
                      child: FittedBox(
                        child: SizedBox(
                          width: widthPx,
                          height: heightPx,
                          child: IgnorePointer(
                            child: DashboardWidgetWrapper(
                              name: definition.name(context),
                              icon: definition.icon,
                              frameStyle: definition.frameStyle,
                              supportedSizes: definition.supportedSizes,
                              currentSize: selectedSize,
                              onRemove: () {},
                              onResize: (_) {},
                              child: definition.build(context, selectedSize),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Miniaturowe tło pulpitu z tapetą używane w podglądzie widgetów.
class _DashboardBackgroundPreview extends StatelessWidget {
  /// Tworzy miniaturowe tło pulpitu z tapetą.
  const _DashboardBackgroundPreview({required this.wallpaperPath});

  /// Ścieżka do tapety.
  final String wallpaperPath;

  @override
  Widget build(BuildContext context) {
    final path = wallpaperPath.trim();
    ImageProvider<Object>? wallpaper;
    if (path.isNotEmpty) {
      if (path.startsWith('assets/')) {
        wallpaper = AssetImage(path);
      } else if (!kIsWeb) {
        wallpaper = FileImage(File(path));
      }
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        image: wallpaper == null
            ? null
            : DecorationImage(
                image: wallpaper,
                fit: .cover,
              ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [
              context.colors.surface.withValues(alpha: .08),
              context.colors.surface.withValues(alpha: .18),
              context.colors.surface.withValues(alpha: .28),
            ],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
