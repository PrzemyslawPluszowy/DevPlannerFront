import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

/// Definicja kompaktowego widgetu zegara dla pulpitu.
class ClockWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję kompaktowego widgetu zegara.
  const ClockWidgetDefinition();

  @override
  String get typeId => 'clock';

  @override
  String name(BuildContext context) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' => 'Zegar',
      _ => 'Clock',
    };
  }

  @override
  String description(BuildContext context) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' =>
        'Mały zegar w trzech kompaktowych wariantach: cyfrowym, z datą i analogowym.',
      _ =>
        'Small clock widget in three compact variants: digital, with date, and analog.',
    };
  }

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardWidgetCategoryGeneral;

  @override
  IconData get icon => Icons.schedule_rounded;

  @override
  DashboardWidgetFrameStyle get frameStyle => .minimal;

  @override
  List<DashboardWidgetSize> get supportedSizes => const [
    DashboardWidgetSize(4, 2),
    DashboardWidgetSize(2, 2),
    DashboardWidgetSize(4, 4),
  ];

  @override
  Widget build(BuildContext context, DashboardWidgetSize size) {
    return _ClockWidgetBody(size: size);
  }
}

/// Wariant prezentacji zegara zależny od rozmiaru widgetu.
enum _ClockThemeMode { light, dark }

/// Tryb prezentacji zegarka.
enum _ClockDisplayMode { digital, digitalWithDate, analog }

/// Tryb tła zegarka.
enum _ClockBackgroundMode { standard, transparent }

/// Skala typografii dla cyfrowego zegarka.
enum _ClockTextScale { small, medium, large }

/// Ciało widgetu zegara, które aktualizuje czas w tle.
class _ClockWidgetBody extends StatefulWidget {
  /// Tworzy ciało widgetu zegara.
  const _ClockWidgetBody({required this.size});

  /// Aktualny rozmiar widgetu.
  final DashboardWidgetSize size;

  @override
  State<_ClockWidgetBody> createState() => _ClockWidgetBodyState();
}

