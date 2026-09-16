import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qweather_icons/qweather_icons.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Nowoczesny, przeszklony modal wyświetlający szczegółową prognozę pogody na 7 dni.
class WeatherDetailedForecastModal extends StatelessWidget {
  /// Tworzy instancję modalu ze szczegółową prognozą.
  const WeatherDetailedForecastModal({
    required this.location,
    required this.forecast,
    super.key,
  });

  /// Lokalizacja pogodowa.
  final WeatherWidgetLocation location;

  /// Prognoza pogodowa.
  final WeatherWidgetForecast forecast;

  /// Wyświetla modal na ekranie.
  static Future<void> show(
    BuildContext context, {
    required WeatherWidgetLocation location,
    required WeatherWidgetForecast forecast,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .4),
      builder: (context) {
        return WeatherDetailedForecastModal(
          location: location,
          forecast: forecast,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final isPl = Localizations.localeOf(context).languageCode == 'pl';

    // Formatowanie czasu ostatniej synchronizacji
    final syncTime = DateFormat.Hm().format(forecast.generatedAt);
    final syncDate = DateFormat.yMMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(forecast.generatedAt);

    final updateLabel =
        isPl
            ? 'Aktualizacja: $syncDate o $syncTime'
            : 'Updated: $syncDate at $syncTime';

    final surface = Container(
      width: min(640, size.width - 32),
      constraints: BoxConstraints(
        maxHeight: size.height - 64,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: .topLeft,
          end: .bottomRight,
          colors: [
            colors.surfaceContainerLowest.withValues(alpha: .72),
            colors.surfaceContainerLow.withValues(alpha: .58),
          ],
        ),
        borderRadius: const BorderRadius.all(.circular(Sizes.p24)),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: .42),
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: .16),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Nagłówek okna
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Sizes.p24,
              Sizes.p20,
              Sizes.p16,
              Sizes.p12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        location.label,
                        style: context.text.headlineMedium?.copyWith(
                          fontWeight: .w800,
                          color: colors.onSurface,
                        ),
                      ),
                      if (location.locationSummary.isNotEmpty) ...[
                        Gaps.h2,
                        AppText(
                          location.locationSummary,
                          style: context.text.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: .w500,
                          ),
                        ),
                      ],
                      Gaps.h4,
                      AppText(
                        updateLabel,
                        style: context.text.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant.withValues(alpha: .7),
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surfaceContainerHighest.withValues(
                      alpha: .24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colors.outlineVariant.withValues(alpha: .22), height: 1),

          // 2. Lista prognozy
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(Sizes.p20),
              itemCount: forecast.days.length,
              separatorBuilder: (context, index) => Gaps.h8,
              itemBuilder: (context, index) {
                final day = forecast.days[index];
                return _ForecastDayRow(day: day, index: index);
              },
            ),
          ),
        ],
      ),
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(.circular(Sizes.p24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: surface,
        ),
      ),
    );
  }

  /// Pomocnicza funkcja do wyznaczania minimalnej/maksymalnej wartości.
  static double min(double a, double b) => a < b ? a : b;
}

/// Pojedynczy, nowoczesny wiersz prognozy pogodowej w modalu.
class _ForecastDayRow extends StatelessWidget {
  /// Tworzy wiersz prognozy pojedynczego dnia.
  const _ForecastDayRow({required this.day, required this.index});

  /// Dane prognozy na dany dzień.
  final WeatherWidgetDailyForecast day;

  /// Indeks dnia w liście.
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final locale = Localizations.localeOf(context).languageCode;
    final condition = _weatherCondition(day.weatherCode);

    // Formatowanie daty i nazwy dnia
    var dayName = '';
    var dateLabel = '';

    if (index == 0) {
      dayName = locale == 'pl' ? 'Dzisiaj' : 'Today';
    } else if (index == 1) {
      dayName = locale == 'pl' ? 'Jutro' : 'Tomorrow';
    } else {
      dayName =
          DateFormat.EEEE(locale).format(day.date).capitalizeFirstLetter();
    }

    dateLabel = DateFormat.MMMd(locale).format(day.date);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p10,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .14),
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: .22),
        ),
      ),
      child: Row(
        children: [
          // 1. Data i dzień tygodnia
          SizedBox(
            width: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: .min,
              children: [
                AppText(
                  dayName,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: .w700,
                    color: colors.onSurface,
                    height: 1.1,
                  ),
                ),
                Gaps.h2,
                AppText(
                  dateLabel,
                  style: context.text.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: .w600,
                  ),
                ),
              ],
            ),
          ),
          Gaps.w8,

          // 2. Warunki (ikona + krótki opis)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: .topLeft,
                      end: .bottomRight,
                      colors: [
                        colors.primary.withValues(alpha: .14),
                        colors.tertiary.withValues(alpha: .08),
                      ],
                    ),
                    borderRadius: const BorderRadius.all(.circular(Sizes.p10)),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: .18),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      condition.icon,
                      color: colors.primary,
                      size: 20,
                    ),
                  ),
                ),
                Gaps.w8,
                Expanded(
                  child: AppText(
                    condition.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodyMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: .w600,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gaps.w8,

          // 3. Dodatkowe wskaźniki (Wiatr i Opady)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: .min,
              children: [
                // Wiatr
                Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.air_rounded,
                      size: 14,
                      color: colors.secondary.withValues(alpha: .8),
                    ),
                    Gaps.w4,
                    AppText(
                      '${day.windSpeedMax.toStringAsFixed(0)} km/h',
                      style: context.text.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: .w600,
                      ),
                    ),
                  ],
                ),
                Gaps.h4,
                // Opady
                Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.water_drop_rounded,
                      size: 14,
                      color: Colors.blue.withValues(alpha: .8),
                    ),
                    Gaps.w4,
                    AppText(
                      '${day.precipitationSum.toStringAsFixed(1)} mm',
                      style: context.text.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: .w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gaps.w8,

          // 4. Wizualny pasek temperatury (Apple-style)
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 32,
                  child: AppText(
                    '${day.temperatureMin.toStringAsFixed(0)}°',
                    textAlign: TextAlign.right,
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: .w600,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ),
                Gaps.w4,
                // Pasek temperatury z gradientem
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(.circular(Sizes.p2)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withValues(alpha: .8),
                        Colors.orange.withValues(alpha: .8),
                      ],
                    ),
                  ),
                ),
                Gaps.w4,
                SizedBox(
                  width: 32,
                  child: AppText(
                    '${day.temperatureMax.toStringAsFixed(0)}°',
                    style: context.text.labelMedium?.copyWith(
                      fontWeight: .w700,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}

/// Helper extension na String do capitalizacji pierwszej litery.
extension _StringExtension on String {
  /// Zwraca string z wielką pierwszą literą.
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
