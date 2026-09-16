import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qweather_icons/qweather_icons.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/cubit/weather_widget_state.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/weather_detailed_forecast_modal.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Ciało wizualne widgetu pogodowego.
class WeatherWidgetContent extends StatelessWidget {
  /// Tworzy ciało wizualne widgetu pogodowego.
  const WeatherWidgetContent({
    required this.size,
    required this.backgroundMode,
    required this.state,
    required this.onRefresh,
    required this.onDetectLocation,
    required this.onEditLocation,
    required this.onClearLocation,
    super.key,
  });

  /// Aktualny rozmiar widgetu na pulpicie.
  final DashboardWidgetSize size;

  /// Tryb tła widgetu.
  final WeatherWidgetBackgroundMode backgroundMode;

  /// Aktualny stan cubita pogodowego.
  final WeatherWidgetState state;

  /// Callback odświeżania prognozy.
  final VoidCallback onRefresh;

  /// Callback wykrywania lokalizacji urządzenia.
  final VoidCallback onDetectLocation;

  /// Callback otwierający picker lokalizacji.
  final VoidCallback onEditLocation;

  /// Callback czyszczący lokalizację widgetu.
  final VoidCallback onClearLocation;

  bool get _isTodayOnlySize => size.width <= 2 && size.height <= 2;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      WeatherWidgetInitial() => _WeatherEmptyState(
        backgroundMode: backgroundMode,
        isTiny: _isTodayOnlySize,
        title: _label(context, pl: 'Brak lokalizacji', en: 'No location'),
        message: _label(
          context,
          pl: 'Wykryj pozycję urządzenia albo wybierz miasto ręcznie.',
          en: 'Detect the device position or choose a city manually.',
        ),
        primaryActionLabel: _label(
          context,
          pl: 'Wykryj lokalizację',
          en: 'Detect location',
        ),
        secondaryActionLabel: _label(
          context,
          pl: 'Wybierz ręcznie',
          en: 'Pick manually',
        ),
        onPrimaryAction: onDetectLocation,
        onSecondaryAction: onEditLocation,
      ),
      WeatherWidgetLoading(:final location?) => _WeatherLoadingView(
        backgroundMode: backgroundMode,
        isTiny: _isTodayOnlySize,
        location: location,
      ),
      WeatherWidgetLoading() => _WeatherLoadingView(
        backgroundMode: backgroundMode,
        isTiny: _isTodayOnlySize,
        location: null,
      ),
      WeatherWidgetError(:final message, :final location?) => _WeatherErrorView(
        backgroundMode: backgroundMode,
        isTiny: _isTodayOnlySize,
        location: location,
        message: message,
        onRetry: onRefresh,
        onEditLocation: onEditLocation,
        onDetectLocation: onDetectLocation,
        onClearLocation: onClearLocation,
      ),
      WeatherWidgetError(:final message) => _WeatherErrorView(
        backgroundMode: backgroundMode,
        isTiny: _isTodayOnlySize,
        location: null,
        message: message,
        onRetry: onRefresh,
        onEditLocation: onEditLocation,
        onDetectLocation: onDetectLocation,
        onClearLocation: onClearLocation,
      ),
      WeatherWidgetLoaded(:final location, :final forecast, :final loadedAt) =>
        _WeatherLoadedView(
          size: size,
          backgroundMode: backgroundMode,
          location: location,
          forecast: forecast,
          loadedAt: loadedAt,
        ),
    };
  }

  String _label(
    BuildContext context, {
    required String pl,
    required String en,
  }) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' => pl,
      _ => en,
    };
  }
}

/// Ekran pusty widgetu pogodowego z akcjami konfiguracji.
class _WeatherEmptyState extends StatelessWidget {
  /// Tworzy ekran pusty widgetu pogodowego.
  const _WeatherEmptyState({
    required this.backgroundMode,
    required this.isTiny,
    required this.title,
    required this.message,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
    required this.onPrimaryAction,
    required this.onSecondaryAction,
  });