/// Stan widgetu zegara odświeżający czas co sekundę.
class _ClockWidgetBodyState extends State<_ClockWidgetBody> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  _ClockThemeMode _themeMode = _ClockThemeMode.light;
  _ClockDisplayMode _displayMode = _ClockDisplayMode.digital;
  _ClockBackgroundMode _backgroundMode = _ClockBackgroundMode.standard;
  _ClockTextScale _textScale = _ClockTextScale.medium;
  DashboardWidgetHeaderActionController? _headerActionController;

  String _label({
    required String pl,
    required String en,
  }) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' => pl,
      _ => en,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = DashboardWidgetSettingsScope.maybeOf(context)?.settings;
    if (settings != null) {
      if (settings['themeMode'] case final String val) {
        _themeMode = _ClockThemeMode.values.firstWhere(
          (e) => e.name == val,
          orElse: () => _ClockThemeMode.light,
        );
      }
      if (settings['displayMode'] case final String val) {
        _displayMode = _ClockDisplayMode.values.firstWhere(
          (e) => e.name == val,
          orElse: () => _ClockDisplayMode.digital,
        );
      }
      if (settings['backgroundMode'] case final String val) {
        _backgroundMode = _ClockBackgroundMode.values.firstWhere(
          (e) => e.name == val,
          orElse: () => _ClockBackgroundMode.standard,
        );
      }
      if (settings['textScale'] case final String val) {
        _textScale = _ClockTextScale.values.firstWhere(
          (e) => e.name == val,
          orElse: () => _ClockTextScale.medium,
        );
      }
    }
  }

  void _registerContextMenuActions() {
    final controller = DashboardWidgetHeaderActionScope.maybeOf(context);
    if (identical(_headerActionController, controller)) {
      return;
    }

    _headerActionController?.setContextMenuActionsBuilder(null);
    _headerActionController = controller;
    _headerActionController?.setContextMenuActionsBuilder((_) {
      return [
        AppContextMenuAction(
          label: _label(pl: 'Motyw jasny', en: 'Light theme'),
          icon: Icons.light_mode_rounded,
          selected: _themeMode == _ClockThemeMode.light,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'themeMode': _ClockThemeMode.light.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Motyw ciemny', en: 'Dark theme'),
          icon: Icons.dark_mode_rounded,
          selected: _themeMode == _ClockThemeMode.dark,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'themeMode': _ClockThemeMode.dark.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Tryb: cyfrowy', en: 'Mode: digital'),
          icon: Icons.more_time_rounded,
          selected: _displayMode == _ClockDisplayMode.digital,
          separatorBefore: true,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'displayMode': _ClockDisplayMode.digital.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(
            pl: 'Tryb: cyfrowy z datą',
            en: 'Mode: digital with date',
          ),
          icon: Icons.calendar_today_rounded,
          selected: _displayMode == _ClockDisplayMode.digitalWithDate,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'displayMode': _ClockDisplayMode.digitalWithDate.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Tryb: analogowy', en: 'Mode: analog'),
          icon: Icons.watch_later_outlined,
          selected: _displayMode == _ClockDisplayMode.analog,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'displayMode': _ClockDisplayMode.analog.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Tło: standardowe', en: 'Background: standard'),
          icon: Icons.layers_rounded,
          selected: _backgroundMode == _ClockBackgroundMode.standard,
          separatorBefore: true,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'backgroundMode': _ClockBackgroundMode.standard.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Tło: przezroczyste', en: 'Background: transparent'),
          icon: Icons.layers_clear_rounded,
          selected: _backgroundMode == _ClockBackgroundMode.transparent,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'backgroundMode': _ClockBackgroundMode.transparent.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Rozmiar: small', en: 'Size: small'),
          icon: Icons.format_size_rounded,
          selected: _textScale == _ClockTextScale.small,
          separatorBefore: true,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'textScale': _ClockTextScale.small.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Rozmiar: medium', en: 'Size: medium'),
          icon: Icons.format_size_rounded,
          selected: _textScale == _ClockTextScale.medium,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'textScale': _ClockTextScale.medium.name},
              );
            }
          },
        ),
        AppContextMenuAction(
          label: _label(pl: 'Rozmiar: large', en: 'Size: large'),
          icon: Icons.format_size_rounded,
          selected: _textScale == _ClockTextScale.large,
          onTap: (_) async {
            final scope = DashboardWidgetSettingsScope.maybeOf(context);
            if (scope != null) {
              await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
                scope.id,
                {'textScale': _ClockTextScale.large.name},
              );
            }
          },
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _headerActionController?.setContextMenuActionsBuilder(null);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _registerContextMenuActions();

    return switch (_displayMode) {
      _ClockDisplayMode.digital ||
      _ClockDisplayMode.digitalWithDate => _DigitalClockView(
        now: _now,
        themeMode: _themeMode,
        backgroundMode: _backgroundMode,
        textScale: _textScale,
        showDate: _displayMode == _ClockDisplayMode.digitalWithDate,
      ),
      _ClockDisplayMode.analog => _AnalogClockView(
        now: _now,
        themeMode: _themeMode,
        backgroundMode: _backgroundMode,
        textScale: _textScale,
      ),
    };
  }
}

/// Wspólny szklany kontener dla widoków zegara.
class _ClockCardWrapper extends StatelessWidget {
  /// Tworzy szklany kontener dla widoku zegara.
  const _ClockCardWrapper({
    required this.themeMode,
    required this.backgroundMode,
    required this.child,
  });

  /// Lokalny wariant kolorystyczny.
  final _ClockThemeMode themeMode;

  /// Tryb tła.
  final _ClockBackgroundMode backgroundMode;

