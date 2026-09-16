import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/dashboard/data/weather/open_meteo_weather_repository.dart';
import 'package:ready_next/features/dashboard/data/weather/weather_widget_models.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';

/// Okno wyboru lokalizacji pogodowej po nazwie miasta lub kodzie pocztowym.
class WeatherLocationPickerSheet extends StatefulWidget {
  /// Tworzy okno wyboru lokalizacji.
  const WeatherLocationPickerSheet({
    required this.repository,
    required this.languageCode,
    super.key,
    this.initialQuery,
  });

  /// Repozytorium Open-Meteo.
  final OpenMeteoWeatherRepository repository;

  /// Kod języka wykorzystywany przez geokodowanie.
  final String languageCode;

  /// Opcjonalne początkowe zapytanie.
  final String? initialQuery;

  @override
  State<WeatherLocationPickerSheet> createState() =>
      _WeatherLocationPickerSheetState();

  /// Otwiera okno i zwraca wybraną lokalizację.
  static Future<WeatherWidgetLocation?> show(
    BuildContext context, {
    required OpenMeteoWeatherRepository repository,
    required String languageCode,
    String? initialQuery,
  }) {
    return showDialog<WeatherWidgetLocation>(
      context: context,
      builder: (context) {
        return WeatherLocationPickerSheet(
          repository: repository,
          languageCode: languageCode,
          initialQuery: initialQuery,
        );
      },
    );
  }
}

/// Stan wyboru lokalizacji pogodowej.
class _WeatherLocationPickerSheetState
    extends State<WeatherLocationPickerSheet> {
  late final TextEditingController _queryController;
  List<WeatherWidgetLocation> _results = const [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: widget.initialQuery ?? '');
    if (_queryController.text.trim().length >= 2) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_search());
        }
      });
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _queryController.text.trim();
    if (query.length < 2) {
      setState(() {
        _results = const [];
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await widget.repository.searchLocations(
        query: query,
        language: widget.languageCode,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _results = const [];
        _isLoading = false;
        _errorMessage = error.toString();
      });
    }
  }

  void _selectLocation(WeatherWidgetLocation location) {
    Navigator.of(context).pop(location);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final localeName = Localizations.localeOf(context).languageCode;
    final isPl = localeName == 'pl';
    final title = isPl ? 'Wybierz lokalizację' : 'Choose location';
    final hint = isPl ? 'Miasto lub kod pocztowy' : 'City or postal code';
    final searchLabel = isPl ? 'Szukaj' : 'Search';
    final cancelLabel = isPl ? 'Anuluj' : 'Cancel';

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: context.text.titleLarge?.copyWith(fontWeight: .w700),
              ),
              Gaps.h4,
              AppText(
                isPl
                    ? 'Wpisz nazwę miejscowości albo kod pocztowy.'
                    : 'Type a city name or postal code.',
                style: context.text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h16,
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _queryController,
                      hintText: hint,
                      prefixIcon: Icons.search_rounded,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _search(),
                    ),
                  ),
                  Gaps.w12,
                  AppActionButton.filled(
                    label: searchLabel,
                    icon: Icons.search_rounded,
                    onPressedAsync: _search,
                  ),
                ],
              ),
              Gaps.h16,
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: switch ((
                    _isLoading,
                    _errorMessage,
                    _results.isEmpty,
                  )) {
                    (true, _, _) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    (false, final message?, _) => AppEmptyState.error(
                      compact: true,
                      title: isPl
                          ? 'Nie udało się wyszukać lokalizacji'
                          : 'Could not search locations',
                      message: message,
                      action: AppActionButton.outlined(
                        label: searchLabel,
                        icon: Icons.refresh_rounded,
                        onPressedAsync: _search,
                      ),
                    ),
                    (false, _, true) => AppEmptyState.noResults(
                      compact: true,
                      title: isPl ? 'Brak wyników' : 'No results',
                      message: isPl
                          ? 'Spróbuj podać inną nazwę miejscowości.'
                          : 'Try a different city name.',
                    ),
                    _ => _WeatherLocationResultsList(
                      locations: _results,
                      onSelected: _selectLocation,
                    ),
                  },
                ),
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: .end,
                children: [
                  AppActionButton.text(
                    label: cancelLabel,
                    icon: Icons.close_rounded,
                    tone: .neutral,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lista wyników wyszukiwania lokalizacji pogodowej.
class _WeatherLocationResultsList extends StatelessWidget {
  /// Tworzy listę wyników.
  const _WeatherLocationResultsList({
    required this.locations,
    required this.onSelected,
  });

  /// Lista zwróconych lokalizacji.
  final List<WeatherWidgetLocation> locations;

  /// Callback wywoływany po wyborze lokalizacji.
  final ValueChanged<WeatherWidgetLocation> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: locations.length,
      separatorBuilder: (context, index) => Gaps.h8,
      itemBuilder: (context, index) {
        final location = locations[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onSelected(location),
            borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
            child: Container(
              padding: const EdgeInsets.all(Sizes.p12),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLowest,
                borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                border: Border.all(color: colors.outlineVariant),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.place_rounded, color: colors.primary),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          location.label,
                          style: context.text.titleSmall?.copyWith(
                            fontWeight: .w700,
                          ),
                        ),
                        if (location.locationSummary.trim().isNotEmpty) ...[
                          Gaps.h4,
                          AppText(
                            location.locationSummary,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                        Gaps.h4,
                        AppText(
                          'GPS: ${location.latitude.toStringAsFixed(4)}, '
                          '${location.longitude.toStringAsFixed(4)}',
                          style: context.text.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