  final WeatherWidgetBackgroundMode backgroundMode;
  final bool isTiny;
  final String title;
  final String message;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final VoidCallback onPrimaryAction;
  final VoidCallback onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    if (isTiny) {
      return _WeatherTinyState(
        backgroundMode: backgroundMode,
        icon: Icons.cloud_queue_rounded,
        title: title,
        subtitle: primaryActionLabel,
        onPressed: onPrimaryAction,
      );
    }

    return _WeatherSurface(
      backgroundMode: backgroundMode,
      child: _WeatherStatusRow(
        leading: const Icon(
          Icons.cloud_queue_rounded,
          size: 26,
        ),
        title: title,
        message: message,
        actions: [
          _WeatherIconAction(
            tooltip: primaryActionLabel,
            icon: Icons.my_location_rounded,
            onPressed: onPrimaryAction,
          ),
          _WeatherIconAction(
            tooltip: secondaryActionLabel,
            icon: Icons.search_rounded,
            onPressed: onSecondaryAction,
          ),
        ],
      ),
    );
  }
}

/// Widok ładowania danych pogodowych z nazwą lokalizacji.
class _WeatherLoadingView extends StatelessWidget {
  /// Tworzy widok ładowania danych pogodowych.
  const _WeatherLoadingView({
    required this.backgroundMode,
    required this.isTiny,
    required this.location,
  });

  final WeatherWidgetBackgroundMode backgroundMode;
  final bool isTiny;
  final WeatherWidgetLocation? location;

  @override
  Widget build(BuildContext context) {
    if (isTiny) {
      return _WeatherTinyState(
        backgroundMode: backgroundMode,
        icon: Icons.cloud_sync_rounded,
        title:
            location?.label ?? _label(context, pl: 'Ładowanie', en: 'Loading'),
        subtitle: _label(context, pl: 'Pogoda', en: 'Weather'),
        progress: true,
      );
    }

    return _WeatherSurface(
      backgroundMode: backgroundMode,
      child: _WeatherStatusRow(
        leading: const SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2.4),
        ),
        title:
            location?.label ??
            _label(context, pl: 'Ładowanie pogody', en: 'Loading weather'),
        message:
            location?.compactSummary ??
            _label(
              context,
              pl: 'Pobieranie prognozy 7-dniowej',
              en: 'Fetching 7-day forecast',
            ),
      ),
    );
  }

  String _label(
    BuildContext context, {
    required String pl,
    required String en,
  }) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' => pl,
      _ => en,
    };
  }
}

/// Widok błędu pobierania danych pogodowych.
class _WeatherErrorView extends StatelessWidget {
  /// Tworzy widok błędu widgetu.
  const _WeatherErrorView({
    required this.backgroundMode,
    required this.isTiny,
    required this.location,
    required this.message,
    required this.onRetry,
    required this.onEditLocation,
    required this.onDetectLocation,
    required this.onClearLocation,
  });

  final WeatherWidgetBackgroundMode backgroundMode;
  final bool isTiny;
  final WeatherWidgetLocation? location;
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onEditLocation;
  final VoidCallback onDetectLocation;
  final VoidCallback onClearLocation;

  @override
  Widget build(BuildContext context) {
    if (isTiny) {
      return _WeatherTinyState(
        backgroundMode: backgroundMode,
        icon: Icons.error_outline_rounded,
        iconColor: context.colors.error,
        title: _label(context, pl: 'Błąd pogody', en: 'Weather error'),
        subtitle: _label(context, pl: 'Ponów', en: 'Retry'),
        onPressed: onRetry,
      );
    }

    return _WeatherSurface(
      backgroundMode: backgroundMode,
      child: _WeatherStatusRow(
        leading: Icon(
          Icons.error_outline_rounded,
          size: 26,
          color: context.colors.error,
        ),
        title: _label(
          context,
          pl: 'Nie udało się pobrać pogody',
          en: 'Failed to load weather',
        ),
        message: message,
        actions: [
          _WeatherIconAction(
            tooltip: _label(context, pl: 'Ponów', en: 'Retry'),
            icon: Icons.refresh_rounded,
            onPressed: onRetry,
          ),
          _WeatherIconAction(
            tooltip: _label(
              context,
              pl: 'Wybierz lokalizację',
              en: 'Pick location',
            ),
            icon: Icons.search_rounded,
            onPressed: onEditLocation,
          ),
          _WeatherIconAction(
            tooltip: _label(context, pl: 'Wykryj', en: 'Detect'),
            icon: Icons.my_location_rounded,
            onPressed: onDetectLocation,
          ),
          if (location != null)
            _WeatherIconAction(
              tooltip: _label(context, pl: 'Wyczyść', en: 'Clear'),
              icon: Icons.delete_outline_rounded,
              onPressed: onClearLocation,
              isDestructive: true,
            ),
        ],
      ),
    );
  }