  /// Zawartość kontenera.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (backgroundMode == _ClockBackgroundMode.transparent) {
      return Padding(
        padding: const .all(Sizes.p16),
        child: child,
      );
    }

    final isDarkClock = themeMode == _ClockThemeMode.dark;

    final backgroundColor = isDarkClock
        ? Colors.black.withValues(alpha: .22)
        : Colors.white.withValues(alpha: .18);
    final borderColor = isDarkClock
        ? Colors.white.withValues(alpha: .06)
        : Colors.white.withValues(alpha: .22);
    final shadowColor = Colors.black.withValues(alpha: .12);

    return ClipRRect(
      borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const .all(Sizes.p16),
          child: child,
        ),
      ),
    );
  }
}

/// Cyfrowy wariant zegara renderowany jako lekki overlay na pulpicie.
class _DigitalClockView extends StatelessWidget {
  /// Tworzy cyfrowy wariant zegara.
  const _DigitalClockView({
    required this.now,
    required this.themeMode,
    required this.backgroundMode,
    required this.textScale,
    required this.showDate,
  });

  /// Aktualny czas.
  final DateTime now;

  /// Lokalny wariant kolorystyczny widgetu.
  final _ClockThemeMode themeMode;

  /// Tryb tła.
  final _ClockBackgroundMode backgroundMode;

  /// Skala typografii dla cyfrowej prezentacji.
  final _ClockTextScale textScale;

  /// Czy wyświetlać datę.
  final bool showDate;

  @override
  Widget build(BuildContext context) {
    final hourString = DateFormat('HH').format(now);
    final minuteString = DateFormat('mm').format(now);

    final foregroundColor = switch (themeMode) {
      _ClockThemeMode.light => Colors.white.withValues(alpha: .94),
      _ClockThemeMode.dark => Colors.black.withValues(alpha: .82),
    };
    final accentColor = switch (themeMode) {
      _ClockThemeMode.light => Colors.white.withValues(alpha: .62),
      _ClockThemeMode.dark => Colors.black.withValues(alpha: .54),
    };

    final colonColor = now.second.isEven
        ? foregroundColor
        : foregroundColor.withValues(alpha: .2);

    final locale = Localizations.localeOf(context).toLanguageTag();

    String capitalize(String s) =>
        s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

    return _ClockCardWrapper(
      themeMode: themeMode,
      backgroundMode: backgroundMode,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final textScaleFactor = switch (textScale) {
            _ClockTextScale.small => .75,
            _ClockTextScale.medium => 1.0,
            _ClockTextScale.large => 1.3,
          };

          final timeFontSize =
              (height > 100
                  ? (showDate ? 44.0 : 54.0)
                  : (showDate ? 32.0 : 40.0)) *
              textScaleFactor;

          final dateFontSize = (height > 100 ? 14.0 : 12.0) * textScaleFactor;

          final timeStyle = context.text.headlineLarge?.copyWith(
            fontSize: timeFontSize,
            fontWeight: .w700,
            color: foregroundColor,
            height: 1.0,
            letterSpacing: -1.0,
          );

          final dateStyle = context.text.bodyMedium?.copyWith(
            fontSize: dateFontSize,
            fontWeight: .w500,
            color: accentColor,
            height: 1.1,
          );

          final datePattern = width < 150 ? 'E, d MMM' : 'EEEE, d MMMM';
          final dateText = capitalize(
            DateFormat(datePattern, locale).format(now),
          );

          final clockRow = FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: .min,
              children: [
                AppText(hourString, style: timeStyle),
                Padding(
                  padding: const .symmetric(horizontal: Sizes.p2),
                  child: AppText(
                    ':',
                    style: timeStyle?.copyWith(color: colonColor),
                  ),
                ),
                AppText(minuteString, style: timeStyle),
              ],
            ),
          );

          if (showDate) {
            return Column(
              mainAxisAlignment: .center,
              children: [
                clockRow,
                Gaps.h8,
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AppText(
                    dateText,
                    style: dateStyle,
                    maxLines: 1,
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: clockRow,
            );
          }
        },
      ),
    );
  }
}

/// Minimalistyczny wariant analogowy dla zegarka overlay.
class _AnalogClockView extends StatelessWidget {
  /// Tworzy wariant analogowy.
  const _AnalogClockView({
    required this.now,
    required this.themeMode,
    required this.backgroundMode,
    required this.textScale,
  });

