import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qweather_icons/qweather_icons.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/dashboard/application/dashboard_preferences_cubit.dart';
import 'package:ready_next/features/dashboard/data/weather/open_meteo_weather_repository.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_location_service.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_definition.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/dashboard_widget_header_actions.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/cubit/weather_widget_cubit.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/cubit/weather_widget_state.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/weather_location_picker_sheet.dart';
import 'package:ready_next/features/dashboard/presentation/widgets/weather/weather_widget_content.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Definicja 7-dniowego widgetu pogodowego na pulpicie.
class WeatherWidgetDefinition extends DashboardWidgetDefinition {
  /// Tworzy definicję widgetu pogodowego.
  const WeatherWidgetDefinition();

  @override
  String get typeId => 'weather_7_day';

  @override
  String name(BuildContext context) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' => 'Pogoda',
      _ => 'Weather',
    };
  }

  @override
  String description(BuildContext context) {
    return switch (Localizations.localeOf(context).languageCode) {
      'pl' =>
        'Widget z 7-dniową prognozą Open-Meteo i lokalizacją wykrywaną automatycznie albo wybieraną ręcznie.',
      _ =>
        'Open-Meteo 7-day forecast widget with automatic or manual location selection.',
    };
  }

  @override
  String category(BuildContext context) =>
      context.l10n.dashboardWidgetCategoryGeneral;

  @override
  IconData get icon => QWeatherIcons.getIconWith('cloudy_fill').iconData;

  @override
  DashboardWidgetFrameStyle get frameStyle => .minimal;

  @override
  List<DashboardWidgetSize> get supportedSizes => const [
    DashboardWidgetSize(4, 4),
    DashboardWidgetSize(4, 6),
    DashboardWidgetSize(4, 8),
    DashboardWidgetSize(4, 10),
    DashboardWidgetSize(10, 4),
  ];

  @override
  Widget build(BuildContext context, DashboardWidgetSize size) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OpenMeteoWeatherRepository>(
          create: (_) => OpenMeteoWeatherRepository(),
          dispose: (repository) => repository.dispose(),
        ),
        RepositoryProvider<WeatherLocationService>(
          create: (_) => const WeatherLocationService(),
        ),
      ],
      child: BlocProvider(
        create: (context) => WeatherWidgetCubit(
          repository: context.read<OpenMeteoWeatherRepository>(),
        ),
        child: _WeatherWidgetBody(size: size),
      ),
    );
  }
}

/// Stan widgetu pogodowego odpowiedzialny za synchronizację ustawień i menu.
class _WeatherWidgetBody extends StatefulWidget {
  /// Tworzy stan widgetu pogodowego.
  const _WeatherWidgetBody({required this.size});

  final DashboardWidgetSize size;

  @override
  State<_WeatherWidgetBody> createState() => _WeatherWidgetBodyState();
}

/// Logika widgetu pogodowego.
class _WeatherWidgetBodyState extends State<_WeatherWidgetBody> {
  late final VoidCallback _refreshAction;
  late final DashboardWidgetContextMenuActionsBuilder _menuActionsBuilder;
  String? _lastSettingsSignature;
  WeatherWidgetBackgroundMode _backgroundMode =
      WeatherWidgetBackgroundMode.standard;
  bool _headerActionsRegistered = false;

  @override
  void initState() {
    super.initState();
    _refreshAction = _handleRefreshPressed;
    _menuActionsBuilder = _buildMenuActions;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncBackgroundModeFromSettings();
    _syncLocationFromSettings();
    _registerHeaderActions();
  }

  Future<void> _handleRefreshPressed() async {
    if (!mounted) {
      return;
    }
    await context.read<WeatherWidgetCubit>().refresh();
  }

  Future<void> _detectCurrentLocation() async {
    final service = context.read<WeatherLocationService>();
    final detected = await service.detectCurrentLocation();
    if (!mounted) {
      return;
    }

    if (detected == null) {
      _showMessage(
        _label(
          pl: 'Nie udało się wykryć lokalizacji urządzenia.',
          en: 'Could not detect the device location.',
        ),
      );
      return;
    }

    await _applyLocation(detected);
  }

  Future<void> _pickLocationManually() async {
    final repository = context.read<OpenMeteoWeatherRepository>();
    final languageCode = Localizations.localeOf(context).languageCode;
    final selected = await WeatherLocationPickerSheet.show(
      context,
      repository: repository,
      languageCode: languageCode,
      initialQuery: context.read<WeatherWidgetCubit>().currentLocation?.label,
    );

    if (!mounted || selected == null) {
      return;
    }

    await _applyLocation(selected);
  }