  String _label(
    BuildContext context, {
    required String pl,
    required String en,
  }) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' => pl,
      _ => en,
    };
  }
}

/// Minimalny wariant stanu dla małego widgetu 1x1.
class _WeatherTinyState extends StatelessWidget {
  /// Tworzy minimalny wariant stanu.
  const _WeatherTinyState({
    required this.backgroundMode,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.progress = false,
    this.onPressed,
    this.iconColor,
  });

  final WeatherWidgetBackgroundMode backgroundMode;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool progress;
  final VoidCallback? onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return _WeatherSurface(
      backgroundMode: backgroundMode,
      child: Column(
        mainAxisAlignment: .center,
        children: [
          if (progress)
            const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          else
            Icon(
              icon,
              size: 28,
              color: iconColor ?? colors.primary,
            ),
          Gaps.h8,
          AppText(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: .center,
            style: context.text.labelLarge?.copyWith(
              fontWeight: .w700,
              height: 1.0,
            ),
          ),
          Gaps.h4,
          if (onPressed != null)
            _WeatherMiniButton(
              label: subtitle,
              onPressed: onPressed!,
            )
          else
            AppText(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: .center,
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.0,
              ),
            ),
        ],
      ),
    );
  }
}

/// Minimalny przycisk tekstowy dla wariantu 1x1.
class _WeatherMiniButton extends StatelessWidget {
  /// Tworzy minimalny przycisk tekstowy.
  const _WeatherMiniButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p4,
        ),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: .12),
          borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
          border: Border.all(
            color: colors.primary.withValues(alpha: .24),
          ),
        ),
        child: AppText(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.labelSmall?.copyWith(
            color: colors.primary,
            fontWeight: .w700,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}

/// Niski, poziomy stan pomocniczy dla kompaktowego widgetu.
class _WeatherStatusRow extends StatelessWidget {
  /// Tworzy poziomy stan pomocniczy.
  const _WeatherStatusRow({
    required this.leading,
    required this.title,
    required this.message,
    this.actions = const [],
  });

  final Widget leading;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: .18),
            borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .22),
            ),
          ),
          child: Center(child: leading),
        ),
        Gaps.w8,
        Expanded(
          child: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelLarge?.copyWith(
                  fontWeight: .w700,
                  height: 1.0,
                  color: colors.onSurface,
                ),
              ),
              AppText(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant.withValues(alpha: .9),
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
        if (actions.isNotEmpty) ...[
          Gaps.w8,
          Wrap(
            spacing: Sizes.p4,
            children: actions,
          ),
        ],
      ],
    );
  }
}

/// Minimalna akcja ikonowa do kompaktowych stanów widgetu.
class _WeatherIconAction extends StatelessWidget {
  /// Tworzy akcję ikonową.
  const _WeatherIconAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final baseColor = isDestructive ? colors.error : colors.onSurface;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
        child: Ink(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: .1),
            borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
            border: Border.all(
              color: baseColor.withValues(alpha: .16),
            ),
          ),
          child: Icon(
            icon,
            size: 16,
            color: baseColor,
          ),
        ),
      ),
    );
  }
}