  /// Aktualny czas.
  final DateTime now;

  /// Lokalny wariant kolorystyczny widgetu.
  final _ClockThemeMode themeMode;

  /// Tryb tła.
  final _ClockBackgroundMode backgroundMode;

  /// Skala rozmiaru wariantu analogowego.
  final _ClockTextScale textScale;

  @override
  Widget build(BuildContext context) {
    final padding = switch (textScale) {
      _ClockTextScale.small => Sizes.p16,
      _ClockTextScale.medium => Sizes.p10,
      _ClockTextScale.large => Sizes.p4,
    };

    return _ClockCardWrapper(
      themeMode: themeMode,
      backgroundMode: backgroundMode,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: CustomPaint(
              painter: _ClockAnalogPainter(
                now: now,
                themeMode: themeMode,
                textScale: textScale,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rysownik prostego zegara analogowego.
class _ClockAnalogPainter extends CustomPainter {
  /// Tworzy rysownik zegara analogowego.
  const _ClockAnalogPainter({
    required this.now,
    required this.themeMode,
    required this.textScale,
  });

  /// Aktualny czas.
  final DateTime now;

  /// Lokalny wariant kolorystyczny widgetu.
  final _ClockThemeMode themeMode;

  /// Skala rozmiaru wariantu analogowego.
  final _ClockTextScale textScale;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2;
    final foregroundColor = switch (themeMode) {
      _ClockThemeMode.light => Colors.white.withValues(alpha: .92),
      _ClockThemeMode.dark => Colors.black.withValues(alpha: .8),
    };
    final secondaryColor = switch (themeMode) {
      _ClockThemeMode.light => Colors.white.withValues(alpha: .48),
      _ClockThemeMode.dark => Colors.black.withValues(alpha: .36),
    };
    final hourStroke = switch (textScale) {
      _ClockTextScale.small => 1.8,
      _ClockTextScale.medium => 2.6,
      _ClockTextScale.large => 3.4,
    };
    final minuteStroke = switch (textScale) {
      _ClockTextScale.small => 1.2,
      _ClockTextScale.medium => 1.7,
      _ClockTextScale.large => 2.3,
    };
    final centerDot = switch (textScale) {
      _ClockTextScale.small => 1.4,
      _ClockTextScale.medium => 2.0,
      _ClockTextScale.large => 2.8,
    };

    final tickPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = secondaryColor;

    for (var i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6) - (math.pi / 2);
      final outer = Offset(
        center.dx + math.cos(angle) * (radius - 1),
        center.dy + math.sin(angle) * (radius - 1),
      );
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - 5),
        center.dy + math.sin(angle) * (radius - 5),
      );
      tickPaint.strokeWidth = i % 3 == 0 ? 1.8 : 1.0;
      canvas.drawLine(inner, outer, tickPaint);
    }

    final hourTurns = ((now.hour % 12) + now.minute / 60) / 12;
    final minuteTurns = (now.minute + now.second / 60) / 60;

    void drawHand({
      required double turns,
      required double lengthFactor,
      required double strokeWidth,
      required Color color,
    }) {
      final angle = (turns * math.pi * 2) - (math.pi / 2);
      final end = Offset(
        center.dx + math.cos(angle) * (radius * lengthFactor),
        center.dy + math.sin(angle) * (radius * lengthFactor),
      );
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth
        ..color = color;
      canvas.drawLine(center, end, paint);
    }

    drawHand(
      turns: hourTurns,
      lengthFactor: .42,
      strokeWidth: hourStroke,
      color: foregroundColor,
    );
    drawHand(
      turns: minuteTurns,
      lengthFactor: .64,
      strokeWidth: minuteStroke,
      color: foregroundColor,
    );
    canvas.drawCircle(center, centerDot, Paint()..color = foregroundColor);
  }

  @override
  bool shouldRepaint(covariant _ClockAnalogPainter oldDelegate) {
    return oldDelegate.now != now ||
        oldDelegate.themeMode != themeMode ||
        oldDelegate.textScale != textScale;
  }
}