  Future<void> _clearLocation() async {
    final scope = DashboardWidgetSettingsScope.maybeOf(context);
    if (scope != null) {
      await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
        scope.id,
        {'location': null},
      );
    }
    if (!mounted) {
      return;
    }
    context.read<WeatherWidgetCubit>().clearLocation();
  }

  Future<void> _setBackgroundMode(WeatherWidgetBackgroundMode mode) async {
    final scope = DashboardWidgetSettingsScope.maybeOf(context);
    if (scope != null) {
      await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
        scope.id,
        {'backgroundMode': mode.name},
      );
    }
  }

  Future<void> _applyLocation(WeatherWidgetLocation location) async {
    final scope = DashboardWidgetSettingsScope.maybeOf(context);
    if (scope != null) {
      await context.read<DashboardPreferencesCubit>().updateWidgetSettings(
        scope.id,
        {'location': location.toSettingsMap()},
      );
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'last_weather_location',
        jsonEncode(location.toSettingsMap()),
      );
    } catch (_) {}

    if (!mounted) {
      return;
    }

    await context.read<WeatherWidgetCubit>().setLocation(location);
  }

  void _syncLocationFromSettings() {
    final scope = DashboardWidgetSettingsScope.maybeOf(context);
    final settings = scope?.settings;
    final location = WeatherWidgetLocation.fromSettingsMap(
      settings?['location'],
    );
    final signature = location?.settingsSignature;
    if (signature == _lastSettingsSignature) {
      return;
    }

    _lastSettingsSignature = signature;
    final cubit = context.read<WeatherWidgetCubit>();
    if (location == null) {
      if (cubit.currentLocation != null) {
        cubit.clearLocation();
      }
      return;
    }

    final currentSignature = cubit.currentLocation?.settingsSignature;
    if (currentSignature == signature) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(context.read<WeatherWidgetCubit>().setLocation(location));
      }
    });
  }

  void _syncBackgroundModeFromSettings() {
    final scope = DashboardWidgetSettingsScope.maybeOf(context);
    final settings = scope?.settings;
    final backgroundMode = switch (settings?['backgroundMode']) {
      final String value
          when value == WeatherWidgetBackgroundMode.transparent.name =>
        WeatherWidgetBackgroundMode.transparent,
      _ => WeatherWidgetBackgroundMode.standard,
    };

    if (backgroundMode == _backgroundMode) {
      return;
    }

    setState(() {
      _backgroundMode = backgroundMode;
    });
  }

  void _registerHeaderActions() {
    if (_headerActionsRegistered) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final controller = DashboardWidgetHeaderActionScope.maybeOf(context);
      if (controller == null) {
        return;
      }

      controller.setContextMenuActionsBuilder(_menuActionsBuilder);
    });

    _headerActionsRegistered = true;
  }

  List<AppContextMenuAction> _buildMenuActions(BuildContext _) {
    final cubit = context.read<WeatherWidgetCubit>();
    final hasLocation = cubit.currentLocation != null;
    final isPl = Localizations.localeOf(context).languageCode == 'pl';

    return [
      AppContextMenuAction(
        label: isPl ? 'Wykryj lokalizację' : 'Detect location',
        icon: Icons.my_location_rounded,
        onTap: (_) => _detectCurrentLocation(),
      ),
      AppContextMenuAction(
        label: isPl ? 'Wybierz lokalizację' : 'Pick location',
        icon: Icons.search_rounded,
        onTap: (_) => _pickLocationManually(),
      ),
      AppContextMenuAction(
        label: isPl ? 'Odśwież prognozę' : 'Refresh forecast',
        icon: Icons.refresh_rounded,
        enabled: hasLocation,
        separatorBefore: true,
        onTap: (_) => _handleRefreshPressed(),
      ),
      AppContextMenuAction(
        label: isPl ? 'Wyczyść lokalizację' : 'Clear location',
        icon: Icons.delete_outline_rounded,
        isDestructive: true,
        enabled: hasLocation,
        onTap: (_) => _clearLocation(),
      ),
      AppContextMenuAction(
        label: isPl ? 'Tło standardowe' : 'Standard background',
        icon: Icons.layers_rounded,
        selected: _backgroundMode == WeatherWidgetBackgroundMode.standard,
        separatorBefore: true,
        onTap: (_) => _setBackgroundMode(WeatherWidgetBackgroundMode.standard),
      ),
      AppContextMenuAction(
        label: isPl ? 'Tło przezroczyste' : 'Transparent background',
        icon: Icons.layers_clear_rounded,
        selected: _backgroundMode == WeatherWidgetBackgroundMode.transparent,
        onTap: (_) =>
            _setBackgroundMode(WeatherWidgetBackgroundMode.transparent),
      ),
    ];
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherWidgetCubit, WeatherWidgetState>(
      builder: (context, state) {
        _syncRefreshAction(state);

        return WeatherWidgetContent(
          size: widget.size,
          backgroundMode: _backgroundMode,
          state: state,
          onRefresh: _handleRefreshPressed,
          onDetectLocation: _detectCurrentLocation,
          onEditLocation: _pickLocationManually,
          onClearLocation: _clearLocation,
        );
      },
    );
  }

  void _syncRefreshAction(WeatherWidgetState state) {
    final controller = DashboardWidgetHeaderActionScope.maybeOf(context);
    final refreshAction = switch (state) {
      WeatherWidgetLoaded() ||
      WeatherWidgetLoading(location: _) => _refreshAction,
      _ => null,
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || controller == null) {
        return;
      }

      controller.setRefreshAction(refreshAction);
    });
  }
}