/// Główny widok załadowanej prognozy.
class _WeatherLoadedView extends StatelessWidget {
  /// Tworzy główny widok załadowanej prognozy.
  const _WeatherLoadedView({
    required this.size,
    required this.backgroundMode,
    required this.location,
    required this.forecast,
    required this.loadedAt,
  });

  final DashboardWidgetSize size;
  final WeatherWidgetBackgroundMode backgroundMode;
  final WeatherWidgetLocation location;
  final WeatherWidgetForecast forecast;
  final DateTime loadedAt;

  @override
  Widget build(BuildContext context) {
    final body = size.width <= 4
        ? (size.height <= 2
            ? _WeatherTodayView(
                location: location,
                forecast: forecast,
              )
            : _WeatherVerticalForecastView(
                location: location,
                forecast: forecast,
                loadedAt: loadedAt,
                size: size,
              ))
        : _WeatherStripForecastView(
            location: location,
            forecast: forecast,
            loadedAt: loadedAt,
            size: size,
          );

    return InkWell(
      onTap: () => _showDetailedForecast(context),
      borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
      child: _WeatherSurface(
        backgroundMode: backgroundMode,
        child: body,
      ),
    );
  }

  void _showDetailedForecast(BuildContext context) {
    unawaited(
      WeatherDetailedForecastModal.show(
        context,
        location: location,
        forecast: forecast,
      ),
    );
  }
}

/// Pionowy widok prognozy pogodowej dla wysokich widgetów (np. 1x5).
/// Pokazuje dzisiejszą pogodę na górze w karcie i listę prognozy poniżej.
class _WeatherVerticalForecastView extends StatelessWidget {
  /// Tworzy pionowy widok prognozy pogodowej.
  const _WeatherVerticalForecastView({
    required this.location,
    required this.forecast,
    required this.loadedAt,
    required this.size,
  });

  /// Lokalizacja pogodowa.
  final WeatherWidgetLocation location;

  /// Prognoza pogodowa.
  final WeatherWidgetForecast forecast;

  /// Data i czas ostatniego załadowania danych.
  final DateTime loadedAt;

  /// Rozmiar widgetu na pulpicie.
  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = forecast.today;
    final condition = _weatherCondition(today?.weatherCode ?? 0);
    final temperature = today == null
        ? '--'
        : '${today.temperatureMax.toStringAsFixed(0)}°';
    final low = today == null
        ? ''
        : '${today.temperatureMin.toStringAsFixed(0)}°';

    // Dopasowanie liczby dni prognozy oraz stopnia zwartości układu do wysokości widgetu.
    final isCompact = size.height <= 4;
    final daysToTake = switch (size.height) {
      <= 4 => 2,
      <= 6 => 4,
      <= 8 => 6,
      _ => 7,
    };

    final cardPadding = isCompact
        ? const EdgeInsets.symmetric(horizontal: Sizes.p8, vertical: Sizes.p4)
        : const EdgeInsets.symmetric(horizontal: Sizes.p10, vertical: Sizes.p12);
    final gapHeight = isCompact ? Gaps.h4 : Gaps.h8;
    final iconSize = isCompact ? 36.0 : 44.0;

    return Column(
      children: [
        // Górna sekcja - dzisiejsza pogoda w ładnej, wyeksponowanej karcie
        Container(
          width: double.infinity,
          padding: cardPadding,
          decoration: BoxDecoration(
            color: isDark
                ? colors.surfaceContainerHighest.withValues(alpha: .65)
                : Colors.white.withValues(alpha: .85),
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .22),
            ),
          ),
          child: Column(
            mainAxisSize: .min,
            children: [
              AppText(
                location.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: .center,
                style: context.text.labelLarge?.copyWith(
                  fontWeight: .w800,
                  color: colors.onSurface,
                ),
              ),
              gapHeight,
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topLeft,
                    end: .bottomRight,
                    colors: [
                      colors.primary.withValues(alpha: .98),
                      colors.tertiary.withValues(alpha: .92),
                    ],
                  ),
                  borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                ),
                child: Icon(
                  condition.icon,
                  color: colors.onPrimary,
                  size: isCompact ? 20 : 24,
                ),
              ),
              gapHeight,
              AppText(
                temperature,
                maxLines: 1,
                style: context.text.titleLarge?.copyWith(
                  fontWeight: .w800,
                  height: 1.0,
                ),
              ),
              if (low.isNotEmpty) ...[
                Gaps.h2,
                AppText(
                  low,
                  maxLines: 1,
                  style: context.text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: .w600,
                    height: 1.0,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isCompact) Gaps.h4 else Gaps.h8,
        // Dolna sekcja - lista prognozy na kolejne dni
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.p10,
              vertical: isCompact ? Sizes.p4 : Sizes.p8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: .topLeft,
                end: .bottomRight,
                colors: [
                  colors.primary.withValues(alpha: .82),
                  colors.tertiary.withValues(alpha: .72),
                ],
              ),
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              border: Border.all(
                color: colors.onPrimary.withValues(alpha: .14),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final day in forecast.days.take(daysToTake).indexed) ...[
                  _WeatherVerticalDayRow(
                    day: day.$2,
                    index: day.$1,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Wiersz pojedynczego dnia w pionowym widoku prognozy.
class _WeatherVerticalDayRow extends StatelessWidget {
  /// Tworzy wiersz prognozy pojedynczego dnia.
  const _WeatherVerticalDayRow({
    required this.day,
    required this.index,
  });

  /// Dzień prognozy.
  final WeatherWidgetDailyForecast day;

  /// Indeks dnia w liście prognoz.
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final condition = _weatherCondition(day.weatherCode);
    final dayLabel = _compactDayLabel(context, day.date, index);

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nazwa dnia
          SizedBox(
            width: 24,
            child: AppText(
              dayLabel,
              style: context.text.labelSmall?.copyWith(
                fontWeight: .w800,
                color: colors.onPrimary.withValues(alpha: .86),
                height: 1.0,
              ),
            ),
          ),
          // Ikona pogodowa
          Icon(
            condition.icon,
            color: colors.onPrimary,
            size: 18,
          ),
          // Temperatura maksymalna i minimalna
          Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                '${day.temperatureMax.toStringAsFixed(0)}°',
                style: context.text.labelSmall?.copyWith(
                  fontWeight: .w800,
                  color: colors.onPrimary,
                  height: 1.0,
                ),
              ),
              AppText(
                '${day.temperatureMin.toStringAsFixed(0)}°',
                style: context.text.labelSmall?.copyWith(
                  fontWeight: .w600,
                  color: colors.onPrimary.withValues(alpha: .7),
                  fontSize: 8,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Powierzchnia pogody z opcjonalnym szklistym tłem.
class _WeatherSurface extends StatelessWidget {
  /// Tworzy powierzchnię widgetu pogodowego.
  const _WeatherSurface({
    required this.backgroundMode,
    required this.child,
  });

  final WeatherWidgetBackgroundMode backgroundMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isTransparent =
        backgroundMode == WeatherWidgetBackgroundMode.transparent;

    final surface = Container(
      decoration: BoxDecoration(
        gradient: isTransparent
            ? null
            : LinearGradient(
                begin: .topLeft,
                end: .bottomRight,
                colors: [
                  colors.surfaceContainerLowest.withValues(alpha: .72),
                  colors.surfaceContainerLow.withValues(alpha: .58),
                ],
              ),
        color: isTransparent ? Colors.transparent : null,
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        border: isTransparent
            ? null
            : Border.all(color: colors.outlineVariant.withValues(alpha: .42)),
        boxShadow: isTransparent
            ? null
            : [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: .08),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p10,
      ),
      child: child,
    );

    if (isTransparent) {
      return surface;
    }

    return ClipRRect(
      borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: surface,
      ),
    );
  }
}

/// Widok 1x1 pokazujący tylko dzisiejszą pogodę.
class _WeatherTodayView extends StatelessWidget {
  /// Tworzy widok 1x1 dla dzisiejszej pogody.
  const _WeatherTodayView({
    required this.location,
    required this.forecast,
  });

  final WeatherWidgetLocation location;
  final WeatherWidgetForecast forecast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final today = forecast.today;
    final condition = _weatherCondition(today?.weatherCode ?? 0);
    final temperature = today == null
        ? '--'
        : '${today.temperatureMax.toStringAsFixed(0)}°';
    final low = today == null
        ? ''
        : '${today.temperatureMin.toStringAsFixed(0)}°';

    return Column(
      mainAxisAlignment: .center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: .topLeft,
              end: .bottomRight,
              colors: [
                colors.primary.withValues(alpha: .98),
                colors.tertiary.withValues(alpha: .92),
              ],
            ),
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
          ),
          child: Icon(
            condition.icon,
            color: colors.onPrimary,
            size: 24,
          ),
        ),
        Gaps.h8,
        AppText(
          temperature,
          maxLines: 1,
          style: context.text.headlineSmall?.copyWith(
            fontWeight: .w700,
            height: 1.0,
          ),
        ),
        if (low.isNotEmpty) ...[
          Gaps.h2,
          AppText(
            low,
            maxLines: 1,
            style: context.text.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: .w600,
              height: 1.0,
            ),
          ),
        ],
        Gaps.h4,
        AppText(
          condition.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: .center,
          style: context.text.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: .w700,
            height: 1.0,
          ),
        ),
        AppText(
          location.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: .center,
          style: context.text.labelSmall?.copyWith(
            color: colors.onSurfaceVariant.withValues(alpha: .82),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

/// Szeroki widok paska z 7-dniową prognozą.
class _WeatherStripForecastView extends StatelessWidget {
  /// Tworzy szeroki widok paska prognozy.
  const _WeatherStripForecastView({
    required this.location,
    required this.forecast,
    required this.loadedAt,
    required this.size,
  });

  final WeatherWidgetLocation location;
  final WeatherWidgetForecast forecast;
  final DateTime loadedAt;
  final DashboardWidgetSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = forecast.today;
    final condition = _weatherCondition(today?.weatherCode ?? 0);
    final temperatureLabel = today == null
        ? '--'
        : '${today.temperatureMax.toStringAsFixed(0)}°';
    final lowLabel = today == null
        ? ''
        : '${today.temperatureMin.toStringAsFixed(0)}°';
    const summaryWidth = 152.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: summaryWidth,
          height: double.infinity,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p10,
              vertical: Sizes.p8,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? colors.surfaceContainerHighest.withValues(alpha: .65)
                  : Colors.white.withValues(alpha: .85),
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: .22),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topLeft,
                      end: .bottomRight,
                      colors: [
                        colors.primary.withValues(alpha: .98),
                        colors.tertiary.withValues(alpha: .92),
                      ],
                    ),
                    borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                  ),
                  child: Icon(
                    condition.icon,
                    color: colors.onPrimary,
                    size: 26,
                  ),
                ),
                Gaps.w8,
                Expanded(
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: context.text.titleMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: .w700,
                            height: 1.0,
                          ),
                          children: [
                            TextSpan(text: temperatureLabel),
                            if (lowLabel.isNotEmpty)
                              TextSpan(
                                text: '  $lowLabel',
                                style: context.text.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                  fontWeight: .w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      AppText(
                        condition.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: .w600,
                          height: 1.0,
                        ),
                      ),
                      AppText(
                        _stripSubtitle(location, loadedAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant.withValues(alpha: .82),
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Gaps.w8,
        Expanded(
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p10,
              vertical: Sizes.p8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: .topLeft,
                end: .bottomRight,
                colors: [
                  colors.primary.withValues(alpha: .82),
                  colors.tertiary.withValues(alpha: .72),
                ],
              ),
              borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
              border: Border.all(
                color: colors.onPrimary.withValues(alpha: .14),
              ),
            ),
            child: Row(
              children: [
                for (final day in forecast.days.take(7).indexed) ...[
                  if (day.$1 > 0) Gaps.w4,
                  Expanded(
                    child: _WeatherForecastChip(
                      day: day.$2,
                      index: day.$1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _stripSubtitle(WeatherWidgetLocation location, DateTime loadedAt) {
    final time = DateFormat.Hm().format(loadedAt);
    return '${location.label} · $time';
  }
}

/// Bardzo mały kafelek pojedynczego dnia.
class _WeatherForecastChip extends StatelessWidget {
  /// Tworzy kafelek pojedynczego dnia.
  const _WeatherForecastChip({
    required this.day,
    required this.index,
  });

  final WeatherWidgetDailyForecast day;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final condition = _weatherCondition(day.weatherCode);
    final dayLabel = _compactDayLabel(context, day.date, index);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p2,
        vertical: Sizes.p4,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(.circular(Sizes.p10)),
      ),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          AppText(
            dayLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: .center,
            style: context.text.labelSmall?.copyWith(
              fontWeight: .w700,
              height: 1.0,
              color: colors.onPrimary.withValues(alpha: .86),
            ),
          ),
          Gaps.h4,
          Icon(condition.icon, color: colors.onPrimary, size: 20),
          Gaps.h4,
          AppText(
            '${day.temperatureMax.toStringAsFixed(0)}°',
            maxLines: 1,
            style: context.text.labelSmall?.copyWith(
              fontWeight: .w700,
              height: 1.0,
              color: colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Opis warunków pogodowych i ikona dla kodu WMO.
({IconData icon, String label}) _weatherCondition(int code) {
  return switch (code) {
    0 => (icon: _qweather('sunny_fill'), label: 'Bezchmurnie'),
    1 => (icon: _qweather('few_clouds_fill'), label: 'Prawie bezchmurnie'),
    2 => (
      icon: _qweather('partly_cloudy_fill'),
      label: 'Częściowe zachmurzenie',
    ),
    3 => (icon: _qweather('cloudy_fill'), label: 'Zachmurzenie'),
    45 || 48 => (icon: _qweather('foggy_fill'), label: 'Mgła'),
    51 || 53 || 55 || 56 || 57 => (
      icon: switch (code) {
        56 || 57 => _qweather('sleet_fill'),
        _ => _qweather('drizzle_rain_fill'),
      },
      label: 'Mżawka',
    ),
    61 || 63 || 65 || 66 || 67 => (
      icon: switch (code) {
        61 => _qweather('light_rain_fill'),
        63 => _qweather('moderate_rain_fill'),
        65 || 66 || 67 => _qweather('rain_fill'),
        _ => _qweather('rain_fill'),
      },
      label: 'Deszcz',
    ),
    71 || 73 || 75 || 77 => (
      icon: switch (code) {
        71 => _qweather('light_snow_fill'),
        73 => _qweather('moderate_snow_fill'),
        75 => _qweather('heavy_snow_fill'),
        77 => _qweather('snow_fill'),
        _ => _qweather('snow_fill'),
      },
      label: 'Śnieg',
    ),
    80 || 81 || 82 => (
      icon: _qweather('shower_rain_fill'),
      label: 'Przelotne opady',
    ),
    85 || 86 => (
      icon: _qweather('rain_and_snow_fill'),
      label: 'Śnieg z deszczem',
    ),
    95 || 96 || 99 => (
      icon: switch (code) {
        95 => _qweather('thunderstorm_fill'),
        96 || 99 => _qweather('thundershower_with_hail_fill'),
        _ => _qweather('thunderstorm_fill'),
      },
      label: 'Burza',
    ),
    _ => (icon: _qweather('cloudy_fill'), label: 'Pogoda'),
  };
}

IconData _qweather(String tag) {
  return QWeatherIcons.getIconWith(tag).iconData;
}

String _compactDayLabel(BuildContext context, DateTime date, int index) {
  final locale = Localizations.localeOf(context).languageCode;
  return switch (index) {
    0 => locale == 'pl' ? 'Dz' : 'Td',
    1 => locale == 'pl' ? 'Jt' : 'Tm',
    _ => DateFormat.E(
      locale,
    ).format(date).characters.take(2).toString().toUpperCase(),
  };
}
